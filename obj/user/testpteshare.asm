
obj/user/testpteshare:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba 9e 4a 80 00 00 	movabs $0x804a9e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf b1 4a 80 00 00 	movabs $0x804ab1,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba c5 4a 80 00 00 	movabs $0x804ac5,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf b1 4a 80 00 00 	movabs $0x804ab1,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 7f 43 80 00 00 	movabs $0x80437f,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 bf 12 80 00 00 	movabs $0x8012bf,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 ce 4a 80 00 00 	movabs $0x804ace,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 d4 4a 80 00 00 	movabs $0x804ad4,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf da 4a 80 00 00 	movabs $0x804ada,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba f5 4a 80 00 00 	movabs $0x804af5,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be f9 4a 80 00 00 	movabs $0x804af9,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 06 4b 80 00 00 	movabs $0x804b06,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 a7 36 80 00 00 	movabs $0x8036a7,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 18 4b 80 00 00 	movabs $0x804b18,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf b1 4a 80 00 00 	movabs $0x804ab1,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 7f 43 80 00 00 	movabs $0x80437f,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 bf 12 80 00 00 	movabs $0x8012bf,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 ce 4a 80 00 00 	movabs $0x804ace,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 d4 4a 80 00 00 	movabs $0x804ad4,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 22 4b 80 00 00 	movabs $0x804b22,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 20          	sub    $0x20,%rsp
  8002b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8002b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8002b7:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8002c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ce:	48 63 d0             	movslq %eax,%rdx
  8002d1:	48 89 d0             	mov    %rdx,%rax
  8002d4:	48 c1 e0 03          	shl    $0x3,%rax
  8002d8:	48 01 d0             	add    %rdx,%rax
  8002db:	48 c1 e0 05          	shl    $0x5,%rax
  8002df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002e6:	00 00 00 
  8002e9:	48 01 c2             	add    %rax,%rdx
  8002ec:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002f3:	00 00 00 
  8002f6:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8002fd:	7e 14                	jle    800313 <libmain+0x6b>
		binaryname = argv[0];
  8002ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800303:	48 8b 10             	mov    (%rax),%rdx
  800306:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80030d:	00 00 00 
  800310:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800313:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800317:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80031a:	48 89 d6             	mov    %rdx,%rsi
  80031d:	89 c7                	mov    %eax,%edi
  80031f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800326:	00 00 00 
  800329:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80032b:	48 b8 39 03 80 00 00 	movabs $0x800339,%rax
  800332:	00 00 00 
  800335:	ff d0                	callq  *%rax
}
  800337:	c9                   	leaveq 
  800338:	c3                   	retq   

0000000000800339 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800339:	55                   	push   %rbp
  80033a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80033d:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800349:	bf 00 00 00 00       	mov    $0x0,%edi
  80034e:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
}
  80035a:	5d                   	pop    %rbp
  80035b:	c3                   	retq   

000000000080035c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80035c:	55                   	push   %rbp
  80035d:	48 89 e5             	mov    %rsp,%rbp
  800360:	53                   	push   %rbx
  800361:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800368:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80036f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800375:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80037c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800383:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80038a:	84 c0                	test   %al,%al
  80038c:	74 23                	je     8003b1 <_panic+0x55>
  80038e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800395:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800399:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80039d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003a1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003a5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003ad:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003b1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003b8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003bf:	00 00 00 
  8003c2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003c9:	00 00 00 
  8003cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003d0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003d7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003de:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003e5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003ec:	00 00 00 
  8003ef:	48 8b 18             	mov    (%rax),%rbx
  8003f2:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
  8003fe:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800404:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80040b:	41 89 c8             	mov    %ecx,%r8d
  80040e:	48 89 d1             	mov    %rdx,%rcx
  800411:	48 89 da             	mov    %rbx,%rdx
  800414:	89 c6                	mov    %eax,%esi
  800416:	48 bf 48 4b 80 00 00 	movabs $0x804b48,%rdi
  80041d:	00 00 00 
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	49 b9 95 05 80 00 00 	movabs $0x800595,%r9
  80042c:	00 00 00 
  80042f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800432:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800439:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800440:	48 89 d6             	mov    %rdx,%rsi
  800443:	48 89 c7             	mov    %rax,%rdi
  800446:	48 b8 e9 04 80 00 00 	movabs $0x8004e9,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
	cprintf("\n");
  800452:	48 bf 6b 4b 80 00 00 	movabs $0x804b6b,%rdi
  800459:	00 00 00 
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  800468:	00 00 00 
  80046b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046d:	cc                   	int3   
  80046e:	eb fd                	jmp    80046d <_panic+0x111>

0000000000800470 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800470:	55                   	push   %rbp
  800471:	48 89 e5             	mov    %rsp,%rbp
  800474:	48 83 ec 10          	sub    $0x10,%rsp
  800478:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80047f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800483:	8b 00                	mov    (%rax),%eax
  800485:	8d 48 01             	lea    0x1(%rax),%ecx
  800488:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80048c:	89 0a                	mov    %ecx,(%rdx)
  80048e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800491:	89 d1                	mov    %edx,%ecx
  800493:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800497:	48 98                	cltq   
  800499:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80049d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a8:	75 2c                	jne    8004d6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	48 98                	cltq   
  8004b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b6:	48 83 c2 08          	add    $0x8,%rdx
  8004ba:	48 89 c6             	mov    %rax,%rsi
  8004bd:	48 89 d7             	mov    %rdx,%rdi
  8004c0:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  8004c7:	00 00 00 
  8004ca:	ff d0                	callq  *%rax
        b->idx = 0;
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004da:	8b 40 04             	mov    0x4(%rax),%eax
  8004dd:	8d 50 01             	lea    0x1(%rax),%edx
  8004e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004e7:	c9                   	leaveq 
  8004e8:	c3                   	retq   

00000000008004e9 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004e9:	55                   	push   %rbp
  8004ea:	48 89 e5             	mov    %rsp,%rbp
  8004ed:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004f4:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004fb:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800502:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800509:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800510:	48 8b 0a             	mov    (%rdx),%rcx
  800513:	48 89 08             	mov    %rcx,(%rax)
  800516:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80051a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80051e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800522:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800526:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80052d:	00 00 00 
    b.cnt = 0;
  800530:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800537:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80053a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800541:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800548:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80054f:	48 89 c6             	mov    %rax,%rsi
  800552:	48 bf 70 04 80 00 00 	movabs $0x800470,%rdi
  800559:	00 00 00 
  80055c:	48 b8 48 09 80 00 00 	movabs $0x800948,%rax
  800563:	00 00 00 
  800566:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800568:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80056e:	48 98                	cltq   
  800570:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800577:	48 83 c2 08          	add    $0x8,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80058d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005a0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005ae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005b5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005bc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005c3:	84 c0                	test   %al,%al
  8005c5:	74 20                	je     8005e7 <cprintf+0x52>
  8005c7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005cb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005cf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005d3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005db:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005df:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005e3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005e7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005ee:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005f5:	00 00 00 
  8005f8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005ff:	00 00 00 
  800602:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800606:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80060d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800614:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80061b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800622:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800629:	48 8b 0a             	mov    (%rdx),%rcx
  80062c:	48 89 08             	mov    %rcx,(%rax)
  80062f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800633:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800637:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80063b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80063f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800646:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80064d:	48 89 d6             	mov    %rdx,%rsi
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 e9 04 80 00 00 	movabs $0x8004e9,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800665:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80066b:	c9                   	leaveq 
  80066c:	c3                   	retq   

000000000080066d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066d:	55                   	push   %rbp
  80066e:	48 89 e5             	mov    %rsp,%rbp
  800671:	53                   	push   %rbx
  800672:	48 83 ec 38          	sub    $0x38,%rsp
  800676:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80067e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800682:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800685:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800689:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800690:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800694:	77 3b                	ja     8006d1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800696:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800699:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80069d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a9:	48 f7 f3             	div    %rbx
  8006ac:	48 89 c2             	mov    %rax,%rdx
  8006af:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006b2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006b5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bd:	41 89 f9             	mov    %edi,%r9d
  8006c0:	48 89 c7             	mov    %rax,%rdi
  8006c3:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  8006ca:	00 00 00 
  8006cd:	ff d0                	callq  *%rax
  8006cf:	eb 1e                	jmp    8006ef <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d1:	eb 12                	jmp    8006e5 <printnum+0x78>
			putch(padc, putdat);
  8006d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006d7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	48 89 ce             	mov    %rcx,%rsi
  8006e1:	89 d7                	mov    %edx,%edi
  8006e3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006ed:	7f e4                	jg     8006d3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ef:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	48 f7 f1             	div    %rcx
  8006fe:	48 89 d0             	mov    %rdx,%rax
  800701:	48 ba 70 4d 80 00 00 	movabs $0x804d70,%rdx
  800708:	00 00 00 
  80070b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80070f:	0f be d0             	movsbl %al,%edx
  800712:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	48 89 ce             	mov    %rcx,%rsi
  80071d:	89 d7                	mov    %edx,%edi
  80071f:	ff d0                	callq  *%rax
}
  800721:	48 83 c4 38          	add    $0x38,%rsp
  800725:	5b                   	pop    %rbx
  800726:	5d                   	pop    %rbp
  800727:	c3                   	retq   

0000000000800728 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800728:	55                   	push   %rbp
  800729:	48 89 e5             	mov    %rsp,%rbp
  80072c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800730:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800734:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800737:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073b:	7e 52                	jle    80078f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	8b 00                	mov    (%rax),%eax
  800743:	83 f8 30             	cmp    $0x30,%eax
  800746:	73 24                	jae    80076c <getuint+0x44>
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800754:	8b 00                	mov    (%rax),%eax
  800756:	89 c0                	mov    %eax,%eax
  800758:	48 01 d0             	add    %rdx,%rax
  80075b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075f:	8b 12                	mov    (%rdx),%edx
  800761:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800768:	89 0a                	mov    %ecx,(%rdx)
  80076a:	eb 17                	jmp    800783 <getuint+0x5b>
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800774:	48 89 d0             	mov    %rdx,%rax
  800777:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800783:	48 8b 00             	mov    (%rax),%rax
  800786:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078a:	e9 a3 00 00 00       	jmpq   800832 <getuint+0x10a>
	else if (lflag)
  80078f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800793:	74 4f                	je     8007e4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	8b 00                	mov    (%rax),%eax
  80079b:	83 f8 30             	cmp    $0x30,%eax
  80079e:	73 24                	jae    8007c4 <getuint+0x9c>
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	8b 00                	mov    (%rax),%eax
  8007ae:	89 c0                	mov    %eax,%eax
  8007b0:	48 01 d0             	add    %rdx,%rax
  8007b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b7:	8b 12                	mov    (%rdx),%edx
  8007b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c0:	89 0a                	mov    %ecx,(%rdx)
  8007c2:	eb 17                	jmp    8007db <getuint+0xb3>
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cc:	48 89 d0             	mov    %rdx,%rax
  8007cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007db:	48 8b 00             	mov    (%rax),%rax
  8007de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e2:	eb 4e                	jmp    800832 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	8b 00                	mov    (%rax),%eax
  8007ea:	83 f8 30             	cmp    $0x30,%eax
  8007ed:	73 24                	jae    800813 <getuint+0xeb>
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	8b 00                	mov    (%rax),%eax
  8007fd:	89 c0                	mov    %eax,%eax
  8007ff:	48 01 d0             	add    %rdx,%rax
  800802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800806:	8b 12                	mov    (%rdx),%edx
  800808:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	89 0a                	mov    %ecx,(%rdx)
  800811:	eb 17                	jmp    80082a <getuint+0x102>
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081b:	48 89 d0             	mov    %rdx,%rax
  80081e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	89 c0                	mov    %eax,%eax
  80082e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800832:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800836:	c9                   	leaveq 
  800837:	c3                   	retq   

0000000000800838 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800838:	55                   	push   %rbp
  800839:	48 89 e5             	mov    %rsp,%rbp
  80083c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800840:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800844:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800847:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80084b:	7e 52                	jle    80089f <getint+0x67>
		x=va_arg(*ap, long long);
  80084d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800851:	8b 00                	mov    (%rax),%eax
  800853:	83 f8 30             	cmp    $0x30,%eax
  800856:	73 24                	jae    80087c <getint+0x44>
  800858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800864:	8b 00                	mov    (%rax),%eax
  800866:	89 c0                	mov    %eax,%eax
  800868:	48 01 d0             	add    %rdx,%rax
  80086b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086f:	8b 12                	mov    (%rdx),%edx
  800871:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800878:	89 0a                	mov    %ecx,(%rdx)
  80087a:	eb 17                	jmp    800893 <getint+0x5b>
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800884:	48 89 d0             	mov    %rdx,%rax
  800887:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800893:	48 8b 00             	mov    (%rax),%rax
  800896:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80089a:	e9 a3 00 00 00       	jmpq   800942 <getint+0x10a>
	else if (lflag)
  80089f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008a3:	74 4f                	je     8008f4 <getint+0xbc>
		x=va_arg(*ap, long);
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	8b 00                	mov    (%rax),%eax
  8008ab:	83 f8 30             	cmp    $0x30,%eax
  8008ae:	73 24                	jae    8008d4 <getint+0x9c>
  8008b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 c0                	mov    %eax,%eax
  8008c0:	48 01 d0             	add    %rdx,%rax
  8008c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c7:	8b 12                	mov    (%rdx),%edx
  8008c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d0:	89 0a                	mov    %ecx,(%rdx)
  8008d2:	eb 17                	jmp    8008eb <getint+0xb3>
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008dc:	48 89 d0             	mov    %rdx,%rax
  8008df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008eb:	48 8b 00             	mov    (%rax),%rax
  8008ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f2:	eb 4e                	jmp    800942 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	83 f8 30             	cmp    $0x30,%eax
  8008fd:	73 24                	jae    800923 <getint+0xeb>
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	8b 00                	mov    (%rax),%eax
  80090d:	89 c0                	mov    %eax,%eax
  80090f:	48 01 d0             	add    %rdx,%rax
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	8b 12                	mov    (%rdx),%edx
  800918:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	89 0a                	mov    %ecx,(%rdx)
  800921:	eb 17                	jmp    80093a <getint+0x102>
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092b:	48 89 d0             	mov    %rdx,%rax
  80092e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800932:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800936:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093a:	8b 00                	mov    (%rax),%eax
  80093c:	48 98                	cltq   
  80093e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800942:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800946:	c9                   	leaveq 
  800947:	c3                   	retq   

