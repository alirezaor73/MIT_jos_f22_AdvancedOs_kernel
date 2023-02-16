
obj/user/spin:     file format elf64-x86-64


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
  80003c:	e8 07 01 00 00       	callq  800148 <libmain>
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
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800052:	48 bf 20 3e 80 00 00 	movabs $0x803e20,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf 48 3e 80 00 00 	movabs $0x803e48,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf 68 3e 80 00 00 	movabs $0x803e68,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf 90 3e 80 00 00 	movabs $0x803e90,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 20          	sub    $0x20,%rsp
  800150:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800157:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800169:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016e:	48 63 d0             	movslq %eax,%rdx
  800171:	48 89 d0             	mov    %rdx,%rax
  800174:	48 c1 e0 03          	shl    $0x3,%rax
  800178:	48 01 d0             	add    %rdx,%rax
  80017b:	48 c1 e0 05          	shl    $0x5,%rax
  80017f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800186:	00 00 00 
  800189:	48 01 c2             	add    %rax,%rdx
  80018c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800193:	00 00 00 
  800196:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800199:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80019d:	7e 14                	jle    8001b3 <libmain+0x6b>
		binaryname = argv[0];
  80019f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001a3:	48 8b 10             	mov    (%rax),%rdx
  8001a6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ad:	00 00 00 
  8001b0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ba:	48 89 d6             	mov    %rdx,%rsi
  8001bd:	89 c7                	mov    %eax,%edi
  8001bf:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c6:	00 00 00 
  8001c9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001cb:	48 b8 d9 01 80 00 00 	movabs $0x8001d9,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
}
  8001d7:	c9                   	leaveq 
  8001d8:	c3                   	retq   

00000000008001d9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d9:	55                   	push   %rbp
  8001da:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001dd:	48 b8 d0 23 80 00 00 	movabs $0x8023d0,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ee:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8001f5:	00 00 00 
  8001f8:	ff d0                	callq  *%rax
}
  8001fa:	5d                   	pop    %rbp
  8001fb:	c3                   	retq   

00000000008001fc <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
  800200:	48 83 ec 10          	sub    $0x10,%rsp
  800204:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800207:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80020b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020f:	8b 00                	mov    (%rax),%eax
  800211:	8d 48 01             	lea    0x1(%rax),%ecx
  800214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800218:	89 0a                	mov    %ecx,(%rdx)
  80021a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800223:	48 98                	cltq   
  800225:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022d:	8b 00                	mov    (%rax),%eax
  80022f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800234:	75 2c                	jne    800262 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023a:	8b 00                	mov    (%rax),%eax
  80023c:	48 98                	cltq   
  80023e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800242:	48 83 c2 08          	add    $0x8,%rdx
  800246:	48 89 c6             	mov    %rax,%rsi
  800249:	48 89 d7             	mov    %rdx,%rdi
  80024c:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
        b->idx = 0;
  800258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800266:	8b 40 04             	mov    0x4(%rax),%eax
  800269:	8d 50 01             	lea    0x1(%rax),%edx
  80026c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800270:	89 50 04             	mov    %edx,0x4(%rax)
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
  800279:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800280:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800287:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80028e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800295:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80029c:	48 8b 0a             	mov    (%rdx),%rcx
  80029f:	48 89 08             	mov    %rcx,(%rax)
  8002a2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002aa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ae:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002b2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b9:	00 00 00 
    b.cnt = 0;
  8002bc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002c6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002cd:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002d4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002db:	48 89 c6             	mov    %rax,%rsi
  8002de:	48 bf fc 01 80 00 00 	movabs $0x8001fc,%rdi
  8002e5:	00 00 00 
  8002e8:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  8002ef:	00 00 00 
  8002f2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002f4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002fa:	48 98                	cltq   
  8002fc:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800303:	48 83 c2 08          	add    $0x8,%rdx
  800307:	48 89 c6             	mov    %rax,%rsi
  80030a:	48 89 d7             	mov    %rdx,%rdi
  80030d:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  800314:	00 00 00 
  800317:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800319:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80032c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800333:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80033a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800341:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800348:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80034f:	84 c0                	test   %al,%al
  800351:	74 20                	je     800373 <cprintf+0x52>
  800353:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800357:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80035b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80035f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800363:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800367:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80036b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80036f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800373:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80037a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800381:	00 00 00 
  800384:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80038b:	00 00 00 
  80038e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800392:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800399:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003a0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003a7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ae:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003b5:	48 8b 0a             	mov    (%rdx),%rcx
  8003b8:	48 89 08             	mov    %rcx,(%rax)
  8003bb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003bf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003cb:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d9:	48 89 d6             	mov    %rdx,%rsi
  8003dc:	48 89 c7             	mov    %rax,%rdi
  8003df:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
  8003eb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003f1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f7:	c9                   	leaveq 
  8003f8:	c3                   	retq   

00000000008003f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f9:	55                   	push   %rbp
  8003fa:	48 89 e5             	mov    %rsp,%rbp
  8003fd:	53                   	push   %rbx
  8003fe:	48 83 ec 38          	sub    $0x38,%rsp
  800402:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800406:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80040a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80040e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800411:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800415:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800419:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80041c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800420:	77 3b                	ja     80045d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800422:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800425:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800429:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800430:	ba 00 00 00 00       	mov    $0x0,%edx
  800435:	48 f7 f3             	div    %rbx
  800438:	48 89 c2             	mov    %rax,%rdx
  80043b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80043e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800441:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800445:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800449:	41 89 f9             	mov    %edi,%r9d
  80044c:	48 89 c7             	mov    %rax,%rdi
  80044f:	48 b8 f9 03 80 00 00 	movabs $0x8003f9,%rax
  800456:	00 00 00 
  800459:	ff d0                	callq  *%rax
  80045b:	eb 1e                	jmp    80047b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045d:	eb 12                	jmp    800471 <printnum+0x78>
			putch(padc, putdat);
  80045f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800463:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046a:	48 89 ce             	mov    %rcx,%rsi
  80046d:	89 d7                	mov    %edx,%edi
  80046f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800471:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800475:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800479:	7f e4                	jg     80045f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80047e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800482:	ba 00 00 00 00       	mov    $0x0,%edx
  800487:	48 f7 f1             	div    %rcx
  80048a:	48 89 d0             	mov    %rdx,%rax
  80048d:	48 ba d0 40 80 00 00 	movabs $0x8040d0,%rdx
  800494:	00 00 00 
  800497:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80049b:	0f be d0             	movsbl %al,%edx
  80049e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a6:	48 89 ce             	mov    %rcx,%rsi
  8004a9:	89 d7                	mov    %edx,%edi
  8004ab:	ff d0                	callq  *%rax
}
  8004ad:	48 83 c4 38          	add    $0x38,%rsp
  8004b1:	5b                   	pop    %rbx
  8004b2:	5d                   	pop    %rbp
  8004b3:	c3                   	retq   

00000000008004b4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b4:	55                   	push   %rbp
  8004b5:	48 89 e5             	mov    %rsp,%rbp
  8004b8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004c0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8004c3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c7:	7e 52                	jle    80051b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cd:	8b 00                	mov    (%rax),%eax
  8004cf:	83 f8 30             	cmp    $0x30,%eax
  8004d2:	73 24                	jae    8004f8 <getuint+0x44>
  8004d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e0:	8b 00                	mov    (%rax),%eax
  8004e2:	89 c0                	mov    %eax,%eax
  8004e4:	48 01 d0             	add    %rdx,%rax
  8004e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004eb:	8b 12                	mov    (%rdx),%edx
  8004ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f4:	89 0a                	mov    %ecx,(%rdx)
  8004f6:	eb 17                	jmp    80050f <getuint+0x5b>
  8004f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800500:	48 89 d0             	mov    %rdx,%rax
  800503:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050f:	48 8b 00             	mov    (%rax),%rax
  800512:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800516:	e9 a3 00 00 00       	jmpq   8005be <getuint+0x10a>
	else if (lflag)
  80051b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80051f:	74 4f                	je     800570 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800525:	8b 00                	mov    (%rax),%eax
  800527:	83 f8 30             	cmp    $0x30,%eax
  80052a:	73 24                	jae    800550 <getuint+0x9c>
  80052c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800530:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800538:	8b 00                	mov    (%rax),%eax
  80053a:	89 c0                	mov    %eax,%eax
  80053c:	48 01 d0             	add    %rdx,%rax
  80053f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800543:	8b 12                	mov    (%rdx),%edx
  800545:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800548:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054c:	89 0a                	mov    %ecx,(%rdx)
  80054e:	eb 17                	jmp    800567 <getuint+0xb3>
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800558:	48 89 d0             	mov    %rdx,%rax
  80055b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800563:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800567:	48 8b 00             	mov    (%rax),%rax
  80056a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056e:	eb 4e                	jmp    8005be <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800574:	8b 00                	mov    (%rax),%eax
  800576:	83 f8 30             	cmp    $0x30,%eax
  800579:	73 24                	jae    80059f <getuint+0xeb>
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800587:	8b 00                	mov    (%rax),%eax
  800589:	89 c0                	mov    %eax,%eax
  80058b:	48 01 d0             	add    %rdx,%rax
  80058e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800592:	8b 12                	mov    (%rdx),%edx
  800594:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800597:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059b:	89 0a                	mov    %ecx,(%rdx)
  80059d:	eb 17                	jmp    8005b6 <getuint+0x102>
  80059f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a7:	48 89 d0             	mov    %rdx,%rax
  8005aa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	89 c0                	mov    %eax,%eax
  8005ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c2:	c9                   	leaveq 
  8005c3:	c3                   	retq   

00000000008005c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d7:	7e 52                	jle    80062b <getint+0x67>
		x=va_arg(*ap, long long);
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	8b 00                	mov    (%rax),%eax
  8005df:	83 f8 30             	cmp    $0x30,%eax
  8005e2:	73 24                	jae    800608 <getint+0x44>
  8005e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f0:	8b 00                	mov    (%rax),%eax
  8005f2:	89 c0                	mov    %eax,%eax
  8005f4:	48 01 d0             	add    %rdx,%rax
  8005f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fb:	8b 12                	mov    (%rdx),%edx
  8005fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800600:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800604:	89 0a                	mov    %ecx,(%rdx)
  800606:	eb 17                	jmp    80061f <getint+0x5b>
  800608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800610:	48 89 d0             	mov    %rdx,%rax
  800613:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061f:	48 8b 00             	mov    (%rax),%rax
  800622:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800626:	e9 a3 00 00 00       	jmpq   8006ce <getint+0x10a>
	else if (lflag)
  80062b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062f:	74 4f                	je     800680 <getint+0xbc>
		x=va_arg(*ap, long);
  800631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	83 f8 30             	cmp    $0x30,%eax
  80063a:	73 24                	jae    800660 <getint+0x9c>
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	8b 00                	mov    (%rax),%eax
  80064a:	89 c0                	mov    %eax,%eax
  80064c:	48 01 d0             	add    %rdx,%rax
  80064f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800653:	8b 12                	mov    (%rdx),%edx
  800655:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800658:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065c:	89 0a                	mov    %ecx,(%rdx)
  80065e:	eb 17                	jmp    800677 <getint+0xb3>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800668:	48 89 d0             	mov    %rdx,%rax
  80066b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800673:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800677:	48 8b 00             	mov    (%rax),%rax
  80067a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067e:	eb 4e                	jmp    8006ce <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800684:	8b 00                	mov    (%rax),%eax
  800686:	83 f8 30             	cmp    $0x30,%eax
  800689:	73 24                	jae    8006af <getint+0xeb>
  80068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	8b 00                	mov    (%rax),%eax
  800699:	89 c0                	mov    %eax,%eax
  80069b:	48 01 d0             	add    %rdx,%rax
  80069e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a2:	8b 12                	mov    (%rdx),%edx
  8006a4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	89 0a                	mov    %ecx,(%rdx)
  8006ad:	eb 17                	jmp    8006c6 <getint+0x102>
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b7:	48 89 d0             	mov    %rdx,%rax
  8006ba:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	48 98                	cltq   
  8006ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d2:	c9                   	leaveq 
  8006d3:	c3                   	retq   

