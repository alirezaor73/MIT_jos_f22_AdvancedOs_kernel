
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
  800052:	48 bf c0 1b 80 00 00 	movabs $0x801bc0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 90 04 80 00 00 	movabs $0x800490,%rdx
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
  800092:	48 ba e0 1b 80 00 00 	movabs $0x801be0,%rdx
  800099:	00 00 00 
  80009c:	be 11 00 00 00       	mov    $0x11,%esi
  8000a1:	48 bf fd 1b 80 00 00 	movabs $0x801bfd,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b8 57 02 80 00 00 	movabs $0x800257,%r8
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
  80011e:	48 ba 10 1c 80 00 00 	movabs $0x801c10,%rdx
  800125:	00 00 00 
  800128:	be 16 00 00 00       	mov    $0x16,%esi
  80012d:	48 bf fd 1b 80 00 00 	movabs $0x801bfd,%rdi
  800134:	00 00 00 
  800137:	b8 00 00 00 00       	mov    $0x0,%eax
  80013c:	49 b8 57 02 80 00 00 	movabs $0x800257,%r8
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
  800156:	48 bf 38 1c 80 00 00 	movabs $0x801c38,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 90 04 80 00 00 	movabs $0x800490,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
	bigarray[ARRAYSIZE+1024] = 0;
  800171:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800178:	00 00 00 
  80017b:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%rax)
  800182:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800185:	48 ba 6b 1c 80 00 00 	movabs $0x801c6b,%rdx
  80018c:	00 00 00 
  80018f:	be 1a 00 00 00       	mov    $0x1a,%esi
  800194:	48 bf fd 1b 80 00 00 	movabs $0x801bfd,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	48 b9 57 02 80 00 00 	movabs $0x800257,%rcx
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
  8001b3:	48 83 ec 20          	sub    $0x20,%rsp
  8001b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001be:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8001cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d5:	48 63 d0             	movslq %eax,%rdx
  8001d8:	48 89 d0             	mov    %rdx,%rax
  8001db:	48 c1 e0 03          	shl    $0x3,%rax
  8001df:	48 01 d0             	add    %rdx,%rax
  8001e2:	48 c1 e0 05          	shl    $0x5,%rax
  8001e6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001ed:	00 00 00 
  8001f0:	48 01 c2             	add    %rax,%rdx
  8001f3:	48 b8 20 30 c0 00 00 	movabs $0xc03020,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800204:	7e 14                	jle    80021a <libmain+0x6b>
		binaryname = argv[0];
  800206:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800214:	00 00 00 
  800217:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80021e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800221:	48 89 d6             	mov    %rdx,%rsi
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800232:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800244:	bf 00 00 00 00       	mov    $0x0,%edi
  800249:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
}
  800255:	5d                   	pop    %rbp
  800256:	c3                   	retq   

0000000000800257 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800257:	55                   	push   %rbp
  800258:	48 89 e5             	mov    %rsp,%rbp
  80025b:	53                   	push   %rbx
  80025c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800263:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80026a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800270:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800277:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80027e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800285:	84 c0                	test   %al,%al
  800287:	74 23                	je     8002ac <_panic+0x55>
  800289:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800290:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800294:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800298:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80029c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002a4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002a8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002ac:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002b3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002ba:	00 00 00 
  8002bd:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c4:	00 00 00 
  8002c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002cb:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002d2:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002e0:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002e7:	00 00 00 
  8002ea:	48 8b 18             	mov    (%rax),%rbx
  8002ed:	48 b8 0b 19 80 00 00 	movabs $0x80190b,%rax
  8002f4:	00 00 00 
  8002f7:	ff d0                	callq  *%rax
  8002f9:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002ff:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800306:	41 89 c8             	mov    %ecx,%r8d
  800309:	48 89 d1             	mov    %rdx,%rcx
  80030c:	48 89 da             	mov    %rbx,%rdx
  80030f:	89 c6                	mov    %eax,%esi
  800311:	48 bf 90 1c 80 00 00 	movabs $0x801c90,%rdi
  800318:	00 00 00 
  80031b:	b8 00 00 00 00       	mov    $0x0,%eax
  800320:	49 b9 90 04 80 00 00 	movabs $0x800490,%r9
  800327:	00 00 00 
  80032a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80032d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800334:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80033b:	48 89 d6             	mov    %rdx,%rsi
  80033e:	48 89 c7             	mov    %rax,%rdi
  800341:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  800348:	00 00 00 
  80034b:	ff d0                	callq  *%rax
	cprintf("\n");
  80034d:	48 bf b3 1c 80 00 00 	movabs $0x801cb3,%rdi
  800354:	00 00 00 
  800357:	b8 00 00 00 00       	mov    $0x0,%eax
  80035c:	48 ba 90 04 80 00 00 	movabs $0x800490,%rdx
  800363:	00 00 00 
  800366:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800368:	cc                   	int3   
  800369:	eb fd                	jmp    800368 <_panic+0x111>

000000000080036b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80036b:	55                   	push   %rbp
  80036c:	48 89 e5             	mov    %rsp,%rbp
  80036f:	48 83 ec 10          	sub    $0x10,%rsp
  800373:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800376:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80037a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037e:	8b 00                	mov    (%rax),%eax
  800380:	8d 48 01             	lea    0x1(%rax),%ecx
  800383:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800387:	89 0a                	mov    %ecx,(%rdx)
  800389:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80038c:	89 d1                	mov    %edx,%ecx
  80038e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800392:	48 98                	cltq   
  800394:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039c:	8b 00                	mov    (%rax),%eax
  80039e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a3:	75 2c                	jne    8003d1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a9:	8b 00                	mov    (%rax),%eax
  8003ab:	48 98                	cltq   
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	48 83 c2 08          	add    $0x8,%rdx
  8003b5:	48 89 c6             	mov    %rax,%rsi
  8003b8:	48 89 d7             	mov    %rdx,%rdi
  8003bb:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
        b->idx = 0;
  8003c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d5:	8b 40 04             	mov    0x4(%rax),%eax
  8003d8:	8d 50 01             	lea    0x1(%rax),%edx
  8003db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003df:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e2:	c9                   	leaveq 
  8003e3:	c3                   	retq   

00000000008003e4 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e4:	55                   	push   %rbp
  8003e5:	48 89 e5             	mov    %rsp,%rbp
  8003e8:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003ef:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003f6:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003fd:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800404:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80040b:	48 8b 0a             	mov    (%rdx),%rcx
  80040e:	48 89 08             	mov    %rcx,(%rax)
  800411:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800415:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800419:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80041d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800421:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800428:	00 00 00 
    b.cnt = 0;
  80042b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800432:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800435:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80043c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800443:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80044a:	48 89 c6             	mov    %rax,%rsi
  80044d:	48 bf 6b 03 80 00 00 	movabs $0x80036b,%rdi
  800454:	00 00 00 
  800457:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  80045e:	00 00 00 
  800461:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800463:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800469:	48 98                	cltq   
  80046b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800472:	48 83 c2 08          	add    $0x8,%rdx
  800476:	48 89 c6             	mov    %rax,%rsi
  800479:	48 89 d7             	mov    %rdx,%rdi
  80047c:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  800483:	00 00 00 
  800486:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800488:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80048e:	c9                   	leaveq 
  80048f:	c3                   	retq   

0000000000800490 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800490:	55                   	push   %rbp
  800491:	48 89 e5             	mov    %rsp,%rbp
  800494:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80049b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004a9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004b7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004be:	84 c0                	test   %al,%al
  8004c0:	74 20                	je     8004e2 <cprintf+0x52>
  8004c2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004c6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004d6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004da:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004de:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004e2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004e9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004f0:	00 00 00 
  8004f3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004fa:	00 00 00 
  8004fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800501:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800508:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80050f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800516:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80051d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800524:	48 8b 0a             	mov    (%rdx),%rcx
  800527:	48 89 08             	mov    %rcx,(%rax)
  80052a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80052e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800532:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800536:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80053a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800541:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800548:	48 89 d6             	mov    %rdx,%rsi
  80054b:	48 89 c7             	mov    %rax,%rdi
  80054e:	48 b8 e4 03 80 00 00 	movabs $0x8003e4,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800560:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800566:	c9                   	leaveq 
  800567:	c3                   	retq   

