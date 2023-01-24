
obj/user/primes:     file format elf64-x86-64


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
  80003c:	e8 8d 01 00 00       	callq  8001ce <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 d3 21 80 00 00 	movabs $0x8021d3,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 00 25 80 00 00 	movabs $0x802500,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 af 04 80 00 00 	movabs $0x8004af,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 0c 25 80 00 00 	movabs $0x80250c,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf 15 25 80 00 00 	movabs $0x802515,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 76 02 80 00 00 	movabs $0x800276,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 d3 21 80 00 00 	movabs $0x8021d3,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 20                	je     80013b <primeproc+0xf8>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>
  80013b:	eb b1                	jmp    8000ee <primeproc+0xab>

000000000080013d <umain>:
}

void
umain(int argc, char **argv)
{
  80013d:	55                   	push   %rbp
  80013e:	48 89 e5             	mov    %rsp,%rbp
  800141:	48 83 ec 20          	sub    $0x20,%rsp
  800145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014c:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba 0c 25 80 00 00 	movabs $0x80250c,%rdx
  80016d:	00 00 00 
  800170:	be 2d 00 00 00       	mov    $0x2d,%esi
  800175:	48 bf 15 25 80 00 00 	movabs $0x802515,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 76 02 80 00 00 	movabs $0x800276,%r8
  80018b:	00 00 00 
  80018e:	41 ff d0             	callq  *%r8
	if (id == 0)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	75 0c                	jne    8001a3 <umain+0x66>
		primeproc();
  800197:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001aa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 94 22 80 00 00 	movabs $0x802294,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001cc:	eb dc                	jmp    8001aa <umain+0x6d>

00000000008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 20          	sub    $0x20,%rsp
  8001d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8001dd:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8001ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f4:	48 63 d0             	movslq %eax,%rdx
  8001f7:	48 89 d0             	mov    %rdx,%rax
  8001fa:	48 c1 e0 03          	shl    $0x3,%rax
  8001fe:	48 01 d0             	add    %rdx,%rax
  800201:	48 c1 e0 05          	shl    $0x5,%rax
  800205:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80020c:	00 00 00 
  80020f:	48 01 c2             	add    %rax,%rdx
  800212:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800219:	00 00 00 
  80021c:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800223:	7e 14                	jle    800239 <libmain+0x6b>
		binaryname = argv[0];
  800225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800229:	48 8b 10             	mov    (%rax),%rdx
  80022c:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800233:	00 00 00 
  800236:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800239:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80023d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800240:	48 89 d6             	mov    %rdx,%rsi
  800243:	89 c7                	mov    %eax,%edi
  800245:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  80024c:	00 00 00 
  80024f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800251:	48 b8 5f 02 80 00 00 	movabs $0x80025f,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
}
  80025d:	c9                   	leaveq 
  80025e:	c3                   	retq   

000000000080025f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025f:	55                   	push   %rbp
  800260:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800263:	bf 00 00 00 00       	mov    $0x0,%edi
  800268:	48 b8 e6 18 80 00 00 	movabs $0x8018e6,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
}
  800274:	5d                   	pop    %rbp
  800275:	c3                   	retq   

0000000000800276 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800276:	55                   	push   %rbp
  800277:	48 89 e5             	mov    %rsp,%rbp
  80027a:	53                   	push   %rbx
  80027b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800282:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800289:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80028f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800296:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a4:	84 c0                	test   %al,%al
  8002a6:	74 23                	je     8002cb <_panic+0x55>
  8002a8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002af:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002bb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002bf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002cb:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d9:	00 00 00 
  8002dc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e3:	00 00 00 
  8002e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002ea:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002f1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ff:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800306:	00 00 00 
  800309:	48 8b 18             	mov    (%rax),%rbx
  80030c:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
  800318:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80031e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800325:	41 89 c8             	mov    %ecx,%r8d
  800328:	48 89 d1             	mov    %rdx,%rcx
  80032b:	48 89 da             	mov    %rbx,%rdx
  80032e:	89 c6                	mov    %eax,%esi
  800330:	48 bf 30 25 80 00 00 	movabs $0x802530,%rdi
  800337:	00 00 00 
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	49 b9 af 04 80 00 00 	movabs $0x8004af,%r9
  800346:	00 00 00 
  800349:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800353:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80035a:	48 89 d6             	mov    %rdx,%rsi
  80035d:	48 89 c7             	mov    %rax,%rdi
  800360:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  800367:	00 00 00 
  80036a:	ff d0                	callq  *%rax
	cprintf("\n");
  80036c:	48 bf 53 25 80 00 00 	movabs $0x802553,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba af 04 80 00 00 	movabs $0x8004af,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800387:	cc                   	int3   
  800388:	eb fd                	jmp    800387 <_panic+0x111>

000000000080038a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80038a:	55                   	push   %rbp
  80038b:	48 89 e5             	mov    %rsp,%rbp
  80038e:	48 83 ec 10          	sub    $0x10,%rsp
  800392:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039d:	8b 00                	mov    (%rax),%eax
  80039f:	8d 48 01             	lea    0x1(%rax),%ecx
  8003a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a6:	89 0a                	mov    %ecx,(%rdx)
  8003a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	48 98                	cltq   
  8003b3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bb:	8b 00                	mov    (%rax),%eax
  8003bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c2:	75 2c                	jne    8003f0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c8:	8b 00                	mov    (%rax),%eax
  8003ca:	48 98                	cltq   
  8003cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d0:	48 83 c2 08          	add    $0x8,%rdx
  8003d4:	48 89 c6             	mov    %rax,%rsi
  8003d7:	48 89 d7             	mov    %rdx,%rdi
  8003da:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  8003e1:	00 00 00 
  8003e4:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f4:	8b 40 04             	mov    0x4(%rax),%eax
  8003f7:	8d 50 01             	lea    0x1(%rax),%edx
  8003fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fe:	89 50 04             	mov    %edx,0x4(%rax)
}
  800401:	c9                   	leaveq 
  800402:	c3                   	retq   

0000000000800403 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80040e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800415:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80041c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800423:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80042a:	48 8b 0a             	mov    (%rdx),%rcx
  80042d:	48 89 08             	mov    %rcx,(%rax)
  800430:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800434:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800438:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800440:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800447:	00 00 00 
    b.cnt = 0;
  80044a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800451:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800454:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80045b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800462:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800469:	48 89 c6             	mov    %rax,%rsi
  80046c:	48 bf 8a 03 80 00 00 	movabs $0x80038a,%rdi
  800473:	00 00 00 
  800476:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  80047d:	00 00 00 
  800480:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800482:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800488:	48 98                	cltq   
  80048a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800491:	48 83 c2 08          	add    $0x8,%rdx
  800495:	48 89 c6             	mov    %rax,%rsi
  800498:	48 89 d7             	mov    %rdx,%rdi
  80049b:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004ad:	c9                   	leaveq 
  8004ae:	c3                   	retq   

00000000008004af <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004af:	55                   	push   %rbp
  8004b0:	48 89 e5             	mov    %rsp,%rbp
  8004b3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ba:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004c8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004cf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004dd:	84 c0                	test   %al,%al
  8004df:	74 20                	je     800501 <cprintf+0x52>
  8004e1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004e9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004f9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004fd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800501:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800508:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050f:	00 00 00 
  800512:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800519:	00 00 00 
  80051c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800520:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800527:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80052e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800535:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80053c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800543:	48 8b 0a             	mov    (%rdx),%rcx
  800546:	48 89 08             	mov    %rcx,(%rax)
  800549:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800551:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800555:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800559:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800560:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800567:	48 89 d6             	mov    %rdx,%rsi
  80056a:	48 89 c7             	mov    %rax,%rdi
  80056d:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  800574:	00 00 00 
  800577:	ff d0                	callq  *%rax
  800579:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80057f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   

0000000000800587 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800587:	55                   	push   %rbp
  800588:	48 89 e5             	mov    %rsp,%rbp
  80058b:	53                   	push   %rbx
  80058c:	48 83 ec 38          	sub    $0x38,%rsp
  800590:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800594:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800598:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80059c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80059f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005a3:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005aa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ae:	77 3b                	ja     8005eb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005b3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005b7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005be:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c3:	48 f7 f3             	div    %rbx
  8005c6:	48 89 c2             	mov    %rax,%rdx
  8005c9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005cc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005cf:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	41 89 f9             	mov    %edi,%r9d
  8005da:	48 89 c7             	mov    %rax,%rdi
  8005dd:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  8005e4:	00 00 00 
  8005e7:	ff d0                	callq  *%rax
  8005e9:	eb 1e                	jmp    800609 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005eb:	eb 12                	jmp    8005ff <printnum+0x78>
			putch(padc, putdat);
  8005ed:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005f1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 89 ce             	mov    %rcx,%rsi
  8005fb:	89 d7                	mov    %edx,%edi
  8005fd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ff:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800603:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800607:	7f e4                	jg     8005ed <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800609:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80060c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	48 f7 f1             	div    %rcx
  800618:	48 89 d0             	mov    %rdx,%rax
  80061b:	48 ba b0 26 80 00 00 	movabs $0x8026b0,%rdx
  800622:	00 00 00 
  800625:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800629:	0f be d0             	movsbl %al,%edx
  80062c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	48 89 ce             	mov    %rcx,%rsi
  800637:	89 d7                	mov    %edx,%edi
  800639:	ff d0                	callq  *%rax
}
  80063b:	48 83 c4 38          	add    $0x38,%rsp
  80063f:	5b                   	pop    %rbx
  800640:	5d                   	pop    %rbp
  800641:	c3                   	retq   

