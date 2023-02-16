
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
  80005c:	48 b8 29 22 80 00 00 	movabs $0x802229,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf a0 3e 80 00 00 	movabs $0x803ea0,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba ac 3e 80 00 00 	movabs $0x803eac,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf b5 3e 80 00 00 	movabs $0x803eb5,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
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
  8000ff:	48 b8 29 22 80 00 00 	movabs $0x802229,%rax
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
  80012d:	48 b8 ea 22 80 00 00 	movabs $0x8022ea,%rax
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
  80014c:	48 b8 78 1f 80 00 00 	movabs $0x801f78,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba ac 3e 80 00 00 	movabs $0x803eac,%rdx
  80016d:	00 00 00 
  800170:	be 2d 00 00 00       	mov    $0x2d,%esi
  800175:	48 bf b5 3e 80 00 00 	movabs $0x803eb5,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
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
  8001bc:	48 b8 ea 22 80 00 00 	movabs $0x8022ea,%rax
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
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8001dd:	48 b8 36 19 80 00 00 	movabs $0x801936,%rax
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
  800212:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800219:	00 00 00 
  80021c:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800223:	7e 14                	jle    800239 <libmain+0x6b>
		binaryname = argv[0];
  800225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800229:	48 8b 10             	mov    (%rax),%rdx
  80022c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
	close_all();
  800263:	48 b8 45 27 80 00 00 	movabs $0x802745,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80026f:	bf 00 00 00 00       	mov    $0x0,%edi
  800274:	48 b8 f2 18 80 00 00 	movabs $0x8018f2,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
}
  800280:	5d                   	pop    %rbp
  800281:	c3                   	retq   

0000000000800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
  800286:	53                   	push   %rbx
  800287:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80028e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800295:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80029b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002a2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002b0:	84 c0                	test   %al,%al
  8002b2:	74 23                	je     8002d7 <_panic+0x55>
  8002b4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002bb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002bf:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002c3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002cb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002cf:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002d3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002de:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002e5:	00 00 00 
  8002e8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002ef:	00 00 00 
  8002f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002fd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800304:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80030b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800312:	00 00 00 
  800315:	48 8b 18             	mov    (%rax),%rbx
  800318:	48 b8 36 19 80 00 00 	movabs $0x801936,%rax
  80031f:	00 00 00 
  800322:	ff d0                	callq  *%rax
  800324:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80032a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800331:	41 89 c8             	mov    %ecx,%r8d
  800334:	48 89 d1             	mov    %rdx,%rcx
  800337:	48 89 da             	mov    %rbx,%rdx
  80033a:	89 c6                	mov    %eax,%esi
  80033c:	48 bf d0 3e 80 00 00 	movabs $0x803ed0,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b9 bb 04 80 00 00 	movabs $0x8004bb,%r9
  800352:	00 00 00 
  800355:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800358:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80035f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800366:	48 89 d6             	mov    %rdx,%rsi
  800369:	48 89 c7             	mov    %rax,%rdi
  80036c:	48 b8 0f 04 80 00 00 	movabs $0x80040f,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
	cprintf("\n");
  800378:	48 bf f3 3e 80 00 00 	movabs $0x803ef3,%rdi
  80037f:	00 00 00 
  800382:	b8 00 00 00 00       	mov    $0x0,%eax
  800387:	48 ba bb 04 80 00 00 	movabs $0x8004bb,%rdx
  80038e:	00 00 00 
  800391:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800393:	cc                   	int3   
  800394:	eb fd                	jmp    800393 <_panic+0x111>

0000000000800396 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800396:	55                   	push   %rbp
  800397:	48 89 e5             	mov    %rsp,%rbp
  80039a:	48 83 ec 10          	sub    $0x10,%rsp
  80039e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a9:	8b 00                	mov    (%rax),%eax
  8003ab:	8d 48 01             	lea    0x1(%rax),%ecx
  8003ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b2:	89 0a                	mov    %ecx,(%rdx)
  8003b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003b7:	89 d1                	mov    %edx,%ecx
  8003b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bd:	48 98                	cltq   
  8003bf:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c7:	8b 00                	mov    (%rax),%eax
  8003c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ce:	75 2c                	jne    8003fc <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d4:	8b 00                	mov    (%rax),%eax
  8003d6:	48 98                	cltq   
  8003d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003dc:	48 83 c2 08          	add    $0x8,%rdx
  8003e0:	48 89 c6             	mov    %rax,%rsi
  8003e3:	48 89 d7             	mov    %rdx,%rdi
  8003e6:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
        b->idx = 0;
  8003f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	8b 40 04             	mov    0x4(%rax),%eax
  800403:	8d 50 01             	lea    0x1(%rax),%edx
  800406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80040d:	c9                   	leaveq 
  80040e:	c3                   	retq   

000000000080040f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80040f:	55                   	push   %rbp
  800410:	48 89 e5             	mov    %rsp,%rbp
  800413:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80041a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800421:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800428:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80042f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800436:	48 8b 0a             	mov    (%rdx),%rcx
  800439:	48 89 08             	mov    %rcx,(%rax)
  80043c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800440:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800444:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800448:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80044c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800453:	00 00 00 
    b.cnt = 0;
  800456:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80045d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800460:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800467:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80046e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800475:	48 89 c6             	mov    %rax,%rsi
  800478:	48 bf 96 03 80 00 00 	movabs $0x800396,%rdi
  80047f:	00 00 00 
  800482:	48 b8 6e 08 80 00 00 	movabs $0x80086e,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80048e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800494:	48 98                	cltq   
  800496:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80049d:	48 83 c2 08          	add    $0x8,%rdx
  8004a1:	48 89 c6             	mov    %rax,%rsi
  8004a4:	48 89 d7             	mov    %rdx,%rdi
  8004a7:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8004ae:	00 00 00 
  8004b1:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004cd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004d4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004db:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e9:	84 c0                	test   %al,%al
  8004eb:	74 20                	je     80050d <cprintf+0x52>
  8004ed:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004f5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004fd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800501:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800505:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800509:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80050d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800514:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80051b:	00 00 00 
  80051e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800525:	00 00 00 
  800528:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800533:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80053a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800541:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800548:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80054f:	48 8b 0a             	mov    (%rdx),%rcx
  800552:	48 89 08             	mov    %rcx,(%rax)
  800555:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800559:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80055d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800561:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800565:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80056c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800573:	48 89 d6             	mov    %rdx,%rsi
  800576:	48 89 c7             	mov    %rax,%rdi
  800579:	48 b8 0f 04 80 00 00 	movabs $0x80040f,%rax
  800580:	00 00 00 
  800583:	ff d0                	callq  *%rax
  800585:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80058b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800591:	c9                   	leaveq 
  800592:	c3                   	retq   

0000000000800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %rbp
  800594:	48 89 e5             	mov    %rsp,%rbp
  800597:	53                   	push   %rbx
  800598:	48 83 ec 38          	sub    $0x38,%rsp
  80059c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005a8:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005ab:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005af:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005b6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005ba:	77 3b                	ja     8005f7 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bc:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005bf:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005c3:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cf:	48 f7 f3             	div    %rbx
  8005d2:	48 89 c2             	mov    %rax,%rdx
  8005d5:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005d8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005db:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	41 89 f9             	mov    %edi,%r9d
  8005e6:	48 89 c7             	mov    %rax,%rdi
  8005e9:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  8005f0:	00 00 00 
  8005f3:	ff d0                	callq  *%rax
  8005f5:	eb 1e                	jmp    800615 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	eb 12                	jmp    80060b <printnum+0x78>
			putch(padc, putdat);
  8005f9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005fd:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 89 ce             	mov    %rcx,%rsi
  800607:	89 d7                	mov    %edx,%edi
  800609:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80060f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800613:	7f e4                	jg     8005f9 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800615:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80061c:	ba 00 00 00 00       	mov    $0x0,%edx
  800621:	48 f7 f1             	div    %rcx
  800624:	48 89 d0             	mov    %rdx,%rax
  800627:	48 ba f0 40 80 00 00 	movabs $0x8040f0,%rdx
  80062e:	00 00 00 
  800631:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800635:	0f be d0             	movsbl %al,%edx
  800638:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	48 89 ce             	mov    %rcx,%rsi
  800643:	89 d7                	mov    %edx,%edi
  800645:	ff d0                	callq  *%rax
}
  800647:	48 83 c4 38          	add    $0x38,%rsp
  80064b:	5b                   	pop    %rbx
  80064c:	5d                   	pop    %rbp
  80064d:	c3                   	retq   

000000000080064e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064e:	55                   	push   %rbp
  80064f:	48 89 e5             	mov    %rsp,%rbp
  800652:	48 83 ec 1c          	sub    $0x1c,%rsp
  800656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80065a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80065d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800661:	7e 52                	jle    8006b5 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800667:	8b 00                	mov    (%rax),%eax
  800669:	83 f8 30             	cmp    $0x30,%eax
  80066c:	73 24                	jae    800692 <getuint+0x44>
  80066e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800672:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067a:	8b 00                	mov    (%rax),%eax
  80067c:	89 c0                	mov    %eax,%eax
  80067e:	48 01 d0             	add    %rdx,%rax
  800681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800685:	8b 12                	mov    (%rdx),%edx
  800687:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	89 0a                	mov    %ecx,(%rdx)
  800690:	eb 17                	jmp    8006a9 <getuint+0x5b>
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80069a:	48 89 d0             	mov    %rdx,%rax
  80069d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a9:	48 8b 00             	mov    (%rax),%rax
  8006ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b0:	e9 a3 00 00 00       	jmpq   800758 <getuint+0x10a>
	else if (lflag)
  8006b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b9:	74 4f                	je     80070a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	83 f8 30             	cmp    $0x30,%eax
  8006c4:	73 24                	jae    8006ea <getuint+0x9c>
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	89 c0                	mov    %eax,%eax
  8006d6:	48 01 d0             	add    %rdx,%rax
  8006d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dd:	8b 12                	mov    (%rdx),%edx
  8006df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e6:	89 0a                	mov    %ecx,(%rdx)
  8006e8:	eb 17                	jmp    800701 <getuint+0xb3>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f2:	48 89 d0             	mov    %rdx,%rax
  8006f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800701:	48 8b 00             	mov    (%rax),%rax
  800704:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800708:	eb 4e                	jmp    800758 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	8b 00                	mov    (%rax),%eax
  800710:	83 f8 30             	cmp    $0x30,%eax
  800713:	73 24                	jae    800739 <getuint+0xeb>
  800715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800719:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800721:	8b 00                	mov    (%rax),%eax
  800723:	89 c0                	mov    %eax,%eax
  800725:	48 01 d0             	add    %rdx,%rax
  800728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072c:	8b 12                	mov    (%rdx),%edx
  80072e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800731:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800735:	89 0a                	mov    %ecx,(%rdx)
  800737:	eb 17                	jmp    800750 <getuint+0x102>
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800741:	48 89 d0             	mov    %rdx,%rax
  800744:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800748:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800750:	8b 00                	mov    (%rax),%eax
  800752:	89 c0                	mov    %eax,%eax
  800754:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075c:	c9                   	leaveq 
  80075d:	c3                   	retq   

000000000080075e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075e:	55                   	push   %rbp
  80075f:	48 89 e5             	mov    %rsp,%rbp
  800762:	48 83 ec 1c          	sub    $0x1c,%rsp
  800766:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80076a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80076d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800771:	7e 52                	jle    8007c5 <getint+0x67>
		x=va_arg(*ap, long long);
  800773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800777:	8b 00                	mov    (%rax),%eax
  800779:	83 f8 30             	cmp    $0x30,%eax
  80077c:	73 24                	jae    8007a2 <getint+0x44>
  80077e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800782:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	8b 00                	mov    (%rax),%eax
  80078c:	89 c0                	mov    %eax,%eax
  80078e:	48 01 d0             	add    %rdx,%rax
  800791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800795:	8b 12                	mov    (%rdx),%edx
  800797:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	89 0a                	mov    %ecx,(%rdx)
  8007a0:	eb 17                	jmp    8007b9 <getint+0x5b>
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007aa:	48 89 d0             	mov    %rdx,%rax
  8007ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b9:	48 8b 00             	mov    (%rax),%rax
  8007bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007c0:	e9 a3 00 00 00       	jmpq   800868 <getint+0x10a>
	else if (lflag)
  8007c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c9:	74 4f                	je     80081a <getint+0xbc>
		x=va_arg(*ap, long);
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	8b 00                	mov    (%rax),%eax
  8007d1:	83 f8 30             	cmp    $0x30,%eax
  8007d4:	73 24                	jae    8007fa <getint+0x9c>
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	89 c0                	mov    %eax,%eax
  8007e6:	48 01 d0             	add    %rdx,%rax
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	8b 12                	mov    (%rdx),%edx
  8007ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f6:	89 0a                	mov    %ecx,(%rdx)
  8007f8:	eb 17                	jmp    800811 <getint+0xb3>
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800802:	48 89 d0             	mov    %rdx,%rax
  800805:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800811:	48 8b 00             	mov    (%rax),%rax
  800814:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800818:	eb 4e                	jmp    800868 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	8b 00                	mov    (%rax),%eax
  800820:	83 f8 30             	cmp    $0x30,%eax
  800823:	73 24                	jae    800849 <getint+0xeb>
  800825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800829:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	8b 00                	mov    (%rax),%eax
  800833:	89 c0                	mov    %eax,%eax
  800835:	48 01 d0             	add    %rdx,%rax
  800838:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083c:	8b 12                	mov    (%rdx),%edx
  80083e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800841:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800845:	89 0a                	mov    %ecx,(%rdx)
  800847:	eb 17                	jmp    800860 <getint+0x102>
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800851:	48 89 d0             	mov    %rdx,%rax
  800854:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800858:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800860:	8b 00                	mov    (%rax),%eax
  800862:	48 98                	cltq   
  800864:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800868:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80086c:	c9                   	leaveq 
  80086d:	c3                   	retq   