0000000000800568 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800568:	55                   	push   %rbp
  800569:	48 89 e5             	mov    %rsp,%rbp
  80056c:	53                   	push   %rbx
  80056d:	48 83 ec 38          	sub    $0x38,%rsp
  800571:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800575:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800579:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80057d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800580:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800584:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800588:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80058b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80058f:	77 3b                	ja     8005cc <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800591:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800594:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800598:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80059b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	48 f7 f3             	div    %rbx
  8005a7:	48 89 c2             	mov    %rax,%rdx
  8005aa:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005ad:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005b0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	41 89 f9             	mov    %edi,%r9d
  8005bb:	48 89 c7             	mov    %rax,%rdi
  8005be:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  8005c5:	00 00 00 
  8005c8:	ff d0                	callq  *%rax
  8005ca:	eb 1e                	jmp    8005ea <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005cc:	eb 12                	jmp    8005e0 <printnum+0x78>
			putch(padc, putdat);
  8005ce:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005d2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d9:	48 89 ce             	mov    %rcx,%rsi
  8005dc:	89 d7                	mov    %edx,%edi
  8005de:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e0:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005e8:	7f e4                	jg     8005ce <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f6:	48 f7 f1             	div    %rcx
  8005f9:	48 89 d0             	mov    %rdx,%rax
  8005fc:	48 ba 10 1e 80 00 00 	movabs $0x801e10,%rdx
  800603:	00 00 00 
  800606:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80060a:	0f be d0             	movsbl %al,%edx
  80060d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	48 89 ce             	mov    %rcx,%rsi
  800618:	89 d7                	mov    %edx,%edi
  80061a:	ff d0                	callq  *%rax
}
  80061c:	48 83 c4 38          	add    $0x38,%rsp
  800620:	5b                   	pop    %rbx
  800621:	5d                   	pop    %rbp
  800622:	c3                   	retq   

0000000000800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %rbp
  800624:	48 89 e5             	mov    %rsp,%rbp
  800627:	48 83 ec 1c          	sub    $0x1c,%rsp
  80062b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80062f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800632:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800636:	7e 52                	jle    80068a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	83 f8 30             	cmp    $0x30,%eax
  800641:	73 24                	jae    800667 <getuint+0x44>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	89 c0                	mov    %eax,%eax
  800653:	48 01 d0             	add    %rdx,%rax
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	8b 12                	mov    (%rdx),%edx
  80065c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800663:	89 0a                	mov    %ecx,(%rdx)
  800665:	eb 17                	jmp    80067e <getuint+0x5b>
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066f:	48 89 d0             	mov    %rdx,%rax
  800672:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067e:	48 8b 00             	mov    (%rax),%rax
  800681:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800685:	e9 a3 00 00 00       	jmpq   80072d <getuint+0x10a>
	else if (lflag)
  80068a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80068e:	74 4f                	je     8006df <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800694:	8b 00                	mov    (%rax),%eax
  800696:	83 f8 30             	cmp    $0x30,%eax
  800699:	73 24                	jae    8006bf <getuint+0x9c>
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	8b 00                	mov    (%rax),%eax
  8006a9:	89 c0                	mov    %eax,%eax
  8006ab:	48 01 d0             	add    %rdx,%rax
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	8b 12                	mov    (%rdx),%edx
  8006b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	89 0a                	mov    %ecx,(%rdx)
  8006bd:	eb 17                	jmp    8006d6 <getuint+0xb3>
  8006bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c7:	48 89 d0             	mov    %rdx,%rax
  8006ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d6:	48 8b 00             	mov    (%rax),%rax
  8006d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006dd:	eb 4e                	jmp    80072d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	83 f8 30             	cmp    $0x30,%eax
  8006e8:	73 24                	jae    80070e <getuint+0xeb>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	8b 00                	mov    (%rax),%eax
  8006f8:	89 c0                	mov    %eax,%eax
  8006fa:	48 01 d0             	add    %rdx,%rax
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	8b 12                	mov    (%rdx),%edx
  800703:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070a:	89 0a                	mov    %ecx,(%rdx)
  80070c:	eb 17                	jmp    800725 <getuint+0x102>
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800716:	48 89 d0             	mov    %rdx,%rax
  800719:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800725:	8b 00                	mov    (%rax),%eax
  800727:	89 c0                	mov    %eax,%eax
  800729:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80072d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800731:	c9                   	leaveq 
  800732:	c3                   	retq   

0000000000800733 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800733:	55                   	push   %rbp
  800734:	48 89 e5             	mov    %rsp,%rbp
  800737:	48 83 ec 1c          	sub    $0x1c,%rsp
  80073b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80073f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800742:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800746:	7e 52                	jle    80079a <getint+0x67>
		x=va_arg(*ap, long long);
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	83 f8 30             	cmp    $0x30,%eax
  800751:	73 24                	jae    800777 <getint+0x44>
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	8b 00                	mov    (%rax),%eax
  800761:	89 c0                	mov    %eax,%eax
  800763:	48 01 d0             	add    %rdx,%rax
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	8b 12                	mov    (%rdx),%edx
  80076c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80076f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800773:	89 0a                	mov    %ecx,(%rdx)
  800775:	eb 17                	jmp    80078e <getint+0x5b>
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80077f:	48 89 d0             	mov    %rdx,%rax
  800782:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80078e:	48 8b 00             	mov    (%rax),%rax
  800791:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800795:	e9 a3 00 00 00       	jmpq   80083d <getint+0x10a>
	else if (lflag)
  80079a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80079e:	74 4f                	je     8007ef <getint+0xbc>
		x=va_arg(*ap, long);
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	8b 00                	mov    (%rax),%eax
  8007a6:	83 f8 30             	cmp    $0x30,%eax
  8007a9:	73 24                	jae    8007cf <getint+0x9c>
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	8b 00                	mov    (%rax),%eax
  8007b9:	89 c0                	mov    %eax,%eax
  8007bb:	48 01 d0             	add    %rdx,%rax
  8007be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c2:	8b 12                	mov    (%rdx),%edx
  8007c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cb:	89 0a                	mov    %ecx,(%rdx)
  8007cd:	eb 17                	jmp    8007e6 <getint+0xb3>
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d7:	48 89 d0             	mov    %rdx,%rax
  8007da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e6:	48 8b 00             	mov    (%rax),%rax
  8007e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ed:	eb 4e                	jmp    80083d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	8b 00                	mov    (%rax),%eax
  8007f5:	83 f8 30             	cmp    $0x30,%eax
  8007f8:	73 24                	jae    80081e <getint+0xeb>
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	8b 00                	mov    (%rax),%eax
  800808:	89 c0                	mov    %eax,%eax
  80080a:	48 01 d0             	add    %rdx,%rax
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	8b 12                	mov    (%rdx),%edx
  800813:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800816:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081a:	89 0a                	mov    %ecx,(%rdx)
  80081c:	eb 17                	jmp    800835 <getint+0x102>
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800826:	48 89 d0             	mov    %rdx,%rax
  800829:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800835:	8b 00                	mov    (%rax),%eax
  800837:	48 98                	cltq   
  800839:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80083d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800841:	c9                   	leaveq 
  800842:	c3                   	retq   

