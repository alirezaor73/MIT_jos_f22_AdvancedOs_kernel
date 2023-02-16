
obj/user/num:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 60 3b 80 00 00 	movabs $0x803b60,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba c0 2f 80 00 00 	movabs $0x802fc0,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 65 3b 80 00 00 	movabs $0x803b65,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 80 3b 80 00 00 	movabs $0x803b80,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 8b 3b 80 00 00 	movabs $0x803b8b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 80 3b 80 00 00 	movabs $0x803b80,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb a0 3b 80 00 00 	movabs $0x803ba0,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be a4 3b 80 00 00 	movabs $0x803ba4,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba ac 3b 80 00 00 	movabs $0x803bac,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf 80 3b 80 00 00 	movabs $0x803b80,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 20          	sub    $0x20,%rsp
  8002e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8002e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8002e7:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8002f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002fe:	48 63 d0             	movslq %eax,%rdx
  800301:	48 89 d0             	mov    %rdx,%rax
  800304:	48 c1 e0 03          	shl    $0x3,%rax
  800308:	48 01 d0             	add    %rdx,%rax
  80030b:	48 c1 e0 05          	shl    $0x5,%rax
  80030f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800316:	00 00 00 
  800319:	48 01 c2             	add    %rax,%rdx
  80031c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800323:	00 00 00 
  800326:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800329:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032d:	7e 14                	jle    800343 <libmain+0x6b>
		binaryname = argv[0];
  80032f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800333:	48 8b 10             	mov    (%rax),%rdx
  800336:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80033d:	00 00 00 
  800340:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800343:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800347:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80034a:	48 89 d6             	mov    %rdx,%rsi
  80034d:	89 c7                	mov    %eax,%edi
  80034f:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800356:	00 00 00 
  800359:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80035b:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  800362:	00 00 00 
  800365:	ff d0                	callq  *%rax
}
  800367:	c9                   	leaveq 
  800368:	c3                   	retq   

0000000000800369 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80036d:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800379:	bf 00 00 00 00       	mov    $0x0,%edi
  80037e:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax
}
  80038a:	5d                   	pop    %rbp
  80038b:	c3                   	retq   

000000000080038c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038c:	55                   	push   %rbp
  80038d:	48 89 e5             	mov    %rsp,%rbp
  800390:	53                   	push   %rbx
  800391:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800398:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80039f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003a5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003ac:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003b3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003ba:	84 c0                	test   %al,%al
  8003bc:	74 23                	je     8003e1 <_panic+0x55>
  8003be:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003c5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003cd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003d1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003d5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003dd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003e1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003ef:	00 00 00 
  8003f2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f9:	00 00 00 
  8003fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800400:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800407:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80040e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800415:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80041c:	00 00 00 
  80041f:	48 8b 18             	mov    (%rax),%rbx
  800422:	48 b8 40 1a 80 00 00 	movabs $0x801a40,%rax
  800429:	00 00 00 
  80042c:	ff d0                	callq  *%rax
  80042e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800434:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80043b:	41 89 c8             	mov    %ecx,%r8d
  80043e:	48 89 d1             	mov    %rdx,%rcx
  800441:	48 89 da             	mov    %rbx,%rdx
  800444:	89 c6                	mov    %eax,%esi
  800446:	48 bf c8 3b 80 00 00 	movabs $0x803bc8,%rdi
  80044d:	00 00 00 
  800450:	b8 00 00 00 00       	mov    $0x0,%eax
  800455:	49 b9 c5 05 80 00 00 	movabs $0x8005c5,%r9
  80045c:	00 00 00 
  80045f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800462:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800469:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800470:	48 89 d6             	mov    %rdx,%rsi
  800473:	48 89 c7             	mov    %rax,%rdi
  800476:	48 b8 19 05 80 00 00 	movabs $0x800519,%rax
  80047d:	00 00 00 
  800480:	ff d0                	callq  *%rax
	cprintf("\n");
  800482:	48 bf eb 3b 80 00 00 	movabs $0x803beb,%rdi
  800489:	00 00 00 
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
  800491:	48 ba c5 05 80 00 00 	movabs $0x8005c5,%rdx
  800498:	00 00 00 
  80049b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80049d:	cc                   	int3   
  80049e:	eb fd                	jmp    80049d <_panic+0x111>

00000000008004a0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	48 83 ec 10          	sub    $0x10,%rsp
  8004a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b3:	8b 00                	mov    (%rax),%eax
  8004b5:	8d 48 01             	lea    0x1(%rax),%ecx
  8004b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004bc:	89 0a                	mov    %ecx,(%rdx)
  8004be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004c1:	89 d1                	mov    %edx,%ecx
  8004c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c7:	48 98                	cltq   
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d1:	8b 00                	mov    (%rax),%eax
  8004d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d8:	75 2c                	jne    800506 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004de:	8b 00                	mov    (%rax),%eax
  8004e0:	48 98                	cltq   
  8004e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e6:	48 83 c2 08          	add    $0x8,%rdx
  8004ea:	48 89 c6             	mov    %rax,%rsi
  8004ed:	48 89 d7             	mov    %rdx,%rdi
  8004f0:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8004f7:	00 00 00 
  8004fa:	ff d0                	callq  *%rax
        b->idx = 0;
  8004fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800500:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050a:	8b 40 04             	mov    0x4(%rax),%eax
  80050d:	8d 50 01             	lea    0x1(%rax),%edx
  800510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800514:	89 50 04             	mov    %edx,0x4(%rax)
}
  800517:	c9                   	leaveq 
  800518:	c3                   	retq   

0000000000800519 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800524:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80052b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800532:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800539:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800540:	48 8b 0a             	mov    (%rdx),%rcx
  800543:	48 89 08             	mov    %rcx,(%rax)
  800546:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800552:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800556:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80055d:	00 00 00 
    b.cnt = 0;
  800560:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800567:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80056a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800571:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800578:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80057f:	48 89 c6             	mov    %rax,%rsi
  800582:	48 bf a0 04 80 00 00 	movabs $0x8004a0,%rdi
  800589:	00 00 00 
  80058c:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  800593:	00 00 00 
  800596:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800598:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a7:	48 83 c2 08          	add    $0x8,%rdx
  8005ab:	48 89 c6             	mov    %rax,%rsi
  8005ae:	48 89 d7             	mov    %rdx,%rdi
  8005b1:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005c3:	c9                   	leaveq 
  8005c4:	c3                   	retq   

00000000008005c5 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005c5:	55                   	push   %rbp
  8005c6:	48 89 e5             	mov    %rsp,%rbp
  8005c9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005d0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005f3:	84 c0                	test   %al,%al
  8005f5:	74 20                	je     800617 <cprintf+0x52>
  8005f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800603:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800607:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80060b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80060f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800613:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800617:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80061e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800625:	00 00 00 
  800628:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80062f:	00 00 00 
  800632:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800636:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80063d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800644:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80064b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800652:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800659:	48 8b 0a             	mov    (%rdx),%rcx
  80065c:	48 89 08             	mov    %rcx,(%rax)
  80065f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800663:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800667:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80066b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80066f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800676:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80067d:	48 89 d6             	mov    %rdx,%rsi
  800680:	48 89 c7             	mov    %rax,%rdi
  800683:	48 b8 19 05 80 00 00 	movabs $0x800519,%rax
  80068a:	00 00 00 
  80068d:	ff d0                	callq  *%rax
  80068f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800695:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80069b:	c9                   	leaveq 
  80069c:	c3                   	retq   

000000000080069d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069d:	55                   	push   %rbp
  80069e:	48 89 e5             	mov    %rsp,%rbp
  8006a1:	53                   	push   %rbx
  8006a2:	48 83 ec 38          	sub    $0x38,%rsp
  8006a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006b2:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006b5:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006b9:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006bd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006c0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006c4:	77 3b                	ja     800701 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006c9:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006cd:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	48 f7 f3             	div    %rbx
  8006dc:	48 89 c2             	mov    %rax,%rdx
  8006df:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006e2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006e5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	41 89 f9             	mov    %edi,%r9d
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
  8006ff:	eb 1e                	jmp    80071f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800701:	eb 12                	jmp    800715 <printnum+0x78>
			putch(padc, putdat);
  800703:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800707:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	48 89 ce             	mov    %rcx,%rsi
  800711:	89 d7                	mov    %edx,%edi
  800713:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800715:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800719:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80071d:	7f e4                	jg     800703 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	48 f7 f1             	div    %rcx
  80072e:	48 89 d0             	mov    %rdx,%rax
  800731:	48 ba f0 3d 80 00 00 	movabs $0x803df0,%rdx
  800738:	00 00 00 
  80073b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80073f:	0f be d0             	movsbl %al,%edx
  800742:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	48 89 ce             	mov    %rcx,%rsi
  80074d:	89 d7                	mov    %edx,%edi
  80074f:	ff d0                	callq  *%rax
}
  800751:	48 83 c4 38          	add    $0x38,%rsp
  800755:	5b                   	pop    %rbx
  800756:	5d                   	pop    %rbp
  800757:	c3                   	retq   

0000000000800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %rbp
  800759:	48 89 e5             	mov    %rsp,%rbp
  80075c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800760:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800764:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800767:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076b:	7e 52                	jle    8007bf <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	83 f8 30             	cmp    $0x30,%eax
  800776:	73 24                	jae    80079c <getuint+0x44>
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	8b 00                	mov    (%rax),%eax
  800786:	89 c0                	mov    %eax,%eax
  800788:	48 01 d0             	add    %rdx,%rax
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	8b 12                	mov    (%rdx),%edx
  800791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800798:	89 0a                	mov    %ecx,(%rdx)
  80079a:	eb 17                	jmp    8007b3 <getuint+0x5b>
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a4:	48 89 d0             	mov    %rdx,%rax
  8007a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b3:	48 8b 00             	mov    (%rax),%rax
  8007b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ba:	e9 a3 00 00 00       	jmpq   800862 <getuint+0x10a>
	else if (lflag)
  8007bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c3:	74 4f                	je     800814 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	8b 00                	mov    (%rax),%eax
  8007cb:	83 f8 30             	cmp    $0x30,%eax
  8007ce:	73 24                	jae    8007f4 <getuint+0x9c>
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	8b 00                	mov    (%rax),%eax
  8007de:	89 c0                	mov    %eax,%eax
  8007e0:	48 01 d0             	add    %rdx,%rax
  8007e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e7:	8b 12                	mov    (%rdx),%edx
  8007e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f0:	89 0a                	mov    %ecx,(%rdx)
  8007f2:	eb 17                	jmp    80080b <getuint+0xb3>
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fc:	48 89 d0             	mov    %rdx,%rax
  8007ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080b:	48 8b 00             	mov    (%rax),%rax
  80080e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800812:	eb 4e                	jmp    800862 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	83 f8 30             	cmp    $0x30,%eax
  80081d:	73 24                	jae    800843 <getuint+0xeb>
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	8b 00                	mov    (%rax),%eax
  80082d:	89 c0                	mov    %eax,%eax
  80082f:	48 01 d0             	add    %rdx,%rax
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	8b 12                	mov    (%rdx),%edx
  800838:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	89 0a                	mov    %ecx,(%rdx)
  800841:	eb 17                	jmp    80085a <getuint+0x102>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084b:	48 89 d0             	mov    %rdx,%rax
  80084e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800852:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800856:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085a:	8b 00                	mov    (%rax),%eax
  80085c:	89 c0                	mov    %eax,%eax
  80085e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800866:	c9                   	leaveq 
  800867:	c3                   	retq   

0000000000800868 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800868:	55                   	push   %rbp
  800869:	48 89 e5             	mov    %rsp,%rbp
  80086c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800870:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800874:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800877:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80087b:	7e 52                	jle    8008cf <getint+0x67>
		x=va_arg(*ap, long long);
  80087d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800881:	8b 00                	mov    (%rax),%eax
  800883:	83 f8 30             	cmp    $0x30,%eax
  800886:	73 24                	jae    8008ac <getint+0x44>
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	8b 00                	mov    (%rax),%eax
  800896:	89 c0                	mov    %eax,%eax
  800898:	48 01 d0             	add    %rdx,%rax
  80089b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089f:	8b 12                	mov    (%rdx),%edx
  8008a1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a8:	89 0a                	mov    %ecx,(%rdx)
  8008aa:	eb 17                	jmp    8008c3 <getint+0x5b>
  8008ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b4:	48 89 d0             	mov    %rdx,%rax
  8008b7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008c3:	48 8b 00             	mov    (%rax),%rax
  8008c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ca:	e9 a3 00 00 00       	jmpq   800972 <getint+0x10a>
	else if (lflag)
  8008cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008d3:	74 4f                	je     800924 <getint+0xbc>
		x=va_arg(*ap, long);
  8008d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d9:	8b 00                	mov    (%rax),%eax
  8008db:	83 f8 30             	cmp    $0x30,%eax
  8008de:	73 24                	jae    800904 <getint+0x9c>
  8008e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ec:	8b 00                	mov    (%rax),%eax
  8008ee:	89 c0                	mov    %eax,%eax
  8008f0:	48 01 d0             	add    %rdx,%rax
  8008f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f7:	8b 12                	mov    (%rdx),%edx
  8008f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800900:	89 0a                	mov    %ecx,(%rdx)
  800902:	eb 17                	jmp    80091b <getint+0xb3>
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80090c:	48 89 d0             	mov    %rdx,%rax
  80090f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800913:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800917:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091b:	48 8b 00             	mov    (%rax),%rax
  80091e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800922:	eb 4e                	jmp    800972 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800928:	8b 00                	mov    (%rax),%eax
  80092a:	83 f8 30             	cmp    $0x30,%eax
  80092d:	73 24                	jae    800953 <getint+0xeb>
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	8b 00                	mov    (%rax),%eax
  80093d:	89 c0                	mov    %eax,%eax
  80093f:	48 01 d0             	add    %rdx,%rax
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	8b 12                	mov    (%rdx),%edx
  800948:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094f:	89 0a                	mov    %ecx,(%rdx)
  800951:	eb 17                	jmp    80096a <getint+0x102>
  800953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800957:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095b:	48 89 d0             	mov    %rdx,%rax
  80095e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800962:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800966:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80096a:	8b 00                	mov    (%rax),%eax
  80096c:	48 98                	cltq   
  80096e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800976:	c9                   	leaveq 
  800977:	c3                   	retq   

