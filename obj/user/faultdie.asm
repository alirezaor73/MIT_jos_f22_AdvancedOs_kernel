
obj/user/faultdie:     file format elf64-x86-64


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
  80003c:	e8 9c 00 00 00       	callq  8000dd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800062:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800065:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800068:	83 e0 07             	and    $0x7,%eax
  80006b:	89 c2                	mov    %eax,%edx
  80006d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800071:	48 89 c6             	mov    %rax,%rsi
  800074:	48 bf 40 1c 80 00 00 	movabs $0x801c40,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 aa 02 80 00 00 	movabs $0x8002aa,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
}
  8000a9:	c9                   	leaveq 
  8000aa:	c3                   	retq   

00000000008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	55                   	push   %rbp
  8000ac:	48 89 e5             	mov    %rsp,%rbp
  8000af:	48 83 ec 10          	sub    $0x10,%rsp
  8000b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000ba:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  8000c1:	00 00 00 
  8000c4:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d0:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000db:	c9                   	leaveq 
  8000dc:	c3                   	retq   

00000000008000dd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %rbp
  8000de:	48 89 e5             	mov    %rsp,%rbp
  8000e1:	48 83 ec 20          	sub    $0x20,%rsp
  8000e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000ec:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
  8000f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8000fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000fe:	25 ff 03 00 00       	and    $0x3ff,%eax
  800103:	48 63 d0             	movslq %eax,%rdx
  800106:	48 89 d0             	mov    %rdx,%rax
  800109:	48 c1 e0 03          	shl    $0x3,%rax
  80010d:	48 01 d0             	add    %rdx,%rax
  800110:	48 c1 e0 05          	shl    $0x5,%rax
  800114:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80011b:	00 00 00 
  80011e:	48 01 c2             	add    %rax,%rdx
  800121:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800128:	00 00 00 
  80012b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800132:	7e 14                	jle    800148 <libmain+0x6b>
		binaryname = argv[0];
  800134:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800138:	48 8b 10             	mov    (%rax),%rdx
  80013b:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800142:	00 00 00 
  800145:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800148:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80014c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80014f:	48 89 d6             	mov    %rdx,%rsi
  800152:	89 c7                	mov    %eax,%edi
  800154:	48 b8 ab 00 80 00 00 	movabs $0x8000ab,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800160:	48 b8 6e 01 80 00 00 	movabs $0x80016e,%rax
  800167:	00 00 00 
  80016a:	ff d0                	callq  *%rax
}
  80016c:	c9                   	leaveq 
  80016d:	c3                   	retq   

000000000080016e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016e:	55                   	push   %rbp
  80016f:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800172:	bf 00 00 00 00       	mov    $0x0,%edi
  800177:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
}
  800183:	5d                   	pop    %rbp
  800184:	c3                   	retq   

0000000000800185 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800185:	55                   	push   %rbp
  800186:	48 89 e5             	mov    %rsp,%rbp
  800189:	48 83 ec 10          	sub    $0x10,%rsp
  80018d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800190:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800198:	8b 00                	mov    (%rax),%eax
  80019a:	8d 48 01             	lea    0x1(%rax),%ecx
  80019d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a1:	89 0a                	mov    %ecx,(%rdx)
  8001a3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001a6:	89 d1                	mov    %edx,%ecx
  8001a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ac:	48 98                	cltq   
  8001ae:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b6:	8b 00                	mov    (%rax),%eax
  8001b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bd:	75 2c                	jne    8001eb <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c3:	8b 00                	mov    (%rax),%eax
  8001c5:	48 98                	cltq   
  8001c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001cb:	48 83 c2 08          	add    $0x8,%rdx
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	48 89 d7             	mov    %rdx,%rdi
  8001d5:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
        b->idx = 0;
  8001e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ef:	8b 40 04             	mov    0x4(%rax),%eax
  8001f2:	8d 50 01             	lea    0x1(%rax),%edx
  8001f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001fc:	c9                   	leaveq 
  8001fd:	c3                   	retq   

00000000008001fe <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001fe:	55                   	push   %rbp
  8001ff:	48 89 e5             	mov    %rsp,%rbp
  800202:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800209:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800210:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800217:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80021e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800225:	48 8b 0a             	mov    (%rdx),%rcx
  800228:	48 89 08             	mov    %rcx,(%rax)
  80022b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80022f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800233:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800237:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80023b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800242:	00 00 00 
    b.cnt = 0;
  800245:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80024c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80024f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800256:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80025d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800264:	48 89 c6             	mov    %rax,%rsi
  800267:	48 bf 85 01 80 00 00 	movabs $0x800185,%rdi
  80026e:	00 00 00 
  800271:	48 b8 5d 06 80 00 00 	movabs $0x80065d,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80027d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800283:	48 98                	cltq   
  800285:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80028c:	48 83 c2 08          	add    $0x8,%rdx
  800290:	48 89 c6             	mov    %rax,%rsi
  800293:	48 89 d7             	mov    %rdx,%rdi
  800296:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002a8:	c9                   	leaveq 
  8002a9:	c3                   	retq   

00000000008002aa <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002b5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002bc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002c3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002ca:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002d1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002d8:	84 c0                	test   %al,%al
  8002da:	74 20                	je     8002fc <cprintf+0x52>
  8002dc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002e0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002e4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002e8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002ec:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002f0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002f4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002f8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002fc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800303:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80030a:	00 00 00 
  80030d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800314:	00 00 00 
  800317:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80031b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800322:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800329:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800330:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800337:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80033e:	48 8b 0a             	mov    (%rdx),%rcx
  800341:	48 89 08             	mov    %rcx,(%rax)
  800344:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800348:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80034c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800350:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800354:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80035b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800362:	48 89 d6             	mov    %rdx,%rsi
  800365:	48 89 c7             	mov    %rax,%rdi
  800368:	48 b8 fe 01 80 00 00 	movabs $0x8001fe,%rax
  80036f:	00 00 00 
  800372:	ff d0                	callq  *%rax
  800374:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80037a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800380:	c9                   	leaveq 
  800381:	c3                   	retq   

0000000000800382 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800382:	55                   	push   %rbp
  800383:	48 89 e5             	mov    %rsp,%rbp
  800386:	53                   	push   %rbx
  800387:	48 83 ec 38          	sub    $0x38,%rsp
  80038b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80038f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800393:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800397:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80039a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80039e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003a9:	77 3b                	ja     8003e6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ab:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003ae:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003b2:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003be:	48 f7 f3             	div    %rbx
  8003c1:	48 89 c2             	mov    %rax,%rdx
  8003c4:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003c7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003ca:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d2:	41 89 f9             	mov    %edi,%r9d
  8003d5:	48 89 c7             	mov    %rax,%rdi
  8003d8:	48 b8 82 03 80 00 00 	movabs $0x800382,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax
  8003e4:	eb 1e                	jmp    800404 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e6:	eb 12                	jmp    8003fa <printnum+0x78>
			putch(padc, putdat);
  8003e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003ec:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f3:	48 89 ce             	mov    %rcx,%rsi
  8003f6:	89 d7                	mov    %edx,%edi
  8003f8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fa:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003fe:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800402:	7f e4                	jg     8003e8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800404:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	48 f7 f1             	div    %rcx
  800413:	48 89 d0             	mov    %rdx,%rax
  800416:	48 ba d0 1d 80 00 00 	movabs $0x801dd0,%rdx
  80041d:	00 00 00 
  800420:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800424:	0f be d0             	movsbl %al,%edx
  800427:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80042b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042f:	48 89 ce             	mov    %rcx,%rsi
  800432:	89 d7                	mov    %edx,%edi
  800434:	ff d0                	callq  *%rax
}
  800436:	48 83 c4 38          	add    $0x38,%rsp
  80043a:	5b                   	pop    %rbx
  80043b:	5d                   	pop    %rbp
  80043c:	c3                   	retq   

