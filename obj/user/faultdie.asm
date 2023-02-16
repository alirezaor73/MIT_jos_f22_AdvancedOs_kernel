
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
  800074:	48 bf c0 37 80 00 00 	movabs $0x8037c0,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 b6 02 80 00 00 	movabs $0x8002b6,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
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
  8000c4:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8000ec:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
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
  800121:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800128:	00 00 00 
  80012b:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800132:	7e 14                	jle    800148 <libmain+0x6b>
		binaryname = argv[0];
  800134:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800138:	48 8b 10             	mov    (%rax),%rdx
  80013b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
	close_all();
  800172:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  800179:	00 00 00 
  80017c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80017e:	bf 00 00 00 00       	mov    $0x0,%edi
  800183:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	callq  *%rax
}
  80018f:	5d                   	pop    %rbp
  800190:	c3                   	retq   

0000000000800191 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800191:	55                   	push   %rbp
  800192:	48 89 e5             	mov    %rsp,%rbp
  800195:	48 83 ec 10          	sub    $0x10,%rsp
  800199:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80019c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a4:	8b 00                	mov    (%rax),%eax
  8001a6:	8d 48 01             	lea    0x1(%rax),%ecx
  8001a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ad:	89 0a                	mov    %ecx,(%rdx)
  8001af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001b2:	89 d1                	mov    %edx,%ecx
  8001b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b8:	48 98                	cltq   
  8001ba:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c2:	8b 00                	mov    (%rax),%eax
  8001c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c9:	75 2c                	jne    8001f7 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001cf:	8b 00                	mov    (%rax),%eax
  8001d1:	48 98                	cltq   
  8001d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d7:	48 83 c2 08          	add    $0x8,%rdx
  8001db:	48 89 c6             	mov    %rax,%rsi
  8001de:	48 89 d7             	mov    %rdx,%rdi
  8001e1:	48 b8 65 16 80 00 00 	movabs $0x801665,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	callq  *%rax
        b->idx = 0;
  8001ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fb:	8b 40 04             	mov    0x4(%rax),%eax
  8001fe:	8d 50 01             	lea    0x1(%rax),%edx
  800201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800205:	89 50 04             	mov    %edx,0x4(%rax)
}
  800208:	c9                   	leaveq 
  800209:	c3                   	retq   

000000000080020a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80020a:	55                   	push   %rbp
  80020b:	48 89 e5             	mov    %rsp,%rbp
  80020e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800215:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80021c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800223:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80022a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800231:	48 8b 0a             	mov    (%rdx),%rcx
  800234:	48 89 08             	mov    %rcx,(%rax)
  800237:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80023b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80023f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800243:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800247:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80024e:	00 00 00 
    b.cnt = 0;
  800251:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800258:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80025b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800262:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800269:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800270:	48 89 c6             	mov    %rax,%rsi
  800273:	48 bf 91 01 80 00 00 	movabs $0x800191,%rdi
  80027a:	00 00 00 
  80027d:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800284:	00 00 00 
  800287:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800289:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80028f:	48 98                	cltq   
  800291:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800298:	48 83 c2 08          	add    $0x8,%rdx
  80029c:	48 89 c6             	mov    %rax,%rsi
  80029f:	48 89 d7             	mov    %rdx,%rdi
  8002a2:	48 b8 65 16 80 00 00 	movabs $0x801665,%rax
  8002a9:	00 00 00 
  8002ac:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002b4:	c9                   	leaveq 
  8002b5:	c3                   	retq   

00000000008002b6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002b6:	55                   	push   %rbp
  8002b7:	48 89 e5             	mov    %rsp,%rbp
  8002ba:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002c1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002c8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002cf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002d6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002dd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002e4:	84 c0                	test   %al,%al
  8002e6:	74 20                	je     800308 <cprintf+0x52>
  8002e8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002ec:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002f0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002f4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002f8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002fc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800300:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800304:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800308:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80030f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800316:	00 00 00 
  800319:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800320:	00 00 00 
  800323:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800327:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80032e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800335:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80033c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800343:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80034a:	48 8b 0a             	mov    (%rdx),%rcx
  80034d:	48 89 08             	mov    %rcx,(%rax)
  800350:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800354:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800358:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800360:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800367:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80036e:	48 89 d6             	mov    %rdx,%rsi
  800371:	48 89 c7             	mov    %rax,%rdi
  800374:	48 b8 0a 02 80 00 00 	movabs $0x80020a,%rax
  80037b:	00 00 00 
  80037e:	ff d0                	callq  *%rax
  800380:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800386:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80038c:	c9                   	leaveq 
  80038d:	c3                   	retq   

000000000080038e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80038e:	55                   	push   %rbp
  80038f:	48 89 e5             	mov    %rsp,%rbp
  800392:	53                   	push   %rbx
  800393:	48 83 ec 38          	sub    $0x38,%rsp
  800397:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80039b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80039f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003a3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003a6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003aa:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ae:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003b1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003b5:	77 3b                	ja     8003f2 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003ba:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003be:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ca:	48 f7 f3             	div    %rbx
  8003cd:	48 89 c2             	mov    %rax,%rdx
  8003d0:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003d3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d6:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003de:	41 89 f9             	mov    %edi,%r9d
  8003e1:	48 89 c7             	mov    %rax,%rdi
  8003e4:	48 b8 8e 03 80 00 00 	movabs $0x80038e,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
  8003f0:	eb 1e                	jmp    800410 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003f2:	eb 12                	jmp    800406 <printnum+0x78>
			putch(padc, putdat);
  8003f4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ff:	48 89 ce             	mov    %rcx,%rsi
  800402:	89 d7                	mov    %edx,%edi
  800404:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800406:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80040a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80040e:	7f e4                	jg     8003f4 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800410:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	48 f7 f1             	div    %rcx
  80041f:	48 89 d0             	mov    %rdx,%rax
  800422:	48 ba f0 39 80 00 00 	movabs $0x8039f0,%rdx
  800429:	00 00 00 
  80042c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800430:	0f be d0             	movsbl %al,%edx
  800433:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800437:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043b:	48 89 ce             	mov    %rcx,%rsi
  80043e:	89 d7                	mov    %edx,%edi
  800440:	ff d0                	callq  *%rax
}
  800442:	48 83 c4 38          	add    $0x38,%rsp
  800446:	5b                   	pop    %rbx
  800447:	5d                   	pop    %rbp
  800448:	c3                   	retq   

0000000000800449 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800449:	55                   	push   %rbp
  80044a:	48 89 e5             	mov    %rsp,%rbp
  80044d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800451:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800455:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800458:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80045c:	7e 52                	jle    8004b0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80045e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800462:	8b 00                	mov    (%rax),%eax
  800464:	83 f8 30             	cmp    $0x30,%eax
  800467:	73 24                	jae    80048d <getuint+0x44>
  800469:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800475:	8b 00                	mov    (%rax),%eax
  800477:	89 c0                	mov    %eax,%eax
  800479:	48 01 d0             	add    %rdx,%rax
  80047c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800480:	8b 12                	mov    (%rdx),%edx
  800482:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800485:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800489:	89 0a                	mov    %ecx,(%rdx)
  80048b:	eb 17                	jmp    8004a4 <getuint+0x5b>
  80048d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800491:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800495:	48 89 d0             	mov    %rdx,%rax
  800498:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80049c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a4:	48 8b 00             	mov    (%rax),%rax
  8004a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ab:	e9 a3 00 00 00       	jmpq   800553 <getuint+0x10a>
	else if (lflag)
  8004b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004b4:	74 4f                	je     800505 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ba:	8b 00                	mov    (%rax),%eax
  8004bc:	83 f8 30             	cmp    $0x30,%eax
  8004bf:	73 24                	jae    8004e5 <getuint+0x9c>
  8004c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cd:	8b 00                	mov    (%rax),%eax
  8004cf:	89 c0                	mov    %eax,%eax
  8004d1:	48 01 d0             	add    %rdx,%rax
  8004d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d8:	8b 12                	mov    (%rdx),%edx
  8004da:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e1:	89 0a                	mov    %ecx,(%rdx)
  8004e3:	eb 17                	jmp    8004fc <getuint+0xb3>
  8004e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ed:	48 89 d0             	mov    %rdx,%rax
  8004f0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fc:	48 8b 00             	mov    (%rax),%rax
  8004ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800503:	eb 4e                	jmp    800553 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800509:	8b 00                	mov    (%rax),%eax
  80050b:	83 f8 30             	cmp    $0x30,%eax
  80050e:	73 24                	jae    800534 <getuint+0xeb>
  800510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800514:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	8b 00                	mov    (%rax),%eax
  80051e:	89 c0                	mov    %eax,%eax
  800520:	48 01 d0             	add    %rdx,%rax
  800523:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800527:	8b 12                	mov    (%rdx),%edx
  800529:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80052c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800530:	89 0a                	mov    %ecx,(%rdx)
  800532:	eb 17                	jmp    80054b <getuint+0x102>
  800534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800538:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80053c:	48 89 d0             	mov    %rdx,%rax
  80053f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800547:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80054b:	8b 00                	mov    (%rax),%eax
  80054d:	89 c0                	mov    %eax,%eax
  80054f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800557:	c9                   	leaveq 
  800558:	c3                   	retq   

0000000000800559 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800559:	55                   	push   %rbp
  80055a:	48 89 e5             	mov    %rsp,%rbp
  80055d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800561:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800565:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800568:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056c:	7e 52                	jle    8005c0 <getint+0x67>
		x=va_arg(*ap, long long);
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	83 f8 30             	cmp    $0x30,%eax
  800577:	73 24                	jae    80059d <getint+0x44>
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	89 c0                	mov    %eax,%eax
  800589:	48 01 d0             	add    %rdx,%rax
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	8b 12                	mov    (%rdx),%edx
  800592:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	89 0a                	mov    %ecx,(%rdx)
  80059b:	eb 17                	jmp    8005b4 <getint+0x5b>
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a5:	48 89 d0             	mov    %rdx,%rax
  8005a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b4:	48 8b 00             	mov    (%rax),%rax
  8005b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005bb:	e9 a3 00 00 00       	jmpq   800663 <getint+0x10a>
	else if (lflag)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c4:	74 4f                	je     800615 <getint+0xbc>
		x=va_arg(*ap, long);
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	8b 00                	mov    (%rax),%eax
  8005cc:	83 f8 30             	cmp    $0x30,%eax
  8005cf:	73 24                	jae    8005f5 <getint+0x9c>
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	8b 00                	mov    (%rax),%eax
  8005df:	89 c0                	mov    %eax,%eax
  8005e1:	48 01 d0             	add    %rdx,%rax
  8005e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e8:	8b 12                	mov    (%rdx),%edx
  8005ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f1:	89 0a                	mov    %ecx,(%rdx)
  8005f3:	eb 17                	jmp    80060c <getint+0xb3>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fd:	48 89 d0             	mov    %rdx,%rax
  800600:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800604:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800608:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060c:	48 8b 00             	mov    (%rax),%rax
  80060f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800613:	eb 4e                	jmp    800663 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	83 f8 30             	cmp    $0x30,%eax
  80061e:	73 24                	jae    800644 <getint+0xeb>
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
  800642:	eb 17                	jmp    80065b <getint+0x102>
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064c:	48 89 d0             	mov    %rdx,%rax
  80064f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	48 98                	cltq   
  80065f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800667:	c9                   	leaveq 
  800668:	c3                   	retq   

