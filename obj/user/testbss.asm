
obj/user/testbss:     file format elf64-x86-64


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
  80003c:	e8 6e 01 00 00       	callq  8001af <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	cprintf("Making sure bss works right...\n");
  800052:	48 bf 20 19 80 00 00 	movabs $0x801920,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 5f 04 80 00 00 	movabs $0x80045f,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	for (i = 0; i < ARRAYSIZE; i++)
  80006d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800074:	eb 4b                	jmp    8000c1 <umain+0x7e>
		if (bigarray[i] != 0)
  800076:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  80007d:	00 00 00 
  800080:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800083:	48 63 d2             	movslq %edx,%rdx
  800086:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800089:	85 c0                	test   %eax,%eax
  80008b:	74 30                	je     8000bd <umain+0x7a>
			panic("bigarray[%d] isn't cleared!\n", i);
  80008d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800090:	89 c1                	mov    %eax,%ecx
  800092:	48 ba 40 19 80 00 00 	movabs $0x801940,%rdx
  800099:	00 00 00 
  80009c:	be 11 00 00 00       	mov    $0x11,%esi
  8000a1:	48 bf 5d 19 80 00 00 	movabs $0x80195d,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b8 26 02 80 00 00 	movabs $0x800226,%r8
  8000b7:	00 00 00 
  8000ba:	41 ff d0             	callq  *%r8
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  8000bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000c1:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  8000c8:	7e ac                	jle    800076 <umain+0x33>
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000d1:	eb 1a                	jmp    8000ed <umain+0xaa>
		bigarray[i] = i;
  8000d3:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8000d6:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  8000dd:	00 00 00 
  8000e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000e3:	48 63 d2             	movslq %edx,%rdx
  8000e6:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ed:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  8000f4:	7e dd                	jle    8000d3 <umain+0x90>
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000fd:	eb 4e                	jmp    80014d <umain+0x10a>
		if (bigarray[i] != i)
  8000ff:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800106:	00 00 00 
  800109:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80010c:	48 63 d2             	movslq %edx,%rdx
  80010f:	8b 14 90             	mov    (%rax,%rdx,4),%edx
  800112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800115:	39 c2                	cmp    %eax,%edx
  800117:	74 30                	je     800149 <umain+0x106>
			panic("bigarray[%d] didn't hold its value!\n", i);
  800119:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80011c:	89 c1                	mov    %eax,%ecx
  80011e:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  800125:	00 00 00 
  800128:	be 16 00 00 00       	mov    $0x16,%esi
  80012d:	48 bf 5d 19 80 00 00 	movabs $0x80195d,%rdi
  800134:	00 00 00 
  800137:	b8 00 00 00 00       	mov    $0x0,%eax
  80013c:	49 b8 26 02 80 00 00 	movabs $0x800226,%r8
  800143:	00 00 00 
  800146:	41 ff d0             	callq  *%r8
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  800149:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80014d:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  800154:	7e a9                	jle    8000ff <umain+0xbc>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800156:	48 bf 98 19 80 00 00 	movabs $0x801998,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 5f 04 80 00 00 	movabs $0x80045f,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
	bigarray[ARRAYSIZE+1024] = 0;
  800171:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800178:	00 00 00 
  80017b:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%rax)
  800182:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800185:	48 ba cb 19 80 00 00 	movabs $0x8019cb,%rdx
  80018c:	00 00 00 
  80018f:	be 1a 00 00 00       	mov    $0x1a,%esi
  800194:	48 bf 5d 19 80 00 00 	movabs $0x80195d,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	48 b9 26 02 80 00 00 	movabs $0x800226,%rcx
  8001aa:	00 00 00 
  8001ad:	ff d1                	callq  *%rcx

00000000008001af <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001af:	55                   	push   %rbp
  8001b0:	48 89 e5             	mov    %rsp,%rbp
  8001b3:	48 83 ec 10          	sub    $0x10,%rsp
  8001b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001be:	48 b8 20 30 c0 00 00 	movabs $0xc03020,%rax
  8001c5:	00 00 00 
  8001c8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d3:	7e 14                	jle    8001e9 <libmain+0x3a>
		binaryname = argv[0];
  8001d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d9:	48 8b 10             	mov    (%rax),%rdx
  8001dc:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001e3:	00 00 00 
  8001e6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f0:	48 89 d6             	mov    %rdx,%rsi
  8001f3:	89 c7                	mov    %eax,%edi
  8001f5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001fc:	00 00 00 
  8001ff:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800201:	48 b8 0f 02 80 00 00 	movabs $0x80020f,%rax
  800208:	00 00 00 
  80020b:	ff d0                	callq  *%rax
}
  80020d:	c9                   	leaveq 
  80020e:	c3                   	retq   

000000000080020f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020f:	55                   	push   %rbp
  800210:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800213:	bf 00 00 00 00       	mov    $0x0,%edi
  800218:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
}
  800224:	5d                   	pop    %rbp
  800225:	c3                   	retq   

0000000000800226 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	53                   	push   %rbx
  80022b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800232:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800239:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80023f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800246:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80024d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800254:	84 c0                	test   %al,%al
  800256:	74 23                	je     80027b <_panic+0x55>
  800258:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80025f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800263:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800267:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80026b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80026f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800273:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800277:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80027b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800282:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800289:	00 00 00 
  80028c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800293:	00 00 00 
  800296:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80029a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002a1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002a8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002af:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002b6:	00 00 00 
  8002b9:	48 8b 18             	mov    (%rax),%rbx
  8002bc:	48 b8 da 18 80 00 00 	movabs $0x8018da,%rax
  8002c3:	00 00 00 
  8002c6:	ff d0                	callq  *%rax
  8002c8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002ce:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002d5:	41 89 c8             	mov    %ecx,%r8d
  8002d8:	48 89 d1             	mov    %rdx,%rcx
  8002db:	48 89 da             	mov    %rbx,%rdx
  8002de:	89 c6                	mov    %eax,%esi
  8002e0:	48 bf f0 19 80 00 00 	movabs $0x8019f0,%rdi
  8002e7:	00 00 00 
  8002ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ef:	49 b9 5f 04 80 00 00 	movabs $0x80045f,%r9
  8002f6:	00 00 00 
  8002f9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002fc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800303:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80030a:	48 89 d6             	mov    %rdx,%rsi
  80030d:	48 89 c7             	mov    %rax,%rdi
  800310:	48 b8 b3 03 80 00 00 	movabs $0x8003b3,%rax
  800317:	00 00 00 
  80031a:	ff d0                	callq  *%rax
	cprintf("\n");
  80031c:	48 bf 13 1a 80 00 00 	movabs $0x801a13,%rdi
  800323:	00 00 00 
  800326:	b8 00 00 00 00       	mov    $0x0,%eax
  80032b:	48 ba 5f 04 80 00 00 	movabs $0x80045f,%rdx
  800332:	00 00 00 
  800335:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800337:	cc                   	int3   
  800338:	eb fd                	jmp    800337 <_panic+0x111>

000000000080033a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80033a:	55                   	push   %rbp
  80033b:	48 89 e5             	mov    %rsp,%rbp
  80033e:	48 83 ec 10          	sub    $0x10,%rsp
  800342:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800345:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034d:	8b 00                	mov    (%rax),%eax
  80034f:	8d 48 01             	lea    0x1(%rax),%ecx
  800352:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800356:	89 0a                	mov    %ecx,(%rdx)
  800358:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80035b:	89 d1                	mov    %edx,%ecx
  80035d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800361:	48 98                	cltq   
  800363:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036b:	8b 00                	mov    (%rax),%eax
  80036d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800372:	75 2c                	jne    8003a0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	8b 00                	mov    (%rax),%eax
  80037a:	48 98                	cltq   
  80037c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800380:	48 83 c2 08          	add    $0x8,%rdx
  800384:	48 89 c6             	mov    %rax,%rsi
  800387:	48 89 d7             	mov    %rdx,%rdi
  80038a:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  800391:	00 00 00 
  800394:	ff d0                	callq  *%rax
        b->idx = 0;
  800396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a4:	8b 40 04             	mov    0x4(%rax),%eax
  8003a7:	8d 50 01             	lea    0x1(%rax),%edx
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003b1:	c9                   	leaveq 
  8003b2:	c3                   	retq   