000000000080043d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80043d:	55                   	push   %rbp
  80043e:	48 89 e5             	mov    %rsp,%rbp
  800441:	48 83 ec 1c          	sub    $0x1c,%rsp
  800445:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800449:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80044c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800450:	7e 52                	jle    8004a4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800456:	8b 00                	mov    (%rax),%eax
  800458:	83 f8 30             	cmp    $0x30,%eax
  80045b:	73 24                	jae    800481 <getuint+0x44>
  80045d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800461:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800469:	8b 00                	mov    (%rax),%eax
  80046b:	89 c0                	mov    %eax,%eax
  80046d:	48 01 d0             	add    %rdx,%rax
  800470:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800474:	8b 12                	mov    (%rdx),%edx
  800476:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800479:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047d:	89 0a                	mov    %ecx,(%rdx)
  80047f:	eb 17                	jmp    800498 <getuint+0x5b>
  800481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800485:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800489:	48 89 d0             	mov    %rdx,%rax
  80048c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800490:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800494:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800498:	48 8b 00             	mov    (%rax),%rax
  80049b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80049f:	e9 a3 00 00 00       	jmpq   800547 <getuint+0x10a>
	else if (lflag)
  8004a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004a8:	74 4f                	je     8004f9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	83 f8 30             	cmp    $0x30,%eax
  8004b3:	73 24                	jae    8004d9 <getuint+0x9c>
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c1:	8b 00                	mov    (%rax),%eax
  8004c3:	89 c0                	mov    %eax,%eax
  8004c5:	48 01 d0             	add    %rdx,%rax
  8004c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cc:	8b 12                	mov    (%rdx),%edx
  8004ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d5:	89 0a                	mov    %ecx,(%rdx)
  8004d7:	eb 17                	jmp    8004f0 <getuint+0xb3>
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004e1:	48 89 d0             	mov    %rdx,%rax
  8004e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f0:	48 8b 00             	mov    (%rax),%rax
  8004f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004f7:	eb 4e                	jmp    800547 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fd:	8b 00                	mov    (%rax),%eax
  8004ff:	83 f8 30             	cmp    $0x30,%eax
  800502:	73 24                	jae    800528 <getuint+0xeb>
  800504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800508:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80050c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800510:	8b 00                	mov    (%rax),%eax
  800512:	89 c0                	mov    %eax,%eax
  800514:	48 01 d0             	add    %rdx,%rax
  800517:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051b:	8b 12                	mov    (%rdx),%edx
  80051d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800520:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800524:	89 0a                	mov    %ecx,(%rdx)
  800526:	eb 17                	jmp    80053f <getuint+0x102>
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800530:	48 89 d0             	mov    %rdx,%rax
  800533:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800537:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80053f:	8b 00                	mov    (%rax),%eax
  800541:	89 c0                	mov    %eax,%eax
  800543:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80054b:	c9                   	leaveq 
  80054c:	c3                   	retq   

000000000080054d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80054d:	55                   	push   %rbp
  80054e:	48 89 e5             	mov    %rsp,%rbp
  800551:	48 83 ec 1c          	sub    $0x1c,%rsp
  800555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800559:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80055c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800560:	7e 52                	jle    8005b4 <getint+0x67>
		x=va_arg(*ap, long long);
  800562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800566:	8b 00                	mov    (%rax),%eax
  800568:	83 f8 30             	cmp    $0x30,%eax
  80056b:	73 24                	jae    800591 <getint+0x44>
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800579:	8b 00                	mov    (%rax),%eax
  80057b:	89 c0                	mov    %eax,%eax
  80057d:	48 01 d0             	add    %rdx,%rax
  800580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800584:	8b 12                	mov    (%rdx),%edx
  800586:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800589:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058d:	89 0a                	mov    %ecx,(%rdx)
  80058f:	eb 17                	jmp    8005a8 <getint+0x5b>
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800599:	48 89 d0             	mov    %rdx,%rax
  80059c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a8:	48 8b 00             	mov    (%rax),%rax
  8005ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005af:	e9 a3 00 00 00       	jmpq   800657 <getint+0x10a>
	else if (lflag)
  8005b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005b8:	74 4f                	je     800609 <getint+0xbc>
		x=va_arg(*ap, long);
  8005ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005be:	8b 00                	mov    (%rax),%eax
  8005c0:	83 f8 30             	cmp    $0x30,%eax
  8005c3:	73 24                	jae    8005e9 <getint+0x9c>
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d1:	8b 00                	mov    (%rax),%eax
  8005d3:	89 c0                	mov    %eax,%eax
  8005d5:	48 01 d0             	add    %rdx,%rax
  8005d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dc:	8b 12                	mov    (%rdx),%edx
  8005de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e5:	89 0a                	mov    %ecx,(%rdx)
  8005e7:	eb 17                	jmp    800600 <getint+0xb3>
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005f1:	48 89 d0             	mov    %rdx,%rax
  8005f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800600:	48 8b 00             	mov    (%rax),%rax
  800603:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800607:	eb 4e                	jmp    800657 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060d:	8b 00                	mov    (%rax),%eax
  80060f:	83 f8 30             	cmp    $0x30,%eax
  800612:	73 24                	jae    800638 <getint+0xeb>
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
  800636:	eb 17                	jmp    80064f <getint+0x102>
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800640:	48 89 d0             	mov    %rdx,%rax
  800643:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800647:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	48 98                	cltq   
  800653:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80065b:	c9                   	leaveq 
  80065c:	c3                   	retq   

