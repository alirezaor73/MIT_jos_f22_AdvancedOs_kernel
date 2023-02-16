
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
  800052:	48 bf 40 37 80 00 00 	movabs $0x803740,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	for (i = 0; i < ARRAYSIZE; i++)
  80006d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800074:	eb 4b                	jmp    8000c1 <umain+0x7e>
		if (bigarray[i] != 0)
  800076:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80007d:	00 00 00 
  800080:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800083:	48 63 d2             	movslq %edx,%rdx
  800086:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800089:	85 c0                	test   %eax,%eax
  80008b:	74 30                	je     8000bd <umain+0x7a>
			panic("bigarray[%d] isn't cleared!\n", i);
  80008d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800090:	89 c1                	mov    %eax,%ecx
  800092:	48 ba 60 37 80 00 00 	movabs $0x803760,%rdx
  800099:	00 00 00 
  80009c:	be 11 00 00 00       	mov    $0x11,%esi
  8000a1:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
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
  8000d6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
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
  8000ff:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
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
  80011e:	48 ba 90 37 80 00 00 	movabs $0x803790,%rdx
  800125:	00 00 00 
  800128:	be 16 00 00 00       	mov    $0x16,%esi
  80012d:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  800134:	00 00 00 
  800137:	b8 00 00 00 00       	mov    $0x0,%eax
  80013c:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
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
  800156:	48 bf b8 37 80 00 00 	movabs $0x8037b8,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
	bigarray[ARRAYSIZE+1024] = 0;
  800171:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800178:	00 00 00 
  80017b:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%rax)
  800182:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800185:	48 ba eb 37 80 00 00 	movabs $0x8037eb,%rdx
  80018c:	00 00 00 
  80018f:	be 1a 00 00 00       	mov    $0x1a,%esi
  800194:	48 bf 7d 37 80 00 00 	movabs $0x80377d,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	48 b9 63 02 80 00 00 	movabs $0x800263,%rcx
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8001be:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
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
  8001f3:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800204:	7e 14                	jle    80021a <libmain+0x6b>
		binaryname = argv[0];
  800206:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
	close_all();
  800244:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800250:	bf 00 00 00 00       	mov    $0x0,%edi
  800255:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
}
  800261:	5d                   	pop    %rbp
  800262:	c3                   	retq   

0000000000800263 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	53                   	push   %rbx
  800268:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80026f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800276:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80027c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800283:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800291:	84 c0                	test   %al,%al
  800293:	74 23                	je     8002b8 <_panic+0x55>
  800295:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80029c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ac:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002bf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002c6:	00 00 00 
  8002c9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d0:	00 00 00 
  8002d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002de:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ec:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002f3:	00 00 00 
  8002f6:	48 8b 18             	mov    (%rax),%rbx
  8002f9:	48 b8 17 19 80 00 00 	movabs $0x801917,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
  800305:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80030b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800312:	41 89 c8             	mov    %ecx,%r8d
  800315:	48 89 d1             	mov    %rdx,%rcx
  800318:	48 89 da             	mov    %rbx,%rdx
  80031b:	89 c6                	mov    %eax,%esi
  80031d:	48 bf 10 38 80 00 00 	movabs $0x803810,%rdi
  800324:	00 00 00 
  800327:	b8 00 00 00 00       	mov    $0x0,%eax
  80032c:	49 b9 9c 04 80 00 00 	movabs $0x80049c,%r9
  800333:	00 00 00 
  800336:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800339:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800340:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800347:	48 89 d6             	mov    %rdx,%rsi
  80034a:	48 89 c7             	mov    %rax,%rdi
  80034d:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
	cprintf("\n");
  800359:	48 bf 33 38 80 00 00 	movabs $0x803833,%rdi
  800360:	00 00 00 
  800363:	b8 00 00 00 00       	mov    $0x0,%eax
  800368:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  80036f:	00 00 00 
  800372:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800374:	cc                   	int3   
  800375:	eb fd                	jmp    800374 <_panic+0x111>

0000000000800377 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038a:	8b 00                	mov    (%rax),%eax
  80038c:	8d 48 01             	lea    0x1(%rax),%ecx
  80038f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800393:	89 0a                	mov    %ecx,(%rdx)
  800395:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800398:	89 d1                	mov    %edx,%ecx
  80039a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039e:	48 98                	cltq   
  8003a0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	8b 00                	mov    (%rax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	8b 00                	mov    (%rax),%eax
  8003b7:	48 98                	cltq   
  8003b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bd:	48 83 c2 08          	add    $0x8,%rdx
  8003c1:	48 89 c6             	mov    %rax,%rsi
  8003c4:	48 89 d7             	mov    %rdx,%rdi
  8003c7:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  8003ce:	00 00 00 
  8003d1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e1:	8b 40 04             	mov    0x4(%rax),%eax
  8003e4:	8d 50 01             	lea    0x1(%rax),%edx
  8003e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003eb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003fb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800402:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800409:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800410:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800417:	48 8b 0a             	mov    (%rdx),%rcx
  80041a:	48 89 08             	mov    %rcx,(%rax)
  80041d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800421:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800425:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800429:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80042d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800434:	00 00 00 
    b.cnt = 0;
  800437:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80043e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800441:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800448:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80044f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800456:	48 89 c6             	mov    %rax,%rsi
  800459:	48 bf 77 03 80 00 00 	movabs $0x800377,%rdi
  800460:	00 00 00 
  800463:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  80046a:	00 00 00 
  80046d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80046f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800475:	48 98                	cltq   
  800477:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80047e:	48 83 c2 08          	add    $0x8,%rdx
  800482:	48 89 c6             	mov    %rax,%rsi
  800485:	48 89 d7             	mov    %rdx,%rdi
  800488:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800494:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049a:	c9                   	leaveq 
  80049b:	c3                   	retq   

000000000080049c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80049c:	55                   	push   %rbp
  80049d:	48 89 e5             	mov    %rsp,%rbp
  8004a0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ae:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004bc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ca:	84 c0                	test   %al,%al
  8004cc:	74 20                	je     8004ee <cprintf+0x52>
  8004ce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004da:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004de:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ee:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004f5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004fc:	00 00 00 
  8004ff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800506:	00 00 00 
  800509:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800514:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80051b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800522:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800529:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800530:	48 8b 0a             	mov    (%rdx),%rcx
  800533:	48 89 08             	mov    %rcx,(%rax)
  800536:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80053e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800542:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800546:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80054d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800554:	48 89 d6             	mov    %rdx,%rsi
  800557:	48 89 c7             	mov    %rax,%rdi
  80055a:	48 b8 f0 03 80 00 00 	movabs $0x8003f0,%rax
  800561:	00 00 00 
  800564:	ff d0                	callq  *%rax
  800566:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80056c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800572:	c9                   	leaveq 
  800573:	c3                   	retq   

0000000000800574 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800574:	55                   	push   %rbp
  800575:	48 89 e5             	mov    %rsp,%rbp
  800578:	53                   	push   %rbx
  800579:	48 83 ec 38          	sub    $0x38,%rsp
  80057d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800581:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800585:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800589:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80058c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800590:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800594:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800597:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80059b:	77 3b                	ja     8005d8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a0:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a4:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b0:	48 f7 f3             	div    %rbx
  8005b3:	48 89 c2             	mov    %rax,%rdx
  8005b6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005b9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005bc:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	41 89 f9             	mov    %edi,%r9d
  8005c7:	48 89 c7             	mov    %rax,%rdi
  8005ca:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  8005d1:	00 00 00 
  8005d4:	ff d0                	callq  *%rax
  8005d6:	eb 1e                	jmp    8005f6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d8:	eb 12                	jmp    8005ec <printnum+0x78>
			putch(padc, putdat);
  8005da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005de:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	48 89 ce             	mov    %rcx,%rsi
  8005e8:	89 d7                	mov    %edx,%edi
  8005ea:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ec:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f4:	7f e4                	jg     8005da <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800602:	48 f7 f1             	div    %rcx
  800605:	48 89 d0             	mov    %rdx,%rax
  800608:	48 ba 30 3a 80 00 00 	movabs $0x803a30,%rdx
  80060f:	00 00 00 
  800612:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800616:	0f be d0             	movsbl %al,%edx
  800619:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	48 89 ce             	mov    %rcx,%rsi
  800624:	89 d7                	mov    %edx,%edi
  800626:	ff d0                	callq  *%rax
}
  800628:	48 83 c4 38          	add    $0x38,%rsp
  80062c:	5b                   	pop    %rbx
  80062d:	5d                   	pop    %rbp
  80062e:	c3                   	retq   

000000000080062f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80062f:	55                   	push   %rbp
  800630:	48 89 e5             	mov    %rsp,%rbp
  800633:	48 83 ec 1c          	sub    $0x1c,%rsp
  800637:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80063e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800642:	7e 52                	jle    800696 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	8b 00                	mov    (%rax),%eax
  80064a:	83 f8 30             	cmp    $0x30,%eax
  80064d:	73 24                	jae    800673 <getuint+0x44>
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	89 c0                	mov    %eax,%eax
  80065f:	48 01 d0             	add    %rdx,%rax
  800662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800666:	8b 12                	mov    (%rdx),%edx
  800668:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	89 0a                	mov    %ecx,(%rdx)
  800671:	eb 17                	jmp    80068a <getuint+0x5b>
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067b:	48 89 d0             	mov    %rdx,%rax
  80067e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800686:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068a:	48 8b 00             	mov    (%rax),%rax
  80068d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800691:	e9 a3 00 00 00       	jmpq   800739 <getuint+0x10a>
	else if (lflag)
  800696:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069a:	74 4f                	je     8006eb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	83 f8 30             	cmp    $0x30,%eax
  8006a5:	73 24                	jae    8006cb <getuint+0x9c>
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	89 c0                	mov    %eax,%eax
  8006b7:	48 01 d0             	add    %rdx,%rax
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	8b 12                	mov    (%rdx),%edx
  8006c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	89 0a                	mov    %ecx,(%rdx)
  8006c9:	eb 17                	jmp    8006e2 <getuint+0xb3>
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d3:	48 89 d0             	mov    %rdx,%rax
  8006d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e2:	48 8b 00             	mov    (%rax),%rax
  8006e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e9:	eb 4e                	jmp    800739 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	8b 00                	mov    (%rax),%eax
  8006f1:	83 f8 30             	cmp    $0x30,%eax
  8006f4:	73 24                	jae    80071a <getuint+0xeb>
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800702:	8b 00                	mov    (%rax),%eax
  800704:	89 c0                	mov    %eax,%eax
  800706:	48 01 d0             	add    %rdx,%rax
  800709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070d:	8b 12                	mov    (%rdx),%edx
  80070f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	89 0a                	mov    %ecx,(%rdx)
  800718:	eb 17                	jmp    800731 <getuint+0x102>
  80071a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800722:	48 89 d0             	mov    %rdx,%rax
  800725:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800729:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800731:	8b 00                	mov    (%rax),%eax
  800733:	89 c0                	mov    %eax,%eax
  800735:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80073d:	c9                   	leaveq 
  80073e:	c3                   	retq   

000000000080073f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80073f:	55                   	push   %rbp
  800740:	48 89 e5             	mov    %rsp,%rbp
  800743:	48 83 ec 1c          	sub    $0x1c,%rsp
  800747:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80074e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800752:	7e 52                	jle    8007a6 <getint+0x67>
		x=va_arg(*ap, long long);
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	83 f8 30             	cmp    $0x30,%eax
  80075d:	73 24                	jae    800783 <getint+0x44>
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	89 c0                	mov    %eax,%eax
  80076f:	48 01 d0             	add    %rdx,%rax
  800772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800776:	8b 12                	mov    (%rdx),%edx
  800778:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077f:	89 0a                	mov    %ecx,(%rdx)
  800781:	eb 17                	jmp    80079a <getint+0x5b>
  800783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800787:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078b:	48 89 d0             	mov    %rdx,%rax
  80078e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800792:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800796:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079a:	48 8b 00             	mov    (%rax),%rax
  80079d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a1:	e9 a3 00 00 00       	jmpq   800849 <getint+0x10a>
	else if (lflag)
  8007a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007aa:	74 4f                	je     8007fb <getint+0xbc>
		x=va_arg(*ap, long);
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	83 f8 30             	cmp    $0x30,%eax
  8007b5:	73 24                	jae    8007db <getint+0x9c>
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	89 c0                	mov    %eax,%eax
  8007c7:	48 01 d0             	add    %rdx,%rax
  8007ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ce:	8b 12                	mov    (%rdx),%edx
  8007d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	89 0a                	mov    %ecx,(%rdx)
  8007d9:	eb 17                	jmp    8007f2 <getint+0xb3>
  8007db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e3:	48 89 d0             	mov    %rdx,%rax
  8007e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f2:	48 8b 00             	mov    (%rax),%rax
  8007f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f9:	eb 4e                	jmp    800849 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	83 f8 30             	cmp    $0x30,%eax
  800804:	73 24                	jae    80082a <getint+0xeb>
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	89 c0                	mov    %eax,%eax
  800816:	48 01 d0             	add    %rdx,%rax
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	8b 12                	mov    (%rdx),%edx
  80081f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	89 0a                	mov    %ecx,(%rdx)
  800828:	eb 17                	jmp    800841 <getint+0x102>
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800832:	48 89 d0             	mov    %rdx,%rax
  800835:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800839:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800841:	8b 00                	mov    (%rax),%eax
  800843:	48 98                	cltq   
  800845:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084d:	c9                   	leaveq 
  80084e:	c3                   	retq   