0000000000800642 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800642:	55                   	push   %rbp
  800643:	48 89 e5             	mov    %rsp,%rbp
  800646:	48 83 ec 1c          	sub    $0x1c,%rsp
  80064a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80064e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800651:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800655:	7e 52                	jle    8006a9 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	8b 00                	mov    (%rax),%eax
  80065d:	83 f8 30             	cmp    $0x30,%eax
  800660:	73 24                	jae    800686 <getuint+0x44>
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80066a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066e:	8b 00                	mov    (%rax),%eax
  800670:	89 c0                	mov    %eax,%eax
  800672:	48 01 d0             	add    %rdx,%rax
  800675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800679:	8b 12                	mov    (%rdx),%edx
  80067b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	89 0a                	mov    %ecx,(%rdx)
  800684:	eb 17                	jmp    80069d <getuint+0x5b>
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068e:	48 89 d0             	mov    %rdx,%rax
  800691:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800695:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800699:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069d:	48 8b 00             	mov    (%rax),%rax
  8006a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a4:	e9 a3 00 00 00       	jmpq   80074c <getuint+0x10a>
	else if (lflag)
  8006a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006ad:	74 4f                	je     8006fe <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	83 f8 30             	cmp    $0x30,%eax
  8006b8:	73 24                	jae    8006de <getuint+0x9c>
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	89 c0                	mov    %eax,%eax
  8006ca:	48 01 d0             	add    %rdx,%rax
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	8b 12                	mov    (%rdx),%edx
  8006d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	89 0a                	mov    %ecx,(%rdx)
  8006dc:	eb 17                	jmp    8006f5 <getuint+0xb3>
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e6:	48 89 d0             	mov    %rdx,%rax
  8006e9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f5:	48 8b 00             	mov    (%rax),%rax
  8006f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006fc:	eb 4e                	jmp    80074c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800702:	8b 00                	mov    (%rax),%eax
  800704:	83 f8 30             	cmp    $0x30,%eax
  800707:	73 24                	jae    80072d <getuint+0xeb>
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800715:	8b 00                	mov    (%rax),%eax
  800717:	89 c0                	mov    %eax,%eax
  800719:	48 01 d0             	add    %rdx,%rax
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	8b 12                	mov    (%rdx),%edx
  800722:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800725:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800729:	89 0a                	mov    %ecx,(%rdx)
  80072b:	eb 17                	jmp    800744 <getuint+0x102>
  80072d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800731:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800735:	48 89 d0             	mov    %rdx,%rax
  800738:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800740:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800744:	8b 00                	mov    (%rax),%eax
  800746:	89 c0                	mov    %eax,%eax
  800748:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80074c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800750:	c9                   	leaveq 
  800751:	c3                   	retq   

0000000000800752 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	48 83 ec 1c          	sub    $0x1c,%rsp
  80075a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800761:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800765:	7e 52                	jle    8007b9 <getint+0x67>
		x=va_arg(*ap, long long);
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	8b 00                	mov    (%rax),%eax
  80076d:	83 f8 30             	cmp    $0x30,%eax
  800770:	73 24                	jae    800796 <getint+0x44>
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077e:	8b 00                	mov    (%rax),%eax
  800780:	89 c0                	mov    %eax,%eax
  800782:	48 01 d0             	add    %rdx,%rax
  800785:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800789:	8b 12                	mov    (%rdx),%edx
  80078b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800792:	89 0a                	mov    %ecx,(%rdx)
  800794:	eb 17                	jmp    8007ad <getint+0x5b>
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079e:	48 89 d0             	mov    %rdx,%rax
  8007a1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ad:	48 8b 00             	mov    (%rax),%rax
  8007b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b4:	e9 a3 00 00 00       	jmpq   80085c <getint+0x10a>
	else if (lflag)
  8007b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bd:	74 4f                	je     80080e <getint+0xbc>
		x=va_arg(*ap, long);
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	83 f8 30             	cmp    $0x30,%eax
  8007c8:	73 24                	jae    8007ee <getint+0x9c>
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	8b 12                	mov    (%rdx),%edx
  8007e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	89 0a                	mov    %ecx,(%rdx)
  8007ec:	eb 17                	jmp    800805 <getint+0xb3>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f6:	48 89 d0             	mov    %rdx,%rax
  8007f9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800805:	48 8b 00             	mov    (%rax),%rax
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080c:	eb 4e                	jmp    80085c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80080e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800812:	8b 00                	mov    (%rax),%eax
  800814:	83 f8 30             	cmp    $0x30,%eax
  800817:	73 24                	jae    80083d <getint+0xeb>
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	89 c0                	mov    %eax,%eax
  800829:	48 01 d0             	add    %rdx,%rax
  80082c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800830:	8b 12                	mov    (%rdx),%edx
  800832:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	89 0a                	mov    %ecx,(%rdx)
  80083b:	eb 17                	jmp    800854 <getint+0x102>
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800845:	48 89 d0             	mov    %rdx,%rax
  800848:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800850:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800854:	8b 00                	mov    (%rax),%eax
  800856:	48 98                	cltq   
  800858:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800860:	c9                   	leaveq 
  800861:	c3                   	retq   