0000000000800948 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800948:	55                   	push   %rbp
  800949:	48 89 e5             	mov    %rsp,%rbp
  80094c:	41 54                	push   %r12
  80094e:	53                   	push   %rbx
  80094f:	48 83 ec 60          	sub    $0x60,%rsp
  800953:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800957:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80095b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80095f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800963:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800967:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80096b:	48 8b 0a             	mov    (%rdx),%rcx
  80096e:	48 89 08             	mov    %rcx,(%rax)
  800971:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800975:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800979:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80097d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800981:	eb 17                	jmp    80099a <vprintfmt+0x52>
			if (ch == '\0')
  800983:	85 db                	test   %ebx,%ebx
  800985:	0f 84 df 04 00 00    	je     800e6a <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80098b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800993:	48 89 d6             	mov    %rdx,%rsi
  800996:	89 df                	mov    %ebx,%edi
  800998:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80099e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009a2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009a6:	0f b6 00             	movzbl (%rax),%eax
  8009a9:	0f b6 d8             	movzbl %al,%ebx
  8009ac:	83 fb 25             	cmp    $0x25,%ebx
  8009af:	75 d2                	jne    800983 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009b5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009dd:	0f b6 00             	movzbl (%rax),%eax
  8009e0:	0f b6 d8             	movzbl %al,%ebx
  8009e3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009e6:	83 f8 55             	cmp    $0x55,%eax
  8009e9:	0f 87 47 04 00 00    	ja     800e36 <vprintfmt+0x4ee>
  8009ef:	89 c0                	mov    %eax,%eax
  8009f1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009f8:	00 
  8009f9:	48 b8 98 4d 80 00 00 	movabs $0x804d98,%rax
  800a00:	00 00 00 
  800a03:	48 01 d0             	add    %rdx,%rax
  800a06:	48 8b 00             	mov    (%rax),%rax
  800a09:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a0b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a0f:	eb c0                	jmp    8009d1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a11:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a15:	eb ba                	jmp    8009d1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a17:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a1e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	c1 e0 02             	shl    $0x2,%eax
  800a26:	01 d0                	add    %edx,%eax
  800a28:	01 c0                	add    %eax,%eax
  800a2a:	01 d8                	add    %ebx,%eax
  800a2c:	83 e8 30             	sub    $0x30,%eax
  800a2f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a32:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a36:	0f b6 00             	movzbl (%rax),%eax
  800a39:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3f:	7e 0c                	jle    800a4d <vprintfmt+0x105>
  800a41:	83 fb 39             	cmp    $0x39,%ebx
  800a44:	7f 07                	jg     800a4d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a46:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4b:	eb d1                	jmp    800a1e <vprintfmt+0xd6>
			goto process_precision;
  800a4d:	eb 58                	jmp    800aa7 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a52:	83 f8 30             	cmp    $0x30,%eax
  800a55:	73 17                	jae    800a6e <vprintfmt+0x126>
  800a57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5e:	89 c0                	mov    %eax,%eax
  800a60:	48 01 d0             	add    %rdx,%rax
  800a63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a66:	83 c2 08             	add    $0x8,%edx
  800a69:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a6c:	eb 0f                	jmp    800a7d <vprintfmt+0x135>
  800a6e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a72:	48 89 d0             	mov    %rdx,%rax
  800a75:	48 83 c2 08          	add    $0x8,%rdx
  800a79:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a7d:	8b 00                	mov    (%rax),%eax
  800a7f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a82:	eb 23                	jmp    800aa7 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a88:	79 0c                	jns    800a96 <vprintfmt+0x14e>
				width = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a91:	e9 3b ff ff ff       	jmpq   8009d1 <vprintfmt+0x89>
  800a96:	e9 36 ff ff ff       	jmpq   8009d1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a9b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800aa2:	e9 2a ff ff ff       	jmpq   8009d1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800aa7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aab:	79 12                	jns    800abf <vprintfmt+0x177>
				width = precision, precision = -1;
  800aad:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ab3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800aba:	e9 12 ff ff ff       	jmpq   8009d1 <vprintfmt+0x89>
  800abf:	e9 0d ff ff ff       	jmpq   8009d1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ac8:	e9 04 ff ff ff       	jmpq   8009d1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800acd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad0:	83 f8 30             	cmp    $0x30,%eax
  800ad3:	73 17                	jae    800aec <vprintfmt+0x1a4>
  800ad5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adc:	89 c0                	mov    %eax,%eax
  800ade:	48 01 d0             	add    %rdx,%rax
  800ae1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae4:	83 c2 08             	add    $0x8,%edx
  800ae7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aea:	eb 0f                	jmp    800afb <vprintfmt+0x1b3>
  800aec:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af0:	48 89 d0             	mov    %rdx,%rax
  800af3:	48 83 c2 08          	add    $0x8,%rdx
  800af7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afb:	8b 10                	mov    (%rax),%edx
  800afd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	48 89 ce             	mov    %rcx,%rsi
  800b08:	89 d7                	mov    %edx,%edi
  800b0a:	ff d0                	callq  *%rax
			break;
  800b0c:	e9 53 03 00 00       	jmpq   800e64 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b14:	83 f8 30             	cmp    $0x30,%eax
  800b17:	73 17                	jae    800b30 <vprintfmt+0x1e8>
  800b19:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b20:	89 c0                	mov    %eax,%eax
  800b22:	48 01 d0             	add    %rdx,%rax
  800b25:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b28:	83 c2 08             	add    $0x8,%edx
  800b2b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b2e:	eb 0f                	jmp    800b3f <vprintfmt+0x1f7>
  800b30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b34:	48 89 d0             	mov    %rdx,%rax
  800b37:	48 83 c2 08          	add    $0x8,%rdx
  800b3b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b41:	85 db                	test   %ebx,%ebx
  800b43:	79 02                	jns    800b47 <vprintfmt+0x1ff>
				err = -err;
  800b45:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b47:	83 fb 15             	cmp    $0x15,%ebx
  800b4a:	7f 16                	jg     800b62 <vprintfmt+0x21a>
  800b4c:	48 b8 c0 4c 80 00 00 	movabs $0x804cc0,%rax
  800b53:	00 00 00 
  800b56:	48 63 d3             	movslq %ebx,%rdx
  800b59:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b5d:	4d 85 e4             	test   %r12,%r12
  800b60:	75 2e                	jne    800b90 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b62:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6a:	89 d9                	mov    %ebx,%ecx
  800b6c:	48 ba 81 4d 80 00 00 	movabs $0x804d81,%rdx
  800b73:	00 00 00 
  800b76:	48 89 c7             	mov    %rax,%rdi
  800b79:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7e:	49 b8 73 0e 80 00 00 	movabs $0x800e73,%r8
  800b85:	00 00 00 
  800b88:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b8b:	e9 d4 02 00 00       	jmpq   800e64 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b90:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b98:	4c 89 e1             	mov    %r12,%rcx
  800b9b:	48 ba 8a 4d 80 00 00 	movabs $0x804d8a,%rdx
  800ba2:	00 00 00 
  800ba5:	48 89 c7             	mov    %rax,%rdi
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	49 b8 73 0e 80 00 00 	movabs $0x800e73,%r8
  800bb4:	00 00 00 
  800bb7:	41 ff d0             	callq  *%r8
			break;
  800bba:	e9 a5 02 00 00       	jmpq   800e64 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc2:	83 f8 30             	cmp    $0x30,%eax
  800bc5:	73 17                	jae    800bde <vprintfmt+0x296>
  800bc7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bcb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bce:	89 c0                	mov    %eax,%eax
  800bd0:	48 01 d0             	add    %rdx,%rax
  800bd3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd6:	83 c2 08             	add    $0x8,%edx
  800bd9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdc:	eb 0f                	jmp    800bed <vprintfmt+0x2a5>
  800bde:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be2:	48 89 d0             	mov    %rdx,%rax
  800be5:	48 83 c2 08          	add    $0x8,%rdx
  800be9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bed:	4c 8b 20             	mov    (%rax),%r12
  800bf0:	4d 85 e4             	test   %r12,%r12
  800bf3:	75 0a                	jne    800bff <vprintfmt+0x2b7>
				p = "(null)";
  800bf5:	49 bc 8d 4d 80 00 00 	movabs $0x804d8d,%r12
  800bfc:	00 00 00 
			if (width > 0 && padc != '-')
  800bff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c03:	7e 3f                	jle    800c44 <vprintfmt+0x2fc>
  800c05:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c09:	74 39                	je     800c44 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c0e:	48 98                	cltq   
  800c10:	48 89 c6             	mov    %rax,%rsi
  800c13:	4c 89 e7             	mov    %r12,%rdi
  800c16:	48 b8 1f 11 80 00 00 	movabs $0x80111f,%rax
  800c1d:	00 00 00 
  800c20:	ff d0                	callq  *%rax
  800c22:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c25:	eb 17                	jmp    800c3e <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c27:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c2b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c33:	48 89 ce             	mov    %rcx,%rsi
  800c36:	89 d7                	mov    %edx,%edi
  800c38:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c42:	7f e3                	jg     800c27 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c44:	eb 37                	jmp    800c7d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c46:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c4a:	74 1e                	je     800c6a <vprintfmt+0x322>
  800c4c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c4f:	7e 05                	jle    800c56 <vprintfmt+0x30e>
  800c51:	83 fb 7e             	cmp    $0x7e,%ebx
  800c54:	7e 14                	jle    800c6a <vprintfmt+0x322>
					putch('?', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c66:	ff d0                	callq  *%rax
  800c68:	eb 0f                	jmp    800c79 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c72:	48 89 d6             	mov    %rdx,%rsi
  800c75:	89 df                	mov    %ebx,%edi
  800c77:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c79:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c7d:	4c 89 e0             	mov    %r12,%rax
  800c80:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c84:	0f b6 00             	movzbl (%rax),%eax
  800c87:	0f be d8             	movsbl %al,%ebx
  800c8a:	85 db                	test   %ebx,%ebx
  800c8c:	74 10                	je     800c9e <vprintfmt+0x356>
  800c8e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c92:	78 b2                	js     800c46 <vprintfmt+0x2fe>
  800c94:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c98:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c9c:	79 a8                	jns    800c46 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c9e:	eb 16                	jmp    800cb6 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ca0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca8:	48 89 d6             	mov    %rdx,%rsi
  800cab:	bf 20 00 00 00       	mov    $0x20,%edi
  800cb0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cb2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cba:	7f e4                	jg     800ca0 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cbc:	e9 a3 01 00 00       	jmpq   800e64 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cc1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc5:	be 03 00 00 00       	mov    $0x3,%esi
  800cca:	48 89 c7             	mov    %rax,%rdi
  800ccd:	48 b8 38 08 80 00 00 	movabs $0x800838,%rax
  800cd4:	00 00 00 
  800cd7:	ff d0                	callq  *%rax
  800cd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce1:	48 85 c0             	test   %rax,%rax
  800ce4:	79 1d                	jns    800d03 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ce6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cee:	48 89 d6             	mov    %rdx,%rsi
  800cf1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cf6:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfc:	48 f7 d8             	neg    %rax
  800cff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d03:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d0a:	e9 e8 00 00 00       	jmpq   800df7 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d0f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d13:	be 03 00 00 00       	mov    $0x3,%esi
  800d18:	48 89 c7             	mov    %rax,%rdi
  800d1b:	48 b8 28 07 80 00 00 	movabs $0x800728,%rax
  800d22:	00 00 00 
  800d25:	ff d0                	callq  *%rax
  800d27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d2b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d32:	e9 c0 00 00 00       	jmpq   800df7 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3f:	48 89 d6             	mov    %rdx,%rsi
  800d42:	bf 58 00 00 00       	mov    $0x58,%edi
  800d47:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d51:	48 89 d6             	mov    %rdx,%rsi
  800d54:	bf 58 00 00 00       	mov    $0x58,%edi
  800d59:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d63:	48 89 d6             	mov    %rdx,%rsi
  800d66:	bf 58 00 00 00       	mov    $0x58,%edi
  800d6b:	ff d0                	callq  *%rax
			break;
  800d6d:	e9 f2 00 00 00       	jmpq   800e64 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800d72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7a:	48 89 d6             	mov    %rdx,%rsi
  800d7d:	bf 30 00 00 00       	mov    $0x30,%edi
  800d82:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8c:	48 89 d6             	mov    %rdx,%rsi
  800d8f:	bf 78 00 00 00       	mov    $0x78,%edi
  800d94:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d99:	83 f8 30             	cmp    $0x30,%eax
  800d9c:	73 17                	jae    800db5 <vprintfmt+0x46d>
  800d9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800da2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da5:	89 c0                	mov    %eax,%eax
  800da7:	48 01 d0             	add    %rdx,%rax
  800daa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dad:	83 c2 08             	add    $0x8,%edx
  800db0:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800db3:	eb 0f                	jmp    800dc4 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800db5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800db9:	48 89 d0             	mov    %rdx,%rax
  800dbc:	48 83 c2 08          	add    $0x8,%rdx
  800dc0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dc4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dcb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800dd2:	eb 23                	jmp    800df7 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dd4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dd8:	be 03 00 00 00       	mov    $0x3,%esi
  800ddd:	48 89 c7             	mov    %rax,%rdi
  800de0:	48 b8 28 07 80 00 00 	movabs $0x800728,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	callq  *%rax
  800dec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800df0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800df7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800dfc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800dff:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	45 89 c1             	mov    %r8d,%r9d
  800e11:	41 89 f8             	mov    %edi,%r8d
  800e14:	48 89 c7             	mov    %rax,%rdi
  800e17:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800e1e:	00 00 00 
  800e21:	ff d0                	callq  *%rax
			break;
  800e23:	eb 3f                	jmp    800e64 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2d:	48 89 d6             	mov    %rdx,%rsi
  800e30:	89 df                	mov    %ebx,%edi
  800e32:	ff d0                	callq  *%rax
			break;
  800e34:	eb 2e                	jmp    800e64 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3e:	48 89 d6             	mov    %rdx,%rsi
  800e41:	bf 25 00 00 00       	mov    $0x25,%edi
  800e46:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e48:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e4d:	eb 05                	jmp    800e54 <vprintfmt+0x50c>
  800e4f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e58:	48 83 e8 01          	sub    $0x1,%rax
  800e5c:	0f b6 00             	movzbl (%rax),%eax
  800e5f:	3c 25                	cmp    $0x25,%al
  800e61:	75 ec                	jne    800e4f <vprintfmt+0x507>
				/* do nothing */;
			break;
  800e63:	90                   	nop
		}
	}
  800e64:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e65:	e9 30 fb ff ff       	jmpq   80099a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e6a:	48 83 c4 60          	add    $0x60,%rsp
  800e6e:	5b                   	pop    %rbx
  800e6f:	41 5c                	pop    %r12
  800e71:	5d                   	pop    %rbp
  800e72:	c3                   	retq   

0000000000800e73 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e73:	55                   	push   %rbp
  800e74:	48 89 e5             	mov    %rsp,%rbp
  800e77:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e7e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e85:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e8c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e93:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e9a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ea1:	84 c0                	test   %al,%al
  800ea3:	74 20                	je     800ec5 <printfmt+0x52>
  800ea5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ea9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ead:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eb1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eb5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eb9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ebd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ec1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ec5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ecc:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ed3:	00 00 00 
  800ed6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800edd:	00 00 00 
  800ee0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ee4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800eeb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ef2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ef9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f00:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f07:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f0e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f15:	48 89 c7             	mov    %rax,%rdi
  800f18:	48 b8 48 09 80 00 00 	movabs $0x800948,%rax
  800f1f:	00 00 00 
  800f22:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f24:	c9                   	leaveq 
  800f25:	c3                   	retq   

0000000000800f26 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f26:	55                   	push   %rbp
  800f27:	48 89 e5             	mov    %rsp,%rbp
  800f2a:	48 83 ec 10          	sub    $0x10,%rsp
  800f2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f39:	8b 40 10             	mov    0x10(%rax),%eax
  800f3c:	8d 50 01             	lea    0x1(%rax),%edx
  800f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f43:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f4a:	48 8b 10             	mov    (%rax),%rdx
  800f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f51:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f55:	48 39 c2             	cmp    %rax,%rdx
  800f58:	73 17                	jae    800f71 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5e:	48 8b 00             	mov    (%rax),%rax
  800f61:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f69:	48 89 0a             	mov    %rcx,(%rdx)
  800f6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f6f:	88 10                	mov    %dl,(%rax)
}
  800f71:	c9                   	leaveq 
  800f72:	c3                   	retq   

0000000000800f73 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f73:	55                   	push   %rbp
  800f74:	48 89 e5             	mov    %rsp,%rbp
  800f77:	48 83 ec 50          	sub    $0x50,%rsp
  800f7b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f7f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f82:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f86:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f8a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f8e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f92:	48 8b 0a             	mov    (%rdx),%rcx
  800f95:	48 89 08             	mov    %rcx,(%rax)
  800f98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fa0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fa8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fac:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fb0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fb3:	48 98                	cltq   
  800fb5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fbd:	48 01 d0             	add    %rdx,%rax
  800fc0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fcb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fd0:	74 06                	je     800fd8 <vsnprintf+0x65>
  800fd2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fd6:	7f 07                	jg     800fdf <vsnprintf+0x6c>
		return -E_INVAL;
  800fd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdd:	eb 2f                	jmp    80100e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fdf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fe3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fe7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800feb:	48 89 c6             	mov    %rax,%rsi
  800fee:	48 bf 26 0f 80 00 00 	movabs $0x800f26,%rdi
  800ff5:	00 00 00 
  800ff8:	48 b8 48 09 80 00 00 	movabs $0x800948,%rax
  800fff:	00 00 00 
  801002:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801004:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801008:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80100b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80100e:	c9                   	leaveq 
  80100f:	c3                   	retq   

0000000000801010 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801010:	55                   	push   %rbp
  801011:	48 89 e5             	mov    %rsp,%rbp
  801014:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80101b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801022:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801028:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80102f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801036:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80103d:	84 c0                	test   %al,%al
  80103f:	74 20                	je     801061 <snprintf+0x51>
  801041:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801045:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801049:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80104d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801051:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801055:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801059:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80105d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801061:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801068:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80106f:	00 00 00 
  801072:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801079:	00 00 00 
  80107c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801080:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801087:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80108e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801095:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80109c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010a3:	48 8b 0a             	mov    (%rdx),%rcx
  8010a6:	48 89 08             	mov    %rcx,(%rax)
  8010a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010b9:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010c0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010c7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010cd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010d4:	48 89 c7             	mov    %rax,%rdi
  8010d7:	48 b8 73 0f 80 00 00 	movabs $0x800f73,%rax
  8010de:	00 00 00 
  8010e1:	ff d0                	callq  *%rax
  8010e3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010e9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 18          	sub    $0x18,%rsp
  8010f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801104:	eb 09                	jmp    80110f <strlen+0x1e>
		n++;
  801106:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80110a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80110f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	84 c0                	test   %al,%al
  801118:	75 ec                	jne    801106 <strlen+0x15>
		n++;
	return n;
  80111a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80111d:	c9                   	leaveq 
  80111e:	c3                   	retq   

000000000080111f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80111f:	55                   	push   %rbp
  801120:	48 89 e5             	mov    %rsp,%rbp
  801123:	48 83 ec 20          	sub    $0x20,%rsp
  801127:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80112f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801136:	eb 0e                	jmp    801146 <strnlen+0x27>
		n++;
  801138:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80113c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801141:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801146:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80114b:	74 0b                	je     801158 <strnlen+0x39>
  80114d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801151:	0f b6 00             	movzbl (%rax),%eax
  801154:	84 c0                	test   %al,%al
  801156:	75 e0                	jne    801138 <strnlen+0x19>
		n++;
	return n;
  801158:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80115b:	c9                   	leaveq 
  80115c:	c3                   	retq   

000000000080115d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80115d:	55                   	push   %rbp
  80115e:	48 89 e5             	mov    %rsp,%rbp
  801161:	48 83 ec 20          	sub    $0x20,%rsp
  801165:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801169:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801175:	90                   	nop
  801176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80117e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801182:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801186:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80118a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80118e:	0f b6 12             	movzbl (%rdx),%edx
  801191:	88 10                	mov    %dl,(%rax)
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	84 c0                	test   %al,%al
  801198:	75 dc                	jne    801176 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80119e:	c9                   	leaveq 
  80119f:	c3                   	retq   

00000000008011a0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011a0:	55                   	push   %rbp
  8011a1:	48 89 e5             	mov    %rsp,%rbp
  8011a4:	48 83 ec 20          	sub    $0x20,%rsp
  8011a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	48 89 c7             	mov    %rax,%rdi
  8011b7:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  8011be:	00 00 00 
  8011c1:	ff d0                	callq  *%rax
  8011c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011c9:	48 63 d0             	movslq %eax,%rdx
  8011cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d0:	48 01 c2             	add    %rax,%rdx
  8011d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d7:	48 89 c6             	mov    %rax,%rsi
  8011da:	48 89 d7             	mov    %rdx,%rdi
  8011dd:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  8011e4:	00 00 00 
  8011e7:	ff d0                	callq  *%rax
	return dst;
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011ed:	c9                   	leaveq 
  8011ee:	c3                   	retq   

00000000008011ef <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011ef:	55                   	push   %rbp
  8011f0:	48 89 e5             	mov    %rsp,%rbp
  8011f3:	48 83 ec 28          	sub    $0x28,%rsp
  8011f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801207:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80120b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801212:	00 
  801213:	eb 2a                	jmp    80123f <strncpy+0x50>
		*dst++ = *src;
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801221:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801225:	0f b6 12             	movzbl (%rdx),%edx
  801228:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80122a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	74 05                	je     80123a <strncpy+0x4b>
			src++;
  801235:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80123a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801247:	72 cc                	jb     801215 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80124d:	c9                   	leaveq 
  80124e:	c3                   	retq   

000000000080124f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80124f:	55                   	push   %rbp
  801250:	48 89 e5             	mov    %rsp,%rbp
  801253:	48 83 ec 28          	sub    $0x28,%rsp
  801257:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80125f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801267:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80126b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801270:	74 3d                	je     8012af <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801272:	eb 1d                	jmp    801291 <strlcpy+0x42>
			*dst++ = *src++;
  801274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801278:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80127c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801280:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801284:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801288:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80128c:	0f b6 12             	movzbl (%rdx),%edx
  80128f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801291:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801296:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80129b:	74 0b                	je     8012a8 <strlcpy+0x59>
  80129d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a1:	0f b6 00             	movzbl (%rax),%eax
  8012a4:	84 c0                	test   %al,%al
  8012a6:	75 cc                	jne    801274 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ac:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	48 29 c2             	sub    %rax,%rdx
  8012ba:	48 89 d0             	mov    %rdx,%rax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 10          	sub    $0x10,%rsp
  8012c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012cf:	eb 0a                	jmp    8012db <strcmp+0x1c>
		p++, q++;
  8012d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	84 c0                	test   %al,%al
  8012e4:	74 12                	je     8012f8 <strcmp+0x39>
  8012e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ea:	0f b6 10             	movzbl (%rax),%edx
  8012ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f1:	0f b6 00             	movzbl (%rax),%eax
  8012f4:	38 c2                	cmp    %al,%dl
  8012f6:	74 d9                	je     8012d1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fc:	0f b6 00             	movzbl (%rax),%eax
  8012ff:	0f b6 d0             	movzbl %al,%edx
  801302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801306:	0f b6 00             	movzbl (%rax),%eax
  801309:	0f b6 c0             	movzbl %al,%eax
  80130c:	29 c2                	sub    %eax,%edx
  80130e:	89 d0                	mov    %edx,%eax
}
  801310:	c9                   	leaveq 
  801311:	c3                   	retq   

0000000000801312 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801312:	55                   	push   %rbp
  801313:	48 89 e5             	mov    %rsp,%rbp
  801316:	48 83 ec 18          	sub    $0x18,%rsp
  80131a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801322:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801326:	eb 0f                	jmp    801337 <strncmp+0x25>
		n--, p++, q++;
  801328:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80132d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801332:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801337:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80133c:	74 1d                	je     80135b <strncmp+0x49>
  80133e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	84 c0                	test   %al,%al
  801347:	74 12                	je     80135b <strncmp+0x49>
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	0f b6 10             	movzbl (%rax),%edx
  801350:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	38 c2                	cmp    %al,%dl
  801359:	74 cd                	je     801328 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80135b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801360:	75 07                	jne    801369 <strncmp+0x57>
		return 0;
  801362:	b8 00 00 00 00       	mov    $0x0,%eax
  801367:	eb 18                	jmp    801381 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	0f b6 00             	movzbl (%rax),%eax
  801370:	0f b6 d0             	movzbl %al,%edx
  801373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	0f b6 c0             	movzbl %al,%eax
  80137d:	29 c2                	sub    %eax,%edx
  80137f:	89 d0                	mov    %edx,%eax
}
  801381:	c9                   	leaveq 
  801382:	c3                   	retq   

0000000000801383 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801383:	55                   	push   %rbp
  801384:	48 89 e5             	mov    %rsp,%rbp
  801387:	48 83 ec 0c          	sub    $0xc,%rsp
  80138b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138f:	89 f0                	mov    %esi,%eax
  801391:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801394:	eb 17                	jmp    8013ad <strchr+0x2a>
		if (*s == c)
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013a0:	75 06                	jne    8013a8 <strchr+0x25>
			return (char *) s;
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	eb 15                	jmp    8013bd <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	84 c0                	test   %al,%al
  8013b6:	75 de                	jne    801396 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013bd:	c9                   	leaveq 
  8013be:	c3                   	retq   

00000000008013bf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 83 ec 0c          	sub    $0xc,%rsp
  8013c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cb:	89 f0                	mov    %esi,%eax
  8013cd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013d0:	eb 13                	jmp    8013e5 <strfind+0x26>
		if (*s == c)
  8013d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d6:	0f b6 00             	movzbl (%rax),%eax
  8013d9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013dc:	75 02                	jne    8013e0 <strfind+0x21>
			break;
  8013de:	eb 10                	jmp    8013f0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e9:	0f b6 00             	movzbl (%rax),%eax
  8013ec:	84 c0                	test   %al,%al
  8013ee:	75 e2                	jne    8013d2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013f4:	c9                   	leaveq 
  8013f5:	c3                   	retq   

00000000008013f6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013f6:	55                   	push   %rbp
  8013f7:	48 89 e5             	mov    %rsp,%rbp
  8013fa:	48 83 ec 18          	sub    $0x18,%rsp
  8013fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801402:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801405:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801409:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140e:	75 06                	jne    801416 <memset+0x20>
		return v;
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	eb 69                	jmp    80147f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801416:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141a:	83 e0 03             	and    $0x3,%eax
  80141d:	48 85 c0             	test   %rax,%rax
  801420:	75 48                	jne    80146a <memset+0x74>
  801422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801426:	83 e0 03             	and    $0x3,%eax
  801429:	48 85 c0             	test   %rax,%rax
  80142c:	75 3c                	jne    80146a <memset+0x74>
		c &= 0xFF;
  80142e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801435:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801438:	c1 e0 18             	shl    $0x18,%eax
  80143b:	89 c2                	mov    %eax,%edx
  80143d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801440:	c1 e0 10             	shl    $0x10,%eax
  801443:	09 c2                	or     %eax,%edx
  801445:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801448:	c1 e0 08             	shl    $0x8,%eax
  80144b:	09 d0                	or     %edx,%eax
  80144d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801454:	48 c1 e8 02          	shr    $0x2,%rax
  801458:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80145b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801462:	48 89 d7             	mov    %rdx,%rdi
  801465:	fc                   	cld    
  801466:	f3 ab                	rep stos %eax,%es:(%rdi)
  801468:	eb 11                	jmp    80147b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80146a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801471:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801475:	48 89 d7             	mov    %rdx,%rdi
  801478:	fc                   	cld    
  801479:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80147b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80147f:	c9                   	leaveq 
  801480:	c3                   	retq   