000000000080086e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086e:	55                   	push   %rbp
  80086f:	48 89 e5             	mov    %rsp,%rbp
  800872:	41 54                	push   %r12
  800874:	53                   	push   %rbx
  800875:	48 83 ec 60          	sub    $0x60,%rsp
  800879:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80087d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800881:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800885:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800889:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80088d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800891:	48 8b 0a             	mov    (%rdx),%rcx
  800894:	48 89 08             	mov    %rcx,(%rax)
  800897:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80089b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a7:	eb 17                	jmp    8008c0 <vprintfmt+0x52>
			if (ch == '\0')
  8008a9:	85 db                	test   %ebx,%ebx
  8008ab:	0f 84 df 04 00 00    	je     800d90 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008b1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b9:	48 89 d6             	mov    %rdx,%rsi
  8008bc:	89 df                	mov    %ebx,%edi
  8008be:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008cc:	0f b6 00             	movzbl (%rax),%eax
  8008cf:	0f b6 d8             	movzbl %al,%ebx
  8008d2:	83 fb 25             	cmp    $0x25,%ebx
  8008d5:	75 d2                	jne    8008a9 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008db:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ff:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800903:	0f b6 00             	movzbl (%rax),%eax
  800906:	0f b6 d8             	movzbl %al,%ebx
  800909:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80090c:	83 f8 55             	cmp    $0x55,%eax
  80090f:	0f 87 47 04 00 00    	ja     800d5c <vprintfmt+0x4ee>
  800915:	89 c0                	mov    %eax,%eax
  800917:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80091e:	00 
  80091f:	48 b8 18 41 80 00 00 	movabs $0x804118,%rax
  800926:	00 00 00 
  800929:	48 01 d0             	add    %rdx,%rax
  80092c:	48 8b 00             	mov    (%rax),%rax
  80092f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800931:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800935:	eb c0                	jmp    8008f7 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800937:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80093b:	eb ba                	jmp    8008f7 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800944:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800947:	89 d0                	mov    %edx,%eax
  800949:	c1 e0 02             	shl    $0x2,%eax
  80094c:	01 d0                	add    %edx,%eax
  80094e:	01 c0                	add    %eax,%eax
  800950:	01 d8                	add    %ebx,%eax
  800952:	83 e8 30             	sub    $0x30,%eax
  800955:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800958:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80095c:	0f b6 00             	movzbl (%rax),%eax
  80095f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800962:	83 fb 2f             	cmp    $0x2f,%ebx
  800965:	7e 0c                	jle    800973 <vprintfmt+0x105>
  800967:	83 fb 39             	cmp    $0x39,%ebx
  80096a:	7f 07                	jg     800973 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800971:	eb d1                	jmp    800944 <vprintfmt+0xd6>
			goto process_precision;
  800973:	eb 58                	jmp    8009cd <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	83 f8 30             	cmp    $0x30,%eax
  80097b:	73 17                	jae    800994 <vprintfmt+0x126>
  80097d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800981:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800984:	89 c0                	mov    %eax,%eax
  800986:	48 01 d0             	add    %rdx,%rax
  800989:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098c:	83 c2 08             	add    $0x8,%edx
  80098f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800992:	eb 0f                	jmp    8009a3 <vprintfmt+0x135>
  800994:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800998:	48 89 d0             	mov    %rdx,%rax
  80099b:	48 83 c2 08          	add    $0x8,%rdx
  80099f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a3:	8b 00                	mov    (%rax),%eax
  8009a5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009a8:	eb 23                	jmp    8009cd <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ae:	79 0c                	jns    8009bc <vprintfmt+0x14e>
				width = 0;
  8009b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b7:	e9 3b ff ff ff       	jmpq   8008f7 <vprintfmt+0x89>
  8009bc:	e9 36 ff ff ff       	jmpq   8008f7 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009c1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009c8:	e9 2a ff ff ff       	jmpq   8008f7 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d1:	79 12                	jns    8009e5 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009d3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009e0:	e9 12 ff ff ff       	jmpq   8008f7 <vprintfmt+0x89>
  8009e5:	e9 0d ff ff ff       	jmpq   8008f7 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009ea:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ee:	e9 04 ff ff ff       	jmpq   8008f7 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f6:	83 f8 30             	cmp    $0x30,%eax
  8009f9:	73 17                	jae    800a12 <vprintfmt+0x1a4>
  8009fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a02:	89 c0                	mov    %eax,%eax
  800a04:	48 01 d0             	add    %rdx,%rax
  800a07:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0a:	83 c2 08             	add    $0x8,%edx
  800a0d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a10:	eb 0f                	jmp    800a21 <vprintfmt+0x1b3>
  800a12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a16:	48 89 d0             	mov    %rdx,%rax
  800a19:	48 83 c2 08          	add    $0x8,%rdx
  800a1d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a21:	8b 10                	mov    (%rax),%edx
  800a23:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2b:	48 89 ce             	mov    %rcx,%rsi
  800a2e:	89 d7                	mov    %edx,%edi
  800a30:	ff d0                	callq  *%rax
			break;
  800a32:	e9 53 03 00 00       	jmpq   800d8a <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3a:	83 f8 30             	cmp    $0x30,%eax
  800a3d:	73 17                	jae    800a56 <vprintfmt+0x1e8>
  800a3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a46:	89 c0                	mov    %eax,%eax
  800a48:	48 01 d0             	add    %rdx,%rax
  800a4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4e:	83 c2 08             	add    $0x8,%edx
  800a51:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a54:	eb 0f                	jmp    800a65 <vprintfmt+0x1f7>
  800a56:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a5a:	48 89 d0             	mov    %rdx,%rax
  800a5d:	48 83 c2 08          	add    $0x8,%rdx
  800a61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a65:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a67:	85 db                	test   %ebx,%ebx
  800a69:	79 02                	jns    800a6d <vprintfmt+0x1ff>
				err = -err;
  800a6b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a6d:	83 fb 15             	cmp    $0x15,%ebx
  800a70:	7f 16                	jg     800a88 <vprintfmt+0x21a>
  800a72:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  800a79:	00 00 00 
  800a7c:	48 63 d3             	movslq %ebx,%rdx
  800a7f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a83:	4d 85 e4             	test   %r12,%r12
  800a86:	75 2e                	jne    800ab6 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a88:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a90:	89 d9                	mov    %ebx,%ecx
  800a92:	48 ba 01 41 80 00 00 	movabs $0x804101,%rdx
  800a99:	00 00 00 
  800a9c:	48 89 c7             	mov    %rax,%rdi
  800a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa4:	49 b8 99 0d 80 00 00 	movabs $0x800d99,%r8
  800aab:	00 00 00 
  800aae:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab1:	e9 d4 02 00 00       	jmpq   800d8a <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abe:	4c 89 e1             	mov    %r12,%rcx
  800ac1:	48 ba 0a 41 80 00 00 	movabs $0x80410a,%rdx
  800ac8:	00 00 00 
  800acb:	48 89 c7             	mov    %rax,%rdi
  800ace:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad3:	49 b8 99 0d 80 00 00 	movabs $0x800d99,%r8
  800ada:	00 00 00 
  800add:	41 ff d0             	callq  *%r8
			break;
  800ae0:	e9 a5 02 00 00       	jmpq   800d8a <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ae5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae8:	83 f8 30             	cmp    $0x30,%eax
  800aeb:	73 17                	jae    800b04 <vprintfmt+0x296>
  800aed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af4:	89 c0                	mov    %eax,%eax
  800af6:	48 01 d0             	add    %rdx,%rax
  800af9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afc:	83 c2 08             	add    $0x8,%edx
  800aff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b02:	eb 0f                	jmp    800b13 <vprintfmt+0x2a5>
  800b04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b08:	48 89 d0             	mov    %rdx,%rax
  800b0b:	48 83 c2 08          	add    $0x8,%rdx
  800b0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b13:	4c 8b 20             	mov    (%rax),%r12
  800b16:	4d 85 e4             	test   %r12,%r12
  800b19:	75 0a                	jne    800b25 <vprintfmt+0x2b7>
				p = "(null)";
  800b1b:	49 bc 0d 41 80 00 00 	movabs $0x80410d,%r12
  800b22:	00 00 00 
			if (width > 0 && padc != '-')
  800b25:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b29:	7e 3f                	jle    800b6a <vprintfmt+0x2fc>
  800b2b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b2f:	74 39                	je     800b6a <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b34:	48 98                	cltq   
  800b36:	48 89 c6             	mov    %rax,%rsi
  800b39:	4c 89 e7             	mov    %r12,%rdi
  800b3c:	48 b8 45 10 80 00 00 	movabs $0x801045,%rax
  800b43:	00 00 00 
  800b46:	ff d0                	callq  *%rax
  800b48:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b4b:	eb 17                	jmp    800b64 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b4d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b51:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b59:	48 89 ce             	mov    %rcx,%rsi
  800b5c:	89 d7                	mov    %edx,%edi
  800b5e:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b60:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b68:	7f e3                	jg     800b4d <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6a:	eb 37                	jmp    800ba3 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b70:	74 1e                	je     800b90 <vprintfmt+0x322>
  800b72:	83 fb 1f             	cmp    $0x1f,%ebx
  800b75:	7e 05                	jle    800b7c <vprintfmt+0x30e>
  800b77:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7a:	7e 14                	jle    800b90 <vprintfmt+0x322>
					putch('?', putdat);
  800b7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b84:	48 89 d6             	mov    %rdx,%rsi
  800b87:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b8c:	ff d0                	callq  *%rax
  800b8e:	eb 0f                	jmp    800b9f <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b98:	48 89 d6             	mov    %rdx,%rsi
  800b9b:	89 df                	mov    %ebx,%edi
  800b9d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba3:	4c 89 e0             	mov    %r12,%rax
  800ba6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800baa:	0f b6 00             	movzbl (%rax),%eax
  800bad:	0f be d8             	movsbl %al,%ebx
  800bb0:	85 db                	test   %ebx,%ebx
  800bb2:	74 10                	je     800bc4 <vprintfmt+0x356>
  800bb4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb8:	78 b2                	js     800b6c <vprintfmt+0x2fe>
  800bba:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bbe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc2:	79 a8                	jns    800b6c <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc4:	eb 16                	jmp    800bdc <vprintfmt+0x36e>
				putch(' ', putdat);
  800bc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 d6             	mov    %rdx,%rsi
  800bd1:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd6:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bdc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be0:	7f e4                	jg     800bc6 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800be2:	e9 a3 01 00 00       	jmpq   800d8a <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800beb:	be 03 00 00 00       	mov    $0x3,%esi
  800bf0:	48 89 c7             	mov    %rax,%rdi
  800bf3:	48 b8 5e 07 80 00 00 	movabs $0x80075e,%rax
  800bfa:	00 00 00 
  800bfd:	ff d0                	callq  *%rax
  800bff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	48 85 c0             	test   %rax,%rax
  800c0a:	79 1d                	jns    800c29 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c14:	48 89 d6             	mov    %rdx,%rsi
  800c17:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c1c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c22:	48 f7 d8             	neg    %rax
  800c25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c29:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c30:	e9 e8 00 00 00       	jmpq   800d1d <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c35:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c39:	be 03 00 00 00       	mov    $0x3,%esi
  800c3e:	48 89 c7             	mov    %rax,%rdi
  800c41:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800c48:	00 00 00 
  800c4b:	ff d0                	callq  *%rax
  800c4d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c51:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c58:	e9 c0 00 00 00       	jmpq   800d1d <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c65:	48 89 d6             	mov    %rdx,%rsi
  800c68:	bf 58 00 00 00       	mov    $0x58,%edi
  800c6d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c77:	48 89 d6             	mov    %rdx,%rsi
  800c7a:	bf 58 00 00 00       	mov    $0x58,%edi
  800c7f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c89:	48 89 d6             	mov    %rdx,%rsi
  800c8c:	bf 58 00 00 00       	mov    $0x58,%edi
  800c91:	ff d0                	callq  *%rax
			break;
  800c93:	e9 f2 00 00 00       	jmpq   800d8a <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca0:	48 89 d6             	mov    %rdx,%rsi
  800ca3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ca8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800caa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb2:	48 89 d6             	mov    %rdx,%rsi
  800cb5:	bf 78 00 00 00       	mov    $0x78,%edi
  800cba:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbf:	83 f8 30             	cmp    $0x30,%eax
  800cc2:	73 17                	jae    800cdb <vprintfmt+0x46d>
  800cc4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccb:	89 c0                	mov    %eax,%eax
  800ccd:	48 01 d0             	add    %rdx,%rax
  800cd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd3:	83 c2 08             	add    $0x8,%edx
  800cd6:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd9:	eb 0f                	jmp    800cea <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cdb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cdf:	48 89 d0             	mov    %rdx,%rax
  800ce2:	48 83 c2 08          	add    $0x8,%rdx
  800ce6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cea:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ced:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cf1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cf8:	eb 23                	jmp    800d1d <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cfe:	be 03 00 00 00       	mov    $0x3,%esi
  800d03:	48 89 c7             	mov    %rax,%rdi
  800d06:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800d0d:	00 00 00 
  800d10:	ff d0                	callq  *%rax
  800d12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d16:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d1d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d22:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d25:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d34:	45 89 c1             	mov    %r8d,%r9d
  800d37:	41 89 f8             	mov    %edi,%r8d
  800d3a:	48 89 c7             	mov    %rax,%rdi
  800d3d:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  800d44:	00 00 00 
  800d47:	ff d0                	callq  *%rax
			break;
  800d49:	eb 3f                	jmp    800d8a <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d53:	48 89 d6             	mov    %rdx,%rsi
  800d56:	89 df                	mov    %ebx,%edi
  800d58:	ff d0                	callq  *%rax
			break;
  800d5a:	eb 2e                	jmp    800d8a <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d64:	48 89 d6             	mov    %rdx,%rsi
  800d67:	bf 25 00 00 00       	mov    $0x25,%edi
  800d6c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d6e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d73:	eb 05                	jmp    800d7a <vprintfmt+0x50c>
  800d75:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d7e:	48 83 e8 01          	sub    $0x1,%rax
  800d82:	0f b6 00             	movzbl (%rax),%eax
  800d85:	3c 25                	cmp    $0x25,%al
  800d87:	75 ec                	jne    800d75 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d89:	90                   	nop
		}
	}
  800d8a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8b:	e9 30 fb ff ff       	jmpq   8008c0 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d90:	48 83 c4 60          	add    $0x60,%rsp
  800d94:	5b                   	pop    %rbx
  800d95:	41 5c                	pop    %r12
  800d97:	5d                   	pop    %rbp
  800d98:	c3                   	retq   

0000000000800d99 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d99:	55                   	push   %rbp
  800d9a:	48 89 e5             	mov    %rsp,%rbp
  800d9d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800da4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dab:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800db2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800db9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc7:	84 c0                	test   %al,%al
  800dc9:	74 20                	je     800deb <printfmt+0x52>
  800dcb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dcf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ddb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ddf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800deb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800df2:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800df9:	00 00 00 
  800dfc:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e03:	00 00 00 
  800e06:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e11:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e18:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e1f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e26:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e2d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e34:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e3b:	48 89 c7             	mov    %rax,%rdi
  800e3e:	48 b8 6e 08 80 00 00 	movabs $0x80086e,%rax
  800e45:	00 00 00 
  800e48:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e4a:	c9                   	leaveq 
  800e4b:	c3                   	retq   

0000000000800e4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e4c:	55                   	push   %rbp
  800e4d:	48 89 e5             	mov    %rsp,%rbp
  800e50:	48 83 ec 10          	sub    $0x10,%rsp
  800e54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5f:	8b 40 10             	mov    0x10(%rax),%eax
  800e62:	8d 50 01             	lea    0x1(%rax),%edx
  800e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e69:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e70:	48 8b 10             	mov    (%rax),%rdx
  800e73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e77:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e7b:	48 39 c2             	cmp    %rax,%rdx
  800e7e:	73 17                	jae    800e97 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e84:	48 8b 00             	mov    (%rax),%rax
  800e87:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e8f:	48 89 0a             	mov    %rcx,(%rdx)
  800e92:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e95:	88 10                	mov    %dl,(%rax)
}
  800e97:	c9                   	leaveq 
  800e98:	c3                   	retq   

0000000000800e99 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e99:	55                   	push   %rbp
  800e9a:	48 89 e5             	mov    %rsp,%rbp
  800e9d:	48 83 ec 50          	sub    $0x50,%rsp
  800ea1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ea5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ea8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eac:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800eb0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eb4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eb8:	48 8b 0a             	mov    (%rdx),%rcx
  800ebb:	48 89 08             	mov    %rcx,(%rax)
  800ebe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ec2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eca:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ece:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ed6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ed9:	48 98                	cltq   
  800edb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800edf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee3:	48 01 d0             	add    %rdx,%rax
  800ee6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ef1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ef6:	74 06                	je     800efe <vsnprintf+0x65>
  800ef8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800efc:	7f 07                	jg     800f05 <vsnprintf+0x6c>
		return -E_INVAL;
  800efe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f03:	eb 2f                	jmp    800f34 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f05:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f09:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f0d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f11:	48 89 c6             	mov    %rax,%rsi
  800f14:	48 bf 4c 0e 80 00 00 	movabs $0x800e4c,%rdi
  800f1b:	00 00 00 
  800f1e:	48 b8 6e 08 80 00 00 	movabs $0x80086e,%rax
  800f25:	00 00 00 
  800f28:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f2e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f31:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f34:	c9                   	leaveq 
  800f35:	c3                   	retq   

0000000000800f36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f36:	55                   	push   %rbp
  800f37:	48 89 e5             	mov    %rsp,%rbp
  800f3a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f41:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f48:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f4e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f55:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f5c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f63:	84 c0                	test   %al,%al
  800f65:	74 20                	je     800f87 <snprintf+0x51>
  800f67:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f6b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f6f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f73:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f77:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f7b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f7f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f83:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f87:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f8e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f95:	00 00 00 
  800f98:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f9f:	00 00 00 
  800fa2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fb4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fbb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fc2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fc9:	48 8b 0a             	mov    (%rdx),%rcx
  800fcc:	48 89 08             	mov    %rcx,(%rax)
  800fcf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fdb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fdf:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fe6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fed:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ff3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ffa:	48 89 c7             	mov    %rax,%rdi
  800ffd:	48 b8 99 0e 80 00 00 	movabs $0x800e99,%rax
  801004:	00 00 00 
  801007:	ff d0                	callq  *%rax
  801009:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80100f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801015:	c9                   	leaveq 
  801016:	c3                   	retq   

0000000000801017 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801017:	55                   	push   %rbp
  801018:	48 89 e5             	mov    %rsp,%rbp
  80101b:	48 83 ec 18          	sub    $0x18,%rsp
  80101f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102a:	eb 09                	jmp    801035 <strlen+0x1e>
		n++;
  80102c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801030:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801039:	0f b6 00             	movzbl (%rax),%eax
  80103c:	84 c0                	test   %al,%al
  80103e:	75 ec                	jne    80102c <strlen+0x15>
		n++;
	return n;
  801040:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801043:	c9                   	leaveq 
  801044:	c3                   	retq   

0000000000801045 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801045:	55                   	push   %rbp
  801046:	48 89 e5             	mov    %rsp,%rbp
  801049:	48 83 ec 20          	sub    $0x20,%rsp
  80104d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801051:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105c:	eb 0e                	jmp    80106c <strnlen+0x27>
		n++;
  80105e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801062:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801067:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80106c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801071:	74 0b                	je     80107e <strnlen+0x39>
  801073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801077:	0f b6 00             	movzbl (%rax),%eax
  80107a:	84 c0                	test   %al,%al
  80107c:	75 e0                	jne    80105e <strnlen+0x19>
		n++;
	return n;
  80107e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801081:	c9                   	leaveq 
  801082:	c3                   	retq   

0000000000801083 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801083:	55                   	push   %rbp
  801084:	48 89 e5             	mov    %rsp,%rbp
  801087:	48 83 ec 20          	sub    $0x20,%rsp
  80108b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80108f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801097:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80109b:	90                   	nop
  80109c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010b0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b4:	0f b6 12             	movzbl (%rdx),%edx
  8010b7:	88 10                	mov    %dl,(%rax)
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 dc                	jne    80109c <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 83 ec 20          	sub    $0x20,%rsp
  8010ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010da:	48 89 c7             	mov    %rax,%rdi
  8010dd:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	callq  *%rax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ef:	48 63 d0             	movslq %eax,%rdx
  8010f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f6:	48 01 c2             	add    %rax,%rdx
  8010f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010fd:	48 89 c6             	mov    %rax,%rsi
  801100:	48 89 d7             	mov    %rdx,%rdi
  801103:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  80110a:	00 00 00 
  80110d:	ff d0                	callq  *%rax
	return dst;
  80110f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 28          	sub    $0x28,%rsp
  80111d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801121:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801125:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801131:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801138:	00 
  801139:	eb 2a                	jmp    801165 <strncpy+0x50>
		*dst++ = *src;
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801143:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801147:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80114b:	0f b6 12             	movzbl (%rdx),%edx
  80114e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801154:	0f b6 00             	movzbl (%rax),%eax
  801157:	84 c0                	test   %al,%al
  801159:	74 05                	je     801160 <strncpy+0x4b>
			src++;
  80115b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801160:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80116d:	72 cc                	jb     80113b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80116f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801173:	c9                   	leaveq 
  801174:	c3                   	retq   

