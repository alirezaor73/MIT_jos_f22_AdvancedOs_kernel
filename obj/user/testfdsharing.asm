
obj/user/testfdsharing:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  80005e:	00 00 00 
  800061:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba c5 40 80 00 00 	movabs $0x8040c5,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba e8 40 80 00 00 	movabs $0x8040e8,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 e5 20 80 00 00 	movabs $0x8020e5,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba f2 40 80 00 00 	movabs $0x8040f2,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 00 41 80 00 00 	movabs $0x804100,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba 48 41 80 00 00 	movabs $0x804148,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 ef 03 80 00 00 	movabs $0x8003ef,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 5f 16 80 00 00 	movabs $0x80165f,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba 78 41 80 00 00 	movabs $0x804178,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf ae 41 80 00 00 	movabs $0x8041ae,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 cc 03 80 00 00 	movabs $0x8003cc,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 a8 39 80 00 00 	movabs $0x8039a8,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 83 29 80 00 00 	movabs $0x802983,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf d3 40 80 00 00 	movabs $0x8040d3,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 ef 03 80 00 00 	movabs $0x8003ef,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf eb 41 80 00 00 	movabs $0x8041eb,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 20          	sub    $0x20,%rsp
  800343:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80034a:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800361:	48 63 d0             	movslq %eax,%rdx
  800364:	48 89 d0             	mov    %rdx,%rax
  800367:	48 c1 e0 03          	shl    $0x3,%rax
  80036b:	48 01 d0             	add    %rdx,%rax
  80036e:	48 c1 e0 05          	shl    $0x5,%rax
  800372:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800379:	00 00 00 
  80037c:	48 01 c2             	add    %rax,%rdx
  80037f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800386:	00 00 00 
  800389:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80038c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800390:	7e 14                	jle    8003a6 <libmain+0x6b>
		binaryname = argv[0];
  800392:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800396:	48 8b 10             	mov    (%rax),%rdx
  800399:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003a0:	00 00 00 
  8003a3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8003aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003ad:	48 89 d6             	mov    %rdx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003be:	48 b8 cc 03 80 00 00 	movabs $0x8003cc,%rax
  8003c5:	00 00 00 
  8003c8:	ff d0                	callq  *%rax
}
  8003ca:	c9                   	leaveq 
  8003cb:	c3                   	retq   

00000000008003cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003cc:	55                   	push   %rbp
  8003cd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003d0:	48 b8 d7 26 80 00 00 	movabs $0x8026d7,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8003e1:	48 b8 5f 1a 80 00 00 	movabs $0x801a5f,%rax
  8003e8:	00 00 00 
  8003eb:	ff d0                	callq  *%rax
}
  8003ed:	5d                   	pop    %rbp
  8003ee:	c3                   	retq   

00000000008003ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ef:	55                   	push   %rbp
  8003f0:	48 89 e5             	mov    %rsp,%rbp
  8003f3:	53                   	push   %rbx
  8003f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800402:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800408:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80040f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800416:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80041d:	84 c0                	test   %al,%al
  80041f:	74 23                	je     800444 <_panic+0x55>
  800421:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800428:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80042c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800430:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800434:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800438:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80043c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800440:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800444:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80044b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800452:	00 00 00 
  800455:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80045c:	00 00 00 
  80045f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800463:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80046a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800471:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800478:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80047f:	00 00 00 
  800482:	48 8b 18             	mov    (%rax),%rbx
  800485:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800497:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80049e:	41 89 c8             	mov    %ecx,%r8d
  8004a1:	48 89 d1             	mov    %rdx,%rcx
  8004a4:	48 89 da             	mov    %rbx,%rdx
  8004a7:	89 c6                	mov    %eax,%esi
  8004a9:	48 bf 10 42 80 00 00 	movabs $0x804210,%rdi
  8004b0:	00 00 00 
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	49 b9 28 06 80 00 00 	movabs $0x800628,%r9
  8004bf:	00 00 00 
  8004c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004d3:	48 89 d6             	mov    %rdx,%rsi
  8004d6:	48 89 c7             	mov    %rax,%rdi
  8004d9:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  8004e0:	00 00 00 
  8004e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8004e5:	48 bf 33 42 80 00 00 	movabs $0x804233,%rdi
  8004ec:	00 00 00 
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  8004fb:	00 00 00 
  8004fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800500:	cc                   	int3   
  800501:	eb fd                	jmp    800500 <_panic+0x111>

0000000000800503 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800503:	55                   	push   %rbp
  800504:	48 89 e5             	mov    %rsp,%rbp
  800507:	48 83 ec 10          	sub    $0x10,%rsp
  80050b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80050e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800516:	8b 00                	mov    (%rax),%eax
  800518:	8d 48 01             	lea    0x1(%rax),%ecx
  80051b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051f:	89 0a                	mov    %ecx,(%rdx)
  800521:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800524:	89 d1                	mov    %edx,%ecx
  800526:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80052a:	48 98                	cltq   
  80052c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800530:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053b:	75 2c                	jne    800569 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80053d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	48 98                	cltq   
  800545:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800549:	48 83 c2 08          	add    $0x8,%rdx
  80054d:	48 89 c6             	mov    %rax,%rsi
  800550:	48 89 d7             	mov    %rdx,%rdi
  800553:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  80055a:	00 00 00 
  80055d:	ff d0                	callq  *%rax
        b->idx = 0;
  80055f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800563:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056d:	8b 40 04             	mov    0x4(%rax),%eax
  800570:	8d 50 01             	lea    0x1(%rax),%edx
  800573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800577:	89 50 04             	mov    %edx,0x4(%rax)
}
  80057a:	c9                   	leaveq 
  80057b:	c3                   	retq   

000000000080057c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80057c:	55                   	push   %rbp
  80057d:	48 89 e5             	mov    %rsp,%rbp
  800580:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800587:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80058e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800595:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80059c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005a3:	48 8b 0a             	mov    (%rdx),%rcx
  8005a6:	48 89 08             	mov    %rcx,(%rax)
  8005a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005c0:	00 00 00 
    b.cnt = 0;
  8005c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005ca:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005cd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005d4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005db:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005e2:	48 89 c6             	mov    %rax,%rsi
  8005e5:	48 bf 03 05 80 00 00 	movabs $0x800503,%rdi
  8005ec:	00 00 00 
  8005ef:	48 b8 db 09 80 00 00 	movabs $0x8009db,%rax
  8005f6:	00 00 00 
  8005f9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005fb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800601:	48 98                	cltq   
  800603:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80060a:	48 83 c2 08          	add    $0x8,%rdx
  80060e:	48 89 c6             	mov    %rax,%rsi
  800611:	48 89 d7             	mov    %rdx,%rdi
  800614:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  80061b:	00 00 00 
  80061e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800620:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800626:	c9                   	leaveq 
  800627:	c3                   	retq   

0000000000800628 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800628:	55                   	push   %rbp
  800629:	48 89 e5             	mov    %rsp,%rbp
  80062c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800633:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80063a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800641:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800648:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80064f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800656:	84 c0                	test   %al,%al
  800658:	74 20                	je     80067a <cprintf+0x52>
  80065a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80065e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800662:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800666:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80066a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80066e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800672:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800676:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80067a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800681:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800688:	00 00 00 
  80068b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800692:	00 00 00 
  800695:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800699:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006bc:	48 8b 0a             	mov    (%rdx),%rcx
  8006bf:	48 89 08             	mov    %rcx,(%rax)
  8006c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006d2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006e0:	48 89 d6             	mov    %rdx,%rsi
  8006e3:	48 89 c7             	mov    %rax,%rdi
  8006e6:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  8006ed:	00 00 00 
  8006f0:	ff d0                	callq  *%rax
  8006f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006fe:	c9                   	leaveq 
  8006ff:	c3                   	retq   

0000000000800700 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800700:	55                   	push   %rbp
  800701:	48 89 e5             	mov    %rsp,%rbp
  800704:	53                   	push   %rbx
  800705:	48 83 ec 38          	sub    $0x38,%rsp
  800709:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80070d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800711:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800715:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800718:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80071c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800723:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800727:	77 3b                	ja     800764 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800729:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80072c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800730:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	48 f7 f3             	div    %rbx
  80073f:	48 89 c2             	mov    %rax,%rdx
  800742:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800745:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800748:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	41 89 f9             	mov    %edi,%r9d
  800753:	48 89 c7             	mov    %rax,%rdi
  800756:	48 b8 00 07 80 00 00 	movabs $0x800700,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
  800762:	eb 1e                	jmp    800782 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800764:	eb 12                	jmp    800778 <printnum+0x78>
			putch(padc, putdat);
  800766:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80076a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	48 89 ce             	mov    %rcx,%rsi
  800774:	89 d7                	mov    %edx,%edi
  800776:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800778:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80077c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800780:	7f e4                	jg     800766 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800782:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	48 f7 f1             	div    %rcx
  800791:	48 89 d0             	mov    %rdx,%rax
  800794:	48 ba 30 44 80 00 00 	movabs $0x804430,%rdx
  80079b:	00 00 00 
  80079e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007a2:	0f be d0             	movsbl %al,%edx
  8007a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 89 ce             	mov    %rcx,%rsi
  8007b0:	89 d7                	mov    %edx,%edi
  8007b2:	ff d0                	callq  *%rax
}
  8007b4:	48 83 c4 38          	add    $0x38,%rsp
  8007b8:	5b                   	pop    %rbx
  8007b9:	5d                   	pop    %rbp
  8007ba:	c3                   	retq   

00000000008007bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bb:	55                   	push   %rbp
  8007bc:	48 89 e5             	mov    %rsp,%rbp
  8007bf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8007ca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ce:	7e 52                	jle    800822 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	8b 00                	mov    (%rax),%eax
  8007d6:	83 f8 30             	cmp    $0x30,%eax
  8007d9:	73 24                	jae    8007ff <getuint+0x44>
  8007db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e7:	8b 00                	mov    (%rax),%eax
  8007e9:	89 c0                	mov    %eax,%eax
  8007eb:	48 01 d0             	add    %rdx,%rax
  8007ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f2:	8b 12                	mov    (%rdx),%edx
  8007f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fb:	89 0a                	mov    %ecx,(%rdx)
  8007fd:	eb 17                	jmp    800816 <getuint+0x5b>
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800807:	48 89 d0             	mov    %rdx,%rax
  80080a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80080e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800812:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800816:	48 8b 00             	mov    (%rax),%rax
  800819:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80081d:	e9 a3 00 00 00       	jmpq   8008c5 <getuint+0x10a>
	else if (lflag)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800826:	74 4f                	je     800877 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	8b 00                	mov    (%rax),%eax
  80082e:	83 f8 30             	cmp    $0x30,%eax
  800831:	73 24                	jae    800857 <getuint+0x9c>
  800833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800837:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	8b 00                	mov    (%rax),%eax
  800841:	89 c0                	mov    %eax,%eax
  800843:	48 01 d0             	add    %rdx,%rax
  800846:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084a:	8b 12                	mov    (%rdx),%edx
  80084c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800853:	89 0a                	mov    %ecx,(%rdx)
  800855:	eb 17                	jmp    80086e <getuint+0xb3>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80085f:	48 89 d0             	mov    %rdx,%rax
  800862:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800866:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086e:	48 8b 00             	mov    (%rax),%rax
  800871:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800875:	eb 4e                	jmp    8008c5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	83 f8 30             	cmp    $0x30,%eax
  800880:	73 24                	jae    8008a6 <getuint+0xeb>
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088e:	8b 00                	mov    (%rax),%eax
  800890:	89 c0                	mov    %eax,%eax
  800892:	48 01 d0             	add    %rdx,%rax
  800895:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800899:	8b 12                	mov    (%rdx),%edx
  80089b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a2:	89 0a                	mov    %ecx,(%rdx)
  8008a4:	eb 17                	jmp    8008bd <getuint+0x102>
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ae:	48 89 d0             	mov    %rdx,%rax
  8008b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bd:	8b 00                	mov    (%rax),%eax
  8008bf:	89 c0                	mov    %eax,%eax
  8008c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c9:	c9                   	leaveq 
  8008ca:	c3                   	retq   

00000000008008cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008cb:	55                   	push   %rbp
  8008cc:	48 89 e5             	mov    %rsp,%rbp
  8008cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008de:	7e 52                	jle    800932 <getint+0x67>
		x=va_arg(*ap, long long);
  8008e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e4:	8b 00                	mov    (%rax),%eax
  8008e6:	83 f8 30             	cmp    $0x30,%eax
  8008e9:	73 24                	jae    80090f <getint+0x44>
  8008eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	8b 00                	mov    (%rax),%eax
  8008f9:	89 c0                	mov    %eax,%eax
  8008fb:	48 01 d0             	add    %rdx,%rax
  8008fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800902:	8b 12                	mov    (%rdx),%edx
  800904:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800907:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090b:	89 0a                	mov    %ecx,(%rdx)
  80090d:	eb 17                	jmp    800926 <getint+0x5b>
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800917:	48 89 d0             	mov    %rdx,%rax
  80091a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80091e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800922:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800926:	48 8b 00             	mov    (%rax),%rax
  800929:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092d:	e9 a3 00 00 00       	jmpq   8009d5 <getint+0x10a>
	else if (lflag)
  800932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800936:	74 4f                	je     800987 <getint+0xbc>
		x=va_arg(*ap, long);
  800938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093c:	8b 00                	mov    (%rax),%eax
  80093e:	83 f8 30             	cmp    $0x30,%eax
  800941:	73 24                	jae    800967 <getint+0x9c>
  800943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800947:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	8b 00                	mov    (%rax),%eax
  800951:	89 c0                	mov    %eax,%eax
  800953:	48 01 d0             	add    %rdx,%rax
  800956:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095a:	8b 12                	mov    (%rdx),%edx
  80095c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80095f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800963:	89 0a                	mov    %ecx,(%rdx)
  800965:	eb 17                	jmp    80097e <getint+0xb3>
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80096f:	48 89 d0             	mov    %rdx,%rax
  800972:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800976:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80097e:	48 8b 00             	mov    (%rax),%rax
  800981:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800985:	eb 4e                	jmp    8009d5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	8b 00                	mov    (%rax),%eax
  80098d:	83 f8 30             	cmp    $0x30,%eax
  800990:	73 24                	jae    8009b6 <getint+0xeb>
  800992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800996:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099e:	8b 00                	mov    (%rax),%eax
  8009a0:	89 c0                	mov    %eax,%eax
  8009a2:	48 01 d0             	add    %rdx,%rax
  8009a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a9:	8b 12                	mov    (%rdx),%edx
  8009ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b2:	89 0a                	mov    %ecx,(%rdx)
  8009b4:	eb 17                	jmp    8009cd <getint+0x102>
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009be:	48 89 d0             	mov    %rdx,%rax
  8009c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cd:	8b 00                	mov    (%rax),%eax
  8009cf:	48 98                	cltq   
  8009d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d9:	c9                   	leaveq 
  8009da:	c3                   	retq   