0000000000801481 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801481:	55                   	push   %rbp
  801482:	48 89 e5             	mov    %rsp,%rbp
  801485:	48 83 ec 28          	sub    $0x28,%rsp
  801489:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80148d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801491:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801495:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801499:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80149d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014ad:	0f 83 88 00 00 00    	jae    80153b <memmove+0xba>
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014bb:	48 01 d0             	add    %rdx,%rax
  8014be:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014c2:	76 77                	jbe    80153b <memmove+0xba>
		s += n;
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d8:	83 e0 03             	and    $0x3,%eax
  8014db:	48 85 c0             	test   %rax,%rax
  8014de:	75 3b                	jne    80151b <memmove+0x9a>
  8014e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e4:	83 e0 03             	and    $0x3,%eax
  8014e7:	48 85 c0             	test   %rax,%rax
  8014ea:	75 2f                	jne    80151b <memmove+0x9a>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	83 e0 03             	and    $0x3,%eax
  8014f3:	48 85 c0             	test   %rax,%rax
  8014f6:	75 23                	jne    80151b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fc:	48 83 e8 04          	sub    $0x4,%rax
  801500:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801504:	48 83 ea 04          	sub    $0x4,%rdx
  801508:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80150c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801510:	48 89 c7             	mov    %rax,%rdi
  801513:	48 89 d6             	mov    %rdx,%rsi
  801516:	fd                   	std    
  801517:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801519:	eb 1d                	jmp    801538 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80151b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801527:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	48 89 d7             	mov    %rdx,%rdi
  801532:	48 89 c1             	mov    %rax,%rcx
  801535:	fd                   	std    
  801536:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801538:	fc                   	cld    
  801539:	eb 57                	jmp    801592 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80153b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153f:	83 e0 03             	and    $0x3,%eax
  801542:	48 85 c0             	test   %rax,%rax
  801545:	75 36                	jne    80157d <memmove+0xfc>
  801547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154b:	83 e0 03             	and    $0x3,%eax
  80154e:	48 85 c0             	test   %rax,%rax
  801551:	75 2a                	jne    80157d <memmove+0xfc>
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	83 e0 03             	and    $0x3,%eax
  80155a:	48 85 c0             	test   %rax,%rax
  80155d:	75 1e                	jne    80157d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 c1 e8 02          	shr    $0x2,%rax
  801567:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80156a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801572:	48 89 c7             	mov    %rax,%rdi
  801575:	48 89 d6             	mov    %rdx,%rsi
  801578:	fc                   	cld    
  801579:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80157b:	eb 15                	jmp    801592 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80157d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801581:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801585:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801589:	48 89 c7             	mov    %rax,%rdi
  80158c:	48 89 d6             	mov    %rdx,%rsi
  80158f:	fc                   	cld    
  801590:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801596:	c9                   	leaveq 
  801597:	c3                   	retq   

0000000000801598 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801598:	55                   	push   %rbp
  801599:	48 89 e5             	mov    %rsp,%rbp
  80159c:	48 83 ec 18          	sub    $0x18,%rsp
  8015a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b8:	48 89 ce             	mov    %rcx,%rsi
  8015bb:	48 89 c7             	mov    %rax,%rdi
  8015be:	48 b8 81 14 80 00 00 	movabs $0x801481,%rax
  8015c5:	00 00 00 
  8015c8:	ff d0                	callq  *%rax
}
  8015ca:	c9                   	leaveq 
  8015cb:	c3                   	retq   

00000000008015cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015cc:	55                   	push   %rbp
  8015cd:	48 89 e5             	mov    %rsp,%rbp
  8015d0:	48 83 ec 28          	sub    $0x28,%rsp
  8015d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015f0:	eb 36                	jmp    801628 <memcmp+0x5c>
		if (*s1 != *s2)
  8015f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f6:	0f b6 10             	movzbl (%rax),%edx
  8015f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fd:	0f b6 00             	movzbl (%rax),%eax
  801600:	38 c2                	cmp    %al,%dl
  801602:	74 1a                	je     80161e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	0f b6 d0             	movzbl %al,%edx
  80160e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801612:	0f b6 00             	movzbl (%rax),%eax
  801615:	0f b6 c0             	movzbl %al,%eax
  801618:	29 c2                	sub    %eax,%edx
  80161a:	89 d0                	mov    %edx,%eax
  80161c:	eb 20                	jmp    80163e <memcmp+0x72>
		s1++, s2++;
  80161e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801623:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801630:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801634:	48 85 c0             	test   %rax,%rax
  801637:	75 b9                	jne    8015f2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163e:	c9                   	leaveq 
  80163f:	c3                   	retq   

0000000000801640 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	48 83 ec 28          	sub    $0x28,%rsp
  801648:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80164c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80164f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80165b:	48 01 d0             	add    %rdx,%rax
  80165e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801662:	eb 15                	jmp    801679 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801668:	0f b6 10             	movzbl (%rax),%edx
  80166b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80166e:	38 c2                	cmp    %al,%dl
  801670:	75 02                	jne    801674 <memfind+0x34>
			break;
  801672:	eb 0f                	jmp    801683 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801674:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801681:	72 e1                	jb     801664 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801687:	c9                   	leaveq 
  801688:	c3                   	retq   

0000000000801689 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801689:	55                   	push   %rbp
  80168a:	48 89 e5             	mov    %rsp,%rbp
  80168d:	48 83 ec 34          	sub    $0x34,%rsp
  801691:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801695:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801699:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80169c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016a3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016aa:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ab:	eb 05                	jmp    8016b2 <strtol+0x29>
		s++;
  8016ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	3c 20                	cmp    $0x20,%al
  8016bb:	74 f0                	je     8016ad <strtol+0x24>
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	0f b6 00             	movzbl (%rax),%eax
  8016c4:	3c 09                	cmp    $0x9,%al
  8016c6:	74 e5                	je     8016ad <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	3c 2b                	cmp    $0x2b,%al
  8016d1:	75 07                	jne    8016da <strtol+0x51>
		s++;
  8016d3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d8:	eb 17                	jmp    8016f1 <strtol+0x68>
	else if (*s == '-')
  8016da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016de:	0f b6 00             	movzbl (%rax),%eax
  8016e1:	3c 2d                	cmp    $0x2d,%al
  8016e3:	75 0c                	jne    8016f1 <strtol+0x68>
		s++, neg = 1;
  8016e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016f5:	74 06                	je     8016fd <strtol+0x74>
  8016f7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016fb:	75 28                	jne    801725 <strtol+0x9c>
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 30                	cmp    $0x30,%al
  801706:	75 1d                	jne    801725 <strtol+0x9c>
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	48 83 c0 01          	add    $0x1,%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 78                	cmp    $0x78,%al
  801715:	75 0e                	jne    801725 <strtol+0x9c>
		s += 2, base = 16;
  801717:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80171c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801723:	eb 2c                	jmp    801751 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801725:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801729:	75 19                	jne    801744 <strtol+0xbb>
  80172b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172f:	0f b6 00             	movzbl (%rax),%eax
  801732:	3c 30                	cmp    $0x30,%al
  801734:	75 0e                	jne    801744 <strtol+0xbb>
		s++, base = 8;
  801736:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80173b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801742:	eb 0d                	jmp    801751 <strtol+0xc8>
	else if (base == 0)
  801744:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801748:	75 07                	jne    801751 <strtol+0xc8>
		base = 10;
  80174a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801755:	0f b6 00             	movzbl (%rax),%eax
  801758:	3c 2f                	cmp    $0x2f,%al
  80175a:	7e 1d                	jle    801779 <strtol+0xf0>
  80175c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801760:	0f b6 00             	movzbl (%rax),%eax
  801763:	3c 39                	cmp    $0x39,%al
  801765:	7f 12                	jg     801779 <strtol+0xf0>
			dig = *s - '0';
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	0f be c0             	movsbl %al,%eax
  801771:	83 e8 30             	sub    $0x30,%eax
  801774:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801777:	eb 4e                	jmp    8017c7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	0f b6 00             	movzbl (%rax),%eax
  801780:	3c 60                	cmp    $0x60,%al
  801782:	7e 1d                	jle    8017a1 <strtol+0x118>
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	3c 7a                	cmp    $0x7a,%al
  80178d:	7f 12                	jg     8017a1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80178f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80179f:	eb 26                	jmp    8017c7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a5:	0f b6 00             	movzbl (%rax),%eax
  8017a8:	3c 40                	cmp    $0x40,%al
  8017aa:	7e 48                	jle    8017f4 <strtol+0x16b>
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	0f b6 00             	movzbl (%rax),%eax
  8017b3:	3c 5a                	cmp    $0x5a,%al
  8017b5:	7f 3d                	jg     8017f4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	0f be c0             	movsbl %al,%eax
  8017c1:	83 e8 37             	sub    $0x37,%eax
  8017c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ca:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017cd:	7c 02                	jl     8017d1 <strtol+0x148>
			break;
  8017cf:	eb 23                	jmp    8017f4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017d9:	48 98                	cltq   
  8017db:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017e0:	48 89 c2             	mov    %rax,%rdx
  8017e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e6:	48 98                	cltq   
  8017e8:	48 01 d0             	add    %rdx,%rax
  8017eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017ef:	e9 5d ff ff ff       	jmpq   801751 <strtol+0xc8>

	if (endptr)
  8017f4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017f9:	74 0b                	je     801806 <strtol+0x17d>
		*endptr = (char *) s;
  8017fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801803:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801806:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80180a:	74 09                	je     801815 <strtol+0x18c>
  80180c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801810:	48 f7 d8             	neg    %rax
  801813:	eb 04                	jmp    801819 <strtol+0x190>
  801815:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801819:	c9                   	leaveq 
  80181a:	c3                   	retq   

000000000080181b <strstr>:

char * strstr(const char *in, const char *str)
{
  80181b:	55                   	push   %rbp
  80181c:	48 89 e5             	mov    %rsp,%rbp
  80181f:	48 83 ec 30          	sub    $0x30,%rsp
  801823:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801827:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80182b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80182f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801833:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801837:	0f b6 00             	movzbl (%rax),%eax
  80183a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80183d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801841:	75 06                	jne    801849 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801847:	eb 6b                	jmp    8018b4 <strstr+0x99>

	len = strlen(str);
  801849:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184d:	48 89 c7             	mov    %rax,%rdi
  801850:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  801857:	00 00 00 
  80185a:	ff d0                	callq  *%rax
  80185c:	48 98                	cltq   
  80185e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80186a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80186e:	0f b6 00             	movzbl (%rax),%eax
  801871:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801874:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801878:	75 07                	jne    801881 <strstr+0x66>
				return (char *) 0;
  80187a:	b8 00 00 00 00       	mov    $0x0,%eax
  80187f:	eb 33                	jmp    8018b4 <strstr+0x99>
		} while (sc != c);
  801881:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801885:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801888:	75 d8                	jne    801862 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80188a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80188e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801896:	48 89 ce             	mov    %rcx,%rsi
  801899:	48 89 c7             	mov    %rax,%rdi
  80189c:	48 b8 12 13 80 00 00 	movabs $0x801312,%rax
  8018a3:	00 00 00 
  8018a6:	ff d0                	callq  *%rax
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	75 b6                	jne    801862 <strstr+0x47>

	return (char *) (in - 1);
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	48 83 e8 01          	sub    $0x1,%rax
}
  8018b4:	c9                   	leaveq 
  8018b5:	c3                   	retq   

00000000008018b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	53                   	push   %rbx
  8018bb:	48 83 ec 48          	sub    $0x48,%rsp
  8018bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018c2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018c5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018c9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018cd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018d1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018d8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018dc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018e0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018e4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018e8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018ec:	4c 89 c3             	mov    %r8,%rbx
  8018ef:	cd 30                	int    $0x30
  8018f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018f9:	74 3e                	je     801939 <syscall+0x83>
  8018fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801900:	7e 37                	jle    801939 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801902:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801906:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801909:	49 89 d0             	mov    %rdx,%r8
  80190c:	89 c1                	mov    %eax,%ecx
  80190e:	48 ba 48 50 80 00 00 	movabs $0x805048,%rdx
  801915:	00 00 00 
  801918:	be 23 00 00 00       	mov    $0x23,%esi
  80191d:	48 bf 65 50 80 00 00 	movabs $0x805065,%rdi
  801924:	00 00 00 
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	49 b9 5c 03 80 00 00 	movabs $0x80035c,%r9
  801933:	00 00 00 
  801936:	41 ff d1             	callq  *%r9

	return ret;
  801939:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80193d:	48 83 c4 48          	add    $0x48,%rsp
  801941:	5b                   	pop    %rbx
  801942:	5d                   	pop    %rbp
  801943:	c3                   	retq   

0000000000801944 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	48 83 ec 20          	sub    $0x20,%rsp
  80194c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801950:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801958:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801963:	00 
  801964:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801970:	48 89 d1             	mov    %rdx,%rcx
  801973:	48 89 c2             	mov    %rax,%rdx
  801976:	be 00 00 00 00       	mov    $0x0,%esi
  80197b:	bf 00 00 00 00       	mov    $0x0,%edi
  801980:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_cgetc>:

int
sys_cgetc(void)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801996:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199d:	00 
  80199e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019af:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b4:	be 00 00 00 00       	mov    $0x0,%esi
  8019b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019be:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  8019c5:	00 00 00 
  8019c8:	ff d0                	callq  *%rax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 10          	sub    $0x10,%rsp
  8019d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019da:	48 98                	cltq   
  8019dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e3:	00 
  8019e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f5:	48 89 c2             	mov    %rax,%rdx
  8019f8:	be 01 00 00 00       	mov    $0x1,%esi
  8019fd:	bf 03 00 00 00       	mov    $0x3,%edi
  801a02:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801a09:	00 00 00 
  801a0c:	ff d0                	callq  *%rax
}
  801a0e:	c9                   	leaveq 
  801a0f:	c3                   	retq   

0000000000801a10 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a10:	55                   	push   %rbp
  801a11:	48 89 e5             	mov    %rsp,%rbp
  801a14:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1f:	00 
  801a20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a31:	ba 00 00 00 00       	mov    $0x0,%edx
  801a36:	be 00 00 00 00       	mov    $0x0,%esi
  801a3b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a40:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801a47:	00 00 00 
  801a4a:	ff d0                	callq  *%rax
}
  801a4c:	c9                   	leaveq 
  801a4d:	c3                   	retq   

0000000000801a4e <sys_yield>:

void
sys_yield(void)
{
  801a4e:	55                   	push   %rbp
  801a4f:	48 89 e5             	mov    %rsp,%rbp
  801a52:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5d:	00 
  801a5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a74:	be 00 00 00 00       	mov    $0x0,%esi
  801a79:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a7e:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	callq  *%rax
}
  801a8a:	c9                   	leaveq 
  801a8b:	c3                   	retq   

0000000000801a8c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	48 83 ec 20          	sub    $0x20,%rsp
  801a94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a9b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa1:	48 63 c8             	movslq %eax,%rcx
  801aa4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aab:	48 98                	cltq   
  801aad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab4:	00 
  801ab5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abb:	49 89 c8             	mov    %rcx,%r8
  801abe:	48 89 d1             	mov    %rdx,%rcx
  801ac1:	48 89 c2             	mov    %rax,%rdx
  801ac4:	be 01 00 00 00       	mov    $0x1,%esi
  801ac9:	bf 04 00 00 00       	mov    $0x4,%edi
  801ace:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
}
  801ada:	c9                   	leaveq 
  801adb:	c3                   	retq   

0000000000801adc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801adc:	55                   	push   %rbp
  801add:	48 89 e5             	mov    %rsp,%rbp
  801ae0:	48 83 ec 30          	sub    $0x30,%rsp
  801ae4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aeb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801aee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801af2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801af6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801af9:	48 63 c8             	movslq %eax,%rcx
  801afc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b03:	48 63 f0             	movslq %eax,%rsi
  801b06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0d:	48 98                	cltq   
  801b0f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b13:	49 89 f9             	mov    %rdi,%r9
  801b16:	49 89 f0             	mov    %rsi,%r8
  801b19:	48 89 d1             	mov    %rdx,%rcx
  801b1c:	48 89 c2             	mov    %rax,%rdx
  801b1f:	be 01 00 00 00       	mov    $0x1,%esi
  801b24:	bf 05 00 00 00       	mov    $0x5,%edi
  801b29:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
}
  801b35:	c9                   	leaveq 
  801b36:	c3                   	retq   

0000000000801b37 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b37:	55                   	push   %rbp
  801b38:	48 89 e5             	mov    %rsp,%rbp
  801b3b:	48 83 ec 20          	sub    $0x20,%rsp
  801b3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4d:	48 98                	cltq   
  801b4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b56:	00 
  801b57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b63:	48 89 d1             	mov    %rdx,%rcx
  801b66:	48 89 c2             	mov    %rax,%rdx
  801b69:	be 01 00 00 00       	mov    $0x1,%esi
  801b6e:	bf 06 00 00 00       	mov    $0x6,%edi
  801b73:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801b7a:	00 00 00 
  801b7d:	ff d0                	callq  *%rax
}
  801b7f:	c9                   	leaveq 
  801b80:	c3                   	retq   

0000000000801b81 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b81:	55                   	push   %rbp
  801b82:	48 89 e5             	mov    %rsp,%rbp
  801b85:	48 83 ec 10          	sub    $0x10,%rsp
  801b89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b92:	48 63 d0             	movslq %eax,%rdx
  801b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b98:	48 98                	cltq   
  801b9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba1:	00 
  801ba2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bae:	48 89 d1             	mov    %rdx,%rcx
  801bb1:	48 89 c2             	mov    %rax,%rdx
  801bb4:	be 01 00 00 00       	mov    $0x1,%esi
  801bb9:	bf 08 00 00 00       	mov    $0x8,%edi
  801bbe:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	callq  *%rax
}
  801bca:	c9                   	leaveq 
  801bcb:	c3                   	retq   

0000000000801bcc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bcc:	55                   	push   %rbp
  801bcd:	48 89 e5             	mov    %rsp,%rbp
  801bd0:	48 83 ec 20          	sub    $0x20,%rsp
  801bd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be2:	48 98                	cltq   
  801be4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801beb:	00 
  801bec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf8:	48 89 d1             	mov    %rdx,%rcx
  801bfb:	48 89 c2             	mov    %rax,%rdx
  801bfe:	be 01 00 00 00       	mov    $0x1,%esi
  801c03:	bf 09 00 00 00       	mov    $0x9,%edi
  801c08:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801c0f:	00 00 00 
  801c12:	ff d0                	callq  *%rax
}
  801c14:	c9                   	leaveq 
  801c15:	c3                   	retq   

0000000000801c16 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c16:	55                   	push   %rbp
  801c17:	48 89 e5             	mov    %rsp,%rbp
  801c1a:	48 83 ec 20          	sub    $0x20,%rsp
  801c1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2c:	48 98                	cltq   
  801c2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c35:	00 
  801c36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c42:	48 89 d1             	mov    %rdx,%rcx
  801c45:	48 89 c2             	mov    %rax,%rdx
  801c48:	be 01 00 00 00       	mov    $0x1,%esi
  801c4d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c52:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
}
  801c5e:	c9                   	leaveq 
  801c5f:	c3                   	retq   

0000000000801c60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c60:	55                   	push   %rbp
  801c61:	48 89 e5             	mov    %rsp,%rbp
  801c64:	48 83 ec 20          	sub    $0x20,%rsp
  801c68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c6f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c73:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c79:	48 63 f0             	movslq %eax,%rsi
  801c7c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c83:	48 98                	cltq   
  801c85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c90:	00 
  801c91:	49 89 f1             	mov    %rsi,%r9
  801c94:	49 89 c8             	mov    %rcx,%r8
  801c97:	48 89 d1             	mov    %rdx,%rcx
  801c9a:	48 89 c2             	mov    %rax,%rdx
  801c9d:	be 00 00 00 00       	mov    $0x0,%esi
  801ca2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ca7:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
}
  801cb3:	c9                   	leaveq 
  801cb4:	c3                   	retq   

0000000000801cb5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cb5:	55                   	push   %rbp
  801cb6:	48 89 e5             	mov    %rsp,%rbp
  801cb9:	48 83 ec 10          	sub    $0x10,%rsp
  801cbd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ccc:	00 
  801ccd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cde:	48 89 c2             	mov    %rax,%rdx
  801ce1:	be 01 00 00 00       	mov    $0x1,%esi
  801ce6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ceb:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801cf2:	00 00 00 
  801cf5:	ff d0                	callq  *%rax
}
  801cf7:	c9                   	leaveq 
  801cf8:	c3                   	retq   