000000000080065d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80065d:	55                   	push   %rbp
  80065e:	48 89 e5             	mov    %rsp,%rbp
  800661:	41 54                	push   %r12
  800663:	53                   	push   %rbx
  800664:	48 83 ec 60          	sub    $0x60,%rsp
  800668:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80066c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800670:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800674:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800678:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80067c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800680:	48 8b 0a             	mov    (%rdx),%rcx
  800683:	48 89 08             	mov    %rcx,(%rax)
  800686:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80068a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80068e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800692:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800696:	eb 17                	jmp    8006af <vprintfmt+0x52>
			if (ch == '\0')
  800698:	85 db                	test   %ebx,%ebx
  80069a:	0f 84 df 04 00 00    	je     800b7f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8006a0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006a8:	48 89 d6             	mov    %rdx,%rsi
  8006ab:	89 df                	mov    %ebx,%edi
  8006ad:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006af:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006bb:	0f b6 00             	movzbl (%rax),%eax
  8006be:	0f b6 d8             	movzbl %al,%ebx
  8006c1:	83 fb 25             	cmp    $0x25,%ebx
  8006c4:	75 d2                	jne    800698 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006c6:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006ca:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006d1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f2:	0f b6 00             	movzbl (%rax),%eax
  8006f5:	0f b6 d8             	movzbl %al,%ebx
  8006f8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006fb:	83 f8 55             	cmp    $0x55,%eax
  8006fe:	0f 87 47 04 00 00    	ja     800b4b <vprintfmt+0x4ee>
  800704:	89 c0                	mov    %eax,%eax
  800706:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80070d:	00 
  80070e:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  800715:	00 00 00 
  800718:	48 01 d0             	add    %rdx,%rax
  80071b:	48 8b 00             	mov    (%rax),%rax
  80071e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800720:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800724:	eb c0                	jmp    8006e6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800726:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80072a:	eb ba                	jmp    8006e6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80072c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800733:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800736:	89 d0                	mov    %edx,%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	01 d0                	add    %edx,%eax
  80073d:	01 c0                	add    %eax,%eax
  80073f:	01 d8                	add    %ebx,%eax
  800741:	83 e8 30             	sub    $0x30,%eax
  800744:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800747:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80074b:	0f b6 00             	movzbl (%rax),%eax
  80074e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800751:	83 fb 2f             	cmp    $0x2f,%ebx
  800754:	7e 0c                	jle    800762 <vprintfmt+0x105>
  800756:	83 fb 39             	cmp    $0x39,%ebx
  800759:	7f 07                	jg     800762 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800760:	eb d1                	jmp    800733 <vprintfmt+0xd6>
			goto process_precision;
  800762:	eb 58                	jmp    8007bc <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800764:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800767:	83 f8 30             	cmp    $0x30,%eax
  80076a:	73 17                	jae    800783 <vprintfmt+0x126>
  80076c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800770:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800773:	89 c0                	mov    %eax,%eax
  800775:	48 01 d0             	add    %rdx,%rax
  800778:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80077b:	83 c2 08             	add    $0x8,%edx
  80077e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800781:	eb 0f                	jmp    800792 <vprintfmt+0x135>
  800783:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800787:	48 89 d0             	mov    %rdx,%rax
  80078a:	48 83 c2 08          	add    $0x8,%rdx
  80078e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800792:	8b 00                	mov    (%rax),%eax
  800794:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800797:	eb 23                	jmp    8007bc <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800799:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80079d:	79 0c                	jns    8007ab <vprintfmt+0x14e>
				width = 0;
  80079f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007a6:	e9 3b ff ff ff       	jmpq   8006e6 <vprintfmt+0x89>
  8007ab:	e9 36 ff ff ff       	jmpq   8006e6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007b0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007b7:	e9 2a ff ff ff       	jmpq   8006e6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c0:	79 12                	jns    8007d4 <vprintfmt+0x177>
				width = precision, precision = -1;
  8007c2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007c5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007c8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007cf:	e9 12 ff ff ff       	jmpq   8006e6 <vprintfmt+0x89>
  8007d4:	e9 0d ff ff ff       	jmpq   8006e6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007d9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007dd:	e9 04 ff ff ff       	jmpq   8006e6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e5:	83 f8 30             	cmp    $0x30,%eax
  8007e8:	73 17                	jae    800801 <vprintfmt+0x1a4>
  8007ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f1:	89 c0                	mov    %eax,%eax
  8007f3:	48 01 d0             	add    %rdx,%rax
  8007f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f9:	83 c2 08             	add    $0x8,%edx
  8007fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ff:	eb 0f                	jmp    800810 <vprintfmt+0x1b3>
  800801:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800805:	48 89 d0             	mov    %rdx,%rax
  800808:	48 83 c2 08          	add    $0x8,%rdx
  80080c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800810:	8b 10                	mov    (%rax),%edx
  800812:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800816:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80081a:	48 89 ce             	mov    %rcx,%rsi
  80081d:	89 d7                	mov    %edx,%edi
  80081f:	ff d0                	callq  *%rax
			break;
  800821:	e9 53 03 00 00       	jmpq   800b79 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800826:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800829:	83 f8 30             	cmp    $0x30,%eax
  80082c:	73 17                	jae    800845 <vprintfmt+0x1e8>
  80082e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800832:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800835:	89 c0                	mov    %eax,%eax
  800837:	48 01 d0             	add    %rdx,%rax
  80083a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80083d:	83 c2 08             	add    $0x8,%edx
  800840:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800843:	eb 0f                	jmp    800854 <vprintfmt+0x1f7>
  800845:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800849:	48 89 d0             	mov    %rdx,%rax
  80084c:	48 83 c2 08          	add    $0x8,%rdx
  800850:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800854:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800856:	85 db                	test   %ebx,%ebx
  800858:	79 02                	jns    80085c <vprintfmt+0x1ff>
				err = -err;
  80085a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80085c:	83 fb 15             	cmp    $0x15,%ebx
  80085f:	7f 16                	jg     800877 <vprintfmt+0x21a>
  800861:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  800868:	00 00 00 
  80086b:	48 63 d3             	movslq %ebx,%rdx
  80086e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800872:	4d 85 e4             	test   %r12,%r12
  800875:	75 2e                	jne    8008a5 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800877:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80087b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087f:	89 d9                	mov    %ebx,%ecx
  800881:	48 ba e1 1d 80 00 00 	movabs $0x801de1,%rdx
  800888:	00 00 00 
  80088b:	48 89 c7             	mov    %rax,%rdi
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
  800893:	49 b8 88 0b 80 00 00 	movabs $0x800b88,%r8
  80089a:	00 00 00 
  80089d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a0:	e9 d4 02 00 00       	jmpq   800b79 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ad:	4c 89 e1             	mov    %r12,%rcx
  8008b0:	48 ba ea 1d 80 00 00 	movabs $0x801dea,%rdx
  8008b7:	00 00 00 
  8008ba:	48 89 c7             	mov    %rax,%rdi
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c2:	49 b8 88 0b 80 00 00 	movabs $0x800b88,%r8
  8008c9:	00 00 00 
  8008cc:	41 ff d0             	callq  *%r8
			break;
  8008cf:	e9 a5 02 00 00       	jmpq   800b79 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d7:	83 f8 30             	cmp    $0x30,%eax
  8008da:	73 17                	jae    8008f3 <vprintfmt+0x296>
  8008dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e3:	89 c0                	mov    %eax,%eax
  8008e5:	48 01 d0             	add    %rdx,%rax
  8008e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008eb:	83 c2 08             	add    $0x8,%edx
  8008ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008f1:	eb 0f                	jmp    800902 <vprintfmt+0x2a5>
  8008f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f7:	48 89 d0             	mov    %rdx,%rax
  8008fa:	48 83 c2 08          	add    $0x8,%rdx
  8008fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800902:	4c 8b 20             	mov    (%rax),%r12
  800905:	4d 85 e4             	test   %r12,%r12
  800908:	75 0a                	jne    800914 <vprintfmt+0x2b7>
				p = "(null)";
  80090a:	49 bc ed 1d 80 00 00 	movabs $0x801ded,%r12
  800911:	00 00 00 
			if (width > 0 && padc != '-')
  800914:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800918:	7e 3f                	jle    800959 <vprintfmt+0x2fc>
  80091a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80091e:	74 39                	je     800959 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800920:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800923:	48 98                	cltq   
  800925:	48 89 c6             	mov    %rax,%rsi
  800928:	4c 89 e7             	mov    %r12,%rdi
  80092b:	48 b8 34 0e 80 00 00 	movabs $0x800e34,%rax
  800932:	00 00 00 
  800935:	ff d0                	callq  *%rax
  800937:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80093a:	eb 17                	jmp    800953 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80093c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800940:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800944:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800948:	48 89 ce             	mov    %rcx,%rsi
  80094b:	89 d7                	mov    %edx,%edi
  80094d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80094f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800953:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800957:	7f e3                	jg     80093c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	eb 37                	jmp    800992 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80095b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80095f:	74 1e                	je     80097f <vprintfmt+0x322>
  800961:	83 fb 1f             	cmp    $0x1f,%ebx
  800964:	7e 05                	jle    80096b <vprintfmt+0x30e>
  800966:	83 fb 7e             	cmp    $0x7e,%ebx
  800969:	7e 14                	jle    80097f <vprintfmt+0x322>
					putch('?', putdat);
  80096b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80096f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800973:	48 89 d6             	mov    %rdx,%rsi
  800976:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80097b:	ff d0                	callq  *%rax
  80097d:	eb 0f                	jmp    80098e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80097f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800983:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800987:	48 89 d6             	mov    %rdx,%rsi
  80098a:	89 df                	mov    %ebx,%edi
  80098c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800992:	4c 89 e0             	mov    %r12,%rax
  800995:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800999:	0f b6 00             	movzbl (%rax),%eax
  80099c:	0f be d8             	movsbl %al,%ebx
  80099f:	85 db                	test   %ebx,%ebx
  8009a1:	74 10                	je     8009b3 <vprintfmt+0x356>
  8009a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009a7:	78 b2                	js     80095b <vprintfmt+0x2fe>
  8009a9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009b1:	79 a8                	jns    80095b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b3:	eb 16                	jmp    8009cb <vprintfmt+0x36e>
				putch(' ', putdat);
  8009b5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bd:	48 89 d6             	mov    %rdx,%rsi
  8009c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8009c5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cf:	7f e4                	jg     8009b5 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8009d1:	e9 a3 01 00 00       	jmpq   800b79 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009d6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009da:	be 03 00 00 00       	mov    $0x3,%esi
  8009df:	48 89 c7             	mov    %rax,%rdi
  8009e2:	48 b8 4d 05 80 00 00 	movabs $0x80054d,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 85 c0             	test   %rax,%rax
  8009f9:	79 1d                	jns    800a18 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a03:	48 89 d6             	mov    %rdx,%rsi
  800a06:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a0b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	48 f7 d8             	neg    %rax
  800a14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a18:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a1f:	e9 e8 00 00 00       	jmpq   800b0c <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a28:	be 03 00 00 00       	mov    $0x3,%esi
  800a2d:	48 89 c7             	mov    %rax,%rdi
  800a30:	48 b8 3d 04 80 00 00 	movabs $0x80043d,%rax
  800a37:	00 00 00 
  800a3a:	ff d0                	callq  *%rax
  800a3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a40:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a47:	e9 c0 00 00 00       	jmpq   800b0c <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a54:	48 89 d6             	mov    %rdx,%rsi
  800a57:	bf 58 00 00 00       	mov    $0x58,%edi
  800a5c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a66:	48 89 d6             	mov    %rdx,%rsi
  800a69:	bf 58 00 00 00       	mov    $0x58,%edi
  800a6e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a78:	48 89 d6             	mov    %rdx,%rsi
  800a7b:	bf 58 00 00 00       	mov    $0x58,%edi
  800a80:	ff d0                	callq  *%rax
			break;
  800a82:	e9 f2 00 00 00       	jmpq   800b79 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8f:	48 89 d6             	mov    %rdx,%rsi
  800a92:	bf 30 00 00 00       	mov    $0x30,%edi
  800a97:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	48 89 d6             	mov    %rdx,%rsi
  800aa4:	bf 78 00 00 00       	mov    $0x78,%edi
  800aa9:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800aab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aae:	83 f8 30             	cmp    $0x30,%eax
  800ab1:	73 17                	jae    800aca <vprintfmt+0x46d>
  800ab3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aba:	89 c0                	mov    %eax,%eax
  800abc:	48 01 d0             	add    %rdx,%rax
  800abf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac2:	83 c2 08             	add    $0x8,%edx
  800ac5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac8:	eb 0f                	jmp    800ad9 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800aca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ace:	48 89 d0             	mov    %rdx,%rax
  800ad1:	48 83 c2 08          	add    $0x8,%rdx
  800ad5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad9:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800adc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ae0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ae7:	eb 23                	jmp    800b0c <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ae9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aed:	be 03 00 00 00       	mov    $0x3,%esi
  800af2:	48 89 c7             	mov    %rax,%rdi
  800af5:	48 b8 3d 04 80 00 00 	movabs $0x80043d,%rax
  800afc:	00 00 00 
  800aff:	ff d0                	callq  *%rax
  800b01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b05:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b11:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b14:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b1b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b23:	45 89 c1             	mov    %r8d,%r9d
  800b26:	41 89 f8             	mov    %edi,%r8d
  800b29:	48 89 c7             	mov    %rax,%rdi
  800b2c:	48 b8 82 03 80 00 00 	movabs $0x800382,%rax
  800b33:	00 00 00 
  800b36:	ff d0                	callq  *%rax
			break;
  800b38:	eb 3f                	jmp    800b79 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b42:	48 89 d6             	mov    %rdx,%rsi
  800b45:	89 df                	mov    %ebx,%edi
  800b47:	ff d0                	callq  *%rax
			break;
  800b49:	eb 2e                	jmp    800b79 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b53:	48 89 d6             	mov    %rdx,%rsi
  800b56:	bf 25 00 00 00       	mov    $0x25,%edi
  800b5b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b62:	eb 05                	jmp    800b69 <vprintfmt+0x50c>
  800b64:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6d:	48 83 e8 01          	sub    $0x1,%rax
  800b71:	0f b6 00             	movzbl (%rax),%eax
  800b74:	3c 25                	cmp    $0x25,%al
  800b76:	75 ec                	jne    800b64 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b78:	90                   	nop
		}
	}
  800b79:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7a:	e9 30 fb ff ff       	jmpq   8006af <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b7f:	48 83 c4 60          	add    $0x60,%rsp
  800b83:	5b                   	pop    %rbx
  800b84:	41 5c                	pop    %r12
  800b86:	5d                   	pop    %rbp
  800b87:	c3                   	retq   