00000000008003b3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003b3:	55                   	push   %rbp
  8003b4:	48 89 e5             	mov    %rsp,%rbp
  8003b7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003be:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003c5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003cc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003d3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003da:	48 8b 0a             	mov    (%rdx),%rcx
  8003dd:	48 89 08             	mov    %rcx,(%rax)
  8003e0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003e4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003e8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ec:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003f7:	00 00 00 
    b.cnt = 0;
  8003fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800401:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800404:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80040b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800412:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800419:	48 89 c6             	mov    %rax,%rsi
  80041c:	48 bf 3a 03 80 00 00 	movabs $0x80033a,%rdi
  800423:	00 00 00 
  800426:	48 b8 12 08 80 00 00 	movabs $0x800812,%rax
  80042d:	00 00 00 
  800430:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800432:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800438:	48 98                	cltq   
  80043a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800441:	48 83 c2 08          	add    $0x8,%rdx
  800445:	48 89 c6             	mov    %rax,%rsi
  800448:	48 89 d7             	mov    %rdx,%rdi
  80044b:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  800452:	00 00 00 
  800455:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800457:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80045d:	c9                   	leaveq 
  80045e:	c3                   	retq   

000000000080045f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80045f:	55                   	push   %rbp
  800460:	48 89 e5             	mov    %rsp,%rbp
  800463:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80046a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800471:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800478:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80047f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800486:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80048d:	84 c0                	test   %al,%al
  80048f:	74 20                	je     8004b1 <cprintf+0x52>
  800491:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800495:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800499:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80049d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004a1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004a5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004a9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004b1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004b8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004bf:	00 00 00 
  8004c2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004c9:	00 00 00 
  8004cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004d7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004de:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004e5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004ec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004f3:	48 8b 0a             	mov    (%rdx),%rcx
  8004f6:	48 89 08             	mov    %rcx,(%rax)
  8004f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800501:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800505:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800509:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800510:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800517:	48 89 d6             	mov    %rdx,%rsi
  80051a:	48 89 c7             	mov    %rax,%rdi
  80051d:	48 b8 b3 03 80 00 00 	movabs $0x8003b3,%rax
  800524:	00 00 00 
  800527:	ff d0                	callq  *%rax
  800529:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80052f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800535:	c9                   	leaveq 
  800536:	c3                   	retq   

0000000000800537 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800537:	55                   	push   %rbp
  800538:	48 89 e5             	mov    %rsp,%rbp
  80053b:	53                   	push   %rbx
  80053c:	48 83 ec 38          	sub    $0x38,%rsp
  800540:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800544:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800548:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80054c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80054f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800553:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800557:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80055a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80055e:	77 3b                	ja     80059b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800560:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800563:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800567:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80056a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056e:	ba 00 00 00 00       	mov    $0x0,%edx
  800573:	48 f7 f3             	div    %rbx
  800576:	48 89 c2             	mov    %rax,%rdx
  800579:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80057c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80057f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800587:	41 89 f9             	mov    %edi,%r9d
  80058a:	48 89 c7             	mov    %rax,%rdi
  80058d:	48 b8 37 05 80 00 00 	movabs $0x800537,%rax
  800594:	00 00 00 
  800597:	ff d0                	callq  *%rax
  800599:	eb 1e                	jmp    8005b9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80059b:	eb 12                	jmp    8005af <printnum+0x78>
			putch(padc, putdat);
  80059d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005a1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	48 89 ce             	mov    %rcx,%rsi
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005af:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005b7:	7f e4                	jg     80059d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005b9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c5:	48 f7 f1             	div    %rcx
  8005c8:	48 89 d0             	mov    %rdx,%rax
  8005cb:	48 ba 50 1b 80 00 00 	movabs $0x801b50,%rdx
  8005d2:	00 00 00 
  8005d5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005d9:	0f be d0             	movsbl %al,%edx
  8005dc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e4:	48 89 ce             	mov    %rcx,%rsi
  8005e7:	89 d7                	mov    %edx,%edi
  8005e9:	ff d0                	callq  *%rax
}
  8005eb:	48 83 c4 38          	add    $0x38,%rsp
  8005ef:	5b                   	pop    %rbx
  8005f0:	5d                   	pop    %rbp
  8005f1:	c3                   	retq   

00000000008005f2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005f2:	55                   	push   %rbp
  8005f3:	48 89 e5             	mov    %rsp,%rbp
  8005f6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005fe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800601:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800605:	7e 52                	jle    800659 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	8b 00                	mov    (%rax),%eax
  80060d:	83 f8 30             	cmp    $0x30,%eax
  800610:	73 24                	jae    800636 <getuint+0x44>
  800612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800616:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	8b 00                	mov    (%rax),%eax
  800620:	89 c0                	mov    %eax,%eax
  800622:	48 01 d0             	add    %rdx,%rax
  800625:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800629:	8b 12                	mov    (%rdx),%edx
  80062b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	89 0a                	mov    %ecx,(%rdx)
  800634:	eb 17                	jmp    80064d <getuint+0x5b>
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80063e:	48 89 d0             	mov    %rdx,%rax
  800641:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064d:	48 8b 00             	mov    (%rax),%rax
  800650:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800654:	e9 a3 00 00 00       	jmpq   8006fc <getuint+0x10a>
	else if (lflag)
  800659:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80065d:	74 4f                	je     8006ae <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	83 f8 30             	cmp    $0x30,%eax
  800668:	73 24                	jae    80068e <getuint+0x9c>
  80066a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800676:	8b 00                	mov    (%rax),%eax
  800678:	89 c0                	mov    %eax,%eax
  80067a:	48 01 d0             	add    %rdx,%rax
  80067d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800681:	8b 12                	mov    (%rdx),%edx
  800683:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	89 0a                	mov    %ecx,(%rdx)
  80068c:	eb 17                	jmp    8006a5 <getuint+0xb3>
  80068e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800692:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800696:	48 89 d0             	mov    %rdx,%rax
  800699:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a5:	48 8b 00             	mov    (%rax),%rax
  8006a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ac:	eb 4e                	jmp    8006fc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b2:	8b 00                	mov    (%rax),%eax
  8006b4:	83 f8 30             	cmp    $0x30,%eax
  8006b7:	73 24                	jae    8006dd <getuint+0xeb>
  8006b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c5:	8b 00                	mov    (%rax),%eax
  8006c7:	89 c0                	mov    %eax,%eax
  8006c9:	48 01 d0             	add    %rdx,%rax
  8006cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d0:	8b 12                	mov    (%rdx),%edx
  8006d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d9:	89 0a                	mov    %ecx,(%rdx)
  8006db:	eb 17                	jmp    8006f4 <getuint+0x102>
  8006dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e5:	48 89 d0             	mov    %rdx,%rax
  8006e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	89 c0                	mov    %eax,%eax
  8006f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800700:	c9                   	leaveq 
  800701:	c3                   	retq   