0000000000800862 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	41 54                	push   %r12
  800868:	53                   	push   %rbx
  800869:	48 83 ec 60          	sub    $0x60,%rsp
  80086d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800871:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800875:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800879:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800881:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800885:	48 8b 0a             	mov    (%rdx),%rcx
  800888:	48 89 08             	mov    %rcx,(%rax)
  80088b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800893:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800897:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089b:	eb 17                	jmp    8008b4 <vprintfmt+0x52>
			if (ch == '\0')
  80089d:	85 db                	test   %ebx,%ebx
  80089f:	0f 84 df 04 00 00    	je     800d84 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ad:	48 89 d6             	mov    %rdx,%rsi
  8008b0:	89 df                	mov    %ebx,%edi
  8008b2:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008bc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c0:	0f b6 00             	movzbl (%rax),%eax
  8008c3:	0f b6 d8             	movzbl %al,%ebx
  8008c6:	83 fb 25             	cmp    $0x25,%ebx
  8008c9:	75 d2                	jne    80089d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008cf:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008eb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f7:	0f b6 00             	movzbl (%rax),%eax
  8008fa:	0f b6 d8             	movzbl %al,%ebx
  8008fd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800900:	83 f8 55             	cmp    $0x55,%eax
  800903:	0f 87 47 04 00 00    	ja     800d50 <vprintfmt+0x4ee>
  800909:	89 c0                	mov    %eax,%eax
  80090b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800912:	00 
  800913:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  80091a:	00 00 00 
  80091d:	48 01 d0             	add    %rdx,%rax
  800920:	48 8b 00             	mov    (%rax),%rax
  800923:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800925:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800929:	eb c0                	jmp    8008eb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80092b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80092f:	eb ba                	jmp    8008eb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800931:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800938:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	c1 e0 02             	shl    $0x2,%eax
  800940:	01 d0                	add    %edx,%eax
  800942:	01 c0                	add    %eax,%eax
  800944:	01 d8                	add    %ebx,%eax
  800946:	83 e8 30             	sub    $0x30,%eax
  800949:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80094c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800950:	0f b6 00             	movzbl (%rax),%eax
  800953:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800956:	83 fb 2f             	cmp    $0x2f,%ebx
  800959:	7e 0c                	jle    800967 <vprintfmt+0x105>
  80095b:	83 fb 39             	cmp    $0x39,%ebx
  80095e:	7f 07                	jg     800967 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800960:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800965:	eb d1                	jmp    800938 <vprintfmt+0xd6>
			goto process_precision;
  800967:	eb 58                	jmp    8009c1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800969:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096c:	83 f8 30             	cmp    $0x30,%eax
  80096f:	73 17                	jae    800988 <vprintfmt+0x126>
  800971:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	89 c0                	mov    %eax,%eax
  80097a:	48 01 d0             	add    %rdx,%rax
  80097d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800980:	83 c2 08             	add    $0x8,%edx
  800983:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800986:	eb 0f                	jmp    800997 <vprintfmt+0x135>
  800988:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098c:	48 89 d0             	mov    %rdx,%rax
  80098f:	48 83 c2 08          	add    $0x8,%rdx
  800993:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800997:	8b 00                	mov    (%rax),%eax
  800999:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80099c:	eb 23                	jmp    8009c1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80099e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a2:	79 0c                	jns    8009b0 <vprintfmt+0x14e>
				width = 0;
  8009a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009ab:	e9 3b ff ff ff       	jmpq   8008eb <vprintfmt+0x89>
  8009b0:	e9 36 ff ff ff       	jmpq   8008eb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009b5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009bc:	e9 2a ff ff ff       	jmpq   8008eb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c5:	79 12                	jns    8009d9 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009c7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009ca:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009d4:	e9 12 ff ff ff       	jmpq   8008eb <vprintfmt+0x89>
  8009d9:	e9 0d ff ff ff       	jmpq   8008eb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009de:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e2:	e9 04 ff ff ff       	jmpq   8008eb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ea:	83 f8 30             	cmp    $0x30,%eax
  8009ed:	73 17                	jae    800a06 <vprintfmt+0x1a4>
  8009ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f6:	89 c0                	mov    %eax,%eax
  8009f8:	48 01 d0             	add    %rdx,%rax
  8009fb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fe:	83 c2 08             	add    $0x8,%edx
  800a01:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a04:	eb 0f                	jmp    800a15 <vprintfmt+0x1b3>
  800a06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0a:	48 89 d0             	mov    %rdx,%rax
  800a0d:	48 83 c2 08          	add    $0x8,%rdx
  800a11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a15:	8b 10                	mov    (%rax),%edx
  800a17:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1f:	48 89 ce             	mov    %rcx,%rsi
  800a22:	89 d7                	mov    %edx,%edi
  800a24:	ff d0                	callq  *%rax
			break;
  800a26:	e9 53 03 00 00       	jmpq   800d7e <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2e:	83 f8 30             	cmp    $0x30,%eax
  800a31:	73 17                	jae    800a4a <vprintfmt+0x1e8>
  800a33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3a:	89 c0                	mov    %eax,%eax
  800a3c:	48 01 d0             	add    %rdx,%rax
  800a3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a42:	83 c2 08             	add    $0x8,%edx
  800a45:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a48:	eb 0f                	jmp    800a59 <vprintfmt+0x1f7>
  800a4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4e:	48 89 d0             	mov    %rdx,%rax
  800a51:	48 83 c2 08          	add    $0x8,%rdx
  800a55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a59:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x1ff>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 15             	cmp    $0x15,%ebx
  800a64:	7f 16                	jg     800a7c <vprintfmt+0x21a>
  800a66:	48 b8 00 26 80 00 00 	movabs $0x802600,%rax
  800a6d:	00 00 00 
  800a70:	48 63 d3             	movslq %ebx,%rdx
  800a73:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a77:	4d 85 e4             	test   %r12,%r12
  800a7a:	75 2e                	jne    800aaa <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a7c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a84:	89 d9                	mov    %ebx,%ecx
  800a86:	48 ba c1 26 80 00 00 	movabs $0x8026c1,%rdx
  800a8d:	00 00 00 
  800a90:	48 89 c7             	mov    %rax,%rdi
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	49 b8 8d 0d 80 00 00 	movabs $0x800d8d,%r8
  800a9f:	00 00 00 
  800aa2:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa5:	e9 d4 02 00 00       	jmpq   800d7e <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aaa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab2:	4c 89 e1             	mov    %r12,%rcx
  800ab5:	48 ba ca 26 80 00 00 	movabs $0x8026ca,%rdx
  800abc:	00 00 00 
  800abf:	48 89 c7             	mov    %rax,%rdi
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac7:	49 b8 8d 0d 80 00 00 	movabs $0x800d8d,%r8
  800ace:	00 00 00 
  800ad1:	41 ff d0             	callq  *%r8
			break;
  800ad4:	e9 a5 02 00 00       	jmpq   800d7e <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adc:	83 f8 30             	cmp    $0x30,%eax
  800adf:	73 17                	jae    800af8 <vprintfmt+0x296>
  800ae1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae8:	89 c0                	mov    %eax,%eax
  800aea:	48 01 d0             	add    %rdx,%rax
  800aed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af0:	83 c2 08             	add    $0x8,%edx
  800af3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af6:	eb 0f                	jmp    800b07 <vprintfmt+0x2a5>
  800af8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afc:	48 89 d0             	mov    %rdx,%rax
  800aff:	48 83 c2 08          	add    $0x8,%rdx
  800b03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b07:	4c 8b 20             	mov    (%rax),%r12
  800b0a:	4d 85 e4             	test   %r12,%r12
  800b0d:	75 0a                	jne    800b19 <vprintfmt+0x2b7>
				p = "(null)";
  800b0f:	49 bc cd 26 80 00 00 	movabs $0x8026cd,%r12
  800b16:	00 00 00 
			if (width > 0 && padc != '-')
  800b19:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1d:	7e 3f                	jle    800b5e <vprintfmt+0x2fc>
  800b1f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b23:	74 39                	je     800b5e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b25:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b28:	48 98                	cltq   
  800b2a:	48 89 c6             	mov    %rax,%rsi
  800b2d:	4c 89 e7             	mov    %r12,%rdi
  800b30:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  800b37:	00 00 00 
  800b3a:	ff d0                	callq  *%rax
  800b3c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b3f:	eb 17                	jmp    800b58 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b41:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b45:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4d:	48 89 ce             	mov    %rcx,%rsi
  800b50:	89 d7                	mov    %edx,%edi
  800b52:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b54:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b58:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5c:	7f e3                	jg     800b41 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5e:	eb 37                	jmp    800b97 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b60:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b64:	74 1e                	je     800b84 <vprintfmt+0x322>
  800b66:	83 fb 1f             	cmp    $0x1f,%ebx
  800b69:	7e 05                	jle    800b70 <vprintfmt+0x30e>
  800b6b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6e:	7e 14                	jle    800b84 <vprintfmt+0x322>
					putch('?', putdat);
  800b70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b78:	48 89 d6             	mov    %rdx,%rsi
  800b7b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b80:	ff d0                	callq  *%rax
  800b82:	eb 0f                	jmp    800b93 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	48 89 d6             	mov    %rdx,%rsi
  800b8f:	89 df                	mov    %ebx,%edi
  800b91:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b93:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b97:	4c 89 e0             	mov    %r12,%rax
  800b9a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b9e:	0f b6 00             	movzbl (%rax),%eax
  800ba1:	0f be d8             	movsbl %al,%ebx
  800ba4:	85 db                	test   %ebx,%ebx
  800ba6:	74 10                	je     800bb8 <vprintfmt+0x356>
  800ba8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bac:	78 b2                	js     800b60 <vprintfmt+0x2fe>
  800bae:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bb2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb6:	79 a8                	jns    800b60 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb8:	eb 16                	jmp    800bd0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc2:	48 89 d6             	mov    %rdx,%rsi
  800bc5:	bf 20 00 00 00       	mov    $0x20,%edi
  800bca:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd4:	7f e4                	jg     800bba <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bd6:	e9 a3 01 00 00       	jmpq   800d7e <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bdb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdf:	be 03 00 00 00       	mov    $0x3,%esi
  800be4:	48 89 c7             	mov    %rax,%rdi
  800be7:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800bee:	00 00 00 
  800bf1:	ff d0                	callq  *%rax
  800bf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfb:	48 85 c0             	test   %rax,%rax
  800bfe:	79 1d                	jns    800c1d <vprintfmt+0x3bb>
				putch('-', putdat);
  800c00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c08:	48 89 d6             	mov    %rdx,%rsi
  800c0b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c10:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c16:	48 f7 d8             	neg    %rax
  800c19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c1d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c24:	e9 e8 00 00 00       	jmpq   800d11 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c29:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2d:	be 03 00 00 00       	mov    $0x3,%esi
  800c32:	48 89 c7             	mov    %rax,%rdi
  800c35:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  800c3c:	00 00 00 
  800c3f:	ff d0                	callq  *%rax
  800c41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c45:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c4c:	e9 c0 00 00 00       	jmpq   800d11 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c59:	48 89 d6             	mov    %rdx,%rsi
  800c5c:	bf 58 00 00 00       	mov    $0x58,%edi
  800c61:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 d6             	mov    %rdx,%rsi
  800c6e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c73:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7d:	48 89 d6             	mov    %rdx,%rsi
  800c80:	bf 58 00 00 00       	mov    $0x58,%edi
  800c85:	ff d0                	callq  *%rax
			break;
  800c87:	e9 f2 00 00 00       	jmpq   800d7e <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c94:	48 89 d6             	mov    %rdx,%rsi
  800c97:	bf 30 00 00 00       	mov    $0x30,%edi
  800c9c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca6:	48 89 d6             	mov    %rdx,%rsi
  800ca9:	bf 78 00 00 00       	mov    $0x78,%edi
  800cae:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb3:	83 f8 30             	cmp    $0x30,%eax
  800cb6:	73 17                	jae    800ccf <vprintfmt+0x46d>
  800cb8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbf:	89 c0                	mov    %eax,%eax
  800cc1:	48 01 d0             	add    %rdx,%rax
  800cc4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc7:	83 c2 08             	add    $0x8,%edx
  800cca:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccd:	eb 0f                	jmp    800cde <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ccf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd3:	48 89 d0             	mov    %rdx,%rax
  800cd6:	48 83 c2 08          	add    $0x8,%rdx
  800cda:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cde:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ce5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cec:	eb 23                	jmp    800d11 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf2:	be 03 00 00 00       	mov    $0x3,%esi
  800cf7:	48 89 c7             	mov    %rax,%rdi
  800cfa:	48 b8 42 06 80 00 00 	movabs $0x800642,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d0a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d11:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d16:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d19:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d20:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d28:	45 89 c1             	mov    %r8d,%r9d
  800d2b:	41 89 f8             	mov    %edi,%r8d
  800d2e:	48 89 c7             	mov    %rax,%rdi
  800d31:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  800d38:	00 00 00 
  800d3b:	ff d0                	callq  *%rax
			break;
  800d3d:	eb 3f                	jmp    800d7e <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d47:	48 89 d6             	mov    %rdx,%rsi
  800d4a:	89 df                	mov    %ebx,%edi
  800d4c:	ff d0                	callq  *%rax
			break;
  800d4e:	eb 2e                	jmp    800d7e <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d58:	48 89 d6             	mov    %rdx,%rsi
  800d5b:	bf 25 00 00 00       	mov    $0x25,%edi
  800d60:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d62:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d67:	eb 05                	jmp    800d6e <vprintfmt+0x50c>
  800d69:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d6e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d72:	48 83 e8 01          	sub    $0x1,%rax
  800d76:	0f b6 00             	movzbl (%rax),%eax
  800d79:	3c 25                	cmp    $0x25,%al
  800d7b:	75 ec                	jne    800d69 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d7d:	90                   	nop
		}
	}
  800d7e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7f:	e9 30 fb ff ff       	jmpq   8008b4 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d84:	48 83 c4 60          	add    $0x60,%rsp
  800d88:	5b                   	pop    %rbx
  800d89:	41 5c                	pop    %r12
  800d8b:	5d                   	pop    %rbp
  800d8c:	c3                   	retq   

0000000000800d8d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8d:	55                   	push   %rbp
  800d8e:	48 89 e5             	mov    %rsp,%rbp
  800d91:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d98:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d9f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 20                	je     800ddf <printfmt+0x52>
  800dbf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dcf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ddf:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de6:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ded:	00 00 00 
  800df0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800df7:	00 00 00 
  800dfa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dfe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e05:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e13:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e1a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e21:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e28:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e2f:	48 89 c7             	mov    %rax,%rdi
  800e32:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800e39:	00 00 00 
  800e3c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e3e:	c9                   	leaveq 
  800e3f:	c3                   	retq   