0000000000800b88 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b88:	55                   	push   %rbp
  800b89:	48 89 e5             	mov    %rsp,%rbp
  800b8c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b93:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b9a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ba1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ba8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800baf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bb6:	84 c0                	test   %al,%al
  800bb8:	74 20                	je     800bda <printfmt+0x52>
  800bba:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bbe:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bc2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bc6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bca:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bce:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bd2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bd6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bda:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800be1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800be8:	00 00 00 
  800beb:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bf2:	00 00 00 
  800bf5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bf9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c00:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c07:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c0e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c15:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c1c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c23:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c2a:	48 89 c7             	mov    %rax,%rdi
  800c2d:	48 b8 5d 06 80 00 00 	movabs $0x80065d,%rax
  800c34:	00 00 00 
  800c37:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c39:	c9                   	leaveq 
  800c3a:	c3                   	retq   

0000000000800c3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c3b:	55                   	push   %rbp
  800c3c:	48 89 e5             	mov    %rsp,%rbp
  800c3f:	48 83 ec 10          	sub    $0x10,%rsp
  800c43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4e:	8b 40 10             	mov    0x10(%rax),%eax
  800c51:	8d 50 01             	lea    0x1(%rax),%edx
  800c54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c58:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5f:	48 8b 10             	mov    (%rax),%rdx
  800c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c66:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c6a:	48 39 c2             	cmp    %rax,%rdx
  800c6d:	73 17                	jae    800c86 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c73:	48 8b 00             	mov    (%rax),%rax
  800c76:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c7e:	48 89 0a             	mov    %rcx,(%rdx)
  800c81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c84:	88 10                	mov    %dl,(%rax)
}
  800c86:	c9                   	leaveq 
  800c87:	c3                   	retq   

0000000000800c88 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c88:	55                   	push   %rbp
  800c89:	48 89 e5             	mov    %rsp,%rbp
  800c8c:	48 83 ec 50          	sub    $0x50,%rsp
  800c90:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c94:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c97:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c9b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c9f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ca3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ca7:	48 8b 0a             	mov    (%rdx),%rcx
  800caa:	48 89 08             	mov    %rcx,(%rax)
  800cad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cb1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cb5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cb9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cc5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cc8:	48 98                	cltq   
  800cca:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cd2:	48 01 d0             	add    %rdx,%rax
  800cd5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cd9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ce0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ce5:	74 06                	je     800ced <vsnprintf+0x65>
  800ce7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ceb:	7f 07                	jg     800cf4 <vsnprintf+0x6c>
		return -E_INVAL;
  800ced:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf2:	eb 2f                	jmp    800d23 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cf4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cf8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cfc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d00:	48 89 c6             	mov    %rax,%rsi
  800d03:	48 bf 3b 0c 80 00 00 	movabs $0x800c3b,%rdi
  800d0a:	00 00 00 
  800d0d:	48 b8 5d 06 80 00 00 	movabs $0x80065d,%rax
  800d14:	00 00 00 
  800d17:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d1d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d20:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d23:	c9                   	leaveq 
  800d24:	c3                   	retq   

0000000000800d25 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d25:	55                   	push   %rbp
  800d26:	48 89 e5             	mov    %rsp,%rbp
  800d29:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d30:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d37:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d3d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d44:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d4b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d52:	84 c0                	test   %al,%al
  800d54:	74 20                	je     800d76 <snprintf+0x51>
  800d56:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d5a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d5e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d62:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d66:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d6a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d6e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d72:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d76:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d7d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d84:	00 00 00 
  800d87:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d8e:	00 00 00 
  800d91:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d95:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d9c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800daa:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800db1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db8:	48 8b 0a             	mov    (%rdx),%rcx
  800dbb:	48 89 08             	mov    %rcx,(%rax)
  800dbe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dca:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dce:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dd5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ddc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800de2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800de9:	48 89 c7             	mov    %rax,%rdi
  800dec:	48 b8 88 0c 80 00 00 	movabs $0x800c88,%rax
  800df3:	00 00 00 
  800df6:	ff d0                	callq  *%rax
  800df8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dfe:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e04:	c9                   	leaveq 
  800e05:	c3                   	retq   

0000000000800e06 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e06:	55                   	push   %rbp
  800e07:	48 89 e5             	mov    %rsp,%rbp
  800e0a:	48 83 ec 18          	sub    $0x18,%rsp
  800e0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e19:	eb 09                	jmp    800e24 <strlen+0x1e>
		n++;
  800e1b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e28:	0f b6 00             	movzbl (%rax),%eax
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 ec                	jne    800e1b <strlen+0x15>
		n++;
	return n;
  800e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e32:	c9                   	leaveq 
  800e33:	c3                   	retq   

0000000000800e34 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 20          	sub    $0x20,%rsp
  800e3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e4b:	eb 0e                	jmp    800e5b <strnlen+0x27>
		n++;
  800e4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e56:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e5b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e60:	74 0b                	je     800e6d <strnlen+0x39>
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	0f b6 00             	movzbl (%rax),%eax
  800e69:	84 c0                	test   %al,%al
  800e6b:	75 e0                	jne    800e4d <strnlen+0x19>
		n++;
	return n;
  800e6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e70:	c9                   	leaveq 
  800e71:	c3                   	retq   