00000000008009db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009db:	55                   	push   %rbp
  8009dc:	48 89 e5             	mov    %rsp,%rbp
  8009df:	41 54                	push   %r12
  8009e1:	53                   	push   %rbx
  8009e2:	48 83 ec 60          	sub    $0x60,%rsp
  8009e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009fe:	48 8b 0a             	mov    (%rdx),%rcx
  800a01:	48 89 08             	mov    %rcx,(%rax)
  800a04:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a08:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a0c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a10:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a14:	eb 17                	jmp    800a2d <vprintfmt+0x52>
			if (ch == '\0')
  800a16:	85 db                	test   %ebx,%ebx
  800a18:	0f 84 df 04 00 00    	je     800efd <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800a1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a26:	48 89 d6             	mov    %rdx,%rsi
  800a29:	89 df                	mov    %ebx,%edi
  800a2b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a35:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a39:	0f b6 00             	movzbl (%rax),%eax
  800a3c:	0f b6 d8             	movzbl %al,%ebx
  800a3f:	83 fb 25             	cmp    $0x25,%ebx
  800a42:	75 d2                	jne    800a16 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a44:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a48:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a4f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a64:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a68:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a70:	0f b6 00             	movzbl (%rax),%eax
  800a73:	0f b6 d8             	movzbl %al,%ebx
  800a76:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a79:	83 f8 55             	cmp    $0x55,%eax
  800a7c:	0f 87 47 04 00 00    	ja     800ec9 <vprintfmt+0x4ee>
  800a82:	89 c0                	mov    %eax,%eax
  800a84:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a8b:	00 
  800a8c:	48 b8 58 44 80 00 00 	movabs $0x804458,%rax
  800a93:	00 00 00 
  800a96:	48 01 d0             	add    %rdx,%rax
  800a99:	48 8b 00             	mov    (%rax),%rax
  800a9c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a9e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aa2:	eb c0                	jmp    800a64 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aa8:	eb ba                	jmp    800a64 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aaa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ab1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	c1 e0 02             	shl    $0x2,%eax
  800ab9:	01 d0                	add    %edx,%eax
  800abb:	01 c0                	add    %eax,%eax
  800abd:	01 d8                	add    %ebx,%eax
  800abf:	83 e8 30             	sub    $0x30,%eax
  800ac2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ac5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac9:	0f b6 00             	movzbl (%rax),%eax
  800acc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800acf:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad2:	7e 0c                	jle    800ae0 <vprintfmt+0x105>
  800ad4:	83 fb 39             	cmp    $0x39,%ebx
  800ad7:	7f 07                	jg     800ae0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ade:	eb d1                	jmp    800ab1 <vprintfmt+0xd6>
			goto process_precision;
  800ae0:	eb 58                	jmp    800b3a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ae2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae5:	83 f8 30             	cmp    $0x30,%eax
  800ae8:	73 17                	jae    800b01 <vprintfmt+0x126>
  800aea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af1:	89 c0                	mov    %eax,%eax
  800af3:	48 01 d0             	add    %rdx,%rax
  800af6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af9:	83 c2 08             	add    $0x8,%edx
  800afc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aff:	eb 0f                	jmp    800b10 <vprintfmt+0x135>
  800b01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b05:	48 89 d0             	mov    %rdx,%rax
  800b08:	48 83 c2 08          	add    $0x8,%rdx
  800b0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b10:	8b 00                	mov    (%rax),%eax
  800b12:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b15:	eb 23                	jmp    800b3a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1b:	79 0c                	jns    800b29 <vprintfmt+0x14e>
				width = 0;
  800b1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b24:	e9 3b ff ff ff       	jmpq   800a64 <vprintfmt+0x89>
  800b29:	e9 36 ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b2e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b35:	e9 2a ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b3e:	79 12                	jns    800b52 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b43:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b4d:	e9 12 ff ff ff       	jmpq   800a64 <vprintfmt+0x89>
  800b52:	e9 0d ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b57:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b5b:	e9 04 ff ff ff       	jmpq   800a64 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b63:	83 f8 30             	cmp    $0x30,%eax
  800b66:	73 17                	jae    800b7f <vprintfmt+0x1a4>
  800b68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6f:	89 c0                	mov    %eax,%eax
  800b71:	48 01 d0             	add    %rdx,%rax
  800b74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b77:	83 c2 08             	add    $0x8,%edx
  800b7a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b7d:	eb 0f                	jmp    800b8e <vprintfmt+0x1b3>
  800b7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b83:	48 89 d0             	mov    %rdx,%rax
  800b86:	48 83 c2 08          	add    $0x8,%rdx
  800b8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b8e:	8b 10                	mov    (%rax),%edx
  800b90:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b98:	48 89 ce             	mov    %rcx,%rsi
  800b9b:	89 d7                	mov    %edx,%edi
  800b9d:	ff d0                	callq  *%rax
			break;
  800b9f:	e9 53 03 00 00       	jmpq   800ef7 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ba4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba7:	83 f8 30             	cmp    $0x30,%eax
  800baa:	73 17                	jae    800bc3 <vprintfmt+0x1e8>
  800bac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb3:	89 c0                	mov    %eax,%eax
  800bb5:	48 01 d0             	add    %rdx,%rax
  800bb8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bbb:	83 c2 08             	add    $0x8,%edx
  800bbe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bc1:	eb 0f                	jmp    800bd2 <vprintfmt+0x1f7>
  800bc3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc7:	48 89 d0             	mov    %rdx,%rax
  800bca:	48 83 c2 08          	add    $0x8,%rdx
  800bce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bd2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bd4:	85 db                	test   %ebx,%ebx
  800bd6:	79 02                	jns    800bda <vprintfmt+0x1ff>
				err = -err;
  800bd8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bda:	83 fb 15             	cmp    $0x15,%ebx
  800bdd:	7f 16                	jg     800bf5 <vprintfmt+0x21a>
  800bdf:	48 b8 80 43 80 00 00 	movabs $0x804380,%rax
  800be6:	00 00 00 
  800be9:	48 63 d3             	movslq %ebx,%rdx
  800bec:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bf0:	4d 85 e4             	test   %r12,%r12
  800bf3:	75 2e                	jne    800c23 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800bf5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bf9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfd:	89 d9                	mov    %ebx,%ecx
  800bff:	48 ba 41 44 80 00 00 	movabs $0x804441,%rdx
  800c06:	00 00 00 
  800c09:	48 89 c7             	mov    %rax,%rdi
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	49 b8 06 0f 80 00 00 	movabs $0x800f06,%r8
  800c18:	00 00 00 
  800c1b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c1e:	e9 d4 02 00 00       	jmpq   800ef7 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2b:	4c 89 e1             	mov    %r12,%rcx
  800c2e:	48 ba 4a 44 80 00 00 	movabs $0x80444a,%rdx
  800c35:	00 00 00 
  800c38:	48 89 c7             	mov    %rax,%rdi
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c40:	49 b8 06 0f 80 00 00 	movabs $0x800f06,%r8
  800c47:	00 00 00 
  800c4a:	41 ff d0             	callq  *%r8
			break;
  800c4d:	e9 a5 02 00 00       	jmpq   800ef7 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c55:	83 f8 30             	cmp    $0x30,%eax
  800c58:	73 17                	jae    800c71 <vprintfmt+0x296>
  800c5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c61:	89 c0                	mov    %eax,%eax
  800c63:	48 01 d0             	add    %rdx,%rax
  800c66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c69:	83 c2 08             	add    $0x8,%edx
  800c6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c6f:	eb 0f                	jmp    800c80 <vprintfmt+0x2a5>
  800c71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c75:	48 89 d0             	mov    %rdx,%rax
  800c78:	48 83 c2 08          	add    $0x8,%rdx
  800c7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c80:	4c 8b 20             	mov    (%rax),%r12
  800c83:	4d 85 e4             	test   %r12,%r12
  800c86:	75 0a                	jne    800c92 <vprintfmt+0x2b7>
				p = "(null)";
  800c88:	49 bc 4d 44 80 00 00 	movabs $0x80444d,%r12
  800c8f:	00 00 00 
			if (width > 0 && padc != '-')
  800c92:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c96:	7e 3f                	jle    800cd7 <vprintfmt+0x2fc>
  800c98:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c9c:	74 39                	je     800cd7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c9e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ca1:	48 98                	cltq   
  800ca3:	48 89 c6             	mov    %rax,%rsi
  800ca6:	4c 89 e7             	mov    %r12,%rdi
  800ca9:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  800cb0:	00 00 00 
  800cb3:	ff d0                	callq  *%rax
  800cb5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cb8:	eb 17                	jmp    800cd1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cba:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cbe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc6:	48 89 ce             	mov    %rcx,%rsi
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ccd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd5:	7f e3                	jg     800cba <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd7:	eb 37                	jmp    800d10 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cd9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cdd:	74 1e                	je     800cfd <vprintfmt+0x322>
  800cdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800ce2:	7e 05                	jle    800ce9 <vprintfmt+0x30e>
  800ce4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ce7:	7e 14                	jle    800cfd <vprintfmt+0x322>
					putch('?', putdat);
  800ce9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ced:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf1:	48 89 d6             	mov    %rdx,%rsi
  800cf4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cf9:	ff d0                	callq  *%rax
  800cfb:	eb 0f                	jmp    800d0c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800cfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d05:	48 89 d6             	mov    %rdx,%rsi
  800d08:	89 df                	mov    %ebx,%edi
  800d0a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d10:	4c 89 e0             	mov    %r12,%rax
  800d13:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d17:	0f b6 00             	movzbl (%rax),%eax
  800d1a:	0f be d8             	movsbl %al,%ebx
  800d1d:	85 db                	test   %ebx,%ebx
  800d1f:	74 10                	je     800d31 <vprintfmt+0x356>
  800d21:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d25:	78 b2                	js     800cd9 <vprintfmt+0x2fe>
  800d27:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d2b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d2f:	79 a8                	jns    800cd9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d31:	eb 16                	jmp    800d49 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3b:	48 89 d6             	mov    %rdx,%rsi
  800d3e:	bf 20 00 00 00       	mov    $0x20,%edi
  800d43:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d4d:	7f e4                	jg     800d33 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d4f:	e9 a3 01 00 00       	jmpq   800ef7 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d58:	be 03 00 00 00       	mov    $0x3,%esi
  800d5d:	48 89 c7             	mov    %rax,%rdi
  800d60:	48 b8 cb 08 80 00 00 	movabs $0x8008cb,%rax
  800d67:	00 00 00 
  800d6a:	ff d0                	callq  *%rax
  800d6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d74:	48 85 c0             	test   %rax,%rax
  800d77:	79 1d                	jns    800d96 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d81:	48 89 d6             	mov    %rdx,%rsi
  800d84:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d89:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8f:	48 f7 d8             	neg    %rax
  800d92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d9d:	e9 e8 00 00 00       	jmpq   800e8a <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800da2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da6:	be 03 00 00 00       	mov    $0x3,%esi
  800dab:	48 89 c7             	mov    %rax,%rdi
  800dae:	48 b8 bb 07 80 00 00 	movabs $0x8007bb,%rax
  800db5:	00 00 00 
  800db8:	ff d0                	callq  *%rax
  800dba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dbe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dc5:	e9 c0 00 00 00       	jmpq   800e8a <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd2:	48 89 d6             	mov    %rdx,%rsi
  800dd5:	bf 58 00 00 00       	mov    $0x58,%edi
  800dda:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ddc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de4:	48 89 d6             	mov    %rdx,%rsi
  800de7:	bf 58 00 00 00       	mov    $0x58,%edi
  800dec:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df6:	48 89 d6             	mov    %rdx,%rsi
  800df9:	bf 58 00 00 00       	mov    $0x58,%edi
  800dfe:	ff d0                	callq  *%rax
			break;
  800e00:	e9 f2 00 00 00       	jmpq   800ef7 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0d:	48 89 d6             	mov    %rdx,%rsi
  800e10:	bf 30 00 00 00       	mov    $0x30,%edi
  800e15:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1f:	48 89 d6             	mov    %rdx,%rsi
  800e22:	bf 78 00 00 00       	mov    $0x78,%edi
  800e27:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e2c:	83 f8 30             	cmp    $0x30,%eax
  800e2f:	73 17                	jae    800e48 <vprintfmt+0x46d>
  800e31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e38:	89 c0                	mov    %eax,%eax
  800e3a:	48 01 d0             	add    %rdx,%rax
  800e3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e40:	83 c2 08             	add    $0x8,%edx
  800e43:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e46:	eb 0f                	jmp    800e57 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800e48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e4c:	48 89 d0             	mov    %rdx,%rax
  800e4f:	48 83 c2 08          	add    $0x8,%rdx
  800e53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e57:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e5a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e5e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e65:	eb 23                	jmp    800e8a <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e6b:	be 03 00 00 00       	mov    $0x3,%esi
  800e70:	48 89 c7             	mov    %rax,%rdi
  800e73:	48 b8 bb 07 80 00 00 	movabs $0x8007bb,%rax
  800e7a:	00 00 00 
  800e7d:	ff d0                	callq  *%rax
  800e7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e83:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e8a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e8f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e92:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e99:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea1:	45 89 c1             	mov    %r8d,%r9d
  800ea4:	41 89 f8             	mov    %edi,%r8d
  800ea7:	48 89 c7             	mov    %rax,%rdi
  800eaa:	48 b8 00 07 80 00 00 	movabs $0x800700,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	callq  *%rax
			break;
  800eb6:	eb 3f                	jmp    800ef7 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ebc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec0:	48 89 d6             	mov    %rdx,%rsi
  800ec3:	89 df                	mov    %ebx,%edi
  800ec5:	ff d0                	callq  *%rax
			break;
  800ec7:	eb 2e                	jmp    800ef7 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ec9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ecd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed1:	48 89 d6             	mov    %rdx,%rsi
  800ed4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ed9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800edb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee0:	eb 05                	jmp    800ee7 <vprintfmt+0x50c>
  800ee2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800eeb:	48 83 e8 01          	sub    $0x1,%rax
  800eef:	0f b6 00             	movzbl (%rax),%eax
  800ef2:	3c 25                	cmp    $0x25,%al
  800ef4:	75 ec                	jne    800ee2 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ef6:	90                   	nop
		}
	}
  800ef7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ef8:	e9 30 fb ff ff       	jmpq   800a2d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800efd:	48 83 c4 60          	add    $0x60,%rsp
  800f01:	5b                   	pop    %rbx
  800f02:	41 5c                	pop    %r12
  800f04:	5d                   	pop    %rbp
  800f05:	c3                   	retq   

0000000000800f06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f06:	55                   	push   %rbp
  800f07:	48 89 e5             	mov    %rsp,%rbp
  800f0a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f11:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f18:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f1f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f26:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f34:	84 c0                	test   %al,%al
  800f36:	74 20                	je     800f58 <printfmt+0x52>
  800f38:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f3c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f40:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f44:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f48:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f4c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f50:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f54:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f58:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f5f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f66:	00 00 00 
  800f69:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f70:	00 00 00 
  800f73:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f77:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f7e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f85:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f93:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f9a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fa1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fa8:	48 89 c7             	mov    %rax,%rdi
  800fab:	48 b8 db 09 80 00 00 	movabs $0x8009db,%rax
  800fb2:	00 00 00 
  800fb5:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fb7:	c9                   	leaveq 
  800fb8:	c3                   	retq   

0000000000800fb9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fb9:	55                   	push   %rbp
  800fba:	48 89 e5             	mov    %rsp,%rbp
  800fbd:	48 83 ec 10          	sub    $0x10,%rsp
  800fc1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcc:	8b 40 10             	mov    0x10(%rax),%eax
  800fcf:	8d 50 01             	lea    0x1(%rax),%edx
  800fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdd:	48 8b 10             	mov    (%rax),%rdx
  800fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe4:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fe8:	48 39 c2             	cmp    %rax,%rdx
  800feb:	73 17                	jae    801004 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff1:	48 8b 00             	mov    (%rax),%rax
  800ff4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ff8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ffc:	48 89 0a             	mov    %rcx,(%rdx)
  800fff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801002:	88 10                	mov    %dl,(%rax)
}
  801004:	c9                   	leaveq 
  801005:	c3                   	retq   

0000000000801006 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801006:	55                   	push   %rbp
  801007:	48 89 e5             	mov    %rsp,%rbp
  80100a:	48 83 ec 50          	sub    $0x50,%rsp
  80100e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801012:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801015:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801019:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80101d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801021:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801025:	48 8b 0a             	mov    (%rdx),%rcx
  801028:	48 89 08             	mov    %rcx,(%rax)
  80102b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80102f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801033:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801037:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80103f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801043:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801046:	48 98                	cltq   
  801048:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80104c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801050:	48 01 d0             	add    %rdx,%rax
  801053:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801057:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80105e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801063:	74 06                	je     80106b <vsnprintf+0x65>
  801065:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801069:	7f 07                	jg     801072 <vsnprintf+0x6c>
		return -E_INVAL;
  80106b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801070:	eb 2f                	jmp    8010a1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801072:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801076:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80107a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80107e:	48 89 c6             	mov    %rax,%rsi
  801081:	48 bf b9 0f 80 00 00 	movabs $0x800fb9,%rdi
  801088:	00 00 00 
  80108b:	48 b8 db 09 80 00 00 	movabs $0x8009db,%rax
  801092:	00 00 00 
  801095:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801097:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80109b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80109e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010a1:	c9                   	leaveq 
  8010a2:	c3                   	retq   

00000000008010a3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a3:	55                   	push   %rbp
  8010a4:	48 89 e5             	mov    %rsp,%rbp
  8010a7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010ae:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010b5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010bb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010c2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010c9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d0:	84 c0                	test   %al,%al
  8010d2:	74 20                	je     8010f4 <snprintf+0x51>
  8010d4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010d8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010dc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010e4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010e8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010ec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010f4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010fb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801102:	00 00 00 
  801105:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80110c:	00 00 00 
  80110f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801113:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80111a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801121:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801128:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80112f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801136:	48 8b 0a             	mov    (%rdx),%rcx
  801139:	48 89 08             	mov    %rcx,(%rax)
  80113c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801140:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801144:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801148:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80114c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801153:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80115a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801160:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801167:	48 89 c7             	mov    %rax,%rdi
  80116a:	48 b8 06 10 80 00 00 	movabs $0x801006,%rax
  801171:	00 00 00 
  801174:	ff d0                	callq  *%rax
  801176:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80117c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801182:	c9                   	leaveq 
  801183:	c3                   	retq   

0000000000801184 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801184:	55                   	push   %rbp
  801185:	48 89 e5             	mov    %rsp,%rbp
  801188:	48 83 ec 18          	sub    $0x18,%rsp
  80118c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801197:	eb 09                	jmp    8011a2 <strlen+0x1e>
		n++;
  801199:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80119d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	84 c0                	test   %al,%al
  8011ab:	75 ec                	jne    801199 <strlen+0x15>
		n++;
	return n;
  8011ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 20          	sub    $0x20,%rsp
  8011ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c9:	eb 0e                	jmp    8011d9 <strnlen+0x27>
		n++;
  8011cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011cf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011d4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011d9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011de:	74 0b                	je     8011eb <strnlen+0x39>
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 e0                	jne    8011cb <strnlen+0x19>
		n++;
	return n;
  8011eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011ee:	c9                   	leaveq 
  8011ef:	c3                   	retq   

00000000008011f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	48 83 ec 20          	sub    $0x20,%rsp
  8011f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801204:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801208:	90                   	nop
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801211:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801215:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801219:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80121d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801221:	0f b6 12             	movzbl (%rdx),%edx
  801224:	88 10                	mov    %dl,(%rax)
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	84 c0                	test   %al,%al
  80122b:	75 dc                	jne    801209 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801231:	c9                   	leaveq 
  801232:	c3                   	retq   

0000000000801233 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801233:	55                   	push   %rbp
  801234:	48 89 e5             	mov    %rsp,%rbp
  801237:	48 83 ec 20          	sub    $0x20,%rsp
  80123b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80123f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801247:	48 89 c7             	mov    %rax,%rdi
  80124a:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  801251:	00 00 00 
  801254:	ff d0                	callq  *%rax
  801256:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80125c:	48 63 d0             	movslq %eax,%rdx
  80125f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801263:	48 01 c2             	add    %rax,%rdx
  801266:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126a:	48 89 c6             	mov    %rax,%rsi
  80126d:	48 89 d7             	mov    %rdx,%rdi
  801270:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  801277:	00 00 00 
  80127a:	ff d0                	callq  *%rax
	return dst;
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801280:	c9                   	leaveq 
  801281:	c3                   	retq   