0000000000800e40 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e40:	55                   	push   %rbp
  800e41:	48 89 e5             	mov    %rsp,%rbp
  800e44:	48 83 ec 10          	sub    $0x10,%rsp
  800e48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e53:	8b 40 10             	mov    0x10(%rax),%eax
  800e56:	8d 50 01             	lea    0x1(%rax),%edx
  800e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e64:	48 8b 10             	mov    (%rax),%rdx
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e6f:	48 39 c2             	cmp    %rax,%rdx
  800e72:	73 17                	jae    800e8b <sprintputch+0x4b>
		*b->buf++ = ch;
  800e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e78:	48 8b 00             	mov    (%rax),%rax
  800e7b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e83:	48 89 0a             	mov    %rcx,(%rdx)
  800e86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e89:	88 10                	mov    %dl,(%rax)
}
  800e8b:	c9                   	leaveq 
  800e8c:	c3                   	retq   

0000000000800e8d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e8d:	55                   	push   %rbp
  800e8e:	48 89 e5             	mov    %rsp,%rbp
  800e91:	48 83 ec 50          	sub    $0x50,%rsp
  800e95:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e99:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e9c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ea8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eac:	48 8b 0a             	mov    (%rdx),%rcx
  800eaf:	48 89 08             	mov    %rcx,(%rax)
  800eb2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ebe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eca:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ecd:	48 98                	cltq   
  800ecf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ed3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed7:	48 01 d0             	add    %rdx,%rax
  800eda:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ede:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eea:	74 06                	je     800ef2 <vsnprintf+0x65>
  800eec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef0:	7f 07                	jg     800ef9 <vsnprintf+0x6c>
		return -E_INVAL;
  800ef2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef7:	eb 2f                	jmp    800f28 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ef9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800efd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f01:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f05:	48 89 c6             	mov    %rax,%rsi
  800f08:	48 bf 40 0e 80 00 00 	movabs $0x800e40,%rdi
  800f0f:	00 00 00 
  800f12:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f22:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f25:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f28:	c9                   	leaveq 
  800f29:	c3                   	retq   

0000000000800f2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2a:	55                   	push   %rbp
  800f2b:	48 89 e5             	mov    %rsp,%rbp
  800f2e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f35:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f3c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f42:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f49:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f50:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f57:	84 c0                	test   %al,%al
  800f59:	74 20                	je     800f7b <snprintf+0x51>
  800f5b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f63:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f67:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f73:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f77:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f82:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f89:	00 00 00 
  800f8c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f93:	00 00 00 
  800f96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800faf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fbd:	48 8b 0a             	mov    (%rdx),%rcx
  800fc0:	48 89 08             	mov    %rcx,(%rax)
  800fc3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fcb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fcf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fda:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fe7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fee:	48 89 c7             	mov    %rax,%rdi
  800ff1:	48 b8 8d 0e 80 00 00 	movabs $0x800e8d,%rax
  800ff8:	00 00 00 
  800ffb:	ff d0                	callq  *%rax
  800ffd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801003:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 18          	sub    $0x18,%rsp
  801013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101e:	eb 09                	jmp    801029 <strlen+0x1e>
		n++;
  801020:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801024:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	84 c0                	test   %al,%al
  801032:	75 ec                	jne    801020 <strlen+0x15>
		n++;
	return n;
  801034:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801037:	c9                   	leaveq 
  801038:	c3                   	retq   

0000000000801039 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
  80103d:	48 83 ec 20          	sub    $0x20,%rsp
  801041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801050:	eb 0e                	jmp    801060 <strnlen+0x27>
		n++;
  801052:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801056:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801060:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801065:	74 0b                	je     801072 <strnlen+0x39>
  801067:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106b:	0f b6 00             	movzbl (%rax),%eax
  80106e:	84 c0                	test   %al,%al
  801070:	75 e0                	jne    801052 <strnlen+0x19>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801075:	c9                   	leaveq 
  801076:	c3                   	retq   

0000000000801077 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801077:	55                   	push   %rbp
  801078:	48 89 e5             	mov    %rsp,%rbp
  80107b:	48 83 ec 20          	sub    $0x20,%rsp
  80107f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80108f:	90                   	nop
  801090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801094:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801098:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80109c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010a8:	0f b6 12             	movzbl (%rdx),%edx
  8010ab:	88 10                	mov    %dl,(%rax)
  8010ad:	0f b6 00             	movzbl (%rax),%eax
  8010b0:	84 c0                	test   %al,%al
  8010b2:	75 dc                	jne    801090 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b8:	c9                   	leaveq 
  8010b9:	c3                   	retq   

00000000008010ba <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010ba:	55                   	push   %rbp
  8010bb:	48 89 e5             	mov    %rsp,%rbp
  8010be:	48 83 ec 20          	sub    $0x20,%rsp
  8010c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ce:	48 89 c7             	mov    %rax,%rdi
  8010d1:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
  8010dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e3:	48 63 d0             	movslq %eax,%rdx
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	48 01 c2             	add    %rax,%rdx
  8010ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f1:	48 89 c6             	mov    %rax,%rsi
  8010f4:	48 89 d7             	mov    %rdx,%rdi
  8010f7:	48 b8 77 10 80 00 00 	movabs $0x801077,%rax
  8010fe:	00 00 00 
  801101:	ff d0                	callq  *%rax
	return dst;
  801103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801107:	c9                   	leaveq 
  801108:	c3                   	retq   

0000000000801109 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801109:	55                   	push   %rbp
  80110a:	48 89 e5             	mov    %rsp,%rbp
  80110d:	48 83 ec 28          	sub    $0x28,%rsp
  801111:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801115:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801119:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801125:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112c:	00 
  80112d:	eb 2a                	jmp    801159 <strncpy+0x50>
		*dst++ = *src;
  80112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801133:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801137:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80113f:	0f b6 12             	movzbl (%rdx),%edx
  801142:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801144:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801148:	0f b6 00             	movzbl (%rax),%eax
  80114b:	84 c0                	test   %al,%al
  80114d:	74 05                	je     801154 <strncpy+0x4b>
			src++;
  80114f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801154:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801161:	72 cc                	jb     80112f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801163:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801167:	c9                   	leaveq 
  801168:	c3                   	retq   

0000000000801169 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	48 83 ec 28          	sub    $0x28,%rsp
  801171:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801175:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801179:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80117d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801181:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801185:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118a:	74 3d                	je     8011c9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80118c:	eb 1d                	jmp    8011ab <strlcpy+0x42>
			*dst++ = *src++;
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801196:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80119e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a6:	0f b6 12             	movzbl (%rdx),%edx
  8011a9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ab:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b5:	74 0b                	je     8011c2 <strlcpy+0x59>
  8011b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 cc                	jne    80118e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d1:	48 29 c2             	sub    %rax,%rdx
  8011d4:	48 89 d0             	mov    %rdx,%rax
}
  8011d7:	c9                   	leaveq 
  8011d8:	c3                   	retq   

00000000008011d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	48 83 ec 10          	sub    $0x10,%rsp
  8011e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011e9:	eb 0a                	jmp    8011f5 <strcmp+0x1c>
		p++, q++;
  8011eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 12                	je     801212 <strcmp+0x39>
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	0f b6 10             	movzbl (%rax),%edx
  801207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	38 c2                	cmp    %al,%dl
  801210:	74 d9                	je     8011eb <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	0f b6 00             	movzbl (%rax),%eax
  801219:	0f b6 d0             	movzbl %al,%edx
  80121c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	0f b6 c0             	movzbl %al,%eax
  801226:	29 c2                	sub    %eax,%edx
  801228:	89 d0                	mov    %edx,%eax
}
  80122a:	c9                   	leaveq 
  80122b:	c3                   	retq   

000000000080122c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80122c:	55                   	push   %rbp
  80122d:	48 89 e5             	mov    %rsp,%rbp
  801230:	48 83 ec 18          	sub    $0x18,%rsp
  801234:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801238:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80123c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801240:	eb 0f                	jmp    801251 <strncmp+0x25>
		n--, p++, q++;
  801242:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801247:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801251:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801256:	74 1d                	je     801275 <strncmp+0x49>
  801258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125c:	0f b6 00             	movzbl (%rax),%eax
  80125f:	84 c0                	test   %al,%al
  801261:	74 12                	je     801275 <strncmp+0x49>
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801267:	0f b6 10             	movzbl (%rax),%edx
  80126a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126e:	0f b6 00             	movzbl (%rax),%eax
  801271:	38 c2                	cmp    %al,%dl
  801273:	74 cd                	je     801242 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801275:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127a:	75 07                	jne    801283 <strncmp+0x57>
		return 0;
  80127c:	b8 00 00 00 00       	mov    $0x0,%eax
  801281:	eb 18                	jmp    80129b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	0f b6 00             	movzbl (%rax),%eax
  80128a:	0f b6 d0             	movzbl %al,%edx
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	0f b6 00             	movzbl (%rax),%eax
  801294:	0f b6 c0             	movzbl %al,%eax
  801297:	29 c2                	sub    %eax,%edx
  801299:	89 d0                	mov    %edx,%eax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 0c          	sub    $0xc,%rsp
  8012a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a9:	89 f0                	mov    %esi,%eax
  8012ab:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ae:	eb 17                	jmp    8012c7 <strchr+0x2a>
		if (*s == c)
  8012b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b4:	0f b6 00             	movzbl (%rax),%eax
  8012b7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ba:	75 06                	jne    8012c2 <strchr+0x25>
			return (char *) s;
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	eb 15                	jmp    8012d7 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	0f b6 00             	movzbl (%rax),%eax
  8012ce:	84 c0                	test   %al,%al
  8012d0:	75 de                	jne    8012b0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d7:	c9                   	leaveq 
  8012d8:	c3                   	retq   