000000000080084f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80084f:	55                   	push   %rbp
  800850:	48 89 e5             	mov    %rsp,%rbp
  800853:	41 54                	push   %r12
  800855:	53                   	push   %rbx
  800856:	48 83 ec 60          	sub    $0x60,%rsp
  80085a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80085e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800862:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800866:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80086e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800872:	48 8b 0a             	mov    (%rdx),%rcx
  800875:	48 89 08             	mov    %rcx,(%rax)
  800878:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80087c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800880:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800884:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800888:	eb 17                	jmp    8008a1 <vprintfmt+0x52>
			if (ch == '\0')
  80088a:	85 db                	test   %ebx,%ebx
  80088c:	0f 84 df 04 00 00    	je     800d71 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800892:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800896:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 df                	mov    %ebx,%edi
  80089f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ad:	0f b6 00             	movzbl (%rax),%eax
  8008b0:	0f b6 d8             	movzbl %al,%ebx
  8008b3:	83 fb 25             	cmp    $0x25,%ebx
  8008b6:	75 d2                	jne    80088a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008bc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e4:	0f b6 00             	movzbl (%rax),%eax
  8008e7:	0f b6 d8             	movzbl %al,%ebx
  8008ea:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ed:	83 f8 55             	cmp    $0x55,%eax
  8008f0:	0f 87 47 04 00 00    	ja     800d3d <vprintfmt+0x4ee>
  8008f6:	89 c0                	mov    %eax,%eax
  8008f8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ff:	00 
  800900:	48 b8 58 3a 80 00 00 	movabs $0x803a58,%rax
  800907:	00 00 00 
  80090a:	48 01 d0             	add    %rdx,%rax
  80090d:	48 8b 00             	mov    (%rax),%rax
  800910:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800912:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800916:	eb c0                	jmp    8008d8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800918:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80091c:	eb ba                	jmp    8008d8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800925:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800928:	89 d0                	mov    %edx,%eax
  80092a:	c1 e0 02             	shl    $0x2,%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	01 c0                	add    %eax,%eax
  800931:	01 d8                	add    %ebx,%eax
  800933:	83 e8 30             	sub    $0x30,%eax
  800936:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800939:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093d:	0f b6 00             	movzbl (%rax),%eax
  800940:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800943:	83 fb 2f             	cmp    $0x2f,%ebx
  800946:	7e 0c                	jle    800954 <vprintfmt+0x105>
  800948:	83 fb 39             	cmp    $0x39,%ebx
  80094b:	7f 07                	jg     800954 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800952:	eb d1                	jmp    800925 <vprintfmt+0xd6>
			goto process_precision;
  800954:	eb 58                	jmp    8009ae <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	83 f8 30             	cmp    $0x30,%eax
  80095c:	73 17                	jae    800975 <vprintfmt+0x126>
  80095e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800962:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800965:	89 c0                	mov    %eax,%eax
  800967:	48 01 d0             	add    %rdx,%rax
  80096a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096d:	83 c2 08             	add    $0x8,%edx
  800970:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800973:	eb 0f                	jmp    800984 <vprintfmt+0x135>
  800975:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800979:	48 89 d0             	mov    %rdx,%rax
  80097c:	48 83 c2 08          	add    $0x8,%rdx
  800980:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800984:	8b 00                	mov    (%rax),%eax
  800986:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800989:	eb 23                	jmp    8009ae <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80098b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098f:	79 0c                	jns    80099d <vprintfmt+0x14e>
				width = 0;
  800991:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800998:	e9 3b ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>
  80099d:	e9 36 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a9:	e9 2a ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b2:	79 12                	jns    8009c6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c1:	e9 12 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>
  8009c6:	e9 0d ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009cf:	e9 04 ff ff ff       	jmpq   8008d8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d7:	83 f8 30             	cmp    $0x30,%eax
  8009da:	73 17                	jae    8009f3 <vprintfmt+0x1a4>
  8009dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	89 c0                	mov    %eax,%eax
  8009e5:	48 01 d0             	add    %rdx,%rax
  8009e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009eb:	83 c2 08             	add    $0x8,%edx
  8009ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f1:	eb 0f                	jmp    800a02 <vprintfmt+0x1b3>
  8009f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f7:	48 89 d0             	mov    %rdx,%rax
  8009fa:	48 83 c2 08          	add    $0x8,%rdx
  8009fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a02:	8b 10                	mov    (%rax),%edx
  800a04:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0c:	48 89 ce             	mov    %rcx,%rsi
  800a0f:	89 d7                	mov    %edx,%edi
  800a11:	ff d0                	callq  *%rax
			break;
  800a13:	e9 53 03 00 00       	jmpq   800d6b <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1b:	83 f8 30             	cmp    $0x30,%eax
  800a1e:	73 17                	jae    800a37 <vprintfmt+0x1e8>
  800a20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a27:	89 c0                	mov    %eax,%eax
  800a29:	48 01 d0             	add    %rdx,%rax
  800a2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2f:	83 c2 08             	add    $0x8,%edx
  800a32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a35:	eb 0f                	jmp    800a46 <vprintfmt+0x1f7>
  800a37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3b:	48 89 d0             	mov    %rdx,%rax
  800a3e:	48 83 c2 08          	add    $0x8,%rdx
  800a42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a46:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a48:	85 db                	test   %ebx,%ebx
  800a4a:	79 02                	jns    800a4e <vprintfmt+0x1ff>
				err = -err;
  800a4c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a4e:	83 fb 15             	cmp    $0x15,%ebx
  800a51:	7f 16                	jg     800a69 <vprintfmt+0x21a>
  800a53:	48 b8 80 39 80 00 00 	movabs $0x803980,%rax
  800a5a:	00 00 00 
  800a5d:	48 63 d3             	movslq %ebx,%rdx
  800a60:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a64:	4d 85 e4             	test   %r12,%r12
  800a67:	75 2e                	jne    800a97 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a69:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a71:	89 d9                	mov    %ebx,%ecx
  800a73:	48 ba 41 3a 80 00 00 	movabs $0x803a41,%rdx
  800a7a:	00 00 00 
  800a7d:	48 89 c7             	mov    %rax,%rdi
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	49 b8 7a 0d 80 00 00 	movabs $0x800d7a,%r8
  800a8c:	00 00 00 
  800a8f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a92:	e9 d4 02 00 00       	jmpq   800d6b <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a97:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9f:	4c 89 e1             	mov    %r12,%rcx
  800aa2:	48 ba 4a 3a 80 00 00 	movabs $0x803a4a,%rdx
  800aa9:	00 00 00 
  800aac:	48 89 c7             	mov    %rax,%rdi
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	49 b8 7a 0d 80 00 00 	movabs $0x800d7a,%r8
  800abb:	00 00 00 
  800abe:	41 ff d0             	callq  *%r8
			break;
  800ac1:	e9 a5 02 00 00       	jmpq   800d6b <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	83 f8 30             	cmp    $0x30,%eax
  800acc:	73 17                	jae    800ae5 <vprintfmt+0x296>
  800ace:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad5:	89 c0                	mov    %eax,%eax
  800ad7:	48 01 d0             	add    %rdx,%rax
  800ada:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800add:	83 c2 08             	add    $0x8,%edx
  800ae0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae3:	eb 0f                	jmp    800af4 <vprintfmt+0x2a5>
  800ae5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae9:	48 89 d0             	mov    %rdx,%rax
  800aec:	48 83 c2 08          	add    $0x8,%rdx
  800af0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af4:	4c 8b 20             	mov    (%rax),%r12
  800af7:	4d 85 e4             	test   %r12,%r12
  800afa:	75 0a                	jne    800b06 <vprintfmt+0x2b7>
				p = "(null)";
  800afc:	49 bc 4d 3a 80 00 00 	movabs $0x803a4d,%r12
  800b03:	00 00 00 
			if (width > 0 && padc != '-')
  800b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0a:	7e 3f                	jle    800b4b <vprintfmt+0x2fc>
  800b0c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b10:	74 39                	je     800b4b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b12:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b15:	48 98                	cltq   
  800b17:	48 89 c6             	mov    %rax,%rsi
  800b1a:	4c 89 e7             	mov    %r12,%rdi
  800b1d:	48 b8 26 10 80 00 00 	movabs $0x801026,%rax
  800b24:	00 00 00 
  800b27:	ff d0                	callq  *%rax
  800b29:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b2c:	eb 17                	jmp    800b45 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b2e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b32:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3a:	48 89 ce             	mov    %rcx,%rsi
  800b3d:	89 d7                	mov    %edx,%edi
  800b3f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b45:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b49:	7f e3                	jg     800b2e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	eb 37                	jmp    800b84 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b51:	74 1e                	je     800b71 <vprintfmt+0x322>
  800b53:	83 fb 1f             	cmp    $0x1f,%ebx
  800b56:	7e 05                	jle    800b5d <vprintfmt+0x30e>
  800b58:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5b:	7e 14                	jle    800b71 <vprintfmt+0x322>
					putch('?', putdat);
  800b5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b65:	48 89 d6             	mov    %rdx,%rsi
  800b68:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b6d:	ff d0                	callq  *%rax
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b79:	48 89 d6             	mov    %rdx,%rsi
  800b7c:	89 df                	mov    %ebx,%edi
  800b7e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b84:	4c 89 e0             	mov    %r12,%rax
  800b87:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b8b:	0f b6 00             	movzbl (%rax),%eax
  800b8e:	0f be d8             	movsbl %al,%ebx
  800b91:	85 db                	test   %ebx,%ebx
  800b93:	74 10                	je     800ba5 <vprintfmt+0x356>
  800b95:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b99:	78 b2                	js     800b4d <vprintfmt+0x2fe>
  800b9b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b9f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba3:	79 a8                	jns    800b4d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba5:	eb 16                	jmp    800bbd <vprintfmt+0x36e>
				putch(' ', putdat);
  800ba7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baf:	48 89 d6             	mov    %rdx,%rsi
  800bb2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc1:	7f e4                	jg     800ba7 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc3:	e9 a3 01 00 00       	jmpq   800d6b <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcc:	be 03 00 00 00       	mov    $0x3,%esi
  800bd1:	48 89 c7             	mov    %rax,%rdi
  800bd4:	48 b8 3f 07 80 00 00 	movabs $0x80073f,%rax
  800bdb:	00 00 00 
  800bde:	ff d0                	callq  *%rax
  800be0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be8:	48 85 c0             	test   %rax,%rax
  800beb:	79 1d                	jns    800c0a <vprintfmt+0x3bb>
				putch('-', putdat);
  800bed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf5:	48 89 d6             	mov    %rdx,%rsi
  800bf8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bfd:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c03:	48 f7 d8             	neg    %rax
  800c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c11:	e9 e8 00 00 00       	jmpq   800cfe <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c16:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1a:	be 03 00 00 00       	mov    $0x3,%esi
  800c1f:	48 89 c7             	mov    %rax,%rdi
  800c22:	48 b8 2f 06 80 00 00 	movabs $0x80062f,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c39:	e9 c0 00 00 00       	jmpq   800cfe <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c46:	48 89 d6             	mov    %rdx,%rsi
  800c49:	bf 58 00 00 00       	mov    $0x58,%edi
  800c4e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c58:	48 89 d6             	mov    %rdx,%rsi
  800c5b:	bf 58 00 00 00       	mov    $0x58,%edi
  800c60:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6a:	48 89 d6             	mov    %rdx,%rsi
  800c6d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c72:	ff d0                	callq  *%rax
			break;
  800c74:	e9 f2 00 00 00       	jmpq   800d6b <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c81:	48 89 d6             	mov    %rdx,%rsi
  800c84:	bf 30 00 00 00       	mov    $0x30,%edi
  800c89:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c93:	48 89 d6             	mov    %rdx,%rsi
  800c96:	bf 78 00 00 00       	mov    $0x78,%edi
  800c9b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca0:	83 f8 30             	cmp    $0x30,%eax
  800ca3:	73 17                	jae    800cbc <vprintfmt+0x46d>
  800ca5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cac:	89 c0                	mov    %eax,%eax
  800cae:	48 01 d0             	add    %rdx,%rax
  800cb1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb4:	83 c2 08             	add    $0x8,%edx
  800cb7:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cba:	eb 0f                	jmp    800ccb <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cbc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc0:	48 89 d0             	mov    %rdx,%rax
  800cc3:	48 83 c2 08          	add    $0x8,%rdx
  800cc7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cd9:	eb 23                	jmp    800cfe <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cdb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cdf:	be 03 00 00 00       	mov    $0x3,%esi
  800ce4:	48 89 c7             	mov    %rax,%rdi
  800ce7:	48 b8 2f 06 80 00 00 	movabs $0x80062f,%rax
  800cee:	00 00 00 
  800cf1:	ff d0                	callq  *%rax
  800cf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cfe:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d03:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d06:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d15:	45 89 c1             	mov    %r8d,%r9d
  800d18:	41 89 f8             	mov    %edi,%r8d
  800d1b:	48 89 c7             	mov    %rax,%rdi
  800d1e:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800d25:	00 00 00 
  800d28:	ff d0                	callq  *%rax
			break;
  800d2a:	eb 3f                	jmp    800d6b <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d34:	48 89 d6             	mov    %rdx,%rsi
  800d37:	89 df                	mov    %ebx,%edi
  800d39:	ff d0                	callq  *%rax
			break;
  800d3b:	eb 2e                	jmp    800d6b <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d45:	48 89 d6             	mov    %rdx,%rsi
  800d48:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d4f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d54:	eb 05                	jmp    800d5b <vprintfmt+0x50c>
  800d56:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d5f:	48 83 e8 01          	sub    $0x1,%rax
  800d63:	0f b6 00             	movzbl (%rax),%eax
  800d66:	3c 25                	cmp    $0x25,%al
  800d68:	75 ec                	jne    800d56 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d6a:	90                   	nop
		}
	}
  800d6b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6c:	e9 30 fb ff ff       	jmpq   8008a1 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d71:	48 83 c4 60          	add    $0x60,%rsp
  800d75:	5b                   	pop    %rbx
  800d76:	41 5c                	pop    %r12
  800d78:	5d                   	pop    %rbp
  800d79:	c3                   	retq   

0000000000800d7a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d7a:	55                   	push   %rbp
  800d7b:	48 89 e5             	mov    %rsp,%rbp
  800d7e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d85:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d8c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d93:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d9a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da8:	84 c0                	test   %al,%al
  800daa:	74 20                	je     800dcc <printfmt+0x52>
  800dac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800db4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dbc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dc4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dcc:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dda:	00 00 00 
  800ddd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800de4:	00 00 00 
  800de7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800deb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e00:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e07:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e0e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e15:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e1c:	48 89 c7             	mov    %rax,%rdi
  800e1f:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  800e26:	00 00 00 
  800e29:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e2b:	c9                   	leaveq 
  800e2c:	c3                   	retq   

0000000000800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %rbp
  800e2e:	48 89 e5             	mov    %rsp,%rbp
  800e31:	48 83 ec 10          	sub    $0x10,%rsp
  800e35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e40:	8b 40 10             	mov    0x10(%rax),%eax
  800e43:	8d 50 01             	lea    0x1(%rax),%edx
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e51:	48 8b 10             	mov    (%rax),%rdx
  800e54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e58:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e5c:	48 39 c2             	cmp    %rax,%rdx
  800e5f:	73 17                	jae    800e78 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	48 8b 00             	mov    (%rax),%rax
  800e68:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e70:	48 89 0a             	mov    %rcx,(%rdx)
  800e73:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e76:	88 10                	mov    %dl,(%rax)
}
  800e78:	c9                   	leaveq 
  800e79:	c3                   	retq   

0000000000800e7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e7a:	55                   	push   %rbp
  800e7b:	48 89 e5             	mov    %rsp,%rbp
  800e7e:	48 83 ec 50          	sub    $0x50,%rsp
  800e82:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e86:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e89:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e8d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e91:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e95:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e99:	48 8b 0a             	mov    (%rdx),%rcx
  800e9c:	48 89 08             	mov    %rcx,(%rax)
  800e9f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eab:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eaf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eba:	48 98                	cltq   
  800ebc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ec0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec4:	48 01 d0             	add    %rdx,%rax
  800ec7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ecb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed7:	74 06                	je     800edf <vsnprintf+0x65>
  800ed9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800edd:	7f 07                	jg     800ee6 <vsnprintf+0x6c>
		return -E_INVAL;
  800edf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee4:	eb 2f                	jmp    800f15 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ee6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eea:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef2:	48 89 c6             	mov    %rax,%rsi
  800ef5:	48 bf 2d 0e 80 00 00 	movabs $0x800e2d,%rdi
  800efc:	00 00 00 
  800eff:	48 b8 4f 08 80 00 00 	movabs $0x80084f,%rax
  800f06:	00 00 00 
  800f09:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f0f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f12:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f15:	c9                   	leaveq 
  800f16:	c3                   	retq   

0000000000800f17 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f17:	55                   	push   %rbp
  800f18:	48 89 e5             	mov    %rsp,%rbp
  800f1b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f22:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f29:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f2f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f36:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f44:	84 c0                	test   %al,%al
  800f46:	74 20                	je     800f68 <snprintf+0x51>
  800f48:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f50:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f54:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f58:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f60:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f64:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f68:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f6f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f76:	00 00 00 
  800f79:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f80:	00 00 00 
  800f83:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f87:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f8e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f95:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f9c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800faa:	48 8b 0a             	mov    (%rdx),%rcx
  800fad:	48 89 08             	mov    %rcx,(%rax)
  800fb0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fc0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fce:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fd4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fdb:	48 89 c7             	mov    %rax,%rdi
  800fde:	48 b8 7a 0e 80 00 00 	movabs $0x800e7a,%rax
  800fe5:	00 00 00 
  800fe8:	ff d0                	callq  *%rax
  800fea:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ff0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ff6:	c9                   	leaveq 
  800ff7:	c3                   	retq   