0000000000800e72 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e72:	55                   	push   %rbp
  800e73:	48 89 e5             	mov    %rsp,%rbp
  800e76:	48 83 ec 20          	sub    $0x20,%rsp
  800e7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e8a:	90                   	nop
  800e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e97:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e9b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e9f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ea3:	0f b6 12             	movzbl (%rdx),%edx
  800ea6:	88 10                	mov    %dl,(%rax)
  800ea8:	0f b6 00             	movzbl (%rax),%eax
  800eab:	84 c0                	test   %al,%al
  800ead:	75 dc                	jne    800e8b <strcpy+0x19>
		/* do nothing */;
	return ret;
  800eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eb3:	c9                   	leaveq 
  800eb4:	c3                   	retq   

0000000000800eb5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eb5:	55                   	push   %rbp
  800eb6:	48 89 e5             	mov    %rsp,%rbp
  800eb9:	48 83 ec 20          	sub    $0x20,%rsp
  800ebd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 89 c7             	mov    %rax,%rdi
  800ecc:	48 b8 06 0e 80 00 00 	movabs $0x800e06,%rax
  800ed3:	00 00 00 
  800ed6:	ff d0                	callq  *%rax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ede:	48 63 d0             	movslq %eax,%rdx
  800ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee5:	48 01 c2             	add    %rax,%rdx
  800ee8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eec:	48 89 c6             	mov    %rax,%rsi
  800eef:	48 89 d7             	mov    %rdx,%rdi
  800ef2:	48 b8 72 0e 80 00 00 	movabs $0x800e72,%rax
  800ef9:	00 00 00 
  800efc:	ff d0                	callq  *%rax
	return dst;
  800efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 83 ec 28          	sub    $0x28,%rsp
  800f0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f20:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f27:	00 
  800f28:	eb 2a                	jmp    800f54 <strncpy+0x50>
		*dst++ = *src;
  800f2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f32:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f36:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f3a:	0f b6 12             	movzbl (%rdx),%edx
  800f3d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f43:	0f b6 00             	movzbl (%rax),%eax
  800f46:	84 c0                	test   %al,%al
  800f48:	74 05                	je     800f4f <strncpy+0x4b>
			src++;
  800f4a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f58:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f5c:	72 cc                	jb     800f2a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f62:	c9                   	leaveq 
  800f63:	c3                   	retq   

0000000000800f64 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f64:	55                   	push   %rbp
  800f65:	48 89 e5             	mov    %rsp,%rbp
  800f68:	48 83 ec 28          	sub    $0x28,%rsp
  800f6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f74:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f80:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f85:	74 3d                	je     800fc4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f87:	eb 1d                	jmp    800fa6 <strlcpy+0x42>
			*dst++ = *src++;
  800f89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f91:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f95:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f99:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f9d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fa1:	0f b6 12             	movzbl (%rdx),%edx
  800fa4:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fb0:	74 0b                	je     800fbd <strlcpy+0x59>
  800fb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 cc                	jne    800f89 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcc:	48 29 c2             	sub    %rax,%rdx
  800fcf:	48 89 d0             	mov    %rdx,%rax
}
  800fd2:	c9                   	leaveq 
  800fd3:	c3                   	retq   

0000000000800fd4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fd4:	55                   	push   %rbp
  800fd5:	48 89 e5             	mov    %rsp,%rbp
  800fd8:	48 83 ec 10          	sub    $0x10,%rsp
  800fdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fe4:	eb 0a                	jmp    800ff0 <strcmp+0x1c>
		p++, q++;
  800fe6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800feb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ff0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff4:	0f b6 00             	movzbl (%rax),%eax
  800ff7:	84 c0                	test   %al,%al
  800ff9:	74 12                	je     80100d <strcmp+0x39>
  800ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fff:	0f b6 10             	movzbl (%rax),%edx
  801002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801006:	0f b6 00             	movzbl (%rax),%eax
  801009:	38 c2                	cmp    %al,%dl
  80100b:	74 d9                	je     800fe6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80100d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801011:	0f b6 00             	movzbl (%rax),%eax
  801014:	0f b6 d0             	movzbl %al,%edx
  801017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101b:	0f b6 00             	movzbl (%rax),%eax
  80101e:	0f b6 c0             	movzbl %al,%eax
  801021:	29 c2                	sub    %eax,%edx
  801023:	89 d0                	mov    %edx,%eax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 83 ec 18          	sub    $0x18,%rsp
  80102f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801033:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801037:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80103b:	eb 0f                	jmp    80104c <strncmp+0x25>
		n--, p++, q++;
  80103d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801042:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801047:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80104c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801051:	74 1d                	je     801070 <strncmp+0x49>
  801053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	84 c0                	test   %al,%al
  80105c:	74 12                	je     801070 <strncmp+0x49>
  80105e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801062:	0f b6 10             	movzbl (%rax),%edx
  801065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801069:	0f b6 00             	movzbl (%rax),%eax
  80106c:	38 c2                	cmp    %al,%dl
  80106e:	74 cd                	je     80103d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801070:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801075:	75 07                	jne    80107e <strncmp+0x57>
		return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
  80107c:	eb 18                	jmp    801096 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80107e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801082:	0f b6 00             	movzbl (%rax),%eax
  801085:	0f b6 d0             	movzbl %al,%edx
  801088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108c:	0f b6 00             	movzbl (%rax),%eax
  80108f:	0f b6 c0             	movzbl %al,%eax
  801092:	29 c2                	sub    %eax,%edx
  801094:	89 d0                	mov    %edx,%eax
}
  801096:	c9                   	leaveq 
  801097:	c3                   	retq   

0000000000801098 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	48 83 ec 0c          	sub    $0xc,%rsp
  8010a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010a4:	89 f0                	mov    %esi,%eax
  8010a6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010a9:	eb 17                	jmp    8010c2 <strchr+0x2a>
		if (*s == c)
  8010ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010af:	0f b6 00             	movzbl (%rax),%eax
  8010b2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010b5:	75 06                	jne    8010bd <strchr+0x25>
			return (char *) s;
  8010b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bb:	eb 15                	jmp    8010d2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c6:	0f b6 00             	movzbl (%rax),%eax
  8010c9:	84 c0                	test   %al,%al
  8010cb:	75 de                	jne    8010ab <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d2:	c9                   	leaveq 
  8010d3:	c3                   	retq   

00000000008010d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010d4:	55                   	push   %rbp
  8010d5:	48 89 e5             	mov    %rsp,%rbp
  8010d8:	48 83 ec 0c          	sub    $0xc,%rsp
  8010dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e0:	89 f0                	mov    %esi,%eax
  8010e2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010e5:	eb 13                	jmp    8010fa <strfind+0x26>
		if (*s == c)
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	0f b6 00             	movzbl (%rax),%eax
  8010ee:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010f1:	75 02                	jne    8010f5 <strfind+0x21>
			break;
  8010f3:	eb 10                	jmp    801105 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fe:	0f b6 00             	movzbl (%rax),%eax
  801101:	84 c0                	test   %al,%al
  801103:	75 e2                	jne    8010e7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801109:	c9                   	leaveq 
  80110a:	c3                   	retq   

000000000080110b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	48 83 ec 18          	sub    $0x18,%rsp
  801113:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801117:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80111a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80111e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801123:	75 06                	jne    80112b <memset+0x20>
		return v;
  801125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801129:	eb 69                	jmp    801194 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80112b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112f:	83 e0 03             	and    $0x3,%eax
  801132:	48 85 c0             	test   %rax,%rax
  801135:	75 48                	jne    80117f <memset+0x74>
  801137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113b:	83 e0 03             	and    $0x3,%eax
  80113e:	48 85 c0             	test   %rax,%rax
  801141:	75 3c                	jne    80117f <memset+0x74>
		c &= 0xFF;
  801143:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80114a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114d:	c1 e0 18             	shl    $0x18,%eax
  801150:	89 c2                	mov    %eax,%edx
  801152:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801155:	c1 e0 10             	shl    $0x10,%eax
  801158:	09 c2                	or     %eax,%edx
  80115a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80115d:	c1 e0 08             	shl    $0x8,%eax
  801160:	09 d0                	or     %edx,%eax
  801162:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801165:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801169:	48 c1 e8 02          	shr    $0x2,%rax
  80116d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801170:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801174:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801177:	48 89 d7             	mov    %rdx,%rdi
  80117a:	fc                   	cld    
  80117b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80117d:	eb 11                	jmp    801190 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80117f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801183:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801186:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80118a:	48 89 d7             	mov    %rdx,%rdi
  80118d:	fc                   	cld    
  80118e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801194:	c9                   	leaveq 
  801195:	c3                   	retq   

