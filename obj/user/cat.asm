
obj/user/cat:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 fc 22 80 00 00 	movabs $0x8022fc,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba e0 3a 80 00 00 	movabs $0x803ae0,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf fb 3a 80 00 00 	movabs $0x803afb,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 fd 02 80 00 00 	movabs $0x8002fd,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba 06 3b 80 00 00 	movabs $0x803b06,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf fb 3a 80 00 00 	movabs $0x803afb,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 fd 02 80 00 00 	movabs $0x8002fd,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800146:	00 00 00 
  800149:	48 bb 1b 3b 80 00 00 	movabs $0x803b1b,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be 1f 3b 80 00 00 	movabs $0x803b1f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf 27 3b 80 00 00 	movabs $0x803b27,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 31 2f 80 00 00 	movabs $0x802f31,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 20          	sub    $0x20,%rsp
  800251:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800258:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026f:	48 63 d0             	movslq %eax,%rdx
  800272:	48 89 d0             	mov    %rdx,%rax
  800275:	48 c1 e0 03          	shl    $0x3,%rax
  800279:	48 01 d0             	add    %rdx,%rax
  80027c:	48 c1 e0 05          	shl    $0x5,%rax
  800280:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800287:	00 00 00 
  80028a:	48 01 c2             	add    %rax,%rdx
  80028d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800294:	00 00 00 
  800297:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80029e:	7e 14                	jle    8002b4 <libmain+0x6b>
		binaryname = argv[0];
  8002a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002a4:	48 8b 10             	mov    (%rax),%rdx
  8002a7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002ae:	00 00 00 
  8002b1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bb:	48 89 d6             	mov    %rdx,%rsi
  8002be:	89 c7                	mov    %eax,%edi
  8002c0:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002c7:	00 00 00 
  8002ca:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002cc:	48 b8 da 02 80 00 00 	movabs $0x8002da,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
}
  8002d8:	c9                   	leaveq 
  8002d9:	c3                   	retq   

00000000008002da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002da:	55                   	push   %rbp
  8002db:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002de:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  8002e5:	00 00 00 
  8002e8:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ef:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  8002f6:	00 00 00 
  8002f9:	ff d0                	callq  *%rax
}
  8002fb:	5d                   	pop    %rbp
  8002fc:	c3                   	retq   

00000000008002fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fd:	55                   	push   %rbp
  8002fe:	48 89 e5             	mov    %rsp,%rbp
  800301:	53                   	push   %rbx
  800302:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800309:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800310:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800316:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80031d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800324:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80032b:	84 c0                	test   %al,%al
  80032d:	74 23                	je     800352 <_panic+0x55>
  80032f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800336:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80033a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80033e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800342:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800346:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80034a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80034e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800352:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800359:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800360:	00 00 00 
  800363:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80036a:	00 00 00 
  80036d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800371:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800378:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80037f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800386:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80038d:	00 00 00 
  800390:	48 8b 18             	mov    (%rax),%rbx
  800393:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  80039a:	00 00 00 
  80039d:	ff d0                	callq  *%rax
  80039f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003a5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003ac:	41 89 c8             	mov    %ecx,%r8d
  8003af:	48 89 d1             	mov    %rdx,%rcx
  8003b2:	48 89 da             	mov    %rbx,%rdx
  8003b5:	89 c6                	mov    %eax,%esi
  8003b7:	48 bf 48 3b 80 00 00 	movabs $0x803b48,%rdi
  8003be:	00 00 00 
  8003c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c6:	49 b9 36 05 80 00 00 	movabs $0x800536,%r9
  8003cd:	00 00 00 
  8003d0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003da:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e1:	48 89 d6             	mov    %rdx,%rsi
  8003e4:	48 89 c7             	mov    %rax,%rdi
  8003e7:	48 b8 8a 04 80 00 00 	movabs $0x80048a,%rax
  8003ee:	00 00 00 
  8003f1:	ff d0                	callq  *%rax
	cprintf("\n");
  8003f3:	48 bf 6b 3b 80 00 00 	movabs $0x803b6b,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	48 ba 36 05 80 00 00 	movabs $0x800536,%rdx
  800409:	00 00 00 
  80040c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80040e:	cc                   	int3   
  80040f:	eb fd                	jmp    80040e <_panic+0x111>

0000000000800411 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800411:	55                   	push   %rbp
  800412:	48 89 e5             	mov    %rsp,%rbp
  800415:	48 83 ec 10          	sub    $0x10,%rsp
  800419:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800424:	8b 00                	mov    (%rax),%eax
  800426:	8d 48 01             	lea    0x1(%rax),%ecx
  800429:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042d:	89 0a                	mov    %ecx,(%rdx)
  80042f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800432:	89 d1                	mov    %edx,%ecx
  800434:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800438:	48 98                	cltq   
  80043a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80043e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800442:	8b 00                	mov    (%rax),%eax
  800444:	3d ff 00 00 00       	cmp    $0xff,%eax
  800449:	75 2c                	jne    800477 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80044b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044f:	8b 00                	mov    (%rax),%eax
  800451:	48 98                	cltq   
  800453:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800457:	48 83 c2 08          	add    $0x8,%rdx
  80045b:	48 89 c6             	mov    %rax,%rsi
  80045e:	48 89 d7             	mov    %rdx,%rdi
  800461:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  800468:	00 00 00 
  80046b:	ff d0                	callq  *%rax
        b->idx = 0;
  80046d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800471:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047b:	8b 40 04             	mov    0x4(%rax),%eax
  80047e:	8d 50 01             	lea    0x1(%rax),%edx
  800481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800485:	89 50 04             	mov    %edx,0x4(%rax)
}
  800488:	c9                   	leaveq 
  800489:	c3                   	retq   

000000000080048a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800495:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80049c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004a3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004aa:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004b1:	48 8b 0a             	mov    (%rdx),%rcx
  8004b4:	48 89 08             	mov    %rcx,(%rax)
  8004b7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004bb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004bf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004ce:	00 00 00 
    b.cnt = 0;
  8004d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d8:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004db:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004e2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004f0:	48 89 c6             	mov    %rax,%rsi
  8004f3:	48 bf 11 04 80 00 00 	movabs $0x800411,%rdi
  8004fa:	00 00 00 
  8004fd:	48 b8 e9 08 80 00 00 	movabs $0x8008e9,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800509:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80050f:	48 98                	cltq   
  800511:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800518:	48 83 c2 08          	add    $0x8,%rdx
  80051c:	48 89 c6             	mov    %rax,%rsi
  80051f:	48 89 d7             	mov    %rdx,%rdi
  800522:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  800529:	00 00 00 
  80052c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800534:	c9                   	leaveq 
  800535:	c3                   	retq   

0000000000800536 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800536:	55                   	push   %rbp
  800537:	48 89 e5             	mov    %rsp,%rbp
  80053a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800541:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800548:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80054f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800556:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80055d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800564:	84 c0                	test   %al,%al
  800566:	74 20                	je     800588 <cprintf+0x52>
  800568:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80056c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800570:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800574:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800578:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80057c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800580:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800584:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800588:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80058f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800596:	00 00 00 
  800599:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005a0:	00 00 00 
  8005a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005b5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005bc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005ca:	48 8b 0a             	mov    (%rdx),%rcx
  8005cd:	48 89 08             	mov    %rcx,(%rax)
  8005d0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005d4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005dc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005e0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ee:	48 89 d6             	mov    %rdx,%rsi
  8005f1:	48 89 c7             	mov    %rax,%rdi
  8005f4:	48 b8 8a 04 80 00 00 	movabs $0x80048a,%rax
  8005fb:	00 00 00 
  8005fe:	ff d0                	callq  *%rax
  800600:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800606:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80060c:	c9                   	leaveq 
  80060d:	c3                   	retq   

000000000080060e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060e:	55                   	push   %rbp
  80060f:	48 89 e5             	mov    %rsp,%rbp
  800612:	53                   	push   %rbx
  800613:	48 83 ec 38          	sub    $0x38,%rsp
  800617:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80061b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80061f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800623:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800626:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80062a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800631:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800635:	77 3b                	ja     800672 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800637:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80063a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80063e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800645:	ba 00 00 00 00       	mov    $0x0,%edx
  80064a:	48 f7 f3             	div    %rbx
  80064d:	48 89 c2             	mov    %rax,%rdx
  800650:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800653:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800656:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	41 89 f9             	mov    %edi,%r9d
  800661:	48 89 c7             	mov    %rax,%rdi
  800664:	48 b8 0e 06 80 00 00 	movabs $0x80060e,%rax
  80066b:	00 00 00 
  80066e:	ff d0                	callq  *%rax
  800670:	eb 1e                	jmp    800690 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800672:	eb 12                	jmp    800686 <printnum+0x78>
			putch(padc, putdat);
  800674:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800678:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80067b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067f:	48 89 ce             	mov    %rcx,%rsi
  800682:	89 d7                	mov    %edx,%edi
  800684:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800686:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80068a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80068e:	7f e4                	jg     800674 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800690:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
  80069c:	48 f7 f1             	div    %rcx
  80069f:	48 89 d0             	mov    %rdx,%rax
  8006a2:	48 ba 70 3d 80 00 00 	movabs $0x803d70,%rdx
  8006a9:	00 00 00 
  8006ac:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006b0:	0f be d0             	movsbl %al,%edx
  8006b3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bb:	48 89 ce             	mov    %rcx,%rsi
  8006be:	89 d7                	mov    %edx,%edi
  8006c0:	ff d0                	callq  *%rax
}
  8006c2:	48 83 c4 38          	add    $0x38,%rsp
  8006c6:	5b                   	pop    %rbx
  8006c7:	5d                   	pop    %rbp
  8006c8:	c3                   	retq   

00000000008006c9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c9:	55                   	push   %rbp
  8006ca:	48 89 e5             	mov    %rsp,%rbp
  8006cd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8006d8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006dc:	7e 52                	jle    800730 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	8b 00                	mov    (%rax),%eax
  8006e4:	83 f8 30             	cmp    $0x30,%eax
  8006e7:	73 24                	jae    80070d <getuint+0x44>
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	89 c0                	mov    %eax,%eax
  8006f9:	48 01 d0             	add    %rdx,%rax
  8006fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800700:	8b 12                	mov    (%rdx),%edx
  800702:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	89 0a                	mov    %ecx,(%rdx)
  80070b:	eb 17                	jmp    800724 <getuint+0x5b>
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800715:	48 89 d0             	mov    %rdx,%rax
  800718:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800724:	48 8b 00             	mov    (%rax),%rax
  800727:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072b:	e9 a3 00 00 00       	jmpq   8007d3 <getuint+0x10a>
	else if (lflag)
  800730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800734:	74 4f                	je     800785 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	83 f8 30             	cmp    $0x30,%eax
  80073f:	73 24                	jae    800765 <getuint+0x9c>
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074d:	8b 00                	mov    (%rax),%eax
  80074f:	89 c0                	mov    %eax,%eax
  800751:	48 01 d0             	add    %rdx,%rax
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	8b 12                	mov    (%rdx),%edx
  80075a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800761:	89 0a                	mov    %ecx,(%rdx)
  800763:	eb 17                	jmp    80077c <getuint+0xb3>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076d:	48 89 d0             	mov    %rdx,%rax
  800770:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800783:	eb 4e                	jmp    8007d3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	8b 00                	mov    (%rax),%eax
  80078b:	83 f8 30             	cmp    $0x30,%eax
  80078e:	73 24                	jae    8007b4 <getuint+0xeb>
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	8b 00                	mov    (%rax),%eax
  80079e:	89 c0                	mov    %eax,%eax
  8007a0:	48 01 d0             	add    %rdx,%rax
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	8b 12                	mov    (%rdx),%edx
  8007a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b0:	89 0a                	mov    %ecx,(%rdx)
  8007b2:	eb 17                	jmp    8007cb <getuint+0x102>
  8007b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007bc:	48 89 d0             	mov    %rdx,%rax
  8007bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cb:	8b 00                	mov    (%rax),%eax
  8007cd:	89 c0                	mov    %eax,%eax
  8007cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d7:	c9                   	leaveq 
  8007d8:	c3                   	retq   

00000000008007d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d9:	55                   	push   %rbp
  8007da:	48 89 e5             	mov    %rsp,%rbp
  8007dd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ec:	7e 52                	jle    800840 <getint+0x67>
		x=va_arg(*ap, long long);
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	8b 00                	mov    (%rax),%eax
  8007f4:	83 f8 30             	cmp    $0x30,%eax
  8007f7:	73 24                	jae    80081d <getint+0x44>
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800805:	8b 00                	mov    (%rax),%eax
  800807:	89 c0                	mov    %eax,%eax
  800809:	48 01 d0             	add    %rdx,%rax
  80080c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800810:	8b 12                	mov    (%rdx),%edx
  800812:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800819:	89 0a                	mov    %ecx,(%rdx)
  80081b:	eb 17                	jmp    800834 <getint+0x5b>
  80081d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800821:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800825:	48 89 d0             	mov    %rdx,%rax
  800828:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800830:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800834:	48 8b 00             	mov    (%rax),%rax
  800837:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083b:	e9 a3 00 00 00       	jmpq   8008e3 <getint+0x10a>
	else if (lflag)
  800840:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800844:	74 4f                	je     800895 <getint+0xbc>
		x=va_arg(*ap, long);
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	8b 00                	mov    (%rax),%eax
  80084c:	83 f8 30             	cmp    $0x30,%eax
  80084f:	73 24                	jae    800875 <getint+0x9c>
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085d:	8b 00                	mov    (%rax),%eax
  80085f:	89 c0                	mov    %eax,%eax
  800861:	48 01 d0             	add    %rdx,%rax
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	8b 12                	mov    (%rdx),%edx
  80086a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800871:	89 0a                	mov    %ecx,(%rdx)
  800873:	eb 17                	jmp    80088c <getint+0xb3>
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087d:	48 89 d0             	mov    %rdx,%rax
  800880:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800888:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088c:	48 8b 00             	mov    (%rax),%rax
  80088f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800893:	eb 4e                	jmp    8008e3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800899:	8b 00                	mov    (%rax),%eax
  80089b:	83 f8 30             	cmp    $0x30,%eax
  80089e:	73 24                	jae    8008c4 <getint+0xeb>
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	89 c0                	mov    %eax,%eax
  8008b0:	48 01 d0             	add    %rdx,%rax
  8008b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b7:	8b 12                	mov    (%rdx),%edx
  8008b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c0:	89 0a                	mov    %ecx,(%rdx)
  8008c2:	eb 17                	jmp    8008db <getint+0x102>
  8008c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008cc:	48 89 d0             	mov    %rdx,%rax
  8008cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008db:	8b 00                	mov    (%rax),%eax
  8008dd:	48 98                	cltq   
  8008df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e7:	c9                   	leaveq 
  8008e8:	c3                   	retq   