0000000000800978 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800978:	55                   	push   %rbp
  800979:	48 89 e5             	mov    %rsp,%rbp
  80097c:	41 54                	push   %r12
  80097e:	53                   	push   %rbx
  80097f:	48 83 ec 60          	sub    $0x60,%rsp
  800983:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800987:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80098b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800993:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800997:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80099b:	48 8b 0a             	mov    (%rdx),%rcx
  80099e:	48 89 08             	mov    %rcx,(%rax)
  8009a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b1:	eb 17                	jmp    8009ca <vprintfmt+0x52>
			if (ch == '\0')
  8009b3:	85 db                	test   %ebx,%ebx
  8009b5:	0f 84 df 04 00 00    	je     800e9a <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8009bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c3:	48 89 d6             	mov    %rdx,%rsi
  8009c6:	89 df                	mov    %ebx,%edi
  8009c8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d6:	0f b6 00             	movzbl (%rax),%eax
  8009d9:	0f b6 d8             	movzbl %al,%ebx
  8009dc:	83 fb 25             	cmp    $0x25,%ebx
  8009df:	75 d2                	jne    8009b3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009e5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009ec:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a05:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a09:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0d:	0f b6 00             	movzbl (%rax),%eax
  800a10:	0f b6 d8             	movzbl %al,%ebx
  800a13:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a16:	83 f8 55             	cmp    $0x55,%eax
  800a19:	0f 87 47 04 00 00    	ja     800e66 <vprintfmt+0x4ee>
  800a1f:	89 c0                	mov    %eax,%eax
  800a21:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a28:	00 
  800a29:	48 b8 18 3e 80 00 00 	movabs $0x803e18,%rax
  800a30:	00 00 00 
  800a33:	48 01 d0             	add    %rdx,%rax
  800a36:	48 8b 00             	mov    (%rax),%rax
  800a39:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a3b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a3f:	eb c0                	jmp    800a01 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a41:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a45:	eb ba                	jmp    800a01 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a47:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a4e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a51:	89 d0                	mov    %edx,%eax
  800a53:	c1 e0 02             	shl    $0x2,%eax
  800a56:	01 d0                	add    %edx,%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	01 d8                	add    %ebx,%eax
  800a5c:	83 e8 30             	sub    $0x30,%eax
  800a5f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a62:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a66:	0f b6 00             	movzbl (%rax),%eax
  800a69:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a6c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a6f:	7e 0c                	jle    800a7d <vprintfmt+0x105>
  800a71:	83 fb 39             	cmp    $0x39,%ebx
  800a74:	7f 07                	jg     800a7d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a76:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a7b:	eb d1                	jmp    800a4e <vprintfmt+0xd6>
			goto process_precision;
  800a7d:	eb 58                	jmp    800ad7 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a82:	83 f8 30             	cmp    $0x30,%eax
  800a85:	73 17                	jae    800a9e <vprintfmt+0x126>
  800a87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8e:	89 c0                	mov    %eax,%eax
  800a90:	48 01 d0             	add    %rdx,%rax
  800a93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a96:	83 c2 08             	add    $0x8,%edx
  800a99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9c:	eb 0f                	jmp    800aad <vprintfmt+0x135>
  800a9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa2:	48 89 d0             	mov    %rdx,%rax
  800aa5:	48 83 c2 08          	add    $0x8,%rdx
  800aa9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aad:	8b 00                	mov    (%rax),%eax
  800aaf:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ab2:	eb 23                	jmp    800ad7 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800ab4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab8:	79 0c                	jns    800ac6 <vprintfmt+0x14e>
				width = 0;
  800aba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ac1:	e9 3b ff ff ff       	jmpq   800a01 <vprintfmt+0x89>
  800ac6:	e9 36 ff ff ff       	jmpq   800a01 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800acb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ad2:	e9 2a ff ff ff       	jmpq   800a01 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800ad7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800adb:	79 12                	jns    800aef <vprintfmt+0x177>
				width = precision, precision = -1;
  800add:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ae3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800aea:	e9 12 ff ff ff       	jmpq   800a01 <vprintfmt+0x89>
  800aef:	e9 0d ff ff ff       	jmpq   800a01 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800af8:	e9 04 ff ff ff       	jmpq   800a01 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800afd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b00:	83 f8 30             	cmp    $0x30,%eax
  800b03:	73 17                	jae    800b1c <vprintfmt+0x1a4>
  800b05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0c:	89 c0                	mov    %eax,%eax
  800b0e:	48 01 d0             	add    %rdx,%rax
  800b11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b14:	83 c2 08             	add    $0x8,%edx
  800b17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1a:	eb 0f                	jmp    800b2b <vprintfmt+0x1b3>
  800b1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b20:	48 89 d0             	mov    %rdx,%rax
  800b23:	48 83 c2 08          	add    $0x8,%rdx
  800b27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2b:	8b 10                	mov    (%rax),%edx
  800b2d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 ce             	mov    %rcx,%rsi
  800b38:	89 d7                	mov    %edx,%edi
  800b3a:	ff d0                	callq  *%rax
			break;
  800b3c:	e9 53 03 00 00       	jmpq   800e94 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b44:	83 f8 30             	cmp    $0x30,%eax
  800b47:	73 17                	jae    800b60 <vprintfmt+0x1e8>
  800b49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b50:	89 c0                	mov    %eax,%eax
  800b52:	48 01 d0             	add    %rdx,%rax
  800b55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b58:	83 c2 08             	add    $0x8,%edx
  800b5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b5e:	eb 0f                	jmp    800b6f <vprintfmt+0x1f7>
  800b60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b64:	48 89 d0             	mov    %rdx,%rax
  800b67:	48 83 c2 08          	add    $0x8,%rdx
  800b6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b6f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b71:	85 db                	test   %ebx,%ebx
  800b73:	79 02                	jns    800b77 <vprintfmt+0x1ff>
				err = -err;
  800b75:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b77:	83 fb 15             	cmp    $0x15,%ebx
  800b7a:	7f 16                	jg     800b92 <vprintfmt+0x21a>
  800b7c:	48 b8 40 3d 80 00 00 	movabs $0x803d40,%rax
  800b83:	00 00 00 
  800b86:	48 63 d3             	movslq %ebx,%rdx
  800b89:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b8d:	4d 85 e4             	test   %r12,%r12
  800b90:	75 2e                	jne    800bc0 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b92:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9a:	89 d9                	mov    %ebx,%ecx
  800b9c:	48 ba 01 3e 80 00 00 	movabs $0x803e01,%rdx
  800ba3:	00 00 00 
  800ba6:	48 89 c7             	mov    %rax,%rdi
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bae:	49 b8 a3 0e 80 00 00 	movabs $0x800ea3,%r8
  800bb5:	00 00 00 
  800bb8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bbb:	e9 d4 02 00 00       	jmpq   800e94 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc8:	4c 89 e1             	mov    %r12,%rcx
  800bcb:	48 ba 0a 3e 80 00 00 	movabs $0x803e0a,%rdx
  800bd2:	00 00 00 
  800bd5:	48 89 c7             	mov    %rax,%rdi
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	49 b8 a3 0e 80 00 00 	movabs $0x800ea3,%r8
  800be4:	00 00 00 
  800be7:	41 ff d0             	callq  *%r8
			break;
  800bea:	e9 a5 02 00 00       	jmpq   800e94 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf2:	83 f8 30             	cmp    $0x30,%eax
  800bf5:	73 17                	jae    800c0e <vprintfmt+0x296>
  800bf7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfe:	89 c0                	mov    %eax,%eax
  800c00:	48 01 d0             	add    %rdx,%rax
  800c03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c06:	83 c2 08             	add    $0x8,%edx
  800c09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0c:	eb 0f                	jmp    800c1d <vprintfmt+0x2a5>
  800c0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c12:	48 89 d0             	mov    %rdx,%rax
  800c15:	48 83 c2 08          	add    $0x8,%rdx
  800c19:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1d:	4c 8b 20             	mov    (%rax),%r12
  800c20:	4d 85 e4             	test   %r12,%r12
  800c23:	75 0a                	jne    800c2f <vprintfmt+0x2b7>
				p = "(null)";
  800c25:	49 bc 0d 3e 80 00 00 	movabs $0x803e0d,%r12
  800c2c:	00 00 00 
			if (width > 0 && padc != '-')
  800c2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c33:	7e 3f                	jle    800c74 <vprintfmt+0x2fc>
  800c35:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c39:	74 39                	je     800c74 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c3e:	48 98                	cltq   
  800c40:	48 89 c6             	mov    %rax,%rsi
  800c43:	4c 89 e7             	mov    %r12,%rdi
  800c46:	48 b8 4f 11 80 00 00 	movabs $0x80114f,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	callq  *%rax
  800c52:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c55:	eb 17                	jmp    800c6e <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c57:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c5b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c63:	48 89 ce             	mov    %rcx,%rsi
  800c66:	89 d7                	mov    %edx,%edi
  800c68:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c72:	7f e3                	jg     800c57 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c74:	eb 37                	jmp    800cad <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c7a:	74 1e                	je     800c9a <vprintfmt+0x322>
  800c7c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c7f:	7e 05                	jle    800c86 <vprintfmt+0x30e>
  800c81:	83 fb 7e             	cmp    $0x7e,%ebx
  800c84:	7e 14                	jle    800c9a <vprintfmt+0x322>
					putch('?', putdat);
  800c86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8e:	48 89 d6             	mov    %rdx,%rsi
  800c91:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c96:	ff d0                	callq  *%rax
  800c98:	eb 0f                	jmp    800ca9 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca2:	48 89 d6             	mov    %rdx,%rsi
  800ca5:	89 df                	mov    %ebx,%edi
  800ca7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cad:	4c 89 e0             	mov    %r12,%rax
  800cb0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cb4:	0f b6 00             	movzbl (%rax),%eax
  800cb7:	0f be d8             	movsbl %al,%ebx
  800cba:	85 db                	test   %ebx,%ebx
  800cbc:	74 10                	je     800cce <vprintfmt+0x356>
  800cbe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc2:	78 b2                	js     800c76 <vprintfmt+0x2fe>
  800cc4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cc8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ccc:	79 a8                	jns    800c76 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cce:	eb 16                	jmp    800ce6 <vprintfmt+0x36e>
				putch(' ', putdat);
  800cd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd8:	48 89 d6             	mov    %rdx,%rsi
  800cdb:	bf 20 00 00 00       	mov    $0x20,%edi
  800ce0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cea:	7f e4                	jg     800cd0 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cec:	e9 a3 01 00 00       	jmpq   800e94 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cf1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf5:	be 03 00 00 00       	mov    $0x3,%esi
  800cfa:	48 89 c7             	mov    %rax,%rdi
  800cfd:	48 b8 68 08 80 00 00 	movabs $0x800868,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
  800d09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d11:	48 85 c0             	test   %rax,%rax
  800d14:	79 1d                	jns    800d33 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1e:	48 89 d6             	mov    %rdx,%rsi
  800d21:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d26:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2c:	48 f7 d8             	neg    %rax
  800d2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d33:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d3a:	e9 e8 00 00 00       	jmpq   800e27 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d43:	be 03 00 00 00       	mov    $0x3,%esi
  800d48:	48 89 c7             	mov    %rax,%rdi
  800d4b:	48 b8 58 07 80 00 00 	movabs $0x800758,%rax
  800d52:	00 00 00 
  800d55:	ff d0                	callq  *%rax
  800d57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d5b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d62:	e9 c0 00 00 00       	jmpq   800e27 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6f:	48 89 d6             	mov    %rdx,%rsi
  800d72:	bf 58 00 00 00       	mov    $0x58,%edi
  800d77:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d81:	48 89 d6             	mov    %rdx,%rsi
  800d84:	bf 58 00 00 00       	mov    $0x58,%edi
  800d89:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d93:	48 89 d6             	mov    %rdx,%rsi
  800d96:	bf 58 00 00 00       	mov    $0x58,%edi
  800d9b:	ff d0                	callq  *%rax
			break;
  800d9d:	e9 f2 00 00 00       	jmpq   800e94 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800da2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800daa:	48 89 d6             	mov    %rdx,%rsi
  800dad:	bf 30 00 00 00       	mov    $0x30,%edi
  800db2:	ff d0                	callq  *%rax
			putch('x', putdat);
  800db4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbc:	48 89 d6             	mov    %rdx,%rsi
  800dbf:	bf 78 00 00 00       	mov    $0x78,%edi
  800dc4:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc9:	83 f8 30             	cmp    $0x30,%eax
  800dcc:	73 17                	jae    800de5 <vprintfmt+0x46d>
  800dce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd5:	89 c0                	mov    %eax,%eax
  800dd7:	48 01 d0             	add    %rdx,%rax
  800dda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ddd:	83 c2 08             	add    $0x8,%edx
  800de0:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de3:	eb 0f                	jmp    800df4 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800de5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800de9:	48 89 d0             	mov    %rdx,%rax
  800dec:	48 83 c2 08          	add    $0x8,%rdx
  800df0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800df4:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800df7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dfb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e02:	eb 23                	jmp    800e27 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e08:	be 03 00 00 00       	mov    $0x3,%esi
  800e0d:	48 89 c7             	mov    %rax,%rdi
  800e10:	48 b8 58 07 80 00 00 	movabs $0x800758,%rax
  800e17:	00 00 00 
  800e1a:	ff d0                	callq  *%rax
  800e1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e20:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e27:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e2c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e2f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e36:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3e:	45 89 c1             	mov    %r8d,%r9d
  800e41:	41 89 f8             	mov    %edi,%r8d
  800e44:	48 89 c7             	mov    %rax,%rdi
  800e47:	48 b8 9d 06 80 00 00 	movabs $0x80069d,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	callq  *%rax
			break;
  800e53:	eb 3f                	jmp    800e94 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5d:	48 89 d6             	mov    %rdx,%rsi
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	ff d0                	callq  *%rax
			break;
  800e64:	eb 2e                	jmp    800e94 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6e:	48 89 d6             	mov    %rdx,%rsi
  800e71:	bf 25 00 00 00       	mov    $0x25,%edi
  800e76:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e78:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e7d:	eb 05                	jmp    800e84 <vprintfmt+0x50c>
  800e7f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e84:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e88:	48 83 e8 01          	sub    $0x1,%rax
  800e8c:	0f b6 00             	movzbl (%rax),%eax
  800e8f:	3c 25                	cmp    $0x25,%al
  800e91:	75 ec                	jne    800e7f <vprintfmt+0x507>
				/* do nothing */;
			break;
  800e93:	90                   	nop
		}
	}
  800e94:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e95:	e9 30 fb ff ff       	jmpq   8009ca <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e9a:	48 83 c4 60          	add    $0x60,%rsp
  800e9e:	5b                   	pop    %rbx
  800e9f:	41 5c                	pop    %r12
  800ea1:	5d                   	pop    %rbp
  800ea2:	c3                   	retq   

0000000000800ea3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ea3:	55                   	push   %rbp
  800ea4:	48 89 e5             	mov    %rsp,%rbp
  800ea7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eae:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eb5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ebc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ec3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eca:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ed1:	84 c0                	test   %al,%al
  800ed3:	74 20                	je     800ef5 <printfmt+0x52>
  800ed5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ed9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800edd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ee1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ee5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ee9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eed:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ef1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ef5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800efc:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f03:	00 00 00 
  800f06:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f0d:	00 00 00 
  800f10:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f14:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f1b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f22:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f29:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f30:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f37:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f3e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f45:	48 89 c7             	mov    %rax,%rdi
  800f48:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  800f4f:	00 00 00 
  800f52:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f54:	c9                   	leaveq 
  800f55:	c3                   	retq   

0000000000800f56 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f56:	55                   	push   %rbp
  800f57:	48 89 e5             	mov    %rsp,%rbp
  800f5a:	48 83 ec 10          	sub    $0x10,%rsp
  800f5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f69:	8b 40 10             	mov    0x10(%rax),%eax
  800f6c:	8d 50 01             	lea    0x1(%rax),%edx
  800f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f73:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7a:	48 8b 10             	mov    (%rax),%rdx
  800f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f81:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f85:	48 39 c2             	cmp    %rax,%rdx
  800f88:	73 17                	jae    800fa1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8e:	48 8b 00             	mov    (%rax),%rax
  800f91:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f99:	48 89 0a             	mov    %rcx,(%rdx)
  800f9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f9f:	88 10                	mov    %dl,(%rax)
}
  800fa1:	c9                   	leaveq 
  800fa2:	c3                   	retq   

0000000000800fa3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fa3:	55                   	push   %rbp
  800fa4:	48 89 e5             	mov    %rsp,%rbp
  800fa7:	48 83 ec 50          	sub    $0x50,%rsp
  800fab:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800faf:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fb2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fb6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fba:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fbe:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fc2:	48 8b 0a             	mov    (%rdx),%rcx
  800fc5:	48 89 08             	mov    %rcx,(%rax)
  800fc8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fcc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fd4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fdc:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fe0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fe3:	48 98                	cltq   
  800fe5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fe9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fed:	48 01 d0             	add    %rdx,%rax
  800ff0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ff4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ffb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801000:	74 06                	je     801008 <vsnprintf+0x65>
  801002:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801006:	7f 07                	jg     80100f <vsnprintf+0x6c>
		return -E_INVAL;
  801008:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100d:	eb 2f                	jmp    80103e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80100f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801013:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801017:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80101b:	48 89 c6             	mov    %rax,%rsi
  80101e:	48 bf 56 0f 80 00 00 	movabs $0x800f56,%rdi
  801025:	00 00 00 
  801028:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  80102f:	00 00 00 
  801032:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801034:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801038:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80103b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80103e:	c9                   	leaveq 
  80103f:	c3                   	retq   

0000000000801040 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801040:	55                   	push   %rbp
  801041:	48 89 e5             	mov    %rsp,%rbp
  801044:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80104b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801052:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801058:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80105f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801066:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80106d:	84 c0                	test   %al,%al
  80106f:	74 20                	je     801091 <snprintf+0x51>
  801071:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801075:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801079:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80107d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801081:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801085:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801089:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80108d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801091:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801098:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80109f:	00 00 00 
  8010a2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010a9:	00 00 00 
  8010ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010b7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010be:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010c5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010cc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010d3:	48 8b 0a             	mov    (%rdx),%rcx
  8010d6:	48 89 08             	mov    %rcx,(%rax)
  8010d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010e9:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010f0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010f7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010fd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801104:	48 89 c7             	mov    %rax,%rdi
  801107:	48 b8 a3 0f 80 00 00 	movabs $0x800fa3,%rax
  80110e:	00 00 00 
  801111:	ff d0                	callq  *%rax
  801113:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801119:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80111f:	c9                   	leaveq 
  801120:	c3                   	retq   

