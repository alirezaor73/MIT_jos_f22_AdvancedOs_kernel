
obj/user/icode:     file format elf64-x86-64


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
  80003c:	e8 21 02 00 00       	callq  800262 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#define MOTD "/motd"

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800063:	00 00 00 
  800066:	48 bb 60 42 80 00 00 	movabs $0x804260,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf 66 42 80 00 00 	movabs $0x804266,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf 75 42 80 00 00 	movabs $0x804275,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 88 42 80 00 00 	movabs $0x804288,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 8e 42 80 00 00 	movabs $0x80428e,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf a4 42 80 00 00 	movabs $0x8042a4,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf b1 42 80 00 00 	movabs $0x8042b1,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x111>
		cprintf("Writing MOTD\n");
  80011a:	48 bf c4 42 80 00 00 	movabs $0x8042c4,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800135:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800138:	48 63 d0             	movslq %eax,%rdx
  80013b:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800142:	48 89 d6             	mov    %rdx,%rsi
  800145:	48 89 c7             	mov    %rax,%rdi
  800148:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800154:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  80015b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80015e:	ba 00 02 00 00       	mov    $0x200,%edx
  800163:	48 89 ce             	mov    %rcx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 cb 21 80 00 00 	movabs $0x8021cb,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800177:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd7>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf d2 42 80 00 00 	movabs $0x8042d2,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 ff 42 80 00 00 	movabs $0x8042ff,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba 08 43 80 00 00 	movabs $0x804308,%rdx
  8001db:	00 00 00 
  8001de:	48 be 11 43 80 00 00 	movabs $0x804311,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf 16 43 80 00 00 	movabs $0x804316,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 57 30 80 00 00 	movabs $0x803057,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 21 43 80 00 00 	movabs $0x804321,%rdx
  800219:	00 00 00 
  80021c:	be 1e 00 00 00       	mov    $0x1e,%esi
  800221:	48 bf a4 42 80 00 00 	movabs $0x8042a4,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf 3d 43 80 00 00 	movabs $0x80433d,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
}
  800258:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  80025f:	5b                   	pop    %rbx
  800260:	5d                   	pop    %rbp
  800261:	c3                   	retq   

0000000000800262 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800262:	55                   	push   %rbp
  800263:	48 89 e5             	mov    %rsp,%rbp
  800266:	48 83 ec 20          	sub    $0x20,%rsp
  80026a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80026d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800271:	48 b8 ca 19 80 00 00 	movabs $0x8019ca,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
  80027d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800283:	25 ff 03 00 00       	and    $0x3ff,%eax
  800288:	48 63 d0             	movslq %eax,%rdx
  80028b:	48 89 d0             	mov    %rdx,%rax
  80028e:	48 c1 e0 03          	shl    $0x3,%rax
  800292:	48 01 d0             	add    %rdx,%rax
  800295:	48 c1 e0 05          	shl    $0x5,%rax
  800299:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002a0:	00 00 00 
  8002a3:	48 01 c2             	add    %rax,%rdx
  8002a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002ad:	00 00 00 
  8002b0:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8002b7:	7e 14                	jle    8002cd <libmain+0x6b>
		binaryname = argv[0];
  8002b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002bd:	48 8b 10             	mov    (%rax),%rdx
  8002c0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002c7:	00 00 00 
  8002ca:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002d4:	48 89 d6             	mov    %rdx,%rsi
  8002d7:	89 c7                	mov    %eax,%edi
  8002d9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002e5:	48 b8 f3 02 80 00 00 	movabs $0x8002f3,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
}
  8002f1:	c9                   	leaveq 
  8002f2:	c3                   	retq   

00000000008002f3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002f3:	55                   	push   %rbp
  8002f4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002f7:	48 b8 f4 1f 80 00 00 	movabs $0x801ff4,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800303:	bf 00 00 00 00       	mov    $0x0,%edi
  800308:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  80030f:	00 00 00 
  800312:	ff d0                	callq  *%rax
}
  800314:	5d                   	pop    %rbp
  800315:	c3                   	retq   

0000000000800316 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800316:	55                   	push   %rbp
  800317:	48 89 e5             	mov    %rsp,%rbp
  80031a:	53                   	push   %rbx
  80031b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800322:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800329:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80032f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800336:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80033d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800344:	84 c0                	test   %al,%al
  800346:	74 23                	je     80036b <_panic+0x55>
  800348:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80034f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800353:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800357:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80035b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80035f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800363:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800367:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80036b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800372:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800379:	00 00 00 
  80037c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800383:	00 00 00 
  800386:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800391:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800398:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003a6:	00 00 00 
  8003a9:	48 8b 18             	mov    (%rax),%rbx
  8003ac:	48 b8 ca 19 80 00 00 	movabs $0x8019ca,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
  8003b8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003be:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003c5:	41 89 c8             	mov    %ecx,%r8d
  8003c8:	48 89 d1             	mov    %rdx,%rcx
  8003cb:	48 89 da             	mov    %rbx,%rdx
  8003ce:	89 c6                	mov    %eax,%esi
  8003d0:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  8003d7:	00 00 00 
  8003da:	b8 00 00 00 00       	mov    $0x0,%eax
  8003df:	49 b9 4f 05 80 00 00 	movabs $0x80054f,%r9
  8003e6:	00 00 00 
  8003e9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ec:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003f3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003fa:	48 89 d6             	mov    %rdx,%rsi
  8003fd:	48 89 c7             	mov    %rax,%rdi
  800400:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
	cprintf("\n");
  80040c:	48 bf 7b 43 80 00 00 	movabs $0x80437b,%rdi
  800413:	00 00 00 
  800416:	b8 00 00 00 00       	mov    $0x0,%eax
  80041b:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  800422:	00 00 00 
  800425:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800427:	cc                   	int3   
  800428:	eb fd                	jmp    800427 <_panic+0x111>

000000000080042a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80042a:	55                   	push   %rbp
  80042b:	48 89 e5             	mov    %rsp,%rbp
  80042e:	48 83 ec 10          	sub    $0x10,%rsp
  800432:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800435:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043d:	8b 00                	mov    (%rax),%eax
  80043f:	8d 48 01             	lea    0x1(%rax),%ecx
  800442:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800446:	89 0a                	mov    %ecx,(%rdx)
  800448:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80044b:	89 d1                	mov    %edx,%ecx
  80044d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800451:	48 98                	cltq   
  800453:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045b:	8b 00                	mov    (%rax),%eax
  80045d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800462:	75 2c                	jne    800490 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800468:	8b 00                	mov    (%rax),%eax
  80046a:	48 98                	cltq   
  80046c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800470:	48 83 c2 08          	add    $0x8,%rdx
  800474:	48 89 c6             	mov    %rax,%rsi
  800477:	48 89 d7             	mov    %rdx,%rdi
  80047a:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
        b->idx = 0;
  800486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800494:	8b 40 04             	mov    0x4(%rax),%eax
  800497:	8d 50 01             	lea    0x1(%rax),%edx
  80049a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049e:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004ae:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004b5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004bc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004c3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004ca:	48 8b 0a             	mov    (%rdx),%rcx
  8004cd:	48 89 08             	mov    %rcx,(%rax)
  8004d0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004d4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004d8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004dc:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004e0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004e7:	00 00 00 
    b.cnt = 0;
  8004ea:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004f1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004f4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004fb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800502:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800509:	48 89 c6             	mov    %rax,%rsi
  80050c:	48 bf 2a 04 80 00 00 	movabs $0x80042a,%rdi
  800513:	00 00 00 
  800516:	48 b8 02 09 80 00 00 	movabs $0x800902,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800522:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800528:	48 98                	cltq   
  80052a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800531:	48 83 c2 08          	add    $0x8,%rdx
  800535:	48 89 c6             	mov    %rax,%rsi
  800538:	48 89 d7             	mov    %rdx,%rdi
  80053b:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  800542:	00 00 00 
  800545:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800547:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80054d:	c9                   	leaveq 
  80054e:	c3                   	retq   

000000000080054f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80054f:	55                   	push   %rbp
  800550:	48 89 e5             	mov    %rsp,%rbp
  800553:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80055a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800561:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800568:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80056f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800576:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80057d:	84 c0                	test   %al,%al
  80057f:	74 20                	je     8005a1 <cprintf+0x52>
  800581:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800585:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800589:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80058d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800591:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800595:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800599:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80059d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005a1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005a8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005af:	00 00 00 
  8005b2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005b9:	00 00 00 
  8005bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005c0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005c7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005ce:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005d5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005dc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005e3:	48 8b 0a             	mov    (%rdx),%rcx
  8005e6:	48 89 08             	mov    %rcx,(%rax)
  8005e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005f9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800600:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800607:	48 89 d6             	mov    %rdx,%rsi
  80060a:	48 89 c7             	mov    %rax,%rdi
  80060d:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800614:	00 00 00 
  800617:	ff d0                	callq  *%rax
  800619:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80061f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800625:	c9                   	leaveq 
  800626:	c3                   	retq   

0000000000800627 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	53                   	push   %rbx
  80062c:	48 83 ec 38          	sub    $0x38,%rsp
  800630:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800634:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800638:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80063c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80063f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800643:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800647:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80064a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80064e:	77 3b                	ja     80068b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800653:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800657:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80065a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80065e:	ba 00 00 00 00       	mov    $0x0,%edx
  800663:	48 f7 f3             	div    %rbx
  800666:	48 89 c2             	mov    %rax,%rdx
  800669:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80066c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80066f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	41 89 f9             	mov    %edi,%r9d
  80067a:	48 89 c7             	mov    %rax,%rdi
  80067d:	48 b8 27 06 80 00 00 	movabs $0x800627,%rax
  800684:	00 00 00 
  800687:	ff d0                	callq  *%rax
  800689:	eb 1e                	jmp    8006a9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068b:	eb 12                	jmp    80069f <printnum+0x78>
			putch(padc, putdat);
  80068d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800691:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	48 89 ce             	mov    %rcx,%rsi
  80069b:	89 d7                	mov    %edx,%edi
  80069d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006a7:	7f e4                	jg     80068d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b5:	48 f7 f1             	div    %rcx
  8006b8:	48 89 d0             	mov    %rdx,%rax
  8006bb:	48 ba 70 45 80 00 00 	movabs $0x804570,%rdx
  8006c2:	00 00 00 
  8006c5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006c9:	0f be d0             	movsbl %al,%edx
  8006cc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	48 89 ce             	mov    %rcx,%rsi
  8006d7:	89 d7                	mov    %edx,%edi
  8006d9:	ff d0                	callq  *%rax
}
  8006db:	48 83 c4 38          	add    $0x38,%rsp
  8006df:	5b                   	pop    %rbx
  8006e0:	5d                   	pop    %rbp
  8006e1:	c3                   	retq   

00000000008006e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e2:	55                   	push   %rbp
  8006e3:	48 89 e5             	mov    %rsp,%rbp
  8006e6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ee:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8006f1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f5:	7e 52                	jle    800749 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	83 f8 30             	cmp    $0x30,%eax
  800700:	73 24                	jae    800726 <getuint+0x44>
  800702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800706:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	8b 00                	mov    (%rax),%eax
  800710:	89 c0                	mov    %eax,%eax
  800712:	48 01 d0             	add    %rdx,%rax
  800715:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800719:	8b 12                	mov    (%rdx),%edx
  80071b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800722:	89 0a                	mov    %ecx,(%rdx)
  800724:	eb 17                	jmp    80073d <getuint+0x5b>
  800726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072e:	48 89 d0             	mov    %rdx,%rax
  800731:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800739:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073d:	48 8b 00             	mov    (%rax),%rax
  800740:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800744:	e9 a3 00 00 00       	jmpq   8007ec <getuint+0x10a>
	else if (lflag)
  800749:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80074d:	74 4f                	je     80079e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	8b 00                	mov    (%rax),%eax
  800755:	83 f8 30             	cmp    $0x30,%eax
  800758:	73 24                	jae    80077e <getuint+0x9c>
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800766:	8b 00                	mov    (%rax),%eax
  800768:	89 c0                	mov    %eax,%eax
  80076a:	48 01 d0             	add    %rdx,%rax
  80076d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800771:	8b 12                	mov    (%rdx),%edx
  800773:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077a:	89 0a                	mov    %ecx,(%rdx)
  80077c:	eb 17                	jmp    800795 <getuint+0xb3>
  80077e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800782:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800786:	48 89 d0             	mov    %rdx,%rax
  800789:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800791:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800795:	48 8b 00             	mov    (%rax),%rax
  800798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079c:	eb 4e                	jmp    8007ec <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	8b 00                	mov    (%rax),%eax
  8007a4:	83 f8 30             	cmp    $0x30,%eax
  8007a7:	73 24                	jae    8007cd <getuint+0xeb>
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	8b 00                	mov    (%rax),%eax
  8007b7:	89 c0                	mov    %eax,%eax
  8007b9:	48 01 d0             	add    %rdx,%rax
  8007bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c0:	8b 12                	mov    (%rdx),%edx
  8007c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c9:	89 0a                	mov    %ecx,(%rdx)
  8007cb:	eb 17                	jmp    8007e4 <getuint+0x102>
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d5:	48 89 d0             	mov    %rdx,%rax
  8007d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e4:	8b 00                	mov    (%rax),%eax
  8007e6:	89 c0                	mov    %eax,%eax
  8007e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007f0:	c9                   	leaveq 
  8007f1:	c3                   	retq   

00000000008007f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007f2:	55                   	push   %rbp
  8007f3:	48 89 e5             	mov    %rsp,%rbp
  8007f6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007fe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800801:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800805:	7e 52                	jle    800859 <getint+0x67>
		x=va_arg(*ap, long long);
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	8b 00                	mov    (%rax),%eax
  80080d:	83 f8 30             	cmp    $0x30,%eax
  800810:	73 24                	jae    800836 <getint+0x44>
  800812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800816:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	8b 00                	mov    (%rax),%eax
  800820:	89 c0                	mov    %eax,%eax
  800822:	48 01 d0             	add    %rdx,%rax
  800825:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800829:	8b 12                	mov    (%rdx),%edx
  80082b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800832:	89 0a                	mov    %ecx,(%rdx)
  800834:	eb 17                	jmp    80084d <getint+0x5b>
  800836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083e:	48 89 d0             	mov    %rdx,%rax
  800841:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800845:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800849:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084d:	48 8b 00             	mov    (%rax),%rax
  800850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800854:	e9 a3 00 00 00       	jmpq   8008fc <getint+0x10a>
	else if (lflag)
  800859:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80085d:	74 4f                	je     8008ae <getint+0xbc>
		x=va_arg(*ap, long);
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	83 f8 30             	cmp    $0x30,%eax
  800868:	73 24                	jae    80088e <getint+0x9c>
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800876:	8b 00                	mov    (%rax),%eax
  800878:	89 c0                	mov    %eax,%eax
  80087a:	48 01 d0             	add    %rdx,%rax
  80087d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800881:	8b 12                	mov    (%rdx),%edx
  800883:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800886:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088a:	89 0a                	mov    %ecx,(%rdx)
  80088c:	eb 17                	jmp    8008a5 <getint+0xb3>
  80088e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800892:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800896:	48 89 d0             	mov    %rdx,%rax
  800899:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80089d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a5:	48 8b 00             	mov    (%rax),%rax
  8008a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ac:	eb 4e                	jmp    8008fc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	83 f8 30             	cmp    $0x30,%eax
  8008b7:	73 24                	jae    8008dd <getint+0xeb>
  8008b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c5:	8b 00                	mov    (%rax),%eax
  8008c7:	89 c0                	mov    %eax,%eax
  8008c9:	48 01 d0             	add    %rdx,%rax
  8008cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d0:	8b 12                	mov    (%rdx),%edx
  8008d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d9:	89 0a                	mov    %ecx,(%rdx)
  8008db:	eb 17                	jmp    8008f4 <getint+0x102>
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e5:	48 89 d0             	mov    %rdx,%rax
  8008e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f4:	8b 00                	mov    (%rax),%eax
  8008f6:	48 98                	cltq   
  8008f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800900:	c9                   	leaveq 
  800901:	c3                   	retq   