0000000000801175 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801175:	55                   	push   %rbp
  801176:	48 89 e5             	mov    %rsp,%rbp
  801179:	48 83 ec 28          	sub    $0x28,%rsp
  80117d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801181:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801185:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801191:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801196:	74 3d                	je     8011d5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801198:	eb 1d                	jmp    8011b7 <strlcpy+0x42>
			*dst++ = *src++;
  80119a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011aa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011ae:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011b2:	0f b6 12             	movzbl (%rdx),%edx
  8011b5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011bc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011c1:	74 0b                	je     8011ce <strlcpy+0x59>
  8011c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c7:	0f b6 00             	movzbl (%rax),%eax
  8011ca:	84 c0                	test   %al,%al
  8011cc:	75 cc                	jne    80119a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dd:	48 29 c2             	sub    %rax,%rdx
  8011e0:	48 89 d0             	mov    %rdx,%rax
}
  8011e3:	c9                   	leaveq 
  8011e4:	c3                   	retq   

00000000008011e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011e5:	55                   	push   %rbp
  8011e6:	48 89 e5             	mov    %rsp,%rbp
  8011e9:	48 83 ec 10          	sub    $0x10,%rsp
  8011ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011f5:	eb 0a                	jmp    801201 <strcmp+0x1c>
		p++, q++;
  8011f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	84 c0                	test   %al,%al
  80120a:	74 12                	je     80121e <strcmp+0x39>
  80120c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801210:	0f b6 10             	movzbl (%rax),%edx
  801213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801217:	0f b6 00             	movzbl (%rax),%eax
  80121a:	38 c2                	cmp    %al,%dl
  80121c:	74 d9                	je     8011f7 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801222:	0f b6 00             	movzbl (%rax),%eax
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122c:	0f b6 00             	movzbl (%rax),%eax
  80122f:	0f b6 c0             	movzbl %al,%eax
  801232:	29 c2                	sub    %eax,%edx
  801234:	89 d0                	mov    %edx,%eax
}
  801236:	c9                   	leaveq 
  801237:	c3                   	retq   

0000000000801238 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801238:	55                   	push   %rbp
  801239:	48 89 e5             	mov    %rsp,%rbp
  80123c:	48 83 ec 18          	sub    $0x18,%rsp
  801240:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801244:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801248:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80124c:	eb 0f                	jmp    80125d <strncmp+0x25>
		n--, p++, q++;
  80124e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801253:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801258:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80125d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801262:	74 1d                	je     801281 <strncmp+0x49>
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	0f b6 00             	movzbl (%rax),%eax
  80126b:	84 c0                	test   %al,%al
  80126d:	74 12                	je     801281 <strncmp+0x49>
  80126f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801273:	0f b6 10             	movzbl (%rax),%edx
  801276:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127a:	0f b6 00             	movzbl (%rax),%eax
  80127d:	38 c2                	cmp    %al,%dl
  80127f:	74 cd                	je     80124e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801281:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801286:	75 07                	jne    80128f <strncmp+0x57>
		return 0;
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
  80128d:	eb 18                	jmp    8012a7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80128f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801293:	0f b6 00             	movzbl (%rax),%eax
  801296:	0f b6 d0             	movzbl %al,%edx
  801299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	0f b6 c0             	movzbl %al,%eax
  8012a3:	29 c2                	sub    %eax,%edx
  8012a5:	89 d0                	mov    %edx,%eax
}
  8012a7:	c9                   	leaveq 
  8012a8:	c3                   	retq   

00000000008012a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012a9:	55                   	push   %rbp
  8012aa:	48 89 e5             	mov    %rsp,%rbp
  8012ad:	48 83 ec 0c          	sub    $0xc,%rsp
  8012b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b5:	89 f0                	mov    %esi,%eax
  8012b7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ba:	eb 17                	jmp    8012d3 <strchr+0x2a>
		if (*s == c)
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c6:	75 06                	jne    8012ce <strchr+0x25>
			return (char *) s;
  8012c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cc:	eb 15                	jmp    8012e3 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	84 c0                	test   %al,%al
  8012dc:	75 de                	jne    8012bc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e3:	c9                   	leaveq 
  8012e4:	c3                   	retq   

00000000008012e5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e5:	55                   	push   %rbp
  8012e6:	48 89 e5             	mov    %rsp,%rbp
  8012e9:	48 83 ec 0c          	sub    $0xc,%rsp
  8012ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f1:	89 f0                	mov    %esi,%eax
  8012f3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012f6:	eb 13                	jmp    80130b <strfind+0x26>
		if (*s == c)
  8012f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fc:	0f b6 00             	movzbl (%rax),%eax
  8012ff:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801302:	75 02                	jne    801306 <strfind+0x21>
			break;
  801304:	eb 10                	jmp    801316 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801306:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130f:	0f b6 00             	movzbl (%rax),%eax
  801312:	84 c0                	test   %al,%al
  801314:	75 e2                	jne    8012f8 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80131a:	c9                   	leaveq 
  80131b:	c3                   	retq   

000000000080131c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80131c:	55                   	push   %rbp
  80131d:	48 89 e5             	mov    %rsp,%rbp
  801320:	48 83 ec 18          	sub    $0x18,%rsp
  801324:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801328:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80132b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80132f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801334:	75 06                	jne    80133c <memset+0x20>
		return v;
  801336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133a:	eb 69                	jmp    8013a5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	83 e0 03             	and    $0x3,%eax
  801343:	48 85 c0             	test   %rax,%rax
  801346:	75 48                	jne    801390 <memset+0x74>
  801348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134c:	83 e0 03             	and    $0x3,%eax
  80134f:	48 85 c0             	test   %rax,%rax
  801352:	75 3c                	jne    801390 <memset+0x74>
		c &= 0xFF;
  801354:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80135b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135e:	c1 e0 18             	shl    $0x18,%eax
  801361:	89 c2                	mov    %eax,%edx
  801363:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801366:	c1 e0 10             	shl    $0x10,%eax
  801369:	09 c2                	or     %eax,%edx
  80136b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136e:	c1 e0 08             	shl    $0x8,%eax
  801371:	09 d0                	or     %edx,%eax
  801373:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137a:	48 c1 e8 02          	shr    $0x2,%rax
  80137e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801381:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801385:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801388:	48 89 d7             	mov    %rdx,%rdi
  80138b:	fc                   	cld    
  80138c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80138e:	eb 11                	jmp    8013a1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801390:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801394:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801397:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80139b:	48 89 d7             	mov    %rdx,%rdi
  80139e:	fc                   	cld    
  80139f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013a5:	c9                   	leaveq 
  8013a6:	c3                   	retq   

00000000008013a7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013a7:	55                   	push   %rbp
  8013a8:	48 89 e5             	mov    %rsp,%rbp
  8013ab:	48 83 ec 28          	sub    $0x28,%rsp
  8013af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d3:	0f 83 88 00 00 00    	jae    801461 <memmove+0xba>
  8013d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e1:	48 01 d0             	add    %rdx,%rax
  8013e4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e8:	76 77                	jbe    801461 <memmove+0xba>
		s += n;
  8013ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ee:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f6:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	83 e0 03             	and    $0x3,%eax
  801401:	48 85 c0             	test   %rax,%rax
  801404:	75 3b                	jne    801441 <memmove+0x9a>
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	83 e0 03             	and    $0x3,%eax
  80140d:	48 85 c0             	test   %rax,%rax
  801410:	75 2f                	jne    801441 <memmove+0x9a>
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	83 e0 03             	and    $0x3,%eax
  801419:	48 85 c0             	test   %rax,%rax
  80141c:	75 23                	jne    801441 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801422:	48 83 e8 04          	sub    $0x4,%rax
  801426:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142a:	48 83 ea 04          	sub    $0x4,%rdx
  80142e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801432:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801436:	48 89 c7             	mov    %rax,%rdi
  801439:	48 89 d6             	mov    %rdx,%rsi
  80143c:	fd                   	std    
  80143d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143f:	eb 1d                	jmp    80145e <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801445:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	48 89 d7             	mov    %rdx,%rdi
  801458:	48 89 c1             	mov    %rax,%rcx
  80145b:	fd                   	std    
  80145c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80145e:	fc                   	cld    
  80145f:	eb 57                	jmp    8014b8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801465:	83 e0 03             	and    $0x3,%eax
  801468:	48 85 c0             	test   %rax,%rax
  80146b:	75 36                	jne    8014a3 <memmove+0xfc>
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 2a                	jne    8014a3 <memmove+0xfc>
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	83 e0 03             	and    $0x3,%eax
  801480:	48 85 c0             	test   %rax,%rax
  801483:	75 1e                	jne    8014a3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801489:	48 c1 e8 02          	shr    $0x2,%rax
  80148d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801494:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801498:	48 89 c7             	mov    %rax,%rdi
  80149b:	48 89 d6             	mov    %rdx,%rsi
  80149e:	fc                   	cld    
  80149f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a1:	eb 15                	jmp    8014b8 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ab:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014af:	48 89 c7             	mov    %rax,%rdi
  8014b2:	48 89 d6             	mov    %rdx,%rsi
  8014b5:	fc                   	cld    
  8014b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014bc:	c9                   	leaveq 
  8014bd:	c3                   	retq   

00000000008014be <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014be:	55                   	push   %rbp
  8014bf:	48 89 e5             	mov    %rsp,%rbp
  8014c2:	48 83 ec 18          	sub    $0x18,%rsp
  8014c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014de:	48 89 ce             	mov    %rcx,%rsi
  8014e1:	48 89 c7             	mov    %rax,%rdi
  8014e4:	48 b8 a7 13 80 00 00 	movabs $0x8013a7,%rax
  8014eb:	00 00 00 
  8014ee:	ff d0                	callq  *%rax
}
  8014f0:	c9                   	leaveq 
  8014f1:	c3                   	retq   

00000000008014f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014f2:	55                   	push   %rbp
  8014f3:	48 89 e5             	mov    %rsp,%rbp
  8014f6:	48 83 ec 28          	sub    $0x28,%rsp
  8014fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801502:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80150e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801512:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801516:	eb 36                	jmp    80154e <memcmp+0x5c>
		if (*s1 != *s2)
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151c:	0f b6 10             	movzbl (%rax),%edx
  80151f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	38 c2                	cmp    %al,%dl
  801528:	74 1a                	je     801544 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80152a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152e:	0f b6 00             	movzbl (%rax),%eax
  801531:	0f b6 d0             	movzbl %al,%edx
  801534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	0f b6 c0             	movzbl %al,%eax
  80153e:	29 c2                	sub    %eax,%edx
  801540:	89 d0                	mov    %edx,%eax
  801542:	eb 20                	jmp    801564 <memcmp+0x72>
		s1++, s2++;
  801544:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801549:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801556:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80155a:	48 85 c0             	test   %rax,%rax
  80155d:	75 b9                	jne    801518 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801564:	c9                   	leaveq 
  801565:	c3                   	retq   

0000000000801566 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801566:	55                   	push   %rbp
  801567:	48 89 e5             	mov    %rsp,%rbp
  80156a:	48 83 ec 28          	sub    $0x28,%rsp
  80156e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801572:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801575:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801581:	48 01 d0             	add    %rdx,%rax
  801584:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801588:	eb 15                	jmp    80159f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80158a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158e:	0f b6 10             	movzbl (%rax),%edx
  801591:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801594:	38 c2                	cmp    %al,%dl
  801596:	75 02                	jne    80159a <memfind+0x34>
			break;
  801598:	eb 0f                	jmp    8015a9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80159a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80159f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015a7:	72 e1                	jb     80158a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 34          	sub    $0x34,%rsp
  8015b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015bf:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015c9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015d0:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d1:	eb 05                	jmp    8015d8 <strtol+0x29>
		s++;
  8015d3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 20                	cmp    $0x20,%al
  8015e1:	74 f0                	je     8015d3 <strtol+0x24>
  8015e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	3c 09                	cmp    $0x9,%al
  8015ec:	74 e5                	je     8015d3 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	3c 2b                	cmp    $0x2b,%al
  8015f7:	75 07                	jne    801600 <strtol+0x51>
		s++;
  8015f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fe:	eb 17                	jmp    801617 <strtol+0x68>
	else if (*s == '-')
  801600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	3c 2d                	cmp    $0x2d,%al
  801609:	75 0c                	jne    801617 <strtol+0x68>
		s++, neg = 1;
  80160b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801610:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801617:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161b:	74 06                	je     801623 <strtol+0x74>
  80161d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801621:	75 28                	jne    80164b <strtol+0x9c>
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	3c 30                	cmp    $0x30,%al
  80162c:	75 1d                	jne    80164b <strtol+0x9c>
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	48 83 c0 01          	add    $0x1,%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3c 78                	cmp    $0x78,%al
  80163b:	75 0e                	jne    80164b <strtol+0x9c>
		s += 2, base = 16;
  80163d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801642:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801649:	eb 2c                	jmp    801677 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80164b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80164f:	75 19                	jne    80166a <strtol+0xbb>
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 30                	cmp    $0x30,%al
  80165a:	75 0e                	jne    80166a <strtol+0xbb>
		s++, base = 8;
  80165c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801661:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801668:	eb 0d                	jmp    801677 <strtol+0xc8>
	else if (base == 0)
  80166a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166e:	75 07                	jne    801677 <strtol+0xc8>
		base = 10;
  801670:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	3c 2f                	cmp    $0x2f,%al
  801680:	7e 1d                	jle    80169f <strtol+0xf0>
  801682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801686:	0f b6 00             	movzbl (%rax),%eax
  801689:	3c 39                	cmp    $0x39,%al
  80168b:	7f 12                	jg     80169f <strtol+0xf0>
			dig = *s - '0';
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	0f be c0             	movsbl %al,%eax
  801697:	83 e8 30             	sub    $0x30,%eax
  80169a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169d:	eb 4e                	jmp    8016ed <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80169f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a3:	0f b6 00             	movzbl (%rax),%eax
  8016a6:	3c 60                	cmp    $0x60,%al
  8016a8:	7e 1d                	jle    8016c7 <strtol+0x118>
  8016aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	3c 7a                	cmp    $0x7a,%al
  8016b3:	7f 12                	jg     8016c7 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	0f be c0             	movsbl %al,%eax
  8016bf:	83 e8 57             	sub    $0x57,%eax
  8016c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c5:	eb 26                	jmp    8016ed <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	3c 40                	cmp    $0x40,%al
  8016d0:	7e 48                	jle    80171a <strtol+0x16b>
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	0f b6 00             	movzbl (%rax),%eax
  8016d9:	3c 5a                	cmp    $0x5a,%al
  8016db:	7f 3d                	jg     80171a <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 37             	sub    $0x37,%eax
  8016ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f0:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016f3:	7c 02                	jl     8016f7 <strtol+0x148>
			break;
  8016f5:	eb 23                	jmp    80171a <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016ff:	48 98                	cltq   
  801701:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801706:	48 89 c2             	mov    %rax,%rdx
  801709:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170c:	48 98                	cltq   
  80170e:	48 01 d0             	add    %rdx,%rax
  801711:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801715:	e9 5d ff ff ff       	jmpq   801677 <strtol+0xc8>

	if (endptr)
  80171a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80171f:	74 0b                	je     80172c <strtol+0x17d>
		*endptr = (char *) s;
  801721:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801725:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801729:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80172c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801730:	74 09                	je     80173b <strtol+0x18c>
  801732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801736:	48 f7 d8             	neg    %rax
  801739:	eb 04                	jmp    80173f <strtol+0x190>
  80173b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <strstr>:

char * strstr(const char *in, const char *str)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 30          	sub    $0x30,%rsp
  801749:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801751:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801755:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801759:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801763:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801767:	75 06                	jne    80176f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	eb 6b                	jmp    8017da <strstr+0x99>

	len = strlen(str);
  80176f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801773:	48 89 c7             	mov    %rax,%rdi
  801776:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
  801782:	48 98                	cltq   
  801784:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801790:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80179a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80179e:	75 07                	jne    8017a7 <strstr+0x66>
				return (char *) 0;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a5:	eb 33                	jmp    8017da <strstr+0x99>
		} while (sc != c);
  8017a7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ab:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017ae:	75 d8                	jne    801788 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	48 89 ce             	mov    %rcx,%rsi
  8017bf:	48 89 c7             	mov    %rax,%rdi
  8017c2:	48 b8 38 12 80 00 00 	movabs $0x801238,%rax
  8017c9:	00 00 00 
  8017cc:	ff d0                	callq  *%rax
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	75 b6                	jne    801788 <strstr+0x47>

	return (char *) (in - 1);
  8017d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d6:	48 83 e8 01          	sub    $0x1,%rax
}
  8017da:	c9                   	leaveq 
  8017db:	c3                   	retq   

00000000008017dc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017dc:	55                   	push   %rbp
  8017dd:	48 89 e5             	mov    %rsp,%rbp
  8017e0:	53                   	push   %rbx
  8017e1:	48 83 ec 48          	sub    $0x48,%rsp
  8017e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017e8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017eb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ef:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017f3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017f7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017fe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801802:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801806:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80180a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80180e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801812:	4c 89 c3             	mov    %r8,%rbx
  801815:	cd 30                	int    $0x30
  801817:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80181b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80181f:	74 3e                	je     80185f <syscall+0x83>
  801821:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801826:	7e 37                	jle    80185f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801828:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80182f:	49 89 d0             	mov    %rdx,%r8
  801832:	89 c1                	mov    %eax,%ecx
  801834:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  80183b:	00 00 00 
  80183e:	be 23 00 00 00       	mov    $0x23,%esi
  801843:	48 bf e5 43 80 00 00 	movabs $0x8043e5,%rdi
  80184a:	00 00 00 
  80184d:	b8 00 00 00 00       	mov    $0x0,%eax
  801852:	49 b9 82 02 80 00 00 	movabs $0x800282,%r9
  801859:	00 00 00 
  80185c:	41 ff d1             	callq  *%r9

	return ret;
  80185f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801863:	48 83 c4 48          	add    $0x48,%rsp
  801867:	5b                   	pop    %rbx
  801868:	5d                   	pop    %rbp
  801869:	c3                   	retq   