00000000008008e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e9:	55                   	push   %rbp
  8008ea:	48 89 e5             	mov    %rsp,%rbp
  8008ed:	41 54                	push   %r12
  8008ef:	53                   	push   %rbx
  8008f0:	48 83 ec 60          	sub    $0x60,%rsp
  8008f4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008fc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800900:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800904:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800908:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80090c:	48 8b 0a             	mov    (%rdx),%rcx
  80090f:	48 89 08             	mov    %rcx,(%rax)
  800912:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800916:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80091a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800922:	eb 17                	jmp    80093b <vprintfmt+0x52>
			if (ch == '\0')
  800924:	85 db                	test   %ebx,%ebx
  800926:	0f 84 df 04 00 00    	je     800e0b <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80092c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800930:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800934:	48 89 d6             	mov    %rdx,%rsi
  800937:	89 df                	mov    %ebx,%edi
  800939:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800943:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800947:	0f b6 00             	movzbl (%rax),%eax
  80094a:	0f b6 d8             	movzbl %al,%ebx
  80094d:	83 fb 25             	cmp    $0x25,%ebx
  800950:	75 d2                	jne    800924 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800952:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800956:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80095d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800964:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80096b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800972:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800976:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80097a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80097e:	0f b6 00             	movzbl (%rax),%eax
  800981:	0f b6 d8             	movzbl %al,%ebx
  800984:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800987:	83 f8 55             	cmp    $0x55,%eax
  80098a:	0f 87 47 04 00 00    	ja     800dd7 <vprintfmt+0x4ee>
  800990:	89 c0                	mov    %eax,%eax
  800992:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800999:	00 
  80099a:	48 b8 98 3d 80 00 00 	movabs $0x803d98,%rax
  8009a1:	00 00 00 
  8009a4:	48 01 d0             	add    %rdx,%rax
  8009a7:	48 8b 00             	mov    (%rax),%rax
  8009aa:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009b0:	eb c0                	jmp    800972 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b6:	eb ba                	jmp    800972 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009d3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d7:	0f b6 00             	movzbl (%rax),%eax
  8009da:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009dd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e0:	7e 0c                	jle    8009ee <vprintfmt+0x105>
  8009e2:	83 fb 39             	cmp    $0x39,%ebx
  8009e5:	7f 07                	jg     8009ee <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ec:	eb d1                	jmp    8009bf <vprintfmt+0xd6>
			goto process_precision;
  8009ee:	eb 58                	jmp    800a48 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	83 f8 30             	cmp    $0x30,%eax
  8009f6:	73 17                	jae    800a0f <vprintfmt+0x126>
  8009f8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ff:	89 c0                	mov    %eax,%eax
  800a01:	48 01 d0             	add    %rdx,%rax
  800a04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a07:	83 c2 08             	add    $0x8,%edx
  800a0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0d:	eb 0f                	jmp    800a1e <vprintfmt+0x135>
  800a0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a13:	48 89 d0             	mov    %rdx,%rax
  800a16:	48 83 c2 08          	add    $0x8,%rdx
  800a1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a23:	eb 23                	jmp    800a48 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a25:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a29:	79 0c                	jns    800a37 <vprintfmt+0x14e>
				width = 0;
  800a2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a32:	e9 3b ff ff ff       	jmpq   800972 <vprintfmt+0x89>
  800a37:	e9 36 ff ff ff       	jmpq   800972 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a3c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a43:	e9 2a ff ff ff       	jmpq   800972 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a48:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4c:	79 12                	jns    800a60 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a4e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a51:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a54:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a5b:	e9 12 ff ff ff       	jmpq   800972 <vprintfmt+0x89>
  800a60:	e9 0d ff ff ff       	jmpq   800972 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a65:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a69:	e9 04 ff ff ff       	jmpq   800972 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a71:	83 f8 30             	cmp    $0x30,%eax
  800a74:	73 17                	jae    800a8d <vprintfmt+0x1a4>
  800a76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7d:	89 c0                	mov    %eax,%eax
  800a7f:	48 01 d0             	add    %rdx,%rax
  800a82:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a85:	83 c2 08             	add    $0x8,%edx
  800a88:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8b:	eb 0f                	jmp    800a9c <vprintfmt+0x1b3>
  800a8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a91:	48 89 d0             	mov    %rdx,%rax
  800a94:	48 83 c2 08          	add    $0x8,%rdx
  800a98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9c:	8b 10                	mov    (%rax),%edx
  800a9e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aa2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa6:	48 89 ce             	mov    %rcx,%rsi
  800aa9:	89 d7                	mov    %edx,%edi
  800aab:	ff d0                	callq  *%rax
			break;
  800aad:	e9 53 03 00 00       	jmpq   800e05 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ab2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab5:	83 f8 30             	cmp    $0x30,%eax
  800ab8:	73 17                	jae    800ad1 <vprintfmt+0x1e8>
  800aba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800abe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac1:	89 c0                	mov    %eax,%eax
  800ac3:	48 01 d0             	add    %rdx,%rax
  800ac6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac9:	83 c2 08             	add    $0x8,%edx
  800acc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800acf:	eb 0f                	jmp    800ae0 <vprintfmt+0x1f7>
  800ad1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad5:	48 89 d0             	mov    %rdx,%rax
  800ad8:	48 83 c2 08          	add    $0x8,%rdx
  800adc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ae2:	85 db                	test   %ebx,%ebx
  800ae4:	79 02                	jns    800ae8 <vprintfmt+0x1ff>
				err = -err;
  800ae6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae8:	83 fb 15             	cmp    $0x15,%ebx
  800aeb:	7f 16                	jg     800b03 <vprintfmt+0x21a>
  800aed:	48 b8 c0 3c 80 00 00 	movabs $0x803cc0,%rax
  800af4:	00 00 00 
  800af7:	48 63 d3             	movslq %ebx,%rdx
  800afa:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800afe:	4d 85 e4             	test   %r12,%r12
  800b01:	75 2e                	jne    800b31 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b03:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0b:	89 d9                	mov    %ebx,%ecx
  800b0d:	48 ba 81 3d 80 00 00 	movabs $0x803d81,%rdx
  800b14:	00 00 00 
  800b17:	48 89 c7             	mov    %rax,%rdi
  800b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1f:	49 b8 14 0e 80 00 00 	movabs $0x800e14,%r8
  800b26:	00 00 00 
  800b29:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2c:	e9 d4 02 00 00       	jmpq   800e05 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b39:	4c 89 e1             	mov    %r12,%rcx
  800b3c:	48 ba 8a 3d 80 00 00 	movabs $0x803d8a,%rdx
  800b43:	00 00 00 
  800b46:	48 89 c7             	mov    %rax,%rdi
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4e:	49 b8 14 0e 80 00 00 	movabs $0x800e14,%r8
  800b55:	00 00 00 
  800b58:	41 ff d0             	callq  *%r8
			break;
  800b5b:	e9 a5 02 00 00       	jmpq   800e05 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b63:	83 f8 30             	cmp    $0x30,%eax
  800b66:	73 17                	jae    800b7f <vprintfmt+0x296>
  800b68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6f:	89 c0                	mov    %eax,%eax
  800b71:	48 01 d0             	add    %rdx,%rax
  800b74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b77:	83 c2 08             	add    $0x8,%edx
  800b7a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b7d:	eb 0f                	jmp    800b8e <vprintfmt+0x2a5>
  800b7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b83:	48 89 d0             	mov    %rdx,%rax
  800b86:	48 83 c2 08          	add    $0x8,%rdx
  800b8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b8e:	4c 8b 20             	mov    (%rax),%r12
  800b91:	4d 85 e4             	test   %r12,%r12
  800b94:	75 0a                	jne    800ba0 <vprintfmt+0x2b7>
				p = "(null)";
  800b96:	49 bc 8d 3d 80 00 00 	movabs $0x803d8d,%r12
  800b9d:	00 00 00 
			if (width > 0 && padc != '-')
  800ba0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba4:	7e 3f                	jle    800be5 <vprintfmt+0x2fc>
  800ba6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800baa:	74 39                	je     800be5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800baf:	48 98                	cltq   
  800bb1:	48 89 c6             	mov    %rax,%rsi
  800bb4:	4c 89 e7             	mov    %r12,%rdi
  800bb7:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  800bbe:	00 00 00 
  800bc1:	ff d0                	callq  *%rax
  800bc3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc6:	eb 17                	jmp    800bdf <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bc8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bcc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd4:	48 89 ce             	mov    %rcx,%rsi
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be3:	7f e3                	jg     800bc8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be5:	eb 37                	jmp    800c1e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800be7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800beb:	74 1e                	je     800c0b <vprintfmt+0x322>
  800bed:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf0:	7e 05                	jle    800bf7 <vprintfmt+0x30e>
  800bf2:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf5:	7e 14                	jle    800c0b <vprintfmt+0x322>
					putch('?', putdat);
  800bf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bff:	48 89 d6             	mov    %rdx,%rsi
  800c02:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c07:	ff d0                	callq  *%rax
  800c09:	eb 0f                	jmp    800c1a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c13:	48 89 d6             	mov    %rdx,%rsi
  800c16:	89 df                	mov    %ebx,%edi
  800c18:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c1e:	4c 89 e0             	mov    %r12,%rax
  800c21:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c25:	0f b6 00             	movzbl (%rax),%eax
  800c28:	0f be d8             	movsbl %al,%ebx
  800c2b:	85 db                	test   %ebx,%ebx
  800c2d:	74 10                	je     800c3f <vprintfmt+0x356>
  800c2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c33:	78 b2                	js     800be7 <vprintfmt+0x2fe>
  800c35:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c39:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c3d:	79 a8                	jns    800be7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c3f:	eb 16                	jmp    800c57 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c49:	48 89 d6             	mov    %rdx,%rsi
  800c4c:	bf 20 00 00 00       	mov    $0x20,%edi
  800c51:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c53:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5b:	7f e4                	jg     800c41 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c5d:	e9 a3 01 00 00       	jmpq   800e05 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c62:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c66:	be 03 00 00 00       	mov    $0x3,%esi
  800c6b:	48 89 c7             	mov    %rax,%rdi
  800c6e:	48 b8 d9 07 80 00 00 	movabs $0x8007d9,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	callq  *%rax
  800c7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c82:	48 85 c0             	test   %rax,%rax
  800c85:	79 1d                	jns    800ca4 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8f:	48 89 d6             	mov    %rdx,%rsi
  800c92:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c97:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9d:	48 f7 d8             	neg    %rax
  800ca0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ca4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cab:	e9 e8 00 00 00       	jmpq   800d98 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cb0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb4:	be 03 00 00 00       	mov    $0x3,%esi
  800cb9:	48 89 c7             	mov    %rax,%rdi
  800cbc:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  800cc3:	00 00 00 
  800cc6:	ff d0                	callq  *%rax
  800cc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ccc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd3:	e9 c0 00 00 00       	jmpq   800d98 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 58 00 00 00       	mov    $0x58,%edi
  800ce8:	ff d0                	callq  *%rax
			putch('X', putdat);
  800cea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf2:	48 89 d6             	mov    %rdx,%rsi
  800cf5:	bf 58 00 00 00       	mov    $0x58,%edi
  800cfa:	ff d0                	callq  *%rax
			putch('X', putdat);
  800cfc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	48 89 d6             	mov    %rdx,%rsi
  800d07:	bf 58 00 00 00       	mov    $0x58,%edi
  800d0c:	ff d0                	callq  *%rax
			break;
  800d0e:	e9 f2 00 00 00       	jmpq   800e05 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800d13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1b:	48 89 d6             	mov    %rdx,%rsi
  800d1e:	bf 30 00 00 00       	mov    $0x30,%edi
  800d23:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	bf 78 00 00 00       	mov    $0x78,%edi
  800d35:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3a:	83 f8 30             	cmp    $0x30,%eax
  800d3d:	73 17                	jae    800d56 <vprintfmt+0x46d>
  800d3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d46:	89 c0                	mov    %eax,%eax
  800d48:	48 01 d0             	add    %rdx,%rax
  800d4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d4e:	83 c2 08             	add    $0x8,%edx
  800d51:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d54:	eb 0f                	jmp    800d65 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800d56:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5a:	48 89 d0             	mov    %rdx,%rax
  800d5d:	48 83 c2 08          	add    $0x8,%rdx
  800d61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d65:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d6c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d73:	eb 23                	jmp    800d98 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d79:	be 03 00 00 00       	mov    $0x3,%esi
  800d7e:	48 89 c7             	mov    %rax,%rdi
  800d81:	48 b8 c9 06 80 00 00 	movabs $0x8006c9,%rax
  800d88:	00 00 00 
  800d8b:	ff d0                	callq  *%rax
  800d8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d91:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d98:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d9d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800da3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800daf:	45 89 c1             	mov    %r8d,%r9d
  800db2:	41 89 f8             	mov    %edi,%r8d
  800db5:	48 89 c7             	mov    %rax,%rdi
  800db8:	48 b8 0e 06 80 00 00 	movabs $0x80060e,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	callq  *%rax
			break;
  800dc4:	eb 3f                	jmp    800e05 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dce:	48 89 d6             	mov    %rdx,%rsi
  800dd1:	89 df                	mov    %ebx,%edi
  800dd3:	ff d0                	callq  *%rax
			break;
  800dd5:	eb 2e                	jmp    800e05 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddf:	48 89 d6             	mov    %rdx,%rsi
  800de2:	bf 25 00 00 00       	mov    $0x25,%edi
  800de7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dee:	eb 05                	jmp    800df5 <vprintfmt+0x50c>
  800df0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800df9:	48 83 e8 01          	sub    $0x1,%rax
  800dfd:	0f b6 00             	movzbl (%rax),%eax
  800e00:	3c 25                	cmp    $0x25,%al
  800e02:	75 ec                	jne    800df0 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800e04:	90                   	nop
		}
	}
  800e05:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e06:	e9 30 fb ff ff       	jmpq   80093b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e0b:	48 83 c4 60          	add    $0x60,%rsp
  800e0f:	5b                   	pop    %rbx
  800e10:	41 5c                	pop    %r12
  800e12:	5d                   	pop    %rbp
  800e13:	c3                   	retq   

0000000000800e14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e14:	55                   	push   %rbp
  800e15:	48 89 e5             	mov    %rsp,%rbp
  800e18:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e1f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e26:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e42:	84 c0                	test   %al,%al
  800e44:	74 20                	je     800e66 <printfmt+0x52>
  800e46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e66:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e6d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e74:	00 00 00 
  800e77:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e7e:	00 00 00 
  800e81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e85:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e93:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ea1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ea8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eaf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eb6:	48 89 c7             	mov    %rax,%rdi
  800eb9:	48 b8 e9 08 80 00 00 	movabs $0x8008e9,%rax
  800ec0:	00 00 00 
  800ec3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ec5:	c9                   	leaveq 
  800ec6:	c3                   	retq   

0000000000800ec7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ec7:	55                   	push   %rbp
  800ec8:	48 89 e5             	mov    %rsp,%rbp
  800ecb:	48 83 ec 10          	sub    $0x10,%rsp
  800ecf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eda:	8b 40 10             	mov    0x10(%rax),%eax
  800edd:	8d 50 01             	lea    0x1(%rax),%edx
  800ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eeb:	48 8b 10             	mov    (%rax),%rdx
  800eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ef6:	48 39 c2             	cmp    %rax,%rdx
  800ef9:	73 17                	jae    800f12 <sprintputch+0x4b>
		*b->buf++ = ch;
  800efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eff:	48 8b 00             	mov    (%rax),%rax
  800f02:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f0a:	48 89 0a             	mov    %rcx,(%rdx)
  800f0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f10:	88 10                	mov    %dl,(%rax)
}
  800f12:	c9                   	leaveq 
  800f13:	c3                   	retq   

0000000000800f14 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f14:	55                   	push   %rbp
  800f15:	48 89 e5             	mov    %rsp,%rbp
  800f18:	48 83 ec 50          	sub    $0x50,%rsp
  800f1c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f20:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f23:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f27:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f2b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f2f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f33:	48 8b 0a             	mov    (%rdx),%rcx
  800f36:	48 89 08             	mov    %rcx,(%rax)
  800f39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f4d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f51:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f54:	48 98                	cltq   
  800f56:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f5e:	48 01 d0             	add    %rdx,%rax
  800f61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f6c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f71:	74 06                	je     800f79 <vsnprintf+0x65>
  800f73:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f77:	7f 07                	jg     800f80 <vsnprintf+0x6c>
		return -E_INVAL;
  800f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7e:	eb 2f                	jmp    800faf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f80:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f84:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f8c:	48 89 c6             	mov    %rax,%rsi
  800f8f:	48 bf c7 0e 80 00 00 	movabs $0x800ec7,%rdi
  800f96:	00 00 00 
  800f99:	48 b8 e9 08 80 00 00 	movabs $0x8008e9,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fa9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fac:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800faf:	c9                   	leaveq 
  800fb0:	c3                   	retq   