0000000000801121 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	48 83 ec 18          	sub    $0x18,%rsp
  801129:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80112d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801134:	eb 09                	jmp    80113f <strlen+0x1e>
		n++;
  801136:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80113a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80113f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801143:	0f b6 00             	movzbl (%rax),%eax
  801146:	84 c0                	test   %al,%al
  801148:	75 ec                	jne    801136 <strlen+0x15>
		n++;
	return n;
  80114a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80114d:	c9                   	leaveq 
  80114e:	c3                   	retq   

000000000080114f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80114f:	55                   	push   %rbp
  801150:	48 89 e5             	mov    %rsp,%rbp
  801153:	48 83 ec 20          	sub    $0x20,%rsp
  801157:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801166:	eb 0e                	jmp    801176 <strnlen+0x27>
		n++;
  801168:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80116c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801171:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801176:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80117b:	74 0b                	je     801188 <strnlen+0x39>
  80117d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801181:	0f b6 00             	movzbl (%rax),%eax
  801184:	84 c0                	test   %al,%al
  801186:	75 e0                	jne    801168 <strnlen+0x19>
		n++;
	return n;
  801188:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80118b:	c9                   	leaveq 
  80118c:	c3                   	retq   

000000000080118d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80118d:	55                   	push   %rbp
  80118e:	48 89 e5             	mov    %rsp,%rbp
  801191:	48 83 ec 20          	sub    $0x20,%rsp
  801195:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801199:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80119d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011a5:	90                   	nop
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011b6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011ba:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011be:	0f b6 12             	movzbl (%rdx),%edx
  8011c1:	88 10                	mov    %dl,(%rax)
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	84 c0                	test   %al,%al
  8011c8:	75 dc                	jne    8011a6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ce:	c9                   	leaveq 
  8011cf:	c3                   	retq   

00000000008011d0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011d0:	55                   	push   %rbp
  8011d1:	48 89 e5             	mov    %rsp,%rbp
  8011d4:	48 83 ec 20          	sub    $0x20,%rsp
  8011d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	48 89 c7             	mov    %rax,%rdi
  8011e7:	48 b8 21 11 80 00 00 	movabs $0x801121,%rax
  8011ee:	00 00 00 
  8011f1:	ff d0                	callq  *%rax
  8011f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f9:	48 63 d0             	movslq %eax,%rdx
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 01 c2             	add    %rax,%rdx
  801203:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801207:	48 89 c6             	mov    %rax,%rsi
  80120a:	48 89 d7             	mov    %rdx,%rdi
  80120d:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  801214:	00 00 00 
  801217:	ff d0                	callq  *%rax
	return dst;
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 83 ec 28          	sub    $0x28,%rsp
  801227:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80122f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801233:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801237:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80123b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801242:	00 
  801243:	eb 2a                	jmp    80126f <strncpy+0x50>
		*dst++ = *src;
  801245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801249:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80124d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801251:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801255:	0f b6 12             	movzbl (%rdx),%edx
  801258:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80125a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80125e:	0f b6 00             	movzbl (%rax),%eax
  801261:	84 c0                	test   %al,%al
  801263:	74 05                	je     80126a <strncpy+0x4b>
			src++;
  801265:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80126a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801273:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801277:	72 cc                	jb     801245 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80127d:	c9                   	leaveq 
  80127e:	c3                   	retq   

000000000080127f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80127f:	55                   	push   %rbp
  801280:	48 89 e5             	mov    %rsp,%rbp
  801283:	48 83 ec 28          	sub    $0x28,%rsp
  801287:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80128f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801297:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80129b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012a0:	74 3d                	je     8012df <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012a2:	eb 1d                	jmp    8012c1 <strlcpy+0x42>
			*dst++ = *src++;
  8012a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012b0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012b4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012b8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012bc:	0f b6 12             	movzbl (%rdx),%edx
  8012bf:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012c1:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012cb:	74 0b                	je     8012d8 <strlcpy+0x59>
  8012cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 cc                	jne    8012a4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dc:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e7:	48 29 c2             	sub    %rax,%rdx
  8012ea:	48 89 d0             	mov    %rdx,%rax
}
  8012ed:	c9                   	leaveq 
  8012ee:	c3                   	retq   

00000000008012ef <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ef:	55                   	push   %rbp
  8012f0:	48 89 e5             	mov    %rsp,%rbp
  8012f3:	48 83 ec 10          	sub    $0x10,%rsp
  8012f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012ff:	eb 0a                	jmp    80130b <strcmp+0x1c>
		p++, q++;
  801301:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801306:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	0f b6 00             	movzbl (%rax),%eax
  801312:	84 c0                	test   %al,%al
  801314:	74 12                	je     801328 <strcmp+0x39>
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	0f b6 10             	movzbl (%rax),%edx
  80131d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801321:	0f b6 00             	movzbl (%rax),%eax
  801324:	38 c2                	cmp    %al,%dl
  801326:	74 d9                	je     801301 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	0f b6 00             	movzbl (%rax),%eax
  80132f:	0f b6 d0             	movzbl %al,%edx
  801332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801336:	0f b6 00             	movzbl (%rax),%eax
  801339:	0f b6 c0             	movzbl %al,%eax
  80133c:	29 c2                	sub    %eax,%edx
  80133e:	89 d0                	mov    %edx,%eax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 18          	sub    $0x18,%rsp
  80134a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801352:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801356:	eb 0f                	jmp    801367 <strncmp+0x25>
		n--, p++, q++;
  801358:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80135d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801362:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801367:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80136c:	74 1d                	je     80138b <strncmp+0x49>
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	84 c0                	test   %al,%al
  801377:	74 12                	je     80138b <strncmp+0x49>
  801379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137d:	0f b6 10             	movzbl (%rax),%edx
  801380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	38 c2                	cmp    %al,%dl
  801389:	74 cd                	je     801358 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80138b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801390:	75 07                	jne    801399 <strncmp+0x57>
		return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	eb 18                	jmp    8013b1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	0f b6 d0             	movzbl %al,%edx
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	0f b6 c0             	movzbl %al,%eax
  8013ad:	29 c2                	sub    %eax,%edx
  8013af:	89 d0                	mov    %edx,%eax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 0c          	sub    $0xc,%rsp
  8013bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013bf:	89 f0                	mov    %esi,%eax
  8013c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013c4:	eb 17                	jmp    8013dd <strchr+0x2a>
		if (*s == c)
  8013c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ca:	0f b6 00             	movzbl (%rax),%eax
  8013cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013d0:	75 06                	jne    8013d8 <strchr+0x25>
			return (char *) s;
  8013d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d6:	eb 15                	jmp    8013ed <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	84 c0                	test   %al,%al
  8013e6:	75 de                	jne    8013c6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ed:	c9                   	leaveq 
  8013ee:	c3                   	retq   

00000000008013ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ef:	55                   	push   %rbp
  8013f0:	48 89 e5             	mov    %rsp,%rbp
  8013f3:	48 83 ec 0c          	sub    $0xc,%rsp
  8013f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013fb:	89 f0                	mov    %esi,%eax
  8013fd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801400:	eb 13                	jmp    801415 <strfind+0x26>
		if (*s == c)
  801402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80140c:	75 02                	jne    801410 <strfind+0x21>
			break;
  80140e:	eb 10                	jmp    801420 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801410:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	84 c0                	test   %al,%al
  80141e:	75 e2                	jne    801402 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801424:	c9                   	leaveq 
  801425:	c3                   	retq   

0000000000801426 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801426:	55                   	push   %rbp
  801427:	48 89 e5             	mov    %rsp,%rbp
  80142a:	48 83 ec 18          	sub    $0x18,%rsp
  80142e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801432:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801435:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801439:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80143e:	75 06                	jne    801446 <memset+0x20>
		return v;
  801440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801444:	eb 69                	jmp    8014af <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	83 e0 03             	and    $0x3,%eax
  80144d:	48 85 c0             	test   %rax,%rax
  801450:	75 48                	jne    80149a <memset+0x74>
  801452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801456:	83 e0 03             	and    $0x3,%eax
  801459:	48 85 c0             	test   %rax,%rax
  80145c:	75 3c                	jne    80149a <memset+0x74>
		c &= 0xFF;
  80145e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801465:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801468:	c1 e0 18             	shl    $0x18,%eax
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801470:	c1 e0 10             	shl    $0x10,%eax
  801473:	09 c2                	or     %eax,%edx
  801475:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801478:	c1 e0 08             	shl    $0x8,%eax
  80147b:	09 d0                	or     %edx,%eax
  80147d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801484:	48 c1 e8 02          	shr    $0x2,%rax
  801488:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80148b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801492:	48 89 d7             	mov    %rdx,%rdi
  801495:	fc                   	cld    
  801496:	f3 ab                	rep stos %eax,%es:(%rdi)
  801498:	eb 11                	jmp    8014ab <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80149a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014a5:	48 89 d7             	mov    %rdx,%rdi
  8014a8:	fc                   	cld    
  8014a9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 28          	sub    $0x28,%rsp
  8014b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014dd:	0f 83 88 00 00 00    	jae    80156b <memmove+0xba>
  8014e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014eb:	48 01 d0             	add    %rdx,%rax
  8014ee:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014f2:	76 77                	jbe    80156b <memmove+0xba>
		s += n;
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801508:	83 e0 03             	and    $0x3,%eax
  80150b:	48 85 c0             	test   %rax,%rax
  80150e:	75 3b                	jne    80154b <memmove+0x9a>
  801510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801514:	83 e0 03             	and    $0x3,%eax
  801517:	48 85 c0             	test   %rax,%rax
  80151a:	75 2f                	jne    80154b <memmove+0x9a>
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	83 e0 03             	and    $0x3,%eax
  801523:	48 85 c0             	test   %rax,%rax
  801526:	75 23                	jne    80154b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152c:	48 83 e8 04          	sub    $0x4,%rax
  801530:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801534:	48 83 ea 04          	sub    $0x4,%rdx
  801538:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80153c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801540:	48 89 c7             	mov    %rax,%rdi
  801543:	48 89 d6             	mov    %rdx,%rsi
  801546:	fd                   	std    
  801547:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801549:	eb 1d                	jmp    801568 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80154b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801557:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80155b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155f:	48 89 d7             	mov    %rdx,%rdi
  801562:	48 89 c1             	mov    %rax,%rcx
  801565:	fd                   	std    
  801566:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801568:	fc                   	cld    
  801569:	eb 57                	jmp    8015c2 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80156b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156f:	83 e0 03             	and    $0x3,%eax
  801572:	48 85 c0             	test   %rax,%rax
  801575:	75 36                	jne    8015ad <memmove+0xfc>
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	83 e0 03             	and    $0x3,%eax
  80157e:	48 85 c0             	test   %rax,%rax
  801581:	75 2a                	jne    8015ad <memmove+0xfc>
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	83 e0 03             	and    $0x3,%eax
  80158a:	48 85 c0             	test   %rax,%rax
  80158d:	75 1e                	jne    8015ad <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	48 c1 e8 02          	shr    $0x2,%rax
  801597:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a2:	48 89 c7             	mov    %rax,%rdi
  8015a5:	48 89 d6             	mov    %rdx,%rsi
  8015a8:	fc                   	cld    
  8015a9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ab:	eb 15                	jmp    8015c2 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015b9:	48 89 c7             	mov    %rax,%rdi
  8015bc:	48 89 d6             	mov    %rdx,%rsi
  8015bf:	fc                   	cld    
  8015c0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c6:	c9                   	leaveq 
  8015c7:	c3                   	retq   

00000000008015c8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 18          	sub    $0x18,%rsp
  8015d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e8:	48 89 ce             	mov    %rcx,%rsi
  8015eb:	48 89 c7             	mov    %rax,%rdi
  8015ee:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  8015f5:	00 00 00 
  8015f8:	ff d0                	callq  *%rax
}
  8015fa:	c9                   	leaveq 
  8015fb:	c3                   	retq   

00000000008015fc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015fc:	55                   	push   %rbp
  8015fd:	48 89 e5             	mov    %rsp,%rbp
  801600:	48 83 ec 28          	sub    $0x28,%rsp
  801604:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801608:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80160c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801614:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801618:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80161c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801620:	eb 36                	jmp    801658 <memcmp+0x5c>
		if (*s1 != *s2)
  801622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801626:	0f b6 10             	movzbl (%rax),%edx
  801629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	38 c2                	cmp    %al,%dl
  801632:	74 1a                	je     80164e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	0f b6 d0             	movzbl %al,%edx
  80163e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	0f b6 c0             	movzbl %al,%eax
  801648:	29 c2                	sub    %eax,%edx
  80164a:	89 d0                	mov    %edx,%eax
  80164c:	eb 20                	jmp    80166e <memcmp+0x72>
		s1++, s2++;
  80164e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801653:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801660:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801664:	48 85 c0             	test   %rax,%rax
  801667:	75 b9                	jne    801622 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166e:	c9                   	leaveq 
  80166f:	c3                   	retq   

0000000000801670 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801670:	55                   	push   %rbp
  801671:	48 89 e5             	mov    %rsp,%rbp
  801674:	48 83 ec 28          	sub    $0x28,%rsp
  801678:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80167c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80167f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80168b:	48 01 d0             	add    %rdx,%rax
  80168e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801692:	eb 15                	jmp    8016a9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801698:	0f b6 10             	movzbl (%rax),%edx
  80169b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80169e:	38 c2                	cmp    %al,%dl
  8016a0:	75 02                	jne    8016a4 <memfind+0x34>
			break;
  8016a2:	eb 0f                	jmp    8016b3 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ad:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016b1:	72 e1                	jb     801694 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b7:	c9                   	leaveq 
  8016b8:	c3                   	retq   

00000000008016b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016b9:	55                   	push   %rbp
  8016ba:	48 89 e5             	mov    %rsp,%rbp
  8016bd:	48 83 ec 34          	sub    $0x34,%rsp
  8016c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016c9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016d3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016da:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016db:	eb 05                	jmp    8016e2 <strtol+0x29>
		s++;
  8016dd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	3c 20                	cmp    $0x20,%al
  8016eb:	74 f0                	je     8016dd <strtol+0x24>
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	0f b6 00             	movzbl (%rax),%eax
  8016f4:	3c 09                	cmp    $0x9,%al
  8016f6:	74 e5                	je     8016dd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	3c 2b                	cmp    $0x2b,%al
  801701:	75 07                	jne    80170a <strtol+0x51>
		s++;
  801703:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801708:	eb 17                	jmp    801721 <strtol+0x68>
	else if (*s == '-')
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	0f b6 00             	movzbl (%rax),%eax
  801711:	3c 2d                	cmp    $0x2d,%al
  801713:	75 0c                	jne    801721 <strtol+0x68>
		s++, neg = 1;
  801715:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801721:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801725:	74 06                	je     80172d <strtol+0x74>
  801727:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80172b:	75 28                	jne    801755 <strtol+0x9c>
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	0f b6 00             	movzbl (%rax),%eax
  801734:	3c 30                	cmp    $0x30,%al
  801736:	75 1d                	jne    801755 <strtol+0x9c>
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	48 83 c0 01          	add    $0x1,%rax
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	3c 78                	cmp    $0x78,%al
  801745:	75 0e                	jne    801755 <strtol+0x9c>
		s += 2, base = 16;
  801747:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80174c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801753:	eb 2c                	jmp    801781 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801755:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801759:	75 19                	jne    801774 <strtol+0xbb>
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	3c 30                	cmp    $0x30,%al
  801764:	75 0e                	jne    801774 <strtol+0xbb>
		s++, base = 8;
  801766:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80176b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801772:	eb 0d                	jmp    801781 <strtol+0xc8>
	else if (base == 0)
  801774:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801778:	75 07                	jne    801781 <strtol+0xc8>
		base = 10;
  80177a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	3c 2f                	cmp    $0x2f,%al
  80178a:	7e 1d                	jle    8017a9 <strtol+0xf0>
  80178c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801790:	0f b6 00             	movzbl (%rax),%eax
  801793:	3c 39                	cmp    $0x39,%al
  801795:	7f 12                	jg     8017a9 <strtol+0xf0>
			dig = *s - '0';
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	0f be c0             	movsbl %al,%eax
  8017a1:	83 e8 30             	sub    $0x30,%eax
  8017a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017a7:	eb 4e                	jmp    8017f7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	3c 60                	cmp    $0x60,%al
  8017b2:	7e 1d                	jle    8017d1 <strtol+0x118>
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	0f b6 00             	movzbl (%rax),%eax
  8017bb:	3c 7a                	cmp    $0x7a,%al
  8017bd:	7f 12                	jg     8017d1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c3:	0f b6 00             	movzbl (%rax),%eax
  8017c6:	0f be c0             	movsbl %al,%eax
  8017c9:	83 e8 57             	sub    $0x57,%eax
  8017cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017cf:	eb 26                	jmp    8017f7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	0f b6 00             	movzbl (%rax),%eax
  8017d8:	3c 40                	cmp    $0x40,%al
  8017da:	7e 48                	jle    801824 <strtol+0x16b>
  8017dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e0:	0f b6 00             	movzbl (%rax),%eax
  8017e3:	3c 5a                	cmp    $0x5a,%al
  8017e5:	7f 3d                	jg     801824 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017eb:	0f b6 00             	movzbl (%rax),%eax
  8017ee:	0f be c0             	movsbl %al,%eax
  8017f1:	83 e8 37             	sub    $0x37,%eax
  8017f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017fd:	7c 02                	jl     801801 <strtol+0x148>
			break;
  8017ff:	eb 23                	jmp    801824 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801801:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801806:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801809:	48 98                	cltq   
  80180b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801810:	48 89 c2             	mov    %rax,%rdx
  801813:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801816:	48 98                	cltq   
  801818:	48 01 d0             	add    %rdx,%rax
  80181b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80181f:	e9 5d ff ff ff       	jmpq   801781 <strtol+0xc8>

	if (endptr)
  801824:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801829:	74 0b                	je     801836 <strtol+0x17d>
		*endptr = (char *) s;
  80182b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80182f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801833:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801836:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80183a:	74 09                	je     801845 <strtol+0x18c>
  80183c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801840:	48 f7 d8             	neg    %rax
  801843:	eb 04                	jmp    801849 <strtol+0x190>
  801845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801849:	c9                   	leaveq 
  80184a:	c3                   	retq   