0000000000800843 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800843:	55                   	push   %rbp
  800844:	48 89 e5             	mov    %rsp,%rbp
  800847:	41 54                	push   %r12
  800849:	53                   	push   %rbx
  80084a:	48 83 ec 60          	sub    $0x60,%rsp
  80084e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800852:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800856:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80085e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800862:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800866:	48 8b 0a             	mov    (%rdx),%rcx
  800869:	48 89 08             	mov    %rcx,(%rax)
  80086c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800870:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800874:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800878:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087c:	eb 17                	jmp    800895 <vprintfmt+0x52>
			if (ch == '\0')
  80087e:	85 db                	test   %ebx,%ebx
  800880:	0f 84 df 04 00 00    	je     800d65 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800886:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80088a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088e:	48 89 d6             	mov    %rdx,%rsi
  800891:	89 df                	mov    %ebx,%edi
  800893:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800895:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800899:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80089d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a1:	0f b6 00             	movzbl (%rax),%eax
  8008a4:	0f b6 d8             	movzbl %al,%ebx
  8008a7:	83 fb 25             	cmp    $0x25,%ebx
  8008aa:	75 d2                	jne    80087e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ac:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d8:	0f b6 00             	movzbl (%rax),%eax
  8008db:	0f b6 d8             	movzbl %al,%ebx
  8008de:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008e1:	83 f8 55             	cmp    $0x55,%eax
  8008e4:	0f 87 47 04 00 00    	ja     800d31 <vprintfmt+0x4ee>
  8008ea:	89 c0                	mov    %eax,%eax
  8008ec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008f3:	00 
  8008f4:	48 b8 38 1e 80 00 00 	movabs $0x801e38,%rax
  8008fb:	00 00 00 
  8008fe:	48 01 d0             	add    %rdx,%rax
  800901:	48 8b 00             	mov    (%rax),%rax
  800904:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800906:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80090a:	eb c0                	jmp    8008cc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80090c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800910:	eb ba                	jmp    8008cc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800912:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800919:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80091c:	89 d0                	mov    %edx,%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	01 d0                	add    %edx,%eax
  800923:	01 c0                	add    %eax,%eax
  800925:	01 d8                	add    %ebx,%eax
  800927:	83 e8 30             	sub    $0x30,%eax
  80092a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80092d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800931:	0f b6 00             	movzbl (%rax),%eax
  800934:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800937:	83 fb 2f             	cmp    $0x2f,%ebx
  80093a:	7e 0c                	jle    800948 <vprintfmt+0x105>
  80093c:	83 fb 39             	cmp    $0x39,%ebx
  80093f:	7f 07                	jg     800948 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800941:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800946:	eb d1                	jmp    800919 <vprintfmt+0xd6>
			goto process_precision;
  800948:	eb 58                	jmp    8009a2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80094a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 17                	jae    800969 <vprintfmt+0x126>
  800952:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	89 c0                	mov    %eax,%eax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800961:	83 c2 08             	add    $0x8,%edx
  800964:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800967:	eb 0f                	jmp    800978 <vprintfmt+0x135>
  800969:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096d:	48 89 d0             	mov    %rdx,%rax
  800970:	48 83 c2 08          	add    $0x8,%rdx
  800974:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80097d:	eb 23                	jmp    8009a2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80097f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800983:	79 0c                	jns    800991 <vprintfmt+0x14e>
				width = 0;
  800985:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80098c:	e9 3b ff ff ff       	jmpq   8008cc <vprintfmt+0x89>
  800991:	e9 36 ff ff ff       	jmpq   8008cc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800996:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80099d:	e9 2a ff ff ff       	jmpq   8008cc <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a6:	79 12                	jns    8009ba <vprintfmt+0x177>
				width = precision, precision = -1;
  8009a8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009ab:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009b5:	e9 12 ff ff ff       	jmpq   8008cc <vprintfmt+0x89>
  8009ba:	e9 0d ff ff ff       	jmpq   8008cc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009bf:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009c3:	e9 04 ff ff ff       	jmpq   8008cc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cb:	83 f8 30             	cmp    $0x30,%eax
  8009ce:	73 17                	jae    8009e7 <vprintfmt+0x1a4>
  8009d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d7:	89 c0                	mov    %eax,%eax
  8009d9:	48 01 d0             	add    %rdx,%rax
  8009dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009df:	83 c2 08             	add    $0x8,%edx
  8009e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e5:	eb 0f                	jmp    8009f6 <vprintfmt+0x1b3>
  8009e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009eb:	48 89 d0             	mov    %rdx,%rax
  8009ee:	48 83 c2 08          	add    $0x8,%rdx
  8009f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f6:	8b 10                	mov    (%rax),%edx
  8009f8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a00:	48 89 ce             	mov    %rcx,%rsi
  800a03:	89 d7                	mov    %edx,%edi
  800a05:	ff d0                	callq  *%rax
			break;
  800a07:	e9 53 03 00 00       	jmpq   800d5f <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0f:	83 f8 30             	cmp    $0x30,%eax
  800a12:	73 17                	jae    800a2b <vprintfmt+0x1e8>
  800a14:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1b:	89 c0                	mov    %eax,%eax
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a23:	83 c2 08             	add    $0x8,%edx
  800a26:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a29:	eb 0f                	jmp    800a3a <vprintfmt+0x1f7>
  800a2b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2f:	48 89 d0             	mov    %rdx,%rax
  800a32:	48 83 c2 08          	add    $0x8,%rdx
  800a36:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a3a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a3c:	85 db                	test   %ebx,%ebx
  800a3e:	79 02                	jns    800a42 <vprintfmt+0x1ff>
				err = -err;
  800a40:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a42:	83 fb 15             	cmp    $0x15,%ebx
  800a45:	7f 16                	jg     800a5d <vprintfmt+0x21a>
  800a47:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  800a4e:	00 00 00 
  800a51:	48 63 d3             	movslq %ebx,%rdx
  800a54:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a58:	4d 85 e4             	test   %r12,%r12
  800a5b:	75 2e                	jne    800a8b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a5d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a65:	89 d9                	mov    %ebx,%ecx
  800a67:	48 ba 21 1e 80 00 00 	movabs $0x801e21,%rdx
  800a6e:	00 00 00 
  800a71:	48 89 c7             	mov    %rax,%rdi
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b8 6e 0d 80 00 00 	movabs $0x800d6e,%r8
  800a80:	00 00 00 
  800a83:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a86:	e9 d4 02 00 00       	jmpq   800d5f <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a93:	4c 89 e1             	mov    %r12,%rcx
  800a96:	48 ba 2a 1e 80 00 00 	movabs $0x801e2a,%rdx
  800a9d:	00 00 00 
  800aa0:	48 89 c7             	mov    %rax,%rdi
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	49 b8 6e 0d 80 00 00 	movabs $0x800d6e,%r8
  800aaf:	00 00 00 
  800ab2:	41 ff d0             	callq  *%r8
			break;
  800ab5:	e9 a5 02 00 00       	jmpq   800d5f <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abd:	83 f8 30             	cmp    $0x30,%eax
  800ac0:	73 17                	jae    800ad9 <vprintfmt+0x296>
  800ac2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	89 c0                	mov    %eax,%eax
  800acb:	48 01 d0             	add    %rdx,%rax
  800ace:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad1:	83 c2 08             	add    $0x8,%edx
  800ad4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad7:	eb 0f                	jmp    800ae8 <vprintfmt+0x2a5>
  800ad9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800add:	48 89 d0             	mov    %rdx,%rax
  800ae0:	48 83 c2 08          	add    $0x8,%rdx
  800ae4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae8:	4c 8b 20             	mov    (%rax),%r12
  800aeb:	4d 85 e4             	test   %r12,%r12
  800aee:	75 0a                	jne    800afa <vprintfmt+0x2b7>
				p = "(null)";
  800af0:	49 bc 2d 1e 80 00 00 	movabs $0x801e2d,%r12
  800af7:	00 00 00 
			if (width > 0 && padc != '-')
  800afa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800afe:	7e 3f                	jle    800b3f <vprintfmt+0x2fc>
  800b00:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b04:	74 39                	je     800b3f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b06:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b09:	48 98                	cltq   
  800b0b:	48 89 c6             	mov    %rax,%rsi
  800b0e:	4c 89 e7             	mov    %r12,%rdi
  800b11:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  800b18:	00 00 00 
  800b1b:	ff d0                	callq  *%rax
  800b1d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b20:	eb 17                	jmp    800b39 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b22:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b26:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2e:	48 89 ce             	mov    %rcx,%rsi
  800b31:	89 d7                	mov    %edx,%edi
  800b33:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3d:	7f e3                	jg     800b22 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3f:	eb 37                	jmp    800b78 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b45:	74 1e                	je     800b65 <vprintfmt+0x322>
  800b47:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4a:	7e 05                	jle    800b51 <vprintfmt+0x30e>
  800b4c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4f:	7e 14                	jle    800b65 <vprintfmt+0x322>
					putch('?', putdat);
  800b51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b59:	48 89 d6             	mov    %rdx,%rsi
  800b5c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b61:	ff d0                	callq  *%rax
  800b63:	eb 0f                	jmp    800b74 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b65:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6d:	48 89 d6             	mov    %rdx,%rsi
  800b70:	89 df                	mov    %ebx,%edi
  800b72:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b74:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b78:	4c 89 e0             	mov    %r12,%rax
  800b7b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b7f:	0f b6 00             	movzbl (%rax),%eax
  800b82:	0f be d8             	movsbl %al,%ebx
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	74 10                	je     800b99 <vprintfmt+0x356>
  800b89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b8d:	78 b2                	js     800b41 <vprintfmt+0x2fe>
  800b8f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b93:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b97:	79 a8                	jns    800b41 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b99:	eb 16                	jmp    800bb1 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba3:	48 89 d6             	mov    %rdx,%rsi
  800ba6:	bf 20 00 00 00       	mov    $0x20,%edi
  800bab:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bad:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb5:	7f e4                	jg     800b9b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bb7:	e9 a3 01 00 00       	jmpq   800d5f <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc0:	be 03 00 00 00       	mov    $0x3,%esi
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 33 07 80 00 00 	movabs $0x800733,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
  800bd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	48 85 c0             	test   %rax,%rax
  800bdf:	79 1d                	jns    800bfe <vprintfmt+0x3bb>
				putch('-', putdat);
  800be1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bf1:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf7:	48 f7 d8             	neg    %rax
  800bfa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bfe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c05:	e9 e8 00 00 00       	jmpq   800cf2 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c0e:	be 03 00 00 00       	mov    $0x3,%esi
  800c13:	48 89 c7             	mov    %rax,%rdi
  800c16:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  800c1d:	00 00 00 
  800c20:	ff d0                	callq  *%rax
  800c22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c2d:	e9 c0 00 00 00       	jmpq   800cf2 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3a:	48 89 d6             	mov    %rdx,%rsi
  800c3d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c42:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	48 89 d6             	mov    %rdx,%rsi
  800c4f:	bf 58 00 00 00       	mov    $0x58,%edi
  800c54:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 58 00 00 00       	mov    $0x58,%edi
  800c66:	ff d0                	callq  *%rax
			break;
  800c68:	e9 f2 00 00 00       	jmpq   800d5f <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c75:	48 89 d6             	mov    %rdx,%rsi
  800c78:	bf 30 00 00 00       	mov    $0x30,%edi
  800c7d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c87:	48 89 d6             	mov    %rdx,%rsi
  800c8a:	bf 78 00 00 00       	mov    $0x78,%edi
  800c8f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c94:	83 f8 30             	cmp    $0x30,%eax
  800c97:	73 17                	jae    800cb0 <vprintfmt+0x46d>
  800c99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca0:	89 c0                	mov    %eax,%eax
  800ca2:	48 01 d0             	add    %rdx,%rax
  800ca5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca8:	83 c2 08             	add    $0x8,%edx
  800cab:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cae:	eb 0f                	jmp    800cbf <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cb0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb4:	48 89 d0             	mov    %rdx,%rax
  800cb7:	48 83 c2 08          	add    $0x8,%rdx
  800cbb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbf:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cc6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ccd:	eb 23                	jmp    800cf2 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ccf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd3:	be 03 00 00 00       	mov    $0x3,%esi
  800cd8:	48 89 c7             	mov    %rax,%rdi
  800cdb:	48 b8 23 06 80 00 00 	movabs $0x800623,%rax
  800ce2:	00 00 00 
  800ce5:	ff d0                	callq  *%rax
  800ce7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ceb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cf7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cfa:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cfd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d01:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d09:	45 89 c1             	mov    %r8d,%r9d
  800d0c:	41 89 f8             	mov    %edi,%r8d
  800d0f:	48 89 c7             	mov    %rax,%rdi
  800d12:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	callq  *%rax
			break;
  800d1e:	eb 3f                	jmp    800d5f <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d28:	48 89 d6             	mov    %rdx,%rsi
  800d2b:	89 df                	mov    %ebx,%edi
  800d2d:	ff d0                	callq  *%rax
			break;
  800d2f:	eb 2e                	jmp    800d5f <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d39:	48 89 d6             	mov    %rdx,%rsi
  800d3c:	bf 25 00 00 00       	mov    $0x25,%edi
  800d41:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d43:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d48:	eb 05                	jmp    800d4f <vprintfmt+0x50c>
  800d4a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d53:	48 83 e8 01          	sub    $0x1,%rax
  800d57:	0f b6 00             	movzbl (%rax),%eax
  800d5a:	3c 25                	cmp    $0x25,%al
  800d5c:	75 ec                	jne    800d4a <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d5e:	90                   	nop
		}
	}
  800d5f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d60:	e9 30 fb ff ff       	jmpq   800895 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d65:	48 83 c4 60          	add    $0x60,%rsp
  800d69:	5b                   	pop    %rbx
  800d6a:	41 5c                	pop    %r12
  800d6c:	5d                   	pop    %rbp
  800d6d:	c3                   	retq   