00000000008006d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d4:	55                   	push   %rbp
  8006d5:	48 89 e5             	mov    %rsp,%rbp
  8006d8:	41 54                	push   %r12
  8006da:	53                   	push   %rbx
  8006db:	48 83 ec 60          	sub    $0x60,%rsp
  8006df:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006eb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f7:	48 8b 0a             	mov    (%rdx),%rcx
  8006fa:	48 89 08             	mov    %rcx,(%rax)
  8006fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800701:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800705:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800709:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x52>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 df 04 00 00    	je     800bf6 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800717:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80071b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80071f:	48 89 d6             	mov    %rdx,%rsi
  800722:	89 df                	mov    %ebx,%edi
  800724:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80072a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80072e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800732:	0f b6 00             	movzbl (%rax),%eax
  800735:	0f b6 d8             	movzbl %al,%ebx
  800738:	83 fb 25             	cmp    $0x25,%ebx
  80073b:	75 d2                	jne    80070f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800741:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800748:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80074f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800756:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800761:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800765:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800769:	0f b6 00             	movzbl (%rax),%eax
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 47 04 00 00    	ja     800bc2 <vprintfmt+0x4ee>
  80077b:	89 c0                	mov    %eax,%eax
  80077d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800784:	00 
  800785:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  80078c:	00 00 00 
  80078f:	48 01 d0             	add    %rdx,%rax
  800792:	48 8b 00             	mov    (%rax),%rax
  800795:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800797:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80079b:	eb c0                	jmp    80075d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a1:	eb ba                	jmp    80075d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007aa:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007ad:	89 d0                	mov    %edx,%eax
  8007af:	c1 e0 02             	shl    $0x2,%eax
  8007b2:	01 d0                	add    %edx,%eax
  8007b4:	01 c0                	add    %eax,%eax
  8007b6:	01 d8                	add    %ebx,%eax
  8007b8:	83 e8 30             	sub    $0x30,%eax
  8007bb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007be:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c2:	0f b6 00             	movzbl (%rax),%eax
  8007c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007cb:	7e 0c                	jle    8007d9 <vprintfmt+0x105>
  8007cd:	83 fb 39             	cmp    $0x39,%ebx
  8007d0:	7f 07                	jg     8007d9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d7:	eb d1                	jmp    8007aa <vprintfmt+0xd6>
			goto process_precision;
  8007d9:	eb 58                	jmp    800833 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007de:	83 f8 30             	cmp    $0x30,%eax
  8007e1:	73 17                	jae    8007fa <vprintfmt+0x126>
  8007e3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ea:	89 c0                	mov    %eax,%eax
  8007ec:	48 01 d0             	add    %rdx,%rax
  8007ef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f2:	83 c2 08             	add    $0x8,%edx
  8007f5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f8:	eb 0f                	jmp    800809 <vprintfmt+0x135>
  8007fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fe:	48 89 d0             	mov    %rdx,%rax
  800801:	48 83 c2 08          	add    $0x8,%rdx
  800805:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800809:	8b 00                	mov    (%rax),%eax
  80080b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80080e:	eb 23                	jmp    800833 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800810:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800814:	79 0c                	jns    800822 <vprintfmt+0x14e>
				width = 0;
  800816:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80081d:	e9 3b ff ff ff       	jmpq   80075d <vprintfmt+0x89>
  800822:	e9 36 ff ff ff       	jmpq   80075d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800827:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80082e:	e9 2a ff ff ff       	jmpq   80075d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800833:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800837:	79 12                	jns    80084b <vprintfmt+0x177>
				width = precision, precision = -1;
  800839:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80083f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800846:	e9 12 ff ff ff       	jmpq   80075d <vprintfmt+0x89>
  80084b:	e9 0d ff ff ff       	jmpq   80075d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800850:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800854:	e9 04 ff ff ff       	jmpq   80075d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800859:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085c:	83 f8 30             	cmp    $0x30,%eax
  80085f:	73 17                	jae    800878 <vprintfmt+0x1a4>
  800861:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800865:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800868:	89 c0                	mov    %eax,%eax
  80086a:	48 01 d0             	add    %rdx,%rax
  80086d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800870:	83 c2 08             	add    $0x8,%edx
  800873:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800876:	eb 0f                	jmp    800887 <vprintfmt+0x1b3>
  800878:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087c:	48 89 d0             	mov    %rdx,%rax
  80087f:	48 83 c2 08          	add    $0x8,%rdx
  800883:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800887:	8b 10                	mov    (%rax),%edx
  800889:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80088d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800891:	48 89 ce             	mov    %rcx,%rsi
  800894:	89 d7                	mov    %edx,%edi
  800896:	ff d0                	callq  *%rax
			break;
  800898:	e9 53 03 00 00       	jmpq   800bf0 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80089d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a0:	83 f8 30             	cmp    $0x30,%eax
  8008a3:	73 17                	jae    8008bc <vprintfmt+0x1e8>
  8008a5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ac:	89 c0                	mov    %eax,%eax
  8008ae:	48 01 d0             	add    %rdx,%rax
  8008b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b4:	83 c2 08             	add    $0x8,%edx
  8008b7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ba:	eb 0f                	jmp    8008cb <vprintfmt+0x1f7>
  8008bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c0:	48 89 d0             	mov    %rdx,%rax
  8008c3:	48 83 c2 08          	add    $0x8,%rdx
  8008c7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008cb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008cd:	85 db                	test   %ebx,%ebx
  8008cf:	79 02                	jns    8008d3 <vprintfmt+0x1ff>
				err = -err;
  8008d1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d3:	83 fb 15             	cmp    $0x15,%ebx
  8008d6:	7f 16                	jg     8008ee <vprintfmt+0x21a>
  8008d8:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8008df:	00 00 00 
  8008e2:	48 63 d3             	movslq %ebx,%rdx
  8008e5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e9:	4d 85 e4             	test   %r12,%r12
  8008ec:	75 2e                	jne    80091c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ee:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f6:	89 d9                	mov    %ebx,%ecx
  8008f8:	48 ba e1 40 80 00 00 	movabs $0x8040e1,%rdx
  8008ff:	00 00 00 
  800902:	48 89 c7             	mov    %rax,%rdi
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	49 b8 ff 0b 80 00 00 	movabs $0x800bff,%r8
  800911:	00 00 00 
  800914:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800917:	e9 d4 02 00 00       	jmpq   800bf0 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800920:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800924:	4c 89 e1             	mov    %r12,%rcx
  800927:	48 ba ea 40 80 00 00 	movabs $0x8040ea,%rdx
  80092e:	00 00 00 
  800931:	48 89 c7             	mov    %rax,%rdi
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	49 b8 ff 0b 80 00 00 	movabs $0x800bff,%r8
  800940:	00 00 00 
  800943:	41 ff d0             	callq  *%r8
			break;
  800946:	e9 a5 02 00 00       	jmpq   800bf0 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80094b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094e:	83 f8 30             	cmp    $0x30,%eax
  800951:	73 17                	jae    80096a <vprintfmt+0x296>
  800953:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800957:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095a:	89 c0                	mov    %eax,%eax
  80095c:	48 01 d0             	add    %rdx,%rax
  80095f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800962:	83 c2 08             	add    $0x8,%edx
  800965:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800968:	eb 0f                	jmp    800979 <vprintfmt+0x2a5>
  80096a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096e:	48 89 d0             	mov    %rdx,%rax
  800971:	48 83 c2 08          	add    $0x8,%rdx
  800975:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800979:	4c 8b 20             	mov    (%rax),%r12
  80097c:	4d 85 e4             	test   %r12,%r12
  80097f:	75 0a                	jne    80098b <vprintfmt+0x2b7>
				p = "(null)";
  800981:	49 bc ed 40 80 00 00 	movabs $0x8040ed,%r12
  800988:	00 00 00 
			if (width > 0 && padc != '-')
  80098b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098f:	7e 3f                	jle    8009d0 <vprintfmt+0x2fc>
  800991:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800995:	74 39                	je     8009d0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800997:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80099a:	48 98                	cltq   
  80099c:	48 89 c6             	mov    %rax,%rsi
  80099f:	4c 89 e7             	mov    %r12,%rdi
  8009a2:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  8009a9:	00 00 00 
  8009ac:	ff d0                	callq  *%rax
  8009ae:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009b1:	eb 17                	jmp    8009ca <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009b3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bf:	48 89 ce             	mov    %rcx,%rsi
  8009c2:	89 d7                	mov    %edx,%edi
  8009c4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ce:	7f e3                	jg     8009b3 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d0:	eb 37                	jmp    800a09 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009d6:	74 1e                	je     8009f6 <vprintfmt+0x322>
  8009d8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009db:	7e 05                	jle    8009e2 <vprintfmt+0x30e>
  8009dd:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e0:	7e 14                	jle    8009f6 <vprintfmt+0x322>
					putch('?', putdat);
  8009e2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ea:	48 89 d6             	mov    %rdx,%rsi
  8009ed:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f2:	ff d0                	callq  *%rax
  8009f4:	eb 0f                	jmp    800a05 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fe:	48 89 d6             	mov    %rdx,%rsi
  800a01:	89 df                	mov    %ebx,%edi
  800a03:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a05:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a09:	4c 89 e0             	mov    %r12,%rax
  800a0c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be d8             	movsbl %al,%ebx
  800a16:	85 db                	test   %ebx,%ebx
  800a18:	74 10                	je     800a2a <vprintfmt+0x356>
  800a1a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1e:	78 b2                	js     8009d2 <vprintfmt+0x2fe>
  800a20:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a24:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a28:	79 a8                	jns    8009d2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2a:	eb 16                	jmp    800a42 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a34:	48 89 d6             	mov    %rdx,%rsi
  800a37:	bf 20 00 00 00       	mov    $0x20,%edi
  800a3c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a46:	7f e4                	jg     800a2c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a48:	e9 a3 01 00 00       	jmpq   800bf0 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a4d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a51:	be 03 00 00 00       	mov    $0x3,%esi
  800a56:	48 89 c7             	mov    %rax,%rdi
  800a59:	48 b8 c4 05 80 00 00 	movabs $0x8005c4,%rax
  800a60:	00 00 00 
  800a63:	ff d0                	callq  *%rax
  800a65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6d:	48 85 c0             	test   %rax,%rax
  800a70:	79 1d                	jns    800a8f <vprintfmt+0x3bb>
				putch('-', putdat);
  800a72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7a:	48 89 d6             	mov    %rdx,%rsi
  800a7d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a82:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a88:	48 f7 d8             	neg    %rax
  800a8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a8f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a96:	e9 e8 00 00 00       	jmpq   800b83 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a9b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9f:	be 03 00 00 00       	mov    $0x3,%esi
  800aa4:	48 89 c7             	mov    %rax,%rdi
  800aa7:	48 b8 b4 04 80 00 00 	movabs $0x8004b4,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	callq  *%rax
  800ab3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800abe:	e9 c0 00 00 00       	jmpq   800b83 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acb:	48 89 d6             	mov    %rdx,%rsi
  800ace:	bf 58 00 00 00       	mov    $0x58,%edi
  800ad3:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ad5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	48 89 d6             	mov    %rdx,%rsi
  800ae0:	bf 58 00 00 00       	mov    $0x58,%edi
  800ae5:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ae7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aeb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aef:	48 89 d6             	mov    %rdx,%rsi
  800af2:	bf 58 00 00 00       	mov    $0x58,%edi
  800af7:	ff d0                	callq  *%rax
			break;
  800af9:	e9 f2 00 00 00       	jmpq   800bf0 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800afe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b06:	48 89 d6             	mov    %rdx,%rsi
  800b09:	bf 30 00 00 00       	mov    $0x30,%edi
  800b0e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b18:	48 89 d6             	mov    %rdx,%rsi
  800b1b:	bf 78 00 00 00       	mov    $0x78,%edi
  800b20:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b25:	83 f8 30             	cmp    $0x30,%eax
  800b28:	73 17                	jae    800b41 <vprintfmt+0x46d>
  800b2a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b31:	89 c0                	mov    %eax,%eax
  800b33:	48 01 d0             	add    %rdx,%rax
  800b36:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b39:	83 c2 08             	add    $0x8,%edx
  800b3c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3f:	eb 0f                	jmp    800b50 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800b41:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b45:	48 89 d0             	mov    %rdx,%rax
  800b48:	48 83 c2 08          	add    $0x8,%rdx
  800b4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b50:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b57:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b5e:	eb 23                	jmp    800b83 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b60:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b64:	be 03 00 00 00       	mov    $0x3,%esi
  800b69:	48 89 c7             	mov    %rax,%rdi
  800b6c:	48 b8 b4 04 80 00 00 	movabs $0x8004b4,%rax
  800b73:	00 00 00 
  800b76:	ff d0                	callq  *%rax
  800b78:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b7c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b83:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b88:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b8b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b92:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9a:	45 89 c1             	mov    %r8d,%r9d
  800b9d:	41 89 f8             	mov    %edi,%r8d
  800ba0:	48 89 c7             	mov    %rax,%rdi
  800ba3:	48 b8 f9 03 80 00 00 	movabs $0x8003f9,%rax
  800baa:	00 00 00 
  800bad:	ff d0                	callq  *%rax
			break;
  800baf:	eb 3f                	jmp    800bf0 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb9:	48 89 d6             	mov    %rdx,%rsi
  800bbc:	89 df                	mov    %ebx,%edi
  800bbe:	ff d0                	callq  *%rax
			break;
  800bc0:	eb 2e                	jmp    800bf0 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	48 89 d6             	mov    %rdx,%rsi
  800bcd:	bf 25 00 00 00       	mov    $0x25,%edi
  800bd2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bd9:	eb 05                	jmp    800be0 <vprintfmt+0x50c>
  800bdb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800be0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be4:	48 83 e8 01          	sub    $0x1,%rax
  800be8:	0f b6 00             	movzbl (%rax),%eax
  800beb:	3c 25                	cmp    $0x25,%al
  800bed:	75 ec                	jne    800bdb <vprintfmt+0x507>
				/* do nothing */;
			break;
  800bef:	90                   	nop
		}
	}
  800bf0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf1:	e9 30 fb ff ff       	jmpq   800726 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bf6:	48 83 c4 60          	add    $0x60,%rsp
  800bfa:	5b                   	pop    %rbx
  800bfb:	41 5c                	pop    %r12
  800bfd:	5d                   	pop    %rbp
  800bfe:	c3                   	retq   

0000000000800bff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bff:	55                   	push   %rbp
  800c00:	48 89 e5             	mov    %rsp,%rbp
  800c03:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c0a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c11:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c18:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c1f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c26:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c2d:	84 c0                	test   %al,%al
  800c2f:	74 20                	je     800c51 <printfmt+0x52>
  800c31:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c35:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c39:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c3d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c41:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c45:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c49:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c4d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c51:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c58:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c5f:	00 00 00 
  800c62:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c69:	00 00 00 
  800c6c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c70:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c77:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c7e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c85:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c8c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c93:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c9a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ca1:	48 89 c7             	mov    %rax,%rdi
  800ca4:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800cab:	00 00 00 
  800cae:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cb0:	c9                   	leaveq 
  800cb1:	c3                   	retq   

0000000000800cb2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb2:	55                   	push   %rbp
  800cb3:	48 89 e5             	mov    %rsp,%rbp
  800cb6:	48 83 ec 10          	sub    $0x10,%rsp
  800cba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc5:	8b 40 10             	mov    0x10(%rax),%eax
  800cc8:	8d 50 01             	lea    0x1(%rax),%edx
  800ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ccf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd6:	48 8b 10             	mov    (%rax),%rdx
  800cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdd:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ce1:	48 39 c2             	cmp    %rax,%rdx
  800ce4:	73 17                	jae    800cfd <sprintputch+0x4b>
		*b->buf++ = ch;
  800ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cea:	48 8b 00             	mov    (%rax),%rax
  800ced:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf5:	48 89 0a             	mov    %rcx,(%rdx)
  800cf8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cfb:	88 10                	mov    %dl,(%rax)
}
  800cfd:	c9                   	leaveq 
  800cfe:	c3                   	retq   

0000000000800cff <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cff:	55                   	push   %rbp
  800d00:	48 89 e5             	mov    %rsp,%rbp
  800d03:	48 83 ec 50          	sub    $0x50,%rsp
  800d07:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d0b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d0e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d12:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d16:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d1a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d1e:	48 8b 0a             	mov    (%rdx),%rcx
  800d21:	48 89 08             	mov    %rcx,(%rax)
  800d24:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d28:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d2c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d30:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d34:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d38:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d3c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d3f:	48 98                	cltq   
  800d41:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d49:	48 01 d0             	add    %rdx,%rax
  800d4c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d50:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d57:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d5c:	74 06                	je     800d64 <vsnprintf+0x65>
  800d5e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d62:	7f 07                	jg     800d6b <vsnprintf+0x6c>
		return -E_INVAL;
  800d64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d69:	eb 2f                	jmp    800d9a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d6b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d6f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d77:	48 89 c6             	mov    %rax,%rsi
  800d7a:	48 bf b2 0c 80 00 00 	movabs $0x800cb2,%rdi
  800d81:	00 00 00 
  800d84:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d94:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d97:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d9a:	c9                   	leaveq 
  800d9b:	c3                   	retq   

0000000000800d9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9c:	55                   	push   %rbp
  800d9d:	48 89 e5             	mov    %rsp,%rbp
  800da0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800da7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800dae:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800db4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dbb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc9:	84 c0                	test   %al,%al
  800dcb:	74 20                	je     800ded <snprintf+0x51>
  800dcd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ddd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ded:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800df4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dfb:	00 00 00 
  800dfe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e05:	00 00 00 
  800e08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e13:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e1a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e21:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e28:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e2f:	48 8b 0a             	mov    (%rdx),%rcx
  800e32:	48 89 08             	mov    %rcx,(%rax)
  800e35:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e39:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e3d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e41:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e45:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e4c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e53:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e59:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e60:	48 89 c7             	mov    %rax,%rdi
  800e63:	48 b8 ff 0c 80 00 00 	movabs $0x800cff,%rax
  800e6a:	00 00 00 
  800e6d:	ff d0                	callq  *%rax
  800e6f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e75:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e7b:	c9                   	leaveq 
  800e7c:	c3                   	retq   

0000000000800e7d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e7d:	55                   	push   %rbp
  800e7e:	48 89 e5             	mov    %rsp,%rbp
  800e81:	48 83 ec 18          	sub    $0x18,%rsp
  800e85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e90:	eb 09                	jmp    800e9b <strlen+0x1e>
		n++;
  800e92:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e96:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9f:	0f b6 00             	movzbl (%rax),%eax
  800ea2:	84 c0                	test   %al,%al
  800ea4:	75 ec                	jne    800e92 <strlen+0x15>
		n++;
	return n;
  800ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea9:	c9                   	leaveq 
  800eaa:	c3                   	retq   

0000000000800eab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eab:	55                   	push   %rbp
  800eac:	48 89 e5             	mov    %rsp,%rbp
  800eaf:	48 83 ec 20          	sub    $0x20,%rsp
  800eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ec2:	eb 0e                	jmp    800ed2 <strnlen+0x27>
		n++;
  800ec4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ecd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ed2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ed7:	74 0b                	je     800ee4 <strnlen+0x39>
  800ed9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edd:	0f b6 00             	movzbl (%rax),%eax
  800ee0:	84 c0                	test   %al,%al
  800ee2:	75 e0                	jne    800ec4 <strnlen+0x19>
		n++;
	return n;
  800ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ee7:	c9                   	leaveq 
  800ee8:	c3                   	retq   

0000000000800ee9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee9:	55                   	push   %rbp
  800eea:	48 89 e5             	mov    %rsp,%rbp
  800eed:	48 83 ec 20          	sub    $0x20,%rsp
  800ef1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f01:	90                   	nop
  800f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f06:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f0e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f12:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f16:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f1a:	0f b6 12             	movzbl (%rdx),%edx
  800f1d:	88 10                	mov    %dl,(%rax)
  800f1f:	0f b6 00             	movzbl (%rax),%eax
  800f22:	84 c0                	test   %al,%al
  800f24:	75 dc                	jne    800f02 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f2a:	c9                   	leaveq 
  800f2b:	c3                   	retq   

0000000000800f2c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f2c:	55                   	push   %rbp
  800f2d:	48 89 e5             	mov    %rsp,%rbp
  800f30:	48 83 ec 20          	sub    $0x20,%rsp
  800f34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f40:	48 89 c7             	mov    %rax,%rdi
  800f43:	48 b8 7d 0e 80 00 00 	movabs $0x800e7d,%rax
  800f4a:	00 00 00 
  800f4d:	ff d0                	callq  *%rax
  800f4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f55:	48 63 d0             	movslq %eax,%rdx
  800f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5c:	48 01 c2             	add    %rax,%rdx
  800f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f63:	48 89 c6             	mov    %rax,%rsi
  800f66:	48 89 d7             	mov    %rdx,%rdi
  800f69:	48 b8 e9 0e 80 00 00 	movabs $0x800ee9,%rax
  800f70:	00 00 00 
  800f73:	ff d0                	callq  *%rax
	return dst;
  800f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f79:	c9                   	leaveq 
  800f7a:	c3                   	retq   

0000000000800f7b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f7b:	55                   	push   %rbp
  800f7c:	48 89 e5             	mov    %rsp,%rbp
  800f7f:	48 83 ec 28          	sub    $0x28,%rsp
  800f83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f8b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f97:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f9e:	00 
  800f9f:	eb 2a                	jmp    800fcb <strncpy+0x50>
		*dst++ = *src;
  800fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb1:	0f b6 12             	movzbl (%rdx),%edx
  800fb4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fba:	0f b6 00             	movzbl (%rax),%eax
  800fbd:	84 c0                	test   %al,%al
  800fbf:	74 05                	je     800fc6 <strncpy+0x4b>
			src++;
  800fc1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fd3:	72 cc                	jb     800fa1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fd9:	c9                   	leaveq 
  800fda:	c3                   	retq   

0000000000800fdb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fdb:	55                   	push   %rbp
  800fdc:	48 89 e5             	mov    %rsp,%rbp
  800fdf:	48 83 ec 28          	sub    $0x28,%rsp
  800fe3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800feb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ff7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ffc:	74 3d                	je     80103b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ffe:	eb 1d                	jmp    80101d <strlcpy+0x42>
			*dst++ = *src++;
  801000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801004:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801008:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80100c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801010:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801014:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801018:	0f b6 12             	movzbl (%rdx),%edx
  80101b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80101d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801022:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801027:	74 0b                	je     801034 <strlcpy+0x59>
  801029:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	84 c0                	test   %al,%al
  801032:	75 cc                	jne    801000 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801038:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80103b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80103f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801043:	48 29 c2             	sub    %rax,%rdx
  801046:	48 89 d0             	mov    %rdx,%rax
}
  801049:	c9                   	leaveq 
  80104a:	c3                   	retq   

000000000080104b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80104b:	55                   	push   %rbp
  80104c:	48 89 e5             	mov    %rsp,%rbp
  80104f:	48 83 ec 10          	sub    $0x10,%rsp
  801053:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801057:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80105b:	eb 0a                	jmp    801067 <strcmp+0x1c>
		p++, q++;
  80105d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801062:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801067:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106b:	0f b6 00             	movzbl (%rax),%eax
  80106e:	84 c0                	test   %al,%al
  801070:	74 12                	je     801084 <strcmp+0x39>
  801072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801076:	0f b6 10             	movzbl (%rax),%edx
  801079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107d:	0f b6 00             	movzbl (%rax),%eax
  801080:	38 c2                	cmp    %al,%dl
  801082:	74 d9                	je     80105d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801088:	0f b6 00             	movzbl (%rax),%eax
  80108b:	0f b6 d0             	movzbl %al,%edx
  80108e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	0f b6 c0             	movzbl %al,%eax
  801098:	29 c2                	sub    %eax,%edx
  80109a:	89 d0                	mov    %edx,%eax
}
  80109c:	c9                   	leaveq 
  80109d:	c3                   	retq   