000000000080184b <strstr>:

char * strstr(const char *in, const char *str)
{
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	48 83 ec 30          	sub    $0x30,%rsp
  801853:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801857:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80185b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80185f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801863:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801867:	0f b6 00             	movzbl (%rax),%eax
  80186a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80186d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801871:	75 06                	jne    801879 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801877:	eb 6b                	jmp    8018e4 <strstr+0x99>

	len = strlen(str);
  801879:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80187d:	48 89 c7             	mov    %rax,%rdi
  801880:	48 b8 21 11 80 00 00 	movabs $0x801121,%rax
  801887:	00 00 00 
  80188a:	ff d0                	callq  *%rax
  80188c:	48 98                	cltq   
  80188e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801896:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80189a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80189e:	0f b6 00             	movzbl (%rax),%eax
  8018a1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018a4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018a8:	75 07                	jne    8018b1 <strstr+0x66>
				return (char *) 0;
  8018aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8018af:	eb 33                	jmp    8018e4 <strstr+0x99>
		} while (sc != c);
  8018b1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018b5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018b8:	75 d8                	jne    801892 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018be:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c6:	48 89 ce             	mov    %rcx,%rsi
  8018c9:	48 89 c7             	mov    %rax,%rdi
  8018cc:	48 b8 42 13 80 00 00 	movabs $0x801342,%rax
  8018d3:	00 00 00 
  8018d6:	ff d0                	callq  *%rax
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	75 b6                	jne    801892 <strstr+0x47>

	return (char *) (in - 1);
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	48 83 e8 01          	sub    $0x1,%rax
}
  8018e4:	c9                   	leaveq 
  8018e5:	c3                   	retq   

00000000008018e6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018e6:	55                   	push   %rbp
  8018e7:	48 89 e5             	mov    %rsp,%rbp
  8018ea:	53                   	push   %rbx
  8018eb:	48 83 ec 48          	sub    $0x48,%rsp
  8018ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018f2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018f5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018f9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018fd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801901:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801905:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801908:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80190c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801910:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801914:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801918:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80191c:	4c 89 c3             	mov    %r8,%rbx
  80191f:	cd 30                	int    $0x30
  801921:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801925:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801929:	74 3e                	je     801969 <syscall+0x83>
  80192b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801930:	7e 37                	jle    801969 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801932:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801936:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801939:	49 89 d0             	mov    %rdx,%r8
  80193c:	89 c1                	mov    %eax,%ecx
  80193e:	48 ba c8 40 80 00 00 	movabs $0x8040c8,%rdx
  801945:	00 00 00 
  801948:	be 23 00 00 00       	mov    $0x23,%esi
  80194d:	48 bf e5 40 80 00 00 	movabs $0x8040e5,%rdi
  801954:	00 00 00 
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	49 b9 8c 03 80 00 00 	movabs $0x80038c,%r9
  801963:	00 00 00 
  801966:	41 ff d1             	callq  *%r9

	return ret;
  801969:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80196d:	48 83 c4 48          	add    $0x48,%rsp
  801971:	5b                   	pop    %rbx
  801972:	5d                   	pop    %rbp
  801973:	c3                   	retq   

0000000000801974 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801974:	55                   	push   %rbp
  801975:	48 89 e5             	mov    %rsp,%rbp
  801978:	48 83 ec 20          	sub    $0x20,%rsp
  80197c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801980:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801984:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801988:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801993:	00 
  801994:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a0:	48 89 d1             	mov    %rdx,%rcx
  8019a3:	48 89 c2             	mov    %rax,%rdx
  8019a6:	be 00 00 00 00       	mov    $0x0,%esi
  8019ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b0:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  8019b7:	00 00 00 
  8019ba:	ff d0                	callq  *%rax
}
  8019bc:	c9                   	leaveq 
  8019bd:	c3                   	retq   

00000000008019be <sys_cgetc>:

int
sys_cgetc(void)
{
  8019be:	55                   	push   %rbp
  8019bf:	48 89 e5             	mov    %rsp,%rbp
  8019c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cd:	00 
  8019ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019df:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e4:	be 00 00 00 00       	mov    $0x0,%esi
  8019e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ee:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
}
  8019fa:	c9                   	leaveq 
  8019fb:	c3                   	retq   

00000000008019fc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019fc:	55                   	push   %rbp
  8019fd:	48 89 e5             	mov    %rsp,%rbp
  801a00:	48 83 ec 10          	sub    $0x10,%rsp
  801a04:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0a:	48 98                	cltq   
  801a0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a13:	00 
  801a14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a25:	48 89 c2             	mov    %rax,%rdx
  801a28:	be 01 00 00 00       	mov    $0x1,%esi
  801a2d:	bf 03 00 00 00       	mov    $0x3,%edi
  801a32:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4f:	00 
  801a50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	be 00 00 00 00       	mov    $0x0,%esi
  801a6b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a70:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
}
  801a7c:	c9                   	leaveq 
  801a7d:	c3                   	retq   

0000000000801a7e <sys_yield>:

void
sys_yield(void)
{
  801a7e:	55                   	push   %rbp
  801a7f:	48 89 e5             	mov    %rsp,%rbp
  801a82:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8d:	00 
  801a8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	be 00 00 00 00       	mov    $0x0,%esi
  801aa9:	bf 0b 00 00 00       	mov    $0xb,%edi
  801aae:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 20          	sub    $0x20,%rsp
  801ac4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ace:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad1:	48 63 c8             	movslq %eax,%rcx
  801ad4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	48 98                	cltq   
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	49 89 c8             	mov    %rcx,%r8
  801aee:	48 89 d1             	mov    %rdx,%rcx
  801af1:	48 89 c2             	mov    %rax,%rdx
  801af4:	be 01 00 00 00       	mov    $0x1,%esi
  801af9:	bf 04 00 00 00       	mov    $0x4,%edi
  801afe:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
}
  801b0a:	c9                   	leaveq 
  801b0b:	c3                   	retq   

0000000000801b0c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b0c:	55                   	push   %rbp
  801b0d:	48 89 e5             	mov    %rsp,%rbp
  801b10:	48 83 ec 30          	sub    $0x30,%rsp
  801b14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b1e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b22:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b26:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b29:	48 63 c8             	movslq %eax,%rcx
  801b2c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b33:	48 63 f0             	movslq %eax,%rsi
  801b36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3d:	48 98                	cltq   
  801b3f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b43:	49 89 f9             	mov    %rdi,%r9
  801b46:	49 89 f0             	mov    %rsi,%r8
  801b49:	48 89 d1             	mov    %rdx,%rcx
  801b4c:	48 89 c2             	mov    %rax,%rdx
  801b4f:	be 01 00 00 00       	mov    $0x1,%esi
  801b54:	bf 05 00 00 00       	mov    $0x5,%edi
  801b59:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801b60:	00 00 00 
  801b63:	ff d0                	callq  *%rax
}
  801b65:	c9                   	leaveq 
  801b66:	c3                   	retq   

0000000000801b67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b67:	55                   	push   %rbp
  801b68:	48 89 e5             	mov    %rsp,%rbp
  801b6b:	48 83 ec 20          	sub    $0x20,%rsp
  801b6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7d:	48 98                	cltq   
  801b7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b86:	00 
  801b87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b93:	48 89 d1             	mov    %rdx,%rcx
  801b96:	48 89 c2             	mov    %rax,%rdx
  801b99:	be 01 00 00 00       	mov    $0x1,%esi
  801b9e:	bf 06 00 00 00       	mov    $0x6,%edi
  801ba3:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
}
  801baf:	c9                   	leaveq 
  801bb0:	c3                   	retq   

0000000000801bb1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bb1:	55                   	push   %rbp
  801bb2:	48 89 e5             	mov    %rsp,%rbp
  801bb5:	48 83 ec 10          	sub    $0x10,%rsp
  801bb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc2:	48 63 d0             	movslq %eax,%rdx
  801bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc8:	48 98                	cltq   
  801bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd1:	00 
  801bd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bde:	48 89 d1             	mov    %rdx,%rcx
  801be1:	48 89 c2             	mov    %rax,%rdx
  801be4:	be 01 00 00 00       	mov    $0x1,%esi
  801be9:	bf 08 00 00 00       	mov    $0x8,%edi
  801bee:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	callq  *%rax
}
  801bfa:	c9                   	leaveq 
  801bfb:	c3                   	retq   

0000000000801bfc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bfc:	55                   	push   %rbp
  801bfd:	48 89 e5             	mov    %rsp,%rbp
  801c00:	48 83 ec 20          	sub    $0x20,%rsp
  801c04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c12:	48 98                	cltq   
  801c14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1b:	00 
  801c1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c28:	48 89 d1             	mov    %rdx,%rcx
  801c2b:	48 89 c2             	mov    %rax,%rdx
  801c2e:	be 01 00 00 00       	mov    $0x1,%esi
  801c33:	bf 09 00 00 00       	mov    $0x9,%edi
  801c38:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
}
  801c44:	c9                   	leaveq 
  801c45:	c3                   	retq   

0000000000801c46 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	48 83 ec 20          	sub    $0x20,%rsp
  801c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5c:	48 98                	cltq   
  801c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c65:	00 
  801c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c72:	48 89 d1             	mov    %rdx,%rcx
  801c75:	48 89 c2             	mov    %rax,%rdx
  801c78:	be 01 00 00 00       	mov    $0x1,%esi
  801c7d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c82:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
}
  801c8e:	c9                   	leaveq 
  801c8f:	c3                   	retq   

0000000000801c90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 20          	sub    $0x20,%rsp
  801c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c9f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ca3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca9:	48 63 f0             	movslq %eax,%rsi
  801cac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb3:	48 98                	cltq   
  801cb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc0:	00 
  801cc1:	49 89 f1             	mov    %rsi,%r9
  801cc4:	49 89 c8             	mov    %rcx,%r8
  801cc7:	48 89 d1             	mov    %rdx,%rcx
  801cca:	48 89 c2             	mov    %rax,%rdx
  801ccd:	be 00 00 00 00       	mov    $0x0,%esi
  801cd2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cd7:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
}
  801ce3:	c9                   	leaveq 
  801ce4:	c3                   	retq   

0000000000801ce5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ce5:	55                   	push   %rbp
  801ce6:	48 89 e5             	mov    %rsp,%rbp
  801ce9:	48 83 ec 10          	sub    $0x10,%rsp
  801ced:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cfc:	00 
  801cfd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d09:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d0e:	48 89 c2             	mov    %rax,%rdx
  801d11:	be 01 00 00 00       	mov    $0x1,%esi
  801d16:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d1b:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  801d22:	00 00 00 
  801d25:	ff d0                	callq  *%rax
}
  801d27:	c9                   	leaveq 
  801d28:	c3                   	retq   

0000000000801d29 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d29:	55                   	push   %rbp
  801d2a:	48 89 e5             	mov    %rsp,%rbp
  801d2d:	48 83 ec 08          	sub    $0x8,%rsp
  801d31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d39:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d40:	ff ff ff 
  801d43:	48 01 d0             	add    %rdx,%rax
  801d46:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d4a:	c9                   	leaveq 
  801d4b:	c3                   	retq   

0000000000801d4c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d4c:	55                   	push   %rbp
  801d4d:	48 89 e5             	mov    %rsp,%rbp
  801d50:	48 83 ec 08          	sub    $0x8,%rsp
  801d54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5c:	48 89 c7             	mov    %rax,%rdi
  801d5f:	48 b8 29 1d 80 00 00 	movabs $0x801d29,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	callq  *%rax
  801d6b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d71:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d75:	c9                   	leaveq 
  801d76:	c3                   	retq   

0000000000801d77 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d77:	55                   	push   %rbp
  801d78:	48 89 e5             	mov    %rsp,%rbp
  801d7b:	48 83 ec 18          	sub    $0x18,%rsp
  801d7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d8a:	eb 6b                	jmp    801df7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8f:	48 98                	cltq   
  801d91:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d97:	48 c1 e0 0c          	shl    $0xc,%rax
  801d9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da3:	48 c1 e8 15          	shr    $0x15,%rax
  801da7:	48 89 c2             	mov    %rax,%rdx
  801daa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801db1:	01 00 00 
  801db4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db8:	83 e0 01             	and    $0x1,%eax
  801dbb:	48 85 c0             	test   %rax,%rax
  801dbe:	74 21                	je     801de1 <fd_alloc+0x6a>
  801dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc4:	48 c1 e8 0c          	shr    $0xc,%rax
  801dc8:	48 89 c2             	mov    %rax,%rdx
  801dcb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dd2:	01 00 00 
  801dd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd9:	83 e0 01             	and    $0x1,%eax
  801ddc:	48 85 c0             	test   %rax,%rax
  801ddf:	75 12                	jne    801df3 <fd_alloc+0x7c>
			*fd_store = fd;
  801de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
  801df1:	eb 1a                	jmp    801e0d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801df3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801df7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dfb:	7e 8f                	jle    801d8c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e01:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e08:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e0d:	c9                   	leaveq 
  801e0e:	c3                   	retq   

0000000000801e0f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e0f:	55                   	push   %rbp
  801e10:	48 89 e5             	mov    %rsp,%rbp
  801e13:	48 83 ec 20          	sub    $0x20,%rsp
  801e17:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e22:	78 06                	js     801e2a <fd_lookup+0x1b>
  801e24:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e28:	7e 07                	jle    801e31 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e2f:	eb 6c                	jmp    801e9d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e34:	48 98                	cltq   
  801e36:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e3c:	48 c1 e0 0c          	shl    $0xc,%rax
  801e40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e48:	48 c1 e8 15          	shr    $0x15,%rax
  801e4c:	48 89 c2             	mov    %rax,%rdx
  801e4f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e56:	01 00 00 
  801e59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5d:	83 e0 01             	and    $0x1,%eax
  801e60:	48 85 c0             	test   %rax,%rax
  801e63:	74 21                	je     801e86 <fd_lookup+0x77>
  801e65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e69:	48 c1 e8 0c          	shr    $0xc,%rax
  801e6d:	48 89 c2             	mov    %rax,%rdx
  801e70:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e77:	01 00 00 
  801e7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7e:	83 e0 01             	and    $0x1,%eax
  801e81:	48 85 c0             	test   %rax,%rax
  801e84:	75 07                	jne    801e8d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e8b:	eb 10                	jmp    801e9d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e91:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e95:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9d:	c9                   	leaveq 
  801e9e:	c3                   	retq   