0000000000800902 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800902:	55                   	push   %rbp
  800903:	48 89 e5             	mov    %rsp,%rbp
  800906:	41 54                	push   %r12
  800908:	53                   	push   %rbx
  800909:	48 83 ec 60          	sub    $0x60,%rsp
  80090d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800911:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800915:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800919:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80091d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800921:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800925:	48 8b 0a             	mov    (%rdx),%rcx
  800928:	48 89 08             	mov    %rcx,(%rax)
  80092b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80092f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800933:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800937:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093b:	eb 17                	jmp    800954 <vprintfmt+0x52>
			if (ch == '\0')
  80093d:	85 db                	test   %ebx,%ebx
  80093f:	0f 84 df 04 00 00    	je     800e24 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800945:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800949:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094d:	48 89 d6             	mov    %rdx,%rsi
  800950:	89 df                	mov    %ebx,%edi
  800952:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800954:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800958:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800960:	0f b6 00             	movzbl (%rax),%eax
  800963:	0f b6 d8             	movzbl %al,%ebx
  800966:	83 fb 25             	cmp    $0x25,%ebx
  800969:	75 d2                	jne    80093d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80096b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80096f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800976:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80097d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800984:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800993:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800997:	0f b6 00             	movzbl (%rax),%eax
  80099a:	0f b6 d8             	movzbl %al,%ebx
  80099d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009a0:	83 f8 55             	cmp    $0x55,%eax
  8009a3:	0f 87 47 04 00 00    	ja     800df0 <vprintfmt+0x4ee>
  8009a9:	89 c0                	mov    %eax,%eax
  8009ab:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009b2:	00 
  8009b3:	48 b8 98 45 80 00 00 	movabs $0x804598,%rax
  8009ba:	00 00 00 
  8009bd:	48 01 d0             	add    %rdx,%rax
  8009c0:	48 8b 00             	mov    (%rax),%rax
  8009c3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009c5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009c9:	eb c0                	jmp    80098b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cb:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009cf:	eb ba                	jmp    80098b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009d8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	c1 e0 02             	shl    $0x2,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d8                	add    %ebx,%eax
  8009e6:	83 e8 30             	sub    $0x30,%eax
  8009e9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009ec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f0:	0f b6 00             	movzbl (%rax),%eax
  8009f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f9:	7e 0c                	jle    800a07 <vprintfmt+0x105>
  8009fb:	83 fb 39             	cmp    $0x39,%ebx
  8009fe:	7f 07                	jg     800a07 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a00:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a05:	eb d1                	jmp    8009d8 <vprintfmt+0xd6>
			goto process_precision;
  800a07:	eb 58                	jmp    800a61 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0c:	83 f8 30             	cmp    $0x30,%eax
  800a0f:	73 17                	jae    800a28 <vprintfmt+0x126>
  800a11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	89 c0                	mov    %eax,%eax
  800a1a:	48 01 d0             	add    %rdx,%rax
  800a1d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a20:	83 c2 08             	add    $0x8,%edx
  800a23:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a26:	eb 0f                	jmp    800a37 <vprintfmt+0x135>
  800a28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2c:	48 89 d0             	mov    %rdx,%rax
  800a2f:	48 83 c2 08          	add    $0x8,%rdx
  800a33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a37:	8b 00                	mov    (%rax),%eax
  800a39:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a3c:	eb 23                	jmp    800a61 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a42:	79 0c                	jns    800a50 <vprintfmt+0x14e>
				width = 0;
  800a44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a4b:	e9 3b ff ff ff       	jmpq   80098b <vprintfmt+0x89>
  800a50:	e9 36 ff ff ff       	jmpq   80098b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a55:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a5c:	e9 2a ff ff ff       	jmpq   80098b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a65:	79 12                	jns    800a79 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a67:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a6a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a6d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a74:	e9 12 ff ff ff       	jmpq   80098b <vprintfmt+0x89>
  800a79:	e9 0d ff ff ff       	jmpq   80098b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a82:	e9 04 ff ff ff       	jmpq   80098b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8a:	83 f8 30             	cmp    $0x30,%eax
  800a8d:	73 17                	jae    800aa6 <vprintfmt+0x1a4>
  800a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a96:	89 c0                	mov    %eax,%eax
  800a98:	48 01 d0             	add    %rdx,%rax
  800a9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9e:	83 c2 08             	add    $0x8,%edx
  800aa1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa4:	eb 0f                	jmp    800ab5 <vprintfmt+0x1b3>
  800aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aaa:	48 89 d0             	mov    %rdx,%rax
  800aad:	48 83 c2 08          	add    $0x8,%rdx
  800ab1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab5:	8b 10                	mov    (%rax),%edx
  800ab7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800abb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abf:	48 89 ce             	mov    %rcx,%rsi
  800ac2:	89 d7                	mov    %edx,%edi
  800ac4:	ff d0                	callq  *%rax
			break;
  800ac6:	e9 53 03 00 00       	jmpq   800e1e <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800acb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ace:	83 f8 30             	cmp    $0x30,%eax
  800ad1:	73 17                	jae    800aea <vprintfmt+0x1e8>
  800ad3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ada:	89 c0                	mov    %eax,%eax
  800adc:	48 01 d0             	add    %rdx,%rax
  800adf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae2:	83 c2 08             	add    $0x8,%edx
  800ae5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae8:	eb 0f                	jmp    800af9 <vprintfmt+0x1f7>
  800aea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aee:	48 89 d0             	mov    %rdx,%rax
  800af1:	48 83 c2 08          	add    $0x8,%rdx
  800af5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800afb:	85 db                	test   %ebx,%ebx
  800afd:	79 02                	jns    800b01 <vprintfmt+0x1ff>
				err = -err;
  800aff:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b01:	83 fb 15             	cmp    $0x15,%ebx
  800b04:	7f 16                	jg     800b1c <vprintfmt+0x21a>
  800b06:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  800b0d:	00 00 00 
  800b10:	48 63 d3             	movslq %ebx,%rdx
  800b13:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b17:	4d 85 e4             	test   %r12,%r12
  800b1a:	75 2e                	jne    800b4a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b1c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b24:	89 d9                	mov    %ebx,%ecx
  800b26:	48 ba 81 45 80 00 00 	movabs $0x804581,%rdx
  800b2d:	00 00 00 
  800b30:	48 89 c7             	mov    %rax,%rdi
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
  800b38:	49 b8 2d 0e 80 00 00 	movabs $0x800e2d,%r8
  800b3f:	00 00 00 
  800b42:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b45:	e9 d4 02 00 00       	jmpq   800e1e <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	4c 89 e1             	mov    %r12,%rcx
  800b55:	48 ba 8a 45 80 00 00 	movabs $0x80458a,%rdx
  800b5c:	00 00 00 
  800b5f:	48 89 c7             	mov    %rax,%rdi
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	49 b8 2d 0e 80 00 00 	movabs $0x800e2d,%r8
  800b6e:	00 00 00 
  800b71:	41 ff d0             	callq  *%r8
			break;
  800b74:	e9 a5 02 00 00       	jmpq   800e1e <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7c:	83 f8 30             	cmp    $0x30,%eax
  800b7f:	73 17                	jae    800b98 <vprintfmt+0x296>
  800b81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b88:	89 c0                	mov    %eax,%eax
  800b8a:	48 01 d0             	add    %rdx,%rax
  800b8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b90:	83 c2 08             	add    $0x8,%edx
  800b93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b96:	eb 0f                	jmp    800ba7 <vprintfmt+0x2a5>
  800b98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9c:	48 89 d0             	mov    %rdx,%rax
  800b9f:	48 83 c2 08          	add    $0x8,%rdx
  800ba3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba7:	4c 8b 20             	mov    (%rax),%r12
  800baa:	4d 85 e4             	test   %r12,%r12
  800bad:	75 0a                	jne    800bb9 <vprintfmt+0x2b7>
				p = "(null)";
  800baf:	49 bc 8d 45 80 00 00 	movabs $0x80458d,%r12
  800bb6:	00 00 00 
			if (width > 0 && padc != '-')
  800bb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bbd:	7e 3f                	jle    800bfe <vprintfmt+0x2fc>
  800bbf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bc3:	74 39                	je     800bfe <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bc8:	48 98                	cltq   
  800bca:	48 89 c6             	mov    %rax,%rsi
  800bcd:	4c 89 e7             	mov    %r12,%rdi
  800bd0:	48 b8 d9 10 80 00 00 	movabs $0x8010d9,%rax
  800bd7:	00 00 00 
  800bda:	ff d0                	callq  *%rax
  800bdc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bdf:	eb 17                	jmp    800bf8 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800be1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800be5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bed:	48 89 ce             	mov    %rcx,%rsi
  800bf0:	89 d7                	mov    %edx,%edi
  800bf2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bfc:	7f e3                	jg     800be1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bfe:	eb 37                	jmp    800c37 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c00:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c04:	74 1e                	je     800c24 <vprintfmt+0x322>
  800c06:	83 fb 1f             	cmp    $0x1f,%ebx
  800c09:	7e 05                	jle    800c10 <vprintfmt+0x30e>
  800c0b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c0e:	7e 14                	jle    800c24 <vprintfmt+0x322>
					putch('?', putdat);
  800c10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c18:	48 89 d6             	mov    %rdx,%rsi
  800c1b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c20:	ff d0                	callq  *%rax
  800c22:	eb 0f                	jmp    800c33 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2c:	48 89 d6             	mov    %rdx,%rsi
  800c2f:	89 df                	mov    %ebx,%edi
  800c31:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c33:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c37:	4c 89 e0             	mov    %r12,%rax
  800c3a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c3e:	0f b6 00             	movzbl (%rax),%eax
  800c41:	0f be d8             	movsbl %al,%ebx
  800c44:	85 db                	test   %ebx,%ebx
  800c46:	74 10                	je     800c58 <vprintfmt+0x356>
  800c48:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c4c:	78 b2                	js     800c00 <vprintfmt+0x2fe>
  800c4e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c52:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c56:	79 a8                	jns    800c00 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c58:	eb 16                	jmp    800c70 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c62:	48 89 d6             	mov    %rdx,%rsi
  800c65:	bf 20 00 00 00       	mov    $0x20,%edi
  800c6a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c6c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c70:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c74:	7f e4                	jg     800c5a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c76:	e9 a3 01 00 00       	jmpq   800e1e <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c7b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c7f:	be 03 00 00 00       	mov    $0x3,%esi
  800c84:	48 89 c7             	mov    %rax,%rdi
  800c87:	48 b8 f2 07 80 00 00 	movabs $0x8007f2,%rax
  800c8e:	00 00 00 
  800c91:	ff d0                	callq  *%rax
  800c93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9b:	48 85 c0             	test   %rax,%rax
  800c9e:	79 1d                	jns    800cbd <vprintfmt+0x3bb>
				putch('-', putdat);
  800ca0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca8:	48 89 d6             	mov    %rdx,%rsi
  800cab:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cb0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb6:	48 f7 d8             	neg    %rax
  800cb9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cbd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc4:	e9 e8 00 00 00       	jmpq   800db1 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cc9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccd:	be 03 00 00 00       	mov    $0x3,%esi
  800cd2:	48 89 c7             	mov    %rax,%rdi
  800cd5:	48 b8 e2 06 80 00 00 	movabs $0x8006e2,%rax
  800cdc:	00 00 00 
  800cdf:	ff d0                	callq  *%rax
  800ce1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ce5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cec:	e9 c0 00 00 00       	jmpq   800db1 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cf1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf9:	48 89 d6             	mov    %rdx,%rsi
  800cfc:	bf 58 00 00 00       	mov    $0x58,%edi
  800d01:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0b:	48 89 d6             	mov    %rdx,%rsi
  800d0e:	bf 58 00 00 00       	mov    $0x58,%edi
  800d13:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1d:	48 89 d6             	mov    %rdx,%rsi
  800d20:	bf 58 00 00 00       	mov    $0x58,%edi
  800d25:	ff d0                	callq  *%rax
			break;
  800d27:	e9 f2 00 00 00       	jmpq   800e1e <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800d2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d34:	48 89 d6             	mov    %rdx,%rsi
  800d37:	bf 30 00 00 00       	mov    $0x30,%edi
  800d3c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d46:	48 89 d6             	mov    %rdx,%rsi
  800d49:	bf 78 00 00 00       	mov    $0x78,%edi
  800d4e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d53:	83 f8 30             	cmp    $0x30,%eax
  800d56:	73 17                	jae    800d6f <vprintfmt+0x46d>
  800d58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5f:	89 c0                	mov    %eax,%eax
  800d61:	48 01 d0             	add    %rdx,%rax
  800d64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d67:	83 c2 08             	add    $0x8,%edx
  800d6a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6d:	eb 0f                	jmp    800d7e <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800d6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d73:	48 89 d0             	mov    %rdx,%rax
  800d76:	48 83 c2 08          	add    $0x8,%rdx
  800d7a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d7e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d85:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d8c:	eb 23                	jmp    800db1 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d92:	be 03 00 00 00       	mov    $0x3,%esi
  800d97:	48 89 c7             	mov    %rax,%rdi
  800d9a:	48 b8 e2 06 80 00 00 	movabs $0x8006e2,%rax
  800da1:	00 00 00 
  800da4:	ff d0                	callq  *%rax
  800da6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800daa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800db1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800db6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800db9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc8:	45 89 c1             	mov    %r8d,%r9d
  800dcb:	41 89 f8             	mov    %edi,%r8d
  800dce:	48 89 c7             	mov    %rax,%rdi
  800dd1:	48 b8 27 06 80 00 00 	movabs $0x800627,%rax
  800dd8:	00 00 00 
  800ddb:	ff d0                	callq  *%rax
			break;
  800ddd:	eb 3f                	jmp    800e1e <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ddf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de7:	48 89 d6             	mov    %rdx,%rsi
  800dea:	89 df                	mov    %ebx,%edi
  800dec:	ff d0                	callq  *%rax
			break;
  800dee:	eb 2e                	jmp    800e1e <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800df0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df8:	48 89 d6             	mov    %rdx,%rsi
  800dfb:	bf 25 00 00 00       	mov    $0x25,%edi
  800e00:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e02:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e07:	eb 05                	jmp    800e0e <vprintfmt+0x50c>
  800e09:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e12:	48 83 e8 01          	sub    $0x1,%rax
  800e16:	0f b6 00             	movzbl (%rax),%eax
  800e19:	3c 25                	cmp    $0x25,%al
  800e1b:	75 ec                	jne    800e09 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800e1d:	90                   	nop
		}
	}
  800e1e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e1f:	e9 30 fb ff ff       	jmpq   800954 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e24:	48 83 c4 60          	add    $0x60,%rsp
  800e28:	5b                   	pop    %rbx
  800e29:	41 5c                	pop    %r12
  800e2b:	5d                   	pop    %rbp
  800e2c:	c3                   	retq   

0000000000800e2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e2d:	55                   	push   %rbp
  800e2e:	48 89 e5             	mov    %rsp,%rbp
  800e31:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e38:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e3f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e46:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e4d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e54:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e5b:	84 c0                	test   %al,%al
  800e5d:	74 20                	je     800e7f <printfmt+0x52>
  800e5f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e63:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e67:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e6b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e6f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e73:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e77:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e7b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e7f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e86:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e8d:	00 00 00 
  800e90:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e97:	00 00 00 
  800e9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e9e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ea5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eac:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800eb3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800eba:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ec1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ec8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ecf:	48 89 c7             	mov    %rax,%rdi
  800ed2:	48 b8 02 09 80 00 00 	movabs $0x800902,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ede:	c9                   	leaveq 
  800edf:	c3                   	retq   

0000000000800ee0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ee0:	55                   	push   %rbp
  800ee1:	48 89 e5             	mov    %rsp,%rbp
  800ee4:	48 83 ec 10          	sub    $0x10,%rsp
  800ee8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eeb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef3:	8b 40 10             	mov    0x10(%rax),%eax
  800ef6:	8d 50 01             	lea    0x1(%rax),%edx
  800ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800efd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f04:	48 8b 10             	mov    (%rax),%rdx
  800f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f0f:	48 39 c2             	cmp    %rax,%rdx
  800f12:	73 17                	jae    800f2b <sprintputch+0x4b>
		*b->buf++ = ch;
  800f14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f18:	48 8b 00             	mov    (%rax),%rax
  800f1b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f23:	48 89 0a             	mov    %rcx,(%rdx)
  800f26:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f29:	88 10                	mov    %dl,(%rax)
}
  800f2b:	c9                   	leaveq 
  800f2c:	c3                   	retq   

0000000000800f2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f2d:	55                   	push   %rbp
  800f2e:	48 89 e5             	mov    %rsp,%rbp
  800f31:	48 83 ec 50          	sub    $0x50,%rsp
  800f35:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f39:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f3c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f40:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f44:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f48:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f4c:	48 8b 0a             	mov    (%rdx),%rcx
  800f4f:	48 89 08             	mov    %rcx,(%rax)
  800f52:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f56:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f5a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f5e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f66:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f6a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f6d:	48 98                	cltq   
  800f6f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f73:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f77:	48 01 d0             	add    %rdx,%rax
  800f7a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f85:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f8a:	74 06                	je     800f92 <vsnprintf+0x65>
  800f8c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f90:	7f 07                	jg     800f99 <vsnprintf+0x6c>
		return -E_INVAL;
  800f92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f97:	eb 2f                	jmp    800fc8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f99:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f9d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fa1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fa5:	48 89 c6             	mov    %rax,%rsi
  800fa8:	48 bf e0 0e 80 00 00 	movabs $0x800ee0,%rdi
  800faf:	00 00 00 
  800fb2:	48 b8 02 09 80 00 00 	movabs $0x800902,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fc2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fc5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fc8:	c9                   	leaveq 
  800fc9:	c3                   	retq   

0000000000800fca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fca:	55                   	push   %rbp
  800fcb:	48 89 e5             	mov    %rsp,%rbp
  800fce:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fd5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fdc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fe2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fe9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ff0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ff7:	84 c0                	test   %al,%al
  800ff9:	74 20                	je     80101b <snprintf+0x51>
  800ffb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801003:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801007:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80100b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80100f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801013:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801017:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80101b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801022:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801029:	00 00 00 
  80102c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801033:	00 00 00 
  801036:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80103a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801041:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801048:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80104f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801056:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80105d:	48 8b 0a             	mov    (%rdx),%rcx
  801060:	48 89 08             	mov    %rcx,(%rax)
  801063:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801067:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80106b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80106f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801073:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80107a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801081:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801087:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80108e:	48 89 c7             	mov    %rax,%rdi
  801091:	48 b8 2d 0f 80 00 00 	movabs $0x800f2d,%rax
  801098:	00 00 00 
  80109b:	ff d0                	callq  *%rax
  80109d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010a3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 83 ec 18          	sub    $0x18,%rsp
  8010b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010be:	eb 09                	jmp    8010c9 <strlen+0x1e>
		n++;
  8010c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cd:	0f b6 00             	movzbl (%rax),%eax
  8010d0:	84 c0                	test   %al,%al
  8010d2:	75 ec                	jne    8010c0 <strlen+0x15>
		n++;
	return n;
  8010d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010d7:	c9                   	leaveq 
  8010d8:	c3                   	retq   

00000000008010d9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010d9:	55                   	push   %rbp
  8010da:	48 89 e5             	mov    %rsp,%rbp
  8010dd:	48 83 ec 20          	sub    $0x20,%rsp
  8010e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010f0:	eb 0e                	jmp    801100 <strnlen+0x27>
		n++;
  8010f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010f6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010fb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801100:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801105:	74 0b                	je     801112 <strnlen+0x39>
  801107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110b:	0f b6 00             	movzbl (%rax),%eax
  80110e:	84 c0                	test   %al,%al
  801110:	75 e0                	jne    8010f2 <strnlen+0x19>
		n++;
	return n;
  801112:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801115:	c9                   	leaveq 
  801116:	c3                   	retq   

0000000000801117 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	48 83 ec 20          	sub    $0x20,%rsp
  80111f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801123:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80112f:	90                   	nop
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801138:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801140:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801144:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801148:	0f b6 12             	movzbl (%rdx),%edx
  80114b:	88 10                	mov    %dl,(%rax)
  80114d:	0f b6 00             	movzbl (%rax),%eax
  801150:	84 c0                	test   %al,%al
  801152:	75 dc                	jne    801130 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801158:	c9                   	leaveq 
  801159:	c3                   	retq   

000000000080115a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80115a:	55                   	push   %rbp
  80115b:	48 89 e5             	mov    %rsp,%rbp
  80115e:	48 83 ec 20          	sub    $0x20,%rsp
  801162:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801166:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80116a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116e:	48 89 c7             	mov    %rax,%rdi
  801171:	48 b8 ab 10 80 00 00 	movabs $0x8010ab,%rax
  801178:	00 00 00 
  80117b:	ff d0                	callq  *%rax
  80117d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801180:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801183:	48 63 d0             	movslq %eax,%rdx
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	48 01 c2             	add    %rax,%rdx
  80118d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801191:	48 89 c6             	mov    %rax,%rsi
  801194:	48 89 d7             	mov    %rdx,%rdi
  801197:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  80119e:	00 00 00 
  8011a1:	ff d0                	callq  *%rax
	return dst;
  8011a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011a7:	c9                   	leaveq 
  8011a8:	c3                   	retq   

00000000008011a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011a9:	55                   	push   %rbp
  8011aa:	48 89 e5             	mov    %rsp,%rbp
  8011ad:	48 83 ec 28          	sub    $0x28,%rsp
  8011b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011cc:	00 
  8011cd:	eb 2a                	jmp    8011f9 <strncpy+0x50>
		*dst++ = *src;
  8011cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011df:	0f b6 12             	movzbl (%rdx),%edx
  8011e2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	84 c0                	test   %al,%al
  8011ed:	74 05                	je     8011f4 <strncpy+0x4b>
			src++;
  8011ef:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801201:	72 cc                	jb     8011cf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801207:	c9                   	leaveq 
  801208:	c3                   	retq   

0000000000801209 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	48 83 ec 28          	sub    $0x28,%rsp
  801211:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801215:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801219:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801221:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801225:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80122a:	74 3d                	je     801269 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80122c:	eb 1d                	jmp    80124b <strlcpy+0x42>
			*dst++ = *src++;
  80122e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801232:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801236:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801242:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801246:	0f b6 12             	movzbl (%rdx),%edx
  801249:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80124b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801250:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801255:	74 0b                	je     801262 <strlcpy+0x59>
  801257:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80125b:	0f b6 00             	movzbl (%rax),%eax
  80125e:	84 c0                	test   %al,%al
  801260:	75 cc                	jne    80122e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801266:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801269:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80126d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801271:	48 29 c2             	sub    %rax,%rdx
  801274:	48 89 d0             	mov    %rdx,%rax
}
  801277:	c9                   	leaveq 
  801278:	c3                   	retq   