0000000000801cf9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801cf9:	55                   	push   %rbp
  801cfa:	48 89 e5             	mov    %rsp,%rbp
  801cfd:	48 83 ec 30          	sub    $0x30,%rsp
  801d01:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d09:	48 8b 00             	mov    (%rax),%rax
  801d0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d14:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d18:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801d1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d1e:	83 e0 02             	and    $0x2,%eax
  801d21:	85 c0                	test   %eax,%eax
  801d23:	75 4d                	jne    801d72 <pgfault+0x79>
  801d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d29:	48 c1 e8 0c          	shr    $0xc,%rax
  801d2d:	48 89 c2             	mov    %rax,%rdx
  801d30:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d37:	01 00 00 
  801d3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d3e:	25 00 08 00 00       	and    $0x800,%eax
  801d43:	48 85 c0             	test   %rax,%rax
  801d46:	74 2a                	je     801d72 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801d48:	48 ba 78 50 80 00 00 	movabs $0x805078,%rdx
  801d4f:	00 00 00 
  801d52:	be 1e 00 00 00       	mov    $0x1e,%esi
  801d57:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801d5e:	00 00 00 
  801d61:	b8 00 00 00 00       	mov    $0x0,%eax
  801d66:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801d6d:	00 00 00 
  801d70:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801d72:	ba 07 00 00 00       	mov    $0x7,%edx
  801d77:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d81:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	0f 85 cd 00 00 00    	jne    801e62 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801da7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801daf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801db4:	48 89 c6             	mov    %rax,%rsi
  801db7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801dbc:	48 b8 81 14 80 00 00 	movabs $0x801481,%rax
  801dc3:	00 00 00 
  801dc6:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801dc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dcc:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801dd2:	48 89 c1             	mov    %rax,%rcx
  801dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dda:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ddf:	bf 00 00 00 00       	mov    $0x0,%edi
  801de4:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  801deb:	00 00 00 
  801dee:	ff d0                	callq  *%rax
  801df0:	85 c0                	test   %eax,%eax
  801df2:	79 2a                	jns    801e1e <pgfault+0x125>
				panic("Page map at temp address failed");
  801df4:	48 ba a8 50 80 00 00 	movabs $0x8050a8,%rdx
  801dfb:	00 00 00 
  801dfe:	be 2f 00 00 00       	mov    $0x2f,%esi
  801e03:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801e0a:	00 00 00 
  801e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e12:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801e19:	00 00 00 
  801e1c:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801e1e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e23:	bf 00 00 00 00       	mov    $0x0,%edi
  801e28:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	callq  *%rax
  801e34:	85 c0                	test   %eax,%eax
  801e36:	79 54                	jns    801e8c <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801e38:	48 ba c8 50 80 00 00 	movabs $0x8050c8,%rdx
  801e3f:	00 00 00 
  801e42:	be 31 00 00 00       	mov    $0x31,%esi
  801e47:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801e4e:	00 00 00 
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
  801e56:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801e5d:	00 00 00 
  801e60:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801e62:	48 ba f0 50 80 00 00 	movabs $0x8050f0,%rdx
  801e69:	00 00 00 
  801e6c:	be 35 00 00 00       	mov    $0x35,%esi
  801e71:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801e78:	00 00 00 
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801e87:	00 00 00 
  801e8a:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801e8c:	c9                   	leaveq 
  801e8d:	c3                   	retq   

0000000000801e8e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e8e:	55                   	push   %rbp
  801e8f:	48 89 e5             	mov    %rsp,%rbp
  801e92:	48 83 ec 20          	sub    $0x20,%rsp
  801e96:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e99:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801e9c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea3:	01 00 00 
  801ea6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ea9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ead:	25 07 0e 00 00       	and    $0xe07,%eax
  801eb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801eb5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801eb8:	48 c1 e0 0c          	shl    $0xc,%rax
  801ebc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec3:	25 00 04 00 00       	and    $0x400,%eax
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	74 57                	je     801f23 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ecc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ecf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ed3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eda:	41 89 f0             	mov    %esi,%r8d
  801edd:	48 89 c6             	mov    %rax,%rsi
  801ee0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee5:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  801eec:	00 00 00 
  801eef:	ff d0                	callq  *%rax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	0f 8e 52 01 00 00    	jle    80204b <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801ef9:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  801f00:	00 00 00 
  801f03:	be 52 00 00 00       	mov    $0x52,%esi
  801f08:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801f0f:	00 00 00 
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801f1e:	00 00 00 
  801f21:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f26:	83 e0 02             	and    $0x2,%eax
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	75 10                	jne    801f3d <duppage+0xaf>
  801f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f30:	25 00 08 00 00       	and    $0x800,%eax
  801f35:	85 c0                	test   %eax,%eax
  801f37:	0f 84 bb 00 00 00    	je     801ff8 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f40:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801f45:	80 cc 08             	or     $0x8,%ah
  801f48:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f4b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f4e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f52:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f59:	41 89 f0             	mov    %esi,%r8d
  801f5c:	48 89 c6             	mov    %rax,%rsi
  801f5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f64:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  801f6b:	00 00 00 
  801f6e:	ff d0                	callq  *%rax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	7e 2a                	jle    801f9e <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801f74:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  801f7b:	00 00 00 
  801f7e:	be 5a 00 00 00       	mov    $0x5a,%esi
  801f83:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801f8a:	00 00 00 
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801f99:	00 00 00 
  801f9c:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f9e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801fa1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa9:	41 89 c8             	mov    %ecx,%r8d
  801fac:	48 89 d1             	mov    %rdx,%rcx
  801faf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb4:	48 89 c6             	mov    %rax,%rsi
  801fb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbc:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	7e 2a                	jle    801ff6 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801fcc:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  801fd3:	00 00 00 
  801fd6:	be 5d 00 00 00       	mov    $0x5d,%esi
  801fdb:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  801fe2:	00 00 00 
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  801ff1:	00 00 00 
  801ff4:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ff6:	eb 53                	jmp    80204b <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ff8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ffb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802006:	41 89 f0             	mov    %esi,%r8d
  802009:	48 89 c6             	mov    %rax,%rsi
  80200c:	bf 00 00 00 00       	mov    $0x0,%edi
  802011:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	7e 2a                	jle    80204b <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  802021:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  802028:	00 00 00 
  80202b:	be 61 00 00 00       	mov    $0x61,%esi
  802030:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  802037:	00 00 00 
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  802046:	00 00 00 
  802049:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802050:	c9                   	leaveq 
  802051:	c3                   	retq   

0000000000802052 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802052:	55                   	push   %rbp
  802053:	48 89 e5             	mov    %rsp,%rbp
  802056:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  80205a:	48 bf f9 1c 80 00 00 	movabs $0x801cf9,%rdi
  802061:	00 00 00 
  802064:	48 b8 cf 46 80 00 00 	movabs $0x8046cf,%rax
  80206b:	00 00 00 
  80206e:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802070:	b8 07 00 00 00       	mov    $0x7,%eax
  802075:	cd 30                	int    $0x30
  802077:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80207a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80207d:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  802080:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802084:	79 30                	jns    8020b6 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802086:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802089:	89 c1                	mov    %eax,%ecx
  80208b:	48 ba 3b 51 80 00 00 	movabs $0x80513b,%rdx
  802092:	00 00 00 
  802095:	be 89 00 00 00       	mov    $0x89,%esi
  80209a:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  8020a1:	00 00 00 
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  8020b0:	00 00 00 
  8020b3:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  8020b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020ba:	75 46                	jne    802102 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  8020bc:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  8020c3:	00 00 00 
  8020c6:	ff d0                	callq  *%rax
  8020c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020cd:	48 63 d0             	movslq %eax,%rdx
  8020d0:	48 89 d0             	mov    %rdx,%rax
  8020d3:	48 c1 e0 03          	shl    $0x3,%rax
  8020d7:	48 01 d0             	add    %rdx,%rax
  8020da:	48 c1 e0 05          	shl    $0x5,%rax
  8020de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8020e5:	00 00 00 
  8020e8:	48 01 c2             	add    %rax,%rdx
  8020eb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8020f2:	00 00 00 
  8020f5:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fd:	e9 d1 01 00 00       	jmpq   8022d3 <fork+0x281>
	}

	uint64_t ad = 0;
  802102:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802109:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  80210a:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80210f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802113:	e9 df 00 00 00       	jmpq   8021f7 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211c:	48 c1 e8 27          	shr    $0x27,%rax
  802120:	48 89 c2             	mov    %rax,%rdx
  802123:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80212a:	01 00 00 
  80212d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802131:	83 e0 01             	and    $0x1,%eax
  802134:	48 85 c0             	test   %rax,%rax
  802137:	0f 84 9e 00 00 00    	je     8021db <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80213d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802141:	48 c1 e8 1e          	shr    $0x1e,%rax
  802145:	48 89 c2             	mov    %rax,%rdx
  802148:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80214f:	01 00 00 
  802152:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802156:	83 e0 01             	and    $0x1,%eax
  802159:	48 85 c0             	test   %rax,%rax
  80215c:	74 73                	je     8021d1 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80215e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802162:	48 c1 e8 15          	shr    $0x15,%rax
  802166:	48 89 c2             	mov    %rax,%rdx
  802169:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802170:	01 00 00 
  802173:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802177:	83 e0 01             	and    $0x1,%eax
  80217a:	48 85 c0             	test   %rax,%rax
  80217d:	74 48                	je     8021c7 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80217f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802183:	48 c1 e8 0c          	shr    $0xc,%rax
  802187:	48 89 c2             	mov    %rax,%rdx
  80218a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802191:	01 00 00 
  802194:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802198:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80219c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a0:	83 e0 01             	and    $0x1,%eax
  8021a3:	48 85 c0             	test   %rax,%rax
  8021a6:	74 47                	je     8021ef <fork+0x19d>
						duppage(envid, VPN(addr));
  8021a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b0:	89 c2                	mov    %eax,%edx
  8021b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021b5:	89 d6                	mov    %edx,%esi
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	48 b8 8e 1e 80 00 00 	movabs $0x801e8e,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	eb 28                	jmp    8021ef <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  8021c7:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8021ce:	00 
  8021cf:	eb 1e                	jmp    8021ef <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8021d1:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8021d8:	40 
  8021d9:	eb 14                	jmp    8021ef <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  8021db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021df:	48 c1 e8 27          	shr    $0x27,%rax
  8021e3:	48 83 c0 01          	add    $0x1,%rax
  8021e7:	48 c1 e0 27          	shl    $0x27,%rax
  8021eb:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8021ef:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8021f6:	00 
  8021f7:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8021fe:	00 
  8021ff:	0f 87 13 ff ff ff    	ja     802118 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802205:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802208:	ba 07 00 00 00       	mov    $0x7,%edx
  80220d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802212:	89 c7                	mov    %eax,%edi
  802214:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802220:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802223:	ba 07 00 00 00       	mov    $0x7,%edx
  802228:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80222d:	89 c7                	mov    %eax,%edi
  80222f:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80223b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80223e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802244:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802249:	ba 00 00 00 00       	mov    $0x0,%edx
  80224e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802253:	89 c7                	mov    %eax,%edi
  802255:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802261:	ba 00 10 00 00       	mov    $0x1000,%edx
  802266:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80226b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802270:	48 b8 81 14 80 00 00 	movabs $0x801481,%rax
  802277:	00 00 00 
  80227a:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80227c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802281:	bf 00 00 00 00       	mov    $0x0,%edi
  802286:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  80228d:	00 00 00 
  802290:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802292:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802299:	00 00 00 
  80229c:	48 8b 00             	mov    (%rax),%rax
  80229f:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8022a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022a9:	48 89 d6             	mov    %rdx,%rsi
  8022ac:	89 c7                	mov    %eax,%edi
  8022ae:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  8022b5:	00 00 00 
  8022b8:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  8022ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022bd:	be 02 00 00 00       	mov    $0x2,%esi
  8022c2:	89 c7                	mov    %eax,%edi
  8022c4:	48 b8 81 1b 80 00 00 	movabs $0x801b81,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	callq  *%rax

	return envid;
  8022d0:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8022d3:	c9                   	leaveq 
  8022d4:	c3                   	retq   

00000000008022d5 <sfork>:

// Challenge!
int
sfork(void)
{
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022d9:	48 ba 53 51 80 00 00 	movabs $0x805153,%rdx
  8022e0:	00 00 00 
  8022e3:	be b8 00 00 00       	mov    $0xb8,%esi
  8022e8:	48 bf 9d 50 80 00 00 	movabs $0x80509d,%rdi
  8022ef:	00 00 00 
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  8022fe:	00 00 00 
  802301:	ff d1                	callq  *%rcx

0000000000802303 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
  802307:	48 83 ec 08          	sub    $0x8,%rsp
  80230b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80230f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802313:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80231a:	ff ff ff 
  80231d:	48 01 d0             	add    %rdx,%rax
  802320:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802324:	c9                   	leaveq 
  802325:	c3                   	retq   

0000000000802326 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802326:	55                   	push   %rbp
  802327:	48 89 e5             	mov    %rsp,%rbp
  80232a:	48 83 ec 08          	sub    $0x8,%rsp
  80232e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802336:	48 89 c7             	mov    %rax,%rdi
  802339:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
  802345:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80234b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80234f:	c9                   	leaveq 
  802350:	c3                   	retq   

0000000000802351 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802351:	55                   	push   %rbp
  802352:	48 89 e5             	mov    %rsp,%rbp
  802355:	48 83 ec 18          	sub    $0x18,%rsp
  802359:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80235d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802364:	eb 6b                	jmp    8023d1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802366:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802369:	48 98                	cltq   
  80236b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802371:	48 c1 e0 0c          	shl    $0xc,%rax
  802375:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237d:	48 c1 e8 15          	shr    $0x15,%rax
  802381:	48 89 c2             	mov    %rax,%rdx
  802384:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80238b:	01 00 00 
  80238e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802392:	83 e0 01             	and    $0x1,%eax
  802395:	48 85 c0             	test   %rax,%rax
  802398:	74 21                	je     8023bb <fd_alloc+0x6a>
  80239a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239e:	48 c1 e8 0c          	shr    $0xc,%rax
  8023a2:	48 89 c2             	mov    %rax,%rdx
  8023a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ac:	01 00 00 
  8023af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b3:	83 e0 01             	and    $0x1,%eax
  8023b6:	48 85 c0             	test   %rax,%rax
  8023b9:	75 12                	jne    8023cd <fd_alloc+0x7c>
			*fd_store = fd;
  8023bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	eb 1a                	jmp    8023e7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023d1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023d5:	7e 8f                	jle    802366 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023db:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023e2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023e7:	c9                   	leaveq 
  8023e8:	c3                   	retq   

00000000008023e9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023e9:	55                   	push   %rbp
  8023ea:	48 89 e5             	mov    %rsp,%rbp
  8023ed:	48 83 ec 20          	sub    $0x20,%rsp
  8023f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023fc:	78 06                	js     802404 <fd_lookup+0x1b>
  8023fe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802402:	7e 07                	jle    80240b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802404:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802409:	eb 6c                	jmp    802477 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80240b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80240e:	48 98                	cltq   
  802410:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802416:	48 c1 e0 0c          	shl    $0xc,%rax
  80241a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80241e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802422:	48 c1 e8 15          	shr    $0x15,%rax
  802426:	48 89 c2             	mov    %rax,%rdx
  802429:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802430:	01 00 00 
  802433:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802437:	83 e0 01             	and    $0x1,%eax
  80243a:	48 85 c0             	test   %rax,%rax
  80243d:	74 21                	je     802460 <fd_lookup+0x77>
  80243f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802443:	48 c1 e8 0c          	shr    $0xc,%rax
  802447:	48 89 c2             	mov    %rax,%rdx
  80244a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802451:	01 00 00 
  802454:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802458:	83 e0 01             	and    $0x1,%eax
  80245b:	48 85 c0             	test   %rax,%rax
  80245e:	75 07                	jne    802467 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802460:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802465:	eb 10                	jmp    802477 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802467:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802477:	c9                   	leaveq 
  802478:	c3                   	retq   

0000000000802479 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802479:	55                   	push   %rbp
  80247a:	48 89 e5             	mov    %rsp,%rbp
  80247d:	48 83 ec 30          	sub    $0x30,%rsp
  802481:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802485:	89 f0                	mov    %esi,%eax
  802487:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80248a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248e:	48 89 c7             	mov    %rax,%rdi
  802491:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a1:	48 89 d6             	mov    %rdx,%rsi
  8024a4:	89 c7                	mov    %eax,%edi
  8024a6:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
  8024b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b9:	78 0a                	js     8024c5 <fd_close+0x4c>
	    || fd != fd2)
  8024bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024c3:	74 12                	je     8024d7 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024c5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024c9:	74 05                	je     8024d0 <fd_close+0x57>
  8024cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ce:	eb 05                	jmp    8024d5 <fd_close+0x5c>
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d5:	eb 69                	jmp    802540 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024db:	8b 00                	mov    (%rax),%eax
  8024dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e1:	48 89 d6             	mov    %rdx,%rsi
  8024e4:	89 c7                	mov    %eax,%edi
  8024e6:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  8024ed:	00 00 00 
  8024f0:	ff d0                	callq  *%rax
  8024f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f9:	78 2a                	js     802525 <fd_close+0xac>
		if (dev->dev_close)
  8024fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ff:	48 8b 40 20          	mov    0x20(%rax),%rax
  802503:	48 85 c0             	test   %rax,%rax
  802506:	74 16                	je     80251e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802510:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802514:	48 89 d7             	mov    %rdx,%rdi
  802517:	ff d0                	callq  *%rax
  802519:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251c:	eb 07                	jmp    802525 <fd_close+0xac>
		else
			r = 0;
  80251e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802529:	48 89 c6             	mov    %rax,%rsi
  80252c:	bf 00 00 00 00       	mov    $0x0,%edi
  802531:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
	return r;
  80253d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802540:	c9                   	leaveq 
  802541:	c3                   	retq   

0000000000802542 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802542:	55                   	push   %rbp
  802543:	48 89 e5             	mov    %rsp,%rbp
  802546:	48 83 ec 20          	sub    $0x20,%rsp
  80254a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80254d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802551:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802558:	eb 41                	jmp    80259b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80255a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802561:	00 00 00 
  802564:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802567:	48 63 d2             	movslq %edx,%rdx
  80256a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256e:	8b 00                	mov    (%rax),%eax
  802570:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802573:	75 22                	jne    802597 <dev_lookup+0x55>
			*dev = devtab[i];
  802575:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80257c:	00 00 00 
  80257f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802582:	48 63 d2             	movslq %edx,%rdx
  802585:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
  802595:	eb 60                	jmp    8025f7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802597:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80259b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025a2:	00 00 00 
  8025a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025a8:	48 63 d2             	movslq %edx,%rdx
  8025ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025af:	48 85 c0             	test   %rax,%rax
  8025b2:	75 a6                	jne    80255a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025b4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025bb:	00 00 00 
  8025be:	48 8b 00             	mov    (%rax),%rax
  8025c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025ca:	89 c6                	mov    %eax,%esi
  8025cc:	48 bf 70 51 80 00 00 	movabs $0x805170,%rdi
  8025d3:	00 00 00 
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  8025e2:	00 00 00 
  8025e5:	ff d1                	callq  *%rcx
	*dev = 0;
  8025e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025f7:	c9                   	leaveq 
  8025f8:	c3                   	retq   

00000000008025f9 <close>:

int
close(int fdnum)
{
  8025f9:	55                   	push   %rbp
  8025fa:	48 89 e5             	mov    %rsp,%rbp
  8025fd:	48 83 ec 20          	sub    $0x20,%rsp
  802601:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802604:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802608:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	79 05                	jns    80262a <close+0x31>
		return r;
  802625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802628:	eb 18                	jmp    802642 <close+0x49>
	else
		return fd_close(fd, 1);
  80262a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262e:	be 01 00 00 00       	mov    $0x1,%esi
  802633:	48 89 c7             	mov    %rax,%rdi
  802636:	48 b8 79 24 80 00 00 	movabs $0x802479,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax
}
  802642:	c9                   	leaveq 
  802643:	c3                   	retq   

0000000000802644 <close_all>:

void
close_all(void)
{
  802644:	55                   	push   %rbp
  802645:	48 89 e5             	mov    %rsp,%rbp
  802648:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80264c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802653:	eb 15                	jmp    80266a <close_all+0x26>
		close(i);
  802655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802658:	89 c7                	mov    %eax,%edi
  80265a:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802666:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80266a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80266e:	7e e5                	jle    802655 <close_all+0x11>
		close(i);
}
  802670:	c9                   	leaveq 
  802671:	c3                   	retq   