0000000000801e9f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e9f:	55                   	push   %rbp
  801ea0:	48 89 e5             	mov    %rsp,%rbp
  801ea3:	48 83 ec 30          	sub    $0x30,%rsp
  801ea7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801eab:	89 f0                	mov    %esi,%eax
  801ead:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb4:	48 89 c7             	mov    %rax,%rdi
  801eb7:	48 b8 29 1d 80 00 00 	movabs $0x801d29,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
  801ec3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ec7:	48 89 d6             	mov    %rdx,%rsi
  801eca:	89 c7                	mov    %eax,%edi
  801ecc:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
  801ed8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801edb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801edf:	78 0a                	js     801eeb <fd_close+0x4c>
	    || fd != fd2)
  801ee1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee5:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ee9:	74 12                	je     801efd <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eeb:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801eef:	74 05                	je     801ef6 <fd_close+0x57>
  801ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef4:	eb 05                	jmp    801efb <fd_close+0x5c>
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	eb 69                	jmp    801f66 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f01:	8b 00                	mov    (%rax),%eax
  801f03:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f07:	48 89 d6             	mov    %rdx,%rsi
  801f0a:	89 c7                	mov    %eax,%edi
  801f0c:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
  801f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1f:	78 2a                	js     801f4b <fd_close+0xac>
		if (dev->dev_close)
  801f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f25:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f29:	48 85 c0             	test   %rax,%rax
  801f2c:	74 16                	je     801f44 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f32:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f36:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f3a:	48 89 d7             	mov    %rdx,%rdi
  801f3d:	ff d0                	callq  *%rax
  801f3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f42:	eb 07                	jmp    801f4b <fd_close+0xac>
		else
			r = 0;
  801f44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4f:	48 89 c6             	mov    %rax,%rsi
  801f52:	bf 00 00 00 00       	mov    $0x0,%edi
  801f57:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  801f5e:	00 00 00 
  801f61:	ff d0                	callq  *%rax
	return r;
  801f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f66:	c9                   	leaveq 
  801f67:	c3                   	retq   

0000000000801f68 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f68:	55                   	push   %rbp
  801f69:	48 89 e5             	mov    %rsp,%rbp
  801f6c:	48 83 ec 20          	sub    $0x20,%rsp
  801f70:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f7e:	eb 41                	jmp    801fc1 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f80:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f87:	00 00 00 
  801f8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f8d:	48 63 d2             	movslq %edx,%rdx
  801f90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f94:	8b 00                	mov    (%rax),%eax
  801f96:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f99:	75 22                	jne    801fbd <dev_lookup+0x55>
			*dev = devtab[i];
  801f9b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801fa2:	00 00 00 
  801fa5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fa8:	48 63 d2             	movslq %edx,%rdx
  801fab:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801faf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	eb 60                	jmp    80201d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fbd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fc1:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801fc8:	00 00 00 
  801fcb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fce:	48 63 d2             	movslq %edx,%rdx
  801fd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd5:	48 85 c0             	test   %rax,%rax
  801fd8:	75 a6                	jne    801f80 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fda:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fe1:	00 00 00 
  801fe4:	48 8b 00             	mov    (%rax),%rax
  801fe7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ff0:	89 c6                	mov    %eax,%esi
  801ff2:	48 bf f8 40 80 00 00 	movabs $0x8040f8,%rdi
  801ff9:	00 00 00 
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	48 b9 c5 05 80 00 00 	movabs $0x8005c5,%rcx
  802008:	00 00 00 
  80200b:	ff d1                	callq  *%rcx
	*dev = 0;
  80200d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802011:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802018:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80201d:	c9                   	leaveq 
  80201e:	c3                   	retq   

000000000080201f <close>:

int
close(int fdnum)
{
  80201f:	55                   	push   %rbp
  802020:	48 89 e5             	mov    %rsp,%rbp
  802023:	48 83 ec 20          	sub    $0x20,%rsp
  802027:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80202a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80202e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802031:	48 89 d6             	mov    %rdx,%rsi
  802034:	89 c7                	mov    %eax,%edi
  802036:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
  802042:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802045:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802049:	79 05                	jns    802050 <close+0x31>
		return r;
  80204b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204e:	eb 18                	jmp    802068 <close+0x49>
	else
		return fd_close(fd, 1);
  802050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802054:	be 01 00 00 00       	mov    $0x1,%esi
  802059:	48 89 c7             	mov    %rax,%rdi
  80205c:	48 b8 9f 1e 80 00 00 	movabs $0x801e9f,%rax
  802063:	00 00 00 
  802066:	ff d0                	callq  *%rax
}
  802068:	c9                   	leaveq 
  802069:	c3                   	retq   

000000000080206a <close_all>:

void
close_all(void)
{
  80206a:	55                   	push   %rbp
  80206b:	48 89 e5             	mov    %rsp,%rbp
  80206e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802079:	eb 15                	jmp    802090 <close_all+0x26>
		close(i);
  80207b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207e:	89 c7                	mov    %eax,%edi
  802080:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802087:	00 00 00 
  80208a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80208c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802090:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802094:	7e e5                	jle    80207b <close_all+0x11>
		close(i);
}
  802096:	c9                   	leaveq 
  802097:	c3                   	retq   

0000000000802098 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802098:	55                   	push   %rbp
  802099:	48 89 e5             	mov    %rsp,%rbp
  80209c:	48 83 ec 40          	sub    $0x40,%rsp
  8020a0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020a3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020a6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020aa:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020ad:	48 89 d6             	mov    %rdx,%rsi
  8020b0:	89 c7                	mov    %eax,%edi
  8020b2:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8020b9:	00 00 00 
  8020bc:	ff d0                	callq  *%rax
  8020be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c5:	79 08                	jns    8020cf <dup+0x37>
		return r;
  8020c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ca:	e9 70 01 00 00       	jmpq   80223f <dup+0x1a7>
	close(newfdnum);
  8020cf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020d2:	89 c7                	mov    %eax,%edi
  8020d4:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020e0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020e3:	48 98                	cltq   
  8020e5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020eb:	48 c1 e0 0c          	shl    $0xc,%rax
  8020ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f7:	48 89 c7             	mov    %rax,%rdi
  8020fa:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  802101:	00 00 00 
  802104:	ff d0                	callq  *%rax
  802106:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80210a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210e:	48 89 c7             	mov    %rax,%rdi
  802111:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
  80211d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802125:	48 c1 e8 15          	shr    $0x15,%rax
  802129:	48 89 c2             	mov    %rax,%rdx
  80212c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802133:	01 00 00 
  802136:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213a:	83 e0 01             	and    $0x1,%eax
  80213d:	48 85 c0             	test   %rax,%rax
  802140:	74 73                	je     8021b5 <dup+0x11d>
  802142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802146:	48 c1 e8 0c          	shr    $0xc,%rax
  80214a:	48 89 c2             	mov    %rax,%rdx
  80214d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802154:	01 00 00 
  802157:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215b:	83 e0 01             	and    $0x1,%eax
  80215e:	48 85 c0             	test   %rax,%rax
  802161:	74 52                	je     8021b5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802167:	48 c1 e8 0c          	shr    $0xc,%rax
  80216b:	48 89 c2             	mov    %rax,%rdx
  80216e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802175:	01 00 00 
  802178:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217c:	25 07 0e 00 00       	and    $0xe07,%eax
  802181:	89 c1                	mov    %eax,%ecx
  802183:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218b:	41 89 c8             	mov    %ecx,%r8d
  80218e:	48 89 d1             	mov    %rdx,%rcx
  802191:	ba 00 00 00 00       	mov    $0x0,%edx
  802196:	48 89 c6             	mov    %rax,%rsi
  802199:	bf 00 00 00 00       	mov    $0x0,%edi
  80219e:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	callq  *%rax
  8021aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b1:	79 02                	jns    8021b5 <dup+0x11d>
			goto err;
  8021b3:	eb 57                	jmp    80220c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8021bd:	48 89 c2             	mov    %rax,%rdx
  8021c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c7:	01 00 00 
  8021ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8021d3:	89 c1                	mov    %eax,%ecx
  8021d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021dd:	41 89 c8             	mov    %ecx,%r8d
  8021e0:	48 89 d1             	mov    %rdx,%rcx
  8021e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e8:	48 89 c6             	mov    %rax,%rsi
  8021eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f0:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  8021f7:	00 00 00 
  8021fa:	ff d0                	callq  *%rax
  8021fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802203:	79 02                	jns    802207 <dup+0x16f>
		goto err;
  802205:	eb 05                	jmp    80220c <dup+0x174>

	return newfdnum;
  802207:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80220a:	eb 33                	jmp    80223f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80220c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802210:	48 89 c6             	mov    %rax,%rsi
  802213:	bf 00 00 00 00       	mov    $0x0,%edi
  802218:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  80221f:	00 00 00 
  802222:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802224:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802228:	48 89 c6             	mov    %rax,%rsi
  80222b:	bf 00 00 00 00       	mov    $0x0,%edi
  802230:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
	return r;
  80223c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80223f:	c9                   	leaveq 
  802240:	c3                   	retq   

0000000000802241 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802241:	55                   	push   %rbp
  802242:	48 89 e5             	mov    %rsp,%rbp
  802245:	48 83 ec 40          	sub    $0x40,%rsp
  802249:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80224c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802250:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802254:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802258:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80225b:	48 89 d6             	mov    %rdx,%rsi
  80225e:	89 c7                	mov    %eax,%edi
  802260:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  802267:	00 00 00 
  80226a:	ff d0                	callq  *%rax
  80226c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802273:	78 24                	js     802299 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802279:	8b 00                	mov    (%rax),%eax
  80227b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80227f:	48 89 d6             	mov    %rdx,%rsi
  802282:	89 c7                	mov    %eax,%edi
  802284:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax
  802290:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802297:	79 05                	jns    80229e <read+0x5d>
		return r;
  802299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229c:	eb 76                	jmp    802314 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80229e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a2:	8b 40 08             	mov    0x8(%rax),%eax
  8022a5:	83 e0 03             	and    $0x3,%eax
  8022a8:	83 f8 01             	cmp    $0x1,%eax
  8022ab:	75 3a                	jne    8022e7 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8022b4:	00 00 00 
  8022b7:	48 8b 00             	mov    (%rax),%rax
  8022ba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022c0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022c3:	89 c6                	mov    %eax,%esi
  8022c5:	48 bf 17 41 80 00 00 	movabs $0x804117,%rdi
  8022cc:	00 00 00 
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	48 b9 c5 05 80 00 00 	movabs $0x8005c5,%rcx
  8022db:	00 00 00 
  8022de:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022e5:	eb 2d                	jmp    802314 <read+0xd3>
	}
	if (!dev->dev_read)
  8022e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022eb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022ef:	48 85 c0             	test   %rax,%rax
  8022f2:	75 07                	jne    8022fb <read+0xba>
		return -E_NOT_SUPP;
  8022f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022f9:	eb 19                	jmp    802314 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ff:	48 8b 40 10          	mov    0x10(%rax),%rax
  802303:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802307:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80230b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80230f:	48 89 cf             	mov    %rcx,%rdi
  802312:	ff d0                	callq  *%rax
}
  802314:	c9                   	leaveq 
  802315:	c3                   	retq   

0000000000802316 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 30          	sub    $0x30,%rsp
  80231e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802321:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802325:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802329:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802330:	eb 49                	jmp    80237b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802335:	48 98                	cltq   
  802337:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80233b:	48 29 c2             	sub    %rax,%rdx
  80233e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802341:	48 63 c8             	movslq %eax,%rcx
  802344:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802348:	48 01 c1             	add    %rax,%rcx
  80234b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80234e:	48 89 ce             	mov    %rcx,%rsi
  802351:	89 c7                	mov    %eax,%edi
  802353:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
  80235f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802362:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802366:	79 05                	jns    80236d <readn+0x57>
			return m;
  802368:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80236b:	eb 1c                	jmp    802389 <readn+0x73>
		if (m == 0)
  80236d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802371:	75 02                	jne    802375 <readn+0x5f>
			break;
  802373:	eb 11                	jmp    802386 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802375:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802378:	01 45 fc             	add    %eax,-0x4(%rbp)
  80237b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237e:	48 98                	cltq   
  802380:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802384:	72 ac                	jb     802332 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802386:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802389:	c9                   	leaveq 
  80238a:	c3                   	retq   

000000000080238b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80238b:	55                   	push   %rbp
  80238c:	48 89 e5             	mov    %rsp,%rbp
  80238f:	48 83 ec 40          	sub    $0x40,%rsp
  802393:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802396:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80239a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80239e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023a5:	48 89 d6             	mov    %rdx,%rsi
  8023a8:	89 c7                	mov    %eax,%edi
  8023aa:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8023b1:	00 00 00 
  8023b4:	ff d0                	callq  *%rax
  8023b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bd:	78 24                	js     8023e3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c3:	8b 00                	mov    (%rax),%eax
  8023c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c9:	48 89 d6             	mov    %rdx,%rsi
  8023cc:	89 c7                	mov    %eax,%edi
  8023ce:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
  8023da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e1:	79 05                	jns    8023e8 <write+0x5d>
		return r;
  8023e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e6:	eb 75                	jmp    80245d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ec:	8b 40 08             	mov    0x8(%rax),%eax
  8023ef:	83 e0 03             	and    $0x3,%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 3a                	jne    802430 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023f6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023fd:	00 00 00 
  802400:	48 8b 00             	mov    (%rax),%rax
  802403:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802409:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80240c:	89 c6                	mov    %eax,%esi
  80240e:	48 bf 33 41 80 00 00 	movabs $0x804133,%rdi
  802415:	00 00 00 
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
  80241d:	48 b9 c5 05 80 00 00 	movabs $0x8005c5,%rcx
  802424:	00 00 00 
  802427:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802429:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80242e:	eb 2d                	jmp    80245d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802434:	48 8b 40 18          	mov    0x18(%rax),%rax
  802438:	48 85 c0             	test   %rax,%rax
  80243b:	75 07                	jne    802444 <write+0xb9>
		return -E_NOT_SUPP;
  80243d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802442:	eb 19                	jmp    80245d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802448:	48 8b 40 18          	mov    0x18(%rax),%rax
  80244c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802450:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802454:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802458:	48 89 cf             	mov    %rcx,%rdi
  80245b:	ff d0                	callq  *%rax
}
  80245d:	c9                   	leaveq 
  80245e:	c3                   	retq   

000000000080245f <seek>:

int
seek(int fdnum, off_t offset)
{
  80245f:	55                   	push   %rbp
  802460:	48 89 e5             	mov    %rsp,%rbp
  802463:	48 83 ec 18          	sub    $0x18,%rsp
  802467:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80246a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802471:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802474:	48 89 d6             	mov    %rdx,%rsi
  802477:	89 c7                	mov    %eax,%edi
  802479:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  802480:	00 00 00 
  802483:	ff d0                	callq  *%rax
  802485:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80248c:	79 05                	jns    802493 <seek+0x34>
		return r;
  80248e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802491:	eb 0f                	jmp    8024a2 <seek+0x43>
	fd->fd_offset = offset;
  802493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802497:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80249a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a2:	c9                   	leaveq 
  8024a3:	c3                   	retq   

00000000008024a4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024a4:	55                   	push   %rbp
  8024a5:	48 89 e5             	mov    %rsp,%rbp
  8024a8:	48 83 ec 30          	sub    $0x30,%rsp
  8024ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024af:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024b9:	48 89 d6             	mov    %rdx,%rsi
  8024bc:	89 c7                	mov    %eax,%edi
  8024be:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8024c5:	00 00 00 
  8024c8:	ff d0                	callq  *%rax
  8024ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d1:	78 24                	js     8024f7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d7:	8b 00                	mov    (%rax),%eax
  8024d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024dd:	48 89 d6             	mov    %rdx,%rsi
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
  8024ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f5:	79 05                	jns    8024fc <ftruncate+0x58>
		return r;
  8024f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fa:	eb 72                	jmp    80256e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802500:	8b 40 08             	mov    0x8(%rax),%eax
  802503:	83 e0 03             	and    $0x3,%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	75 3a                	jne    802544 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80250a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802511:	00 00 00 
  802514:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802517:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80251d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802520:	89 c6                	mov    %eax,%esi
  802522:	48 bf 50 41 80 00 00 	movabs $0x804150,%rdi
  802529:	00 00 00 
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
  802531:	48 b9 c5 05 80 00 00 	movabs $0x8005c5,%rcx
  802538:	00 00 00 
  80253b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80253d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802542:	eb 2a                	jmp    80256e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802548:	48 8b 40 30          	mov    0x30(%rax),%rax
  80254c:	48 85 c0             	test   %rax,%rax
  80254f:	75 07                	jne    802558 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802551:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802556:	eb 16                	jmp    80256e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802560:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802564:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802567:	89 ce                	mov    %ecx,%esi
  802569:	48 89 d7             	mov    %rdx,%rdi
  80256c:	ff d0                	callq  *%rax
}
  80256e:	c9                   	leaveq 
  80256f:	c3                   	retq   