000000000080109e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80109e:	55                   	push   %rbp
  80109f:	48 89 e5             	mov    %rsp,%rbp
  8010a2:	48 83 ec 18          	sub    $0x18,%rsp
  8010a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010b2:	eb 0f                	jmp    8010c3 <strncmp+0x25>
		n--, p++, q++;
  8010b4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010c3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010c8:	74 1d                	je     8010e7 <strncmp+0x49>
  8010ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ce:	0f b6 00             	movzbl (%rax),%eax
  8010d1:	84 c0                	test   %al,%al
  8010d3:	74 12                	je     8010e7 <strncmp+0x49>
  8010d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d9:	0f b6 10             	movzbl (%rax),%edx
  8010dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e0:	0f b6 00             	movzbl (%rax),%eax
  8010e3:	38 c2                	cmp    %al,%dl
  8010e5:	74 cd                	je     8010b4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ec:	75 07                	jne    8010f5 <strncmp+0x57>
		return 0;
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f3:	eb 18                	jmp    80110d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f9:	0f b6 00             	movzbl (%rax),%eax
  8010fc:	0f b6 d0             	movzbl %al,%edx
  8010ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801103:	0f b6 00             	movzbl (%rax),%eax
  801106:	0f b6 c0             	movzbl %al,%eax
  801109:	29 c2                	sub    %eax,%edx
  80110b:	89 d0                	mov    %edx,%eax
}
  80110d:	c9                   	leaveq 
  80110e:	c3                   	retq   

000000000080110f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80110f:	55                   	push   %rbp
  801110:	48 89 e5             	mov    %rsp,%rbp
  801113:	48 83 ec 0c          	sub    $0xc,%rsp
  801117:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111b:	89 f0                	mov    %esi,%eax
  80111d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801120:	eb 17                	jmp    801139 <strchr+0x2a>
		if (*s == c)
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801126:	0f b6 00             	movzbl (%rax),%eax
  801129:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80112c:	75 06                	jne    801134 <strchr+0x25>
			return (char *) s;
  80112e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801132:	eb 15                	jmp    801149 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801134:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113d:	0f b6 00             	movzbl (%rax),%eax
  801140:	84 c0                	test   %al,%al
  801142:	75 de                	jne    801122 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801149:	c9                   	leaveq 
  80114a:	c3                   	retq   

000000000080114b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	48 83 ec 0c          	sub    $0xc,%rsp
  801153:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801157:	89 f0                	mov    %esi,%eax
  801159:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80115c:	eb 13                	jmp    801171 <strfind+0x26>
		if (*s == c)
  80115e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801162:	0f b6 00             	movzbl (%rax),%eax
  801165:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801168:	75 02                	jne    80116c <strfind+0x21>
			break;
  80116a:	eb 10                	jmp    80117c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80116c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801175:	0f b6 00             	movzbl (%rax),%eax
  801178:	84 c0                	test   %al,%al
  80117a:	75 e2                	jne    80115e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80117c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801180:	c9                   	leaveq 
  801181:	c3                   	retq   

0000000000801182 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801182:	55                   	push   %rbp
  801183:	48 89 e5             	mov    %rsp,%rbp
  801186:	48 83 ec 18          	sub    $0x18,%rsp
  80118a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801191:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801195:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119a:	75 06                	jne    8011a2 <memset+0x20>
		return v;
  80119c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a0:	eb 69                	jmp    80120b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a6:	83 e0 03             	and    $0x3,%eax
  8011a9:	48 85 c0             	test   %rax,%rax
  8011ac:	75 48                	jne    8011f6 <memset+0x74>
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	83 e0 03             	and    $0x3,%eax
  8011b5:	48 85 c0             	test   %rax,%rax
  8011b8:	75 3c                	jne    8011f6 <memset+0x74>
		c &= 0xFF;
  8011ba:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c4:	c1 e0 18             	shl    $0x18,%eax
  8011c7:	89 c2                	mov    %eax,%edx
  8011c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011cc:	c1 e0 10             	shl    $0x10,%eax
  8011cf:	09 c2                	or     %eax,%edx
  8011d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d4:	c1 e0 08             	shl    $0x8,%eax
  8011d7:	09 d0                	or     %edx,%eax
  8011d9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e0:	48 c1 e8 02          	shr    $0x2,%rax
  8011e4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ee:	48 89 d7             	mov    %rdx,%rdi
  8011f1:	fc                   	cld    
  8011f2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011f4:	eb 11                	jmp    801207 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801201:	48 89 d7             	mov    %rdx,%rdi
  801204:	fc                   	cld    
  801205:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120b:	c9                   	leaveq 
  80120c:	c3                   	retq   

000000000080120d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80120d:	55                   	push   %rbp
  80120e:	48 89 e5             	mov    %rsp,%rbp
  801211:	48 83 ec 28          	sub    $0x28,%rsp
  801215:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801219:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801221:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801225:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801231:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801235:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801239:	0f 83 88 00 00 00    	jae    8012c7 <memmove+0xba>
  80123f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801243:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801247:	48 01 d0             	add    %rdx,%rax
  80124a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80124e:	76 77                	jbe    8012c7 <memmove+0xba>
		s += n;
  801250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801254:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801258:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801264:	83 e0 03             	and    $0x3,%eax
  801267:	48 85 c0             	test   %rax,%rax
  80126a:	75 3b                	jne    8012a7 <memmove+0x9a>
  80126c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801270:	83 e0 03             	and    $0x3,%eax
  801273:	48 85 c0             	test   %rax,%rax
  801276:	75 2f                	jne    8012a7 <memmove+0x9a>
  801278:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127c:	83 e0 03             	and    $0x3,%eax
  80127f:	48 85 c0             	test   %rax,%rax
  801282:	75 23                	jne    8012a7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801288:	48 83 e8 04          	sub    $0x4,%rax
  80128c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801290:	48 83 ea 04          	sub    $0x4,%rdx
  801294:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801298:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80129c:	48 89 c7             	mov    %rax,%rdi
  80129f:	48 89 d6             	mov    %rdx,%rsi
  8012a2:	fd                   	std    
  8012a3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012a5:	eb 1d                	jmp    8012c4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bb:	48 89 d7             	mov    %rdx,%rdi
  8012be:	48 89 c1             	mov    %rax,%rcx
  8012c1:	fd                   	std    
  8012c2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012c4:	fc                   	cld    
  8012c5:	eb 57                	jmp    80131e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	83 e0 03             	and    $0x3,%eax
  8012ce:	48 85 c0             	test   %rax,%rax
  8012d1:	75 36                	jne    801309 <memmove+0xfc>
  8012d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d7:	83 e0 03             	and    $0x3,%eax
  8012da:	48 85 c0             	test   %rax,%rax
  8012dd:	75 2a                	jne    801309 <memmove+0xfc>
  8012df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e3:	83 e0 03             	and    $0x3,%eax
  8012e6:	48 85 c0             	test   %rax,%rax
  8012e9:	75 1e                	jne    801309 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ef:	48 c1 e8 02          	shr    $0x2,%rax
  8012f3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012fe:	48 89 c7             	mov    %rax,%rdi
  801301:	48 89 d6             	mov    %rdx,%rsi
  801304:	fc                   	cld    
  801305:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801307:	eb 15                	jmp    80131e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801311:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801315:	48 89 c7             	mov    %rax,%rdi
  801318:	48 89 d6             	mov    %rdx,%rsi
  80131b:	fc                   	cld    
  80131c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80131e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801322:	c9                   	leaveq 
  801323:	c3                   	retq   

0000000000801324 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	48 83 ec 18          	sub    $0x18,%rsp
  80132c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801330:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801334:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801338:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80133c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	48 89 ce             	mov    %rcx,%rsi
  801347:	48 89 c7             	mov    %rax,%rdi
  80134a:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  801351:	00 00 00 
  801354:	ff d0                	callq  *%rax
}
  801356:	c9                   	leaveq 
  801357:	c3                   	retq   

0000000000801358 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801358:	55                   	push   %rbp
  801359:	48 89 e5             	mov    %rsp,%rbp
  80135c:	48 83 ec 28          	sub    $0x28,%rsp
  801360:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801364:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801368:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80136c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801370:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801378:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80137c:	eb 36                	jmp    8013b4 <memcmp+0x5c>
		if (*s1 != *s2)
  80137e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801382:	0f b6 10             	movzbl (%rax),%edx
  801385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 1a                	je     8013aa <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801394:	0f b6 00             	movzbl (%rax),%eax
  801397:	0f b6 d0             	movzbl %al,%edx
  80139a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139e:	0f b6 00             	movzbl (%rax),%eax
  8013a1:	0f b6 c0             	movzbl %al,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	eb 20                	jmp    8013ca <memcmp+0x72>
		s1++, s2++;
  8013aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013af:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013c0:	48 85 c0             	test   %rax,%rax
  8013c3:	75 b9                	jne    80137e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ca:	c9                   	leaveq 
  8013cb:	c3                   	retq   

00000000008013cc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013cc:	55                   	push   %rbp
  8013cd:	48 89 e5             	mov    %rsp,%rbp
  8013d0:	48 83 ec 28          	sub    $0x28,%rsp
  8013d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013e7:	48 01 d0             	add    %rdx,%rax
  8013ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ee:	eb 15                	jmp    801405 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f4:	0f b6 10             	movzbl (%rax),%edx
  8013f7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013fa:	38 c2                	cmp    %al,%dl
  8013fc:	75 02                	jne    801400 <memfind+0x34>
			break;
  8013fe:	eb 0f                	jmp    80140f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801400:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801409:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80140d:	72 e1                	jb     8013f0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801413:	c9                   	leaveq 
  801414:	c3                   	retq   

0000000000801415 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801415:	55                   	push   %rbp
  801416:	48 89 e5             	mov    %rsp,%rbp
  801419:	48 83 ec 34          	sub    $0x34,%rsp
  80141d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801421:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801425:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801428:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80142f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801436:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801437:	eb 05                	jmp    80143e <strtol+0x29>
		s++;
  801439:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	0f b6 00             	movzbl (%rax),%eax
  801445:	3c 20                	cmp    $0x20,%al
  801447:	74 f0                	je     801439 <strtol+0x24>
  801449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	3c 09                	cmp    $0x9,%al
  801452:	74 e5                	je     801439 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	0f b6 00             	movzbl (%rax),%eax
  80145b:	3c 2b                	cmp    $0x2b,%al
  80145d:	75 07                	jne    801466 <strtol+0x51>
		s++;
  80145f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801464:	eb 17                	jmp    80147d <strtol+0x68>
	else if (*s == '-')
  801466:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	3c 2d                	cmp    $0x2d,%al
  80146f:	75 0c                	jne    80147d <strtol+0x68>
		s++, neg = 1;
  801471:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801481:	74 06                	je     801489 <strtol+0x74>
  801483:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801487:	75 28                	jne    8014b1 <strtol+0x9c>
  801489:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148d:	0f b6 00             	movzbl (%rax),%eax
  801490:	3c 30                	cmp    $0x30,%al
  801492:	75 1d                	jne    8014b1 <strtol+0x9c>
  801494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801498:	48 83 c0 01          	add    $0x1,%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	3c 78                	cmp    $0x78,%al
  8014a1:	75 0e                	jne    8014b1 <strtol+0x9c>
		s += 2, base = 16;
  8014a3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014a8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014af:	eb 2c                	jmp    8014dd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b5:	75 19                	jne    8014d0 <strtol+0xbb>
  8014b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	3c 30                	cmp    $0x30,%al
  8014c0:	75 0e                	jne    8014d0 <strtol+0xbb>
		s++, base = 8;
  8014c2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014ce:	eb 0d                	jmp    8014dd <strtol+0xc8>
	else if (base == 0)
  8014d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d4:	75 07                	jne    8014dd <strtol+0xc8>
		base = 10;
  8014d6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	3c 2f                	cmp    $0x2f,%al
  8014e6:	7e 1d                	jle    801505 <strtol+0xf0>
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	3c 39                	cmp    $0x39,%al
  8014f1:	7f 12                	jg     801505 <strtol+0xf0>
			dig = *s - '0';
  8014f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	0f be c0             	movsbl %al,%eax
  8014fd:	83 e8 30             	sub    $0x30,%eax
  801500:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801503:	eb 4e                	jmp    801553 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	3c 60                	cmp    $0x60,%al
  80150e:	7e 1d                	jle    80152d <strtol+0x118>
  801510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801514:	0f b6 00             	movzbl (%rax),%eax
  801517:	3c 7a                	cmp    $0x7a,%al
  801519:	7f 12                	jg     80152d <strtol+0x118>
			dig = *s - 'a' + 10;
  80151b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f be c0             	movsbl %al,%eax
  801525:	83 e8 57             	sub    $0x57,%eax
  801528:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80152b:	eb 26                	jmp    801553 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80152d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	3c 40                	cmp    $0x40,%al
  801536:	7e 48                	jle    801580 <strtol+0x16b>
  801538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153c:	0f b6 00             	movzbl (%rax),%eax
  80153f:	3c 5a                	cmp    $0x5a,%al
  801541:	7f 3d                	jg     801580 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801543:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801547:	0f b6 00             	movzbl (%rax),%eax
  80154a:	0f be c0             	movsbl %al,%eax
  80154d:	83 e8 37             	sub    $0x37,%eax
  801550:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801553:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801556:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801559:	7c 02                	jl     80155d <strtol+0x148>
			break;
  80155b:	eb 23                	jmp    801580 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80155d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801562:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801565:	48 98                	cltq   
  801567:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80156c:	48 89 c2             	mov    %rax,%rdx
  80156f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801572:	48 98                	cltq   
  801574:	48 01 d0             	add    %rdx,%rax
  801577:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80157b:	e9 5d ff ff ff       	jmpq   8014dd <strtol+0xc8>

	if (endptr)
  801580:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801585:	74 0b                	je     801592 <strtol+0x17d>
		*endptr = (char *) s;
  801587:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80158b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80158f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801596:	74 09                	je     8015a1 <strtol+0x18c>
  801598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159c:	48 f7 d8             	neg    %rax
  80159f:	eb 04                	jmp    8015a5 <strtol+0x190>
  8015a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015a5:	c9                   	leaveq 
  8015a6:	c3                   	retq   

00000000008015a7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	48 83 ec 30          	sub    $0x30,%rsp
  8015af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015bf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015c9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015cd:	75 06                	jne    8015d5 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	eb 6b                	jmp    801640 <strstr+0x99>

	len = strlen(str);
  8015d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d9:	48 89 c7             	mov    %rax,%rdi
  8015dc:	48 b8 7d 0e 80 00 00 	movabs $0x800e7d,%rax
  8015e3:	00 00 00 
  8015e6:	ff d0                	callq  *%rax
  8015e8:	48 98                	cltq   
  8015ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801600:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801604:	75 07                	jne    80160d <strstr+0x66>
				return (char *) 0;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 33                	jmp    801640 <strstr+0x99>
		} while (sc != c);
  80160d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801611:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801614:	75 d8                	jne    8015ee <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801616:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80161a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80161e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801622:	48 89 ce             	mov    %rcx,%rsi
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  80162f:	00 00 00 
  801632:	ff d0                	callq  *%rax
  801634:	85 c0                	test   %eax,%eax
  801636:	75 b6                	jne    8015ee <strstr+0x47>

	return (char *) (in - 1);
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	48 83 e8 01          	sub    $0x1,%rax
}
  801640:	c9                   	leaveq 
  801641:	c3                   	retq   

0000000000801642 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801642:	55                   	push   %rbp
  801643:	48 89 e5             	mov    %rsp,%rbp
  801646:	53                   	push   %rbx
  801647:	48 83 ec 48          	sub    $0x48,%rsp
  80164b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80164e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801651:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801655:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801659:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80165d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801661:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801664:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801668:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80166c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801670:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801674:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801678:	4c 89 c3             	mov    %r8,%rbx
  80167b:	cd 30                	int    $0x30
  80167d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801681:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801685:	74 3e                	je     8016c5 <syscall+0x83>
  801687:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80168c:	7e 37                	jle    8016c5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80168e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801692:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801695:	49 89 d0             	mov    %rdx,%r8
  801698:	89 c1                	mov    %eax,%ecx
  80169a:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  8016a1:	00 00 00 
  8016a4:	be 23 00 00 00       	mov    $0x23,%esi
  8016a9:	48 bf c5 43 80 00 00 	movabs $0x8043c5,%rdi
  8016b0:	00 00 00 
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	49 b9 54 39 80 00 00 	movabs $0x803954,%r9
  8016bf:	00 00 00 
  8016c2:	41 ff d1             	callq  *%r9

	return ret;
  8016c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c9:	48 83 c4 48          	add    $0x48,%rsp
  8016cd:	5b                   	pop    %rbx
  8016ce:	5d                   	pop    %rbp
  8016cf:	c3                   	retq   

00000000008016d0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016d0:	55                   	push   %rbp
  8016d1:	48 89 e5             	mov    %rsp,%rbp
  8016d4:	48 83 ec 20          	sub    $0x20,%rsp
  8016d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ef:	00 
  8016f0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016fc:	48 89 d1             	mov    %rdx,%rcx
  8016ff:	48 89 c2             	mov    %rax,%rdx
  801702:	be 00 00 00 00       	mov    $0x0,%esi
  801707:	bf 00 00 00 00       	mov    $0x0,%edi
  80170c:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801713:	00 00 00 
  801716:	ff d0                	callq  *%rax
}
  801718:	c9                   	leaveq 
  801719:	c3                   	retq   

000000000080171a <sys_cgetc>:

int
sys_cgetc(void)
{
  80171a:	55                   	push   %rbp
  80171b:	48 89 e5             	mov    %rsp,%rbp
  80171e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801722:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801729:	00 
  80172a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801730:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801736:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173b:	ba 00 00 00 00       	mov    $0x0,%edx
  801740:	be 00 00 00 00       	mov    $0x0,%esi
  801745:	bf 01 00 00 00       	mov    $0x1,%edi
  80174a:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
}
  801756:	c9                   	leaveq 
  801757:	c3                   	retq   

0000000000801758 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	48 83 ec 10          	sub    $0x10,%rsp
  801760:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801763:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801766:	48 98                	cltq   
  801768:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80176f:	00 
  801770:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801776:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80177c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801781:	48 89 c2             	mov    %rax,%rdx
  801784:	be 01 00 00 00       	mov    $0x1,%esi
  801789:	bf 03 00 00 00       	mov    $0x3,%edi
  80178e:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801795:	00 00 00 
  801798:	ff d0                	callq  *%rax
}
  80179a:	c9                   	leaveq 
  80179b:	c3                   	retq   

000000000080179c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
  8017a0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ab:	00 
  8017ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	be 00 00 00 00       	mov    $0x0,%esi
  8017c7:	bf 02 00 00 00       	mov    $0x2,%edi
  8017cc:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  8017d3:	00 00 00 
  8017d6:	ff d0                	callq  *%rax
}
  8017d8:	c9                   	leaveq 
  8017d9:	c3                   	retq   

00000000008017da <sys_yield>:

void
sys_yield(void)
{
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e9:	00 
  8017ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801800:	be 00 00 00 00       	mov    $0x0,%esi
  801805:	bf 0b 00 00 00       	mov    $0xb,%edi
  80180a:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801811:	00 00 00 
  801814:	ff d0                	callq  *%rax
}
  801816:	c9                   	leaveq 
  801817:	c3                   	retq   

0000000000801818 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801818:	55                   	push   %rbp
  801819:	48 89 e5             	mov    %rsp,%rbp
  80181c:	48 83 ec 20          	sub    $0x20,%rsp
  801820:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801823:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801827:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80182a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80182d:	48 63 c8             	movslq %eax,%rcx
  801830:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801834:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801837:	48 98                	cltq   
  801839:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801840:	00 
  801841:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801847:	49 89 c8             	mov    %rcx,%r8
  80184a:	48 89 d1             	mov    %rdx,%rcx
  80184d:	48 89 c2             	mov    %rax,%rdx
  801850:	be 01 00 00 00       	mov    $0x1,%esi
  801855:	bf 04 00 00 00       	mov    $0x4,%edi
  80185a:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801861:	00 00 00 
  801864:	ff d0                	callq  *%rax
}
  801866:	c9                   	leaveq 
  801867:	c3                   	retq   

0000000000801868 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 30          	sub    $0x30,%rsp
  801870:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801873:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801877:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80187a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80187e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801882:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801885:	48 63 c8             	movslq %eax,%rcx
  801888:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80188c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80188f:	48 63 f0             	movslq %eax,%rsi
  801892:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801896:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801899:	48 98                	cltq   
  80189b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80189f:	49 89 f9             	mov    %rdi,%r9
  8018a2:	49 89 f0             	mov    %rsi,%r8
  8018a5:	48 89 d1             	mov    %rdx,%rcx
  8018a8:	48 89 c2             	mov    %rax,%rdx
  8018ab:	be 01 00 00 00       	mov    $0x1,%esi
  8018b0:	bf 05 00 00 00       	mov    $0x5,%edi
  8018b5:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  8018bc:	00 00 00 
  8018bf:	ff d0                	callq  *%rax
}
  8018c1:	c9                   	leaveq 
  8018c2:	c3                   	retq   

00000000008018c3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018c3:	55                   	push   %rbp
  8018c4:	48 89 e5             	mov    %rsp,%rbp
  8018c7:	48 83 ec 20          	sub    $0x20,%rsp
  8018cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d9:	48 98                	cltq   
  8018db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e2:	00 
  8018e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ef:	48 89 d1             	mov    %rdx,%rcx
  8018f2:	48 89 c2             	mov    %rax,%rdx
  8018f5:	be 01 00 00 00       	mov    $0x1,%esi
  8018fa:	bf 06 00 00 00       	mov    $0x6,%edi
  8018ff:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 10          	sub    $0x10,%rsp
  801915:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801918:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80191b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80191e:	48 63 d0             	movslq %eax,%rdx
  801921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801924:	48 98                	cltq   
  801926:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192d:	00 
  80192e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801934:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193a:	48 89 d1             	mov    %rdx,%rcx
  80193d:	48 89 c2             	mov    %rax,%rdx
  801940:	be 01 00 00 00       	mov    $0x1,%esi
  801945:	bf 08 00 00 00       	mov    $0x8,%edi
  80194a:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 20          	sub    $0x20,%rsp
  801960:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801963:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196e:	48 98                	cltq   
  801970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801977:	00 
  801978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801984:	48 89 d1             	mov    %rdx,%rcx
  801987:	48 89 c2             	mov    %rax,%rdx
  80198a:	be 01 00 00 00       	mov    $0x1,%esi
  80198f:	bf 09 00 00 00       	mov    $0x9,%edi
  801994:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  80199b:	00 00 00 
  80199e:	ff d0                	callq  *%rax
}
  8019a0:	c9                   	leaveq 
  8019a1:	c3                   	retq   

00000000008019a2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019a2:	55                   	push   %rbp
  8019a3:	48 89 e5             	mov    %rsp,%rbp
  8019a6:	48 83 ec 20          	sub    $0x20,%rsp
  8019aa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b8:	48 98                	cltq   
  8019ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c1:	00 
  8019c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ce:	48 89 d1             	mov    %rdx,%rcx
  8019d1:	48 89 c2             	mov    %rax,%rdx
  8019d4:	be 01 00 00 00       	mov    $0x1,%esi
  8019d9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019de:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  8019e5:	00 00 00 
  8019e8:	ff d0                	callq  *%rax
}
  8019ea:	c9                   	leaveq 
  8019eb:	c3                   	retq   

00000000008019ec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019ec:	55                   	push   %rbp
  8019ed:	48 89 e5             	mov    %rsp,%rbp
  8019f0:	48 83 ec 20          	sub    $0x20,%rsp
  8019f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019ff:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a05:	48 63 f0             	movslq %eax,%rsi
  801a08:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0f:	48 98                	cltq   
  801a11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1c:	00 
  801a1d:	49 89 f1             	mov    %rsi,%r9
  801a20:	49 89 c8             	mov    %rcx,%r8
  801a23:	48 89 d1             	mov    %rdx,%rcx
  801a26:	48 89 c2             	mov    %rax,%rdx
  801a29:	be 00 00 00 00       	mov    $0x0,%esi
  801a2e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a33:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	callq  *%rax
}
  801a3f:	c9                   	leaveq 
  801a40:	c3                   	retq   

0000000000801a41 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a41:	55                   	push   %rbp
  801a42:	48 89 e5             	mov    %rsp,%rbp
  801a45:	48 83 ec 10          	sub    $0x10,%rsp
  801a49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a58:	00 
  801a59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6a:	48 89 c2             	mov    %rax,%rdx
  801a6d:	be 01 00 00 00       	mov    $0x1,%esi
  801a72:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a77:	48 b8 42 16 80 00 00 	movabs $0x801642,%rax
  801a7e:	00 00 00 
  801a81:	ff d0                	callq  *%rax
}
  801a83:	c9                   	leaveq 
  801a84:	c3                   	retq   

0000000000801a85 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a85:	55                   	push   %rbp
  801a86:	48 89 e5             	mov    %rsp,%rbp
  801a89:	48 83 ec 30          	sub    $0x30,%rsp
  801a8d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a95:	48 8b 00             	mov    (%rax),%rax
  801a98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801a9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801aa4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801aa7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801aaa:	83 e0 02             	and    $0x2,%eax
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	75 4d                	jne    801afe <pgfault+0x79>
  801ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab5:	48 c1 e8 0c          	shr    $0xc,%rax
  801ab9:	48 89 c2             	mov    %rax,%rdx
  801abc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ac3:	01 00 00 
  801ac6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801aca:	25 00 08 00 00       	and    $0x800,%eax
  801acf:	48 85 c0             	test   %rax,%rax
  801ad2:	74 2a                	je     801afe <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801ad4:	48 ba d8 43 80 00 00 	movabs $0x8043d8,%rdx
  801adb:	00 00 00 
  801ade:	be 1e 00 00 00       	mov    $0x1e,%esi
  801ae3:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801aea:	00 00 00 
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
  801af2:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801af9:	00 00 00 
  801afc:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801afe:	ba 07 00 00 00       	mov    $0x7,%edx
  801b03:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b08:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0d:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	0f 85 cd 00 00 00    	jne    801bee <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b33:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b40:	48 89 c6             	mov    %rax,%rsi
  801b43:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b48:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b58:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b5e:	48 89 c1             	mov    %rax,%rcx
  801b61:	ba 00 00 00 00       	mov    $0x0,%edx
  801b66:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b70:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801b77:	00 00 00 
  801b7a:	ff d0                	callq  *%rax
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	79 2a                	jns    801baa <pgfault+0x125>
				panic("Page map at temp address failed");
  801b80:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  801b87:	00 00 00 
  801b8a:	be 2f 00 00 00       	mov    $0x2f,%esi
  801b8f:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801b96:	00 00 00 
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801ba5:	00 00 00 
  801ba8:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801baa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801baf:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb4:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	callq  *%rax
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	79 54                	jns    801c18 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801bc4:	48 ba 28 44 80 00 00 	movabs $0x804428,%rdx
  801bcb:	00 00 00 
  801bce:	be 31 00 00 00       	mov    $0x31,%esi
  801bd3:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801bda:	00 00 00 
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801be2:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801be9:	00 00 00 
  801bec:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801bee:	48 ba 50 44 80 00 00 	movabs $0x804450,%rdx
  801bf5:	00 00 00 
  801bf8:	be 35 00 00 00       	mov    $0x35,%esi
  801bfd:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801c04:	00 00 00 
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0c:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801c13:	00 00 00 
  801c16:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801c18:	c9                   	leaveq 
  801c19:	c3                   	retq   

0000000000801c1a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c1a:	55                   	push   %rbp
  801c1b:	48 89 e5             	mov    %rsp,%rbp
  801c1e:	48 83 ec 20          	sub    $0x20,%rsp
  801c22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c25:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801c28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c2f:	01 00 00 
  801c32:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c39:	25 07 0e 00 00       	and    $0xe07,%eax
  801c3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c41:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c44:	48 c1 e0 0c          	shl    $0xc,%rax
  801c48:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4f:	25 00 04 00 00       	and    $0x400,%eax
  801c54:	85 c0                	test   %eax,%eax
  801c56:	74 57                	je     801caf <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c5b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c66:	41 89 f0             	mov    %esi,%r8d
  801c69:	48 89 c6             	mov    %rax,%rsi
  801c6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c71:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	0f 8e 52 01 00 00    	jle    801dd7 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801c85:	48 ba 7d 44 80 00 00 	movabs $0x80447d,%rdx
  801c8c:	00 00 00 
  801c8f:	be 52 00 00 00       	mov    $0x52,%esi
  801c94:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801c9b:	00 00 00 
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca3:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801caa:	00 00 00 
  801cad:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb2:	83 e0 02             	and    $0x2,%eax
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	75 10                	jne    801cc9 <duppage+0xaf>
  801cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbc:	25 00 08 00 00       	and    $0x800,%eax
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	0f 84 bb 00 00 00    	je     801d84 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccc:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801cd1:	80 cc 08             	or     $0x8,%ah
  801cd4:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cd7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cda:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cde:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ce1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce5:	41 89 f0             	mov    %esi,%r8d
  801ce8:	48 89 c6             	mov    %rax,%rsi
  801ceb:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf0:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	callq  *%rax
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	7e 2a                	jle    801d2a <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801d00:	48 ba 7d 44 80 00 00 	movabs $0x80447d,%rdx
  801d07:	00 00 00 
  801d0a:	be 5a 00 00 00       	mov    $0x5a,%esi
  801d0f:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801d16:	00 00 00 
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801d25:	00 00 00 
  801d28:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d2a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d35:	41 89 c8             	mov    %ecx,%r8d
  801d38:	48 89 d1             	mov    %rdx,%rcx
  801d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d40:	48 89 c6             	mov    %rax,%rsi
  801d43:	bf 00 00 00 00       	mov    $0x0,%edi
  801d48:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801d4f:	00 00 00 
  801d52:	ff d0                	callq  *%rax
  801d54:	85 c0                	test   %eax,%eax
  801d56:	7e 2a                	jle    801d82 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801d58:	48 ba 7d 44 80 00 00 	movabs $0x80447d,%rdx
  801d5f:	00 00 00 
  801d62:	be 5d 00 00 00       	mov    $0x5d,%esi
  801d67:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801d6e:	00 00 00 
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
  801d76:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801d7d:	00 00 00 
  801d80:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d82:	eb 53                	jmp    801dd7 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d84:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d87:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d8b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d92:	41 89 f0             	mov    %esi,%r8d
  801d95:	48 89 c6             	mov    %rax,%rsi
  801d98:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9d:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	callq  *%rax
  801da9:	85 c0                	test   %eax,%eax
  801dab:	7e 2a                	jle    801dd7 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801dad:	48 ba 7d 44 80 00 00 	movabs $0x80447d,%rdx
  801db4:	00 00 00 
  801db7:	be 61 00 00 00       	mov    $0x61,%esi
  801dbc:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801dc3:	00 00 00 
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcb:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  801dd2:	00 00 00 
  801dd5:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801de6:	48 bf 85 1a 80 00 00 	movabs $0x801a85,%rdi
  801ded:	00 00 00 
  801df0:	48 b8 68 3a 80 00 00 	movabs $0x803a68,%rax
  801df7:	00 00 00 
  801dfa:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dfc:	b8 07 00 00 00       	mov    $0x7,%eax
  801e01:	cd 30                	int    $0x30
  801e03:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e06:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e09:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e10:	79 30                	jns    801e42 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801e12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e15:	89 c1                	mov    %eax,%ecx
  801e17:	48 ba 9b 44 80 00 00 	movabs $0x80449b,%rdx
  801e1e:	00 00 00 
  801e21:	be 89 00 00 00       	mov    $0x89,%esi
  801e26:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  801e2d:	00 00 00 
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
  801e35:	49 b8 54 39 80 00 00 	movabs $0x803954,%r8
  801e3c:	00 00 00 
  801e3f:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e46:	75 46                	jne    801e8e <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e48:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  801e4f:	00 00 00 
  801e52:	ff d0                	callq  *%rax
  801e54:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e59:	48 63 d0             	movslq %eax,%rdx
  801e5c:	48 89 d0             	mov    %rdx,%rax
  801e5f:	48 c1 e0 03          	shl    $0x3,%rax
  801e63:	48 01 d0             	add    %rdx,%rax
  801e66:	48 c1 e0 05          	shl    $0x5,%rax
  801e6a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e71:	00 00 00 
  801e74:	48 01 c2             	add    %rax,%rdx
  801e77:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801e7e:	00 00 00 
  801e81:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
  801e89:	e9 d1 01 00 00       	jmpq   80205f <fork+0x281>
	}

	uint64_t ad = 0;
  801e8e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801e95:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801e96:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801e9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801e9f:	e9 df 00 00 00       	jmpq   801f83 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea8:	48 c1 e8 27          	shr    $0x27,%rax
  801eac:	48 89 c2             	mov    %rax,%rdx
  801eaf:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801eb6:	01 00 00 
  801eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebd:	83 e0 01             	and    $0x1,%eax
  801ec0:	48 85 c0             	test   %rax,%rax
  801ec3:	0f 84 9e 00 00 00    	je     801f67 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801ec9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecd:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ed1:	48 89 c2             	mov    %rax,%rdx
  801ed4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801edb:	01 00 00 
  801ede:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee2:	83 e0 01             	and    $0x1,%eax
  801ee5:	48 85 c0             	test   %rax,%rax
  801ee8:	74 73                	je     801f5d <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eee:	48 c1 e8 15          	shr    $0x15,%rax
  801ef2:	48 89 c2             	mov    %rax,%rdx
  801ef5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801efc:	01 00 00 
  801eff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f03:	83 e0 01             	and    $0x1,%eax
  801f06:	48 85 c0             	test   %rax,%rax
  801f09:	74 48                	je     801f53 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0f:	48 c1 e8 0c          	shr    $0xc,%rax
  801f13:	48 89 c2             	mov    %rax,%rdx
  801f16:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1d:	01 00 00 
  801f20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2c:	83 e0 01             	and    $0x1,%eax
  801f2f:	48 85 c0             	test   %rax,%rax
  801f32:	74 47                	je     801f7b <fork+0x19d>
						duppage(envid, VPN(addr));
  801f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f38:	48 c1 e8 0c          	shr    $0xc,%rax
  801f3c:	89 c2                	mov    %eax,%edx
  801f3e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f41:	89 d6                	mov    %edx,%esi
  801f43:	89 c7                	mov    %eax,%edi
  801f45:	48 b8 1a 1c 80 00 00 	movabs $0x801c1a,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
  801f51:	eb 28                	jmp    801f7b <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  801f53:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801f5a:	00 
  801f5b:	eb 1e                	jmp    801f7b <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801f5d:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801f64:	40 
  801f65:	eb 14                	jmp    801f7b <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  801f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f6b:	48 c1 e8 27          	shr    $0x27,%rax
  801f6f:	48 83 c0 01          	add    $0x1,%rax
  801f73:	48 c1 e0 27          	shl    $0x27,%rax
  801f77:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801f7b:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801f82:	00 
  801f83:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  801f8a:	00 
  801f8b:	0f 87 13 ff ff ff    	ja     801ea4 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801f91:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f94:	ba 07 00 00 00       	mov    $0x7,%edx
  801f99:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f9e:	89 c7                	mov    %eax,%edi
  801fa0:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  801fac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801faf:	ba 07 00 00 00       	mov    $0x7,%edx
  801fb4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fb9:	89 c7                	mov    %eax,%edi
  801fbb:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  801fc2:	00 00 00 
  801fc5:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  801fc7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fca:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fd0:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  801fd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fda:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801fdf:	89 c7                	mov    %eax,%edi
  801fe1:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801fe8:	00 00 00 
  801feb:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  801fed:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ff2:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  801ff7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ffc:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802008:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80200d:	bf 00 00 00 00       	mov    $0x0,%edi
  802012:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  802019:	00 00 00 
  80201c:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80201e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802025:	00 00 00 
  802028:	48 8b 00             	mov    (%rax),%rax
  80202b:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802032:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802035:	48 89 d6             	mov    %rdx,%rsi
  802038:	89 c7                	mov    %eax,%edi
  80203a:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802046:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802049:	be 02 00 00 00       	mov    $0x2,%esi
  80204e:	89 c7                	mov    %eax,%edi
  802050:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax

	return envid;
  80205c:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80205f:	c9                   	leaveq 
  802060:	c3                   	retq   