0000000000801279 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801279:	55                   	push   %rbp
  80127a:	48 89 e5             	mov    %rsp,%rbp
  80127d:	48 83 ec 10          	sub    $0x10,%rsp
  801281:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801285:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801289:	eb 0a                	jmp    801295 <strcmp+0x1c>
		p++, q++;
  80128b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801290:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801299:	0f b6 00             	movzbl (%rax),%eax
  80129c:	84 c0                	test   %al,%al
  80129e:	74 12                	je     8012b2 <strcmp+0x39>
  8012a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a4:	0f b6 10             	movzbl (%rax),%edx
  8012a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ab:	0f b6 00             	movzbl (%rax),%eax
  8012ae:	38 c2                	cmp    %al,%dl
  8012b0:	74 d9                	je     80128b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	0f b6 00             	movzbl (%rax),%eax
  8012b9:	0f b6 d0             	movzbl %al,%edx
  8012bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	0f b6 c0             	movzbl %al,%eax
  8012c6:	29 c2                	sub    %eax,%edx
  8012c8:	89 d0                	mov    %edx,%eax
}
  8012ca:	c9                   	leaveq 
  8012cb:	c3                   	retq   

00000000008012cc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012cc:	55                   	push   %rbp
  8012cd:	48 89 e5             	mov    %rsp,%rbp
  8012d0:	48 83 ec 18          	sub    $0x18,%rsp
  8012d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012e0:	eb 0f                	jmp    8012f1 <strncmp+0x25>
		n--, p++, q++;
  8012e2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012f6:	74 1d                	je     801315 <strncmp+0x49>
  8012f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fc:	0f b6 00             	movzbl (%rax),%eax
  8012ff:	84 c0                	test   %al,%al
  801301:	74 12                	je     801315 <strncmp+0x49>
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	0f b6 10             	movzbl (%rax),%edx
  80130a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	38 c2                	cmp    %al,%dl
  801313:	74 cd                	je     8012e2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801315:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131a:	75 07                	jne    801323 <strncmp+0x57>
		return 0;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
  801321:	eb 18                	jmp    80133b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	0f b6 00             	movzbl (%rax),%eax
  80132a:	0f b6 d0             	movzbl %al,%edx
  80132d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801331:	0f b6 00             	movzbl (%rax),%eax
  801334:	0f b6 c0             	movzbl %al,%eax
  801337:	29 c2                	sub    %eax,%edx
  801339:	89 d0                	mov    %edx,%eax
}
  80133b:	c9                   	leaveq 
  80133c:	c3                   	retq   

000000000080133d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 0c          	sub    $0xc,%rsp
  801345:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801349:	89 f0                	mov    %esi,%eax
  80134b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80134e:	eb 17                	jmp    801367 <strchr+0x2a>
		if (*s == c)
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80135a:	75 06                	jne    801362 <strchr+0x25>
			return (char *) s;
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	eb 15                	jmp    801377 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801362:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	84 c0                	test   %al,%al
  801370:	75 de                	jne    801350 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801377:	c9                   	leaveq 
  801378:	c3                   	retq   

0000000000801379 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801379:	55                   	push   %rbp
  80137a:	48 89 e5             	mov    %rsp,%rbp
  80137d:	48 83 ec 0c          	sub    $0xc,%rsp
  801381:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801385:	89 f0                	mov    %esi,%eax
  801387:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80138a:	eb 13                	jmp    80139f <strfind+0x26>
		if (*s == c)
  80138c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801390:	0f b6 00             	movzbl (%rax),%eax
  801393:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801396:	75 02                	jne    80139a <strfind+0x21>
			break;
  801398:	eb 10                	jmp    8013aa <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80139a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80139f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a3:	0f b6 00             	movzbl (%rax),%eax
  8013a6:	84 c0                	test   %al,%al
  8013a8:	75 e2                	jne    80138c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ae:	c9                   	leaveq 
  8013af:	c3                   	retq   

00000000008013b0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013b0:	55                   	push   %rbp
  8013b1:	48 89 e5             	mov    %rsp,%rbp
  8013b4:	48 83 ec 18          	sub    $0x18,%rsp
  8013b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013bc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013c3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013c8:	75 06                	jne    8013d0 <memset+0x20>
		return v;
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	eb 69                	jmp    801439 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d4:	83 e0 03             	and    $0x3,%eax
  8013d7:	48 85 c0             	test   %rax,%rax
  8013da:	75 48                	jne    801424 <memset+0x74>
  8013dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e0:	83 e0 03             	and    $0x3,%eax
  8013e3:	48 85 c0             	test   %rax,%rax
  8013e6:	75 3c                	jne    801424 <memset+0x74>
		c &= 0xFF;
  8013e8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f2:	c1 e0 18             	shl    $0x18,%eax
  8013f5:	89 c2                	mov    %eax,%edx
  8013f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013fa:	c1 e0 10             	shl    $0x10,%eax
  8013fd:	09 c2                	or     %eax,%edx
  8013ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801402:	c1 e0 08             	shl    $0x8,%eax
  801405:	09 d0                	or     %edx,%eax
  801407:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80140a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140e:	48 c1 e8 02          	shr    $0x2,%rax
  801412:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801415:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801419:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141c:	48 89 d7             	mov    %rdx,%rdi
  80141f:	fc                   	cld    
  801420:	f3 ab                	rep stos %eax,%es:(%rdi)
  801422:	eb 11                	jmp    801435 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801424:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801428:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80142f:	48 89 d7             	mov    %rdx,%rdi
  801432:	fc                   	cld    
  801433:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801439:	c9                   	leaveq 
  80143a:	c3                   	retq   

000000000080143b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80143b:	55                   	push   %rbp
  80143c:	48 89 e5             	mov    %rsp,%rbp
  80143f:	48 83 ec 28          	sub    $0x28,%rsp
  801443:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801447:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80144b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80144f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801453:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801467:	0f 83 88 00 00 00    	jae    8014f5 <memmove+0xba>
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801475:	48 01 d0             	add    %rdx,%rax
  801478:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80147c:	76 77                	jbe    8014f5 <memmove+0xba>
		s += n;
  80147e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801482:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	83 e0 03             	and    $0x3,%eax
  801495:	48 85 c0             	test   %rax,%rax
  801498:	75 3b                	jne    8014d5 <memmove+0x9a>
  80149a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149e:	83 e0 03             	and    $0x3,%eax
  8014a1:	48 85 c0             	test   %rax,%rax
  8014a4:	75 2f                	jne    8014d5 <memmove+0x9a>
  8014a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014aa:	83 e0 03             	and    $0x3,%eax
  8014ad:	48 85 c0             	test   %rax,%rax
  8014b0:	75 23                	jne    8014d5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b6:	48 83 e8 04          	sub    $0x4,%rax
  8014ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014be:	48 83 ea 04          	sub    $0x4,%rdx
  8014c2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014c6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014ca:	48 89 c7             	mov    %rax,%rdi
  8014cd:	48 89 d6             	mov    %rdx,%rsi
  8014d0:	fd                   	std    
  8014d1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014d3:	eb 1d                	jmp    8014f2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	48 89 d7             	mov    %rdx,%rdi
  8014ec:	48 89 c1             	mov    %rax,%rcx
  8014ef:	fd                   	std    
  8014f0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014f2:	fc                   	cld    
  8014f3:	eb 57                	jmp    80154c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	83 e0 03             	and    $0x3,%eax
  8014fc:	48 85 c0             	test   %rax,%rax
  8014ff:	75 36                	jne    801537 <memmove+0xfc>
  801501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801505:	83 e0 03             	and    $0x3,%eax
  801508:	48 85 c0             	test   %rax,%rax
  80150b:	75 2a                	jne    801537 <memmove+0xfc>
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	83 e0 03             	and    $0x3,%eax
  801514:	48 85 c0             	test   %rax,%rax
  801517:	75 1e                	jne    801537 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151d:	48 c1 e8 02          	shr    $0x2,%rax
  801521:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801524:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801528:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152c:	48 89 c7             	mov    %rax,%rdi
  80152f:	48 89 d6             	mov    %rdx,%rsi
  801532:	fc                   	cld    
  801533:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801535:	eb 15                	jmp    80154c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801543:	48 89 c7             	mov    %rax,%rdi
  801546:	48 89 d6             	mov    %rdx,%rsi
  801549:	fc                   	cld    
  80154a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80154c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 18          	sub    $0x18,%rsp
  80155a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80155e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801562:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80156a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	48 89 ce             	mov    %rcx,%rsi
  801575:	48 89 c7             	mov    %rax,%rdi
  801578:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  80157f:	00 00 00 
  801582:	ff d0                	callq  *%rax
}
  801584:	c9                   	leaveq 
  801585:	c3                   	retq   

0000000000801586 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801586:	55                   	push   %rbp
  801587:	48 89 e5             	mov    %rsp,%rbp
  80158a:	48 83 ec 28          	sub    $0x28,%rsp
  80158e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801592:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801596:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80159a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015aa:	eb 36                	jmp    8015e2 <memcmp+0x5c>
		if (*s1 != *s2)
  8015ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b0:	0f b6 10             	movzbl (%rax),%edx
  8015b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	38 c2                	cmp    %al,%dl
  8015bc:	74 1a                	je     8015d8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	0f b6 d0             	movzbl %al,%edx
  8015c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cc:	0f b6 00             	movzbl (%rax),%eax
  8015cf:	0f b6 c0             	movzbl %al,%eax
  8015d2:	29 c2                	sub    %eax,%edx
  8015d4:	89 d0                	mov    %edx,%eax
  8015d6:	eb 20                	jmp    8015f8 <memcmp+0x72>
		s1++, s2++;
  8015d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ee:	48 85 c0             	test   %rax,%rax
  8015f1:	75 b9                	jne    8015ac <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f8:	c9                   	leaveq 
  8015f9:	c3                   	retq   

00000000008015fa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015fa:	55                   	push   %rbp
  8015fb:	48 89 e5             	mov    %rsp,%rbp
  8015fe:	48 83 ec 28          	sub    $0x28,%rsp
  801602:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801606:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801609:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801615:	48 01 d0             	add    %rdx,%rax
  801618:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80161c:	eb 15                	jmp    801633 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80161e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801622:	0f b6 10             	movzbl (%rax),%edx
  801625:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801628:	38 c2                	cmp    %al,%dl
  80162a:	75 02                	jne    80162e <memfind+0x34>
			break;
  80162c:	eb 0f                	jmp    80163d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80162e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801637:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80163b:	72 e1                	jb     80161e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80163d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801641:	c9                   	leaveq 
  801642:	c3                   	retq   

0000000000801643 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 83 ec 34          	sub    $0x34,%rsp
  80164b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80164f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801653:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80165d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801664:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801665:	eb 05                	jmp    80166c <strtol+0x29>
		s++;
  801667:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 20                	cmp    $0x20,%al
  801675:	74 f0                	je     801667 <strtol+0x24>
  801677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	3c 09                	cmp    $0x9,%al
  801680:	74 e5                	je     801667 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801686:	0f b6 00             	movzbl (%rax),%eax
  801689:	3c 2b                	cmp    $0x2b,%al
  80168b:	75 07                	jne    801694 <strtol+0x51>
		s++;
  80168d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801692:	eb 17                	jmp    8016ab <strtol+0x68>
	else if (*s == '-')
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 2d                	cmp    $0x2d,%al
  80169d:	75 0c                	jne    8016ab <strtol+0x68>
		s++, neg = 1;
  80169f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016af:	74 06                	je     8016b7 <strtol+0x74>
  8016b1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016b5:	75 28                	jne    8016df <strtol+0x9c>
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	3c 30                	cmp    $0x30,%al
  8016c0:	75 1d                	jne    8016df <strtol+0x9c>
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	48 83 c0 01          	add    $0x1,%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3c 78                	cmp    $0x78,%al
  8016cf:	75 0e                	jne    8016df <strtol+0x9c>
		s += 2, base = 16;
  8016d1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016d6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016dd:	eb 2c                	jmp    80170b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e3:	75 19                	jne    8016fe <strtol+0xbb>
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	0f b6 00             	movzbl (%rax),%eax
  8016ec:	3c 30                	cmp    $0x30,%al
  8016ee:	75 0e                	jne    8016fe <strtol+0xbb>
		s++, base = 8;
  8016f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016fc:	eb 0d                	jmp    80170b <strtol+0xc8>
	else if (base == 0)
  8016fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801702:	75 07                	jne    80170b <strtol+0xc8>
		base = 10;
  801704:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	3c 2f                	cmp    $0x2f,%al
  801714:	7e 1d                	jle    801733 <strtol+0xf0>
  801716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	3c 39                	cmp    $0x39,%al
  80171f:	7f 12                	jg     801733 <strtol+0xf0>
			dig = *s - '0';
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 30             	sub    $0x30,%eax
  80172e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801731:	eb 4e                	jmp    801781 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	3c 60                	cmp    $0x60,%al
  80173c:	7e 1d                	jle    80175b <strtol+0x118>
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	0f b6 00             	movzbl (%rax),%eax
  801745:	3c 7a                	cmp    $0x7a,%al
  801747:	7f 12                	jg     80175b <strtol+0x118>
			dig = *s - 'a' + 10;
  801749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174d:	0f b6 00             	movzbl (%rax),%eax
  801750:	0f be c0             	movsbl %al,%eax
  801753:	83 e8 57             	sub    $0x57,%eax
  801756:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801759:	eb 26                	jmp    801781 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	3c 40                	cmp    $0x40,%al
  801764:	7e 48                	jle    8017ae <strtol+0x16b>
  801766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	3c 5a                	cmp    $0x5a,%al
  80176f:	7f 3d                	jg     8017ae <strtol+0x16b>
			dig = *s - 'A' + 10;
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	0f b6 00             	movzbl (%rax),%eax
  801778:	0f be c0             	movsbl %al,%eax
  80177b:	83 e8 37             	sub    $0x37,%eax
  80177e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801781:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801784:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801787:	7c 02                	jl     80178b <strtol+0x148>
			break;
  801789:	eb 23                	jmp    8017ae <strtol+0x16b>
		s++, val = (val * base) + dig;
  80178b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801790:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801793:	48 98                	cltq   
  801795:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80179a:	48 89 c2             	mov    %rax,%rdx
  80179d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017a0:	48 98                	cltq   
  8017a2:	48 01 d0             	add    %rdx,%rax
  8017a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017a9:	e9 5d ff ff ff       	jmpq   80170b <strtol+0xc8>

	if (endptr)
  8017ae:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017b3:	74 0b                	je     8017c0 <strtol+0x17d>
		*endptr = (char *) s;
  8017b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017bd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017c4:	74 09                	je     8017cf <strtol+0x18c>
  8017c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ca:	48 f7 d8             	neg    %rax
  8017cd:	eb 04                	jmp    8017d3 <strtol+0x190>
  8017cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017d3:	c9                   	leaveq 
  8017d4:	c3                   	retq   

00000000008017d5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017d5:	55                   	push   %rbp
  8017d6:	48 89 e5             	mov    %rsp,%rbp
  8017d9:	48 83 ec 30          	sub    $0x30,%rsp
  8017dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ed:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017f1:	0f b6 00             	movzbl (%rax),%eax
  8017f4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017f7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017fb:	75 06                	jne    801803 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	eb 6b                	jmp    80186e <strstr+0x99>

	len = strlen(str);
  801803:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801807:	48 89 c7             	mov    %rax,%rdi
  80180a:	48 b8 ab 10 80 00 00 	movabs $0x8010ab,%rax
  801811:	00 00 00 
  801814:	ff d0                	callq  *%rax
  801816:	48 98                	cltq   
  801818:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801824:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801828:	0f b6 00             	movzbl (%rax),%eax
  80182b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80182e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801832:	75 07                	jne    80183b <strstr+0x66>
				return (char *) 0;
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
  801839:	eb 33                	jmp    80186e <strstr+0x99>
		} while (sc != c);
  80183b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80183f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801842:	75 d8                	jne    80181c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801848:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	48 89 ce             	mov    %rcx,%rsi
  801853:	48 89 c7             	mov    %rax,%rdi
  801856:	48 b8 cc 12 80 00 00 	movabs $0x8012cc,%rax
  80185d:	00 00 00 
  801860:	ff d0                	callq  *%rax
  801862:	85 c0                	test   %eax,%eax
  801864:	75 b6                	jne    80181c <strstr+0x47>

	return (char *) (in - 1);
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	48 83 e8 01          	sub    $0x1,%rax
}
  80186e:	c9                   	leaveq 
  80186f:	c3                   	retq   

0000000000801870 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801870:	55                   	push   %rbp
  801871:	48 89 e5             	mov    %rsp,%rbp
  801874:	53                   	push   %rbx
  801875:	48 83 ec 48          	sub    $0x48,%rsp
  801879:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80187c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80187f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801883:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801887:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80188b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801892:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801896:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80189a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80189e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018a2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018a6:	4c 89 c3             	mov    %r8,%rbx
  8018a9:	cd 30                	int    $0x30
  8018ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018af:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018b3:	74 3e                	je     8018f3 <syscall+0x83>
  8018b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ba:	7e 37                	jle    8018f3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018c3:	49 89 d0             	mov    %rdx,%r8
  8018c6:	89 c1                	mov    %eax,%ecx
  8018c8:	48 ba 48 48 80 00 00 	movabs $0x804848,%rdx
  8018cf:	00 00 00 
  8018d2:	be 23 00 00 00       	mov    $0x23,%esi
  8018d7:	48 bf 65 48 80 00 00 	movabs $0x804865,%rdi
  8018de:	00 00 00 
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e6:	49 b9 16 03 80 00 00 	movabs $0x800316,%r9
  8018ed:	00 00 00 
  8018f0:	41 ff d1             	callq  *%r9

	return ret;
  8018f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018f7:	48 83 c4 48          	add    $0x48,%rsp
  8018fb:	5b                   	pop    %rbx
  8018fc:	5d                   	pop    %rbp
  8018fd:	c3                   	retq   

00000000008018fe <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018fe:	55                   	push   %rbp
  8018ff:	48 89 e5             	mov    %rsp,%rbp
  801902:	48 83 ec 20          	sub    $0x20,%rsp
  801906:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80190a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80190e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801912:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801916:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191d:	00 
  80191e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801924:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192a:	48 89 d1             	mov    %rdx,%rcx
  80192d:	48 89 c2             	mov    %rax,%rdx
  801930:	be 00 00 00 00       	mov    $0x0,%esi
  801935:	bf 00 00 00 00       	mov    $0x0,%edi
  80193a:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
}
  801946:	c9                   	leaveq 
  801947:	c3                   	retq   

0000000000801948 <sys_cgetc>:

int
sys_cgetc(void)
{
  801948:	55                   	push   %rbp
  801949:	48 89 e5             	mov    %rsp,%rbp
  80194c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801950:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801957:	00 
  801958:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801964:	b9 00 00 00 00       	mov    $0x0,%ecx
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	be 00 00 00 00       	mov    $0x0,%esi
  801973:	bf 01 00 00 00       	mov    $0x1,%edi
  801978:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  80197f:	00 00 00 
  801982:	ff d0                	callq  *%rax
}
  801984:	c9                   	leaveq 
  801985:	c3                   	retq   