0000000000800ff8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff8:	55                   	push   %rbp
  800ff9:	48 89 e5             	mov    %rsp,%rbp
  800ffc:	48 83 ec 18          	sub    $0x18,%rsp
  801000:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801004:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80100b:	eb 09                	jmp    801016 <strlen+0x1e>
		n++;
  80100d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801011:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101a:	0f b6 00             	movzbl (%rax),%eax
  80101d:	84 c0                	test   %al,%al
  80101f:	75 ec                	jne    80100d <strlen+0x15>
		n++;
	return n;
  801021:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801024:	c9                   	leaveq 
  801025:	c3                   	retq   

0000000000801026 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801026:	55                   	push   %rbp
  801027:	48 89 e5             	mov    %rsp,%rbp
  80102a:	48 83 ec 20          	sub    $0x20,%rsp
  80102e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801032:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801036:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103d:	eb 0e                	jmp    80104d <strnlen+0x27>
		n++;
  80103f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801043:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801048:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80104d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801052:	74 0b                	je     80105f <strnlen+0x39>
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	0f b6 00             	movzbl (%rax),%eax
  80105b:	84 c0                	test   %al,%al
  80105d:	75 e0                	jne    80103f <strnlen+0x19>
		n++;
	return n;
  80105f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801062:	c9                   	leaveq 
  801063:	c3                   	retq   

0000000000801064 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 20          	sub    $0x20,%rsp
  80106c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80107c:	90                   	nop
  80107d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801081:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801085:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801089:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80108d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801091:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801095:	0f b6 12             	movzbl (%rdx),%edx
  801098:	88 10                	mov    %dl,(%rax)
  80109a:	0f b6 00             	movzbl (%rax),%eax
  80109d:	84 c0                	test   %al,%al
  80109f:	75 dc                	jne    80107d <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 20          	sub    $0x20,%rsp
  8010af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 89 c7             	mov    %rax,%rdi
  8010be:	48 b8 f8 0f 80 00 00 	movabs $0x800ff8,%rax
  8010c5:	00 00 00 
  8010c8:	ff d0                	callq  *%rax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d0:	48 63 d0             	movslq %eax,%rdx
  8010d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d7:	48 01 c2             	add    %rax,%rdx
  8010da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010de:	48 89 c6             	mov    %rax,%rsi
  8010e1:	48 89 d7             	mov    %rdx,%rdi
  8010e4:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  8010eb:	00 00 00 
  8010ee:	ff d0                	callq  *%rax
	return dst;
  8010f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010f4:	c9                   	leaveq 
  8010f5:	c3                   	retq   

00000000008010f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 83 ec 28          	sub    $0x28,%rsp
  8010fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801102:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801106:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80110a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801112:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801119:	00 
  80111a:	eb 2a                	jmp    801146 <strncpy+0x50>
		*dst++ = *src;
  80111c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801120:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801124:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801128:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112c:	0f b6 12             	movzbl (%rdx),%edx
  80112f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801135:	0f b6 00             	movzbl (%rax),%eax
  801138:	84 c0                	test   %al,%al
  80113a:	74 05                	je     801141 <strncpy+0x4b>
			src++;
  80113c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801141:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80114e:	72 cc                	jb     80111c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801154:	c9                   	leaveq 
  801155:	c3                   	retq   

0000000000801156 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801156:	55                   	push   %rbp
  801157:	48 89 e5             	mov    %rsp,%rbp
  80115a:	48 83 ec 28          	sub    $0x28,%rsp
  80115e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801162:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801166:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80116a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801172:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801177:	74 3d                	je     8011b6 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801179:	eb 1d                	jmp    801198 <strlcpy+0x42>
			*dst++ = *src++;
  80117b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801183:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801187:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80118b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80118f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801193:	0f b6 12             	movzbl (%rdx),%edx
  801196:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801198:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80119d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a2:	74 0b                	je     8011af <strlcpy+0x59>
  8011a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a8:	0f b6 00             	movzbl (%rax),%eax
  8011ab:	84 c0                	test   %al,%al
  8011ad:	75 cc                	jne    80117b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b3:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	48 29 c2             	sub    %rax,%rdx
  8011c1:	48 89 d0             	mov    %rdx,%rax
}
  8011c4:	c9                   	leaveq 
  8011c5:	c3                   	retq   

00000000008011c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c6:	55                   	push   %rbp
  8011c7:	48 89 e5             	mov    %rsp,%rbp
  8011ca:	48 83 ec 10          	sub    $0x10,%rsp
  8011ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d6:	eb 0a                	jmp    8011e2 <strcmp+0x1c>
		p++, q++;
  8011d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e6:	0f b6 00             	movzbl (%rax),%eax
  8011e9:	84 c0                	test   %al,%al
  8011eb:	74 12                	je     8011ff <strcmp+0x39>
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f1:	0f b6 10             	movzbl (%rax),%edx
  8011f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f8:	0f b6 00             	movzbl (%rax),%eax
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 d9                	je     8011d8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801203:	0f b6 00             	movzbl (%rax),%eax
  801206:	0f b6 d0             	movzbl %al,%edx
  801209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120d:	0f b6 00             	movzbl (%rax),%eax
  801210:	0f b6 c0             	movzbl %al,%eax
  801213:	29 c2                	sub    %eax,%edx
  801215:	89 d0                	mov    %edx,%eax
}
  801217:	c9                   	leaveq 
  801218:	c3                   	retq   

0000000000801219 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801219:	55                   	push   %rbp
  80121a:	48 89 e5             	mov    %rsp,%rbp
  80121d:	48 83 ec 18          	sub    $0x18,%rsp
  801221:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801225:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801229:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80122d:	eb 0f                	jmp    80123e <strncmp+0x25>
		n--, p++, q++;
  80122f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801234:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801239:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80123e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801243:	74 1d                	je     801262 <strncmp+0x49>
  801245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801249:	0f b6 00             	movzbl (%rax),%eax
  80124c:	84 c0                	test   %al,%al
  80124e:	74 12                	je     801262 <strncmp+0x49>
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	0f b6 10             	movzbl (%rax),%edx
  801257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125b:	0f b6 00             	movzbl (%rax),%eax
  80125e:	38 c2                	cmp    %al,%dl
  801260:	74 cd                	je     80122f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801262:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801267:	75 07                	jne    801270 <strncmp+0x57>
		return 0;
  801269:	b8 00 00 00 00       	mov    $0x0,%eax
  80126e:	eb 18                	jmp    801288 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801274:	0f b6 00             	movzbl (%rax),%eax
  801277:	0f b6 d0             	movzbl %al,%edx
  80127a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	0f b6 c0             	movzbl %al,%eax
  801284:	29 c2                	sub    %eax,%edx
  801286:	89 d0                	mov    %edx,%eax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   

000000000080128a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80128a:	55                   	push   %rbp
  80128b:	48 89 e5             	mov    %rsp,%rbp
  80128e:	48 83 ec 0c          	sub    $0xc,%rsp
  801292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801296:	89 f0                	mov    %esi,%eax
  801298:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80129b:	eb 17                	jmp    8012b4 <strchr+0x2a>
		if (*s == c)
  80129d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a1:	0f b6 00             	movzbl (%rax),%eax
  8012a4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a7:	75 06                	jne    8012af <strchr+0x25>
			return (char *) s;
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ad:	eb 15                	jmp    8012c4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	84 c0                	test   %al,%al
  8012bd:	75 de                	jne    80129d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c4:	c9                   	leaveq 
  8012c5:	c3                   	retq   

00000000008012c6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012c6:	55                   	push   %rbp
  8012c7:	48 89 e5             	mov    %rsp,%rbp
  8012ca:	48 83 ec 0c          	sub    $0xc,%rsp
  8012ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d2:	89 f0                	mov    %esi,%eax
  8012d4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d7:	eb 13                	jmp    8012ec <strfind+0x26>
		if (*s == c)
  8012d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e3:	75 02                	jne    8012e7 <strfind+0x21>
			break;
  8012e5:	eb 10                	jmp    8012f7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f0:	0f b6 00             	movzbl (%rax),%eax
  8012f3:	84 c0                	test   %al,%al
  8012f5:	75 e2                	jne    8012d9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012fb:	c9                   	leaveq 
  8012fc:	c3                   	retq   

00000000008012fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
  801301:	48 83 ec 18          	sub    $0x18,%rsp
  801305:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801309:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80130c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801310:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801315:	75 06                	jne    80131d <memset+0x20>
		return v;
  801317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131b:	eb 69                	jmp    801386 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	83 e0 03             	and    $0x3,%eax
  801324:	48 85 c0             	test   %rax,%rax
  801327:	75 48                	jne    801371 <memset+0x74>
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	83 e0 03             	and    $0x3,%eax
  801330:	48 85 c0             	test   %rax,%rax
  801333:	75 3c                	jne    801371 <memset+0x74>
		c &= 0xFF;
  801335:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80133c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133f:	c1 e0 18             	shl    $0x18,%eax
  801342:	89 c2                	mov    %eax,%edx
  801344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801347:	c1 e0 10             	shl    $0x10,%eax
  80134a:	09 c2                	or     %eax,%edx
  80134c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134f:	c1 e0 08             	shl    $0x8,%eax
  801352:	09 d0                	or     %edx,%eax
  801354:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135b:	48 c1 e8 02          	shr    $0x2,%rax
  80135f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801362:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801366:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801369:	48 89 d7             	mov    %rdx,%rdi
  80136c:	fc                   	cld    
  80136d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80136f:	eb 11                	jmp    801382 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801371:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801375:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801378:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80137c:	48 89 d7             	mov    %rdx,%rdi
  80137f:	fc                   	cld    
  801380:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801386:	c9                   	leaveq 
  801387:	c3                   	retq   

0000000000801388 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801388:	55                   	push   %rbp
  801389:	48 89 e5             	mov    %rsp,%rbp
  80138c:	48 83 ec 28          	sub    $0x28,%rsp
  801390:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801394:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801398:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80139c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b4:	0f 83 88 00 00 00    	jae    801442 <memmove+0xba>
  8013ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c2:	48 01 d0             	add    %rdx,%rax
  8013c5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c9:	76 77                	jbe    801442 <memmove+0xba>
		s += n;
  8013cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cf:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	83 e0 03             	and    $0x3,%eax
  8013e2:	48 85 c0             	test   %rax,%rax
  8013e5:	75 3b                	jne    801422 <memmove+0x9a>
  8013e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013eb:	83 e0 03             	and    $0x3,%eax
  8013ee:	48 85 c0             	test   %rax,%rax
  8013f1:	75 2f                	jne    801422 <memmove+0x9a>
  8013f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f7:	83 e0 03             	and    $0x3,%eax
  8013fa:	48 85 c0             	test   %rax,%rax
  8013fd:	75 23                	jne    801422 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801403:	48 83 e8 04          	sub    $0x4,%rax
  801407:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140b:	48 83 ea 04          	sub    $0x4,%rdx
  80140f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801413:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801417:	48 89 c7             	mov    %rax,%rdi
  80141a:	48 89 d6             	mov    %rdx,%rsi
  80141d:	fd                   	std    
  80141e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801420:	eb 1d                	jmp    80143f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801426:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	48 89 d7             	mov    %rdx,%rdi
  801439:	48 89 c1             	mov    %rax,%rcx
  80143c:	fd                   	std    
  80143d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80143f:	fc                   	cld    
  801440:	eb 57                	jmp    801499 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801446:	83 e0 03             	and    $0x3,%eax
  801449:	48 85 c0             	test   %rax,%rax
  80144c:	75 36                	jne    801484 <memmove+0xfc>
  80144e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801452:	83 e0 03             	and    $0x3,%eax
  801455:	48 85 c0             	test   %rax,%rax
  801458:	75 2a                	jne    801484 <memmove+0xfc>
  80145a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145e:	83 e0 03             	and    $0x3,%eax
  801461:	48 85 c0             	test   %rax,%rax
  801464:	75 1e                	jne    801484 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801466:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146a:	48 c1 e8 02          	shr    $0x2,%rax
  80146e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801479:	48 89 c7             	mov    %rax,%rdi
  80147c:	48 89 d6             	mov    %rdx,%rsi
  80147f:	fc                   	cld    
  801480:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801482:	eb 15                	jmp    801499 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801490:	48 89 c7             	mov    %rax,%rdi
  801493:	48 89 d6             	mov    %rdx,%rsi
  801496:	fc                   	cld    
  801497:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80149d:	c9                   	leaveq 
  80149e:	c3                   	retq   

000000000080149f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	48 83 ec 18          	sub    $0x18,%rsp
  8014a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	48 89 ce             	mov    %rcx,%rsi
  8014c2:	48 89 c7             	mov    %rax,%rdi
  8014c5:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  8014cc:	00 00 00 
  8014cf:	ff d0                	callq  *%rax
}
  8014d1:	c9                   	leaveq 
  8014d2:	c3                   	retq   

00000000008014d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d3:	55                   	push   %rbp
  8014d4:	48 89 e5             	mov    %rsp,%rbp
  8014d7:	48 83 ec 28          	sub    $0x28,%rsp
  8014db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f7:	eb 36                	jmp    80152f <memcmp+0x5c>
		if (*s1 != *s2)
  8014f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fd:	0f b6 10             	movzbl (%rax),%edx
  801500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	38 c2                	cmp    %al,%dl
  801509:	74 1a                	je     801525 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80150b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150f:	0f b6 00             	movzbl (%rax),%eax
  801512:	0f b6 d0             	movzbl %al,%edx
  801515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801519:	0f b6 00             	movzbl (%rax),%eax
  80151c:	0f b6 c0             	movzbl %al,%eax
  80151f:	29 c2                	sub    %eax,%edx
  801521:	89 d0                	mov    %edx,%eax
  801523:	eb 20                	jmp    801545 <memcmp+0x72>
		s1++, s2++;
  801525:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80152f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801533:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801537:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80153b:	48 85 c0             	test   %rax,%rax
  80153e:	75 b9                	jne    8014f9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801545:	c9                   	leaveq 
  801546:	c3                   	retq   