0000000000801282 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801282:	55                   	push   %rbp
  801283:	48 89 e5             	mov    %rsp,%rbp
  801286:	48 83 ec 28          	sub    $0x28,%rsp
  80128a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801292:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80129e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012a5:	00 
  8012a6:	eb 2a                	jmp    8012d2 <strncpy+0x50>
		*dst++ = *src;
  8012a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012b8:	0f b6 12             	movzbl (%rdx),%edx
  8012bb:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c1:	0f b6 00             	movzbl (%rax),%eax
  8012c4:	84 c0                	test   %al,%al
  8012c6:	74 05                	je     8012cd <strncpy+0x4b>
			src++;
  8012c8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012da:	72 cc                	jb     8012a8 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 28          	sub    $0x28,%rsp
  8012ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012fe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801303:	74 3d                	je     801342 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801305:	eb 1d                	jmp    801324 <strlcpy+0x42>
			*dst++ = *src++;
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80130f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801313:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801317:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80131b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80131f:	0f b6 12             	movzbl (%rdx),%edx
  801322:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801324:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801329:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80132e:	74 0b                	je     80133b <strlcpy+0x59>
  801330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801334:	0f b6 00             	movzbl (%rax),%eax
  801337:	84 c0                	test   %al,%al
  801339:	75 cc                	jne    801307 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801342:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134a:	48 29 c2             	sub    %rax,%rdx
  80134d:	48 89 d0             	mov    %rdx,%rax
}
  801350:	c9                   	leaveq 
  801351:	c3                   	retq   

0000000000801352 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801352:	55                   	push   %rbp
  801353:	48 89 e5             	mov    %rsp,%rbp
  801356:	48 83 ec 10          	sub    $0x10,%rsp
  80135a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801362:	eb 0a                	jmp    80136e <strcmp+0x1c>
		p++, q++;
  801364:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801369:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	84 c0                	test   %al,%al
  801377:	74 12                	je     80138b <strcmp+0x39>
  801379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137d:	0f b6 10             	movzbl (%rax),%edx
  801380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	38 c2                	cmp    %al,%dl
  801389:	74 d9                	je     801364 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	0f b6 00             	movzbl (%rax),%eax
  801392:	0f b6 d0             	movzbl %al,%edx
  801395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801399:	0f b6 00             	movzbl (%rax),%eax
  80139c:	0f b6 c0             	movzbl %al,%eax
  80139f:	29 c2                	sub    %eax,%edx
  8013a1:	89 d0                	mov    %edx,%eax
}
  8013a3:	c9                   	leaveq 
  8013a4:	c3                   	retq   

00000000008013a5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013a5:	55                   	push   %rbp
  8013a6:	48 89 e5             	mov    %rsp,%rbp
  8013a9:	48 83 ec 18          	sub    $0x18,%rsp
  8013ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013b9:	eb 0f                	jmp    8013ca <strncmp+0x25>
		n--, p++, q++;
  8013bb:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013cf:	74 1d                	je     8013ee <strncmp+0x49>
  8013d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d5:	0f b6 00             	movzbl (%rax),%eax
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 12                	je     8013ee <strncmp+0x49>
  8013dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e0:	0f b6 10             	movzbl (%rax),%edx
  8013e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	38 c2                	cmp    %al,%dl
  8013ec:	74 cd                	je     8013bb <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f3:	75 07                	jne    8013fc <strncmp+0x57>
		return 0;
  8013f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fa:	eb 18                	jmp    801414 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	0f b6 00             	movzbl (%rax),%eax
  801403:	0f b6 d0             	movzbl %al,%edx
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	0f b6 c0             	movzbl %al,%eax
  801410:	29 c2                	sub    %eax,%edx
  801412:	89 d0                	mov    %edx,%eax
}
  801414:	c9                   	leaveq 
  801415:	c3                   	retq   

0000000000801416 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801416:	55                   	push   %rbp
  801417:	48 89 e5             	mov    %rsp,%rbp
  80141a:	48 83 ec 0c          	sub    $0xc,%rsp
  80141e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801422:	89 f0                	mov    %esi,%eax
  801424:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801427:	eb 17                	jmp    801440 <strchr+0x2a>
		if (*s == c)
  801429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801433:	75 06                	jne    80143b <strchr+0x25>
			return (char *) s;
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	eb 15                	jmp    801450 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80143b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	84 c0                	test   %al,%al
  801449:	75 de                	jne    801429 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801450:	c9                   	leaveq 
  801451:	c3                   	retq   

0000000000801452 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801452:	55                   	push   %rbp
  801453:	48 89 e5             	mov    %rsp,%rbp
  801456:	48 83 ec 0c          	sub    $0xc,%rsp
  80145a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145e:	89 f0                	mov    %esi,%eax
  801460:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801463:	eb 13                	jmp    801478 <strfind+0x26>
		if (*s == c)
  801465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801469:	0f b6 00             	movzbl (%rax),%eax
  80146c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80146f:	75 02                	jne    801473 <strfind+0x21>
			break;
  801471:	eb 10                	jmp    801483 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801473:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	84 c0                	test   %al,%al
  801481:	75 e2                	jne    801465 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801487:	c9                   	leaveq 
  801488:	c3                   	retq   

0000000000801489 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801489:	55                   	push   %rbp
  80148a:	48 89 e5             	mov    %rsp,%rbp
  80148d:	48 83 ec 18          	sub    $0x18,%rsp
  801491:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801495:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801498:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80149c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014a1:	75 06                	jne    8014a9 <memset+0x20>
		return v;
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a7:	eb 69                	jmp    801512 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ad:	83 e0 03             	and    $0x3,%eax
  8014b0:	48 85 c0             	test   %rax,%rax
  8014b3:	75 48                	jne    8014fd <memset+0x74>
  8014b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b9:	83 e0 03             	and    $0x3,%eax
  8014bc:	48 85 c0             	test   %rax,%rax
  8014bf:	75 3c                	jne    8014fd <memset+0x74>
		c &= 0xFF;
  8014c1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cb:	c1 e0 18             	shl    $0x18,%eax
  8014ce:	89 c2                	mov    %eax,%edx
  8014d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d3:	c1 e0 10             	shl    $0x10,%eax
  8014d6:	09 c2                	or     %eax,%edx
  8014d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014db:	c1 e0 08             	shl    $0x8,%eax
  8014de:	09 d0                	or     %edx,%eax
  8014e0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e7:	48 c1 e8 02          	shr    $0x2,%rax
  8014eb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f5:	48 89 d7             	mov    %rdx,%rdi
  8014f8:	fc                   	cld    
  8014f9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014fb:	eb 11                	jmp    80150e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801501:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801504:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801508:	48 89 d7             	mov    %rdx,%rdi
  80150b:	fc                   	cld    
  80150c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80150e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801512:	c9                   	leaveq 
  801513:	c3                   	retq   

0000000000801514 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801514:	55                   	push   %rbp
  801515:	48 89 e5             	mov    %rsp,%rbp
  801518:	48 83 ec 28          	sub    $0x28,%rsp
  80151c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801520:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801524:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801528:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80152c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801534:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801540:	0f 83 88 00 00 00    	jae    8015ce <memmove+0xba>
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80154e:	48 01 d0             	add    %rdx,%rax
  801551:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801555:	76 77                	jbe    8015ce <memmove+0xba>
		s += n;
  801557:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156b:	83 e0 03             	and    $0x3,%eax
  80156e:	48 85 c0             	test   %rax,%rax
  801571:	75 3b                	jne    8015ae <memmove+0x9a>
  801573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801577:	83 e0 03             	and    $0x3,%eax
  80157a:	48 85 c0             	test   %rax,%rax
  80157d:	75 2f                	jne    8015ae <memmove+0x9a>
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	83 e0 03             	and    $0x3,%eax
  801586:	48 85 c0             	test   %rax,%rax
  801589:	75 23                	jne    8015ae <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80158b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158f:	48 83 e8 04          	sub    $0x4,%rax
  801593:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801597:	48 83 ea 04          	sub    $0x4,%rdx
  80159b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80159f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015a3:	48 89 c7             	mov    %rax,%rdi
  8015a6:	48 89 d6             	mov    %rdx,%rsi
  8015a9:	fd                   	std    
  8015aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ac:	eb 1d                	jmp    8015cb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ba:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	48 89 d7             	mov    %rdx,%rdi
  8015c5:	48 89 c1             	mov    %rax,%rcx
  8015c8:	fd                   	std    
  8015c9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015cb:	fc                   	cld    
  8015cc:	eb 57                	jmp    801625 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d2:	83 e0 03             	and    $0x3,%eax
  8015d5:	48 85 c0             	test   %rax,%rax
  8015d8:	75 36                	jne    801610 <memmove+0xfc>
  8015da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015de:	83 e0 03             	and    $0x3,%eax
  8015e1:	48 85 c0             	test   %rax,%rax
  8015e4:	75 2a                	jne    801610 <memmove+0xfc>
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	83 e0 03             	and    $0x3,%eax
  8015ed:	48 85 c0             	test   %rax,%rax
  8015f0:	75 1e                	jne    801610 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f6:	48 c1 e8 02          	shr    $0x2,%rax
  8015fa:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801601:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801605:	48 89 c7             	mov    %rax,%rdi
  801608:	48 89 d6             	mov    %rdx,%rsi
  80160b:	fc                   	cld    
  80160c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80160e:	eb 15                	jmp    801625 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801614:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801618:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80161c:	48 89 c7             	mov    %rax,%rdi
  80161f:	48 89 d6             	mov    %rdx,%rsi
  801622:	fc                   	cld    
  801623:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801629:	c9                   	leaveq 
  80162a:	c3                   	retq   

000000000080162b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80162b:	55                   	push   %rbp
  80162c:	48 89 e5             	mov    %rsp,%rbp
  80162f:	48 83 ec 18          	sub    $0x18,%rsp
  801633:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801637:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80163b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80163f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801643:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801647:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164b:	48 89 ce             	mov    %rcx,%rsi
  80164e:	48 89 c7             	mov    %rax,%rdi
  801651:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  801658:	00 00 00 
  80165b:	ff d0                	callq  *%rax
}
  80165d:	c9                   	leaveq 
  80165e:	c3                   	retq   

000000000080165f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80165f:	55                   	push   %rbp
  801660:	48 89 e5             	mov    %rsp,%rbp
  801663:	48 83 ec 28          	sub    $0x28,%rsp
  801667:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80166b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80166f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801677:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80167b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80167f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801683:	eb 36                	jmp    8016bb <memcmp+0x5c>
		if (*s1 != *s2)
  801685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801689:	0f b6 10             	movzbl (%rax),%edx
  80168c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	38 c2                	cmp    %al,%dl
  801695:	74 1a                	je     8016b1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169b:	0f b6 00             	movzbl (%rax),%eax
  80169e:	0f b6 d0             	movzbl %al,%edx
  8016a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	0f b6 c0             	movzbl %al,%eax
  8016ab:	29 c2                	sub    %eax,%edx
  8016ad:	89 d0                	mov    %edx,%eax
  8016af:	eb 20                	jmp    8016d1 <memcmp+0x72>
		s1++, s2++;
  8016b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016c7:	48 85 c0             	test   %rax,%rax
  8016ca:	75 b9                	jne    801685 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d1:	c9                   	leaveq 
  8016d2:	c3                   	retq   

00000000008016d3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016d3:	55                   	push   %rbp
  8016d4:	48 89 e5             	mov    %rsp,%rbp
  8016d7:	48 83 ec 28          	sub    $0x28,%rsp
  8016db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ee:	48 01 d0             	add    %rdx,%rax
  8016f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016f5:	eb 15                	jmp    80170c <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fb:	0f b6 10             	movzbl (%rax),%edx
  8016fe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801701:	38 c2                	cmp    %al,%dl
  801703:	75 02                	jne    801707 <memfind+0x34>
			break;
  801705:	eb 0f                	jmp    801716 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801707:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80170c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801710:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801714:	72 e1                	jb     8016f7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171a:	c9                   	leaveq 
  80171b:	c3                   	retq   

000000000080171c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80171c:	55                   	push   %rbp
  80171d:	48 89 e5             	mov    %rsp,%rbp
  801720:	48 83 ec 34          	sub    $0x34,%rsp
  801724:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801728:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80172c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801736:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80173d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80173e:	eb 05                	jmp    801745 <strtol+0x29>
		s++;
  801740:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	3c 20                	cmp    $0x20,%al
  80174e:	74 f0                	je     801740 <strtol+0x24>
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	3c 09                	cmp    $0x9,%al
  801759:	74 e5                	je     801740 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	3c 2b                	cmp    $0x2b,%al
  801764:	75 07                	jne    80176d <strtol+0x51>
		s++;
  801766:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80176b:	eb 17                	jmp    801784 <strtol+0x68>
	else if (*s == '-')
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	3c 2d                	cmp    $0x2d,%al
  801776:	75 0c                	jne    801784 <strtol+0x68>
		s++, neg = 1;
  801778:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80177d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801784:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801788:	74 06                	je     801790 <strtol+0x74>
  80178a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80178e:	75 28                	jne    8017b8 <strtol+0x9c>
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	3c 30                	cmp    $0x30,%al
  801799:	75 1d                	jne    8017b8 <strtol+0x9c>
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	48 83 c0 01          	add    $0x1,%rax
  8017a3:	0f b6 00             	movzbl (%rax),%eax
  8017a6:	3c 78                	cmp    $0x78,%al
  8017a8:	75 0e                	jne    8017b8 <strtol+0x9c>
		s += 2, base = 16;
  8017aa:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017af:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017b6:	eb 2c                	jmp    8017e4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017bc:	75 19                	jne    8017d7 <strtol+0xbb>
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	0f b6 00             	movzbl (%rax),%eax
  8017c5:	3c 30                	cmp    $0x30,%al
  8017c7:	75 0e                	jne    8017d7 <strtol+0xbb>
		s++, base = 8;
  8017c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ce:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017d5:	eb 0d                	jmp    8017e4 <strtol+0xc8>
	else if (base == 0)
  8017d7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017db:	75 07                	jne    8017e4 <strtol+0xc8>
		base = 10;
  8017dd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	0f b6 00             	movzbl (%rax),%eax
  8017eb:	3c 2f                	cmp    $0x2f,%al
  8017ed:	7e 1d                	jle    80180c <strtol+0xf0>
  8017ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f3:	0f b6 00             	movzbl (%rax),%eax
  8017f6:	3c 39                	cmp    $0x39,%al
  8017f8:	7f 12                	jg     80180c <strtol+0xf0>
			dig = *s - '0';
  8017fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fe:	0f b6 00             	movzbl (%rax),%eax
  801801:	0f be c0             	movsbl %al,%eax
  801804:	83 e8 30             	sub    $0x30,%eax
  801807:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80180a:	eb 4e                	jmp    80185a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80180c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801810:	0f b6 00             	movzbl (%rax),%eax
  801813:	3c 60                	cmp    $0x60,%al
  801815:	7e 1d                	jle    801834 <strtol+0x118>
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	0f b6 00             	movzbl (%rax),%eax
  80181e:	3c 7a                	cmp    $0x7a,%al
  801820:	7f 12                	jg     801834 <strtol+0x118>
			dig = *s - 'a' + 10;
  801822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801826:	0f b6 00             	movzbl (%rax),%eax
  801829:	0f be c0             	movsbl %al,%eax
  80182c:	83 e8 57             	sub    $0x57,%eax
  80182f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801832:	eb 26                	jmp    80185a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	0f b6 00             	movzbl (%rax),%eax
  80183b:	3c 40                	cmp    $0x40,%al
  80183d:	7e 48                	jle    801887 <strtol+0x16b>
  80183f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801843:	0f b6 00             	movzbl (%rax),%eax
  801846:	3c 5a                	cmp    $0x5a,%al
  801848:	7f 3d                	jg     801887 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80184a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	0f be c0             	movsbl %al,%eax
  801854:	83 e8 37             	sub    $0x37,%eax
  801857:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80185a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80185d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801860:	7c 02                	jl     801864 <strtol+0x148>
			break;
  801862:	eb 23                	jmp    801887 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801864:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801869:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80186c:	48 98                	cltq   
  80186e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801873:	48 89 c2             	mov    %rax,%rdx
  801876:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801879:	48 98                	cltq   
  80187b:	48 01 d0             	add    %rdx,%rax
  80187e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801882:	e9 5d ff ff ff       	jmpq   8017e4 <strtol+0xc8>

	if (endptr)
  801887:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80188c:	74 0b                	je     801899 <strtol+0x17d>
		*endptr = (char *) s;
  80188e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801892:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801896:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801899:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189d:	74 09                	je     8018a8 <strtol+0x18c>
  80189f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a3:	48 f7 d8             	neg    %rax
  8018a6:	eb 04                	jmp    8018ac <strtol+0x190>
  8018a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018ac:	c9                   	leaveq 
  8018ad:	c3                   	retq   

00000000008018ae <strstr>:

char * strstr(const char *in, const char *str)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 30          	sub    $0x30,%rsp
  8018b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018c6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ca:	0f b6 00             	movzbl (%rax),%eax
  8018cd:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018d0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018d4:	75 06                	jne    8018dc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	eb 6b                	jmp    801947 <strstr+0x99>

	len = strlen(str);
  8018dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e0:	48 89 c7             	mov    %rax,%rdi
  8018e3:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  8018ea:	00 00 00 
  8018ed:	ff d0                	callq  *%rax
  8018ef:	48 98                	cltq   
  8018f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801907:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80190b:	75 07                	jne    801914 <strstr+0x66>
				return (char *) 0;
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
  801912:	eb 33                	jmp    801947 <strstr+0x99>
		} while (sc != c);
  801914:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801918:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80191b:	75 d8                	jne    8018f5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80191d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801921:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801929:	48 89 ce             	mov    %rcx,%rsi
  80192c:	48 89 c7             	mov    %rax,%rdi
  80192f:	48 b8 a5 13 80 00 00 	movabs $0x8013a5,%rax
  801936:	00 00 00 
  801939:	ff d0                	callq  *%rax
  80193b:	85 c0                	test   %eax,%eax
  80193d:	75 b6                	jne    8018f5 <strstr+0x47>

	return (char *) (in - 1);
  80193f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801943:	48 83 e8 01          	sub    $0x1,%rax
}
  801947:	c9                   	leaveq 
  801948:	c3                   	retq   