0000000000800669 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800669:	55                   	push   %rbp
  80066a:	48 89 e5             	mov    %rsp,%rbp
  80066d:	41 54                	push   %r12
  80066f:	53                   	push   %rbx
  800670:	48 83 ec 60          	sub    $0x60,%rsp
  800674:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800678:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80067c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800680:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800684:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800688:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80068c:	48 8b 0a             	mov    (%rdx),%rcx
  80068f:	48 89 08             	mov    %rcx,(%rax)
  800692:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800696:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80069a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80069e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a2:	eb 17                	jmp    8006bb <vprintfmt+0x52>
			if (ch == '\0')
  8006a4:	85 db                	test   %ebx,%ebx
  8006a6:	0f 84 df 04 00 00    	je     800b8b <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8006ac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006b4:	48 89 d6             	mov    %rdx,%rsi
  8006b7:	89 df                	mov    %ebx,%edi
  8006b9:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006c3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c7:	0f b6 00             	movzbl (%rax),%eax
  8006ca:	0f b6 d8             	movzbl %al,%ebx
  8006cd:	83 fb 25             	cmp    $0x25,%ebx
  8006d0:	75 d2                	jne    8006a4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006d2:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006d6:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006dd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006eb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006fa:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006fe:	0f b6 00             	movzbl (%rax),%eax
  800701:	0f b6 d8             	movzbl %al,%ebx
  800704:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800707:	83 f8 55             	cmp    $0x55,%eax
  80070a:	0f 87 47 04 00 00    	ja     800b57 <vprintfmt+0x4ee>
  800710:	89 c0                	mov    %eax,%eax
  800712:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800719:	00 
  80071a:	48 b8 18 3a 80 00 00 	movabs $0x803a18,%rax
  800721:	00 00 00 
  800724:	48 01 d0             	add    %rdx,%rax
  800727:	48 8b 00             	mov    (%rax),%rax
  80072a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80072c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800730:	eb c0                	jmp    8006f2 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800732:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800736:	eb ba                	jmp    8006f2 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800738:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80073f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800742:	89 d0                	mov    %edx,%eax
  800744:	c1 e0 02             	shl    $0x2,%eax
  800747:	01 d0                	add    %edx,%eax
  800749:	01 c0                	add    %eax,%eax
  80074b:	01 d8                	add    %ebx,%eax
  80074d:	83 e8 30             	sub    $0x30,%eax
  800750:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800753:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800757:	0f b6 00             	movzbl (%rax),%eax
  80075a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80075d:	83 fb 2f             	cmp    $0x2f,%ebx
  800760:	7e 0c                	jle    80076e <vprintfmt+0x105>
  800762:	83 fb 39             	cmp    $0x39,%ebx
  800765:	7f 07                	jg     80076e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800767:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80076c:	eb d1                	jmp    80073f <vprintfmt+0xd6>
			goto process_precision;
  80076e:	eb 58                	jmp    8007c8 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800770:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800773:	83 f8 30             	cmp    $0x30,%eax
  800776:	73 17                	jae    80078f <vprintfmt+0x126>
  800778:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80077c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80077f:	89 c0                	mov    %eax,%eax
  800781:	48 01 d0             	add    %rdx,%rax
  800784:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800787:	83 c2 08             	add    $0x8,%edx
  80078a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80078d:	eb 0f                	jmp    80079e <vprintfmt+0x135>
  80078f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800793:	48 89 d0             	mov    %rdx,%rax
  800796:	48 83 c2 08          	add    $0x8,%rdx
  80079a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80079e:	8b 00                	mov    (%rax),%eax
  8007a0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007a3:	eb 23                	jmp    8007c8 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007a9:	79 0c                	jns    8007b7 <vprintfmt+0x14e>
				width = 0;
  8007ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007b2:	e9 3b ff ff ff       	jmpq   8006f2 <vprintfmt+0x89>
  8007b7:	e9 36 ff ff ff       	jmpq   8006f2 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007bc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007c3:	e9 2a ff ff ff       	jmpq   8006f2 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007cc:	79 12                	jns    8007e0 <vprintfmt+0x177>
				width = precision, precision = -1;
  8007ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007d1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007db:	e9 12 ff ff ff       	jmpq   8006f2 <vprintfmt+0x89>
  8007e0:	e9 0d ff ff ff       	jmpq   8006f2 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007e9:	e9 04 ff ff ff       	jmpq   8006f2 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 17                	jae    80080d <vprintfmt+0x1a4>
  8007f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fd:	89 c0                	mov    %eax,%eax
  8007ff:	48 01 d0             	add    %rdx,%rax
  800802:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800805:	83 c2 08             	add    $0x8,%edx
  800808:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080b:	eb 0f                	jmp    80081c <vprintfmt+0x1b3>
  80080d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800811:	48 89 d0             	mov    %rdx,%rax
  800814:	48 83 c2 08          	add    $0x8,%rdx
  800818:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80081c:	8b 10                	mov    (%rax),%edx
  80081e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800822:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800826:	48 89 ce             	mov    %rcx,%rsi
  800829:	89 d7                	mov    %edx,%edi
  80082b:	ff d0                	callq  *%rax
			break;
  80082d:	e9 53 03 00 00       	jmpq   800b85 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800832:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800835:	83 f8 30             	cmp    $0x30,%eax
  800838:	73 17                	jae    800851 <vprintfmt+0x1e8>
  80083a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80083e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800841:	89 c0                	mov    %eax,%eax
  800843:	48 01 d0             	add    %rdx,%rax
  800846:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800849:	83 c2 08             	add    $0x8,%edx
  80084c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084f:	eb 0f                	jmp    800860 <vprintfmt+0x1f7>
  800851:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800855:	48 89 d0             	mov    %rdx,%rax
  800858:	48 83 c2 08          	add    $0x8,%rdx
  80085c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800860:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x1ff>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 15             	cmp    $0x15,%ebx
  80086b:	7f 16                	jg     800883 <vprintfmt+0x21a>
  80086d:	48 b8 40 39 80 00 00 	movabs $0x803940,%rax
  800874:	00 00 00 
  800877:	48 63 d3             	movslq %ebx,%rdx
  80087a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80087e:	4d 85 e4             	test   %r12,%r12
  800881:	75 2e                	jne    8008b1 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800883:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800887:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088b:	89 d9                	mov    %ebx,%ecx
  80088d:	48 ba 01 3a 80 00 00 	movabs $0x803a01,%rdx
  800894:	00 00 00 
  800897:	48 89 c7             	mov    %rax,%rdi
  80089a:	b8 00 00 00 00       	mov    $0x0,%eax
  80089f:	49 b8 94 0b 80 00 00 	movabs $0x800b94,%r8
  8008a6:	00 00 00 
  8008a9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ac:	e9 d4 02 00 00       	jmpq   800b85 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b9:	4c 89 e1             	mov    %r12,%rcx
  8008bc:	48 ba 0a 3a 80 00 00 	movabs $0x803a0a,%rdx
  8008c3:	00 00 00 
  8008c6:	48 89 c7             	mov    %rax,%rdi
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ce:	49 b8 94 0b 80 00 00 	movabs $0x800b94,%r8
  8008d5:	00 00 00 
  8008d8:	41 ff d0             	callq  *%r8
			break;
  8008db:	e9 a5 02 00 00       	jmpq   800b85 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e3:	83 f8 30             	cmp    $0x30,%eax
  8008e6:	73 17                	jae    8008ff <vprintfmt+0x296>
  8008e8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ef:	89 c0                	mov    %eax,%eax
  8008f1:	48 01 d0             	add    %rdx,%rax
  8008f4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f7:	83 c2 08             	add    $0x8,%edx
  8008fa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008fd:	eb 0f                	jmp    80090e <vprintfmt+0x2a5>
  8008ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800903:	48 89 d0             	mov    %rdx,%rax
  800906:	48 83 c2 08          	add    $0x8,%rdx
  80090a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80090e:	4c 8b 20             	mov    (%rax),%r12
  800911:	4d 85 e4             	test   %r12,%r12
  800914:	75 0a                	jne    800920 <vprintfmt+0x2b7>
				p = "(null)";
  800916:	49 bc 0d 3a 80 00 00 	movabs $0x803a0d,%r12
  80091d:	00 00 00 
			if (width > 0 && padc != '-')
  800920:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800924:	7e 3f                	jle    800965 <vprintfmt+0x2fc>
  800926:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80092a:	74 39                	je     800965 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80092c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80092f:	48 98                	cltq   
  800931:	48 89 c6             	mov    %rax,%rsi
  800934:	4c 89 e7             	mov    %r12,%rdi
  800937:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  80093e:	00 00 00 
  800941:	ff d0                	callq  *%rax
  800943:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800946:	eb 17                	jmp    80095f <vprintfmt+0x2f6>
					putch(padc, putdat);
  800948:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80094c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800950:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800954:	48 89 ce             	mov    %rcx,%rsi
  800957:	89 d7                	mov    %edx,%edi
  800959:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80095b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800963:	7f e3                	jg     800948 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800965:	eb 37                	jmp    80099e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800967:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80096b:	74 1e                	je     80098b <vprintfmt+0x322>
  80096d:	83 fb 1f             	cmp    $0x1f,%ebx
  800970:	7e 05                	jle    800977 <vprintfmt+0x30e>
  800972:	83 fb 7e             	cmp    $0x7e,%ebx
  800975:	7e 14                	jle    80098b <vprintfmt+0x322>
					putch('?', putdat);
  800977:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80097b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097f:	48 89 d6             	mov    %rdx,%rsi
  800982:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800987:	ff d0                	callq  *%rax
  800989:	eb 0f                	jmp    80099a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80098b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800993:	48 89 d6             	mov    %rdx,%rsi
  800996:	89 df                	mov    %ebx,%edi
  800998:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80099e:	4c 89 e0             	mov    %r12,%rax
  8009a1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009a5:	0f b6 00             	movzbl (%rax),%eax
  8009a8:	0f be d8             	movsbl %al,%ebx
  8009ab:	85 db                	test   %ebx,%ebx
  8009ad:	74 10                	je     8009bf <vprintfmt+0x356>
  8009af:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009b3:	78 b2                	js     800967 <vprintfmt+0x2fe>
  8009b5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009bd:	79 a8                	jns    800967 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	eb 16                	jmp    8009d7 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c9:	48 89 d6             	mov    %rdx,%rsi
  8009cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8009d1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009db:	7f e4                	jg     8009c1 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8009dd:	e9 a3 01 00 00       	jmpq   800b85 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009e2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e6:	be 03 00 00 00       	mov    $0x3,%esi
  8009eb:	48 89 c7             	mov    %rax,%rdi
  8009ee:	48 b8 59 05 80 00 00 	movabs $0x800559,%rax
  8009f5:	00 00 00 
  8009f8:	ff d0                	callq  *%rax
  8009fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a02:	48 85 c0             	test   %rax,%rax
  800a05:	79 1d                	jns    800a24 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0f:	48 89 d6             	mov    %rdx,%rsi
  800a12:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a17:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1d:	48 f7 d8             	neg    %rax
  800a20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a24:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a2b:	e9 e8 00 00 00       	jmpq   800b18 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a30:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a34:	be 03 00 00 00       	mov    $0x3,%esi
  800a39:	48 89 c7             	mov    %rax,%rdi
  800a3c:	48 b8 49 04 80 00 00 	movabs $0x800449,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	callq  *%rax
  800a48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a4c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a53:	e9 c0 00 00 00       	jmpq   800b18 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a60:	48 89 d6             	mov    %rdx,%rsi
  800a63:	bf 58 00 00 00       	mov    $0x58,%edi
  800a68:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a6a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	48 89 d6             	mov    %rdx,%rsi
  800a75:	bf 58 00 00 00       	mov    $0x58,%edi
  800a7a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a84:	48 89 d6             	mov    %rdx,%rsi
  800a87:	bf 58 00 00 00       	mov    $0x58,%edi
  800a8c:	ff d0                	callq  *%rax
			break;
  800a8e:	e9 f2 00 00 00       	jmpq   800b85 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9b:	48 89 d6             	mov    %rdx,%rsi
  800a9e:	bf 30 00 00 00       	mov    $0x30,%edi
  800aa3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800aa5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aad:	48 89 d6             	mov    %rdx,%rsi
  800ab0:	bf 78 00 00 00       	mov    $0x78,%edi
  800ab5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ab7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aba:	83 f8 30             	cmp    $0x30,%eax
  800abd:	73 17                	jae    800ad6 <vprintfmt+0x46d>
  800abf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ac3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac6:	89 c0                	mov    %eax,%eax
  800ac8:	48 01 d0             	add    %rdx,%rax
  800acb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ace:	83 c2 08             	add    $0x8,%edx
  800ad1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	eb 0f                	jmp    800ae5 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ad6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ada:	48 89 d0             	mov    %rdx,%rax
  800add:	48 83 c2 08          	add    $0x8,%rdx
  800ae1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800aec:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800af5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af9:	be 03 00 00 00       	mov    $0x3,%esi
  800afe:	48 89 c7             	mov    %rax,%rdi
  800b01:	48 b8 49 04 80 00 00 	movabs $0x800449,%rax
  800b08:	00 00 00 
  800b0b:	ff d0                	callq  *%rax
  800b0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b11:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b18:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b1d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b20:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b23:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b27:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2f:	45 89 c1             	mov    %r8d,%r9d
  800b32:	41 89 f8             	mov    %edi,%r8d
  800b35:	48 89 c7             	mov    %rax,%rdi
  800b38:	48 b8 8e 03 80 00 00 	movabs $0x80038e,%rax
  800b3f:	00 00 00 
  800b42:	ff d0                	callq  *%rax
			break;
  800b44:	eb 3f                	jmp    800b85 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4e:	48 89 d6             	mov    %rdx,%rsi
  800b51:	89 df                	mov    %ebx,%edi
  800b53:	ff d0                	callq  *%rax
			break;
  800b55:	eb 2e                	jmp    800b85 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5f:	48 89 d6             	mov    %rdx,%rsi
  800b62:	bf 25 00 00 00       	mov    $0x25,%edi
  800b67:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b69:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b6e:	eb 05                	jmp    800b75 <vprintfmt+0x50c>
  800b70:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b75:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b79:	48 83 e8 01          	sub    $0x1,%rax
  800b7d:	0f b6 00             	movzbl (%rax),%eax
  800b80:	3c 25                	cmp    $0x25,%al
  800b82:	75 ec                	jne    800b70 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b84:	90                   	nop
		}
	}
  800b85:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b86:	e9 30 fb ff ff       	jmpq   8006bb <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b8b:	48 83 c4 60          	add    $0x60,%rsp
  800b8f:	5b                   	pop    %rbx
  800b90:	41 5c                	pop    %r12
  800b92:	5d                   	pop    %rbp
  800b93:	c3                   	retq   

0000000000800b94 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b94:	55                   	push   %rbp
  800b95:	48 89 e5             	mov    %rsp,%rbp
  800b98:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b9f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ba6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bb4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bbb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bc2:	84 c0                	test   %al,%al
  800bc4:	74 20                	je     800be6 <printfmt+0x52>
  800bc6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bd2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bd6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bda:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bde:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800be2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800be6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bed:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bf4:	00 00 00 
  800bf7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bfe:	00 00 00 
  800c01:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c05:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c0c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c13:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c1a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c21:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c28:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c2f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c45:	c9                   	leaveq 
  800c46:	c3                   	retq   

0000000000800c47 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c47:	55                   	push   %rbp
  800c48:	48 89 e5             	mov    %rsp,%rbp
  800c4b:	48 83 ec 10          	sub    $0x10,%rsp
  800c4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5a:	8b 40 10             	mov    0x10(%rax),%eax
  800c5d:	8d 50 01             	lea    0x1(%rax),%edx
  800c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c64:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6b:	48 8b 10             	mov    (%rax),%rdx
  800c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c72:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c76:	48 39 c2             	cmp    %rax,%rdx
  800c79:	73 17                	jae    800c92 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7f:	48 8b 00             	mov    (%rax),%rax
  800c82:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c8a:	48 89 0a             	mov    %rcx,(%rdx)
  800c8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c90:	88 10                	mov    %dl,(%rax)
}
  800c92:	c9                   	leaveq 
  800c93:	c3                   	retq   

0000000000800c94 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c94:	55                   	push   %rbp
  800c95:	48 89 e5             	mov    %rsp,%rbp
  800c98:	48 83 ec 50          	sub    $0x50,%rsp
  800c9c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ca0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ca3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ca7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cab:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800caf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cb3:	48 8b 0a             	mov    (%rdx),%rcx
  800cb6:	48 89 08             	mov    %rcx,(%rax)
  800cb9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cbd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cc1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cc5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ccd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cd1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cd4:	48 98                	cltq   
  800cd6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cde:	48 01 d0             	add    %rdx,%rax
  800ce1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ce5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cec:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cf1:	74 06                	je     800cf9 <vsnprintf+0x65>
  800cf3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cf7:	7f 07                	jg     800d00 <vsnprintf+0x6c>
		return -E_INVAL;
  800cf9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cfe:	eb 2f                	jmp    800d2f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d00:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d04:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d0c:	48 89 c6             	mov    %rax,%rsi
  800d0f:	48 bf 47 0c 80 00 00 	movabs $0x800c47,%rdi
  800d16:	00 00 00 
  800d19:	48 b8 69 06 80 00 00 	movabs $0x800669,%rax
  800d20:	00 00 00 
  800d23:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d29:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d2c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d2f:	c9                   	leaveq 
  800d30:	c3                   	retq   

0000000000800d31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d31:	55                   	push   %rbp
  800d32:	48 89 e5             	mov    %rsp,%rbp
  800d35:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d3c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d43:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d49:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d50:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d57:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d5e:	84 c0                	test   %al,%al
  800d60:	74 20                	je     800d82 <snprintf+0x51>
  800d62:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d66:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d6a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d6e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d72:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d76:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d7a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d7e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d82:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d89:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d90:	00 00 00 
  800d93:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d9a:	00 00 00 
  800d9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800da8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800daf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800db6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dbd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dc4:	48 8b 0a             	mov    (%rdx),%rcx
  800dc7:	48 89 08             	mov    %rcx,(%rax)
  800dca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dd2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dd6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dda:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800de1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800de8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800df5:	48 89 c7             	mov    %rax,%rdi
  800df8:	48 b8 94 0c 80 00 00 	movabs $0x800c94,%rax
  800dff:	00 00 00 
  800e02:	ff d0                	callq  *%rax
  800e04:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e0a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e10:	c9                   	leaveq 
  800e11:	c3                   	retq   

0000000000800e12 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e12:	55                   	push   %rbp
  800e13:	48 89 e5             	mov    %rsp,%rbp
  800e16:	48 83 ec 18          	sub    $0x18,%rsp
  800e1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e25:	eb 09                	jmp    800e30 <strlen+0x1e>
		n++;
  800e27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e34:	0f b6 00             	movzbl (%rax),%eax
  800e37:	84 c0                	test   %al,%al
  800e39:	75 ec                	jne    800e27 <strlen+0x15>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e3e:	c9                   	leaveq 
  800e3f:	c3                   	retq   

0000000000800e40 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e40:	55                   	push   %rbp
  800e41:	48 89 e5             	mov    %rsp,%rbp
  800e44:	48 83 ec 20          	sub    $0x20,%rsp
  800e48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e57:	eb 0e                	jmp    800e67 <strnlen+0x27>
		n++;
  800e59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e62:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e67:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e6c:	74 0b                	je     800e79 <strnlen+0x39>
  800e6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e72:	0f b6 00             	movzbl (%rax),%eax
  800e75:	84 c0                	test   %al,%al
  800e77:	75 e0                	jne    800e59 <strnlen+0x19>
		n++;
	return n;
  800e79:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e7c:	c9                   	leaveq 
  800e7d:	c3                   	retq   

0000000000800e7e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7e:	55                   	push   %rbp
  800e7f:	48 89 e5             	mov    %rsp,%rbp
  800e82:	48 83 ec 20          	sub    $0x20,%rsp
  800e86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e96:	90                   	nop
  800e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ea3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800eab:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800eaf:	0f b6 12             	movzbl (%rdx),%edx
  800eb2:	88 10                	mov    %dl,(%rax)
  800eb4:	0f b6 00             	movzbl (%rax),%eax
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 dc                	jne    800e97 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ebb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ebf:	c9                   	leaveq 
  800ec0:	c3                   	retq   

0000000000800ec1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ec1:	55                   	push   %rbp
  800ec2:	48 89 e5             	mov    %rsp,%rbp
  800ec5:	48 83 ec 20          	sub    $0x20,%rsp
  800ec9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ecd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed5:	48 89 c7             	mov    %rax,%rdi
  800ed8:	48 b8 12 0e 80 00 00 	movabs $0x800e12,%rax
  800edf:	00 00 00 
  800ee2:	ff d0                	callq  *%rax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ee7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eea:	48 63 d0             	movslq %eax,%rdx
  800eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef1:	48 01 c2             	add    %rax,%rdx
  800ef4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ef8:	48 89 c6             	mov    %rax,%rsi
  800efb:	48 89 d7             	mov    %rdx,%rdi
  800efe:	48 b8 7e 0e 80 00 00 	movabs $0x800e7e,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	callq  *%rax
	return dst;
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f0e:	c9                   	leaveq 
  800f0f:	c3                   	retq   