0000000000802672 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802672:	55                   	push   %rbp
  802673:	48 89 e5             	mov    %rsp,%rbp
  802676:	48 83 ec 40          	sub    $0x40,%rsp
  80267a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80267d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802680:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802684:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802687:	48 89 d6             	mov    %rdx,%rsi
  80268a:	89 c7                	mov    %eax,%edi
  80268c:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
  802698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269f:	79 08                	jns    8026a9 <dup+0x37>
		return r;
  8026a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a4:	e9 70 01 00 00       	jmpq   802819 <dup+0x1a7>
	close(newfdnum);
  8026a9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026ac:	89 c7                	mov    %eax,%edi
  8026ae:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026ba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026bd:	48 98                	cltq   
  8026bf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c5:	48 c1 e0 0c          	shl    $0xc,%rax
  8026c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d1:	48 89 c7             	mov    %rax,%rdi
  8026d4:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
  8026e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e8:	48 89 c7             	mov    %rax,%rdi
  8026eb:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8026f2:	00 00 00 
  8026f5:	ff d0                	callq  *%rax
  8026f7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ff:	48 c1 e8 15          	shr    $0x15,%rax
  802703:	48 89 c2             	mov    %rax,%rdx
  802706:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80270d:	01 00 00 
  802710:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802714:	83 e0 01             	and    $0x1,%eax
  802717:	48 85 c0             	test   %rax,%rax
  80271a:	74 73                	je     80278f <dup+0x11d>
  80271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802720:	48 c1 e8 0c          	shr    $0xc,%rax
  802724:	48 89 c2             	mov    %rax,%rdx
  802727:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272e:	01 00 00 
  802731:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802735:	83 e0 01             	and    $0x1,%eax
  802738:	48 85 c0             	test   %rax,%rax
  80273b:	74 52                	je     80278f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80273d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802741:	48 c1 e8 0c          	shr    $0xc,%rax
  802745:	48 89 c2             	mov    %rax,%rdx
  802748:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80274f:	01 00 00 
  802752:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802756:	25 07 0e 00 00       	and    $0xe07,%eax
  80275b:	89 c1                	mov    %eax,%ecx
  80275d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802765:	41 89 c8             	mov    %ecx,%r8d
  802768:	48 89 d1             	mov    %rdx,%rcx
  80276b:	ba 00 00 00 00       	mov    $0x0,%edx
  802770:	48 89 c6             	mov    %rax,%rsi
  802773:	bf 00 00 00 00       	mov    $0x0,%edi
  802778:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
  802784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278b:	79 02                	jns    80278f <dup+0x11d>
			goto err;
  80278d:	eb 57                	jmp    8027e6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80278f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802793:	48 c1 e8 0c          	shr    $0xc,%rax
  802797:	48 89 c2             	mov    %rax,%rdx
  80279a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027a1:	01 00 00 
  8027a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027b7:	41 89 c8             	mov    %ecx,%r8d
  8027ba:	48 89 d1             	mov    %rdx,%rcx
  8027bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c2:	48 89 c6             	mov    %rax,%rsi
  8027c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ca:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027dd:	79 02                	jns    8027e1 <dup+0x16f>
		goto err;
  8027df:	eb 05                	jmp    8027e6 <dup+0x174>

	return newfdnum;
  8027e1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027e4:	eb 33                	jmp    802819 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ea:	48 89 c6             	mov    %rax,%rsi
  8027ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f2:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802802:	48 89 c6             	mov    %rax,%rsi
  802805:	bf 00 00 00 00       	mov    $0x0,%edi
  80280a:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  802811:	00 00 00 
  802814:	ff d0                	callq  *%rax
	return r;
  802816:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802819:	c9                   	leaveq 
  80281a:	c3                   	retq   

000000000080281b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80281b:	55                   	push   %rbp
  80281c:	48 89 e5             	mov    %rsp,%rbp
  80281f:	48 83 ec 40          	sub    $0x40,%rsp
  802823:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802826:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80282a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802832:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802835:	48 89 d6             	mov    %rdx,%rsi
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
  802846:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284d:	78 24                	js     802873 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80284f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802853:	8b 00                	mov    (%rax),%eax
  802855:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802859:	48 89 d6             	mov    %rdx,%rsi
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  802865:	00 00 00 
  802868:	ff d0                	callq  *%rax
  80286a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802871:	79 05                	jns    802878 <read+0x5d>
		return r;
  802873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802876:	eb 76                	jmp    8028ee <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287c:	8b 40 08             	mov    0x8(%rax),%eax
  80287f:	83 e0 03             	and    $0x3,%eax
  802882:	83 f8 01             	cmp    $0x1,%eax
  802885:	75 3a                	jne    8028c1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802887:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80288e:	00 00 00 
  802891:	48 8b 00             	mov    (%rax),%rax
  802894:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80289a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80289d:	89 c6                	mov    %eax,%esi
  80289f:	48 bf 8f 51 80 00 00 	movabs $0x80518f,%rdi
  8028a6:	00 00 00 
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ae:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  8028b5:	00 00 00 
  8028b8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028bf:	eb 2d                	jmp    8028ee <read+0xd3>
	}
	if (!dev->dev_read)
  8028c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028c9:	48 85 c0             	test   %rax,%rax
  8028cc:	75 07                	jne    8028d5 <read+0xba>
		return -E_NOT_SUPP;
  8028ce:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d3:	eb 19                	jmp    8028ee <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028e5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028e9:	48 89 cf             	mov    %rcx,%rdi
  8028ec:	ff d0                	callq  *%rax
}
  8028ee:	c9                   	leaveq 
  8028ef:	c3                   	retq   

00000000008028f0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028f0:	55                   	push   %rbp
  8028f1:	48 89 e5             	mov    %rsp,%rbp
  8028f4:	48 83 ec 30          	sub    $0x30,%rsp
  8028f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802903:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80290a:	eb 49                	jmp    802955 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80290c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290f:	48 98                	cltq   
  802911:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802915:	48 29 c2             	sub    %rax,%rdx
  802918:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291b:	48 63 c8             	movslq %eax,%rcx
  80291e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802922:	48 01 c1             	add    %rax,%rcx
  802925:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802928:	48 89 ce             	mov    %rcx,%rsi
  80292b:	89 c7                	mov    %eax,%edi
  80292d:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  802934:	00 00 00 
  802937:	ff d0                	callq  *%rax
  802939:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80293c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802940:	79 05                	jns    802947 <readn+0x57>
			return m;
  802942:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802945:	eb 1c                	jmp    802963 <readn+0x73>
		if (m == 0)
  802947:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80294b:	75 02                	jne    80294f <readn+0x5f>
			break;
  80294d:	eb 11                	jmp    802960 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80294f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802952:	01 45 fc             	add    %eax,-0x4(%rbp)
  802955:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802958:	48 98                	cltq   
  80295a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80295e:	72 ac                	jb     80290c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802960:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802963:	c9                   	leaveq 
  802964:	c3                   	retq   

0000000000802965 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802965:	55                   	push   %rbp
  802966:	48 89 e5             	mov    %rsp,%rbp
  802969:	48 83 ec 40          	sub    $0x40,%rsp
  80296d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802970:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802974:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802978:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80297f:	48 89 d6             	mov    %rdx,%rsi
  802982:	89 c7                	mov    %eax,%edi
  802984:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  80298b:	00 00 00 
  80298e:	ff d0                	callq  *%rax
  802990:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802997:	78 24                	js     8029bd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299d:	8b 00                	mov    (%rax),%eax
  80299f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a3:	48 89 d6             	mov    %rdx,%rsi
  8029a6:	89 c7                	mov    %eax,%edi
  8029a8:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bb:	79 05                	jns    8029c2 <write+0x5d>
		return r;
  8029bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c0:	eb 75                	jmp    802a37 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c6:	8b 40 08             	mov    0x8(%rax),%eax
  8029c9:	83 e0 03             	and    $0x3,%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	75 3a                	jne    802a0a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029d0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029d7:	00 00 00 
  8029da:	48 8b 00             	mov    (%rax),%rax
  8029dd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e6:	89 c6                	mov    %eax,%esi
  8029e8:	48 bf ab 51 80 00 00 	movabs $0x8051ab,%rdi
  8029ef:	00 00 00 
  8029f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f7:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  8029fe:	00 00 00 
  802a01:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a08:	eb 2d                	jmp    802a37 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a12:	48 85 c0             	test   %rax,%rax
  802a15:	75 07                	jne    802a1e <write+0xb9>
		return -E_NOT_SUPP;
  802a17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1c:	eb 19                	jmp    802a37 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a22:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a2a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a32:	48 89 cf             	mov    %rcx,%rdi
  802a35:	ff d0                	callq  *%rax
}
  802a37:	c9                   	leaveq 
  802a38:	c3                   	retq   

0000000000802a39 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a39:	55                   	push   %rbp
  802a3a:	48 89 e5             	mov    %rsp,%rbp
  802a3d:	48 83 ec 18          	sub    $0x18,%rsp
  802a41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a44:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a47:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a4e:	48 89 d6             	mov    %rdx,%rsi
  802a51:	89 c7                	mov    %eax,%edi
  802a53:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802a5a:	00 00 00 
  802a5d:	ff d0                	callq  *%rax
  802a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a66:	79 05                	jns    802a6d <seek+0x34>
		return r;
  802a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6b:	eb 0f                	jmp    802a7c <seek+0x43>
	fd->fd_offset = offset;
  802a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a71:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a74:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7c:	c9                   	leaveq 
  802a7d:	c3                   	retq   

0000000000802a7e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a7e:	55                   	push   %rbp
  802a7f:	48 89 e5             	mov    %rsp,%rbp
  802a82:	48 83 ec 30          	sub    $0x30,%rsp
  802a86:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a89:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a8c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a90:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a93:	48 89 d6             	mov    %rdx,%rsi
  802a96:	89 c7                	mov    %eax,%edi
  802a98:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
  802aa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aab:	78 24                	js     802ad1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab1:	8b 00                	mov    (%rax),%eax
  802ab3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab7:	48 89 d6             	mov    %rdx,%rsi
  802aba:	89 c7                	mov    %eax,%edi
  802abc:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acf:	79 05                	jns    802ad6 <ftruncate+0x58>
		return r;
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	eb 72                	jmp    802b48 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ada:	8b 40 08             	mov    0x8(%rax),%eax
  802add:	83 e0 03             	and    $0x3,%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	75 3a                	jne    802b1e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ae4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802aeb:	00 00 00 
  802aee:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802af1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802af7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802afa:	89 c6                	mov    %eax,%esi
  802afc:	48 bf c8 51 80 00 00 	movabs $0x8051c8,%rdi
  802b03:	00 00 00 
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  802b12:	00 00 00 
  802b15:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b1c:	eb 2a                	jmp    802b48 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b22:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b26:	48 85 c0             	test   %rax,%rax
  802b29:	75 07                	jne    802b32 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b2b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b30:	eb 16                	jmp    802b48 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b36:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b41:	89 ce                	mov    %ecx,%esi
  802b43:	48 89 d7             	mov    %rdx,%rdi
  802b46:	ff d0                	callq  *%rax
}
  802b48:	c9                   	leaveq 
  802b49:	c3                   	retq   

0000000000802b4a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b4a:	55                   	push   %rbp
  802b4b:	48 89 e5             	mov    %rsp,%rbp
  802b4e:	48 83 ec 30          	sub    $0x30,%rsp
  802b52:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b55:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b60:	48 89 d6             	mov    %rdx,%rsi
  802b63:	89 c7                	mov    %eax,%edi
  802b65:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b78:	78 24                	js     802b9e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7e:	8b 00                	mov    (%rax),%eax
  802b80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b84:	48 89 d6             	mov    %rdx,%rsi
  802b87:	89 c7                	mov    %eax,%edi
  802b89:	48 b8 42 25 80 00 00 	movabs $0x802542,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 05                	jns    802ba3 <fstat+0x59>
		return r;
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	eb 5e                	jmp    802c01 <fstat+0xb7>
	if (!dev->dev_stat)
  802ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bab:	48 85 c0             	test   %rax,%rax
  802bae:	75 07                	jne    802bb7 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb5:	eb 4a                	jmp    802c01 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bc9:	00 00 00 
	stat->st_isdir = 0;
  802bcc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bd7:	00 00 00 
	stat->st_dev = dev;
  802bda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bed:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bf1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bf9:	48 89 ce             	mov    %rcx,%rsi
  802bfc:	48 89 d7             	mov    %rdx,%rdi
  802bff:	ff d0                	callq  *%rax
}
  802c01:	c9                   	leaveq 
  802c02:	c3                   	retq   

0000000000802c03 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	48 83 ec 20          	sub    $0x20,%rsp
  802c0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c17:	be 00 00 00 00       	mov    $0x0,%esi
  802c1c:	48 89 c7             	mov    %rax,%rdi
  802c1f:	48 b8 f1 2c 80 00 00 	movabs $0x802cf1,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
  802c2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c32:	79 05                	jns    802c39 <stat+0x36>
		return fd;
  802c34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c37:	eb 2f                	jmp    802c68 <stat+0x65>
	r = fstat(fd, stat);
  802c39:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c40:	48 89 d6             	mov    %rdx,%rsi
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
  802c51:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
	return r;
  802c65:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c68:	c9                   	leaveq 
  802c69:	c3                   	retq   

0000000000802c6a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c6a:	55                   	push   %rbp
  802c6b:	48 89 e5             	mov    %rsp,%rbp
  802c6e:	48 83 ec 10          	sub    $0x10,%rsp
  802c72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c79:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c80:	00 00 00 
  802c83:	8b 00                	mov    (%rax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	75 1d                	jne    802ca6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c89:	bf 01 00 00 00       	mov    $0x1,%edi
  802c8e:	48 b8 72 49 80 00 00 	movabs $0x804972,%rax
  802c95:	00 00 00 
  802c98:	ff d0                	callq  *%rax
  802c9a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ca1:	00 00 00 
  802ca4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ca6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cad:	00 00 00 
  802cb0:	8b 00                	mov    (%rax),%eax
  802cb2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cb5:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cba:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802cc1:	00 00 00 
  802cc4:	89 c7                	mov    %eax,%edi
  802cc6:	48 b8 da 48 80 00 00 	movabs $0x8048da,%rax
  802ccd:	00 00 00 
  802cd0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd6:	ba 00 00 00 00       	mov    $0x0,%edx
  802cdb:	48 89 c6             	mov    %rax,%rsi
  802cde:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce3:	48 b8 19 48 80 00 00 	movabs $0x804819,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
}
  802cef:	c9                   	leaveq 
  802cf0:	c3                   	retq   

0000000000802cf1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cf1:	55                   	push   %rbp
  802cf2:	48 89 e5             	mov    %rsp,%rbp
  802cf5:	48 83 ec 20          	sub    $0x20,%rsp
  802cf9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cfd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d04:	48 89 c7             	mov    %rax,%rdi
  802d07:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
  802d13:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d18:	7e 0a                	jle    802d24 <open+0x33>
		return -E_BAD_PATH;
  802d1a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d1f:	e9 a5 00 00 00       	jmpq   802dc9 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802d24:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d28:	48 89 c7             	mov    %rax,%rdi
  802d2b:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  802d32:	00 00 00 
  802d35:	ff d0                	callq  *%rax
  802d37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3e:	79 08                	jns    802d48 <open+0x57>
		return r;
  802d40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d43:	e9 81 00 00 00       	jmpq   802dc9 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4c:	48 89 c6             	mov    %rax,%rsi
  802d4f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802d56:	00 00 00 
  802d59:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802d65:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d6c:	00 00 00 
  802d6f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d72:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7c:	48 89 c6             	mov    %rax,%rsi
  802d7f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d84:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  802d8b:	00 00 00 
  802d8e:	ff d0                	callq  *%rax
  802d90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d97:	79 1d                	jns    802db6 <open+0xc5>
		fd_close(fd, 0);
  802d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9d:	be 00 00 00 00       	mov    $0x0,%esi
  802da2:	48 89 c7             	mov    %rax,%rdi
  802da5:	48 b8 79 24 80 00 00 	movabs $0x802479,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
		return r;
  802db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db4:	eb 13                	jmp    802dc9 <open+0xd8>
	}

	return fd2num(fd);
  802db6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dba:	48 89 c7             	mov    %rax,%rdi
  802dbd:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  802dc4:	00 00 00 
  802dc7:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802dc9:	c9                   	leaveq 
  802dca:	c3                   	retq   

0000000000802dcb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802dcb:	55                   	push   %rbp
  802dcc:	48 89 e5             	mov    %rsp,%rbp
  802dcf:	48 83 ec 10          	sub    $0x10,%rsp
  802dd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802dd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ddb:	8b 50 0c             	mov    0xc(%rax),%edx
  802dde:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802de5:	00 00 00 
  802de8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802dea:	be 00 00 00 00       	mov    $0x0,%esi
  802def:	bf 06 00 00 00       	mov    $0x6,%edi
  802df4:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	callq  *%rax
}
  802e00:	c9                   	leaveq 
  802e01:	c3                   	retq   

0000000000802e02 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e02:	55                   	push   %rbp
  802e03:	48 89 e5             	mov    %rsp,%rbp
  802e06:	48 83 ec 30          	sub    $0x30,%rsp
  802e0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e12:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1a:	8b 50 0c             	mov    0xc(%rax),%edx
  802e1d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e24:	00 00 00 
  802e27:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e29:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e30:	00 00 00 
  802e33:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e37:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e3b:	be 00 00 00 00       	mov    $0x0,%esi
  802e40:	bf 03 00 00 00       	mov    $0x3,%edi
  802e45:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
  802e51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e58:	79 08                	jns    802e62 <devfile_read+0x60>
		return r;
  802e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5d:	e9 a4 00 00 00       	jmpq   802f06 <devfile_read+0x104>
	assert(r <= n);
  802e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e65:	48 98                	cltq   
  802e67:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e6b:	76 35                	jbe    802ea2 <devfile_read+0xa0>
  802e6d:	48 b9 f5 51 80 00 00 	movabs $0x8051f5,%rcx
  802e74:	00 00 00 
  802e77:	48 ba fc 51 80 00 00 	movabs $0x8051fc,%rdx
  802e7e:	00 00 00 
  802e81:	be 84 00 00 00       	mov    $0x84,%esi
  802e86:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  802e8d:	00 00 00 
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
  802e95:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  802e9c:	00 00 00 
  802e9f:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802ea2:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802ea9:	7e 35                	jle    802ee0 <devfile_read+0xde>
  802eab:	48 b9 1c 52 80 00 00 	movabs $0x80521c,%rcx
  802eb2:	00 00 00 
  802eb5:	48 ba fc 51 80 00 00 	movabs $0x8051fc,%rdx
  802ebc:	00 00 00 
  802ebf:	be 85 00 00 00       	mov    $0x85,%esi
  802ec4:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  802ecb:	00 00 00 
  802ece:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed3:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  802eda:	00 00 00 
  802edd:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee3:	48 63 d0             	movslq %eax,%rdx
  802ee6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eea:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802ef1:	00 00 00 
  802ef4:	48 89 c7             	mov    %rax,%rdi
  802ef7:	48 b8 81 14 80 00 00 	movabs $0x801481,%rax
  802efe:	00 00 00 
  802f01:	ff d0                	callq  *%rax
	return r;
  802f03:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802f06:	c9                   	leaveq 
  802f07:	c3                   	retq   

0000000000802f08 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f08:	55                   	push   %rbp
  802f09:	48 89 e5             	mov    %rsp,%rbp
  802f0c:	48 83 ec 30          	sub    $0x30,%rsp
  802f10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f20:	8b 50 0c             	mov    0xc(%rax),%edx
  802f23:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f2a:	00 00 00 
  802f2d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f2f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f36:	00 00 00 
  802f39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f3d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802f41:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f48:	00 
  802f49:	76 35                	jbe    802f80 <devfile_write+0x78>
  802f4b:	48 b9 28 52 80 00 00 	movabs $0x805228,%rcx
  802f52:	00 00 00 
  802f55:	48 ba fc 51 80 00 00 	movabs $0x8051fc,%rdx
  802f5c:	00 00 00 
  802f5f:	be 9e 00 00 00       	mov    $0x9e,%esi
  802f64:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  802f6b:	00 00 00 
  802f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f73:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  802f7a:	00 00 00 
  802f7d:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802f80:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f88:	48 89 c6             	mov    %rax,%rsi
  802f8b:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802f92:	00 00 00 
  802f95:	48 b8 98 15 80 00 00 	movabs $0x801598,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802fa1:	be 00 00 00 00       	mov    $0x0,%esi
  802fa6:	bf 04 00 00 00       	mov    $0x4,%edi
  802fab:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
  802fb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbe:	79 05                	jns    802fc5 <devfile_write+0xbd>
		return r;
  802fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc3:	eb 43                	jmp    803008 <devfile_write+0x100>
	assert(r <= n);
  802fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc8:	48 98                	cltq   
  802fca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fce:	76 35                	jbe    803005 <devfile_write+0xfd>
  802fd0:	48 b9 f5 51 80 00 00 	movabs $0x8051f5,%rcx
  802fd7:	00 00 00 
  802fda:	48 ba fc 51 80 00 00 	movabs $0x8051fc,%rdx
  802fe1:	00 00 00 
  802fe4:	be a2 00 00 00       	mov    $0xa2,%esi
  802fe9:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  802ff0:	00 00 00 
  802ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff8:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  802fff:	00 00 00 
  803002:	41 ff d0             	callq  *%r8
	return r;
  803005:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  803008:	c9                   	leaveq 
  803009:	c3                   	retq   