0000000000802570 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802570:	55                   	push   %rbp
  802571:	48 89 e5             	mov    %rsp,%rbp
  802574:	48 83 ec 30          	sub    $0x30,%rsp
  802578:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80257b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80257f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802583:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802586:	48 89 d6             	mov    %rdx,%rsi
  802589:	89 c7                	mov    %eax,%edi
  80258b:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax
  802597:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259e:	78 24                	js     8025c4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a4:	8b 00                	mov    (%rax),%eax
  8025a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025aa:	48 89 d6             	mov    %rdx,%rsi
  8025ad:	89 c7                	mov    %eax,%edi
  8025af:	48 b8 68 1f 80 00 00 	movabs $0x801f68,%rax
  8025b6:	00 00 00 
  8025b9:	ff d0                	callq  *%rax
  8025bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c2:	79 05                	jns    8025c9 <fstat+0x59>
		return r;
  8025c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c7:	eb 5e                	jmp    802627 <fstat+0xb7>
	if (!dev->dev_stat)
  8025c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cd:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025d1:	48 85 c0             	test   %rax,%rax
  8025d4:	75 07                	jne    8025dd <fstat+0x6d>
		return -E_NOT_SUPP;
  8025d6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025db:	eb 4a                	jmp    802627 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025ef:	00 00 00 
	stat->st_isdir = 0;
  8025f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025f6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025fd:	00 00 00 
	stat->st_dev = dev;
  802600:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802604:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802608:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80260f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802613:	48 8b 40 28          	mov    0x28(%rax),%rax
  802617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80261b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80261f:	48 89 ce             	mov    %rcx,%rsi
  802622:	48 89 d7             	mov    %rdx,%rdi
  802625:	ff d0                	callq  *%rax
}
  802627:	c9                   	leaveq 
  802628:	c3                   	retq   

0000000000802629 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802629:	55                   	push   %rbp
  80262a:	48 89 e5             	mov    %rsp,%rbp
  80262d:	48 83 ec 20          	sub    $0x20,%rsp
  802631:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802635:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263d:	be 00 00 00 00       	mov    $0x0,%esi
  802642:	48 89 c7             	mov    %rax,%rdi
  802645:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  80264c:	00 00 00 
  80264f:	ff d0                	callq  *%rax
  802651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802658:	79 05                	jns    80265f <stat+0x36>
		return fd;
  80265a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265d:	eb 2f                	jmp    80268e <stat+0x65>
	r = fstat(fd, stat);
  80265f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802663:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802666:	48 89 d6             	mov    %rdx,%rsi
  802669:	89 c7                	mov    %eax,%edi
  80266b:	48 b8 70 25 80 00 00 	movabs $0x802570,%rax
  802672:	00 00 00 
  802675:	ff d0                	callq  *%rax
  802677:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80267a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267d:	89 c7                	mov    %eax,%edi
  80267f:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
	return r;
  80268b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80268e:	c9                   	leaveq 
  80268f:	c3                   	retq   

0000000000802690 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802690:	55                   	push   %rbp
  802691:	48 89 e5             	mov    %rsp,%rbp
  802694:	48 83 ec 10          	sub    $0x10,%rsp
  802698:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80269b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80269f:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8026a6:	00 00 00 
  8026a9:	8b 00                	mov    (%rax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	75 1d                	jne    8026cc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026af:	bf 01 00 00 00       	mov    $0x1,%edi
  8026b4:	48 b8 4b 3a 80 00 00 	movabs $0x803a4b,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
  8026c0:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  8026c7:	00 00 00 
  8026ca:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026cc:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8026d3:	00 00 00 
  8026d6:	8b 00                	mov    (%rax),%eax
  8026d8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026e0:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026e7:	00 00 00 
  8026ea:	89 c7                	mov    %eax,%edi
  8026ec:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802701:	48 89 c6             	mov    %rax,%rsi
  802704:	bf 00 00 00 00       	mov    $0x0,%edi
  802709:	48 b8 f2 38 80 00 00 	movabs $0x8038f2,%rax
  802710:	00 00 00 
  802713:	ff d0                	callq  *%rax
}
  802715:	c9                   	leaveq 
  802716:	c3                   	retq   

0000000000802717 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802717:	55                   	push   %rbp
  802718:	48 89 e5             	mov    %rsp,%rbp
  80271b:	48 83 ec 20          	sub    $0x20,%rsp
  80271f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802723:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272a:	48 89 c7             	mov    %rax,%rdi
  80272d:	48 b8 21 11 80 00 00 	movabs $0x801121,%rax
  802734:	00 00 00 
  802737:	ff d0                	callq  *%rax
  802739:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80273e:	7e 0a                	jle    80274a <open+0x33>
		return -E_BAD_PATH;
  802740:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802745:	e9 a5 00 00 00       	jmpq   8027ef <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80274a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80274e:	48 89 c7             	mov    %rax,%rdi
  802751:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	79 08                	jns    80276e <open+0x57>
		return r;
  802766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802769:	e9 81 00 00 00       	jmpq   8027ef <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80276e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802772:	48 89 c6             	mov    %rax,%rsi
  802775:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80277c:	00 00 00 
  80277f:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80278b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802792:	00 00 00 
  802795:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802798:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80279e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a2:	48 89 c6             	mov    %rax,%rsi
  8027a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8027aa:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	callq  *%rax
  8027b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bd:	79 1d                	jns    8027dc <open+0xc5>
		fd_close(fd, 0);
  8027bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c3:	be 00 00 00 00       	mov    $0x0,%esi
  8027c8:	48 89 c7             	mov    %rax,%rdi
  8027cb:	48 b8 9f 1e 80 00 00 	movabs $0x801e9f,%rax
  8027d2:	00 00 00 
  8027d5:	ff d0                	callq  *%rax
		return r;
  8027d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027da:	eb 13                	jmp    8027ef <open+0xd8>
	}

	return fd2num(fd);
  8027dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e0:	48 89 c7             	mov    %rax,%rdi
  8027e3:	48 b8 29 1d 80 00 00 	movabs $0x801d29,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8027ef:	c9                   	leaveq 
  8027f0:	c3                   	retq   

00000000008027f1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027f1:	55                   	push   %rbp
  8027f2:	48 89 e5             	mov    %rsp,%rbp
  8027f5:	48 83 ec 10          	sub    $0x10,%rsp
  8027f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802801:	8b 50 0c             	mov    0xc(%rax),%edx
  802804:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80280b:	00 00 00 
  80280e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802810:	be 00 00 00 00       	mov    $0x0,%esi
  802815:	bf 06 00 00 00       	mov    $0x6,%edi
  80281a:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
}
  802826:	c9                   	leaveq 
  802827:	c3                   	retq   

0000000000802828 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802828:	55                   	push   %rbp
  802829:	48 89 e5             	mov    %rsp,%rbp
  80282c:	48 83 ec 30          	sub    $0x30,%rsp
  802830:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802834:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802838:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80283c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802840:	8b 50 0c             	mov    0xc(%rax),%edx
  802843:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80284a:	00 00 00 
  80284d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80284f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802856:	00 00 00 
  802859:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80285d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802861:	be 00 00 00 00       	mov    $0x0,%esi
  802866:	bf 03 00 00 00       	mov    $0x3,%edi
  80286b:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
  802877:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287e:	79 08                	jns    802888 <devfile_read+0x60>
		return r;
  802880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802883:	e9 a4 00 00 00       	jmpq   80292c <devfile_read+0x104>
	assert(r <= n);
  802888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288b:	48 98                	cltq   
  80288d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802891:	76 35                	jbe    8028c8 <devfile_read+0xa0>
  802893:	48 b9 7d 41 80 00 00 	movabs $0x80417d,%rcx
  80289a:	00 00 00 
  80289d:	48 ba 84 41 80 00 00 	movabs $0x804184,%rdx
  8028a4:	00 00 00 
  8028a7:	be 84 00 00 00       	mov    $0x84,%esi
  8028ac:	48 bf 99 41 80 00 00 	movabs $0x804199,%rdi
  8028b3:	00 00 00 
  8028b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bb:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  8028c2:	00 00 00 
  8028c5:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8028c8:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8028cf:	7e 35                	jle    802906 <devfile_read+0xde>
  8028d1:	48 b9 a4 41 80 00 00 	movabs $0x8041a4,%rcx
  8028d8:	00 00 00 
  8028db:	48 ba 84 41 80 00 00 	movabs $0x804184,%rdx
  8028e2:	00 00 00 
  8028e5:	be 85 00 00 00       	mov    $0x85,%esi
  8028ea:	48 bf 99 41 80 00 00 	movabs $0x804199,%rdi
  8028f1:	00 00 00 
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f9:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  802900:	00 00 00 
  802903:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802909:	48 63 d0             	movslq %eax,%rdx
  80290c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802910:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802917:	00 00 00 
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
	return r;
  802929:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80292c:	c9                   	leaveq 
  80292d:	c3                   	retq   

000000000080292e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80292e:	55                   	push   %rbp
  80292f:	48 89 e5             	mov    %rsp,%rbp
  802932:	48 83 ec 30          	sub    $0x30,%rsp
  802936:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80293a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80293e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802946:	8b 50 0c             	mov    0xc(%rax),%edx
  802949:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802950:	00 00 00 
  802953:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802955:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80295c:	00 00 00 
  80295f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802963:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802967:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80296e:	00 
  80296f:	76 35                	jbe    8029a6 <devfile_write+0x78>
  802971:	48 b9 b0 41 80 00 00 	movabs $0x8041b0,%rcx
  802978:	00 00 00 
  80297b:	48 ba 84 41 80 00 00 	movabs $0x804184,%rdx
  802982:	00 00 00 
  802985:	be 9e 00 00 00       	mov    $0x9e,%esi
  80298a:	48 bf 99 41 80 00 00 	movabs $0x804199,%rdi
  802991:	00 00 00 
  802994:	b8 00 00 00 00       	mov    $0x0,%eax
  802999:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  8029a0:	00 00 00 
  8029a3:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8029a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ae:	48 89 c6             	mov    %rax,%rsi
  8029b1:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8029b8:	00 00 00 
  8029bb:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  8029c2:	00 00 00 
  8029c5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8029c7:	be 00 00 00 00       	mov    $0x0,%esi
  8029cc:	bf 04 00 00 00       	mov    $0x4,%edi
  8029d1:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax
  8029dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e4:	79 05                	jns    8029eb <devfile_write+0xbd>
		return r;
  8029e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e9:	eb 43                	jmp    802a2e <devfile_write+0x100>
	assert(r <= n);
  8029eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ee:	48 98                	cltq   
  8029f0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029f4:	76 35                	jbe    802a2b <devfile_write+0xfd>
  8029f6:	48 b9 7d 41 80 00 00 	movabs $0x80417d,%rcx
  8029fd:	00 00 00 
  802a00:	48 ba 84 41 80 00 00 	movabs $0x804184,%rdx
  802a07:	00 00 00 
  802a0a:	be a2 00 00 00       	mov    $0xa2,%esi
  802a0f:	48 bf 99 41 80 00 00 	movabs $0x804199,%rdi
  802a16:	00 00 00 
  802a19:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1e:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  802a25:	00 00 00 
  802a28:	41 ff d0             	callq  *%r8
	return r;
  802a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802a2e:	c9                   	leaveq 
  802a2f:	c3                   	retq   

0000000000802a30 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a30:	55                   	push   %rbp
  802a31:	48 89 e5             	mov    %rsp,%rbp
  802a34:	48 83 ec 20          	sub    $0x20,%rsp
  802a38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a44:	8b 50 0c             	mov    0xc(%rax),%edx
  802a47:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a4e:	00 00 00 
  802a51:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a53:	be 00 00 00 00       	mov    $0x0,%esi
  802a58:	bf 05 00 00 00       	mov    $0x5,%edi
  802a5d:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a70:	79 05                	jns    802a77 <devfile_stat+0x47>
		return r;
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	eb 56                	jmp    802acd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a82:	00 00 00 
  802a85:	48 89 c7             	mov    %rax,%rdi
  802a88:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802a8f:	00 00 00 
  802a92:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a94:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a9b:	00 00 00 
  802a9e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802aa4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802aae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ab5:	00 00 00 
  802ab8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802abe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802acd:	c9                   	leaveq 
  802ace:	c3                   	retq   

0000000000802acf <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802acf:	55                   	push   %rbp
  802ad0:	48 89 e5             	mov    %rsp,%rbp
  802ad3:	48 83 ec 10          	sub    $0x10,%rsp
  802ad7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802adb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ade:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ae5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aec:	00 00 00 
  802aef:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802af1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802af8:	00 00 00 
  802afb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802afe:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b01:	be 00 00 00 00       	mov    $0x0,%esi
  802b06:	bf 02 00 00 00       	mov    $0x2,%edi
  802b0b:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
}
  802b17:	c9                   	leaveq 
  802b18:	c3                   	retq   

0000000000802b19 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b19:	55                   	push   %rbp
  802b1a:	48 89 e5             	mov    %rsp,%rbp
  802b1d:	48 83 ec 10          	sub    $0x10,%rsp
  802b21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b29:	48 89 c7             	mov    %rax,%rdi
  802b2c:	48 b8 21 11 80 00 00 	movabs $0x801121,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b3d:	7e 07                	jle    802b46 <remove+0x2d>
		return -E_BAD_PATH;
  802b3f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b44:	eb 33                	jmp    802b79 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b4a:	48 89 c6             	mov    %rax,%rsi
  802b4d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802b54:	00 00 00 
  802b57:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b63:	be 00 00 00 00       	mov    $0x0,%esi
  802b68:	bf 07 00 00 00       	mov    $0x7,%edi
  802b6d:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
}
  802b79:	c9                   	leaveq 
  802b7a:	c3                   	retq   

0000000000802b7b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b7b:	55                   	push   %rbp
  802b7c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b7f:	be 00 00 00 00       	mov    $0x0,%esi
  802b84:	bf 08 00 00 00       	mov    $0x8,%edi
  802b89:	48 b8 90 26 80 00 00 	movabs $0x802690,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
}
  802b95:	5d                   	pop    %rbp
  802b96:	c3                   	retq   