0000000000800f10 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f10:	55                   	push   %rbp
  800f11:	48 89 e5             	mov    %rsp,%rbp
  800f14:	48 83 ec 28          	sub    $0x28,%rsp
  800f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f28:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f2c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f33:	00 
  800f34:	eb 2a                	jmp    800f60 <strncpy+0x50>
		*dst++ = *src;
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f46:	0f b6 12             	movzbl (%rdx),%edx
  800f49:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4f:	0f b6 00             	movzbl (%rax),%eax
  800f52:	84 c0                	test   %al,%al
  800f54:	74 05                	je     800f5b <strncpy+0x4b>
			src++;
  800f56:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f5b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f64:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f68:	72 cc                	jb     800f36 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f6e:	c9                   	leaveq 
  800f6f:	c3                   	retq   

0000000000800f70 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f70:	55                   	push   %rbp
  800f71:	48 89 e5             	mov    %rsp,%rbp
  800f74:	48 83 ec 28          	sub    $0x28,%rsp
  800f78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f88:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f8c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f91:	74 3d                	je     800fd0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f93:	eb 1d                	jmp    800fb2 <strlcpy+0x42>
			*dst++ = *src++;
  800f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fa9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fad:	0f b6 12             	movzbl (%rdx),%edx
  800fb0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fb2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fb7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fbc:	74 0b                	je     800fc9 <strlcpy+0x59>
  800fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc2:	0f b6 00             	movzbl (%rax),%eax
  800fc5:	84 c0                	test   %al,%al
  800fc7:	75 cc                	jne    800f95 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fd0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd8:	48 29 c2             	sub    %rax,%rdx
  800fdb:	48 89 d0             	mov    %rdx,%rax
}
  800fde:	c9                   	leaveq 
  800fdf:	c3                   	retq   

0000000000800fe0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fe0:	55                   	push   %rbp
  800fe1:	48 89 e5             	mov    %rsp,%rbp
  800fe4:	48 83 ec 10          	sub    $0x10,%rsp
  800fe8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800ff0:	eb 0a                	jmp    800ffc <strcmp+0x1c>
		p++, q++;
  800ff2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ff7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801000:	0f b6 00             	movzbl (%rax),%eax
  801003:	84 c0                	test   %al,%al
  801005:	74 12                	je     801019 <strcmp+0x39>
  801007:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100b:	0f b6 10             	movzbl (%rax),%edx
  80100e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801012:	0f b6 00             	movzbl (%rax),%eax
  801015:	38 c2                	cmp    %al,%dl
  801017:	74 d9                	je     800ff2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801019:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101d:	0f b6 00             	movzbl (%rax),%eax
  801020:	0f b6 d0             	movzbl %al,%edx
  801023:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801027:	0f b6 00             	movzbl (%rax),%eax
  80102a:	0f b6 c0             	movzbl %al,%eax
  80102d:	29 c2                	sub    %eax,%edx
  80102f:	89 d0                	mov    %edx,%eax
}
  801031:	c9                   	leaveq 
  801032:	c3                   	retq   

0000000000801033 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801033:	55                   	push   %rbp
  801034:	48 89 e5             	mov    %rsp,%rbp
  801037:	48 83 ec 18          	sub    $0x18,%rsp
  80103b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801043:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801047:	eb 0f                	jmp    801058 <strncmp+0x25>
		n--, p++, q++;
  801049:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80104e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801053:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801058:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80105d:	74 1d                	je     80107c <strncmp+0x49>
  80105f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801063:	0f b6 00             	movzbl (%rax),%eax
  801066:	84 c0                	test   %al,%al
  801068:	74 12                	je     80107c <strncmp+0x49>
  80106a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106e:	0f b6 10             	movzbl (%rax),%edx
  801071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801075:	0f b6 00             	movzbl (%rax),%eax
  801078:	38 c2                	cmp    %al,%dl
  80107a:	74 cd                	je     801049 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80107c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801081:	75 07                	jne    80108a <strncmp+0x57>
		return 0;
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
  801088:	eb 18                	jmp    8010a2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80108a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108e:	0f b6 00             	movzbl (%rax),%eax
  801091:	0f b6 d0             	movzbl %al,%edx
  801094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	0f b6 c0             	movzbl %al,%eax
  80109e:	29 c2                	sub    %eax,%edx
  8010a0:	89 d0                	mov    %edx,%eax
}
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 83 ec 0c          	sub    $0xc,%rsp
  8010ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b0:	89 f0                	mov    %esi,%eax
  8010b2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010b5:	eb 17                	jmp    8010ce <strchr+0x2a>
		if (*s == c)
  8010b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bb:	0f b6 00             	movzbl (%rax),%eax
  8010be:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010c1:	75 06                	jne    8010c9 <strchr+0x25>
			return (char *) s;
  8010c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c7:	eb 15                	jmp    8010de <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 de                	jne    8010b7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 83 ec 0c          	sub    $0xc,%rsp
  8010e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ec:	89 f0                	mov    %esi,%eax
  8010ee:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010f1:	eb 13                	jmp    801106 <strfind+0x26>
		if (*s == c)
  8010f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f7:	0f b6 00             	movzbl (%rax),%eax
  8010fa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010fd:	75 02                	jne    801101 <strfind+0x21>
			break;
  8010ff:	eb 10                	jmp    801111 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801101:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	84 c0                	test   %al,%al
  80110f:	75 e2                	jne    8010f3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801115:	c9                   	leaveq 
  801116:	c3                   	retq   

0000000000801117 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	48 83 ec 18          	sub    $0x18,%rsp
  80111f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801123:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801126:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80112a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80112f:	75 06                	jne    801137 <memset+0x20>
		return v;
  801131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801135:	eb 69                	jmp    8011a0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113b:	83 e0 03             	and    $0x3,%eax
  80113e:	48 85 c0             	test   %rax,%rax
  801141:	75 48                	jne    80118b <memset+0x74>
  801143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801147:	83 e0 03             	and    $0x3,%eax
  80114a:	48 85 c0             	test   %rax,%rax
  80114d:	75 3c                	jne    80118b <memset+0x74>
		c &= 0xFF;
  80114f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801156:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801159:	c1 e0 18             	shl    $0x18,%eax
  80115c:	89 c2                	mov    %eax,%edx
  80115e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801161:	c1 e0 10             	shl    $0x10,%eax
  801164:	09 c2                	or     %eax,%edx
  801166:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801169:	c1 e0 08             	shl    $0x8,%eax
  80116c:	09 d0                	or     %edx,%eax
  80116e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801175:	48 c1 e8 02          	shr    $0x2,%rax
  801179:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80117c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801180:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801183:	48 89 d7             	mov    %rdx,%rdi
  801186:	fc                   	cld    
  801187:	f3 ab                	rep stos %eax,%es:(%rdi)
  801189:	eb 11                	jmp    80119c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80118b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80118f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801192:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801196:	48 89 d7             	mov    %rdx,%rdi
  801199:	fc                   	cld    
  80119a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80119c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011a0:	c9                   	leaveq 
  8011a1:	c3                   	retq   

00000000008011a2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011a2:	55                   	push   %rbp
  8011a3:	48 89 e5             	mov    %rsp,%rbp
  8011a6:	48 83 ec 28          	sub    $0x28,%rsp
  8011aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ca:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011ce:	0f 83 88 00 00 00    	jae    80125c <memmove+0xba>
  8011d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011dc:	48 01 d0             	add    %rdx,%rax
  8011df:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011e3:	76 77                	jbe    80125c <memmove+0xba>
		s += n;
  8011e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	48 85 c0             	test   %rax,%rax
  8011ff:	75 3b                	jne    80123c <memmove+0x9a>
  801201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801205:	83 e0 03             	and    $0x3,%eax
  801208:	48 85 c0             	test   %rax,%rax
  80120b:	75 2f                	jne    80123c <memmove+0x9a>
  80120d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801211:	83 e0 03             	and    $0x3,%eax
  801214:	48 85 c0             	test   %rax,%rax
  801217:	75 23                	jne    80123c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121d:	48 83 e8 04          	sub    $0x4,%rax
  801221:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801225:	48 83 ea 04          	sub    $0x4,%rdx
  801229:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80122d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801231:	48 89 c7             	mov    %rax,%rdi
  801234:	48 89 d6             	mov    %rdx,%rsi
  801237:	fd                   	std    
  801238:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80123a:	eb 1d                	jmp    801259 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80123c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801240:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80124c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801250:	48 89 d7             	mov    %rdx,%rdi
  801253:	48 89 c1             	mov    %rax,%rcx
  801256:	fd                   	std    
  801257:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801259:	fc                   	cld    
  80125a:	eb 57                	jmp    8012b3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80125c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801260:	83 e0 03             	and    $0x3,%eax
  801263:	48 85 c0             	test   %rax,%rax
  801266:	75 36                	jne    80129e <memmove+0xfc>
  801268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126c:	83 e0 03             	and    $0x3,%eax
  80126f:	48 85 c0             	test   %rax,%rax
  801272:	75 2a                	jne    80129e <memmove+0xfc>
  801274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801278:	83 e0 03             	and    $0x3,%eax
  80127b:	48 85 c0             	test   %rax,%rax
  80127e:	75 1e                	jne    80129e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801280:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801284:	48 c1 e8 02          	shr    $0x2,%rax
  801288:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80128b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801293:	48 89 c7             	mov    %rax,%rdi
  801296:	48 89 d6             	mov    %rdx,%rsi
  801299:	fc                   	cld    
  80129a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80129c:	eb 15                	jmp    8012b3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80129e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012aa:	48 89 c7             	mov    %rax,%rdi
  8012ad:	48 89 d6             	mov    %rdx,%rsi
  8012b0:	fc                   	cld    
  8012b1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 18          	sub    $0x18,%rsp
  8012c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012d1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	48 89 ce             	mov    %rcx,%rsi
  8012dc:	48 89 c7             	mov    %rax,%rdi
  8012df:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  8012e6:	00 00 00 
  8012e9:	ff d0                	callq  *%rax
}
  8012eb:	c9                   	leaveq 
  8012ec:	c3                   	retq   

00000000008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012ed:	55                   	push   %rbp
  8012ee:	48 89 e5             	mov    %rsp,%rbp
  8012f1:	48 83 ec 28          	sub    $0x28,%rsp
  8012f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801311:	eb 36                	jmp    801349 <memcmp+0x5c>
		if (*s1 != *s2)
  801313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801317:	0f b6 10             	movzbl (%rax),%edx
  80131a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131e:	0f b6 00             	movzbl (%rax),%eax
  801321:	38 c2                	cmp    %al,%dl
  801323:	74 1a                	je     80133f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801329:	0f b6 00             	movzbl (%rax),%eax
  80132c:	0f b6 d0             	movzbl %al,%edx
  80132f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801333:	0f b6 00             	movzbl (%rax),%eax
  801336:	0f b6 c0             	movzbl %al,%eax
  801339:	29 c2                	sub    %eax,%edx
  80133b:	89 d0                	mov    %edx,%eax
  80133d:	eb 20                	jmp    80135f <memcmp+0x72>
		s1++, s2++;
  80133f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801344:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801349:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801351:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801355:	48 85 c0             	test   %rax,%rax
  801358:	75 b9                	jne    801313 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135f:	c9                   	leaveq 
  801360:	c3                   	retq   

0000000000801361 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801361:	55                   	push   %rbp
  801362:	48 89 e5             	mov    %rsp,%rbp
  801365:	48 83 ec 28          	sub    $0x28,%rsp
  801369:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801370:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801378:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80137c:	48 01 d0             	add    %rdx,%rax
  80137f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801383:	eb 15                	jmp    80139a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801389:	0f b6 10             	movzbl (%rax),%edx
  80138c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80138f:	38 c2                	cmp    %al,%dl
  801391:	75 02                	jne    801395 <memfind+0x34>
			break;
  801393:	eb 0f                	jmp    8013a4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801395:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80139a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013a2:	72 e1                	jb     801385 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a8:	c9                   	leaveq 
  8013a9:	c3                   	retq   

00000000008013aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013aa:	55                   	push   %rbp
  8013ab:	48 89 e5             	mov    %rsp,%rbp
  8013ae:	48 83 ec 34          	sub    $0x34,%rsp
  8013b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013ba:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013c4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013cb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cc:	eb 05                	jmp    8013d3 <strtol+0x29>
		s++;
  8013ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	3c 20                	cmp    $0x20,%al
  8013dc:	74 f0                	je     8013ce <strtol+0x24>
  8013de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	3c 09                	cmp    $0x9,%al
  8013e7:	74 e5                	je     8013ce <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ed:	0f b6 00             	movzbl (%rax),%eax
  8013f0:	3c 2b                	cmp    $0x2b,%al
  8013f2:	75 07                	jne    8013fb <strtol+0x51>
		s++;
  8013f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f9:	eb 17                	jmp    801412 <strtol+0x68>
	else if (*s == '-')
  8013fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	3c 2d                	cmp    $0x2d,%al
  801404:	75 0c                	jne    801412 <strtol+0x68>
		s++, neg = 1;
  801406:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80140b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801412:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801416:	74 06                	je     80141e <strtol+0x74>
  801418:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80141c:	75 28                	jne    801446 <strtol+0x9c>
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	3c 30                	cmp    $0x30,%al
  801427:	75 1d                	jne    801446 <strtol+0x9c>
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	48 83 c0 01          	add    $0x1,%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	3c 78                	cmp    $0x78,%al
  801436:	75 0e                	jne    801446 <strtol+0x9c>
		s += 2, base = 16;
  801438:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80143d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801444:	eb 2c                	jmp    801472 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801446:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80144a:	75 19                	jne    801465 <strtol+0xbb>
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3c 30                	cmp    $0x30,%al
  801455:	75 0e                	jne    801465 <strtol+0xbb>
		s++, base = 8;
  801457:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801463:	eb 0d                	jmp    801472 <strtol+0xc8>
	else if (base == 0)
  801465:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801469:	75 07                	jne    801472 <strtol+0xc8>
		base = 10;
  80146b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801476:	0f b6 00             	movzbl (%rax),%eax
  801479:	3c 2f                	cmp    $0x2f,%al
  80147b:	7e 1d                	jle    80149a <strtol+0xf0>
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	3c 39                	cmp    $0x39,%al
  801486:	7f 12                	jg     80149a <strtol+0xf0>
			dig = *s - '0';
  801488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	0f be c0             	movsbl %al,%eax
  801492:	83 e8 30             	sub    $0x30,%eax
  801495:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801498:	eb 4e                	jmp    8014e8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 60                	cmp    $0x60,%al
  8014a3:	7e 1d                	jle    8014c2 <strtol+0x118>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	3c 7a                	cmp    $0x7a,%al
  8014ae:	7f 12                	jg     8014c2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	0f be c0             	movsbl %al,%eax
  8014ba:	83 e8 57             	sub    $0x57,%eax
  8014bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c0:	eb 26                	jmp    8014e8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 40                	cmp    $0x40,%al
  8014cb:	7e 48                	jle    801515 <strtol+0x16b>
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	3c 5a                	cmp    $0x5a,%al
  8014d6:	7f 3d                	jg     801515 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	0f be c0             	movsbl %al,%eax
  8014e2:	83 e8 37             	sub    $0x37,%eax
  8014e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014eb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014ee:	7c 02                	jl     8014f2 <strtol+0x148>
			break;
  8014f0:	eb 23                	jmp    801515 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014f7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014fa:	48 98                	cltq   
  8014fc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801501:	48 89 c2             	mov    %rax,%rdx
  801504:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801507:	48 98                	cltq   
  801509:	48 01 d0             	add    %rdx,%rax
  80150c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801510:	e9 5d ff ff ff       	jmpq   801472 <strtol+0xc8>

	if (endptr)
  801515:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80151a:	74 0b                	je     801527 <strtol+0x17d>
		*endptr = (char *) s;
  80151c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801520:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801524:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80152b:	74 09                	je     801536 <strtol+0x18c>
  80152d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801531:	48 f7 d8             	neg    %rax
  801534:	eb 04                	jmp    80153a <strtol+0x190>
  801536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80153a:	c9                   	leaveq 
  80153b:	c3                   	retq   

000000000080153c <strstr>:

char * strstr(const char *in, const char *str)
{
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	48 83 ec 30          	sub    $0x30,%rsp
  801544:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801548:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80154c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801550:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801554:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80155e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801562:	75 06                	jne    80156a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	eb 6b                	jmp    8015d5 <strstr+0x99>

	len = strlen(str);
  80156a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80156e:	48 89 c7             	mov    %rax,%rdi
  801571:	48 b8 12 0e 80 00 00 	movabs $0x800e12,%rax
  801578:	00 00 00 
  80157b:	ff d0                	callq  *%rax
  80157d:	48 98                	cltq   
  80157f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80158b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80158f:	0f b6 00             	movzbl (%rax),%eax
  801592:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801595:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801599:	75 07                	jne    8015a2 <strstr+0x66>
				return (char *) 0;
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a0:	eb 33                	jmp    8015d5 <strstr+0x99>
		} while (sc != c);
  8015a2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015a6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015a9:	75 d8                	jne    801583 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015af:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	48 89 ce             	mov    %rcx,%rsi
  8015ba:	48 89 c7             	mov    %rax,%rdi
  8015bd:	48 b8 33 10 80 00 00 	movabs $0x801033,%rax
  8015c4:	00 00 00 
  8015c7:	ff d0                	callq  *%rax
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	75 b6                	jne    801583 <strstr+0x47>

	return (char *) (in - 1);
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	48 83 e8 01          	sub    $0x1,%rax
}
  8015d5:	c9                   	leaveq 
  8015d6:	c3                   	retq   

00000000008015d7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015d7:	55                   	push   %rbp
  8015d8:	48 89 e5             	mov    %rsp,%rbp
  8015db:	53                   	push   %rbx
  8015dc:	48 83 ec 48          	sub    $0x48,%rsp
  8015e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015e3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015e6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015ea:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015ee:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015f2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015f9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015fd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801601:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801605:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801609:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80160d:	4c 89 c3             	mov    %r8,%rbx
  801610:	cd 30                	int    $0x30
  801612:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801616:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80161a:	74 3e                	je     80165a <syscall+0x83>
  80161c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801621:	7e 37                	jle    80165a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801627:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80162a:	49 89 d0             	mov    %rdx,%r8
  80162d:	89 c1                	mov    %eax,%ecx
  80162f:	48 ba c8 3c 80 00 00 	movabs $0x803cc8,%rdx
  801636:	00 00 00 
  801639:	be 23 00 00 00       	mov    $0x23,%esi
  80163e:	48 bf e5 3c 80 00 00 	movabs $0x803ce5,%rdi
  801645:	00 00 00 
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
  80164d:	49 b9 29 34 80 00 00 	movabs $0x803429,%r9
  801654:	00 00 00 
  801657:	41 ff d1             	callq  *%r9

	return ret;
  80165a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80165e:	48 83 c4 48          	add    $0x48,%rsp
  801662:	5b                   	pop    %rbx
  801663:	5d                   	pop    %rbp
  801664:	c3                   	retq   

0000000000801665 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	48 83 ec 20          	sub    $0x20,%rsp
  80166d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801671:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801679:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80167d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801684:	00 
  801685:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80168b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801691:	48 89 d1             	mov    %rdx,%rcx
  801694:	48 89 c2             	mov    %rax,%rdx
  801697:	be 00 00 00 00       	mov    $0x0,%esi
  80169c:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a1:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  8016a8:	00 00 00 
  8016ab:	ff d0                	callq  *%rax
}
  8016ad:	c9                   	leaveq 
  8016ae:	c3                   	retq   

00000000008016af <sys_cgetc>:

int
sys_cgetc(void)
{
  8016af:	55                   	push   %rbp
  8016b0:	48 89 e5             	mov    %rsp,%rbp
  8016b3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016be:	00 
  8016bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d5:	be 00 00 00 00       	mov    $0x0,%esi
  8016da:	bf 01 00 00 00       	mov    $0x1,%edi
  8016df:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  8016e6:	00 00 00 
  8016e9:	ff d0                	callq  *%rax
}
  8016eb:	c9                   	leaveq 
  8016ec:	c3                   	retq   

00000000008016ed <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	48 83 ec 10          	sub    $0x10,%rsp
  8016f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016fb:	48 98                	cltq   
  8016fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801704:	00 
  801705:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80170b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801711:	b9 00 00 00 00       	mov    $0x0,%ecx
  801716:	48 89 c2             	mov    %rax,%rdx
  801719:	be 01 00 00 00       	mov    $0x1,%esi
  80171e:	bf 03 00 00 00       	mov    $0x3,%edi
  801723:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  80172a:	00 00 00 
  80172d:	ff d0                	callq  *%rax
}
  80172f:	c9                   	leaveq 
  801730:	c3                   	retq   

0000000000801731 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801731:	55                   	push   %rbp
  801732:	48 89 e5             	mov    %rsp,%rbp
  801735:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801739:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801740:	00 
  801741:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801747:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	be 00 00 00 00       	mov    $0x0,%esi
  80175c:	bf 02 00 00 00       	mov    $0x2,%edi
  801761:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  801768:	00 00 00 
  80176b:	ff d0                	callq  *%rax
}
  80176d:	c9                   	leaveq 
  80176e:	c3                   	retq   

000000000080176f <sys_yield>:

void
sys_yield(void)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801777:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80177e:	00 
  80177f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801785:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80178b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801790:	ba 00 00 00 00       	mov    $0x0,%edx
  801795:	be 00 00 00 00       	mov    $0x0,%esi
  80179a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80179f:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  8017a6:	00 00 00 
  8017a9:	ff d0                	callq  *%rax
}
  8017ab:	c9                   	leaveq 
  8017ac:	c3                   	retq   

00000000008017ad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ad:	55                   	push   %rbp
  8017ae:	48 89 e5             	mov    %rsp,%rbp
  8017b1:	48 83 ec 20          	sub    $0x20,%rsp
  8017b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017bc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017c2:	48 63 c8             	movslq %eax,%rcx
  8017c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017cc:	48 98                	cltq   
  8017ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d5:	00 
  8017d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017dc:	49 89 c8             	mov    %rcx,%r8
  8017df:	48 89 d1             	mov    %rdx,%rcx
  8017e2:	48 89 c2             	mov    %rax,%rdx
  8017e5:	be 01 00 00 00       	mov    $0x1,%esi
  8017ea:	bf 04 00 00 00       	mov    $0x4,%edi
  8017ef:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  8017f6:	00 00 00 
  8017f9:	ff d0                	callq  *%rax
}
  8017fb:	c9                   	leaveq 
  8017fc:	c3                   	retq   

00000000008017fd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017fd:	55                   	push   %rbp
  8017fe:	48 89 e5             	mov    %rsp,%rbp
  801801:	48 83 ec 30          	sub    $0x30,%rsp
  801805:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801808:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80180f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801813:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801817:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80181a:	48 63 c8             	movslq %eax,%rcx
  80181d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801821:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801824:	48 63 f0             	movslq %eax,%rsi
  801827:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182e:	48 98                	cltq   
  801830:	48 89 0c 24          	mov    %rcx,(%rsp)
  801834:	49 89 f9             	mov    %rdi,%r9
  801837:	49 89 f0             	mov    %rsi,%r8
  80183a:	48 89 d1             	mov    %rdx,%rcx
  80183d:	48 89 c2             	mov    %rax,%rdx
  801840:	be 01 00 00 00       	mov    $0x1,%esi
  801845:	bf 05 00 00 00       	mov    $0x5,%edi
  80184a:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  801851:	00 00 00 
  801854:	ff d0                	callq  *%rax
}
  801856:	c9                   	leaveq 
  801857:	c3                   	retq   

0000000000801858 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801858:	55                   	push   %rbp
  801859:	48 89 e5             	mov    %rsp,%rbp
  80185c:	48 83 ec 20          	sub    $0x20,%rsp
  801860:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801863:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801867:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186e:	48 98                	cltq   
  801870:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801877:	00 
  801878:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801884:	48 89 d1             	mov    %rdx,%rcx
  801887:	48 89 c2             	mov    %rax,%rdx
  80188a:	be 01 00 00 00       	mov    $0x1,%esi
  80188f:	bf 06 00 00 00       	mov    $0x6,%edi
  801894:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	callq  *%rax
}
  8018a0:	c9                   	leaveq 
  8018a1:	c3                   	retq   

00000000008018a2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018a2:	55                   	push   %rbp
  8018a3:	48 89 e5             	mov    %rsp,%rbp
  8018a6:	48 83 ec 10          	sub    $0x10,%rsp
  8018aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ad:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018b3:	48 63 d0             	movslq %eax,%rdx
  8018b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b9:	48 98                	cltq   
  8018bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c2:	00 
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	48 89 d1             	mov    %rdx,%rcx
  8018d2:	48 89 c2             	mov    %rax,%rdx
  8018d5:	be 01 00 00 00       	mov    $0x1,%esi
  8018da:	bf 08 00 00 00       	mov    $0x8,%edi
  8018df:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	callq  *%rax
}
  8018eb:	c9                   	leaveq 
  8018ec:	c3                   	retq   

00000000008018ed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018ed:	55                   	push   %rbp
  8018ee:	48 89 e5             	mov    %rsp,%rbp
  8018f1:	48 83 ec 20          	sub    $0x20,%rsp
  8018f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801900:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801903:	48 98                	cltq   
  801905:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190c:	00 
  80190d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801913:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801919:	48 89 d1             	mov    %rdx,%rcx
  80191c:	48 89 c2             	mov    %rax,%rdx
  80191f:	be 01 00 00 00       	mov    $0x1,%esi
  801924:	bf 09 00 00 00       	mov    $0x9,%edi
  801929:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  801930:	00 00 00 
  801933:	ff d0                	callq  *%rax
}
  801935:	c9                   	leaveq 
  801936:	c3                   	retq   

0000000000801937 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801937:	55                   	push   %rbp
  801938:	48 89 e5             	mov    %rsp,%rbp
  80193b:	48 83 ec 20          	sub    $0x20,%rsp
  80193f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801942:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801946:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194d:	48 98                	cltq   
  80194f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801956:	00 
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801963:	48 89 d1             	mov    %rdx,%rcx
  801966:	48 89 c2             	mov    %rax,%rdx
  801969:	be 01 00 00 00       	mov    $0x1,%esi
  80196e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801973:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  80197a:	00 00 00 
  80197d:	ff d0                	callq  *%rax
}
  80197f:	c9                   	leaveq 
  801980:	c3                   	retq   

0000000000801981 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801981:	55                   	push   %rbp
  801982:	48 89 e5             	mov    %rsp,%rbp
  801985:	48 83 ec 20          	sub    $0x20,%rsp
  801989:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80198c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801990:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801994:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801997:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199a:	48 63 f0             	movslq %eax,%rsi
  80199d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a4:	48 98                	cltq   
  8019a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b1:	00 
  8019b2:	49 89 f1             	mov    %rsi,%r9
  8019b5:	49 89 c8             	mov    %rcx,%r8
  8019b8:	48 89 d1             	mov    %rdx,%rcx
  8019bb:	48 89 c2             	mov    %rax,%rdx
  8019be:	be 00 00 00 00       	mov    $0x0,%esi
  8019c3:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019c8:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  8019cf:	00 00 00 
  8019d2:	ff d0                	callq  *%rax
}
  8019d4:	c9                   	leaveq 
  8019d5:	c3                   	retq   

00000000008019d6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019d6:	55                   	push   %rbp
  8019d7:	48 89 e5             	mov    %rsp,%rbp
  8019da:	48 83 ec 10          	sub    $0x10,%rsp
  8019de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ed:	00 
  8019ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ff:	48 89 c2             	mov    %rax,%rdx
  801a02:	be 01 00 00 00       	mov    $0x1,%esi
  801a07:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a0c:	48 b8 d7 15 80 00 00 	movabs $0x8015d7,%rax
  801a13:	00 00 00 
  801a16:	ff d0                	callq  *%rax
}
  801a18:	c9                   	leaveq 
  801a19:	c3                   	retq   

0000000000801a1a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801a1a:	55                   	push   %rbp
  801a1b:	48 89 e5             	mov    %rsp,%rbp
  801a1e:	48 83 ec 10          	sub    $0x10,%rsp
  801a22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801a26:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801a2d:	00 00 00 
  801a30:	48 8b 00             	mov    (%rax),%rax
  801a33:	48 85 c0             	test   %rax,%rax
  801a36:	75 49                	jne    801a81 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  801a38:	ba 07 00 00 00       	mov    $0x7,%edx
  801a3d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801a42:	bf 00 00 00 00       	mov    $0x0,%edi
  801a47:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  801a4e:	00 00 00 
  801a51:	ff d0                	callq  *%rax
  801a53:	85 c0                	test   %eax,%eax
  801a55:	79 2a                	jns    801a81 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  801a57:	48 ba f8 3c 80 00 00 	movabs $0x803cf8,%rdx
  801a5e:	00 00 00 
  801a61:	be 21 00 00 00       	mov    $0x21,%esi
  801a66:	48 bf 23 3d 80 00 00 	movabs $0x803d23,%rdi
  801a6d:	00 00 00 
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	48 b9 29 34 80 00 00 	movabs $0x803429,%rcx
  801a7c:	00 00 00 
  801a7f:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801a81:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801a88:	00 00 00 
  801a8b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a8f:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  801a92:	48 be dd 1a 80 00 00 	movabs $0x801add,%rsi
  801a99:	00 00 00 
  801a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa1:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  801aa8:	00 00 00 
  801aab:	ff d0                	callq  *%rax
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	79 2a                	jns    801adb <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  801ab1:	48 ba 38 3d 80 00 00 	movabs $0x803d38,%rdx
  801ab8:	00 00 00 
  801abb:	be 27 00 00 00       	mov    $0x27,%esi
  801ac0:	48 bf 23 3d 80 00 00 	movabs $0x803d23,%rdi
  801ac7:	00 00 00 
  801aca:	b8 00 00 00 00       	mov    $0x0,%eax
  801acf:	48 b9 29 34 80 00 00 	movabs $0x803429,%rcx
  801ad6:	00 00 00 
  801ad9:	ff d1                	callq  *%rcx
}
  801adb:	c9                   	leaveq 
  801adc:	c3                   	retq   

0000000000801add <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801add:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801ae0:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801ae7:	00 00 00 
call *%rax
  801aea:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  801aec:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801af3:	00 
    movq 152(%rsp), %rcx
  801af4:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801afb:	00 
    subq $8, %rcx
  801afc:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  801b00:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  801b03:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801b0a:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  801b0b:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  801b0f:	4c 8b 3c 24          	mov    (%rsp),%r15
  801b13:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801b18:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801b1d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801b22:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801b27:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801b2c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801b31:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801b36:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801b3b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801b40:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801b45:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801b4a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801b4f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801b54:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801b59:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  801b5d:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  801b61:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  801b62:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  801b63:	c3                   	retq   

0000000000801b64 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b64:	55                   	push   %rbp
  801b65:	48 89 e5             	mov    %rsp,%rbp
  801b68:	48 83 ec 08          	sub    $0x8,%rsp
  801b6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b74:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b7b:	ff ff ff 
  801b7e:	48 01 d0             	add    %rdx,%rax
  801b81:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   

0000000000801b87 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	48 83 ec 08          	sub    $0x8,%rsp
  801b8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b97:	48 89 c7             	mov    %rax,%rdi
  801b9a:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
  801ba6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801bac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801bb0:	c9                   	leaveq 
  801bb1:	c3                   	retq   

0000000000801bb2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801bb2:	55                   	push   %rbp
  801bb3:	48 89 e5             	mov    %rsp,%rbp
  801bb6:	48 83 ec 18          	sub    $0x18,%rsp
  801bba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801bc5:	eb 6b                	jmp    801c32 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bca:	48 98                	cltq   
  801bcc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801bd2:	48 c1 e0 0c          	shl    $0xc,%rax
  801bd6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801bda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bde:	48 c1 e8 15          	shr    $0x15,%rax
  801be2:	48 89 c2             	mov    %rax,%rdx
  801be5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bec:	01 00 00 
  801bef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bf3:	83 e0 01             	and    $0x1,%eax
  801bf6:	48 85 c0             	test   %rax,%rax
  801bf9:	74 21                	je     801c1c <fd_alloc+0x6a>
  801bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bff:	48 c1 e8 0c          	shr    $0xc,%rax
  801c03:	48 89 c2             	mov    %rax,%rdx
  801c06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c0d:	01 00 00 
  801c10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c14:	83 e0 01             	and    $0x1,%eax
  801c17:	48 85 c0             	test   %rax,%rax
  801c1a:	75 12                	jne    801c2e <fd_alloc+0x7c>
			*fd_store = fd;
  801c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c24:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	eb 1a                	jmp    801c48 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c32:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801c36:	7e 8f                	jle    801bc7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c43:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c48:	c9                   	leaveq 
  801c49:	c3                   	retq   