0000000000801547 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801547:	55                   	push   %rbp
  801548:	48 89 e5             	mov    %rsp,%rbp
  80154b:	48 83 ec 28          	sub    $0x28,%rsp
  80154f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801553:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801556:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80155a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801562:	48 01 d0             	add    %rdx,%rax
  801565:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801569:	eb 15                	jmp    801580 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80156b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156f:	0f b6 10             	movzbl (%rax),%edx
  801572:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801575:	38 c2                	cmp    %al,%dl
  801577:	75 02                	jne    80157b <memfind+0x34>
			break;
  801579:	eb 0f                	jmp    80158a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80157b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801584:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801588:	72 e1                	jb     80156b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80158a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 83 ec 34          	sub    $0x34,%rsp
  801598:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015a0:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015aa:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015b1:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b2:	eb 05                	jmp    8015b9 <strtol+0x29>
		s++;
  8015b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f0                	je     8015b4 <strtol+0x24>
  8015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	3c 09                	cmp    $0x9,%al
  8015cd:	74 e5                	je     8015b4 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	3c 2b                	cmp    $0x2b,%al
  8015d8:	75 07                	jne    8015e1 <strtol+0x51>
		s++;
  8015da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015df:	eb 17                	jmp    8015f8 <strtol+0x68>
	else if (*s == '-')
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	0f b6 00             	movzbl (%rax),%eax
  8015e8:	3c 2d                	cmp    $0x2d,%al
  8015ea:	75 0c                	jne    8015f8 <strtol+0x68>
		s++, neg = 1;
  8015ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fc:	74 06                	je     801604 <strtol+0x74>
  8015fe:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801602:	75 28                	jne    80162c <strtol+0x9c>
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 30                	cmp    $0x30,%al
  80160d:	75 1d                	jne    80162c <strtol+0x9c>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	48 83 c0 01          	add    $0x1,%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	3c 78                	cmp    $0x78,%al
  80161c:	75 0e                	jne    80162c <strtol+0x9c>
		s += 2, base = 16;
  80161e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801623:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80162a:	eb 2c                	jmp    801658 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80162c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801630:	75 19                	jne    80164b <strtol+0xbb>
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3c 30                	cmp    $0x30,%al
  80163b:	75 0e                	jne    80164b <strtol+0xbb>
		s++, base = 8;
  80163d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801642:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801649:	eb 0d                	jmp    801658 <strtol+0xc8>
	else if (base == 0)
  80164b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80164f:	75 07                	jne    801658 <strtol+0xc8>
		base = 10;
  801651:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	3c 2f                	cmp    $0x2f,%al
  801661:	7e 1d                	jle    801680 <strtol+0xf0>
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 39                	cmp    $0x39,%al
  80166c:	7f 12                	jg     801680 <strtol+0xf0>
			dig = *s - '0';
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	0f be c0             	movsbl %al,%eax
  801678:	83 e8 30             	sub    $0x30,%eax
  80167b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167e:	eb 4e                	jmp    8016ce <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	3c 60                	cmp    $0x60,%al
  801689:	7e 1d                	jle    8016a8 <strtol+0x118>
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 12                	jg     8016a8 <strtol+0x118>
			dig = *s - 'a' + 10;
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 57             	sub    $0x57,%eax
  8016a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a6:	eb 26                	jmp    8016ce <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ac:	0f b6 00             	movzbl (%rax),%eax
  8016af:	3c 40                	cmp    $0x40,%al
  8016b1:	7e 48                	jle    8016fb <strtol+0x16b>
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 5a                	cmp    $0x5a,%al
  8016bc:	7f 3d                	jg     8016fb <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	0f be c0             	movsbl %al,%eax
  8016c8:	83 e8 37             	sub    $0x37,%eax
  8016cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016d4:	7c 02                	jl     8016d8 <strtol+0x148>
			break;
  8016d6:	eb 23                	jmp    8016fb <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016dd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016e0:	48 98                	cltq   
  8016e2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e7:	48 89 c2             	mov    %rax,%rdx
  8016ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ed:	48 98                	cltq   
  8016ef:	48 01 d0             	add    %rdx,%rax
  8016f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016f6:	e9 5d ff ff ff       	jmpq   801658 <strtol+0xc8>

	if (endptr)
  8016fb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801700:	74 0b                	je     80170d <strtol+0x17d>
		*endptr = (char *) s;
  801702:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801706:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80170a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80170d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801711:	74 09                	je     80171c <strtol+0x18c>
  801713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801717:	48 f7 d8             	neg    %rax
  80171a:	eb 04                	jmp    801720 <strtol+0x190>
  80171c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801720:	c9                   	leaveq 
  801721:	c3                   	retq   

0000000000801722 <strstr>:

char * strstr(const char *in, const char *str)
{
  801722:	55                   	push   %rbp
  801723:	48 89 e5             	mov    %rsp,%rbp
  801726:	48 83 ec 30          	sub    $0x30,%rsp
  80172a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80172e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801732:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801736:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80173a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801744:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801748:	75 06                	jne    801750 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	eb 6b                	jmp    8017bb <strstr+0x99>

	len = strlen(str);
  801750:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801754:	48 89 c7             	mov    %rax,%rdi
  801757:	48 b8 f8 0f 80 00 00 	movabs $0x800ff8,%rax
  80175e:	00 00 00 
  801761:	ff d0                	callq  *%rax
  801763:	48 98                	cltq   
  801765:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801771:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801775:	0f b6 00             	movzbl (%rax),%eax
  801778:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80177b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80177f:	75 07                	jne    801788 <strstr+0x66>
				return (char *) 0;
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	eb 33                	jmp    8017bb <strstr+0x99>
		} while (sc != c);
  801788:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80178c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80178f:	75 d8                	jne    801769 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801791:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801795:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	48 89 ce             	mov    %rcx,%rsi
  8017a0:	48 89 c7             	mov    %rax,%rdi
  8017a3:	48 b8 19 12 80 00 00 	movabs $0x801219,%rax
  8017aa:	00 00 00 
  8017ad:	ff d0                	callq  *%rax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	75 b6                	jne    801769 <strstr+0x47>

	return (char *) (in - 1);
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	48 83 e8 01          	sub    $0x1,%rax
}
  8017bb:	c9                   	leaveq 
  8017bc:	c3                   	retq   

00000000008017bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017bd:	55                   	push   %rbp
  8017be:	48 89 e5             	mov    %rsp,%rbp
  8017c1:	53                   	push   %rbx
  8017c2:	48 83 ec 48          	sub    $0x48,%rsp
  8017c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017c9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017cc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017d4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017d8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017df:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017e3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017e7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017eb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ef:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017f3:	4c 89 c3             	mov    %r8,%rbx
  8017f6:	cd 30                	int    $0x30
  8017f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801800:	74 3e                	je     801840 <syscall+0x83>
  801802:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801807:	7e 37                	jle    801840 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801810:	49 89 d0             	mov    %rdx,%r8
  801813:	89 c1                	mov    %eax,%ecx
  801815:	48 ba 08 3d 80 00 00 	movabs $0x803d08,%rdx
  80181c:	00 00 00 
  80181f:	be 23 00 00 00       	mov    $0x23,%esi
  801824:	48 bf 25 3d 80 00 00 	movabs $0x803d25,%rdi
  80182b:	00 00 00 
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
  801833:	49 b9 63 02 80 00 00 	movabs $0x800263,%r9
  80183a:	00 00 00 
  80183d:	41 ff d1             	callq  *%r9

	return ret;
  801840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801844:	48 83 c4 48          	add    $0x48,%rsp
  801848:	5b                   	pop    %rbx
  801849:	5d                   	pop    %rbp
  80184a:	c3                   	retq   

000000000080184b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	48 83 ec 20          	sub    $0x20,%rsp
  801853:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801857:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80185b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801863:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186a:	00 
  80186b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801871:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801877:	48 89 d1             	mov    %rdx,%rcx
  80187a:	48 89 c2             	mov    %rax,%rdx
  80187d:	be 00 00 00 00       	mov    $0x0,%esi
  801882:	bf 00 00 00 00       	mov    $0x0,%edi
  801887:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  80188e:	00 00 00 
  801891:	ff d0                	callq  *%rax
}
  801893:	c9                   	leaveq 
  801894:	c3                   	retq   

0000000000801895 <sys_cgetc>:

int
sys_cgetc(void)
{
  801895:	55                   	push   %rbp
  801896:	48 89 e5             	mov    %rsp,%rbp
  801899:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80189d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a4:	00 
  8018a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	be 00 00 00 00       	mov    $0x0,%esi
  8018c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8018c5:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	callq  *%rax
}
  8018d1:	c9                   	leaveq 
  8018d2:	c3                   	retq   

00000000008018d3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018d3:	55                   	push   %rbp
  8018d4:	48 89 e5             	mov    %rsp,%rbp
  8018d7:	48 83 ec 10          	sub    $0x10,%rsp
  8018db:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e1:	48 98                	cltq   
  8018e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ea:	00 
  8018eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018fc:	48 89 c2             	mov    %rax,%rdx
  8018ff:	be 01 00 00 00       	mov    $0x1,%esi
  801904:	bf 03 00 00 00       	mov    $0x3,%edi
  801909:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801910:	00 00 00 
  801913:	ff d0                	callq  *%rax
}
  801915:	c9                   	leaveq 
  801916:	c3                   	retq   

0000000000801917 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801917:	55                   	push   %rbp
  801918:	48 89 e5             	mov    %rsp,%rbp
  80191b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80191f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801926:	00 
  801927:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801933:	b9 00 00 00 00       	mov    $0x0,%ecx
  801938:	ba 00 00 00 00       	mov    $0x0,%edx
  80193d:	be 00 00 00 00       	mov    $0x0,%esi
  801942:	bf 02 00 00 00       	mov    $0x2,%edi
  801947:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  80194e:	00 00 00 
  801951:	ff d0                	callq  *%rax
}
  801953:	c9                   	leaveq 
  801954:	c3                   	retq   

0000000000801955 <sys_yield>:

void
sys_yield(void)
{
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80195d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801964:	00 
  801965:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801971:	b9 00 00 00 00       	mov    $0x0,%ecx
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	be 00 00 00 00       	mov    $0x0,%esi
  801980:	bf 0b 00 00 00       	mov    $0xb,%edi
  801985:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  80198c:	00 00 00 
  80198f:	ff d0                	callq  *%rax
}
  801991:	c9                   	leaveq 
  801992:	c3                   	retq   

0000000000801993 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801993:	55                   	push   %rbp
  801994:	48 89 e5             	mov    %rsp,%rbp
  801997:	48 83 ec 20          	sub    $0x20,%rsp
  80199b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80199e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a8:	48 63 c8             	movslq %eax,%rcx
  8019ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b2:	48 98                	cltq   
  8019b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bb:	00 
  8019bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c2:	49 89 c8             	mov    %rcx,%r8
  8019c5:	48 89 d1             	mov    %rdx,%rcx
  8019c8:	48 89 c2             	mov    %rax,%rdx
  8019cb:	be 01 00 00 00       	mov    $0x1,%esi
  8019d0:	bf 04 00 00 00       	mov    $0x4,%edi
  8019d5:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  8019dc:	00 00 00 
  8019df:	ff d0                	callq  *%rax
}
  8019e1:	c9                   	leaveq 
  8019e2:	c3                   	retq   

00000000008019e3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019e3:	55                   	push   %rbp
  8019e4:	48 89 e5             	mov    %rsp,%rbp
  8019e7:	48 83 ec 30          	sub    $0x30,%rsp
  8019eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019f5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a00:	48 63 c8             	movslq %eax,%rcx
  801a03:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a0a:	48 63 f0             	movslq %eax,%rsi
  801a0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a14:	48 98                	cltq   
  801a16:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a1a:	49 89 f9             	mov    %rdi,%r9
  801a1d:	49 89 f0             	mov    %rsi,%r8
  801a20:	48 89 d1             	mov    %rdx,%rcx
  801a23:	48 89 c2             	mov    %rax,%rdx
  801a26:	be 01 00 00 00       	mov    $0x1,%esi
  801a2b:	bf 05 00 00 00       	mov    $0x5,%edi
  801a30:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801a37:	00 00 00 
  801a3a:	ff d0                	callq  *%rax
}
  801a3c:	c9                   	leaveq 
  801a3d:	c3                   	retq   

0000000000801a3e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a3e:	55                   	push   %rbp
  801a3f:	48 89 e5             	mov    %rsp,%rbp
  801a42:	48 83 ec 20          	sub    $0x20,%rsp
  801a46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a54:	48 98                	cltq   
  801a56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5d:	00 
  801a5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6a:	48 89 d1             	mov    %rdx,%rcx
  801a6d:	48 89 c2             	mov    %rax,%rdx
  801a70:	be 01 00 00 00       	mov    $0x1,%esi
  801a75:	bf 06 00 00 00       	mov    $0x6,%edi
  801a7a:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 10          	sub    $0x10,%rsp
  801a90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a93:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a99:	48 63 d0             	movslq %eax,%rdx
  801a9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9f:	48 98                	cltq   
  801aa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa8:	00 
  801aa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aaf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab5:	48 89 d1             	mov    %rdx,%rcx
  801ab8:	48 89 c2             	mov    %rax,%rdx
  801abb:	be 01 00 00 00       	mov    $0x1,%esi
  801ac0:	bf 08 00 00 00       	mov    $0x8,%edi
  801ac5:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	callq  *%rax
}
  801ad1:	c9                   	leaveq 
  801ad2:	c3                   	retq   

0000000000801ad3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ad3:	55                   	push   %rbp
  801ad4:	48 89 e5             	mov    %rsp,%rbp
  801ad7:	48 83 ec 20          	sub    $0x20,%rsp
  801adb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ade:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ae2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae9:	48 98                	cltq   
  801aeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af2:	00 
  801af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aff:	48 89 d1             	mov    %rdx,%rcx
  801b02:	48 89 c2             	mov    %rax,%rdx
  801b05:	be 01 00 00 00       	mov    $0x1,%esi
  801b0a:	bf 09 00 00 00       	mov    $0x9,%edi
  801b0f:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801b16:	00 00 00 
  801b19:	ff d0                	callq  *%rax
}
  801b1b:	c9                   	leaveq 
  801b1c:	c3                   	retq   

0000000000801b1d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b1d:	55                   	push   %rbp
  801b1e:	48 89 e5             	mov    %rsp,%rbp
  801b21:	48 83 ec 20          	sub    $0x20,%rsp
  801b25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b33:	48 98                	cltq   
  801b35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3c:	00 
  801b3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b49:	48 89 d1             	mov    %rdx,%rcx
  801b4c:	48 89 c2             	mov    %rax,%rdx
  801b4f:	be 01 00 00 00       	mov    $0x1,%esi
  801b54:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b59:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
}
  801b65:	c9                   	leaveq 
  801b66:	c3                   	retq   

0000000000801b67 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
  801b6b:	48 83 ec 20          	sub    $0x20,%rsp
  801b6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b76:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b7a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b80:	48 63 f0             	movslq %eax,%rsi
  801b83:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8a:	48 98                	cltq   
  801b8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b97:	00 
  801b98:	49 89 f1             	mov    %rsi,%r9
  801b9b:	49 89 c8             	mov    %rcx,%r8
  801b9e:	48 89 d1             	mov    %rdx,%rcx
  801ba1:	48 89 c2             	mov    %rax,%rdx
  801ba4:	be 00 00 00 00       	mov    $0x0,%esi
  801ba9:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bae:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801bb5:	00 00 00 
  801bb8:	ff d0                	callq  *%rax
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 10          	sub    $0x10,%rsp
  801bc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd3:	00 
  801bd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be5:	48 89 c2             	mov    %rax,%rdx
  801be8:	be 01 00 00 00       	mov    $0x1,%esi
  801bed:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bf2:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 08          	sub    $0x8,%rsp
  801c08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c10:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c17:	ff ff ff 
  801c1a:	48 01 d0             	add    %rdx,%rax
  801c1d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c21:	c9                   	leaveq 
  801c22:	c3                   	retq   

0000000000801c23 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c23:	55                   	push   %rbp
  801c24:	48 89 e5             	mov    %rsp,%rbp
  801c27:	48 83 ec 08          	sub    $0x8,%rsp
  801c2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c33:	48 89 c7             	mov    %rax,%rdi
  801c36:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  801c3d:	00 00 00 
  801c40:	ff d0                	callq  *%rax
  801c42:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c48:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c4c:	c9                   	leaveq 
  801c4d:	c3                   	retq   