0000000000800702 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800702:	55                   	push   %rbp
  800703:	48 89 e5             	mov    %rsp,%rbp
  800706:	48 83 ec 1c          	sub    $0x1c,%rsp
  80070a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80070e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800711:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800715:	7e 52                	jle    800769 <getint+0x67>
		x=va_arg(*ap, long long);
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	83 f8 30             	cmp    $0x30,%eax
  800720:	73 24                	jae    800746 <getint+0x44>
  800722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800726:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80072a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072e:	8b 00                	mov    (%rax),%eax
  800730:	89 c0                	mov    %eax,%eax
  800732:	48 01 d0             	add    %rdx,%rax
  800735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800739:	8b 12                	mov    (%rdx),%edx
  80073b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80073e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800742:	89 0a                	mov    %ecx,(%rdx)
  800744:	eb 17                	jmp    80075d <getint+0x5b>
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80074e:	48 89 d0             	mov    %rdx,%rax
  800751:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80075d:	48 8b 00             	mov    (%rax),%rax
  800760:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800764:	e9 a3 00 00 00       	jmpq   80080c <getint+0x10a>
	else if (lflag)
  800769:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80076d:	74 4f                	je     8007be <getint+0xbc>
		x=va_arg(*ap, long);
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	8b 00                	mov    (%rax),%eax
  800775:	83 f8 30             	cmp    $0x30,%eax
  800778:	73 24                	jae    80079e <getint+0x9c>
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	8b 00                	mov    (%rax),%eax
  800788:	89 c0                	mov    %eax,%eax
  80078a:	48 01 d0             	add    %rdx,%rax
  80078d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800791:	8b 12                	mov    (%rdx),%edx
  800793:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800796:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079a:	89 0a                	mov    %ecx,(%rdx)
  80079c:	eb 17                	jmp    8007b5 <getint+0xb3>
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a6:	48 89 d0             	mov    %rdx,%rax
  8007a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b5:	48 8b 00             	mov    (%rax),%rax
  8007b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007bc:	eb 4e                	jmp    80080c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	8b 00                	mov    (%rax),%eax
  8007c4:	83 f8 30             	cmp    $0x30,%eax
  8007c7:	73 24                	jae    8007ed <getint+0xeb>
  8007c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d5:	8b 00                	mov    (%rax),%eax
  8007d7:	89 c0                	mov    %eax,%eax
  8007d9:	48 01 d0             	add    %rdx,%rax
  8007dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e0:	8b 12                	mov    (%rdx),%edx
  8007e2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e9:	89 0a                	mov    %ecx,(%rdx)
  8007eb:	eb 17                	jmp    800804 <getint+0x102>
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f5:	48 89 d0             	mov    %rdx,%rax
  8007f8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800804:	8b 00                	mov    (%rax),%eax
  800806:	48 98                	cltq   
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80080c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800810:	c9                   	leaveq 
  800811:	c3                   	retq   