000000000080186a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80186a:	55                   	push   %rbp
  80186b:	48 89 e5             	mov    %rsp,%rbp
  80186e:	48 83 ec 20          	sub    $0x20,%rsp
  801872:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801876:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80187a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801882:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801889:	00 
  80188a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801890:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801896:	48 89 d1             	mov    %rdx,%rcx
  801899:	48 89 c2             	mov    %rax,%rdx
  80189c:	be 00 00 00 00       	mov    $0x0,%esi
  8018a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a6:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  8018ad:	00 00 00 
  8018b0:	ff d0                	callq  *%rax
}
  8018b2:	c9                   	leaveq 
  8018b3:	c3                   	retq   

00000000008018b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b4:	55                   	push   %rbp
  8018b5:	48 89 e5             	mov    %rsp,%rbp
  8018b8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c3:	00 
  8018c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018da:	be 00 00 00 00       	mov    $0x0,%esi
  8018df:	bf 01 00 00 00       	mov    $0x1,%edi
  8018e4:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  8018eb:	00 00 00 
  8018ee:	ff d0                	callq  *%rax
}
  8018f0:	c9                   	leaveq 
  8018f1:	c3                   	retq   

00000000008018f2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018f2:	55                   	push   %rbp
  8018f3:	48 89 e5             	mov    %rsp,%rbp
  8018f6:	48 83 ec 10          	sub    $0x10,%rsp
  8018fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801900:	48 98                	cltq   
  801902:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801909:	00 
  80190a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801910:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801916:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191b:	48 89 c2             	mov    %rax,%rdx
  80191e:	be 01 00 00 00       	mov    $0x1,%esi
  801923:	bf 03 00 00 00       	mov    $0x3,%edi
  801928:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  80192f:	00 00 00 
  801932:	ff d0                	callq  *%rax
}
  801934:	c9                   	leaveq 
  801935:	c3                   	retq   

0000000000801936 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801936:	55                   	push   %rbp
  801937:	48 89 e5             	mov    %rsp,%rbp
  80193a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80193e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801945:	00 
  801946:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801952:	b9 00 00 00 00       	mov    $0x0,%ecx
  801957:	ba 00 00 00 00       	mov    $0x0,%edx
  80195c:	be 00 00 00 00       	mov    $0x0,%esi
  801961:	bf 02 00 00 00       	mov    $0x2,%edi
  801966:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  80196d:	00 00 00 
  801970:	ff d0                	callq  *%rax
}
  801972:	c9                   	leaveq 
  801973:	c3                   	retq   

0000000000801974 <sys_yield>:

void
sys_yield(void)
{
  801974:	55                   	push   %rbp
  801975:	48 89 e5             	mov    %rsp,%rbp
  801978:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80197c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801983:	00 
  801984:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801990:	b9 00 00 00 00       	mov    $0x0,%ecx
  801995:	ba 00 00 00 00       	mov    $0x0,%edx
  80199a:	be 00 00 00 00       	mov    $0x0,%esi
  80199f:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019a4:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  8019ab:	00 00 00 
  8019ae:	ff d0                	callq  *%rax
}
  8019b0:	c9                   	leaveq 
  8019b1:	c3                   	retq   

00000000008019b2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019b2:	55                   	push   %rbp
  8019b3:	48 89 e5             	mov    %rsp,%rbp
  8019b6:	48 83 ec 20          	sub    $0x20,%rsp
  8019ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019c1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c7:	48 63 c8             	movslq %eax,%rcx
  8019ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d1:	48 98                	cltq   
  8019d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019da:	00 
  8019db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e1:	49 89 c8             	mov    %rcx,%r8
  8019e4:	48 89 d1             	mov    %rdx,%rcx
  8019e7:	48 89 c2             	mov    %rax,%rdx
  8019ea:	be 01 00 00 00       	mov    $0x1,%esi
  8019ef:	bf 04 00 00 00       	mov    $0x4,%edi
  8019f4:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  8019fb:	00 00 00 
  8019fe:	ff d0                	callq  *%rax
}
  801a00:	c9                   	leaveq 
  801a01:	c3                   	retq   

0000000000801a02 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a02:	55                   	push   %rbp
  801a03:	48 89 e5             	mov    %rsp,%rbp
  801a06:	48 83 ec 30          	sub    $0x30,%rsp
  801a0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a11:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a14:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a18:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a1c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a1f:	48 63 c8             	movslq %eax,%rcx
  801a22:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a29:	48 63 f0             	movslq %eax,%rsi
  801a2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a39:	49 89 f9             	mov    %rdi,%r9
  801a3c:	49 89 f0             	mov    %rsi,%r8
  801a3f:	48 89 d1             	mov    %rdx,%rcx
  801a42:	48 89 c2             	mov    %rax,%rdx
  801a45:	be 01 00 00 00       	mov    $0x1,%esi
  801a4a:	bf 05 00 00 00       	mov    $0x5,%edi
  801a4f:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
}
  801a5b:	c9                   	leaveq 
  801a5c:	c3                   	retq   

0000000000801a5d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a5d:	55                   	push   %rbp
  801a5e:	48 89 e5             	mov    %rsp,%rbp
  801a61:	48 83 ec 20          	sub    $0x20,%rsp
  801a65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a73:	48 98                	cltq   
  801a75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7c:	00 
  801a7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a89:	48 89 d1             	mov    %rdx,%rcx
  801a8c:	48 89 c2             	mov    %rax,%rdx
  801a8f:	be 01 00 00 00       	mov    $0x1,%esi
  801a94:	bf 06 00 00 00       	mov    $0x6,%edi
  801a99:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801aa0:	00 00 00 
  801aa3:	ff d0                	callq  *%rax
}
  801aa5:	c9                   	leaveq 
  801aa6:	c3                   	retq   

0000000000801aa7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
  801aab:	48 83 ec 10          	sub    $0x10,%rsp
  801aaf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab8:	48 63 d0             	movslq %eax,%rdx
  801abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801abe:	48 98                	cltq   
  801ac0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac7:	00 
  801ac8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ace:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad4:	48 89 d1             	mov    %rdx,%rcx
  801ad7:	48 89 c2             	mov    %rax,%rdx
  801ada:	be 01 00 00 00       	mov    $0x1,%esi
  801adf:	bf 08 00 00 00       	mov    $0x8,%edi
  801ae4:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	callq  *%rax
}
  801af0:	c9                   	leaveq 
  801af1:	c3                   	retq   

0000000000801af2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801af2:	55                   	push   %rbp
  801af3:	48 89 e5             	mov    %rsp,%rbp
  801af6:	48 83 ec 20          	sub    $0x20,%rsp
  801afa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801afd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b08:	48 98                	cltq   
  801b0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b11:	00 
  801b12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1e:	48 89 d1             	mov    %rdx,%rcx
  801b21:	48 89 c2             	mov    %rax,%rdx
  801b24:	be 01 00 00 00       	mov    $0x1,%esi
  801b29:	bf 09 00 00 00       	mov    $0x9,%edi
  801b2e:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	callq  *%rax
}
  801b3a:	c9                   	leaveq 
  801b3b:	c3                   	retq   

0000000000801b3c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b3c:	55                   	push   %rbp
  801b3d:	48 89 e5             	mov    %rsp,%rbp
  801b40:	48 83 ec 20          	sub    $0x20,%rsp
  801b44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b52:	48 98                	cltq   
  801b54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5b:	00 
  801b5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b68:	48 89 d1             	mov    %rdx,%rcx
  801b6b:	48 89 c2             	mov    %rax,%rdx
  801b6e:	be 01 00 00 00       	mov    $0x1,%esi
  801b73:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b78:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801b7f:	00 00 00 
  801b82:	ff d0                	callq  *%rax
}
  801b84:	c9                   	leaveq 
  801b85:	c3                   	retq   

0000000000801b86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b86:	55                   	push   %rbp
  801b87:	48 89 e5             	mov    %rsp,%rbp
  801b8a:	48 83 ec 20          	sub    $0x20,%rsp
  801b8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b95:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b99:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b9f:	48 63 f0             	movslq %eax,%rsi
  801ba2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba9:	48 98                	cltq   
  801bab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801baf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb6:	00 
  801bb7:	49 89 f1             	mov    %rsi,%r9
  801bba:	49 89 c8             	mov    %rcx,%r8
  801bbd:	48 89 d1             	mov    %rdx,%rcx
  801bc0:	48 89 c2             	mov    %rax,%rdx
  801bc3:	be 00 00 00 00       	mov    $0x0,%esi
  801bc8:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bcd:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 10          	sub    $0x10,%rsp
  801be3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801beb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf2:	00 
  801bf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c04:	48 89 c2             	mov    %rax,%rdx
  801c07:	be 01 00 00 00       	mov    $0x1,%esi
  801c0c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c11:	48 b8 dc 17 80 00 00 	movabs $0x8017dc,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	callq  *%rax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   

0000000000801c1f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	48 83 ec 30          	sub    $0x30,%rsp
  801c27:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2f:	48 8b 00             	mov    (%rax),%rax
  801c32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c3e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c41:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c44:	83 e0 02             	and    $0x2,%eax
  801c47:	85 c0                	test   %eax,%eax
  801c49:	75 4d                	jne    801c98 <pgfault+0x79>
  801c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4f:	48 c1 e8 0c          	shr    $0xc,%rax
  801c53:	48 89 c2             	mov    %rax,%rdx
  801c56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c5d:	01 00 00 
  801c60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c64:	25 00 08 00 00       	and    $0x800,%eax
  801c69:	48 85 c0             	test   %rax,%rax
  801c6c:	74 2a                	je     801c98 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801c6e:	48 ba f8 43 80 00 00 	movabs $0x8043f8,%rdx
  801c75:	00 00 00 
  801c78:	be 1e 00 00 00       	mov    $0x1e,%esi
  801c7d:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801c84:	00 00 00 
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8c:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801c93:	00 00 00 
  801c96:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801c98:	ba 07 00 00 00       	mov    $0x7,%edx
  801c9d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ca2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca7:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	0f 85 cd 00 00 00    	jne    801d88 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ccd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801cd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cd5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cda:	48 89 c6             	mov    %rax,%rsi
  801cdd:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ce2:	48 b8 a7 13 80 00 00 	movabs $0x8013a7,%rax
  801ce9:	00 00 00 
  801cec:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cf2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cf8:	48 89 c1             	mov    %rax,%rcx
  801cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801d00:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d05:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  801d11:	00 00 00 
  801d14:	ff d0                	callq  *%rax
  801d16:	85 c0                	test   %eax,%eax
  801d18:	79 2a                	jns    801d44 <pgfault+0x125>
				panic("Page map at temp address failed");
  801d1a:	48 ba 28 44 80 00 00 	movabs $0x804428,%rdx
  801d21:	00 00 00 
  801d24:	be 2f 00 00 00       	mov    $0x2f,%esi
  801d29:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801d30:	00 00 00 
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
  801d38:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801d3f:	00 00 00 
  801d42:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d44:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d49:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4e:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	callq  *%rax
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	79 54                	jns    801db2 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d5e:	48 ba 48 44 80 00 00 	movabs $0x804448,%rdx
  801d65:	00 00 00 
  801d68:	be 31 00 00 00       	mov    $0x31,%esi
  801d6d:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801d74:	00 00 00 
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7c:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801d83:	00 00 00 
  801d86:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801d88:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  801d8f:	00 00 00 
  801d92:	be 35 00 00 00       	mov    $0x35,%esi
  801d97:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801d9e:	00 00 00 
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801dad:	00 00 00 
  801db0:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801db2:	c9                   	leaveq 
  801db3:	c3                   	retq   

0000000000801db4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801db4:	55                   	push   %rbp
  801db5:	48 89 e5             	mov    %rsp,%rbp
  801db8:	48 83 ec 20          	sub    $0x20,%rsp
  801dbc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dbf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801dc2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dc9:	01 00 00 
  801dcc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801dcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd3:	25 07 0e 00 00       	and    $0xe07,%eax
  801dd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801ddb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801dde:	48 c1 e0 0c          	shl    $0xc,%rax
  801de2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de9:	25 00 04 00 00       	and    $0x400,%eax
  801dee:	85 c0                	test   %eax,%eax
  801df0:	74 57                	je     801e49 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801df2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801df5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801df9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e00:	41 89 f0             	mov    %esi,%r8d
  801e03:	48 89 c6             	mov    %rax,%rsi
  801e06:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0b:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  801e12:	00 00 00 
  801e15:	ff d0                	callq  *%rax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	0f 8e 52 01 00 00    	jle    801f71 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801e1f:	48 ba 9d 44 80 00 00 	movabs $0x80449d,%rdx
  801e26:	00 00 00 
  801e29:	be 52 00 00 00       	mov    $0x52,%esi
  801e2e:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801e35:	00 00 00 
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801e44:	00 00 00 
  801e47:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4c:	83 e0 02             	and    $0x2,%eax
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	75 10                	jne    801e63 <duppage+0xaf>
  801e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e56:	25 00 08 00 00       	and    $0x800,%eax
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	0f 84 bb 00 00 00    	je     801f1e <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e66:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e6b:	80 cc 08             	or     $0x8,%ah
  801e6e:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e71:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e74:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e78:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7f:	41 89 f0             	mov    %esi,%r8d
  801e82:	48 89 c6             	mov    %rax,%rsi
  801e85:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8a:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  801e91:	00 00 00 
  801e94:	ff d0                	callq  *%rax
  801e96:	85 c0                	test   %eax,%eax
  801e98:	7e 2a                	jle    801ec4 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801e9a:	48 ba 9d 44 80 00 00 	movabs $0x80449d,%rdx
  801ea1:	00 00 00 
  801ea4:	be 5a 00 00 00       	mov    $0x5a,%esi
  801ea9:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801eb0:	00 00 00 
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb8:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801ebf:	00 00 00 
  801ec2:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ec4:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801ec7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ecf:	41 89 c8             	mov    %ecx,%r8d
  801ed2:	48 89 d1             	mov    %rdx,%rcx
  801ed5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eda:	48 89 c6             	mov    %rax,%rsi
  801edd:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee2:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	callq  *%rax
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	7e 2a                	jle    801f1c <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801ef2:	48 ba 9d 44 80 00 00 	movabs $0x80449d,%rdx
  801ef9:	00 00 00 
  801efc:	be 5d 00 00 00       	mov    $0x5d,%esi
  801f01:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801f08:	00 00 00 
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f10:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801f17:	00 00 00 
  801f1a:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f1c:	eb 53                	jmp    801f71 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f1e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f21:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f25:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2c:	41 89 f0             	mov    %esi,%r8d
  801f2f:	48 89 c6             	mov    %rax,%rsi
  801f32:	bf 00 00 00 00       	mov    $0x0,%edi
  801f37:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  801f3e:	00 00 00 
  801f41:	ff d0                	callq  *%rax
  801f43:	85 c0                	test   %eax,%eax
  801f45:	7e 2a                	jle    801f71 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801f47:	48 ba 9d 44 80 00 00 	movabs $0x80449d,%rdx
  801f4e:	00 00 00 
  801f51:	be 61 00 00 00       	mov    $0x61,%esi
  801f56:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801f5d:	00 00 00 
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  801f6c:	00 00 00 
  801f6f:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f76:	c9                   	leaveq 
  801f77:	c3                   	retq   