0000000000800fb1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fbc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fc3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fc9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fd7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fde:	84 c0                	test   %al,%al
  800fe0:	74 20                	je     801002 <snprintf+0x51>
  800fe2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fe6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ff2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ff6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ffa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ffe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801002:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801009:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801010:	00 00 00 
  801013:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80101a:	00 00 00 
  80101d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801021:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801028:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80102f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801036:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80103d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801044:	48 8b 0a             	mov    (%rdx),%rcx
  801047:	48 89 08             	mov    %rcx,(%rax)
  80104a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801052:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801056:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80105a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801061:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801068:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80106e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801075:	48 89 c7             	mov    %rax,%rdi
  801078:	48 b8 14 0f 80 00 00 	movabs $0x800f14,%rax
  80107f:	00 00 00 
  801082:	ff d0                	callq  *%rax
  801084:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80108a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 18          	sub    $0x18,%rsp
  80109a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a5:	eb 09                	jmp    8010b0 <strlen+0x1e>
		n++;
  8010a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 ec                	jne    8010a7 <strlen+0x15>
		n++;
	return n;
  8010bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 20          	sub    $0x20,%rsp
  8010c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010d7:	eb 0e                	jmp    8010e7 <strnlen+0x27>
		n++;
  8010d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010dd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ec:	74 0b                	je     8010f9 <strnlen+0x39>
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	75 e0                	jne    8010d9 <strnlen+0x19>
		n++;
	return n;
  8010f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 20          	sub    $0x20,%rsp
  801106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801116:	90                   	nop
  801117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801127:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80112f:	0f b6 12             	movzbl (%rdx),%edx
  801132:	88 10                	mov    %dl,(%rax)
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	84 c0                	test   %al,%al
  801139:	75 dc                	jne    801117 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 20          	sub    $0x20,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 89 c7             	mov    %rax,%rdi
  801158:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  80115f:	00 00 00 
  801162:	ff d0                	callq  *%rax
  801164:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116a:	48 63 d0             	movslq %eax,%rdx
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 01 c2             	add    %rax,%rdx
  801174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801178:	48 89 c6             	mov    %rax,%rsi
  80117b:	48 89 d7             	mov    %rdx,%rdi
  80117e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  801185:	00 00 00 
  801188:	ff d0                	callq  *%rax
	return dst;
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 83 ec 28          	sub    $0x28,%rsp
  801198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011b3:	00 
  8011b4:	eb 2a                	jmp    8011e0 <strncpy+0x50>
		*dst++ = *src;
  8011b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c6:	0f b6 12             	movzbl (%rdx),%edx
  8011c9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	74 05                	je     8011db <strncpy+0x4b>
			src++;
  8011d6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011e8:	72 cc                	jb     8011b6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011ee:	c9                   	leaveq 
  8011ef:	c3                   	retq   

00000000008011f0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	48 83 ec 28          	sub    $0x28,%rsp
  8011f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801200:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801208:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80120c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801211:	74 3d                	je     801250 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801213:	eb 1d                	jmp    801232 <strlcpy+0x42>
			*dst++ = *src++;
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801221:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801225:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801229:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80122d:	0f b6 12             	movzbl (%rdx),%edx
  801230:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801232:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801237:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80123c:	74 0b                	je     801249 <strlcpy+0x59>
  80123e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	75 cc                	jne    801215 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801250:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	48 29 c2             	sub    %rax,%rdx
  80125b:	48 89 d0             	mov    %rdx,%rax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 10          	sub    $0x10,%rsp
  801268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801270:	eb 0a                	jmp    80127c <strcmp+0x1c>
		p++, q++;
  801272:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801277:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	84 c0                	test   %al,%al
  801285:	74 12                	je     801299 <strcmp+0x39>
  801287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128b:	0f b6 10             	movzbl (%rax),%edx
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	0f b6 00             	movzbl (%rax),%eax
  801295:	38 c2                	cmp    %al,%dl
  801297:	74 d9                	je     801272 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	0f b6 d0             	movzbl %al,%edx
  8012a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a7:	0f b6 00             	movzbl (%rax),%eax
  8012aa:	0f b6 c0             	movzbl %al,%eax
  8012ad:	29 c2                	sub    %eax,%edx
  8012af:	89 d0                	mov    %edx,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 18          	sub    $0x18,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012c7:	eb 0f                	jmp    8012d8 <strncmp+0x25>
		n--, p++, q++;
  8012c9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012dd:	74 1d                	je     8012fc <strncmp+0x49>
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	84 c0                	test   %al,%al
  8012e8:	74 12                	je     8012fc <strncmp+0x49>
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 10             	movzbl (%rax),%edx
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	38 c2                	cmp    %al,%dl
  8012fa:	74 cd                	je     8012c9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801301:	75 07                	jne    80130a <strncmp+0x57>
		return 0;
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
  801308:	eb 18                	jmp    801322 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	0f b6 d0             	movzbl %al,%edx
  801314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	0f b6 c0             	movzbl %al,%eax
  80131e:	29 c2                	sub    %eax,%edx
  801320:	89 d0                	mov    %edx,%eax
}
  801322:	c9                   	leaveq 
  801323:	c3                   	retq   

0000000000801324 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	48 83 ec 0c          	sub    $0xc,%rsp
  80132c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801330:	89 f0                	mov    %esi,%eax
  801332:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801335:	eb 17                	jmp    80134e <strchr+0x2a>
		if (*s == c)
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801341:	75 06                	jne    801349 <strchr+0x25>
			return (char *) s;
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801347:	eb 15                	jmp    80135e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	0f b6 00             	movzbl (%rax),%eax
  801355:	84 c0                	test   %al,%al
  801357:	75 de                	jne    801337 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 0c          	sub    $0xc,%rsp
  801368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136c:	89 f0                	mov    %esi,%eax
  80136e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801371:	eb 13                	jmp    801386 <strfind+0x26>
		if (*s == c)
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137d:	75 02                	jne    801381 <strfind+0x21>
			break;
  80137f:	eb 10                	jmp    801391 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801381:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138a:	0f b6 00             	movzbl (%rax),%eax
  80138d:	84 c0                	test   %al,%al
  80138f:	75 e2                	jne    801373 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801395:	c9                   	leaveq 
  801396:	c3                   	retq   

0000000000801397 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801397:	55                   	push   %rbp
  801398:	48 89 e5             	mov    %rsp,%rbp
  80139b:	48 83 ec 18          	sub    $0x18,%rsp
  80139f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013af:	75 06                	jne    8013b7 <memset+0x20>
		return v;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 69                	jmp    801420 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	83 e0 03             	and    $0x3,%eax
  8013be:	48 85 c0             	test   %rax,%rax
  8013c1:	75 48                	jne    80140b <memset+0x74>
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	75 3c                	jne    80140b <memset+0x74>
		c &= 0xFF;
  8013cf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	c1 e0 18             	shl    $0x18,%eax
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	c1 e0 10             	shl    $0x10,%eax
  8013e4:	09 c2                	or     %eax,%edx
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	c1 e0 08             	shl    $0x8,%eax
  8013ec:	09 d0                	or     %edx,%eax
  8013ee:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f5:	48 c1 e8 02          	shr    $0x2,%rax
  8013f9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801403:	48 89 d7             	mov    %rdx,%rdi
  801406:	fc                   	cld    
  801407:	f3 ab                	rep stos %eax,%es:(%rdi)
  801409:	eb 11                	jmp    80141c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80140b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801412:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801416:	48 89 d7             	mov    %rdx,%rdi
  801419:	fc                   	cld    
  80141a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801420:	c9                   	leaveq 
  801421:	c3                   	retq   

0000000000801422 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801422:	55                   	push   %rbp
  801423:	48 89 e5             	mov    %rsp,%rbp
  801426:	48 83 ec 28          	sub    $0x28,%rsp
  80142a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801432:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144e:	0f 83 88 00 00 00    	jae    8014dc <memmove+0xba>
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145c:	48 01 d0             	add    %rdx,%rax
  80145f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801463:	76 77                	jbe    8014dc <memmove+0xba>
		s += n;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 3b                	jne    8014bc <memmove+0x9a>
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	83 e0 03             	and    $0x3,%eax
  801488:	48 85 c0             	test   %rax,%rax
  80148b:	75 2f                	jne    8014bc <memmove+0x9a>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 23                	jne    8014bc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	48 83 e8 04          	sub    $0x4,%rax
  8014a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a5:	48 83 ea 04          	sub    $0x4,%rdx
  8014a9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ad:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014b1:	48 89 c7             	mov    %rax,%rdi
  8014b4:	48 89 d6             	mov    %rdx,%rsi
  8014b7:	fd                   	std    
  8014b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ba:	eb 1d                	jmp    8014d9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	48 89 d7             	mov    %rdx,%rdi
  8014d3:	48 89 c1             	mov    %rax,%rcx
  8014d6:	fd                   	std    
  8014d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014d9:	fc                   	cld    
  8014da:	eb 57                	jmp    801533 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	83 e0 03             	and    $0x3,%eax
  8014e3:	48 85 c0             	test   %rax,%rax
  8014e6:	75 36                	jne    80151e <memmove+0xfc>
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	83 e0 03             	and    $0x3,%eax
  8014ef:	48 85 c0             	test   %rax,%rax
  8014f2:	75 2a                	jne    80151e <memmove+0xfc>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	75 1e                	jne    80151e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 c1 e8 02          	shr    $0x2,%rax
  801508:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 89 c7             	mov    %rax,%rdi
  801516:	48 89 d6             	mov    %rdx,%rsi
  801519:	fc                   	cld    
  80151a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80151c:	eb 15                	jmp    801533 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801526:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152a:	48 89 c7             	mov    %rax,%rdi
  80152d:	48 89 d6             	mov    %rdx,%rsi
  801530:	fc                   	cld    
  801531:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 18          	sub    $0x18,%rsp
  801541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801545:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801549:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80154d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801551:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	48 89 ce             	mov    %rcx,%rsi
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 28          	sub    $0x28,%rsp
  801575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80158d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801591:	eb 36                	jmp    8015c9 <memcmp+0x5c>
		if (*s1 != *s2)
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	0f b6 10             	movzbl (%rax),%edx
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	38 c2                	cmp    %al,%dl
  8015a3:	74 1a                	je     8015bf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	0f b6 d0             	movzbl %al,%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	29 c2                	sub    %eax,%edx
  8015bb:	89 d0                	mov    %edx,%eax
  8015bd:	eb 20                	jmp    8015df <memcmp+0x72>
		s1++, s2++;
  8015bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015d5:	48 85 c0             	test   %rax,%rax
  8015d8:	75 b9                	jne    801593 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015df:	c9                   	leaveq 
  8015e0:	c3                   	retq   

00000000008015e1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e1:	55                   	push   %rbp
  8015e2:	48 89 e5             	mov    %rsp,%rbp
  8015e5:	48 83 ec 28          	sub    $0x28,%rsp
  8015e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fc:	48 01 d0             	add    %rdx,%rax
  8015ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801603:	eb 15                	jmp    80161a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	0f b6 10             	movzbl (%rax),%edx
  80160c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80160f:	38 c2                	cmp    %al,%dl
  801611:	75 02                	jne    801615 <memfind+0x34>
			break;
  801613:	eb 0f                	jmp    801624 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801615:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801622:	72 e1                	jb     801605 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 34          	sub    $0x34,%rsp
  801632:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801636:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80163a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801644:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80164b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164c:	eb 05                	jmp    801653 <strtol+0x29>
		s++;
  80164e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	3c 20                	cmp    $0x20,%al
  80165c:	74 f0                	je     80164e <strtol+0x24>
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 09                	cmp    $0x9,%al
  801667:	74 e5                	je     80164e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 2b                	cmp    $0x2b,%al
  801672:	75 07                	jne    80167b <strtol+0x51>
		s++;
  801674:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801679:	eb 17                	jmp    801692 <strtol+0x68>
	else if (*s == '-')
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	3c 2d                	cmp    $0x2d,%al
  801684:	75 0c                	jne    801692 <strtol+0x68>
		s++, neg = 1;
  801686:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801692:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801696:	74 06                	je     80169e <strtol+0x74>
  801698:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80169c:	75 28                	jne    8016c6 <strtol+0x9c>
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 30                	cmp    $0x30,%al
  8016a7:	75 1d                	jne    8016c6 <strtol+0x9c>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	48 83 c0 01          	add    $0x1,%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	3c 78                	cmp    $0x78,%al
  8016b6:	75 0e                	jne    8016c6 <strtol+0x9c>
		s += 2, base = 16;
  8016b8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016bd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016c4:	eb 2c                	jmp    8016f2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ca:	75 19                	jne    8016e5 <strtol+0xbb>
  8016cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	3c 30                	cmp    $0x30,%al
  8016d5:	75 0e                	jne    8016e5 <strtol+0xbb>
		s++, base = 8;
  8016d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016dc:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016e3:	eb 0d                	jmp    8016f2 <strtol+0xc8>
	else if (base == 0)
  8016e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e9:	75 07                	jne    8016f2 <strtol+0xc8>
		base = 10;
  8016eb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	3c 2f                	cmp    $0x2f,%al
  8016fb:	7e 1d                	jle    80171a <strtol+0xf0>
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 39                	cmp    $0x39,%al
  801706:	7f 12                	jg     80171a <strtol+0xf0>
			dig = *s - '0';
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	0f b6 00             	movzbl (%rax),%eax
  80170f:	0f be c0             	movsbl %al,%eax
  801712:	83 e8 30             	sub    $0x30,%eax
  801715:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801718:	eb 4e                	jmp    801768 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80171a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171e:	0f b6 00             	movzbl (%rax),%eax
  801721:	3c 60                	cmp    $0x60,%al
  801723:	7e 1d                	jle    801742 <strtol+0x118>
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	0f b6 00             	movzbl (%rax),%eax
  80172c:	3c 7a                	cmp    $0x7a,%al
  80172e:	7f 12                	jg     801742 <strtol+0x118>
			dig = *s - 'a' + 10;
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	0f be c0             	movsbl %al,%eax
  80173a:	83 e8 57             	sub    $0x57,%eax
  80173d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801740:	eb 26                	jmp    801768 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 40                	cmp    $0x40,%al
  80174b:	7e 48                	jle    801795 <strtol+0x16b>
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 5a                	cmp    $0x5a,%al
  801756:	7f 3d                	jg     801795 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	0f be c0             	movsbl %al,%eax
  801762:	83 e8 37             	sub    $0x37,%eax
  801765:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80176e:	7c 02                	jl     801772 <strtol+0x148>
			break;
  801770:	eb 23                	jmp    801795 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801772:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801777:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80177a:	48 98                	cltq   
  80177c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801781:	48 89 c2             	mov    %rax,%rdx
  801784:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801787:	48 98                	cltq   
  801789:	48 01 d0             	add    %rdx,%rax
  80178c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801790:	e9 5d ff ff ff       	jmpq   8016f2 <strtol+0xc8>

	if (endptr)
  801795:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80179a:	74 0b                	je     8017a7 <strtol+0x17d>
		*endptr = (char *) s;
  80179c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017a4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ab:	74 09                	je     8017b6 <strtol+0x18c>
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	48 f7 d8             	neg    %rax
  8017b4:	eb 04                	jmp    8017ba <strtol+0x190>
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <strstr>:

char * strstr(const char *in, const char *str)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 30          	sub    $0x30,%rsp
  8017c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017de:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e2:	75 06                	jne    8017ea <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	eb 6b                	jmp    801855 <strstr+0x99>

	len = strlen(str);
  8017ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ee:	48 89 c7             	mov    %rax,%rdi
  8017f1:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	callq  *%rax
  8017fd:	48 98                	cltq   
  8017ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80180b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801815:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801819:	75 07                	jne    801822 <strstr+0x66>
				return (char *) 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	eb 33                	jmp    801855 <strstr+0x99>
		} while (sc != c);
  801822:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801826:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801829:	75 d8                	jne    801803 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80182b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801837:	48 89 ce             	mov    %rcx,%rsi
  80183a:	48 89 c7             	mov    %rax,%rdi
  80183d:	48 b8 b3 12 80 00 00 	movabs $0x8012b3,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
  801849:	85 c0                	test   %eax,%eax
  80184b:	75 b6                	jne    801803 <strstr+0x47>

	return (char *) (in - 1);
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	48 83 e8 01          	sub    $0x1,%rax
}
  801855:	c9                   	leaveq 
  801856:	c3                   	retq   

0000000000801857 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801857:	55                   	push   %rbp
  801858:	48 89 e5             	mov    %rsp,%rbp
  80185b:	53                   	push   %rbx
  80185c:	48 83 ec 48          	sub    $0x48,%rsp
  801860:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801863:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801866:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80186a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80186e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801872:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801876:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801879:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80187d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801881:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801885:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801889:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80188d:	4c 89 c3             	mov    %r8,%rbx
  801890:	cd 30                	int    $0x30
  801892:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801896:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80189a:	74 3e                	je     8018da <syscall+0x83>
  80189c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a1:	7e 37                	jle    8018da <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018aa:	49 89 d0             	mov    %rdx,%r8
  8018ad:	89 c1                	mov    %eax,%ecx
  8018af:	48 ba 48 40 80 00 00 	movabs $0x804048,%rdx
  8018b6:	00 00 00 
  8018b9:	be 23 00 00 00       	mov    $0x23,%esi
  8018be:	48 bf 65 40 80 00 00 	movabs $0x804065,%rdi
  8018c5:	00 00 00 
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cd:	49 b9 fd 02 80 00 00 	movabs $0x8002fd,%r9
  8018d4:	00 00 00 
  8018d7:	41 ff d1             	callq  *%r9

	return ret;
  8018da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018de:	48 83 c4 48          	add    $0x48,%rsp
  8018e2:	5b                   	pop    %rbx
  8018e3:	5d                   	pop    %rbp
  8018e4:	c3                   	retq   

00000000008018e5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018e5:	55                   	push   %rbp
  8018e6:	48 89 e5             	mov    %rsp,%rbp
  8018e9:	48 83 ec 20          	sub    $0x20,%rsp
  8018ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801904:	00 
  801905:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801911:	48 89 d1             	mov    %rdx,%rcx
  801914:	48 89 c2             	mov    %rax,%rdx
  801917:	be 00 00 00 00       	mov    $0x0,%esi
  80191c:	bf 00 00 00 00       	mov    $0x0,%edi
  801921:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
}
  80192d:	c9                   	leaveq 
  80192e:	c3                   	retq   

000000000080192f <sys_cgetc>:

int
sys_cgetc(void)
{
  80192f:	55                   	push   %rbp
  801930:	48 89 e5             	mov    %rsp,%rbp
  801933:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801937:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193e:	00 
  80193f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801945:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	be 00 00 00 00       	mov    $0x0,%esi
  80195a:	bf 01 00 00 00       	mov    $0x1,%edi
  80195f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	48 83 ec 10          	sub    $0x10,%rsp
  801975:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197b:	48 98                	cltq   
  80197d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801984:	00 
  801985:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801991:	b9 00 00 00 00       	mov    $0x0,%ecx
  801996:	48 89 c2             	mov    %rax,%rdx
  801999:	be 01 00 00 00       	mov    $0x1,%esi
  80199e:	bf 03 00 00 00       	mov    $0x3,%edi
  8019a3:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
}
  8019af:	c9                   	leaveq 
  8019b0:	c3                   	retq   

00000000008019b1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019b1:	55                   	push   %rbp
  8019b2:	48 89 e5             	mov    %rsp,%rbp
  8019b5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c0:	00 
  8019c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d7:	be 00 00 00 00       	mov    $0x0,%esi
  8019dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8019e1:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	callq  *%rax
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_yield>:

void
sys_yield(void)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fe:	00 
  8019ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a10:	ba 00 00 00 00       	mov    $0x0,%edx
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a1f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 20          	sub    $0x20,%rsp
  801a35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a42:	48 63 c8             	movslq %eax,%rcx
  801a45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4c:	48 98                	cltq   
  801a4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a55:	00 
  801a56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5c:	49 89 c8             	mov    %rcx,%r8
  801a5f:	48 89 d1             	mov    %rdx,%rcx
  801a62:	48 89 c2             	mov    %rax,%rdx
  801a65:	be 01 00 00 00       	mov    $0x1,%esi
  801a6a:	bf 04 00 00 00       	mov    $0x4,%edi
  801a6f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801a76:	00 00 00 
  801a79:	ff d0                	callq  *%rax
}
  801a7b:	c9                   	leaveq 
  801a7c:	c3                   	retq   

0000000000801a7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	48 83 ec 30          	sub    $0x30,%rsp
  801a85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a8f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a93:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a97:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a9a:	48 63 c8             	movslq %eax,%rcx
  801a9d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aa1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa4:	48 63 f0             	movslq %eax,%rsi
  801aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aae:	48 98                	cltq   
  801ab0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ab4:	49 89 f9             	mov    %rdi,%r9
  801ab7:	49 89 f0             	mov    %rsi,%r8
  801aba:	48 89 d1             	mov    %rdx,%rcx
  801abd:	48 89 c2             	mov    %rax,%rdx
  801ac0:	be 01 00 00 00       	mov    $0x1,%esi
  801ac5:	bf 05 00 00 00       	mov    $0x5,%edi
  801aca:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801ad1:	00 00 00 
  801ad4:	ff d0                	callq  *%rax
}
  801ad6:	c9                   	leaveq 
  801ad7:	c3                   	retq   

0000000000801ad8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
  801adc:	48 83 ec 20          	sub    $0x20,%rsp
  801ae0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ae7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aee:	48 98                	cltq   
  801af0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af7:	00 
  801af8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b04:	48 89 d1             	mov    %rdx,%rcx
  801b07:	48 89 c2             	mov    %rax,%rdx
  801b0a:	be 01 00 00 00       	mov    $0x1,%esi
  801b0f:	bf 06 00 00 00       	mov    $0x6,%edi
  801b14:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
}
  801b20:	c9                   	leaveq 
  801b21:	c3                   	retq   

0000000000801b22 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b22:	55                   	push   %rbp
  801b23:	48 89 e5             	mov    %rsp,%rbp
  801b26:	48 83 ec 10          	sub    $0x10,%rsp
  801b2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b33:	48 63 d0             	movslq %eax,%rdx
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b39:	48 98                	cltq   
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	48 89 d1             	mov    %rdx,%rcx
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	be 01 00 00 00       	mov    $0x1,%esi
  801b5a:	bf 08 00 00 00       	mov    $0x8,%edi
  801b5f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 20          	sub    $0x20,%rsp
  801b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b83:	48 98                	cltq   
  801b85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8c:	00 
  801b8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b99:	48 89 d1             	mov    %rdx,%rcx
  801b9c:	48 89 c2             	mov    %rax,%rdx
  801b9f:	be 01 00 00 00       	mov    $0x1,%esi
  801ba4:	bf 09 00 00 00       	mov    $0x9,%edi
  801ba9:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	callq  *%rax
}
  801bb5:	c9                   	leaveq 
  801bb6:	c3                   	retq   

0000000000801bb7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bb7:	55                   	push   %rbp
  801bb8:	48 89 e5             	mov    %rsp,%rbp
  801bbb:	48 83 ec 20          	sub    $0x20,%rsp
  801bbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcd:	48 98                	cltq   
  801bcf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd6:	00 
  801bd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be3:	48 89 d1             	mov    %rdx,%rcx
  801be6:	48 89 c2             	mov    %rax,%rdx
  801be9:	be 01 00 00 00       	mov    $0x1,%esi
  801bee:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bf3:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	48 83 ec 20          	sub    $0x20,%rsp
  801c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c10:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c14:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1a:	48 63 f0             	movslq %eax,%rsi
  801c1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c24:	48 98                	cltq   
  801c26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c31:	00 
  801c32:	49 89 f1             	mov    %rsi,%r9
  801c35:	49 89 c8             	mov    %rcx,%r8
  801c38:	48 89 d1             	mov    %rdx,%rcx
  801c3b:	48 89 c2             	mov    %rax,%rdx
  801c3e:	be 00 00 00 00       	mov    $0x0,%esi
  801c43:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c48:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801c4f:	00 00 00 
  801c52:	ff d0                	callq  *%rax
}
  801c54:	c9                   	leaveq 
  801c55:	c3                   	retq   

0000000000801c56 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c56:	55                   	push   %rbp
  801c57:	48 89 e5             	mov    %rsp,%rbp
  801c5a:	48 83 ec 10          	sub    $0x10,%rsp
  801c5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6d:	00 
  801c6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7f:	48 89 c2             	mov    %rax,%rdx
  801c82:	be 01 00 00 00       	mov    $0x1,%esi
  801c87:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c8c:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801c93:	00 00 00 
  801c96:	ff d0                	callq  *%rax
}
  801c98:	c9                   	leaveq 
  801c99:	c3                   	retq   

0000000000801c9a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c9a:	55                   	push   %rbp
  801c9b:	48 89 e5             	mov    %rsp,%rbp
  801c9e:	48 83 ec 08          	sub    $0x8,%rsp
  801ca2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ca6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801caa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cb1:	ff ff ff 
  801cb4:	48 01 d0             	add    %rdx,%rax
  801cb7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cbb:	c9                   	leaveq 
  801cbc:	c3                   	retq   

0000000000801cbd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cbd:	55                   	push   %rbp
  801cbe:	48 89 e5             	mov    %rsp,%rbp
  801cc1:	48 83 ec 08          	sub    $0x8,%rsp
  801cc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ccd:	48 89 c7             	mov    %rax,%rdi
  801cd0:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
  801cdc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ce2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ce6:	c9                   	leaveq 
  801ce7:	c3                   	retq   

0000000000801ce8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ce8:	55                   	push   %rbp
  801ce9:	48 89 e5             	mov    %rsp,%rbp
  801cec:	48 83 ec 18          	sub    $0x18,%rsp
  801cf0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cfb:	eb 6b                	jmp    801d68 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d00:	48 98                	cltq   
  801d02:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d08:	48 c1 e0 0c          	shl    $0xc,%rax
  801d0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d14:	48 c1 e8 15          	shr    $0x15,%rax
  801d18:	48 89 c2             	mov    %rax,%rdx
  801d1b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d22:	01 00 00 
  801d25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d29:	83 e0 01             	and    $0x1,%eax
  801d2c:	48 85 c0             	test   %rax,%rax
  801d2f:	74 21                	je     801d52 <fd_alloc+0x6a>
  801d31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d35:	48 c1 e8 0c          	shr    $0xc,%rax
  801d39:	48 89 c2             	mov    %rax,%rdx
  801d3c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d43:	01 00 00 
  801d46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d4a:	83 e0 01             	and    $0x1,%eax
  801d4d:	48 85 c0             	test   %rax,%rax
  801d50:	75 12                	jne    801d64 <fd_alloc+0x7c>
			*fd_store = fd;
  801d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d62:	eb 1a                	jmp    801d7e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d64:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d68:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d6c:	7e 8f                	jle    801cfd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d72:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d79:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d7e:	c9                   	leaveq 
  801d7f:	c3                   	retq   

0000000000801d80 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d80:	55                   	push   %rbp
  801d81:	48 89 e5             	mov    %rsp,%rbp
  801d84:	48 83 ec 20          	sub    $0x20,%rsp
  801d88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d93:	78 06                	js     801d9b <fd_lookup+0x1b>
  801d95:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d99:	7e 07                	jle    801da2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da0:	eb 6c                	jmp    801e0e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801da2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801da5:	48 98                	cltq   
  801da7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dad:	48 c1 e0 0c          	shl    $0xc,%rax
  801db1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db9:	48 c1 e8 15          	shr    $0x15,%rax
  801dbd:	48 89 c2             	mov    %rax,%rdx
  801dc0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dc7:	01 00 00 
  801dca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dce:	83 e0 01             	and    $0x1,%eax
  801dd1:	48 85 c0             	test   %rax,%rax
  801dd4:	74 21                	je     801df7 <fd_lookup+0x77>
  801dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dda:	48 c1 e8 0c          	shr    $0xc,%rax
  801dde:	48 89 c2             	mov    %rax,%rdx
  801de1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801de8:	01 00 00 
  801deb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801def:	83 e0 01             	and    $0x1,%eax
  801df2:	48 85 c0             	test   %rax,%rax
  801df5:	75 07                	jne    801dfe <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfc:	eb 10                	jmp    801e0e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801dfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e06:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0e:	c9                   	leaveq 
  801e0f:	c3                   	retq   

0000000000801e10 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e10:	55                   	push   %rbp
  801e11:	48 89 e5             	mov    %rsp,%rbp
  801e14:	48 83 ec 30          	sub    $0x30,%rsp
  801e18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e1c:	89 f0                	mov    %esi,%eax
  801e1e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e25:	48 89 c7             	mov    %rax,%rdi
  801e28:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	callq  *%rax
  801e34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e38:	48 89 d6             	mov    %rdx,%rsi
  801e3b:	89 c7                	mov    %eax,%edi
  801e3d:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
  801e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e50:	78 0a                	js     801e5c <fd_close+0x4c>
	    || fd != fd2)
  801e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e56:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e5a:	74 12                	je     801e6e <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e5c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e60:	74 05                	je     801e67 <fd_close+0x57>
  801e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e65:	eb 05                	jmp    801e6c <fd_close+0x5c>
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	eb 69                	jmp    801ed7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e72:	8b 00                	mov    (%rax),%eax
  801e74:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e78:	48 89 d6             	mov    %rdx,%rsi
  801e7b:	89 c7                	mov    %eax,%edi
  801e7d:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	callq  *%rax
  801e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e90:	78 2a                	js     801ebc <fd_close+0xac>
		if (dev->dev_close)
  801e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e96:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e9a:	48 85 c0             	test   %rax,%rax
  801e9d:	74 16                	je     801eb5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ea7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801eab:	48 89 d7             	mov    %rdx,%rdi
  801eae:	ff d0                	callq  *%rax
  801eb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb3:	eb 07                	jmp    801ebc <fd_close+0xac>
		else
			r = 0;
  801eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ebc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec0:	48 89 c6             	mov    %rax,%rsi
  801ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec8:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
	return r;
  801ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ed7:	c9                   	leaveq 
  801ed8:	c3                   	retq   