000000000080300a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80300a:	55                   	push   %rbp
  80300b:	48 89 e5             	mov    %rsp,%rbp
  80300e:	48 83 ec 20          	sub    $0x20,%rsp
  803012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803016:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80301a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301e:	8b 50 0c             	mov    0xc(%rax),%edx
  803021:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803028:	00 00 00 
  80302b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80302d:	be 00 00 00 00       	mov    $0x0,%esi
  803032:	bf 05 00 00 00       	mov    $0x5,%edi
  803037:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
  803043:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803046:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304a:	79 05                	jns    803051 <devfile_stat+0x47>
		return r;
  80304c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304f:	eb 56                	jmp    8030a7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803051:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803055:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80305c:	00 00 00 
  80305f:	48 89 c7             	mov    %rax,%rdi
  803062:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80306e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803075:	00 00 00 
  803078:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80307e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803082:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803088:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80308f:	00 00 00 
  803092:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803098:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80309c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030a7:	c9                   	leaveq 
  8030a8:	c3                   	retq   

00000000008030a9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030a9:	55                   	push   %rbp
  8030aa:	48 89 e5             	mov    %rsp,%rbp
  8030ad:	48 83 ec 10          	sub    $0x10,%rsp
  8030b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030b5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8030bf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030c6:	00 00 00 
  8030c9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030cb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030d2:	00 00 00 
  8030d5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030d8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030db:	be 00 00 00 00       	mov    $0x0,%esi
  8030e0:	bf 02 00 00 00       	mov    $0x2,%edi
  8030e5:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  8030ec:	00 00 00 
  8030ef:	ff d0                	callq  *%rax
}
  8030f1:	c9                   	leaveq 
  8030f2:	c3                   	retq   

00000000008030f3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8030f3:	55                   	push   %rbp
  8030f4:	48 89 e5             	mov    %rsp,%rbp
  8030f7:	48 83 ec 10          	sub    $0x10,%rsp
  8030fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803103:	48 89 c7             	mov    %rax,%rdi
  803106:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
  803112:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803117:	7e 07                	jle    803120 <remove+0x2d>
		return -E_BAD_PATH;
  803119:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80311e:	eb 33                	jmp    803153 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803124:	48 89 c6             	mov    %rax,%rsi
  803127:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80312e:	00 00 00 
  803131:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80313d:	be 00 00 00 00       	mov    $0x0,%esi
  803142:	bf 07 00 00 00       	mov    $0x7,%edi
  803147:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
}
  803153:	c9                   	leaveq 
  803154:	c3                   	retq   

0000000000803155 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803155:	55                   	push   %rbp
  803156:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803159:	be 00 00 00 00       	mov    $0x0,%esi
  80315e:	bf 08 00 00 00       	mov    $0x8,%edi
  803163:	48 b8 6a 2c 80 00 00 	movabs $0x802c6a,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
}
  80316f:	5d                   	pop    %rbp
  803170:	c3                   	retq   

0000000000803171 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803171:	55                   	push   %rbp
  803172:	48 89 e5             	mov    %rsp,%rbp
  803175:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80317c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803183:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80318a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803191:	be 00 00 00 00       	mov    $0x0,%esi
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 f1 2c 80 00 00 	movabs $0x802cf1,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
  8031a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8031a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ac:	79 28                	jns    8031d6 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8031ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b1:	89 c6                	mov    %eax,%esi
  8031b3:	48 bf 55 52 80 00 00 	movabs $0x805255,%rdi
  8031ba:	00 00 00 
  8031bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c2:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  8031c9:	00 00 00 
  8031cc:	ff d2                	callq  *%rdx
		return fd_src;
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	e9 74 01 00 00       	jmpq   80334a <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8031d6:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8031dd:	be 01 01 00 00       	mov    $0x101,%esi
  8031e2:	48 89 c7             	mov    %rax,%rdi
  8031e5:	48 b8 f1 2c 80 00 00 	movabs $0x802cf1,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031f8:	79 39                	jns    803233 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8031fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031fd:	89 c6                	mov    %eax,%esi
  8031ff:	48 bf 6b 52 80 00 00 	movabs $0x80526b,%rdi
  803206:	00 00 00 
  803209:	b8 00 00 00 00       	mov    $0x0,%eax
  80320e:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  803215:	00 00 00 
  803218:	ff d2                	callq  *%rdx
		close(fd_src);
  80321a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321d:	89 c7                	mov    %eax,%edi
  80321f:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
		return fd_dest;
  80322b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80322e:	e9 17 01 00 00       	jmpq   80334a <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803233:	eb 74                	jmp    8032a9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803235:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803238:	48 63 d0             	movslq %eax,%rdx
  80323b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803242:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803245:	48 89 ce             	mov    %rcx,%rsi
  803248:	89 c7                	mov    %eax,%edi
  80324a:	48 b8 65 29 80 00 00 	movabs $0x802965,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
  803256:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803259:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80325d:	79 4a                	jns    8032a9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80325f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803262:	89 c6                	mov    %eax,%esi
  803264:	48 bf 85 52 80 00 00 	movabs $0x805285,%rdi
  80326b:	00 00 00 
  80326e:	b8 00 00 00 00       	mov    $0x0,%eax
  803273:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  80327a:	00 00 00 
  80327d:	ff d2                	callq  *%rdx
			close(fd_src);
  80327f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803282:	89 c7                	mov    %eax,%edi
  803284:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
			close(fd_dest);
  803290:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803293:	89 c7                	mov    %eax,%edi
  803295:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
			return write_size;
  8032a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032a4:	e9 a1 00 00 00       	jmpq   80334a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032a9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b3:	ba 00 02 00 00       	mov    $0x200,%edx
  8032b8:	48 89 ce             	mov    %rcx,%rsi
  8032bb:	89 c7                	mov    %eax,%edi
  8032bd:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
  8032c9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032d0:	0f 8f 5f ff ff ff    	jg     803235 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8032d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032da:	79 47                	jns    803323 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8032dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032df:	89 c6                	mov    %eax,%esi
  8032e1:	48 bf 98 52 80 00 00 	movabs $0x805298,%rdi
  8032e8:	00 00 00 
  8032eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f0:	48 ba 95 05 80 00 00 	movabs $0x800595,%rdx
  8032f7:	00 00 00 
  8032fa:	ff d2                	callq  *%rdx
		close(fd_src);
  8032fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ff:	89 c7                	mov    %eax,%edi
  803301:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
		close(fd_dest);
  80330d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803310:	89 c7                	mov    %eax,%edi
  803312:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
		return read_size;
  80331e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803321:	eb 27                	jmp    80334a <copy+0x1d9>
	}
	close(fd_src);
  803323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803326:	89 c7                	mov    %eax,%edi
  803328:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
	close(fd_dest);
  803334:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803337:	89 c7                	mov    %eax,%edi
  803339:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  803340:	00 00 00 
  803343:	ff d0                	callq  *%rax
	return 0;
  803345:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80334a:	c9                   	leaveq 
  80334b:	c3                   	retq   

000000000080334c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80334c:	55                   	push   %rbp
  80334d:	48 89 e5             	mov    %rsp,%rbp
  803350:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803357:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80335e:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803365:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80336c:	be 00 00 00 00       	mov    $0x0,%esi
  803371:	48 89 c7             	mov    %rax,%rdi
  803374:	48 b8 f1 2c 80 00 00 	movabs $0x802cf1,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
  803380:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803383:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803387:	79 08                	jns    803391 <spawn+0x45>
		return r;
  803389:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80338c:	e9 14 03 00 00       	jmpq   8036a5 <spawn+0x359>
	fd = r;
  803391:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803394:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803397:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80339e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8033a2:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8033a9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033ac:	ba 00 02 00 00       	mov    $0x200,%edx
  8033b1:	48 89 ce             	mov    %rcx,%rsi
  8033b4:	89 c7                	mov    %eax,%edi
  8033b6:	48 b8 f0 28 80 00 00 	movabs $0x8028f0,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8033c7:	75 0d                	jne    8033d6 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8033c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033cd:	8b 00                	mov    (%rax),%eax
  8033cf:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8033d4:	74 43                	je     803419 <spawn+0xcd>
		close(fd);
  8033d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033d9:	89 c7                	mov    %eax,%edi
  8033db:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8033e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033eb:	8b 00                	mov    (%rax),%eax
  8033ed:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8033f2:	89 c6                	mov    %eax,%esi
  8033f4:	48 bf b0 52 80 00 00 	movabs $0x8052b0,%rdi
  8033fb:	00 00 00 
  8033fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803403:	48 b9 95 05 80 00 00 	movabs $0x800595,%rcx
  80340a:	00 00 00 
  80340d:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80340f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803414:	e9 8c 02 00 00       	jmpq   8036a5 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803419:	b8 07 00 00 00       	mov    $0x7,%eax
  80341e:	cd 30                	int    $0x30
  803420:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803423:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803426:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803429:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80342d:	79 08                	jns    803437 <spawn+0xeb>
		return r;
  80342f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803432:	e9 6e 02 00 00       	jmpq   8036a5 <spawn+0x359>
	child = r;
  803437:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80343a:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80343d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803440:	25 ff 03 00 00       	and    $0x3ff,%eax
  803445:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80344c:	00 00 00 
  80344f:	48 63 d0             	movslq %eax,%rdx
  803452:	48 89 d0             	mov    %rdx,%rax
  803455:	48 c1 e0 03          	shl    $0x3,%rax
  803459:	48 01 d0             	add    %rdx,%rax
  80345c:	48 c1 e0 05          	shl    $0x5,%rax
  803460:	48 01 c8             	add    %rcx,%rax
  803463:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80346a:	48 89 c6             	mov    %rax,%rsi
  80346d:	b8 18 00 00 00       	mov    $0x18,%eax
  803472:	48 89 d7             	mov    %rdx,%rdi
  803475:	48 89 c1             	mov    %rax,%rcx
  803478:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  80347b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803483:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  80348a:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803491:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803498:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80349f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034a2:	48 89 ce             	mov    %rcx,%rsi
  8034a5:	89 c7                	mov    %eax,%edi
  8034a7:	48 b8 0f 39 80 00 00 	movabs $0x80390f,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
  8034b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034ba:	79 08                	jns    8034c4 <spawn+0x178>
		return r;
  8034bc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034bf:	e9 e1 01 00 00       	jmpq   8036a5 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8034c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8034cc:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8034d3:	48 01 d0             	add    %rdx,%rax
  8034d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8034da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034e1:	e9 a3 00 00 00       	jmpq   803589 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8034e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ea:	8b 00                	mov    (%rax),%eax
  8034ec:	83 f8 01             	cmp    $0x1,%eax
  8034ef:	74 05                	je     8034f6 <spawn+0x1aa>
			continue;
  8034f1:	e9 8a 00 00 00       	jmpq   803580 <spawn+0x234>
		perm = PTE_P | PTE_U;
  8034f6:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8034fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803501:	8b 40 04             	mov    0x4(%rax),%eax
  803504:	83 e0 02             	and    $0x2,%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 04                	je     80350f <spawn+0x1c3>
			perm |= PTE_W;
  80350b:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80350f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803513:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803517:	41 89 c1             	mov    %eax,%r9d
  80351a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351e:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803526:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80352a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352e:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803532:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803535:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803538:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80353b:	89 3c 24             	mov    %edi,(%rsp)
  80353e:	89 c7                	mov    %eax,%edi
  803540:	48 b8 b8 3b 80 00 00 	movabs $0x803bb8,%rax
  803547:	00 00 00 
  80354a:	ff d0                	callq  *%rax
  80354c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80354f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803553:	79 2b                	jns    803580 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803555:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803556:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803559:	89 c7                	mov    %eax,%edi
  80355b:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803562:	00 00 00 
  803565:	ff d0                	callq  *%rax
	close(fd);
  803567:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80356a:	89 c7                	mov    %eax,%edi
  80356c:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
	return r;
  803578:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80357b:	e9 25 01 00 00       	jmpq   8036a5 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803580:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803584:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80358d:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803591:	0f b7 c0             	movzwl %ax,%eax
  803594:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803597:	0f 8f 49 ff ff ff    	jg     8034e6 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80359d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8035a0:	89 c7                	mov    %eax,%edi
  8035a2:	48 b8 f9 25 80 00 00 	movabs $0x8025f9,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
	fd = -1;
  8035ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8035b5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8035b8:	89 c7                	mov    %eax,%edi
  8035ba:	48 b8 a4 3d 80 00 00 	movabs $0x803da4,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
  8035c6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035cd:	79 30                	jns    8035ff <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8035cf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035d2:	89 c1                	mov    %eax,%ecx
  8035d4:	48 ba ca 52 80 00 00 	movabs $0x8052ca,%rdx
  8035db:	00 00 00 
  8035de:	be 82 00 00 00       	mov    $0x82,%esi
  8035e3:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  8035ea:	00 00 00 
  8035ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f2:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  8035f9:	00 00 00 
  8035fc:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8035ff:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803606:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803609:	48 89 d6             	mov    %rdx,%rsi
  80360c:	89 c7                	mov    %eax,%edi
  80360e:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  803615:	00 00 00 
  803618:	ff d0                	callq  *%rax
  80361a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80361d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803621:	79 30                	jns    803653 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803623:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803626:	89 c1                	mov    %eax,%ecx
  803628:	48 ba ec 52 80 00 00 	movabs $0x8052ec,%rdx
  80362f:	00 00 00 
  803632:	be 85 00 00 00       	mov    $0x85,%esi
  803637:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  80363e:	00 00 00 
  803641:	b8 00 00 00 00       	mov    $0x0,%eax
  803646:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  80364d:	00 00 00 
  803650:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803653:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803656:	be 02 00 00 00       	mov    $0x2,%esi
  80365b:	89 c7                	mov    %eax,%edi
  80365d:	48 b8 81 1b 80 00 00 	movabs $0x801b81,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
  803669:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80366c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803670:	79 30                	jns    8036a2 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803672:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803675:	89 c1                	mov    %eax,%ecx
  803677:	48 ba 06 53 80 00 00 	movabs $0x805306,%rdx
  80367e:	00 00 00 
  803681:	be 88 00 00 00       	mov    $0x88,%esi
  803686:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  80368d:	00 00 00 
  803690:	b8 00 00 00 00       	mov    $0x0,%eax
  803695:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  80369c:	00 00 00 
  80369f:	41 ff d0             	callq  *%r8

	return child;
  8036a2:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8036a5:	c9                   	leaveq 
  8036a6:	c3                   	retq   

00000000008036a7 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8036a7:	55                   	push   %rbp
  8036a8:	48 89 e5             	mov    %rsp,%rbp
  8036ab:	41 55                	push   %r13
  8036ad:	41 54                	push   %r12
  8036af:	53                   	push   %rbx
  8036b0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8036b7:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8036be:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8036c5:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8036cc:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8036d3:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8036da:	84 c0                	test   %al,%al
  8036dc:	74 26                	je     803704 <spawnl+0x5d>
  8036de:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8036e5:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8036ec:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8036f0:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8036f4:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8036f8:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8036fc:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803700:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803704:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80370b:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803712:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803715:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80371c:	00 00 00 
  80371f:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803726:	00 00 00 
  803729:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80372d:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803734:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80373b:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803742:	eb 07                	jmp    80374b <spawnl+0xa4>
		argc++;
  803744:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80374b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803751:	83 f8 30             	cmp    $0x30,%eax
  803754:	73 23                	jae    803779 <spawnl+0xd2>
  803756:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80375d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803763:	89 c0                	mov    %eax,%eax
  803765:	48 01 d0             	add    %rdx,%rax
  803768:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80376e:	83 c2 08             	add    $0x8,%edx
  803771:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803777:	eb 15                	jmp    80378e <spawnl+0xe7>
  803779:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803780:	48 89 d0             	mov    %rdx,%rax
  803783:	48 83 c2 08          	add    $0x8,%rdx
  803787:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80378e:	48 8b 00             	mov    (%rax),%rax
  803791:	48 85 c0             	test   %rax,%rax
  803794:	75 ae                	jne    803744 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803796:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80379c:	83 c0 02             	add    $0x2,%eax
  80379f:	48 89 e2             	mov    %rsp,%rdx
  8037a2:	48 89 d3             	mov    %rdx,%rbx
  8037a5:	48 63 d0             	movslq %eax,%rdx
  8037a8:	48 83 ea 01          	sub    $0x1,%rdx
  8037ac:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8037b3:	48 63 d0             	movslq %eax,%rdx
  8037b6:	49 89 d4             	mov    %rdx,%r12
  8037b9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8037bf:	48 63 d0             	movslq %eax,%rdx
  8037c2:	49 89 d2             	mov    %rdx,%r10
  8037c5:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8037cb:	48 98                	cltq   
  8037cd:	48 c1 e0 03          	shl    $0x3,%rax
  8037d1:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8037d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8037da:	48 83 e8 01          	sub    $0x1,%rax
  8037de:	48 01 d0             	add    %rdx,%rax
  8037e1:	bf 10 00 00 00       	mov    $0x10,%edi
  8037e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8037eb:	48 f7 f7             	div    %rdi
  8037ee:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8037f2:	48 29 c4             	sub    %rax,%rsp
  8037f5:	48 89 e0             	mov    %rsp,%rax
  8037f8:	48 83 c0 07          	add    $0x7,%rax
  8037fc:	48 c1 e8 03          	shr    $0x3,%rax
  803800:	48 c1 e0 03          	shl    $0x3,%rax
  803804:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80380b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803812:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803819:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80381c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803822:	8d 50 01             	lea    0x1(%rax),%edx
  803825:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80382c:	48 63 d2             	movslq %edx,%rdx
  80382f:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803836:	00 

	va_start(vl, arg0);
  803837:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80383e:	00 00 00 
  803841:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803848:	00 00 00 
  80384b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80384f:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803856:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80385d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803864:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80386b:	00 00 00 
  80386e:	eb 63                	jmp    8038d3 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803870:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803876:	8d 70 01             	lea    0x1(%rax),%esi
  803879:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80387f:	83 f8 30             	cmp    $0x30,%eax
  803882:	73 23                	jae    8038a7 <spawnl+0x200>
  803884:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80388b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803891:	89 c0                	mov    %eax,%eax
  803893:	48 01 d0             	add    %rdx,%rax
  803896:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80389c:	83 c2 08             	add    $0x8,%edx
  80389f:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8038a5:	eb 15                	jmp    8038bc <spawnl+0x215>
  8038a7:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8038ae:	48 89 d0             	mov    %rdx,%rax
  8038b1:	48 83 c2 08          	add    $0x8,%rdx
  8038b5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8038bc:	48 8b 08             	mov    (%rax),%rcx
  8038bf:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8038c6:	89 f2                	mov    %esi,%edx
  8038c8:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8038cc:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8038d3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8038d9:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8038df:	77 8f                	ja     803870 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8038e1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8038e8:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8038ef:	48 89 d6             	mov    %rdx,%rsi
  8038f2:	48 89 c7             	mov    %rax,%rdi
  8038f5:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
  803901:	48 89 dc             	mov    %rbx,%rsp
}
  803904:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803908:	5b                   	pop    %rbx
  803909:	41 5c                	pop    %r12
  80390b:	41 5d                	pop    %r13
  80390d:	5d                   	pop    %rbp
  80390e:	c3                   	retq   