0000000000800812 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800812:	55                   	push   %rbp
  800813:	48 89 e5             	mov    %rsp,%rbp
  800816:	41 54                	push   %r12
  800818:	53                   	push   %rbx
  800819:	48 83 ec 60          	sub    $0x60,%rsp
  80081d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800821:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800825:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800829:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80082d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800831:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800835:	48 8b 0a             	mov    (%rdx),%rcx
  800838:	48 89 08             	mov    %rcx,(%rax)
  80083b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80083f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800843:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800847:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084b:	eb 17                	jmp    800864 <vprintfmt+0x52>
			if (ch == '\0')
  80084d:	85 db                	test   %ebx,%ebx
  80084f:	0f 84 df 04 00 00    	je     800d34 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800855:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800859:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085d:	48 89 d6             	mov    %rdx,%rsi
  800860:	89 df                	mov    %ebx,%edi
  800862:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800864:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800868:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80086c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800870:	0f b6 00             	movzbl (%rax),%eax
  800873:	0f b6 d8             	movzbl %al,%ebx
  800876:	83 fb 25             	cmp    $0x25,%ebx
  800879:	75 d2                	jne    80084d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80087b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80087f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800886:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80088d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800894:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a7:	0f b6 00             	movzbl (%rax),%eax
  8008aa:	0f b6 d8             	movzbl %al,%ebx
  8008ad:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008b0:	83 f8 55             	cmp    $0x55,%eax
  8008b3:	0f 87 47 04 00 00    	ja     800d00 <vprintfmt+0x4ee>
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008c2:	00 
  8008c3:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  8008ca:	00 00 00 
  8008cd:	48 01 d0             	add    %rdx,%rax
  8008d0:	48 8b 00             	mov    (%rax),%rax
  8008d3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008d5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008d9:	eb c0                	jmp    80089b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008db:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008df:	eb ba                	jmp    80089b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008e8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008eb:	89 d0                	mov    %edx,%eax
  8008ed:	c1 e0 02             	shl    $0x2,%eax
  8008f0:	01 d0                	add    %edx,%eax
  8008f2:	01 c0                	add    %eax,%eax
  8008f4:	01 d8                	add    %ebx,%eax
  8008f6:	83 e8 30             	sub    $0x30,%eax
  8008f9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800900:	0f b6 00             	movzbl (%rax),%eax
  800903:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800906:	83 fb 2f             	cmp    $0x2f,%ebx
  800909:	7e 0c                	jle    800917 <vprintfmt+0x105>
  80090b:	83 fb 39             	cmp    $0x39,%ebx
  80090e:	7f 07                	jg     800917 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800910:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800915:	eb d1                	jmp    8008e8 <vprintfmt+0xd6>
			goto process_precision;
  800917:	eb 58                	jmp    800971 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800919:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091c:	83 f8 30             	cmp    $0x30,%eax
  80091f:	73 17                	jae    800938 <vprintfmt+0x126>
  800921:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800925:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800928:	89 c0                	mov    %eax,%eax
  80092a:	48 01 d0             	add    %rdx,%rax
  80092d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800930:	83 c2 08             	add    $0x8,%edx
  800933:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800936:	eb 0f                	jmp    800947 <vprintfmt+0x135>
  800938:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093c:	48 89 d0             	mov    %rdx,%rax
  80093f:	48 83 c2 08          	add    $0x8,%rdx
  800943:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800947:	8b 00                	mov    (%rax),%eax
  800949:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80094c:	eb 23                	jmp    800971 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80094e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800952:	79 0c                	jns    800960 <vprintfmt+0x14e>
				width = 0;
  800954:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80095b:	e9 3b ff ff ff       	jmpq   80089b <vprintfmt+0x89>
  800960:	e9 36 ff ff ff       	jmpq   80089b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800965:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80096c:	e9 2a ff ff ff       	jmpq   80089b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800971:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800975:	79 12                	jns    800989 <vprintfmt+0x177>
				width = precision, precision = -1;
  800977:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80097a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80097d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800984:	e9 12 ff ff ff       	jmpq   80089b <vprintfmt+0x89>
  800989:	e9 0d ff ff ff       	jmpq   80089b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80098e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800992:	e9 04 ff ff ff       	jmpq   80089b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800997:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099a:	83 f8 30             	cmp    $0x30,%eax
  80099d:	73 17                	jae    8009b6 <vprintfmt+0x1a4>
  80099f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a6:	89 c0                	mov    %eax,%eax
  8009a8:	48 01 d0             	add    %rdx,%rax
  8009ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b4:	eb 0f                	jmp    8009c5 <vprintfmt+0x1b3>
  8009b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ba:	48 89 d0             	mov    %rdx,%rax
  8009bd:	48 83 c2 08          	add    $0x8,%rdx
  8009c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c5:	8b 10                	mov    (%rax),%edx
  8009c7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cf:	48 89 ce             	mov    %rcx,%rsi
  8009d2:	89 d7                	mov    %edx,%edi
  8009d4:	ff d0                	callq  *%rax
			break;
  8009d6:	e9 53 03 00 00       	jmpq   800d2e <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009de:	83 f8 30             	cmp    $0x30,%eax
  8009e1:	73 17                	jae    8009fa <vprintfmt+0x1e8>
  8009e3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ea:	89 c0                	mov    %eax,%eax
  8009ec:	48 01 d0             	add    %rdx,%rax
  8009ef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f2:	83 c2 08             	add    $0x8,%edx
  8009f5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f8:	eb 0f                	jmp    800a09 <vprintfmt+0x1f7>
  8009fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fe:	48 89 d0             	mov    %rdx,%rax
  800a01:	48 83 c2 08          	add    $0x8,%rdx
  800a05:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a09:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a0b:	85 db                	test   %ebx,%ebx
  800a0d:	79 02                	jns    800a11 <vprintfmt+0x1ff>
				err = -err;
  800a0f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a11:	83 fb 15             	cmp    $0x15,%ebx
  800a14:	7f 16                	jg     800a2c <vprintfmt+0x21a>
  800a16:	48 b8 a0 1a 80 00 00 	movabs $0x801aa0,%rax
  800a1d:	00 00 00 
  800a20:	48 63 d3             	movslq %ebx,%rdx
  800a23:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a27:	4d 85 e4             	test   %r12,%r12
  800a2a:	75 2e                	jne    800a5a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a34:	89 d9                	mov    %ebx,%ecx
  800a36:	48 ba 61 1b 80 00 00 	movabs $0x801b61,%rdx
  800a3d:	00 00 00 
  800a40:	48 89 c7             	mov    %rax,%rdi
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
  800a48:	49 b8 3d 0d 80 00 00 	movabs $0x800d3d,%r8
  800a4f:	00 00 00 
  800a52:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a55:	e9 d4 02 00 00       	jmpq   800d2e <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a5a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	4c 89 e1             	mov    %r12,%rcx
  800a65:	48 ba 6a 1b 80 00 00 	movabs $0x801b6a,%rdx
  800a6c:	00 00 00 
  800a6f:	48 89 c7             	mov    %rax,%rdi
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
  800a77:	49 b8 3d 0d 80 00 00 	movabs $0x800d3d,%r8
  800a7e:	00 00 00 
  800a81:	41 ff d0             	callq  *%r8
			break;
  800a84:	e9 a5 02 00 00       	jmpq   800d2e <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8c:	83 f8 30             	cmp    $0x30,%eax
  800a8f:	73 17                	jae    800aa8 <vprintfmt+0x296>
  800a91:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a95:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a98:	89 c0                	mov    %eax,%eax
  800a9a:	48 01 d0             	add    %rdx,%rax
  800a9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa0:	83 c2 08             	add    $0x8,%edx
  800aa3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa6:	eb 0f                	jmp    800ab7 <vprintfmt+0x2a5>
  800aa8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aac:	48 89 d0             	mov    %rdx,%rax
  800aaf:	48 83 c2 08          	add    $0x8,%rdx
  800ab3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab7:	4c 8b 20             	mov    (%rax),%r12
  800aba:	4d 85 e4             	test   %r12,%r12
  800abd:	75 0a                	jne    800ac9 <vprintfmt+0x2b7>
				p = "(null)";
  800abf:	49 bc 6d 1b 80 00 00 	movabs $0x801b6d,%r12
  800ac6:	00 00 00 
			if (width > 0 && padc != '-')
  800ac9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acd:	7e 3f                	jle    800b0e <vprintfmt+0x2fc>
  800acf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ad3:	74 39                	je     800b0e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad8:	48 98                	cltq   
  800ada:	48 89 c6             	mov    %rax,%rsi
  800add:	4c 89 e7             	mov    %r12,%rdi
  800ae0:	48 b8 e9 0f 80 00 00 	movabs $0x800fe9,%rax
  800ae7:	00 00 00 
  800aea:	ff d0                	callq  *%rax
  800aec:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800aef:	eb 17                	jmp    800b08 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800af1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800af5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800af9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afd:	48 89 ce             	mov    %rcx,%rsi
  800b00:	89 d7                	mov    %edx,%edi
  800b02:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b04:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b08:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0c:	7f e3                	jg     800af1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0e:	eb 37                	jmp    800b47 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b14:	74 1e                	je     800b34 <vprintfmt+0x322>
  800b16:	83 fb 1f             	cmp    $0x1f,%ebx
  800b19:	7e 05                	jle    800b20 <vprintfmt+0x30e>
  800b1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1e:	7e 14                	jle    800b34 <vprintfmt+0x322>
					putch('?', putdat);
  800b20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b28:	48 89 d6             	mov    %rdx,%rsi
  800b2b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b30:	ff d0                	callq  *%rax
  800b32:	eb 0f                	jmp    800b43 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	48 89 d6             	mov    %rdx,%rsi
  800b3f:	89 df                	mov    %ebx,%edi
  800b41:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b43:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b47:	4c 89 e0             	mov    %r12,%rax
  800b4a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b4e:	0f b6 00             	movzbl (%rax),%eax
  800b51:	0f be d8             	movsbl %al,%ebx
  800b54:	85 db                	test   %ebx,%ebx
  800b56:	74 10                	je     800b68 <vprintfmt+0x356>
  800b58:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b5c:	78 b2                	js     800b10 <vprintfmt+0x2fe>
  800b5e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b62:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b66:	79 a8                	jns    800b10 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b68:	eb 16                	jmp    800b80 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b72:	48 89 d6             	mov    %rdx,%rsi
  800b75:	bf 20 00 00 00       	mov    $0x20,%edi
  800b7a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b80:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b84:	7f e4                	jg     800b6a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b86:	e9 a3 01 00 00       	jmpq   800d2e <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b8b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b8f:	be 03 00 00 00       	mov    $0x3,%esi
  800b94:	48 89 c7             	mov    %rax,%rdi
  800b97:	48 b8 02 07 80 00 00 	movabs $0x800702,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
  800ba3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bab:	48 85 c0             	test   %rax,%rax
  800bae:	79 1d                	jns    800bcd <vprintfmt+0x3bb>
				putch('-', putdat);
  800bb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb8:	48 89 d6             	mov    %rdx,%rsi
  800bbb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bc0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc6:	48 f7 d8             	neg    %rax
  800bc9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bcd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bd4:	e9 e8 00 00 00       	jmpq   800cc1 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bd9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdd:	be 03 00 00 00       	mov    $0x3,%esi
  800be2:	48 89 c7             	mov    %rax,%rdi
  800be5:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  800bec:	00 00 00 
  800bef:	ff d0                	callq  *%rax
  800bf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bf5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bfc:	e9 c0 00 00 00       	jmpq   800cc1 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c09:	48 89 d6             	mov    %rdx,%rsi
  800c0c:	bf 58 00 00 00       	mov    $0x58,%edi
  800c11:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1b:	48 89 d6             	mov    %rdx,%rsi
  800c1e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c23:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2d:	48 89 d6             	mov    %rdx,%rsi
  800c30:	bf 58 00 00 00       	mov    $0x58,%edi
  800c35:	ff d0                	callq  *%rax
			break;
  800c37:	e9 f2 00 00 00       	jmpq   800d2e <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c44:	48 89 d6             	mov    %rdx,%rsi
  800c47:	bf 30 00 00 00       	mov    $0x30,%edi
  800c4c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c56:	48 89 d6             	mov    %rdx,%rsi
  800c59:	bf 78 00 00 00       	mov    $0x78,%edi
  800c5e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c63:	83 f8 30             	cmp    $0x30,%eax
  800c66:	73 17                	jae    800c7f <vprintfmt+0x46d>
  800c68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6f:	89 c0                	mov    %eax,%eax
  800c71:	48 01 d0             	add    %rdx,%rax
  800c74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c77:	83 c2 08             	add    $0x8,%edx
  800c7a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7d:	eb 0f                	jmp    800c8e <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800c7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c83:	48 89 d0             	mov    %rdx,%rax
  800c86:	48 83 c2 08          	add    $0x8,%rdx
  800c8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c8e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c95:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c9c:	eb 23                	jmp    800cc1 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c9e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ca2:	be 03 00 00 00       	mov    $0x3,%esi
  800ca7:	48 89 c7             	mov    %rax,%rdi
  800caa:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  800cb1:	00 00 00 
  800cb4:	ff d0                	callq  *%rax
  800cb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cc6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cc9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ccc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd8:	45 89 c1             	mov    %r8d,%r9d
  800cdb:	41 89 f8             	mov    %edi,%r8d
  800cde:	48 89 c7             	mov    %rax,%rdi
  800ce1:	48 b8 37 05 80 00 00 	movabs $0x800537,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	callq  *%rax
			break;
  800ced:	eb 3f                	jmp    800d2e <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf7:	48 89 d6             	mov    %rdx,%rsi
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	ff d0                	callq  *%rax
			break;
  800cfe:	eb 2e                	jmp    800d2e <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d08:	48 89 d6             	mov    %rdx,%rsi
  800d0b:	bf 25 00 00 00       	mov    $0x25,%edi
  800d10:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d12:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d17:	eb 05                	jmp    800d1e <vprintfmt+0x50c>
  800d19:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d1e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d22:	48 83 e8 01          	sub    $0x1,%rax
  800d26:	0f b6 00             	movzbl (%rax),%eax
  800d29:	3c 25                	cmp    $0x25,%al
  800d2b:	75 ec                	jne    800d19 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d2d:	90                   	nop
		}
	}
  800d2e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2f:	e9 30 fb ff ff       	jmpq   800864 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d34:	48 83 c4 60          	add    $0x60,%rsp
  800d38:	5b                   	pop    %rbx
  800d39:	41 5c                	pop    %r12
  800d3b:	5d                   	pop    %rbp
  800d3c:	c3                   	retq   