0000000000802061 <sfork>:

// Challenge!
int
sfork(void)
{
  802061:	55                   	push   %rbp
  802062:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802065:	48 ba b3 44 80 00 00 	movabs $0x8044b3,%rdx
  80206c:	00 00 00 
  80206f:	be b8 00 00 00       	mov    $0xb8,%esi
  802074:	48 bf fd 43 80 00 00 	movabs $0x8043fd,%rdi
  80207b:	00 00 00 
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  80208a:	00 00 00 
  80208d:	ff d1                	callq  *%rcx

000000000080208f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80208f:	55                   	push   %rbp
  802090:	48 89 e5             	mov    %rsp,%rbp
  802093:	48 83 ec 08          	sub    $0x8,%rsp
  802097:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80209b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80209f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020a6:	ff ff ff 
  8020a9:	48 01 d0             	add    %rdx,%rax
  8020ac:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020b0:	c9                   	leaveq 
  8020b1:	c3                   	retq   

00000000008020b2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020b2:	55                   	push   %rbp
  8020b3:	48 89 e5             	mov    %rsp,%rbp
  8020b6:	48 83 ec 08          	sub    $0x8,%rsp
  8020ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c2:	48 89 c7             	mov    %rax,%rdi
  8020c5:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  8020cc:	00 00 00 
  8020cf:	ff d0                	callq  *%rax
  8020d1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8020d7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8020db:	c9                   	leaveq 
  8020dc:	c3                   	retq   

00000000008020dd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8020dd:	55                   	push   %rbp
  8020de:	48 89 e5             	mov    %rsp,%rbp
  8020e1:	48 83 ec 18          	sub    $0x18,%rsp
  8020e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020f0:	eb 6b                	jmp    80215d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8020f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f5:	48 98                	cltq   
  8020f7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020fd:	48 c1 e0 0c          	shl    $0xc,%rax
  802101:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802109:	48 c1 e8 15          	shr    $0x15,%rax
  80210d:	48 89 c2             	mov    %rax,%rdx
  802110:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802117:	01 00 00 
  80211a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211e:	83 e0 01             	and    $0x1,%eax
  802121:	48 85 c0             	test   %rax,%rax
  802124:	74 21                	je     802147 <fd_alloc+0x6a>
  802126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212a:	48 c1 e8 0c          	shr    $0xc,%rax
  80212e:	48 89 c2             	mov    %rax,%rdx
  802131:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802138:	01 00 00 
  80213b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213f:	83 e0 01             	and    $0x1,%eax
  802142:	48 85 c0             	test   %rax,%rax
  802145:	75 12                	jne    802159 <fd_alloc+0x7c>
			*fd_store = fd;
  802147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	eb 1a                	jmp    802173 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802159:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80215d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802161:	7e 8f                	jle    8020f2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802167:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80216e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802173:	c9                   	leaveq 
  802174:	c3                   	retq   

0000000000802175 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802175:	55                   	push   %rbp
  802176:	48 89 e5             	mov    %rsp,%rbp
  802179:	48 83 ec 20          	sub    $0x20,%rsp
  80217d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802180:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802184:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802188:	78 06                	js     802190 <fd_lookup+0x1b>
  80218a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80218e:	7e 07                	jle    802197 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802190:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802195:	eb 6c                	jmp    802203 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802197:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80219a:	48 98                	cltq   
  80219c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021a2:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021ae:	48 c1 e8 15          	shr    $0x15,%rax
  8021b2:	48 89 c2             	mov    %rax,%rdx
  8021b5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021bc:	01 00 00 
  8021bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c3:	83 e0 01             	and    $0x1,%eax
  8021c6:	48 85 c0             	test   %rax,%rax
  8021c9:	74 21                	je     8021ec <fd_lookup+0x77>
  8021cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021cf:	48 c1 e8 0c          	shr    $0xc,%rax
  8021d3:	48 89 c2             	mov    %rax,%rdx
  8021d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021dd:	01 00 00 
  8021e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e4:	83 e0 01             	and    $0x1,%eax
  8021e7:	48 85 c0             	test   %rax,%rax
  8021ea:	75 07                	jne    8021f3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021f1:	eb 10                	jmp    802203 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8021f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021fb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802203:	c9                   	leaveq 
  802204:	c3                   	retq   

0000000000802205 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802205:	55                   	push   %rbp
  802206:	48 89 e5             	mov    %rsp,%rbp
  802209:	48 83 ec 30          	sub    $0x30,%rsp
  80220d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802211:	89 f0                	mov    %esi,%eax
  802213:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802216:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80221a:	48 89 c7             	mov    %rax,%rdi
  80221d:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  802224:	00 00 00 
  802227:	ff d0                	callq  *%rax
  802229:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80222d:	48 89 d6             	mov    %rdx,%rsi
  802230:	89 c7                	mov    %eax,%edi
  802232:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  802239:	00 00 00 
  80223c:	ff d0                	callq  *%rax
  80223e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802241:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802245:	78 0a                	js     802251 <fd_close+0x4c>
	    || fd != fd2)
  802247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80224f:	74 12                	je     802263 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802251:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802255:	74 05                	je     80225c <fd_close+0x57>
  802257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225a:	eb 05                	jmp    802261 <fd_close+0x5c>
  80225c:	b8 00 00 00 00       	mov    $0x0,%eax
  802261:	eb 69                	jmp    8022cc <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802263:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802267:	8b 00                	mov    (%rax),%eax
  802269:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80226d:	48 89 d6             	mov    %rdx,%rsi
  802270:	89 c7                	mov    %eax,%edi
  802272:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802281:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802285:	78 2a                	js     8022b1 <fd_close+0xac>
		if (dev->dev_close)
  802287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80228f:	48 85 c0             	test   %rax,%rax
  802292:	74 16                	je     8022aa <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 8b 40 20          	mov    0x20(%rax),%rax
  80229c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022a0:	48 89 d7             	mov    %rdx,%rdi
  8022a3:	ff d0                	callq  *%rax
  8022a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a8:	eb 07                	jmp    8022b1 <fd_close+0xac>
		else
			r = 0;
  8022aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b5:	48 89 c6             	mov    %rax,%rsi
  8022b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022bd:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  8022c4:	00 00 00 
  8022c7:	ff d0                	callq  *%rax
	return r;
  8022c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022cc:	c9                   	leaveq 
  8022cd:	c3                   	retq   

00000000008022ce <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8022ce:	55                   	push   %rbp
  8022cf:	48 89 e5             	mov    %rsp,%rbp
  8022d2:	48 83 ec 20          	sub    $0x20,%rsp
  8022d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8022dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022e4:	eb 41                	jmp    802327 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8022e6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8022ed:	00 00 00 
  8022f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022f3:	48 63 d2             	movslq %edx,%rdx
  8022f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022fa:	8b 00                	mov    (%rax),%eax
  8022fc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022ff:	75 22                	jne    802323 <dev_lookup+0x55>
			*dev = devtab[i];
  802301:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802308:	00 00 00 
  80230b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80230e:	48 63 d2             	movslq %edx,%rdx
  802311:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802315:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802319:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	eb 60                	jmp    802383 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802323:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802327:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80232e:	00 00 00 
  802331:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802334:	48 63 d2             	movslq %edx,%rdx
  802337:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233b:	48 85 c0             	test   %rax,%rax
  80233e:	75 a6                	jne    8022e6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802340:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802347:	00 00 00 
  80234a:	48 8b 00             	mov    (%rax),%rax
  80234d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802353:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802356:	89 c6                	mov    %eax,%esi
  802358:	48 bf d0 44 80 00 00 	movabs $0x8044d0,%rdi
  80235f:	00 00 00 
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
  802367:	48 b9 21 03 80 00 00 	movabs $0x800321,%rcx
  80236e:	00 00 00 
  802371:	ff d1                	callq  *%rcx
	*dev = 0;
  802373:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802377:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80237e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802383:	c9                   	leaveq 
  802384:	c3                   	retq   

0000000000802385 <close>:

int
close(int fdnum)
{
  802385:	55                   	push   %rbp
  802386:	48 89 e5             	mov    %rsp,%rbp
  802389:	48 83 ec 20          	sub    $0x20,%rsp
  80238d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802390:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802394:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802397:	48 89 d6             	mov    %rdx,%rsi
  80239a:	89 c7                	mov    %eax,%edi
  80239c:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  8023a3:	00 00 00 
  8023a6:	ff d0                	callq  *%rax
  8023a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023af:	79 05                	jns    8023b6 <close+0x31>
		return r;
  8023b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b4:	eb 18                	jmp    8023ce <close+0x49>
	else
		return fd_close(fd, 1);
  8023b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ba:	be 01 00 00 00       	mov    $0x1,%esi
  8023bf:	48 89 c7             	mov    %rax,%rdi
  8023c2:	48 b8 05 22 80 00 00 	movabs $0x802205,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	callq  *%rax
}
  8023ce:	c9                   	leaveq 
  8023cf:	c3                   	retq   

00000000008023d0 <close_all>:

void
close_all(void)
{
  8023d0:	55                   	push   %rbp
  8023d1:	48 89 e5             	mov    %rsp,%rbp
  8023d4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8023d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023df:	eb 15                	jmp    8023f6 <close_all+0x26>
		close(i);
  8023e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e4:	89 c7                	mov    %eax,%edi
  8023e6:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8023f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023f6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023fa:	7e e5                	jle    8023e1 <close_all+0x11>
		close(i);
}
  8023fc:	c9                   	leaveq 
  8023fd:	c3                   	retq   

00000000008023fe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	48 83 ec 40          	sub    $0x40,%rsp
  802406:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802409:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80240c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802410:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802413:	48 89 d6             	mov    %rdx,%rsi
  802416:	89 c7                	mov    %eax,%edi
  802418:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  80241f:	00 00 00 
  802422:	ff d0                	callq  *%rax
  802424:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802427:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242b:	79 08                	jns    802435 <dup+0x37>
		return r;
  80242d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802430:	e9 70 01 00 00       	jmpq   8025a5 <dup+0x1a7>
	close(newfdnum);
  802435:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802438:	89 c7                	mov    %eax,%edi
  80243a:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  802441:	00 00 00 
  802444:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802446:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802449:	48 98                	cltq   
  80244b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802451:	48 c1 e0 0c          	shl    $0xc,%rax
  802455:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80245d:	48 89 c7             	mov    %rax,%rdi
  802460:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
  80246c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802474:	48 89 c7             	mov    %rax,%rdi
  802477:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  80247e:	00 00 00 
  802481:	ff d0                	callq  *%rax
  802483:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248b:	48 c1 e8 15          	shr    $0x15,%rax
  80248f:	48 89 c2             	mov    %rax,%rdx
  802492:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802499:	01 00 00 
  80249c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a0:	83 e0 01             	and    $0x1,%eax
  8024a3:	48 85 c0             	test   %rax,%rax
  8024a6:	74 73                	je     80251b <dup+0x11d>
  8024a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8024b0:	48 89 c2             	mov    %rax,%rdx
  8024b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ba:	01 00 00 
  8024bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c1:	83 e0 01             	and    $0x1,%eax
  8024c4:	48 85 c0             	test   %rax,%rax
  8024c7:	74 52                	je     80251b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8024c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8024d1:	48 89 c2             	mov    %rax,%rdx
  8024d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024db:	01 00 00 
  8024de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8024e7:	89 c1                	mov    %eax,%ecx
  8024e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f1:	41 89 c8             	mov    %ecx,%r8d
  8024f4:	48 89 d1             	mov    %rdx,%rcx
  8024f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fc:	48 89 c6             	mov    %rax,%rsi
  8024ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802504:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax
  802510:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802513:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802517:	79 02                	jns    80251b <dup+0x11d>
			goto err;
  802519:	eb 57                	jmp    802572 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80251b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80251f:	48 c1 e8 0c          	shr    $0xc,%rax
  802523:	48 89 c2             	mov    %rax,%rdx
  802526:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80252d:	01 00 00 
  802530:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802534:	25 07 0e 00 00       	and    $0xe07,%eax
  802539:	89 c1                	mov    %eax,%ecx
  80253b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802543:	41 89 c8             	mov    %ecx,%r8d
  802546:	48 89 d1             	mov    %rdx,%rcx
  802549:	ba 00 00 00 00       	mov    $0x0,%edx
  80254e:	48 89 c6             	mov    %rax,%rsi
  802551:	bf 00 00 00 00       	mov    $0x0,%edi
  802556:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  80255d:	00 00 00 
  802560:	ff d0                	callq  *%rax
  802562:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802569:	79 02                	jns    80256d <dup+0x16f>
		goto err;
  80256b:	eb 05                	jmp    802572 <dup+0x174>

	return newfdnum;
  80256d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802570:	eb 33                	jmp    8025a5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802576:	48 89 c6             	mov    %rax,%rsi
  802579:	bf 00 00 00 00       	mov    $0x0,%edi
  80257e:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80258a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258e:	48 89 c6             	mov    %rax,%rsi
  802591:	bf 00 00 00 00       	mov    $0x0,%edi
  802596:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  80259d:	00 00 00 
  8025a0:	ff d0                	callq  *%rax
	return r;
  8025a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025a5:	c9                   	leaveq 
  8025a6:	c3                   	retq   

00000000008025a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025a7:	55                   	push   %rbp
  8025a8:	48 89 e5             	mov    %rsp,%rbp
  8025ab:	48 83 ec 40          	sub    $0x40,%rsp
  8025af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025c1:	48 89 d6             	mov    %rdx,%rsi
  8025c4:	89 c7                	mov    %eax,%edi
  8025c6:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
  8025d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d9:	78 24                	js     8025ff <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025df:	8b 00                	mov    (%rax),%eax
  8025e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025e5:	48 89 d6             	mov    %rdx,%rsi
  8025e8:	89 c7                	mov    %eax,%edi
  8025ea:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  8025f1:	00 00 00 
  8025f4:	ff d0                	callq  *%rax
  8025f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fd:	79 05                	jns    802604 <read+0x5d>
		return r;
  8025ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802602:	eb 76                	jmp    80267a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802608:	8b 40 08             	mov    0x8(%rax),%eax
  80260b:	83 e0 03             	and    $0x3,%eax
  80260e:	83 f8 01             	cmp    $0x1,%eax
  802611:	75 3a                	jne    80264d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802613:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80261a:	00 00 00 
  80261d:	48 8b 00             	mov    (%rax),%rax
  802620:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802626:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802629:	89 c6                	mov    %eax,%esi
  80262b:	48 bf ef 44 80 00 00 	movabs $0x8044ef,%rdi
  802632:	00 00 00 
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
  80263a:	48 b9 21 03 80 00 00 	movabs $0x800321,%rcx
  802641:	00 00 00 
  802644:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802646:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80264b:	eb 2d                	jmp    80267a <read+0xd3>
	}
	if (!dev->dev_read)
  80264d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802651:	48 8b 40 10          	mov    0x10(%rax),%rax
  802655:	48 85 c0             	test   %rax,%rax
  802658:	75 07                	jne    802661 <read+0xba>
		return -E_NOT_SUPP;
  80265a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80265f:	eb 19                	jmp    80267a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802665:	48 8b 40 10          	mov    0x10(%rax),%rax
  802669:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80266d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802671:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802675:	48 89 cf             	mov    %rcx,%rdi
  802678:	ff d0                	callq  *%rax
}
  80267a:	c9                   	leaveq 
  80267b:	c3                   	retq   

000000000080267c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80267c:	55                   	push   %rbp
  80267d:	48 89 e5             	mov    %rsp,%rbp
  802680:	48 83 ec 30          	sub    $0x30,%rsp
  802684:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802687:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80268b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80268f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802696:	eb 49                	jmp    8026e1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269b:	48 98                	cltq   
  80269d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026a1:	48 29 c2             	sub    %rax,%rdx
  8026a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a7:	48 63 c8             	movslq %eax,%rcx
  8026aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ae:	48 01 c1             	add    %rax,%rcx
  8026b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026b4:	48 89 ce             	mov    %rcx,%rsi
  8026b7:	89 c7                	mov    %eax,%edi
  8026b9:	48 b8 a7 25 80 00 00 	movabs $0x8025a7,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	callq  *%rax
  8026c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8026c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026cc:	79 05                	jns    8026d3 <readn+0x57>
			return m;
  8026ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026d1:	eb 1c                	jmp    8026ef <readn+0x73>
		if (m == 0)
  8026d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026d7:	75 02                	jne    8026db <readn+0x5f>
			break;
  8026d9:	eb 11                	jmp    8026ec <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026de:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e4:	48 98                	cltq   
  8026e6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8026ea:	72 ac                	jb     802698 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8026ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026ef:	c9                   	leaveq 
  8026f0:	c3                   	retq   