0000000000801196 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801196:	55                   	push   %rbp
  801197:	48 89 e5             	mov    %rsp,%rbp
  80119a:	48 83 ec 28          	sub    $0x28,%rsp
  80119e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011c2:	0f 83 88 00 00 00    	jae    801250 <memmove+0xba>
  8011c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d0:	48 01 d0             	add    %rdx,%rax
  8011d3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011d7:	76 77                	jbe    801250 <memmove+0xba>
		s += n;
  8011d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011dd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ed:	83 e0 03             	and    $0x3,%eax
  8011f0:	48 85 c0             	test   %rax,%rax
  8011f3:	75 3b                	jne    801230 <memmove+0x9a>
  8011f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	48 85 c0             	test   %rax,%rax
  8011ff:	75 2f                	jne    801230 <memmove+0x9a>
  801201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801205:	83 e0 03             	and    $0x3,%eax
  801208:	48 85 c0             	test   %rax,%rax
  80120b:	75 23                	jne    801230 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80120d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801211:	48 83 e8 04          	sub    $0x4,%rax
  801215:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801219:	48 83 ea 04          	sub    $0x4,%rdx
  80121d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801221:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801225:	48 89 c7             	mov    %rax,%rdi
  801228:	48 89 d6             	mov    %rdx,%rsi
  80122b:	fd                   	std    
  80122c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80122e:	eb 1d                	jmp    80124d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801234:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801240:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801244:	48 89 d7             	mov    %rdx,%rdi
  801247:	48 89 c1             	mov    %rax,%rcx
  80124a:	fd                   	std    
  80124b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80124d:	fc                   	cld    
  80124e:	eb 57                	jmp    8012a7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	83 e0 03             	and    $0x3,%eax
  801257:	48 85 c0             	test   %rax,%rax
  80125a:	75 36                	jne    801292 <memmove+0xfc>
  80125c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801260:	83 e0 03             	and    $0x3,%eax
  801263:	48 85 c0             	test   %rax,%rax
  801266:	75 2a                	jne    801292 <memmove+0xfc>
  801268:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126c:	83 e0 03             	and    $0x3,%eax
  80126f:	48 85 c0             	test   %rax,%rax
  801272:	75 1e                	jne    801292 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801278:	48 c1 e8 02          	shr    $0x2,%rax
  80127c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80127f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801283:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801287:	48 89 c7             	mov    %rax,%rdi
  80128a:	48 89 d6             	mov    %rdx,%rsi
  80128d:	fc                   	cld    
  80128e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801290:	eb 15                	jmp    8012a7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801296:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80129e:	48 89 c7             	mov    %rax,%rdi
  8012a1:	48 89 d6             	mov    %rdx,%rsi
  8012a4:	fc                   	cld    
  8012a5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012ab:	c9                   	leaveq 
  8012ac:	c3                   	retq   

00000000008012ad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012ad:	55                   	push   %rbp
  8012ae:	48 89 e5             	mov    %rsp,%rbp
  8012b1:	48 83 ec 18          	sub    $0x18,%rsp
  8012b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012c5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	48 89 ce             	mov    %rcx,%rsi
  8012d0:	48 89 c7             	mov    %rax,%rdi
  8012d3:	48 b8 96 11 80 00 00 	movabs $0x801196,%rax
  8012da:	00 00 00 
  8012dd:	ff d0                	callq  *%rax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 83 ec 28          	sub    $0x28,%rsp
  8012e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801301:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801305:	eb 36                	jmp    80133d <memcmp+0x5c>
		if (*s1 != *s2)
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 10             	movzbl (%rax),%edx
  80130e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801312:	0f b6 00             	movzbl (%rax),%eax
  801315:	38 c2                	cmp    %al,%dl
  801317:	74 1a                	je     801333 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131d:	0f b6 00             	movzbl (%rax),%eax
  801320:	0f b6 d0             	movzbl %al,%edx
  801323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801327:	0f b6 00             	movzbl (%rax),%eax
  80132a:	0f b6 c0             	movzbl %al,%eax
  80132d:	29 c2                	sub    %eax,%edx
  80132f:	89 d0                	mov    %edx,%eax
  801331:	eb 20                	jmp    801353 <memcmp+0x72>
		s1++, s2++;
  801333:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801338:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80133d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801341:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801345:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801349:	48 85 c0             	test   %rax,%rax
  80134c:	75 b9                	jne    801307 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801353:	c9                   	leaveq 
  801354:	c3                   	retq   

0000000000801355 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801355:	55                   	push   %rbp
  801356:	48 89 e5             	mov    %rsp,%rbp
  801359:	48 83 ec 28          	sub    $0x28,%rsp
  80135d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801361:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801364:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801370:	48 01 d0             	add    %rdx,%rax
  801373:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801377:	eb 15                	jmp    80138e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137d:	0f b6 10             	movzbl (%rax),%edx
  801380:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801383:	38 c2                	cmp    %al,%dl
  801385:	75 02                	jne    801389 <memfind+0x34>
			break;
  801387:	eb 0f                	jmp    801398 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801389:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801392:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801396:	72 e1                	jb     801379 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 34          	sub    $0x34,%rsp
  8013a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013ae:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013b8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013bf:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c0:	eb 05                	jmp    8013c7 <strtol+0x29>
		s++;
  8013c2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	3c 20                	cmp    $0x20,%al
  8013d0:	74 f0                	je     8013c2 <strtol+0x24>
  8013d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d6:	0f b6 00             	movzbl (%rax),%eax
  8013d9:	3c 09                	cmp    $0x9,%al
  8013db:	74 e5                	je     8013c2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 07                	jne    8013ef <strtol+0x51>
		s++;
  8013e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ed:	eb 17                	jmp    801406 <strtol+0x68>
	else if (*s == '-')
  8013ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f3:	0f b6 00             	movzbl (%rax),%eax
  8013f6:	3c 2d                	cmp    $0x2d,%al
  8013f8:	75 0c                	jne    801406 <strtol+0x68>
		s++, neg = 1;
  8013fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801406:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80140a:	74 06                	je     801412 <strtol+0x74>
  80140c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801410:	75 28                	jne    80143a <strtol+0x9c>
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	3c 30                	cmp    $0x30,%al
  80141b:	75 1d                	jne    80143a <strtol+0x9c>
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	48 83 c0 01          	add    $0x1,%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	3c 78                	cmp    $0x78,%al
  80142a:	75 0e                	jne    80143a <strtol+0x9c>
		s += 2, base = 16;
  80142c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801431:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801438:	eb 2c                	jmp    801466 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80143a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80143e:	75 19                	jne    801459 <strtol+0xbb>
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	3c 30                	cmp    $0x30,%al
  801449:	75 0e                	jne    801459 <strtol+0xbb>
		s++, base = 8;
  80144b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801450:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801457:	eb 0d                	jmp    801466 <strtol+0xc8>
	else if (base == 0)
  801459:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80145d:	75 07                	jne    801466 <strtol+0xc8>
		base = 10;
  80145f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801466:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	3c 2f                	cmp    $0x2f,%al
  80146f:	7e 1d                	jle    80148e <strtol+0xf0>
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	0f b6 00             	movzbl (%rax),%eax
  801478:	3c 39                	cmp    $0x39,%al
  80147a:	7f 12                	jg     80148e <strtol+0xf0>
			dig = *s - '0';
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	0f be c0             	movsbl %al,%eax
  801486:	83 e8 30             	sub    $0x30,%eax
  801489:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80148c:	eb 4e                	jmp    8014dc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80148e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	3c 60                	cmp    $0x60,%al
  801497:	7e 1d                	jle    8014b6 <strtol+0x118>
  801499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149d:	0f b6 00             	movzbl (%rax),%eax
  8014a0:	3c 7a                	cmp    $0x7a,%al
  8014a2:	7f 12                	jg     8014b6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	0f b6 00             	movzbl (%rax),%eax
  8014ab:	0f be c0             	movsbl %al,%eax
  8014ae:	83 e8 57             	sub    $0x57,%eax
  8014b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014b4:	eb 26                	jmp    8014dc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	3c 40                	cmp    $0x40,%al
  8014bf:	7e 48                	jle    801509 <strtol+0x16b>
  8014c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c5:	0f b6 00             	movzbl (%rax),%eax
  8014c8:	3c 5a                	cmp    $0x5a,%al
  8014ca:	7f 3d                	jg     801509 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	0f b6 00             	movzbl (%rax),%eax
  8014d3:	0f be c0             	movsbl %al,%eax
  8014d6:	83 e8 37             	sub    $0x37,%eax
  8014d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014df:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014e2:	7c 02                	jl     8014e6 <strtol+0x148>
			break;
  8014e4:	eb 23                	jmp    801509 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014e6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014eb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014ee:	48 98                	cltq   
  8014f0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014f5:	48 89 c2             	mov    %rax,%rdx
  8014f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014fb:	48 98                	cltq   
  8014fd:	48 01 d0             	add    %rdx,%rax
  801500:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801504:	e9 5d ff ff ff       	jmpq   801466 <strtol+0xc8>

	if (endptr)
  801509:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80150e:	74 0b                	je     80151b <strtol+0x17d>
		*endptr = (char *) s;
  801510:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801514:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801518:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80151b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80151f:	74 09                	je     80152a <strtol+0x18c>
  801521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801525:	48 f7 d8             	neg    %rax
  801528:	eb 04                	jmp    80152e <strtol+0x190>
  80152a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80152e:	c9                   	leaveq 
  80152f:	c3                   	retq   