0000000000800d6e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6e:	55                   	push   %rbp
  800d6f:	48 89 e5             	mov    %rsp,%rbp
  800d72:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d79:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d80:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d87:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d8e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d95:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d9c:	84 c0                	test   %al,%al
  800d9e:	74 20                	je     800dc0 <printfmt+0x52>
  800da0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800da4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800da8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dac:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800db0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800db4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800db8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dbc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dc0:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dc7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dce:	00 00 00 
  800dd1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dd8:	00 00 00 
  800ddb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ddf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800de6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ded:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800df4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dfb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e02:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e09:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e10:	48 89 c7             	mov    %rax,%rdi
  800e13:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  800e1a:	00 00 00 
  800e1d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e1f:	c9                   	leaveq 
  800e20:	c3                   	retq   

0000000000800e21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e21:	55                   	push   %rbp
  800e22:	48 89 e5             	mov    %rsp,%rbp
  800e25:	48 83 ec 10          	sub    $0x10,%rsp
  800e29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e34:	8b 40 10             	mov    0x10(%rax),%eax
  800e37:	8d 50 01             	lea    0x1(%rax),%edx
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e45:	48 8b 10             	mov    (%rax),%rdx
  800e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e50:	48 39 c2             	cmp    %rax,%rdx
  800e53:	73 17                	jae    800e6c <sprintputch+0x4b>
		*b->buf++ = ch;
  800e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e59:	48 8b 00             	mov    (%rax),%rax
  800e5c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e64:	48 89 0a             	mov    %rcx,(%rdx)
  800e67:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e6a:	88 10                	mov    %dl,(%rax)
}
  800e6c:	c9                   	leaveq 
  800e6d:	c3                   	retq   

0000000000800e6e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e6e:	55                   	push   %rbp
  800e6f:	48 89 e5             	mov    %rsp,%rbp
  800e72:	48 83 ec 50          	sub    $0x50,%rsp
  800e76:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e7a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e7d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e81:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e85:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e89:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e8d:	48 8b 0a             	mov    (%rdx),%rcx
  800e90:	48 89 08             	mov    %rcx,(%rax)
  800e93:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e97:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e9b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e9f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eab:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eae:	48 98                	cltq   
  800eb0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eb4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb8:	48 01 d0             	add    %rdx,%rax
  800ebb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ebf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ec6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ecb:	74 06                	je     800ed3 <vsnprintf+0x65>
  800ecd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ed1:	7f 07                	jg     800eda <vsnprintf+0x6c>
		return -E_INVAL;
  800ed3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed8:	eb 2f                	jmp    800f09 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eda:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ede:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ee2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ee6:	48 89 c6             	mov    %rax,%rsi
  800ee9:	48 bf 21 0e 80 00 00 	movabs $0x800e21,%rdi
  800ef0:	00 00 00 
  800ef3:	48 b8 43 08 80 00 00 	movabs $0x800843,%rax
  800efa:	00 00 00 
  800efd:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f03:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f06:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f09:	c9                   	leaveq 
  800f0a:	c3                   	retq   