00000000008012d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d9:	55                   	push   %rbp
  8012da:	48 89 e5             	mov    %rsp,%rbp
  8012dd:	48 83 ec 0c          	sub    $0xc,%rsp
  8012e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e5:	89 f0                	mov    %esi,%eax
  8012e7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ea:	eb 13                	jmp    8012ff <strfind+0x26>
		if (*s == c)
  8012ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f0:	0f b6 00             	movzbl (%rax),%eax
  8012f3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f6:	75 02                	jne    8012fa <strfind+0x21>
			break;
  8012f8:	eb 10                	jmp    80130a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	0f b6 00             	movzbl (%rax),%eax
  801306:	84 c0                	test   %al,%al
  801308:	75 e2                	jne    8012ec <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 18          	sub    $0x18,%rsp
  801318:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80131f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801323:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801328:	75 06                	jne    801330 <memset+0x20>
		return v;
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	eb 69                	jmp    801399 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	83 e0 03             	and    $0x3,%eax
  801337:	48 85 c0             	test   %rax,%rax
  80133a:	75 48                	jne    801384 <memset+0x74>
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801340:	83 e0 03             	and    $0x3,%eax
  801343:	48 85 c0             	test   %rax,%rax
  801346:	75 3c                	jne    801384 <memset+0x74>
		c &= 0xFF;
  801348:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80134f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801352:	c1 e0 18             	shl    $0x18,%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135a:	c1 e0 10             	shl    $0x10,%eax
  80135d:	09 c2                	or     %eax,%edx
  80135f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801362:	c1 e0 08             	shl    $0x8,%eax
  801365:	09 d0                	or     %edx,%eax
  801367:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80136a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136e:	48 c1 e8 02          	shr    $0x2,%rax
  801372:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801375:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801379:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137c:	48 89 d7             	mov    %rdx,%rdi
  80137f:	fc                   	cld    
  801380:	f3 ab                	rep stos %eax,%es:(%rdi)
  801382:	eb 11                	jmp    801395 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801384:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801388:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80138f:	48 89 d7             	mov    %rdx,%rdi
  801392:	fc                   	cld    
  801393:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801399:	c9                   	leaveq 
  80139a:	c3                   	retq   

000000000080139b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139b:	55                   	push   %rbp
  80139c:	48 89 e5             	mov    %rsp,%rbp
  80139f:	48 83 ec 28          	sub    $0x28,%rsp
  8013a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c7:	0f 83 88 00 00 00    	jae    801455 <memmove+0xba>
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d5:	48 01 d0             	add    %rdx,%rax
  8013d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013dc:	76 77                	jbe    801455 <memmove+0xba>
		s += n;
  8013de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ea:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f2:	83 e0 03             	and    $0x3,%eax
  8013f5:	48 85 c0             	test   %rax,%rax
  8013f8:	75 3b                	jne    801435 <memmove+0x9a>
  8013fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fe:	83 e0 03             	and    $0x3,%eax
  801401:	48 85 c0             	test   %rax,%rax
  801404:	75 2f                	jne    801435 <memmove+0x9a>
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	83 e0 03             	and    $0x3,%eax
  80140d:	48 85 c0             	test   %rax,%rax
  801410:	75 23                	jne    801435 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801416:	48 83 e8 04          	sub    $0x4,%rax
  80141a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141e:	48 83 ea 04          	sub    $0x4,%rdx
  801422:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801426:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80142a:	48 89 c7             	mov    %rax,%rdi
  80142d:	48 89 d6             	mov    %rdx,%rsi
  801430:	fd                   	std    
  801431:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801433:	eb 1d                	jmp    801452 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801439:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80143d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801441:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801449:	48 89 d7             	mov    %rdx,%rdi
  80144c:	48 89 c1             	mov    %rax,%rcx
  80144f:	fd                   	std    
  801450:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801452:	fc                   	cld    
  801453:	eb 57                	jmp    8014ac <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	48 85 c0             	test   %rax,%rax
  80145f:	75 36                	jne    801497 <memmove+0xfc>
  801461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801465:	83 e0 03             	and    $0x3,%eax
  801468:	48 85 c0             	test   %rax,%rax
  80146b:	75 2a                	jne    801497 <memmove+0xfc>
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 1e                	jne    801497 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	48 c1 e8 02          	shr    $0x2,%rax
  801481:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	48 89 c7             	mov    %rax,%rdi
  80148f:	48 89 d6             	mov    %rdx,%rsi
  801492:	fc                   	cld    
  801493:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801495:	eb 15                	jmp    8014ac <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a3:	48 89 c7             	mov    %rax,%rdi
  8014a6:	48 89 d6             	mov    %rdx,%rsi
  8014a9:	fc                   	cld    
  8014aa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b0:	c9                   	leaveq 
  8014b1:	c3                   	retq   

00000000008014b2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b2:	55                   	push   %rbp
  8014b3:	48 89 e5             	mov    %rsp,%rbp
  8014b6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ca:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d2:	48 89 ce             	mov    %rcx,%rsi
  8014d5:	48 89 c7             	mov    %rax,%rdi
  8014d8:	48 b8 9b 13 80 00 00 	movabs $0x80139b,%rax
  8014df:	00 00 00 
  8014e2:	ff d0                	callq  *%rax
}
  8014e4:	c9                   	leaveq 
  8014e5:	c3                   	retq   

00000000008014e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	48 83 ec 28          	sub    $0x28,%rsp
  8014ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801502:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801506:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80150a:	eb 36                	jmp    801542 <memcmp+0x5c>
		if (*s1 != *s2)
  80150c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801510:	0f b6 10             	movzbl (%rax),%edx
  801513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	38 c2                	cmp    %al,%dl
  80151c:	74 1a                	je     801538 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	0f b6 d0             	movzbl %al,%edx
  801528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152c:	0f b6 00             	movzbl (%rax),%eax
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	29 c2                	sub    %eax,%edx
  801534:	89 d0                	mov    %edx,%eax
  801536:	eb 20                	jmp    801558 <memcmp+0x72>
		s1++, s2++;
  801538:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80154a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154e:	48 85 c0             	test   %rax,%rax
  801551:	75 b9                	jne    80150c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801558:	c9                   	leaveq 
  801559:	c3                   	retq   

000000000080155a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	48 83 ec 28          	sub    $0x28,%rsp
  801562:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801566:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801569:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801575:	48 01 d0             	add    %rdx,%rax
  801578:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80157c:	eb 15                	jmp    801593 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801582:	0f b6 10             	movzbl (%rax),%edx
  801585:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	75 02                	jne    80158e <memfind+0x34>
			break;
  80158c:	eb 0f                	jmp    80159d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801597:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80159b:	72 e1                	jb     80157e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80159d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a1:	c9                   	leaveq 
  8015a2:	c3                   	retq   

00000000008015a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a3:	55                   	push   %rbp
  8015a4:	48 89 e5             	mov    %rsp,%rbp
  8015a7:	48 83 ec 34          	sub    $0x34,%rsp
  8015ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015b3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015bd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015c4:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c5:	eb 05                	jmp    8015cc <strtol+0x29>
		s++;
  8015c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	0f b6 00             	movzbl (%rax),%eax
  8015d3:	3c 20                	cmp    $0x20,%al
  8015d5:	74 f0                	je     8015c7 <strtol+0x24>
  8015d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015db:	0f b6 00             	movzbl (%rax),%eax
  8015de:	3c 09                	cmp    $0x9,%al
  8015e0:	74 e5                	je     8015c7 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	3c 2b                	cmp    $0x2b,%al
  8015eb:	75 07                	jne    8015f4 <strtol+0x51>
		s++;
  8015ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f2:	eb 17                	jmp    80160b <strtol+0x68>
	else if (*s == '-')
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	0f b6 00             	movzbl (%rax),%eax
  8015fb:	3c 2d                	cmp    $0x2d,%al
  8015fd:	75 0c                	jne    80160b <strtol+0x68>
		s++, neg = 1;
  8015ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801604:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160f:	74 06                	je     801617 <strtol+0x74>
  801611:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801615:	75 28                	jne    80163f <strtol+0x9c>
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	3c 30                	cmp    $0x30,%al
  801620:	75 1d                	jne    80163f <strtol+0x9c>
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	48 83 c0 01          	add    $0x1,%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 78                	cmp    $0x78,%al
  80162f:	75 0e                	jne    80163f <strtol+0x9c>
		s += 2, base = 16;
  801631:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801636:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80163d:	eb 2c                	jmp    80166b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80163f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801643:	75 19                	jne    80165e <strtol+0xbb>
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 30                	cmp    $0x30,%al
  80164e:	75 0e                	jne    80165e <strtol+0xbb>
		s++, base = 8;
  801650:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801655:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80165c:	eb 0d                	jmp    80166b <strtol+0xc8>
	else if (base == 0)
  80165e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801662:	75 07                	jne    80166b <strtol+0xc8>
		base = 10;
  801664:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	3c 2f                	cmp    $0x2f,%al
  801674:	7e 1d                	jle    801693 <strtol+0xf0>
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	3c 39                	cmp    $0x39,%al
  80167f:	7f 12                	jg     801693 <strtol+0xf0>
			dig = *s - '0';
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	0f be c0             	movsbl %al,%eax
  80168b:	83 e8 30             	sub    $0x30,%eax
  80168e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801691:	eb 4e                	jmp    8016e1 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801697:	0f b6 00             	movzbl (%rax),%eax
  80169a:	3c 60                	cmp    $0x60,%al
  80169c:	7e 1d                	jle    8016bb <strtol+0x118>
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 7a                	cmp    $0x7a,%al
  8016a7:	7f 12                	jg     8016bb <strtol+0x118>
			dig = *s - 'a' + 10;
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	0f be c0             	movsbl %al,%eax
  8016b3:	83 e8 57             	sub    $0x57,%eax
  8016b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b9:	eb 26                	jmp    8016e1 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	0f b6 00             	movzbl (%rax),%eax
  8016c2:	3c 40                	cmp    $0x40,%al
  8016c4:	7e 48                	jle    80170e <strtol+0x16b>
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3c 5a                	cmp    $0x5a,%al
  8016cf:	7f 3d                	jg     80170e <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	0f be c0             	movsbl %al,%eax
  8016db:	83 e8 37             	sub    $0x37,%eax
  8016de:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016e7:	7c 02                	jl     8016eb <strtol+0x148>
			break;
  8016e9:	eb 23                	jmp    80170e <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016f3:	48 98                	cltq   
  8016f5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016fa:	48 89 c2             	mov    %rax,%rdx
  8016fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801700:	48 98                	cltq   
  801702:	48 01 d0             	add    %rdx,%rax
  801705:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801709:	e9 5d ff ff ff       	jmpq   80166b <strtol+0xc8>

	if (endptr)
  80170e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801713:	74 0b                	je     801720 <strtol+0x17d>
		*endptr = (char *) s;
  801715:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801719:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80171d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801720:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801724:	74 09                	je     80172f <strtol+0x18c>
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	48 f7 d8             	neg    %rax
  80172d:	eb 04                	jmp    801733 <strtol+0x190>
  80172f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801733:	c9                   	leaveq 
  801734:	c3                   	retq   