0000000000801c4e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c4e:	55                   	push   %rbp
  801c4f:	48 89 e5             	mov    %rsp,%rbp
  801c52:	48 83 ec 18          	sub    $0x18,%rsp
  801c56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c61:	eb 6b                	jmp    801cce <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c66:	48 98                	cltq   
  801c68:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c6e:	48 c1 e0 0c          	shl    $0xc,%rax
  801c72:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7a:	48 c1 e8 15          	shr    $0x15,%rax
  801c7e:	48 89 c2             	mov    %rax,%rdx
  801c81:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c88:	01 00 00 
  801c8b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c8f:	83 e0 01             	and    $0x1,%eax
  801c92:	48 85 c0             	test   %rax,%rax
  801c95:	74 21                	je     801cb8 <fd_alloc+0x6a>
  801c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9b:	48 c1 e8 0c          	shr    $0xc,%rax
  801c9f:	48 89 c2             	mov    %rax,%rdx
  801ca2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ca9:	01 00 00 
  801cac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cb0:	83 e0 01             	and    $0x1,%eax
  801cb3:	48 85 c0             	test   %rax,%rax
  801cb6:	75 12                	jne    801cca <fd_alloc+0x7c>
			*fd_store = fd;
  801cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb 1a                	jmp    801ce4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cd2:	7e 8f                	jle    801c63 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801cdf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ce4:	c9                   	leaveq 
  801ce5:	c3                   	retq   

0000000000801ce6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ce6:	55                   	push   %rbp
  801ce7:	48 89 e5             	mov    %rsp,%rbp
  801cea:	48 83 ec 20          	sub    $0x20,%rsp
  801cee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cf1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801cf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cf9:	78 06                	js     801d01 <fd_lookup+0x1b>
  801cfb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801cff:	7e 07                	jle    801d08 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d06:	eb 6c                	jmp    801d74 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d0b:	48 98                	cltq   
  801d0d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d13:	48 c1 e0 0c          	shl    $0xc,%rax
  801d17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1f:	48 c1 e8 15          	shr    $0x15,%rax
  801d23:	48 89 c2             	mov    %rax,%rdx
  801d26:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d2d:	01 00 00 
  801d30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d34:	83 e0 01             	and    $0x1,%eax
  801d37:	48 85 c0             	test   %rax,%rax
  801d3a:	74 21                	je     801d5d <fd_lookup+0x77>
  801d3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d40:	48 c1 e8 0c          	shr    $0xc,%rax
  801d44:	48 89 c2             	mov    %rax,%rdx
  801d47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d4e:	01 00 00 
  801d51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d55:	83 e0 01             	and    $0x1,%eax
  801d58:	48 85 c0             	test   %rax,%rax
  801d5b:	75 07                	jne    801d64 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d62:	eb 10                	jmp    801d74 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d6c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d74:	c9                   	leaveq 
  801d75:	c3                   	retq   

0000000000801d76 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d76:	55                   	push   %rbp
  801d77:	48 89 e5             	mov    %rsp,%rbp
  801d7a:	48 83 ec 30          	sub    $0x30,%rsp
  801d7e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d82:	89 f0                	mov    %esi,%eax
  801d84:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8b:	48 89 c7             	mov    %rax,%rdi
  801d8e:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
  801d9a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d9e:	48 89 d6             	mov    %rdx,%rsi
  801da1:	89 c7                	mov    %eax,%edi
  801da3:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	callq  *%rax
  801daf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801db2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801db6:	78 0a                	js     801dc2 <fd_close+0x4c>
	    || fd != fd2)
  801db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801dc0:	74 12                	je     801dd4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801dc2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801dc6:	74 05                	je     801dcd <fd_close+0x57>
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	eb 05                	jmp    801dd2 <fd_close+0x5c>
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	eb 69                	jmp    801e3d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801dd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd8:	8b 00                	mov    (%rax),%eax
  801dda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dde:	48 89 d6             	mov    %rdx,%rsi
  801de1:	89 c7                	mov    %eax,%edi
  801de3:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  801dea:	00 00 00 
  801ded:	ff d0                	callq  *%rax
  801def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801df6:	78 2a                	js     801e22 <fd_close+0xac>
		if (dev->dev_close)
  801df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfc:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e00:	48 85 c0             	test   %rax,%rax
  801e03:	74 16                	je     801e1b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e0d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e11:	48 89 d7             	mov    %rdx,%rdi
  801e14:	ff d0                	callq  *%rax
  801e16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e19:	eb 07                	jmp    801e22 <fd_close+0xac>
		else
			r = 0;
  801e1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e26:	48 89 c6             	mov    %rax,%rsi
  801e29:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2e:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  801e35:	00 00 00 
  801e38:	ff d0                	callq  *%rax
	return r;
  801e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e3d:	c9                   	leaveq 
  801e3e:	c3                   	retq   

0000000000801e3f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e3f:	55                   	push   %rbp
  801e40:	48 89 e5             	mov    %rsp,%rbp
  801e43:	48 83 ec 20          	sub    $0x20,%rsp
  801e47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e55:	eb 41                	jmp    801e98 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e57:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e5e:	00 00 00 
  801e61:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e64:	48 63 d2             	movslq %edx,%rdx
  801e67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6b:	8b 00                	mov    (%rax),%eax
  801e6d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e70:	75 22                	jne    801e94 <dev_lookup+0x55>
			*dev = devtab[i];
  801e72:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e79:	00 00 00 
  801e7c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e7f:	48 63 d2             	movslq %edx,%rdx
  801e82:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e8a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	eb 60                	jmp    801ef4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e94:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e98:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e9f:	00 00 00 
  801ea2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ea5:	48 63 d2             	movslq %edx,%rdx
  801ea8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eac:	48 85 c0             	test   %rax,%rax
  801eaf:	75 a6                	jne    801e57 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801eb1:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  801eb8:	00 00 00 
  801ebb:	48 8b 00             	mov    (%rax),%rax
  801ebe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ec4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ec7:	89 c6                	mov    %eax,%esi
  801ec9:	48 bf 38 3d 80 00 00 	movabs $0x803d38,%rdi
  801ed0:	00 00 00 
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  801edf:	00 00 00 
  801ee2:	ff d1                	callq  *%rcx
	*dev = 0;
  801ee4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ef4:	c9                   	leaveq 
  801ef5:	c3                   	retq   

0000000000801ef6 <close>:

int
close(int fdnum)
{
  801ef6:	55                   	push   %rbp
  801ef7:	48 89 e5             	mov    %rsp,%rbp
  801efa:	48 83 ec 20          	sub    $0x20,%rsp
  801efe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f08:	48 89 d6             	mov    %rdx,%rsi
  801f0b:	89 c7                	mov    %eax,%edi
  801f0d:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	callq  *%rax
  801f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f20:	79 05                	jns    801f27 <close+0x31>
		return r;
  801f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f25:	eb 18                	jmp    801f3f <close+0x49>
	else
		return fd_close(fd, 1);
  801f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2b:	be 01 00 00 00       	mov    $0x1,%esi
  801f30:	48 89 c7             	mov    %rax,%rdi
  801f33:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <close_all>:

void
close_all(void)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
  801f45:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f50:	eb 15                	jmp    801f67 <close_all+0x26>
		close(i);
  801f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f55:	89 c7                	mov    %eax,%edi
  801f57:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f63:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f67:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f6b:	7e e5                	jle    801f52 <close_all+0x11>
		close(i);
}
  801f6d:	c9                   	leaveq 
  801f6e:	c3                   	retq   

0000000000801f6f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f6f:	55                   	push   %rbp
  801f70:	48 89 e5             	mov    %rsp,%rbp
  801f73:	48 83 ec 40          	sub    $0x40,%rsp
  801f77:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f7a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f7d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f81:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f84:	48 89 d6             	mov    %rdx,%rsi
  801f87:	89 c7                	mov    %eax,%edi
  801f89:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  801f90:	00 00 00 
  801f93:	ff d0                	callq  *%rax
  801f95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f9c:	79 08                	jns    801fa6 <dup+0x37>
		return r;
  801f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa1:	e9 70 01 00 00       	jmpq   802116 <dup+0x1a7>
	close(newfdnum);
  801fa6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fa9:	89 c7                	mov    %eax,%edi
  801fab:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fb7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fba:	48 98                	cltq   
  801fbc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fc2:	48 c1 e0 0c          	shl    $0xc,%rax
  801fc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fce:	48 89 c7             	mov    %rax,%rdi
  801fd1:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
  801fdd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801fe1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fe5:	48 89 c7             	mov    %rax,%rdi
  801fe8:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  801fef:	00 00 00 
  801ff2:	ff d0                	callq  *%rax
  801ff4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ff8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffc:	48 c1 e8 15          	shr    $0x15,%rax
  802000:	48 89 c2             	mov    %rax,%rdx
  802003:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80200a:	01 00 00 
  80200d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802011:	83 e0 01             	and    $0x1,%eax
  802014:	48 85 c0             	test   %rax,%rax
  802017:	74 73                	je     80208c <dup+0x11d>
  802019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201d:	48 c1 e8 0c          	shr    $0xc,%rax
  802021:	48 89 c2             	mov    %rax,%rdx
  802024:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80202b:	01 00 00 
  80202e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802032:	83 e0 01             	and    $0x1,%eax
  802035:	48 85 c0             	test   %rax,%rax
  802038:	74 52                	je     80208c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80203a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203e:	48 c1 e8 0c          	shr    $0xc,%rax
  802042:	48 89 c2             	mov    %rax,%rdx
  802045:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80204c:	01 00 00 
  80204f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802053:	25 07 0e 00 00       	and    $0xe07,%eax
  802058:	89 c1                	mov    %eax,%ecx
  80205a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80205e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802062:	41 89 c8             	mov    %ecx,%r8d
  802065:	48 89 d1             	mov    %rdx,%rcx
  802068:	ba 00 00 00 00       	mov    $0x0,%edx
  80206d:	48 89 c6             	mov    %rax,%rsi
  802070:	bf 00 00 00 00       	mov    $0x0,%edi
  802075:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802088:	79 02                	jns    80208c <dup+0x11d>
			goto err;
  80208a:	eb 57                	jmp    8020e3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80208c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802090:	48 c1 e8 0c          	shr    $0xc,%rax
  802094:	48 89 c2             	mov    %rax,%rdx
  802097:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80209e:	01 00 00 
  8020a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8020aa:	89 c1                	mov    %eax,%ecx
  8020ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020b4:	41 89 c8             	mov    %ecx,%r8d
  8020b7:	48 89 d1             	mov    %rdx,%rcx
  8020ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8020bf:	48 89 c6             	mov    %rax,%rsi
  8020c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c7:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	callq  *%rax
  8020d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020da:	79 02                	jns    8020de <dup+0x16f>
		goto err;
  8020dc:	eb 05                	jmp    8020e3 <dup+0x174>

	return newfdnum;
  8020de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020e1:	eb 33                	jmp    802116 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8020e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e7:	48 89 c6             	mov    %rax,%rsi
  8020ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ef:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  8020f6:	00 00 00 
  8020f9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8020fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ff:	48 89 c6             	mov    %rax,%rsi
  802102:	bf 00 00 00 00       	mov    $0x0,%edi
  802107:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  80210e:	00 00 00 
  802111:	ff d0                	callq  *%rax
	return r;
  802113:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802116:	c9                   	leaveq 
  802117:	c3                   	retq   

0000000000802118 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802118:	55                   	push   %rbp
  802119:	48 89 e5             	mov    %rsp,%rbp
  80211c:	48 83 ec 40          	sub    $0x40,%rsp
  802120:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802123:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802127:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80212b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80212f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802132:	48 89 d6             	mov    %rdx,%rsi
  802135:	89 c7                	mov    %eax,%edi
  802137:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
  802143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214a:	78 24                	js     802170 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802150:	8b 00                	mov    (%rax),%eax
  802152:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802156:	48 89 d6             	mov    %rdx,%rsi
  802159:	89 c7                	mov    %eax,%edi
  80215b:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax
  802167:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80216a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216e:	79 05                	jns    802175 <read+0x5d>
		return r;
  802170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802173:	eb 76                	jmp    8021eb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802179:	8b 40 08             	mov    0x8(%rax),%eax
  80217c:	83 e0 03             	and    $0x3,%eax
  80217f:	83 f8 01             	cmp    $0x1,%eax
  802182:	75 3a                	jne    8021be <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802184:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  80218b:	00 00 00 
  80218e:	48 8b 00             	mov    (%rax),%rax
  802191:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802197:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80219a:	89 c6                	mov    %eax,%esi
  80219c:	48 bf 57 3d 80 00 00 	movabs $0x803d57,%rdi
  8021a3:	00 00 00 
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  8021b2:	00 00 00 
  8021b5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021bc:	eb 2d                	jmp    8021eb <read+0xd3>
	}
	if (!dev->dev_read)
  8021be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021c6:	48 85 c0             	test   %rax,%rax
  8021c9:	75 07                	jne    8021d2 <read+0xba>
		return -E_NOT_SUPP;
  8021cb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021d0:	eb 19                	jmp    8021eb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021de:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021e2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021e6:	48 89 cf             	mov    %rcx,%rdi
  8021e9:	ff d0                	callq  *%rax
}
  8021eb:	c9                   	leaveq 
  8021ec:	c3                   	retq   

00000000008021ed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021ed:	55                   	push   %rbp
  8021ee:	48 89 e5             	mov    %rsp,%rbp
  8021f1:	48 83 ec 30          	sub    $0x30,%rsp
  8021f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802207:	eb 49                	jmp    802252 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220c:	48 98                	cltq   
  80220e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802212:	48 29 c2             	sub    %rax,%rdx
  802215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802218:	48 63 c8             	movslq %eax,%rcx
  80221b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80221f:	48 01 c1             	add    %rax,%rcx
  802222:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802225:	48 89 ce             	mov    %rcx,%rsi
  802228:	89 c7                	mov    %eax,%edi
  80222a:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax
  802236:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802239:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80223d:	79 05                	jns    802244 <readn+0x57>
			return m;
  80223f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802242:	eb 1c                	jmp    802260 <readn+0x73>
		if (m == 0)
  802244:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802248:	75 02                	jne    80224c <readn+0x5f>
			break;
  80224a:	eb 11                	jmp    80225d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80224c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80224f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802255:	48 98                	cltq   
  802257:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80225b:	72 ac                	jb     802209 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80225d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802260:	c9                   	leaveq 
  802261:	c3                   	retq   

0000000000802262 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802262:	55                   	push   %rbp
  802263:	48 89 e5             	mov    %rsp,%rbp
  802266:	48 83 ec 40          	sub    $0x40,%rsp
  80226a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80226d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802271:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802275:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802279:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80227c:	48 89 d6             	mov    %rdx,%rsi
  80227f:	89 c7                	mov    %eax,%edi
  802281:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax
  80228d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802294:	78 24                	js     8022ba <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229a:	8b 00                	mov    (%rax),%eax
  80229c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a0:	48 89 d6             	mov    %rdx,%rsi
  8022a3:	89 c7                	mov    %eax,%edi
  8022a5:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b8:	79 05                	jns    8022bf <write+0x5d>
		return r;
  8022ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bd:	eb 75                	jmp    802334 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c3:	8b 40 08             	mov    0x8(%rax),%eax
  8022c6:	83 e0 03             	and    $0x3,%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	75 3a                	jne    802307 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022cd:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  8022d4:	00 00 00 
  8022d7:	48 8b 00             	mov    (%rax),%rax
  8022da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022e3:	89 c6                	mov    %eax,%esi
  8022e5:	48 bf 73 3d 80 00 00 	movabs $0x803d73,%rdi
  8022ec:	00 00 00 
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  8022fb:	00 00 00 
  8022fe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802300:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802305:	eb 2d                	jmp    802334 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80230f:	48 85 c0             	test   %rax,%rax
  802312:	75 07                	jne    80231b <write+0xb9>
		return -E_NOT_SUPP;
  802314:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802319:	eb 19                	jmp    802334 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80231b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802323:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802327:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80232b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80232f:	48 89 cf             	mov    %rcx,%rdi
  802332:	ff d0                	callq  *%rax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <seek>:

int
seek(int fdnum, off_t offset)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 18          	sub    $0x18,%rsp
  80233e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802341:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802344:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802348:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80234b:	48 89 d6             	mov    %rdx,%rsi
  80234e:	89 c7                	mov    %eax,%edi
  802350:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
  80235c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80235f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802363:	79 05                	jns    80236a <seek+0x34>
		return r;
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802368:	eb 0f                	jmp    802379 <seek+0x43>
	fd->fd_offset = offset;
  80236a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802371:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802379:	c9                   	leaveq 
  80237a:	c3                   	retq   

000000000080237b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80237b:	55                   	push   %rbp
  80237c:	48 89 e5             	mov    %rsp,%rbp
  80237f:	48 83 ec 30          	sub    $0x30,%rsp
  802383:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802386:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802389:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80238d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802390:	48 89 d6             	mov    %rdx,%rsi
  802393:	89 c7                	mov    %eax,%edi
  802395:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
  8023a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a8:	78 24                	js     8023ce <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ae:	8b 00                	mov    (%rax),%eax
  8023b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b4:	48 89 d6             	mov    %rdx,%rsi
  8023b7:	89 c7                	mov    %eax,%edi
  8023b9:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  8023c0:	00 00 00 
  8023c3:	ff d0                	callq  *%rax
  8023c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cc:	79 05                	jns    8023d3 <ftruncate+0x58>
		return r;
  8023ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d1:	eb 72                	jmp    802445 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d7:	8b 40 08             	mov    0x8(%rax),%eax
  8023da:	83 e0 03             	and    $0x3,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	75 3a                	jne    80241b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8023e1:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  8023e8:	00 00 00 
  8023eb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8023ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023f7:	89 c6                	mov    %eax,%esi
  8023f9:	48 bf 90 3d 80 00 00 	movabs $0x803d90,%rdi
  802400:	00 00 00 
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	48 b9 9c 04 80 00 00 	movabs $0x80049c,%rcx
  80240f:	00 00 00 
  802412:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802419:	eb 2a                	jmp    802445 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80241b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802423:	48 85 c0             	test   %rax,%rax
  802426:	75 07                	jne    80242f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802428:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80242d:	eb 16                	jmp    802445 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80242f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802433:	48 8b 40 30          	mov    0x30(%rax),%rax
  802437:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80243b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80243e:	89 ce                	mov    %ecx,%esi
  802440:	48 89 d7             	mov    %rdx,%rdi
  802443:	ff d0                	callq  *%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 30          	sub    $0x30,%rsp
  80244f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802452:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802456:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80245a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80245d:	48 89 d6             	mov    %rdx,%rsi
  802460:	89 c7                	mov    %eax,%edi
  802462:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  802469:	00 00 00 
  80246c:	ff d0                	callq  *%rax
  80246e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802471:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802475:	78 24                	js     80249b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247b:	8b 00                	mov    (%rax),%eax
  80247d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802481:	48 89 d6             	mov    %rdx,%rsi
  802484:	89 c7                	mov    %eax,%edi
  802486:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  80248d:	00 00 00 
  802490:	ff d0                	callq  *%rax
  802492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802499:	79 05                	jns    8024a0 <fstat+0x59>
		return r;
  80249b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249e:	eb 5e                	jmp    8024fe <fstat+0xb7>
	if (!dev->dev_stat)
  8024a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024a8:	48 85 c0             	test   %rax,%rax
  8024ab:	75 07                	jne    8024b4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b2:	eb 4a                	jmp    8024fe <fstat+0xb7>
	stat->st_name[0] = 0;
  8024b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024b8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024bf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024c6:	00 00 00 
	stat->st_isdir = 0;
  8024c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024cd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024d4:	00 00 00 
	stat->st_dev = dev;
  8024d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024df:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8024e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ea:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024f2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024f6:	48 89 ce             	mov    %rcx,%rsi
  8024f9:	48 89 d7             	mov    %rdx,%rdi
  8024fc:	ff d0                	callq  *%rax
}
  8024fe:	c9                   	leaveq 
  8024ff:	c3                   	retq   

0000000000802500 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802500:	55                   	push   %rbp
  802501:	48 89 e5             	mov    %rsp,%rbp
  802504:	48 83 ec 20          	sub    $0x20,%rsp
  802508:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80250c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802514:	be 00 00 00 00       	mov    $0x0,%esi
  802519:	48 89 c7             	mov    %rax,%rdi
  80251c:	48 b8 ee 25 80 00 00 	movabs $0x8025ee,%rax
  802523:	00 00 00 
  802526:	ff d0                	callq  *%rax
  802528:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252f:	79 05                	jns    802536 <stat+0x36>
		return fd;
  802531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802534:	eb 2f                	jmp    802565 <stat+0x65>
	r = fstat(fd, stat);
  802536:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80253a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253d:	48 89 d6             	mov    %rdx,%rsi
  802540:	89 c7                	mov    %eax,%edi
  802542:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  802549:	00 00 00 
  80254c:	ff d0                	callq  *%rax
  80254e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802554:	89 c7                	mov    %eax,%edi
  802556:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  80255d:	00 00 00 
  802560:	ff d0                	callq  *%rax
	return r;
  802562:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802565:	c9                   	leaveq 
  802566:	c3                   	retq   

0000000000802567 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802567:	55                   	push   %rbp
  802568:	48 89 e5             	mov    %rsp,%rbp
  80256b:	48 83 ec 10          	sub    $0x10,%rsp
  80256f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802572:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802576:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80257d:	00 00 00 
  802580:	8b 00                	mov    (%rax),%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	75 1d                	jne    8025a3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802586:	bf 01 00 00 00       	mov    $0x1,%edi
  80258b:	48 b8 1e 36 80 00 00 	movabs $0x80361e,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax
  802597:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80259e:	00 00 00 
  8025a1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025a3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025aa:	00 00 00 
  8025ad:	8b 00                	mov    (%rax),%eax
  8025af:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025b2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025b7:	48 ba 00 70 c0 00 00 	movabs $0xc07000,%rdx
  8025be:	00 00 00 
  8025c1:	89 c7                	mov    %eax,%edi
  8025c3:	48 b8 86 35 80 00 00 	movabs $0x803586,%rax
  8025ca:	00 00 00 
  8025cd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d8:	48 89 c6             	mov    %rax,%rsi
  8025db:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e0:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
}
  8025ec:	c9                   	leaveq 
  8025ed:	c3                   	retq   

00000000008025ee <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025ee:	55                   	push   %rbp
  8025ef:	48 89 e5             	mov    %rsp,%rbp
  8025f2:	48 83 ec 20          	sub    $0x20,%rsp
  8025f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8025fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802601:	48 89 c7             	mov    %rax,%rdi
  802604:	48 b8 f8 0f 80 00 00 	movabs $0x800ff8,%rax
  80260b:	00 00 00 
  80260e:	ff d0                	callq  *%rax
  802610:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802615:	7e 0a                	jle    802621 <open+0x33>
		return -E_BAD_PATH;
  802617:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80261c:	e9 a5 00 00 00       	jmpq   8026c6 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802621:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802625:	48 89 c7             	mov    %rax,%rdi
  802628:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  80262f:	00 00 00 
  802632:	ff d0                	callq  *%rax
  802634:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802637:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263b:	79 08                	jns    802645 <open+0x57>
		return r;
  80263d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802640:	e9 81 00 00 00       	jmpq   8026c6 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802649:	48 89 c6             	mov    %rax,%rsi
  80264c:	48 bf 00 70 c0 00 00 	movabs $0xc07000,%rdi
  802653:	00 00 00 
  802656:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802662:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  802669:	00 00 00 
  80266c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80266f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802679:	48 89 c6             	mov    %rax,%rsi
  80267c:	bf 01 00 00 00       	mov    $0x1,%edi
  802681:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  802688:	00 00 00 
  80268b:	ff d0                	callq  *%rax
  80268d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802690:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802694:	79 1d                	jns    8026b3 <open+0xc5>
		fd_close(fd, 0);
  802696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269a:	be 00 00 00 00       	mov    $0x0,%esi
  80269f:	48 89 c7             	mov    %rax,%rdi
  8026a2:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
		return r;
  8026ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b1:	eb 13                	jmp    8026c6 <open+0xd8>
	}

	return fd2num(fd);
  8026b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b7:	48 89 c7             	mov    %rax,%rdi
  8026ba:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8026c6:	c9                   	leaveq 
  8026c7:	c3                   	retq   

00000000008026c8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026c8:	55                   	push   %rbp
  8026c9:	48 89 e5             	mov    %rsp,%rbp
  8026cc:	48 83 ec 10          	sub    $0x10,%rsp
  8026d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8026db:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  8026e2:	00 00 00 
  8026e5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8026e7:	be 00 00 00 00       	mov    $0x0,%esi
  8026ec:	bf 06 00 00 00       	mov    $0x6,%edi
  8026f1:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax
}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   

00000000008026ff <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 30          	sub    $0x30,%rsp
  802707:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80270f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802717:	8b 50 0c             	mov    0xc(%rax),%edx
  80271a:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  802721:	00 00 00 
  802724:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802726:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  80272d:	00 00 00 
  802730:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802734:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802738:	be 00 00 00 00       	mov    $0x0,%esi
  80273d:	bf 03 00 00 00       	mov    $0x3,%edi
  802742:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  802749:	00 00 00 
  80274c:	ff d0                	callq  *%rax
  80274e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802751:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802755:	79 08                	jns    80275f <devfile_read+0x60>
		return r;
  802757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275a:	e9 a4 00 00 00       	jmpq   802803 <devfile_read+0x104>
	assert(r <= n);
  80275f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802762:	48 98                	cltq   
  802764:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802768:	76 35                	jbe    80279f <devfile_read+0xa0>
  80276a:	48 b9 bd 3d 80 00 00 	movabs $0x803dbd,%rcx
  802771:	00 00 00 
  802774:	48 ba c4 3d 80 00 00 	movabs $0x803dc4,%rdx
  80277b:	00 00 00 
  80277e:	be 84 00 00 00       	mov    $0x84,%esi
  802783:	48 bf d9 3d 80 00 00 	movabs $0x803dd9,%rdi
  80278a:	00 00 00 
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
  802792:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  802799:	00 00 00 
  80279c:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80279f:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8027a6:	7e 35                	jle    8027dd <devfile_read+0xde>
  8027a8:	48 b9 e4 3d 80 00 00 	movabs $0x803de4,%rcx
  8027af:	00 00 00 
  8027b2:	48 ba c4 3d 80 00 00 	movabs $0x803dc4,%rdx
  8027b9:	00 00 00 
  8027bc:	be 85 00 00 00       	mov    $0x85,%esi
  8027c1:	48 bf d9 3d 80 00 00 	movabs $0x803dd9,%rdi
  8027c8:	00 00 00 
  8027cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d0:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  8027d7:	00 00 00 
  8027da:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8027dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e0:	48 63 d0             	movslq %eax,%rdx
  8027e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e7:	48 be 00 70 c0 00 00 	movabs $0xc07000,%rsi
  8027ee:	00 00 00 
  8027f1:	48 89 c7             	mov    %rax,%rdi
  8027f4:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
	return r;
  802800:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802803:	c9                   	leaveq 
  802804:	c3                   	retq   

0000000000802805 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802805:	55                   	push   %rbp
  802806:	48 89 e5             	mov    %rsp,%rbp
  802809:	48 83 ec 30          	sub    $0x30,%rsp
  80280d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802811:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802815:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281d:	8b 50 0c             	mov    0xc(%rax),%edx
  802820:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  802827:	00 00 00 
  80282a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80282c:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  802833:	00 00 00 
  802836:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80283a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80283e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802845:	00 
  802846:	76 35                	jbe    80287d <devfile_write+0x78>
  802848:	48 b9 f0 3d 80 00 00 	movabs $0x803df0,%rcx
  80284f:	00 00 00 
  802852:	48 ba c4 3d 80 00 00 	movabs $0x803dc4,%rdx
  802859:	00 00 00 
  80285c:	be 9e 00 00 00       	mov    $0x9e,%esi
  802861:	48 bf d9 3d 80 00 00 	movabs $0x803dd9,%rdi
  802868:	00 00 00 
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  802877:	00 00 00 
  80287a:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80287d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802885:	48 89 c6             	mov    %rax,%rsi
  802888:	48 bf 10 70 c0 00 00 	movabs $0xc07010,%rdi
  80288f:	00 00 00 
  802892:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  802899:	00 00 00 
  80289c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80289e:	be 00 00 00 00       	mov    $0x0,%esi
  8028a3:	bf 04 00 00 00       	mov    $0x4,%edi
  8028a8:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	callq  *%rax
  8028b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bb:	79 05                	jns    8028c2 <devfile_write+0xbd>
		return r;
  8028bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c0:	eb 43                	jmp    802905 <devfile_write+0x100>
	assert(r <= n);
  8028c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c5:	48 98                	cltq   
  8028c7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028cb:	76 35                	jbe    802902 <devfile_write+0xfd>
  8028cd:	48 b9 bd 3d 80 00 00 	movabs $0x803dbd,%rcx
  8028d4:	00 00 00 
  8028d7:	48 ba c4 3d 80 00 00 	movabs $0x803dc4,%rdx
  8028de:	00 00 00 
  8028e1:	be a2 00 00 00       	mov    $0xa2,%esi
  8028e6:	48 bf d9 3d 80 00 00 	movabs $0x803dd9,%rdi
  8028ed:	00 00 00 
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f5:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  8028fc:	00 00 00 
  8028ff:	41 ff d0             	callq  *%r8
	return r;
  802902:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802905:	c9                   	leaveq 
  802906:	c3                   	retq   

0000000000802907 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802907:	55                   	push   %rbp
  802908:	48 89 e5             	mov    %rsp,%rbp
  80290b:	48 83 ec 20          	sub    $0x20,%rsp
  80290f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802913:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291b:	8b 50 0c             	mov    0xc(%rax),%edx
  80291e:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  802925:	00 00 00 
  802928:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80292a:	be 00 00 00 00       	mov    $0x0,%esi
  80292f:	bf 05 00 00 00       	mov    $0x5,%edi
  802934:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
  802940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802947:	79 05                	jns    80294e <devfile_stat+0x47>
		return r;
  802949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294c:	eb 56                	jmp    8029a4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80294e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802952:	48 be 00 70 c0 00 00 	movabs $0xc07000,%rsi
  802959:	00 00 00 
  80295c:	48 89 c7             	mov    %rax,%rdi
  80295f:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80296b:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  802972:	00 00 00 
  802975:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80297b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80297f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802985:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  80298c:	00 00 00 
  80298f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802995:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802999:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a4:	c9                   	leaveq 
  8029a5:	c3                   	retq   

00000000008029a6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 83 ec 10          	sub    $0x10,%rsp
  8029ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b9:	8b 50 0c             	mov    0xc(%rax),%edx
  8029bc:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  8029c3:	00 00 00 
  8029c6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029c8:	48 b8 00 70 c0 00 00 	movabs $0xc07000,%rax
  8029cf:	00 00 00 
  8029d2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029d8:	be 00 00 00 00       	mov    $0x0,%esi
  8029dd:	bf 02 00 00 00       	mov    $0x2,%edi
  8029e2:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
}
  8029ee:	c9                   	leaveq 
  8029ef:	c3                   	retq   

00000000008029f0 <remove>:

// Delete a file
int
remove(const char *path)
{
  8029f0:	55                   	push   %rbp
  8029f1:	48 89 e5             	mov    %rsp,%rbp
  8029f4:	48 83 ec 10          	sub    $0x10,%rsp
  8029f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a00:	48 89 c7             	mov    %rax,%rdi
  802a03:	48 b8 f8 0f 80 00 00 	movabs $0x800ff8,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a14:	7e 07                	jle    802a1d <remove+0x2d>
		return -E_BAD_PATH;
  802a16:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a1b:	eb 33                	jmp    802a50 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a21:	48 89 c6             	mov    %rax,%rsi
  802a24:	48 bf 00 70 c0 00 00 	movabs $0xc07000,%rdi
  802a2b:	00 00 00 
  802a2e:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a3a:	be 00 00 00 00       	mov    $0x0,%esi
  802a3f:	bf 07 00 00 00       	mov    $0x7,%edi
  802a44:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
}
  802a50:	c9                   	leaveq 
  802a51:	c3                   	retq   

0000000000802a52 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a52:	55                   	push   %rbp
  802a53:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a56:	be 00 00 00 00       	mov    $0x0,%esi
  802a5b:	bf 08 00 00 00       	mov    $0x8,%edi
  802a60:	48 b8 67 25 80 00 00 	movabs $0x802567,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
}
  802a6c:	5d                   	pop    %rbp
  802a6d:	c3                   	retq   

0000000000802a6e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a6e:	55                   	push   %rbp
  802a6f:	48 89 e5             	mov    %rsp,%rbp
  802a72:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a79:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a80:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a87:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a8e:	be 00 00 00 00       	mov    $0x0,%esi
  802a93:	48 89 c7             	mov    %rax,%rdi
  802a96:	48 b8 ee 25 80 00 00 	movabs $0x8025ee,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
  802aa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802aa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa9:	79 28                	jns    802ad3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aae:	89 c6                	mov    %eax,%esi
  802ab0:	48 bf 1d 3e 80 00 00 	movabs $0x803e1d,%rdi
  802ab7:	00 00 00 
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  802ac6:	00 00 00 
  802ac9:	ff d2                	callq  *%rdx
		return fd_src;
  802acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ace:	e9 74 01 00 00       	jmpq   802c47 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ad3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802ada:	be 01 01 00 00       	mov    $0x101,%esi
  802adf:	48 89 c7             	mov    %rax,%rdi
  802ae2:	48 b8 ee 25 80 00 00 	movabs $0x8025ee,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
  802aee:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802af1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802af5:	79 39                	jns    802b30 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802af7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802afa:	89 c6                	mov    %eax,%esi
  802afc:	48 bf 33 3e 80 00 00 	movabs $0x803e33,%rdi
  802b03:	00 00 00 
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  802b12:	00 00 00 
  802b15:	ff d2                	callq  *%rdx
		close(fd_src);
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	89 c7                	mov    %eax,%edi
  802b1c:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802b23:	00 00 00 
  802b26:	ff d0                	callq  *%rax
		return fd_dest;
  802b28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b2b:	e9 17 01 00 00       	jmpq   802c47 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b30:	eb 74                	jmp    802ba6 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b35:	48 63 d0             	movslq %eax,%rdx
  802b38:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b42:	48 89 ce             	mov    %rcx,%rsi
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 62 22 80 00 00 	movabs $0x802262,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b56:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b5a:	79 4a                	jns    802ba6 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b5c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b5f:	89 c6                	mov    %eax,%esi
  802b61:	48 bf 4d 3e 80 00 00 	movabs $0x803e4d,%rdi
  802b68:	00 00 00 
  802b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b70:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  802b77:	00 00 00 
  802b7a:	ff d2                	callq  *%rdx
			close(fd_src);
  802b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7f:	89 c7                	mov    %eax,%edi
  802b81:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
			close(fd_dest);
  802b8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b90:	89 c7                	mov    %eax,%edi
  802b92:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
			return write_size;
  802b9e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ba1:	e9 a1 00 00 00       	jmpq   802c47 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ba6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb0:	ba 00 02 00 00       	mov    $0x200,%edx
  802bb5:	48 89 ce             	mov    %rcx,%rsi
  802bb8:	89 c7                	mov    %eax,%edi
  802bba:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
  802bc6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bcd:	0f 8f 5f ff ff ff    	jg     802b32 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bd7:	79 47                	jns    802c20 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802bd9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bdc:	89 c6                	mov    %eax,%esi
  802bde:	48 bf 60 3e 80 00 00 	movabs $0x803e60,%rdi
  802be5:	00 00 00 
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bed:	48 ba 9c 04 80 00 00 	movabs $0x80049c,%rdx
  802bf4:	00 00 00 
  802bf7:	ff d2                	callq  *%rdx
		close(fd_src);
  802bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
		close(fd_dest);
  802c0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c0d:	89 c7                	mov    %eax,%edi
  802c0f:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
		return read_size;
  802c1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c1e:	eb 27                	jmp    802c47 <copy+0x1d9>
	}
	close(fd_src);
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
	close(fd_dest);
  802c31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c34:	89 c7                	mov    %eax,%edi
  802c36:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
	return 0;
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802c47:	c9                   	leaveq 
  802c48:	c3                   	retq   

0000000000802c49 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c49:	55                   	push   %rbp
  802c4a:	48 89 e5             	mov    %rsp,%rbp
  802c4d:	53                   	push   %rbx
  802c4e:	48 83 ec 38          	sub    $0x38,%rsp
  802c52:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c56:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802c5a:	48 89 c7             	mov    %rax,%rdi
  802c5d:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	callq  *%rax
  802c69:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c70:	0f 88 bf 01 00 00    	js     802e35 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c7a:	ba 07 04 00 00       	mov    $0x407,%edx
  802c7f:	48 89 c6             	mov    %rax,%rsi
  802c82:	bf 00 00 00 00       	mov    $0x0,%edi
  802c87:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  802c8e:	00 00 00 
  802c91:	ff d0                	callq  *%rax
  802c93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c9a:	0f 88 95 01 00 00    	js     802e35 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ca0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ca4:	48 89 c7             	mov    %rax,%rdi
  802ca7:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
  802cb3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cb6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cba:	0f 88 5d 01 00 00    	js     802e1d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc4:	ba 07 04 00 00       	mov    $0x407,%edx
  802cc9:	48 89 c6             	mov    %rax,%rsi
  802ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd1:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
  802cdd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ce0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ce4:	0f 88 33 01 00 00    	js     802e1d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802cea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cee:	48 89 c7             	mov    %rax,%rdi
  802cf1:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d05:	ba 07 04 00 00       	mov    $0x407,%edx
  802d0a:	48 89 c6             	mov    %rax,%rsi
  802d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d12:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  802d19:	00 00 00 
  802d1c:	ff d0                	callq  *%rax
  802d1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d25:	79 05                	jns    802d2c <pipe+0xe3>
		goto err2;
  802d27:	e9 d9 00 00 00       	jmpq   802e05 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d30:	48 89 c7             	mov    %rax,%rdi
  802d33:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  802d3a:	00 00 00 
  802d3d:	ff d0                	callq  *%rax
  802d3f:	48 89 c2             	mov    %rax,%rdx
  802d42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d46:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802d4c:	48 89 d1             	mov    %rdx,%rcx
  802d4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d54:	48 89 c6             	mov    %rax,%rsi
  802d57:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5c:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d6f:	79 1b                	jns    802d8c <pipe+0x143>
		goto err3;
  802d71:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d76:	48 89 c6             	mov    %rax,%rsi
  802d79:	bf 00 00 00 00       	mov    $0x0,%edi
  802d7e:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
  802d8a:	eb 79                	jmp    802e05 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d90:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d97:	00 00 00 
  802d9a:	8b 12                	mov    (%rdx),%edx
  802d9c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802da9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dad:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802db4:	00 00 00 
  802db7:	8b 12                	mov    (%rdx),%edx
  802db9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802dbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dbf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802dc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dca:	48 89 c7             	mov    %rax,%rdi
  802dcd:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
  802dd9:	89 c2                	mov    %eax,%edx
  802ddb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ddf:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802de1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802de5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802de9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ded:	48 89 c7             	mov    %rax,%rdi
  802df0:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  802df7:	00 00 00 
  802dfa:	ff d0                	callq  *%rax
  802dfc:	89 03                	mov    %eax,(%rbx)
	return 0;
  802dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802e03:	eb 33                	jmp    802e38 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802e05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e09:	48 89 c6             	mov    %rax,%rsi
  802e0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e11:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  802e18:	00 00 00 
  802e1b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802e1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e21:	48 89 c6             	mov    %rax,%rsi
  802e24:	bf 00 00 00 00       	mov    $0x0,%edi
  802e29:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  802e30:	00 00 00 
  802e33:	ff d0                	callq  *%rax
err:
	return r;
  802e35:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802e38:	48 83 c4 38          	add    $0x38,%rsp
  802e3c:	5b                   	pop    %rbx
  802e3d:	5d                   	pop    %rbp
  802e3e:	c3                   	retq   

0000000000802e3f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e3f:	55                   	push   %rbp
  802e40:	48 89 e5             	mov    %rsp,%rbp
  802e43:	53                   	push   %rbx
  802e44:	48 83 ec 28          	sub    $0x28,%rsp
  802e48:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e50:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  802e57:	00 00 00 
  802e5a:	48 8b 00             	mov    (%rax),%rax
  802e5d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e63:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802e66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6a:	48 89 c7             	mov    %rax,%rdi
  802e6d:	48 b8 a0 36 80 00 00 	movabs $0x8036a0,%rax
  802e74:	00 00 00 
  802e77:	ff d0                	callq  *%rax
  802e79:	89 c3                	mov    %eax,%ebx
  802e7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7f:	48 89 c7             	mov    %rax,%rdi
  802e82:	48 b8 a0 36 80 00 00 	movabs $0x8036a0,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	callq  *%rax
  802e8e:	39 c3                	cmp    %eax,%ebx
  802e90:	0f 94 c0             	sete   %al
  802e93:	0f b6 c0             	movzbl %al,%eax
  802e96:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802e99:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  802ea0:	00 00 00 
  802ea3:	48 8b 00             	mov    (%rax),%rax
  802ea6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802eac:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802eaf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eb2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802eb5:	75 05                	jne    802ebc <_pipeisclosed+0x7d>
			return ret;
  802eb7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802eba:	eb 4f                	jmp    802f0b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ebc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ebf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ec2:	74 42                	je     802f06 <_pipeisclosed+0xc7>
  802ec4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802ec8:	75 3c                	jne    802f06 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802eca:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  802ed1:	00 00 00 
  802ed4:	48 8b 00             	mov    (%rax),%rax
  802ed7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802edd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802ee0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ee3:	89 c6                	mov    %eax,%esi
  802ee5:	48 bf 7b 3e 80 00 00 	movabs $0x803e7b,%rdi
  802eec:	00 00 00 
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef4:	49 b8 9c 04 80 00 00 	movabs $0x80049c,%r8
  802efb:	00 00 00 
  802efe:	41 ff d0             	callq  *%r8
	}
  802f01:	e9 4a ff ff ff       	jmpq   802e50 <_pipeisclosed+0x11>
  802f06:	e9 45 ff ff ff       	jmpq   802e50 <_pipeisclosed+0x11>
}
  802f0b:	48 83 c4 28          	add    $0x28,%rsp
  802f0f:	5b                   	pop    %rbx
  802f10:	5d                   	pop    %rbp
  802f11:	c3                   	retq   

0000000000802f12 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802f12:	55                   	push   %rbp
  802f13:	48 89 e5             	mov    %rsp,%rbp
  802f16:	48 83 ec 30          	sub    $0x30,%rsp
  802f1a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f21:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f24:	48 89 d6             	mov    %rdx,%rsi
  802f27:	89 c7                	mov    %eax,%edi
  802f29:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
  802f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3c:	79 05                	jns    802f43 <pipeisclosed+0x31>
		return r;
  802f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f41:	eb 31                	jmp    802f74 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	48 89 c7             	mov    %rax,%rdi
  802f4a:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f62:	48 89 d6             	mov    %rdx,%rsi
  802f65:	48 89 c7             	mov    %rax,%rdi
  802f68:	48 b8 3f 2e 80 00 00 	movabs $0x802e3f,%rax
  802f6f:	00 00 00 
  802f72:	ff d0                	callq  *%rax
}
  802f74:	c9                   	leaveq 
  802f75:	c3                   	retq   

0000000000802f76 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f76:	55                   	push   %rbp
  802f77:	48 89 e5             	mov    %rsp,%rbp
  802f7a:	48 83 ec 40          	sub    $0x40,%rsp
  802f7e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f82:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f86:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8e:	48 89 c7             	mov    %rax,%rdi
  802f91:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
  802f9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802fa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802fa9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fb0:	00 
  802fb1:	e9 92 00 00 00       	jmpq   803048 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802fb6:	eb 41                	jmp    802ff9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802fb8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802fbd:	74 09                	je     802fc8 <devpipe_read+0x52>
				return i;
  802fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc3:	e9 92 00 00 00       	jmpq   80305a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802fc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd0:	48 89 d6             	mov    %rdx,%rsi
  802fd3:	48 89 c7             	mov    %rax,%rdi
  802fd6:	48 b8 3f 2e 80 00 00 	movabs $0x802e3f,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 07                	je     802fed <devpipe_read+0x77>
				return 0;
  802fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  802feb:	eb 6d                	jmp    80305a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fed:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ff9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffd:	8b 10                	mov    (%rax),%edx
  802fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803003:	8b 40 04             	mov    0x4(%rax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	74 ae                	je     802fb8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80300a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803012:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301a:	8b 00                	mov    (%rax),%eax
  80301c:	99                   	cltd   
  80301d:	c1 ea 1b             	shr    $0x1b,%edx
  803020:	01 d0                	add    %edx,%eax
  803022:	83 e0 1f             	and    $0x1f,%eax
  803025:	29 d0                	sub    %edx,%eax
  803027:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80302b:	48 98                	cltq   
  80302d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803032:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803038:	8b 00                	mov    (%rax),%eax
  80303a:	8d 50 01             	lea    0x1(%rax),%edx
  80303d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803041:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803043:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803050:	0f 82 60 ff ff ff    	jb     802fb6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80305a:	c9                   	leaveq 
  80305b:	c3                   	retq   

000000000080305c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80305c:	55                   	push   %rbp
  80305d:	48 89 e5             	mov    %rsp,%rbp
  803060:	48 83 ec 40          	sub    $0x40,%rsp
  803064:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803068:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80306c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803070:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803074:	48 89 c7             	mov    %rax,%rdi
  803077:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803087:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80308f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803096:	00 
  803097:	e9 8e 00 00 00       	jmpq   80312a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80309c:	eb 31                	jmp    8030cf <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80309e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a6:	48 89 d6             	mov    %rdx,%rsi
  8030a9:	48 89 c7             	mov    %rax,%rdi
  8030ac:	48 b8 3f 2e 80 00 00 	movabs $0x802e3f,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 07                	je     8030c3 <devpipe_write+0x67>
				return 0;
  8030bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c1:	eb 79                	jmp    80313c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8030c3:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  8030ca:	00 00 00 
  8030cd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d3:	8b 40 04             	mov    0x4(%rax),%eax
  8030d6:	48 63 d0             	movslq %eax,%rdx
  8030d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dd:	8b 00                	mov    (%rax),%eax
  8030df:	48 98                	cltq   
  8030e1:	48 83 c0 20          	add    $0x20,%rax
  8030e5:	48 39 c2             	cmp    %rax,%rdx
  8030e8:	73 b4                	jae    80309e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ee:	8b 40 04             	mov    0x4(%rax),%eax
  8030f1:	99                   	cltd   
  8030f2:	c1 ea 1b             	shr    $0x1b,%edx
  8030f5:	01 d0                	add    %edx,%eax
  8030f7:	83 e0 1f             	and    $0x1f,%eax
  8030fa:	29 d0                	sub    %edx,%eax
  8030fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803100:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803104:	48 01 ca             	add    %rcx,%rdx
  803107:	0f b6 0a             	movzbl (%rdx),%ecx
  80310a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80310e:	48 98                	cltq   
  803110:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803118:	8b 40 04             	mov    0x4(%rax),%eax
  80311b:	8d 50 01             	lea    0x1(%rax),%edx
  80311e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803122:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803125:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80312a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803132:	0f 82 64 ff ff ff    	jb     80309c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80313c:	c9                   	leaveq 
  80313d:	c3                   	retq   

000000000080313e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80313e:	55                   	push   %rbp
  80313f:	48 89 e5             	mov    %rsp,%rbp
  803142:	48 83 ec 20          	sub    $0x20,%rsp
  803146:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80314a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80314e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803152:	48 89 c7             	mov    %rax,%rdi
  803155:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
  803161:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803165:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803169:	48 be 8e 3e 80 00 00 	movabs $0x803e8e,%rsi
  803170:	00 00 00 
  803173:	48 89 c7             	mov    %rax,%rdi
  803176:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803186:	8b 50 04             	mov    0x4(%rax),%edx
  803189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318d:	8b 00                	mov    (%rax),%eax
  80318f:	29 c2                	sub    %eax,%edx
  803191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803195:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80319b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8031a6:	00 00 00 
	stat->st_dev = &devpipe;
  8031a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ad:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8031b4:	00 00 00 
  8031b7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8031be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c3:	c9                   	leaveq 
  8031c4:	c3                   	retq   

00000000008031c5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8031c5:	55                   	push   %rbp
  8031c6:	48 89 e5             	mov    %rsp,%rbp
  8031c9:	48 83 ec 10          	sub    $0x10,%rsp
  8031cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8031d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d5:	48 89 c6             	mov    %rax,%rsi
  8031d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8031dd:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8031e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ed:	48 89 c7             	mov    %rax,%rdi
  8031f0:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
  8031fc:	48 89 c6             	mov    %rax,%rsi
  8031ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803204:	48 b8 3e 1a 80 00 00 	movabs $0x801a3e,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
}
  803210:	c9                   	leaveq 
  803211:	c3                   	retq   