0000000000800f0b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f0b:	55                   	push   %rbp
  800f0c:	48 89 e5             	mov    %rsp,%rbp
  800f0f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f16:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f1d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f23:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f31:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f38:	84 c0                	test   %al,%al
  800f3a:	74 20                	je     800f5c <snprintf+0x51>
  800f3c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f40:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f44:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f48:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f4c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f50:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f54:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f58:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f5c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f63:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f6a:	00 00 00 
  800f6d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f74:	00 00 00 
  800f77:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f7b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f82:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f89:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f90:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f97:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f9e:	48 8b 0a             	mov    (%rdx),%rcx
  800fa1:	48 89 08             	mov    %rcx,(%rax)
  800fa4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fa8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fb4:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fbb:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fc2:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fc8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fcf:	48 89 c7             	mov    %rax,%rdi
  800fd2:	48 b8 6e 0e 80 00 00 	movabs $0x800e6e,%rax
  800fd9:	00 00 00 
  800fdc:	ff d0                	callq  *%rax
  800fde:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fe4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fea:	c9                   	leaveq 
  800feb:	c3                   	retq   

0000000000800fec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fec:	55                   	push   %rbp
  800fed:	48 89 e5             	mov    %rsp,%rbp
  800ff0:	48 83 ec 18          	sub    $0x18,%rsp
  800ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fff:	eb 09                	jmp    80100a <strlen+0x1e>
		n++;
  801001:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801005:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80100a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100e:	0f b6 00             	movzbl (%rax),%eax
  801011:	84 c0                	test   %al,%al
  801013:	75 ec                	jne    801001 <strlen+0x15>
		n++;
	return n;
  801015:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801018:	c9                   	leaveq 
  801019:	c3                   	retq   

000000000080101a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80101a:	55                   	push   %rbp
  80101b:	48 89 e5             	mov    %rsp,%rbp
  80101e:	48 83 ec 20          	sub    $0x20,%rsp
  801022:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801026:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801031:	eb 0e                	jmp    801041 <strnlen+0x27>
		n++;
  801033:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801037:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80103c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801041:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801046:	74 0b                	je     801053 <strnlen+0x39>
  801048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104c:	0f b6 00             	movzbl (%rax),%eax
  80104f:	84 c0                	test   %al,%al
  801051:	75 e0                	jne    801033 <strnlen+0x19>
		n++;
	return n;
  801053:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801056:	c9                   	leaveq 
  801057:	c3                   	retq   

0000000000801058 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801058:	55                   	push   %rbp
  801059:	48 89 e5             	mov    %rsp,%rbp
  80105c:	48 83 ec 20          	sub    $0x20,%rsp
  801060:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801064:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801070:	90                   	nop
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801079:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80107d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801081:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801085:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801089:	0f b6 12             	movzbl (%rdx),%edx
  80108c:	88 10                	mov    %dl,(%rax)
  80108e:	0f b6 00             	movzbl (%rax),%eax
  801091:	84 c0                	test   %al,%al
  801093:	75 dc                	jne    801071 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801095:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801099:	c9                   	leaveq 
  80109a:	c3                   	retq   

000000000080109b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80109b:	55                   	push   %rbp
  80109c:	48 89 e5             	mov    %rsp,%rbp
  80109f:	48 83 ec 20          	sub    $0x20,%rsp
  8010a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 89 c7             	mov    %rax,%rdi
  8010b2:	48 b8 ec 0f 80 00 00 	movabs $0x800fec,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	callq  *%rax
  8010be:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c4:	48 63 d0             	movslq %eax,%rdx
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	48 01 c2             	add    %rax,%rdx
  8010ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d2:	48 89 c6             	mov    %rax,%rsi
  8010d5:	48 89 d7             	mov    %rdx,%rdi
  8010d8:	48 b8 58 10 80 00 00 	movabs $0x801058,%rax
  8010df:	00 00 00 
  8010e2:	ff d0                	callq  *%rax
	return dst;
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010e8:	c9                   	leaveq 
  8010e9:	c3                   	retq   

00000000008010ea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010ea:	55                   	push   %rbp
  8010eb:	48 89 e5             	mov    %rsp,%rbp
  8010ee:	48 83 ec 28          	sub    $0x28,%rsp
  8010f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801106:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80110d:	00 
  80110e:	eb 2a                	jmp    80113a <strncpy+0x50>
		*dst++ = *src;
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801118:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80111c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801120:	0f b6 12             	movzbl (%rdx),%edx
  801123:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801125:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801129:	0f b6 00             	movzbl (%rax),%eax
  80112c:	84 c0                	test   %al,%al
  80112e:	74 05                	je     801135 <strncpy+0x4b>
			src++;
  801130:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801135:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801142:	72 cc                	jb     801110 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801148:	c9                   	leaveq 
  801149:	c3                   	retq   

000000000080114a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80114a:	55                   	push   %rbp
  80114b:	48 89 e5             	mov    %rsp,%rbp
  80114e:	48 83 ec 28          	sub    $0x28,%rsp
  801152:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801156:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80115e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801162:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801166:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80116b:	74 3d                	je     8011aa <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80116d:	eb 1d                	jmp    80118c <strlcpy+0x42>
			*dst++ = *src++;
  80116f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801173:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801177:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80117b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80117f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801183:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801187:	0f b6 12             	movzbl (%rdx),%edx
  80118a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80118c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801191:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801196:	74 0b                	je     8011a3 <strlcpy+0x59>
  801198:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119c:	0f b6 00             	movzbl (%rax),%eax
  80119f:	84 c0                	test   %al,%al
  8011a1:	75 cc                	jne    80116f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b2:	48 29 c2             	sub    %rax,%rdx
  8011b5:	48 89 d0             	mov    %rdx,%rax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 10          	sub    $0x10,%rsp
  8011c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ca:	eb 0a                	jmp    8011d6 <strcmp+0x1c>
		p++, q++;
  8011cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011da:	0f b6 00             	movzbl (%rax),%eax
  8011dd:	84 c0                	test   %al,%al
  8011df:	74 12                	je     8011f3 <strcmp+0x39>
  8011e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e5:	0f b6 10             	movzbl (%rax),%edx
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	38 c2                	cmp    %al,%dl
  8011f1:	74 d9                	je     8011cc <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f7:	0f b6 00             	movzbl (%rax),%eax
  8011fa:	0f b6 d0             	movzbl %al,%edx
  8011fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	0f b6 c0             	movzbl %al,%eax
  801207:	29 c2                	sub    %eax,%edx
  801209:	89 d0                	mov    %edx,%eax
}
  80120b:	c9                   	leaveq 
  80120c:	c3                   	retq   

000000000080120d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80120d:	55                   	push   %rbp
  80120e:	48 89 e5             	mov    %rsp,%rbp
  801211:	48 83 ec 18          	sub    $0x18,%rsp
  801215:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801219:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80121d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801221:	eb 0f                	jmp    801232 <strncmp+0x25>
		n--, p++, q++;
  801223:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801228:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80122d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801232:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801237:	74 1d                	je     801256 <strncmp+0x49>
  801239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	84 c0                	test   %al,%al
  801242:	74 12                	je     801256 <strncmp+0x49>
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	0f b6 10             	movzbl (%rax),%edx
  80124b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	38 c2                	cmp    %al,%dl
  801254:	74 cd                	je     801223 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801256:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80125b:	75 07                	jne    801264 <strncmp+0x57>
		return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
  801262:	eb 18                	jmp    80127c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	0f b6 00             	movzbl (%rax),%eax
  80126b:	0f b6 d0             	movzbl %al,%edx
  80126e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801272:	0f b6 00             	movzbl (%rax),%eax
  801275:	0f b6 c0             	movzbl %al,%eax
  801278:	29 c2                	sub    %eax,%edx
  80127a:	89 d0                	mov    %edx,%eax
}
  80127c:	c9                   	leaveq 
  80127d:	c3                   	retq   