0000000000801986 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801986:	55                   	push   %rbp
  801987:	48 89 e5             	mov    %rsp,%rbp
  80198a:	48 83 ec 10          	sub    $0x10,%rsp
  80198e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801991:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801994:	48 98                	cltq   
  801996:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199d:	00 
  80199e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019af:	48 89 c2             	mov    %rax,%rdx
  8019b2:	be 01 00 00 00       	mov    $0x1,%esi
  8019b7:	bf 03 00 00 00       	mov    $0x3,%edi
  8019bc:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8019c3:	00 00 00 
  8019c6:	ff d0                	callq  *%rax
}
  8019c8:	c9                   	leaveq 
  8019c9:	c3                   	retq   

00000000008019ca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019ca:	55                   	push   %rbp
  8019cb:	48 89 e5             	mov    %rsp,%rbp
  8019ce:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d9:	00 
  8019da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f0:	be 00 00 00 00       	mov    $0x0,%esi
  8019f5:	bf 02 00 00 00       	mov    $0x2,%edi
  8019fa:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801a01:	00 00 00 
  801a04:	ff d0                	callq  *%rax
}
  801a06:	c9                   	leaveq 
  801a07:	c3                   	retq   

0000000000801a08 <sys_yield>:

void
sys_yield(void)
{
  801a08:	55                   	push   %rbp
  801a09:	48 89 e5             	mov    %rsp,%rbp
  801a0c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a17:	00 
  801a18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a29:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2e:	be 00 00 00 00       	mov    $0x0,%esi
  801a33:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a38:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	callq  *%rax
}
  801a44:	c9                   	leaveq 
  801a45:	c3                   	retq   

0000000000801a46 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
  801a4a:	48 83 ec 20          	sub    $0x20,%rsp
  801a4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a55:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5b:	48 63 c8             	movslq %eax,%rcx
  801a5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a65:	48 98                	cltq   
  801a67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6e:	00 
  801a6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a75:	49 89 c8             	mov    %rcx,%r8
  801a78:	48 89 d1             	mov    %rdx,%rcx
  801a7b:	48 89 c2             	mov    %rax,%rdx
  801a7e:	be 01 00 00 00       	mov    $0x1,%esi
  801a83:	bf 04 00 00 00       	mov    $0x4,%edi
  801a88:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	callq  *%rax
}
  801a94:	c9                   	leaveq 
  801a95:	c3                   	retq   

0000000000801a96 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a96:	55                   	push   %rbp
  801a97:	48 89 e5             	mov    %rsp,%rbp
  801a9a:	48 83 ec 30          	sub    $0x30,%rsp
  801a9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aa5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801aa8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aac:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ab0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ab3:	48 63 c8             	movslq %eax,%rcx
  801ab6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abd:	48 63 f0             	movslq %eax,%rsi
  801ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac7:	48 98                	cltq   
  801ac9:	48 89 0c 24          	mov    %rcx,(%rsp)
  801acd:	49 89 f9             	mov    %rdi,%r9
  801ad0:	49 89 f0             	mov    %rsi,%r8
  801ad3:	48 89 d1             	mov    %rdx,%rcx
  801ad6:	48 89 c2             	mov    %rax,%rdx
  801ad9:	be 01 00 00 00       	mov    $0x1,%esi
  801ade:	bf 05 00 00 00       	mov    $0x5,%edi
  801ae3:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	callq  *%rax
}
  801aef:	c9                   	leaveq 
  801af0:	c3                   	retq   

0000000000801af1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
  801af5:	48 83 ec 20          	sub    $0x20,%rsp
  801af9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801afc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b07:	48 98                	cltq   
  801b09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b10:	00 
  801b11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1d:	48 89 d1             	mov    %rdx,%rcx
  801b20:	48 89 c2             	mov    %rax,%rdx
  801b23:	be 01 00 00 00       	mov    $0x1,%esi
  801b28:	bf 06 00 00 00       	mov    $0x6,%edi
  801b2d:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801b34:	00 00 00 
  801b37:	ff d0                	callq  *%rax
}
  801b39:	c9                   	leaveq 
  801b3a:	c3                   	retq   

0000000000801b3b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b3b:	55                   	push   %rbp
  801b3c:	48 89 e5             	mov    %rsp,%rbp
  801b3f:	48 83 ec 10          	sub    $0x10,%rsp
  801b43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b46:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4c:	48 63 d0             	movslq %eax,%rdx
  801b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b52:	48 98                	cltq   
  801b54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5b:	00 
  801b5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b68:	48 89 d1             	mov    %rdx,%rcx
  801b6b:	48 89 c2             	mov    %rax,%rdx
  801b6e:	be 01 00 00 00       	mov    $0x1,%esi
  801b73:	bf 08 00 00 00       	mov    $0x8,%edi
  801b78:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	callq  *%rax
}
  801b84:	c9                   	leaveq 
  801b85:	c3                   	retq   

0000000000801b86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b86:	55                   	push   %rbp
  801b87:	48 89 e5             	mov    %rsp,%rbp
  801b8a:	48 83 ec 20          	sub    $0x20,%rsp
  801b8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9c:	48 98                	cltq   
  801b9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba5:	00 
  801ba6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb2:	48 89 d1             	mov    %rdx,%rcx
  801bb5:	48 89 c2             	mov    %rax,%rdx
  801bb8:	be 01 00 00 00       	mov    $0x1,%esi
  801bbd:	bf 09 00 00 00       	mov    $0x9,%edi
  801bc2:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801bc9:	00 00 00 
  801bcc:	ff d0                	callq  *%rax
}
  801bce:	c9                   	leaveq 
  801bcf:	c3                   	retq   

0000000000801bd0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bd0:	55                   	push   %rbp
  801bd1:	48 89 e5             	mov    %rsp,%rbp
  801bd4:	48 83 ec 20          	sub    $0x20,%rsp
  801bd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be6:	48 98                	cltq   
  801be8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bef:	00 
  801bf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfc:	48 89 d1             	mov    %rdx,%rcx
  801bff:	48 89 c2             	mov    %rax,%rdx
  801c02:	be 01 00 00 00       	mov    $0x1,%esi
  801c07:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c0c:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	callq  *%rax
}
  801c18:	c9                   	leaveq 
  801c19:	c3                   	retq   

0000000000801c1a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c1a:	55                   	push   %rbp
  801c1b:	48 89 e5             	mov    %rsp,%rbp
  801c1e:	48 83 ec 20          	sub    $0x20,%rsp
  801c22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c29:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c2d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c33:	48 63 f0             	movslq %eax,%rsi
  801c36:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3d:	48 98                	cltq   
  801c3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4a:	00 
  801c4b:	49 89 f1             	mov    %rsi,%r9
  801c4e:	49 89 c8             	mov    %rcx,%r8
  801c51:	48 89 d1             	mov    %rdx,%rcx
  801c54:	48 89 c2             	mov    %rax,%rdx
  801c57:	be 00 00 00 00       	mov    $0x0,%esi
  801c5c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c61:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
  801c73:	48 83 ec 10          	sub    $0x10,%rsp
  801c77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c86:	00 
  801c87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c93:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c98:	48 89 c2             	mov    %rax,%rdx
  801c9b:	be 01 00 00 00       	mov    $0x1,%esi
  801ca0:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ca5:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  801cac:	00 00 00 
  801caf:	ff d0                	callq  *%rax
}
  801cb1:	c9                   	leaveq 
  801cb2:	c3                   	retq   

0000000000801cb3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cb3:	55                   	push   %rbp
  801cb4:	48 89 e5             	mov    %rsp,%rbp
  801cb7:	48 83 ec 08          	sub    $0x8,%rsp
  801cbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cbf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cc3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cca:	ff ff ff 
  801ccd:	48 01 d0             	add    %rdx,%rax
  801cd0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cd4:	c9                   	leaveq 
  801cd5:	c3                   	retq   

0000000000801cd6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cd6:	55                   	push   %rbp
  801cd7:	48 89 e5             	mov    %rsp,%rbp
  801cda:	48 83 ec 08          	sub    $0x8,%rsp
  801cde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ce2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce6:	48 89 c7             	mov    %rax,%rdi
  801ce9:	48 b8 b3 1c 80 00 00 	movabs $0x801cb3,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	callq  *%rax
  801cf5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cfb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cff:	c9                   	leaveq 
  801d00:	c3                   	retq   

0000000000801d01 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d01:	55                   	push   %rbp
  801d02:	48 89 e5             	mov    %rsp,%rbp
  801d05:	48 83 ec 18          	sub    $0x18,%rsp
  801d09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d14:	eb 6b                	jmp    801d81 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d19:	48 98                	cltq   
  801d1b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d21:	48 c1 e0 0c          	shl    $0xc,%rax
  801d25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2d:	48 c1 e8 15          	shr    $0x15,%rax
  801d31:	48 89 c2             	mov    %rax,%rdx
  801d34:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d3b:	01 00 00 
  801d3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d42:	83 e0 01             	and    $0x1,%eax
  801d45:	48 85 c0             	test   %rax,%rax
  801d48:	74 21                	je     801d6b <fd_alloc+0x6a>
  801d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d4e:	48 c1 e8 0c          	shr    $0xc,%rax
  801d52:	48 89 c2             	mov    %rax,%rdx
  801d55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d5c:	01 00 00 
  801d5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d63:	83 e0 01             	and    $0x1,%eax
  801d66:	48 85 c0             	test   %rax,%rax
  801d69:	75 12                	jne    801d7d <fd_alloc+0x7c>
			*fd_store = fd;
  801d6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d73:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7b:	eb 1a                	jmp    801d97 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d7d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d81:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d85:	7e 8f                	jle    801d16 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d92:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d97:	c9                   	leaveq 
  801d98:	c3                   	retq   

0000000000801d99 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d99:	55                   	push   %rbp
  801d9a:	48 89 e5             	mov    %rsp,%rbp
  801d9d:	48 83 ec 20          	sub    $0x20,%rsp
  801da1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801da4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801da8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dac:	78 06                	js     801db4 <fd_lookup+0x1b>
  801dae:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801db2:	7e 07                	jle    801dbb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801db4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db9:	eb 6c                	jmp    801e27 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801dbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dbe:	48 98                	cltq   
  801dc0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dc6:	48 c1 e0 0c          	shl    $0xc,%rax
  801dca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd2:	48 c1 e8 15          	shr    $0x15,%rax
  801dd6:	48 89 c2             	mov    %rax,%rdx
  801dd9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801de0:	01 00 00 
  801de3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de7:	83 e0 01             	and    $0x1,%eax
  801dea:	48 85 c0             	test   %rax,%rax
  801ded:	74 21                	je     801e10 <fd_lookup+0x77>
  801def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df3:	48 c1 e8 0c          	shr    $0xc,%rax
  801df7:	48 89 c2             	mov    %rax,%rdx
  801dfa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e01:	01 00 00 
  801e04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e08:	83 e0 01             	and    $0x1,%eax
  801e0b:	48 85 c0             	test   %rax,%rax
  801e0e:	75 07                	jne    801e17 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e15:	eb 10                	jmp    801e27 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e27:	c9                   	leaveq 
  801e28:	c3                   	retq   

0000000000801e29 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e29:	55                   	push   %rbp
  801e2a:	48 89 e5             	mov    %rsp,%rbp
  801e2d:	48 83 ec 30          	sub    $0x30,%rsp
  801e31:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e35:	89 f0                	mov    %esi,%eax
  801e37:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3e:	48 89 c7             	mov    %rax,%rdi
  801e41:	48 b8 b3 1c 80 00 00 	movabs $0x801cb3,%rax
  801e48:	00 00 00 
  801e4b:	ff d0                	callq  *%rax
  801e4d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e51:	48 89 d6             	mov    %rdx,%rsi
  801e54:	89 c7                	mov    %eax,%edi
  801e56:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  801e5d:	00 00 00 
  801e60:	ff d0                	callq  *%rax
  801e62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e69:	78 0a                	js     801e75 <fd_close+0x4c>
	    || fd != fd2)
  801e6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e73:	74 12                	je     801e87 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e75:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e79:	74 05                	je     801e80 <fd_close+0x57>
  801e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7e:	eb 05                	jmp    801e85 <fd_close+0x5c>
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
  801e85:	eb 69                	jmp    801ef0 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8b:	8b 00                	mov    (%rax),%eax
  801e8d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e91:	48 89 d6             	mov    %rdx,%rsi
  801e94:	89 c7                	mov    %eax,%edi
  801e96:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  801e9d:	00 00 00 
  801ea0:	ff d0                	callq  *%rax
  801ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea9:	78 2a                	js     801ed5 <fd_close+0xac>
		if (dev->dev_close)
  801eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eaf:	48 8b 40 20          	mov    0x20(%rax),%rax
  801eb3:	48 85 c0             	test   %rax,%rax
  801eb6:	74 16                	je     801ece <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebc:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ec0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ec4:	48 89 d7             	mov    %rdx,%rdi
  801ec7:	ff d0                	callq  *%rax
  801ec9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ecc:	eb 07                	jmp    801ed5 <fd_close+0xac>
		else
			r = 0;
  801ece:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ed5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed9:	48 89 c6             	mov    %rax,%rsi
  801edc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee1:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  801ee8:	00 00 00 
  801eeb:	ff d0                	callq  *%rax
	return r;
  801eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ef0:	c9                   	leaveq 
  801ef1:	c3                   	retq   

0000000000801ef2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ef2:	55                   	push   %rbp
  801ef3:	48 89 e5             	mov    %rsp,%rbp
  801ef6:	48 83 ec 20          	sub    $0x20,%rsp
  801efa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801efd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f08:	eb 41                	jmp    801f4b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f0a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f11:	00 00 00 
  801f14:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f17:	48 63 d2             	movslq %edx,%rdx
  801f1a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1e:	8b 00                	mov    (%rax),%eax
  801f20:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f23:	75 22                	jne    801f47 <dev_lookup+0x55>
			*dev = devtab[i];
  801f25:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f2c:	00 00 00 
  801f2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f32:	48 63 d2             	movslq %edx,%rdx
  801f35:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	eb 60                	jmp    801fa7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f47:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f4b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f52:	00 00 00 
  801f55:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f58:	48 63 d2             	movslq %edx,%rdx
  801f5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5f:	48 85 c0             	test   %rax,%rax
  801f62:	75 a6                	jne    801f0a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f64:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f6b:	00 00 00 
  801f6e:	48 8b 00             	mov    (%rax),%rax
  801f71:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f77:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f7a:	89 c6                	mov    %eax,%esi
  801f7c:	48 bf 78 48 80 00 00 	movabs $0x804878,%rdi
  801f83:	00 00 00 
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8b:	48 b9 4f 05 80 00 00 	movabs $0x80054f,%rcx
  801f92:	00 00 00 
  801f95:	ff d1                	callq  *%rcx
	*dev = 0;
  801f97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fa7:	c9                   	leaveq 
  801fa8:	c3                   	retq   

0000000000801fa9 <close>:

int
close(int fdnum)
{
  801fa9:	55                   	push   %rbp
  801faa:	48 89 e5             	mov    %rsp,%rbp
  801fad:	48 83 ec 20          	sub    $0x20,%rsp
  801fb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fbb:	48 89 d6             	mov    %rdx,%rsi
  801fbe:	89 c7                	mov    %eax,%edi
  801fc0:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  801fc7:	00 00 00 
  801fca:	ff d0                	callq  *%rax
  801fcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd3:	79 05                	jns    801fda <close+0x31>
		return r;
  801fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd8:	eb 18                	jmp    801ff2 <close+0x49>
	else
		return fd_close(fd, 1);
  801fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fde:	be 01 00 00 00       	mov    $0x1,%esi
  801fe3:	48 89 c7             	mov    %rax,%rdi
  801fe6:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
}
  801ff2:	c9                   	leaveq 
  801ff3:	c3                   	retq   

0000000000801ff4 <close_all>:

void
close_all(void)
{
  801ff4:	55                   	push   %rbp
  801ff5:	48 89 e5             	mov    %rsp,%rbp
  801ff8:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802003:	eb 15                	jmp    80201a <close_all+0x26>
		close(i);
  802005:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802008:	89 c7                	mov    %eax,%edi
  80200a:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802011:	00 00 00 
  802014:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802016:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80201a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80201e:	7e e5                	jle    802005 <close_all+0x11>
		close(i);
}
  802020:	c9                   	leaveq 
  802021:	c3                   	retq   

0000000000802022 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802022:	55                   	push   %rbp
  802023:	48 89 e5             	mov    %rsp,%rbp
  802026:	48 83 ec 40          	sub    $0x40,%rsp
  80202a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80202d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802030:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802034:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802037:	48 89 d6             	mov    %rdx,%rsi
  80203a:	89 c7                	mov    %eax,%edi
  80203c:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  802043:	00 00 00 
  802046:	ff d0                	callq  *%rax
  802048:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80204b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204f:	79 08                	jns    802059 <dup+0x37>
		return r;
  802051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802054:	e9 70 01 00 00       	jmpq   8021c9 <dup+0x1a7>
	close(newfdnum);
  802059:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80205c:	89 c7                	mov    %eax,%edi
  80205e:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802065:	00 00 00 
  802068:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80206a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80206d:	48 98                	cltq   
  80206f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802075:	48 c1 e0 0c          	shl    $0xc,%rax
  802079:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80207d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802081:	48 89 c7             	mov    %rax,%rdi
  802084:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	callq  *%rax
  802090:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802098:	48 89 c7             	mov    %rax,%rdi
  80209b:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
  8020a7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020af:	48 c1 e8 15          	shr    $0x15,%rax
  8020b3:	48 89 c2             	mov    %rax,%rdx
  8020b6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020bd:	01 00 00 
  8020c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c4:	83 e0 01             	and    $0x1,%eax
  8020c7:	48 85 c0             	test   %rax,%rax
  8020ca:	74 73                	je     80213f <dup+0x11d>
  8020cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d4:	48 89 c2             	mov    %rax,%rdx
  8020d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020de:	01 00 00 
  8020e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e5:	83 e0 01             	and    $0x1,%eax
  8020e8:	48 85 c0             	test   %rax,%rax
  8020eb:	74 52                	je     80213f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8020f5:	48 89 c2             	mov    %rax,%rdx
  8020f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ff:	01 00 00 
  802102:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802106:	25 07 0e 00 00       	and    $0xe07,%eax
  80210b:	89 c1                	mov    %eax,%ecx
  80210d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	41 89 c8             	mov    %ecx,%r8d
  802118:	48 89 d1             	mov    %rdx,%rcx
  80211b:	ba 00 00 00 00       	mov    $0x0,%edx
  802120:	48 89 c6             	mov    %rax,%rsi
  802123:	bf 00 00 00 00       	mov    $0x0,%edi
  802128:	48 b8 96 1a 80 00 00 	movabs $0x801a96,%rax
  80212f:	00 00 00 
  802132:	ff d0                	callq  *%rax
  802134:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802137:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213b:	79 02                	jns    80213f <dup+0x11d>
			goto err;
  80213d:	eb 57                	jmp    802196 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80213f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802143:	48 c1 e8 0c          	shr    $0xc,%rax
  802147:	48 89 c2             	mov    %rax,%rdx
  80214a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802151:	01 00 00 
  802154:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802158:	25 07 0e 00 00       	and    $0xe07,%eax
  80215d:	89 c1                	mov    %eax,%ecx
  80215f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802163:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802167:	41 89 c8             	mov    %ecx,%r8d
  80216a:	48 89 d1             	mov    %rdx,%rcx
  80216d:	ba 00 00 00 00       	mov    $0x0,%edx
  802172:	48 89 c6             	mov    %rax,%rsi
  802175:	bf 00 00 00 00       	mov    $0x0,%edi
  80217a:	48 b8 96 1a 80 00 00 	movabs $0x801a96,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
  802186:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218d:	79 02                	jns    802191 <dup+0x16f>
		goto err;
  80218f:	eb 05                	jmp    802196 <dup+0x174>

	return newfdnum;
  802191:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802194:	eb 33                	jmp    8021c9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219a:	48 89 c6             	mov    %rax,%rsi
  80219d:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a2:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b2:	48 89 c6             	mov    %rax,%rsi
  8021b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ba:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	callq  *%rax
	return r;
  8021c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021c9:	c9                   	leaveq 
  8021ca:	c3                   	retq   