0000000000801949 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801949:	55                   	push   %rbp
  80194a:	48 89 e5             	mov    %rsp,%rbp
  80194d:	53                   	push   %rbx
  80194e:	48 83 ec 48          	sub    $0x48,%rsp
  801952:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801955:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801958:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80195c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801960:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801964:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801968:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80196b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80196f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801973:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801977:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80197b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80197f:	4c 89 c3             	mov    %r8,%rbx
  801982:	cd 30                	int    $0x30
  801984:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801988:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80198c:	74 3e                	je     8019cc <syscall+0x83>
  80198e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801993:	7e 37                	jle    8019cc <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801999:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80199c:	49 89 d0             	mov    %rdx,%r8
  80199f:	89 c1                	mov    %eax,%ecx
  8019a1:	48 ba 08 47 80 00 00 	movabs $0x804708,%rdx
  8019a8:	00 00 00 
  8019ab:	be 23 00 00 00       	mov    $0x23,%esi
  8019b0:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  8019b7:	00 00 00 
  8019ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bf:	49 b9 ef 03 80 00 00 	movabs $0x8003ef,%r9
  8019c6:	00 00 00 
  8019c9:	41 ff d1             	callq  *%r9

	return ret;
  8019cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d0:	48 83 c4 48          	add    $0x48,%rsp
  8019d4:	5b                   	pop    %rbx
  8019d5:	5d                   	pop    %rbp
  8019d6:	c3                   	retq   

00000000008019d7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019d7:	55                   	push   %rbp
  8019d8:	48 89 e5             	mov    %rsp,%rbp
  8019db:	48 83 ec 20          	sub    $0x20,%rsp
  8019df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f6:	00 
  8019f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a03:	48 89 d1             	mov    %rdx,%rcx
  801a06:	48 89 c2             	mov    %rax,%rdx
  801a09:	be 00 00 00 00       	mov    $0x0,%esi
  801a0e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a13:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	callq  *%rax
}
  801a1f:	c9                   	leaveq 
  801a20:	c3                   	retq   

0000000000801a21 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a21:	55                   	push   %rbp
  801a22:	48 89 e5             	mov    %rsp,%rbp
  801a25:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a30:	00 
  801a31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
  801a47:	be 00 00 00 00       	mov    $0x0,%esi
  801a4c:	bf 01 00 00 00       	mov    $0x1,%edi
  801a51:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801a58:	00 00 00 
  801a5b:	ff d0                	callq  *%rax
}
  801a5d:	c9                   	leaveq 
  801a5e:	c3                   	retq   

0000000000801a5f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a5f:	55                   	push   %rbp
  801a60:	48 89 e5             	mov    %rsp,%rbp
  801a63:	48 83 ec 10          	sub    $0x10,%rsp
  801a67:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6d:	48 98                	cltq   
  801a6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a76:	00 
  801a77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a83:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a88:	48 89 c2             	mov    %rax,%rdx
  801a8b:	be 01 00 00 00       	mov    $0x1,%esi
  801a90:	bf 03 00 00 00       	mov    $0x3,%edi
  801a95:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
}
  801aa1:	c9                   	leaveq 
  801aa2:	c3                   	retq   

0000000000801aa3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801aab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab2:	00 
  801ab3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac9:	be 00 00 00 00       	mov    $0x0,%esi
  801ace:	bf 02 00 00 00       	mov    $0x2,%edi
  801ad3:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_yield>:

void
sys_yield(void)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ae9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af0:	00 
  801af1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	be 00 00 00 00       	mov    $0x0,%esi
  801b0c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b11:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 20          	sub    $0x20,%rsp
  801b27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b2e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b34:	48 63 c8             	movslq %eax,%rcx
  801b37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3e:	48 98                	cltq   
  801b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b47:	00 
  801b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4e:	49 89 c8             	mov    %rcx,%r8
  801b51:	48 89 d1             	mov    %rdx,%rcx
  801b54:	48 89 c2             	mov    %rax,%rdx
  801b57:	be 01 00 00 00       	mov    $0x1,%esi
  801b5c:	bf 04 00 00 00       	mov    $0x4,%edi
  801b61:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801b68:	00 00 00 
  801b6b:	ff d0                	callq  *%rax
}
  801b6d:	c9                   	leaveq 
  801b6e:	c3                   	retq   

0000000000801b6f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b6f:	55                   	push   %rbp
  801b70:	48 89 e5             	mov    %rsp,%rbp
  801b73:	48 83 ec 30          	sub    $0x30,%rsp
  801b77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b7e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b81:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b85:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b89:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b8c:	48 63 c8             	movslq %eax,%rcx
  801b8f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b96:	48 63 f0             	movslq %eax,%rsi
  801b99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba0:	48 98                	cltq   
  801ba2:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ba6:	49 89 f9             	mov    %rdi,%r9
  801ba9:	49 89 f0             	mov    %rsi,%r8
  801bac:	48 89 d1             	mov    %rdx,%rcx
  801baf:	48 89 c2             	mov    %rax,%rdx
  801bb2:	be 01 00 00 00       	mov    $0x1,%esi
  801bb7:	bf 05 00 00 00       	mov    $0x5,%edi
  801bbc:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	callq  *%rax
}
  801bc8:	c9                   	leaveq 
  801bc9:	c3                   	retq   

0000000000801bca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	48 83 ec 20          	sub    $0x20,%rsp
  801bd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be0:	48 98                	cltq   
  801be2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be9:	00 
  801bea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf6:	48 89 d1             	mov    %rdx,%rcx
  801bf9:	48 89 c2             	mov    %rax,%rdx
  801bfc:	be 01 00 00 00       	mov    $0x1,%esi
  801c01:	bf 06 00 00 00       	mov    $0x6,%edi
  801c06:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax
}
  801c12:	c9                   	leaveq 
  801c13:	c3                   	retq   

0000000000801c14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c14:	55                   	push   %rbp
  801c15:	48 89 e5             	mov    %rsp,%rbp
  801c18:	48 83 ec 10          	sub    $0x10,%rsp
  801c1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c25:	48 63 d0             	movslq %eax,%rdx
  801c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2b:	48 98                	cltq   
  801c2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c34:	00 
  801c35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c41:	48 89 d1             	mov    %rdx,%rcx
  801c44:	48 89 c2             	mov    %rax,%rdx
  801c47:	be 01 00 00 00       	mov    $0x1,%esi
  801c4c:	bf 08 00 00 00       	mov    $0x8,%edi
  801c51:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
}
  801c5d:	c9                   	leaveq 
  801c5e:	c3                   	retq   

0000000000801c5f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c5f:	55                   	push   %rbp
  801c60:	48 89 e5             	mov    %rsp,%rbp
  801c63:	48 83 ec 20          	sub    $0x20,%rsp
  801c67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c75:	48 98                	cltq   
  801c77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7e:	00 
  801c7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8b:	48 89 d1             	mov    %rdx,%rcx
  801c8e:	48 89 c2             	mov    %rax,%rdx
  801c91:	be 01 00 00 00       	mov    $0x1,%esi
  801c96:	bf 09 00 00 00       	mov    $0x9,%edi
  801c9b:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	callq  *%rax
}
  801ca7:	c9                   	leaveq 
  801ca8:	c3                   	retq   

0000000000801ca9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ca9:	55                   	push   %rbp
  801caa:	48 89 e5             	mov    %rsp,%rbp
  801cad:	48 83 ec 20          	sub    $0x20,%rsp
  801cb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbf:	48 98                	cltq   
  801cc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc8:	00 
  801cc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ccf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd5:	48 89 d1             	mov    %rdx,%rcx
  801cd8:	48 89 c2             	mov    %rax,%rdx
  801cdb:	be 01 00 00 00       	mov    $0x1,%esi
  801ce0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ce5:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801cec:	00 00 00 
  801cef:	ff d0                	callq  *%rax
}
  801cf1:	c9                   	leaveq 
  801cf2:	c3                   	retq   

0000000000801cf3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cf3:	55                   	push   %rbp
  801cf4:	48 89 e5             	mov    %rsp,%rbp
  801cf7:	48 83 ec 20          	sub    $0x20,%rsp
  801cfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d02:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d06:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d0c:	48 63 f0             	movslq %eax,%rsi
  801d0f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d16:	48 98                	cltq   
  801d18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d23:	00 
  801d24:	49 89 f1             	mov    %rsi,%r9
  801d27:	49 89 c8             	mov    %rcx,%r8
  801d2a:	48 89 d1             	mov    %rdx,%rcx
  801d2d:	48 89 c2             	mov    %rax,%rdx
  801d30:	be 00 00 00 00       	mov    $0x0,%esi
  801d35:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d3a:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801d41:	00 00 00 
  801d44:	ff d0                	callq  *%rax
}
  801d46:	c9                   	leaveq 
  801d47:	c3                   	retq   

0000000000801d48 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d48:	55                   	push   %rbp
  801d49:	48 89 e5             	mov    %rsp,%rbp
  801d4c:	48 83 ec 10          	sub    $0x10,%rsp
  801d50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5f:	00 
  801d60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d71:	48 89 c2             	mov    %rax,%rdx
  801d74:	be 01 00 00 00       	mov    $0x1,%esi
  801d79:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d7e:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  801d85:	00 00 00 
  801d88:	ff d0                	callq  *%rax
}
  801d8a:	c9                   	leaveq 
  801d8b:	c3                   	retq   

0000000000801d8c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d8c:	55                   	push   %rbp
  801d8d:	48 89 e5             	mov    %rsp,%rbp
  801d90:	48 83 ec 30          	sub    $0x30,%rsp
  801d94:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9c:	48 8b 00             	mov    (%rax),%rax
  801d9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801da3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dab:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801dae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801db1:	83 e0 02             	and    $0x2,%eax
  801db4:	85 c0                	test   %eax,%eax
  801db6:	75 4d                	jne    801e05 <pgfault+0x79>
  801db8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dbc:	48 c1 e8 0c          	shr    $0xc,%rax
  801dc0:	48 89 c2             	mov    %rax,%rdx
  801dc3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dca:	01 00 00 
  801dcd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd1:	25 00 08 00 00       	and    $0x800,%eax
  801dd6:	48 85 c0             	test   %rax,%rax
  801dd9:	74 2a                	je     801e05 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801ddb:	48 ba 38 47 80 00 00 	movabs $0x804738,%rdx
  801de2:	00 00 00 
  801de5:	be 1e 00 00 00       	mov    $0x1e,%esi
  801dea:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  801df1:	00 00 00 
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  801e00:	00 00 00 
  801e03:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801e05:	ba 07 00 00 00       	mov    $0x7,%edx
  801e0a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e14:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	85 c0                	test   %eax,%eax
  801e22:	0f 85 cd 00 00 00    	jne    801ef5 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e34:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e3a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e42:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e47:	48 89 c6             	mov    %rax,%rsi
  801e4a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e4f:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e5f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e65:	48 89 c1             	mov    %rax,%rcx
  801e68:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e72:	bf 00 00 00 00       	mov    $0x0,%edi
  801e77:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	callq  *%rax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	79 2a                	jns    801eb1 <pgfault+0x125>
				panic("Page map at temp address failed");
  801e87:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  801e8e:	00 00 00 
  801e91:	be 2f 00 00 00       	mov    $0x2f,%esi
  801e96:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  801e9d:	00 00 00 
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea5:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  801eac:	00 00 00 
  801eaf:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801eb1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebb:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  801ec2:	00 00 00 
  801ec5:	ff d0                	callq  *%rax
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	79 54                	jns    801f1f <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ecb:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  801ed2:	00 00 00 
  801ed5:	be 31 00 00 00       	mov    $0x31,%esi
  801eda:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  801ee1:	00 00 00 
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  801ef0:	00 00 00 
  801ef3:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801ef5:	48 ba b0 47 80 00 00 	movabs $0x8047b0,%rdx
  801efc:	00 00 00 
  801eff:	be 35 00 00 00       	mov    $0x35,%esi
  801f04:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  801f0b:	00 00 00 
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f13:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  801f1a:	00 00 00 
  801f1d:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801f1f:	c9                   	leaveq 
  801f20:	c3                   	retq   

0000000000801f21 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f21:	55                   	push   %rbp
  801f22:	48 89 e5             	mov    %rsp,%rbp
  801f25:	48 83 ec 20          	sub    $0x20,%rsp
  801f29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f2c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801f2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f36:	01 00 00 
  801f39:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f40:	25 07 0e 00 00       	and    $0xe07,%eax
  801f45:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f48:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f4b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f56:	25 00 04 00 00       	and    $0x400,%eax
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	74 57                	je     801fb6 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f5f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f62:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f66:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6d:	41 89 f0             	mov    %esi,%r8d
  801f70:	48 89 c6             	mov    %rax,%rsi
  801f73:	bf 00 00 00 00       	mov    $0x0,%edi
  801f78:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	callq  *%rax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	0f 8e 52 01 00 00    	jle    8020de <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801f8c:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  801f93:	00 00 00 
  801f96:	be 52 00 00 00       	mov    $0x52,%esi
  801f9b:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  801fa2:	00 00 00 
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  801fb1:	00 00 00 
  801fb4:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801fb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb9:	83 e0 02             	and    $0x2,%eax
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	75 10                	jne    801fd0 <duppage+0xaf>
  801fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc3:	25 00 08 00 00       	and    $0x800,%eax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	0f 84 bb 00 00 00    	je     80208b <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801fd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd3:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801fd8:	80 cc 08             	or     $0x8,%ah
  801fdb:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fde:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fe1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fe5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fec:	41 89 f0             	mov    %esi,%r8d
  801fef:	48 89 c6             	mov    %rax,%rsi
  801ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff7:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  801ffe:	00 00 00 
  802001:	ff d0                	callq  *%rax
  802003:	85 c0                	test   %eax,%eax
  802005:	7e 2a                	jle    802031 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  802007:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  80200e:	00 00 00 
  802011:	be 5a 00 00 00       	mov    $0x5a,%esi
  802016:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  80201d:	00 00 00 
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  80202c:	00 00 00 
  80202f:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802031:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802034:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203c:	41 89 c8             	mov    %ecx,%r8d
  80203f:	48 89 d1             	mov    %rdx,%rcx
  802042:	ba 00 00 00 00       	mov    $0x0,%edx
  802047:	48 89 c6             	mov    %rax,%rsi
  80204a:	bf 00 00 00 00       	mov    $0x0,%edi
  80204f:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	7e 2a                	jle    802089 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  80205f:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  802066:	00 00 00 
  802069:	be 5d 00 00 00       	mov    $0x5d,%esi
  80206e:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  802075:	00 00 00 
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  802084:	00 00 00 
  802087:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802089:	eb 53                	jmp    8020de <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  80208b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80208e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802092:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802099:	41 89 f0             	mov    %esi,%r8d
  80209c:	48 89 c6             	mov    %rax,%rsi
  80209f:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a4:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	7e 2a                	jle    8020de <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  8020b4:	48 ba dd 47 80 00 00 	movabs $0x8047dd,%rdx
  8020bb:	00 00 00 
  8020be:	be 61 00 00 00       	mov    $0x61,%esi
  8020c3:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  8020ca:	00 00 00 
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d2:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  8020d9:	00 00 00 
  8020dc:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e3:	c9                   	leaveq 
  8020e4:	c3                   	retq   

00000000008020e5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8020e5:	55                   	push   %rbp
  8020e6:	48 89 e5             	mov    %rsp,%rbp
  8020e9:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  8020ed:	48 bf 8c 1d 80 00 00 	movabs $0x801d8c,%rdi
  8020f4:	00 00 00 
  8020f7:	48 b8 f8 3c 80 00 00 	movabs $0x803cf8,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802103:	b8 07 00 00 00       	mov    $0x7,%eax
  802108:	cd 30                	int    $0x30
  80210a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80210d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802110:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  802113:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802117:	79 30                	jns    802149 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802119:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80211c:	89 c1                	mov    %eax,%ecx
  80211e:	48 ba fb 47 80 00 00 	movabs $0x8047fb,%rdx
  802125:	00 00 00 
  802128:	be 89 00 00 00       	mov    $0x89,%esi
  80212d:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  802134:	00 00 00 
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  802143:	00 00 00 
  802146:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  802149:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80214d:	75 46                	jne    802195 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  80214f:	48 b8 a3 1a 80 00 00 	movabs $0x801aa3,%rax
  802156:	00 00 00 
  802159:	ff d0                	callq  *%rax
  80215b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802160:	48 63 d0             	movslq %eax,%rdx
  802163:	48 89 d0             	mov    %rdx,%rax
  802166:	48 c1 e0 03          	shl    $0x3,%rax
  80216a:	48 01 d0             	add    %rdx,%rax
  80216d:	48 c1 e0 05          	shl    $0x5,%rax
  802171:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802178:	00 00 00 
  80217b:	48 01 c2             	add    %rax,%rdx
  80217e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802185:	00 00 00 
  802188:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
  802190:	e9 d1 01 00 00       	jmpq   802366 <fork+0x281>
	}

	uint64_t ad = 0;
  802195:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80219c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  80219d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8021a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021a6:	e9 df 00 00 00       	jmpq   80228a <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8021ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021af:	48 c1 e8 27          	shr    $0x27,%rax
  8021b3:	48 89 c2             	mov    %rax,%rdx
  8021b6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021bd:	01 00 00 
  8021c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c4:	83 e0 01             	and    $0x1,%eax
  8021c7:	48 85 c0             	test   %rax,%rax
  8021ca:	0f 84 9e 00 00 00    	je     80226e <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8021d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021d8:	48 89 c2             	mov    %rax,%rdx
  8021db:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021e2:	01 00 00 
  8021e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e9:	83 e0 01             	and    $0x1,%eax
  8021ec:	48 85 c0             	test   %rax,%rax
  8021ef:	74 73                	je     802264 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8021f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f5:	48 c1 e8 15          	shr    $0x15,%rax
  8021f9:	48 89 c2             	mov    %rax,%rdx
  8021fc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802203:	01 00 00 
  802206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220a:	83 e0 01             	and    $0x1,%eax
  80220d:	48 85 c0             	test   %rax,%rax
  802210:	74 48                	je     80225a <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802216:	48 c1 e8 0c          	shr    $0xc,%rax
  80221a:	48 89 c2             	mov    %rax,%rdx
  80221d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802224:	01 00 00 
  802227:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80222f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802233:	83 e0 01             	and    $0x1,%eax
  802236:	48 85 c0             	test   %rax,%rax
  802239:	74 47                	je     802282 <fork+0x19d>
						duppage(envid, VPN(addr));
  80223b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223f:	48 c1 e8 0c          	shr    $0xc,%rax
  802243:	89 c2                	mov    %eax,%edx
  802245:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802248:	89 d6                	mov    %edx,%esi
  80224a:	89 c7                	mov    %eax,%edi
  80224c:	48 b8 21 1f 80 00 00 	movabs $0x801f21,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	eb 28                	jmp    802282 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  80225a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802261:	00 
  802262:	eb 1e                	jmp    802282 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802264:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80226b:	40 
  80226c:	eb 14                	jmp    802282 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  80226e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802272:	48 c1 e8 27          	shr    $0x27,%rax
  802276:	48 83 c0 01          	add    $0x1,%rax
  80227a:	48 c1 e0 27          	shl    $0x27,%rax
  80227e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802282:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802289:	00 
  80228a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802291:	00 
  802292:	0f 87 13 ff ff ff    	ja     8021ab <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802298:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80229b:	ba 07 00 00 00       	mov    $0x7,%edx
  8022a0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8022a5:	89 c7                	mov    %eax,%edi
  8022a7:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8022b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022b6:	ba 07 00 00 00       	mov    $0x7,%edx
  8022bb:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022c0:	89 c7                	mov    %eax,%edi
  8022c2:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  8022c9:	00 00 00 
  8022cc:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8022ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022d1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8022d7:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8022dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022e6:	89 c7                	mov    %eax,%edi
  8022e8:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8022f4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022f9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022fe:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802303:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  80230a:	00 00 00 
  80230d:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80230f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802314:	bf 00 00 00 00       	mov    $0x0,%edi
  802319:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  802320:	00 00 00 
  802323:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802325:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80232c:	00 00 00 
  80232f:	48 8b 00             	mov    (%rax),%rax
  802332:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802339:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80233c:	48 89 d6             	mov    %rdx,%rsi
  80233f:	89 c7                	mov    %eax,%edi
  802341:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  802348:	00 00 00 
  80234b:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80234d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802350:	be 02 00 00 00       	mov    $0x2,%esi
  802355:	89 c7                	mov    %eax,%edi
  802357:	48 b8 14 1c 80 00 00 	movabs $0x801c14,%rax
  80235e:	00 00 00 
  802361:	ff d0                	callq  *%rax

	return envid;
  802363:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  802366:	c9                   	leaveq 
  802367:	c3                   	retq   