000000000080127e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80127e:	55                   	push   %rbp
  80127f:	48 89 e5             	mov    %rsp,%rbp
  801282:	48 83 ec 0c          	sub    $0xc,%rsp
  801286:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128a:	89 f0                	mov    %esi,%eax
  80128c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80128f:	eb 17                	jmp    8012a8 <strchr+0x2a>
		if (*s == c)
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80129b:	75 06                	jne    8012a3 <strchr+0x25>
			return (char *) s;
  80129d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a1:	eb 15                	jmp    8012b8 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ac:	0f b6 00             	movzbl (%rax),%eax
  8012af:	84 c0                	test   %al,%al
  8012b1:	75 de                	jne    801291 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b8:	c9                   	leaveq 
  8012b9:	c3                   	retq   

00000000008012ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012ba:	55                   	push   %rbp
  8012bb:	48 89 e5             	mov    %rsp,%rbp
  8012be:	48 83 ec 0c          	sub    $0xc,%rsp
  8012c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c6:	89 f0                	mov    %esi,%eax
  8012c8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012cb:	eb 13                	jmp    8012e0 <strfind+0x26>
		if (*s == c)
  8012cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d7:	75 02                	jne    8012db <strfind+0x21>
			break;
  8012d9:	eb 10                	jmp    8012eb <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e4:	0f b6 00             	movzbl (%rax),%eax
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 e2                	jne    8012cd <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ef:	c9                   	leaveq 
  8012f0:	c3                   	retq   

00000000008012f1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f1:	55                   	push   %rbp
  8012f2:	48 89 e5             	mov    %rsp,%rbp
  8012f5:	48 83 ec 18          	sub    $0x18,%rsp
  8012f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fd:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801300:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801304:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801309:	75 06                	jne    801311 <memset+0x20>
		return v;
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	eb 69                	jmp    80137a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801315:	83 e0 03             	and    $0x3,%eax
  801318:	48 85 c0             	test   %rax,%rax
  80131b:	75 48                	jne    801365 <memset+0x74>
  80131d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801321:	83 e0 03             	and    $0x3,%eax
  801324:	48 85 c0             	test   %rax,%rax
  801327:	75 3c                	jne    801365 <memset+0x74>
		c &= 0xFF;
  801329:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801330:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801333:	c1 e0 18             	shl    $0x18,%eax
  801336:	89 c2                	mov    %eax,%edx
  801338:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133b:	c1 e0 10             	shl    $0x10,%eax
  80133e:	09 c2                	or     %eax,%edx
  801340:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801343:	c1 e0 08             	shl    $0x8,%eax
  801346:	09 d0                	or     %edx,%eax
  801348:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	48 c1 e8 02          	shr    $0x2,%rax
  801353:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801356:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135d:	48 89 d7             	mov    %rdx,%rdi
  801360:	fc                   	cld    
  801361:	f3 ab                	rep stos %eax,%es:(%rdi)
  801363:	eb 11                	jmp    801376 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801365:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801369:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801370:	48 89 d7             	mov    %rdx,%rdi
  801373:	fc                   	cld    
  801374:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137a:	c9                   	leaveq 
  80137b:	c3                   	retq   

000000000080137c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80137c:	55                   	push   %rbp
  80137d:	48 89 e5             	mov    %rsp,%rbp
  801380:	48 83 ec 28          	sub    $0x28,%rsp
  801384:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801388:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80138c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801390:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801394:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a8:	0f 83 88 00 00 00    	jae    801436 <memmove+0xba>
  8013ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b6:	48 01 d0             	add    %rdx,%rax
  8013b9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013bd:	76 77                	jbe    801436 <memmove+0xba>
		s += n;
  8013bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cb:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d3:	83 e0 03             	and    $0x3,%eax
  8013d6:	48 85 c0             	test   %rax,%rax
  8013d9:	75 3b                	jne    801416 <memmove+0x9a>
  8013db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013df:	83 e0 03             	and    $0x3,%eax
  8013e2:	48 85 c0             	test   %rax,%rax
  8013e5:	75 2f                	jne    801416 <memmove+0x9a>
  8013e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013eb:	83 e0 03             	and    $0x3,%eax
  8013ee:	48 85 c0             	test   %rax,%rax
  8013f1:	75 23                	jne    801416 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f7:	48 83 e8 04          	sub    $0x4,%rax
  8013fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ff:	48 83 ea 04          	sub    $0x4,%rdx
  801403:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801407:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80140b:	48 89 c7             	mov    %rax,%rdi
  80140e:	48 89 d6             	mov    %rdx,%rsi
  801411:	fd                   	std    
  801412:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801414:	eb 1d                	jmp    801433 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80141e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801422:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142a:	48 89 d7             	mov    %rdx,%rdi
  80142d:	48 89 c1             	mov    %rax,%rcx
  801430:	fd                   	std    
  801431:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801433:	fc                   	cld    
  801434:	eb 57                	jmp    80148d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143a:	83 e0 03             	and    $0x3,%eax
  80143d:	48 85 c0             	test   %rax,%rax
  801440:	75 36                	jne    801478 <memmove+0xfc>
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	83 e0 03             	and    $0x3,%eax
  801449:	48 85 c0             	test   %rax,%rax
  80144c:	75 2a                	jne    801478 <memmove+0xfc>
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	83 e0 03             	and    $0x3,%eax
  801455:	48 85 c0             	test   %rax,%rax
  801458:	75 1e                	jne    801478 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80145a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145e:	48 c1 e8 02          	shr    $0x2,%rax
  801462:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801469:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146d:	48 89 c7             	mov    %rax,%rdi
  801470:	48 89 d6             	mov    %rdx,%rsi
  801473:	fc                   	cld    
  801474:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801476:	eb 15                	jmp    80148d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801480:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801484:	48 89 c7             	mov    %rax,%rdi
  801487:	48 89 d6             	mov    %rdx,%rsi
  80148a:	fc                   	cld    
  80148b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80148d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801491:	c9                   	leaveq 
  801492:	c3                   	retq   

0000000000801493 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	48 83 ec 18          	sub    $0x18,%rsp
  80149b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ab:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b3:	48 89 ce             	mov    %rcx,%rsi
  8014b6:	48 89 c7             	mov    %rax,%rdi
  8014b9:	48 b8 7c 13 80 00 00 	movabs $0x80137c,%rax
  8014c0:	00 00 00 
  8014c3:	ff d0                	callq  *%rax
}
  8014c5:	c9                   	leaveq 
  8014c6:	c3                   	retq   

00000000008014c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c7:	55                   	push   %rbp
  8014c8:	48 89 e5             	mov    %rsp,%rbp
  8014cb:	48 83 ec 28          	sub    $0x28,%rsp
  8014cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014eb:	eb 36                	jmp    801523 <memcmp+0x5c>
		if (*s1 != *s2)
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	0f b6 10             	movzbl (%rax),%edx
  8014f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	38 c2                	cmp    %al,%dl
  8014fd:	74 1a                	je     801519 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	0f b6 d0             	movzbl %al,%edx
  801509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	0f b6 c0             	movzbl %al,%eax
  801513:	29 c2                	sub    %eax,%edx
  801515:	89 d0                	mov    %edx,%eax
  801517:	eb 20                	jmp    801539 <memcmp+0x72>
		s1++, s2++;
  801519:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80152b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80152f:	48 85 c0             	test   %rax,%rax
  801532:	75 b9                	jne    8014ed <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801534:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801539:	c9                   	leaveq 
  80153a:	c3                   	retq   