0000000000801c4a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c4a:	55                   	push   %rbp
  801c4b:	48 89 e5             	mov    %rsp,%rbp
  801c4e:	48 83 ec 20          	sub    $0x20,%rsp
  801c52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c59:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c5d:	78 06                	js     801c65 <fd_lookup+0x1b>
  801c5f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c63:	7e 07                	jle    801c6c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c6a:	eb 6c                	jmp    801cd8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c6f:	48 98                	cltq   
  801c71:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c77:	48 c1 e0 0c          	shl    $0xc,%rax
  801c7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c83:	48 c1 e8 15          	shr    $0x15,%rax
  801c87:	48 89 c2             	mov    %rax,%rdx
  801c8a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c91:	01 00 00 
  801c94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c98:	83 e0 01             	and    $0x1,%eax
  801c9b:	48 85 c0             	test   %rax,%rax
  801c9e:	74 21                	je     801cc1 <fd_lookup+0x77>
  801ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ca8:	48 89 c2             	mov    %rax,%rdx
  801cab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cb2:	01 00 00 
  801cb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cb9:	83 e0 01             	and    $0x1,%eax
  801cbc:	48 85 c0             	test   %rax,%rax
  801cbf:	75 07                	jne    801cc8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801cc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc6:	eb 10                	jmp    801cd8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801cc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ccc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cd0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd8:	c9                   	leaveq 
  801cd9:	c3                   	retq   

0000000000801cda <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801cda:	55                   	push   %rbp
  801cdb:	48 89 e5             	mov    %rsp,%rbp
  801cde:	48 83 ec 30          	sub    $0x30,%rsp
  801ce2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ce6:	89 f0                	mov    %esi,%eax
  801ce8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ceb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cef:	48 89 c7             	mov    %rax,%rdi
  801cf2:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
  801cfe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d02:	48 89 d6             	mov    %rdx,%rsi
  801d05:	89 c7                	mov    %eax,%edi
  801d07:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	callq  *%rax
  801d13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d1a:	78 0a                	js     801d26 <fd_close+0x4c>
	    || fd != fd2)
  801d1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d20:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801d24:	74 12                	je     801d38 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801d26:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801d2a:	74 05                	je     801d31 <fd_close+0x57>
  801d2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2f:	eb 05                	jmp    801d36 <fd_close+0x5c>
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
  801d36:	eb 69                	jmp    801da1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3c:	8b 00                	mov    (%rax),%eax
  801d3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d42:	48 89 d6             	mov    %rdx,%rsi
  801d45:	89 c7                	mov    %eax,%edi
  801d47:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  801d4e:	00 00 00 
  801d51:	ff d0                	callq  *%rax
  801d53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d5a:	78 2a                	js     801d86 <fd_close+0xac>
		if (dev->dev_close)
  801d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d60:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d64:	48 85 c0             	test   %rax,%rax
  801d67:	74 16                	je     801d7f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6d:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d71:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d75:	48 89 d7             	mov    %rdx,%rdi
  801d78:	ff d0                	callq  *%rax
  801d7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d7d:	eb 07                	jmp    801d86 <fd_close+0xac>
		else
			r = 0;
  801d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8a:	48 89 c6             	mov    %rax,%rsi
  801d8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d92:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  801d99:	00 00 00 
  801d9c:	ff d0                	callq  *%rax
	return r;
  801d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801da1:	c9                   	leaveq 
  801da2:	c3                   	retq   

0000000000801da3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801da3:	55                   	push   %rbp
  801da4:	48 89 e5             	mov    %rsp,%rbp
  801da7:	48 83 ec 20          	sub    $0x20,%rsp
  801dab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801db2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801db9:	eb 41                	jmp    801dfc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801dbb:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801dc2:	00 00 00 
  801dc5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dc8:	48 63 d2             	movslq %edx,%rdx
  801dcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcf:	8b 00                	mov    (%rax),%eax
  801dd1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801dd4:	75 22                	jne    801df8 <dev_lookup+0x55>
			*dev = devtab[i];
  801dd6:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ddd:	00 00 00 
  801de0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801de3:	48 63 d2             	movslq %edx,%rdx
  801de6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801dea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	eb 60                	jmp    801e58 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801df8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dfc:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e03:	00 00 00 
  801e06:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e09:	48 63 d2             	movslq %edx,%rdx
  801e0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e10:	48 85 c0             	test   %rax,%rax
  801e13:	75 a6                	jne    801dbb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e15:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801e1c:	00 00 00 
  801e1f:	48 8b 00             	mov    (%rax),%rax
  801e22:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801e28:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e2b:	89 c6                	mov    %eax,%esi
  801e2d:	48 bf 70 3d 80 00 00 	movabs $0x803d70,%rdi
  801e34:	00 00 00 
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3c:	48 b9 b6 02 80 00 00 	movabs $0x8002b6,%rcx
  801e43:	00 00 00 
  801e46:	ff d1                	callq  *%rcx
	*dev = 0;
  801e48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e58:	c9                   	leaveq 
  801e59:	c3                   	retq   

0000000000801e5a <close>:

int
close(int fdnum)
{
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
  801e5e:	48 83 ec 20          	sub    $0x20,%rsp
  801e62:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e6c:	48 89 d6             	mov    %rdx,%rsi
  801e6f:	89 c7                	mov    %eax,%edi
  801e71:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
  801e7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e84:	79 05                	jns    801e8b <close+0x31>
		return r;
  801e86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e89:	eb 18                	jmp    801ea3 <close+0x49>
	else
		return fd_close(fd, 1);
  801e8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e8f:	be 01 00 00 00       	mov    $0x1,%esi
  801e94:	48 89 c7             	mov    %rax,%rdi
  801e97:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  801e9e:	00 00 00 
  801ea1:	ff d0                	callq  *%rax
}
  801ea3:	c9                   	leaveq 
  801ea4:	c3                   	retq   

0000000000801ea5 <close_all>:

void
close_all(void)
{
  801ea5:	55                   	push   %rbp
  801ea6:	48 89 e5             	mov    %rsp,%rbp
  801ea9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ead:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eb4:	eb 15                	jmp    801ecb <close_all+0x26>
		close(i);
  801eb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb9:	89 c7                	mov    %eax,%edi
  801ebb:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  801ec2:	00 00 00 
  801ec5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ec7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ecb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ecf:	7e e5                	jle    801eb6 <close_all+0x11>
		close(i);
}
  801ed1:	c9                   	leaveq 
  801ed2:	c3                   	retq   

0000000000801ed3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ed3:	55                   	push   %rbp
  801ed4:	48 89 e5             	mov    %rsp,%rbp
  801ed7:	48 83 ec 40          	sub    $0x40,%rsp
  801edb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ede:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ee1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ee5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ee8:	48 89 d6             	mov    %rdx,%rsi
  801eeb:	89 c7                	mov    %eax,%edi
  801eed:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
  801ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f00:	79 08                	jns    801f0a <dup+0x37>
		return r;
  801f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f05:	e9 70 01 00 00       	jmpq   80207a <dup+0x1a7>
	close(newfdnum);
  801f0a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f0d:	89 c7                	mov    %eax,%edi
  801f0f:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801f1b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f1e:	48 98                	cltq   
  801f20:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f26:	48 c1 e0 0c          	shl    $0xc,%rax
  801f2a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801f2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f32:	48 89 c7             	mov    %rax,%rdi
  801f35:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801f3c:	00 00 00 
  801f3f:	ff d0                	callq  *%rax
  801f41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f49:	48 89 c7             	mov    %rax,%rdi
  801f4c:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  801f53:	00 00 00 
  801f56:	ff d0                	callq  *%rax
  801f58:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f60:	48 c1 e8 15          	shr    $0x15,%rax
  801f64:	48 89 c2             	mov    %rax,%rdx
  801f67:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f6e:	01 00 00 
  801f71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f75:	83 e0 01             	and    $0x1,%eax
  801f78:	48 85 c0             	test   %rax,%rax
  801f7b:	74 73                	je     801ff0 <dup+0x11d>
  801f7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f81:	48 c1 e8 0c          	shr    $0xc,%rax
  801f85:	48 89 c2             	mov    %rax,%rdx
  801f88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f8f:	01 00 00 
  801f92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f96:	83 e0 01             	and    $0x1,%eax
  801f99:	48 85 c0             	test   %rax,%rax
  801f9c:	74 52                	je     801ff0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa2:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa6:	48 89 c2             	mov    %rax,%rdx
  801fa9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb0:	01 00 00 
  801fb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb7:	25 07 0e 00 00       	and    $0xe07,%eax
  801fbc:	89 c1                	mov    %eax,%ecx
  801fbe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc6:	41 89 c8             	mov    %ecx,%r8d
  801fc9:	48 89 d1             	mov    %rdx,%rcx
  801fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd1:	48 89 c6             	mov    %rax,%rsi
  801fd4:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd9:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
  801fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fec:	79 02                	jns    801ff0 <dup+0x11d>
			goto err;
  801fee:	eb 57                	jmp    802047 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ff8:	48 89 c2             	mov    %rax,%rdx
  801ffb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802002:	01 00 00 
  802005:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802009:	25 07 0e 00 00       	and    $0xe07,%eax
  80200e:	89 c1                	mov    %eax,%ecx
  802010:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802014:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802018:	41 89 c8             	mov    %ecx,%r8d
  80201b:	48 89 d1             	mov    %rdx,%rcx
  80201e:	ba 00 00 00 00       	mov    $0x0,%edx
  802023:	48 89 c6             	mov    %rax,%rsi
  802026:	bf 00 00 00 00       	mov    $0x0,%edi
  80202b:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
  802037:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80203a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80203e:	79 02                	jns    802042 <dup+0x16f>
		goto err;
  802040:	eb 05                	jmp    802047 <dup+0x174>

	return newfdnum;
  802042:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802045:	eb 33                	jmp    80207a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204b:	48 89 c6             	mov    %rax,%rsi
  80204e:	bf 00 00 00 00       	mov    $0x0,%edi
  802053:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  80205a:	00 00 00 
  80205d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80205f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802063:	48 89 c6             	mov    %rax,%rsi
  802066:	bf 00 00 00 00       	mov    $0x0,%edi
  80206b:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  802072:	00 00 00 
  802075:	ff d0                	callq  *%rax
	return r;
  802077:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80207a:	c9                   	leaveq 
  80207b:	c3                   	retq   

000000000080207c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80207c:	55                   	push   %rbp
  80207d:	48 89 e5             	mov    %rsp,%rbp
  802080:	48 83 ec 40          	sub    $0x40,%rsp
  802084:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802087:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80208b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80208f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802093:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802096:	48 89 d6             	mov    %rdx,%rsi
  802099:	89 c7                	mov    %eax,%edi
  80209b:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
  8020a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ae:	78 24                	js     8020d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b4:	8b 00                	mov    (%rax),%eax
  8020b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020ba:	48 89 d6             	mov    %rdx,%rsi
  8020bd:	89 c7                	mov    %eax,%edi
  8020bf:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax
  8020cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020d2:	79 05                	jns    8020d9 <read+0x5d>
		return r;
  8020d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d7:	eb 76                	jmp    80214f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dd:	8b 40 08             	mov    0x8(%rax),%eax
  8020e0:	83 e0 03             	and    $0x3,%eax
  8020e3:	83 f8 01             	cmp    $0x1,%eax
  8020e6:	75 3a                	jne    802122 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020e8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020ef:	00 00 00 
  8020f2:	48 8b 00             	mov    (%rax),%rax
  8020f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020fe:	89 c6                	mov    %eax,%esi
  802100:	48 bf 8f 3d 80 00 00 	movabs $0x803d8f,%rdi
  802107:	00 00 00 
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	48 b9 b6 02 80 00 00 	movabs $0x8002b6,%rcx
  802116:	00 00 00 
  802119:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80211b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802120:	eb 2d                	jmp    80214f <read+0xd3>
	}
	if (!dev->dev_read)
  802122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802126:	48 8b 40 10          	mov    0x10(%rax),%rax
  80212a:	48 85 c0             	test   %rax,%rax
  80212d:	75 07                	jne    802136 <read+0xba>
		return -E_NOT_SUPP;
  80212f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802134:	eb 19                	jmp    80214f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80213e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802142:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802146:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80214a:	48 89 cf             	mov    %rcx,%rdi
  80214d:	ff d0                	callq  *%rax
}
  80214f:	c9                   	leaveq 
  802150:	c3                   	retq   

0000000000802151 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802151:	55                   	push   %rbp
  802152:	48 89 e5             	mov    %rsp,%rbp
  802155:	48 83 ec 30          	sub    $0x30,%rsp
  802159:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80215c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802160:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80216b:	eb 49                	jmp    8021b6 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80216d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802170:	48 98                	cltq   
  802172:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802176:	48 29 c2             	sub    %rax,%rdx
  802179:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217c:	48 63 c8             	movslq %eax,%rcx
  80217f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802183:	48 01 c1             	add    %rax,%rcx
  802186:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802189:	48 89 ce             	mov    %rcx,%rsi
  80218c:	89 c7                	mov    %eax,%edi
  80218e:	48 b8 7c 20 80 00 00 	movabs $0x80207c,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
  80219a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80219d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021a1:	79 05                	jns    8021a8 <readn+0x57>
			return m;
  8021a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021a6:	eb 1c                	jmp    8021c4 <readn+0x73>
		if (m == 0)
  8021a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021ac:	75 02                	jne    8021b0 <readn+0x5f>
			break;
  8021ae:	eb 11                	jmp    8021c1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021b3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8021b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b9:	48 98                	cltq   
  8021bb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8021bf:	72 ac                	jb     80216d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8021c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021c4:	c9                   	leaveq 
  8021c5:	c3                   	retq   

00000000008021c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021c6:	55                   	push   %rbp
  8021c7:	48 89 e5             	mov    %rsp,%rbp
  8021ca:	48 83 ec 40          	sub    $0x40,%rsp
  8021ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021e0:	48 89 d6             	mov    %rdx,%rsi
  8021e3:	89 c7                	mov    %eax,%edi
  8021e5:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
  8021f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f8:	78 24                	js     80221e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fe:	8b 00                	mov    (%rax),%eax
  802200:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802204:	48 89 d6             	mov    %rdx,%rsi
  802207:	89 c7                	mov    %eax,%edi
  802209:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
  802215:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802218:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221c:	79 05                	jns    802223 <write+0x5d>
		return r;
  80221e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802221:	eb 75                	jmp    802298 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802227:	8b 40 08             	mov    0x8(%rax),%eax
  80222a:	83 e0 03             	and    $0x3,%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 3a                	jne    80226b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802231:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802238:	00 00 00 
  80223b:	48 8b 00             	mov    (%rax),%rax
  80223e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802244:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802247:	89 c6                	mov    %eax,%esi
  802249:	48 bf ab 3d 80 00 00 	movabs $0x803dab,%rdi
  802250:	00 00 00 
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
  802258:	48 b9 b6 02 80 00 00 	movabs $0x8002b6,%rcx
  80225f:	00 00 00 
  802262:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802264:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802269:	eb 2d                	jmp    802298 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80226b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802273:	48 85 c0             	test   %rax,%rax
  802276:	75 07                	jne    80227f <write+0xb9>
		return -E_NOT_SUPP;
  802278:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80227d:	eb 19                	jmp    802298 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80227f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802283:	48 8b 40 18          	mov    0x18(%rax),%rax
  802287:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80228b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80228f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802293:	48 89 cf             	mov    %rcx,%rdi
  802296:	ff d0                	callq  *%rax
}
  802298:	c9                   	leaveq 
  802299:	c3                   	retq   

000000000080229a <seek>:

int
seek(int fdnum, off_t offset)
{
  80229a:	55                   	push   %rbp
  80229b:	48 89 e5             	mov    %rsp,%rbp
  80229e:	48 83 ec 18          	sub    $0x18,%rsp
  8022a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022af:	48 89 d6             	mov    %rdx,%rsi
  8022b2:	89 c7                	mov    %eax,%edi
  8022b4:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax
  8022c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c7:	79 05                	jns    8022ce <seek+0x34>
		return r;
  8022c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cc:	eb 0f                	jmp    8022dd <seek+0x43>
	fd->fd_offset = offset;
  8022ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022d5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022dd:	c9                   	leaveq 
  8022de:	c3                   	retq   

00000000008022df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022df:	55                   	push   %rbp
  8022e0:	48 89 e5             	mov    %rsp,%rbp
  8022e3:	48 83 ec 30          	sub    $0x30,%rsp
  8022e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022f4:	48 89 d6             	mov    %rdx,%rsi
  8022f7:	89 c7                	mov    %eax,%edi
  8022f9:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  802300:	00 00 00 
  802303:	ff d0                	callq  *%rax
  802305:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802308:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80230c:	78 24                	js     802332 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80230e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802312:	8b 00                	mov    (%rax),%eax
  802314:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802318:	48 89 d6             	mov    %rdx,%rsi
  80231b:	89 c7                	mov    %eax,%edi
  80231d:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  802324:	00 00 00 
  802327:	ff d0                	callq  *%rax
  802329:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802330:	79 05                	jns    802337 <ftruncate+0x58>
		return r;
  802332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802335:	eb 72                	jmp    8023a9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233b:	8b 40 08             	mov    0x8(%rax),%eax
  80233e:	83 e0 03             	and    $0x3,%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	75 3a                	jne    80237f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802345:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80234c:	00 00 00 
  80234f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802352:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802358:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80235b:	89 c6                	mov    %eax,%esi
  80235d:	48 bf c8 3d 80 00 00 	movabs $0x803dc8,%rdi
  802364:	00 00 00 
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	48 b9 b6 02 80 00 00 	movabs $0x8002b6,%rcx
  802373:	00 00 00 
  802376:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802378:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237d:	eb 2a                	jmp    8023a9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80237f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802383:	48 8b 40 30          	mov    0x30(%rax),%rax
  802387:	48 85 c0             	test   %rax,%rax
  80238a:	75 07                	jne    802393 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80238c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802391:	eb 16                	jmp    8023a9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802393:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802397:	48 8b 40 30          	mov    0x30(%rax),%rax
  80239b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80239f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8023a2:	89 ce                	mov    %ecx,%esi
  8023a4:	48 89 d7             	mov    %rdx,%rdi
  8023a7:	ff d0                	callq  *%rax
}
  8023a9:	c9                   	leaveq 
  8023aa:	c3                   	retq   

00000000008023ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
  8023af:	48 83 ec 30          	sub    $0x30,%rsp
  8023b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c1:	48 89 d6             	mov    %rdx,%rsi
  8023c4:	89 c7                	mov    %eax,%edi
  8023c6:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  8023cd:	00 00 00 
  8023d0:	ff d0                	callq  *%rax
  8023d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d9:	78 24                	js     8023ff <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023df:	8b 00                	mov    (%rax),%eax
  8023e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e5:	48 89 d6             	mov    %rdx,%rsi
  8023e8:	89 c7                	mov    %eax,%edi
  8023ea:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
  8023f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fd:	79 05                	jns    802404 <fstat+0x59>
		return r;
  8023ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802402:	eb 5e                	jmp    802462 <fstat+0xb7>
	if (!dev->dev_stat)
  802404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802408:	48 8b 40 28          	mov    0x28(%rax),%rax
  80240c:	48 85 c0             	test   %rax,%rax
  80240f:	75 07                	jne    802418 <fstat+0x6d>
		return -E_NOT_SUPP;
  802411:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802416:	eb 4a                	jmp    802462 <fstat+0xb7>
	stat->st_name[0] = 0;
  802418:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80241c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80241f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802423:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80242a:	00 00 00 
	stat->st_isdir = 0;
  80242d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802431:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802438:	00 00 00 
	stat->st_dev = dev;
  80243b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80243f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802443:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80244a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802452:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802456:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80245a:	48 89 ce             	mov    %rcx,%rsi
  80245d:	48 89 d7             	mov    %rdx,%rdi
  802460:	ff d0                	callq  *%rax
}
  802462:	c9                   	leaveq 
  802463:	c3                   	retq   

0000000000802464 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
  802468:	48 83 ec 20          	sub    $0x20,%rsp
  80246c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802470:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802478:	be 00 00 00 00       	mov    $0x0,%esi
  80247d:	48 89 c7             	mov    %rax,%rdi
  802480:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802487:	00 00 00 
  80248a:	ff d0                	callq  *%rax
  80248c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80248f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802493:	79 05                	jns    80249a <stat+0x36>
		return fd;
  802495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802498:	eb 2f                	jmp    8024c9 <stat+0x65>
	r = fstat(fd, stat);
  80249a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80249e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a1:	48 89 d6             	mov    %rdx,%rsi
  8024a4:	89 c7                	mov    %eax,%edi
  8024a6:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  8024ad:	00 00 00 
  8024b0:	ff d0                	callq  *%rax
  8024b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8024b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b8:	89 c7                	mov    %eax,%edi
  8024ba:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  8024c1:	00 00 00 
  8024c4:	ff d0                	callq  *%rax
	return r;
  8024c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8024c9:	c9                   	leaveq 
  8024ca:	c3                   	retq   

00000000008024cb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8024cb:	55                   	push   %rbp
  8024cc:	48 89 e5             	mov    %rsp,%rbp
  8024cf:	48 83 ec 10          	sub    $0x10,%rsp
  8024d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024da:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024e1:	00 00 00 
  8024e4:	8b 00                	mov    (%rax),%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	75 1d                	jne    802507 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8024ef:	48 b8 96 36 80 00 00 	movabs $0x803696,%rax
  8024f6:	00 00 00 
  8024f9:	ff d0                	callq  *%rax
  8024fb:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802502:	00 00 00 
  802505:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802507:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80250e:	00 00 00 
  802511:	8b 00                	mov    (%rax),%eax
  802513:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802516:	b9 07 00 00 00       	mov    $0x7,%ecx
  80251b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802522:	00 00 00 
  802525:	89 c7                	mov    %eax,%edi
  802527:	48 b8 fe 35 80 00 00 	movabs $0x8035fe,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802537:	ba 00 00 00 00       	mov    $0x0,%edx
  80253c:	48 89 c6             	mov    %rax,%rsi
  80253f:	bf 00 00 00 00       	mov    $0x0,%edi
  802544:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	callq  *%rax
}
  802550:	c9                   	leaveq 
  802551:	c3                   	retq   

0000000000802552 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802552:	55                   	push   %rbp
  802553:	48 89 e5             	mov    %rsp,%rbp
  802556:	48 83 ec 20          	sub    $0x20,%rsp
  80255a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80255e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802565:	48 89 c7             	mov    %rax,%rdi
  802568:	48 b8 12 0e 80 00 00 	movabs $0x800e12,%rax
  80256f:	00 00 00 
  802572:	ff d0                	callq  *%rax
  802574:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802579:	7e 0a                	jle    802585 <open+0x33>
		return -E_BAD_PATH;
  80257b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802580:	e9 a5 00 00 00       	jmpq   80262a <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802585:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802589:	48 89 c7             	mov    %rax,%rdi
  80258c:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  802593:	00 00 00 
  802596:	ff d0                	callq  *%rax
  802598:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259f:	79 08                	jns    8025a9 <open+0x57>
		return r;
  8025a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a4:	e9 81 00 00 00       	jmpq   80262a <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8025a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ad:	48 89 c6             	mov    %rax,%rsi
  8025b0:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8025b7:	00 00 00 
  8025ba:	48 b8 7e 0e 80 00 00 	movabs $0x800e7e,%rax
  8025c1:	00 00 00 
  8025c4:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8025c6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025cd:	00 00 00 
  8025d0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8025d3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dd:	48 89 c6             	mov    %rax,%rsi
  8025e0:	bf 01 00 00 00       	mov    $0x1,%edi
  8025e5:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8025ec:	00 00 00 
  8025ef:	ff d0                	callq  *%rax
  8025f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f8:	79 1d                	jns    802617 <open+0xc5>
		fd_close(fd, 0);
  8025fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fe:	be 00 00 00 00       	mov    $0x0,%esi
  802603:	48 89 c7             	mov    %rax,%rdi
  802606:	48 b8 da 1c 80 00 00 	movabs $0x801cda,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
		return r;
  802612:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802615:	eb 13                	jmp    80262a <open+0xd8>
	}

	return fd2num(fd);
  802617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261b:	48 89 c7             	mov    %rax,%rdi
  80261e:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802625:	00 00 00 
  802628:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80262a:	c9                   	leaveq 
  80262b:	c3                   	retq   

000000000080262c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80262c:	55                   	push   %rbp
  80262d:	48 89 e5             	mov    %rsp,%rbp
  802630:	48 83 ec 10          	sub    $0x10,%rsp
  802634:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80263c:	8b 50 0c             	mov    0xc(%rax),%edx
  80263f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802646:	00 00 00 
  802649:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80264b:	be 00 00 00 00       	mov    $0x0,%esi
  802650:	bf 06 00 00 00       	mov    $0x6,%edi
  802655:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	callq  *%rax
}
  802661:	c9                   	leaveq 
  802662:	c3                   	retq   

0000000000802663 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802663:	55                   	push   %rbp
  802664:	48 89 e5             	mov    %rsp,%rbp
  802667:	48 83 ec 30          	sub    $0x30,%rsp
  80266b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80266f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802673:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267b:	8b 50 0c             	mov    0xc(%rax),%edx
  80267e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802685:	00 00 00 
  802688:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80268a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802691:	00 00 00 
  802694:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802698:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80269c:	be 00 00 00 00       	mov    $0x0,%esi
  8026a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8026a6:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
  8026b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b9:	79 08                	jns    8026c3 <devfile_read+0x60>
		return r;
  8026bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026be:	e9 a4 00 00 00       	jmpq   802767 <devfile_read+0x104>
	assert(r <= n);
  8026c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c6:	48 98                	cltq   
  8026c8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8026cc:	76 35                	jbe    802703 <devfile_read+0xa0>
  8026ce:	48 b9 f5 3d 80 00 00 	movabs $0x803df5,%rcx
  8026d5:	00 00 00 
  8026d8:	48 ba fc 3d 80 00 00 	movabs $0x803dfc,%rdx
  8026df:	00 00 00 
  8026e2:	be 84 00 00 00       	mov    $0x84,%esi
  8026e7:	48 bf 11 3e 80 00 00 	movabs $0x803e11,%rdi
  8026ee:	00 00 00 
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f6:	49 b8 29 34 80 00 00 	movabs $0x803429,%r8
  8026fd:	00 00 00 
  802700:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802703:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80270a:	7e 35                	jle    802741 <devfile_read+0xde>
  80270c:	48 b9 1c 3e 80 00 00 	movabs $0x803e1c,%rcx
  802713:	00 00 00 
  802716:	48 ba fc 3d 80 00 00 	movabs $0x803dfc,%rdx
  80271d:	00 00 00 
  802720:	be 85 00 00 00       	mov    $0x85,%esi
  802725:	48 bf 11 3e 80 00 00 	movabs $0x803e11,%rdi
  80272c:	00 00 00 
  80272f:	b8 00 00 00 00       	mov    $0x0,%eax
  802734:	49 b8 29 34 80 00 00 	movabs $0x803429,%r8
  80273b:	00 00 00 
  80273e:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802744:	48 63 d0             	movslq %eax,%rdx
  802747:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80274b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802752:	00 00 00 
  802755:	48 89 c7             	mov    %rax,%rdi
  802758:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
	return r;
  802764:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 30          	sub    $0x30,%rsp
  802771:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802775:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802779:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80277d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802781:	8b 50 0c             	mov    0xc(%rax),%edx
  802784:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80278b:	00 00 00 
  80278e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802790:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802797:	00 00 00 
  80279a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80279e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8027a2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8027a9:	00 
  8027aa:	76 35                	jbe    8027e1 <devfile_write+0x78>
  8027ac:	48 b9 28 3e 80 00 00 	movabs $0x803e28,%rcx
  8027b3:	00 00 00 
  8027b6:	48 ba fc 3d 80 00 00 	movabs $0x803dfc,%rdx
  8027bd:	00 00 00 
  8027c0:	be 9e 00 00 00       	mov    $0x9e,%esi
  8027c5:	48 bf 11 3e 80 00 00 	movabs $0x803e11,%rdi
  8027cc:	00 00 00 
  8027cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d4:	49 b8 29 34 80 00 00 	movabs $0x803429,%r8
  8027db:	00 00 00 
  8027de:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8027e1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e9:	48 89 c6             	mov    %rax,%rsi
  8027ec:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8027f3:	00 00 00 
  8027f6:	48 b8 b9 12 80 00 00 	movabs $0x8012b9,%rax
  8027fd:	00 00 00 
  802800:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802802:	be 00 00 00 00       	mov    $0x0,%esi
  802807:	bf 04 00 00 00       	mov    $0x4,%edi
  80280c:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
  802818:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281f:	79 05                	jns    802826 <devfile_write+0xbd>
		return r;
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802824:	eb 43                	jmp    802869 <devfile_write+0x100>
	assert(r <= n);
  802826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802829:	48 98                	cltq   
  80282b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80282f:	76 35                	jbe    802866 <devfile_write+0xfd>
  802831:	48 b9 f5 3d 80 00 00 	movabs $0x803df5,%rcx
  802838:	00 00 00 
  80283b:	48 ba fc 3d 80 00 00 	movabs $0x803dfc,%rdx
  802842:	00 00 00 
  802845:	be a2 00 00 00       	mov    $0xa2,%esi
  80284a:	48 bf 11 3e 80 00 00 	movabs $0x803e11,%rdi
  802851:	00 00 00 
  802854:	b8 00 00 00 00       	mov    $0x0,%eax
  802859:	49 b8 29 34 80 00 00 	movabs $0x803429,%r8
  802860:	00 00 00 
  802863:	41 ff d0             	callq  *%r8
	return r;
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802869:	c9                   	leaveq 
  80286a:	c3                   	retq   

000000000080286b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80286b:	55                   	push   %rbp
  80286c:	48 89 e5             	mov    %rsp,%rbp
  80286f:	48 83 ec 20          	sub    $0x20,%rsp
  802873:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802877:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80287b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287f:	8b 50 0c             	mov    0xc(%rax),%edx
  802882:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802889:	00 00 00 
  80288c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80288e:	be 00 00 00 00       	mov    $0x0,%esi
  802893:	bf 05 00 00 00       	mov    $0x5,%edi
  802898:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  80289f:	00 00 00 
  8028a2:	ff d0                	callq  *%rax
  8028a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ab:	79 05                	jns    8028b2 <devfile_stat+0x47>
		return r;
  8028ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b0:	eb 56                	jmp    802908 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b6:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8028bd:	00 00 00 
  8028c0:	48 89 c7             	mov    %rax,%rdi
  8028c3:	48 b8 7e 0e 80 00 00 	movabs $0x800e7e,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8028cf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028d6:	00 00 00 
  8028d9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8028df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8028e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f0:	00 00 00 
  8028f3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028fd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802908:	c9                   	leaveq 
  802909:	c3                   	retq   

000000000080290a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80290a:	55                   	push   %rbp
  80290b:	48 89 e5             	mov    %rsp,%rbp
  80290e:	48 83 ec 10          	sub    $0x10,%rsp
  802912:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802916:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80291d:	8b 50 0c             	mov    0xc(%rax),%edx
  802920:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802927:	00 00 00 
  80292a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80292c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802933:	00 00 00 
  802936:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802939:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80293c:	be 00 00 00 00       	mov    $0x0,%esi
  802941:	bf 02 00 00 00       	mov    $0x2,%edi
  802946:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  80294d:	00 00 00 
  802950:	ff d0                	callq  *%rax
}
  802952:	c9                   	leaveq 
  802953:	c3                   	retq   

0000000000802954 <remove>:

// Delete a file
int
remove(const char *path)
{
  802954:	55                   	push   %rbp
  802955:	48 89 e5             	mov    %rsp,%rbp
  802958:	48 83 ec 10          	sub    $0x10,%rsp
  80295c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802960:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802964:	48 89 c7             	mov    %rax,%rdi
  802967:	48 b8 12 0e 80 00 00 	movabs $0x800e12,%rax
  80296e:	00 00 00 
  802971:	ff d0                	callq  *%rax
  802973:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802978:	7e 07                	jle    802981 <remove+0x2d>
		return -E_BAD_PATH;
  80297a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80297f:	eb 33                	jmp    8029b4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802985:	48 89 c6             	mov    %rax,%rsi
  802988:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80298f:	00 00 00 
  802992:	48 b8 7e 0e 80 00 00 	movabs $0x800e7e,%rax
  802999:	00 00 00 
  80299c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80299e:	be 00 00 00 00       	mov    $0x0,%esi
  8029a3:	bf 07 00 00 00       	mov    $0x7,%edi
  8029a8:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
}
  8029b4:	c9                   	leaveq 
  8029b5:	c3                   	retq   