0000000000802368 <sfork>:

// Challenge!
int
sfork(void)
{
  802368:	55                   	push   %rbp
  802369:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80236c:	48 ba 13 48 80 00 00 	movabs $0x804813,%rdx
  802373:	00 00 00 
  802376:	be b8 00 00 00       	mov    $0xb8,%esi
  80237b:	48 bf 5d 47 80 00 00 	movabs $0x80475d,%rdi
  802382:	00 00 00 
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
  80238a:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  802391:	00 00 00 
  802394:	ff d1                	callq  *%rcx

0000000000802396 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802396:	55                   	push   %rbp
  802397:	48 89 e5             	mov    %rsp,%rbp
  80239a:	48 83 ec 08          	sub    $0x8,%rsp
  80239e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023a6:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023ad:	ff ff ff 
  8023b0:	48 01 d0             	add    %rdx,%rax
  8023b3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023b7:	c9                   	leaveq 
  8023b8:	c3                   	retq   

00000000008023b9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023b9:	55                   	push   %rbp
  8023ba:	48 89 e5             	mov    %rsp,%rbp
  8023bd:	48 83 ec 08          	sub    $0x8,%rsp
  8023c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c9:	48 89 c7             	mov    %rax,%rdi
  8023cc:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	callq  *%rax
  8023d8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023de:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023e2:	c9                   	leaveq 
  8023e3:	c3                   	retq   

00000000008023e4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023e4:	55                   	push   %rbp
  8023e5:	48 89 e5             	mov    %rsp,%rbp
  8023e8:	48 83 ec 18          	sub    $0x18,%rsp
  8023ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023f7:	eb 6b                	jmp    802464 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fc:	48 98                	cltq   
  8023fe:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802404:	48 c1 e0 0c          	shl    $0xc,%rax
  802408:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80240c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802410:	48 c1 e8 15          	shr    $0x15,%rax
  802414:	48 89 c2             	mov    %rax,%rdx
  802417:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80241e:	01 00 00 
  802421:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802425:	83 e0 01             	and    $0x1,%eax
  802428:	48 85 c0             	test   %rax,%rax
  80242b:	74 21                	je     80244e <fd_alloc+0x6a>
  80242d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802431:	48 c1 e8 0c          	shr    $0xc,%rax
  802435:	48 89 c2             	mov    %rax,%rdx
  802438:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80243f:	01 00 00 
  802442:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802446:	83 e0 01             	and    $0x1,%eax
  802449:	48 85 c0             	test   %rax,%rax
  80244c:	75 12                	jne    802460 <fd_alloc+0x7c>
			*fd_store = fd;
  80244e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802452:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802456:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	eb 1a                	jmp    80247a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802460:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802464:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802468:	7e 8f                	jle    8023f9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80246a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802475:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80247a:	c9                   	leaveq 
  80247b:	c3                   	retq   

000000000080247c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80247c:	55                   	push   %rbp
  80247d:	48 89 e5             	mov    %rsp,%rbp
  802480:	48 83 ec 20          	sub    $0x20,%rsp
  802484:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802487:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80248b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80248f:	78 06                	js     802497 <fd_lookup+0x1b>
  802491:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802495:	7e 07                	jle    80249e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249c:	eb 6c                	jmp    80250a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80249e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a1:	48 98                	cltq   
  8024a3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024a9:	48 c1 e0 0c          	shl    $0xc,%rax
  8024ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b5:	48 c1 e8 15          	shr    $0x15,%rax
  8024b9:	48 89 c2             	mov    %rax,%rdx
  8024bc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024c3:	01 00 00 
  8024c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ca:	83 e0 01             	and    $0x1,%eax
  8024cd:	48 85 c0             	test   %rax,%rax
  8024d0:	74 21                	je     8024f3 <fd_lookup+0x77>
  8024d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8024da:	48 89 c2             	mov    %rax,%rdx
  8024dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024e4:	01 00 00 
  8024e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024eb:	83 e0 01             	and    $0x1,%eax
  8024ee:	48 85 c0             	test   %rax,%rax
  8024f1:	75 07                	jne    8024fa <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024f8:	eb 10                	jmp    80250a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802502:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250a:	c9                   	leaveq 
  80250b:	c3                   	retq   

000000000080250c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80250c:	55                   	push   %rbp
  80250d:	48 89 e5             	mov    %rsp,%rbp
  802510:	48 83 ec 30          	sub    $0x30,%rsp
  802514:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802518:	89 f0                	mov    %esi,%eax
  80251a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80251d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802521:	48 89 c7             	mov    %rax,%rdi
  802524:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  80252b:	00 00 00 
  80252e:	ff d0                	callq  *%rax
  802530:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802534:	48 89 d6             	mov    %rdx,%rsi
  802537:	89 c7                	mov    %eax,%edi
  802539:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax
  802545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254c:	78 0a                	js     802558 <fd_close+0x4c>
	    || fd != fd2)
  80254e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802552:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802556:	74 12                	je     80256a <fd_close+0x5e>
		return (must_exist ? r : 0);
  802558:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80255c:	74 05                	je     802563 <fd_close+0x57>
  80255e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802561:	eb 05                	jmp    802568 <fd_close+0x5c>
  802563:	b8 00 00 00 00       	mov    $0x0,%eax
  802568:	eb 69                	jmp    8025d3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80256a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80256e:	8b 00                	mov    (%rax),%eax
  802570:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802574:	48 89 d6             	mov    %rdx,%rsi
  802577:	89 c7                	mov    %eax,%edi
  802579:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  802580:	00 00 00 
  802583:	ff d0                	callq  *%rax
  802585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258c:	78 2a                	js     8025b8 <fd_close+0xac>
		if (dev->dev_close)
  80258e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802592:	48 8b 40 20          	mov    0x20(%rax),%rax
  802596:	48 85 c0             	test   %rax,%rax
  802599:	74 16                	je     8025b1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80259b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259f:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025a7:	48 89 d7             	mov    %rdx,%rdi
  8025aa:	ff d0                	callq  *%rax
  8025ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025af:	eb 07                	jmp    8025b8 <fd_close+0xac>
		else
			r = 0;
  8025b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025bc:	48 89 c6             	mov    %rax,%rsi
  8025bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c4:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  8025cb:	00 00 00 
  8025ce:	ff d0                	callq  *%rax
	return r;
  8025d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025d3:	c9                   	leaveq 
  8025d4:	c3                   	retq   

00000000008025d5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025d5:	55                   	push   %rbp
  8025d6:	48 89 e5             	mov    %rsp,%rbp
  8025d9:	48 83 ec 20          	sub    $0x20,%rsp
  8025dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025eb:	eb 41                	jmp    80262e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025ed:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025f4:	00 00 00 
  8025f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025fa:	48 63 d2             	movslq %edx,%rdx
  8025fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802601:	8b 00                	mov    (%rax),%eax
  802603:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802606:	75 22                	jne    80262a <dev_lookup+0x55>
			*dev = devtab[i];
  802608:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80260f:	00 00 00 
  802612:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802615:	48 63 d2             	movslq %edx,%rdx
  802618:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80261c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802620:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	eb 60                	jmp    80268a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80262a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80262e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802635:	00 00 00 
  802638:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80263b:	48 63 d2             	movslq %edx,%rdx
  80263e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802642:	48 85 c0             	test   %rax,%rax
  802645:	75 a6                	jne    8025ed <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802647:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80264e:	00 00 00 
  802651:	48 8b 00             	mov    (%rax),%rax
  802654:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80265a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80265d:	89 c6                	mov    %eax,%esi
  80265f:	48 bf 30 48 80 00 00 	movabs $0x804830,%rdi
  802666:	00 00 00 
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	48 b9 28 06 80 00 00 	movabs $0x800628,%rcx
  802675:	00 00 00 
  802678:	ff d1                	callq  *%rcx
	*dev = 0;
  80267a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80267e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802685:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <close>:

int
close(int fdnum)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 20          	sub    $0x20,%rsp
  802694:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802697:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80269b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80269e:	48 89 d6             	mov    %rdx,%rsi
  8026a1:	89 c7                	mov    %eax,%edi
  8026a3:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	callq  *%rax
  8026af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b6:	79 05                	jns    8026bd <close+0x31>
		return r;
  8026b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bb:	eb 18                	jmp    8026d5 <close+0x49>
	else
		return fd_close(fd, 1);
  8026bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c1:	be 01 00 00 00       	mov    $0x1,%esi
  8026c6:	48 89 c7             	mov    %rax,%rdi
  8026c9:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  8026d0:	00 00 00 
  8026d3:	ff d0                	callq  *%rax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   

00000000008026d7 <close_all>:

void
close_all(void)
{
  8026d7:	55                   	push   %rbp
  8026d8:	48 89 e5             	mov    %rsp,%rbp
  8026db:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026e6:	eb 15                	jmp    8026fd <close_all+0x26>
		close(i);
  8026e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026eb:	89 c7                	mov    %eax,%edi
  8026ed:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8026f4:	00 00 00 
  8026f7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026fd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802701:	7e e5                	jle    8026e8 <close_all+0x11>
		close(i);
}
  802703:	c9                   	leaveq 
  802704:	c3                   	retq   

0000000000802705 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802705:	55                   	push   %rbp
  802706:	48 89 e5             	mov    %rsp,%rbp
  802709:	48 83 ec 40          	sub    $0x40,%rsp
  80270d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802710:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802713:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802717:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80271a:	48 89 d6             	mov    %rdx,%rsi
  80271d:	89 c7                	mov    %eax,%edi
  80271f:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
  80272b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802732:	79 08                	jns    80273c <dup+0x37>
		return r;
  802734:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802737:	e9 70 01 00 00       	jmpq   8028ac <dup+0x1a7>
	close(newfdnum);
  80273c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80273f:	89 c7                	mov    %eax,%edi
  802741:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802748:	00 00 00 
  80274b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80274d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802750:	48 98                	cltq   
  802752:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802758:	48 c1 e0 0c          	shl    $0xc,%rax
  80275c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802764:	48 89 c7             	mov    %rax,%rdi
  802767:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  80276e:	00 00 00 
  802771:	ff d0                	callq  *%rax
  802773:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277b:	48 89 c7             	mov    %rax,%rdi
  80277e:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
  80278a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80278e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802792:	48 c1 e8 15          	shr    $0x15,%rax
  802796:	48 89 c2             	mov    %rax,%rdx
  802799:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a0:	01 00 00 
  8027a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a7:	83 e0 01             	and    $0x1,%eax
  8027aa:	48 85 c0             	test   %rax,%rax
  8027ad:	74 73                	je     802822 <dup+0x11d>
  8027af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b7:	48 89 c2             	mov    %rax,%rdx
  8027ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c1:	01 00 00 
  8027c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c8:	83 e0 01             	and    $0x1,%eax
  8027cb:	48 85 c0             	test   %rax,%rax
  8027ce:	74 52                	je     802822 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8027d8:	48 89 c2             	mov    %rax,%rdx
  8027db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027e2:	01 00 00 
  8027e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8027ee:	89 c1                	mov    %eax,%ecx
  8027f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f8:	41 89 c8             	mov    %ecx,%r8d
  8027fb:	48 89 d1             	mov    %rdx,%rcx
  8027fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802803:	48 89 c6             	mov    %rax,%rsi
  802806:	bf 00 00 00 00       	mov    $0x0,%edi
  80280b:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax
  802817:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281e:	79 02                	jns    802822 <dup+0x11d>
			goto err;
  802820:	eb 57                	jmp    802879 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802826:	48 c1 e8 0c          	shr    $0xc,%rax
  80282a:	48 89 c2             	mov    %rax,%rdx
  80282d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802834:	01 00 00 
  802837:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80283b:	25 07 0e 00 00       	and    $0xe07,%eax
  802840:	89 c1                	mov    %eax,%ecx
  802842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802846:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80284a:	41 89 c8             	mov    %ecx,%r8d
  80284d:	48 89 d1             	mov    %rdx,%rcx
  802850:	ba 00 00 00 00       	mov    $0x0,%edx
  802855:	48 89 c6             	mov    %rax,%rsi
  802858:	bf 00 00 00 00       	mov    $0x0,%edi
  80285d:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
  802869:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802870:	79 02                	jns    802874 <dup+0x16f>
		goto err;
  802872:	eb 05                	jmp    802879 <dup+0x174>

	return newfdnum;
  802874:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802877:	eb 33                	jmp    8028ac <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287d:	48 89 c6             	mov    %rax,%rsi
  802880:	bf 00 00 00 00       	mov    $0x0,%edi
  802885:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802891:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802895:	48 89 c6             	mov    %rax,%rsi
  802898:	bf 00 00 00 00       	mov    $0x0,%edi
  80289d:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  8028a4:	00 00 00 
  8028a7:	ff d0                	callq  *%rax
	return r;
  8028a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028ac:	c9                   	leaveq 
  8028ad:	c3                   	retq   

00000000008028ae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028ae:	55                   	push   %rbp
  8028af:	48 89 e5             	mov    %rsp,%rbp
  8028b2:	48 83 ec 40          	sub    $0x40,%rsp
  8028b6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028bd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028c8:	48 89 d6             	mov    %rdx,%rsi
  8028cb:	89 c7                	mov    %eax,%edi
  8028cd:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
  8028d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e0:	78 24                	js     802906 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e6:	8b 00                	mov    (%rax),%eax
  8028e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028ec:	48 89 d6             	mov    %rdx,%rsi
  8028ef:	89 c7                	mov    %eax,%edi
  8028f1:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
  8028fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802900:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802904:	79 05                	jns    80290b <read+0x5d>
		return r;
  802906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802909:	eb 76                	jmp    802981 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80290b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290f:	8b 40 08             	mov    0x8(%rax),%eax
  802912:	83 e0 03             	and    $0x3,%eax
  802915:	83 f8 01             	cmp    $0x1,%eax
  802918:	75 3a                	jne    802954 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80291a:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802921:	00 00 00 
  802924:	48 8b 00             	mov    (%rax),%rax
  802927:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80292d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802930:	89 c6                	mov    %eax,%esi
  802932:	48 bf 4f 48 80 00 00 	movabs $0x80484f,%rdi
  802939:	00 00 00 
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
  802941:	48 b9 28 06 80 00 00 	movabs $0x800628,%rcx
  802948:	00 00 00 
  80294b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80294d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802952:	eb 2d                	jmp    802981 <read+0xd3>
	}
	if (!dev->dev_read)
  802954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802958:	48 8b 40 10          	mov    0x10(%rax),%rax
  80295c:	48 85 c0             	test   %rax,%rax
  80295f:	75 07                	jne    802968 <read+0xba>
		return -E_NOT_SUPP;
  802961:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802966:	eb 19                	jmp    802981 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802970:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802974:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802978:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80297c:	48 89 cf             	mov    %rcx,%rdi
  80297f:	ff d0                	callq  *%rax
}
  802981:	c9                   	leaveq 
  802982:	c3                   	retq   