0000000000800d3d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d3d:	55                   	push   %rbp
  800d3e:	48 89 e5             	mov    %rsp,%rbp
  800d41:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d48:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d4f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6b:	84 c0                	test   %al,%al
  800d6d:	74 20                	je     800d8f <printfmt+0x52>
  800d6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d8f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d96:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d9d:	00 00 00 
  800da0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800da7:	00 00 00 
  800daa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800db5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dbc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dca:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dd1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dd8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ddf:	48 89 c7             	mov    %rax,%rdi
  800de2:	48 b8 12 08 80 00 00 	movabs $0x800812,%rax
  800de9:	00 00 00 
  800dec:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dee:	c9                   	leaveq 
  800def:	c3                   	retq   

0000000000800df0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df0:	55                   	push   %rbp
  800df1:	48 89 e5             	mov    %rsp,%rbp
  800df4:	48 83 ec 10          	sub    $0x10,%rsp
  800df8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e03:	8b 40 10             	mov    0x10(%rax),%eax
  800e06:	8d 50 01             	lea    0x1(%rax),%edx
  800e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e14:	48 8b 10             	mov    (%rax),%rdx
  800e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e1f:	48 39 c2             	cmp    %rax,%rdx
  800e22:	73 17                	jae    800e3b <sprintputch+0x4b>
		*b->buf++ = ch;
  800e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e28:	48 8b 00             	mov    (%rax),%rax
  800e2b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e33:	48 89 0a             	mov    %rcx,(%rdx)
  800e36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e39:	88 10                	mov    %dl,(%rax)
}
  800e3b:	c9                   	leaveq 
  800e3c:	c3                   	retq   

0000000000800e3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e3d:	55                   	push   %rbp
  800e3e:	48 89 e5             	mov    %rsp,%rbp
  800e41:	48 83 ec 50          	sub    $0x50,%rsp
  800e45:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e49:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e4c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e50:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e54:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e58:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e5c:	48 8b 0a             	mov    (%rdx),%rcx
  800e5f:	48 89 08             	mov    %rcx,(%rax)
  800e62:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e66:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e6a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e6e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e7a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e7d:	48 98                	cltq   
  800e7f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e87:	48 01 d0             	add    %rdx,%rax
  800e8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e95:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e9a:	74 06                	je     800ea2 <vsnprintf+0x65>
  800e9c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ea0:	7f 07                	jg     800ea9 <vsnprintf+0x6c>
		return -E_INVAL;
  800ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea7:	eb 2f                	jmp    800ed8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ea9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ead:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eb1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eb5:	48 89 c6             	mov    %rax,%rsi
  800eb8:	48 bf f0 0d 80 00 00 	movabs $0x800df0,%rdi
  800ebf:	00 00 00 
  800ec2:	48 b8 12 08 80 00 00 	movabs $0x800812,%rax
  800ec9:	00 00 00 
  800ecc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ece:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ed2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ed5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ed8:	c9                   	leaveq 
  800ed9:	c3                   	retq   

0000000000800eda <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eda:	55                   	push   %rbp
  800edb:	48 89 e5             	mov    %rsp,%rbp
  800ede:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ee5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800eec:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ef2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ef9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f00:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f07:	84 c0                	test   %al,%al
  800f09:	74 20                	je     800f2b <snprintf+0x51>
  800f0b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f0f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f13:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f17:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f1b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f1f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f23:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f27:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f2b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f32:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f39:	00 00 00 
  800f3c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f43:	00 00 00 
  800f46:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f4a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f51:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f58:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f5f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f66:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f6d:	48 8b 0a             	mov    (%rdx),%rcx
  800f70:	48 89 08             	mov    %rcx,(%rax)
  800f73:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f77:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f7b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f83:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f8a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f91:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f97:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f9e:	48 89 c7             	mov    %rax,%rdi
  800fa1:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  800fa8:	00 00 00 
  800fab:	ff d0                	callq  *%rax
  800fad:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fb3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fb9:	c9                   	leaveq 
  800fba:	c3                   	retq   

0000000000800fbb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fbb:	55                   	push   %rbp
  800fbc:	48 89 e5             	mov    %rsp,%rbp
  800fbf:	48 83 ec 18          	sub    $0x18,%rsp
  800fc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fce:	eb 09                	jmp    800fd9 <strlen+0x1e>
		n++;
  800fd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdd:	0f b6 00             	movzbl (%rax),%eax
  800fe0:	84 c0                	test   %al,%al
  800fe2:	75 ec                	jne    800fd0 <strlen+0x15>
		n++;
	return n;
  800fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fe7:	c9                   	leaveq 
  800fe8:	c3                   	retq   

0000000000800fe9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe9:	55                   	push   %rbp
  800fea:	48 89 e5             	mov    %rsp,%rbp
  800fed:	48 83 ec 20          	sub    $0x20,%rsp
  800ff1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801000:	eb 0e                	jmp    801010 <strnlen+0x27>
		n++;
  801002:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801006:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80100b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801010:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801015:	74 0b                	je     801022 <strnlen+0x39>
  801017:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101b:	0f b6 00             	movzbl (%rax),%eax
  80101e:	84 c0                	test   %al,%al
  801020:	75 e0                	jne    801002 <strnlen+0x19>
		n++;
	return n;
  801022:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 83 ec 20          	sub    $0x20,%rsp
  80102f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801033:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801037:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80103f:	90                   	nop
  801040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801044:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801048:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80104c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801050:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801054:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801058:	0f b6 12             	movzbl (%rdx),%edx
  80105b:	88 10                	mov    %dl,(%rax)
  80105d:	0f b6 00             	movzbl (%rax),%eax
  801060:	84 c0                	test   %al,%al
  801062:	75 dc                	jne    801040 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801068:	c9                   	leaveq 
  801069:	c3                   	retq   