0000000000801f78 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f78:	55                   	push   %rbp
  801f79:	48 89 e5             	mov    %rsp,%rbp
  801f7c:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801f80:	48 bf 1f 1c 80 00 00 	movabs $0x801c1f,%rdi
  801f87:	00 00 00 
  801f8a:	48 b8 c9 3c 80 00 00 	movabs $0x803cc9,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f96:	b8 07 00 00 00       	mov    $0x7,%eax
  801f9b:	cd 30                	int    $0x30
  801f9d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801fa0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801fa3:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801faa:	79 30                	jns    801fdc <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801fac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801faf:	89 c1                	mov    %eax,%ecx
  801fb1:	48 ba bb 44 80 00 00 	movabs $0x8044bb,%rdx
  801fb8:	00 00 00 
  801fbb:	be 89 00 00 00       	mov    $0x89,%esi
  801fc0:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801fc7:	00 00 00 
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
  801fd6:	00 00 00 
  801fd9:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fe0:	75 46                	jne    802028 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801fe2:	48 b8 36 19 80 00 00 	movabs $0x801936,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
  801fee:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ff3:	48 63 d0             	movslq %eax,%rdx
  801ff6:	48 89 d0             	mov    %rdx,%rax
  801ff9:	48 c1 e0 03          	shl    $0x3,%rax
  801ffd:	48 01 d0             	add    %rdx,%rax
  802000:	48 c1 e0 05          	shl    $0x5,%rax
  802004:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80200b:	00 00 00 
  80200e:	48 01 c2             	add    %rax,%rdx
  802011:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802018:	00 00 00 
  80201b:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	e9 d1 01 00 00       	jmpq   8021f9 <fork+0x281>
	}

	uint64_t ad = 0;
  802028:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80202f:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802030:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802035:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802039:	e9 df 00 00 00       	jmpq   80211d <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80203e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802042:	48 c1 e8 27          	shr    $0x27,%rax
  802046:	48 89 c2             	mov    %rax,%rdx
  802049:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802050:	01 00 00 
  802053:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802057:	83 e0 01             	and    $0x1,%eax
  80205a:	48 85 c0             	test   %rax,%rax
  80205d:	0f 84 9e 00 00 00    	je     802101 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802067:	48 c1 e8 1e          	shr    $0x1e,%rax
  80206b:	48 89 c2             	mov    %rax,%rdx
  80206e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802075:	01 00 00 
  802078:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80207c:	83 e0 01             	and    $0x1,%eax
  80207f:	48 85 c0             	test   %rax,%rax
  802082:	74 73                	je     8020f7 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802088:	48 c1 e8 15          	shr    $0x15,%rax
  80208c:	48 89 c2             	mov    %rax,%rdx
  80208f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802096:	01 00 00 
  802099:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80209d:	83 e0 01             	and    $0x1,%eax
  8020a0:	48 85 c0             	test   %rax,%rax
  8020a3:	74 48                	je     8020ed <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8020a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8020ad:	48 89 c2             	mov    %rax,%rdx
  8020b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020b7:	01 00 00 
  8020ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c6:	83 e0 01             	and    $0x1,%eax
  8020c9:	48 85 c0             	test   %rax,%rax
  8020cc:	74 47                	je     802115 <fork+0x19d>
						duppage(envid, VPN(addr));
  8020ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d2:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d6:	89 c2                	mov    %eax,%edx
  8020d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020db:	89 d6                	mov    %edx,%esi
  8020dd:	89 c7                	mov    %eax,%edi
  8020df:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	callq  *%rax
  8020eb:	eb 28                	jmp    802115 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  8020ed:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8020f4:	00 
  8020f5:	eb 1e                	jmp    802115 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020f7:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020fe:	40 
  8020ff:	eb 14                	jmp    802115 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802105:	48 c1 e8 27          	shr    $0x27,%rax
  802109:	48 83 c0 01          	add    $0x1,%rax
  80210d:	48 c1 e0 27          	shl    $0x27,%rax
  802111:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802115:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80211c:	00 
  80211d:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802124:	00 
  802125:	0f 87 13 ff ff ff    	ja     80203e <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80212b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80212e:	ba 07 00 00 00       	mov    $0x7,%edx
  802133:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802138:	89 c7                	mov    %eax,%edi
  80213a:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  802141:	00 00 00 
  802144:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802146:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802149:	ba 07 00 00 00       	mov    $0x7,%edx
  80214e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802153:	89 c7                	mov    %eax,%edi
  802155:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  80215c:	00 00 00 
  80215f:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802161:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802164:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80216a:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80216f:	ba 00 00 00 00       	mov    $0x0,%edx
  802174:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802179:	89 c7                	mov    %eax,%edi
  80217b:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  802182:	00 00 00 
  802185:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802187:	ba 00 10 00 00       	mov    $0x1000,%edx
  80218c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802191:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802196:	48 b8 a7 13 80 00 00 	movabs $0x8013a7,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8021a2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ac:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8021b8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021bf:	00 00 00 
  8021c2:	48 8b 00             	mov    (%rax),%rax
  8021c5:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8021cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021cf:	48 89 d6             	mov    %rdx,%rsi
  8021d2:	89 c7                	mov    %eax,%edi
  8021d4:	48 b8 3c 1b 80 00 00 	movabs $0x801b3c,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  8021e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021e3:	be 02 00 00 00       	mov    $0x2,%esi
  8021e8:	89 c7                	mov    %eax,%edi
  8021ea:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax

	return envid;
  8021f6:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8021f9:	c9                   	leaveq 
  8021fa:	c3                   	retq   

00000000008021fb <sfork>:

// Challenge!
int
sfork(void)
{
  8021fb:	55                   	push   %rbp
  8021fc:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021ff:	48 ba d3 44 80 00 00 	movabs $0x8044d3,%rdx
  802206:	00 00 00 
  802209:	be b8 00 00 00       	mov    $0xb8,%esi
  80220e:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  802215:	00 00 00 
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
  80221d:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  802224:	00 00 00 
  802227:	ff d1                	callq  *%rcx

0000000000802229 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802229:	55                   	push   %rbp
  80222a:	48 89 e5             	mov    %rsp,%rbp
  80222d:	48 83 ec 30          	sub    $0x30,%rsp
  802231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802239:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80223d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802242:	75 0e                	jne    802252 <ipc_recv+0x29>
        pg = (void *)UTOP;
  802244:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80224b:	00 00 00 
  80224e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  802252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802256:	48 89 c7             	mov    %rax,%rdi
  802259:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  802260:	00 00 00 
  802263:	ff d0                	callq  *%rax
  802265:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802268:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226c:	79 27                	jns    802295 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80226e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802273:	74 0a                	je     80227f <ipc_recv+0x56>
            *from_env_store = 0;
  802275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802279:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80227f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802284:	74 0a                	je     802290 <ipc_recv+0x67>
            *perm_store = 0;
  802286:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  802290:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802293:	eb 53                	jmp    8022e8 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  802295:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80229a:	74 19                	je     8022b5 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80229c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022a3:	00 00 00 
  8022a6:	48 8b 00             	mov    (%rax),%rax
  8022a9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8022af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b3:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8022b5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022ba:	74 19                	je     8022d5 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8022bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022c3:	00 00 00 
  8022c6:	48 8b 00             	mov    (%rax),%rax
  8022c9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8022cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d3:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8022d5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022dc:	00 00 00 
  8022df:	48 8b 00             	mov    (%rax),%rax
  8022e2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8022e8:	c9                   	leaveq 
  8022e9:	c3                   	retq   

00000000008022ea <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022ea:	55                   	push   %rbp
  8022eb:	48 89 e5             	mov    %rsp,%rbp
  8022ee:	48 83 ec 30          	sub    $0x30,%rsp
  8022f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022f8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022fc:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8022ff:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802304:	75 0e                	jne    802314 <ipc_send+0x2a>
        pg = (void *)UTOP;
  802306:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80230d:	00 00 00 
  802310:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  802314:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802317:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80231a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80231e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802321:	89 c7                	mov    %eax,%edi
  802323:	48 b8 86 1b 80 00 00 	movabs $0x801b86,%rax
  80232a:	00 00 00 
  80232d:	ff d0                	callq  *%rax
  80232f:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  802332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802336:	79 36                	jns    80236e <ipc_send+0x84>
  802338:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80233c:	74 30                	je     80236e <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80233e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802341:	89 c1                	mov    %eax,%ecx
  802343:	48 ba e9 44 80 00 00 	movabs $0x8044e9,%rdx
  80234a:	00 00 00 
  80234d:	be 49 00 00 00       	mov    $0x49,%esi
  802352:	48 bf f6 44 80 00 00 	movabs $0x8044f6,%rdi
  802359:	00 00 00 
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
  802368:	00 00 00 
  80236b:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80236e:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  802375:	00 00 00 
  802378:	ff d0                	callq  *%rax
    } while(r != 0);
  80237a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237e:	75 94                	jne    802314 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  802380:	c9                   	leaveq 
  802381:	c3                   	retq   

0000000000802382 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802382:	55                   	push   %rbp
  802383:	48 89 e5             	mov    %rsp,%rbp
  802386:	48 83 ec 14          	sub    $0x14,%rsp
  80238a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80238d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802394:	eb 5e                	jmp    8023f4 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802396:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80239d:	00 00 00 
  8023a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a3:	48 63 d0             	movslq %eax,%rdx
  8023a6:	48 89 d0             	mov    %rdx,%rax
  8023a9:	48 c1 e0 03          	shl    $0x3,%rax
  8023ad:	48 01 d0             	add    %rdx,%rax
  8023b0:	48 c1 e0 05          	shl    $0x5,%rax
  8023b4:	48 01 c8             	add    %rcx,%rax
  8023b7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8023bd:	8b 00                	mov    (%rax),%eax
  8023bf:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023c2:	75 2c                	jne    8023f0 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8023c4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023cb:	00 00 00 
  8023ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d1:	48 63 d0             	movslq %eax,%rdx
  8023d4:	48 89 d0             	mov    %rdx,%rax
  8023d7:	48 c1 e0 03          	shl    $0x3,%rax
  8023db:	48 01 d0             	add    %rdx,%rax
  8023de:	48 c1 e0 05          	shl    $0x5,%rax
  8023e2:	48 01 c8             	add    %rcx,%rax
  8023e5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8023eb:	8b 40 08             	mov    0x8(%rax),%eax
  8023ee:	eb 12                	jmp    802402 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8023f0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023f4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8023fb:	7e 99                	jle    802396 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802402:	c9                   	leaveq 
  802403:	c3                   	retq   

0000000000802404 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802404:	55                   	push   %rbp
  802405:	48 89 e5             	mov    %rsp,%rbp
  802408:	48 83 ec 08          	sub    $0x8,%rsp
  80240c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802410:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802414:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80241b:	ff ff ff 
  80241e:	48 01 d0             	add    %rdx,%rax
  802421:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802425:	c9                   	leaveq 
  802426:	c3                   	retq   

0000000000802427 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802427:	55                   	push   %rbp
  802428:	48 89 e5             	mov    %rsp,%rbp
  80242b:	48 83 ec 08          	sub    $0x8,%rsp
  80242f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802437:	48 89 c7             	mov    %rax,%rdi
  80243a:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802441:	00 00 00 
  802444:	ff d0                	callq  *%rax
  802446:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80244c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802450:	c9                   	leaveq 
  802451:	c3                   	retq   

0000000000802452 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802452:	55                   	push   %rbp
  802453:	48 89 e5             	mov    %rsp,%rbp
  802456:	48 83 ec 18          	sub    $0x18,%rsp
  80245a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80245e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802465:	eb 6b                	jmp    8024d2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246a:	48 98                	cltq   
  80246c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802472:	48 c1 e0 0c          	shl    $0xc,%rax
  802476:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80247a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247e:	48 c1 e8 15          	shr    $0x15,%rax
  802482:	48 89 c2             	mov    %rax,%rdx
  802485:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80248c:	01 00 00 
  80248f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802493:	83 e0 01             	and    $0x1,%eax
  802496:	48 85 c0             	test   %rax,%rax
  802499:	74 21                	je     8024bc <fd_alloc+0x6a>
  80249b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249f:	48 c1 e8 0c          	shr    $0xc,%rax
  8024a3:	48 89 c2             	mov    %rax,%rdx
  8024a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ad:	01 00 00 
  8024b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b4:	83 e0 01             	and    $0x1,%eax
  8024b7:	48 85 c0             	test   %rax,%rax
  8024ba:	75 12                	jne    8024ce <fd_alloc+0x7c>
			*fd_store = fd;
  8024bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cc:	eb 1a                	jmp    8024e8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024d2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024d6:	7e 8f                	jle    802467 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8024d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024dc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024e3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024e8:	c9                   	leaveq 
  8024e9:	c3                   	retq   

00000000008024ea <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024ea:	55                   	push   %rbp
  8024eb:	48 89 e5             	mov    %rsp,%rbp
  8024ee:	48 83 ec 20          	sub    $0x20,%rsp
  8024f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024fd:	78 06                	js     802505 <fd_lookup+0x1b>
  8024ff:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802503:	7e 07                	jle    80250c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80250a:	eb 6c                	jmp    802578 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80250c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250f:	48 98                	cltq   
  802511:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802517:	48 c1 e0 0c          	shl    $0xc,%rax
  80251b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80251f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802523:	48 c1 e8 15          	shr    $0x15,%rax
  802527:	48 89 c2             	mov    %rax,%rdx
  80252a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802531:	01 00 00 
  802534:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802538:	83 e0 01             	and    $0x1,%eax
  80253b:	48 85 c0             	test   %rax,%rax
  80253e:	74 21                	je     802561 <fd_lookup+0x77>
  802540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802544:	48 c1 e8 0c          	shr    $0xc,%rax
  802548:	48 89 c2             	mov    %rax,%rdx
  80254b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802552:	01 00 00 
  802555:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802559:	83 e0 01             	and    $0x1,%eax
  80255c:	48 85 c0             	test   %rax,%rax
  80255f:	75 07                	jne    802568 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802561:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802566:	eb 10                	jmp    802578 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802570:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802578:	c9                   	leaveq 
  802579:	c3                   	retq   

000000000080257a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80257a:	55                   	push   %rbp
  80257b:	48 89 e5             	mov    %rsp,%rbp
  80257e:	48 83 ec 30          	sub    $0x30,%rsp
  802582:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802586:	89 f0                	mov    %esi,%eax
  802588:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80258b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258f:	48 89 c7             	mov    %rax,%rdi
  802592:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802599:	00 00 00 
  80259c:	ff d0                	callq  *%rax
  80259e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a2:	48 89 d6             	mov    %rdx,%rsi
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax
  8025b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ba:	78 0a                	js     8025c6 <fd_close+0x4c>
	    || fd != fd2)
  8025bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025c4:	74 12                	je     8025d8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025c6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025ca:	74 05                	je     8025d1 <fd_close+0x57>
  8025cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025cf:	eb 05                	jmp    8025d6 <fd_close+0x5c>
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d6:	eb 69                	jmp    802641 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025dc:	8b 00                	mov    (%rax),%eax
  8025de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025e2:	48 89 d6             	mov    %rdx,%rsi
  8025e5:	89 c7                	mov    %eax,%edi
  8025e7:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8025ee:	00 00 00 
  8025f1:	ff d0                	callq  *%rax
  8025f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fa:	78 2a                	js     802626 <fd_close+0xac>
		if (dev->dev_close)
  8025fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802600:	48 8b 40 20          	mov    0x20(%rax),%rax
  802604:	48 85 c0             	test   %rax,%rax
  802607:	74 16                	je     80261f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802611:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802615:	48 89 d7             	mov    %rdx,%rdi
  802618:	ff d0                	callq  *%rax
  80261a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261d:	eb 07                	jmp    802626 <fd_close+0xac>
		else
			r = 0;
  80261f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80262a:	48 89 c6             	mov    %rax,%rsi
  80262d:	bf 00 00 00 00       	mov    $0x0,%edi
  802632:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
	return r;
  80263e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802641:	c9                   	leaveq 
  802642:	c3                   	retq   

0000000000802643 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802643:	55                   	push   %rbp
  802644:	48 89 e5             	mov    %rsp,%rbp
  802647:	48 83 ec 20          	sub    $0x20,%rsp
  80264b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80264e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802652:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802659:	eb 41                	jmp    80269c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80265b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802662:	00 00 00 
  802665:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802668:	48 63 d2             	movslq %edx,%rdx
  80266b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266f:	8b 00                	mov    (%rax),%eax
  802671:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802674:	75 22                	jne    802698 <dev_lookup+0x55>
			*dev = devtab[i];
  802676:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80267d:	00 00 00 
  802680:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802683:	48 63 d2             	movslq %edx,%rdx
  802686:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80268a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
  802696:	eb 60                	jmp    8026f8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802698:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80269c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026a3:	00 00 00 
  8026a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026a9:	48 63 d2             	movslq %edx,%rdx
  8026ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b0:	48 85 c0             	test   %rax,%rax
  8026b3:	75 a6                	jne    80265b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026bc:	00 00 00 
  8026bf:	48 8b 00             	mov    (%rax),%rax
  8026c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026cb:	89 c6                	mov    %eax,%esi
  8026cd:	48 bf 00 45 80 00 00 	movabs $0x804500,%rdi
  8026d4:	00 00 00 
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dc:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  8026e3:	00 00 00 
  8026e6:	ff d1                	callq  *%rcx
	*dev = 0;
  8026e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026f8:	c9                   	leaveq 
  8026f9:	c3                   	retq   

00000000008026fa <close>:

int
close(int fdnum)
{
  8026fa:	55                   	push   %rbp
  8026fb:	48 89 e5             	mov    %rsp,%rbp
  8026fe:	48 83 ec 20          	sub    $0x20,%rsp
  802702:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802705:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802709:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80270c:	48 89 d6             	mov    %rdx,%rsi
  80270f:	89 c7                	mov    %eax,%edi
  802711:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802718:	00 00 00 
  80271b:	ff d0                	callq  *%rax
  80271d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802720:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802724:	79 05                	jns    80272b <close+0x31>
		return r;
  802726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802729:	eb 18                	jmp    802743 <close+0x49>
	else
		return fd_close(fd, 1);
  80272b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272f:	be 01 00 00 00       	mov    $0x1,%esi
  802734:	48 89 c7             	mov    %rax,%rdi
  802737:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
}
  802743:	c9                   	leaveq 
  802744:	c3                   	retq   

0000000000802745 <close_all>:

void
close_all(void)
{
  802745:	55                   	push   %rbp
  802746:	48 89 e5             	mov    %rsp,%rbp
  802749:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80274d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802754:	eb 15                	jmp    80276b <close_all+0x26>
		close(i);
  802756:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802759:	89 c7                	mov    %eax,%edi
  80275b:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802767:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80276b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80276f:	7e e5                	jle    802756 <close_all+0x11>
		close(i);
}
  802771:	c9                   	leaveq 
  802772:	c3                   	retq   