0000000000802983 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802983:	55                   	push   %rbp
  802984:	48 89 e5             	mov    %rsp,%rbp
  802987:	48 83 ec 30          	sub    $0x30,%rsp
  80298b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80298e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802992:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802996:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80299d:	eb 49                	jmp    8029e8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80299f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a2:	48 98                	cltq   
  8029a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029a8:	48 29 c2             	sub    %rax,%rdx
  8029ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ae:	48 63 c8             	movslq %eax,%rcx
  8029b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b5:	48 01 c1             	add    %rax,%rcx
  8029b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029bb:	48 89 ce             	mov    %rcx,%rsi
  8029be:	89 c7                	mov    %eax,%edi
  8029c0:	48 b8 ae 28 80 00 00 	movabs $0x8028ae,%rax
  8029c7:	00 00 00 
  8029ca:	ff d0                	callq  *%rax
  8029cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029d3:	79 05                	jns    8029da <readn+0x57>
			return m;
  8029d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029d8:	eb 1c                	jmp    8029f6 <readn+0x73>
		if (m == 0)
  8029da:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029de:	75 02                	jne    8029e2 <readn+0x5f>
			break;
  8029e0:	eb 11                	jmp    8029f3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029eb:	48 98                	cltq   
  8029ed:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029f1:	72 ac                	jb     80299f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029f6:	c9                   	leaveq 
  8029f7:	c3                   	retq   

00000000008029f8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
  8029fc:	48 83 ec 40          	sub    $0x40,%rsp
  802a00:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a03:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a07:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a0b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a0f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a12:	48 89 d6             	mov    %rdx,%rsi
  802a15:	89 c7                	mov    %eax,%edi
  802a17:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
  802a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2a:	78 24                	js     802a50 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a30:	8b 00                	mov    (%rax),%eax
  802a32:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a36:	48 89 d6             	mov    %rdx,%rsi
  802a39:	89 c7                	mov    %eax,%edi
  802a3b:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
  802a47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4e:	79 05                	jns    802a55 <write+0x5d>
		return r;
  802a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a53:	eb 75                	jmp    802aca <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a59:	8b 40 08             	mov    0x8(%rax),%eax
  802a5c:	83 e0 03             	and    $0x3,%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	75 3a                	jne    802a9d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a63:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a6a:	00 00 00 
  802a6d:	48 8b 00             	mov    (%rax),%rax
  802a70:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a76:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a79:	89 c6                	mov    %eax,%esi
  802a7b:	48 bf 6b 48 80 00 00 	movabs $0x80486b,%rdi
  802a82:	00 00 00 
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	48 b9 28 06 80 00 00 	movabs $0x800628,%rcx
  802a91:	00 00 00 
  802a94:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a9b:	eb 2d                	jmp    802aca <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa1:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aa5:	48 85 c0             	test   %rax,%rax
  802aa8:	75 07                	jne    802ab1 <write+0xb9>
		return -E_NOT_SUPP;
  802aaa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aaf:	eb 19                	jmp    802aca <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ab1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab5:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ab9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802abd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ac1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ac5:	48 89 cf             	mov    %rcx,%rdi
  802ac8:	ff d0                	callq  *%rax
}
  802aca:	c9                   	leaveq 
  802acb:	c3                   	retq   

0000000000802acc <seek>:

int
seek(int fdnum, off_t offset)
{
  802acc:	55                   	push   %rbp
  802acd:	48 89 e5             	mov    %rsp,%rbp
  802ad0:	48 83 ec 18          	sub    $0x18,%rsp
  802ad4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ad7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ada:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ade:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ae1:	48 89 d6             	mov    %rdx,%rsi
  802ae4:	89 c7                	mov    %eax,%edi
  802ae6:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
  802af2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af9:	79 05                	jns    802b00 <seek+0x34>
		return r;
  802afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afe:	eb 0f                	jmp    802b0f <seek+0x43>
	fd->fd_offset = offset;
  802b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b04:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b07:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 30          	sub    $0x30,%rsp
  802b19:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b1c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b1f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b26:	48 89 d6             	mov    %rdx,%rsi
  802b29:	89 c7                	mov    %eax,%edi
  802b2b:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
  802b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3e:	78 24                	js     802b64 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b44:	8b 00                	mov    (%rax),%eax
  802b46:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4a:	48 89 d6             	mov    %rdx,%rsi
  802b4d:	89 c7                	mov    %eax,%edi
  802b4f:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  802b56:	00 00 00 
  802b59:	ff d0                	callq  *%rax
  802b5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b62:	79 05                	jns    802b69 <ftruncate+0x58>
		return r;
  802b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b67:	eb 72                	jmp    802bdb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6d:	8b 40 08             	mov    0x8(%rax),%eax
  802b70:	83 e0 03             	and    $0x3,%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	75 3a                	jne    802bb1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b77:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b7e:	00 00 00 
  802b81:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b84:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b8a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b8d:	89 c6                	mov    %eax,%esi
  802b8f:	48 bf 88 48 80 00 00 	movabs $0x804888,%rdi
  802b96:	00 00 00 
  802b99:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9e:	48 b9 28 06 80 00 00 	movabs $0x800628,%rcx
  802ba5:	00 00 00 
  802ba8:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802baa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802baf:	eb 2a                	jmp    802bdb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bb9:	48 85 c0             	test   %rax,%rax
  802bbc:	75 07                	jne    802bc5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bbe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc3:	eb 16                	jmp    802bdb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc9:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bcd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bd4:	89 ce                	mov    %ecx,%esi
  802bd6:	48 89 d7             	mov    %rdx,%rdi
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 30          	sub    $0x30,%rsp
  802be5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf3:	48 89 d6             	mov    %rdx,%rsi
  802bf6:	89 c7                	mov    %eax,%edi
  802bf8:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
  802c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0b:	78 24                	js     802c31 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c11:	8b 00                	mov    (%rax),%eax
  802c13:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c17:	48 89 d6             	mov    %rdx,%rsi
  802c1a:	89 c7                	mov    %eax,%edi
  802c1c:	48 b8 d5 25 80 00 00 	movabs $0x8025d5,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
  802c28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2f:	79 05                	jns    802c36 <fstat+0x59>
		return r;
  802c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c34:	eb 5e                	jmp    802c94 <fstat+0xb7>
	if (!dev->dev_stat)
  802c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c3e:	48 85 c0             	test   %rax,%rax
  802c41:	75 07                	jne    802c4a <fstat+0x6d>
		return -E_NOT_SUPP;
  802c43:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c48:	eb 4a                	jmp    802c94 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c4e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c55:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c5c:	00 00 00 
	stat->st_isdir = 0;
  802c5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c63:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c6a:	00 00 00 
	stat->st_dev = dev;
  802c6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c75:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c80:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c88:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c8c:	48 89 ce             	mov    %rcx,%rsi
  802c8f:	48 89 d7             	mov    %rdx,%rdi
  802c92:	ff d0                	callq  *%rax
}
  802c94:	c9                   	leaveq 
  802c95:	c3                   	retq   

0000000000802c96 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c96:	55                   	push   %rbp
  802c97:	48 89 e5             	mov    %rsp,%rbp
  802c9a:	48 83 ec 20          	sub    $0x20,%rsp
  802c9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ca2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802caa:	be 00 00 00 00       	mov    $0x0,%esi
  802caf:	48 89 c7             	mov    %rax,%rdi
  802cb2:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc5:	79 05                	jns    802ccc <stat+0x36>
		return fd;
  802cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cca:	eb 2f                	jmp    802cfb <stat+0x65>
	r = fstat(fd, stat);
  802ccc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd3:	48 89 d6             	mov    %rdx,%rsi
  802cd6:	89 c7                	mov    %eax,%edi
  802cd8:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
  802ce4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cea:	89 c7                	mov    %eax,%edi
  802cec:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
	return r;
  802cf8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cfb:	c9                   	leaveq 
  802cfc:	c3                   	retq   

0000000000802cfd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cfd:	55                   	push   %rbp
  802cfe:	48 89 e5             	mov    %rsp,%rbp
  802d01:	48 83 ec 10          	sub    $0x10,%rsp
  802d05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d0c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d13:	00 00 00 
  802d16:	8b 00                	mov    (%rax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	75 1d                	jne    802d39 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d1c:	bf 01 00 00 00       	mov    $0x1,%edi
  802d21:	48 b8 9b 3f 80 00 00 	movabs $0x803f9b,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
  802d2d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d34:	00 00 00 
  802d37:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d39:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d40:	00 00 00 
  802d43:	8b 00                	mov    (%rax),%eax
  802d45:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d48:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d4d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d54:	00 00 00 
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 03 3f 80 00 00 	movabs $0x803f03,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d69:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6e:	48 89 c6             	mov    %rax,%rsi
  802d71:	bf 00 00 00 00       	mov    $0x0,%edi
  802d76:	48 b8 42 3e 80 00 00 	movabs $0x803e42,%rax
  802d7d:	00 00 00 
  802d80:	ff d0                	callq  *%rax
}
  802d82:	c9                   	leaveq 
  802d83:	c3                   	retq   

0000000000802d84 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d84:	55                   	push   %rbp
  802d85:	48 89 e5             	mov    %rsp,%rbp
  802d88:	48 83 ec 20          	sub    $0x20,%rsp
  802d8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d90:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d97:	48 89 c7             	mov    %rax,%rdi
  802d9a:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802dab:	7e 0a                	jle    802db7 <open+0x33>
		return -E_BAD_PATH;
  802dad:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802db2:	e9 a5 00 00 00       	jmpq   802e5c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802db7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dbb:	48 89 c7             	mov    %rax,%rdi
  802dbe:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
  802dca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd1:	79 08                	jns    802ddb <open+0x57>
		return r;
  802dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd6:	e9 81 00 00 00       	jmpq   802e5c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddf:	48 89 c6             	mov    %rax,%rsi
  802de2:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802de9:	00 00 00 
  802dec:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802df8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dff:	00 00 00 
  802e02:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e05:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0f:	48 89 c6             	mov    %rax,%rsi
  802e12:	bf 01 00 00 00       	mov    $0x1,%edi
  802e17:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  802e1e:	00 00 00 
  802e21:	ff d0                	callq  *%rax
  802e23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2a:	79 1d                	jns    802e49 <open+0xc5>
		fd_close(fd, 0);
  802e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e30:	be 00 00 00 00       	mov    $0x0,%esi
  802e35:	48 89 c7             	mov    %rax,%rdi
  802e38:	48 b8 0c 25 80 00 00 	movabs $0x80250c,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
		return r;
  802e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e47:	eb 13                	jmp    802e5c <open+0xd8>
	}

	return fd2num(fd);
  802e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4d:	48 89 c7             	mov    %rax,%rdi
  802e50:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802e5c:	c9                   	leaveq 
  802e5d:	c3                   	retq   

0000000000802e5e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e5e:	55                   	push   %rbp
  802e5f:	48 89 e5             	mov    %rsp,%rbp
  802e62:	48 83 ec 10          	sub    $0x10,%rsp
  802e66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6e:	8b 50 0c             	mov    0xc(%rax),%edx
  802e71:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e78:	00 00 00 
  802e7b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e7d:	be 00 00 00 00       	mov    $0x0,%esi
  802e82:	bf 06 00 00 00       	mov    $0x6,%edi
  802e87:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
}
  802e93:	c9                   	leaveq 
  802e94:	c3                   	retq   

0000000000802e95 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e95:	55                   	push   %rbp
  802e96:	48 89 e5             	mov    %rsp,%rbp
  802e99:	48 83 ec 30          	sub    $0x30,%rsp
  802e9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ea5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ead:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb7:	00 00 00 
  802eba:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ebc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec3:	00 00 00 
  802ec6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eca:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802ece:	be 00 00 00 00       	mov    $0x0,%esi
  802ed3:	bf 03 00 00 00       	mov    $0x3,%edi
  802ed8:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  802edf:	00 00 00 
  802ee2:	ff d0                	callq  *%rax
  802ee4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eeb:	79 08                	jns    802ef5 <devfile_read+0x60>
		return r;
  802eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef0:	e9 a4 00 00 00       	jmpq   802f99 <devfile_read+0x104>
	assert(r <= n);
  802ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef8:	48 98                	cltq   
  802efa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802efe:	76 35                	jbe    802f35 <devfile_read+0xa0>
  802f00:	48 b9 b5 48 80 00 00 	movabs $0x8048b5,%rcx
  802f07:	00 00 00 
  802f0a:	48 ba bc 48 80 00 00 	movabs $0x8048bc,%rdx
  802f11:	00 00 00 
  802f14:	be 84 00 00 00       	mov    $0x84,%esi
  802f19:	48 bf d1 48 80 00 00 	movabs $0x8048d1,%rdi
  802f20:	00 00 00 
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
  802f28:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  802f2f:	00 00 00 
  802f32:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802f35:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802f3c:	7e 35                	jle    802f73 <devfile_read+0xde>
  802f3e:	48 b9 dc 48 80 00 00 	movabs $0x8048dc,%rcx
  802f45:	00 00 00 
  802f48:	48 ba bc 48 80 00 00 	movabs $0x8048bc,%rdx
  802f4f:	00 00 00 
  802f52:	be 85 00 00 00       	mov    $0x85,%esi
  802f57:	48 bf d1 48 80 00 00 	movabs $0x8048d1,%rdi
  802f5e:	00 00 00 
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
  802f66:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  802f6d:	00 00 00 
  802f70:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802f73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f76:	48 63 d0             	movslq %eax,%rdx
  802f79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f84:	00 00 00 
  802f87:	48 89 c7             	mov    %rax,%rdi
  802f8a:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
	return r;
  802f96:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802f99:	c9                   	leaveq 
  802f9a:	c3                   	retq   

0000000000802f9b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f9b:	55                   	push   %rbp
  802f9c:	48 89 e5             	mov    %rsp,%rbp
  802f9f:	48 83 ec 30          	sub    $0x30,%rsp
  802fa3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fa7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb3:	8b 50 0c             	mov    0xc(%rax),%edx
  802fb6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fbd:	00 00 00 
  802fc0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802fc2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc9:	00 00 00 
  802fcc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fd0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802fd4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802fdb:	00 
  802fdc:	76 35                	jbe    803013 <devfile_write+0x78>
  802fde:	48 b9 e8 48 80 00 00 	movabs $0x8048e8,%rcx
  802fe5:	00 00 00 
  802fe8:	48 ba bc 48 80 00 00 	movabs $0x8048bc,%rdx
  802fef:	00 00 00 
  802ff2:	be 9e 00 00 00       	mov    $0x9e,%esi
  802ff7:	48 bf d1 48 80 00 00 	movabs $0x8048d1,%rdi
  802ffe:	00 00 00 
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
  803006:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  80300d:	00 00 00 
  803010:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803013:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803017:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301b:	48 89 c6             	mov    %rax,%rsi
  80301e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803025:	00 00 00 
  803028:	48 b8 2b 16 80 00 00 	movabs $0x80162b,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803034:	be 00 00 00 00       	mov    $0x0,%esi
  803039:	bf 04 00 00 00       	mov    $0x4,%edi
  80303e:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
  80304a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803051:	79 05                	jns    803058 <devfile_write+0xbd>
		return r;
  803053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803056:	eb 43                	jmp    80309b <devfile_write+0x100>
	assert(r <= n);
  803058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305b:	48 98                	cltq   
  80305d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803061:	76 35                	jbe    803098 <devfile_write+0xfd>
  803063:	48 b9 b5 48 80 00 00 	movabs $0x8048b5,%rcx
  80306a:	00 00 00 
  80306d:	48 ba bc 48 80 00 00 	movabs $0x8048bc,%rdx
  803074:	00 00 00 
  803077:	be a2 00 00 00       	mov    $0xa2,%esi
  80307c:	48 bf d1 48 80 00 00 	movabs $0x8048d1,%rdi
  803083:	00 00 00 
  803086:	b8 00 00 00 00       	mov    $0x0,%eax
  80308b:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  803092:	00 00 00 
  803095:	41 ff d0             	callq  *%r8
	return r;
  803098:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80309b:	c9                   	leaveq 
  80309c:	c3                   	retq   

000000000080309d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80309d:	55                   	push   %rbp
  80309e:	48 89 e5             	mov    %rsp,%rbp
  8030a1:	48 83 ec 20          	sub    $0x20,%rsp
  8030a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bb:	00 00 00 
  8030be:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030c0:	be 00 00 00 00       	mov    $0x0,%esi
  8030c5:	bf 05 00 00 00       	mov    $0x5,%edi
  8030ca:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030dd:	79 05                	jns    8030e4 <devfile_stat+0x47>
		return r;
  8030df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e2:	eb 56                	jmp    80313a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030ef:	00 00 00 
  8030f2:	48 89 c7             	mov    %rax,%rdi
  8030f5:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  8030fc:	00 00 00 
  8030ff:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803101:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803108:	00 00 00 
  80310b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803111:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803115:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80311b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803122:	00 00 00 
  803125:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80312b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80312f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803135:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80313a:	c9                   	leaveq 
  80313b:	c3                   	retq   

000000000080313c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80313c:	55                   	push   %rbp
  80313d:	48 89 e5             	mov    %rsp,%rbp
  803140:	48 83 ec 10          	sub    $0x10,%rsp
  803144:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803148:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80314b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80314f:	8b 50 0c             	mov    0xc(%rax),%edx
  803152:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803159:	00 00 00 
  80315c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80315e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803165:	00 00 00 
  803168:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80316b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80316e:	be 00 00 00 00       	mov    $0x0,%esi
  803173:	bf 02 00 00 00       	mov    $0x2,%edi
  803178:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
}
  803184:	c9                   	leaveq 
  803185:	c3                   	retq   

0000000000803186 <remove>:

// Delete a file
int
remove(const char *path)
{
  803186:	55                   	push   %rbp
  803187:	48 89 e5             	mov    %rsp,%rbp
  80318a:	48 83 ec 10          	sub    $0x10,%rsp
  80318e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 84 11 80 00 00 	movabs $0x801184,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
  8031a5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031aa:	7e 07                	jle    8031b3 <remove+0x2d>
		return -E_BAD_PATH;
  8031ac:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031b1:	eb 33                	jmp    8031e6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b7:	48 89 c6             	mov    %rax,%rsi
  8031ba:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031c1:	00 00 00 
  8031c4:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031d0:	be 00 00 00 00       	mov    $0x0,%esi
  8031d5:	bf 07 00 00 00       	mov    $0x7,%edi
  8031da:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
}
  8031e6:	c9                   	leaveq 
  8031e7:	c3                   	retq   