000000000080106a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80106a:	55                   	push   %rbp
  80106b:	48 89 e5             	mov    %rsp,%rbp
  80106e:	48 83 ec 20          	sub    $0x20,%rsp
  801072:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801076:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	48 89 c7             	mov    %rax,%rdi
  801081:	48 b8 bb 0f 80 00 00 	movabs $0x800fbb,%rax
  801088:	00 00 00 
  80108b:	ff d0                	callq  *%rax
  80108d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801093:	48 63 d0             	movslq %eax,%rdx
  801096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109a:	48 01 c2             	add    %rax,%rdx
  80109d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a1:	48 89 c6             	mov    %rax,%rsi
  8010a4:	48 89 d7             	mov    %rdx,%rdi
  8010a7:	48 b8 27 10 80 00 00 	movabs $0x801027,%rax
  8010ae:	00 00 00 
  8010b1:	ff d0                	callq  *%rax
	return dst;
  8010b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010b7:	c9                   	leaveq 
  8010b8:	c3                   	retq   

00000000008010b9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010b9:	55                   	push   %rbp
  8010ba:	48 89 e5             	mov    %rsp,%rbp
  8010bd:	48 83 ec 28          	sub    $0x28,%rsp
  8010c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010d5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010dc:	00 
  8010dd:	eb 2a                	jmp    801109 <strncpy+0x50>
		*dst++ = *src;
  8010df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010eb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ef:	0f b6 12             	movzbl (%rdx),%edx
  8010f2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f8:	0f b6 00             	movzbl (%rax),%eax
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 05                	je     801104 <strncpy+0x4b>
			src++;
  8010ff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801104:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801111:	72 cc                	jb     8010df <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801117:	c9                   	leaveq 
  801118:	c3                   	retq   

0000000000801119 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801119:	55                   	push   %rbp
  80111a:	48 89 e5             	mov    %rsp,%rbp
  80111d:	48 83 ec 28          	sub    $0x28,%rsp
  801121:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801125:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801129:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80112d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801131:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801135:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80113a:	74 3d                	je     801179 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80113c:	eb 1d                	jmp    80115b <strlcpy+0x42>
			*dst++ = *src++;
  80113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801142:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801146:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80114a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80114e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801152:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801156:	0f b6 12             	movzbl (%rdx),%edx
  801159:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80115b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801160:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801165:	74 0b                	je     801172 <strlcpy+0x59>
  801167:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116b:	0f b6 00             	movzbl (%rax),%eax
  80116e:	84 c0                	test   %al,%al
  801170:	75 cc                	jne    80113e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801176:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801179:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	48 29 c2             	sub    %rax,%rdx
  801184:	48 89 d0             	mov    %rdx,%rax
}
  801187:	c9                   	leaveq 
  801188:	c3                   	retq   

0000000000801189 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	48 83 ec 10          	sub    $0x10,%rsp
  801191:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801195:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801199:	eb 0a                	jmp    8011a5 <strcmp+0x1c>
		p++, q++;
  80119b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a9:	0f b6 00             	movzbl (%rax),%eax
  8011ac:	84 c0                	test   %al,%al
  8011ae:	74 12                	je     8011c2 <strcmp+0x39>
  8011b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b4:	0f b6 10             	movzbl (%rax),%edx
  8011b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	38 c2                	cmp    %al,%dl
  8011c0:	74 d9                	je     80119b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c6:	0f b6 00             	movzbl (%rax),%eax
  8011c9:	0f b6 d0             	movzbl %al,%edx
  8011cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d0:	0f b6 00             	movzbl (%rax),%eax
  8011d3:	0f b6 c0             	movzbl %al,%eax
  8011d6:	29 c2                	sub    %eax,%edx
  8011d8:	89 d0                	mov    %edx,%eax
}
  8011da:	c9                   	leaveq 
  8011db:	c3                   	retq   

00000000008011dc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	48 83 ec 18          	sub    $0x18,%rsp
  8011e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011f0:	eb 0f                	jmp    801201 <strncmp+0x25>
		n--, p++, q++;
  8011f2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801201:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801206:	74 1d                	je     801225 <strncmp+0x49>
  801208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	84 c0                	test   %al,%al
  801211:	74 12                	je     801225 <strncmp+0x49>
  801213:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801217:	0f b6 10             	movzbl (%rax),%edx
  80121a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121e:	0f b6 00             	movzbl (%rax),%eax
  801221:	38 c2                	cmp    %al,%dl
  801223:	74 cd                	je     8011f2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801225:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80122a:	75 07                	jne    801233 <strncmp+0x57>
		return 0;
  80122c:	b8 00 00 00 00       	mov    $0x0,%eax
  801231:	eb 18                	jmp    80124b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801233:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801237:	0f b6 00             	movzbl (%rax),%eax
  80123a:	0f b6 d0             	movzbl %al,%edx
  80123d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801241:	0f b6 00             	movzbl (%rax),%eax
  801244:	0f b6 c0             	movzbl %al,%eax
  801247:	29 c2                	sub    %eax,%edx
  801249:	89 d0                	mov    %edx,%eax
}
  80124b:	c9                   	leaveq 
  80124c:	c3                   	retq   

000000000080124d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80124d:	55                   	push   %rbp
  80124e:	48 89 e5             	mov    %rsp,%rbp
  801251:	48 83 ec 0c          	sub    $0xc,%rsp
  801255:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801259:	89 f0                	mov    %esi,%eax
  80125b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80125e:	eb 17                	jmp    801277 <strchr+0x2a>
		if (*s == c)
  801260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801264:	0f b6 00             	movzbl (%rax),%eax
  801267:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80126a:	75 06                	jne    801272 <strchr+0x25>
			return (char *) s;
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	eb 15                	jmp    801287 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801272:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127b:	0f b6 00             	movzbl (%rax),%eax
  80127e:	84 c0                	test   %al,%al
  801280:	75 de                	jne    801260 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801287:	c9                   	leaveq 
  801288:	c3                   	retq   

0000000000801289 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801289:	55                   	push   %rbp
  80128a:	48 89 e5             	mov    %rsp,%rbp
  80128d:	48 83 ec 0c          	sub    $0xc,%rsp
  801291:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801295:	89 f0                	mov    %esi,%eax
  801297:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80129a:	eb 13                	jmp    8012af <strfind+0x26>
		if (*s == c)
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a6:	75 02                	jne    8012aa <strfind+0x21>
			break;
  8012a8:	eb 10                	jmp    8012ba <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	0f b6 00             	movzbl (%rax),%eax
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e2                	jne    80129c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012be:	c9                   	leaveq 
  8012bf:	c3                   	retq   