0000000000802b97 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b97:	55                   	push   %rbp
  802b98:	48 89 e5             	mov    %rsp,%rbp
  802b9b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ba2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ba9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802bb0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802bb7:	be 00 00 00 00       	mov    $0x0,%esi
  802bbc:	48 89 c7             	mov    %rax,%rdi
  802bbf:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
  802bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd2:	79 28                	jns    802bfc <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd7:	89 c6                	mov    %eax,%esi
  802bd9:	48 bf dd 41 80 00 00 	movabs $0x8041dd,%rdi
  802be0:	00 00 00 
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
  802be8:	48 ba c5 05 80 00 00 	movabs $0x8005c5,%rdx
  802bef:	00 00 00 
  802bf2:	ff d2                	callq  *%rdx
		return fd_src;
  802bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf7:	e9 74 01 00 00       	jmpq   802d70 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bfc:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c03:	be 01 01 00 00       	mov    $0x101,%esi
  802c08:	48 89 c7             	mov    %rax,%rdi
  802c0b:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c1e:	79 39                	jns    802c59 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c23:	89 c6                	mov    %eax,%esi
  802c25:	48 bf f3 41 80 00 00 	movabs $0x8041f3,%rdi
  802c2c:	00 00 00 
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c34:	48 ba c5 05 80 00 00 	movabs $0x8005c5,%rdx
  802c3b:	00 00 00 
  802c3e:	ff d2                	callq  *%rdx
		close(fd_src);
  802c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
		return fd_dest;
  802c51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c54:	e9 17 01 00 00       	jmpq   802d70 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c59:	eb 74                	jmp    802ccf <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c5e:	48 63 d0             	movslq %eax,%rdx
  802c61:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c6b:	48 89 ce             	mov    %rcx,%rsi
  802c6e:	89 c7                	mov    %eax,%edi
  802c70:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  802c77:	00 00 00 
  802c7a:	ff d0                	callq  *%rax
  802c7c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c83:	79 4a                	jns    802ccf <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c85:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c88:	89 c6                	mov    %eax,%esi
  802c8a:	48 bf 0d 42 80 00 00 	movabs $0x80420d,%rdi
  802c91:	00 00 00 
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
  802c99:	48 ba c5 05 80 00 00 	movabs $0x8005c5,%rdx
  802ca0:	00 00 00 
  802ca3:	ff d2                	callq  *%rdx
			close(fd_src);
  802ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca8:	89 c7                	mov    %eax,%edi
  802caa:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802cb1:	00 00 00 
  802cb4:	ff d0                	callq  *%rax
			close(fd_dest);
  802cb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb9:	89 c7                	mov    %eax,%edi
  802cbb:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
			return write_size;
  802cc7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cca:	e9 a1 00 00 00       	jmpq   802d70 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ccf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd9:	ba 00 02 00 00       	mov    $0x200,%edx
  802cde:	48 89 ce             	mov    %rcx,%rsi
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802cf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cf6:	0f 8f 5f ff ff ff    	jg     802c5b <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802cfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d00:	79 47                	jns    802d49 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d02:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d05:	89 c6                	mov    %eax,%esi
  802d07:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  802d0e:	00 00 00 
  802d11:	b8 00 00 00 00       	mov    $0x0,%eax
  802d16:	48 ba c5 05 80 00 00 	movabs $0x8005c5,%rdx
  802d1d:	00 00 00 
  802d20:	ff d2                	callq  *%rdx
		close(fd_src);
  802d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d25:	89 c7                	mov    %eax,%edi
  802d27:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
		close(fd_dest);
  802d33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d36:	89 c7                	mov    %eax,%edi
  802d38:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
		return read_size;
  802d44:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d47:	eb 27                	jmp    802d70 <copy+0x1d9>
	}
	close(fd_src);
  802d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
	close(fd_dest);
  802d5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d5d:	89 c7                	mov    %eax,%edi
  802d5f:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
	return 0;
  802d6b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802d70:	c9                   	leaveq 
  802d71:	c3                   	retq   

0000000000802d72 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d72:	55                   	push   %rbp
  802d73:	48 89 e5             	mov    %rsp,%rbp
  802d76:	48 83 ec 20          	sub    $0x20,%rsp
  802d7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d82:	8b 40 0c             	mov    0xc(%rax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	7e 67                	jle    802df0 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8d:	8b 40 04             	mov    0x4(%rax),%eax
  802d90:	48 63 d0             	movslq %eax,%rdx
  802d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d97:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9f:	8b 00                	mov    (%rax),%eax
  802da1:	48 89 ce             	mov    %rcx,%rsi
  802da4:	89 c7                	mov    %eax,%edi
  802da6:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	7e 13                	jle    802dce <writebuf+0x5c>
			b->result += result;
  802dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbf:	8b 50 08             	mov    0x8(%rax),%edx
  802dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcb:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802dce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd2:	8b 40 04             	mov    0x4(%rax),%eax
  802dd5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802dd8:	74 16                	je     802df0 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802dda:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de3:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802de7:	89 c2                	mov    %eax,%edx
  802de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ded:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <putch>:

static void
putch(int ch, void *thunk)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 20          	sub    $0x20,%rsp
  802dfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802e01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0d:	8b 40 04             	mov    0x4(%rax),%eax
  802e10:	8d 48 01             	lea    0x1(%rax),%ecx
  802e13:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e17:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802e1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e1d:	89 d1                	mov    %edx,%ecx
  802e1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e23:	48 98                	cltq   
  802e25:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802e29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2d:	8b 40 04             	mov    0x4(%rax),%eax
  802e30:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e35:	75 1e                	jne    802e55 <putch+0x63>
		writebuf(b);
  802e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3b:	48 89 c7             	mov    %rax,%rdi
  802e3e:	48 b8 72 2d 80 00 00 	movabs $0x802d72,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax
		b->idx = 0;
  802e4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802e55:	c9                   	leaveq 
  802e56:	c3                   	retq   

0000000000802e57 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e57:	55                   	push   %rbp
  802e58:	48 89 e5             	mov    %rsp,%rbp
  802e5b:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e62:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e68:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e6f:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e76:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e7c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e82:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e89:	00 00 00 
	b.result = 0;
  802e8c:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e93:	00 00 00 
	b.error = 1;
  802e96:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e9d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802ea0:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802ea7:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802eae:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802eb5:	48 89 c6             	mov    %rax,%rsi
  802eb8:	48 bf f2 2d 80 00 00 	movabs $0x802df2,%rdi
  802ebf:	00 00 00 
  802ec2:	48 b8 78 09 80 00 00 	movabs $0x800978,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802ece:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	7e 16                	jle    802eee <vfprintf+0x97>
		writebuf(&b);
  802ed8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802edf:	48 89 c7             	mov    %rax,%rdi
  802ee2:	48 b8 72 2d 80 00 00 	movabs $0x802d72,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802eee:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 08                	je     802f00 <vfprintf+0xa9>
  802ef8:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802efe:	eb 06                	jmp    802f06 <vfprintf+0xaf>
  802f00:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802f06:	c9                   	leaveq 
  802f07:	c3                   	retq   

0000000000802f08 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802f08:	55                   	push   %rbp
  802f09:	48 89 e5             	mov    %rsp,%rbp
  802f0c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f13:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802f19:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802f20:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f27:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f2e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f35:	84 c0                	test   %al,%al
  802f37:	74 20                	je     802f59 <fprintf+0x51>
  802f39:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f3d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f41:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f45:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f49:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f4d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f51:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f55:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f59:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f60:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f67:	00 00 00 
  802f6a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f71:	00 00 00 
  802f74:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f78:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f7f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f86:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f8d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f94:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f9b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802fa1:	48 89 ce             	mov    %rcx,%rsi
  802fa4:	89 c7                	mov    %eax,%edi
  802fa6:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  802fad:	00 00 00 
  802fb0:	ff d0                	callq  *%rax
  802fb2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802fb8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802fbe:	c9                   	leaveq 
  802fbf:	c3                   	retq   

0000000000802fc0 <printf>:

int
printf(const char *fmt, ...)
{
  802fc0:	55                   	push   %rbp
  802fc1:	48 89 e5             	mov    %rsp,%rbp
  802fc4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fcb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802fd2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fe0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fe7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fee:	84 c0                	test   %al,%al
  802ff0:	74 20                	je     803012 <printf+0x52>
  802ff2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ff6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ffa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ffe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803002:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803006:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80300a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80300e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803012:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803019:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803020:	00 00 00 
  803023:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80302a:	00 00 00 
  80302d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803031:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803038:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80303f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803046:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80304d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803054:	48 89 c6             	mov    %rax,%rsi
  803057:	bf 01 00 00 00       	mov    $0x1,%edi
  80305c:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
  803068:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80306e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803074:	c9                   	leaveq 
  803075:	c3                   	retq   

0000000000803076 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803076:	55                   	push   %rbp
  803077:	48 89 e5             	mov    %rsp,%rbp
  80307a:	53                   	push   %rbx
  80307b:	48 83 ec 38          	sub    $0x38,%rsp
  80307f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803083:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803087:	48 89 c7             	mov    %rax,%rdi
  80308a:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
  803096:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803099:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80309d:	0f 88 bf 01 00 00    	js     803262 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a7:	ba 07 04 00 00       	mov    $0x407,%edx
  8030ac:	48 89 c6             	mov    %rax,%rsi
  8030af:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b4:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030c7:	0f 88 95 01 00 00    	js     803262 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030cd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030d1:	48 89 c7             	mov    %rax,%rdi
  8030d4:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  8030db:	00 00 00 
  8030de:	ff d0                	callq  *%rax
  8030e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030e7:	0f 88 5d 01 00 00    	js     80324a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030f1:	ba 07 04 00 00       	mov    $0x407,%edx
  8030f6:	48 89 c6             	mov    %rax,%rsi
  8030f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8030fe:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80310d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803111:	0f 88 33 01 00 00    	js     80324a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803117:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311b:	48 89 c7             	mov    %rax,%rdi
  80311e:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  803125:	00 00 00 
  803128:	ff d0                	callq  *%rax
  80312a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80312e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803132:	ba 07 04 00 00       	mov    $0x407,%edx
  803137:	48 89 c6             	mov    %rax,%rsi
  80313a:	bf 00 00 00 00       	mov    $0x0,%edi
  80313f:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803146:	00 00 00 
  803149:	ff d0                	callq  *%rax
  80314b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80314e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803152:	79 05                	jns    803159 <pipe+0xe3>
		goto err2;
  803154:	e9 d9 00 00 00       	jmpq   803232 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803159:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315d:	48 89 c7             	mov    %rax,%rdi
  803160:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
  80316c:	48 89 c2             	mov    %rax,%rdx
  80316f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803173:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803179:	48 89 d1             	mov    %rdx,%rcx
  80317c:	ba 00 00 00 00       	mov    $0x0,%edx
  803181:	48 89 c6             	mov    %rax,%rsi
  803184:	bf 00 00 00 00       	mov    $0x0,%edi
  803189:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
  803195:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803198:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80319c:	79 1b                	jns    8031b9 <pipe+0x143>
		goto err3;
  80319e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80319f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a3:	48 89 c6             	mov    %rax,%rsi
  8031a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ab:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  8031b2:	00 00 00 
  8031b5:	ff d0                	callq  *%rax
  8031b7:	eb 79                	jmp    803232 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031bd:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8031c4:	00 00 00 
  8031c7:	8b 12                	mov    (%rdx),%edx
  8031c9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8031cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031da:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8031e1:	00 00 00 
  8031e4:	8b 12                	mov    (%rdx),%edx
  8031e6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8031e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031ec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f7:	48 89 c7             	mov    %rax,%rdi
  8031fa:	48 b8 29 1d 80 00 00 	movabs $0x801d29,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
  803206:	89 c2                	mov    %eax,%edx
  803208:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80320c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80320e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803212:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803216:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80321a:	48 89 c7             	mov    %rax,%rdi
  80321d:	48 b8 29 1d 80 00 00 	movabs $0x801d29,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
  803229:	89 03                	mov    %eax,(%rbx)
	return 0;
  80322b:	b8 00 00 00 00       	mov    $0x0,%eax
  803230:	eb 33                	jmp    803265 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803232:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803236:	48 89 c6             	mov    %rax,%rsi
  803239:	bf 00 00 00 00       	mov    $0x0,%edi
  80323e:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  803245:	00 00 00 
  803248:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80324a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324e:	48 89 c6             	mov    %rax,%rsi
  803251:	bf 00 00 00 00       	mov    $0x0,%edi
  803256:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
err:
	return r;
  803262:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803265:	48 83 c4 38          	add    $0x38,%rsp
  803269:	5b                   	pop    %rbx
  80326a:	5d                   	pop    %rbp
  80326b:	c3                   	retq   

000000000080326c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80326c:	55                   	push   %rbp
  80326d:	48 89 e5             	mov    %rsp,%rbp
  803270:	53                   	push   %rbx
  803271:	48 83 ec 28          	sub    $0x28,%rsp
  803275:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803279:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80327d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803284:	00 00 00 
  803287:	48 8b 00             	mov    (%rax),%rax
  80328a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803290:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803293:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803297:	48 89 c7             	mov    %rax,%rdi
  80329a:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
  8032a6:	89 c3                	mov    %eax,%ebx
  8032a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ac:	48 89 c7             	mov    %rax,%rdi
  8032af:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  8032b6:	00 00 00 
  8032b9:	ff d0                	callq  *%rax
  8032bb:	39 c3                	cmp    %eax,%ebx
  8032bd:	0f 94 c0             	sete   %al
  8032c0:	0f b6 c0             	movzbl %al,%eax
  8032c3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8032c6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032cd:	00 00 00 
  8032d0:	48 8b 00             	mov    (%rax),%rax
  8032d3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032d9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032df:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032e2:	75 05                	jne    8032e9 <_pipeisclosed+0x7d>
			return ret;
  8032e4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032e7:	eb 4f                	jmp    803338 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8032e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ec:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032ef:	74 42                	je     803333 <_pipeisclosed+0xc7>
  8032f1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8032f5:	75 3c                	jne    803333 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032f7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032fe:	00 00 00 
  803301:	48 8b 00             	mov    (%rax),%rax
  803304:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80330a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80330d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803310:	89 c6                	mov    %eax,%esi
  803312:	48 bf 3b 42 80 00 00 	movabs $0x80423b,%rdi
  803319:	00 00 00 
  80331c:	b8 00 00 00 00       	mov    $0x0,%eax
  803321:	49 b8 c5 05 80 00 00 	movabs $0x8005c5,%r8
  803328:	00 00 00 
  80332b:	41 ff d0             	callq  *%r8
	}
  80332e:	e9 4a ff ff ff       	jmpq   80327d <_pipeisclosed+0x11>
  803333:	e9 45 ff ff ff       	jmpq   80327d <_pipeisclosed+0x11>
}
  803338:	48 83 c4 28          	add    $0x28,%rsp
  80333c:	5b                   	pop    %rbx
  80333d:	5d                   	pop    %rbp
  80333e:	c3                   	retq   

000000000080333f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80333f:	55                   	push   %rbp
  803340:	48 89 e5             	mov    %rsp,%rbp
  803343:	48 83 ec 30          	sub    $0x30,%rsp
  803347:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80334a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80334e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803351:	48 89 d6             	mov    %rdx,%rsi
  803354:	89 c7                	mov    %eax,%edi
  803356:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
  803362:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803369:	79 05                	jns    803370 <pipeisclosed+0x31>
		return r;
  80336b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336e:	eb 31                	jmp    8033a1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803374:	48 89 c7             	mov    %rax,%rdi
  803377:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
  803383:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80338f:	48 89 d6             	mov    %rdx,%rsi
  803392:	48 89 c7             	mov    %rax,%rdi
  803395:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 40          	sub    $0x40,%rsp
  8033ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8033b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033bb:	48 89 c7             	mov    %rax,%rdi
  8033be:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
  8033ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033d6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033dd:	00 
  8033de:	e9 92 00 00 00       	jmpq   803475 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8033e3:	eb 41                	jmp    803426 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033e5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033ea:	74 09                	je     8033f5 <devpipe_read+0x52>
				return i;
  8033ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f0:	e9 92 00 00 00       	jmpq   803487 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8033f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033fd:	48 89 d6             	mov    %rdx,%rsi
  803400:	48 89 c7             	mov    %rax,%rdi
  803403:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
  80340f:	85 c0                	test   %eax,%eax
  803411:	74 07                	je     80341a <devpipe_read+0x77>
				return 0;
  803413:	b8 00 00 00 00       	mov    $0x0,%eax
  803418:	eb 6d                	jmp    803487 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80341a:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342a:	8b 10                	mov    (%rax),%edx
  80342c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803430:	8b 40 04             	mov    0x4(%rax),%eax
  803433:	39 c2                	cmp    %eax,%edx
  803435:	74 ae                	je     8033e5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80343f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803447:	8b 00                	mov    (%rax),%eax
  803449:	99                   	cltd   
  80344a:	c1 ea 1b             	shr    $0x1b,%edx
  80344d:	01 d0                	add    %edx,%eax
  80344f:	83 e0 1f             	and    $0x1f,%eax
  803452:	29 d0                	sub    %edx,%eax
  803454:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803458:	48 98                	cltq   
  80345a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80345f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803465:	8b 00                	mov    (%rax),%eax
  803467:	8d 50 01             	lea    0x1(%rax),%edx
  80346a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803470:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803479:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80347d:	0f 82 60 ff ff ff    	jb     8033e3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803487:	c9                   	leaveq 
  803488:	c3                   	retq   