0000000000801530 <strstr>:

char * strstr(const char *in, const char *str)
{
  801530:	55                   	push   %rbp
  801531:	48 89 e5             	mov    %rsp,%rbp
  801534:	48 83 ec 30          	sub    $0x30,%rsp
  801538:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80153c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801540:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801544:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801548:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801552:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801556:	75 06                	jne    80155e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	eb 6b                	jmp    8015c9 <strstr+0x99>

	len = strlen(str);
  80155e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801562:	48 89 c7             	mov    %rax,%rdi
  801565:	48 b8 06 0e 80 00 00 	movabs $0x800e06,%rax
  80156c:	00 00 00 
  80156f:	ff d0                	callq  *%rax
  801571:	48 98                	cltq   
  801573:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80157f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801583:	0f b6 00             	movzbl (%rax),%eax
  801586:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801589:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80158d:	75 07                	jne    801596 <strstr+0x66>
				return (char *) 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
  801594:	eb 33                	jmp    8015c9 <strstr+0x99>
		} while (sc != c);
  801596:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80159a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80159d:	75 d8                	jne    801577 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80159f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015a3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ab:	48 89 ce             	mov    %rcx,%rsi
  8015ae:	48 89 c7             	mov    %rax,%rdi
  8015b1:	48 b8 27 10 80 00 00 	movabs $0x801027,%rax
  8015b8:	00 00 00 
  8015bb:	ff d0                	callq  *%rax
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	75 b6                	jne    801577 <strstr+0x47>

	return (char *) (in - 1);
  8015c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c5:	48 83 e8 01          	sub    $0x1,%rax
}
  8015c9:	c9                   	leaveq 
  8015ca:	c3                   	retq   

00000000008015cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015cb:	55                   	push   %rbp
  8015cc:	48 89 e5             	mov    %rsp,%rbp
  8015cf:	53                   	push   %rbx
  8015d0:	48 83 ec 48          	sub    $0x48,%rsp
  8015d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015d7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015da:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015de:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015e2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015e6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015ed:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015f1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015f5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015f9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015fd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801601:	4c 89 c3             	mov    %r8,%rbx
  801604:	cd 30                	int    $0x30
  801606:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80160a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80160e:	74 3e                	je     80164e <syscall+0x83>
  801610:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801615:	7e 37                	jle    80164e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80161e:	49 89 d0             	mov    %rdx,%r8
  801621:	89 c1                	mov    %eax,%ecx
  801623:	48 ba a8 20 80 00 00 	movabs $0x8020a8,%rdx
  80162a:	00 00 00 
  80162d:	be 23 00 00 00       	mov    $0x23,%esi
  801632:	48 bf c5 20 80 00 00 	movabs $0x8020c5,%rdi
  801639:	00 00 00 
  80163c:	b8 00 00 00 00       	mov    $0x0,%eax
  801641:	49 b9 0e 1b 80 00 00 	movabs $0x801b0e,%r9
  801648:	00 00 00 
  80164b:	41 ff d1             	callq  *%r9

	return ret;
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801652:	48 83 c4 48          	add    $0x48,%rsp
  801656:	5b                   	pop    %rbx
  801657:	5d                   	pop    %rbp
  801658:	c3                   	retq   

0000000000801659 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801659:	55                   	push   %rbp
  80165a:	48 89 e5             	mov    %rsp,%rbp
  80165d:	48 83 ec 20          	sub    $0x20,%rsp
  801661:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801665:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801671:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801678:	00 
  801679:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80167f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801685:	48 89 d1             	mov    %rdx,%rcx
  801688:	48 89 c2             	mov    %rax,%rdx
  80168b:	be 00 00 00 00       	mov    $0x0,%esi
  801690:	bf 00 00 00 00       	mov    $0x0,%edi
  801695:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  80169c:	00 00 00 
  80169f:	ff d0                	callq  *%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016ab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016b2:	00 
  8016b3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ce:	bf 01 00 00 00       	mov    $0x1,%edi
  8016d3:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8016da:	00 00 00 
  8016dd:	ff d0                	callq  *%rax
}
  8016df:	c9                   	leaveq 
  8016e0:	c3                   	retq   

00000000008016e1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	48 83 ec 10          	sub    $0x10,%rsp
  8016e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ef:	48 98                	cltq   
  8016f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f8:	00 
  8016f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80170a:	48 89 c2             	mov    %rax,%rdx
  80170d:	be 01 00 00 00       	mov    $0x1,%esi
  801712:	bf 03 00 00 00       	mov    $0x3,%edi
  801717:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  80171e:	00 00 00 
  801721:	ff d0                	callq  *%rax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80172d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801734:	00 
  801735:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80173b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801741:	b9 00 00 00 00       	mov    $0x0,%ecx
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	be 00 00 00 00       	mov    $0x0,%esi
  801750:	bf 02 00 00 00       	mov    $0x2,%edi
  801755:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	callq  *%rax
}
  801761:	c9                   	leaveq 
  801762:	c3                   	retq   

0000000000801763 <sys_yield>:

void
sys_yield(void)
{
  801763:	55                   	push   %rbp
  801764:	48 89 e5             	mov    %rsp,%rbp
  801767:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80176b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801772:	00 
  801773:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801779:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80177f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	be 00 00 00 00       	mov    $0x0,%esi
  80178e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801793:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  80179a:	00 00 00 
  80179d:	ff d0                	callq  *%rax
}
  80179f:	c9                   	leaveq 
  8017a0:	c3                   	retq   

00000000008017a1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017a1:	55                   	push   %rbp
  8017a2:	48 89 e5             	mov    %rsp,%rbp
  8017a5:	48 83 ec 20          	sub    $0x20,%rsp
  8017a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017b6:	48 63 c8             	movslq %eax,%rcx
  8017b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017c0:	48 98                	cltq   
  8017c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c9:	00 
  8017ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d0:	49 89 c8             	mov    %rcx,%r8
  8017d3:	48 89 d1             	mov    %rdx,%rcx
  8017d6:	48 89 c2             	mov    %rax,%rdx
  8017d9:	be 01 00 00 00       	mov    $0x1,%esi
  8017de:	bf 04 00 00 00       	mov    $0x4,%edi
  8017e3:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8017ea:	00 00 00 
  8017ed:	ff d0                	callq  *%rax
}
  8017ef:	c9                   	leaveq 
  8017f0:	c3                   	retq   

00000000008017f1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017f1:	55                   	push   %rbp
  8017f2:	48 89 e5             	mov    %rsp,%rbp
  8017f5:	48 83 ec 30          	sub    $0x30,%rsp
  8017f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801800:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801803:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801807:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80180b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80180e:	48 63 c8             	movslq %eax,%rcx
  801811:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801815:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801818:	48 63 f0             	movslq %eax,%rsi
  80181b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801822:	48 98                	cltq   
  801824:	48 89 0c 24          	mov    %rcx,(%rsp)
  801828:	49 89 f9             	mov    %rdi,%r9
  80182b:	49 89 f0             	mov    %rsi,%r8
  80182e:	48 89 d1             	mov    %rdx,%rcx
  801831:	48 89 c2             	mov    %rax,%rdx
  801834:	be 01 00 00 00       	mov    $0x1,%esi
  801839:	bf 05 00 00 00       	mov    $0x5,%edi
  80183e:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801845:	00 00 00 
  801848:	ff d0                	callq  *%rax
}
  80184a:	c9                   	leaveq 
  80184b:	c3                   	retq   