0000000000802773 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802773:	55                   	push   %rbp
  802774:	48 89 e5             	mov    %rsp,%rbp
  802777:	48 83 ec 40          	sub    $0x40,%rsp
  80277b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80277e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802781:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802785:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802788:	48 89 d6             	mov    %rdx,%rsi
  80278b:	89 c7                	mov    %eax,%edi
  80278d:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
  802799:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a0:	79 08                	jns    8027aa <dup+0x37>
		return r;
  8027a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a5:	e9 70 01 00 00       	jmpq   80291a <dup+0x1a7>
	close(newfdnum);
  8027aa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027ad:	89 c7                	mov    %eax,%edi
  8027af:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  8027b6:	00 00 00 
  8027b9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027bb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027be:	48 98                	cltq   
  8027c0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027c6:	48 c1 e0 0c          	shl    $0xc,%rax
  8027ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d2:	48 89 c7             	mov    %rax,%rdi
  8027d5:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e9:	48 89 c7             	mov    %rax,%rdi
  8027ec:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
  8027f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802800:	48 c1 e8 15          	shr    $0x15,%rax
  802804:	48 89 c2             	mov    %rax,%rdx
  802807:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80280e:	01 00 00 
  802811:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802815:	83 e0 01             	and    $0x1,%eax
  802818:	48 85 c0             	test   %rax,%rax
  80281b:	74 73                	je     802890 <dup+0x11d>
  80281d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802821:	48 c1 e8 0c          	shr    $0xc,%rax
  802825:	48 89 c2             	mov    %rax,%rdx
  802828:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80282f:	01 00 00 
  802832:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802836:	83 e0 01             	and    $0x1,%eax
  802839:	48 85 c0             	test   %rax,%rax
  80283c:	74 52                	je     802890 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80283e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802842:	48 c1 e8 0c          	shr    $0xc,%rax
  802846:	48 89 c2             	mov    %rax,%rdx
  802849:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802850:	01 00 00 
  802853:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802857:	25 07 0e 00 00       	and    $0xe07,%eax
  80285c:	89 c1                	mov    %eax,%ecx
  80285e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802866:	41 89 c8             	mov    %ecx,%r8d
  802869:	48 89 d1             	mov    %rdx,%rcx
  80286c:	ba 00 00 00 00       	mov    $0x0,%edx
  802871:	48 89 c6             	mov    %rax,%rsi
  802874:	bf 00 00 00 00       	mov    $0x0,%edi
  802879:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
  802885:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802888:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288c:	79 02                	jns    802890 <dup+0x11d>
			goto err;
  80288e:	eb 57                	jmp    8028e7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802894:	48 c1 e8 0c          	shr    $0xc,%rax
  802898:	48 89 c2             	mov    %rax,%rdx
  80289b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028a2:	01 00 00 
  8028a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8028ae:	89 c1                	mov    %eax,%ecx
  8028b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b8:	41 89 c8             	mov    %ecx,%r8d
  8028bb:	48 89 d1             	mov    %rdx,%rcx
  8028be:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c3:	48 89 c6             	mov    %rax,%rsi
  8028c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028cb:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
  8028d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028de:	79 02                	jns    8028e2 <dup+0x16f>
		goto err;
  8028e0:	eb 05                	jmp    8028e7 <dup+0x174>

	return newfdnum;
  8028e2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028e5:	eb 33                	jmp    80291a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028eb:	48 89 c6             	mov    %rax,%rsi
  8028ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f3:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802903:	48 89 c6             	mov    %rax,%rsi
  802906:	bf 00 00 00 00       	mov    $0x0,%edi
  80290b:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  802912:	00 00 00 
  802915:	ff d0                	callq  *%rax
	return r;
  802917:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80291a:	c9                   	leaveq 
  80291b:	c3                   	retq   

000000000080291c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80291c:	55                   	push   %rbp
  80291d:	48 89 e5             	mov    %rsp,%rbp
  802920:	48 83 ec 40          	sub    $0x40,%rsp
  802924:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802927:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80292b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80292f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802933:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802936:	48 89 d6             	mov    %rdx,%rsi
  802939:	89 c7                	mov    %eax,%edi
  80293b:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
  802947:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294e:	78 24                	js     802974 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	8b 00                	mov    (%rax),%eax
  802956:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80295a:	48 89 d6             	mov    %rdx,%rsi
  80295d:	89 c7                	mov    %eax,%edi
  80295f:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
  80296b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802972:	79 05                	jns    802979 <read+0x5d>
		return r;
  802974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802977:	eb 76                	jmp    8029ef <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297d:	8b 40 08             	mov    0x8(%rax),%eax
  802980:	83 e0 03             	and    $0x3,%eax
  802983:	83 f8 01             	cmp    $0x1,%eax
  802986:	75 3a                	jne    8029c2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802988:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80298f:	00 00 00 
  802992:	48 8b 00             	mov    (%rax),%rax
  802995:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80299b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80299e:	89 c6                	mov    %eax,%esi
  8029a0:	48 bf 1f 45 80 00 00 	movabs $0x80451f,%rdi
  8029a7:	00 00 00 
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  8029b6:	00 00 00 
  8029b9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c0:	eb 2d                	jmp    8029ef <read+0xd3>
	}
	if (!dev->dev_read)
  8029c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029ca:	48 85 c0             	test   %rax,%rax
  8029cd:	75 07                	jne    8029d6 <read+0xba>
		return -E_NOT_SUPP;
  8029cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029d4:	eb 19                	jmp    8029ef <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029da:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029e6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029ea:	48 89 cf             	mov    %rcx,%rdi
  8029ed:	ff d0                	callq  *%rax
}
  8029ef:	c9                   	leaveq 
  8029f0:	c3                   	retq   

00000000008029f1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029f1:	55                   	push   %rbp
  8029f2:	48 89 e5             	mov    %rsp,%rbp
  8029f5:	48 83 ec 30          	sub    $0x30,%rsp
  8029f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a0b:	eb 49                	jmp    802a56 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a10:	48 98                	cltq   
  802a12:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a16:	48 29 c2             	sub    %rax,%rdx
  802a19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1c:	48 63 c8             	movslq %eax,%rcx
  802a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a23:	48 01 c1             	add    %rax,%rcx
  802a26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a29:	48 89 ce             	mov    %rcx,%rsi
  802a2c:	89 c7                	mov    %eax,%edi
  802a2e:	48 b8 1c 29 80 00 00 	movabs $0x80291c,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
  802a3a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a41:	79 05                	jns    802a48 <readn+0x57>
			return m;
  802a43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a46:	eb 1c                	jmp    802a64 <readn+0x73>
		if (m == 0)
  802a48:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a4c:	75 02                	jne    802a50 <readn+0x5f>
			break;
  802a4e:	eb 11                	jmp    802a61 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a53:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a59:	48 98                	cltq   
  802a5b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a5f:	72 ac                	jb     802a0d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a64:	c9                   	leaveq 
  802a65:	c3                   	retq   

0000000000802a66 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a66:	55                   	push   %rbp
  802a67:	48 89 e5             	mov    %rsp,%rbp
  802a6a:	48 83 ec 40          	sub    $0x40,%rsp
  802a6e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a71:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a75:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a79:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a80:	48 89 d6             	mov    %rdx,%rsi
  802a83:	89 c7                	mov    %eax,%edi
  802a85:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802a8c:	00 00 00 
  802a8f:	ff d0                	callq  *%rax
  802a91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a98:	78 24                	js     802abe <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9e:	8b 00                	mov    (%rax),%eax
  802aa0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa4:	48 89 d6             	mov    %rdx,%rsi
  802aa7:	89 c7                	mov    %eax,%edi
  802aa9:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
  802ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abc:	79 05                	jns    802ac3 <write+0x5d>
		return r;
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	eb 75                	jmp    802b38 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac7:	8b 40 08             	mov    0x8(%rax),%eax
  802aca:	83 e0 03             	and    $0x3,%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	75 3a                	jne    802b0b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ad1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ad8:	00 00 00 
  802adb:	48 8b 00             	mov    (%rax),%rax
  802ade:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ae4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ae7:	89 c6                	mov    %eax,%esi
  802ae9:	48 bf 3b 45 80 00 00 	movabs $0x80453b,%rdi
  802af0:	00 00 00 
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  802aff:	00 00 00 
  802b02:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b09:	eb 2d                	jmp    802b38 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b13:	48 85 c0             	test   %rax,%rax
  802b16:	75 07                	jne    802b1f <write+0xb9>
		return -E_NOT_SUPP;
  802b18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1d:	eb 19                	jmp    802b38 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b23:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b27:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b2f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b33:	48 89 cf             	mov    %rcx,%rdi
  802b36:	ff d0                	callq  *%rax
}
  802b38:	c9                   	leaveq 
  802b39:	c3                   	retq   

0000000000802b3a <seek>:

int
seek(int fdnum, off_t offset)
{
  802b3a:	55                   	push   %rbp
  802b3b:	48 89 e5             	mov    %rsp,%rbp
  802b3e:	48 83 ec 18          	sub    $0x18,%rsp
  802b42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b45:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b4f:	48 89 d6             	mov    %rdx,%rsi
  802b52:	89 c7                	mov    %eax,%edi
  802b54:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	callq  *%rax
  802b60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b67:	79 05                	jns    802b6e <seek+0x34>
		return r;
  802b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6c:	eb 0f                	jmp    802b7d <seek+0x43>
	fd->fd_offset = offset;
  802b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b72:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b75:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b7d:	c9                   	leaveq 
  802b7e:	c3                   	retq   

0000000000802b7f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b7f:	55                   	push   %rbp
  802b80:	48 89 e5             	mov    %rsp,%rbp
  802b83:	48 83 ec 30          	sub    $0x30,%rsp
  802b87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b8a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b8d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b91:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b94:	48 89 d6             	mov    %rdx,%rsi
  802b97:	89 c7                	mov    %eax,%edi
  802b99:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
  802ba5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bac:	78 24                	js     802bd2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb2:	8b 00                	mov    (%rax),%eax
  802bb4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb8:	48 89 d6             	mov    %rdx,%rsi
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd0:	79 05                	jns    802bd7 <ftruncate+0x58>
		return r;
  802bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd5:	eb 72                	jmp    802c49 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdb:	8b 40 08             	mov    0x8(%rax),%eax
  802bde:	83 e0 03             	and    $0x3,%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	75 3a                	jne    802c1f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802be5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bec:	00 00 00 
  802bef:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802bf2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bf8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bfb:	89 c6                	mov    %eax,%esi
  802bfd:	48 bf 58 45 80 00 00 	movabs $0x804558,%rdi
  802c04:	00 00 00 
  802c07:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0c:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  802c13:	00 00 00 
  802c16:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c1d:	eb 2a                	jmp    802c49 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c23:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c27:	48 85 c0             	test   %rax,%rax
  802c2a:	75 07                	jne    802c33 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c31:	eb 16                	jmp    802c49 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c37:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c3f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c42:	89 ce                	mov    %ecx,%esi
  802c44:	48 89 d7             	mov    %rdx,%rdi
  802c47:	ff d0                	callq  *%rax
}
  802c49:	c9                   	leaveq 
  802c4a:	c3                   	retq   

0000000000802c4b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c4b:	55                   	push   %rbp
  802c4c:	48 89 e5             	mov    %rsp,%rbp
  802c4f:	48 83 ec 30          	sub    $0x30,%rsp
  802c53:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c56:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c5a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c61:	48 89 d6             	mov    %rdx,%rsi
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c79:	78 24                	js     802c9f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7f:	8b 00                	mov    (%rax),%eax
  802c81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c85:	48 89 d6             	mov    %rdx,%rsi
  802c88:	89 c7                	mov    %eax,%edi
  802c8a:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802c91:	00 00 00 
  802c94:	ff d0                	callq  *%rax
  802c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9d:	79 05                	jns    802ca4 <fstat+0x59>
		return r;
  802c9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca2:	eb 5e                	jmp    802d02 <fstat+0xb7>
	if (!dev->dev_stat)
  802ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cac:	48 85 c0             	test   %rax,%rax
  802caf:	75 07                	jne    802cb8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cb1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb6:	eb 4a                	jmp    802d02 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cbc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cca:	00 00 00 
	stat->st_isdir = 0;
  802ccd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cd1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802cd8:	00 00 00 
	stat->st_dev = dev;
  802cdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cee:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cf2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cf6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cfa:	48 89 ce             	mov    %rcx,%rsi
  802cfd:	48 89 d7             	mov    %rdx,%rdi
  802d00:	ff d0                	callq  *%rax
}
  802d02:	c9                   	leaveq 
  802d03:	c3                   	retq   

0000000000802d04 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d04:	55                   	push   %rbp
  802d05:	48 89 e5             	mov    %rsp,%rbp
  802d08:	48 83 ec 20          	sub    $0x20,%rsp
  802d0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d18:	be 00 00 00 00       	mov    $0x0,%esi
  802d1d:	48 89 c7             	mov    %rax,%rdi
  802d20:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  802d27:	00 00 00 
  802d2a:	ff d0                	callq  *%rax
  802d2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d33:	79 05                	jns    802d3a <stat+0x36>
		return fd;
  802d35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d38:	eb 2f                	jmp    802d69 <stat+0x65>
	r = fstat(fd, stat);
  802d3a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d41:	48 89 d6             	mov    %rdx,%rsi
  802d44:	89 c7                	mov    %eax,%edi
  802d46:	48 b8 4b 2c 80 00 00 	movabs $0x802c4b,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d58:	89 c7                	mov    %eax,%edi
  802d5a:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
	return r;
  802d66:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d69:	c9                   	leaveq 
  802d6a:	c3                   	retq   

0000000000802d6b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d6b:	55                   	push   %rbp
  802d6c:	48 89 e5             	mov    %rsp,%rbp
  802d6f:	48 83 ec 10          	sub    $0x10,%rsp
  802d73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d7a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d81:	00 00 00 
  802d84:	8b 00                	mov    (%rax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	75 1d                	jne    802da7 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d8a:	bf 01 00 00 00       	mov    $0x1,%edi
  802d8f:	48 b8 82 23 80 00 00 	movabs $0x802382,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
  802d9b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802da2:	00 00 00 
  802da5:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802da7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dae:	00 00 00 
  802db1:	8b 00                	mov    (%rax),%eax
  802db3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802db6:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dbb:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802dc2:	00 00 00 
  802dc5:	89 c7                	mov    %eax,%edi
  802dc7:	48 b8 ea 22 80 00 00 	movabs $0x8022ea,%rax
  802dce:	00 00 00 
  802dd1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802dd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ddc:	48 89 c6             	mov    %rax,%rsi
  802ddf:	bf 00 00 00 00       	mov    $0x0,%edi
  802de4:	48 b8 29 22 80 00 00 	movabs $0x802229,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	48 83 ec 20          	sub    $0x20,%rsp
  802dfa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dfe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e05:	48 89 c7             	mov    %rax,%rdi
  802e08:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
  802e14:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e19:	7e 0a                	jle    802e25 <open+0x33>
		return -E_BAD_PATH;
  802e1b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e20:	e9 a5 00 00 00       	jmpq   802eca <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e25:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e29:	48 89 c7             	mov    %rax,%rdi
  802e2c:	48 b8 52 24 80 00 00 	movabs $0x802452,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
  802e38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3f:	79 08                	jns    802e49 <open+0x57>
		return r;
  802e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e44:	e9 81 00 00 00       	jmpq   802eca <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4d:	48 89 c6             	mov    %rax,%rsi
  802e50:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e57:	00 00 00 
  802e5a:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802e66:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6d:	00 00 00 
  802e70:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e73:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7d:	48 89 c6             	mov    %rax,%rsi
  802e80:	bf 01 00 00 00       	mov    $0x1,%edi
  802e85:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e98:	79 1d                	jns    802eb7 <open+0xc5>
		fd_close(fd, 0);
  802e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9e:	be 00 00 00 00       	mov    $0x0,%esi
  802ea3:	48 89 c7             	mov    %rax,%rdi
  802ea6:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
		return r;
  802eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb5:	eb 13                	jmp    802eca <open+0xd8>
	}

	return fd2num(fd);
  802eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebb:	48 89 c7             	mov    %rax,%rdi
  802ebe:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  802ec5:	00 00 00 
  802ec8:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802eca:	c9                   	leaveq 
  802ecb:	c3                   	retq   

0000000000802ecc <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ecc:	55                   	push   %rbp
  802ecd:	48 89 e5             	mov    %rsp,%rbp
  802ed0:	48 83 ec 10          	sub    $0x10,%rsp
  802ed4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edc:	8b 50 0c             	mov    0xc(%rax),%edx
  802edf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ee6:	00 00 00 
  802ee9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802eeb:	be 00 00 00 00       	mov    $0x0,%esi
  802ef0:	bf 06 00 00 00       	mov    $0x6,%edi
  802ef5:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  802efc:	00 00 00 
  802eff:	ff d0                	callq  *%rax
}
  802f01:	c9                   	leaveq 
  802f02:	c3                   	retq   

0000000000802f03 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f03:	55                   	push   %rbp
  802f04:	48 89 e5             	mov    %rsp,%rbp
  802f07:	48 83 ec 30          	sub    $0x30,%rsp
  802f0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f25:	00 00 00 
  802f28:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f2a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f31:	00 00 00 
  802f34:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f38:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f3c:	be 00 00 00 00       	mov    $0x0,%esi
  802f41:	bf 03 00 00 00       	mov    $0x3,%edi
  802f46:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
  802f52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f59:	79 08                	jns    802f63 <devfile_read+0x60>
		return r;
  802f5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5e:	e9 a4 00 00 00       	jmpq   803007 <devfile_read+0x104>
	assert(r <= n);
  802f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f66:	48 98                	cltq   
  802f68:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f6c:	76 35                	jbe    802fa3 <devfile_read+0xa0>
  802f6e:	48 b9 85 45 80 00 00 	movabs $0x804585,%rcx
  802f75:	00 00 00 
  802f78:	48 ba 8c 45 80 00 00 	movabs $0x80458c,%rdx
  802f7f:	00 00 00 
  802f82:	be 84 00 00 00       	mov    $0x84,%esi
  802f87:	48 bf a1 45 80 00 00 	movabs $0x8045a1,%rdi
  802f8e:	00 00 00 
  802f91:	b8 00 00 00 00       	mov    $0x0,%eax
  802f96:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
  802f9d:	00 00 00 
  802fa0:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802fa3:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802faa:	7e 35                	jle    802fe1 <devfile_read+0xde>
  802fac:	48 b9 ac 45 80 00 00 	movabs $0x8045ac,%rcx
  802fb3:	00 00 00 
  802fb6:	48 ba 8c 45 80 00 00 	movabs $0x80458c,%rdx
  802fbd:	00 00 00 
  802fc0:	be 85 00 00 00       	mov    $0x85,%esi
  802fc5:	48 bf a1 45 80 00 00 	movabs $0x8045a1,%rdi
  802fcc:	00 00 00 
  802fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd4:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
  802fdb:	00 00 00 
  802fde:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802fe1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe4:	48 63 d0             	movslq %eax,%rdx
  802fe7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802feb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ff2:	00 00 00 
  802ff5:	48 89 c7             	mov    %rax,%rdi
  802ff8:	48 b8 a7 13 80 00 00 	movabs $0x8013a7,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
	return r;
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  803007:	c9                   	leaveq 
  803008:	c3                   	retq   