0000000000801ed9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ed9:	55                   	push   %rbp
  801eda:	48 89 e5             	mov    %rsp,%rbp
  801edd:	48 83 ec 20          	sub    $0x20,%rsp
  801ee1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ee4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eef:	eb 41                	jmp    801f32 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ef1:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ef8:	00 00 00 
  801efb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801efe:	48 63 d2             	movslq %edx,%rdx
  801f01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f05:	8b 00                	mov    (%rax),%eax
  801f07:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f0a:	75 22                	jne    801f2e <dev_lookup+0x55>
			*dev = devtab[i];
  801f0c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f13:	00 00 00 
  801f16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f19:	48 63 d2             	movslq %edx,%rdx
  801f1c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f24:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	eb 60                	jmp    801f8e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f32:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f39:	00 00 00 
  801f3c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f3f:	48 63 d2             	movslq %edx,%rdx
  801f42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f46:	48 85 c0             	test   %rax,%rax
  801f49:	75 a6                	jne    801ef1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f4b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  801f52:	00 00 00 
  801f55:	48 8b 00             	mov    (%rax),%rax
  801f58:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f5e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f61:	89 c6                	mov    %eax,%esi
  801f63:	48 bf 78 40 80 00 00 	movabs $0x804078,%rdi
  801f6a:	00 00 00 
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	48 b9 36 05 80 00 00 	movabs $0x800536,%rcx
  801f79:	00 00 00 
  801f7c:	ff d1                	callq  *%rcx
	*dev = 0;
  801f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f82:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <close>:

int
close(int fdnum)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 20          	sub    $0x20,%rsp
  801f98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fa2:	48 89 d6             	mov    %rdx,%rsi
  801fa5:	89 c7                	mov    %eax,%edi
  801fa7:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
  801fb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fba:	79 05                	jns    801fc1 <close+0x31>
		return r;
  801fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fbf:	eb 18                	jmp    801fd9 <close+0x49>
	else
		return fd_close(fd, 1);
  801fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc5:	be 01 00 00 00       	mov    $0x1,%esi
  801fca:	48 89 c7             	mov    %rax,%rdi
  801fcd:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	callq  *%rax
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <close_all>:

void
close_all(void)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
  801fdf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fea:	eb 15                	jmp    802001 <close_all+0x26>
		close(i);
  801fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fef:	89 c7                	mov    %eax,%edi
  801ff1:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ffd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802001:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802005:	7e e5                	jle    801fec <close_all+0x11>
		close(i);
}
  802007:	c9                   	leaveq 
  802008:	c3                   	retq   

0000000000802009 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802009:	55                   	push   %rbp
  80200a:	48 89 e5             	mov    %rsp,%rbp
  80200d:	48 83 ec 40          	sub    $0x40,%rsp
  802011:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802014:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802017:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80201b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80201e:	48 89 d6             	mov    %rdx,%rsi
  802021:	89 c7                	mov    %eax,%edi
  802023:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
  80202f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802032:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802036:	79 08                	jns    802040 <dup+0x37>
		return r;
  802038:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203b:	e9 70 01 00 00       	jmpq   8021b0 <dup+0x1a7>
	close(newfdnum);
  802040:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802043:	89 c7                	mov    %eax,%edi
  802045:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802051:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802054:	48 98                	cltq   
  802056:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80205c:	48 c1 e0 0c          	shl    $0xc,%rax
  802060:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802068:	48 89 c7             	mov    %rax,%rdi
  80206b:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  802072:	00 00 00 
  802075:	ff d0                	callq  *%rax
  802077:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80207b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207f:	48 89 c7             	mov    %rax,%rdi
  802082:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802096:	48 c1 e8 15          	shr    $0x15,%rax
  80209a:	48 89 c2             	mov    %rax,%rdx
  80209d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a4:	01 00 00 
  8020a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ab:	83 e0 01             	and    $0x1,%eax
  8020ae:	48 85 c0             	test   %rax,%rax
  8020b1:	74 73                	je     802126 <dup+0x11d>
  8020b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8020bb:	48 89 c2             	mov    %rax,%rdx
  8020be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c5:	01 00 00 
  8020c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cc:	83 e0 01             	and    $0x1,%eax
  8020cf:	48 85 c0             	test   %rax,%rax
  8020d2:	74 52                	je     802126 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8020dc:	48 89 c2             	mov    %rax,%rdx
  8020df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020e6:	01 00 00 
  8020e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8020f2:	89 c1                	mov    %eax,%ecx
  8020f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fc:	41 89 c8             	mov    %ecx,%r8d
  8020ff:	48 89 d1             	mov    %rdx,%rcx
  802102:	ba 00 00 00 00       	mov    $0x0,%edx
  802107:	48 89 c6             	mov    %rax,%rsi
  80210a:	bf 00 00 00 00       	mov    $0x0,%edi
  80210f:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
  80211b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802122:	79 02                	jns    802126 <dup+0x11d>
			goto err;
  802124:	eb 57                	jmp    80217d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802126:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212a:	48 c1 e8 0c          	shr    $0xc,%rax
  80212e:	48 89 c2             	mov    %rax,%rdx
  802131:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802138:	01 00 00 
  80213b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213f:	25 07 0e 00 00       	and    $0xe07,%eax
  802144:	89 c1                	mov    %eax,%ecx
  802146:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214e:	41 89 c8             	mov    %ecx,%r8d
  802151:	48 89 d1             	mov    %rdx,%rcx
  802154:	ba 00 00 00 00       	mov    $0x0,%edx
  802159:	48 89 c6             	mov    %rax,%rsi
  80215c:	bf 00 00 00 00       	mov    $0x0,%edi
  802161:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
  80216d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802174:	79 02                	jns    802178 <dup+0x16f>
		goto err;
  802176:	eb 05                	jmp    80217d <dup+0x174>

	return newfdnum;
  802178:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80217b:	eb 33                	jmp    8021b0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80217d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802181:	48 89 c6             	mov    %rax,%rsi
  802184:	bf 00 00 00 00       	mov    $0x0,%edi
  802189:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  802190:	00 00 00 
  802193:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802199:	48 89 c6             	mov    %rax,%rsi
  80219c:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a1:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
	return r;
  8021ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021b0:	c9                   	leaveq 
  8021b1:	c3                   	retq   

00000000008021b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021b2:	55                   	push   %rbp
  8021b3:	48 89 e5             	mov    %rsp,%rbp
  8021b6:	48 83 ec 40          	sub    $0x40,%rsp
  8021ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021cc:	48 89 d6             	mov    %rdx,%rsi
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e4:	78 24                	js     80220a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ea:	8b 00                	mov    (%rax),%eax
  8021ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021f0:	48 89 d6             	mov    %rdx,%rsi
  8021f3:	89 c7                	mov    %eax,%edi
  8021f5:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	callq  *%rax
  802201:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802204:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802208:	79 05                	jns    80220f <read+0x5d>
		return r;
  80220a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220d:	eb 76                	jmp    802285 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80220f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802213:	8b 40 08             	mov    0x8(%rax),%eax
  802216:	83 e0 03             	and    $0x3,%eax
  802219:	83 f8 01             	cmp    $0x1,%eax
  80221c:	75 3a                	jne    802258 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80221e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802225:	00 00 00 
  802228:	48 8b 00             	mov    (%rax),%rax
  80222b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802231:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802234:	89 c6                	mov    %eax,%esi
  802236:	48 bf 97 40 80 00 00 	movabs $0x804097,%rdi
  80223d:	00 00 00 
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
  802245:	48 b9 36 05 80 00 00 	movabs $0x800536,%rcx
  80224c:	00 00 00 
  80224f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802256:	eb 2d                	jmp    802285 <read+0xd3>
	}
	if (!dev->dev_read)
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802260:	48 85 c0             	test   %rax,%rax
  802263:	75 07                	jne    80226c <read+0xba>
		return -E_NOT_SUPP;
  802265:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80226a:	eb 19                	jmp    802285 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80226c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802270:	48 8b 40 10          	mov    0x10(%rax),%rax
  802274:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802278:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80227c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802280:	48 89 cf             	mov    %rcx,%rdi
  802283:	ff d0                	callq  *%rax
}
  802285:	c9                   	leaveq 
  802286:	c3                   	retq   

0000000000802287 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802287:	55                   	push   %rbp
  802288:	48 89 e5             	mov    %rsp,%rbp
  80228b:	48 83 ec 30          	sub    $0x30,%rsp
  80228f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802292:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802296:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80229a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022a1:	eb 49                	jmp    8022ec <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a6:	48 98                	cltq   
  8022a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022ac:	48 29 c2             	sub    %rax,%rdx
  8022af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b2:	48 63 c8             	movslq %eax,%rcx
  8022b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b9:	48 01 c1             	add    %rax,%rcx
  8022bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022bf:	48 89 ce             	mov    %rcx,%rsi
  8022c2:	89 c7                	mov    %eax,%edi
  8022c4:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	callq  *%rax
  8022d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022d7:	79 05                	jns    8022de <readn+0x57>
			return m;
  8022d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022dc:	eb 1c                	jmp    8022fa <readn+0x73>
		if (m == 0)
  8022de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022e2:	75 02                	jne    8022e6 <readn+0x5f>
			break;
  8022e4:	eb 11                	jmp    8022f7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ef:	48 98                	cltq   
  8022f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022f5:	72 ac                	jb     8022a3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8022f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022fa:	c9                   	leaveq 
  8022fb:	c3                   	retq   

00000000008022fc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022fc:	55                   	push   %rbp
  8022fd:	48 89 e5             	mov    %rsp,%rbp
  802300:	48 83 ec 40          	sub    $0x40,%rsp
  802304:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802307:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80230b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80230f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802313:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802316:	48 89 d6             	mov    %rdx,%rsi
  802319:	89 c7                	mov    %eax,%edi
  80231b:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  802322:	00 00 00 
  802325:	ff d0                	callq  *%rax
  802327:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232e:	78 24                	js     802354 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802334:	8b 00                	mov    (%rax),%eax
  802336:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80233a:	48 89 d6             	mov    %rdx,%rsi
  80233d:	89 c7                	mov    %eax,%edi
  80233f:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  802346:	00 00 00 
  802349:	ff d0                	callq  *%rax
  80234b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802352:	79 05                	jns    802359 <write+0x5d>
		return r;
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	eb 75                	jmp    8023ce <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235d:	8b 40 08             	mov    0x8(%rax),%eax
  802360:	83 e0 03             	and    $0x3,%eax
  802363:	85 c0                	test   %eax,%eax
  802365:	75 3a                	jne    8023a1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802367:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80236e:	00 00 00 
  802371:	48 8b 00             	mov    (%rax),%rax
  802374:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80237a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80237d:	89 c6                	mov    %eax,%esi
  80237f:	48 bf b3 40 80 00 00 	movabs $0x8040b3,%rdi
  802386:	00 00 00 
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
  80238e:	48 b9 36 05 80 00 00 	movabs $0x800536,%rcx
  802395:	00 00 00 
  802398:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80239a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80239f:	eb 2d                	jmp    8023ce <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a9:	48 85 c0             	test   %rax,%rax
  8023ac:	75 07                	jne    8023b5 <write+0xb9>
		return -E_NOT_SUPP;
  8023ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023b3:	eb 19                	jmp    8023ce <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023c9:	48 89 cf             	mov    %rcx,%rdi
  8023cc:	ff d0                	callq  *%rax
}
  8023ce:	c9                   	leaveq 
  8023cf:	c3                   	retq   

00000000008023d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023d0:	55                   	push   %rbp
  8023d1:	48 89 e5             	mov    %rsp,%rbp
  8023d4:	48 83 ec 18          	sub    $0x18,%rsp
  8023d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023db:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e5:	48 89 d6             	mov    %rdx,%rsi
  8023e8:	89 c7                	mov    %eax,%edi
  8023ea:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
  8023f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fd:	79 05                	jns    802404 <seek+0x34>
		return r;
  8023ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802402:	eb 0f                	jmp    802413 <seek+0x43>
	fd->fd_offset = offset;
  802404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802408:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80240b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802413:	c9                   	leaveq 
  802414:	c3                   	retq   

0000000000802415 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802415:	55                   	push   %rbp
  802416:	48 89 e5             	mov    %rsp,%rbp
  802419:	48 83 ec 30          	sub    $0x30,%rsp
  80241d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802420:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802423:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802427:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80242a:	48 89 d6             	mov    %rdx,%rsi
  80242d:	89 c7                	mov    %eax,%edi
  80242f:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax
  80243b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80243e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802442:	78 24                	js     802468 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802448:	8b 00                	mov    (%rax),%eax
  80244a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80244e:	48 89 d6             	mov    %rdx,%rsi
  802451:	89 c7                	mov    %eax,%edi
  802453:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
  80245f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802462:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802466:	79 05                	jns    80246d <ftruncate+0x58>
		return r;
  802468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246b:	eb 72                	jmp    8024df <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80246d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802471:	8b 40 08             	mov    0x8(%rax),%eax
  802474:	83 e0 03             	and    $0x3,%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 3a                	jne    8024b5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80247b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802482:	00 00 00 
  802485:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802488:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80248e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802491:	89 c6                	mov    %eax,%esi
  802493:	48 bf d0 40 80 00 00 	movabs $0x8040d0,%rdi
  80249a:	00 00 00 
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	48 b9 36 05 80 00 00 	movabs $0x800536,%rcx
  8024a9:	00 00 00 
  8024ac:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b3:	eb 2a                	jmp    8024df <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024bd:	48 85 c0             	test   %rax,%rax
  8024c0:	75 07                	jne    8024c9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024c7:	eb 16                	jmp    8024df <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024d5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024d8:	89 ce                	mov    %ecx,%esi
  8024da:	48 89 d7             	mov    %rdx,%rdi
  8024dd:	ff d0                	callq  *%rax
}
  8024df:	c9                   	leaveq 
  8024e0:	c3                   	retq   

00000000008024e1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024e1:	55                   	push   %rbp
  8024e2:	48 89 e5             	mov    %rsp,%rbp
  8024e5:	48 83 ec 30          	sub    $0x30,%rsp
  8024e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	78 24                	js     802535 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802515:	8b 00                	mov    (%rax),%eax
  802517:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <fstat+0x59>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 5e                	jmp    802598 <fstat+0xb7>
	if (!dev->dev_stat)
  80253a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802542:	48 85 c0             	test   %rax,%rax
  802545:	75 07                	jne    80254e <fstat+0x6d>
		return -E_NOT_SUPP;
  802547:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80254c:	eb 4a                	jmp    802598 <fstat+0xb7>
	stat->st_name[0] = 0;
  80254e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802552:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802555:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802559:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802560:	00 00 00 
	stat->st_isdir = 0;
  802563:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802567:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80256e:	00 00 00 
	stat->st_dev = dev;
  802571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802575:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802579:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802584:	48 8b 40 28          	mov    0x28(%rax),%rax
  802588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80258c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802590:	48 89 ce             	mov    %rcx,%rsi
  802593:	48 89 d7             	mov    %rdx,%rdi
  802596:	ff d0                	callq  *%rax
}
  802598:	c9                   	leaveq 
  802599:	c3                   	retq   

000000000080259a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80259a:	55                   	push   %rbp
  80259b:	48 89 e5             	mov    %rsp,%rbp
  80259e:	48 83 ec 20          	sub    $0x20,%rsp
  8025a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ae:	be 00 00 00 00       	mov    $0x0,%esi
  8025b3:	48 89 c7             	mov    %rax,%rdi
  8025b6:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c9:	79 05                	jns    8025d0 <stat+0x36>
		return fd;
  8025cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ce:	eb 2f                	jmp    8025ff <stat+0x65>
	r = fstat(fd, stat);
  8025d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d7:	48 89 d6             	mov    %rdx,%rsi
  8025da:	89 c7                	mov    %eax,%edi
  8025dc:	48 b8 e1 24 80 00 00 	movabs $0x8024e1,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
  8025e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	89 c7                	mov    %eax,%edi
  8025f0:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	callq  *%rax
	return r;
  8025fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025ff:	c9                   	leaveq 
  802600:	c3                   	retq   