000000000080184c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80184c:	55                   	push   %rbp
  80184d:	48 89 e5             	mov    %rsp,%rbp
  801850:	48 83 ec 20          	sub    $0x20,%rsp
  801854:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801857:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80185b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801862:	48 98                	cltq   
  801864:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186b:	00 
  80186c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801872:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801878:	48 89 d1             	mov    %rdx,%rcx
  80187b:	48 89 c2             	mov    %rax,%rdx
  80187e:	be 01 00 00 00       	mov    $0x1,%esi
  801883:	bf 06 00 00 00       	mov    $0x6,%edi
  801888:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
}
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 10          	sub    $0x10,%rsp
  80189e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a7:	48 63 d0             	movslq %eax,%rdx
  8018aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ad:	48 98                	cltq   
  8018af:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b6:	00 
  8018b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c3:	48 89 d1             	mov    %rdx,%rcx
  8018c6:	48 89 c2             	mov    %rax,%rdx
  8018c9:	be 01 00 00 00       	mov    $0x1,%esi
  8018ce:	bf 08 00 00 00       	mov    $0x8,%edi
  8018d3:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8018da:	00 00 00 
  8018dd:	ff d0                	callq  *%rax
}
  8018df:	c9                   	leaveq 
  8018e0:	c3                   	retq   

00000000008018e1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018e1:	55                   	push   %rbp
  8018e2:	48 89 e5             	mov    %rsp,%rbp
  8018e5:	48 83 ec 20          	sub    $0x20,%rsp
  8018e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f7:	48 98                	cltq   
  8018f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801900:	00 
  801901:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801907:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190d:	48 89 d1             	mov    %rdx,%rcx
  801910:	48 89 c2             	mov    %rax,%rdx
  801913:	be 01 00 00 00       	mov    $0x1,%esi
  801918:	bf 09 00 00 00       	mov    $0x9,%edi
  80191d:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801924:	00 00 00 
  801927:	ff d0                	callq  *%rax
}
  801929:	c9                   	leaveq 
  80192a:	c3                   	retq   

000000000080192b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80192b:	55                   	push   %rbp
  80192c:	48 89 e5             	mov    %rsp,%rbp
  80192f:	48 83 ec 20          	sub    $0x20,%rsp
  801933:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801936:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80193e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801941:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801944:	48 63 f0             	movslq %eax,%rsi
  801947:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80194b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194e:	48 98                	cltq   
  801950:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801954:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195b:	00 
  80195c:	49 89 f1             	mov    %rsi,%r9
  80195f:	49 89 c8             	mov    %rcx,%r8
  801962:	48 89 d1             	mov    %rdx,%rcx
  801965:	48 89 c2             	mov    %rax,%rdx
  801968:	be 00 00 00 00       	mov    $0x0,%esi
  80196d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801972:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  801979:	00 00 00 
  80197c:	ff d0                	callq  *%rax
}
  80197e:	c9                   	leaveq 
  80197f:	c3                   	retq   

0000000000801980 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801980:	55                   	push   %rbp
  801981:	48 89 e5             	mov    %rsp,%rbp
  801984:	48 83 ec 10          	sub    $0x10,%rsp
  801988:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80198c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801990:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801997:	00 
  801998:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a9:	48 89 c2             	mov    %rax,%rdx
  8019ac:	be 01 00 00 00       	mov    $0x1,%esi
  8019b1:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019b6:	48 b8 cb 15 80 00 00 	movabs $0x8015cb,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 10          	sub    $0x10,%rsp
  8019cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8019d0:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8019d7:	00 00 00 
  8019da:	48 8b 00             	mov    (%rax),%rax
  8019dd:	48 85 c0             	test   %rax,%rax
  8019e0:	75 49                	jne    801a2b <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8019e2:	ba 07 00 00 00       	mov    $0x7,%edx
  8019e7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8019ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f1:	48 b8 a1 17 80 00 00 	movabs $0x8017a1,%rax
  8019f8:	00 00 00 
  8019fb:	ff d0                	callq  *%rax
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	79 2a                	jns    801a2b <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801a01:	48 ba d8 20 80 00 00 	movabs $0x8020d8,%rdx
  801a08:	00 00 00 
  801a0b:	be 21 00 00 00       	mov    $0x21,%esi
  801a10:	48 bf 03 21 80 00 00 	movabs $0x802103,%rdi
  801a17:	00 00 00 
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1f:	48 b9 0e 1b 80 00 00 	movabs $0x801b0e,%rcx
  801a26:	00 00 00 
  801a29:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801a2b:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801a32:	00 00 00 
  801a35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a39:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801a3c:	48 be 87 1a 80 00 00 	movabs $0x801a87,%rsi
  801a43:	00 00 00 
  801a46:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4b:	48 b8 e1 18 80 00 00 	movabs $0x8018e1,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
  801a57:	85 c0                	test   %eax,%eax
  801a59:	79 2a                	jns    801a85 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801a5b:	48 ba 18 21 80 00 00 	movabs $0x802118,%rdx
  801a62:	00 00 00 
  801a65:	be 27 00 00 00       	mov    $0x27,%esi
  801a6a:	48 bf 03 21 80 00 00 	movabs $0x802103,%rdi
  801a71:	00 00 00 
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	48 b9 0e 1b 80 00 00 	movabs $0x801b0e,%rcx
  801a80:	00 00 00 
  801a83:	ff d1                	callq  *%rcx
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801a87:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801a8a:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  801a91:	00 00 00 
call *%rax
  801a94:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  801a96:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801a9d:	00 
    movq 152(%rsp), %rcx
  801a9e:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801aa5:	00 
    subq $8, %rcx
  801aa6:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  801aaa:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  801aad:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801ab4:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  801ab5:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  801ab9:	4c 8b 3c 24          	mov    (%rsp),%r15
  801abd:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801ac2:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801ac7:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801acc:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801ad1:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801ad6:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801adb:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801ae0:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801ae5:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801aea:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801aef:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801af4:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801af9:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801afe:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801b03:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  801b07:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  801b0b:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  801b0c:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  801b0d:	c3                   	retq   

0000000000801b0e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	53                   	push   %rbx
  801b13:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801b1a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801b21:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801b27:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801b2e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801b35:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801b3c:	84 c0                	test   %al,%al
  801b3e:	74 23                	je     801b63 <_panic+0x55>
  801b40:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801b47:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801b4b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801b4f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801b53:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801b57:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801b5b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801b5f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801b63:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801b6a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801b71:	00 00 00 
  801b74:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801b7b:	00 00 00 
  801b7e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801b82:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801b89:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801b90:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b97:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801b9e:	00 00 00 
  801ba1:	48 8b 18             	mov    (%rax),%rbx
  801ba4:	48 b8 25 17 80 00 00 	movabs $0x801725,%rax
  801bab:	00 00 00 
  801bae:	ff d0                	callq  *%rax
  801bb0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801bb6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801bbd:	41 89 c8             	mov    %ecx,%r8d
  801bc0:	48 89 d1             	mov    %rdx,%rcx
  801bc3:	48 89 da             	mov    %rbx,%rdx
  801bc6:	89 c6                	mov    %eax,%esi
  801bc8:	48 bf 50 21 80 00 00 	movabs $0x802150,%rdi
  801bcf:	00 00 00 
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd7:	49 b9 aa 02 80 00 00 	movabs $0x8002aa,%r9
  801bde:	00 00 00 
  801be1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801be4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801beb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801bf2:	48 89 d6             	mov    %rdx,%rsi
  801bf5:	48 89 c7             	mov    %rax,%rdi
  801bf8:	48 b8 fe 01 80 00 00 	movabs $0x8001fe,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
	cprintf("\n");
  801c04:	48 bf 73 21 80 00 00 	movabs $0x802173,%rdi
  801c0b:	00 00 00 
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c13:	48 ba aa 02 80 00 00 	movabs $0x8002aa,%rdx
  801c1a:	00 00 00 
  801c1d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c1f:	cc                   	int3   
  801c20:	eb fd                	jmp    801c1f <_panic+0x111>