000000000080153b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80153b:	55                   	push   %rbp
  80153c:	48 89 e5             	mov    %rsp,%rbp
  80153f:	48 83 ec 28          	sub    $0x28,%rsp
  801543:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801547:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80154a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801556:	48 01 d0             	add    %rdx,%rax
  801559:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80155d:	eb 15                	jmp    801574 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801563:	0f b6 10             	movzbl (%rax),%edx
  801566:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801569:	38 c2                	cmp    %al,%dl
  80156b:	75 02                	jne    80156f <memfind+0x34>
			break;
  80156d:	eb 0f                	jmp    80157e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80156f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801578:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80157c:	72 e1                	jb     80155f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801582:	c9                   	leaveq 
  801583:	c3                   	retq   

0000000000801584 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801584:	55                   	push   %rbp
  801585:	48 89 e5             	mov    %rsp,%rbp
  801588:	48 83 ec 34          	sub    $0x34,%rsp
  80158c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801590:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801594:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80159e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015a5:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a6:	eb 05                	jmp    8015ad <strtol+0x29>
		s++;
  8015a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	3c 20                	cmp    $0x20,%al
  8015b6:	74 f0                	je     8015a8 <strtol+0x24>
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	0f b6 00             	movzbl (%rax),%eax
  8015bf:	3c 09                	cmp    $0x9,%al
  8015c1:	74 e5                	je     8015a8 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	3c 2b                	cmp    $0x2b,%al
  8015cc:	75 07                	jne    8015d5 <strtol+0x51>
		s++;
  8015ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d3:	eb 17                	jmp    8015ec <strtol+0x68>
	else if (*s == '-')
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	3c 2d                	cmp    $0x2d,%al
  8015de:	75 0c                	jne    8015ec <strtol+0x68>
		s++, neg = 1;
  8015e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f0:	74 06                	je     8015f8 <strtol+0x74>
  8015f2:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015f6:	75 28                	jne    801620 <strtol+0x9c>
  8015f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 1d                	jne    801620 <strtol+0x9c>
  801603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801607:	48 83 c0 01          	add    $0x1,%rax
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	3c 78                	cmp    $0x78,%al
  801610:	75 0e                	jne    801620 <strtol+0x9c>
		s += 2, base = 16;
  801612:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801617:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80161e:	eb 2c                	jmp    80164c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801620:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801624:	75 19                	jne    80163f <strtol+0xbb>
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 30                	cmp    $0x30,%al
  80162f:	75 0e                	jne    80163f <strtol+0xbb>
		s++, base = 8;
  801631:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801636:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80163d:	eb 0d                	jmp    80164c <strtol+0xc8>
	else if (base == 0)
  80163f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801643:	75 07                	jne    80164c <strtol+0xc8>
		base = 10;
  801645:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	3c 2f                	cmp    $0x2f,%al
  801655:	7e 1d                	jle    801674 <strtol+0xf0>
  801657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165b:	0f b6 00             	movzbl (%rax),%eax
  80165e:	3c 39                	cmp    $0x39,%al
  801660:	7f 12                	jg     801674 <strtol+0xf0>
			dig = *s - '0';
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	0f be c0             	movsbl %al,%eax
  80166c:	83 e8 30             	sub    $0x30,%eax
  80166f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801672:	eb 4e                	jmp    8016c2 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	3c 60                	cmp    $0x60,%al
  80167d:	7e 1d                	jle    80169c <strtol+0x118>
  80167f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801683:	0f b6 00             	movzbl (%rax),%eax
  801686:	3c 7a                	cmp    $0x7a,%al
  801688:	7f 12                	jg     80169c <strtol+0x118>
			dig = *s - 'a' + 10;
  80168a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168e:	0f b6 00             	movzbl (%rax),%eax
  801691:	0f be c0             	movsbl %al,%eax
  801694:	83 e8 57             	sub    $0x57,%eax
  801697:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169a:	eb 26                	jmp    8016c2 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	3c 40                	cmp    $0x40,%al
  8016a5:	7e 48                	jle    8016ef <strtol+0x16b>
  8016a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ab:	0f b6 00             	movzbl (%rax),%eax
  8016ae:	3c 5a                	cmp    $0x5a,%al
  8016b0:	7f 3d                	jg     8016ef <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b6:	0f b6 00             	movzbl (%rax),%eax
  8016b9:	0f be c0             	movsbl %al,%eax
  8016bc:	83 e8 37             	sub    $0x37,%eax
  8016bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c5:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016c8:	7c 02                	jl     8016cc <strtol+0x148>
			break;
  8016ca:	eb 23                	jmp    8016ef <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016cc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016d4:	48 98                	cltq   
  8016d6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016db:	48 89 c2             	mov    %rax,%rdx
  8016de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e1:	48 98                	cltq   
  8016e3:	48 01 d0             	add    %rdx,%rax
  8016e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016ea:	e9 5d ff ff ff       	jmpq   80164c <strtol+0xc8>

	if (endptr)
  8016ef:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016f4:	74 0b                	je     801701 <strtol+0x17d>
		*endptr = (char *) s;
  8016f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016fe:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801705:	74 09                	je     801710 <strtol+0x18c>
  801707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170b:	48 f7 d8             	neg    %rax
  80170e:	eb 04                	jmp    801714 <strtol+0x190>
  801710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801714:	c9                   	leaveq 
  801715:	c3                   	retq   

0000000000801716 <strstr>:

char * strstr(const char *in, const char *str)
{
  801716:	55                   	push   %rbp
  801717:	48 89 e5             	mov    %rsp,%rbp
  80171a:	48 83 ec 30          	sub    $0x30,%rsp
  80171e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801722:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801726:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80172e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801732:	0f b6 00             	movzbl (%rax),%eax
  801735:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801738:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80173c:	75 06                	jne    801744 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	eb 6b                	jmp    8017af <strstr+0x99>

	len = strlen(str);
  801744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801748:	48 89 c7             	mov    %rax,%rdi
  80174b:	48 b8 ec 0f 80 00 00 	movabs $0x800fec,%rax
  801752:	00 00 00 
  801755:	ff d0                	callq  *%rax
  801757:	48 98                	cltq   
  801759:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801765:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801769:	0f b6 00             	movzbl (%rax),%eax
  80176c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80176f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801773:	75 07                	jne    80177c <strstr+0x66>
				return (char *) 0;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 33                	jmp    8017af <strstr+0x99>
		} while (sc != c);
  80177c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801780:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801783:	75 d8                	jne    80175d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801785:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801789:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801791:	48 89 ce             	mov    %rcx,%rsi
  801794:	48 89 c7             	mov    %rax,%rdi
  801797:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  80179e:	00 00 00 
  8017a1:	ff d0                	callq  *%rax
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	75 b6                	jne    80175d <strstr+0x47>

	return (char *) (in - 1);
  8017a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ab:	48 83 e8 01          	sub    $0x1,%rax
}
  8017af:	c9                   	leaveq 
  8017b0:	c3                   	retq   

00000000008017b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017b1:	55                   	push   %rbp
  8017b2:	48 89 e5             	mov    %rsp,%rbp
  8017b5:	53                   	push   %rbx
  8017b6:	48 83 ec 48          	sub    $0x48,%rsp
  8017ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017bd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017c0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017c4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017c8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017cc:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017d7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017db:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017df:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017e3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017e7:	4c 89 c3             	mov    %r8,%rbx
  8017ea:	cd 30                	int    $0x30
  8017ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017f4:	74 3e                	je     801834 <syscall+0x83>
  8017f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017fb:	7e 37                	jle    801834 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801801:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801804:	49 89 d0             	mov    %rdx,%r8
  801807:	89 c1                	mov    %eax,%ecx
  801809:	48 ba e8 20 80 00 00 	movabs $0x8020e8,%rdx
  801810:	00 00 00 
  801813:	be 23 00 00 00       	mov    $0x23,%esi
  801818:	48 bf 05 21 80 00 00 	movabs $0x802105,%rdi
  80181f:	00 00 00 
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	49 b9 57 02 80 00 00 	movabs $0x800257,%r9
  80182e:	00 00 00 
  801831:	41 ff d1             	callq  *%r9

	return ret;
  801834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801838:	48 83 c4 48          	add    $0x48,%rsp
  80183c:	5b                   	pop    %rbx
  80183d:	5d                   	pop    %rbp
  80183e:	c3                   	retq   