00000000008021cb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021cb:	55                   	push   %rbp
  8021cc:	48 89 e5             	mov    %rsp,%rbp
  8021cf:	48 83 ec 40          	sub    $0x40,%rsp
  8021d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021e5:	48 89 d6             	mov    %rdx,%rsi
  8021e8:	89 c7                	mov    %eax,%edi
  8021ea:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
  8021f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fd:	78 24                	js     802223 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802203:	8b 00                	mov    (%rax),%eax
  802205:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802209:	48 89 d6             	mov    %rdx,%rsi
  80220c:	89 c7                	mov    %eax,%edi
  80220e:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
  80221a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802221:	79 05                	jns    802228 <read+0x5d>
		return r;
  802223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802226:	eb 76                	jmp    80229e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222c:	8b 40 08             	mov    0x8(%rax),%eax
  80222f:	83 e0 03             	and    $0x3,%eax
  802232:	83 f8 01             	cmp    $0x1,%eax
  802235:	75 3a                	jne    802271 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802237:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80223e:	00 00 00 
  802241:	48 8b 00             	mov    (%rax),%rax
  802244:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80224a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80224d:	89 c6                	mov    %eax,%esi
  80224f:	48 bf 97 48 80 00 00 	movabs $0x804897,%rdi
  802256:	00 00 00 
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
  80225e:	48 b9 4f 05 80 00 00 	movabs $0x80054f,%rcx
  802265:	00 00 00 
  802268:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80226a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226f:	eb 2d                	jmp    80229e <read+0xd3>
	}
	if (!dev->dev_read)
  802271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802275:	48 8b 40 10          	mov    0x10(%rax),%rax
  802279:	48 85 c0             	test   %rax,%rax
  80227c:	75 07                	jne    802285 <read+0xba>
		return -E_NOT_SUPP;
  80227e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802283:	eb 19                	jmp    80229e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802289:	48 8b 40 10          	mov    0x10(%rax),%rax
  80228d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802291:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802295:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802299:	48 89 cf             	mov    %rcx,%rdi
  80229c:	ff d0                	callq  *%rax
}
  80229e:	c9                   	leaveq 
  80229f:	c3                   	retq   

00000000008022a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022a0:	55                   	push   %rbp
  8022a1:	48 89 e5             	mov    %rsp,%rbp
  8022a4:	48 83 ec 30          	sub    $0x30,%rsp
  8022a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ba:	eb 49                	jmp    802305 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bf:	48 98                	cltq   
  8022c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022c5:	48 29 c2             	sub    %rax,%rdx
  8022c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cb:	48 63 c8             	movslq %eax,%rcx
  8022ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022d2:	48 01 c1             	add    %rax,%rcx
  8022d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d8:	48 89 ce             	mov    %rcx,%rsi
  8022db:	89 c7                	mov    %eax,%edi
  8022dd:	48 b8 cb 21 80 00 00 	movabs $0x8021cb,%rax
  8022e4:	00 00 00 
  8022e7:	ff d0                	callq  *%rax
  8022e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022f0:	79 05                	jns    8022f7 <readn+0x57>
			return m;
  8022f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022f5:	eb 1c                	jmp    802313 <readn+0x73>
		if (m == 0)
  8022f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022fb:	75 02                	jne    8022ff <readn+0x5f>
			break;
  8022fd:	eb 11                	jmp    802310 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802302:	01 45 fc             	add    %eax,-0x4(%rbp)
  802305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802308:	48 98                	cltq   
  80230a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80230e:	72 ac                	jb     8022bc <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802310:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802313:	c9                   	leaveq 
  802314:	c3                   	retq   

0000000000802315 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802315:	55                   	push   %rbp
  802316:	48 89 e5             	mov    %rsp,%rbp
  802319:	48 83 ec 40          	sub    $0x40,%rsp
  80231d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802320:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802324:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802328:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80232c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80232f:	48 89 d6             	mov    %rdx,%rsi
  802332:	89 c7                	mov    %eax,%edi
  802334:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax
  802340:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802343:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802347:	78 24                	js     80236d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234d:	8b 00                	mov    (%rax),%eax
  80234f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802353:	48 89 d6             	mov    %rdx,%rsi
  802356:	89 c7                	mov    %eax,%edi
  802358:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  80235f:	00 00 00 
  802362:	ff d0                	callq  *%rax
  802364:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236b:	79 05                	jns    802372 <write+0x5d>
		return r;
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802370:	eb 75                	jmp    8023e7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802376:	8b 40 08             	mov    0x8(%rax),%eax
  802379:	83 e0 03             	and    $0x3,%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	75 3a                	jne    8023ba <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802380:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802387:	00 00 00 
  80238a:	48 8b 00             	mov    (%rax),%rax
  80238d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802393:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802396:	89 c6                	mov    %eax,%esi
  802398:	48 bf b3 48 80 00 00 	movabs $0x8048b3,%rdi
  80239f:	00 00 00 
  8023a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a7:	48 b9 4f 05 80 00 00 	movabs $0x80054f,%rcx
  8023ae:	00 00 00 
  8023b1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b8:	eb 2d                	jmp    8023e7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023be:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023c2:	48 85 c0             	test   %rax,%rax
  8023c5:	75 07                	jne    8023ce <write+0xb9>
		return -E_NOT_SUPP;
  8023c7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023cc:	eb 19                	jmp    8023e7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023da:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023de:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e2:	48 89 cf             	mov    %rcx,%rdi
  8023e5:	ff d0                	callq  *%rax
}
  8023e7:	c9                   	leaveq 
  8023e8:	c3                   	retq   

00000000008023e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023e9:	55                   	push   %rbp
  8023ea:	48 89 e5             	mov    %rsp,%rbp
  8023ed:	48 83 ec 18          	sub    $0x18,%rsp
  8023f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023fe:	48 89 d6             	mov    %rdx,%rsi
  802401:	89 c7                	mov    %eax,%edi
  802403:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	callq  *%rax
  80240f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802412:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802416:	79 05                	jns    80241d <seek+0x34>
		return r;
  802418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241b:	eb 0f                	jmp    80242c <seek+0x43>
	fd->fd_offset = offset;
  80241d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802421:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802424:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	48 83 ec 30          	sub    $0x30,%rsp
  802436:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802439:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802440:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802443:	48 89 d6             	mov    %rdx,%rsi
  802446:	89 c7                	mov    %eax,%edi
  802448:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80244f:	00 00 00 
  802452:	ff d0                	callq  *%rax
  802454:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245b:	78 24                	js     802481 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802461:	8b 00                	mov    (%rax),%eax
  802463:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802467:	48 89 d6             	mov    %rdx,%rsi
  80246a:	89 c7                	mov    %eax,%edi
  80246c:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802473:	00 00 00 
  802476:	ff d0                	callq  *%rax
  802478:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247f:	79 05                	jns    802486 <ftruncate+0x58>
		return r;
  802481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802484:	eb 72                	jmp    8024f8 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248a:	8b 40 08             	mov    0x8(%rax),%eax
  80248d:	83 e0 03             	and    $0x3,%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	75 3a                	jne    8024ce <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802494:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80249b:	00 00 00 
  80249e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024aa:	89 c6                	mov    %eax,%esi
  8024ac:	48 bf d0 48 80 00 00 	movabs $0x8048d0,%rdi
  8024b3:	00 00 00 
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	48 b9 4f 05 80 00 00 	movabs $0x80054f,%rcx
  8024c2:	00 00 00 
  8024c5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024cc:	eb 2a                	jmp    8024f8 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	75 07                	jne    8024e2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e0:	eb 16                	jmp    8024f8 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ee:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024f1:	89 ce                	mov    %ecx,%esi
  8024f3:	48 89 d7             	mov    %rdx,%rdi
  8024f6:	ff d0                	callq  *%rax
}
  8024f8:	c9                   	leaveq 
  8024f9:	c3                   	retq   

00000000008024fa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024fa:	55                   	push   %rbp
  8024fb:	48 89 e5             	mov    %rsp,%rbp
  8024fe:	48 83 ec 30          	sub    $0x30,%rsp
  802502:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802505:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802509:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80250d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802510:	48 89 d6             	mov    %rdx,%rsi
  802513:	89 c7                	mov    %eax,%edi
  802515:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	callq  *%rax
  802521:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802524:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802528:	78 24                	js     80254e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80252a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252e:	8b 00                	mov    (%rax),%eax
  802530:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802534:	48 89 d6             	mov    %rdx,%rsi
  802537:	89 c7                	mov    %eax,%edi
  802539:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax
  802545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254c:	79 05                	jns    802553 <fstat+0x59>
		return r;
  80254e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802551:	eb 5e                	jmp    8025b1 <fstat+0xb7>
	if (!dev->dev_stat)
  802553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802557:	48 8b 40 28          	mov    0x28(%rax),%rax
  80255b:	48 85 c0             	test   %rax,%rax
  80255e:	75 07                	jne    802567 <fstat+0x6d>
		return -E_NOT_SUPP;
  802560:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802565:	eb 4a                	jmp    8025b1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802567:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80256b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80256e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802572:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802579:	00 00 00 
	stat->st_isdir = 0;
  80257c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802580:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802587:	00 00 00 
	stat->st_dev = dev;
  80258a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80258e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802592:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259d:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025a5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025a9:	48 89 ce             	mov    %rcx,%rsi
  8025ac:	48 89 d7             	mov    %rdx,%rdi
  8025af:	ff d0                	callq  *%rax
}
  8025b1:	c9                   	leaveq 
  8025b2:	c3                   	retq   

00000000008025b3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025b3:	55                   	push   %rbp
  8025b4:	48 89 e5             	mov    %rsp,%rbp
  8025b7:	48 83 ec 20          	sub    $0x20,%rsp
  8025bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c7:	be 00 00 00 00       	mov    $0x0,%esi
  8025cc:	48 89 c7             	mov    %rax,%rdi
  8025cf:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  8025d6:	00 00 00 
  8025d9:	ff d0                	callq  *%rax
  8025db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e2:	79 05                	jns    8025e9 <stat+0x36>
		return fd;
  8025e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e7:	eb 2f                	jmp    802618 <stat+0x65>
	r = fstat(fd, stat);
  8025e9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f0:	48 89 d6             	mov    %rdx,%rsi
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
  802601:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802607:	89 c7                	mov    %eax,%edi
  802609:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
	return r;
  802615:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802618:	c9                   	leaveq 
  802619:	c3                   	retq   

000000000080261a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80261a:	55                   	push   %rbp
  80261b:	48 89 e5             	mov    %rsp,%rbp
  80261e:	48 83 ec 10          	sub    $0x10,%rsp
  802622:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802625:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802629:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802630:	00 00 00 
  802633:	8b 00                	mov    (%rax),%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	75 1d                	jne    802656 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802639:	bf 01 00 00 00       	mov    $0x1,%edi
  80263e:	48 b8 3b 41 80 00 00 	movabs $0x80413b,%rax
  802645:	00 00 00 
  802648:	ff d0                	callq  *%rax
  80264a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802651:	00 00 00 
  802654:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802656:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80265d:	00 00 00 
  802660:	8b 00                	mov    (%rax),%eax
  802662:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802665:	b9 07 00 00 00       	mov    $0x7,%ecx
  80266a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802671:	00 00 00 
  802674:	89 c7                	mov    %eax,%edi
  802676:	48 b8 a3 40 80 00 00 	movabs $0x8040a3,%rax
  80267d:	00 00 00 
  802680:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802686:	ba 00 00 00 00       	mov    $0x0,%edx
  80268b:	48 89 c6             	mov    %rax,%rsi
  80268e:	bf 00 00 00 00       	mov    $0x0,%edi
  802693:	48 b8 e2 3f 80 00 00 	movabs $0x803fe2,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
}
  80269f:	c9                   	leaveq 
  8026a0:	c3                   	retq   

00000000008026a1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026a1:	55                   	push   %rbp
  8026a2:	48 89 e5             	mov    %rsp,%rbp
  8026a5:	48 83 ec 20          	sub    $0x20,%rsp
  8026a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ad:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8026b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b4:	48 89 c7             	mov    %rax,%rdi
  8026b7:	48 b8 ab 10 80 00 00 	movabs $0x8010ab,%rax
  8026be:	00 00 00 
  8026c1:	ff d0                	callq  *%rax
  8026c3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026c8:	7e 0a                	jle    8026d4 <open+0x33>
		return -E_BAD_PATH;
  8026ca:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026cf:	e9 a5 00 00 00       	jmpq   802779 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8026d4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026d8:	48 89 c7             	mov    %rax,%rdi
  8026db:	48 b8 01 1d 80 00 00 	movabs $0x801d01,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ee:	79 08                	jns    8026f8 <open+0x57>
		return r;
  8026f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f3:	e9 81 00 00 00       	jmpq   802779 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8026f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fc:	48 89 c6             	mov    %rax,%rsi
  8026ff:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802706:	00 00 00 
  802709:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  802710:	00 00 00 
  802713:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802715:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80271c:	00 00 00 
  80271f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802722:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272c:	48 89 c6             	mov    %rax,%rsi
  80272f:	bf 01 00 00 00       	mov    $0x1,%edi
  802734:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax
  802740:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802743:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802747:	79 1d                	jns    802766 <open+0xc5>
		fd_close(fd, 0);
  802749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274d:	be 00 00 00 00       	mov    $0x0,%esi
  802752:	48 89 c7             	mov    %rax,%rdi
  802755:	48 b8 29 1e 80 00 00 	movabs $0x801e29,%rax
  80275c:	00 00 00 
  80275f:	ff d0                	callq  *%rax
		return r;
  802761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802764:	eb 13                	jmp    802779 <open+0xd8>
	}

	return fd2num(fd);
  802766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276a:	48 89 c7             	mov    %rax,%rdi
  80276d:	48 b8 b3 1c 80 00 00 	movabs $0x801cb3,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802779:	c9                   	leaveq 
  80277a:	c3                   	retq   

000000000080277b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80277b:	55                   	push   %rbp
  80277c:	48 89 e5             	mov    %rsp,%rbp
  80277f:	48 83 ec 10          	sub    $0x10,%rsp
  802783:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80278b:	8b 50 0c             	mov    0xc(%rax),%edx
  80278e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802795:	00 00 00 
  802798:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80279a:	be 00 00 00 00       	mov    $0x0,%esi
  80279f:	bf 06 00 00 00       	mov    $0x6,%edi
  8027a4:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax
}
  8027b0:	c9                   	leaveq 
  8027b1:	c3                   	retq   

00000000008027b2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027b2:	55                   	push   %rbp
  8027b3:	48 89 e5             	mov    %rsp,%rbp
  8027b6:	48 83 ec 30          	sub    $0x30,%rsp
  8027ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ca:	8b 50 0c             	mov    0xc(%rax),%edx
  8027cd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027d4:	00 00 00 
  8027d7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027d9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027e0:	00 00 00 
  8027e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8027eb:	be 00 00 00 00       	mov    $0x0,%esi
  8027f0:	bf 03 00 00 00       	mov    $0x3,%edi
  8027f5:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	callq  *%rax
  802801:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802804:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802808:	79 08                	jns    802812 <devfile_read+0x60>
		return r;
  80280a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280d:	e9 a4 00 00 00       	jmpq   8028b6 <devfile_read+0x104>
	assert(r <= n);
  802812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802815:	48 98                	cltq   
  802817:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80281b:	76 35                	jbe    802852 <devfile_read+0xa0>
  80281d:	48 b9 fd 48 80 00 00 	movabs $0x8048fd,%rcx
  802824:	00 00 00 
  802827:	48 ba 04 49 80 00 00 	movabs $0x804904,%rdx
  80282e:	00 00 00 
  802831:	be 84 00 00 00       	mov    $0x84,%esi
  802836:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
  80283d:	00 00 00 
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
  802845:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  80284c:	00 00 00 
  80284f:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802852:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802859:	7e 35                	jle    802890 <devfile_read+0xde>
  80285b:	48 b9 24 49 80 00 00 	movabs $0x804924,%rcx
  802862:	00 00 00 
  802865:	48 ba 04 49 80 00 00 	movabs $0x804904,%rdx
  80286c:	00 00 00 
  80286f:	be 85 00 00 00       	mov    $0x85,%esi
  802874:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
  80287b:	00 00 00 
  80287e:	b8 00 00 00 00       	mov    $0x0,%eax
  802883:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  80288a:	00 00 00 
  80288d:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802893:	48 63 d0             	movslq %eax,%rdx
  802896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028a1:	00 00 00 
  8028a4:	48 89 c7             	mov    %rax,%rdi
  8028a7:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  8028ae:	00 00 00 
  8028b1:	ff d0                	callq  *%rax
	return r;
  8028b3:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8028b6:	c9                   	leaveq 
  8028b7:	c3                   	retq   

00000000008028b8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028b8:	55                   	push   %rbp
  8028b9:	48 89 e5             	mov    %rsp,%rbp
  8028bc:	48 83 ec 30          	sub    $0x30,%rsp
  8028c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028da:	00 00 00 
  8028dd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028df:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e6:	00 00 00 
  8028e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ed:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8028f1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028f8:	00 
  8028f9:	76 35                	jbe    802930 <devfile_write+0x78>
  8028fb:	48 b9 30 49 80 00 00 	movabs $0x804930,%rcx
  802902:	00 00 00 
  802905:	48 ba 04 49 80 00 00 	movabs $0x804904,%rdx
  80290c:	00 00 00 
  80290f:	be 9e 00 00 00       	mov    $0x9e,%esi
  802914:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
  80291b:	00 00 00 
  80291e:	b8 00 00 00 00       	mov    $0x0,%eax
  802923:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  80292a:	00 00 00 
  80292d:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802930:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802934:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802938:	48 89 c6             	mov    %rax,%rsi
  80293b:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802942:	00 00 00 
  802945:	48 b8 52 15 80 00 00 	movabs $0x801552,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802951:	be 00 00 00 00       	mov    $0x0,%esi
  802956:	bf 04 00 00 00       	mov    $0x4,%edi
  80295b:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802962:	00 00 00 
  802965:	ff d0                	callq  *%rax
  802967:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296e:	79 05                	jns    802975 <devfile_write+0xbd>
		return r;
  802970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802973:	eb 43                	jmp    8029b8 <devfile_write+0x100>
	assert(r <= n);
  802975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802978:	48 98                	cltq   
  80297a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80297e:	76 35                	jbe    8029b5 <devfile_write+0xfd>
  802980:	48 b9 fd 48 80 00 00 	movabs $0x8048fd,%rcx
  802987:	00 00 00 
  80298a:	48 ba 04 49 80 00 00 	movabs $0x804904,%rdx
  802991:	00 00 00 
  802994:	be a2 00 00 00       	mov    $0xa2,%esi
  802999:	48 bf 19 49 80 00 00 	movabs $0x804919,%rdi
  8029a0:	00 00 00 
  8029a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a8:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  8029af:	00 00 00 
  8029b2:	41 ff d0             	callq  *%r8
	return r;
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8029b8:	c9                   	leaveq 
  8029b9:	c3                   	retq   