0000000000802601 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 10          	sub    $0x10,%rsp
  802609:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80260c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802610:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802617:	00 00 00 
  80261a:	8b 00                	mov    (%rax),%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	75 1d                	jne    80263d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802620:	bf 01 00 00 00       	mov    $0x1,%edi
  802625:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802638:	00 00 00 
  80263b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80263d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802644:	00 00 00 
  802647:	8b 00                	mov    (%rax),%eax
  802649:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80264c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802651:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802658:	00 00 00 
  80265b:	89 c7                	mov    %eax,%edi
  80265d:	48 b8 24 39 80 00 00 	movabs $0x803924,%rax
  802664:	00 00 00 
  802667:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266d:	ba 00 00 00 00       	mov    $0x0,%edx
  802672:	48 89 c6             	mov    %rax,%rsi
  802675:	bf 00 00 00 00       	mov    $0x0,%edi
  80267a:	48 b8 63 38 80 00 00 	movabs $0x803863,%rax
  802681:	00 00 00 
  802684:	ff d0                	callq  *%rax
}
  802686:	c9                   	leaveq 
  802687:	c3                   	retq   

0000000000802688 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802688:	55                   	push   %rbp
  802689:	48 89 e5             	mov    %rsp,%rbp
  80268c:	48 83 ec 20          	sub    $0x20,%rsp
  802690:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802694:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269b:	48 89 c7             	mov    %rax,%rdi
  80269e:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
  8026aa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026af:	7e 0a                	jle    8026bb <open+0x33>
		return -E_BAD_PATH;
  8026b1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026b6:	e9 a5 00 00 00       	jmpq   802760 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8026bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026bf:	48 89 c7             	mov    %rax,%rdi
  8026c2:	48 b8 e8 1c 80 00 00 	movabs $0x801ce8,%rax
  8026c9:	00 00 00 
  8026cc:	ff d0                	callq  *%rax
  8026ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d5:	79 08                	jns    8026df <open+0x57>
		return r;
  8026d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026da:	e9 81 00 00 00       	jmpq   802760 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8026df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e3:	48 89 c6             	mov    %rax,%rsi
  8026e6:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8026ed:	00 00 00 
  8026f0:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8026fc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802703:	00 00 00 
  802706:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802709:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80270f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802713:	48 89 c6             	mov    %rax,%rsi
  802716:	bf 01 00 00 00       	mov    $0x1,%edi
  80271b:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802722:	00 00 00 
  802725:	ff d0                	callq  *%rax
  802727:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272e:	79 1d                	jns    80274d <open+0xc5>
		fd_close(fd, 0);
  802730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802734:	be 00 00 00 00       	mov    $0x0,%esi
  802739:	48 89 c7             	mov    %rax,%rdi
  80273c:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  802743:	00 00 00 
  802746:	ff d0                	callq  *%rax
		return r;
  802748:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274b:	eb 13                	jmp    802760 <open+0xd8>
	}

	return fd2num(fd);
  80274d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802751:	48 89 c7             	mov    %rax,%rdi
  802754:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802760:	c9                   	leaveq 
  802761:	c3                   	retq   

0000000000802762 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802762:	55                   	push   %rbp
  802763:	48 89 e5             	mov    %rsp,%rbp
  802766:	48 83 ec 10          	sub    $0x10,%rsp
  80276a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80276e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802772:	8b 50 0c             	mov    0xc(%rax),%edx
  802775:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80277c:	00 00 00 
  80277f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802781:	be 00 00 00 00       	mov    $0x0,%esi
  802786:	bf 06 00 00 00       	mov    $0x6,%edi
  80278b:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
}
  802797:	c9                   	leaveq 
  802798:	c3                   	retq   

0000000000802799 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802799:	55                   	push   %rbp
  80279a:	48 89 e5             	mov    %rsp,%rbp
  80279d:	48 83 ec 30          	sub    $0x30,%rsp
  8027a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8027b4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027bb:	00 00 00 
  8027be:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027c0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027c7:	00 00 00 
  8027ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ce:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8027d2:	be 00 00 00 00       	mov    $0x0,%esi
  8027d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8027dc:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8027e3:	00 00 00 
  8027e6:	ff d0                	callq  *%rax
  8027e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ef:	79 08                	jns    8027f9 <devfile_read+0x60>
		return r;
  8027f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f4:	e9 a4 00 00 00       	jmpq   80289d <devfile_read+0x104>
	assert(r <= n);
  8027f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fc:	48 98                	cltq   
  8027fe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802802:	76 35                	jbe    802839 <devfile_read+0xa0>
  802804:	48 b9 fd 40 80 00 00 	movabs $0x8040fd,%rcx
  80280b:	00 00 00 
  80280e:	48 ba 04 41 80 00 00 	movabs $0x804104,%rdx
  802815:	00 00 00 
  802818:	be 84 00 00 00       	mov    $0x84,%esi
  80281d:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  802824:	00 00 00 
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
  80282c:	49 b8 fd 02 80 00 00 	movabs $0x8002fd,%r8
  802833:	00 00 00 
  802836:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802839:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802840:	7e 35                	jle    802877 <devfile_read+0xde>
  802842:	48 b9 24 41 80 00 00 	movabs $0x804124,%rcx
  802849:	00 00 00 
  80284c:	48 ba 04 41 80 00 00 	movabs $0x804104,%rdx
  802853:	00 00 00 
  802856:	be 85 00 00 00       	mov    $0x85,%esi
  80285b:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  802862:	00 00 00 
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	49 b8 fd 02 80 00 00 	movabs $0x8002fd,%r8
  802871:	00 00 00 
  802874:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802877:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287a:	48 63 d0             	movslq %eax,%rdx
  80287d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802881:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802888:	00 00 00 
  80288b:	48 89 c7             	mov    %rax,%rdi
  80288e:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax
	return r;
  80289a:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80289d:	c9                   	leaveq 
  80289e:	c3                   	retq   

000000000080289f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80289f:	55                   	push   %rbp
  8028a0:	48 89 e5             	mov    %rsp,%rbp
  8028a3:	48 83 ec 30          	sub    $0x30,%rsp
  8028a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028c1:	00 00 00 
  8028c4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028c6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028cd:	00 00 00 
  8028d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8028d8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028df:	00 
  8028e0:	76 35                	jbe    802917 <devfile_write+0x78>
  8028e2:	48 b9 30 41 80 00 00 	movabs $0x804130,%rcx
  8028e9:	00 00 00 
  8028ec:	48 ba 04 41 80 00 00 	movabs $0x804104,%rdx
  8028f3:	00 00 00 
  8028f6:	be 9e 00 00 00       	mov    $0x9e,%esi
  8028fb:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  802902:	00 00 00 
  802905:	b8 00 00 00 00       	mov    $0x0,%eax
  80290a:	49 b8 fd 02 80 00 00 	movabs $0x8002fd,%r8
  802911:	00 00 00 
  802914:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802917:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80291b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80291f:	48 89 c6             	mov    %rax,%rsi
  802922:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802929:	00 00 00 
  80292c:	48 b8 39 15 80 00 00 	movabs $0x801539,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802938:	be 00 00 00 00       	mov    $0x0,%esi
  80293d:	bf 04 00 00 00       	mov    $0x4,%edi
  802942:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802949:	00 00 00 
  80294c:	ff d0                	callq  *%rax
  80294e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802951:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802955:	79 05                	jns    80295c <devfile_write+0xbd>
		return r;
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295a:	eb 43                	jmp    80299f <devfile_write+0x100>
	assert(r <= n);
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	48 98                	cltq   
  802961:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802965:	76 35                	jbe    80299c <devfile_write+0xfd>
  802967:	48 b9 fd 40 80 00 00 	movabs $0x8040fd,%rcx
  80296e:	00 00 00 
  802971:	48 ba 04 41 80 00 00 	movabs $0x804104,%rdx
  802978:	00 00 00 
  80297b:	be a2 00 00 00       	mov    $0xa2,%esi
  802980:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  802987:	00 00 00 
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	49 b8 fd 02 80 00 00 	movabs $0x8002fd,%r8
  802996:	00 00 00 
  802999:	41 ff d0             	callq  *%r8
	return r;
  80299c:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80299f:	c9                   	leaveq 
  8029a0:	c3                   	retq   

00000000008029a1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029a1:	55                   	push   %rbp
  8029a2:	48 89 e5             	mov    %rsp,%rbp
  8029a5:	48 83 ec 20          	sub    $0x20,%rsp
  8029a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029b8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029bf:	00 00 00 
  8029c2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029c4:	be 00 00 00 00       	mov    $0x0,%esi
  8029c9:	bf 05 00 00 00       	mov    $0x5,%edi
  8029ce:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
  8029da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e1:	79 05                	jns    8029e8 <devfile_stat+0x47>
		return r;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e6:	eb 56                	jmp    802a3e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ec:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029f3:	00 00 00 
  8029f6:	48 89 c7             	mov    %rax,%rdi
  8029f9:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a05:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a0c:	00 00 00 
  802a0f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a19:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a1f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a26:	00 00 00 
  802a29:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a33:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3e:	c9                   	leaveq 
  802a3f:	c3                   	retq   

0000000000802a40 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a40:	55                   	push   %rbp
  802a41:	48 89 e5             	mov    %rsp,%rbp
  802a44:	48 83 ec 10          	sub    $0x10,%rsp
  802a48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a4c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a53:	8b 50 0c             	mov    0xc(%rax),%edx
  802a56:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a5d:	00 00 00 
  802a60:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a62:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a69:	00 00 00 
  802a6c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a72:	be 00 00 00 00       	mov    $0x0,%esi
  802a77:	bf 02 00 00 00       	mov    $0x2,%edi
  802a7c:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802a83:	00 00 00 
  802a86:	ff d0                	callq  *%rax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <remove>:

// Delete a file
int
remove(const char *path)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 10          	sub    $0x10,%rsp
  802a92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a9a:	48 89 c7             	mov    %rax,%rdi
  802a9d:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  802aa4:	00 00 00 
  802aa7:	ff d0                	callq  *%rax
  802aa9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802aae:	7e 07                	jle    802ab7 <remove+0x2d>
		return -E_BAD_PATH;
  802ab0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ab5:	eb 33                	jmp    802aea <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ab7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802abb:	48 89 c6             	mov    %rax,%rsi
  802abe:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ac5:	00 00 00 
  802ac8:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ad4:	be 00 00 00 00       	mov    $0x0,%esi
  802ad9:	bf 07 00 00 00       	mov    $0x7,%edi
  802ade:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
}
  802aea:	c9                   	leaveq 
  802aeb:	c3                   	retq   

0000000000802aec <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802aec:	55                   	push   %rbp
  802aed:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802af0:	be 00 00 00 00       	mov    $0x0,%esi
  802af5:	bf 08 00 00 00       	mov    $0x8,%edi
  802afa:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
}
  802b06:	5d                   	pop    %rbp
  802b07:	c3                   	retq   

0000000000802b08 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b13:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b1a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b21:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b28:	be 00 00 00 00       	mov    $0x0,%esi
  802b2d:	48 89 c7             	mov    %rax,%rdi
  802b30:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  802b37:	00 00 00 
  802b3a:	ff d0                	callq  *%rax
  802b3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b43:	79 28                	jns    802b6d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b48:	89 c6                	mov    %eax,%esi
  802b4a:	48 bf 5d 41 80 00 00 	movabs $0x80415d,%rdi
  802b51:	00 00 00 
  802b54:	b8 00 00 00 00       	mov    $0x0,%eax
  802b59:	48 ba 36 05 80 00 00 	movabs $0x800536,%rdx
  802b60:	00 00 00 
  802b63:	ff d2                	callq  *%rdx
		return fd_src;
  802b65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b68:	e9 74 01 00 00       	jmpq   802ce1 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b6d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b74:	be 01 01 00 00       	mov    $0x101,%esi
  802b79:	48 89 c7             	mov    %rax,%rdi
  802b7c:	48 b8 88 26 80 00 00 	movabs $0x802688,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
  802b88:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b8b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b8f:	79 39                	jns    802bca <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b94:	89 c6                	mov    %eax,%esi
  802b96:	48 bf 73 41 80 00 00 	movabs $0x804173,%rdi
  802b9d:	00 00 00 
  802ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba5:	48 ba 36 05 80 00 00 	movabs $0x800536,%rdx
  802bac:	00 00 00 
  802baf:	ff d2                	callq  *%rdx
		close(fd_src);
  802bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb4:	89 c7                	mov    %eax,%edi
  802bb6:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	callq  *%rax
		return fd_dest;
  802bc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc5:	e9 17 01 00 00       	jmpq   802ce1 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bca:	eb 74                	jmp    802c40 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802bcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bcf:	48 63 d0             	movslq %eax,%rdx
  802bd2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdc:	48 89 ce             	mov    %rcx,%rsi
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 fc 22 80 00 00 	movabs $0x8022fc,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
  802bed:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802bf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bf4:	79 4a                	jns    802c40 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802bf6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bf9:	89 c6                	mov    %eax,%esi
  802bfb:	48 bf 8d 41 80 00 00 	movabs $0x80418d,%rdi
  802c02:	00 00 00 
  802c05:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0a:	48 ba 36 05 80 00 00 	movabs $0x800536,%rdx
  802c11:	00 00 00 
  802c14:	ff d2                	callq  *%rdx
			close(fd_src);
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
			close(fd_dest);
  802c27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2a:	89 c7                	mov    %eax,%edi
  802c2c:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	callq  *%rax
			return write_size;
  802c38:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c3b:	e9 a1 00 00 00       	jmpq   802ce1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c40:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4a:	ba 00 02 00 00       	mov    $0x200,%edx
  802c4f:	48 89 ce             	mov    %rcx,%rsi
  802c52:	89 c7                	mov    %eax,%edi
  802c54:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  802c5b:	00 00 00 
  802c5e:	ff d0                	callq  *%rax
  802c60:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c67:	0f 8f 5f ff ff ff    	jg     802bcc <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c71:	79 47                	jns    802cba <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c73:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c76:	89 c6                	mov    %eax,%esi
  802c78:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  802c7f:	00 00 00 
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
  802c87:	48 ba 36 05 80 00 00 	movabs $0x800536,%rdx
  802c8e:	00 00 00 
  802c91:	ff d2                	callq  *%rdx
		close(fd_src);
  802c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c96:	89 c7                	mov    %eax,%edi
  802c98:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802c9f:	00 00 00 
  802ca2:	ff d0                	callq  *%rax
		close(fd_dest);
  802ca4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
		return read_size;
  802cb5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cb8:	eb 27                	jmp    802ce1 <copy+0x1d9>
	}
	close(fd_src);
  802cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbd:	89 c7                	mov    %eax,%edi
  802cbf:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
	close(fd_dest);
  802ccb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cce:	89 c7                	mov    %eax,%edi
  802cd0:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
	return 0;
  802cdc:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802ce1:	c9                   	leaveq 
  802ce2:	c3                   	retq   