000000000080183f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 20          	sub    $0x20,%rsp
  801847:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80184b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80184f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801853:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801857:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185e:	00 
  80185f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801865:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186b:	48 89 d1             	mov    %rdx,%rcx
  80186e:	48 89 c2             	mov    %rax,%rdx
  801871:	be 00 00 00 00       	mov    $0x0,%esi
  801876:	bf 00 00 00 00       	mov    $0x0,%edi
  80187b:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
}
  801887:	c9                   	leaveq 
  801888:	c3                   	retq   

0000000000801889 <sys_cgetc>:

int
sys_cgetc(void)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801891:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801898:	00 
  801899:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018af:	be 00 00 00 00       	mov    $0x0,%esi
  8018b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b9:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 10          	sub    $0x10,%rsp
  8018cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d5:	48 98                	cltq   
  8018d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018de:	00 
  8018df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f0:	48 89 c2             	mov    %rax,%rdx
  8018f3:	be 01 00 00 00       	mov    $0x1,%esi
  8018f8:	bf 03 00 00 00       	mov    $0x3,%edi
  8018fd:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801904:	00 00 00 
  801907:	ff d0                	callq  *%rax
}
  801909:	c9                   	leaveq 
  80190a:	c3                   	retq   

000000000080190b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80190b:	55                   	push   %rbp
  80190c:	48 89 e5             	mov    %rsp,%rbp
  80190f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801913:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191a:	00 
  80191b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801921:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801927:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192c:	ba 00 00 00 00       	mov    $0x0,%edx
  801931:	be 00 00 00 00       	mov    $0x0,%esi
  801936:	bf 02 00 00 00       	mov    $0x2,%edi
  80193b:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801942:	00 00 00 
  801945:	ff d0                	callq  *%rax
}
  801947:	c9                   	leaveq 
  801948:	c3                   	retq   

0000000000801949 <sys_yield>:

void
sys_yield(void)
{
  801949:	55                   	push   %rbp
  80194a:	48 89 e5             	mov    %rsp,%rbp
  80194d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801951:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801958:	00 
  801959:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801965:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196a:	ba 00 00 00 00       	mov    $0x0,%edx
  80196f:	be 00 00 00 00       	mov    $0x0,%esi
  801974:	bf 0a 00 00 00       	mov    $0xa,%edi
  801979:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801980:	00 00 00 
  801983:	ff d0                	callq  *%rax
}
  801985:	c9                   	leaveq 
  801986:	c3                   	retq   

0000000000801987 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801987:	55                   	push   %rbp
  801988:	48 89 e5             	mov    %rsp,%rbp
  80198b:	48 83 ec 20          	sub    $0x20,%rsp
  80198f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801992:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801996:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801999:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199c:	48 63 c8             	movslq %eax,%rcx
  80199f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a6:	48 98                	cltq   
  8019a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019af:	00 
  8019b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b6:	49 89 c8             	mov    %rcx,%r8
  8019b9:	48 89 d1             	mov    %rdx,%rcx
  8019bc:	48 89 c2             	mov    %rax,%rdx
  8019bf:	be 01 00 00 00       	mov    $0x1,%esi
  8019c4:	bf 04 00 00 00       	mov    $0x4,%edi
  8019c9:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
}
  8019d5:	c9                   	leaveq 
  8019d6:	c3                   	retq   

00000000008019d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019d7:	55                   	push   %rbp
  8019d8:	48 89 e5             	mov    %rsp,%rbp
  8019db:	48 83 ec 30          	sub    $0x30,%rsp
  8019df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019e9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019ed:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019f1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019f4:	48 63 c8             	movslq %eax,%rcx
  8019f7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019fe:	48 63 f0             	movslq %eax,%rsi
  801a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a08:	48 98                	cltq   
  801a0a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a0e:	49 89 f9             	mov    %rdi,%r9
  801a11:	49 89 f0             	mov    %rsi,%r8
  801a14:	48 89 d1             	mov    %rdx,%rcx
  801a17:	48 89 c2             	mov    %rax,%rdx
  801a1a:	be 01 00 00 00       	mov    $0x1,%esi
  801a1f:	bf 05 00 00 00       	mov    $0x5,%edi
  801a24:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	callq  *%rax
}
  801a30:	c9                   	leaveq 
  801a31:	c3                   	retq   

0000000000801a32 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a32:	55                   	push   %rbp
  801a33:	48 89 e5             	mov    %rsp,%rbp
  801a36:	48 83 ec 20          	sub    $0x20,%rsp
  801a3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a48:	48 98                	cltq   
  801a4a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a51:	00 
  801a52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5e:	48 89 d1             	mov    %rdx,%rcx
  801a61:	48 89 c2             	mov    %rax,%rdx
  801a64:	be 01 00 00 00       	mov    $0x1,%esi
  801a69:	bf 06 00 00 00       	mov    $0x6,%edi
  801a6e:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801a75:	00 00 00 
  801a78:	ff d0                	callq  *%rax
}
  801a7a:	c9                   	leaveq 
  801a7b:	c3                   	retq   

0000000000801a7c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a7c:	55                   	push   %rbp
  801a7d:	48 89 e5             	mov    %rsp,%rbp
  801a80:	48 83 ec 10          	sub    $0x10,%rsp
  801a84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a87:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8d:	48 63 d0             	movslq %eax,%rdx
  801a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a93:	48 98                	cltq   
  801a95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9c:	00 
  801a9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa9:	48 89 d1             	mov    %rdx,%rcx
  801aac:	48 89 c2             	mov    %rax,%rdx
  801aaf:	be 01 00 00 00       	mov    $0x1,%esi
  801ab4:	bf 08 00 00 00       	mov    $0x8,%edi
  801ab9:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801ac0:	00 00 00 
  801ac3:	ff d0                	callq  *%rax
}
  801ac5:	c9                   	leaveq 
  801ac6:	c3                   	retq   

0000000000801ac7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	48 83 ec 20          	sub    $0x20,%rsp
  801acf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ad6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae6:	00 
  801ae7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af3:	48 89 d1             	mov    %rdx,%rcx
  801af6:	48 89 c2             	mov    %rax,%rdx
  801af9:	be 01 00 00 00       	mov    $0x1,%esi
  801afe:	bf 09 00 00 00       	mov    $0x9,%edi
  801b03:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801b0a:	00 00 00 
  801b0d:	ff d0                	callq  *%rax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 20          	sub    $0x20,%rsp
  801b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b20:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b24:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b2a:	48 63 f0             	movslq %eax,%rsi
  801b2d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b34:	48 98                	cltq   
  801b36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b41:	00 
  801b42:	49 89 f1             	mov    %rsi,%r9
  801b45:	49 89 c8             	mov    %rcx,%r8
  801b48:	48 89 d1             	mov    %rdx,%rcx
  801b4b:	48 89 c2             	mov    %rax,%rdx
  801b4e:	be 00 00 00 00       	mov    $0x0,%esi
  801b53:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b58:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801b5f:	00 00 00 
  801b62:	ff d0                	callq  *%rax
}
  801b64:	c9                   	leaveq 
  801b65:	c3                   	retq   

0000000000801b66 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b66:	55                   	push   %rbp
  801b67:	48 89 e5             	mov    %rsp,%rbp
  801b6a:	48 83 ec 10          	sub    $0x10,%rsp
  801b6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b76:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7d:	00 
  801b7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b84:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8f:	48 89 c2             	mov    %rax,%rdx
  801b92:	be 01 00 00 00       	mov    $0x1,%esi
  801b97:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b9c:	48 b8 b1 17 80 00 00 	movabs $0x8017b1,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	callq  *%rax
}
  801ba8:	c9                   	leaveq 
  801ba9:	c3                   	retq   