0000000000803489 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
  80348d:	48 83 ec 40          	sub    $0x40,%rsp
  803491:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803495:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803499:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80349d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034a1:	48 89 c7             	mov    %rax,%rdi
  8034a4:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
  8034b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034bc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034c3:	00 
  8034c4:	e9 8e 00 00 00       	jmpq   803557 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034c9:	eb 31                	jmp    8034fc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8034cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034d3:	48 89 d6             	mov    %rdx,%rsi
  8034d6:	48 89 c7             	mov    %rax,%rdi
  8034d9:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
  8034e5:	85 c0                	test   %eax,%eax
  8034e7:	74 07                	je     8034f0 <devpipe_write+0x67>
				return 0;
  8034e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ee:	eb 79                	jmp    803569 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8034f0:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  8034f7:	00 00 00 
  8034fa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803500:	8b 40 04             	mov    0x4(%rax),%eax
  803503:	48 63 d0             	movslq %eax,%rdx
  803506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350a:	8b 00                	mov    (%rax),%eax
  80350c:	48 98                	cltq   
  80350e:	48 83 c0 20          	add    $0x20,%rax
  803512:	48 39 c2             	cmp    %rax,%rdx
  803515:	73 b4                	jae    8034cb <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351b:	8b 40 04             	mov    0x4(%rax),%eax
  80351e:	99                   	cltd   
  80351f:	c1 ea 1b             	shr    $0x1b,%edx
  803522:	01 d0                	add    %edx,%eax
  803524:	83 e0 1f             	and    $0x1f,%eax
  803527:	29 d0                	sub    %edx,%eax
  803529:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80352d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803531:	48 01 ca             	add    %rcx,%rdx
  803534:	0f b6 0a             	movzbl (%rdx),%ecx
  803537:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80353b:	48 98                	cltq   
  80353d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803545:	8b 40 04             	mov    0x4(%rax),%eax
  803548:	8d 50 01             	lea    0x1(%rax),%edx
  80354b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803552:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80355f:	0f 82 64 ff ff ff    	jb     8034c9 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803569:	c9                   	leaveq 
  80356a:	c3                   	retq   

000000000080356b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80356b:	55                   	push   %rbp
  80356c:	48 89 e5             	mov    %rsp,%rbp
  80356f:	48 83 ec 20          	sub    $0x20,%rsp
  803573:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803577:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80357b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357f:	48 89 c7             	mov    %rax,%rdi
  803582:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
  80358e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803592:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803596:	48 be 4e 42 80 00 00 	movabs $0x80424e,%rsi
  80359d:	00 00 00 
  8035a0:	48 89 c7             	mov    %rax,%rdi
  8035a3:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8035af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b3:	8b 50 04             	mov    0x4(%rax),%edx
  8035b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ba:	8b 00                	mov    (%rax),%eax
  8035bc:	29 c2                	sub    %eax,%edx
  8035be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8035c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035cc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8035d3:	00 00 00 
	stat->st_dev = &devpipe;
  8035d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035da:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8035e1:	00 00 00 
  8035e4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8035eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035f0:	c9                   	leaveq 
  8035f1:	c3                   	retq   

00000000008035f2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8035f2:	55                   	push   %rbp
  8035f3:	48 89 e5             	mov    %rsp,%rbp
  8035f6:	48 83 ec 10          	sub    $0x10,%rsp
  8035fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803602:	48 89 c6             	mov    %rax,%rsi
  803605:	bf 00 00 00 00       	mov    $0x0,%edi
  80360a:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  803611:	00 00 00 
  803614:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361a:	48 89 c7             	mov    %rax,%rdi
  80361d:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
  803629:	48 89 c6             	mov    %rax,%rsi
  80362c:	bf 00 00 00 00       	mov    $0x0,%edi
  803631:	48 b8 67 1b 80 00 00 	movabs $0x801b67,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
}
  80363d:	c9                   	leaveq 
  80363e:	c3                   	retq   

000000000080363f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80363f:	55                   	push   %rbp
  803640:	48 89 e5             	mov    %rsp,%rbp
  803643:	48 83 ec 20          	sub    $0x20,%rsp
  803647:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80364a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80364d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803650:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803654:	be 01 00 00 00       	mov    $0x1,%esi
  803659:	48 89 c7             	mov    %rax,%rdi
  80365c:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
}
  803668:	c9                   	leaveq 
  803669:	c3                   	retq   

000000000080366a <getchar>:

int
getchar(void)
{
  80366a:	55                   	push   %rbp
  80366b:	48 89 e5             	mov    %rsp,%rbp
  80366e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803672:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803676:	ba 01 00 00 00       	mov    $0x1,%edx
  80367b:	48 89 c6             	mov    %rax,%rsi
  80367e:	bf 00 00 00 00       	mov    $0x0,%edi
  803683:	48 b8 41 22 80 00 00 	movabs $0x802241,%rax
  80368a:	00 00 00 
  80368d:	ff d0                	callq  *%rax
  80368f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803692:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803696:	79 05                	jns    80369d <getchar+0x33>
		return r;
  803698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369b:	eb 14                	jmp    8036b1 <getchar+0x47>
	if (r < 1)
  80369d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a1:	7f 07                	jg     8036aa <getchar+0x40>
		return -E_EOF;
  8036a3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8036a8:	eb 07                	jmp    8036b1 <getchar+0x47>
	return c;
  8036aa:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8036ae:	0f b6 c0             	movzbl %al,%eax
}
  8036b1:	c9                   	leaveq 
  8036b2:	c3                   	retq   

00000000008036b3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 20          	sub    $0x20,%rsp
  8036bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c5:	48 89 d6             	mov    %rdx,%rsi
  8036c8:	89 c7                	mov    %eax,%edi
  8036ca:	48 b8 0f 1e 80 00 00 	movabs $0x801e0f,%rax
  8036d1:	00 00 00 
  8036d4:	ff d0                	callq  *%rax
  8036d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036dd:	79 05                	jns    8036e4 <iscons+0x31>
		return r;
  8036df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e2:	eb 1a                	jmp    8036fe <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e8:	8b 10                	mov    (%rax),%edx
  8036ea:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8036f1:	00 00 00 
  8036f4:	8b 00                	mov    (%rax),%eax
  8036f6:	39 c2                	cmp    %eax,%edx
  8036f8:	0f 94 c0             	sete   %al
  8036fb:	0f b6 c0             	movzbl %al,%eax
}
  8036fe:	c9                   	leaveq 
  8036ff:	c3                   	retq   

0000000000803700 <opencons>:

int
opencons(void)
{
  803700:	55                   	push   %rbp
  803701:	48 89 e5             	mov    %rsp,%rbp
  803704:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803708:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80370c:	48 89 c7             	mov    %rax,%rdi
  80370f:	48 b8 77 1d 80 00 00 	movabs $0x801d77,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
  80371b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803722:	79 05                	jns    803729 <opencons+0x29>
		return r;
  803724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803727:	eb 5b                	jmp    803784 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372d:	ba 07 04 00 00       	mov    $0x407,%edx
  803732:	48 89 c6             	mov    %rax,%rsi
  803735:	bf 00 00 00 00       	mov    $0x0,%edi
  80373a:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803749:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374d:	79 05                	jns    803754 <opencons+0x54>
		return r;
  80374f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803752:	eb 30                	jmp    803784 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803758:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80375f:	00 00 00 
  803762:	8b 12                	mov    (%rdx),%edx
  803764:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80376a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803771:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803775:	48 89 c7             	mov    %rax,%rdi
  803778:	48 b8 29 1d 80 00 00 	movabs $0x801d29,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
}
  803784:	c9                   	leaveq 
  803785:	c3                   	retq   

0000000000803786 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803786:	55                   	push   %rbp
  803787:	48 89 e5             	mov    %rsp,%rbp
  80378a:	48 83 ec 30          	sub    $0x30,%rsp
  80378e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803792:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803796:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80379a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80379f:	75 07                	jne    8037a8 <devcons_read+0x22>
		return 0;
  8037a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a6:	eb 4b                	jmp    8037f3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8037a8:	eb 0c                	jmp    8037b6 <devcons_read+0x30>
		sys_yield();
  8037aa:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  8037b1:	00 00 00 
  8037b4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8037b6:	48 b8 be 19 80 00 00 	movabs $0x8019be,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
  8037c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c9:	74 df                	je     8037aa <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8037cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cf:	79 05                	jns    8037d6 <devcons_read+0x50>
		return c;
  8037d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d4:	eb 1d                	jmp    8037f3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037da:	75 07                	jne    8037e3 <devcons_read+0x5d>
		return 0;
  8037dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e1:	eb 10                	jmp    8037f3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e6:	89 c2                	mov    %eax,%edx
  8037e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ec:	88 10                	mov    %dl,(%rax)
	return 1;
  8037ee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037f3:	c9                   	leaveq 
  8037f4:	c3                   	retq   

00000000008037f5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037f5:	55                   	push   %rbp
  8037f6:	48 89 e5             	mov    %rsp,%rbp
  8037f9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803800:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803807:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80380e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80381c:	eb 76                	jmp    803894 <devcons_write+0x9f>
		m = n - tot;
  80381e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803825:	89 c2                	mov    %eax,%edx
  803827:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382a:	29 c2                	sub    %eax,%edx
  80382c:	89 d0                	mov    %edx,%eax
  80382e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803831:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803834:	83 f8 7f             	cmp    $0x7f,%eax
  803837:	76 07                	jbe    803840 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803839:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803840:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803843:	48 63 d0             	movslq %eax,%rdx
  803846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803849:	48 63 c8             	movslq %eax,%rcx
  80384c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803853:	48 01 c1             	add    %rax,%rcx
  803856:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80385d:	48 89 ce             	mov    %rcx,%rsi
  803860:	48 89 c7             	mov    %rax,%rdi
  803863:	48 b8 b1 14 80 00 00 	movabs $0x8014b1,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80386f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803872:	48 63 d0             	movslq %eax,%rdx
  803875:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80387c:	48 89 d6             	mov    %rdx,%rsi
  80387f:	48 89 c7             	mov    %rax,%rdi
  803882:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803889:	00 00 00 
  80388c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80388e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803891:	01 45 fc             	add    %eax,-0x4(%rbp)
  803894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803897:	48 98                	cltq   
  803899:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8038a0:	0f 82 78 ff ff ff    	jb     80381e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8038a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038a9:	c9                   	leaveq 
  8038aa:	c3                   	retq   

00000000008038ab <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8038ab:	55                   	push   %rbp
  8038ac:	48 89 e5             	mov    %rsp,%rbp
  8038af:	48 83 ec 08          	sub    $0x8,%rsp
  8038b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8038b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038bc:	c9                   	leaveq 
  8038bd:	c3                   	retq   

00000000008038be <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038be:	55                   	push   %rbp
  8038bf:	48 89 e5             	mov    %rsp,%rbp
  8038c2:	48 83 ec 10          	sub    $0x10,%rsp
  8038c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d2:	48 be 5a 42 80 00 00 	movabs $0x80425a,%rsi
  8038d9:	00 00 00 
  8038dc:	48 89 c7             	mov    %rax,%rdi
  8038df:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
	return 0;
  8038eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038f0:	c9                   	leaveq 
  8038f1:	c3                   	retq   

00000000008038f2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8038f2:	55                   	push   %rbp
  8038f3:	48 89 e5             	mov    %rsp,%rbp
  8038f6:	48 83 ec 30          	sub    $0x30,%rsp
  8038fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803902:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803906:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80390b:	75 0e                	jne    80391b <ipc_recv+0x29>
        pg = (void *)UTOP;
  80390d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803914:	00 00 00 
  803917:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  80391b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391f:	48 89 c7             	mov    %rax,%rdi
  803922:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803931:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803935:	79 27                	jns    80395e <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803937:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80393c:	74 0a                	je     803948 <ipc_recv+0x56>
            *from_env_store = 0;
  80393e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803942:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803948:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80394d:	74 0a                	je     803959 <ipc_recv+0x67>
            *perm_store = 0;
  80394f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803953:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803959:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395c:	eb 53                	jmp    8039b1 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  80395e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803963:	74 19                	je     80397e <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803965:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80396c:	00 00 00 
  80396f:	48 8b 00             	mov    (%rax),%rax
  803972:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80397c:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80397e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803983:	74 19                	je     80399e <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803985:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80398c:	00 00 00 
  80398f:	48 8b 00             	mov    (%rax),%rax
  803992:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803998:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399c:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80399e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8039a5:	00 00 00 
  8039a8:	48 8b 00             	mov    (%rax),%rax
  8039ab:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8039b1:	c9                   	leaveq 
  8039b2:	c3                   	retq   

00000000008039b3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8039b3:	55                   	push   %rbp
  8039b4:	48 89 e5             	mov    %rsp,%rbp
  8039b7:	48 83 ec 30          	sub    $0x30,%rsp
  8039bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039be:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039c1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8039c5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8039c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039cd:	75 0e                	jne    8039dd <ipc_send+0x2a>
        pg = (void *)UTOP;
  8039cf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8039d6:	00 00 00 
  8039d9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8039dd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8039e0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8039e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8039e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ea:	89 c7                	mov    %eax,%edi
  8039ec:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
  8039f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8039fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ff:	79 36                	jns    803a37 <ipc_send+0x84>
  803a01:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a05:	74 30                	je     803a37 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0a:	89 c1                	mov    %eax,%ecx
  803a0c:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  803a13:	00 00 00 
  803a16:	be 49 00 00 00       	mov    $0x49,%esi
  803a1b:	48 bf 6e 42 80 00 00 	movabs $0x80426e,%rdi
  803a22:	00 00 00 
  803a25:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2a:	49 b8 8c 03 80 00 00 	movabs $0x80038c,%r8
  803a31:	00 00 00 
  803a34:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803a37:	48 b8 7e 1a 80 00 00 	movabs $0x801a7e,%rax
  803a3e:	00 00 00 
  803a41:	ff d0                	callq  *%rax
    } while(r != 0);
  803a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a47:	75 94                	jne    8039dd <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803a49:	c9                   	leaveq 
  803a4a:	c3                   	retq   

0000000000803a4b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a4b:	55                   	push   %rbp
  803a4c:	48 89 e5             	mov    %rsp,%rbp
  803a4f:	48 83 ec 14          	sub    $0x14,%rsp
  803a53:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803a56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a5d:	eb 5e                	jmp    803abd <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803a5f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a66:	00 00 00 
  803a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6c:	48 63 d0             	movslq %eax,%rdx
  803a6f:	48 89 d0             	mov    %rdx,%rax
  803a72:	48 c1 e0 03          	shl    $0x3,%rax
  803a76:	48 01 d0             	add    %rdx,%rax
  803a79:	48 c1 e0 05          	shl    $0x5,%rax
  803a7d:	48 01 c8             	add    %rcx,%rax
  803a80:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803a86:	8b 00                	mov    (%rax),%eax
  803a88:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a8b:	75 2c                	jne    803ab9 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803a8d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803a94:	00 00 00 
  803a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9a:	48 63 d0             	movslq %eax,%rdx
  803a9d:	48 89 d0             	mov    %rdx,%rax
  803aa0:	48 c1 e0 03          	shl    $0x3,%rax
  803aa4:	48 01 d0             	add    %rdx,%rax
  803aa7:	48 c1 e0 05          	shl    $0x5,%rax
  803aab:	48 01 c8             	add    %rcx,%rax
  803aae:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ab4:	8b 40 08             	mov    0x8(%rax),%eax
  803ab7:	eb 12                	jmp    803acb <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ab9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803abd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ac4:	7e 99                	jle    803a5f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803acb:	c9                   	leaveq 
  803acc:	c3                   	retq   

0000000000803acd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803acd:	55                   	push   %rbp
  803ace:	48 89 e5             	mov    %rsp,%rbp
  803ad1:	48 83 ec 18          	sub    $0x18,%rsp
  803ad5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ad9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803add:	48 c1 e8 15          	shr    $0x15,%rax
  803ae1:	48 89 c2             	mov    %rax,%rdx
  803ae4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803aeb:	01 00 00 
  803aee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803af2:	83 e0 01             	and    $0x1,%eax
  803af5:	48 85 c0             	test   %rax,%rax
  803af8:	75 07                	jne    803b01 <pageref+0x34>
		return 0;
  803afa:	b8 00 00 00 00       	mov    $0x0,%eax
  803aff:	eb 53                	jmp    803b54 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b05:	48 c1 e8 0c          	shr    $0xc,%rax
  803b09:	48 89 c2             	mov    %rax,%rdx
  803b0c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b13:	01 00 00 
  803b16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b22:	83 e0 01             	and    $0x1,%eax
  803b25:	48 85 c0             	test   %rax,%rax
  803b28:	75 07                	jne    803b31 <pageref+0x64>
		return 0;
  803b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2f:	eb 23                	jmp    803b54 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803b31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b35:	48 c1 e8 0c          	shr    $0xc,%rax
  803b39:	48 89 c2             	mov    %rax,%rdx
  803b3c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803b43:	00 00 00 
  803b46:	48 c1 e2 04          	shl    $0x4,%rdx
  803b4a:	48 01 d0             	add    %rdx,%rax
  803b4d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803b51:	0f b7 c0             	movzwl %ax,%eax
}
  803b54:	c9                   	leaveq 
  803b55:	c3                   	retq   