0000000000802ce3 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802ce3:	55                   	push   %rbp
  802ce4:	48 89 e5             	mov    %rsp,%rbp
  802ce7:	48 83 ec 20          	sub    $0x20,%rsp
  802ceb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802cef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf3:	8b 40 0c             	mov    0xc(%rax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	7e 67                	jle    802d61 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802cfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfe:	8b 40 04             	mov    0x4(%rax),%eax
  802d01:	48 63 d0             	movslq %eax,%rdx
  802d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d08:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d10:	8b 00                	mov    (%rax),%eax
  802d12:	48 89 ce             	mov    %rcx,%rsi
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 fc 22 80 00 00 	movabs $0x8022fc,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
  802d23:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2a:	7e 13                	jle    802d3f <writebuf+0x5c>
			b->result += result;
  802d2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d30:	8b 50 08             	mov    0x8(%rax),%edx
  802d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d36:	01 c2                	add    %eax,%edx
  802d38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3c:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802d3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d43:	8b 40 04             	mov    0x4(%rax),%eax
  802d46:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802d49:	74 16                	je     802d61 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d54:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802d58:	89 c2                	mov    %eax,%edx
  802d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5e:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802d61:	c9                   	leaveq 
  802d62:	c3                   	retq   

0000000000802d63 <putch>:

static void
putch(int ch, void *thunk)
{
  802d63:	55                   	push   %rbp
  802d64:	48 89 e5             	mov    %rsp,%rbp
  802d67:	48 83 ec 20          	sub    $0x20,%rsp
  802d6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802d7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7e:	8b 40 04             	mov    0x4(%rax),%eax
  802d81:	8d 48 01             	lea    0x1(%rax),%ecx
  802d84:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d88:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802d8b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d8e:	89 d1                	mov    %edx,%ecx
  802d90:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d94:	48 98                	cltq   
  802d96:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9e:	8b 40 04             	mov    0x4(%rax),%eax
  802da1:	3d 00 01 00 00       	cmp    $0x100,%eax
  802da6:	75 1e                	jne    802dc6 <putch+0x63>
		writebuf(b);
  802da8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dac:	48 89 c7             	mov    %rax,%rdi
  802daf:	48 b8 e3 2c 80 00 00 	movabs $0x802ce3,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	callq  *%rax
		b->idx = 0;
  802dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802dc6:	c9                   	leaveq 
  802dc7:	c3                   	retq   

0000000000802dc8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802dc8:	55                   	push   %rbp
  802dc9:	48 89 e5             	mov    %rsp,%rbp
  802dcc:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802dd3:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802dd9:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802de0:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802de7:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802ded:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802df3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802dfa:	00 00 00 
	b.result = 0;
  802dfd:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e04:	00 00 00 
	b.error = 1;
  802e07:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e0e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e11:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e18:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e1f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e26:	48 89 c6             	mov    %rax,%rsi
  802e29:	48 bf 63 2d 80 00 00 	movabs $0x802d63,%rdi
  802e30:	00 00 00 
  802e33:	48 b8 e9 08 80 00 00 	movabs $0x8008e9,%rax
  802e3a:	00 00 00 
  802e3d:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802e3f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	7e 16                	jle    802e5f <vfprintf+0x97>
		writebuf(&b);
  802e49:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e50:	48 89 c7             	mov    %rax,%rdi
  802e53:	48 b8 e3 2c 80 00 00 	movabs $0x802ce3,%rax
  802e5a:	00 00 00 
  802e5d:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802e5f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	74 08                	je     802e71 <vfprintf+0xa9>
  802e69:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e6f:	eb 06                	jmp    802e77 <vfprintf+0xaf>
  802e71:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802e77:	c9                   	leaveq 
  802e78:	c3                   	retq   

0000000000802e79 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802e79:	55                   	push   %rbp
  802e7a:	48 89 e5             	mov    %rsp,%rbp
  802e7d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e84:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802e8a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e91:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e98:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e9f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802ea6:	84 c0                	test   %al,%al
  802ea8:	74 20                	je     802eca <fprintf+0x51>
  802eaa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802eae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802eb2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802eb6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802eba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802ebe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ec2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ec6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802eca:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ed1:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802ed8:	00 00 00 
  802edb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ee2:	00 00 00 
  802ee5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ee9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ef0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ef7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802efe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f05:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f0c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f12:	48 89 ce             	mov    %rcx,%rsi
  802f15:	89 c7                	mov    %eax,%edi
  802f17:	48 b8 c8 2d 80 00 00 	movabs $0x802dc8,%rax
  802f1e:	00 00 00 
  802f21:	ff d0                	callq  *%rax
  802f23:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f29:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f2f:	c9                   	leaveq 
  802f30:	c3                   	retq   

0000000000802f31 <printf>:

int
printf(const char *fmt, ...)
{
  802f31:	55                   	push   %rbp
  802f32:	48 89 e5             	mov    %rsp,%rbp
  802f35:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f3c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802f43:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f4a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f51:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f58:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f5f:	84 c0                	test   %al,%al
  802f61:	74 20                	je     802f83 <printf+0x52>
  802f63:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f67:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f6b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f6f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f73:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f77:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f7b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f7f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f83:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f8a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802f91:	00 00 00 
  802f94:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f9b:	00 00 00 
  802f9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fa2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802fa9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802fb0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802fb7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802fbe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802fc5:	48 89 c6             	mov    %rax,%rsi
  802fc8:	bf 01 00 00 00       	mov    $0x1,%edi
  802fcd:	48 b8 c8 2d 80 00 00 	movabs $0x802dc8,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
  802fd9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802fdf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802fe5:	c9                   	leaveq 
  802fe6:	c3                   	retq   

0000000000802fe7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802fe7:	55                   	push   %rbp
  802fe8:	48 89 e5             	mov    %rsp,%rbp
  802feb:	53                   	push   %rbx
  802fec:	48 83 ec 38          	sub    $0x38,%rsp
  802ff0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802ff4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802ff8:	48 89 c7             	mov    %rax,%rdi
  802ffb:	48 b8 e8 1c 80 00 00 	movabs $0x801ce8,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
  803007:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80300a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80300e:	0f 88 bf 01 00 00    	js     8031d3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803018:	ba 07 04 00 00       	mov    $0x407,%edx
  80301d:	48 89 c6             	mov    %rax,%rsi
  803020:	bf 00 00 00 00       	mov    $0x0,%edi
  803025:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  80302c:	00 00 00 
  80302f:	ff d0                	callq  *%rax
  803031:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803034:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803038:	0f 88 95 01 00 00    	js     8031d3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80303e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803042:	48 89 c7             	mov    %rax,%rdi
  803045:	48 b8 e8 1c 80 00 00 	movabs $0x801ce8,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
  803051:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803054:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803058:	0f 88 5d 01 00 00    	js     8031bb <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80305e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803062:	ba 07 04 00 00       	mov    $0x407,%edx
  803067:	48 89 c6             	mov    %rax,%rsi
  80306a:	bf 00 00 00 00       	mov    $0x0,%edi
  80306f:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
  80307b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80307e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803082:	0f 88 33 01 00 00    	js     8031bb <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80308c:	48 89 c7             	mov    %rax,%rdi
  80308f:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80309f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a3:	ba 07 04 00 00       	mov    $0x407,%edx
  8030a8:	48 89 c6             	mov    %rax,%rsi
  8030ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b0:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8030b7:	00 00 00 
  8030ba:	ff d0                	callq  *%rax
  8030bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030c3:	79 05                	jns    8030ca <pipe+0xe3>
		goto err2;
  8030c5:	e9 d9 00 00 00       	jmpq   8031a3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ce:	48 89 c7             	mov    %rax,%rdi
  8030d1:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
  8030dd:	48 89 c2             	mov    %rax,%rdx
  8030e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8030ea:	48 89 d1             	mov    %rdx,%rcx
  8030ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8030f2:	48 89 c6             	mov    %rax,%rsi
  8030f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030fa:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
  803106:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803109:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80310d:	79 1b                	jns    80312a <pipe+0x143>
		goto err3;
  80310f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803110:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803114:	48 89 c6             	mov    %rax,%rsi
  803117:	bf 00 00 00 00       	mov    $0x0,%edi
  80311c:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  803123:	00 00 00 
  803126:	ff d0                	callq  *%rax
  803128:	eb 79                	jmp    8031a3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80312a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80312e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803135:	00 00 00 
  803138:	8b 12                	mov    (%rdx),%edx
  80313a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80313c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803140:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803147:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803152:	00 00 00 
  803155:	8b 12                	mov    (%rdx),%edx
  803157:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803159:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803164:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803168:	48 89 c7             	mov    %rax,%rdi
  80316b:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  803172:	00 00 00 
  803175:	ff d0                	callq  *%rax
  803177:	89 c2                	mov    %eax,%edx
  803179:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80317d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80317f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803183:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803187:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
  80319a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80319c:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a1:	eb 33                	jmp    8031d6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8031a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031a7:	48 89 c6             	mov    %rax,%rsi
  8031aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8031af:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8031bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031bf:	48 89 c6             	mov    %rax,%rsi
  8031c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8031c7:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
err:
	return r;
  8031d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8031d6:	48 83 c4 38          	add    $0x38,%rsp
  8031da:	5b                   	pop    %rbx
  8031db:	5d                   	pop    %rbp
  8031dc:	c3                   	retq   

00000000008031dd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8031dd:	55                   	push   %rbp
  8031de:	48 89 e5             	mov    %rsp,%rbp
  8031e1:	53                   	push   %rbx
  8031e2:	48 83 ec 28          	sub    $0x28,%rsp
  8031e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8031ee:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031f5:	00 00 00 
  8031f8:	48 8b 00             	mov    (%rax),%rax
  8031fb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803201:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803204:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803208:	48 89 c7             	mov    %rax,%rdi
  80320b:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
  803217:	89 c3                	mov    %eax,%ebx
  803219:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80321d:	48 89 c7             	mov    %rax,%rdi
  803220:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803227:	00 00 00 
  80322a:	ff d0                	callq  *%rax
  80322c:	39 c3                	cmp    %eax,%ebx
  80322e:	0f 94 c0             	sete   %al
  803231:	0f b6 c0             	movzbl %al,%eax
  803234:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803237:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80323e:	00 00 00 
  803241:	48 8b 00             	mov    (%rax),%rax
  803244:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80324a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80324d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803250:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803253:	75 05                	jne    80325a <_pipeisclosed+0x7d>
			return ret;
  803255:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803258:	eb 4f                	jmp    8032a9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80325a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80325d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803260:	74 42                	je     8032a4 <_pipeisclosed+0xc7>
  803262:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803266:	75 3c                	jne    8032a4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803268:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80326f:	00 00 00 
  803272:	48 8b 00             	mov    (%rax),%rax
  803275:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80327b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80327e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803281:	89 c6                	mov    %eax,%esi
  803283:	48 bf bb 41 80 00 00 	movabs $0x8041bb,%rdi
  80328a:	00 00 00 
  80328d:	b8 00 00 00 00       	mov    $0x0,%eax
  803292:	49 b8 36 05 80 00 00 	movabs $0x800536,%r8
  803299:	00 00 00 
  80329c:	41 ff d0             	callq  *%r8
	}
  80329f:	e9 4a ff ff ff       	jmpq   8031ee <_pipeisclosed+0x11>
  8032a4:	e9 45 ff ff ff       	jmpq   8031ee <_pipeisclosed+0x11>
}
  8032a9:	48 83 c4 28          	add    $0x28,%rsp
  8032ad:	5b                   	pop    %rbx
  8032ae:	5d                   	pop    %rbp
  8032af:	c3                   	retq   

00000000008032b0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8032b0:	55                   	push   %rbp
  8032b1:	48 89 e5             	mov    %rsp,%rbp
  8032b4:	48 83 ec 30          	sub    $0x30,%rsp
  8032b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032c2:	48 89 d6             	mov    %rdx,%rsi
  8032c5:	89 c7                	mov    %eax,%edi
  8032c7:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032da:	79 05                	jns    8032e1 <pipeisclosed+0x31>
		return r;
  8032dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032df:	eb 31                	jmp    803312 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8032e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e5:	48 89 c7             	mov    %rax,%rdi
  8032e8:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  8032ef:	00 00 00 
  8032f2:	ff d0                	callq  *%rax
  8032f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8032f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803300:	48 89 d6             	mov    %rdx,%rsi
  803303:	48 89 c7             	mov    %rax,%rdi
  803306:	48 b8 dd 31 80 00 00 	movabs $0x8031dd,%rax
  80330d:	00 00 00 
  803310:	ff d0                	callq  *%rax
}
  803312:	c9                   	leaveq 
  803313:	c3                   	retq   

0000000000803314 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803314:	55                   	push   %rbp
  803315:	48 89 e5             	mov    %rsp,%rbp
  803318:	48 83 ec 40          	sub    $0x40,%rsp
  80331c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803320:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803324:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803328:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332c:	48 89 c7             	mov    %rax,%rdi
  80332f:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
  80333b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80333f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803343:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803347:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80334e:	00 
  80334f:	e9 92 00 00 00       	jmpq   8033e6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803354:	eb 41                	jmp    803397 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803356:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80335b:	74 09                	je     803366 <devpipe_read+0x52>
				return i;
  80335d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803361:	e9 92 00 00 00       	jmpq   8033f8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803366:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80336a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336e:	48 89 d6             	mov    %rdx,%rsi
  803371:	48 89 c7             	mov    %rax,%rdi
  803374:	48 b8 dd 31 80 00 00 	movabs $0x8031dd,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 07                	je     80338b <devpipe_read+0x77>
				return 0;
  803384:	b8 00 00 00 00       	mov    $0x0,%eax
  803389:	eb 6d                	jmp    8033f8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80338b:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80339b:	8b 10                	mov    (%rax),%edx
  80339d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a1:	8b 40 04             	mov    0x4(%rax),%eax
  8033a4:	39 c2                	cmp    %eax,%edx
  8033a6:	74 ae                	je     803356 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033b0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8033b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b8:	8b 00                	mov    (%rax),%eax
  8033ba:	99                   	cltd   
  8033bb:	c1 ea 1b             	shr    $0x1b,%edx
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	83 e0 1f             	and    $0x1f,%eax
  8033c3:	29 d0                	sub    %edx,%eax
  8033c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c9:	48 98                	cltq   
  8033cb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8033d0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8033d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d6:	8b 00                	mov    (%rax),%eax
  8033d8:	8d 50 01             	lea    0x1(%rax),%edx
  8033db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033df:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ea:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033ee:	0f 82 60 ff ff ff    	jb     803354 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8033f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033f8:	c9                   	leaveq 
  8033f9:	c3                   	retq   

00000000008033fa <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033fa:	55                   	push   %rbp
  8033fb:	48 89 e5             	mov    %rsp,%rbp
  8033fe:	48 83 ec 40          	sub    $0x40,%rsp
  803402:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803406:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80340a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80340e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803412:	48 89 c7             	mov    %rax,%rdi
  803415:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
  803421:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803429:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80342d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803434:	00 
  803435:	e9 8e 00 00 00       	jmpq   8034c8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80343a:	eb 31                	jmp    80346d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80343c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803444:	48 89 d6             	mov    %rdx,%rsi
  803447:	48 89 c7             	mov    %rax,%rdi
  80344a:	48 b8 dd 31 80 00 00 	movabs $0x8031dd,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 07                	je     803461 <devpipe_write+0x67>
				return 0;
  80345a:	b8 00 00 00 00       	mov    $0x0,%eax
  80345f:	eb 79                	jmp    8034da <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803461:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  803468:	00 00 00 
  80346b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80346d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803471:	8b 40 04             	mov    0x4(%rax),%eax
  803474:	48 63 d0             	movslq %eax,%rdx
  803477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347b:	8b 00                	mov    (%rax),%eax
  80347d:	48 98                	cltq   
  80347f:	48 83 c0 20          	add    $0x20,%rax
  803483:	48 39 c2             	cmp    %rax,%rdx
  803486:	73 b4                	jae    80343c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348c:	8b 40 04             	mov    0x4(%rax),%eax
  80348f:	99                   	cltd   
  803490:	c1 ea 1b             	shr    $0x1b,%edx
  803493:	01 d0                	add    %edx,%eax
  803495:	83 e0 1f             	and    $0x1f,%eax
  803498:	29 d0                	sub    %edx,%eax
  80349a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80349e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8034a2:	48 01 ca             	add    %rcx,%rdx
  8034a5:	0f b6 0a             	movzbl (%rdx),%ecx
  8034a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034ac:	48 98                	cltq   
  8034ae:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	8b 40 04             	mov    0x4(%rax),%eax
  8034b9:	8d 50 01             	lea    0x1(%rax),%edx
  8034bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034cc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034d0:	0f 82 64 ff ff ff    	jb     80343a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8034d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034da:	c9                   	leaveq 
  8034db:	c3                   	retq   