00000000008012c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012c0:	55                   	push   %rbp
  8012c1:	48 89 e5             	mov    %rsp,%rbp
  8012c4:	48 83 ec 18          	sub    $0x18,%rsp
  8012c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d8:	75 06                	jne    8012e0 <memset+0x20>
		return v;
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	eb 69                	jmp    801349 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e4:	83 e0 03             	and    $0x3,%eax
  8012e7:	48 85 c0             	test   %rax,%rax
  8012ea:	75 48                	jne    801334 <memset+0x74>
  8012ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f0:	83 e0 03             	and    $0x3,%eax
  8012f3:	48 85 c0             	test   %rax,%rax
  8012f6:	75 3c                	jne    801334 <memset+0x74>
		c &= 0xFF;
  8012f8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801302:	c1 e0 18             	shl    $0x18,%eax
  801305:	89 c2                	mov    %eax,%edx
  801307:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130a:	c1 e0 10             	shl    $0x10,%eax
  80130d:	09 c2                	or     %eax,%edx
  80130f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801312:	c1 e0 08             	shl    $0x8,%eax
  801315:	09 d0                	or     %edx,%eax
  801317:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80131a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131e:	48 c1 e8 02          	shr    $0x2,%rax
  801322:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801325:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	48 89 d7             	mov    %rdx,%rdi
  80132f:	fc                   	cld    
  801330:	f3 ab                	rep stos %eax,%es:(%rdi)
  801332:	eb 11                	jmp    801345 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801334:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801338:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80133f:	48 89 d7             	mov    %rdx,%rdi
  801342:	fc                   	cld    
  801343:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 28          	sub    $0x28,%rsp
  801353:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801357:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80135b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80135f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801363:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801373:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801377:	0f 83 88 00 00 00    	jae    801405 <memmove+0xba>
  80137d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801381:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801385:	48 01 d0             	add    %rdx,%rax
  801388:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80138c:	76 77                	jbe    801405 <memmove+0xba>
		s += n;
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80139e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a2:	83 e0 03             	and    $0x3,%eax
  8013a5:	48 85 c0             	test   %rax,%rax
  8013a8:	75 3b                	jne    8013e5 <memmove+0x9a>
  8013aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ae:	83 e0 03             	and    $0x3,%eax
  8013b1:	48 85 c0             	test   %rax,%rax
  8013b4:	75 2f                	jne    8013e5 <memmove+0x9a>
  8013b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ba:	83 e0 03             	and    $0x3,%eax
  8013bd:	48 85 c0             	test   %rax,%rax
  8013c0:	75 23                	jne    8013e5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c6:	48 83 e8 04          	sub    $0x4,%rax
  8013ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ce:	48 83 ea 04          	sub    $0x4,%rdx
  8013d2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013da:	48 89 c7             	mov    %rax,%rdi
  8013dd:	48 89 d6             	mov    %rdx,%rsi
  8013e0:	fd                   	std    
  8013e1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013e3:	eb 1d                	jmp    801402 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	48 89 d7             	mov    %rdx,%rdi
  8013fc:	48 89 c1             	mov    %rax,%rcx
  8013ff:	fd                   	std    
  801400:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801402:	fc                   	cld    
  801403:	eb 57                	jmp    80145c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	83 e0 03             	and    $0x3,%eax
  80140c:	48 85 c0             	test   %rax,%rax
  80140f:	75 36                	jne    801447 <memmove+0xfc>
  801411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801415:	83 e0 03             	and    $0x3,%eax
  801418:	48 85 c0             	test   %rax,%rax
  80141b:	75 2a                	jne    801447 <memmove+0xfc>
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	83 e0 03             	and    $0x3,%eax
  801424:	48 85 c0             	test   %rax,%rax
  801427:	75 1e                	jne    801447 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	48 c1 e8 02          	shr    $0x2,%rax
  801431:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143c:	48 89 c7             	mov    %rax,%rdi
  80143f:	48 89 d6             	mov    %rdx,%rsi
  801442:	fc                   	cld    
  801443:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801445:	eb 15                	jmp    80145c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801453:	48 89 c7             	mov    %rax,%rdi
  801456:	48 89 d6             	mov    %rdx,%rsi
  801459:	fc                   	cld    
  80145a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 83 ec 18          	sub    $0x18,%rsp
  80146a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80146e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801472:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801476:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80147a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80147e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801482:	48 89 ce             	mov    %rcx,%rsi
  801485:	48 89 c7             	mov    %rax,%rdi
  801488:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  80148f:	00 00 00 
  801492:	ff d0                	callq  *%rax
}
  801494:	c9                   	leaveq 
  801495:	c3                   	retq   

0000000000801496 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801496:	55                   	push   %rbp
  801497:	48 89 e5             	mov    %rsp,%rbp
  80149a:	48 83 ec 28          	sub    $0x28,%rsp
  80149e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014ba:	eb 36                	jmp    8014f2 <memcmp+0x5c>
		if (*s1 != *s2)
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	0f b6 10             	movzbl (%rax),%edx
  8014c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	38 c2                	cmp    %al,%dl
  8014cc:	74 1a                	je     8014e8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	0f b6 d0             	movzbl %al,%edx
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	0f b6 c0             	movzbl %al,%eax
  8014e2:	29 c2                	sub    %eax,%edx
  8014e4:	89 d0                	mov    %edx,%eax
  8014e6:	eb 20                	jmp    801508 <memcmp+0x72>
		s1++, s2++;
  8014e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014fe:	48 85 c0             	test   %rax,%rax
  801501:	75 b9                	jne    8014bc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801508:	c9                   	leaveq 
  801509:	c3                   	retq   

000000000080150a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80150a:	55                   	push   %rbp
  80150b:	48 89 e5             	mov    %rsp,%rbp
  80150e:	48 83 ec 28          	sub    $0x28,%rsp
  801512:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801516:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801519:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80151d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801521:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801525:	48 01 d0             	add    %rdx,%rax
  801528:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80152c:	eb 15                	jmp    801543 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80152e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801532:	0f b6 10             	movzbl (%rax),%edx
  801535:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801538:	38 c2                	cmp    %al,%dl
  80153a:	75 02                	jne    80153e <memfind+0x34>
			break;
  80153c:	eb 0f                	jmp    80154d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80153e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801547:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80154b:	72 e1                	jb     80152e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80154d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801551:	c9                   	leaveq 
  801552:	c3                   	retq   