0000000000803009 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803009:	55                   	push   %rbp
  80300a:	48 89 e5             	mov    %rsp,%rbp
  80300d:	48 83 ec 30          	sub    $0x30,%rsp
  803011:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803015:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803019:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80301d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803021:	8b 50 0c             	mov    0xc(%rax),%edx
  803024:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80302b:	00 00 00 
  80302e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803030:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803037:	00 00 00 
  80303a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80303e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  803042:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803049:	00 
  80304a:	76 35                	jbe    803081 <devfile_write+0x78>
  80304c:	48 b9 b8 45 80 00 00 	movabs $0x8045b8,%rcx
  803053:	00 00 00 
  803056:	48 ba 8c 45 80 00 00 	movabs $0x80458c,%rdx
  80305d:	00 00 00 
  803060:	be 9e 00 00 00       	mov    $0x9e,%esi
  803065:	48 bf a1 45 80 00 00 	movabs $0x8045a1,%rdi
  80306c:	00 00 00 
  80306f:	b8 00 00 00 00       	mov    $0x0,%eax
  803074:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
  80307b:	00 00 00 
  80307e:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803081:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803089:	48 89 c6             	mov    %rax,%rsi
  80308c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803093:	00 00 00 
  803096:	48 b8 be 14 80 00 00 	movabs $0x8014be,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8030a2:	be 00 00 00 00       	mov    $0x0,%esi
  8030a7:	bf 04 00 00 00       	mov    $0x4,%edi
  8030ac:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
  8030b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bf:	79 05                	jns    8030c6 <devfile_write+0xbd>
		return r;
  8030c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c4:	eb 43                	jmp    803109 <devfile_write+0x100>
	assert(r <= n);
  8030c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c9:	48 98                	cltq   
  8030cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030cf:	76 35                	jbe    803106 <devfile_write+0xfd>
  8030d1:	48 b9 85 45 80 00 00 	movabs $0x804585,%rcx
  8030d8:	00 00 00 
  8030db:	48 ba 8c 45 80 00 00 	movabs $0x80458c,%rdx
  8030e2:	00 00 00 
  8030e5:	be a2 00 00 00       	mov    $0xa2,%esi
  8030ea:	48 bf a1 45 80 00 00 	movabs $0x8045a1,%rdi
  8030f1:	00 00 00 
  8030f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f9:	49 b8 82 02 80 00 00 	movabs $0x800282,%r8
  803100:	00 00 00 
  803103:	41 ff d0             	callq  *%r8
	return r;
  803106:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  803109:	c9                   	leaveq 
  80310a:	c3                   	retq   

000000000080310b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80310b:	55                   	push   %rbp
  80310c:	48 89 e5             	mov    %rsp,%rbp
  80310f:	48 83 ec 20          	sub    $0x20,%rsp
  803113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803117:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80311b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311f:	8b 50 0c             	mov    0xc(%rax),%edx
  803122:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803129:	00 00 00 
  80312c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80312e:	be 00 00 00 00       	mov    $0x0,%esi
  803133:	bf 05 00 00 00       	mov    $0x5,%edi
  803138:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314b:	79 05                	jns    803152 <devfile_stat+0x47>
		return r;
  80314d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803150:	eb 56                	jmp    8031a8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803152:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803156:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80315d:	00 00 00 
  803160:	48 89 c7             	mov    %rax,%rdi
  803163:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80316f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803176:	00 00 00 
  803179:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80317f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803183:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803189:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803190:	00 00 00 
  803193:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803199:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a8:	c9                   	leaveq 
  8031a9:	c3                   	retq   

00000000008031aa <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031aa:	55                   	push   %rbp
  8031ab:	48 89 e5             	mov    %rsp,%rbp
  8031ae:	48 83 ec 10          	sub    $0x10,%rsp
  8031b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8031c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c7:	00 00 00 
  8031ca:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d3:	00 00 00 
  8031d6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031d9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031dc:	be 00 00 00 00       	mov    $0x0,%esi
  8031e1:	bf 02 00 00 00       	mov    $0x2,%edi
  8031e6:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  8031ed:	00 00 00 
  8031f0:	ff d0                	callq  *%rax
}
  8031f2:	c9                   	leaveq 
  8031f3:	c3                   	retq   

00000000008031f4 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031f4:	55                   	push   %rbp
  8031f5:	48 89 e5             	mov    %rsp,%rbp
  8031f8:	48 83 ec 10          	sub    $0x10,%rsp
  8031fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803204:	48 89 c7             	mov    %rax,%rdi
  803207:	48 b8 17 10 80 00 00 	movabs $0x801017,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
  803213:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803218:	7e 07                	jle    803221 <remove+0x2d>
		return -E_BAD_PATH;
  80321a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80321f:	eb 33                	jmp    803254 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803225:	48 89 c6             	mov    %rax,%rsi
  803228:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80322f:	00 00 00 
  803232:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80323e:	be 00 00 00 00       	mov    $0x0,%esi
  803243:	bf 07 00 00 00       	mov    $0x7,%edi
  803248:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
}
  803254:	c9                   	leaveq 
  803255:	c3                   	retq   

0000000000803256 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803256:	55                   	push   %rbp
  803257:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80325a:	be 00 00 00 00       	mov    $0x0,%esi
  80325f:	bf 08 00 00 00       	mov    $0x8,%edi
  803264:	48 b8 6b 2d 80 00 00 	movabs $0x802d6b,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
}
  803270:	5d                   	pop    %rbp
  803271:	c3                   	retq   

0000000000803272 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803272:	55                   	push   %rbp
  803273:	48 89 e5             	mov    %rsp,%rbp
  803276:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80327d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803284:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80328b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803292:	be 00 00 00 00       	mov    $0x0,%esi
  803297:	48 89 c7             	mov    %rax,%rdi
  80329a:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
  8032a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ad:	79 28                	jns    8032d7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b2:	89 c6                	mov    %eax,%esi
  8032b4:	48 bf e5 45 80 00 00 	movabs $0x8045e5,%rdi
  8032bb:	00 00 00 
  8032be:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c3:	48 ba bb 04 80 00 00 	movabs $0x8004bb,%rdx
  8032ca:	00 00 00 
  8032cd:	ff d2                	callq  *%rdx
		return fd_src;
  8032cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d2:	e9 74 01 00 00       	jmpq   80344b <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032d7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032de:	be 01 01 00 00       	mov    $0x101,%esi
  8032e3:	48 89 c7             	mov    %rax,%rdi
  8032e6:	48 b8 f2 2d 80 00 00 	movabs $0x802df2,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032f9:	79 39                	jns    803334 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032fe:	89 c6                	mov    %eax,%esi
  803300:	48 bf fb 45 80 00 00 	movabs $0x8045fb,%rdi
  803307:	00 00 00 
  80330a:	b8 00 00 00 00       	mov    $0x0,%eax
  80330f:	48 ba bb 04 80 00 00 	movabs $0x8004bb,%rdx
  803316:	00 00 00 
  803319:	ff d2                	callq  *%rdx
		close(fd_src);
  80331b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331e:	89 c7                	mov    %eax,%edi
  803320:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
		return fd_dest;
  80332c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80332f:	e9 17 01 00 00       	jmpq   80344b <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803334:	eb 74                	jmp    8033aa <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803336:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803339:	48 63 d0             	movslq %eax,%rdx
  80333c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803343:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803346:	48 89 ce             	mov    %rcx,%rsi
  803349:	89 c7                	mov    %eax,%edi
  80334b:	48 b8 66 2a 80 00 00 	movabs $0x802a66,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80335a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80335e:	79 4a                	jns    8033aa <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803360:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803363:	89 c6                	mov    %eax,%esi
  803365:	48 bf 15 46 80 00 00 	movabs $0x804615,%rdi
  80336c:	00 00 00 
  80336f:	b8 00 00 00 00       	mov    $0x0,%eax
  803374:	48 ba bb 04 80 00 00 	movabs $0x8004bb,%rdx
  80337b:	00 00 00 
  80337e:	ff d2                	callq  *%rdx
			close(fd_src);
  803380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803383:	89 c7                	mov    %eax,%edi
  803385:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
			close(fd_dest);
  803391:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803394:	89 c7                	mov    %eax,%edi
  803396:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  80339d:	00 00 00 
  8033a0:	ff d0                	callq  *%rax
			return write_size;
  8033a2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a5:	e9 a1 00 00 00       	jmpq   80344b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033aa:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b4:	ba 00 02 00 00       	mov    $0x200,%edx
  8033b9:	48 89 ce             	mov    %rcx,%rsi
  8033bc:	89 c7                	mov    %eax,%edi
  8033be:	48 b8 1c 29 80 00 00 	movabs $0x80291c,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
  8033ca:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033d1:	0f 8f 5f ff ff ff    	jg     803336 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8033d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033db:	79 47                	jns    803424 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033e0:	89 c6                	mov    %eax,%esi
  8033e2:	48 bf 28 46 80 00 00 	movabs $0x804628,%rdi
  8033e9:	00 00 00 
  8033ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f1:	48 ba bb 04 80 00 00 	movabs $0x8004bb,%rdx
  8033f8:	00 00 00 
  8033fb:	ff d2                	callq  *%rdx
		close(fd_src);
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	89 c7                	mov    %eax,%edi
  803402:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
		close(fd_dest);
  80340e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803411:	89 c7                	mov    %eax,%edi
  803413:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  80341a:	00 00 00 
  80341d:	ff d0                	callq  *%rax
		return read_size;
  80341f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803422:	eb 27                	jmp    80344b <copy+0x1d9>
	}
	close(fd_src);
  803424:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803427:	89 c7                	mov    %eax,%edi
  803429:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
	close(fd_dest);
  803435:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803438:	89 c7                	mov    %eax,%edi
  80343a:	48 b8 fa 26 80 00 00 	movabs $0x8026fa,%rax
  803441:	00 00 00 
  803444:	ff d0                	callq  *%rax
	return 0;
  803446:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80344b:	c9                   	leaveq 
  80344c:	c3                   	retq   

000000000080344d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80344d:	55                   	push   %rbp
  80344e:	48 89 e5             	mov    %rsp,%rbp
  803451:	53                   	push   %rbx
  803452:	48 83 ec 38          	sub    $0x38,%rsp
  803456:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80345a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80345e:	48 89 c7             	mov    %rax,%rdi
  803461:	48 b8 52 24 80 00 00 	movabs $0x802452,%rax
  803468:	00 00 00 
  80346b:	ff d0                	callq  *%rax
  80346d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803470:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803474:	0f 88 bf 01 00 00    	js     803639 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80347a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347e:	ba 07 04 00 00       	mov    $0x407,%edx
  803483:	48 89 c6             	mov    %rax,%rsi
  803486:	bf 00 00 00 00       	mov    $0x0,%edi
  80348b:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  803492:	00 00 00 
  803495:	ff d0                	callq  *%rax
  803497:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80349a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80349e:	0f 88 95 01 00 00    	js     803639 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8034a4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034a8:	48 89 c7             	mov    %rax,%rdi
  8034ab:	48 b8 52 24 80 00 00 	movabs $0x802452,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034be:	0f 88 5d 01 00 00    	js     803621 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c8:	ba 07 04 00 00       	mov    $0x407,%edx
  8034cd:	48 89 c6             	mov    %rax,%rsi
  8034d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d5:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
  8034e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e8:	0f 88 33 01 00 00    	js     803621 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8034ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f2:	48 89 c7             	mov    %rax,%rdi
  8034f5:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
  803501:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803505:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803509:	ba 07 04 00 00       	mov    $0x407,%edx
  80350e:	48 89 c6             	mov    %rax,%rsi
  803511:	bf 00 00 00 00       	mov    $0x0,%edi
  803516:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
  803522:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803525:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803529:	79 05                	jns    803530 <pipe+0xe3>
		goto err2;
  80352b:	e9 d9 00 00 00       	jmpq   803609 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803530:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803534:	48 89 c7             	mov    %rax,%rdi
  803537:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  80353e:	00 00 00 
  803541:	ff d0                	callq  *%rax
  803543:	48 89 c2             	mov    %rax,%rdx
  803546:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803550:	48 89 d1             	mov    %rdx,%rcx
  803553:	ba 00 00 00 00       	mov    $0x0,%edx
  803558:	48 89 c6             	mov    %rax,%rsi
  80355b:	bf 00 00 00 00       	mov    $0x0,%edi
  803560:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  803567:	00 00 00 
  80356a:	ff d0                	callq  *%rax
  80356c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80356f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803573:	79 1b                	jns    803590 <pipe+0x143>
		goto err3;
  803575:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803576:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357a:	48 89 c6             	mov    %rax,%rsi
  80357d:	bf 00 00 00 00       	mov    $0x0,%edi
  803582:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
  80358e:	eb 79                	jmp    803609 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803594:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80359b:	00 00 00 
  80359e:	8b 12                	mov    (%rdx),%edx
  8035a0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8035a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8035ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b1:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8035b8:	00 00 00 
  8035bb:	8b 12                	mov    (%rdx),%edx
  8035bd:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8035bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8035ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ce:	48 89 c7             	mov    %rax,%rdi
  8035d1:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
  8035dd:	89 c2                	mov    %eax,%edx
  8035df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035e3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8035e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035e9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8035ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f1:	48 89 c7             	mov    %rax,%rdi
  8035f4:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
  803600:	89 03                	mov    %eax,(%rbx)
	return 0;
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
  803607:	eb 33                	jmp    80363c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803609:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360d:	48 89 c6             	mov    %rax,%rsi
  803610:	bf 00 00 00 00       	mov    $0x0,%edi
  803615:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  80361c:	00 00 00 
  80361f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803625:	48 89 c6             	mov    %rax,%rsi
  803628:	bf 00 00 00 00       	mov    $0x0,%edi
  80362d:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
err:
	return r;
  803639:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80363c:	48 83 c4 38          	add    $0x38,%rsp
  803640:	5b                   	pop    %rbx
  803641:	5d                   	pop    %rbp
  803642:	c3                   	retq   

0000000000803643 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803643:	55                   	push   %rbp
  803644:	48 89 e5             	mov    %rsp,%rbp
  803647:	53                   	push   %rbx
  803648:	48 83 ec 28          	sub    $0x28,%rsp
  80364c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803650:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803654:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80365b:	00 00 00 
  80365e:	48 8b 00             	mov    (%rax),%rax
  803661:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803667:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80366a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80366e:	48 89 c7             	mov    %rax,%rdi
  803671:	48 b8 13 3e 80 00 00 	movabs $0x803e13,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax
  80367d:	89 c3                	mov    %eax,%ebx
  80367f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 13 3e 80 00 00 	movabs $0x803e13,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	39 c3                	cmp    %eax,%ebx
  803694:	0f 94 c0             	sete   %al
  803697:	0f b6 c0             	movzbl %al,%eax
  80369a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80369d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036a4:	00 00 00 
  8036a7:	48 8b 00             	mov    (%rax),%rax
  8036aa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036b0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8036b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036b9:	75 05                	jne    8036c0 <_pipeisclosed+0x7d>
			return ret;
  8036bb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036be:	eb 4f                	jmp    80370f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8036c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036c6:	74 42                	je     80370a <_pipeisclosed+0xc7>
  8036c8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8036cc:	75 3c                	jne    80370a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8036ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036d5:	00 00 00 
  8036d8:	48 8b 00             	mov    (%rax),%rax
  8036db:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8036e1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e7:	89 c6                	mov    %eax,%esi
  8036e9:	48 bf 43 46 80 00 00 	movabs $0x804643,%rdi
  8036f0:	00 00 00 
  8036f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f8:	49 b8 bb 04 80 00 00 	movabs $0x8004bb,%r8
  8036ff:	00 00 00 
  803702:	41 ff d0             	callq  *%r8
	}
  803705:	e9 4a ff ff ff       	jmpq   803654 <_pipeisclosed+0x11>
  80370a:	e9 45 ff ff ff       	jmpq   803654 <_pipeisclosed+0x11>
}
  80370f:	48 83 c4 28          	add    $0x28,%rsp
  803713:	5b                   	pop    %rbx
  803714:	5d                   	pop    %rbp
  803715:	c3                   	retq   

0000000000803716 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803716:	55                   	push   %rbp
  803717:	48 89 e5             	mov    %rsp,%rbp
  80371a:	48 83 ec 30          	sub    $0x30,%rsp
  80371e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803721:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803725:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803728:	48 89 d6             	mov    %rdx,%rsi
  80372b:	89 c7                	mov    %eax,%edi
  80372d:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803734:	00 00 00 
  803737:	ff d0                	callq  *%rax
  803739:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803740:	79 05                	jns    803747 <pipeisclosed+0x31>
		return r;
  803742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803745:	eb 31                	jmp    803778 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374b:	48 89 c7             	mov    %rax,%rdi
  80374e:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  803755:	00 00 00 
  803758:	ff d0                	callq  *%rax
  80375a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80375e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803762:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803766:	48 89 d6             	mov    %rdx,%rsi
  803769:	48 89 c7             	mov    %rax,%rdi
  80376c:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  803773:	00 00 00 
  803776:	ff d0                	callq  *%rax
}
  803778:	c9                   	leaveq 
  803779:	c3                   	retq   