000000000080390f <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  80390f:	55                   	push   %rbp
  803910:	48 89 e5             	mov    %rsp,%rbp
  803913:	48 83 ec 50          	sub    $0x50,%rsp
  803917:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80391a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80391e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803922:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803929:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80392a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803931:	eb 33                	jmp    803966 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803933:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803936:	48 98                	cltq   
  803938:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80393f:	00 
  803940:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803944:	48 01 d0             	add    %rdx,%rax
  803947:	48 8b 00             	mov    (%rax),%rax
  80394a:	48 89 c7             	mov    %rax,%rdi
  80394d:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  803954:	00 00 00 
  803957:	ff d0                	callq  *%rax
  803959:	83 c0 01             	add    $0x1,%eax
  80395c:	48 98                	cltq   
  80395e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803962:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803966:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803969:	48 98                	cltq   
  80396b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803972:	00 
  803973:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803977:	48 01 d0             	add    %rdx,%rax
  80397a:	48 8b 00             	mov    (%rax),%rax
  80397d:	48 85 c0             	test   %rax,%rax
  803980:	75 b1                	jne    803933 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803982:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803986:	48 f7 d8             	neg    %rax
  803989:	48 05 00 10 40 00    	add    $0x401000,%rax
  80398f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803993:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803997:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80399b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399f:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8039a3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039a6:	83 c2 01             	add    $0x1,%edx
  8039a9:	c1 e2 03             	shl    $0x3,%edx
  8039ac:	48 63 d2             	movslq %edx,%rdx
  8039af:	48 f7 da             	neg    %rdx
  8039b2:	48 01 d0             	add    %rdx,%rax
  8039b5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8039b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039bd:	48 83 e8 10          	sub    $0x10,%rax
  8039c1:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8039c7:	77 0a                	ja     8039d3 <init_stack+0xc4>
		return -E_NO_MEM;
  8039c9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8039ce:	e9 e3 01 00 00       	jmpq   803bb6 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8039d3:	ba 07 00 00 00       	mov    $0x7,%edx
  8039d8:	be 00 00 40 00       	mov    $0x400000,%esi
  8039dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e2:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  8039e9:	00 00 00 
  8039ec:	ff d0                	callq  *%rax
  8039ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f5:	79 08                	jns    8039ff <init_stack+0xf0>
		return r;
  8039f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039fa:	e9 b7 01 00 00       	jmpq   803bb6 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8039ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803a06:	e9 8a 00 00 00       	jmpq   803a95 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803a0b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a0e:	48 98                	cltq   
  803a10:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a17:	00 
  803a18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a1c:	48 01 c2             	add    %rax,%rdx
  803a1f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a28:	48 01 c8             	add    %rcx,%rax
  803a2b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803a31:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803a34:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a37:	48 98                	cltq   
  803a39:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a40:	00 
  803a41:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a45:	48 01 d0             	add    %rdx,%rax
  803a48:	48 8b 10             	mov    (%rax),%rdx
  803a4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a4f:	48 89 d6             	mov    %rdx,%rsi
  803a52:	48 89 c7             	mov    %rax,%rdi
  803a55:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  803a5c:	00 00 00 
  803a5f:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803a61:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a64:	48 98                	cltq   
  803a66:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a6d:	00 
  803a6e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a72:	48 01 d0             	add    %rdx,%rax
  803a75:	48 8b 00             	mov    (%rax),%rax
  803a78:	48 89 c7             	mov    %rax,%rdi
  803a7b:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  803a82:	00 00 00 
  803a85:	ff d0                	callq  *%rax
  803a87:	48 98                	cltq   
  803a89:	48 83 c0 01          	add    $0x1,%rax
  803a8d:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803a91:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803a95:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a98:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803a9b:	0f 8c 6a ff ff ff    	jl     803a0b <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803aa1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803aa4:	48 98                	cltq   
  803aa6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803aad:	00 
  803aae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab2:	48 01 d0             	add    %rdx,%rax
  803ab5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803abc:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803ac3:	00 
  803ac4:	74 35                	je     803afb <init_stack+0x1ec>
  803ac6:	48 b9 20 53 80 00 00 	movabs $0x805320,%rcx
  803acd:	00 00 00 
  803ad0:	48 ba 46 53 80 00 00 	movabs $0x805346,%rdx
  803ad7:	00 00 00 
  803ada:	be f1 00 00 00       	mov    $0xf1,%esi
  803adf:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  803ae6:	00 00 00 
  803ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  803aee:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  803af5:	00 00 00 
  803af8:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803afb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aff:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803b03:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b0c:	48 01 c8             	add    %rcx,%rax
  803b0f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803b15:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803b18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1c:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803b20:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b23:	48 98                	cltq   
  803b25:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  803b28:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803b2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b31:	48 01 d0             	add    %rdx,%rax
  803b34:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803b3a:	48 89 c2             	mov    %rax,%rdx
  803b3d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803b41:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803b44:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b47:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803b4d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b52:	89 c2                	mov    %eax,%edx
  803b54:	be 00 00 40 00       	mov    $0x400000,%esi
  803b59:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5e:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  803b65:	00 00 00 
  803b68:	ff d0                	callq  *%rax
  803b6a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b71:	79 02                	jns    803b75 <init_stack+0x266>
		goto error;
  803b73:	eb 28                	jmp    803b9d <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803b75:	be 00 00 40 00       	mov    $0x400000,%esi
  803b7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7f:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  803b86:	00 00 00 
  803b89:	ff d0                	callq  *%rax
  803b8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b92:	79 02                	jns    803b96 <init_stack+0x287>
		goto error;
  803b94:	eb 07                	jmp    803b9d <init_stack+0x28e>

	return 0;
  803b96:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9b:	eb 19                	jmp    803bb6 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803b9d:	be 00 00 40 00       	mov    $0x400000,%esi
  803ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba7:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
	return r;
  803bb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bb6:	c9                   	leaveq 
  803bb7:	c3                   	retq   

0000000000803bb8 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803bb8:	55                   	push   %rbp
  803bb9:	48 89 e5             	mov    %rsp,%rbp
  803bbc:	48 83 ec 50          	sub    $0x50,%rsp
  803bc0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803bc3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bc7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803bcb:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803bce:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803bd2:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803bd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bda:	25 ff 0f 00 00       	and    $0xfff,%eax
  803bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be6:	74 21                	je     803c09 <map_segment+0x51>
		va -= i;
  803be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803beb:	48 98                	cltq   
  803bed:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803bf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf4:	48 98                	cltq   
  803bf6:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803bfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfd:	48 98                	cltq   
  803bff:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c06:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c10:	e9 79 01 00 00       	jmpq   803d8e <map_segment+0x1d6>
		if (i >= filesz) {
  803c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c18:	48 98                	cltq   
  803c1a:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803c1e:	72 3c                	jb     803c5c <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c23:	48 63 d0             	movslq %eax,%rdx
  803c26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c2a:	48 01 d0             	add    %rdx,%rax
  803c2d:	48 89 c1             	mov    %rax,%rcx
  803c30:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c33:	8b 55 10             	mov    0x10(%rbp),%edx
  803c36:	48 89 ce             	mov    %rcx,%rsi
  803c39:	89 c7                	mov    %eax,%edi
  803c3b:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
  803c47:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c4a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c4e:	0f 89 33 01 00 00    	jns    803d87 <map_segment+0x1cf>
				return r;
  803c54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c57:	e9 46 01 00 00       	jmpq   803da2 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803c5c:	ba 07 00 00 00       	mov    $0x7,%edx
  803c61:	be 00 00 40 00       	mov    $0x400000,%esi
  803c66:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6b:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c7a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c7e:	79 08                	jns    803c88 <map_segment+0xd0>
				return r;
  803c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c83:	e9 1a 01 00 00       	jmpq   803da2 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803c8e:	01 c2                	add    %eax,%edx
  803c90:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803c93:	89 d6                	mov    %edx,%esi
  803c95:	89 c7                	mov    %eax,%edi
  803c97:	48 b8 39 2a 80 00 00 	movabs $0x802a39,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
  803ca3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ca6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803caa:	79 08                	jns    803cb4 <map_segment+0xfc>
				return r;
  803cac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803caf:	e9 ee 00 00 00       	jmpq   803da2 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803cb4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbe:	48 98                	cltq   
  803cc0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803cc4:	48 29 c2             	sub    %rax,%rdx
  803cc7:	48 89 d0             	mov    %rdx,%rax
  803cca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803cce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803cd1:	48 63 d0             	movslq %eax,%rdx
  803cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd8:	48 39 c2             	cmp    %rax,%rdx
  803cdb:	48 0f 47 d0          	cmova  %rax,%rdx
  803cdf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803ce2:	be 00 00 40 00       	mov    $0x400000,%esi
  803ce7:	89 c7                	mov    %eax,%edi
  803ce9:	48 b8 f0 28 80 00 00 	movabs $0x8028f0,%rax
  803cf0:	00 00 00 
  803cf3:	ff d0                	callq  *%rax
  803cf5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803cf8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803cfc:	79 08                	jns    803d06 <map_segment+0x14e>
				return r;
  803cfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d01:	e9 9c 00 00 00       	jmpq   803da2 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d09:	48 63 d0             	movslq %eax,%rdx
  803d0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d10:	48 01 d0             	add    %rdx,%rax
  803d13:	48 89 c2             	mov    %rax,%rdx
  803d16:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d19:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803d1d:	48 89 d1             	mov    %rdx,%rcx
  803d20:	89 c2                	mov    %eax,%edx
  803d22:	be 00 00 40 00       	mov    $0x400000,%esi
  803d27:	bf 00 00 00 00       	mov    $0x0,%edi
  803d2c:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  803d33:	00 00 00 
  803d36:	ff d0                	callq  *%rax
  803d38:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d3f:	79 30                	jns    803d71 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803d41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d44:	89 c1                	mov    %eax,%ecx
  803d46:	48 ba 5b 53 80 00 00 	movabs $0x80535b,%rdx
  803d4d:	00 00 00 
  803d50:	be 24 01 00 00       	mov    $0x124,%esi
  803d55:	48 bf e0 52 80 00 00 	movabs $0x8052e0,%rdi
  803d5c:	00 00 00 
  803d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d64:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  803d6b:	00 00 00 
  803d6e:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803d71:	be 00 00 40 00       	mov    $0x400000,%esi
  803d76:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7b:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803d87:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d91:	48 98                	cltq   
  803d93:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d97:	0f 82 78 fe ff ff    	jb     803c15 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803da2:	c9                   	leaveq 
  803da3:	c3                   	retq   

0000000000803da4 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803da4:	55                   	push   %rbp
  803da5:	48 89 e5             	mov    %rsp,%rbp
  803da8:	48 83 ec 04          	sub    $0x4,%rsp
  803dac:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  803daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803db4:	c9                   	leaveq 
  803db5:	c3                   	retq   

0000000000803db6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803db6:	55                   	push   %rbp
  803db7:	48 89 e5             	mov    %rsp,%rbp
  803dba:	53                   	push   %rbx
  803dbb:	48 83 ec 38          	sub    $0x38,%rsp
  803dbf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803dc3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803dc7:	48 89 c7             	mov    %rax,%rdi
  803dca:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  803dd1:	00 00 00 
  803dd4:	ff d0                	callq  *%rax
  803dd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ddd:	0f 88 bf 01 00 00    	js     803fa2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803de3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de7:	ba 07 04 00 00       	mov    $0x407,%edx
  803dec:	48 89 c6             	mov    %rax,%rsi
  803def:	bf 00 00 00 00       	mov    $0x0,%edi
  803df4:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  803dfb:	00 00 00 
  803dfe:	ff d0                	callq  *%rax
  803e00:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e07:	0f 88 95 01 00 00    	js     803fa2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e0d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e11:	48 89 c7             	mov    %rax,%rdi
  803e14:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  803e1b:	00 00 00 
  803e1e:	ff d0                	callq  *%rax
  803e20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e27:	0f 88 5d 01 00 00    	js     803f8a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e31:	ba 07 04 00 00       	mov    $0x407,%edx
  803e36:	48 89 c6             	mov    %rax,%rsi
  803e39:	bf 00 00 00 00       	mov    $0x0,%edi
  803e3e:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  803e45:	00 00 00 
  803e48:	ff d0                	callq  *%rax
  803e4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e51:	0f 88 33 01 00 00    	js     803f8a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5b:	48 89 c7             	mov    %rax,%rdi
  803e5e:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  803e65:	00 00 00 
  803e68:	ff d0                	callq  *%rax
  803e6a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e72:	ba 07 04 00 00       	mov    $0x407,%edx
  803e77:	48 89 c6             	mov    %rax,%rsi
  803e7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e7f:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
  803e8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e92:	79 05                	jns    803e99 <pipe+0xe3>
		goto err2;
  803e94:	e9 d9 00 00 00       	jmpq   803f72 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9d:	48 89 c7             	mov    %rax,%rdi
  803ea0:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	48 89 c2             	mov    %rax,%rdx
  803eaf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb3:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803eb9:	48 89 d1             	mov    %rdx,%rcx
  803ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  803ec1:	48 89 c6             	mov    %rax,%rsi
  803ec4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec9:	48 b8 dc 1a 80 00 00 	movabs $0x801adc,%rax
  803ed0:	00 00 00 
  803ed3:	ff d0                	callq  *%rax
  803ed5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ed8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803edc:	79 1b                	jns    803ef9 <pipe+0x143>
		goto err3;
  803ede:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803edf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ee3:	48 89 c6             	mov    %rax,%rsi
  803ee6:	bf 00 00 00 00       	mov    $0x0,%edi
  803eeb:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  803ef2:	00 00 00 
  803ef5:	ff d0                	callq  *%rax
  803ef7:	eb 79                	jmp    803f72 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ef9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803efd:	48 ba 80 70 80 00 00 	movabs $0x807080,%rdx
  803f04:	00 00 00 
  803f07:	8b 12                	mov    (%rdx),%edx
  803f09:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f1a:	48 ba 80 70 80 00 00 	movabs $0x807080,%rdx
  803f21:	00 00 00 
  803f24:	8b 12                	mov    (%rdx),%edx
  803f26:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f2c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f37:	48 89 c7             	mov    %rax,%rdi
  803f3a:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	89 c2                	mov    %eax,%edx
  803f48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f4c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f52:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f5a:	48 89 c7             	mov    %rax,%rdi
  803f5d:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  803f64:	00 00 00 
  803f67:	ff d0                	callq  *%rax
  803f69:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f70:	eb 33                	jmp    803fa5 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f76:	48 89 c6             	mov    %rax,%rsi
  803f79:	bf 00 00 00 00       	mov    $0x0,%edi
  803f7e:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  803f85:	00 00 00 
  803f88:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8e:	48 89 c6             	mov    %rax,%rsi
  803f91:	bf 00 00 00 00       	mov    $0x0,%edi
  803f96:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  803f9d:	00 00 00 
  803fa0:	ff d0                	callq  *%rax
err:
	return r;
  803fa2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803fa5:	48 83 c4 38          	add    $0x38,%rsp
  803fa9:	5b                   	pop    %rbx
  803faa:	5d                   	pop    %rbp
  803fab:	c3                   	retq   

0000000000803fac <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fac:	55                   	push   %rbp
  803fad:	48 89 e5             	mov    %rsp,%rbp
  803fb0:	53                   	push   %rbx
  803fb1:	48 83 ec 28          	sub    $0x28,%rsp
  803fb5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fb9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803fbd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fc4:	00 00 00 
  803fc7:	48 8b 00             	mov    (%rax),%rax
  803fca:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803fd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fd7:	48 89 c7             	mov    %rax,%rdi
  803fda:	48 b8 f4 49 80 00 00 	movabs $0x8049f4,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
  803fe6:	89 c3                	mov    %eax,%ebx
  803fe8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fec:	48 89 c7             	mov    %rax,%rdi
  803fef:	48 b8 f4 49 80 00 00 	movabs $0x8049f4,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
  803ffb:	39 c3                	cmp    %eax,%ebx
  803ffd:	0f 94 c0             	sete   %al
  804000:	0f b6 c0             	movzbl %al,%eax
  804003:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804006:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80400d:	00 00 00 
  804010:	48 8b 00             	mov    (%rax),%rax
  804013:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804019:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80401c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80401f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804022:	75 05                	jne    804029 <_pipeisclosed+0x7d>
			return ret;
  804024:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804027:	eb 4f                	jmp    804078 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804029:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80402c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80402f:	74 42                	je     804073 <_pipeisclosed+0xc7>
  804031:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804035:	75 3c                	jne    804073 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804037:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80403e:	00 00 00 
  804041:	48 8b 00             	mov    (%rax),%rax
  804044:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80404a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80404d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804050:	89 c6                	mov    %eax,%esi
  804052:	48 bf 7d 53 80 00 00 	movabs $0x80537d,%rdi
  804059:	00 00 00 
  80405c:	b8 00 00 00 00       	mov    $0x0,%eax
  804061:	49 b8 95 05 80 00 00 	movabs $0x800595,%r8
  804068:	00 00 00 
  80406b:	41 ff d0             	callq  *%r8
	}
  80406e:	e9 4a ff ff ff       	jmpq   803fbd <_pipeisclosed+0x11>
  804073:	e9 45 ff ff ff       	jmpq   803fbd <_pipeisclosed+0x11>
}
  804078:	48 83 c4 28          	add    $0x28,%rsp
  80407c:	5b                   	pop    %rbx
  80407d:	5d                   	pop    %rbp
  80407e:	c3                   	retq   

000000000080407f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80407f:	55                   	push   %rbp
  804080:	48 89 e5             	mov    %rsp,%rbp
  804083:	48 83 ec 30          	sub    $0x30,%rsp
  804087:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80408a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80408e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804091:	48 89 d6             	mov    %rdx,%rsi
  804094:	89 c7                	mov    %eax,%edi
  804096:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  80409d:	00 00 00 
  8040a0:	ff d0                	callq  *%rax
  8040a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a9:	79 05                	jns    8040b0 <pipeisclosed+0x31>
		return r;
  8040ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ae:	eb 31                	jmp    8040e1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040b4:	48 89 c7             	mov    %rax,%rdi
  8040b7:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8040be:	00 00 00 
  8040c1:	ff d0                	callq  *%rax
  8040c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8040c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040cf:	48 89 d6             	mov    %rdx,%rsi
  8040d2:	48 89 c7             	mov    %rax,%rdi
  8040d5:	48 b8 ac 3f 80 00 00 	movabs $0x803fac,%rax
  8040dc:	00 00 00 
  8040df:	ff d0                	callq  *%rax
}
  8040e1:	c9                   	leaveq 
  8040e2:	c3                   	retq   

00000000008040e3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040e3:	55                   	push   %rbp
  8040e4:	48 89 e5             	mov    %rsp,%rbp
  8040e7:	48 83 ec 40          	sub    $0x40,%rsp
  8040eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040f3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8040f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040fb:	48 89 c7             	mov    %rax,%rdi
  8040fe:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  804105:	00 00 00 
  804108:	ff d0                	callq  *%rax
  80410a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80410e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804112:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804116:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80411d:	00 
  80411e:	e9 92 00 00 00       	jmpq   8041b5 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804123:	eb 41                	jmp    804166 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804125:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80412a:	74 09                	je     804135 <devpipe_read+0x52>
				return i;
  80412c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804130:	e9 92 00 00 00       	jmpq   8041c7 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804135:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804139:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80413d:	48 89 d6             	mov    %rdx,%rsi
  804140:	48 89 c7             	mov    %rax,%rdi
  804143:	48 b8 ac 3f 80 00 00 	movabs $0x803fac,%rax
  80414a:	00 00 00 
  80414d:	ff d0                	callq  *%rax
  80414f:	85 c0                	test   %eax,%eax
  804151:	74 07                	je     80415a <devpipe_read+0x77>
				return 0;
  804153:	b8 00 00 00 00       	mov    $0x0,%eax
  804158:	eb 6d                	jmp    8041c7 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80415a:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416a:	8b 10                	mov    (%rax),%edx
  80416c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804170:	8b 40 04             	mov    0x4(%rax),%eax
  804173:	39 c2                	cmp    %eax,%edx
  804175:	74 ae                	je     804125 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804177:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80417b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80417f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804183:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804187:	8b 00                	mov    (%rax),%eax
  804189:	99                   	cltd   
  80418a:	c1 ea 1b             	shr    $0x1b,%edx
  80418d:	01 d0                	add    %edx,%eax
  80418f:	83 e0 1f             	and    $0x1f,%eax
  804192:	29 d0                	sub    %edx,%eax
  804194:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804198:	48 98                	cltq   
  80419a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80419f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a5:	8b 00                	mov    (%rax),%eax
  8041a7:	8d 50 01             	lea    0x1(%rax),%edx
  8041aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ae:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041bd:	0f 82 60 ff ff ff    	jb     804123 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8041c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041c7:	c9                   	leaveq 
  8041c8:	c3                   	retq   

00000000008041c9 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041c9:	55                   	push   %rbp
  8041ca:	48 89 e5             	mov    %rsp,%rbp
  8041cd:	48 83 ec 40          	sub    $0x40,%rsp
  8041d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8041dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041e1:	48 89 c7             	mov    %rax,%rdi
  8041e4:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8041eb:	00 00 00 
  8041ee:	ff d0                	callq  *%rax
  8041f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041fc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804203:	00 
  804204:	e9 8e 00 00 00       	jmpq   804297 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804209:	eb 31                	jmp    80423c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80420b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80420f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804213:	48 89 d6             	mov    %rdx,%rsi
  804216:	48 89 c7             	mov    %rax,%rdi
  804219:	48 b8 ac 3f 80 00 00 	movabs $0x803fac,%rax
  804220:	00 00 00 
  804223:	ff d0                	callq  *%rax
  804225:	85 c0                	test   %eax,%eax
  804227:	74 07                	je     804230 <devpipe_write+0x67>
				return 0;
  804229:	b8 00 00 00 00       	mov    $0x0,%eax
  80422e:	eb 79                	jmp    8042a9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804230:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  804237:	00 00 00 
  80423a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80423c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804240:	8b 40 04             	mov    0x4(%rax),%eax
  804243:	48 63 d0             	movslq %eax,%rdx
  804246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424a:	8b 00                	mov    (%rax),%eax
  80424c:	48 98                	cltq   
  80424e:	48 83 c0 20          	add    $0x20,%rax
  804252:	48 39 c2             	cmp    %rax,%rdx
  804255:	73 b4                	jae    80420b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80425b:	8b 40 04             	mov    0x4(%rax),%eax
  80425e:	99                   	cltd   
  80425f:	c1 ea 1b             	shr    $0x1b,%edx
  804262:	01 d0                	add    %edx,%eax
  804264:	83 e0 1f             	and    $0x1f,%eax
  804267:	29 d0                	sub    %edx,%eax
  804269:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80426d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804271:	48 01 ca             	add    %rcx,%rdx
  804274:	0f b6 0a             	movzbl (%rdx),%ecx
  804277:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80427b:	48 98                	cltq   
  80427d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804285:	8b 40 04             	mov    0x4(%rax),%eax
  804288:	8d 50 01             	lea    0x1(%rax),%edx
  80428b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80428f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804292:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80429f:	0f 82 64 ff ff ff    	jb     804209 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042a9:	c9                   	leaveq 
  8042aa:	c3                   	retq   