00000000008026f1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8026f1:	55                   	push   %rbp
  8026f2:	48 89 e5             	mov    %rsp,%rbp
  8026f5:	48 83 ec 40          	sub    $0x40,%rsp
  8026f9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802700:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802704:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802708:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80270b:	48 89 d6             	mov    %rdx,%rsi
  80270e:	89 c7                	mov    %eax,%edi
  802710:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
  80271c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802723:	78 24                	js     802749 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802729:	8b 00                	mov    (%rax),%eax
  80272b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80272f:	48 89 d6             	mov    %rdx,%rsi
  802732:	89 c7                	mov    %eax,%edi
  802734:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax
  802740:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802743:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802747:	79 05                	jns    80274e <write+0x5d>
		return r;
  802749:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274c:	eb 75                	jmp    8027c3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80274e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802752:	8b 40 08             	mov    0x8(%rax),%eax
  802755:	83 e0 03             	and    $0x3,%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	75 3a                	jne    802796 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80275c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802763:	00 00 00 
  802766:	48 8b 00             	mov    (%rax),%rax
  802769:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80276f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802772:	89 c6                	mov    %eax,%esi
  802774:	48 bf 0b 45 80 00 00 	movabs $0x80450b,%rdi
  80277b:	00 00 00 
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
  802783:	48 b9 21 03 80 00 00 	movabs $0x800321,%rcx
  80278a:	00 00 00 
  80278d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80278f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802794:	eb 2d                	jmp    8027c3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80279e:	48 85 c0             	test   %rax,%rax
  8027a1:	75 07                	jne    8027aa <write+0xb9>
		return -E_NOT_SUPP;
  8027a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a8:	eb 19                	jmp    8027c3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ae:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027b6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027ba:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027be:	48 89 cf             	mov    %rcx,%rdi
  8027c1:	ff d0                	callq  *%rax
}
  8027c3:	c9                   	leaveq 
  8027c4:	c3                   	retq   

00000000008027c5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8027c5:	55                   	push   %rbp
  8027c6:	48 89 e5             	mov    %rsp,%rbp
  8027c9:	48 83 ec 18          	sub    $0x18,%rsp
  8027cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027d0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027da:	48 89 d6             	mov    %rdx,%rsi
  8027dd:	89 c7                	mov    %eax,%edi
  8027df:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
  8027eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f2:	79 05                	jns    8027f9 <seek+0x34>
		return r;
  8027f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f7:	eb 0f                	jmp    802808 <seek+0x43>
	fd->fd_offset = offset;
  8027f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802800:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802808:	c9                   	leaveq 
  802809:	c3                   	retq   

000000000080280a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 30          	sub    $0x30,%rsp
  802812:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802815:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802818:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80281c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80281f:	48 89 d6             	mov    %rdx,%rsi
  802822:	89 c7                	mov    %eax,%edi
  802824:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
  802830:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802833:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802837:	78 24                	js     80285d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283d:	8b 00                	mov    (%rax),%eax
  80283f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802843:	48 89 d6             	mov    %rdx,%rsi
  802846:	89 c7                	mov    %eax,%edi
  802848:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802857:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285b:	79 05                	jns    802862 <ftruncate+0x58>
		return r;
  80285d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802860:	eb 72                	jmp    8028d4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802866:	8b 40 08             	mov    0x8(%rax),%eax
  802869:	83 e0 03             	and    $0x3,%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	75 3a                	jne    8028aa <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802870:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802877:	00 00 00 
  80287a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80287d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802883:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802886:	89 c6                	mov    %eax,%esi
  802888:	48 bf 28 45 80 00 00 	movabs $0x804528,%rdi
  80288f:	00 00 00 
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	48 b9 21 03 80 00 00 	movabs $0x800321,%rcx
  80289e:	00 00 00 
  8028a1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a8:	eb 2a                	jmp    8028d4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ae:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028b2:	48 85 c0             	test   %rax,%rax
  8028b5:	75 07                	jne    8028be <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028b7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028bc:	eb 16                	jmp    8028d4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ca:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8028cd:	89 ce                	mov    %ecx,%esi
  8028cf:	48 89 d7             	mov    %rdx,%rdi
  8028d2:	ff d0                	callq  *%rax
}
  8028d4:	c9                   	leaveq 
  8028d5:	c3                   	retq   

00000000008028d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8028d6:	55                   	push   %rbp
  8028d7:	48 89 e5             	mov    %rsp,%rbp
  8028da:	48 83 ec 30          	sub    $0x30,%rsp
  8028de:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ec:	48 89 d6             	mov    %rdx,%rsi
  8028ef:	89 c7                	mov    %eax,%edi
  8028f1:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
  8028fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802900:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802904:	78 24                	js     80292a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290a:	8b 00                	mov    (%rax),%eax
  80290c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802910:	48 89 d6             	mov    %rdx,%rsi
  802913:	89 c7                	mov    %eax,%edi
  802915:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  80291c:	00 00 00 
  80291f:	ff d0                	callq  *%rax
  802921:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802924:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802928:	79 05                	jns    80292f <fstat+0x59>
		return r;
  80292a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292d:	eb 5e                	jmp    80298d <fstat+0xb7>
	if (!dev->dev_stat)
  80292f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802933:	48 8b 40 28          	mov    0x28(%rax),%rax
  802937:	48 85 c0             	test   %rax,%rax
  80293a:	75 07                	jne    802943 <fstat+0x6d>
		return -E_NOT_SUPP;
  80293c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802941:	eb 4a                	jmp    80298d <fstat+0xb7>
	stat->st_name[0] = 0;
  802943:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802947:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80294a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80294e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802955:	00 00 00 
	stat->st_isdir = 0;
  802958:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80295c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802963:	00 00 00 
	stat->st_dev = dev;
  802966:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80296a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80296e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802979:	48 8b 40 28          	mov    0x28(%rax),%rax
  80297d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802981:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802985:	48 89 ce             	mov    %rcx,%rsi
  802988:	48 89 d7             	mov    %rdx,%rdi
  80298b:	ff d0                	callq  *%rax
}
  80298d:	c9                   	leaveq 
  80298e:	c3                   	retq   

000000000080298f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80298f:	55                   	push   %rbp
  802990:	48 89 e5             	mov    %rsp,%rbp
  802993:	48 83 ec 20          	sub    $0x20,%rsp
  802997:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80299b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80299f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a3:	be 00 00 00 00       	mov    $0x0,%esi
  8029a8:	48 89 c7             	mov    %rax,%rdi
  8029ab:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax
  8029b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029be:	79 05                	jns    8029c5 <stat+0x36>
		return fd;
  8029c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c3:	eb 2f                	jmp    8029f4 <stat+0x65>
	r = fstat(fd, stat);
  8029c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cc:	48 89 d6             	mov    %rdx,%rsi
  8029cf:	89 c7                	mov    %eax,%edi
  8029d1:	48 b8 d6 28 80 00 00 	movabs $0x8028d6,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax
  8029dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8029e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e3:	89 c7                	mov    %eax,%edi
  8029e5:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
	return r;
  8029f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8029f4:	c9                   	leaveq 
  8029f5:	c3                   	retq   

00000000008029f6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8029f6:	55                   	push   %rbp
  8029f7:	48 89 e5             	mov    %rsp,%rbp
  8029fa:	48 83 ec 10          	sub    $0x10,%rsp
  8029fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a05:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a0c:	00 00 00 
  802a0f:	8b 00                	mov    (%rax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	75 1d                	jne    802a32 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a15:	bf 01 00 00 00       	mov    $0x1,%edi
  802a1a:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802a2d:	00 00 00 
  802a30:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a32:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a39:	00 00 00 
  802a3c:	8b 00                	mov    (%rax),%eax
  802a3e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a41:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a46:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a4d:	00 00 00 
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 73 3c 80 00 00 	movabs $0x803c73,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a62:	ba 00 00 00 00       	mov    $0x0,%edx
  802a67:	48 89 c6             	mov    %rax,%rsi
  802a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6f:	48 b8 b2 3b 80 00 00 	movabs $0x803bb2,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
}
  802a7b:	c9                   	leaveq 
  802a7c:	c3                   	retq   

0000000000802a7d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a7d:	55                   	push   %rbp
  802a7e:	48 89 e5             	mov    %rsp,%rbp
  802a81:	48 83 ec 20          	sub    $0x20,%rsp
  802a85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a89:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a90:	48 89 c7             	mov    %rax,%rdi
  802a93:	48 b8 7d 0e 80 00 00 	movabs $0x800e7d,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802aa4:	7e 0a                	jle    802ab0 <open+0x33>
		return -E_BAD_PATH;
  802aa6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802aab:	e9 a5 00 00 00       	jmpq   802b55 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ab0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ab4:	48 89 c7             	mov    %rax,%rdi
  802ab7:	48 b8 dd 20 80 00 00 	movabs $0x8020dd,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	callq  *%rax
  802ac3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aca:	79 08                	jns    802ad4 <open+0x57>
		return r;
  802acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acf:	e9 81 00 00 00       	jmpq   802b55 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad8:	48 89 c6             	mov    %rax,%rsi
  802adb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ae2:	00 00 00 
  802ae5:	48 b8 e9 0e 80 00 00 	movabs $0x800ee9,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802af1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af8:	00 00 00 
  802afb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802afe:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802b04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b08:	48 89 c6             	mov    %rax,%rsi
  802b0b:	bf 01 00 00 00       	mov    $0x1,%edi
  802b10:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
  802b1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b23:	79 1d                	jns    802b42 <open+0xc5>
		fd_close(fd, 0);
  802b25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b29:	be 00 00 00 00       	mov    $0x0,%esi
  802b2e:	48 89 c7             	mov    %rax,%rdi
  802b31:	48 b8 05 22 80 00 00 	movabs $0x802205,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
		return r;
  802b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b40:	eb 13                	jmp    802b55 <open+0xd8>
	}

	return fd2num(fd);
  802b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b46:	48 89 c7             	mov    %rax,%rdi
  802b49:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802b55:	c9                   	leaveq 
  802b56:	c3                   	retq   

0000000000802b57 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802b57:	55                   	push   %rbp
  802b58:	48 89 e5             	mov    %rsp,%rbp
  802b5b:	48 83 ec 10          	sub    $0x10,%rsp
  802b5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b67:	8b 50 0c             	mov    0xc(%rax),%edx
  802b6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b71:	00 00 00 
  802b74:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b76:	be 00 00 00 00       	mov    $0x0,%esi
  802b7b:	bf 06 00 00 00       	mov    $0x6,%edi
  802b80:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
}
  802b8c:	c9                   	leaveq 
  802b8d:	c3                   	retq   

0000000000802b8e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b8e:	55                   	push   %rbp
  802b8f:	48 89 e5             	mov    %rsp,%rbp
  802b92:	48 83 ec 30          	sub    $0x30,%rsp
  802b96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b9e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ba2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ba9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bb0:	00 00 00 
  802bb3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802bb5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bbc:	00 00 00 
  802bbf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802bc7:	be 00 00 00 00       	mov    $0x0,%esi
  802bcc:	bf 03 00 00 00       	mov    $0x3,%edi
  802bd1:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
  802bdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be4:	79 08                	jns    802bee <devfile_read+0x60>
		return r;
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	e9 a4 00 00 00       	jmpq   802c92 <devfile_read+0x104>
	assert(r <= n);
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	48 98                	cltq   
  802bf3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bf7:	76 35                	jbe    802c2e <devfile_read+0xa0>
  802bf9:	48 b9 55 45 80 00 00 	movabs $0x804555,%rcx
  802c00:	00 00 00 
  802c03:	48 ba 5c 45 80 00 00 	movabs $0x80455c,%rdx
  802c0a:	00 00 00 
  802c0d:	be 84 00 00 00       	mov    $0x84,%esi
  802c12:	48 bf 71 45 80 00 00 	movabs $0x804571,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	49 b8 54 39 80 00 00 	movabs $0x803954,%r8
  802c28:	00 00 00 
  802c2b:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802c2e:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802c35:	7e 35                	jle    802c6c <devfile_read+0xde>
  802c37:	48 b9 7c 45 80 00 00 	movabs $0x80457c,%rcx
  802c3e:	00 00 00 
  802c41:	48 ba 5c 45 80 00 00 	movabs $0x80455c,%rdx
  802c48:	00 00 00 
  802c4b:	be 85 00 00 00       	mov    $0x85,%esi
  802c50:	48 bf 71 45 80 00 00 	movabs $0x804571,%rdi
  802c57:	00 00 00 
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5f:	49 b8 54 39 80 00 00 	movabs $0x803954,%r8
  802c66:	00 00 00 
  802c69:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6f:	48 63 d0             	movslq %eax,%rdx
  802c72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c76:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c7d:	00 00 00 
  802c80:	48 89 c7             	mov    %rax,%rdi
  802c83:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
	return r;
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802c92:	c9                   	leaveq 
  802c93:	c3                   	retq   

0000000000802c94 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c94:	55                   	push   %rbp
  802c95:	48 89 e5             	mov    %rsp,%rbp
  802c98:	48 83 ec 30          	sub    $0x30,%rsp
  802c9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ca4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ca8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cac:	8b 50 0c             	mov    0xc(%rax),%edx
  802caf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cb6:	00 00 00 
  802cb9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802cbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cc2:	00 00 00 
  802cc5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cc9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802ccd:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802cd4:	00 
  802cd5:	76 35                	jbe    802d0c <devfile_write+0x78>
  802cd7:	48 b9 88 45 80 00 00 	movabs $0x804588,%rcx
  802cde:	00 00 00 
  802ce1:	48 ba 5c 45 80 00 00 	movabs $0x80455c,%rdx
  802ce8:	00 00 00 
  802ceb:	be 9e 00 00 00       	mov    $0x9e,%esi
  802cf0:	48 bf 71 45 80 00 00 	movabs $0x804571,%rdi
  802cf7:	00 00 00 
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802cff:	49 b8 54 39 80 00 00 	movabs $0x803954,%r8
  802d06:	00 00 00 
  802d09:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802d0c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d14:	48 89 c6             	mov    %rax,%rsi
  802d17:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d1e:	00 00 00 
  802d21:	48 b8 24 13 80 00 00 	movabs $0x801324,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802d2d:	be 00 00 00 00       	mov    $0x0,%esi
  802d32:	bf 04 00 00 00       	mov    $0x4,%edi
  802d37:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
  802d43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4a:	79 05                	jns    802d51 <devfile_write+0xbd>
		return r;
  802d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4f:	eb 43                	jmp    802d94 <devfile_write+0x100>
	assert(r <= n);
  802d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d54:	48 98                	cltq   
  802d56:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d5a:	76 35                	jbe    802d91 <devfile_write+0xfd>
  802d5c:	48 b9 55 45 80 00 00 	movabs $0x804555,%rcx
  802d63:	00 00 00 
  802d66:	48 ba 5c 45 80 00 00 	movabs $0x80455c,%rdx
  802d6d:	00 00 00 
  802d70:	be a2 00 00 00       	mov    $0xa2,%esi
  802d75:	48 bf 71 45 80 00 00 	movabs $0x804571,%rdi
  802d7c:	00 00 00 
  802d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d84:	49 b8 54 39 80 00 00 	movabs $0x803954,%r8
  802d8b:	00 00 00 
  802d8e:	41 ff d0             	callq  *%r8
	return r;
  802d91:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802d94:	c9                   	leaveq 
  802d95:	c3                   	retq   

0000000000802d96 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d96:	55                   	push   %rbp
  802d97:	48 89 e5             	mov    %rsp,%rbp
  802d9a:	48 83 ec 20          	sub    $0x20,%rsp
  802d9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802da2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daa:	8b 50 0c             	mov    0xc(%rax),%edx
  802dad:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802db4:	00 00 00 
  802db7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802db9:	be 00 00 00 00       	mov    $0x0,%esi
  802dbe:	bf 05 00 00 00       	mov    $0x5,%edi
  802dc3:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
  802dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd6:	79 05                	jns    802ddd <devfile_stat+0x47>
		return r;
  802dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddb:	eb 56                	jmp    802e33 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ddd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802de8:	00 00 00 
  802deb:	48 89 c7             	mov    %rax,%rdi
  802dee:	48 b8 e9 0e 80 00 00 	movabs $0x800ee9,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802dfa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e01:	00 00 00 
  802e04:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e0e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1b:	00 00 00 
  802e1e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e28:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e33:	c9                   	leaveq 
  802e34:	c3                   	retq   

0000000000802e35 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e35:	55                   	push   %rbp
  802e36:	48 89 e5             	mov    %rsp,%rbp
  802e39:	48 83 ec 10          	sub    $0x10,%rsp
  802e3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e41:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e48:	8b 50 0c             	mov    0xc(%rax),%edx
  802e4b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e52:	00 00 00 
  802e55:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e5e:	00 00 00 
  802e61:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e67:	be 00 00 00 00       	mov    $0x0,%esi
  802e6c:	bf 02 00 00 00       	mov    $0x2,%edi
  802e71:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax
}
  802e7d:	c9                   	leaveq 
  802e7e:	c3                   	retq   

0000000000802e7f <remove>:

// Delete a file
int
remove(const char *path)
{
  802e7f:	55                   	push   %rbp
  802e80:	48 89 e5             	mov    %rsp,%rbp
  802e83:	48 83 ec 10          	sub    $0x10,%rsp
  802e87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8f:	48 89 c7             	mov    %rax,%rdi
  802e92:	48 b8 7d 0e 80 00 00 	movabs $0x800e7d,%rax
  802e99:	00 00 00 
  802e9c:	ff d0                	callq  *%rax
  802e9e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ea3:	7e 07                	jle    802eac <remove+0x2d>
		return -E_BAD_PATH;
  802ea5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802eaa:	eb 33                	jmp    802edf <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb0:	48 89 c6             	mov    %rax,%rsi
  802eb3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802eba:	00 00 00 
  802ebd:	48 b8 e9 0e 80 00 00 	movabs $0x800ee9,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ec9:	be 00 00 00 00       	mov    $0x0,%esi
  802ece:	bf 07 00 00 00       	mov    $0x7,%edi
  802ed3:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802eda:	00 00 00 
  802edd:	ff d0                	callq  *%rax
}
  802edf:	c9                   	leaveq 
  802ee0:	c3                   	retq   