000000000080377a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80377a:	55                   	push   %rbp
  80377b:	48 89 e5             	mov    %rsp,%rbp
  80377e:	48 83 ec 40          	sub    $0x40,%rsp
  803782:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803786:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80378a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80378e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803792:	48 89 c7             	mov    %rax,%rdi
  803795:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037ad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037b4:	00 
  8037b5:	e9 92 00 00 00       	jmpq   80384c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8037ba:	eb 41                	jmp    8037fd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8037bc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8037c1:	74 09                	je     8037cc <devpipe_read+0x52>
				return i;
  8037c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c7:	e9 92 00 00 00       	jmpq   80385e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8037cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d4:	48 89 d6             	mov    %rdx,%rsi
  8037d7:	48 89 c7             	mov    %rax,%rdi
  8037da:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	74 07                	je     8037f1 <devpipe_read+0x77>
				return 0;
  8037ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ef:	eb 6d                	jmp    80385e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8037f1:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8037f8:	00 00 00 
  8037fb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803801:	8b 10                	mov    (%rax),%edx
  803803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803807:	8b 40 04             	mov    0x4(%rax),%eax
  80380a:	39 c2                	cmp    %eax,%edx
  80380c:	74 ae                	je     8037bc <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80380e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803812:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803816:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80381a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381e:	8b 00                	mov    (%rax),%eax
  803820:	99                   	cltd   
  803821:	c1 ea 1b             	shr    $0x1b,%edx
  803824:	01 d0                	add    %edx,%eax
  803826:	83 e0 1f             	and    $0x1f,%eax
  803829:	29 d0                	sub    %edx,%eax
  80382b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80382f:	48 98                	cltq   
  803831:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803836:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383c:	8b 00                	mov    (%rax),%eax
  80383e:	8d 50 01             	lea    0x1(%rax),%edx
  803841:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803845:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803847:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80384c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803850:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803854:	0f 82 60 ff ff ff    	jb     8037ba <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80385a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80385e:	c9                   	leaveq 
  80385f:	c3                   	retq   

0000000000803860 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803860:	55                   	push   %rbp
  803861:	48 89 e5             	mov    %rsp,%rbp
  803864:	48 83 ec 40          	sub    $0x40,%rsp
  803868:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80386c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803870:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803878:	48 89 c7             	mov    %rax,%rdi
  80387b:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
  803887:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80388b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80388f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803893:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80389a:	00 
  80389b:	e9 8e 00 00 00       	jmpq   80392e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038a0:	eb 31                	jmp    8038d3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8038a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038aa:	48 89 d6             	mov    %rdx,%rsi
  8038ad:	48 89 c7             	mov    %rax,%rdi
  8038b0:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	74 07                	je     8038c7 <devpipe_write+0x67>
				return 0;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c5:	eb 79                	jmp    803940 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8038c7:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d7:	8b 40 04             	mov    0x4(%rax),%eax
  8038da:	48 63 d0             	movslq %eax,%rdx
  8038dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e1:	8b 00                	mov    (%rax),%eax
  8038e3:	48 98                	cltq   
  8038e5:	48 83 c0 20          	add    $0x20,%rax
  8038e9:	48 39 c2             	cmp    %rax,%rdx
  8038ec:	73 b4                	jae    8038a2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8038ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f2:	8b 40 04             	mov    0x4(%rax),%eax
  8038f5:	99                   	cltd   
  8038f6:	c1 ea 1b             	shr    $0x1b,%edx
  8038f9:	01 d0                	add    %edx,%eax
  8038fb:	83 e0 1f             	and    $0x1f,%eax
  8038fe:	29 d0                	sub    %edx,%eax
  803900:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803904:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803908:	48 01 ca             	add    %rcx,%rdx
  80390b:	0f b6 0a             	movzbl (%rdx),%ecx
  80390e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803912:	48 98                	cltq   
  803914:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391c:	8b 40 04             	mov    0x4(%rax),%eax
  80391f:	8d 50 01             	lea    0x1(%rax),%edx
  803922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803926:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803929:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80392e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803932:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803936:	0f 82 64 ff ff ff    	jb     8038a0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80393c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803940:	c9                   	leaveq 
  803941:	c3                   	retq   

0000000000803942 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803942:	55                   	push   %rbp
  803943:	48 89 e5             	mov    %rsp,%rbp
  803946:	48 83 ec 20          	sub    $0x20,%rsp
  80394a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80394e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803956:	48 89 c7             	mov    %rax,%rdi
  803959:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  803960:	00 00 00 
  803963:	ff d0                	callq  *%rax
  803965:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80396d:	48 be 56 46 80 00 00 	movabs $0x804656,%rsi
  803974:	00 00 00 
  803977:	48 89 c7             	mov    %rax,%rdi
  80397a:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803986:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398a:	8b 50 04             	mov    0x4(%rax),%edx
  80398d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803991:	8b 00                	mov    (%rax),%eax
  803993:	29 c2                	sub    %eax,%edx
  803995:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803999:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80399f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8039aa:	00 00 00 
	stat->st_dev = &devpipe;
  8039ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039b1:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8039b8:	00 00 00 
  8039bb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8039c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039c7:	c9                   	leaveq 
  8039c8:	c3                   	retq   

00000000008039c9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8039c9:	55                   	push   %rbp
  8039ca:	48 89 e5             	mov    %rsp,%rbp
  8039cd:	48 83 ec 10          	sub    $0x10,%rsp
  8039d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8039d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d9:	48 89 c6             	mov    %rax,%rsi
  8039dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e1:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8039ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f1:	48 89 c7             	mov    %rax,%rdi
  8039f4:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	48 89 c6             	mov    %rax,%rsi
  803a03:	bf 00 00 00 00       	mov    $0x0,%edi
  803a08:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
}
  803a14:	c9                   	leaveq 
  803a15:	c3                   	retq   

0000000000803a16 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a16:	55                   	push   %rbp
  803a17:	48 89 e5             	mov    %rsp,%rbp
  803a1a:	48 83 ec 20          	sub    $0x20,%rsp
  803a1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a24:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a27:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a2b:	be 01 00 00 00       	mov    $0x1,%esi
  803a30:	48 89 c7             	mov    %rax,%rdi
  803a33:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
}
  803a3f:	c9                   	leaveq 
  803a40:	c3                   	retq   

0000000000803a41 <getchar>:

int
getchar(void)
{
  803a41:	55                   	push   %rbp
  803a42:	48 89 e5             	mov    %rsp,%rbp
  803a45:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a49:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a4d:	ba 01 00 00 00       	mov    $0x1,%edx
  803a52:	48 89 c6             	mov    %rax,%rsi
  803a55:	bf 00 00 00 00       	mov    $0x0,%edi
  803a5a:	48 b8 1c 29 80 00 00 	movabs $0x80291c,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
  803a66:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803a69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a6d:	79 05                	jns    803a74 <getchar+0x33>
		return r;
  803a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a72:	eb 14                	jmp    803a88 <getchar+0x47>
	if (r < 1)
  803a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a78:	7f 07                	jg     803a81 <getchar+0x40>
		return -E_EOF;
  803a7a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803a7f:	eb 07                	jmp    803a88 <getchar+0x47>
	return c;
  803a81:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803a85:	0f b6 c0             	movzbl %al,%eax
}
  803a88:	c9                   	leaveq 
  803a89:	c3                   	retq   

0000000000803a8a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803a8a:	55                   	push   %rbp
  803a8b:	48 89 e5             	mov    %rsp,%rbp
  803a8e:	48 83 ec 20          	sub    $0x20,%rsp
  803a92:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a9c:	48 89 d6             	mov    %rdx,%rsi
  803a9f:	89 c7                	mov    %eax,%edi
  803aa1:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803aa8:	00 00 00 
  803aab:	ff d0                	callq  *%rax
  803aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab4:	79 05                	jns    803abb <iscons+0x31>
		return r;
  803ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab9:	eb 1a                	jmp    803ad5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803abb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abf:	8b 10                	mov    (%rax),%edx
  803ac1:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803ac8:	00 00 00 
  803acb:	8b 00                	mov    (%rax),%eax
  803acd:	39 c2                	cmp    %eax,%edx
  803acf:	0f 94 c0             	sete   %al
  803ad2:	0f b6 c0             	movzbl %al,%eax
}
  803ad5:	c9                   	leaveq 
  803ad6:	c3                   	retq   

0000000000803ad7 <opencons>:

int
opencons(void)
{
  803ad7:	55                   	push   %rbp
  803ad8:	48 89 e5             	mov    %rsp,%rbp
  803adb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803adf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ae3:	48 89 c7             	mov    %rax,%rdi
  803ae6:	48 b8 52 24 80 00 00 	movabs $0x802452,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
  803af2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af9:	79 05                	jns    803b00 <opencons+0x29>
		return r;
  803afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afe:	eb 5b                	jmp    803b5b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b04:	ba 07 04 00 00       	mov    $0x407,%edx
  803b09:	48 89 c6             	mov    %rax,%rsi
  803b0c:	bf 00 00 00 00       	mov    $0x0,%edi
  803b11:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  803b18:	00 00 00 
  803b1b:	ff d0                	callq  *%rax
  803b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b24:	79 05                	jns    803b2b <opencons+0x54>
		return r;
  803b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b29:	eb 30                	jmp    803b5b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2f:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b36:	00 00 00 
  803b39:	8b 12                	mov    (%rdx),%edx
  803b3b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4c:	48 89 c7             	mov    %rax,%rdi
  803b4f:	48 b8 04 24 80 00 00 	movabs $0x802404,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
}
  803b5b:	c9                   	leaveq 
  803b5c:	c3                   	retq   

0000000000803b5d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b5d:	55                   	push   %rbp
  803b5e:	48 89 e5             	mov    %rsp,%rbp
  803b61:	48 83 ec 30          	sub    $0x30,%rsp
  803b65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b6d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803b71:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b76:	75 07                	jne    803b7f <devcons_read+0x22>
		return 0;
  803b78:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7d:	eb 4b                	jmp    803bca <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803b7f:	eb 0c                	jmp    803b8d <devcons_read+0x30>
		sys_yield();
  803b81:	48 b8 74 19 80 00 00 	movabs $0x801974,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b8d:	48 b8 b4 18 80 00 00 	movabs $0x8018b4,%rax
  803b94:	00 00 00 
  803b97:	ff d0                	callq  *%rax
  803b99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba0:	74 df                	je     803b81 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803ba2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba6:	79 05                	jns    803bad <devcons_read+0x50>
		return c;
  803ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bab:	eb 1d                	jmp    803bca <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bad:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803bb1:	75 07                	jne    803bba <devcons_read+0x5d>
		return 0;
  803bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb8:	eb 10                	jmp    803bca <devcons_read+0x6d>
	*(char*)vbuf = c;
  803bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbd:	89 c2                	mov    %eax,%edx
  803bbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc3:	88 10                	mov    %dl,(%rax)
	return 1;
  803bc5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803bca:	c9                   	leaveq 
  803bcb:	c3                   	retq   

0000000000803bcc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bcc:	55                   	push   %rbp
  803bcd:	48 89 e5             	mov    %rsp,%rbp
  803bd0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803bd7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803bde:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803be5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bf3:	eb 76                	jmp    803c6b <devcons_write+0x9f>
		m = n - tot;
  803bf5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803bfc:	89 c2                	mov    %eax,%edx
  803bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c01:	29 c2                	sub    %eax,%edx
  803c03:	89 d0                	mov    %edx,%eax
  803c05:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c0b:	83 f8 7f             	cmp    $0x7f,%eax
  803c0e:	76 07                	jbe    803c17 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c10:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c1a:	48 63 d0             	movslq %eax,%rdx
  803c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c20:	48 63 c8             	movslq %eax,%rcx
  803c23:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c2a:	48 01 c1             	add    %rax,%rcx
  803c2d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c34:	48 89 ce             	mov    %rcx,%rsi
  803c37:	48 89 c7             	mov    %rax,%rdi
  803c3a:	48 b8 a7 13 80 00 00 	movabs $0x8013a7,%rax
  803c41:	00 00 00 
  803c44:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c49:	48 63 d0             	movslq %eax,%rdx
  803c4c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c53:	48 89 d6             	mov    %rdx,%rsi
  803c56:	48 89 c7             	mov    %rax,%rdi
  803c59:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c68:	01 45 fc             	add    %eax,-0x4(%rbp)
  803c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6e:	48 98                	cltq   
  803c70:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803c77:	0f 82 78 ff ff ff    	jb     803bf5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c80:	c9                   	leaveq 
  803c81:	c3                   	retq   

0000000000803c82 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803c82:	55                   	push   %rbp
  803c83:	48 89 e5             	mov    %rsp,%rbp
  803c86:	48 83 ec 08          	sub    $0x8,%rsp
  803c8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c93:	c9                   	leaveq 
  803c94:	c3                   	retq   

0000000000803c95 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c95:	55                   	push   %rbp
  803c96:	48 89 e5             	mov    %rsp,%rbp
  803c99:	48 83 ec 10          	sub    $0x10,%rsp
  803c9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ca1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	48 be 62 46 80 00 00 	movabs $0x804662,%rsi
  803cb0:	00 00 00 
  803cb3:	48 89 c7             	mov    %rax,%rdi
  803cb6:	48 b8 83 10 80 00 00 	movabs $0x801083,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
	return 0;
  803cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cc7:	c9                   	leaveq 
  803cc8:	c3                   	retq   

0000000000803cc9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803cc9:	55                   	push   %rbp
  803cca:	48 89 e5             	mov    %rsp,%rbp
  803ccd:	48 83 ec 10          	sub    $0x10,%rsp
  803cd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803cd5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803cdc:	00 00 00 
  803cdf:	48 8b 00             	mov    (%rax),%rax
  803ce2:	48 85 c0             	test   %rax,%rax
  803ce5:	75 49                	jne    803d30 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803ce7:	ba 07 00 00 00       	mov    $0x7,%edx
  803cec:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803cf1:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf6:	48 b8 b2 19 80 00 00 	movabs $0x8019b2,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
  803d02:	85 c0                	test   %eax,%eax
  803d04:	79 2a                	jns    803d30 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803d06:	48 ba 70 46 80 00 00 	movabs $0x804670,%rdx
  803d0d:	00 00 00 
  803d10:	be 21 00 00 00       	mov    $0x21,%esi
  803d15:	48 bf 9b 46 80 00 00 	movabs $0x80469b,%rdi
  803d1c:	00 00 00 
  803d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d24:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  803d2b:	00 00 00 
  803d2e:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803d30:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d37:	00 00 00 
  803d3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d3e:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803d41:	48 be 8c 3d 80 00 00 	movabs $0x803d8c,%rsi
  803d48:	00 00 00 
  803d4b:	bf 00 00 00 00       	mov    $0x0,%edi
  803d50:	48 b8 3c 1b 80 00 00 	movabs $0x801b3c,%rax
  803d57:	00 00 00 
  803d5a:	ff d0                	callq  *%rax
  803d5c:	85 c0                	test   %eax,%eax
  803d5e:	79 2a                	jns    803d8a <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803d60:	48 ba b0 46 80 00 00 	movabs $0x8046b0,%rdx
  803d67:	00 00 00 
  803d6a:	be 27 00 00 00       	mov    $0x27,%esi
  803d6f:	48 bf 9b 46 80 00 00 	movabs $0x80469b,%rdi
  803d76:	00 00 00 
  803d79:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7e:	48 b9 82 02 80 00 00 	movabs $0x800282,%rcx
  803d85:	00 00 00 
  803d88:	ff d1                	callq  *%rcx
}
  803d8a:	c9                   	leaveq 
  803d8b:	c3                   	retq   

0000000000803d8c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803d8c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803d8f:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803d96:	00 00 00 
call *%rax
  803d99:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803d9b:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803da2:	00 
    movq 152(%rsp), %rcx
  803da3:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803daa:	00 
    subq $8, %rcx
  803dab:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803daf:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803db2:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803db9:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803dba:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803dbe:	4c 8b 3c 24          	mov    (%rsp),%r15
  803dc2:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803dc7:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803dcc:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803dd1:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803dd6:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803ddb:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803de0:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803de5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803dea:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803def:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803df4:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803df9:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803dfe:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e03:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e08:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803e0c:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803e10:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803e11:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803e12:	c3                   	retq   

0000000000803e13 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e13:	55                   	push   %rbp
  803e14:	48 89 e5             	mov    %rsp,%rbp
  803e17:	48 83 ec 18          	sub    $0x18,%rsp
  803e1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e23:	48 c1 e8 15          	shr    $0x15,%rax
  803e27:	48 89 c2             	mov    %rax,%rdx
  803e2a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e31:	01 00 00 
  803e34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e38:	83 e0 01             	and    $0x1,%eax
  803e3b:	48 85 c0             	test   %rax,%rax
  803e3e:	75 07                	jne    803e47 <pageref+0x34>
		return 0;
  803e40:	b8 00 00 00 00       	mov    $0x0,%eax
  803e45:	eb 53                	jmp    803e9a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4b:	48 c1 e8 0c          	shr    $0xc,%rax
  803e4f:	48 89 c2             	mov    %rax,%rdx
  803e52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e59:	01 00 00 
  803e5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e68:	83 e0 01             	and    $0x1,%eax
  803e6b:	48 85 c0             	test   %rax,%rax
  803e6e:	75 07                	jne    803e77 <pageref+0x64>
		return 0;
  803e70:	b8 00 00 00 00       	mov    $0x0,%eax
  803e75:	eb 23                	jmp    803e9a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e7b:	48 c1 e8 0c          	shr    $0xc,%rax
  803e7f:	48 89 c2             	mov    %rax,%rdx
  803e82:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e89:	00 00 00 
  803e8c:	48 c1 e2 04          	shl    $0x4,%rdx
  803e90:	48 01 d0             	add    %rdx,%rax
  803e93:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e97:	0f b7 c0             	movzwl %ax,%eax
}
  803e9a:	c9                   	leaveq 
  803e9b:	c3                   	retq   