00000000008031e8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031e8:	55                   	push   %rbp
  8031e9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031ec:	be 00 00 00 00       	mov    $0x0,%esi
  8031f1:	bf 08 00 00 00       	mov    $0x8,%edi
  8031f6:	48 b8 fd 2c 80 00 00 	movabs $0x802cfd,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
}
  803202:	5d                   	pop    %rbp
  803203:	c3                   	retq   

0000000000803204 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803204:	55                   	push   %rbp
  803205:	48 89 e5             	mov    %rsp,%rbp
  803208:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80320f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803216:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80321d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803224:	be 00 00 00 00       	mov    $0x0,%esi
  803229:	48 89 c7             	mov    %rax,%rdi
  80322c:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
  803238:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80323b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323f:	79 28                	jns    803269 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803244:	89 c6                	mov    %eax,%esi
  803246:	48 bf 15 49 80 00 00 	movabs $0x804915,%rdi
  80324d:	00 00 00 
  803250:	b8 00 00 00 00       	mov    $0x0,%eax
  803255:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  80325c:	00 00 00 
  80325f:	ff d2                	callq  *%rdx
		return fd_src;
  803261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803264:	e9 74 01 00 00       	jmpq   8033dd <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803269:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803270:	be 01 01 00 00       	mov    $0x101,%esi
  803275:	48 89 c7             	mov    %rax,%rdi
  803278:	48 b8 84 2d 80 00 00 	movabs $0x802d84,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
  803284:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803287:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80328b:	79 39                	jns    8032c6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80328d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803290:	89 c6                	mov    %eax,%esi
  803292:	48 bf 2b 49 80 00 00 	movabs $0x80492b,%rdi
  803299:	00 00 00 
  80329c:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a1:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  8032a8:	00 00 00 
  8032ab:	ff d2                	callq  *%rdx
		close(fd_src);
  8032ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b0:	89 c7                	mov    %eax,%edi
  8032b2:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
		return fd_dest;
  8032be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032c1:	e9 17 01 00 00       	jmpq   8033dd <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032c6:	eb 74                	jmp    80333c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8032c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032cb:	48 63 d0             	movslq %eax,%rdx
  8032ce:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032d8:	48 89 ce             	mov    %rcx,%rsi
  8032db:	89 c7                	mov    %eax,%edi
  8032dd:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8032ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8032f0:	79 4a                	jns    80333c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8032f2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032f5:	89 c6                	mov    %eax,%esi
  8032f7:	48 bf 45 49 80 00 00 	movabs $0x804945,%rdi
  8032fe:	00 00 00 
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
  803306:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  80330d:	00 00 00 
  803310:	ff d2                	callq  *%rdx
			close(fd_src);
  803312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803315:	89 c7                	mov    %eax,%edi
  803317:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
			close(fd_dest);
  803323:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803326:	89 c7                	mov    %eax,%edi
  803328:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
			return write_size;
  803334:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803337:	e9 a1 00 00 00       	jmpq   8033dd <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80333c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803343:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803346:	ba 00 02 00 00       	mov    $0x200,%edx
  80334b:	48 89 ce             	mov    %rcx,%rsi
  80334e:	89 c7                	mov    %eax,%edi
  803350:	48 b8 ae 28 80 00 00 	movabs $0x8028ae,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80335f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803363:	0f 8f 5f ff ff ff    	jg     8032c8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803369:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80336d:	79 47                	jns    8033b6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80336f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803372:	89 c6                	mov    %eax,%esi
  803374:	48 bf 58 49 80 00 00 	movabs $0x804958,%rdi
  80337b:	00 00 00 
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	48 ba 28 06 80 00 00 	movabs $0x800628,%rdx
  80338a:	00 00 00 
  80338d:	ff d2                	callq  *%rdx
		close(fd_src);
  80338f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803392:	89 c7                	mov    %eax,%edi
  803394:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
		close(fd_dest);
  8033a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033a3:	89 c7                	mov    %eax,%edi
  8033a5:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
		return read_size;
  8033b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033b4:	eb 27                	jmp    8033dd <copy+0x1d9>
	}
	close(fd_src);
  8033b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b9:	89 c7                	mov    %eax,%edi
  8033bb:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
	close(fd_dest);
  8033c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ca:	89 c7                	mov    %eax,%edi
  8033cc:	48 b8 8c 26 80 00 00 	movabs $0x80268c,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
	return 0;
  8033d8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8033dd:	c9                   	leaveq 
  8033de:	c3                   	retq   

00000000008033df <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033df:	55                   	push   %rbp
  8033e0:	48 89 e5             	mov    %rsp,%rbp
  8033e3:	53                   	push   %rbx
  8033e4:	48 83 ec 38          	sub    $0x38,%rsp
  8033e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033ec:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8033f0:	48 89 c7             	mov    %rax,%rdi
  8033f3:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
  8033ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803402:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803406:	0f 88 bf 01 00 00    	js     8035cb <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80340c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803410:	ba 07 04 00 00       	mov    $0x407,%edx
  803415:	48 89 c6             	mov    %rax,%rsi
  803418:	bf 00 00 00 00       	mov    $0x0,%edi
  80341d:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
  803429:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80342c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803430:	0f 88 95 01 00 00    	js     8035cb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803436:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80343a:	48 89 c7             	mov    %rax,%rdi
  80343d:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
  803449:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80344c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803450:	0f 88 5d 01 00 00    	js     8035b3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803456:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345a:	ba 07 04 00 00       	mov    $0x407,%edx
  80345f:	48 89 c6             	mov    %rax,%rsi
  803462:	bf 00 00 00 00       	mov    $0x0,%edi
  803467:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
  803473:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803476:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80347a:	0f 88 33 01 00 00    	js     8035b3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803484:	48 89 c7             	mov    %rax,%rdi
  803487:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
  803493:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803497:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80349b:	ba 07 04 00 00       	mov    $0x407,%edx
  8034a0:	48 89 c6             	mov    %rax,%rsi
  8034a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a8:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  8034af:	00 00 00 
  8034b2:	ff d0                	callq  *%rax
  8034b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034bb:	79 05                	jns    8034c2 <pipe+0xe3>
		goto err2;
  8034bd:	e9 d9 00 00 00       	jmpq   80359b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c6:	48 89 c7             	mov    %rax,%rdi
  8034c9:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
  8034d5:	48 89 c2             	mov    %rax,%rdx
  8034d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034dc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034e2:	48 89 d1             	mov    %rdx,%rcx
  8034e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034ea:	48 89 c6             	mov    %rax,%rsi
  8034ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f2:	48 b8 6f 1b 80 00 00 	movabs $0x801b6f,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
  8034fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803501:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803505:	79 1b                	jns    803522 <pipe+0x143>
		goto err3;
  803507:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803508:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80350c:	48 89 c6             	mov    %rax,%rsi
  80350f:	bf 00 00 00 00       	mov    $0x0,%edi
  803514:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
  803520:	eb 79                	jmp    80359b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803526:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80352d:	00 00 00 
  803530:	8b 12                	mov    (%rdx),%edx
  803532:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803538:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80353f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803543:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80354a:	00 00 00 
  80354d:	8b 12                	mov    (%rdx),%edx
  80354f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803551:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803555:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80355c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803560:	48 89 c7             	mov    %rax,%rdi
  803563:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
  80356f:	89 c2                	mov    %eax,%edx
  803571:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803575:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803577:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80357b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80357f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803583:	48 89 c7             	mov    %rax,%rdi
  803586:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	89 03                	mov    %eax,(%rbx)
	return 0;
  803594:	b8 00 00 00 00       	mov    $0x0,%eax
  803599:	eb 33                	jmp    8035ce <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80359b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359f:	48 89 c6             	mov    %rax,%rsi
  8035a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a7:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8035b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b7:	48 89 c6             	mov    %rax,%rsi
  8035ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8035bf:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
err:
	return r;
  8035cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035ce:	48 83 c4 38          	add    $0x38,%rsp
  8035d2:	5b                   	pop    %rbx
  8035d3:	5d                   	pop    %rbp
  8035d4:	c3                   	retq   

00000000008035d5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035d5:	55                   	push   %rbp
  8035d6:	48 89 e5             	mov    %rsp,%rbp
  8035d9:	53                   	push   %rbx
  8035da:	48 83 ec 28          	sub    $0x28,%rsp
  8035de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035e6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8035ed:	00 00 00 
  8035f0:	48 8b 00             	mov    (%rax),%rax
  8035f3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8035fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803600:	48 89 c7             	mov    %rax,%rdi
  803603:	48 b8 1d 40 80 00 00 	movabs $0x80401d,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
  80360f:	89 c3                	mov    %eax,%ebx
  803611:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803615:	48 89 c7             	mov    %rax,%rdi
  803618:	48 b8 1d 40 80 00 00 	movabs $0x80401d,%rax
  80361f:	00 00 00 
  803622:	ff d0                	callq  *%rax
  803624:	39 c3                	cmp    %eax,%ebx
  803626:	0f 94 c0             	sete   %al
  803629:	0f b6 c0             	movzbl %al,%eax
  80362c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80362f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803636:	00 00 00 
  803639:	48 8b 00             	mov    (%rax),%rax
  80363c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803642:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803648:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80364b:	75 05                	jne    803652 <_pipeisclosed+0x7d>
			return ret;
  80364d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803650:	eb 4f                	jmp    8036a1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803652:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803655:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803658:	74 42                	je     80369c <_pipeisclosed+0xc7>
  80365a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80365e:	75 3c                	jne    80369c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803660:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803667:	00 00 00 
  80366a:	48 8b 00             	mov    (%rax),%rax
  80366d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803673:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803676:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803679:	89 c6                	mov    %eax,%esi
  80367b:	48 bf 73 49 80 00 00 	movabs $0x804973,%rdi
  803682:	00 00 00 
  803685:	b8 00 00 00 00       	mov    $0x0,%eax
  80368a:	49 b8 28 06 80 00 00 	movabs $0x800628,%r8
  803691:	00 00 00 
  803694:	41 ff d0             	callq  *%r8
	}
  803697:	e9 4a ff ff ff       	jmpq   8035e6 <_pipeisclosed+0x11>
  80369c:	e9 45 ff ff ff       	jmpq   8035e6 <_pipeisclosed+0x11>
}
  8036a1:	48 83 c4 28          	add    $0x28,%rsp
  8036a5:	5b                   	pop    %rbx
  8036a6:	5d                   	pop    %rbp
  8036a7:	c3                   	retq   

00000000008036a8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 30          	sub    $0x30,%rsp
  8036b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036ba:	48 89 d6             	mov    %rdx,%rsi
  8036bd:	89 c7                	mov    %eax,%edi
  8036bf:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
  8036cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d2:	79 05                	jns    8036d9 <pipeisclosed+0x31>
		return r;
  8036d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d7:	eb 31                	jmp    80370a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036dd:	48 89 c7             	mov    %rax,%rdi
  8036e0:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
  8036ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8036f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036f8:	48 89 d6             	mov    %rdx,%rsi
  8036fb:	48 89 c7             	mov    %rax,%rdi
  8036fe:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
}
  80370a:	c9                   	leaveq 
  80370b:	c3                   	retq   

000000000080370c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80370c:	55                   	push   %rbp
  80370d:	48 89 e5             	mov    %rsp,%rbp
  803710:	48 83 ec 40          	sub    $0x40,%rsp
  803714:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803718:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80371c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803724:	48 89 c7             	mov    %rax,%rdi
  803727:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
  803733:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80373b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80373f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803746:	00 
  803747:	e9 92 00 00 00       	jmpq   8037de <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80374c:	eb 41                	jmp    80378f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80374e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803753:	74 09                	je     80375e <devpipe_read+0x52>
				return i;
  803755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803759:	e9 92 00 00 00       	jmpq   8037f0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80375e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803766:	48 89 d6             	mov    %rdx,%rsi
  803769:	48 89 c7             	mov    %rax,%rdi
  80376c:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  803773:	00 00 00 
  803776:	ff d0                	callq  *%rax
  803778:	85 c0                	test   %eax,%eax
  80377a:	74 07                	je     803783 <devpipe_read+0x77>
				return 0;
  80377c:	b8 00 00 00 00       	mov    $0x0,%eax
  803781:	eb 6d                	jmp    8037f0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803783:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80378f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803793:	8b 10                	mov    (%rax),%edx
  803795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803799:	8b 40 04             	mov    0x4(%rax),%eax
  80379c:	39 c2                	cmp    %eax,%edx
  80379e:	74 ae                	je     80374e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037a8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8037ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b0:	8b 00                	mov    (%rax),%eax
  8037b2:	99                   	cltd   
  8037b3:	c1 ea 1b             	shr    $0x1b,%edx
  8037b6:	01 d0                	add    %edx,%eax
  8037b8:	83 e0 1f             	and    $0x1f,%eax
  8037bb:	29 d0                	sub    %edx,%eax
  8037bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037c1:	48 98                	cltq   
  8037c3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037c8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ce:	8b 00                	mov    (%rax),%eax
  8037d0:	8d 50 01             	lea    0x1(%rax),%edx
  8037d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037e6:	0f 82 60 ff ff ff    	jb     80374c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037f0:	c9                   	leaveq 
  8037f1:	c3                   	retq   

00000000008037f2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037f2:	55                   	push   %rbp
  8037f3:	48 89 e5             	mov    %rsp,%rbp
  8037f6:	48 83 ec 40          	sub    $0x40,%rsp
  8037fa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803802:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380a:	48 89 c7             	mov    %rax,%rdi
  80380d:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
  803819:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80381d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803821:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803825:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80382c:	00 
  80382d:	e9 8e 00 00 00       	jmpq   8038c0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803832:	eb 31                	jmp    803865 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803834:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383c:	48 89 d6             	mov    %rdx,%rsi
  80383f:	48 89 c7             	mov    %rax,%rdi
  803842:	48 b8 d5 35 80 00 00 	movabs $0x8035d5,%rax
  803849:	00 00 00 
  80384c:	ff d0                	callq  *%rax
  80384e:	85 c0                	test   %eax,%eax
  803850:	74 07                	je     803859 <devpipe_write+0x67>
				return 0;
  803852:	b8 00 00 00 00       	mov    $0x0,%eax
  803857:	eb 79                	jmp    8038d2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803859:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  803860:	00 00 00 
  803863:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803865:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803869:	8b 40 04             	mov    0x4(%rax),%eax
  80386c:	48 63 d0             	movslq %eax,%rdx
  80386f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803873:	8b 00                	mov    (%rax),%eax
  803875:	48 98                	cltq   
  803877:	48 83 c0 20          	add    $0x20,%rax
  80387b:	48 39 c2             	cmp    %rax,%rdx
  80387e:	73 b4                	jae    803834 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803880:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803884:	8b 40 04             	mov    0x4(%rax),%eax
  803887:	99                   	cltd   
  803888:	c1 ea 1b             	shr    $0x1b,%edx
  80388b:	01 d0                	add    %edx,%eax
  80388d:	83 e0 1f             	and    $0x1f,%eax
  803890:	29 d0                	sub    %edx,%eax
  803892:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803896:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80389a:	48 01 ca             	add    %rcx,%rdx
  80389d:	0f b6 0a             	movzbl (%rdx),%ecx
  8038a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a4:	48 98                	cltq   
  8038a6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8038aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ae:	8b 40 04             	mov    0x4(%rax),%eax
  8038b1:	8d 50 01             	lea    0x1(%rax),%edx
  8038b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038c8:	0f 82 64 ff ff ff    	jb     803832 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8038ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038d2:	c9                   	leaveq 
  8038d3:	c3                   	retq   

00000000008038d4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038d4:	55                   	push   %rbp
  8038d5:	48 89 e5             	mov    %rsp,%rbp
  8038d8:	48 83 ec 20          	sub    $0x20,%rsp
  8038dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e8:	48 89 c7             	mov    %rax,%rdi
  8038eb:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  8038f2:	00 00 00 
  8038f5:	ff d0                	callq  *%rax
  8038f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8038fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ff:	48 be 86 49 80 00 00 	movabs $0x804986,%rsi
  803906:	00 00 00 
  803909:	48 89 c7             	mov    %rax,%rdi
  80390c:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803918:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391c:	8b 50 04             	mov    0x4(%rax),%edx
  80391f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803923:	8b 00                	mov    (%rax),%eax
  803925:	29 c2                	sub    %eax,%edx
  803927:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80392b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803935:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80393c:	00 00 00 
	stat->st_dev = &devpipe;
  80393f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803943:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80394a:	00 00 00 
  80394d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803959:	c9                   	leaveq 
  80395a:	c3                   	retq   

000000000080395b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80395b:	55                   	push   %rbp
  80395c:	48 89 e5             	mov    %rsp,%rbp
  80395f:	48 83 ec 10          	sub    $0x10,%rsp
  803963:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803967:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80396b:	48 89 c6             	mov    %rax,%rsi
  80396e:	bf 00 00 00 00       	mov    $0x0,%edi
  803973:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  80397a:	00 00 00 
  80397d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80397f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803983:	48 89 c7             	mov    %rax,%rdi
  803986:	48 b8 b9 23 80 00 00 	movabs $0x8023b9,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
  803992:	48 89 c6             	mov    %rax,%rsi
  803995:	bf 00 00 00 00       	mov    $0x0,%edi
  80399a:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  8039a1:	00 00 00 
  8039a4:	ff d0                	callq  *%rax
}
  8039a6:	c9                   	leaveq 
  8039a7:	c3                   	retq   