0000000000802ee1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ee1:	55                   	push   %rbp
  802ee2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ee5:	be 00 00 00 00       	mov    $0x0,%esi
  802eea:	bf 08 00 00 00       	mov    $0x8,%edi
  802eef:	48 b8 f6 29 80 00 00 	movabs $0x8029f6,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
}
  802efb:	5d                   	pop    %rbp
  802efc:	c3                   	retq   

0000000000802efd <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802efd:	55                   	push   %rbp
  802efe:	48 89 e5             	mov    %rsp,%rbp
  802f01:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802f08:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f0f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f16:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f1d:	be 00 00 00 00       	mov    $0x0,%esi
  802f22:	48 89 c7             	mov    %rax,%rdi
  802f25:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
  802f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f38:	79 28                	jns    802f62 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3d:	89 c6                	mov    %eax,%esi
  802f3f:	48 bf b5 45 80 00 00 	movabs $0x8045b5,%rdi
  802f46:	00 00 00 
  802f49:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4e:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  802f55:	00 00 00 
  802f58:	ff d2                	callq  *%rdx
		return fd_src;
  802f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5d:	e9 74 01 00 00       	jmpq   8030d6 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f62:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f69:	be 01 01 00 00       	mov    $0x101,%esi
  802f6e:	48 89 c7             	mov    %rax,%rdi
  802f71:	48 b8 7d 2a 80 00 00 	movabs $0x802a7d,%rax
  802f78:	00 00 00 
  802f7b:	ff d0                	callq  *%rax
  802f7d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f80:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f84:	79 39                	jns    802fbf <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f89:	89 c6                	mov    %eax,%esi
  802f8b:	48 bf cb 45 80 00 00 	movabs $0x8045cb,%rdi
  802f92:	00 00 00 
  802f95:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9a:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  802fa1:	00 00 00 
  802fa4:	ff d2                	callq  *%rdx
		close(fd_src);
  802fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa9:	89 c7                	mov    %eax,%edi
  802fab:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
		return fd_dest;
  802fb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fba:	e9 17 01 00 00       	jmpq   8030d6 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fbf:	eb 74                	jmp    803035 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fc1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fc4:	48 63 d0             	movslq %eax,%rdx
  802fc7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fd1:	48 89 ce             	mov    %rcx,%rsi
  802fd4:	89 c7                	mov    %eax,%edi
  802fd6:	48 b8 f1 26 80 00 00 	movabs $0x8026f1,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
  802fe2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802fe9:	79 4a                	jns    803035 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802feb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fee:	89 c6                	mov    %eax,%esi
  802ff0:	48 bf e5 45 80 00 00 	movabs $0x8045e5,%rdi
  802ff7:	00 00 00 
  802ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  802fff:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  803006:	00 00 00 
  803009:	ff d2                	callq  *%rdx
			close(fd_src);
  80300b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300e:	89 c7                	mov    %eax,%edi
  803010:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
			close(fd_dest);
  80301c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80301f:	89 c7                	mov    %eax,%edi
  803021:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
			return write_size;
  80302d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803030:	e9 a1 00 00 00       	jmpq   8030d6 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803035:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80303c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303f:	ba 00 02 00 00       	mov    $0x200,%edx
  803044:	48 89 ce             	mov    %rcx,%rsi
  803047:	89 c7                	mov    %eax,%edi
  803049:	48 b8 a7 25 80 00 00 	movabs $0x8025a7,%rax
  803050:	00 00 00 
  803053:	ff d0                	callq  *%rax
  803055:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803058:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80305c:	0f 8f 5f ff ff ff    	jg     802fc1 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803062:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803066:	79 47                	jns    8030af <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803068:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80306b:	89 c6                	mov    %eax,%esi
  80306d:	48 bf f8 45 80 00 00 	movabs $0x8045f8,%rdi
  803074:	00 00 00 
  803077:	b8 00 00 00 00       	mov    $0x0,%eax
  80307c:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  803083:	00 00 00 
  803086:	ff d2                	callq  *%rdx
		close(fd_src);
  803088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308b:	89 c7                	mov    %eax,%edi
  80308d:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  803094:	00 00 00 
  803097:	ff d0                	callq  *%rax
		close(fd_dest);
  803099:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80309c:	89 c7                	mov    %eax,%edi
  80309e:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
		return read_size;
  8030aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030ad:	eb 27                	jmp    8030d6 <copy+0x1d9>
	}
	close(fd_src);
  8030af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b2:	89 c7                	mov    %eax,%edi
  8030b4:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
	close(fd_dest);
  8030c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c3:	89 c7                	mov    %eax,%edi
  8030c5:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
	return 0;
  8030d1:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8030d6:	c9                   	leaveq 
  8030d7:	c3                   	retq   

00000000008030d8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030d8:	55                   	push   %rbp
  8030d9:	48 89 e5             	mov    %rsp,%rbp
  8030dc:	53                   	push   %rbx
  8030dd:	48 83 ec 38          	sub    $0x38,%rsp
  8030e1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030e5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8030e9:	48 89 c7             	mov    %rax,%rdi
  8030ec:	48 b8 dd 20 80 00 00 	movabs $0x8020dd,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030ff:	0f 88 bf 01 00 00    	js     8032c4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803105:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803109:	ba 07 04 00 00       	mov    $0x407,%edx
  80310e:	48 89 c6             	mov    %rax,%rsi
  803111:	bf 00 00 00 00       	mov    $0x0,%edi
  803116:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
  803122:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803125:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803129:	0f 88 95 01 00 00    	js     8032c4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80312f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803133:	48 89 c7             	mov    %rax,%rdi
  803136:	48 b8 dd 20 80 00 00 	movabs $0x8020dd,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
  803142:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803145:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803149:	0f 88 5d 01 00 00    	js     8032ac <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80314f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803153:	ba 07 04 00 00       	mov    $0x407,%edx
  803158:	48 89 c6             	mov    %rax,%rsi
  80315b:	bf 00 00 00 00       	mov    $0x0,%edi
  803160:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
  80316c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80316f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803173:	0f 88 33 01 00 00    	js     8032ac <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803179:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317d:	48 89 c7             	mov    %rax,%rdi
  803180:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  803187:	00 00 00 
  80318a:	ff d0                	callq  *%rax
  80318c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803190:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803194:	ba 07 04 00 00       	mov    $0x407,%edx
  803199:	48 89 c6             	mov    %rax,%rsi
  80319c:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a1:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031b4:	79 05                	jns    8031bb <pipe+0xe3>
		goto err2;
  8031b6:	e9 d9 00 00 00       	jmpq   803294 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031bf:	48 89 c7             	mov    %rax,%rdi
  8031c2:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  8031c9:	00 00 00 
  8031cc:	ff d0                	callq  *%rax
  8031ce:	48 89 c2             	mov    %rax,%rdx
  8031d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031db:	48 89 d1             	mov    %rdx,%rcx
  8031de:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e3:	48 89 c6             	mov    %rax,%rsi
  8031e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8031eb:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
  8031f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031fe:	79 1b                	jns    80321b <pipe+0x143>
		goto err3;
  803200:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803201:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803205:	48 89 c6             	mov    %rax,%rsi
  803208:	bf 00 00 00 00       	mov    $0x0,%edi
  80320d:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  803214:	00 00 00 
  803217:	ff d0                	callq  *%rax
  803219:	eb 79                	jmp    803294 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80321b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803226:	00 00 00 
  803229:	8b 12                	mov    (%rdx),%edx
  80322b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80322d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803231:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803238:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80323c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803243:	00 00 00 
  803246:	8b 12                	mov    (%rdx),%edx
  803248:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80324a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80324e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803255:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803259:	48 89 c7             	mov    %rax,%rdi
  80325c:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
  803268:	89 c2                	mov    %eax,%edx
  80326a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80326e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803270:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803274:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327c:	48 89 c7             	mov    %rax,%rdi
  80327f:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
  80328b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80328d:	b8 00 00 00 00       	mov    $0x0,%eax
  803292:	eb 33                	jmp    8032c7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803294:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803298:	48 89 c6             	mov    %rax,%rsi
  80329b:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a0:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8032ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b0:	48 89 c6             	mov    %rax,%rsi
  8032b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b8:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  8032bf:	00 00 00 
  8032c2:	ff d0                	callq  *%rax
err:
	return r;
  8032c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032c7:	48 83 c4 38          	add    $0x38,%rsp
  8032cb:	5b                   	pop    %rbx
  8032cc:	5d                   	pop    %rbp
  8032cd:	c3                   	retq   

00000000008032ce <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032ce:	55                   	push   %rbp
  8032cf:	48 89 e5             	mov    %rsp,%rbp
  8032d2:	53                   	push   %rbx
  8032d3:	48 83 ec 28          	sub    $0x28,%rsp
  8032d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032df:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032e6:	00 00 00 
  8032e9:	48 8b 00             	mov    (%rax),%rax
  8032ec:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8032f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f9:	48 89 c7             	mov    %rax,%rdi
  8032fc:	48 b8 8d 3d 80 00 00 	movabs $0x803d8d,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	89 c3                	mov    %eax,%ebx
  80330a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330e:	48 89 c7             	mov    %rax,%rdi
  803311:	48 b8 8d 3d 80 00 00 	movabs $0x803d8d,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
  80331d:	39 c3                	cmp    %eax,%ebx
  80331f:	0f 94 c0             	sete   %al
  803322:	0f b6 c0             	movzbl %al,%eax
  803325:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803328:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80332f:	00 00 00 
  803332:	48 8b 00             	mov    (%rax),%rax
  803335:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80333b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80333e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803341:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803344:	75 05                	jne    80334b <_pipeisclosed+0x7d>
			return ret;
  803346:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803349:	eb 4f                	jmp    80339a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80334b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80334e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803351:	74 42                	je     803395 <_pipeisclosed+0xc7>
  803353:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803357:	75 3c                	jne    803395 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803359:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803360:	00 00 00 
  803363:	48 8b 00             	mov    (%rax),%rax
  803366:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80336c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80336f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803372:	89 c6                	mov    %eax,%esi
  803374:	48 bf 13 46 80 00 00 	movabs $0x804613,%rdi
  80337b:	00 00 00 
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	49 b8 21 03 80 00 00 	movabs $0x800321,%r8
  80338a:	00 00 00 
  80338d:	41 ff d0             	callq  *%r8
	}
  803390:	e9 4a ff ff ff       	jmpq   8032df <_pipeisclosed+0x11>
  803395:	e9 45 ff ff ff       	jmpq   8032df <_pipeisclosed+0x11>
}
  80339a:	48 83 c4 28          	add    $0x28,%rsp
  80339e:	5b                   	pop    %rbx
  80339f:	5d                   	pop    %rbp
  8033a0:	c3                   	retq   

00000000008033a1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033a1:	55                   	push   %rbp
  8033a2:	48 89 e5             	mov    %rsp,%rbp
  8033a5:	48 83 ec 30          	sub    $0x30,%rsp
  8033a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033b3:	48 89 d6             	mov    %rdx,%rsi
  8033b6:	89 c7                	mov    %eax,%edi
  8033b8:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
  8033c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cb:	79 05                	jns    8033d2 <pipeisclosed+0x31>
		return r;
  8033cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d0:	eb 31                	jmp    803403 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8033d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d6:	48 89 c7             	mov    %rax,%rdi
  8033d9:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  8033e0:	00 00 00 
  8033e3:	ff d0                	callq  *%rax
  8033e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8033e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033f1:	48 89 d6             	mov    %rdx,%rsi
  8033f4:	48 89 c7             	mov    %rax,%rdi
  8033f7:	48 b8 ce 32 80 00 00 	movabs $0x8032ce,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
}
  803403:	c9                   	leaveq 
  803404:	c3                   	retq   

0000000000803405 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803405:	55                   	push   %rbp
  803406:	48 89 e5             	mov    %rsp,%rbp
  803409:	48 83 ec 40          	sub    $0x40,%rsp
  80340d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803411:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803415:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803419:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803430:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803434:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803438:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80343f:	00 
  803440:	e9 92 00 00 00       	jmpq   8034d7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803445:	eb 41                	jmp    803488 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803447:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80344c:	74 09                	je     803457 <devpipe_read+0x52>
				return i;
  80344e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803452:	e9 92 00 00 00       	jmpq   8034e9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803457:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80345b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80345f:	48 89 d6             	mov    %rdx,%rsi
  803462:	48 89 c7             	mov    %rax,%rdi
  803465:	48 b8 ce 32 80 00 00 	movabs $0x8032ce,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	85 c0                	test   %eax,%eax
  803473:	74 07                	je     80347c <devpipe_read+0x77>
				return 0;
  803475:	b8 00 00 00 00       	mov    $0x0,%eax
  80347a:	eb 6d                	jmp    8034e9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80347c:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  803483:	00 00 00 
  803486:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348c:	8b 10                	mov    (%rax),%edx
  80348e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803492:	8b 40 04             	mov    0x4(%rax),%eax
  803495:	39 c2                	cmp    %eax,%edx
  803497:	74 ae                	je     803447 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034a1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a9:	8b 00                	mov    (%rax),%eax
  8034ab:	99                   	cltd   
  8034ac:	c1 ea 1b             	shr    $0x1b,%edx
  8034af:	01 d0                	add    %edx,%eax
  8034b1:	83 e0 1f             	and    $0x1f,%eax
  8034b4:	29 d0                	sub    %edx,%eax
  8034b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034ba:	48 98                	cltq   
  8034bc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8034c1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8034c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c7:	8b 00                	mov    (%rax),%eax
  8034c9:	8d 50 01             	lea    0x1(%rax),%edx
  8034cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034db:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034df:	0f 82 60 ff ff ff    	jb     803445 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8034e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034e9:	c9                   	leaveq 
  8034ea:	c3                   	retq   

00000000008034eb <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034eb:	55                   	push   %rbp
  8034ec:	48 89 e5             	mov    %rsp,%rbp
  8034ef:	48 83 ec 40          	sub    $0x40,%rsp
  8034f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8034ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803503:	48 89 c7             	mov    %rax,%rdi
  803506:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803516:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80351e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803525:	00 
  803526:	e9 8e 00 00 00       	jmpq   8035b9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80352b:	eb 31                	jmp    80355e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80352d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803535:	48 89 d6             	mov    %rdx,%rsi
  803538:	48 89 c7             	mov    %rax,%rdi
  80353b:	48 b8 ce 32 80 00 00 	movabs $0x8032ce,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
  803547:	85 c0                	test   %eax,%eax
  803549:	74 07                	je     803552 <devpipe_write+0x67>
				return 0;
  80354b:	b8 00 00 00 00       	mov    $0x0,%eax
  803550:	eb 79                	jmp    8035cb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803552:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80355e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803562:	8b 40 04             	mov    0x4(%rax),%eax
  803565:	48 63 d0             	movslq %eax,%rdx
  803568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356c:	8b 00                	mov    (%rax),%eax
  80356e:	48 98                	cltq   
  803570:	48 83 c0 20          	add    $0x20,%rax
  803574:	48 39 c2             	cmp    %rax,%rdx
  803577:	73 b4                	jae    80352d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357d:	8b 40 04             	mov    0x4(%rax),%eax
  803580:	99                   	cltd   
  803581:	c1 ea 1b             	shr    $0x1b,%edx
  803584:	01 d0                	add    %edx,%eax
  803586:	83 e0 1f             	and    $0x1f,%eax
  803589:	29 d0                	sub    %edx,%eax
  80358b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80358f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803593:	48 01 ca             	add    %rcx,%rdx
  803596:	0f b6 0a             	movzbl (%rdx),%ecx
  803599:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80359d:	48 98                	cltq   
  80359f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a7:	8b 40 04             	mov    0x4(%rax),%eax
  8035aa:	8d 50 01             	lea    0x1(%rax),%edx
  8035ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035bd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035c1:	0f 82 64 ff ff ff    	jb     80352b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035cb:	c9                   	leaveq 
  8035cc:	c3                   	retq   

00000000008035cd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8035cd:	55                   	push   %rbp
  8035ce:	48 89 e5             	mov    %rsp,%rbp
  8035d1:	48 83 ec 20          	sub    $0x20,%rsp
  8035d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e1:	48 89 c7             	mov    %rax,%rdi
  8035e4:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
  8035f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8035f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f8:	48 be 26 46 80 00 00 	movabs $0x804626,%rsi
  8035ff:	00 00 00 
  803602:	48 89 c7             	mov    %rax,%rdi
  803605:	48 b8 e9 0e 80 00 00 	movabs $0x800ee9,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803615:	8b 50 04             	mov    0x4(%rax),%edx
  803618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361c:	8b 00                	mov    (%rax),%eax
  80361e:	29 c2                	sub    %eax,%edx
  803620:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803624:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80362a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80362e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803635:	00 00 00 
	stat->st_dev = &devpipe;
  803638:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80363c:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803643:	00 00 00 
  803646:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80364d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803652:	c9                   	leaveq 
  803653:	c3                   	retq   

0000000000803654 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803654:	55                   	push   %rbp
  803655:	48 89 e5             	mov    %rsp,%rbp
  803658:	48 83 ec 10          	sub    $0x10,%rsp
  80365c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803664:	48 89 c6             	mov    %rax,%rsi
  803667:	bf 00 00 00 00       	mov    $0x0,%edi
  80366c:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367c:	48 89 c7             	mov    %rax,%rdi
  80367f:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  803686:	00 00 00 
  803689:	ff d0                	callq  *%rax
  80368b:	48 89 c6             	mov    %rax,%rsi
  80368e:	bf 00 00 00 00       	mov    $0x0,%edi
  803693:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
}
  80369f:	c9                   	leaveq 
  8036a0:	c3                   	retq   