0000000000801735 <strstr>:

char * strstr(const char *in, const char *str)
{
  801735:	55                   	push   %rbp
  801736:	48 89 e5             	mov    %rsp,%rbp
  801739:	48 83 ec 30          	sub    $0x30,%rsp
  80173d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801741:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801745:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801749:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801757:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80175b:	75 06                	jne    801763 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	eb 6b                	jmp    8017ce <strstr+0x99>

	len = strlen(str);
  801763:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801767:	48 89 c7             	mov    %rax,%rdi
  80176a:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  801771:	00 00 00 
  801774:	ff d0                	callq  *%rax
  801776:	48 98                	cltq   
  801778:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80177c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801780:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801784:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80178e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801792:	75 07                	jne    80179b <strstr+0x66>
				return (char *) 0;
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
  801799:	eb 33                	jmp    8017ce <strstr+0x99>
		} while (sc != c);
  80179b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80179f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017a2:	75 d8                	jne    80177c <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	48 89 ce             	mov    %rcx,%rsi
  8017b3:	48 89 c7             	mov    %rax,%rdi
  8017b6:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	callq  *%rax
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	75 b6                	jne    80177c <strstr+0x47>

	return (char *) (in - 1);
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	48 83 e8 01          	sub    $0x1,%rax
}
  8017ce:	c9                   	leaveq 
  8017cf:	c3                   	retq   

00000000008017d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017d0:	55                   	push   %rbp
  8017d1:	48 89 e5             	mov    %rsp,%rbp
  8017d4:	53                   	push   %rbx
  8017d5:	48 83 ec 48          	sub    $0x48,%rsp
  8017d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017dc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017e3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017e7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017eb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017f6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017fa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017fe:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801802:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801806:	4c 89 c3             	mov    %r8,%rbx
  801809:	cd 30                	int    $0x30
  80180b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80180f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801813:	74 3e                	je     801853 <syscall+0x83>
  801815:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80181a:	7e 37                	jle    801853 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80181c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801820:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801823:	49 89 d0             	mov    %rdx,%r8
  801826:	89 c1                	mov    %eax,%ecx
  801828:	48 ba 88 29 80 00 00 	movabs $0x802988,%rdx
  80182f:	00 00 00 
  801832:	be 23 00 00 00       	mov    $0x23,%esi
  801837:	48 bf a5 29 80 00 00 	movabs $0x8029a5,%rdi
  80183e:	00 00 00 
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	49 b9 76 02 80 00 00 	movabs $0x800276,%r9
  80184d:	00 00 00 
  801850:	41 ff d1             	callq  *%r9

	return ret;
  801853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801857:	48 83 c4 48          	add    $0x48,%rsp
  80185b:	5b                   	pop    %rbx
  80185c:	5d                   	pop    %rbp
  80185d:	c3                   	retq   

000000000080185e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80185e:	55                   	push   %rbp
  80185f:	48 89 e5             	mov    %rsp,%rbp
  801862:	48 83 ec 20          	sub    $0x20,%rsp
  801866:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80186a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80186e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801872:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801876:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187d:	00 
  80187e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801884:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188a:	48 89 d1             	mov    %rdx,%rcx
  80188d:	48 89 c2             	mov    %rax,%rdx
  801890:	be 00 00 00 00       	mov    $0x0,%esi
  801895:	bf 00 00 00 00       	mov    $0x0,%edi
  80189a:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8018a1:	00 00 00 
  8018a4:	ff d0                	callq  *%rax
}
  8018a6:	c9                   	leaveq 
  8018a7:	c3                   	retq   

00000000008018a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a8:	55                   	push   %rbp
  8018a9:	48 89 e5             	mov    %rsp,%rbp
  8018ac:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b7:	00 
  8018b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	be 00 00 00 00       	mov    $0x0,%esi
  8018d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8018d8:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8018df:	00 00 00 
  8018e2:	ff d0                	callq  *%rax
}
  8018e4:	c9                   	leaveq 
  8018e5:	c3                   	retq   

00000000008018e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018e6:	55                   	push   %rbp
  8018e7:	48 89 e5             	mov    %rsp,%rbp
  8018ea:	48 83 ec 10          	sub    $0x10,%rsp
  8018ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f4:	48 98                	cltq   
  8018f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fd:	00 
  8018fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801904:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 01 00 00 00       	mov    $0x1,%esi
  801917:	bf 03 00 00 00       	mov    $0x3,%edi
  80191c:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801932:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801939:	00 
  80193a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801940:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801946:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194b:	ba 00 00 00 00       	mov    $0x0,%edx
  801950:	be 00 00 00 00       	mov    $0x0,%esi
  801955:	bf 02 00 00 00       	mov    $0x2,%edi
  80195a:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_yield>:

void
sys_yield(void)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801977:	00 
  801978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801984:	b9 00 00 00 00       	mov    $0x0,%ecx
  801989:	ba 00 00 00 00       	mov    $0x0,%edx
  80198e:	be 00 00 00 00       	mov    $0x0,%esi
  801993:	bf 0a 00 00 00       	mov    $0xa,%edi
  801998:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 20          	sub    $0x20,%rsp
  8019ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019bb:	48 63 c8             	movslq %eax,%rcx
  8019be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c5:	48 98                	cltq   
  8019c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ce:	00 
  8019cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d5:	49 89 c8             	mov    %rcx,%r8
  8019d8:	48 89 d1             	mov    %rdx,%rcx
  8019db:	48 89 c2             	mov    %rax,%rdx
  8019de:	be 01 00 00 00       	mov    $0x1,%esi
  8019e3:	bf 04 00 00 00       	mov    $0x4,%edi
  8019e8:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 30          	sub    $0x30,%rsp
  8019fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a05:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a08:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a0c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a10:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a13:	48 63 c8             	movslq %eax,%rcx
  801a16:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a1d:	48 63 f0             	movslq %eax,%rsi
  801a20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a27:	48 98                	cltq   
  801a29:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a2d:	49 89 f9             	mov    %rdi,%r9
  801a30:	49 89 f0             	mov    %rsi,%r8
  801a33:	48 89 d1             	mov    %rdx,%rcx
  801a36:	48 89 c2             	mov    %rax,%rdx
  801a39:	be 01 00 00 00       	mov    $0x1,%esi
  801a3e:	bf 05 00 00 00       	mov    $0x5,%edi
  801a43:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   

0000000000801a51 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a51:	55                   	push   %rbp
  801a52:	48 89 e5             	mov    %rsp,%rbp
  801a55:	48 83 ec 20          	sub    $0x20,%rsp
  801a59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a67:	48 98                	cltq   
  801a69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a70:	00 
  801a71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7d:	48 89 d1             	mov    %rdx,%rcx
  801a80:	48 89 c2             	mov    %rax,%rdx
  801a83:	be 01 00 00 00       	mov    $0x1,%esi
  801a88:	bf 06 00 00 00       	mov    $0x6,%edi
  801a8d:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 10          	sub    $0x10,%rsp
  801aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801aa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aac:	48 63 d0             	movslq %eax,%rdx
  801aaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab2:	48 98                	cltq   
  801ab4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abb:	00 
  801abc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac8:	48 89 d1             	mov    %rdx,%rcx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 01 00 00 00       	mov    $0x1,%esi
  801ad3:	bf 08 00 00 00       	mov    $0x8,%edi
  801ad8:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
}
  801ae4:	c9                   	leaveq 
  801ae5:	c3                   	retq   

0000000000801ae6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	48 83 ec 20          	sub    $0x20,%rsp
  801aee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afc:	48 98                	cltq   
  801afe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b05:	00 
  801b06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b12:	48 89 d1             	mov    %rdx,%rcx
  801b15:	48 89 c2             	mov    %rax,%rdx
  801b18:	be 01 00 00 00       	mov    $0x1,%esi
  801b1d:	bf 09 00 00 00       	mov    $0x9,%edi
  801b22:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
}
  801b2e:	c9                   	leaveq 
  801b2f:	c3                   	retq   

0000000000801b30 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b30:	55                   	push   %rbp
  801b31:	48 89 e5             	mov    %rsp,%rbp
  801b34:	48 83 ec 20          	sub    $0x20,%rsp
  801b38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b3f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b43:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b49:	48 63 f0             	movslq %eax,%rsi
  801b4c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b53:	48 98                	cltq   
  801b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b60:	00 
  801b61:	49 89 f1             	mov    %rsi,%r9
  801b64:	49 89 c8             	mov    %rcx,%r8
  801b67:	48 89 d1             	mov    %rdx,%rcx
  801b6a:	48 89 c2             	mov    %rax,%rdx
  801b6d:	be 00 00 00 00       	mov    $0x0,%esi
  801b72:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b77:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	callq  *%rax
}
  801b83:	c9                   	leaveq 
  801b84:	c3                   	retq   

0000000000801b85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b85:	55                   	push   %rbp
  801b86:	48 89 e5             	mov    %rsp,%rbp
  801b89:	48 83 ec 10          	sub    $0x10,%rsp
  801b8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b95:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9c:	00 
  801b9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bae:	48 89 c2             	mov    %rax,%rdx
  801bb1:	be 01 00 00 00       	mov    $0x1,%esi
  801bb6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bbb:	48 b8 d0 17 80 00 00 	movabs $0x8017d0,%rax
  801bc2:	00 00 00 
  801bc5:	ff d0                	callq  *%rax
}
  801bc7:	c9                   	leaveq 
  801bc8:	c3                   	retq   