00000000008034dc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8034dc:	55                   	push   %rbp
  8034dd:	48 89 e5             	mov    %rsp,%rbp
  8034e0:	48 83 ec 20          	sub    $0x20,%rsp
  8034e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8034ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f0:	48 89 c7             	mov    %rax,%rdi
  8034f3:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  8034fa:	00 00 00 
  8034fd:	ff d0                	callq  *%rax
  8034ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803507:	48 be ce 41 80 00 00 	movabs $0x8041ce,%rsi
  80350e:	00 00 00 
  803511:	48 89 c7             	mov    %rax,%rdi
  803514:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803520:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803524:	8b 50 04             	mov    0x4(%rax),%edx
  803527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352b:	8b 00                	mov    (%rax),%eax
  80352d:	29 c2                	sub    %eax,%edx
  80352f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803533:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803544:	00 00 00 
	stat->st_dev = &devpipe;
  803547:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354b:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803552:	00 00 00 
  803555:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80355c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803561:	c9                   	leaveq 
  803562:	c3                   	retq   

0000000000803563 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803563:	55                   	push   %rbp
  803564:	48 89 e5             	mov    %rsp,%rbp
  803567:	48 83 ec 10          	sub    $0x10,%rsp
  80356b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80356f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803573:	48 89 c6             	mov    %rax,%rsi
  803576:	bf 00 00 00 00       	mov    $0x0,%edi
  80357b:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358b:	48 89 c7             	mov    %rax,%rdi
  80358e:	48 b8 bd 1c 80 00 00 	movabs $0x801cbd,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
  80359a:	48 89 c6             	mov    %rax,%rsi
  80359d:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a2:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
}
  8035ae:	c9                   	leaveq 
  8035af:	c3                   	retq   

00000000008035b0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8035b0:	55                   	push   %rbp
  8035b1:	48 89 e5             	mov    %rsp,%rbp
  8035b4:	48 83 ec 20          	sub    $0x20,%rsp
  8035b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8035bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035be:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8035c1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8035c5:	be 01 00 00 00       	mov    $0x1,%esi
  8035ca:	48 89 c7             	mov    %rax,%rdi
  8035cd:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
}
  8035d9:	c9                   	leaveq 
  8035da:	c3                   	retq   

00000000008035db <getchar>:

int
getchar(void)
{
  8035db:	55                   	push   %rbp
  8035dc:	48 89 e5             	mov    %rsp,%rbp
  8035df:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8035e3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8035e7:	ba 01 00 00 00       	mov    $0x1,%edx
  8035ec:	48 89 c6             	mov    %rax,%rsi
  8035ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f4:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
  803600:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803603:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803607:	79 05                	jns    80360e <getchar+0x33>
		return r;
  803609:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360c:	eb 14                	jmp    803622 <getchar+0x47>
	if (r < 1)
  80360e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803612:	7f 07                	jg     80361b <getchar+0x40>
		return -E_EOF;
  803614:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803619:	eb 07                	jmp    803622 <getchar+0x47>
	return c;
  80361b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80361f:	0f b6 c0             	movzbl %al,%eax
}
  803622:	c9                   	leaveq 
  803623:	c3                   	retq   

0000000000803624 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803624:	55                   	push   %rbp
  803625:	48 89 e5             	mov    %rsp,%rbp
  803628:	48 83 ec 20          	sub    $0x20,%rsp
  80362c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80362f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803633:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803636:	48 89 d6             	mov    %rdx,%rsi
  803639:	89 c7                	mov    %eax,%edi
  80363b:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  803642:	00 00 00 
  803645:	ff d0                	callq  *%rax
  803647:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364e:	79 05                	jns    803655 <iscons+0x31>
		return r;
  803650:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803653:	eb 1a                	jmp    80366f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803659:	8b 10                	mov    (%rax),%edx
  80365b:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803662:	00 00 00 
  803665:	8b 00                	mov    (%rax),%eax
  803667:	39 c2                	cmp    %eax,%edx
  803669:	0f 94 c0             	sete   %al
  80366c:	0f b6 c0             	movzbl %al,%eax
}
  80366f:	c9                   	leaveq 
  803670:	c3                   	retq   

0000000000803671 <opencons>:

int
opencons(void)
{
  803671:	55                   	push   %rbp
  803672:	48 89 e5             	mov    %rsp,%rbp
  803675:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803679:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80367d:	48 89 c7             	mov    %rax,%rdi
  803680:	48 b8 e8 1c 80 00 00 	movabs $0x801ce8,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
  80368c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80368f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803693:	79 05                	jns    80369a <opencons+0x29>
		return r;
  803695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803698:	eb 5b                	jmp    8036f5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80369a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369e:	ba 07 04 00 00       	mov    $0x407,%edx
  8036a3:	48 89 c6             	mov    %rax,%rsi
  8036a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ab:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8036b2:	00 00 00 
  8036b5:	ff d0                	callq  *%rax
  8036b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036be:	79 05                	jns    8036c5 <opencons+0x54>
		return r;
  8036c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c3:	eb 30                	jmp    8036f5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8036c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c9:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8036d0:	00 00 00 
  8036d3:	8b 12                	mov    (%rdx),%edx
  8036d5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8036d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8036e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e6:	48 89 c7             	mov    %rax,%rdi
  8036e9:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
}
  8036f5:	c9                   	leaveq 
  8036f6:	c3                   	retq   

00000000008036f7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036f7:	55                   	push   %rbp
  8036f8:	48 89 e5             	mov    %rsp,%rbp
  8036fb:	48 83 ec 30          	sub    $0x30,%rsp
  8036ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803703:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803707:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80370b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803710:	75 07                	jne    803719 <devcons_read+0x22>
		return 0;
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
  803717:	eb 4b                	jmp    803764 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803719:	eb 0c                	jmp    803727 <devcons_read+0x30>
		sys_yield();
  80371b:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803727:	48 b8 2f 19 80 00 00 	movabs $0x80192f,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
  803733:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803736:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80373a:	74 df                	je     80371b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80373c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803740:	79 05                	jns    803747 <devcons_read+0x50>
		return c;
  803742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803745:	eb 1d                	jmp    803764 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803747:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80374b:	75 07                	jne    803754 <devcons_read+0x5d>
		return 0;
  80374d:	b8 00 00 00 00       	mov    $0x0,%eax
  803752:	eb 10                	jmp    803764 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803757:	89 c2                	mov    %eax,%edx
  803759:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80375d:	88 10                	mov    %dl,(%rax)
	return 1;
  80375f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803764:	c9                   	leaveq 
  803765:	c3                   	retq   

0000000000803766 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803766:	55                   	push   %rbp
  803767:	48 89 e5             	mov    %rsp,%rbp
  80376a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803771:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803778:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80377f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803786:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80378d:	eb 76                	jmp    803805 <devcons_write+0x9f>
		m = n - tot;
  80378f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803796:	89 c2                	mov    %eax,%edx
  803798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379b:	29 c2                	sub    %eax,%edx
  80379d:	89 d0                	mov    %edx,%eax
  80379f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8037a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037a5:	83 f8 7f             	cmp    $0x7f,%eax
  8037a8:	76 07                	jbe    8037b1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8037aa:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8037b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037b4:	48 63 d0             	movslq %eax,%rdx
  8037b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ba:	48 63 c8             	movslq %eax,%rcx
  8037bd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8037c4:	48 01 c1             	add    %rax,%rcx
  8037c7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8037ce:	48 89 ce             	mov    %rcx,%rsi
  8037d1:	48 89 c7             	mov    %rax,%rdi
  8037d4:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  8037db:	00 00 00 
  8037de:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8037e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037e3:	48 63 d0             	movslq %eax,%rdx
  8037e6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8037ed:	48 89 d6             	mov    %rdx,%rsi
  8037f0:	48 89 c7             	mov    %rax,%rdi
  8037f3:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803802:	01 45 fc             	add    %eax,-0x4(%rbp)
  803805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803808:	48 98                	cltq   
  80380a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803811:	0f 82 78 ff ff ff    	jb     80378f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803817:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80381a:	c9                   	leaveq 
  80381b:	c3                   	retq   

000000000080381c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80381c:	55                   	push   %rbp
  80381d:	48 89 e5             	mov    %rsp,%rbp
  803820:	48 83 ec 08          	sub    $0x8,%rsp
  803824:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803828:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80382d:	c9                   	leaveq 
  80382e:	c3                   	retq   

000000000080382f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80382f:	55                   	push   %rbp
  803830:	48 89 e5             	mov    %rsp,%rbp
  803833:	48 83 ec 10          	sub    $0x10,%rsp
  803837:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80383b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80383f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803843:	48 be da 41 80 00 00 	movabs $0x8041da,%rsi
  80384a:	00 00 00 
  80384d:	48 89 c7             	mov    %rax,%rdi
  803850:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
	return 0;
  80385c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803861:	c9                   	leaveq 
  803862:	c3                   	retq   

0000000000803863 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803863:	55                   	push   %rbp
  803864:	48 89 e5             	mov    %rsp,%rbp
  803867:	48 83 ec 30          	sub    $0x30,%rsp
  80386b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80386f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803873:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803877:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80387c:	75 0e                	jne    80388c <ipc_recv+0x29>
        pg = (void *)UTOP;
  80387e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803885:	00 00 00 
  803888:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  80388c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803890:	48 89 c7             	mov    %rax,%rdi
  803893:	48 b8 56 1c 80 00 00 	movabs $0x801c56,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a6:	79 27                	jns    8038cf <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8038a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8038ad:	74 0a                	je     8038b9 <ipc_recv+0x56>
            *from_env_store = 0;
  8038af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8038b9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038be:	74 0a                	je     8038ca <ipc_recv+0x67>
            *perm_store = 0;
  8038c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8038ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cd:	eb 53                	jmp    803922 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8038cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8038d4:	74 19                	je     8038ef <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8038d6:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8038dd:	00 00 00 
  8038e0:	48 8b 00             	mov    (%rax),%rax
  8038e3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8038e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ed:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8038ef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038f4:	74 19                	je     80390f <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8038f6:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8038fd:	00 00 00 
  803900:	48 8b 00             	mov    (%rax),%rax
  803903:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803909:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390d:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80390f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803916:	00 00 00 
  803919:	48 8b 00             	mov    (%rax),%rax
  80391c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803922:	c9                   	leaveq 
  803923:	c3                   	retq   

0000000000803924 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803924:	55                   	push   %rbp
  803925:	48 89 e5             	mov    %rsp,%rbp
  803928:	48 83 ec 30          	sub    $0x30,%rsp
  80392c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80392f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803932:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803936:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803939:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80393e:	75 0e                	jne    80394e <ipc_send+0x2a>
        pg = (void *)UTOP;
  803940:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803947:	00 00 00 
  80394a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  80394e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803951:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803954:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803958:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395b:	89 c7                	mov    %eax,%edi
  80395d:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
  803969:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  80396c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803970:	79 36                	jns    8039a8 <ipc_send+0x84>
  803972:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803976:	74 30                	je     8039a8 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	89 c1                	mov    %eax,%ecx
  80397d:	48 ba e1 41 80 00 00 	movabs $0x8041e1,%rdx
  803984:	00 00 00 
  803987:	be 49 00 00 00       	mov    $0x49,%esi
  80398c:	48 bf ee 41 80 00 00 	movabs $0x8041ee,%rdi
  803993:	00 00 00 
  803996:	b8 00 00 00 00       	mov    $0x0,%eax
  80399b:	49 b8 fd 02 80 00 00 	movabs $0x8002fd,%r8
  8039a2:	00 00 00 
  8039a5:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8039a8:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
    } while(r != 0);
  8039b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b8:	75 94                	jne    80394e <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8039ba:	c9                   	leaveq 
  8039bb:	c3                   	retq   

00000000008039bc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8039bc:	55                   	push   %rbp
  8039bd:	48 89 e5             	mov    %rsp,%rbp
  8039c0:	48 83 ec 14          	sub    $0x14,%rsp
  8039c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8039c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039ce:	eb 5e                	jmp    803a2e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8039d0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8039d7:	00 00 00 
  8039da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039dd:	48 63 d0             	movslq %eax,%rdx
  8039e0:	48 89 d0             	mov    %rdx,%rax
  8039e3:	48 c1 e0 03          	shl    $0x3,%rax
  8039e7:	48 01 d0             	add    %rdx,%rax
  8039ea:	48 c1 e0 05          	shl    $0x5,%rax
  8039ee:	48 01 c8             	add    %rcx,%rax
  8039f1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8039f7:	8b 00                	mov    (%rax),%eax
  8039f9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039fc:	75 2c                	jne    803a2a <ipc_find_env+0x6e>
			return envs[i].env_id;
  8039fe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a05:	00 00 00 
  803a08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0b:	48 63 d0             	movslq %eax,%rdx
  803a0e:	48 89 d0             	mov    %rdx,%rax
  803a11:	48 c1 e0 03          	shl    $0x3,%rax
  803a15:	48 01 d0             	add    %rdx,%rax
  803a18:	48 c1 e0 05          	shl    $0x5,%rax
  803a1c:	48 01 c8             	add    %rcx,%rax
  803a1f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803a25:	8b 40 08             	mov    0x8(%rax),%eax
  803a28:	eb 12                	jmp    803a3c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803a2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a2e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803a35:	7e 99                	jle    8039d0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a3c:	c9                   	leaveq 
  803a3d:	c3                   	retq   

0000000000803a3e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a3e:	55                   	push   %rbp
  803a3f:	48 89 e5             	mov    %rsp,%rbp
  803a42:	48 83 ec 18          	sub    $0x18,%rsp
  803a46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a4e:	48 c1 e8 15          	shr    $0x15,%rax
  803a52:	48 89 c2             	mov    %rax,%rdx
  803a55:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a5c:	01 00 00 
  803a5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a63:	83 e0 01             	and    $0x1,%eax
  803a66:	48 85 c0             	test   %rax,%rax
  803a69:	75 07                	jne    803a72 <pageref+0x34>
		return 0;
  803a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a70:	eb 53                	jmp    803ac5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a76:	48 c1 e8 0c          	shr    $0xc,%rax
  803a7a:	48 89 c2             	mov    %rax,%rdx
  803a7d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a84:	01 00 00 
  803a87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a93:	83 e0 01             	and    $0x1,%eax
  803a96:	48 85 c0             	test   %rax,%rax
  803a99:	75 07                	jne    803aa2 <pageref+0x64>
		return 0;
  803a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa0:	eb 23                	jmp    803ac5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803aa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aa6:	48 c1 e8 0c          	shr    $0xc,%rax
  803aaa:	48 89 c2             	mov    %rax,%rdx
  803aad:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ab4:	00 00 00 
  803ab7:	48 c1 e2 04          	shl    $0x4,%rdx
  803abb:	48 01 d0             	add    %rdx,%rax
  803abe:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ac2:	0f b7 c0             	movzwl %ax,%eax
}
  803ac5:	c9                   	leaveq 
  803ac6:	c3                   	retq   