0000000000801553 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	48 83 ec 34          	sub    $0x34,%rsp
  80155b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80155f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801563:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801566:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80156d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801574:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801575:	eb 05                	jmp    80157c <strtol+0x29>
		s++;
  801577:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	3c 20                	cmp    $0x20,%al
  801585:	74 f0                	je     801577 <strtol+0x24>
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	0f b6 00             	movzbl (%rax),%eax
  80158e:	3c 09                	cmp    $0x9,%al
  801590:	74 e5                	je     801577 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	3c 2b                	cmp    $0x2b,%al
  80159b:	75 07                	jne    8015a4 <strtol+0x51>
		s++;
  80159d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a2:	eb 17                	jmp    8015bb <strtol+0x68>
	else if (*s == '-')
  8015a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	3c 2d                	cmp    $0x2d,%al
  8015ad:	75 0c                	jne    8015bb <strtol+0x68>
		s++, neg = 1;
  8015af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015bf:	74 06                	je     8015c7 <strtol+0x74>
  8015c1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015c5:	75 28                	jne    8015ef <strtol+0x9c>
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3c 30                	cmp    $0x30,%al
  8015d0:	75 1d                	jne    8015ef <strtol+0x9c>
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	48 83 c0 01          	add    $0x1,%rax
  8015da:	0f b6 00             	movzbl (%rax),%eax
  8015dd:	3c 78                	cmp    $0x78,%al
  8015df:	75 0e                	jne    8015ef <strtol+0x9c>
		s += 2, base = 16;
  8015e1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015ed:	eb 2c                	jmp    80161b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f3:	75 19                	jne    80160e <strtol+0xbb>
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	3c 30                	cmp    $0x30,%al
  8015fe:	75 0e                	jne    80160e <strtol+0xbb>
		s++, base = 8;
  801600:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801605:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80160c:	eb 0d                	jmp    80161b <strtol+0xc8>
	else if (base == 0)
  80160e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801612:	75 07                	jne    80161b <strtol+0xc8>
		base = 10;
  801614:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 2f                	cmp    $0x2f,%al
  801624:	7e 1d                	jle    801643 <strtol+0xf0>
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 39                	cmp    $0x39,%al
  80162f:	7f 12                	jg     801643 <strtol+0xf0>
			dig = *s - '0';
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	0f be c0             	movsbl %al,%eax
  80163b:	83 e8 30             	sub    $0x30,%eax
  80163e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801641:	eb 4e                	jmp    801691 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 60                	cmp    $0x60,%al
  80164c:	7e 1d                	jle    80166b <strtol+0x118>
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	3c 7a                	cmp    $0x7a,%al
  801657:	7f 12                	jg     80166b <strtol+0x118>
			dig = *s - 'a' + 10;
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	0f be c0             	movsbl %al,%eax
  801663:	83 e8 57             	sub    $0x57,%eax
  801666:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801669:	eb 26                	jmp    801691 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 48                	jle    8016be <strtol+0x16b>
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	3c 5a                	cmp    $0x5a,%al
  80167f:	7f 3d                	jg     8016be <strtol+0x16b>
			dig = *s - 'A' + 10;
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	0f be c0             	movsbl %al,%eax
  80168b:	83 e8 37             	sub    $0x37,%eax
  80168e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801691:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801694:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801697:	7c 02                	jl     80169b <strtol+0x148>
			break;
  801699:	eb 23                	jmp    8016be <strtol+0x16b>
		s++, val = (val * base) + dig;
  80169b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016a3:	48 98                	cltq   
  8016a5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016aa:	48 89 c2             	mov    %rax,%rdx
  8016ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b0:	48 98                	cltq   
  8016b2:	48 01 d0             	add    %rdx,%rax
  8016b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b9:	e9 5d ff ff ff       	jmpq   80161b <strtol+0xc8>

	if (endptr)
  8016be:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016c3:	74 0b                	je     8016d0 <strtol+0x17d>
		*endptr = (char *) s;
  8016c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016cd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d4:	74 09                	je     8016df <strtol+0x18c>
  8016d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016da:	48 f7 d8             	neg    %rax
  8016dd:	eb 04                	jmp    8016e3 <strtol+0x190>
  8016df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016e3:	c9                   	leaveq 
  8016e4:	c3                   	retq   

00000000008016e5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016e5:	55                   	push   %rbp
  8016e6:	48 89 e5             	mov    %rsp,%rbp
  8016e9:	48 83 ec 30          	sub    $0x30,%rsp
  8016ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016fd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801707:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80170b:	75 06                	jne    801713 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	eb 6b                	jmp    80177e <strstr+0x99>

	len = strlen(str);
  801713:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801717:	48 89 c7             	mov    %rax,%rdi
  80171a:	48 b8 bb 0f 80 00 00 	movabs $0x800fbb,%rax
  801721:	00 00 00 
  801724:	ff d0                	callq  *%rax
  801726:	48 98                	cltq   
  801728:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801734:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80173e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801742:	75 07                	jne    80174b <strstr+0x66>
				return (char *) 0;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	eb 33                	jmp    80177e <strstr+0x99>
		} while (sc != c);
  80174b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80174f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801752:	75 d8                	jne    80172c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801754:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801758:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80175c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801760:	48 89 ce             	mov    %rcx,%rsi
  801763:	48 89 c7             	mov    %rax,%rdi
  801766:	48 b8 dc 11 80 00 00 	movabs $0x8011dc,%rax
  80176d:	00 00 00 
  801770:	ff d0                	callq  *%rax
  801772:	85 c0                	test   %eax,%eax
  801774:	75 b6                	jne    80172c <strstr+0x47>

	return (char *) (in - 1);
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	48 83 e8 01          	sub    $0x1,%rax
}
  80177e:	c9                   	leaveq 
  80177f:	c3                   	retq   

0000000000801780 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801780:	55                   	push   %rbp
  801781:	48 89 e5             	mov    %rsp,%rbp
  801784:	53                   	push   %rbx
  801785:	48 83 ec 48          	sub    $0x48,%rsp
  801789:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80178c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80178f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801793:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801797:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80179b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017a2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017aa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017ae:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017b2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b6:	4c 89 c3             	mov    %r8,%rbx
  8017b9:	cd 30                	int    $0x30
  8017bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017c3:	74 3e                	je     801803 <syscall+0x83>
  8017c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ca:	7e 37                	jle    801803 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d3:	49 89 d0             	mov    %rdx,%r8
  8017d6:	89 c1                	mov    %eax,%ecx
  8017d8:	48 ba 28 1e 80 00 00 	movabs $0x801e28,%rdx
  8017df:	00 00 00 
  8017e2:	be 23 00 00 00       	mov    $0x23,%esi
  8017e7:	48 bf 45 1e 80 00 00 	movabs $0x801e45,%rdi
  8017ee:	00 00 00 
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	49 b9 26 02 80 00 00 	movabs $0x800226,%r9
  8017fd:	00 00 00 
  801800:	41 ff d1             	callq  *%r9

	return ret;
  801803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801807:	48 83 c4 48          	add    $0x48,%rsp
  80180b:	5b                   	pop    %rbx
  80180c:	5d                   	pop    %rbp
  80180d:	c3                   	retq   

000000000080180e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
  801812:	48 83 ec 20          	sub    $0x20,%rsp
  801816:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80181e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801822:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801826:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182d:	00 
  80182e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801834:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183a:	48 89 d1             	mov    %rdx,%rcx
  80183d:	48 89 c2             	mov    %rax,%rdx
  801840:	be 00 00 00 00       	mov    $0x0,%esi
  801845:	bf 00 00 00 00       	mov    $0x0,%edi
  80184a:	48 b8 80 17 80 00 00 	movabs $0x801780,%rax
  801851:	00 00 00 
  801854:	ff d0                	callq  *%rax
}
  801856:	c9                   	leaveq 
  801857:	c3                   	retq   

0000000000801858 <sys_cgetc>:

int
sys_cgetc(void)
{
  801858:	55                   	push   %rbp
  801859:	48 89 e5             	mov    %rsp,%rbp
  80185c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801860:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801867:	00 
  801868:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801874:	b9 00 00 00 00       	mov    $0x0,%ecx
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
  80187e:	be 00 00 00 00       	mov    $0x0,%esi
  801883:	bf 01 00 00 00       	mov    $0x1,%edi
  801888:	48 b8 80 17 80 00 00 	movabs $0x801780,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
}
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 10          	sub    $0x10,%rsp
  80189e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a4:	48 98                	cltq   
  8018a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ad:	00 
  8018ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018bf:	48 89 c2             	mov    %rax,%rdx
  8018c2:	be 01 00 00 00       	mov    $0x1,%esi
  8018c7:	bf 03 00 00 00       	mov    $0x3,%edi
  8018cc:	48 b8 80 17 80 00 00 	movabs $0x801780,%rax
  8018d3:	00 00 00 
  8018d6:	ff d0                	callq  *%rax
}
  8018d8:	c9                   	leaveq 
  8018d9:	c3                   	retq   

00000000008018da <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018da:	55                   	push   %rbp
  8018db:	48 89 e5             	mov    %rsp,%rbp
  8018de:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e9:	00 
  8018ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801900:	be 00 00 00 00       	mov    $0x0,%esi
  801905:	bf 02 00 00 00       	mov    $0x2,%edi
  80190a:	48 b8 80 17 80 00 00 	movabs $0x801780,%rax
  801911:	00 00 00 
  801914:	ff d0                	callq  *%rax
}
  801916:	c9                   	leaveq 
  801917:	c3                   	retq   