00000000008029ba <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029ba:	55                   	push   %rbp
  8029bb:	48 89 e5             	mov    %rsp,%rbp
  8029be:	48 83 ec 20          	sub    $0x20,%rsp
  8029c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ce:	8b 50 0c             	mov    0xc(%rax),%edx
  8029d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d8:	00 00 00 
  8029db:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029dd:	be 00 00 00 00       	mov    $0x0,%esi
  8029e2:	bf 05 00 00 00       	mov    $0x5,%edi
  8029e7:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fa:	79 05                	jns    802a01 <devfile_stat+0x47>
		return r;
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ff:	eb 56                	jmp    802a57 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a05:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a0c:	00 00 00 
  802a0f:	48 89 c7             	mov    %rax,%rdi
  802a12:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a25:	00 00 00 
  802a28:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a32:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3f:	00 00 00 
  802a42:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a57:	c9                   	leaveq 
  802a58:	c3                   	retq   

0000000000802a59 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a59:	55                   	push   %rbp
  802a5a:	48 89 e5             	mov    %rsp,%rbp
  802a5d:	48 83 ec 10          	sub    $0x10,%rsp
  802a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a65:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a76:	00 00 00 
  802a79:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a82:	00 00 00 
  802a85:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a8b:	be 00 00 00 00       	mov    $0x0,%esi
  802a90:	bf 02 00 00 00       	mov    $0x2,%edi
  802a95:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	callq  *%rax
}
  802aa1:	c9                   	leaveq 
  802aa2:	c3                   	retq   

0000000000802aa3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802aa3:	55                   	push   %rbp
  802aa4:	48 89 e5             	mov    %rsp,%rbp
  802aa7:	48 83 ec 10          	sub    $0x10,%rsp
  802aab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab3:	48 89 c7             	mov    %rax,%rdi
  802ab6:	48 b8 ab 10 80 00 00 	movabs $0x8010ab,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
  802ac2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ac7:	7e 07                	jle    802ad0 <remove+0x2d>
		return -E_BAD_PATH;
  802ac9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ace:	eb 33                	jmp    802b03 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad4:	48 89 c6             	mov    %rax,%rsi
  802ad7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ade:	00 00 00 
  802ae1:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aed:	be 00 00 00 00       	mov    $0x0,%esi
  802af2:	bf 07 00 00 00       	mov    $0x7,%edi
  802af7:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802afe:	00 00 00 
  802b01:	ff d0                	callq  *%rax
}
  802b03:	c9                   	leaveq 
  802b04:	c3                   	retq   

0000000000802b05 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b09:	be 00 00 00 00       	mov    $0x0,%esi
  802b0e:	bf 08 00 00 00       	mov    $0x8,%edi
  802b13:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
}
  802b1f:	5d                   	pop    %rbp
  802b20:	c3                   	retq   

0000000000802b21 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b21:	55                   	push   %rbp
  802b22:	48 89 e5             	mov    %rsp,%rbp
  802b25:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b2c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b33:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b3a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b41:	be 00 00 00 00       	mov    $0x0,%esi
  802b46:	48 89 c7             	mov    %rax,%rdi
  802b49:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
  802b55:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5c:	79 28                	jns    802b86 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b61:	89 c6                	mov    %eax,%esi
  802b63:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  802b6a:	00 00 00 
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  802b79:	00 00 00 
  802b7c:	ff d2                	callq  *%rdx
		return fd_src;
  802b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b81:	e9 74 01 00 00       	jmpq   802cfa <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b86:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b8d:	be 01 01 00 00       	mov    $0x101,%esi
  802b92:	48 89 c7             	mov    %rax,%rdi
  802b95:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
  802ba1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ba4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ba8:	79 39                	jns    802be3 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802baa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bad:	89 c6                	mov    %eax,%esi
  802baf:	48 bf 73 49 80 00 00 	movabs $0x804973,%rdi
  802bb6:	00 00 00 
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbe:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  802bc5:	00 00 00 
  802bc8:	ff d2                	callq  *%rdx
		close(fd_src);
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcd:	89 c7                	mov    %eax,%edi
  802bcf:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
		return fd_dest;
  802bdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bde:	e9 17 01 00 00       	jmpq   802cfa <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802be3:	eb 74                	jmp    802c59 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802be5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802be8:	48 63 d0             	movslq %eax,%rdx
  802beb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bf2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf5:	48 89 ce             	mov    %rcx,%rsi
  802bf8:	89 c7                	mov    %eax,%edi
  802bfa:	48 b8 15 23 80 00 00 	movabs $0x802315,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
  802c06:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c0d:	79 4a                	jns    802c59 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c0f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c12:	89 c6                	mov    %eax,%esi
  802c14:	48 bf 8d 49 80 00 00 	movabs $0x80498d,%rdi
  802c1b:	00 00 00 
  802c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c23:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  802c2a:	00 00 00 
  802c2d:	ff d2                	callq  *%rdx
			close(fd_src);
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
			close(fd_dest);
  802c40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
			return write_size;
  802c51:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c54:	e9 a1 00 00 00       	jmpq   802cfa <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c59:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c63:	ba 00 02 00 00       	mov    $0x200,%edx
  802c68:	48 89 ce             	mov    %rcx,%rsi
  802c6b:	89 c7                	mov    %eax,%edi
  802c6d:	48 b8 cb 21 80 00 00 	movabs $0x8021cb,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c80:	0f 8f 5f ff ff ff    	jg     802be5 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c8a:	79 47                	jns    802cd3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c8f:	89 c6                	mov    %eax,%esi
  802c91:	48 bf a0 49 80 00 00 	movabs $0x8049a0,%rdi
  802c98:	00 00 00 
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	48 ba 4f 05 80 00 00 	movabs $0x80054f,%rdx
  802ca7:	00 00 00 
  802caa:	ff d2                	callq  *%rdx
		close(fd_src);
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caf:	89 c7                	mov    %eax,%edi
  802cb1:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
		close(fd_dest);
  802cbd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc0:	89 c7                	mov    %eax,%edi
  802cc2:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802cc9:	00 00 00 
  802ccc:	ff d0                	callq  *%rax
		return read_size;
  802cce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cd1:	eb 27                	jmp    802cfa <copy+0x1d9>
	}
	close(fd_src);
  802cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd6:	89 c7                	mov    %eax,%edi
  802cd8:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
	close(fd_dest);
  802ce4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce7:	89 c7                	mov    %eax,%edi
  802ce9:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802cf0:	00 00 00 
  802cf3:	ff d0                	callq  *%rax
	return 0;
  802cf5:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802cfa:	c9                   	leaveq 
  802cfb:	c3                   	retq   

0000000000802cfc <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802cfc:	55                   	push   %rbp
  802cfd:	48 89 e5             	mov    %rsp,%rbp
  802d00:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802d07:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802d0e:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802d15:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802d1c:	be 00 00 00 00       	mov    $0x0,%esi
  802d21:	48 89 c7             	mov    %rax,%rdi
  802d24:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
  802d30:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d33:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d37:	79 08                	jns    802d41 <spawn+0x45>
		return r;
  802d39:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d3c:	e9 14 03 00 00       	jmpq   803055 <spawn+0x359>
	fd = r;
  802d41:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d44:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802d47:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802d4e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802d52:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802d59:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d5c:	ba 00 02 00 00       	mov    $0x200,%edx
  802d61:	48 89 ce             	mov    %rcx,%rsi
  802d64:	89 c7                	mov    %eax,%edi
  802d66:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
  802d72:	3d 00 02 00 00       	cmp    $0x200,%eax
  802d77:	75 0d                	jne    802d86 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802d79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d7d:	8b 00                	mov    (%rax),%eax
  802d7f:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802d84:	74 43                	je     802dc9 <spawn+0xcd>
		close(fd);
  802d86:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d89:	89 c7                	mov    %eax,%edi
  802d8b:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802d97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d9b:	8b 00                	mov    (%rax),%eax
  802d9d:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802da2:	89 c6                	mov    %eax,%esi
  802da4:	48 bf b8 49 80 00 00 	movabs $0x8049b8,%rdi
  802dab:	00 00 00 
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	48 b9 4f 05 80 00 00 	movabs $0x80054f,%rcx
  802dba:	00 00 00 
  802dbd:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802dbf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802dc4:	e9 8c 02 00 00       	jmpq   803055 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802dc9:	b8 07 00 00 00       	mov    $0x7,%eax
  802dce:	cd 30                	int    $0x30
  802dd0:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802dd3:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802dd6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802dd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ddd:	79 08                	jns    802de7 <spawn+0xeb>
		return r;
  802ddf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802de2:	e9 6e 02 00 00       	jmpq   803055 <spawn+0x359>
	child = r;
  802de7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dea:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ded:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802df0:	25 ff 03 00 00       	and    $0x3ff,%eax
  802df5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802dfc:	00 00 00 
  802dff:	48 63 d0             	movslq %eax,%rdx
  802e02:	48 89 d0             	mov    %rdx,%rax
  802e05:	48 c1 e0 03          	shl    $0x3,%rax
  802e09:	48 01 d0             	add    %rdx,%rax
  802e0c:	48 c1 e0 05          	shl    $0x5,%rax
  802e10:	48 01 c8             	add    %rcx,%rax
  802e13:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e1a:	48 89 c6             	mov    %rax,%rsi
  802e1d:	b8 18 00 00 00       	mov    $0x18,%eax
  802e22:	48 89 d7             	mov    %rdx,%rdi
  802e25:	48 89 c1             	mov    %rax,%rcx
  802e28:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802e2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e2f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e33:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802e3a:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802e41:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802e48:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802e4f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e52:	48 89 ce             	mov    %rcx,%rsi
  802e55:	89 c7                	mov    %eax,%edi
  802e57:	48 b8 bf 32 80 00 00 	movabs $0x8032bf,%rax
  802e5e:	00 00 00 
  802e61:	ff d0                	callq  *%rax
  802e63:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e66:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e6a:	79 08                	jns    802e74 <spawn+0x178>
		return r;
  802e6c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e6f:	e9 e1 01 00 00       	jmpq   803055 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802e74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e78:	48 8b 40 20          	mov    0x20(%rax),%rax
  802e7c:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802e83:	48 01 d0             	add    %rdx,%rax
  802e86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e91:	e9 a3 00 00 00       	jmpq   802f39 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9a:	8b 00                	mov    (%rax),%eax
  802e9c:	83 f8 01             	cmp    $0x1,%eax
  802e9f:	74 05                	je     802ea6 <spawn+0x1aa>
			continue;
  802ea1:	e9 8a 00 00 00       	jmpq   802f30 <spawn+0x234>
		perm = PTE_P | PTE_U;
  802ea6:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb1:	8b 40 04             	mov    0x4(%rax),%eax
  802eb4:	83 e0 02             	and    $0x2,%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 04                	je     802ebf <spawn+0x1c3>
			perm |= PTE_W;
  802ebb:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec3:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802ec7:	41 89 c1             	mov    %eax,%r9d
  802eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ece:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed6:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ede:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802ee2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802ee5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ee8:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802eeb:	89 3c 24             	mov    %edi,(%rsp)
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 68 35 80 00 00 	movabs $0x803568,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802eff:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f03:	79 2b                	jns    802f30 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802f05:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802f06:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f09:	89 c7                	mov    %eax,%edi
  802f0b:	48 b8 86 19 80 00 00 	movabs $0x801986,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	callq  *%rax
	close(fd);
  802f17:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f1a:	89 c7                	mov    %eax,%edi
  802f1c:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802f23:	00 00 00 
  802f26:	ff d0                	callq  *%rax
	return r;
  802f28:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f2b:	e9 25 01 00 00       	jmpq   803055 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802f30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f34:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3d:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802f41:	0f b7 c0             	movzwl %ax,%eax
  802f44:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802f47:	0f 8f 49 ff ff ff    	jg     802e96 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802f4d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f50:	89 c7                	mov    %eax,%edi
  802f52:	48 b8 a9 1f 80 00 00 	movabs $0x801fa9,%rax
  802f59:	00 00 00 
  802f5c:	ff d0                	callq  *%rax
	fd = -1;
  802f5e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802f65:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f68:	89 c7                	mov    %eax,%edi
  802f6a:	48 b8 54 37 80 00 00 	movabs $0x803754,%rax
  802f71:	00 00 00 
  802f74:	ff d0                	callq  *%rax
  802f76:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f79:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f7d:	79 30                	jns    802faf <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802f7f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f82:	89 c1                	mov    %eax,%ecx
  802f84:	48 ba d2 49 80 00 00 	movabs $0x8049d2,%rdx
  802f8b:	00 00 00 
  802f8e:	be 82 00 00 00       	mov    $0x82,%esi
  802f93:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  802f9a:	00 00 00 
  802f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa2:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  802fa9:	00 00 00 
  802fac:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802faf:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802fb6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802fb9:	48 89 d6             	mov    %rdx,%rsi
  802fbc:	89 c7                	mov    %eax,%edi
  802fbe:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fcd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fd1:	79 30                	jns    803003 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802fd3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fd6:	89 c1                	mov    %eax,%ecx
  802fd8:	48 ba f4 49 80 00 00 	movabs $0x8049f4,%rdx
  802fdf:	00 00 00 
  802fe2:	be 85 00 00 00       	mov    $0x85,%esi
  802fe7:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  802fee:	00 00 00 
  802ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff6:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  802ffd:	00 00 00 
  803000:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803003:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803006:	be 02 00 00 00       	mov    $0x2,%esi
  80300b:	89 c7                	mov    %eax,%edi
  80300d:	48 b8 3b 1b 80 00 00 	movabs $0x801b3b,%rax
  803014:	00 00 00 
  803017:	ff d0                	callq  *%rax
  803019:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80301c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803020:	79 30                	jns    803052 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803022:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803025:	89 c1                	mov    %eax,%ecx
  803027:	48 ba 0e 4a 80 00 00 	movabs $0x804a0e,%rdx
  80302e:	00 00 00 
  803031:	be 88 00 00 00       	mov    $0x88,%esi
  803036:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  80303d:	00 00 00 
  803040:	b8 00 00 00 00       	mov    $0x0,%eax
  803045:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  80304c:	00 00 00 
  80304f:	41 ff d0             	callq  *%r8

	return child;
  803052:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803055:	c9                   	leaveq 
  803056:	c3                   	retq   

0000000000803057 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803057:	55                   	push   %rbp
  803058:	48 89 e5             	mov    %rsp,%rbp
  80305b:	41 55                	push   %r13
  80305d:	41 54                	push   %r12
  80305f:	53                   	push   %rbx
  803060:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803067:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  80306e:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803075:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  80307c:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803083:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80308a:	84 c0                	test   %al,%al
  80308c:	74 26                	je     8030b4 <spawnl+0x5d>
  80308e:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803095:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  80309c:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8030a0:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8030a4:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8030a8:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8030ac:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8030b0:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8030b4:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8030bb:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8030c2:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8030c5:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8030cc:	00 00 00 
  8030cf:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8030d6:	00 00 00 
  8030d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030dd:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030e4:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8030eb:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8030f2:	eb 07                	jmp    8030fb <spawnl+0xa4>
		argc++;
  8030f4:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8030fb:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803101:	83 f8 30             	cmp    $0x30,%eax
  803104:	73 23                	jae    803129 <spawnl+0xd2>
  803106:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80310d:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803113:	89 c0                	mov    %eax,%eax
  803115:	48 01 d0             	add    %rdx,%rax
  803118:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80311e:	83 c2 08             	add    $0x8,%edx
  803121:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803127:	eb 15                	jmp    80313e <spawnl+0xe7>
  803129:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803130:	48 89 d0             	mov    %rdx,%rax
  803133:	48 83 c2 08          	add    $0x8,%rdx
  803137:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80313e:	48 8b 00             	mov    (%rax),%rax
  803141:	48 85 c0             	test   %rax,%rax
  803144:	75 ae                	jne    8030f4 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803146:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80314c:	83 c0 02             	add    $0x2,%eax
  80314f:	48 89 e2             	mov    %rsp,%rdx
  803152:	48 89 d3             	mov    %rdx,%rbx
  803155:	48 63 d0             	movslq %eax,%rdx
  803158:	48 83 ea 01          	sub    $0x1,%rdx
  80315c:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803163:	48 63 d0             	movslq %eax,%rdx
  803166:	49 89 d4             	mov    %rdx,%r12
  803169:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80316f:	48 63 d0             	movslq %eax,%rdx
  803172:	49 89 d2             	mov    %rdx,%r10
  803175:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80317b:	48 98                	cltq   
  80317d:	48 c1 e0 03          	shl    $0x3,%rax
  803181:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803185:	b8 10 00 00 00       	mov    $0x10,%eax
  80318a:	48 83 e8 01          	sub    $0x1,%rax
  80318e:	48 01 d0             	add    %rdx,%rax
  803191:	bf 10 00 00 00       	mov    $0x10,%edi
  803196:	ba 00 00 00 00       	mov    $0x0,%edx
  80319b:	48 f7 f7             	div    %rdi
  80319e:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8031a2:	48 29 c4             	sub    %rax,%rsp
  8031a5:	48 89 e0             	mov    %rsp,%rax
  8031a8:	48 83 c0 07          	add    $0x7,%rax
  8031ac:	48 c1 e8 03          	shr    $0x3,%rax
  8031b0:	48 c1 e0 03          	shl    $0x3,%rax
  8031b4:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8031bb:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8031c2:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8031c9:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8031cc:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8031d2:	8d 50 01             	lea    0x1(%rax),%edx
  8031d5:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8031dc:	48 63 d2             	movslq %edx,%rdx
  8031df:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8031e6:	00 

	va_start(vl, arg0);
  8031e7:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8031ee:	00 00 00 
  8031f1:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8031f8:	00 00 00 
  8031fb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031ff:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803206:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80320d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803214:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80321b:	00 00 00 
  80321e:	eb 63                	jmp    803283 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803220:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803226:	8d 70 01             	lea    0x1(%rax),%esi
  803229:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80322f:	83 f8 30             	cmp    $0x30,%eax
  803232:	73 23                	jae    803257 <spawnl+0x200>
  803234:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80323b:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803241:	89 c0                	mov    %eax,%eax
  803243:	48 01 d0             	add    %rdx,%rax
  803246:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80324c:	83 c2 08             	add    $0x8,%edx
  80324f:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803255:	eb 15                	jmp    80326c <spawnl+0x215>
  803257:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80325e:	48 89 d0             	mov    %rdx,%rax
  803261:	48 83 c2 08          	add    $0x8,%rdx
  803265:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80326c:	48 8b 08             	mov    (%rax),%rcx
  80326f:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803276:	89 f2                	mov    %esi,%edx
  803278:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80327c:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803283:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803289:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80328f:	77 8f                	ja     803220 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803291:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803298:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80329f:	48 89 d6             	mov    %rdx,%rsi
  8032a2:	48 89 c7             	mov    %rax,%rdi
  8032a5:	48 b8 fc 2c 80 00 00 	movabs $0x802cfc,%rax
  8032ac:	00 00 00 
  8032af:	ff d0                	callq  *%rax
  8032b1:	48 89 dc             	mov    %rbx,%rsp
}
  8032b4:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8032b8:	5b                   	pop    %rbx
  8032b9:	41 5c                	pop    %r12
  8032bb:	41 5d                	pop    %r13
  8032bd:	5d                   	pop    %rbp
  8032be:	c3                   	retq   