00000000008042ab <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042ab:	55                   	push   %rbp
  8042ac:	48 89 e5             	mov    %rsp,%rbp
  8042af:	48 83 ec 20          	sub    $0x20,%rsp
  8042b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042bf:	48 89 c7             	mov    %rax,%rdi
  8042c2:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8042c9:	00 00 00 
  8042cc:	ff d0                	callq  *%rax
  8042ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8042d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042d6:	48 be 90 53 80 00 00 	movabs $0x805390,%rsi
  8042dd:	00 00 00 
  8042e0:	48 89 c7             	mov    %rax,%rdi
  8042e3:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  8042ea:	00 00 00 
  8042ed:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8042ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f3:	8b 50 04             	mov    0x4(%rax),%edx
  8042f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042fa:	8b 00                	mov    (%rax),%eax
  8042fc:	29 c2                	sub    %eax,%edx
  8042fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804302:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804308:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80430c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804313:	00 00 00 
	stat->st_dev = &devpipe;
  804316:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80431a:	48 b9 80 70 80 00 00 	movabs $0x807080,%rcx
  804321:	00 00 00 
  804324:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80432b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804330:	c9                   	leaveq 
  804331:	c3                   	retq   

0000000000804332 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804332:	55                   	push   %rbp
  804333:	48 89 e5             	mov    %rsp,%rbp
  804336:	48 83 ec 10          	sub    $0x10,%rsp
  80433a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80433e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804342:	48 89 c6             	mov    %rax,%rsi
  804345:	bf 00 00 00 00       	mov    $0x0,%edi
  80434a:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  804351:	00 00 00 
  804354:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80435a:	48 89 c7             	mov    %rax,%rdi
  80435d:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  804364:	00 00 00 
  804367:	ff d0                	callq  *%rax
  804369:	48 89 c6             	mov    %rax,%rsi
  80436c:	bf 00 00 00 00       	mov    $0x0,%edi
  804371:	48 b8 37 1b 80 00 00 	movabs $0x801b37,%rax
  804378:	00 00 00 
  80437b:	ff d0                	callq  *%rax
}
  80437d:	c9                   	leaveq 
  80437e:	c3                   	retq   

000000000080437f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80437f:	55                   	push   %rbp
  804380:	48 89 e5             	mov    %rsp,%rbp
  804383:	48 83 ec 20          	sub    $0x20,%rsp
  804387:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80438a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80438e:	75 35                	jne    8043c5 <wait+0x46>
  804390:	48 b9 97 53 80 00 00 	movabs $0x805397,%rcx
  804397:	00 00 00 
  80439a:	48 ba a2 53 80 00 00 	movabs $0x8053a2,%rdx
  8043a1:	00 00 00 
  8043a4:	be 09 00 00 00       	mov    $0x9,%esi
  8043a9:	48 bf b7 53 80 00 00 	movabs $0x8053b7,%rdi
  8043b0:	00 00 00 
  8043b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b8:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  8043bf:	00 00 00 
  8043c2:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8043c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8043cd:	48 63 d0             	movslq %eax,%rdx
  8043d0:	48 89 d0             	mov    %rdx,%rax
  8043d3:	48 c1 e0 03          	shl    $0x3,%rax
  8043d7:	48 01 d0             	add    %rdx,%rax
  8043da:	48 c1 e0 05          	shl    $0x5,%rax
  8043de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043e5:	00 00 00 
  8043e8:	48 01 d0             	add    %rdx,%rax
  8043eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8043ef:	eb 0c                	jmp    8043fd <wait+0x7e>
		sys_yield();
  8043f1:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8043fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804401:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804407:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80440a:	75 0e                	jne    80441a <wait+0x9b>
  80440c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804410:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804416:	85 c0                	test   %eax,%eax
  804418:	75 d7                	jne    8043f1 <wait+0x72>
		sys_yield();
}
  80441a:	c9                   	leaveq 
  80441b:	c3                   	retq   

000000000080441c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80441c:	55                   	push   %rbp
  80441d:	48 89 e5             	mov    %rsp,%rbp
  804420:	48 83 ec 20          	sub    $0x20,%rsp
  804424:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804427:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80442a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80442d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804431:	be 01 00 00 00       	mov    $0x1,%esi
  804436:	48 89 c7             	mov    %rax,%rdi
  804439:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  804440:	00 00 00 
  804443:	ff d0                	callq  *%rax
}
  804445:	c9                   	leaveq 
  804446:	c3                   	retq   

0000000000804447 <getchar>:

int
getchar(void)
{
  804447:	55                   	push   %rbp
  804448:	48 89 e5             	mov    %rsp,%rbp
  80444b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80444f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804453:	ba 01 00 00 00       	mov    $0x1,%edx
  804458:	48 89 c6             	mov    %rax,%rsi
  80445b:	bf 00 00 00 00       	mov    $0x0,%edi
  804460:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  804467:	00 00 00 
  80446a:	ff d0                	callq  *%rax
  80446c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80446f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804473:	79 05                	jns    80447a <getchar+0x33>
		return r;
  804475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804478:	eb 14                	jmp    80448e <getchar+0x47>
	if (r < 1)
  80447a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447e:	7f 07                	jg     804487 <getchar+0x40>
		return -E_EOF;
  804480:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804485:	eb 07                	jmp    80448e <getchar+0x47>
	return c;
  804487:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80448b:	0f b6 c0             	movzbl %al,%eax
}
  80448e:	c9                   	leaveq 
  80448f:	c3                   	retq   

0000000000804490 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804490:	55                   	push   %rbp
  804491:	48 89 e5             	mov    %rsp,%rbp
  804494:	48 83 ec 20          	sub    $0x20,%rsp
  804498:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80449b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80449f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044a2:	48 89 d6             	mov    %rdx,%rsi
  8044a5:	89 c7                	mov    %eax,%edi
  8044a7:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  8044ae:	00 00 00 
  8044b1:	ff d0                	callq  *%rax
  8044b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ba:	79 05                	jns    8044c1 <iscons+0x31>
		return r;
  8044bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044bf:	eb 1a                	jmp    8044db <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c5:	8b 10                	mov    (%rax),%edx
  8044c7:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  8044ce:	00 00 00 
  8044d1:	8b 00                	mov    (%rax),%eax
  8044d3:	39 c2                	cmp    %eax,%edx
  8044d5:	0f 94 c0             	sete   %al
  8044d8:	0f b6 c0             	movzbl %al,%eax
}
  8044db:	c9                   	leaveq 
  8044dc:	c3                   	retq   

00000000008044dd <opencons>:

int
opencons(void)
{
  8044dd:	55                   	push   %rbp
  8044de:	48 89 e5             	mov    %rsp,%rbp
  8044e1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044e5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044e9:	48 89 c7             	mov    %rax,%rdi
  8044ec:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  8044f3:	00 00 00 
  8044f6:	ff d0                	callq  *%rax
  8044f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ff:	79 05                	jns    804506 <opencons+0x29>
		return r;
  804501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804504:	eb 5b                	jmp    804561 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450a:	ba 07 04 00 00       	mov    $0x407,%edx
  80450f:	48 89 c6             	mov    %rax,%rsi
  804512:	bf 00 00 00 00       	mov    $0x0,%edi
  804517:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  80451e:	00 00 00 
  804521:	ff d0                	callq  *%rax
  804523:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804526:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80452a:	79 05                	jns    804531 <opencons+0x54>
		return r;
  80452c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80452f:	eb 30                	jmp    804561 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804531:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804535:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  80453c:	00 00 00 
  80453f:	8b 12                	mov    (%rdx),%edx
  804541:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804547:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80454e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804552:	48 89 c7             	mov    %rax,%rdi
  804555:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  80455c:	00 00 00 
  80455f:	ff d0                	callq  *%rax
}
  804561:	c9                   	leaveq 
  804562:	c3                   	retq   

0000000000804563 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804563:	55                   	push   %rbp
  804564:	48 89 e5             	mov    %rsp,%rbp
  804567:	48 83 ec 30          	sub    $0x30,%rsp
  80456b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80456f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804573:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804577:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80457c:	75 07                	jne    804585 <devcons_read+0x22>
		return 0;
  80457e:	b8 00 00 00 00       	mov    $0x0,%eax
  804583:	eb 4b                	jmp    8045d0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804585:	eb 0c                	jmp    804593 <devcons_read+0x30>
		sys_yield();
  804587:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  80458e:	00 00 00 
  804591:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804593:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  80459a:	00 00 00 
  80459d:	ff d0                	callq  *%rax
  80459f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a6:	74 df                	je     804587 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8045a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ac:	79 05                	jns    8045b3 <devcons_read+0x50>
		return c;
  8045ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b1:	eb 1d                	jmp    8045d0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8045b3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045b7:	75 07                	jne    8045c0 <devcons_read+0x5d>
		return 0;
  8045b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045be:	eb 10                	jmp    8045d0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8045c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c3:	89 c2                	mov    %eax,%edx
  8045c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045c9:	88 10                	mov    %dl,(%rax)
	return 1;
  8045cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8045d0:	c9                   	leaveq 
  8045d1:	c3                   	retq   

00000000008045d2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045d2:	55                   	push   %rbp
  8045d3:	48 89 e5             	mov    %rsp,%rbp
  8045d6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8045dd:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8045e4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045eb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045f9:	eb 76                	jmp    804671 <devcons_write+0x9f>
		m = n - tot;
  8045fb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804602:	89 c2                	mov    %eax,%edx
  804604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804607:	29 c2                	sub    %eax,%edx
  804609:	89 d0                	mov    %edx,%eax
  80460b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80460e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804611:	83 f8 7f             	cmp    $0x7f,%eax
  804614:	76 07                	jbe    80461d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804616:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80461d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804620:	48 63 d0             	movslq %eax,%rdx
  804623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804626:	48 63 c8             	movslq %eax,%rcx
  804629:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804630:	48 01 c1             	add    %rax,%rcx
  804633:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80463a:	48 89 ce             	mov    %rcx,%rsi
  80463d:	48 89 c7             	mov    %rax,%rdi
  804640:	48 b8 81 14 80 00 00 	movabs $0x801481,%rax
  804647:	00 00 00 
  80464a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80464c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80464f:	48 63 d0             	movslq %eax,%rdx
  804652:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804659:	48 89 d6             	mov    %rdx,%rsi
  80465c:	48 89 c7             	mov    %rax,%rdi
  80465f:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  804666:	00 00 00 
  804669:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80466b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80466e:	01 45 fc             	add    %eax,-0x4(%rbp)
  804671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804674:	48 98                	cltq   
  804676:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80467d:	0f 82 78 ff ff ff    	jb     8045fb <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804683:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804686:	c9                   	leaveq 
  804687:	c3                   	retq   

0000000000804688 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804688:	55                   	push   %rbp
  804689:	48 89 e5             	mov    %rsp,%rbp
  80468c:	48 83 ec 08          	sub    $0x8,%rsp
  804690:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804694:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804699:	c9                   	leaveq 
  80469a:	c3                   	retq   

000000000080469b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80469b:	55                   	push   %rbp
  80469c:	48 89 e5             	mov    %rsp,%rbp
  80469f:	48 83 ec 10          	sub    $0x10,%rsp
  8046a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046af:	48 be c7 53 80 00 00 	movabs $0x8053c7,%rsi
  8046b6:	00 00 00 
  8046b9:	48 89 c7             	mov    %rax,%rdi
  8046bc:	48 b8 5d 11 80 00 00 	movabs $0x80115d,%rax
  8046c3:	00 00 00 
  8046c6:	ff d0                	callq  *%rax
	return 0;
  8046c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046cd:	c9                   	leaveq 
  8046ce:	c3                   	retq   

00000000008046cf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8046cf:	55                   	push   %rbp
  8046d0:	48 89 e5             	mov    %rsp,%rbp
  8046d3:	48 83 ec 10          	sub    $0x10,%rsp
  8046d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8046db:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  8046e2:	00 00 00 
  8046e5:	48 8b 00             	mov    (%rax),%rax
  8046e8:	48 85 c0             	test   %rax,%rax
  8046eb:	75 49                	jne    804736 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8046ed:	ba 07 00 00 00       	mov    $0x7,%edx
  8046f2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8046f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8046fc:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  804703:	00 00 00 
  804706:	ff d0                	callq  *%rax
  804708:	85 c0                	test   %eax,%eax
  80470a:	79 2a                	jns    804736 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  80470c:	48 ba d0 53 80 00 00 	movabs $0x8053d0,%rdx
  804713:	00 00 00 
  804716:	be 21 00 00 00       	mov    $0x21,%esi
  80471b:	48 bf fb 53 80 00 00 	movabs $0x8053fb,%rdi
  804722:	00 00 00 
  804725:	b8 00 00 00 00       	mov    $0x0,%eax
  80472a:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  804731:	00 00 00 
  804734:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804736:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80473d:	00 00 00 
  804740:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804744:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  804747:	48 be 92 47 80 00 00 	movabs $0x804792,%rsi
  80474e:	00 00 00 
  804751:	bf 00 00 00 00       	mov    $0x0,%edi
  804756:	48 b8 16 1c 80 00 00 	movabs $0x801c16,%rax
  80475d:	00 00 00 
  804760:	ff d0                	callq  *%rax
  804762:	85 c0                	test   %eax,%eax
  804764:	79 2a                	jns    804790 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  804766:	48 ba 10 54 80 00 00 	movabs $0x805410,%rdx
  80476d:	00 00 00 
  804770:	be 27 00 00 00       	mov    $0x27,%esi
  804775:	48 bf fb 53 80 00 00 	movabs $0x8053fb,%rdi
  80477c:	00 00 00 
  80477f:	b8 00 00 00 00       	mov    $0x0,%eax
  804784:	48 b9 5c 03 80 00 00 	movabs $0x80035c,%rcx
  80478b:	00 00 00 
  80478e:	ff d1                	callq  *%rcx
}
  804790:	c9                   	leaveq 
  804791:	c3                   	retq   

0000000000804792 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804792:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804795:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  80479c:	00 00 00 
call *%rax
  80479f:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  8047a1:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8047a8:	00 
    movq 152(%rsp), %rcx
  8047a9:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8047b0:	00 
    subq $8, %rcx
  8047b1:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  8047b5:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  8047b8:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8047bf:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  8047c0:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8047c4:	4c 8b 3c 24          	mov    (%rsp),%r15
  8047c8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8047cd:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8047d2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8047d7:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8047dc:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8047e1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8047e6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8047eb:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8047f0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8047f5:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8047fa:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8047ff:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804804:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804809:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80480e:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  804812:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  804816:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  804817:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  804818:	c3                   	retq   

0000000000804819 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804819:	55                   	push   %rbp
  80481a:	48 89 e5             	mov    %rsp,%rbp
  80481d:	48 83 ec 30          	sub    $0x30,%rsp
  804821:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804825:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804829:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80482d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804832:	75 0e                	jne    804842 <ipc_recv+0x29>
        pg = (void *)UTOP;
  804834:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80483b:	00 00 00 
  80483e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  804842:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804846:	48 89 c7             	mov    %rax,%rdi
  804849:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  804850:	00 00 00 
  804853:	ff d0                	callq  *%rax
  804855:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804858:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80485c:	79 27                	jns    804885 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80485e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804863:	74 0a                	je     80486f <ipc_recv+0x56>
            *from_env_store = 0;
  804865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804869:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80486f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804874:	74 0a                	je     804880 <ipc_recv+0x67>
            *perm_store = 0;
  804876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80487a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  804880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804883:	eb 53                	jmp    8048d8 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  804885:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80488a:	74 19                	je     8048a5 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80488c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804893:	00 00 00 
  804896:	48 8b 00             	mov    (%rax),%rax
  804899:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80489f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a3:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8048a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048aa:	74 19                	je     8048c5 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8048ac:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048b3:	00 00 00 
  8048b6:	48 8b 00             	mov    (%rax),%rax
  8048b9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8048bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048c3:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8048c5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048cc:	00 00 00 
  8048cf:	48 8b 00             	mov    (%rax),%rax
  8048d2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8048d8:	c9                   	leaveq 
  8048d9:	c3                   	retq   

00000000008048da <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8048da:	55                   	push   %rbp
  8048db:	48 89 e5             	mov    %rsp,%rbp
  8048de:	48 83 ec 30          	sub    $0x30,%rsp
  8048e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048e5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8048e8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8048ec:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8048ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8048f4:	75 0e                	jne    804904 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8048f6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048fd:	00 00 00 
  804900:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  804904:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804907:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80490a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80490e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804911:	89 c7                	mov    %eax,%edi
  804913:	48 b8 60 1c 80 00 00 	movabs $0x801c60,%rax
  80491a:	00 00 00 
  80491d:	ff d0                	callq  *%rax
  80491f:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  804922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804926:	79 36                	jns    80495e <ipc_send+0x84>
  804928:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80492c:	74 30                	je     80495e <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80492e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804931:	89 c1                	mov    %eax,%ecx
  804933:	48 ba 47 54 80 00 00 	movabs $0x805447,%rdx
  80493a:	00 00 00 
  80493d:	be 49 00 00 00       	mov    $0x49,%esi
  804942:	48 bf 54 54 80 00 00 	movabs $0x805454,%rdi
  804949:	00 00 00 
  80494c:	b8 00 00 00 00       	mov    $0x0,%eax
  804951:	49 b8 5c 03 80 00 00 	movabs $0x80035c,%r8
  804958:	00 00 00 
  80495b:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80495e:	48 b8 4e 1a 80 00 00 	movabs $0x801a4e,%rax
  804965:	00 00 00 
  804968:	ff d0                	callq  *%rax
    } while(r != 0);
  80496a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80496e:	75 94                	jne    804904 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  804970:	c9                   	leaveq 
  804971:	c3                   	retq   

0000000000804972 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804972:	55                   	push   %rbp
  804973:	48 89 e5             	mov    %rsp,%rbp
  804976:	48 83 ec 14          	sub    $0x14,%rsp
  80497a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80497d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804984:	eb 5e                	jmp    8049e4 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804986:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80498d:	00 00 00 
  804990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804993:	48 63 d0             	movslq %eax,%rdx
  804996:	48 89 d0             	mov    %rdx,%rax
  804999:	48 c1 e0 03          	shl    $0x3,%rax
  80499d:	48 01 d0             	add    %rdx,%rax
  8049a0:	48 c1 e0 05          	shl    $0x5,%rax
  8049a4:	48 01 c8             	add    %rcx,%rax
  8049a7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8049ad:	8b 00                	mov    (%rax),%eax
  8049af:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8049b2:	75 2c                	jne    8049e0 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8049b4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8049bb:	00 00 00 
  8049be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049c1:	48 63 d0             	movslq %eax,%rdx
  8049c4:	48 89 d0             	mov    %rdx,%rax
  8049c7:	48 c1 e0 03          	shl    $0x3,%rax
  8049cb:	48 01 d0             	add    %rdx,%rax
  8049ce:	48 c1 e0 05          	shl    $0x5,%rax
  8049d2:	48 01 c8             	add    %rcx,%rax
  8049d5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8049db:	8b 40 08             	mov    0x8(%rax),%eax
  8049de:	eb 12                	jmp    8049f2 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8049e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8049e4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8049eb:	7e 99                	jle    804986 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8049ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049f2:	c9                   	leaveq 
  8049f3:	c3                   	retq   

00000000008049f4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8049f4:	55                   	push   %rbp
  8049f5:	48 89 e5             	mov    %rsp,%rbp
  8049f8:	48 83 ec 18          	sub    $0x18,%rsp
  8049fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a04:	48 c1 e8 15          	shr    $0x15,%rax
  804a08:	48 89 c2             	mov    %rax,%rdx
  804a0b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804a12:	01 00 00 
  804a15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a19:	83 e0 01             	and    $0x1,%eax
  804a1c:	48 85 c0             	test   %rax,%rax
  804a1f:	75 07                	jne    804a28 <pageref+0x34>
		return 0;
  804a21:	b8 00 00 00 00       	mov    $0x0,%eax
  804a26:	eb 53                	jmp    804a7b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804a28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a2c:	48 c1 e8 0c          	shr    $0xc,%rax
  804a30:	48 89 c2             	mov    %rax,%rdx
  804a33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804a3a:	01 00 00 
  804a3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804a45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a49:	83 e0 01             	and    $0x1,%eax
  804a4c:	48 85 c0             	test   %rax,%rax
  804a4f:	75 07                	jne    804a58 <pageref+0x64>
		return 0;
  804a51:	b8 00 00 00 00       	mov    $0x0,%eax
  804a56:	eb 23                	jmp    804a7b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a5c:	48 c1 e8 0c          	shr    $0xc,%rax
  804a60:	48 89 c2             	mov    %rax,%rdx
  804a63:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a6a:	00 00 00 
  804a6d:	48 c1 e2 04          	shl    $0x4,%rdx
  804a71:	48 01 d0             	add    %rdx,%rax
  804a74:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804a78:	0f b7 c0             	movzwl %ax,%eax
}
  804a7b:	c9                   	leaveq 
  804a7c:	c3                   	retq   