0000000000803212 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803212:	55                   	push   %rbp
  803213:	48 89 e5             	mov    %rsp,%rbp
  803216:	48 83 ec 20          	sub    $0x20,%rsp
  80321a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80321d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803220:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803223:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803227:	be 01 00 00 00       	mov    $0x1,%esi
  80322c:	48 89 c7             	mov    %rax,%rdi
  80322f:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
}
  80323b:	c9                   	leaveq 
  80323c:	c3                   	retq   

000000000080323d <getchar>:

int
getchar(void)
{
  80323d:	55                   	push   %rbp
  80323e:	48 89 e5             	mov    %rsp,%rbp
  803241:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803245:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803249:	ba 01 00 00 00       	mov    $0x1,%edx
  80324e:	48 89 c6             	mov    %rax,%rsi
  803251:	bf 00 00 00 00       	mov    $0x0,%edi
  803256:	48 b8 18 21 80 00 00 	movabs $0x802118,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
  803262:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803265:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803269:	79 05                	jns    803270 <getchar+0x33>
		return r;
  80326b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326e:	eb 14                	jmp    803284 <getchar+0x47>
	if (r < 1)
  803270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803274:	7f 07                	jg     80327d <getchar+0x40>
		return -E_EOF;
  803276:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80327b:	eb 07                	jmp    803284 <getchar+0x47>
	return c;
  80327d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803281:	0f b6 c0             	movzbl %al,%eax
}
  803284:	c9                   	leaveq 
  803285:	c3                   	retq   

0000000000803286 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803286:	55                   	push   %rbp
  803287:	48 89 e5             	mov    %rsp,%rbp
  80328a:	48 83 ec 20          	sub    $0x20,%rsp
  80328e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803291:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803295:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803298:	48 89 d6             	mov    %rdx,%rsi
  80329b:	89 c7                	mov    %eax,%edi
  80329d:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
  8032a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b0:	79 05                	jns    8032b7 <iscons+0x31>
		return r;
  8032b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b5:	eb 1a                	jmp    8032d1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8032b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bb:	8b 10                	mov    (%rax),%edx
  8032bd:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8032c4:	00 00 00 
  8032c7:	8b 00                	mov    (%rax),%eax
  8032c9:	39 c2                	cmp    %eax,%edx
  8032cb:	0f 94 c0             	sete   %al
  8032ce:	0f b6 c0             	movzbl %al,%eax
}
  8032d1:	c9                   	leaveq 
  8032d2:	c3                   	retq   

00000000008032d3 <opencons>:

int
opencons(void)
{
  8032d3:	55                   	push   %rbp
  8032d4:	48 89 e5             	mov    %rsp,%rbp
  8032d7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8032db:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032df:	48 89 c7             	mov    %rax,%rdi
  8032e2:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
  8032ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f5:	79 05                	jns    8032fc <opencons+0x29>
		return r;
  8032f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fa:	eb 5b                	jmp    803357 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8032fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803300:	ba 07 04 00 00       	mov    $0x407,%edx
  803305:	48 89 c6             	mov    %rax,%rsi
  803308:	bf 00 00 00 00       	mov    $0x0,%edi
  80330d:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
  803319:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803320:	79 05                	jns    803327 <opencons+0x54>
		return r;
  803322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803325:	eb 30                	jmp    803357 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332b:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803332:	00 00 00 
  803335:	8b 12                	mov    (%rdx),%edx
  803337:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
}
  803357:	c9                   	leaveq 
  803358:	c3                   	retq   

0000000000803359 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803359:	55                   	push   %rbp
  80335a:	48 89 e5             	mov    %rsp,%rbp
  80335d:	48 83 ec 30          	sub    $0x30,%rsp
  803361:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803365:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803369:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80336d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803372:	75 07                	jne    80337b <devcons_read+0x22>
		return 0;
  803374:	b8 00 00 00 00       	mov    $0x0,%eax
  803379:	eb 4b                	jmp    8033c6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80337b:	eb 0c                	jmp    803389 <devcons_read+0x30>
		sys_yield();
  80337d:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803389:	48 b8 95 18 80 00 00 	movabs $0x801895,%rax
  803390:	00 00 00 
  803393:	ff d0                	callq  *%rax
  803395:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803398:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339c:	74 df                	je     80337d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80339e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a2:	79 05                	jns    8033a9 <devcons_read+0x50>
		return c;
  8033a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a7:	eb 1d                	jmp    8033c6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8033a9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8033ad:	75 07                	jne    8033b6 <devcons_read+0x5d>
		return 0;
  8033af:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b4:	eb 10                	jmp    8033c6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8033b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b9:	89 c2                	mov    %eax,%edx
  8033bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033bf:	88 10                	mov    %dl,(%rax)
	return 1;
  8033c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8033c6:	c9                   	leaveq 
  8033c7:	c3                   	retq   

00000000008033c8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033c8:	55                   	push   %rbp
  8033c9:	48 89 e5             	mov    %rsp,%rbp
  8033cc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8033d3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8033da:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8033e1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033ef:	eb 76                	jmp    803467 <devcons_write+0x9f>
		m = n - tot;
  8033f1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8033f8:	89 c2                	mov    %eax,%edx
  8033fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fd:	29 c2                	sub    %eax,%edx
  8033ff:	89 d0                	mov    %edx,%eax
  803401:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803404:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803407:	83 f8 7f             	cmp    $0x7f,%eax
  80340a:	76 07                	jbe    803413 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80340c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803413:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803416:	48 63 d0             	movslq %eax,%rdx
  803419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341c:	48 63 c8             	movslq %eax,%rcx
  80341f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803426:	48 01 c1             	add    %rax,%rcx
  803429:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803430:	48 89 ce             	mov    %rcx,%rsi
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803442:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803445:	48 63 d0             	movslq %eax,%rdx
  803448:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80344f:	48 89 d6             	mov    %rdx,%rsi
  803452:	48 89 c7             	mov    %rax,%rdi
  803455:	48 b8 4b 18 80 00 00 	movabs $0x80184b,%rax
  80345c:	00 00 00 
  80345f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803461:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803464:	01 45 fc             	add    %eax,-0x4(%rbp)
  803467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346a:	48 98                	cltq   
  80346c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803473:	0f 82 78 ff ff ff    	jb     8033f1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803479:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80347c:	c9                   	leaveq 
  80347d:	c3                   	retq   

000000000080347e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80347e:	55                   	push   %rbp
  80347f:	48 89 e5             	mov    %rsp,%rbp
  803482:	48 83 ec 08          	sub    $0x8,%rsp
  803486:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80348a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348f:	c9                   	leaveq 
  803490:	c3                   	retq   

0000000000803491 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803491:	55                   	push   %rbp
  803492:	48 89 e5             	mov    %rsp,%rbp
  803495:	48 83 ec 10          	sub    $0x10,%rsp
  803499:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80349d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8034a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a5:	48 be 9a 3e 80 00 00 	movabs $0x803e9a,%rsi
  8034ac:	00 00 00 
  8034af:	48 89 c7             	mov    %rax,%rdi
  8034b2:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
	return 0;
  8034be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034c3:	c9                   	leaveq 
  8034c4:	c3                   	retq   

00000000008034c5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034c5:	55                   	push   %rbp
  8034c6:	48 89 e5             	mov    %rsp,%rbp
  8034c9:	48 83 ec 30          	sub    $0x30,%rsp
  8034cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8034d9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034de:	75 0e                	jne    8034ee <ipc_recv+0x29>
        pg = (void *)UTOP;
  8034e0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034e7:	00 00 00 
  8034ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8034ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f2:	48 89 c7             	mov    %rax,%rdi
  8034f5:	48 b8 bc 1b 80 00 00 	movabs $0x801bbc,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
  803501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803508:	79 27                	jns    803531 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80350a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80350f:	74 0a                	je     80351b <ipc_recv+0x56>
            *from_env_store = 0;
  803511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803515:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80351b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803520:	74 0a                	je     80352c <ipc_recv+0x67>
            *perm_store = 0;
  803522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803526:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80352c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352f:	eb 53                	jmp    803584 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803531:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803536:	74 19                	je     803551 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803538:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  80353f:	00 00 00 
  803542:	48 8b 00             	mov    (%rax),%rax
  803545:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80354b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354f:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803551:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803556:	74 19                	je     803571 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803558:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  80355f:	00 00 00 
  803562:	48 8b 00             	mov    (%rax),%rax
  803565:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80356b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80356f:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803571:	48 b8 20 60 c0 00 00 	movabs $0xc06020,%rax
  803578:	00 00 00 
  80357b:	48 8b 00             	mov    (%rax),%rax
  80357e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803584:	c9                   	leaveq 
  803585:	c3                   	retq   

0000000000803586 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803586:	55                   	push   %rbp
  803587:	48 89 e5             	mov    %rsp,%rbp
  80358a:	48 83 ec 30          	sub    $0x30,%rsp
  80358e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803591:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803594:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803598:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80359b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035a0:	75 0e                	jne    8035b0 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8035a2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8035a9:	00 00 00 
  8035ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8035b0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035b3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035bd:	89 c7                	mov    %eax,%edi
  8035bf:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
  8035cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8035ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d2:	79 36                	jns    80360a <ipc_send+0x84>
  8035d4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8035d8:	74 30                	je     80360a <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8035da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035dd:	89 c1                	mov    %eax,%ecx
  8035df:	48 ba a1 3e 80 00 00 	movabs $0x803ea1,%rdx
  8035e6:	00 00 00 
  8035e9:	be 49 00 00 00       	mov    $0x49,%esi
  8035ee:	48 bf ae 3e 80 00 00 	movabs $0x803eae,%rdi
  8035f5:	00 00 00 
  8035f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fd:	49 b8 63 02 80 00 00 	movabs $0x800263,%r8
  803604:	00 00 00 
  803607:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80360a:	48 b8 55 19 80 00 00 	movabs $0x801955,%rax
  803611:	00 00 00 
  803614:	ff d0                	callq  *%rax
    } while(r != 0);
  803616:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80361a:	75 94                	jne    8035b0 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80361c:	c9                   	leaveq 
  80361d:	c3                   	retq   

000000000080361e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80361e:	55                   	push   %rbp
  80361f:	48 89 e5             	mov    %rsp,%rbp
  803622:	48 83 ec 14          	sub    $0x14,%rsp
  803626:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803630:	eb 5e                	jmp    803690 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803632:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803639:	00 00 00 
  80363c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363f:	48 63 d0             	movslq %eax,%rdx
  803642:	48 89 d0             	mov    %rdx,%rax
  803645:	48 c1 e0 03          	shl    $0x3,%rax
  803649:	48 01 d0             	add    %rdx,%rax
  80364c:	48 c1 e0 05          	shl    $0x5,%rax
  803650:	48 01 c8             	add    %rcx,%rax
  803653:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803659:	8b 00                	mov    (%rax),%eax
  80365b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80365e:	75 2c                	jne    80368c <ipc_find_env+0x6e>
			return envs[i].env_id;
  803660:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803667:	00 00 00 
  80366a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366d:	48 63 d0             	movslq %eax,%rdx
  803670:	48 89 d0             	mov    %rdx,%rax
  803673:	48 c1 e0 03          	shl    $0x3,%rax
  803677:	48 01 d0             	add    %rdx,%rax
  80367a:	48 c1 e0 05          	shl    $0x5,%rax
  80367e:	48 01 c8             	add    %rcx,%rax
  803681:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803687:	8b 40 08             	mov    0x8(%rax),%eax
  80368a:	eb 12                	jmp    80369e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80368c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803690:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803697:	7e 99                	jle    803632 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80369e:	c9                   	leaveq 
  80369f:	c3                   	retq   

00000000008036a0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8036a0:	55                   	push   %rbp
  8036a1:	48 89 e5             	mov    %rsp,%rbp
  8036a4:	48 83 ec 18          	sub    $0x18,%rsp
  8036a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8036ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b0:	48 c1 e8 15          	shr    $0x15,%rax
  8036b4:	48 89 c2             	mov    %rax,%rdx
  8036b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036be:	01 00 00 
  8036c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036c5:	83 e0 01             	and    $0x1,%eax
  8036c8:	48 85 c0             	test   %rax,%rax
  8036cb:	75 07                	jne    8036d4 <pageref+0x34>
		return 0;
  8036cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d2:	eb 53                	jmp    803727 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8036d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8036dc:	48 89 c2             	mov    %rax,%rdx
  8036df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036e6:	01 00 00 
  8036e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8036f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f5:	83 e0 01             	and    $0x1,%eax
  8036f8:	48 85 c0             	test   %rax,%rax
  8036fb:	75 07                	jne    803704 <pageref+0x64>
		return 0;
  8036fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803702:	eb 23                	jmp    803727 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803704:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803708:	48 c1 e8 0c          	shr    $0xc,%rax
  80370c:	48 89 c2             	mov    %rax,%rdx
  80370f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803716:	00 00 00 
  803719:	48 c1 e2 04          	shl    $0x4,%rdx
  80371d:	48 01 d0             	add    %rdx,%rax
  803720:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803724:	0f b7 c0             	movzwl %ax,%eax
}
  803727:	c9                   	leaveq 
  803728:	c3                   	retq   