00000000008032bf <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  8032bf:	55                   	push   %rbp
  8032c0:	48 89 e5             	mov    %rsp,%rbp
  8032c3:	48 83 ec 50          	sub    $0x50,%rsp
  8032c7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8032ca:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8032ce:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8032d2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032d9:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8032da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8032e1:	eb 33                	jmp    803316 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8032e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032e6:	48 98                	cltq   
  8032e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032ef:	00 
  8032f0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032f4:	48 01 d0             	add    %rdx,%rax
  8032f7:	48 8b 00             	mov    (%rax),%rax
  8032fa:	48 89 c7             	mov    %rax,%rdi
  8032fd:	48 b8 ab 10 80 00 00 	movabs $0x8010ab,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
  803309:	83 c0 01             	add    $0x1,%eax
  80330c:	48 98                	cltq   
  80330e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803312:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803316:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803319:	48 98                	cltq   
  80331b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803322:	00 
  803323:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803327:	48 01 d0             	add    %rdx,%rax
  80332a:	48 8b 00             	mov    (%rax),%rax
  80332d:	48 85 c0             	test   %rax,%rax
  803330:	75 b1                	jne    8032e3 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803336:	48 f7 d8             	neg    %rax
  803339:	48 05 00 10 40 00    	add    $0x401000,%rax
  80333f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803343:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803347:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80334b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334f:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803353:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803356:	83 c2 01             	add    $0x1,%edx
  803359:	c1 e2 03             	shl    $0x3,%edx
  80335c:	48 63 d2             	movslq %edx,%rdx
  80335f:	48 f7 da             	neg    %rdx
  803362:	48 01 d0             	add    %rdx,%rax
  803365:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803369:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336d:	48 83 e8 10          	sub    $0x10,%rax
  803371:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803377:	77 0a                	ja     803383 <init_stack+0xc4>
		return -E_NO_MEM;
  803379:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80337e:	e9 e3 01 00 00       	jmpq   803566 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803383:	ba 07 00 00 00       	mov    $0x7,%edx
  803388:	be 00 00 40 00       	mov    $0x400000,%esi
  80338d:	bf 00 00 00 00       	mov    $0x0,%edi
  803392:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
  80339e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a5:	79 08                	jns    8033af <init_stack+0xf0>
		return r;
  8033a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033aa:	e9 b7 01 00 00       	jmpq   803566 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8033af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8033b6:	e9 8a 00 00 00       	jmpq   803445 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8033bb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033be:	48 98                	cltq   
  8033c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033c7:	00 
  8033c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033cc:	48 01 c2             	add    %rax,%rdx
  8033cf:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d8:	48 01 c8             	add    %rcx,%rax
  8033db:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033e1:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8033e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033e7:	48 98                	cltq   
  8033e9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033f0:	00 
  8033f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033f5:	48 01 d0             	add    %rdx,%rax
  8033f8:	48 8b 10             	mov    (%rax),%rdx
  8033fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ff:	48 89 d6             	mov    %rdx,%rsi
  803402:	48 89 c7             	mov    %rax,%rdi
  803405:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803411:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803414:	48 98                	cltq   
  803416:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80341d:	00 
  80341e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803422:	48 01 d0             	add    %rdx,%rax
  803425:	48 8b 00             	mov    (%rax),%rax
  803428:	48 89 c7             	mov    %rax,%rdi
  80342b:	48 b8 ab 10 80 00 00 	movabs $0x8010ab,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
  803437:	48 98                	cltq   
  803439:	48 83 c0 01          	add    $0x1,%rax
  80343d:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803441:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803445:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803448:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80344b:	0f 8c 6a ff ff ff    	jl     8033bb <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803451:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803454:	48 98                	cltq   
  803456:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80345d:	00 
  80345e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803462:	48 01 d0             	add    %rdx,%rax
  803465:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80346c:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803473:	00 
  803474:	74 35                	je     8034ab <init_stack+0x1ec>
  803476:	48 b9 28 4a 80 00 00 	movabs $0x804a28,%rcx
  80347d:	00 00 00 
  803480:	48 ba 4e 4a 80 00 00 	movabs $0x804a4e,%rdx
  803487:	00 00 00 
  80348a:	be f1 00 00 00       	mov    $0xf1,%esi
  80348f:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  803496:	00 00 00 
  803499:	b8 00 00 00 00       	mov    $0x0,%eax
  80349e:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  8034a5:	00 00 00 
  8034a8:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8034ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034af:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8034b3:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8034b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034bc:	48 01 c8             	add    %rcx,%rax
  8034bf:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8034c5:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8034c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034cc:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8034d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034d3:	48 98                	cltq   
  8034d5:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  8034d8:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8034dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e1:	48 01 d0             	add    %rdx,%rax
  8034e4:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8034ea:	48 89 c2             	mov    %rax,%rdx
  8034ed:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8034f1:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8034f4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8034f7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8034fd:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803502:	89 c2                	mov    %eax,%edx
  803504:	be 00 00 40 00       	mov    $0x400000,%esi
  803509:	bf 00 00 00 00       	mov    $0x0,%edi
  80350e:	48 b8 96 1a 80 00 00 	movabs $0x801a96,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
  80351a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80351d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803521:	79 02                	jns    803525 <init_stack+0x266>
		goto error;
  803523:	eb 28                	jmp    80354d <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803525:	be 00 00 40 00       	mov    $0x400000,%esi
  80352a:	bf 00 00 00 00       	mov    $0x0,%edi
  80352f:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
  80353b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80353e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803542:	79 02                	jns    803546 <init_stack+0x287>
		goto error;
  803544:	eb 07                	jmp    80354d <init_stack+0x28e>

	return 0;
  803546:	b8 00 00 00 00       	mov    $0x0,%eax
  80354b:	eb 19                	jmp    803566 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80354d:	be 00 00 40 00       	mov    $0x400000,%esi
  803552:	bf 00 00 00 00       	mov    $0x0,%edi
  803557:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  80355e:	00 00 00 
  803561:	ff d0                	callq  *%rax
	return r;
  803563:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803566:	c9                   	leaveq 
  803567:	c3                   	retq   

0000000000803568 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803568:	55                   	push   %rbp
  803569:	48 89 e5             	mov    %rsp,%rbp
  80356c:	48 83 ec 50          	sub    $0x50,%rsp
  803570:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803573:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803577:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80357b:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80357e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803582:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803586:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80358a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80358f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803596:	74 21                	je     8035b9 <map_segment+0x51>
		va -= i;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359b:	48 98                	cltq   
  80359d:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	48 98                	cltq   
  8035a6:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8035aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ad:	48 98                	cltq   
  8035af:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8035b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b6:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8035b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035c0:	e9 79 01 00 00       	jmpq   80373e <map_segment+0x1d6>
		if (i >= filesz) {
  8035c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c8:	48 98                	cltq   
  8035ca:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8035ce:	72 3c                	jb     80360c <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8035d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d3:	48 63 d0             	movslq %eax,%rdx
  8035d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035da:	48 01 d0             	add    %rdx,%rax
  8035dd:	48 89 c1             	mov    %rax,%rcx
  8035e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035e3:	8b 55 10             	mov    0x10(%rbp),%edx
  8035e6:	48 89 ce             	mov    %rcx,%rsi
  8035e9:	89 c7                	mov    %eax,%edi
  8035eb:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
  8035f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035fa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035fe:	0f 89 33 01 00 00    	jns    803737 <map_segment+0x1cf>
				return r;
  803604:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803607:	e9 46 01 00 00       	jmpq   803752 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80360c:	ba 07 00 00 00       	mov    $0x7,%edx
  803611:	be 00 00 40 00       	mov    $0x400000,%esi
  803616:	bf 00 00 00 00       	mov    $0x0,%edi
  80361b:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
  803627:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80362a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80362e:	79 08                	jns    803638 <map_segment+0xd0>
				return r;
  803630:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803633:	e9 1a 01 00 00       	jmpq   803752 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80363e:	01 c2                	add    %eax,%edx
  803640:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803643:	89 d6                	mov    %edx,%esi
  803645:	89 c7                	mov    %eax,%edi
  803647:	48 b8 e9 23 80 00 00 	movabs $0x8023e9,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
  803653:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803656:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80365a:	79 08                	jns    803664 <map_segment+0xfc>
				return r;
  80365c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80365f:	e9 ee 00 00 00       	jmpq   803752 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803664:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80366b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366e:	48 98                	cltq   
  803670:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803674:	48 29 c2             	sub    %rax,%rdx
  803677:	48 89 d0             	mov    %rdx,%rax
  80367a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80367e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803681:	48 63 d0             	movslq %eax,%rdx
  803684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803688:	48 39 c2             	cmp    %rax,%rdx
  80368b:	48 0f 47 d0          	cmova  %rax,%rdx
  80368f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803692:	be 00 00 40 00       	mov    $0x400000,%esi
  803697:	89 c7                	mov    %eax,%edi
  803699:	48 b8 a0 22 80 00 00 	movabs $0x8022a0,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
  8036a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036ac:	79 08                	jns    8036b6 <map_segment+0x14e>
				return r;
  8036ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b1:	e9 9c 00 00 00       	jmpq   803752 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8036b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b9:	48 63 d0             	movslq %eax,%rdx
  8036bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c0:	48 01 d0             	add    %rdx,%rax
  8036c3:	48 89 c2             	mov    %rax,%rdx
  8036c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036c9:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8036cd:	48 89 d1             	mov    %rdx,%rcx
  8036d0:	89 c2                	mov    %eax,%edx
  8036d2:	be 00 00 40 00       	mov    $0x400000,%esi
  8036d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036dc:	48 b8 96 1a 80 00 00 	movabs $0x801a96,%rax
  8036e3:	00 00 00 
  8036e6:	ff d0                	callq  *%rax
  8036e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036ef:	79 30                	jns    803721 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8036f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f4:	89 c1                	mov    %eax,%ecx
  8036f6:	48 ba 63 4a 80 00 00 	movabs $0x804a63,%rdx
  8036fd:	00 00 00 
  803700:	be 24 01 00 00       	mov    $0x124,%esi
  803705:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  80370c:	00 00 00 
  80370f:	b8 00 00 00 00       	mov    $0x0,%eax
  803714:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  80371b:	00 00 00 
  80371e:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803721:	be 00 00 40 00       	mov    $0x400000,%esi
  803726:	bf 00 00 00 00       	mov    $0x0,%edi
  80372b:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803732:	00 00 00 
  803735:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803737:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80373e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803741:	48 98                	cltq   
  803743:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803747:	0f 82 78 fe ff ff    	jb     8035c5 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80374d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803752:	c9                   	leaveq 
  803753:	c3                   	retq   

0000000000803754 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803754:	55                   	push   %rbp
  803755:	48 89 e5             	mov    %rsp,%rbp
  803758:	48 83 ec 04          	sub    $0x4,%rsp
  80375c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  80375f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803764:	c9                   	leaveq 
  803765:	c3                   	retq   

0000000000803766 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803766:	55                   	push   %rbp
  803767:	48 89 e5             	mov    %rsp,%rbp
  80376a:	53                   	push   %rbx
  80376b:	48 83 ec 38          	sub    $0x38,%rsp
  80376f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803773:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803777:	48 89 c7             	mov    %rax,%rdi
  80377a:	48 b8 01 1d 80 00 00 	movabs $0x801d01,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
  803786:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803789:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80378d:	0f 88 bf 01 00 00    	js     803952 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803797:	ba 07 04 00 00       	mov    $0x407,%edx
  80379c:	48 89 c6             	mov    %rax,%rsi
  80379f:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a4:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
  8037b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b7:	0f 88 95 01 00 00    	js     803952 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037bd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037c1:	48 89 c7             	mov    %rax,%rdi
  8037c4:	48 b8 01 1d 80 00 00 	movabs $0x801d01,%rax
  8037cb:	00 00 00 
  8037ce:	ff d0                	callq  *%rax
  8037d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037d7:	0f 88 5d 01 00 00    	js     80393a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e1:	ba 07 04 00 00       	mov    $0x407,%edx
  8037e6:	48 89 c6             	mov    %rax,%rsi
  8037e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ee:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
  8037fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803801:	0f 88 33 01 00 00    	js     80393a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380b:	48 89 c7             	mov    %rax,%rdi
  80380e:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803815:	00 00 00 
  803818:	ff d0                	callq  *%rax
  80381a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80381e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803822:	ba 07 04 00 00       	mov    $0x407,%edx
  803827:	48 89 c6             	mov    %rax,%rsi
  80382a:	bf 00 00 00 00       	mov    $0x0,%edi
  80382f:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80383e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803842:	79 05                	jns    803849 <pipe+0xe3>
		goto err2;
  803844:	e9 d9 00 00 00       	jmpq   803922 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803849:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80384d:	48 89 c7             	mov    %rax,%rdi
  803850:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
  80385c:	48 89 c2             	mov    %rax,%rdx
  80385f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803863:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803869:	48 89 d1             	mov    %rdx,%rcx
  80386c:	ba 00 00 00 00       	mov    $0x0,%edx
  803871:	48 89 c6             	mov    %rax,%rsi
  803874:	bf 00 00 00 00       	mov    $0x0,%edi
  803879:	48 b8 96 1a 80 00 00 	movabs $0x801a96,%rax
  803880:	00 00 00 
  803883:	ff d0                	callq  *%rax
  803885:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803888:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80388c:	79 1b                	jns    8038a9 <pipe+0x143>
		goto err3;
  80388e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80388f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803893:	48 89 c6             	mov    %rax,%rsi
  803896:	bf 00 00 00 00       	mov    $0x0,%edi
  80389b:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  8038a2:	00 00 00 
  8038a5:	ff d0                	callq  *%rax
  8038a7:	eb 79                	jmp    803922 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8038a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ad:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8038b4:	00 00 00 
  8038b7:	8b 12                	mov    (%rdx),%edx
  8038b9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8038bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038ca:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8038d1:	00 00 00 
  8038d4:	8b 12                	mov    (%rdx),%edx
  8038d6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038dc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e7:	48 89 c7             	mov    %rax,%rdi
  8038ea:	48 b8 b3 1c 80 00 00 	movabs $0x801cb3,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
  8038f6:	89 c2                	mov    %eax,%edx
  8038f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038fc:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8038fe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803902:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803906:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80390a:	48 89 c7             	mov    %rax,%rdi
  80390d:	48 b8 b3 1c 80 00 00 	movabs $0x801cb3,%rax
  803914:	00 00 00 
  803917:	ff d0                	callq  *%rax
  803919:	89 03                	mov    %eax,(%rbx)
	return 0;
  80391b:	b8 00 00 00 00       	mov    $0x0,%eax
  803920:	eb 33                	jmp    803955 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803922:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803926:	48 89 c6             	mov    %rax,%rsi
  803929:	bf 00 00 00 00       	mov    $0x0,%edi
  80392e:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803935:	00 00 00 
  803938:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80393a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393e:	48 89 c6             	mov    %rax,%rsi
  803941:	bf 00 00 00 00       	mov    $0x0,%edi
  803946:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
err:
	return r;
  803952:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803955:	48 83 c4 38          	add    $0x38,%rsp
  803959:	5b                   	pop    %rbx
  80395a:	5d                   	pop    %rbp
  80395b:	c3                   	retq   

000000000080395c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80395c:	55                   	push   %rbp
  80395d:	48 89 e5             	mov    %rsp,%rbp
  803960:	53                   	push   %rbx
  803961:	48 83 ec 28          	sub    $0x28,%rsp
  803965:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803969:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80396d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803974:	00 00 00 
  803977:	48 8b 00             	mov    (%rax),%rax
  80397a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803980:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803983:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803987:	48 89 c7             	mov    %rax,%rdi
  80398a:	48 b8 bd 41 80 00 00 	movabs $0x8041bd,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	89 c3                	mov    %eax,%ebx
  803998:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80399c:	48 89 c7             	mov    %rax,%rdi
  80399f:	48 b8 bd 41 80 00 00 	movabs $0x8041bd,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
  8039ab:	39 c3                	cmp    %eax,%ebx
  8039ad:	0f 94 c0             	sete   %al
  8039b0:	0f b6 c0             	movzbl %al,%eax
  8039b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039b6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039bd:	00 00 00 
  8039c0:	48 8b 00             	mov    (%rax),%rax
  8039c3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039c9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039cf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039d2:	75 05                	jne    8039d9 <_pipeisclosed+0x7d>
			return ret;
  8039d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039d7:	eb 4f                	jmp    803a28 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8039d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039dc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039df:	74 42                	je     803a23 <_pipeisclosed+0xc7>
  8039e1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039e5:	75 3c                	jne    803a23 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039e7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039ee:	00 00 00 
  8039f1:	48 8b 00             	mov    (%rax),%rax
  8039f4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8039fa:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a00:	89 c6                	mov    %eax,%esi
  803a02:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  803a09:	00 00 00 
  803a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a11:	49 b8 4f 05 80 00 00 	movabs $0x80054f,%r8
  803a18:	00 00 00 
  803a1b:	41 ff d0             	callq  *%r8
	}
  803a1e:	e9 4a ff ff ff       	jmpq   80396d <_pipeisclosed+0x11>
  803a23:	e9 45 ff ff ff       	jmpq   80396d <_pipeisclosed+0x11>
}
  803a28:	48 83 c4 28          	add    $0x28,%rsp
  803a2c:	5b                   	pop    %rbx
  803a2d:	5d                   	pop    %rbp
  803a2e:	c3                   	retq   

0000000000803a2f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a2f:	55                   	push   %rbp
  803a30:	48 89 e5             	mov    %rsp,%rbp
  803a33:	48 83 ec 30          	sub    $0x30,%rsp
  803a37:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a41:	48 89 d6             	mov    %rdx,%rsi
  803a44:	89 c7                	mov    %eax,%edi
  803a46:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
  803a52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a59:	79 05                	jns    803a60 <pipeisclosed+0x31>
		return r;
  803a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5e:	eb 31                	jmp    803a91 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a64:	48 89 c7             	mov    %rax,%rdi
  803a67:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
  803a73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a7f:	48 89 d6             	mov    %rdx,%rsi
  803a82:	48 89 c7             	mov    %rax,%rdi
  803a85:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   