00000000008039a8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8039a8:	55                   	push   %rbp
  8039a9:	48 89 e5             	mov    %rsp,%rbp
  8039ac:	48 83 ec 20          	sub    $0x20,%rsp
  8039b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8039b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039b7:	75 35                	jne    8039ee <wait+0x46>
  8039b9:	48 b9 8d 49 80 00 00 	movabs $0x80498d,%rcx
  8039c0:	00 00 00 
  8039c3:	48 ba 98 49 80 00 00 	movabs $0x804998,%rdx
  8039ca:	00 00 00 
  8039cd:	be 09 00 00 00       	mov    $0x9,%esi
  8039d2:	48 bf ad 49 80 00 00 	movabs $0x8049ad,%rdi
  8039d9:	00 00 00 
  8039dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e1:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  8039e8:	00 00 00 
  8039eb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8039ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8039f6:	48 63 d0             	movslq %eax,%rdx
  8039f9:	48 89 d0             	mov    %rdx,%rax
  8039fc:	48 c1 e0 03          	shl    $0x3,%rax
  803a00:	48 01 d0             	add    %rdx,%rax
  803a03:	48 c1 e0 05          	shl    $0x5,%rax
  803a07:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a0e:	00 00 00 
  803a11:	48 01 d0             	add    %rdx,%rax
  803a14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a18:	eb 0c                	jmp    803a26 <wait+0x7e>
		sys_yield();
  803a1a:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  803a21:	00 00 00 
  803a24:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a30:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a33:	75 0e                	jne    803a43 <wait+0x9b>
  803a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a39:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	75 d7                	jne    803a1a <wait+0x72>
		sys_yield();
}
  803a43:	c9                   	leaveq 
  803a44:	c3                   	retq   

0000000000803a45 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a45:	55                   	push   %rbp
  803a46:	48 89 e5             	mov    %rsp,%rbp
  803a49:	48 83 ec 20          	sub    $0x20,%rsp
  803a4d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a53:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a56:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a5a:	be 01 00 00 00       	mov    $0x1,%esi
  803a5f:	48 89 c7             	mov    %rax,%rdi
  803a62:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  803a69:	00 00 00 
  803a6c:	ff d0                	callq  *%rax
}
  803a6e:	c9                   	leaveq 
  803a6f:	c3                   	retq   

0000000000803a70 <getchar>:

int
getchar(void)
{
  803a70:	55                   	push   %rbp
  803a71:	48 89 e5             	mov    %rsp,%rbp
  803a74:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a78:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a7c:	ba 01 00 00 00       	mov    $0x1,%edx
  803a81:	48 89 c6             	mov    %rax,%rsi
  803a84:	bf 00 00 00 00       	mov    $0x0,%edi
  803a89:	48 b8 ae 28 80 00 00 	movabs $0x8028ae,%rax
  803a90:	00 00 00 
  803a93:	ff d0                	callq  *%rax
  803a95:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803a98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a9c:	79 05                	jns    803aa3 <getchar+0x33>
		return r;
  803a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa1:	eb 14                	jmp    803ab7 <getchar+0x47>
	if (r < 1)
  803aa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa7:	7f 07                	jg     803ab0 <getchar+0x40>
		return -E_EOF;
  803aa9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803aae:	eb 07                	jmp    803ab7 <getchar+0x47>
	return c;
  803ab0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ab4:	0f b6 c0             	movzbl %al,%eax
}
  803ab7:	c9                   	leaveq 
  803ab8:	c3                   	retq   

0000000000803ab9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ab9:	55                   	push   %rbp
  803aba:	48 89 e5             	mov    %rsp,%rbp
  803abd:	48 83 ec 20          	sub    $0x20,%rsp
  803ac1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ac4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ac8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803acb:	48 89 d6             	mov    %rdx,%rsi
  803ace:	89 c7                	mov    %eax,%edi
  803ad0:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  803ad7:	00 00 00 
  803ada:	ff d0                	callq  *%rax
  803adc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae3:	79 05                	jns    803aea <iscons+0x31>
		return r;
  803ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae8:	eb 1a                	jmp    803b04 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803aea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aee:	8b 10                	mov    (%rax),%edx
  803af0:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803af7:	00 00 00 
  803afa:	8b 00                	mov    (%rax),%eax
  803afc:	39 c2                	cmp    %eax,%edx
  803afe:	0f 94 c0             	sete   %al
  803b01:	0f b6 c0             	movzbl %al,%eax
}
  803b04:	c9                   	leaveq 
  803b05:	c3                   	retq   

0000000000803b06 <opencons>:

int
opencons(void)
{
  803b06:	55                   	push   %rbp
  803b07:	48 89 e5             	mov    %rsp,%rbp
  803b0a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b0e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b12:	48 89 c7             	mov    %rax,%rdi
  803b15:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b28:	79 05                	jns    803b2f <opencons+0x29>
		return r;
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	eb 5b                	jmp    803b8a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b33:	ba 07 04 00 00       	mov    $0x407,%edx
  803b38:	48 89 c6             	mov    %rax,%rsi
  803b3b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b40:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803b47:	00 00 00 
  803b4a:	ff d0                	callq  *%rax
  803b4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b53:	79 05                	jns    803b5a <opencons+0x54>
		return r;
  803b55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b58:	eb 30                	jmp    803b8a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b65:	00 00 00 
  803b68:	8b 12                	mov    (%rdx),%edx
  803b6a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b70:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7b:	48 89 c7             	mov    %rax,%rdi
  803b7e:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  803b85:	00 00 00 
  803b88:	ff d0                	callq  *%rax
}
  803b8a:	c9                   	leaveq 
  803b8b:	c3                   	retq   

0000000000803b8c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b8c:	55                   	push   %rbp
  803b8d:	48 89 e5             	mov    %rsp,%rbp
  803b90:	48 83 ec 30          	sub    $0x30,%rsp
  803b94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ba0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ba5:	75 07                	jne    803bae <devcons_read+0x22>
		return 0;
  803ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bac:	eb 4b                	jmp    803bf9 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bae:	eb 0c                	jmp    803bbc <devcons_read+0x30>
		sys_yield();
  803bb0:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  803bb7:	00 00 00 
  803bba:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bbc:	48 b8 21 1a 80 00 00 	movabs $0x801a21,%rax
  803bc3:	00 00 00 
  803bc6:	ff d0                	callq  *%rax
  803bc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bcf:	74 df                	je     803bb0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803bd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd5:	79 05                	jns    803bdc <devcons_read+0x50>
		return c;
  803bd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bda:	eb 1d                	jmp    803bf9 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bdc:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803be0:	75 07                	jne    803be9 <devcons_read+0x5d>
		return 0;
  803be2:	b8 00 00 00 00       	mov    $0x0,%eax
  803be7:	eb 10                	jmp    803bf9 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bec:	89 c2                	mov    %eax,%edx
  803bee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf2:	88 10                	mov    %dl,(%rax)
	return 1;
  803bf4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803bf9:	c9                   	leaveq 
  803bfa:	c3                   	retq   

0000000000803bfb <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bfb:	55                   	push   %rbp
  803bfc:	48 89 e5             	mov    %rsp,%rbp
  803bff:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c06:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c0d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c14:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c22:	eb 76                	jmp    803c9a <devcons_write+0x9f>
		m = n - tot;
  803c24:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c2b:	89 c2                	mov    %eax,%edx
  803c2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c30:	29 c2                	sub    %eax,%edx
  803c32:	89 d0                	mov    %edx,%eax
  803c34:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c3a:	83 f8 7f             	cmp    $0x7f,%eax
  803c3d:	76 07                	jbe    803c46 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c3f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c49:	48 63 d0             	movslq %eax,%rdx
  803c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4f:	48 63 c8             	movslq %eax,%rcx
  803c52:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c59:	48 01 c1             	add    %rax,%rcx
  803c5c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c63:	48 89 ce             	mov    %rcx,%rsi
  803c66:	48 89 c7             	mov    %rax,%rdi
  803c69:	48 b8 14 15 80 00 00 	movabs $0x801514,%rax
  803c70:	00 00 00 
  803c73:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c75:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c78:	48 63 d0             	movslq %eax,%rdx
  803c7b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c82:	48 89 d6             	mov    %rdx,%rsi
  803c85:	48 89 c7             	mov    %rax,%rdi
  803c88:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c97:	01 45 fc             	add    %eax,-0x4(%rbp)
  803c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9d:	48 98                	cltq   
  803c9f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ca6:	0f 82 78 ff ff ff    	jb     803c24 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803caf:	c9                   	leaveq 
  803cb0:	c3                   	retq   

0000000000803cb1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cb1:	55                   	push   %rbp
  803cb2:	48 89 e5             	mov    %rsp,%rbp
  803cb5:	48 83 ec 08          	sub    $0x8,%rsp
  803cb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cc2:	c9                   	leaveq 
  803cc3:	c3                   	retq   

0000000000803cc4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cc4:	55                   	push   %rbp
  803cc5:	48 89 e5             	mov    %rsp,%rbp
  803cc8:	48 83 ec 10          	sub    $0x10,%rsp
  803ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd8:	48 be bd 49 80 00 00 	movabs $0x8049bd,%rsi
  803cdf:	00 00 00 
  803ce2:	48 89 c7             	mov    %rax,%rdi
  803ce5:	48 b8 f0 11 80 00 00 	movabs $0x8011f0,%rax
  803cec:	00 00 00 
  803cef:	ff d0                	callq  *%rax
	return 0;
  803cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cf6:	c9                   	leaveq 
  803cf7:	c3                   	retq   

0000000000803cf8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803cf8:	55                   	push   %rbp
  803cf9:	48 89 e5             	mov    %rsp,%rbp
  803cfc:	48 83 ec 10          	sub    $0x10,%rsp
  803d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803d04:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d0b:	00 00 00 
  803d0e:	48 8b 00             	mov    (%rax),%rax
  803d11:	48 85 c0             	test   %rax,%rax
  803d14:	75 49                	jne    803d5f <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803d16:	ba 07 00 00 00       	mov    $0x7,%edx
  803d1b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d20:	bf 00 00 00 00       	mov    $0x0,%edi
  803d25:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803d2c:	00 00 00 
  803d2f:	ff d0                	callq  *%rax
  803d31:	85 c0                	test   %eax,%eax
  803d33:	79 2a                	jns    803d5f <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803d35:	48 ba c8 49 80 00 00 	movabs $0x8049c8,%rdx
  803d3c:	00 00 00 
  803d3f:	be 21 00 00 00       	mov    $0x21,%esi
  803d44:	48 bf f3 49 80 00 00 	movabs $0x8049f3,%rdi
  803d4b:	00 00 00 
  803d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d53:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  803d5a:	00 00 00 
  803d5d:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803d5f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d66:	00 00 00 
  803d69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d6d:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803d70:	48 be bb 3d 80 00 00 	movabs $0x803dbb,%rsi
  803d77:	00 00 00 
  803d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7f:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	85 c0                	test   %eax,%eax
  803d8d:	79 2a                	jns    803db9 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803d8f:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  803d96:	00 00 00 
  803d99:	be 27 00 00 00       	mov    $0x27,%esi
  803d9e:	48 bf f3 49 80 00 00 	movabs $0x8049f3,%rdi
  803da5:	00 00 00 
  803da8:	b8 00 00 00 00       	mov    $0x0,%eax
  803dad:	48 b9 ef 03 80 00 00 	movabs $0x8003ef,%rcx
  803db4:	00 00 00 
  803db7:	ff d1                	callq  *%rcx
}
  803db9:	c9                   	leaveq 
  803dba:	c3                   	retq   

0000000000803dbb <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803dbb:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803dbe:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803dc5:	00 00 00 
call *%rax
  803dc8:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803dca:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803dd1:	00 
    movq 152(%rsp), %rcx
  803dd2:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803dd9:	00 
    subq $8, %rcx
  803dda:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803dde:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803de1:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803de8:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803de9:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803ded:	4c 8b 3c 24          	mov    (%rsp),%r15
  803df1:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803df6:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803dfb:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e00:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e05:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e0a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e0f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e14:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e19:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e1e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e23:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e28:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e2d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e32:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e37:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803e3b:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803e3f:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803e40:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803e41:	c3                   	retq   

0000000000803e42 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e42:	55                   	push   %rbp
  803e43:	48 89 e5             	mov    %rsp,%rbp
  803e46:	48 83 ec 30          	sub    $0x30,%rsp
  803e4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e52:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803e56:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e5b:	75 0e                	jne    803e6b <ipc_recv+0x29>
        pg = (void *)UTOP;
  803e5d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e64:	00 00 00 
  803e67:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803e6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6f:	48 89 c7             	mov    %rax,%rdi
  803e72:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  803e79:	00 00 00 
  803e7c:	ff d0                	callq  *%rax
  803e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e85:	79 27                	jns    803eae <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803e87:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e8c:	74 0a                	je     803e98 <ipc_recv+0x56>
            *from_env_store = 0;
  803e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e92:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803e98:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e9d:	74 0a                	je     803ea9 <ipc_recv+0x67>
            *perm_store = 0;
  803e9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eac:	eb 53                	jmp    803f01 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803eae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803eb3:	74 19                	je     803ece <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803eb5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ebc:	00 00 00 
  803ebf:	48 8b 00             	mov    (%rax),%rax
  803ec2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ec8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ecc:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803ece:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ed3:	74 19                	je     803eee <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803ed5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803edc:	00 00 00 
  803edf:	48 8b 00             	mov    (%rax),%rax
  803ee2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eec:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803eee:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ef5:	00 00 00 
  803ef8:	48 8b 00             	mov    (%rax),%rax
  803efb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803f01:	c9                   	leaveq 
  803f02:	c3                   	retq   

0000000000803f03 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f03:	55                   	push   %rbp
  803f04:	48 89 e5             	mov    %rsp,%rbp
  803f07:	48 83 ec 30          	sub    $0x30,%rsp
  803f0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f0e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f11:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f15:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803f18:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f1d:	75 0e                	jne    803f2d <ipc_send+0x2a>
        pg = (void *)UTOP;
  803f1f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f26:	00 00 00 
  803f29:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803f2d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f30:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f3a:	89 c7                	mov    %eax,%edi
  803f3c:	48 b8 f3 1c 80 00 00 	movabs $0x801cf3,%rax
  803f43:	00 00 00 
  803f46:	ff d0                	callq  *%rax
  803f48:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f4f:	79 36                	jns    803f87 <ipc_send+0x84>
  803f51:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f55:	74 30                	je     803f87 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5a:	89 c1                	mov    %eax,%ecx
  803f5c:	48 ba 3f 4a 80 00 00 	movabs $0x804a3f,%rdx
  803f63:	00 00 00 
  803f66:	be 49 00 00 00       	mov    $0x49,%esi
  803f6b:	48 bf 4c 4a 80 00 00 	movabs $0x804a4c,%rdi
  803f72:	00 00 00 
  803f75:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7a:	49 b8 ef 03 80 00 00 	movabs $0x8003ef,%r8
  803f81:	00 00 00 
  803f84:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803f87:	48 b8 e1 1a 80 00 00 	movabs $0x801ae1,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
    } while(r != 0);
  803f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f97:	75 94                	jne    803f2d <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803f99:	c9                   	leaveq 
  803f9a:	c3                   	retq   

0000000000803f9b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f9b:	55                   	push   %rbp
  803f9c:	48 89 e5             	mov    %rsp,%rbp
  803f9f:	48 83 ec 14          	sub    $0x14,%rsp
  803fa3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fad:	eb 5e                	jmp    80400d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803faf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fb6:	00 00 00 
  803fb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fbc:	48 63 d0             	movslq %eax,%rdx
  803fbf:	48 89 d0             	mov    %rdx,%rax
  803fc2:	48 c1 e0 03          	shl    $0x3,%rax
  803fc6:	48 01 d0             	add    %rdx,%rax
  803fc9:	48 c1 e0 05          	shl    $0x5,%rax
  803fcd:	48 01 c8             	add    %rcx,%rax
  803fd0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803fd6:	8b 00                	mov    (%rax),%eax
  803fd8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fdb:	75 2c                	jne    804009 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803fdd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fe4:	00 00 00 
  803fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fea:	48 63 d0             	movslq %eax,%rdx
  803fed:	48 89 d0             	mov    %rdx,%rax
  803ff0:	48 c1 e0 03          	shl    $0x3,%rax
  803ff4:	48 01 d0             	add    %rdx,%rax
  803ff7:	48 c1 e0 05          	shl    $0x5,%rax
  803ffb:	48 01 c8             	add    %rcx,%rax
  803ffe:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804004:	8b 40 08             	mov    0x8(%rax),%eax
  804007:	eb 12                	jmp    80401b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804009:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80400d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804014:	7e 99                	jle    803faf <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804016:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80401b:	c9                   	leaveq 
  80401c:	c3                   	retq   

000000000080401d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80401d:	55                   	push   %rbp
  80401e:	48 89 e5             	mov    %rsp,%rbp
  804021:	48 83 ec 18          	sub    $0x18,%rsp
  804025:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80402d:	48 c1 e8 15          	shr    $0x15,%rax
  804031:	48 89 c2             	mov    %rax,%rdx
  804034:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80403b:	01 00 00 
  80403e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804042:	83 e0 01             	and    $0x1,%eax
  804045:	48 85 c0             	test   %rax,%rax
  804048:	75 07                	jne    804051 <pageref+0x34>
		return 0;
  80404a:	b8 00 00 00 00       	mov    $0x0,%eax
  80404f:	eb 53                	jmp    8040a4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804055:	48 c1 e8 0c          	shr    $0xc,%rax
  804059:	48 89 c2             	mov    %rax,%rdx
  80405c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804063:	01 00 00 
  804066:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80406a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80406e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804072:	83 e0 01             	and    $0x1,%eax
  804075:	48 85 c0             	test   %rax,%rax
  804078:	75 07                	jne    804081 <pageref+0x64>
		return 0;
  80407a:	b8 00 00 00 00       	mov    $0x0,%eax
  80407f:	eb 23                	jmp    8040a4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804085:	48 c1 e8 0c          	shr    $0xc,%rax
  804089:	48 89 c2             	mov    %rax,%rdx
  80408c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804093:	00 00 00 
  804096:	48 c1 e2 04          	shl    $0x4,%rdx
  80409a:	48 01 d0             	add    %rdx,%rax
  80409d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040a1:	0f b7 c0             	movzwl %ax,%eax
}
  8040a4:	c9                   	leaveq 
  8040a5:	c3                   	retq   