00000000008029b6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029ba:	be 00 00 00 00       	mov    $0x0,%esi
  8029bf:	bf 08 00 00 00       	mov    $0x8,%edi
  8029c4:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
}
  8029d0:	5d                   	pop    %rbp
  8029d1:	c3                   	retq   

00000000008029d2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8029d2:	55                   	push   %rbp
  8029d3:	48 89 e5             	mov    %rsp,%rbp
  8029d6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8029dd:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8029e4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8029eb:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029f2:	be 00 00 00 00       	mov    $0x0,%esi
  8029f7:	48 89 c7             	mov    %rax,%rdi
  8029fa:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802a01:	00 00 00 
  802a04:	ff d0                	callq  *%rax
  802a06:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0d:	79 28                	jns    802a37 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a12:	89 c6                	mov    %eax,%esi
  802a14:	48 bf 55 3e 80 00 00 	movabs $0x803e55,%rdi
  802a1b:	00 00 00 
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a23:	48 ba b6 02 80 00 00 	movabs $0x8002b6,%rdx
  802a2a:	00 00 00 
  802a2d:	ff d2                	callq  *%rdx
		return fd_src;
  802a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a32:	e9 74 01 00 00       	jmpq   802bab <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a37:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a3e:	be 01 01 00 00       	mov    $0x101,%esi
  802a43:	48 89 c7             	mov    %rax,%rdi
  802a46:	48 b8 52 25 80 00 00 	movabs $0x802552,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
  802a52:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a55:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a59:	79 39                	jns    802a94 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a5e:	89 c6                	mov    %eax,%esi
  802a60:	48 bf 6b 3e 80 00 00 	movabs $0x803e6b,%rdi
  802a67:	00 00 00 
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	48 ba b6 02 80 00 00 	movabs $0x8002b6,%rdx
  802a76:	00 00 00 
  802a79:	ff d2                	callq  *%rdx
		close(fd_src);
  802a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7e:	89 c7                	mov    %eax,%edi
  802a80:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802a87:	00 00 00 
  802a8a:	ff d0                	callq  *%rax
		return fd_dest;
  802a8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a8f:	e9 17 01 00 00       	jmpq   802bab <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a94:	eb 74                	jmp    802b0a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a99:	48 63 d0             	movslq %eax,%rdx
  802a9c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802aa3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa6:	48 89 ce             	mov    %rcx,%rsi
  802aa9:	89 c7                	mov    %eax,%edi
  802aab:	48 b8 c6 21 80 00 00 	movabs $0x8021c6,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	callq  *%rax
  802ab7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802aba:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802abe:	79 4a                	jns    802b0a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802ac0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ac3:	89 c6                	mov    %eax,%esi
  802ac5:	48 bf 85 3e 80 00 00 	movabs $0x803e85,%rdi
  802acc:	00 00 00 
  802acf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad4:	48 ba b6 02 80 00 00 	movabs $0x8002b6,%rdx
  802adb:	00 00 00 
  802ade:	ff d2                	callq  *%rdx
			close(fd_src);
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	89 c7                	mov    %eax,%edi
  802ae5:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
			close(fd_dest);
  802af1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802af4:	89 c7                	mov    %eax,%edi
  802af6:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
			return write_size;
  802b02:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b05:	e9 a1 00 00 00       	jmpq   802bab <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b0a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b14:	ba 00 02 00 00       	mov    $0x200,%edx
  802b19:	48 89 ce             	mov    %rcx,%rsi
  802b1c:	89 c7                	mov    %eax,%edi
  802b1e:	48 b8 7c 20 80 00 00 	movabs $0x80207c,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b31:	0f 8f 5f ff ff ff    	jg     802a96 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b3b:	79 47                	jns    802b84 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b3d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b40:	89 c6                	mov    %eax,%esi
  802b42:	48 bf 98 3e 80 00 00 	movabs $0x803e98,%rdi
  802b49:	00 00 00 
  802b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b51:	48 ba b6 02 80 00 00 	movabs $0x8002b6,%rdx
  802b58:	00 00 00 
  802b5b:	ff d2                	callq  *%rdx
		close(fd_src);
  802b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b60:	89 c7                	mov    %eax,%edi
  802b62:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	callq  *%rax
		close(fd_dest);
  802b6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b71:	89 c7                	mov    %eax,%edi
  802b73:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802b7a:	00 00 00 
  802b7d:	ff d0                	callq  *%rax
		return read_size;
  802b7f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b82:	eb 27                	jmp    802bab <copy+0x1d9>
	}
	close(fd_src);
  802b84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b87:	89 c7                	mov    %eax,%edi
  802b89:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
	close(fd_dest);
  802b95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b98:	89 c7                	mov    %eax,%edi
  802b9a:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802ba1:	00 00 00 
  802ba4:	ff d0                	callq  *%rax
	return 0;
  802ba6:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802bab:	c9                   	leaveq 
  802bac:	c3                   	retq   

0000000000802bad <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802bad:	55                   	push   %rbp
  802bae:	48 89 e5             	mov    %rsp,%rbp
  802bb1:	53                   	push   %rbx
  802bb2:	48 83 ec 38          	sub    $0x38,%rsp
  802bb6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802bba:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802bbe:	48 89 c7             	mov    %rax,%rdi
  802bc1:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	callq  *%rax
  802bcd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bd4:	0f 88 bf 01 00 00    	js     802d99 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bde:	ba 07 04 00 00       	mov    $0x407,%edx
  802be3:	48 89 c6             	mov    %rax,%rsi
  802be6:	bf 00 00 00 00       	mov    $0x0,%edi
  802beb:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
  802bf7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bfe:	0f 88 95 01 00 00    	js     802d99 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c04:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c08:	48 89 c7             	mov    %rax,%rdi
  802c0b:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c1e:	0f 88 5d 01 00 00    	js     802d81 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c28:	ba 07 04 00 00       	mov    $0x407,%edx
  802c2d:	48 89 c6             	mov    %rax,%rsi
  802c30:	bf 00 00 00 00       	mov    $0x0,%edi
  802c35:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  802c3c:	00 00 00 
  802c3f:	ff d0                	callq  *%rax
  802c41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c48:	0f 88 33 01 00 00    	js     802d81 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c52:	48 89 c7             	mov    %rax,%rdi
  802c55:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802c5c:	00 00 00 
  802c5f:	ff d0                	callq  *%rax
  802c61:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c69:	ba 07 04 00 00       	mov    $0x407,%edx
  802c6e:	48 89 c6             	mov    %rax,%rsi
  802c71:	bf 00 00 00 00       	mov    $0x0,%edi
  802c76:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c89:	79 05                	jns    802c90 <pipe+0xe3>
		goto err2;
  802c8b:	e9 d9 00 00 00       	jmpq   802d69 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c94:	48 89 c7             	mov    %rax,%rdi
  802c97:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	callq  *%rax
  802ca3:	48 89 c2             	mov    %rax,%rdx
  802ca6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802caa:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802cb0:	48 89 d1             	mov    %rdx,%rcx
  802cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb8:	48 89 c6             	mov    %rax,%rsi
  802cbb:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc0:	48 b8 fd 17 80 00 00 	movabs $0x8017fd,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax
  802ccc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ccf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cd3:	79 1b                	jns    802cf0 <pipe+0x143>
		goto err3;
  802cd5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802cd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cda:	48 89 c6             	mov    %rax,%rsi
  802cdd:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce2:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
  802cee:	eb 79                	jmp    802d69 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802cf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cf4:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802cfb:	00 00 00 
  802cfe:	8b 12                	mov    (%rdx),%edx
  802d00:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d11:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d18:	00 00 00 
  802d1b:	8b 12                	mov    (%rdx),%edx
  802d1d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d23:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802d2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d2e:	48 89 c7             	mov    %rax,%rdi
  802d31:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
  802d3d:	89 c2                	mov    %eax,%edx
  802d3f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d43:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d49:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802d4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d51:	48 89 c7             	mov    %rax,%rdi
  802d54:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
  802d60:	89 03                	mov    %eax,(%rbx)
	return 0;
  802d62:	b8 00 00 00 00       	mov    $0x0,%eax
  802d67:	eb 33                	jmp    802d9c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802d69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d6d:	48 89 c6             	mov    %rax,%rsi
  802d70:	bf 00 00 00 00       	mov    $0x0,%edi
  802d75:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802d81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d85:	48 89 c6             	mov    %rax,%rsi
  802d88:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8d:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
err:
	return r;
  802d99:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802d9c:	48 83 c4 38          	add    $0x38,%rsp
  802da0:	5b                   	pop    %rbx
  802da1:	5d                   	pop    %rbp
  802da2:	c3                   	retq   

0000000000802da3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802da3:	55                   	push   %rbp
  802da4:	48 89 e5             	mov    %rsp,%rbp
  802da7:	53                   	push   %rbx
  802da8:	48 83 ec 28          	sub    $0x28,%rsp
  802dac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802db0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802db4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802dbb:	00 00 00 
  802dbe:	48 8b 00             	mov    (%rax),%rax
  802dc1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802dc7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802dca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dce:	48 89 c7             	mov    %rax,%rdi
  802dd1:	48 b8 18 37 80 00 00 	movabs $0x803718,%rax
  802dd8:	00 00 00 
  802ddb:	ff d0                	callq  *%rax
  802ddd:	89 c3                	mov    %eax,%ebx
  802ddf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de3:	48 89 c7             	mov    %rax,%rdi
  802de6:	48 b8 18 37 80 00 00 	movabs $0x803718,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
  802df2:	39 c3                	cmp    %eax,%ebx
  802df4:	0f 94 c0             	sete   %al
  802df7:	0f b6 c0             	movzbl %al,%eax
  802dfa:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802dfd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e04:	00 00 00 
  802e07:	48 8b 00             	mov    (%rax),%rax
  802e0a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e10:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e16:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e19:	75 05                	jne    802e20 <_pipeisclosed+0x7d>
			return ret;
  802e1b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e1e:	eb 4f                	jmp    802e6f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802e20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e23:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e26:	74 42                	je     802e6a <_pipeisclosed+0xc7>
  802e28:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802e2c:	75 3c                	jne    802e6a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802e2e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e35:	00 00 00 
  802e38:	48 8b 00             	mov    (%rax),%rax
  802e3b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e41:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e47:	89 c6                	mov    %eax,%esi
  802e49:	48 bf b3 3e 80 00 00 	movabs $0x803eb3,%rdi
  802e50:	00 00 00 
  802e53:	b8 00 00 00 00       	mov    $0x0,%eax
  802e58:	49 b8 b6 02 80 00 00 	movabs $0x8002b6,%r8
  802e5f:	00 00 00 
  802e62:	41 ff d0             	callq  *%r8
	}
  802e65:	e9 4a ff ff ff       	jmpq   802db4 <_pipeisclosed+0x11>
  802e6a:	e9 45 ff ff ff       	jmpq   802db4 <_pipeisclosed+0x11>
}
  802e6f:	48 83 c4 28          	add    $0x28,%rsp
  802e73:	5b                   	pop    %rbx
  802e74:	5d                   	pop    %rbp
  802e75:	c3                   	retq   

0000000000802e76 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802e76:	55                   	push   %rbp
  802e77:	48 89 e5             	mov    %rsp,%rbp
  802e7a:	48 83 ec 30          	sub    $0x30,%rsp
  802e7e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e81:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e85:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e88:	48 89 d6             	mov    %rdx,%rsi
  802e8b:	89 c7                	mov    %eax,%edi
  802e8d:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
  802e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea0:	79 05                	jns    802ea7 <pipeisclosed+0x31>
		return r;
  802ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea5:	eb 31                	jmp    802ed8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ec6:	48 89 d6             	mov    %rdx,%rsi
  802ec9:	48 89 c7             	mov    %rax,%rdi
  802ecc:	48 b8 a3 2d 80 00 00 	movabs $0x802da3,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
}
  802ed8:	c9                   	leaveq 
  802ed9:	c3                   	retq   

0000000000802eda <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802eda:	55                   	push   %rbp
  802edb:	48 89 e5             	mov    %rsp,%rbp
  802ede:	48 83 ec 40          	sub    $0x40,%rsp
  802ee2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ee6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802eee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef2:	48 89 c7             	mov    %rax,%rdi
  802ef5:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802efc:	00 00 00 
  802eff:	ff d0                	callq  *%rax
  802f01:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f0d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f14:	00 
  802f15:	e9 92 00 00 00       	jmpq   802fac <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f1a:	eb 41                	jmp    802f5d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f1c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802f21:	74 09                	je     802f2c <devpipe_read+0x52>
				return i;
  802f23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f27:	e9 92 00 00 00       	jmpq   802fbe <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802f2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f34:	48 89 d6             	mov    %rdx,%rsi
  802f37:	48 89 c7             	mov    %rax,%rdi
  802f3a:	48 b8 a3 2d 80 00 00 	movabs $0x802da3,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 07                	je     802f51 <devpipe_read+0x77>
				return 0;
  802f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4f:	eb 6d                	jmp    802fbe <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f51:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802f58:	00 00 00 
  802f5b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f61:	8b 10                	mov    (%rax),%edx
  802f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f67:	8b 40 04             	mov    0x4(%rax),%eax
  802f6a:	39 c2                	cmp    %eax,%edx
  802f6c:	74 ae                	je     802f1c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f76:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7e:	8b 00                	mov    (%rax),%eax
  802f80:	99                   	cltd   
  802f81:	c1 ea 1b             	shr    $0x1b,%edx
  802f84:	01 d0                	add    %edx,%eax
  802f86:	83 e0 1f             	and    $0x1f,%eax
  802f89:	29 d0                	sub    %edx,%eax
  802f8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f8f:	48 98                	cltq   
  802f91:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802f96:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9c:	8b 00                	mov    (%rax),%eax
  802f9e:	8d 50 01             	lea    0x1(%rax),%edx
  802fa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802fa7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802fac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802fb4:	0f 82 60 ff ff ff    	jb     802f1a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802fbe:	c9                   	leaveq 
  802fbf:	c3                   	retq   

0000000000802fc0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fc0:	55                   	push   %rbp
  802fc1:	48 89 e5             	mov    %rsp,%rbp
  802fc4:	48 83 ec 40          	sub    $0x40,%rsp
  802fc8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fcc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fd0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd8:	48 89 c7             	mov    %rax,%rdi
  802fdb:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802feb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802ff3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ffa:	00 
  802ffb:	e9 8e 00 00 00       	jmpq   80308e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803000:	eb 31                	jmp    803033 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803002:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300a:	48 89 d6             	mov    %rdx,%rsi
  80300d:	48 89 c7             	mov    %rax,%rdi
  803010:	48 b8 a3 2d 80 00 00 	movabs $0x802da3,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	74 07                	je     803027 <devpipe_write+0x67>
				return 0;
  803020:	b8 00 00 00 00       	mov    $0x0,%eax
  803025:	eb 79                	jmp    8030a0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803027:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803037:	8b 40 04             	mov    0x4(%rax),%eax
  80303a:	48 63 d0             	movslq %eax,%rdx
  80303d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803041:	8b 00                	mov    (%rax),%eax
  803043:	48 98                	cltq   
  803045:	48 83 c0 20          	add    $0x20,%rax
  803049:	48 39 c2             	cmp    %rax,%rdx
  80304c:	73 b4                	jae    803002 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80304e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803052:	8b 40 04             	mov    0x4(%rax),%eax
  803055:	99                   	cltd   
  803056:	c1 ea 1b             	shr    $0x1b,%edx
  803059:	01 d0                	add    %edx,%eax
  80305b:	83 e0 1f             	and    $0x1f,%eax
  80305e:	29 d0                	sub    %edx,%eax
  803060:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803064:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803068:	48 01 ca             	add    %rcx,%rdx
  80306b:	0f b6 0a             	movzbl (%rdx),%ecx
  80306e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803072:	48 98                	cltq   
  803074:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803078:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307c:	8b 40 04             	mov    0x4(%rax),%eax
  80307f:	8d 50 01             	lea    0x1(%rax),%edx
  803082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803086:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803089:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80308e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803092:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803096:	0f 82 64 ff ff ff    	jb     803000 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80309c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
  8030a6:	48 83 ec 20          	sub    $0x20,%rsp
  8030aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8030b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b6:	48 89 c7             	mov    %rax,%rdi
  8030b9:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
  8030c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8030c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030cd:	48 be c6 3e 80 00 00 	movabs $0x803ec6,%rsi
  8030d4:	00 00 00 
  8030d7:	48 89 c7             	mov    %rax,%rdi
  8030da:	48 b8 7e 0e 80 00 00 	movabs $0x800e7e,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8030e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ea:	8b 50 04             	mov    0x4(%rax),%edx
  8030ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f1:	8b 00                	mov    (%rax),%eax
  8030f3:	29 c2                	sub    %eax,%edx
  8030f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8030ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803103:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80310a:	00 00 00 
	stat->st_dev = &devpipe;
  80310d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803111:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803118:	00 00 00 
  80311b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803122:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803127:	c9                   	leaveq 
  803128:	c3                   	retq   