0000000000801bc9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bc9:	55                   	push   %rbp
  801bca:	48 89 e5             	mov    %rsp,%rbp
  801bcd:	48 83 ec 30          	sub    $0x30,%rsp
  801bd1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd9:	48 8b 00             	mov    (%rax),%rax
  801bdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801be0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be4:	48 8b 40 08          	mov    0x8(%rax),%rax
  801be8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801beb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bee:	83 e0 02             	and    $0x2,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	75 4d                	jne    801c42 <pgfault+0x79>
  801bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf9:	48 c1 e8 0c          	shr    $0xc,%rax
  801bfd:	48 89 c2             	mov    %rax,%rdx
  801c00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c07:	01 00 00 
  801c0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c0e:	25 00 08 00 00       	and    $0x800,%eax
  801c13:	48 85 c0             	test   %rax,%rax
  801c16:	74 2a                	je     801c42 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801c18:	48 ba b8 29 80 00 00 	movabs $0x8029b8,%rdx
  801c1f:	00 00 00 
  801c22:	be 1e 00 00 00       	mov    $0x1e,%esi
  801c27:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801c2e:	00 00 00 
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
  801c36:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801c3d:	00 00 00 
  801c40:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801c42:	ba 07 00 00 00       	mov    $0x7,%edx
  801c47:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c51:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  801c58:	00 00 00 
  801c5b:	ff d0                	callq  *%rax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	0f 85 cd 00 00 00    	jne    801d32 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c71:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c77:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c7f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c84:	48 89 c6             	mov    %rax,%rsi
  801c87:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c8c:	48 b8 9b 13 80 00 00 	movabs $0x80139b,%rax
  801c93:	00 00 00 
  801c96:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ca2:	48 89 c1             	mov    %rax,%rcx
  801ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  801caa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801caf:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb4:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	callq  *%rax
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	79 2a                	jns    801cee <pgfault+0x125>
				panic("Page map at temp address failed");
  801cc4:	48 ba e8 29 80 00 00 	movabs $0x8029e8,%rdx
  801ccb:	00 00 00 
  801cce:	be 2f 00 00 00       	mov    $0x2f,%esi
  801cd3:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801cda:	00 00 00 
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce2:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801ce9:	00 00 00 
  801cec:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801cee:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf8:	48 b8 51 1a 80 00 00 	movabs $0x801a51,%rax
  801cff:	00 00 00 
  801d02:	ff d0                	callq  *%rax
  801d04:	85 c0                	test   %eax,%eax
  801d06:	79 54                	jns    801d5c <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d08:	48 ba 08 2a 80 00 00 	movabs $0x802a08,%rdx
  801d0f:	00 00 00 
  801d12:	be 31 00 00 00       	mov    $0x31,%esi
  801d17:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801d1e:	00 00 00 
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
  801d26:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801d2d:	00 00 00 
  801d30:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801d32:	48 ba 30 2a 80 00 00 	movabs $0x802a30,%rdx
  801d39:	00 00 00 
  801d3c:	be 35 00 00 00       	mov    $0x35,%esi
  801d41:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801d48:	00 00 00 
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d50:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801d57:	00 00 00 
  801d5a:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 20          	sub    $0x20,%rsp
  801d66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d69:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801d6c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d73:	01 00 00 
  801d76:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d7d:	25 07 0e 00 00       	and    $0xe07,%eax
  801d82:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d85:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d88:	48 c1 e0 0c          	shl    $0xc,%rax
  801d8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d93:	25 00 04 00 00       	and    $0x400,%eax
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	74 57                	je     801df3 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d9c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d9f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801da3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801da6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801daa:	41 89 f0             	mov    %esi,%r8d
  801dad:	48 89 c6             	mov    %rax,%rsi
  801db0:	bf 00 00 00 00       	mov    $0x0,%edi
  801db5:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	0f 8e 52 01 00 00    	jle    801f1b <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801dc9:	48 ba 5d 2a 80 00 00 	movabs $0x802a5d,%rdx
  801dd0:	00 00 00 
  801dd3:	be 52 00 00 00       	mov    $0x52,%esi
  801dd8:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801ddf:	00 00 00 
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
  801de7:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801dee:	00 00 00 
  801df1:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df6:	83 e0 02             	and    $0x2,%eax
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	75 10                	jne    801e0d <duppage+0xaf>
  801dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e00:	25 00 08 00 00       	and    $0x800,%eax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	0f 84 bb 00 00 00    	je     801ec8 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e10:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e15:	80 cc 08             	or     $0x8,%ah
  801e18:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e1b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e1e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e22:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e29:	41 89 f0             	mov    %esi,%r8d
  801e2c:	48 89 c6             	mov    %rax,%rsi
  801e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e34:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	85 c0                	test   %eax,%eax
  801e42:	7e 2a                	jle    801e6e <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801e44:	48 ba 5d 2a 80 00 00 	movabs $0x802a5d,%rdx
  801e4b:	00 00 00 
  801e4e:	be 5a 00 00 00       	mov    $0x5a,%esi
  801e53:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801e5a:	00 00 00 
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801e69:	00 00 00 
  801e6c:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e6e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e79:	41 89 c8             	mov    %ecx,%r8d
  801e7c:	48 89 d1             	mov    %rdx,%rcx
  801e7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e84:	48 89 c6             	mov    %rax,%rsi
  801e87:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8c:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801e93:	00 00 00 
  801e96:	ff d0                	callq  *%rax
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	7e 2a                	jle    801ec6 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801e9c:	48 ba 5d 2a 80 00 00 	movabs $0x802a5d,%rdx
  801ea3:	00 00 00 
  801ea6:	be 5d 00 00 00       	mov    $0x5d,%esi
  801eab:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801eb2:	00 00 00 
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eba:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801ec1:	00 00 00 
  801ec4:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ec6:	eb 53                	jmp    801f1b <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ec8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ecb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ecf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed6:	41 89 f0             	mov    %esi,%r8d
  801ed9:	48 89 c6             	mov    %rax,%rsi
  801edc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee1:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801ee8:	00 00 00 
  801eeb:	ff d0                	callq  *%rax
  801eed:	85 c0                	test   %eax,%eax
  801eef:	7e 2a                	jle    801f1b <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801ef1:	48 ba 5d 2a 80 00 00 	movabs $0x802a5d,%rdx
  801ef8:	00 00 00 
  801efb:	be 61 00 00 00       	mov    $0x61,%esi
  801f00:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801f07:	00 00 00 
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0f:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  801f16:	00 00 00 
  801f19:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leaveq 
  801f21:	c3                   	retq   

0000000000801f22 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f22:	55                   	push   %rbp
  801f23:	48 89 e5             	mov    %rsp,%rbp
  801f26:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801f2a:	48 bf c9 1b 80 00 00 	movabs $0x801bc9,%rdi
  801f31:	00 00 00 
  801f34:	48 b8 ae 23 80 00 00 	movabs $0x8023ae,%rax
  801f3b:	00 00 00 
  801f3e:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f40:	b8 07 00 00 00       	mov    $0x7,%eax
  801f45:	cd 30                	int    $0x30
  801f47:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f4d:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801f50:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f54:	79 30                	jns    801f86 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f59:	89 c1                	mov    %eax,%ecx
  801f5b:	48 ba 7b 2a 80 00 00 	movabs $0x802a7b,%rdx
  801f62:	00 00 00 
  801f65:	be 89 00 00 00       	mov    $0x89,%esi
  801f6a:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  801f71:	00 00 00 
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	49 b8 76 02 80 00 00 	movabs $0x800276,%r8
  801f80:	00 00 00 
  801f83:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801f86:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f8a:	75 46                	jne    801fd2 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f8c:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f9d:	48 63 d0             	movslq %eax,%rdx
  801fa0:	48 89 d0             	mov    %rdx,%rax
  801fa3:	48 c1 e0 03          	shl    $0x3,%rax
  801fa7:	48 01 d0             	add    %rdx,%rax
  801faa:	48 c1 e0 05          	shl    $0x5,%rax
  801fae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fb5:	00 00 00 
  801fb8:	48 01 c2             	add    %rax,%rdx
  801fbb:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801fc2:	00 00 00 
  801fc5:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	e9 d1 01 00 00       	jmpq   8021a3 <fork+0x281>
	}

	uint64_t ad = 0;
  801fd2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801fd9:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801fda:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fdf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fe3:	e9 df 00 00 00       	jmpq   8020c7 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fec:	48 c1 e8 27          	shr    $0x27,%rax
  801ff0:	48 89 c2             	mov    %rax,%rdx
  801ff3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ffa:	01 00 00 
  801ffd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802001:	83 e0 01             	and    $0x1,%eax
  802004:	48 85 c0             	test   %rax,%rax
  802007:	0f 84 9e 00 00 00    	je     8020ab <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80200d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802011:	48 c1 e8 1e          	shr    $0x1e,%rax
  802015:	48 89 c2             	mov    %rax,%rdx
  802018:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80201f:	01 00 00 
  802022:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802026:	83 e0 01             	and    $0x1,%eax
  802029:	48 85 c0             	test   %rax,%rax
  80202c:	74 73                	je     8020a1 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80202e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802032:	48 c1 e8 15          	shr    $0x15,%rax
  802036:	48 89 c2             	mov    %rax,%rdx
  802039:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802040:	01 00 00 
  802043:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802047:	83 e0 01             	and    $0x1,%eax
  80204a:	48 85 c0             	test   %rax,%rax
  80204d:	74 48                	je     802097 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80204f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802053:	48 c1 e8 0c          	shr    $0xc,%rax
  802057:	48 89 c2             	mov    %rax,%rdx
  80205a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802061:	01 00 00 
  802064:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802068:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80206c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802070:	83 e0 01             	and    $0x1,%eax
  802073:	48 85 c0             	test   %rax,%rax
  802076:	74 47                	je     8020bf <fork+0x19d>
						duppage(envid, VPN(addr));
  802078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80207c:	48 c1 e8 0c          	shr    $0xc,%rax
  802080:	89 c2                	mov    %eax,%edx
  802082:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802085:	89 d6                	mov    %edx,%esi
  802087:	89 c7                	mov    %eax,%edi
  802089:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax
  802095:	eb 28                	jmp    8020bf <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  802097:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80209e:	00 
  80209f:	eb 1e                	jmp    8020bf <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020a1:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020a8:	40 
  8020a9:	eb 14                	jmp    8020bf <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  8020ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020af:	48 c1 e8 27          	shr    $0x27,%rax
  8020b3:	48 83 c0 01          	add    $0x1,%rax
  8020b7:	48 c1 e0 27          	shl    $0x27,%rax
  8020bb:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8020bf:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020c6:	00 
  8020c7:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020ce:	00 
  8020cf:	0f 87 13 ff ff ff    	ja     801fe8 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8020d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d8:	ba 07 00 00 00       	mov    $0x7,%edx
  8020dd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020e2:	89 c7                	mov    %eax,%edi
  8020e4:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8020eb:	00 00 00 
  8020ee:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8020f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f8:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020fd:	89 c7                	mov    %eax,%edi
  8020ff:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80210b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802114:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802119:	ba 00 00 00 00       	mov    $0x0,%edx
  80211e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802123:	89 c7                	mov    %eax,%edi
  802125:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802131:	ba 00 10 00 00       	mov    $0x1000,%edx
  802136:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80213b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802140:	48 b8 9b 13 80 00 00 	movabs $0x80139b,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80214c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802151:	bf 00 00 00 00       	mov    $0x0,%edi
  802156:	48 b8 51 1a 80 00 00 	movabs $0x801a51,%rax
  80215d:	00 00 00 
  802160:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802162:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802169:	00 00 00 
  80216c:	48 8b 00             	mov    (%rax),%rax
  80216f:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802179:	48 89 d6             	mov    %rdx,%rsi
  80217c:	89 c7                	mov    %eax,%edi
  80217e:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  802185:	00 00 00 
  802188:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80218a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80218d:	be 02 00 00 00       	mov    $0x2,%esi
  802192:	89 c7                	mov    %eax,%edi
  802194:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  80219b:	00 00 00 
  80219e:	ff d0                	callq  *%rax

	return envid;
  8021a0:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <sfork>:

// Challenge!
int
sfork(void)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021a9:	48 ba 93 2a 80 00 00 	movabs $0x802a93,%rdx
  8021b0:	00 00 00 
  8021b3:	be b8 00 00 00       	mov    $0xb8,%esi
  8021b8:	48 bf dd 29 80 00 00 	movabs $0x8029dd,%rdi
  8021bf:	00 00 00 
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  8021ce:	00 00 00 
  8021d1:	ff d1                	callq  *%rcx

00000000008021d3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d3:	55                   	push   %rbp
  8021d4:	48 89 e5             	mov    %rsp,%rbp
  8021d7:	48 83 ec 30          	sub    $0x30,%rsp
  8021db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8021e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8021ec:	75 0e                	jne    8021fc <ipc_recv+0x29>
        pg = (void *)UTOP;
  8021ee:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8021f5:	00 00 00 
  8021f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8021fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802200:	48 89 c7             	mov    %rax,%rdi
  802203:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	callq  *%rax
  80220f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802212:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802216:	79 27                	jns    80223f <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  802218:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80221d:	74 0a                	je     802229 <ipc_recv+0x56>
            *from_env_store = 0;
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  802229:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80222e:	74 0a                	je     80223a <ipc_recv+0x67>
            *perm_store = 0;
  802230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802234:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80223a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223d:	eb 53                	jmp    802292 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  80223f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802244:	74 19                	je     80225f <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  802246:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80224d:	00 00 00 
  802250:	48 8b 00             	mov    (%rax),%rax
  802253:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225d:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  80225f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802264:	74 19                	je     80227f <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  802266:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80226d:	00 00 00 
  802270:	48 8b 00             	mov    (%rax),%rax
  802273:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802279:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227d:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  80227f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802286:	00 00 00 
  802289:	48 8b 00             	mov    (%rax),%rax
  80228c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  802292:	c9                   	leaveq 
  802293:	c3                   	retq   

0000000000802294 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802294:	55                   	push   %rbp
  802295:	48 89 e5             	mov    %rsp,%rbp
  802298:	48 83 ec 30          	sub    $0x30,%rsp
  80229c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80229f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022a2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022a6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8022a9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022ae:	75 0e                	jne    8022be <ipc_send+0x2a>
        pg = (void *)UTOP;
  8022b0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022b7:	00 00 00 
  8022ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8022be:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8022c1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8022c4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022cb:	89 c7                	mov    %eax,%edi
  8022cd:	48 b8 30 1b 80 00 00 	movabs $0x801b30,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8022dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e0:	79 36                	jns    802318 <ipc_send+0x84>
  8022e2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8022e6:	74 30                	je     802318 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8022e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022eb:	89 c1                	mov    %eax,%ecx
  8022ed:	48 ba a9 2a 80 00 00 	movabs $0x802aa9,%rdx
  8022f4:	00 00 00 
  8022f7:	be 49 00 00 00       	mov    $0x49,%esi
  8022fc:	48 bf b6 2a 80 00 00 	movabs $0x802ab6,%rdi
  802303:	00 00 00 
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	49 b8 76 02 80 00 00 	movabs $0x800276,%r8
  802312:	00 00 00 
  802315:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  802318:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  80231f:	00 00 00 
  802322:	ff d0                	callq  *%rax
    } while(r != 0);
  802324:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802328:	75 94                	jne    8022be <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80232a:	c9                   	leaveq 
  80232b:	c3                   	retq   

000000000080232c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80232c:	55                   	push   %rbp
  80232d:	48 89 e5             	mov    %rsp,%rbp
  802330:	48 83 ec 14          	sub    $0x14,%rsp
  802334:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802337:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80233e:	eb 5e                	jmp    80239e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802340:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802347:	00 00 00 
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	48 63 d0             	movslq %eax,%rdx
  802350:	48 89 d0             	mov    %rdx,%rax
  802353:	48 c1 e0 03          	shl    $0x3,%rax
  802357:	48 01 d0             	add    %rdx,%rax
  80235a:	48 c1 e0 05          	shl    $0x5,%rax
  80235e:	48 01 c8             	add    %rcx,%rax
  802361:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802367:	8b 00                	mov    (%rax),%eax
  802369:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80236c:	75 2c                	jne    80239a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80236e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802375:	00 00 00 
  802378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237b:	48 63 d0             	movslq %eax,%rdx
  80237e:	48 89 d0             	mov    %rdx,%rax
  802381:	48 c1 e0 03          	shl    $0x3,%rax
  802385:	48 01 d0             	add    %rdx,%rax
  802388:	48 c1 e0 05          	shl    $0x5,%rax
  80238c:	48 01 c8             	add    %rcx,%rax
  80238f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802395:	8b 40 08             	mov    0x8(%rax),%eax
  802398:	eb 12                	jmp    8023ac <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80239a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80239e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8023a5:	7e 99                	jle    802340 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ac:	c9                   	leaveq 
  8023ad:	c3                   	retq   

00000000008023ae <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023ae:	55                   	push   %rbp
  8023af:	48 89 e5             	mov    %rsp,%rbp
  8023b2:	48 83 ec 10          	sub    $0x10,%rsp
  8023b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8023ba:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8023c1:	00 00 00 
  8023c4:	48 8b 00             	mov    (%rax),%rax
  8023c7:	48 85 c0             	test   %rax,%rax
  8023ca:	75 49                	jne    802415 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8023cc:	ba 07 00 00 00       	mov    $0x7,%edx
  8023d1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8023d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023db:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	79 2a                	jns    802415 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8023eb:	48 ba c0 2a 80 00 00 	movabs $0x802ac0,%rdx
  8023f2:	00 00 00 
  8023f5:	be 21 00 00 00       	mov    $0x21,%esi
  8023fa:	48 bf eb 2a 80 00 00 	movabs $0x802aeb,%rdi
  802401:	00 00 00 
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  802410:	00 00 00 
  802413:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802415:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  80241c:	00 00 00 
  80241f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802423:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802426:	48 be 71 24 80 00 00 	movabs $0x802471,%rsi
  80242d:	00 00 00 
  802430:	bf 00 00 00 00       	mov    $0x0,%edi
  802435:	48 b8 e6 1a 80 00 00 	movabs $0x801ae6,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax
  802441:	85 c0                	test   %eax,%eax
  802443:	79 2a                	jns    80246f <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802445:	48 ba 00 2b 80 00 00 	movabs $0x802b00,%rdx
  80244c:	00 00 00 
  80244f:	be 27 00 00 00       	mov    $0x27,%esi
  802454:	48 bf eb 2a 80 00 00 	movabs $0x802aeb,%rdi
  80245b:	00 00 00 
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
  802463:	48 b9 76 02 80 00 00 	movabs $0x800276,%rcx
  80246a:	00 00 00 
  80246d:	ff d1                	callq  *%rcx
}
  80246f:	c9                   	leaveq 
  802470:	c3                   	retq   

0000000000802471 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  802471:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  802474:	48 a1 10 40 80 00 00 	movabs 0x804010,%rax
  80247b:	00 00 00 
call *%rax
  80247e:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  802480:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802487:	00 
    movq 152(%rsp), %rcx
  802488:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80248f:	00 
    subq $8, %rcx
  802490:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  802494:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  802497:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  80249e:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  80249f:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8024a3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8024a7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8024ac:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8024b1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8024b6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8024bb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8024c0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8024c5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8024ca:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8024cf:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8024d4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8024d9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8024de:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8024e3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8024e8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8024ed:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  8024f1:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  8024f5:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  8024f6:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  8024f7:	c3                   	retq   