0000000000803a93 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a93:	55                   	push   %rbp
  803a94:	48 89 e5             	mov    %rsp,%rbp
  803a97:	48 83 ec 40          	sub    $0x40,%rsp
  803a9b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aa3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803aa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aab:	48 89 c7             	mov    %rax,%rdi
  803aae:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
  803aba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803abe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ac6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803acd:	00 
  803ace:	e9 92 00 00 00       	jmpq   803b65 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803ad3:	eb 41                	jmp    803b16 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ad5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ada:	74 09                	je     803ae5 <devpipe_read+0x52>
				return i;
  803adc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae0:	e9 92 00 00 00       	jmpq   803b77 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ae5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aed:	48 89 d6             	mov    %rdx,%rsi
  803af0:	48 89 c7             	mov    %rax,%rdi
  803af3:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
  803aff:	85 c0                	test   %eax,%eax
  803b01:	74 07                	je     803b0a <devpipe_read+0x77>
				return 0;
  803b03:	b8 00 00 00 00       	mov    $0x0,%eax
  803b08:	eb 6d                	jmp    803b77 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b0a:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1a:	8b 10                	mov    (%rax),%edx
  803b1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b20:	8b 40 04             	mov    0x4(%rax),%eax
  803b23:	39 c2                	cmp    %eax,%edx
  803b25:	74 ae                	je     803ad5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b2f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b37:	8b 00                	mov    (%rax),%eax
  803b39:	99                   	cltd   
  803b3a:	c1 ea 1b             	shr    $0x1b,%edx
  803b3d:	01 d0                	add    %edx,%eax
  803b3f:	83 e0 1f             	and    $0x1f,%eax
  803b42:	29 d0                	sub    %edx,%eax
  803b44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b48:	48 98                	cltq   
  803b4a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b4f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b55:	8b 00                	mov    (%rax),%eax
  803b57:	8d 50 01             	lea    0x1(%rax),%edx
  803b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b60:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b69:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b6d:	0f 82 60 ff ff ff    	jb     803ad3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b77:	c9                   	leaveq 
  803b78:	c3                   	retq   

0000000000803b79 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b79:	55                   	push   %rbp
  803b7a:	48 89 e5             	mov    %rsp,%rbp
  803b7d:	48 83 ec 40          	sub    $0x40,%rsp
  803b81:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b85:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b89:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b91:	48 89 c7             	mov    %rax,%rdi
  803b94:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
  803ba0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ba4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bb3:	00 
  803bb4:	e9 8e 00 00 00       	jmpq   803c47 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bb9:	eb 31                	jmp    803bec <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803bbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc3:	48 89 d6             	mov    %rdx,%rsi
  803bc6:	48 89 c7             	mov    %rax,%rdi
  803bc9:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  803bd0:	00 00 00 
  803bd3:	ff d0                	callq  *%rax
  803bd5:	85 c0                	test   %eax,%eax
  803bd7:	74 07                	je     803be0 <devpipe_write+0x67>
				return 0;
  803bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bde:	eb 79                	jmp    803c59 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803be0:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  803be7:	00 00 00 
  803bea:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf0:	8b 40 04             	mov    0x4(%rax),%eax
  803bf3:	48 63 d0             	movslq %eax,%rdx
  803bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfa:	8b 00                	mov    (%rax),%eax
  803bfc:	48 98                	cltq   
  803bfe:	48 83 c0 20          	add    $0x20,%rax
  803c02:	48 39 c2             	cmp    %rax,%rdx
  803c05:	73 b4                	jae    803bbb <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0b:	8b 40 04             	mov    0x4(%rax),%eax
  803c0e:	99                   	cltd   
  803c0f:	c1 ea 1b             	shr    $0x1b,%edx
  803c12:	01 d0                	add    %edx,%eax
  803c14:	83 e0 1f             	and    $0x1f,%eax
  803c17:	29 d0                	sub    %edx,%eax
  803c19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c21:	48 01 ca             	add    %rcx,%rdx
  803c24:	0f b6 0a             	movzbl (%rdx),%ecx
  803c27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c2b:	48 98                	cltq   
  803c2d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c35:	8b 40 04             	mov    0x4(%rax),%eax
  803c38:	8d 50 01             	lea    0x1(%rax),%edx
  803c3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c42:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c4b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c4f:	0f 82 64 ff ff ff    	jb     803bb9 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c59:	c9                   	leaveq 
  803c5a:	c3                   	retq   

0000000000803c5b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c5b:	55                   	push   %rbp
  803c5c:	48 89 e5             	mov    %rsp,%rbp
  803c5f:	48 83 ec 20          	sub    $0x20,%rsp
  803c63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c6f:	48 89 c7             	mov    %rax,%rdi
  803c72:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
  803c7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c86:	48 be 98 4a 80 00 00 	movabs $0x804a98,%rsi
  803c8d:	00 00 00 
  803c90:	48 89 c7             	mov    %rax,%rdi
  803c93:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca3:	8b 50 04             	mov    0x4(%rax),%edx
  803ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803caa:	8b 00                	mov    (%rax),%eax
  803cac:	29 c2                	sub    %eax,%edx
  803cae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cb2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803cc3:	00 00 00 
	stat->st_dev = &devpipe;
  803cc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cca:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803cd1:	00 00 00 
  803cd4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ce0:	c9                   	leaveq 
  803ce1:	c3                   	retq   

0000000000803ce2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ce2:	55                   	push   %rbp
  803ce3:	48 89 e5             	mov    %rsp,%rbp
  803ce6:	48 83 ec 10          	sub    $0x10,%rsp
  803cea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803cee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf2:	48 89 c6             	mov    %rax,%rsi
  803cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  803cfa:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d0a:	48 89 c7             	mov    %rax,%rdi
  803d0d:	48 b8 d6 1c 80 00 00 	movabs $0x801cd6,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	callq  *%rax
  803d19:	48 89 c6             	mov    %rax,%rsi
  803d1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d21:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
}
  803d2d:	c9                   	leaveq 
  803d2e:	c3                   	retq   

0000000000803d2f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d2f:	55                   	push   %rbp
  803d30:	48 89 e5             	mov    %rsp,%rbp
  803d33:	48 83 ec 20          	sub    $0x20,%rsp
  803d37:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d3d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d40:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d44:	be 01 00 00 00       	mov    $0x1,%esi
  803d49:	48 89 c7             	mov    %rax,%rdi
  803d4c:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  803d53:	00 00 00 
  803d56:	ff d0                	callq  *%rax
}
  803d58:	c9                   	leaveq 
  803d59:	c3                   	retq   

0000000000803d5a <getchar>:

int
getchar(void)
{
  803d5a:	55                   	push   %rbp
  803d5b:	48 89 e5             	mov    %rsp,%rbp
  803d5e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d62:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d66:	ba 01 00 00 00       	mov    $0x1,%edx
  803d6b:	48 89 c6             	mov    %rax,%rsi
  803d6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d73:	48 b8 cb 21 80 00 00 	movabs $0x8021cb,%rax
  803d7a:	00 00 00 
  803d7d:	ff d0                	callq  *%rax
  803d7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d86:	79 05                	jns    803d8d <getchar+0x33>
		return r;
  803d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8b:	eb 14                	jmp    803da1 <getchar+0x47>
	if (r < 1)
  803d8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d91:	7f 07                	jg     803d9a <getchar+0x40>
		return -E_EOF;
  803d93:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d98:	eb 07                	jmp    803da1 <getchar+0x47>
	return c;
  803d9a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d9e:	0f b6 c0             	movzbl %al,%eax
}
  803da1:	c9                   	leaveq 
  803da2:	c3                   	retq   

0000000000803da3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803da3:	55                   	push   %rbp
  803da4:	48 89 e5             	mov    %rsp,%rbp
  803da7:	48 83 ec 20          	sub    $0x20,%rsp
  803dab:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803db2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803db5:	48 89 d6             	mov    %rdx,%rsi
  803db8:	89 c7                	mov    %eax,%edi
  803dba:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803dc1:	00 00 00 
  803dc4:	ff d0                	callq  *%rax
  803dc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dcd:	79 05                	jns    803dd4 <iscons+0x31>
		return r;
  803dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd2:	eb 1a                	jmp    803dee <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd8:	8b 10                	mov    (%rax),%edx
  803dda:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803de1:	00 00 00 
  803de4:	8b 00                	mov    (%rax),%eax
  803de6:	39 c2                	cmp    %eax,%edx
  803de8:	0f 94 c0             	sete   %al
  803deb:	0f b6 c0             	movzbl %al,%eax
}
  803dee:	c9                   	leaveq 
  803def:	c3                   	retq   

0000000000803df0 <opencons>:

int
opencons(void)
{
  803df0:	55                   	push   %rbp
  803df1:	48 89 e5             	mov    %rsp,%rbp
  803df4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803df8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803dfc:	48 89 c7             	mov    %rax,%rdi
  803dff:	48 b8 01 1d 80 00 00 	movabs $0x801d01,%rax
  803e06:	00 00 00 
  803e09:	ff d0                	callq  *%rax
  803e0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e12:	79 05                	jns    803e19 <opencons+0x29>
		return r;
  803e14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e17:	eb 5b                	jmp    803e74 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1d:	ba 07 04 00 00       	mov    $0x407,%edx
  803e22:	48 89 c6             	mov    %rax,%rsi
  803e25:	bf 00 00 00 00       	mov    $0x0,%edi
  803e2a:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  803e31:	00 00 00 
  803e34:	ff d0                	callq  *%rax
  803e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e3d:	79 05                	jns    803e44 <opencons+0x54>
		return r;
  803e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e42:	eb 30                	jmp    803e74 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e48:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803e4f:	00 00 00 
  803e52:	8b 12                	mov    (%rdx),%edx
  803e54:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e65:	48 89 c7             	mov    %rax,%rdi
  803e68:	48 b8 b3 1c 80 00 00 	movabs $0x801cb3,%rax
  803e6f:	00 00 00 
  803e72:	ff d0                	callq  *%rax
}
  803e74:	c9                   	leaveq 
  803e75:	c3                   	retq   

0000000000803e76 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e76:	55                   	push   %rbp
  803e77:	48 89 e5             	mov    %rsp,%rbp
  803e7a:	48 83 ec 30          	sub    $0x30,%rsp
  803e7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e86:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e8a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e8f:	75 07                	jne    803e98 <devcons_read+0x22>
		return 0;
  803e91:	b8 00 00 00 00       	mov    $0x0,%eax
  803e96:	eb 4b                	jmp    803ee3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803e98:	eb 0c                	jmp    803ea6 <devcons_read+0x30>
		sys_yield();
  803e9a:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  803ea1:	00 00 00 
  803ea4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803ea6:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  803ead:	00 00 00 
  803eb0:	ff d0                	callq  *%rax
  803eb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb9:	74 df                	je     803e9a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803ebb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebf:	79 05                	jns    803ec6 <devcons_read+0x50>
		return c;
  803ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec4:	eb 1d                	jmp    803ee3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803ec6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803eca:	75 07                	jne    803ed3 <devcons_read+0x5d>
		return 0;
  803ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed1:	eb 10                	jmp    803ee3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed6:	89 c2                	mov    %eax,%edx
  803ed8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803edc:	88 10                	mov    %dl,(%rax)
	return 1;
  803ede:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ee3:	c9                   	leaveq 
  803ee4:	c3                   	retq   

0000000000803ee5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ee5:	55                   	push   %rbp
  803ee6:	48 89 e5             	mov    %rsp,%rbp
  803ee9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ef0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ef7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803efe:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f0c:	eb 76                	jmp    803f84 <devcons_write+0x9f>
		m = n - tot;
  803f0e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f15:	89 c2                	mov    %eax,%edx
  803f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1a:	29 c2                	sub    %eax,%edx
  803f1c:	89 d0                	mov    %edx,%eax
  803f1e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f24:	83 f8 7f             	cmp    $0x7f,%eax
  803f27:	76 07                	jbe    803f30 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f29:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f33:	48 63 d0             	movslq %eax,%rdx
  803f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f39:	48 63 c8             	movslq %eax,%rcx
  803f3c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f43:	48 01 c1             	add    %rax,%rcx
  803f46:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f4d:	48 89 ce             	mov    %rcx,%rsi
  803f50:	48 89 c7             	mov    %rax,%rdi
  803f53:	48 b8 3b 14 80 00 00 	movabs $0x80143b,%rax
  803f5a:	00 00 00 
  803f5d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f62:	48 63 d0             	movslq %eax,%rdx
  803f65:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f6c:	48 89 d6             	mov    %rdx,%rsi
  803f6f:	48 89 c7             	mov    %rax,%rdi
  803f72:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  803f79:	00 00 00 
  803f7c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f81:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f87:	48 98                	cltq   
  803f89:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f90:	0f 82 78 ff ff ff    	jb     803f0e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f99:	c9                   	leaveq 
  803f9a:	c3                   	retq   

0000000000803f9b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f9b:	55                   	push   %rbp
  803f9c:	48 89 e5             	mov    %rsp,%rbp
  803f9f:	48 83 ec 08          	sub    $0x8,%rsp
  803fa3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fac:	c9                   	leaveq 
  803fad:	c3                   	retq   

0000000000803fae <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fae:	55                   	push   %rbp
  803faf:	48 89 e5             	mov    %rsp,%rbp
  803fb2:	48 83 ec 10          	sub    $0x10,%rsp
  803fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc2:	48 be a4 4a 80 00 00 	movabs $0x804aa4,%rsi
  803fc9:	00 00 00 
  803fcc:	48 89 c7             	mov    %rax,%rdi
  803fcf:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  803fd6:	00 00 00 
  803fd9:	ff d0                	callq  *%rax
	return 0;
  803fdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fe0:	c9                   	leaveq 
  803fe1:	c3                   	retq   

0000000000803fe2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803fe2:	55                   	push   %rbp
  803fe3:	48 89 e5             	mov    %rsp,%rbp
  803fe6:	48 83 ec 30          	sub    $0x30,%rsp
  803fea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ff2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803ff6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ffb:	75 0e                	jne    80400b <ipc_recv+0x29>
        pg = (void *)UTOP;
  803ffd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804004:	00 00 00 
  804007:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  80400b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400f:	48 89 c7             	mov    %rax,%rdi
  804012:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804019:	00 00 00 
  80401c:	ff d0                	callq  *%rax
  80401e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804021:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804025:	79 27                	jns    80404e <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  804027:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80402c:	74 0a                	je     804038 <ipc_recv+0x56>
            *from_env_store = 0;
  80402e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804032:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  804038:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80403d:	74 0a                	je     804049 <ipc_recv+0x67>
            *perm_store = 0;
  80403f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804043:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  804049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404c:	eb 53                	jmp    8040a1 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  80404e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804053:	74 19                	je     80406e <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  804055:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80405c:	00 00 00 
  80405f:	48 8b 00             	mov    (%rax),%rax
  804062:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80406c:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80406e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804073:	74 19                	je     80408e <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  804075:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80407c:	00 00 00 
  80407f:	48 8b 00             	mov    (%rax),%rax
  804082:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80408c:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80408e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804095:	00 00 00 
  804098:	48 8b 00             	mov    (%rax),%rax
  80409b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8040a1:	c9                   	leaveq 
  8040a2:	c3                   	retq   

00000000008040a3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040a3:	55                   	push   %rbp
  8040a4:	48 89 e5             	mov    %rsp,%rbp
  8040a7:	48 83 ec 30          	sub    $0x30,%rsp
  8040ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8040b1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8040b5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8040b8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8040bd:	75 0e                	jne    8040cd <ipc_send+0x2a>
        pg = (void *)UTOP;
  8040bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8040c6:	00 00 00 
  8040c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8040cd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8040d0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8040d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040da:	89 c7                	mov    %eax,%edi
  8040dc:	48 b8 1a 1c 80 00 00 	movabs $0x801c1a,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
  8040e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8040eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ef:	79 36                	jns    804127 <ipc_send+0x84>
  8040f1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040f5:	74 30                	je     804127 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8040f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040fa:	89 c1                	mov    %eax,%ecx
  8040fc:	48 ba ab 4a 80 00 00 	movabs $0x804aab,%rdx
  804103:	00 00 00 
  804106:	be 49 00 00 00       	mov    $0x49,%esi
  80410b:	48 bf b8 4a 80 00 00 	movabs $0x804ab8,%rdi
  804112:	00 00 00 
  804115:	b8 00 00 00 00       	mov    $0x0,%eax
  80411a:	49 b8 16 03 80 00 00 	movabs $0x800316,%r8
  804121:	00 00 00 
  804124:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  804127:	48 b8 08 1a 80 00 00 	movabs $0x801a08,%rax
  80412e:	00 00 00 
  804131:	ff d0                	callq  *%rax
    } while(r != 0);
  804133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804137:	75 94                	jne    8040cd <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  804139:	c9                   	leaveq 
  80413a:	c3                   	retq   

000000000080413b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80413b:	55                   	push   %rbp
  80413c:	48 89 e5             	mov    %rsp,%rbp
  80413f:	48 83 ec 14          	sub    $0x14,%rsp
  804143:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804146:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80414d:	eb 5e                	jmp    8041ad <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80414f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804156:	00 00 00 
  804159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415c:	48 63 d0             	movslq %eax,%rdx
  80415f:	48 89 d0             	mov    %rdx,%rax
  804162:	48 c1 e0 03          	shl    $0x3,%rax
  804166:	48 01 d0             	add    %rdx,%rax
  804169:	48 c1 e0 05          	shl    $0x5,%rax
  80416d:	48 01 c8             	add    %rcx,%rax
  804170:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804176:	8b 00                	mov    (%rax),%eax
  804178:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80417b:	75 2c                	jne    8041a9 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80417d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804184:	00 00 00 
  804187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418a:	48 63 d0             	movslq %eax,%rdx
  80418d:	48 89 d0             	mov    %rdx,%rax
  804190:	48 c1 e0 03          	shl    $0x3,%rax
  804194:	48 01 d0             	add    %rdx,%rax
  804197:	48 c1 e0 05          	shl    $0x5,%rax
  80419b:	48 01 c8             	add    %rcx,%rax
  80419e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8041a4:	8b 40 08             	mov    0x8(%rax),%eax
  8041a7:	eb 12                	jmp    8041bb <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8041a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8041ad:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8041b4:	7e 99                	jle    80414f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8041b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041bb:	c9                   	leaveq 
  8041bc:	c3                   	retq   

00000000008041bd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8041bd:	55                   	push   %rbp
  8041be:	48 89 e5             	mov    %rsp,%rbp
  8041c1:	48 83 ec 18          	sub    $0x18,%rsp
  8041c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8041c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041cd:	48 c1 e8 15          	shr    $0x15,%rax
  8041d1:	48 89 c2             	mov    %rax,%rdx
  8041d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041db:	01 00 00 
  8041de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041e2:	83 e0 01             	and    $0x1,%eax
  8041e5:	48 85 c0             	test   %rax,%rax
  8041e8:	75 07                	jne    8041f1 <pageref+0x34>
		return 0;
  8041ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ef:	eb 53                	jmp    804244 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8041f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f5:	48 c1 e8 0c          	shr    $0xc,%rax
  8041f9:	48 89 c2             	mov    %rax,%rdx
  8041fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804203:	01 00 00 
  804206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80420a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80420e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804212:	83 e0 01             	and    $0x1,%eax
  804215:	48 85 c0             	test   %rax,%rax
  804218:	75 07                	jne    804221 <pageref+0x64>
		return 0;
  80421a:	b8 00 00 00 00       	mov    $0x0,%eax
  80421f:	eb 23                	jmp    804244 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804225:	48 c1 e8 0c          	shr    $0xc,%rax
  804229:	48 89 c2             	mov    %rax,%rdx
  80422c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804233:	00 00 00 
  804236:	48 c1 e2 04          	shl    $0x4,%rdx
  80423a:	48 01 d0             	add    %rdx,%rax
  80423d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804241:	0f b7 c0             	movzwl %ax,%eax
}
  804244:	c9                   	leaveq 
  804245:	c3                   	retq   