00000000008036a1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036a1:	55                   	push   %rbp
  8036a2:	48 89 e5             	mov    %rsp,%rbp
  8036a5:	48 83 ec 20          	sub    $0x20,%rsp
  8036a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8036ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036af:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8036b2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8036b6:	be 01 00 00 00       	mov    $0x1,%esi
  8036bb:	48 89 c7             	mov    %rax,%rdi
  8036be:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
}
  8036ca:	c9                   	leaveq 
  8036cb:	c3                   	retq   

00000000008036cc <getchar>:

int
getchar(void)
{
  8036cc:	55                   	push   %rbp
  8036cd:	48 89 e5             	mov    %rsp,%rbp
  8036d0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8036d4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036d8:	ba 01 00 00 00       	mov    $0x1,%edx
  8036dd:	48 89 c6             	mov    %rax,%rsi
  8036e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e5:	48 b8 a7 25 80 00 00 	movabs $0x8025a7,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8036f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f8:	79 05                	jns    8036ff <getchar+0x33>
		return r;
  8036fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fd:	eb 14                	jmp    803713 <getchar+0x47>
	if (r < 1)
  8036ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803703:	7f 07                	jg     80370c <getchar+0x40>
		return -E_EOF;
  803705:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80370a:	eb 07                	jmp    803713 <getchar+0x47>
	return c;
  80370c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803710:	0f b6 c0             	movzbl %al,%eax
}
  803713:	c9                   	leaveq 
  803714:	c3                   	retq   

0000000000803715 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803715:	55                   	push   %rbp
  803716:	48 89 e5             	mov    %rsp,%rbp
  803719:	48 83 ec 20          	sub    $0x20,%rsp
  80371d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803720:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803727:	48 89 d6             	mov    %rdx,%rsi
  80372a:	89 c7                	mov    %eax,%edi
  80372c:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
  803738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80373f:	79 05                	jns    803746 <iscons+0x31>
		return r;
  803741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803744:	eb 1a                	jmp    803760 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374a:	8b 10                	mov    (%rax),%edx
  80374c:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803753:	00 00 00 
  803756:	8b 00                	mov    (%rax),%eax
  803758:	39 c2                	cmp    %eax,%edx
  80375a:	0f 94 c0             	sete   %al
  80375d:	0f b6 c0             	movzbl %al,%eax
}
  803760:	c9                   	leaveq 
  803761:	c3                   	retq   

0000000000803762 <opencons>:

int
opencons(void)
{
  803762:	55                   	push   %rbp
  803763:	48 89 e5             	mov    %rsp,%rbp
  803766:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80376a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80376e:	48 89 c7             	mov    %rax,%rdi
  803771:	48 b8 dd 20 80 00 00 	movabs $0x8020dd,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
  80377d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803780:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803784:	79 05                	jns    80378b <opencons+0x29>
		return r;
  803786:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803789:	eb 5b                	jmp    8037e6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80378b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378f:	ba 07 04 00 00       	mov    $0x407,%edx
  803794:	48 89 c6             	mov    %rax,%rsi
  803797:	bf 00 00 00 00       	mov    $0x0,%edi
  80379c:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
  8037a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037af:	79 05                	jns    8037b6 <opencons+0x54>
		return r;
  8037b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b4:	eb 30                	jmp    8037e6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8037b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ba:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8037c1:	00 00 00 
  8037c4:	8b 12                	mov    (%rdx),%edx
  8037c6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8037c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8037d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d7:	48 89 c7             	mov    %rax,%rdi
  8037da:	48 b8 8f 20 80 00 00 	movabs $0x80208f,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
}
  8037e6:	c9                   	leaveq 
  8037e7:	c3                   	retq   

00000000008037e8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037e8:	55                   	push   %rbp
  8037e9:	48 89 e5             	mov    %rsp,%rbp
  8037ec:	48 83 ec 30          	sub    $0x30,%rsp
  8037f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8037fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803801:	75 07                	jne    80380a <devcons_read+0x22>
		return 0;
  803803:	b8 00 00 00 00       	mov    $0x0,%eax
  803808:	eb 4b                	jmp    803855 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80380a:	eb 0c                	jmp    803818 <devcons_read+0x30>
		sys_yield();
  80380c:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803818:	48 b8 1a 17 80 00 00 	movabs $0x80171a,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803827:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382b:	74 df                	je     80380c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80382d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803831:	79 05                	jns    803838 <devcons_read+0x50>
		return c;
  803833:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803836:	eb 1d                	jmp    803855 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803838:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80383c:	75 07                	jne    803845 <devcons_read+0x5d>
		return 0;
  80383e:	b8 00 00 00 00       	mov    $0x0,%eax
  803843:	eb 10                	jmp    803855 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803848:	89 c2                	mov    %eax,%edx
  80384a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80384e:	88 10                	mov    %dl,(%rax)
	return 1;
  803850:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803855:	c9                   	leaveq 
  803856:	c3                   	retq   

0000000000803857 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803857:	55                   	push   %rbp
  803858:	48 89 e5             	mov    %rsp,%rbp
  80385b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803862:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803869:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803870:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803877:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80387e:	eb 76                	jmp    8038f6 <devcons_write+0x9f>
		m = n - tot;
  803880:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803887:	89 c2                	mov    %eax,%edx
  803889:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388c:	29 c2                	sub    %eax,%edx
  80388e:	89 d0                	mov    %edx,%eax
  803890:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803893:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803896:	83 f8 7f             	cmp    $0x7f,%eax
  803899:	76 07                	jbe    8038a2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80389b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038a5:	48 63 d0             	movslq %eax,%rdx
  8038a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ab:	48 63 c8             	movslq %eax,%rcx
  8038ae:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8038b5:	48 01 c1             	add    %rax,%rcx
  8038b8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038bf:	48 89 ce             	mov    %rcx,%rsi
  8038c2:	48 89 c7             	mov    %rax,%rdi
  8038c5:	48 b8 0d 12 80 00 00 	movabs $0x80120d,%rax
  8038cc:	00 00 00 
  8038cf:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8038d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038d4:	48 63 d0             	movslq %eax,%rdx
  8038d7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038de:	48 89 d6             	mov    %rdx,%rsi
  8038e1:	48 89 c7             	mov    %rax,%rdi
  8038e4:	48 b8 d0 16 80 00 00 	movabs $0x8016d0,%rax
  8038eb:	00 00 00 
  8038ee:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038f3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f9:	48 98                	cltq   
  8038fb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803902:	0f 82 78 ff ff ff    	jb     803880 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803908:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80390b:	c9                   	leaveq 
  80390c:	c3                   	retq   

000000000080390d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80390d:	55                   	push   %rbp
  80390e:	48 89 e5             	mov    %rsp,%rbp
  803911:	48 83 ec 08          	sub    $0x8,%rsp
  803915:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80391e:	c9                   	leaveq 
  80391f:	c3                   	retq   

0000000000803920 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803920:	55                   	push   %rbp
  803921:	48 89 e5             	mov    %rsp,%rbp
  803924:	48 83 ec 10          	sub    $0x10,%rsp
  803928:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80392c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803934:	48 be 32 46 80 00 00 	movabs $0x804632,%rsi
  80393b:	00 00 00 
  80393e:	48 89 c7             	mov    %rax,%rdi
  803941:	48 b8 e9 0e 80 00 00 	movabs $0x800ee9,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
	return 0;
  80394d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803952:	c9                   	leaveq 
  803953:	c3                   	retq   

0000000000803954 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803954:	55                   	push   %rbp
  803955:	48 89 e5             	mov    %rsp,%rbp
  803958:	53                   	push   %rbx
  803959:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803960:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803967:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80396d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803974:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80397b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803982:	84 c0                	test   %al,%al
  803984:	74 23                	je     8039a9 <_panic+0x55>
  803986:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80398d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803991:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803995:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803999:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80399d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8039a1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8039a5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8039a9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8039b0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8039b7:	00 00 00 
  8039ba:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8039c1:	00 00 00 
  8039c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039c8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8039cf:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8039d6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8039dd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8039e4:	00 00 00 
  8039e7:	48 8b 18             	mov    (%rax),%rbx
  8039ea:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  8039f1:	00 00 00 
  8039f4:	ff d0                	callq  *%rax
  8039f6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8039fc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a03:	41 89 c8             	mov    %ecx,%r8d
  803a06:	48 89 d1             	mov    %rdx,%rcx
  803a09:	48 89 da             	mov    %rbx,%rdx
  803a0c:	89 c6                	mov    %eax,%esi
  803a0e:	48 bf 40 46 80 00 00 	movabs $0x804640,%rdi
  803a15:	00 00 00 
  803a18:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1d:	49 b9 21 03 80 00 00 	movabs $0x800321,%r9
  803a24:	00 00 00 
  803a27:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803a2a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803a31:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a38:	48 89 d6             	mov    %rdx,%rsi
  803a3b:	48 89 c7             	mov    %rax,%rdi
  803a3e:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
	cprintf("\n");
  803a4a:	48 bf 63 46 80 00 00 	movabs $0x804663,%rdi
  803a51:	00 00 00 
  803a54:	b8 00 00 00 00       	mov    $0x0,%eax
  803a59:	48 ba 21 03 80 00 00 	movabs $0x800321,%rdx
  803a60:	00 00 00 
  803a63:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a65:	cc                   	int3   
  803a66:	eb fd                	jmp    803a65 <_panic+0x111>

0000000000803a68 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a68:	55                   	push   %rbp
  803a69:	48 89 e5             	mov    %rsp,%rbp
  803a6c:	48 83 ec 10          	sub    $0x10,%rsp
  803a70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803a74:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803a7b:	00 00 00 
  803a7e:	48 8b 00             	mov    (%rax),%rax
  803a81:	48 85 c0             	test   %rax,%rax
  803a84:	75 49                	jne    803acf <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803a86:	ba 07 00 00 00       	mov    $0x7,%edx
  803a8b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803a90:	bf 00 00 00 00       	mov    $0x0,%edi
  803a95:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  803a9c:	00 00 00 
  803a9f:	ff d0                	callq  *%rax
  803aa1:	85 c0                	test   %eax,%eax
  803aa3:	79 2a                	jns    803acf <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803aa5:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  803aac:	00 00 00 
  803aaf:	be 21 00 00 00       	mov    $0x21,%esi
  803ab4:	48 bf 93 46 80 00 00 	movabs $0x804693,%rdi
  803abb:	00 00 00 
  803abe:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac3:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  803aca:	00 00 00 
  803acd:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803acf:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ad6:	00 00 00 
  803ad9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803add:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803ae0:	48 be 2b 3b 80 00 00 	movabs $0x803b2b,%rsi
  803ae7:	00 00 00 
  803aea:	bf 00 00 00 00       	mov    $0x0,%edi
  803aef:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
  803afb:	85 c0                	test   %eax,%eax
  803afd:	79 2a                	jns    803b29 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803aff:	48 ba a8 46 80 00 00 	movabs $0x8046a8,%rdx
  803b06:	00 00 00 
  803b09:	be 27 00 00 00       	mov    $0x27,%esi
  803b0e:	48 bf 93 46 80 00 00 	movabs $0x804693,%rdi
  803b15:	00 00 00 
  803b18:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1d:	48 b9 54 39 80 00 00 	movabs $0x803954,%rcx
  803b24:	00 00 00 
  803b27:	ff d1                	callq  *%rcx
}
  803b29:	c9                   	leaveq 
  803b2a:	c3                   	retq   

0000000000803b2b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803b2b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803b2e:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803b35:	00 00 00 
call *%rax
  803b38:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803b3a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b41:	00 
    movq 152(%rsp), %rcx
  803b42:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803b49:	00 
    subq $8, %rcx
  803b4a:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803b4e:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803b51:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803b58:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803b59:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803b5d:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b61:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b66:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b6b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b70:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b75:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b7a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803b7f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803b84:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803b89:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803b8e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803b93:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803b98:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803b9d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803ba2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803ba7:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803bab:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803baf:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803bb0:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803bb1:	c3                   	retq   

0000000000803bb2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803bb2:	55                   	push   %rbp
  803bb3:	48 89 e5             	mov    %rsp,%rbp
  803bb6:	48 83 ec 30          	sub    $0x30,%rsp
  803bba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bc2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803bc6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803bcb:	75 0e                	jne    803bdb <ipc_recv+0x29>
        pg = (void *)UTOP;
  803bcd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803bd4:	00 00 00 
  803bd7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803bdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bdf:	48 89 c7             	mov    %rax,%rdi
  803be2:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
  803bee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf5:	79 27                	jns    803c1e <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803bf7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803bfc:	74 0a                	je     803c08 <ipc_recv+0x56>
            *from_env_store = 0;
  803bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c02:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803c08:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c0d:	74 0a                	je     803c19 <ipc_recv+0x67>
            *perm_store = 0;
  803c0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c13:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1c:	eb 53                	jmp    803c71 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803c1e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c23:	74 19                	je     803c3e <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803c25:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c2c:	00 00 00 
  803c2f:	48 8b 00             	mov    (%rax),%rax
  803c32:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c3c:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803c3e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c43:	74 19                	je     803c5e <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803c45:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c4c:	00 00 00 
  803c4f:	48 8b 00             	mov    (%rax),%rax
  803c52:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c5c:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803c5e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c65:	00 00 00 
  803c68:	48 8b 00             	mov    (%rax),%rax
  803c6b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803c71:	c9                   	leaveq 
  803c72:	c3                   	retq   

0000000000803c73 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c73:	55                   	push   %rbp
  803c74:	48 89 e5             	mov    %rsp,%rbp
  803c77:	48 83 ec 30          	sub    $0x30,%rsp
  803c7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c7e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c81:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c85:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803c88:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c8d:	75 0e                	jne    803c9d <ipc_send+0x2a>
        pg = (void *)UTOP;
  803c8f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c96:	00 00 00 
  803c99:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803c9d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ca0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ca3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ca7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803caa:	89 c7                	mov    %eax,%edi
  803cac:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
  803cb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803cbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cbf:	79 36                	jns    803cf7 <ipc_send+0x84>
  803cc1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803cc5:	74 30                	je     803cf7 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cca:	89 c1                	mov    %eax,%ecx
  803ccc:	48 ba df 46 80 00 00 	movabs $0x8046df,%rdx
  803cd3:	00 00 00 
  803cd6:	be 49 00 00 00       	mov    $0x49,%esi
  803cdb:	48 bf ec 46 80 00 00 	movabs $0x8046ec,%rdi
  803ce2:	00 00 00 
  803ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  803cea:	49 b8 54 39 80 00 00 	movabs $0x803954,%r8
  803cf1:	00 00 00 
  803cf4:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803cf7:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  803cfe:	00 00 00 
  803d01:	ff d0                	callq  *%rax
    } while(r != 0);
  803d03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d07:	75 94                	jne    803c9d <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803d09:	c9                   	leaveq 
  803d0a:	c3                   	retq   

0000000000803d0b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d0b:	55                   	push   %rbp
  803d0c:	48 89 e5             	mov    %rsp,%rbp
  803d0f:	48 83 ec 14          	sub    $0x14,%rsp
  803d13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d1d:	eb 5e                	jmp    803d7d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d1f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d26:	00 00 00 
  803d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d2c:	48 63 d0             	movslq %eax,%rdx
  803d2f:	48 89 d0             	mov    %rdx,%rax
  803d32:	48 c1 e0 03          	shl    $0x3,%rax
  803d36:	48 01 d0             	add    %rdx,%rax
  803d39:	48 c1 e0 05          	shl    $0x5,%rax
  803d3d:	48 01 c8             	add    %rcx,%rax
  803d40:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d46:	8b 00                	mov    (%rax),%eax
  803d48:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d4b:	75 2c                	jne    803d79 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d4d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d54:	00 00 00 
  803d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5a:	48 63 d0             	movslq %eax,%rdx
  803d5d:	48 89 d0             	mov    %rdx,%rax
  803d60:	48 c1 e0 03          	shl    $0x3,%rax
  803d64:	48 01 d0             	add    %rdx,%rax
  803d67:	48 c1 e0 05          	shl    $0x5,%rax
  803d6b:	48 01 c8             	add    %rcx,%rax
  803d6e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d74:	8b 40 08             	mov    0x8(%rax),%eax
  803d77:	eb 12                	jmp    803d8b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803d79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d7d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d84:	7e 99                	jle    803d1f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d8b:	c9                   	leaveq 
  803d8c:	c3                   	retq   

0000000000803d8d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d8d:	55                   	push   %rbp
  803d8e:	48 89 e5             	mov    %rsp,%rbp
  803d91:	48 83 ec 18          	sub    $0x18,%rsp
  803d95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d9d:	48 c1 e8 15          	shr    $0x15,%rax
  803da1:	48 89 c2             	mov    %rax,%rdx
  803da4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803dab:	01 00 00 
  803dae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803db2:	83 e0 01             	and    $0x1,%eax
  803db5:	48 85 c0             	test   %rax,%rax
  803db8:	75 07                	jne    803dc1 <pageref+0x34>
		return 0;
  803dba:	b8 00 00 00 00       	mov    $0x0,%eax
  803dbf:	eb 53                	jmp    803e14 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dc5:	48 c1 e8 0c          	shr    $0xc,%rax
  803dc9:	48 89 c2             	mov    %rax,%rdx
  803dcc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dd3:	01 00 00 
  803dd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803dde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de2:	83 e0 01             	and    $0x1,%eax
  803de5:	48 85 c0             	test   %rax,%rax
  803de8:	75 07                	jne    803df1 <pageref+0x64>
		return 0;
  803dea:	b8 00 00 00 00       	mov    $0x0,%eax
  803def:	eb 23                	jmp    803e14 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df5:	48 c1 e8 0c          	shr    $0xc,%rax
  803df9:	48 89 c2             	mov    %rax,%rdx
  803dfc:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e03:	00 00 00 
  803e06:	48 c1 e2 04          	shl    $0x4,%rdx
  803e0a:	48 01 d0             	add    %rdx,%rax
  803e0d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e11:	0f b7 c0             	movzwl %ax,%eax
}
  803e14:	c9                   	leaveq 
  803e15:	c3                   	retq   