0000000000803129 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803129:	55                   	push   %rbp
  80312a:	48 89 e5             	mov    %rsp,%rbp
  80312d:	48 83 ec 10          	sub    $0x10,%rsp
  803131:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803139:	48 89 c6             	mov    %rax,%rsi
  80313c:	bf 00 00 00 00       	mov    $0x0,%edi
  803141:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80314d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803151:	48 89 c7             	mov    %rax,%rdi
  803154:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
  803160:	48 89 c6             	mov    %rax,%rsi
  803163:	bf 00 00 00 00       	mov    $0x0,%edi
  803168:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
}
  803174:	c9                   	leaveq 
  803175:	c3                   	retq   

0000000000803176 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803176:	55                   	push   %rbp
  803177:	48 89 e5             	mov    %rsp,%rbp
  80317a:	48 83 ec 20          	sub    $0x20,%rsp
  80317e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803181:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803184:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803187:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80318b:	be 01 00 00 00       	mov    $0x1,%esi
  803190:	48 89 c7             	mov    %rax,%rdi
  803193:	48 b8 65 16 80 00 00 	movabs $0x801665,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <getchar>:

int
getchar(void)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8031a9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8031ad:	ba 01 00 00 00       	mov    $0x1,%edx
  8031b2:	48 89 c6             	mov    %rax,%rsi
  8031b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ba:	48 b8 7c 20 80 00 00 	movabs $0x80207c,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
  8031c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8031c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cd:	79 05                	jns    8031d4 <getchar+0x33>
		return r;
  8031cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d2:	eb 14                	jmp    8031e8 <getchar+0x47>
	if (r < 1)
  8031d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d8:	7f 07                	jg     8031e1 <getchar+0x40>
		return -E_EOF;
  8031da:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8031df:	eb 07                	jmp    8031e8 <getchar+0x47>
	return c;
  8031e1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8031e5:	0f b6 c0             	movzbl %al,%eax
}
  8031e8:	c9                   	leaveq 
  8031e9:	c3                   	retq   

00000000008031ea <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8031ea:	55                   	push   %rbp
  8031eb:	48 89 e5             	mov    %rsp,%rbp
  8031ee:	48 83 ec 20          	sub    $0x20,%rsp
  8031f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031fc:	48 89 d6             	mov    %rdx,%rsi
  8031ff:	89 c7                	mov    %eax,%edi
  803201:	48 b8 4a 1c 80 00 00 	movabs $0x801c4a,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803210:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803214:	79 05                	jns    80321b <iscons+0x31>
		return r;
  803216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803219:	eb 1a                	jmp    803235 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80321b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321f:	8b 10                	mov    (%rax),%edx
  803221:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803228:	00 00 00 
  80322b:	8b 00                	mov    (%rax),%eax
  80322d:	39 c2                	cmp    %eax,%edx
  80322f:	0f 94 c0             	sete   %al
  803232:	0f b6 c0             	movzbl %al,%eax
}
  803235:	c9                   	leaveq 
  803236:	c3                   	retq   

0000000000803237 <opencons>:

int
opencons(void)
{
  803237:	55                   	push   %rbp
  803238:	48 89 e5             	mov    %rsp,%rbp
  80323b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80323f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803243:	48 89 c7             	mov    %rax,%rdi
  803246:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
  803252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803259:	79 05                	jns    803260 <opencons+0x29>
		return r;
  80325b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325e:	eb 5b                	jmp    8032bb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803264:	ba 07 04 00 00       	mov    $0x407,%edx
  803269:	48 89 c6             	mov    %rax,%rsi
  80326c:	bf 00 00 00 00       	mov    $0x0,%edi
  803271:	48 b8 ad 17 80 00 00 	movabs $0x8017ad,%rax
  803278:	00 00 00 
  80327b:	ff d0                	callq  *%rax
  80327d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803280:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803284:	79 05                	jns    80328b <opencons+0x54>
		return r;
  803286:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803289:	eb 30                	jmp    8032bb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80328b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328f:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803296:	00 00 00 
  803299:	8b 12                	mov    (%rdx),%edx
  80329b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80329d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8032a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ac:	48 89 c7             	mov    %rax,%rdi
  8032af:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  8032b6:	00 00 00 
  8032b9:	ff d0                	callq  *%rax
}
  8032bb:	c9                   	leaveq 
  8032bc:	c3                   	retq   

00000000008032bd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8032bd:	55                   	push   %rbp
  8032be:	48 89 e5             	mov    %rsp,%rbp
  8032c1:	48 83 ec 30          	sub    $0x30,%rsp
  8032c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8032d1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032d6:	75 07                	jne    8032df <devcons_read+0x22>
		return 0;
  8032d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032dd:	eb 4b                	jmp    80332a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8032df:	eb 0c                	jmp    8032ed <devcons_read+0x30>
		sys_yield();
  8032e1:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8032ed:	48 b8 af 16 80 00 00 	movabs $0x8016af,%rax
  8032f4:	00 00 00 
  8032f7:	ff d0                	callq  *%rax
  8032f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803300:	74 df                	je     8032e1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803302:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803306:	79 05                	jns    80330d <devcons_read+0x50>
		return c;
  803308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330b:	eb 1d                	jmp    80332a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80330d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803311:	75 07                	jne    80331a <devcons_read+0x5d>
		return 0;
  803313:	b8 00 00 00 00       	mov    $0x0,%eax
  803318:	eb 10                	jmp    80332a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80331a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331d:	89 c2                	mov    %eax,%edx
  80331f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803323:	88 10                	mov    %dl,(%rax)
	return 1;
  803325:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80332a:	c9                   	leaveq 
  80332b:	c3                   	retq   

000000000080332c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80332c:	55                   	push   %rbp
  80332d:	48 89 e5             	mov    %rsp,%rbp
  803330:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803337:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80333e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803345:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80334c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803353:	eb 76                	jmp    8033cb <devcons_write+0x9f>
		m = n - tot;
  803355:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80335c:	89 c2                	mov    %eax,%edx
  80335e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803361:	29 c2                	sub    %eax,%edx
  803363:	89 d0                	mov    %edx,%eax
  803365:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803368:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80336b:	83 f8 7f             	cmp    $0x7f,%eax
  80336e:	76 07                	jbe    803377 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803370:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803377:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80337a:	48 63 d0             	movslq %eax,%rdx
  80337d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803380:	48 63 c8             	movslq %eax,%rcx
  803383:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80338a:	48 01 c1             	add    %rax,%rcx
  80338d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803394:	48 89 ce             	mov    %rcx,%rsi
  803397:	48 89 c7             	mov    %rax,%rdi
  80339a:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  8033a1:	00 00 00 
  8033a4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8033a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033a9:	48 63 d0             	movslq %eax,%rdx
  8033ac:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8033b3:	48 89 d6             	mov    %rdx,%rsi
  8033b6:	48 89 c7             	mov    %rax,%rdi
  8033b9:	48 b8 65 16 80 00 00 	movabs $0x801665,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8033cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ce:	48 98                	cltq   
  8033d0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8033d7:	0f 82 78 ff ff ff    	jb     803355 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8033dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033e0:	c9                   	leaveq 
  8033e1:	c3                   	retq   

00000000008033e2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8033e2:	55                   	push   %rbp
  8033e3:	48 89 e5             	mov    %rsp,%rbp
  8033e6:	48 83 ec 08          	sub    $0x8,%rsp
  8033ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8033ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f3:	c9                   	leaveq 
  8033f4:	c3                   	retq   

00000000008033f5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8033f5:	55                   	push   %rbp
  8033f6:	48 89 e5             	mov    %rsp,%rbp
  8033f9:	48 83 ec 10          	sub    $0x10,%rsp
  8033fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803401:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803409:	48 be d2 3e 80 00 00 	movabs $0x803ed2,%rsi
  803410:	00 00 00 
  803413:	48 89 c7             	mov    %rax,%rdi
  803416:	48 b8 7e 0e 80 00 00 	movabs $0x800e7e,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
	return 0;
  803422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803427:	c9                   	leaveq 
  803428:	c3                   	retq   

0000000000803429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803429:	55                   	push   %rbp
  80342a:	48 89 e5             	mov    %rsp,%rbp
  80342d:	53                   	push   %rbx
  80342e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803435:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80343c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803442:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803449:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803450:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803457:	84 c0                	test   %al,%al
  803459:	74 23                	je     80347e <_panic+0x55>
  80345b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803462:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803466:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80346a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80346e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803472:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803476:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80347a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80347e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803485:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80348c:	00 00 00 
  80348f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803496:	00 00 00 
  803499:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80349d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8034a4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8034ab:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8034b2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8034b9:	00 00 00 
  8034bc:	48 8b 18             	mov    (%rax),%rbx
  8034bf:	48 b8 31 17 80 00 00 	movabs $0x801731,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
  8034cb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8034d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8034d8:	41 89 c8             	mov    %ecx,%r8d
  8034db:	48 89 d1             	mov    %rdx,%rcx
  8034de:	48 89 da             	mov    %rbx,%rdx
  8034e1:	89 c6                	mov    %eax,%esi
  8034e3:	48 bf e0 3e 80 00 00 	movabs $0x803ee0,%rdi
  8034ea:	00 00 00 
  8034ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f2:	49 b9 b6 02 80 00 00 	movabs $0x8002b6,%r9
  8034f9:	00 00 00 
  8034fc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8034ff:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803506:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80350d:	48 89 d6             	mov    %rdx,%rsi
  803510:	48 89 c7             	mov    %rax,%rdi
  803513:	48 b8 0a 02 80 00 00 	movabs $0x80020a,%rax
  80351a:	00 00 00 
  80351d:	ff d0                	callq  *%rax
	cprintf("\n");
  80351f:	48 bf 03 3f 80 00 00 	movabs $0x803f03,%rdi
  803526:	00 00 00 
  803529:	b8 00 00 00 00       	mov    $0x0,%eax
  80352e:	48 ba b6 02 80 00 00 	movabs $0x8002b6,%rdx
  803535:	00 00 00 
  803538:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80353a:	cc                   	int3   
  80353b:	eb fd                	jmp    80353a <_panic+0x111>

000000000080353d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80353d:	55                   	push   %rbp
  80353e:	48 89 e5             	mov    %rsp,%rbp
  803541:	48 83 ec 30          	sub    $0x30,%rsp
  803545:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803549:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80354d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803551:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803556:	75 0e                	jne    803566 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803558:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80355f:	00 00 00 
  803562:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356a:	48 89 c7             	mov    %rax,%rdi
  80356d:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803574:	00 00 00 
  803577:	ff d0                	callq  *%rax
  803579:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80357c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803580:	79 27                	jns    8035a9 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803582:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803587:	74 0a                	je     803593 <ipc_recv+0x56>
            *from_env_store = 0;
  803589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803593:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803598:	74 0a                	je     8035a4 <ipc_recv+0x67>
            *perm_store = 0;
  80359a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8035a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a7:	eb 53                	jmp    8035fc <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8035a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035ae:	74 19                	je     8035c9 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8035b0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035b7:	00 00 00 
  8035ba:	48 8b 00             	mov    (%rax),%rax
  8035bd:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8035c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c7:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8035c9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035ce:	74 19                	je     8035e9 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8035d0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035d7:	00 00 00 
  8035da:	48 8b 00             	mov    (%rax),%rax
  8035dd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8035e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e7:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8035e9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8035f0:	00 00 00 
  8035f3:	48 8b 00             	mov    (%rax),%rax
  8035f6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8035fc:	c9                   	leaveq 
  8035fd:	c3                   	retq   

00000000008035fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8035fe:	55                   	push   %rbp
  8035ff:	48 89 e5             	mov    %rsp,%rbp
  803602:	48 83 ec 30          	sub    $0x30,%rsp
  803606:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803609:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80360c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803610:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803613:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803618:	75 0e                	jne    803628 <ipc_send+0x2a>
        pg = (void *)UTOP;
  80361a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803621:	00 00 00 
  803624:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803628:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80362b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80362e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803632:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803635:	89 c7                	mov    %eax,%edi
  803637:	48 b8 81 19 80 00 00 	movabs $0x801981,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
  803643:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803646:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364a:	79 36                	jns    803682 <ipc_send+0x84>
  80364c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803650:	74 30                	je     803682 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803655:	89 c1                	mov    %eax,%ecx
  803657:	48 ba 05 3f 80 00 00 	movabs $0x803f05,%rdx
  80365e:	00 00 00 
  803661:	be 49 00 00 00       	mov    $0x49,%esi
  803666:	48 bf 12 3f 80 00 00 	movabs $0x803f12,%rdi
  80366d:	00 00 00 
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
  803675:	49 b8 29 34 80 00 00 	movabs $0x803429,%r8
  80367c:	00 00 00 
  80367f:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803682:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
    } while(r != 0);
  80368e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803692:	75 94                	jne    803628 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 14          	sub    $0x14,%rsp
  80369e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8036a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036a8:	eb 5e                	jmp    803708 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8036aa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8036b1:	00 00 00 
  8036b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b7:	48 63 d0             	movslq %eax,%rdx
  8036ba:	48 89 d0             	mov    %rdx,%rax
  8036bd:	48 c1 e0 03          	shl    $0x3,%rax
  8036c1:	48 01 d0             	add    %rdx,%rax
  8036c4:	48 c1 e0 05          	shl    $0x5,%rax
  8036c8:	48 01 c8             	add    %rcx,%rax
  8036cb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8036d1:	8b 00                	mov    (%rax),%eax
  8036d3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8036d6:	75 2c                	jne    803704 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8036d8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8036df:	00 00 00 
  8036e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e5:	48 63 d0             	movslq %eax,%rdx
  8036e8:	48 89 d0             	mov    %rdx,%rax
  8036eb:	48 c1 e0 03          	shl    $0x3,%rax
  8036ef:	48 01 d0             	add    %rdx,%rax
  8036f2:	48 c1 e0 05          	shl    $0x5,%rax
  8036f6:	48 01 c8             	add    %rcx,%rax
  8036f9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8036ff:	8b 40 08             	mov    0x8(%rax),%eax
  803702:	eb 12                	jmp    803716 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803704:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803708:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80370f:	7e 99                	jle    8036aa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803716:	c9                   	leaveq 
  803717:	c3                   	retq   

0000000000803718 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803718:	55                   	push   %rbp
  803719:	48 89 e5             	mov    %rsp,%rbp
  80371c:	48 83 ec 18          	sub    $0x18,%rsp
  803720:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803728:	48 c1 e8 15          	shr    $0x15,%rax
  80372c:	48 89 c2             	mov    %rax,%rdx
  80372f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803736:	01 00 00 
  803739:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80373d:	83 e0 01             	and    $0x1,%eax
  803740:	48 85 c0             	test   %rax,%rax
  803743:	75 07                	jne    80374c <pageref+0x34>
		return 0;
  803745:	b8 00 00 00 00       	mov    $0x0,%eax
  80374a:	eb 53                	jmp    80379f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80374c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803750:	48 c1 e8 0c          	shr    $0xc,%rax
  803754:	48 89 c2             	mov    %rax,%rdx
  803757:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80375e:	01 00 00 
  803761:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376d:	83 e0 01             	and    $0x1,%eax
  803770:	48 85 c0             	test   %rax,%rax
  803773:	75 07                	jne    80377c <pageref+0x64>
		return 0;
  803775:	b8 00 00 00 00       	mov    $0x0,%eax
  80377a:	eb 23                	jmp    80379f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80377c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803780:	48 c1 e8 0c          	shr    $0xc,%rax
  803784:	48 89 c2             	mov    %rax,%rdx
  803787:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80378e:	00 00 00 
  803791:	48 c1 e2 04          	shl    $0x4,%rdx
  803795:	48 01 d0             	add    %rdx,%rax
  803798:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80379c:	0f b7 c0             	movzwl %ax,%eax
}
  80379f:	c9                   	leaveq 
  8037a0:	c3                   	retq   
