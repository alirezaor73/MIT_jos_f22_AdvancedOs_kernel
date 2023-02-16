
obj/user/testpiperace:     file format elf64-x86-64


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
  80003c:	e8 4c 03 00 00       	callq  80038d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 95 36 80 00 00 	movabs $0x803695,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 79 40 80 00 00 	movabs $0x804079,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 82 40 80 00 00 	movabs $0x804082,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 37 21 80 00 00 	movabs $0x802137,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba 96 40 80 00 00 	movabs $0x804096,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf 82 40 80 00 00 	movabs $0x804082,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if(pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 5e 39 80 00 00 	movabs $0x80395e,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf 9f 40 80 00 00 	movabs $0x80409f,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 1e 04 80 00 00 	movabs $0x80041e,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf ba 40 80 00 00 	movabs $0x8040ba,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 63 d0             	movslq %eax,%rdx
  8001d1:	48 89 d0             	mov    %rdx,%rax
  8001d4:	48 c1 e0 03          	shl    $0x3,%rax
  8001d8:	48 01 d0             	add    %rdx,%rax
  8001db:	48 c1 e0 05          	shl    $0x5,%rax
  8001df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e6:	00 00 00 
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fb:	00 00 00 
  8001fe:	48 29 c2             	sub    %rax,%rdx
  800201:	48 89 d0             	mov    %rdx,%rax
  800204:	48 c1 f8 05          	sar    $0x5,%rax
  800208:	48 89 c2             	mov    %rax,%rdx
  80020b:	48 b8 39 8e e3 38 8e 	movabs $0x8e38e38e38e38e39,%rax
  800212:	e3 38 8e 
  800215:	48 0f af c2          	imul   %rdx,%rax
  800219:	48 89 c6             	mov    %rax,%rsi
  80021c:	48 bf c5 40 80 00 00 	movabs $0x8040c5,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  800232:	00 00 00 
  800235:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800237:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80023a:	be 0a 00 00 00       	mov    $0xa,%esi
  80023f:	89 c7                	mov    %eax,%edi
  800241:	48 b8 32 29 80 00 00 	movabs $0x802932,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80024d:	eb 16                	jmp    800265 <umain+0x222>
		dup(p[0], 10);
  80024f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800252:	be 0a 00 00 00       	mov    $0xa,%esi
  800257:	89 c7                	mov    %eax,%edi
  800259:	48 b8 32 29 80 00 00 	movabs $0x802932,%rax
  800260:	00 00 00 
  800263:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800269:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80026f:	83 f8 02             	cmp    $0x2,%eax
  800272:	74 db                	je     80024f <umain+0x20c>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800274:	48 bf d0 40 80 00 00 	movabs $0x8040d0,%rdi
  80027b:	00 00 00 
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  80028a:	00 00 00 
  80028d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80028f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 5e 39 80 00 00 	movabs $0x80395e,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	74 2a                	je     8002ce <umain+0x28b>
		panic("somehow the other end of p[0] got closed!");
  8002a4:	48 ba e8 40 80 00 00 	movabs $0x8040e8,%rdx
  8002ab:	00 00 00 
  8002ae:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002b3:	48 bf 82 40 80 00 00 	movabs $0x804082,%rdi
  8002ba:	00 00 00 
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  8002c9:	00 00 00 
  8002cc:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002d1:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002d5:	48 89 d6             	mov    %rdx,%rsi
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ed:	79 30                	jns    80031f <umain+0x2dc>
		panic("cannot look up p[0]: %e", r);
  8002ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	48 ba 12 41 80 00 00 	movabs $0x804112,%rdx
  8002fb:	00 00 00 
  8002fe:	be 3c 00 00 00       	mov    $0x3c,%esi
  800303:	48 bf 82 40 80 00 00 	movabs $0x804082,%rdi
  80030a:	00 00 00 
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  800319:	00 00 00 
  80031c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80031f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800323:	48 89 c7             	mov    %rax,%rdi
  800326:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	83 f8 04             	cmp    $0x4,%eax
  80034c:	74 1d                	je     80036b <umain+0x328>
		cprintf("\nchild detected race\n");
  80034e:	48 bf 2a 41 80 00 00 	movabs $0x80412a,%rdi
  800355:	00 00 00 
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  800364:	00 00 00 
  800367:	ff d2                	callq  *%rdx
  800369:	eb 20                	jmp    80038b <umain+0x348>
	else
		cprintf("\nrace didn't happen\n", max);
  80036b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80036e:	89 c6                	mov    %eax,%esi
  800370:	48 bf 40 41 80 00 00 	movabs $0x804140,%rdi
  800377:	00 00 00 
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  800386:	00 00 00 
  800389:	ff d2                	callq  *%rdx
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 20          	sub    $0x20,%rsp
  800395:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800398:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80039c:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8003ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b3:	48 63 d0             	movslq %eax,%rdx
  8003b6:	48 89 d0             	mov    %rdx,%rax
  8003b9:	48 c1 e0 03          	shl    $0x3,%rax
  8003bd:	48 01 d0             	add    %rdx,%rax
  8003c0:	48 c1 e0 05          	shl    $0x5,%rax
  8003c4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8003cb:	00 00 00 
  8003ce:	48 01 c2             	add    %rax,%rdx
  8003d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003d8:	00 00 00 
  8003db:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003e2:	7e 14                	jle    8003f8 <libmain+0x6b>
		binaryname = argv[0];
  8003e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003e8:	48 8b 10             	mov    (%rax),%rdx
  8003eb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003f2:	00 00 00 
  8003f5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8003fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003ff:	48 89 d6             	mov    %rdx,%rsi
  800402:	89 c7                	mov    %eax,%edi
  800404:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80040b:	00 00 00 
  80040e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800410:	48 b8 1e 04 80 00 00 	movabs $0x80041e,%rax
  800417:	00 00 00 
  80041a:	ff d0                	callq  *%rax
}
  80041c:	c9                   	leaveq 
  80041d:	c3                   	retq   

000000000080041e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80041e:	55                   	push   %rbp
  80041f:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800422:	48 b8 04 29 80 00 00 	movabs $0x802904,%rax
  800429:	00 00 00 
  80042c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80042e:	bf 00 00 00 00       	mov    $0x0,%edi
  800433:	48 b8 b1 1a 80 00 00 	movabs $0x801ab1,%rax
  80043a:	00 00 00 
  80043d:	ff d0                	callq  *%rax
}
  80043f:	5d                   	pop    %rbp
  800440:	c3                   	retq   

0000000000800441 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800441:	55                   	push   %rbp
  800442:	48 89 e5             	mov    %rsp,%rbp
  800445:	53                   	push   %rbx
  800446:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80044d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800454:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80045a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800461:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800468:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80046f:	84 c0                	test   %al,%al
  800471:	74 23                	je     800496 <_panic+0x55>
  800473:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80047a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80047e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800482:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800486:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80048a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80048e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800492:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800496:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80049d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004a4:	00 00 00 
  8004a7:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004ae:	00 00 00 
  8004b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004bc:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004c3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004ca:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004d1:	00 00 00 
  8004d4:	48 8b 18             	mov    (%rax),%rbx
  8004d7:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  8004de:	00 00 00 
  8004e1:	ff d0                	callq  *%rax
  8004e3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004e9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004f0:	41 89 c8             	mov    %ecx,%r8d
  8004f3:	48 89 d1             	mov    %rdx,%rcx
  8004f6:	48 89 da             	mov    %rbx,%rdx
  8004f9:	89 c6                	mov    %eax,%esi
  8004fb:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	49 b9 7a 06 80 00 00 	movabs $0x80067a,%r9
  800511:	00 00 00 
  800514:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800517:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80051e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800525:	48 89 d6             	mov    %rdx,%rsi
  800528:	48 89 c7             	mov    %rax,%rdi
  80052b:	48 b8 ce 05 80 00 00 	movabs $0x8005ce,%rax
  800532:	00 00 00 
  800535:	ff d0                	callq  *%rax
	cprintf("\n");
  800537:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
  80053e:	00 00 00 
  800541:	b8 00 00 00 00       	mov    $0x0,%eax
  800546:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  80054d:	00 00 00 
  800550:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800552:	cc                   	int3   
  800553:	eb fd                	jmp    800552 <_panic+0x111>

0000000000800555 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800555:	55                   	push   %rbp
  800556:	48 89 e5             	mov    %rsp,%rbp
  800559:	48 83 ec 10          	sub    $0x10,%rsp
  80055d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800560:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800568:	8b 00                	mov    (%rax),%eax
  80056a:	8d 48 01             	lea    0x1(%rax),%ecx
  80056d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800571:	89 0a                	mov    %ecx,(%rdx)
  800573:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800576:	89 d1                	mov    %edx,%ecx
  800578:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057c:	48 98                	cltq   
  80057e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058d:	75 2c                	jne    8005bb <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80058f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800593:	8b 00                	mov    (%rax),%eax
  800595:	48 98                	cltq   
  800597:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80059b:	48 83 c2 08          	add    $0x8,%rdx
  80059f:	48 89 c6             	mov    %rax,%rsi
  8005a2:	48 89 d7             	mov    %rdx,%rdi
  8005a5:	48 b8 29 1a 80 00 00 	movabs $0x801a29,%rax
  8005ac:	00 00 00 
  8005af:	ff d0                	callq  *%rax
        b->idx = 0;
  8005b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005bf:	8b 40 04             	mov    0x4(%rax),%eax
  8005c2:	8d 50 01             	lea    0x1(%rax),%edx
  8005c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005cc:	c9                   	leaveq 
  8005cd:	c3                   	retq   

00000000008005ce <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005e0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005e7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ee:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005f5:	48 8b 0a             	mov    (%rdx),%rcx
  8005f8:	48 89 08             	mov    %rcx,(%rax)
  8005fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800603:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800607:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80060b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800612:	00 00 00 
    b.cnt = 0;
  800615:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80061c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80061f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800626:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80062d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800634:	48 89 c6             	mov    %rax,%rsi
  800637:	48 bf 55 05 80 00 00 	movabs $0x800555,%rdi
  80063e:	00 00 00 
  800641:	48 b8 2d 0a 80 00 00 	movabs $0x800a2d,%rax
  800648:	00 00 00 
  80064b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80064d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800653:	48 98                	cltq   
  800655:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80065c:	48 83 c2 08          	add    $0x8,%rdx
  800660:	48 89 c6             	mov    %rax,%rsi
  800663:	48 89 d7             	mov    %rdx,%rdi
  800666:	48 b8 29 1a 80 00 00 	movabs $0x801a29,%rax
  80066d:	00 00 00 
  800670:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800672:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800678:	c9                   	leaveq 
  800679:	c3                   	retq   

000000000080067a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80067a:	55                   	push   %rbp
  80067b:	48 89 e5             	mov    %rsp,%rbp
  80067e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800685:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80068c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800693:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80069a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006a1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006a8:	84 c0                	test   %al,%al
  8006aa:	74 20                	je     8006cc <cprintf+0x52>
  8006ac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006b0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006b4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006b8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006bc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006c0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006c4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006c8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006d3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006da:	00 00 00 
  8006dd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006e4:	00 00 00 
  8006e7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006eb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006f2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800700:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800707:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80070e:	48 8b 0a             	mov    (%rdx),%rcx
  800711:	48 89 08             	mov    %rcx,(%rax)
  800714:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800718:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800720:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800724:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80072b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800732:	48 89 d6             	mov    %rdx,%rsi
  800735:	48 89 c7             	mov    %rax,%rdi
  800738:	48 b8 ce 05 80 00 00 	movabs $0x8005ce,%rax
  80073f:	00 00 00 
  800742:	ff d0                	callq  *%rax
  800744:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80074a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800750:	c9                   	leaveq 
  800751:	c3                   	retq   

0000000000800752 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	53                   	push   %rbx
  800757:	48 83 ec 38          	sub    $0x38,%rsp
  80075b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800767:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80076a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80076e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800772:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800775:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800779:	77 3b                	ja     8007b6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80077b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80077e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800782:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	48 f7 f3             	div    %rbx
  800791:	48 89 c2             	mov    %rax,%rdx
  800794:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800797:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80079a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80079e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a2:	41 89 f9             	mov    %edi,%r9d
  8007a5:	48 89 c7             	mov    %rax,%rdi
  8007a8:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  8007af:	00 00 00 
  8007b2:	ff d0                	callq  *%rax
  8007b4:	eb 1e                	jmp    8007d4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b6:	eb 12                	jmp    8007ca <printnum+0x78>
			putch(padc, putdat);
  8007b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007bc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 89 ce             	mov    %rcx,%rsi
  8007c6:	89 d7                	mov    %edx,%edi
  8007c8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ca:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007d2:	7f e4                	jg     8007b8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007db:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e0:	48 f7 f1             	div    %rcx
  8007e3:	48 89 d0             	mov    %rdx,%rax
  8007e6:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
  8007ed:	00 00 00 
  8007f0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007f4:	0f be d0             	movsbl %al,%edx
  8007f7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	48 89 ce             	mov    %rcx,%rsi
  800802:	89 d7                	mov    %edx,%edi
  800804:	ff d0                	callq  *%rax
}
  800806:	48 83 c4 38          	add    $0x38,%rsp
  80080a:	5b                   	pop    %rbx
  80080b:	5d                   	pop    %rbp
  80080c:	c3                   	retq   

000000000080080d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80080d:	55                   	push   %rbp
  80080e:	48 89 e5             	mov    %rsp,%rbp
  800811:	48 83 ec 1c          	sub    $0x1c,%rsp
  800815:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800819:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80081c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800820:	7e 52                	jle    800874 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	8b 00                	mov    (%rax),%eax
  800828:	83 f8 30             	cmp    $0x30,%eax
  80082b:	73 24                	jae    800851 <getuint+0x44>
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	89 c0                	mov    %eax,%eax
  80083d:	48 01 d0             	add    %rdx,%rax
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	8b 12                	mov    (%rdx),%edx
  800846:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	89 0a                	mov    %ecx,(%rdx)
  80084f:	eb 17                	jmp    800868 <getuint+0x5b>
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800859:	48 89 d0             	mov    %rdx,%rax
  80085c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800860:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800864:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800868:	48 8b 00             	mov    (%rax),%rax
  80086b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086f:	e9 a3 00 00 00       	jmpq   800917 <getuint+0x10a>
	else if (lflag)
  800874:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800878:	74 4f                	je     8008c9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80087a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087e:	8b 00                	mov    (%rax),%eax
  800880:	83 f8 30             	cmp    $0x30,%eax
  800883:	73 24                	jae    8008a9 <getuint+0x9c>
  800885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800889:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	8b 00                	mov    (%rax),%eax
  800893:	89 c0                	mov    %eax,%eax
  800895:	48 01 d0             	add    %rdx,%rax
  800898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089c:	8b 12                	mov    (%rdx),%edx
  80089e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a5:	89 0a                	mov    %ecx,(%rdx)
  8008a7:	eb 17                	jmp    8008c0 <getuint+0xb3>
  8008a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b1:	48 89 d0             	mov    %rdx,%rax
  8008b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008c0:	48 8b 00             	mov    (%rax),%rax
  8008c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c7:	eb 4e                	jmp    800917 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cd:	8b 00                	mov    (%rax),%eax
  8008cf:	83 f8 30             	cmp    $0x30,%eax
  8008d2:	73 24                	jae    8008f8 <getuint+0xeb>
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	8b 00                	mov    (%rax),%eax
  8008e2:	89 c0                	mov    %eax,%eax
  8008e4:	48 01 d0             	add    %rdx,%rax
  8008e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008eb:	8b 12                	mov    (%rdx),%edx
  8008ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f4:	89 0a                	mov    %ecx,(%rdx)
  8008f6:	eb 17                	jmp    80090f <getuint+0x102>
  8008f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800900:	48 89 d0             	mov    %rdx,%rax
  800903:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800907:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090f:	8b 00                	mov    (%rax),%eax
  800911:	89 c0                	mov    %eax,%eax
  800913:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80091b:	c9                   	leaveq 
  80091c:	c3                   	retq   

000000000080091d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091d:	55                   	push   %rbp
  80091e:	48 89 e5             	mov    %rsp,%rbp
  800921:	48 83 ec 1c          	sub    $0x1c,%rsp
  800925:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800929:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80092c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800930:	7e 52                	jle    800984 <getint+0x67>
		x=va_arg(*ap, long long);
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	8b 00                	mov    (%rax),%eax
  800938:	83 f8 30             	cmp    $0x30,%eax
  80093b:	73 24                	jae    800961 <getint+0x44>
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	8b 00                	mov    (%rax),%eax
  80094b:	89 c0                	mov    %eax,%eax
  80094d:	48 01 d0             	add    %rdx,%rax
  800950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800954:	8b 12                	mov    (%rdx),%edx
  800956:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	89 0a                	mov    %ecx,(%rdx)
  80095f:	eb 17                	jmp    800978 <getint+0x5b>
  800961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800965:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800969:	48 89 d0             	mov    %rdx,%rax
  80096c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800978:	48 8b 00             	mov    (%rax),%rax
  80097b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097f:	e9 a3 00 00 00       	jmpq   800a27 <getint+0x10a>
	else if (lflag)
  800984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800988:	74 4f                	je     8009d9 <getint+0xbc>
		x=va_arg(*ap, long);
  80098a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098e:	8b 00                	mov    (%rax),%eax
  800990:	83 f8 30             	cmp    $0x30,%eax
  800993:	73 24                	jae    8009b9 <getint+0x9c>
  800995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800999:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	8b 00                	mov    (%rax),%eax
  8009a3:	89 c0                	mov    %eax,%eax
  8009a5:	48 01 d0             	add    %rdx,%rax
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	8b 12                	mov    (%rdx),%edx
  8009ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b5:	89 0a                	mov    %ecx,(%rdx)
  8009b7:	eb 17                	jmp    8009d0 <getint+0xb3>
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009c1:	48 89 d0             	mov    %rdx,%rax
  8009c4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d0:	48 8b 00             	mov    (%rax),%rax
  8009d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d7:	eb 4e                	jmp    800a27 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	8b 00                	mov    (%rax),%eax
  8009df:	83 f8 30             	cmp    $0x30,%eax
  8009e2:	73 24                	jae    800a08 <getint+0xeb>
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f0:	8b 00                	mov    (%rax),%eax
  8009f2:	89 c0                	mov    %eax,%eax
  8009f4:	48 01 d0             	add    %rdx,%rax
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	8b 12                	mov    (%rdx),%edx
  8009fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a04:	89 0a                	mov    %ecx,(%rdx)
  800a06:	eb 17                	jmp    800a1f <getint+0x102>
  800a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a10:	48 89 d0             	mov    %rdx,%rax
  800a13:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1f:	8b 00                	mov    (%rax),%eax
  800a21:	48 98                	cltq   
  800a23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a2b:	c9                   	leaveq 
  800a2c:	c3                   	retq   

0000000000800a2d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2d:	55                   	push   %rbp
  800a2e:	48 89 e5             	mov    %rsp,%rbp
  800a31:	41 54                	push   %r12
  800a33:	53                   	push   %rbx
  800a34:	48 83 ec 60          	sub    $0x60,%rsp
  800a38:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a3c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a40:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a44:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a50:	48 8b 0a             	mov    (%rdx),%rcx
  800a53:	48 89 08             	mov    %rcx,(%rax)
  800a56:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a5a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a5e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a62:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a66:	eb 17                	jmp    800a7f <vprintfmt+0x52>
			if (ch == '\0')
  800a68:	85 db                	test   %ebx,%ebx
  800a6a:	0f 84 df 04 00 00    	je     800f4f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800a70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a78:	48 89 d6             	mov    %rdx,%rsi
  800a7b:	89 df                	mov    %ebx,%edi
  800a7d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a83:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a87:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a8b:	0f b6 00             	movzbl (%rax),%eax
  800a8e:	0f b6 d8             	movzbl %al,%ebx
  800a91:	83 fb 25             	cmp    $0x25,%ebx
  800a94:	75 d2                	jne    800a68 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a96:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a9a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800aa1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800aa8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aaf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ab6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800abe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ac2:	0f b6 00             	movzbl (%rax),%eax
  800ac5:	0f b6 d8             	movzbl %al,%ebx
  800ac8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800acb:	83 f8 55             	cmp    $0x55,%eax
  800ace:	0f 87 47 04 00 00    	ja     800f1b <vprintfmt+0x4ee>
  800ad4:	89 c0                	mov    %eax,%eax
  800ad6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800add:	00 
  800ade:	48 b8 b8 43 80 00 00 	movabs $0x8043b8,%rax
  800ae5:	00 00 00 
  800ae8:	48 01 d0             	add    %rdx,%rax
  800aeb:	48 8b 00             	mov    (%rax),%rax
  800aee:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800af0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800af4:	eb c0                	jmp    800ab6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800afa:	eb ba                	jmp    800ab6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800afc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b03:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b06:	89 d0                	mov    %edx,%eax
  800b08:	c1 e0 02             	shl    $0x2,%eax
  800b0b:	01 d0                	add    %edx,%eax
  800b0d:	01 c0                	add    %eax,%eax
  800b0f:	01 d8                	add    %ebx,%eax
  800b11:	83 e8 30             	sub    $0x30,%eax
  800b14:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1b:	0f b6 00             	movzbl (%rax),%eax
  800b1e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b21:	83 fb 2f             	cmp    $0x2f,%ebx
  800b24:	7e 0c                	jle    800b32 <vprintfmt+0x105>
  800b26:	83 fb 39             	cmp    $0x39,%ebx
  800b29:	7f 07                	jg     800b32 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b30:	eb d1                	jmp    800b03 <vprintfmt+0xd6>
			goto process_precision;
  800b32:	eb 58                	jmp    800b8c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b37:	83 f8 30             	cmp    $0x30,%eax
  800b3a:	73 17                	jae    800b53 <vprintfmt+0x126>
  800b3c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b43:	89 c0                	mov    %eax,%eax
  800b45:	48 01 d0             	add    %rdx,%rax
  800b48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4b:	83 c2 08             	add    $0x8,%edx
  800b4e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b51:	eb 0f                	jmp    800b62 <vprintfmt+0x135>
  800b53:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b57:	48 89 d0             	mov    %rdx,%rax
  800b5a:	48 83 c2 08          	add    $0x8,%rdx
  800b5e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b62:	8b 00                	mov    (%rax),%eax
  800b64:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b67:	eb 23                	jmp    800b8c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b69:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6d:	79 0c                	jns    800b7b <vprintfmt+0x14e>
				width = 0;
  800b6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b76:	e9 3b ff ff ff       	jmpq   800ab6 <vprintfmt+0x89>
  800b7b:	e9 36 ff ff ff       	jmpq   800ab6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b80:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b87:	e9 2a ff ff ff       	jmpq   800ab6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b90:	79 12                	jns    800ba4 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b92:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b95:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b98:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b9f:	e9 12 ff ff ff       	jmpq   800ab6 <vprintfmt+0x89>
  800ba4:	e9 0d ff ff ff       	jmpq   800ab6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bad:	e9 04 ff ff ff       	jmpq   800ab6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb5:	83 f8 30             	cmp    $0x30,%eax
  800bb8:	73 17                	jae    800bd1 <vprintfmt+0x1a4>
  800bba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc1:	89 c0                	mov    %eax,%eax
  800bc3:	48 01 d0             	add    %rdx,%rax
  800bc6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bc9:	83 c2 08             	add    $0x8,%edx
  800bcc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bcf:	eb 0f                	jmp    800be0 <vprintfmt+0x1b3>
  800bd1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd5:	48 89 d0             	mov    %rdx,%rax
  800bd8:	48 83 c2 08          	add    $0x8,%rdx
  800bdc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be0:	8b 10                	mov    (%rax),%edx
  800be2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bea:	48 89 ce             	mov    %rcx,%rsi
  800bed:	89 d7                	mov    %edx,%edi
  800bef:	ff d0                	callq  *%rax
			break;
  800bf1:	e9 53 03 00 00       	jmpq   800f49 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bf6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf9:	83 f8 30             	cmp    $0x30,%eax
  800bfc:	73 17                	jae    800c15 <vprintfmt+0x1e8>
  800bfe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c05:	89 c0                	mov    %eax,%eax
  800c07:	48 01 d0             	add    %rdx,%rax
  800c0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c0d:	83 c2 08             	add    $0x8,%edx
  800c10:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c13:	eb 0f                	jmp    800c24 <vprintfmt+0x1f7>
  800c15:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c19:	48 89 d0             	mov    %rdx,%rax
  800c1c:	48 83 c2 08          	add    $0x8,%rdx
  800c20:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c24:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c26:	85 db                	test   %ebx,%ebx
  800c28:	79 02                	jns    800c2c <vprintfmt+0x1ff>
				err = -err;
  800c2a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c2c:	83 fb 15             	cmp    $0x15,%ebx
  800c2f:	7f 16                	jg     800c47 <vprintfmt+0x21a>
  800c31:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
  800c38:	00 00 00 
  800c3b:	48 63 d3             	movslq %ebx,%rdx
  800c3e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c42:	4d 85 e4             	test   %r12,%r12
  800c45:	75 2e                	jne    800c75 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c47:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4f:	89 d9                	mov    %ebx,%ecx
  800c51:	48 ba a1 43 80 00 00 	movabs $0x8043a1,%rdx
  800c58:	00 00 00 
  800c5b:	48 89 c7             	mov    %rax,%rdi
  800c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c63:	49 b8 58 0f 80 00 00 	movabs $0x800f58,%r8
  800c6a:	00 00 00 
  800c6d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c70:	e9 d4 02 00 00       	jmpq   800f49 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c75:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7d:	4c 89 e1             	mov    %r12,%rcx
  800c80:	48 ba aa 43 80 00 00 	movabs $0x8043aa,%rdx
  800c87:	00 00 00 
  800c8a:	48 89 c7             	mov    %rax,%rdi
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c92:	49 b8 58 0f 80 00 00 	movabs $0x800f58,%r8
  800c99:	00 00 00 
  800c9c:	41 ff d0             	callq  *%r8
			break;
  800c9f:	e9 a5 02 00 00       	jmpq   800f49 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ca4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca7:	83 f8 30             	cmp    $0x30,%eax
  800caa:	73 17                	jae    800cc3 <vprintfmt+0x296>
  800cac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb3:	89 c0                	mov    %eax,%eax
  800cb5:	48 01 d0             	add    %rdx,%rax
  800cb8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cbb:	83 c2 08             	add    $0x8,%edx
  800cbe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc1:	eb 0f                	jmp    800cd2 <vprintfmt+0x2a5>
  800cc3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc7:	48 89 d0             	mov    %rdx,%rax
  800cca:	48 83 c2 08          	add    $0x8,%rdx
  800cce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd2:	4c 8b 20             	mov    (%rax),%r12
  800cd5:	4d 85 e4             	test   %r12,%r12
  800cd8:	75 0a                	jne    800ce4 <vprintfmt+0x2b7>
				p = "(null)";
  800cda:	49 bc ad 43 80 00 00 	movabs $0x8043ad,%r12
  800ce1:	00 00 00 
			if (width > 0 && padc != '-')
  800ce4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce8:	7e 3f                	jle    800d29 <vprintfmt+0x2fc>
  800cea:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cee:	74 39                	je     800d29 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cf3:	48 98                	cltq   
  800cf5:	48 89 c6             	mov    %rax,%rsi
  800cf8:	4c 89 e7             	mov    %r12,%rdi
  800cfb:	48 b8 04 12 80 00 00 	movabs $0x801204,%rax
  800d02:	00 00 00 
  800d05:	ff d0                	callq  *%rax
  800d07:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d0a:	eb 17                	jmp    800d23 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d0c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d10:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d18:	48 89 ce             	mov    %rcx,%rsi
  800d1b:	89 d7                	mov    %edx,%edi
  800d1d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d23:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d27:	7f e3                	jg     800d0c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d29:	eb 37                	jmp    800d62 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d2b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d2f:	74 1e                	je     800d4f <vprintfmt+0x322>
  800d31:	83 fb 1f             	cmp    $0x1f,%ebx
  800d34:	7e 05                	jle    800d3b <vprintfmt+0x30e>
  800d36:	83 fb 7e             	cmp    $0x7e,%ebx
  800d39:	7e 14                	jle    800d4f <vprintfmt+0x322>
					putch('?', putdat);
  800d3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d43:	48 89 d6             	mov    %rdx,%rsi
  800d46:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d4b:	ff d0                	callq  *%rax
  800d4d:	eb 0f                	jmp    800d5e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d57:	48 89 d6             	mov    %rdx,%rsi
  800d5a:	89 df                	mov    %ebx,%edi
  800d5c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d5e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d62:	4c 89 e0             	mov    %r12,%rax
  800d65:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d69:	0f b6 00             	movzbl (%rax),%eax
  800d6c:	0f be d8             	movsbl %al,%ebx
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	74 10                	je     800d83 <vprintfmt+0x356>
  800d73:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d77:	78 b2                	js     800d2b <vprintfmt+0x2fe>
  800d79:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d7d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d81:	79 a8                	jns    800d2b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d83:	eb 16                	jmp    800d9b <vprintfmt+0x36e>
				putch(' ', putdat);
  800d85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8d:	48 89 d6             	mov    %rdx,%rsi
  800d90:	bf 20 00 00 00       	mov    $0x20,%edi
  800d95:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d97:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d9f:	7f e4                	jg     800d85 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800da1:	e9 a3 01 00 00       	jmpq   800f49 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800da6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800daa:	be 03 00 00 00       	mov    $0x3,%esi
  800daf:	48 89 c7             	mov    %rax,%rdi
  800db2:	48 b8 1d 09 80 00 00 	movabs $0x80091d,%rax
  800db9:	00 00 00 
  800dbc:	ff d0                	callq  *%rax
  800dbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc6:	48 85 c0             	test   %rax,%rax
  800dc9:	79 1d                	jns    800de8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800dcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd3:	48 89 d6             	mov    %rdx,%rsi
  800dd6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ddb:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ddd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de1:	48 f7 d8             	neg    %rax
  800de4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800de8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800def:	e9 e8 00 00 00       	jmpq   800edc <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800df4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df8:	be 03 00 00 00       	mov    $0x3,%esi
  800dfd:	48 89 c7             	mov    %rax,%rdi
  800e00:	48 b8 0d 08 80 00 00 	movabs $0x80080d,%rax
  800e07:	00 00 00 
  800e0a:	ff d0                	callq  *%rax
  800e0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e10:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e17:	e9 c0 00 00 00       	jmpq   800edc <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e24:	48 89 d6             	mov    %rdx,%rsi
  800e27:	bf 58 00 00 00       	mov    $0x58,%edi
  800e2c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e36:	48 89 d6             	mov    %rdx,%rsi
  800e39:	bf 58 00 00 00       	mov    $0x58,%edi
  800e3e:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e48:	48 89 d6             	mov    %rdx,%rsi
  800e4b:	bf 58 00 00 00       	mov    $0x58,%edi
  800e50:	ff d0                	callq  *%rax
			break;
  800e52:	e9 f2 00 00 00       	jmpq   800f49 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5f:	48 89 d6             	mov    %rdx,%rsi
  800e62:	bf 30 00 00 00       	mov    $0x30,%edi
  800e67:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e71:	48 89 d6             	mov    %rdx,%rsi
  800e74:	bf 78 00 00 00       	mov    $0x78,%edi
  800e79:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e7e:	83 f8 30             	cmp    $0x30,%eax
  800e81:	73 17                	jae    800e9a <vprintfmt+0x46d>
  800e83:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e8a:	89 c0                	mov    %eax,%eax
  800e8c:	48 01 d0             	add    %rdx,%rax
  800e8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e92:	83 c2 08             	add    $0x8,%edx
  800e95:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e98:	eb 0f                	jmp    800ea9 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800e9a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e9e:	48 89 d0             	mov    %rdx,%rax
  800ea1:	48 83 c2 08          	add    $0x8,%rdx
  800ea5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ea9:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800eb0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800eb7:	eb 23                	jmp    800edc <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800eb9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ebd:	be 03 00 00 00       	mov    $0x3,%esi
  800ec2:	48 89 c7             	mov    %rax,%rdi
  800ec5:	48 b8 0d 08 80 00 00 	movabs $0x80080d,%rax
  800ecc:	00 00 00 
  800ecf:	ff d0                	callq  *%rax
  800ed1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ed5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800edc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ee1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ee4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ee7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eeb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef3:	45 89 c1             	mov    %r8d,%r9d
  800ef6:	41 89 f8             	mov    %edi,%r8d
  800ef9:	48 89 c7             	mov    %rax,%rdi
  800efc:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  800f03:	00 00 00 
  800f06:	ff d0                	callq  *%rax
			break;
  800f08:	eb 3f                	jmp    800f49 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f12:	48 89 d6             	mov    %rdx,%rsi
  800f15:	89 df                	mov    %ebx,%edi
  800f17:	ff d0                	callq  *%rax
			break;
  800f19:	eb 2e                	jmp    800f49 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f23:	48 89 d6             	mov    %rdx,%rsi
  800f26:	bf 25 00 00 00       	mov    $0x25,%edi
  800f2b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f2d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f32:	eb 05                	jmp    800f39 <vprintfmt+0x50c>
  800f34:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f39:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f3d:	48 83 e8 01          	sub    $0x1,%rax
  800f41:	0f b6 00             	movzbl (%rax),%eax
  800f44:	3c 25                	cmp    $0x25,%al
  800f46:	75 ec                	jne    800f34 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800f48:	90                   	nop
		}
	}
  800f49:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4a:	e9 30 fb ff ff       	jmpq   800a7f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f4f:	48 83 c4 60          	add    $0x60,%rsp
  800f53:	5b                   	pop    %rbx
  800f54:	41 5c                	pop    %r12
  800f56:	5d                   	pop    %rbp
  800f57:	c3                   	retq   

0000000000800f58 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f58:	55                   	push   %rbp
  800f59:	48 89 e5             	mov    %rsp,%rbp
  800f5c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f63:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f6a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f71:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f78:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f7f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f86:	84 c0                	test   %al,%al
  800f88:	74 20                	je     800faa <printfmt+0x52>
  800f8a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f92:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f96:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f9a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800faa:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fb1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fb8:	00 00 00 
  800fbb:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fc2:	00 00 00 
  800fc5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fd0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fde:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fe5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fec:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ff3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ffa:	48 89 c7             	mov    %rax,%rdi
  800ffd:	48 b8 2d 0a 80 00 00 	movabs $0x800a2d,%rax
  801004:	00 00 00 
  801007:	ff d0                	callq  *%rax
	va_end(ap);
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 10          	sub    $0x10,%rsp
  801013:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801016:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80101a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101e:	8b 40 10             	mov    0x10(%rax),%eax
  801021:	8d 50 01             	lea    0x1(%rax),%edx
  801024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801028:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80102b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102f:	48 8b 10             	mov    (%rax),%rdx
  801032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801036:	48 8b 40 08          	mov    0x8(%rax),%rax
  80103a:	48 39 c2             	cmp    %rax,%rdx
  80103d:	73 17                	jae    801056 <sprintputch+0x4b>
		*b->buf++ = ch;
  80103f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801043:	48 8b 00             	mov    (%rax),%rax
  801046:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80104a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80104e:	48 89 0a             	mov    %rcx,(%rdx)
  801051:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801054:	88 10                	mov    %dl,(%rax)
}
  801056:	c9                   	leaveq 
  801057:	c3                   	retq   

0000000000801058 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801058:	55                   	push   %rbp
  801059:	48 89 e5             	mov    %rsp,%rbp
  80105c:	48 83 ec 50          	sub    $0x50,%rsp
  801060:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801064:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801067:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80106b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80106f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801073:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801077:	48 8b 0a             	mov    (%rdx),%rcx
  80107a:	48 89 08             	mov    %rcx,(%rax)
  80107d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801081:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801085:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801089:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80108d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801091:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801095:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801098:	48 98                	cltq   
  80109a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80109e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010a2:	48 01 d0             	add    %rdx,%rax
  8010a5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010b0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010b5:	74 06                	je     8010bd <vsnprintf+0x65>
  8010b7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010bb:	7f 07                	jg     8010c4 <vsnprintf+0x6c>
		return -E_INVAL;
  8010bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c2:	eb 2f                	jmp    8010f3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010c4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010c8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010cc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010d0:	48 89 c6             	mov    %rax,%rsi
  8010d3:	48 bf 0b 10 80 00 00 	movabs $0x80100b,%rdi
  8010da:	00 00 00 
  8010dd:	48 b8 2d 0a 80 00 00 	movabs $0x800a2d,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010ed:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010f0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010f3:	c9                   	leaveq 
  8010f4:	c3                   	retq   

00000000008010f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010f5:	55                   	push   %rbp
  8010f6:	48 89 e5             	mov    %rsp,%rbp
  8010f9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801100:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801107:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80110d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801114:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80111b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801122:	84 c0                	test   %al,%al
  801124:	74 20                	je     801146 <snprintf+0x51>
  801126:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80112a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80112e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801132:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801136:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80113a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80113e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801142:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801146:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80114d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801154:	00 00 00 
  801157:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80115e:	00 00 00 
  801161:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801165:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80116c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801173:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80117a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801181:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801188:	48 8b 0a             	mov    (%rdx),%rcx
  80118b:	48 89 08             	mov    %rcx,(%rax)
  80118e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801192:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801196:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80119a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80119e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011a5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011ac:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011b2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011b9:	48 89 c7             	mov    %rax,%rdi
  8011bc:	48 b8 58 10 80 00 00 	movabs $0x801058,%rax
  8011c3:	00 00 00 
  8011c6:	ff d0                	callq  *%rax
  8011c8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011ce:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 18          	sub    $0x18,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011e9:	eb 09                	jmp    8011f4 <strlen+0x1e>
		n++;
  8011eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ef:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f8:	0f b6 00             	movzbl (%rax),%eax
  8011fb:	84 c0                	test   %al,%al
  8011fd:	75 ec                	jne    8011eb <strlen+0x15>
		n++;
	return n;
  8011ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801202:	c9                   	leaveq 
  801203:	c3                   	retq   

0000000000801204 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801204:	55                   	push   %rbp
  801205:	48 89 e5             	mov    %rsp,%rbp
  801208:	48 83 ec 20          	sub    $0x20,%rsp
  80120c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801210:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801214:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80121b:	eb 0e                	jmp    80122b <strnlen+0x27>
		n++;
  80121d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801221:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801226:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80122b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801230:	74 0b                	je     80123d <strnlen+0x39>
  801232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	84 c0                	test   %al,%al
  80123b:	75 e0                	jne    80121d <strnlen+0x19>
		n++;
	return n;
  80123d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801240:	c9                   	leaveq 
  801241:	c3                   	retq   

0000000000801242 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801242:	55                   	push   %rbp
  801243:	48 89 e5             	mov    %rsp,%rbp
  801246:	48 83 ec 20          	sub    $0x20,%rsp
  80124a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801256:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80125a:	90                   	nop
  80125b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801263:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801267:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80126f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801273:	0f b6 12             	movzbl (%rdx),%edx
  801276:	88 10                	mov    %dl,(%rax)
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	84 c0                	test   %al,%al
  80127d:	75 dc                	jne    80125b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801283:	c9                   	leaveq 
  801284:	c3                   	retq   

0000000000801285 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801285:	55                   	push   %rbp
  801286:	48 89 e5             	mov    %rsp,%rbp
  801289:	48 83 ec 20          	sub    $0x20,%rsp
  80128d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801291:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801295:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801299:	48 89 c7             	mov    %rax,%rdi
  80129c:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  8012a3:	00 00 00 
  8012a6:	ff d0                	callq  *%rax
  8012a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ae:	48 63 d0             	movslq %eax,%rdx
  8012b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b5:	48 01 c2             	add    %rax,%rdx
  8012b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bc:	48 89 c6             	mov    %rax,%rsi
  8012bf:	48 89 d7             	mov    %rdx,%rdi
  8012c2:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  8012c9:	00 00 00 
  8012cc:	ff d0                	callq  *%rax
	return dst;
  8012ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 83 ec 28          	sub    $0x28,%rsp
  8012dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012f0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012f7:	00 
  8012f8:	eb 2a                	jmp    801324 <strncpy+0x50>
		*dst++ = *src;
  8012fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801302:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801306:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80130a:	0f b6 12             	movzbl (%rdx),%edx
  80130d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80130f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	84 c0                	test   %al,%al
  801318:	74 05                	je     80131f <strncpy+0x4b>
			src++;
  80131a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80131f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801328:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80132c:	72 cc                	jb     8012fa <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80132e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801332:	c9                   	leaveq 
  801333:	c3                   	retq   

0000000000801334 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801334:	55                   	push   %rbp
  801335:	48 89 e5             	mov    %rsp,%rbp
  801338:	48 83 ec 28          	sub    $0x28,%rsp
  80133c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801340:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801344:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801350:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801355:	74 3d                	je     801394 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801357:	eb 1d                	jmp    801376 <strlcpy+0x42>
			*dst++ = *src++;
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801361:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801365:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801369:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80136d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801371:	0f b6 12             	movzbl (%rdx),%edx
  801374:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801376:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80137b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801380:	74 0b                	je     80138d <strlcpy+0x59>
  801382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	84 c0                	test   %al,%al
  80138b:	75 cc                	jne    801359 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801391:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801394:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139c:	48 29 c2             	sub    %rax,%rdx
  80139f:	48 89 d0             	mov    %rdx,%rax
}
  8013a2:	c9                   	leaveq 
  8013a3:	c3                   	retq   

00000000008013a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013a4:	55                   	push   %rbp
  8013a5:	48 89 e5             	mov    %rsp,%rbp
  8013a8:	48 83 ec 10          	sub    $0x10,%rsp
  8013ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013b4:	eb 0a                	jmp    8013c0 <strcmp+0x1c>
		p++, q++;
  8013b6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	84 c0                	test   %al,%al
  8013c9:	74 12                	je     8013dd <strcmp+0x39>
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cf:	0f b6 10             	movzbl (%rax),%edx
  8013d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d6:	0f b6 00             	movzbl (%rax),%eax
  8013d9:	38 c2                	cmp    %al,%dl
  8013db:	74 d9                	je     8013b6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	0f b6 d0             	movzbl %al,%edx
  8013e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	0f b6 c0             	movzbl %al,%eax
  8013f1:	29 c2                	sub    %eax,%edx
  8013f3:	89 d0                	mov    %edx,%eax
}
  8013f5:	c9                   	leaveq 
  8013f6:	c3                   	retq   

00000000008013f7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013f7:	55                   	push   %rbp
  8013f8:	48 89 e5             	mov    %rsp,%rbp
  8013fb:	48 83 ec 18          	sub    $0x18,%rsp
  8013ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801403:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801407:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80140b:	eb 0f                	jmp    80141c <strncmp+0x25>
		n--, p++, q++;
  80140d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801412:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801417:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80141c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801421:	74 1d                	je     801440 <strncmp+0x49>
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	84 c0                	test   %al,%al
  80142c:	74 12                	je     801440 <strncmp+0x49>
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	0f b6 10             	movzbl (%rax),%edx
  801435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	38 c2                	cmp    %al,%dl
  80143e:	74 cd                	je     80140d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801440:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801445:	75 07                	jne    80144e <strncmp+0x57>
		return 0;
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
  80144c:	eb 18                	jmp    801466 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	0f b6 d0             	movzbl %al,%edx
  801458:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145c:	0f b6 00             	movzbl (%rax),%eax
  80145f:	0f b6 c0             	movzbl %al,%eax
  801462:	29 c2                	sub    %eax,%edx
  801464:	89 d0                	mov    %edx,%eax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 0c          	sub    $0xc,%rsp
  801470:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801474:	89 f0                	mov    %esi,%eax
  801476:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801479:	eb 17                	jmp    801492 <strchr+0x2a>
		if (*s == c)
  80147b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147f:	0f b6 00             	movzbl (%rax),%eax
  801482:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801485:	75 06                	jne    80148d <strchr+0x25>
			return (char *) s;
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	eb 15                	jmp    8014a2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80148d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	84 c0                	test   %al,%al
  80149b:	75 de                	jne    80147b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 0c          	sub    $0xc,%rsp
  8014ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b0:	89 f0                	mov    %esi,%eax
  8014b2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014b5:	eb 13                	jmp    8014ca <strfind+0x26>
		if (*s == c)
  8014b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014c1:	75 02                	jne    8014c5 <strfind+0x21>
			break;
  8014c3:	eb 10                	jmp    8014d5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ce:	0f b6 00             	movzbl (%rax),%eax
  8014d1:	84 c0                	test   %al,%al
  8014d3:	75 e2                	jne    8014b7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014d9:	c9                   	leaveq 
  8014da:	c3                   	retq   

00000000008014db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014db:	55                   	push   %rbp
  8014dc:	48 89 e5             	mov    %rsp,%rbp
  8014df:	48 83 ec 18          	sub    $0x18,%rsp
  8014e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f3:	75 06                	jne    8014fb <memset+0x20>
		return v;
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	eb 69                	jmp    801564 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	83 e0 03             	and    $0x3,%eax
  801502:	48 85 c0             	test   %rax,%rax
  801505:	75 48                	jne    80154f <memset+0x74>
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	83 e0 03             	and    $0x3,%eax
  80150e:	48 85 c0             	test   %rax,%rax
  801511:	75 3c                	jne    80154f <memset+0x74>
		c &= 0xFF;
  801513:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80151a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80151d:	c1 e0 18             	shl    $0x18,%eax
  801520:	89 c2                	mov    %eax,%edx
  801522:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801525:	c1 e0 10             	shl    $0x10,%eax
  801528:	09 c2                	or     %eax,%edx
  80152a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152d:	c1 e0 08             	shl    $0x8,%eax
  801530:	09 d0                	or     %edx,%eax
  801532:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801539:	48 c1 e8 02          	shr    $0x2,%rax
  80153d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801540:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801544:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801547:	48 89 d7             	mov    %rdx,%rdi
  80154a:	fc                   	cld    
  80154b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80154d:	eb 11                	jmp    801560 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80154f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801553:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801556:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80155a:	48 89 d7             	mov    %rdx,%rdi
  80155d:	fc                   	cld    
  80155e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801564:	c9                   	leaveq 
  801565:	c3                   	retq   

0000000000801566 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801566:	55                   	push   %rbp
  801567:	48 89 e5             	mov    %rsp,%rbp
  80156a:	48 83 ec 28          	sub    $0x28,%rsp
  80156e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801572:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801576:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80157a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801586:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801592:	0f 83 88 00 00 00    	jae    801620 <memmove+0xba>
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a0:	48 01 d0             	add    %rdx,%rax
  8015a3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015a7:	76 77                	jbe    801620 <memmove+0xba>
		s += n;
  8015a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ad:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bd:	83 e0 03             	and    $0x3,%eax
  8015c0:	48 85 c0             	test   %rax,%rax
  8015c3:	75 3b                	jne    801600 <memmove+0x9a>
  8015c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c9:	83 e0 03             	and    $0x3,%eax
  8015cc:	48 85 c0             	test   %rax,%rax
  8015cf:	75 2f                	jne    801600 <memmove+0x9a>
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	83 e0 03             	and    $0x3,%eax
  8015d8:	48 85 c0             	test   %rax,%rax
  8015db:	75 23                	jne    801600 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e1:	48 83 e8 04          	sub    $0x4,%rax
  8015e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e9:	48 83 ea 04          	sub    $0x4,%rdx
  8015ed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015f1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015f5:	48 89 c7             	mov    %rax,%rdi
  8015f8:	48 89 d6             	mov    %rdx,%rsi
  8015fb:	fd                   	std    
  8015fc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015fe:	eb 1d                	jmp    80161d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801604:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801614:	48 89 d7             	mov    %rdx,%rdi
  801617:	48 89 c1             	mov    %rax,%rcx
  80161a:	fd                   	std    
  80161b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80161d:	fc                   	cld    
  80161e:	eb 57                	jmp    801677 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	83 e0 03             	and    $0x3,%eax
  801627:	48 85 c0             	test   %rax,%rax
  80162a:	75 36                	jne    801662 <memmove+0xfc>
  80162c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801630:	83 e0 03             	and    $0x3,%eax
  801633:	48 85 c0             	test   %rax,%rax
  801636:	75 2a                	jne    801662 <memmove+0xfc>
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	83 e0 03             	and    $0x3,%eax
  80163f:	48 85 c0             	test   %rax,%rax
  801642:	75 1e                	jne    801662 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 c1 e8 02          	shr    $0x2,%rax
  80164c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80164f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801653:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801657:	48 89 c7             	mov    %rax,%rdi
  80165a:	48 89 d6             	mov    %rdx,%rsi
  80165d:	fc                   	cld    
  80165e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801660:	eb 15                	jmp    801677 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801666:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80166e:	48 89 c7             	mov    %rax,%rdi
  801671:	48 89 d6             	mov    %rdx,%rsi
  801674:	fc                   	cld    
  801675:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80167b:	c9                   	leaveq 
  80167c:	c3                   	retq   

000000000080167d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
  801681:	48 83 ec 18          	sub    $0x18,%rsp
  801685:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801689:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80168d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801691:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801695:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169d:	48 89 ce             	mov    %rcx,%rsi
  8016a0:	48 89 c7             	mov    %rax,%rdi
  8016a3:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  8016aa:	00 00 00 
  8016ad:	ff d0                	callq  *%rax
}
  8016af:	c9                   	leaveq 
  8016b0:	c3                   	retq   

00000000008016b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016b1:	55                   	push   %rbp
  8016b2:	48 89 e5             	mov    %rsp,%rbp
  8016b5:	48 83 ec 28          	sub    $0x28,%rsp
  8016b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016d5:	eb 36                	jmp    80170d <memcmp+0x5c>
		if (*s1 != *s2)
  8016d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016db:	0f b6 10             	movzbl (%rax),%edx
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e2:	0f b6 00             	movzbl (%rax),%eax
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 1a                	je     801703 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f b6 c0             	movzbl %al,%eax
  8016fd:	29 c2                	sub    %eax,%edx
  8016ff:	89 d0                	mov    %edx,%eax
  801701:	eb 20                	jmp    801723 <memcmp+0x72>
		s1++, s2++;
  801703:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801708:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801715:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801719:	48 85 c0             	test   %rax,%rax
  80171c:	75 b9                	jne    8016d7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 28          	sub    $0x28,%rsp
  80172d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801731:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801734:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801740:	48 01 d0             	add    %rdx,%rax
  801743:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801747:	eb 15                	jmp    80175e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174d:	0f b6 10             	movzbl (%rax),%edx
  801750:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801753:	38 c2                	cmp    %al,%dl
  801755:	75 02                	jne    801759 <memfind+0x34>
			break;
  801757:	eb 0f                	jmp    801768 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801759:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80175e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801762:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801766:	72 e1                	jb     801749 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80176c:	c9                   	leaveq 
  80176d:	c3                   	retq   

000000000080176e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80176e:	55                   	push   %rbp
  80176f:	48 89 e5             	mov    %rsp,%rbp
  801772:	48 83 ec 34          	sub    $0x34,%rsp
  801776:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80177a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80177e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801781:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801788:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80178f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801790:	eb 05                	jmp    801797 <strtol+0x29>
		s++;
  801792:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	3c 20                	cmp    $0x20,%al
  8017a0:	74 f0                	je     801792 <strtol+0x24>
  8017a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a6:	0f b6 00             	movzbl (%rax),%eax
  8017a9:	3c 09                	cmp    $0x9,%al
  8017ab:	74 e5                	je     801792 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	3c 2b                	cmp    $0x2b,%al
  8017b6:	75 07                	jne    8017bf <strtol+0x51>
		s++;
  8017b8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017bd:	eb 17                	jmp    8017d6 <strtol+0x68>
	else if (*s == '-')
  8017bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c3:	0f b6 00             	movzbl (%rax),%eax
  8017c6:	3c 2d                	cmp    $0x2d,%al
  8017c8:	75 0c                	jne    8017d6 <strtol+0x68>
		s++, neg = 1;
  8017ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017da:	74 06                	je     8017e2 <strtol+0x74>
  8017dc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017e0:	75 28                	jne    80180a <strtol+0x9c>
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	0f b6 00             	movzbl (%rax),%eax
  8017e9:	3c 30                	cmp    $0x30,%al
  8017eb:	75 1d                	jne    80180a <strtol+0x9c>
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	48 83 c0 01          	add    $0x1,%rax
  8017f5:	0f b6 00             	movzbl (%rax),%eax
  8017f8:	3c 78                	cmp    $0x78,%al
  8017fa:	75 0e                	jne    80180a <strtol+0x9c>
		s += 2, base = 16;
  8017fc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801801:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801808:	eb 2c                	jmp    801836 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80180a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80180e:	75 19                	jne    801829 <strtol+0xbb>
  801810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801814:	0f b6 00             	movzbl (%rax),%eax
  801817:	3c 30                	cmp    $0x30,%al
  801819:	75 0e                	jne    801829 <strtol+0xbb>
		s++, base = 8;
  80181b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801820:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801827:	eb 0d                	jmp    801836 <strtol+0xc8>
	else if (base == 0)
  801829:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80182d:	75 07                	jne    801836 <strtol+0xc8>
		base = 10;
  80182f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	3c 2f                	cmp    $0x2f,%al
  80183f:	7e 1d                	jle    80185e <strtol+0xf0>
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	0f b6 00             	movzbl (%rax),%eax
  801848:	3c 39                	cmp    $0x39,%al
  80184a:	7f 12                	jg     80185e <strtol+0xf0>
			dig = *s - '0';
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	0f be c0             	movsbl %al,%eax
  801856:	83 e8 30             	sub    $0x30,%eax
  801859:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80185c:	eb 4e                	jmp    8018ac <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80185e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801862:	0f b6 00             	movzbl (%rax),%eax
  801865:	3c 60                	cmp    $0x60,%al
  801867:	7e 1d                	jle    801886 <strtol+0x118>
  801869:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186d:	0f b6 00             	movzbl (%rax),%eax
  801870:	3c 7a                	cmp    $0x7a,%al
  801872:	7f 12                	jg     801886 <strtol+0x118>
			dig = *s - 'a' + 10;
  801874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801878:	0f b6 00             	movzbl (%rax),%eax
  80187b:	0f be c0             	movsbl %al,%eax
  80187e:	83 e8 57             	sub    $0x57,%eax
  801881:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801884:	eb 26                	jmp    8018ac <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	3c 40                	cmp    $0x40,%al
  80188f:	7e 48                	jle    8018d9 <strtol+0x16b>
  801891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	3c 5a                	cmp    $0x5a,%al
  80189a:	7f 3d                	jg     8018d9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	0f b6 00             	movzbl (%rax),%eax
  8018a3:	0f be c0             	movsbl %al,%eax
  8018a6:	83 e8 37             	sub    $0x37,%eax
  8018a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018af:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018b2:	7c 02                	jl     8018b6 <strtol+0x148>
			break;
  8018b4:	eb 23                	jmp    8018d9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018bb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018be:	48 98                	cltq   
  8018c0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018c5:	48 89 c2             	mov    %rax,%rdx
  8018c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018cb:	48 98                	cltq   
  8018cd:	48 01 d0             	add    %rdx,%rax
  8018d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018d4:	e9 5d ff ff ff       	jmpq   801836 <strtol+0xc8>

	if (endptr)
  8018d9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018de:	74 0b                	je     8018eb <strtol+0x17d>
		*endptr = (char *) s;
  8018e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018e8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018ef:	74 09                	je     8018fa <strtol+0x18c>
  8018f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f5:	48 f7 d8             	neg    %rax
  8018f8:	eb 04                	jmp    8018fe <strtol+0x190>
  8018fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018fe:	c9                   	leaveq 
  8018ff:	c3                   	retq   

0000000000801900 <strstr>:

char * strstr(const char *in, const char *str)
{
  801900:	55                   	push   %rbp
  801901:	48 89 e5             	mov    %rsp,%rbp
  801904:	48 83 ec 30          	sub    $0x30,%rsp
  801908:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80190c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801910:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801914:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801918:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801922:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801926:	75 06                	jne    80192e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	eb 6b                	jmp    801999 <strstr+0x99>

	len = strlen(str);
  80192e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801932:	48 89 c7             	mov    %rax,%rdi
  801935:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	callq  *%rax
  801941:	48 98                	cltq   
  801943:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80194f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801953:	0f b6 00             	movzbl (%rax),%eax
  801956:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801959:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80195d:	75 07                	jne    801966 <strstr+0x66>
				return (char *) 0;
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
  801964:	eb 33                	jmp    801999 <strstr+0x99>
		} while (sc != c);
  801966:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80196a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80196d:	75 d8                	jne    801947 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80196f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801973:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197b:	48 89 ce             	mov    %rcx,%rsi
  80197e:	48 89 c7             	mov    %rax,%rdi
  801981:	48 b8 f7 13 80 00 00 	movabs $0x8013f7,%rax
  801988:	00 00 00 
  80198b:	ff d0                	callq  *%rax
  80198d:	85 c0                	test   %eax,%eax
  80198f:	75 b6                	jne    801947 <strstr+0x47>

	return (char *) (in - 1);
  801991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801995:	48 83 e8 01          	sub    $0x1,%rax
}
  801999:	c9                   	leaveq 
  80199a:	c3                   	retq   

000000000080199b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80199b:	55                   	push   %rbp
  80199c:	48 89 e5             	mov    %rsp,%rbp
  80199f:	53                   	push   %rbx
  8019a0:	48 83 ec 48          	sub    $0x48,%rsp
  8019a4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019a7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019aa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019ae:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019b2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019b6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019bd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019c1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019c5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019c9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019cd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019d1:	4c 89 c3             	mov    %r8,%rbx
  8019d4:	cd 30                	int    $0x30
  8019d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019da:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019de:	74 3e                	je     801a1e <syscall+0x83>
  8019e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019e5:	7e 37                	jle    801a1e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019ee:	49 89 d0             	mov    %rdx,%r8
  8019f1:	89 c1                	mov    %eax,%ecx
  8019f3:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  8019fa:	00 00 00 
  8019fd:	be 23 00 00 00       	mov    $0x23,%esi
  801a02:	48 bf 85 46 80 00 00 	movabs $0x804685,%rdi
  801a09:	00 00 00 
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a11:	49 b9 41 04 80 00 00 	movabs $0x800441,%r9
  801a18:	00 00 00 
  801a1b:	41 ff d1             	callq  *%r9

	return ret;
  801a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a22:	48 83 c4 48          	add    $0x48,%rsp
  801a26:	5b                   	pop    %rbx
  801a27:	5d                   	pop    %rbp
  801a28:	c3                   	retq   

0000000000801a29 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a29:	55                   	push   %rbp
  801a2a:	48 89 e5             	mov    %rsp,%rbp
  801a2d:	48 83 ec 20          	sub    $0x20,%rsp
  801a31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a41:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a48:	00 
  801a49:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a55:	48 89 d1             	mov    %rdx,%rcx
  801a58:	48 89 c2             	mov    %rax,%rdx
  801a5b:	be 00 00 00 00       	mov    $0x0,%esi
  801a60:	bf 00 00 00 00       	mov    $0x0,%edi
  801a65:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801a6c:	00 00 00 
  801a6f:	ff d0                	callq  *%rax
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a82:	00 
  801a83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a94:	ba 00 00 00 00       	mov    $0x0,%edx
  801a99:	be 00 00 00 00       	mov    $0x0,%esi
  801a9e:	bf 01 00 00 00       	mov    $0x1,%edi
  801aa3:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801aaa:	00 00 00 
  801aad:	ff d0                	callq  *%rax
}
  801aaf:	c9                   	leaveq 
  801ab0:	c3                   	retq   

0000000000801ab1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
  801ab5:	48 83 ec 10          	sub    $0x10,%rsp
  801ab9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801abf:	48 98                	cltq   
  801ac1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac8:	00 
  801ac9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801acf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 03 00 00 00       	mov    $0x3,%edi
  801ae7:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801afd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b04:	00 
  801b05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b16:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1b:	be 00 00 00 00       	mov    $0x0,%esi
  801b20:	bf 02 00 00 00       	mov    $0x2,%edi
  801b25:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801b2c:	00 00 00 
  801b2f:	ff d0                	callq  *%rax
}
  801b31:	c9                   	leaveq 
  801b32:	c3                   	retq   

0000000000801b33 <sys_yield>:

void
sys_yield(void)
{
  801b33:	55                   	push   %rbp
  801b34:	48 89 e5             	mov    %rsp,%rbp
  801b37:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b54:	ba 00 00 00 00       	mov    $0x0,%edx
  801b59:	be 00 00 00 00       	mov    $0x0,%esi
  801b5e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b63:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801b6a:	00 00 00 
  801b6d:	ff d0                	callq  *%rax
}
  801b6f:	c9                   	leaveq 
  801b70:	c3                   	retq   

0000000000801b71 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b71:	55                   	push   %rbp
  801b72:	48 89 e5             	mov    %rsp,%rbp
  801b75:	48 83 ec 20          	sub    $0x20,%rsp
  801b79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b80:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b86:	48 63 c8             	movslq %eax,%rcx
  801b89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b90:	48 98                	cltq   
  801b92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b99:	00 
  801b9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba0:	49 89 c8             	mov    %rcx,%r8
  801ba3:	48 89 d1             	mov    %rdx,%rcx
  801ba6:	48 89 c2             	mov    %rax,%rdx
  801ba9:	be 01 00 00 00       	mov    $0x1,%esi
  801bae:	bf 04 00 00 00       	mov    $0x4,%edi
  801bb3:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801bba:	00 00 00 
  801bbd:	ff d0                	callq  *%rax
}
  801bbf:	c9                   	leaveq 
  801bc0:	c3                   	retq   

0000000000801bc1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bc1:	55                   	push   %rbp
  801bc2:	48 89 e5             	mov    %rsp,%rbp
  801bc5:	48 83 ec 30          	sub    $0x30,%rsp
  801bc9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bd3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bd7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bdb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bde:	48 63 c8             	movslq %eax,%rcx
  801be1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801be5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be8:	48 63 f0             	movslq %eax,%rsi
  801beb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf2:	48 98                	cltq   
  801bf4:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bf8:	49 89 f9             	mov    %rdi,%r9
  801bfb:	49 89 f0             	mov    %rsi,%r8
  801bfe:	48 89 d1             	mov    %rdx,%rcx
  801c01:	48 89 c2             	mov    %rax,%rdx
  801c04:	be 01 00 00 00       	mov    $0x1,%esi
  801c09:	bf 05 00 00 00       	mov    $0x5,%edi
  801c0e:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801c15:	00 00 00 
  801c18:	ff d0                	callq  *%rax
}
  801c1a:	c9                   	leaveq 
  801c1b:	c3                   	retq   

0000000000801c1c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	48 83 ec 20          	sub    $0x20,%rsp
  801c24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c32:	48 98                	cltq   
  801c34:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3b:	00 
  801c3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c48:	48 89 d1             	mov    %rdx,%rcx
  801c4b:	48 89 c2             	mov    %rax,%rdx
  801c4e:	be 01 00 00 00       	mov    $0x1,%esi
  801c53:	bf 06 00 00 00       	mov    $0x6,%edi
  801c58:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	callq  *%rax
}
  801c64:	c9                   	leaveq 
  801c65:	c3                   	retq   

0000000000801c66 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c66:	55                   	push   %rbp
  801c67:	48 89 e5             	mov    %rsp,%rbp
  801c6a:	48 83 ec 10          	sub    $0x10,%rsp
  801c6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c71:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c77:	48 63 d0             	movslq %eax,%rdx
  801c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7d:	48 98                	cltq   
  801c7f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c86:	00 
  801c87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c93:	48 89 d1             	mov    %rdx,%rcx
  801c96:	48 89 c2             	mov    %rax,%rdx
  801c99:	be 01 00 00 00       	mov    $0x1,%esi
  801c9e:	bf 08 00 00 00       	mov    $0x8,%edi
  801ca3:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
}
  801caf:	c9                   	leaveq 
  801cb0:	c3                   	retq   

0000000000801cb1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cb1:	55                   	push   %rbp
  801cb2:	48 89 e5             	mov    %rsp,%rbp
  801cb5:	48 83 ec 20          	sub    $0x20,%rsp
  801cb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cc0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc7:	48 98                	cltq   
  801cc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd0:	00 
  801cd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cdd:	48 89 d1             	mov    %rdx,%rcx
  801ce0:	48 89 c2             	mov    %rax,%rdx
  801ce3:	be 01 00 00 00       	mov    $0x1,%esi
  801ce8:	bf 09 00 00 00       	mov    $0x9,%edi
  801ced:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801cf4:	00 00 00 
  801cf7:	ff d0                	callq  *%rax
}
  801cf9:	c9                   	leaveq 
  801cfa:	c3                   	retq   

0000000000801cfb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cfb:	55                   	push   %rbp
  801cfc:	48 89 e5             	mov    %rsp,%rbp
  801cff:	48 83 ec 20          	sub    $0x20,%rsp
  801d03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d11:	48 98                	cltq   
  801d13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1a:	00 
  801d1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d27:	48 89 d1             	mov    %rdx,%rcx
  801d2a:	48 89 c2             	mov    %rax,%rdx
  801d2d:	be 01 00 00 00       	mov    $0x1,%esi
  801d32:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d37:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801d3e:	00 00 00 
  801d41:	ff d0                	callq  *%rax
}
  801d43:	c9                   	leaveq 
  801d44:	c3                   	retq   

0000000000801d45 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d45:	55                   	push   %rbp
  801d46:	48 89 e5             	mov    %rsp,%rbp
  801d49:	48 83 ec 20          	sub    $0x20,%rsp
  801d4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d54:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d58:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5e:	48 63 f0             	movslq %eax,%rsi
  801d61:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d68:	48 98                	cltq   
  801d6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d75:	00 
  801d76:	49 89 f1             	mov    %rsi,%r9
  801d79:	49 89 c8             	mov    %rcx,%r8
  801d7c:	48 89 d1             	mov    %rdx,%rcx
  801d7f:	48 89 c2             	mov    %rax,%rdx
  801d82:	be 00 00 00 00       	mov    $0x0,%esi
  801d87:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d8c:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	callq  *%rax
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 10          	sub    $0x10,%rsp
  801da2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801da6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801daa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db1:	00 
  801db2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc3:	48 89 c2             	mov    %rax,%rdx
  801dc6:	be 01 00 00 00       	mov    $0x1,%esi
  801dcb:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dd0:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 30          	sub    $0x30,%rsp
  801de6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801dea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dee:	48 8b 00             	mov    (%rax),%rax
  801df1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801df5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df9:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dfd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e00:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e03:	83 e0 02             	and    $0x2,%eax
  801e06:	85 c0                	test   %eax,%eax
  801e08:	75 4d                	jne    801e57 <pgfault+0x79>
  801e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0e:	48 c1 e8 0c          	shr    $0xc,%rax
  801e12:	48 89 c2             	mov    %rax,%rdx
  801e15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e1c:	01 00 00 
  801e1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e23:	25 00 08 00 00       	and    $0x800,%eax
  801e28:	48 85 c0             	test   %rax,%rax
  801e2b:	74 2a                	je     801e57 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801e2d:	48 ba 98 46 80 00 00 	movabs $0x804698,%rdx
  801e34:	00 00 00 
  801e37:	be 1e 00 00 00       	mov    $0x1e,%esi
  801e3c:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  801e43:	00 00 00 
  801e46:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4b:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  801e52:	00 00 00 
  801e55:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801e57:	ba 07 00 00 00       	mov    $0x7,%edx
  801e5c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e61:	bf 00 00 00 00       	mov    $0x0,%edi
  801e66:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  801e6d:	00 00 00 
  801e70:	ff d0                	callq  *%rax
  801e72:	85 c0                	test   %eax,%eax
  801e74:	0f 85 cd 00 00 00    	jne    801f47 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e86:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e8c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e94:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e99:	48 89 c6             	mov    %rax,%rsi
  801e9c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ea1:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801ead:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801eb7:	48 89 c1             	mov    %rax,%rcx
  801eba:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ec4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec9:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	79 2a                	jns    801f03 <pgfault+0x125>
				panic("Page map at temp address failed");
  801ed9:	48 ba c8 46 80 00 00 	movabs $0x8046c8,%rdx
  801ee0:	00 00 00 
  801ee3:	be 2f 00 00 00       	mov    $0x2f,%esi
  801ee8:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  801eef:	00 00 00 
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  801efe:	00 00 00 
  801f01:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f03:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f08:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0d:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	callq  *%rax
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	79 54                	jns    801f71 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801f1d:	48 ba e8 46 80 00 00 	movabs $0x8046e8,%rdx
  801f24:	00 00 00 
  801f27:	be 31 00 00 00       	mov    $0x31,%esi
  801f2c:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  801f33:	00 00 00 
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  801f42:	00 00 00 
  801f45:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801f47:	48 ba 10 47 80 00 00 	movabs $0x804710,%rdx
  801f4e:	00 00 00 
  801f51:	be 35 00 00 00       	mov    $0x35,%esi
  801f56:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  801f5d:	00 00 00 
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  801f6c:	00 00 00 
  801f6f:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801f71:	c9                   	leaveq 
  801f72:	c3                   	retq   

0000000000801f73 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f73:	55                   	push   %rbp
  801f74:	48 89 e5             	mov    %rsp,%rbp
  801f77:	48 83 ec 20          	sub    $0x20,%rsp
  801f7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f7e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801f81:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f88:	01 00 00 
  801f8b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f92:	25 07 0e 00 00       	and    $0xe07,%eax
  801f97:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f9a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f9d:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa8:	25 00 04 00 00       	and    $0x400,%eax
  801fad:	85 c0                	test   %eax,%eax
  801faf:	74 57                	je     802008 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fb1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fb4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fb8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbf:	41 89 f0             	mov    %esi,%r8d
  801fc2:	48 89 c6             	mov    %rax,%rsi
  801fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  801fca:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  801fd1:	00 00 00 
  801fd4:	ff d0                	callq  *%rax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	0f 8e 52 01 00 00    	jle    802130 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801fde:	48 ba 3d 47 80 00 00 	movabs $0x80473d,%rdx
  801fe5:	00 00 00 
  801fe8:	be 52 00 00 00       	mov    $0x52,%esi
  801fed:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  801ff4:	00 00 00 
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  802003:	00 00 00 
  802006:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  802008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200b:	83 e0 02             	and    $0x2,%eax
  80200e:	85 c0                	test   %eax,%eax
  802010:	75 10                	jne    802022 <duppage+0xaf>
  802012:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802015:	25 00 08 00 00       	and    $0x800,%eax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	0f 84 bb 00 00 00    	je     8020dd <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  802022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802025:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  80202a:	80 cc 08             	or     $0x8,%ah
  80202d:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  802030:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802033:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802037:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80203a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203e:	41 89 f0             	mov    %esi,%r8d
  802041:	48 89 c6             	mov    %rax,%rsi
  802044:	bf 00 00 00 00       	mov    $0x0,%edi
  802049:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  802050:	00 00 00 
  802053:	ff d0                	callq  *%rax
  802055:	85 c0                	test   %eax,%eax
  802057:	7e 2a                	jle    802083 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  802059:	48 ba 3d 47 80 00 00 	movabs $0x80473d,%rdx
  802060:	00 00 00 
  802063:	be 5a 00 00 00       	mov    $0x5a,%esi
  802068:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  80206f:	00 00 00 
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  80207e:	00 00 00 
  802081:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802083:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802086:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80208a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208e:	41 89 c8             	mov    %ecx,%r8d
  802091:	48 89 d1             	mov    %rdx,%rcx
  802094:	ba 00 00 00 00       	mov    $0x0,%edx
  802099:	48 89 c6             	mov    %rax,%rsi
  80209c:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a1:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	7e 2a                	jle    8020db <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  8020b1:	48 ba 3d 47 80 00 00 	movabs $0x80473d,%rdx
  8020b8:	00 00 00 
  8020bb:	be 5d 00 00 00       	mov    $0x5d,%esi
  8020c0:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  8020c7:	00 00 00 
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  8020d6:	00 00 00 
  8020d9:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020db:	eb 53                	jmp    802130 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020dd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020e0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020eb:	41 89 f0             	mov    %esi,%r8d
  8020ee:	48 89 c6             	mov    %rax,%rsi
  8020f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f6:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  8020fd:	00 00 00 
  802100:	ff d0                	callq  *%rax
  802102:	85 c0                	test   %eax,%eax
  802104:	7e 2a                	jle    802130 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  802106:	48 ba 3d 47 80 00 00 	movabs $0x80473d,%rdx
  80210d:	00 00 00 
  802110:	be 61 00 00 00       	mov    $0x61,%esi
  802115:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  80211c:	00 00 00 
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  80212b:	00 00 00 
  80212e:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802135:	c9                   	leaveq 
  802136:	c3                   	retq   

0000000000802137 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802137:	55                   	push   %rbp
  802138:	48 89 e5             	mov    %rsp,%rbp
  80213b:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  80213f:	48 bf de 1d 80 00 00 	movabs $0x801dde,%rdi
  802146:	00 00 00 
  802149:	48 b8 11 3f 80 00 00 	movabs $0x803f11,%rax
  802150:	00 00 00 
  802153:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802155:	b8 07 00 00 00       	mov    $0x7,%eax
  80215a:	cd 30                	int    $0x30
  80215c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80215f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802162:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  802165:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802169:	79 30                	jns    80219b <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80216b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80216e:	89 c1                	mov    %eax,%ecx
  802170:	48 ba 5b 47 80 00 00 	movabs $0x80475b,%rdx
  802177:	00 00 00 
  80217a:	be 89 00 00 00       	mov    $0x89,%esi
  80217f:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  802186:	00 00 00 
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  802195:	00 00 00 
  802198:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  80219b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80219f:	75 46                	jne    8021e7 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  8021a1:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
  8021ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021b2:	48 63 d0             	movslq %eax,%rdx
  8021b5:	48 89 d0             	mov    %rdx,%rax
  8021b8:	48 c1 e0 03          	shl    $0x3,%rax
  8021bc:	48 01 d0             	add    %rdx,%rax
  8021bf:	48 c1 e0 05          	shl    $0x5,%rax
  8021c3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8021ca:	00 00 00 
  8021cd:	48 01 c2             	add    %rax,%rdx
  8021d0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021d7:	00 00 00 
  8021da:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	e9 d1 01 00 00       	jmpq   8023b8 <fork+0x281>
	}

	uint64_t ad = 0;
  8021e7:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8021ee:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8021ef:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8021f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021f8:	e9 df 00 00 00       	jmpq   8022dc <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8021fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802201:	48 c1 e8 27          	shr    $0x27,%rax
  802205:	48 89 c2             	mov    %rax,%rdx
  802208:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80220f:	01 00 00 
  802212:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802216:	83 e0 01             	and    $0x1,%eax
  802219:	48 85 c0             	test   %rax,%rax
  80221c:	0f 84 9e 00 00 00    	je     8022c0 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802226:	48 c1 e8 1e          	shr    $0x1e,%rax
  80222a:	48 89 c2             	mov    %rax,%rdx
  80222d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802234:	01 00 00 
  802237:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223b:	83 e0 01             	and    $0x1,%eax
  80223e:	48 85 c0             	test   %rax,%rax
  802241:	74 73                	je     8022b6 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802247:	48 c1 e8 15          	shr    $0x15,%rax
  80224b:	48 89 c2             	mov    %rax,%rdx
  80224e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802255:	01 00 00 
  802258:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225c:	83 e0 01             	and    $0x1,%eax
  80225f:	48 85 c0             	test   %rax,%rax
  802262:	74 48                	je     8022ac <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802268:	48 c1 e8 0c          	shr    $0xc,%rax
  80226c:	48 89 c2             	mov    %rax,%rdx
  80226f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802276:	01 00 00 
  802279:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80227d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802285:	83 e0 01             	and    $0x1,%eax
  802288:	48 85 c0             	test   %rax,%rax
  80228b:	74 47                	je     8022d4 <fork+0x19d>
						duppage(envid, VPN(addr));
  80228d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802291:	48 c1 e8 0c          	shr    $0xc,%rax
  802295:	89 c2                	mov    %eax,%edx
  802297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80229a:	89 d6                	mov    %edx,%esi
  80229c:	89 c7                	mov    %eax,%edi
  80229e:	48 b8 73 1f 80 00 00 	movabs $0x801f73,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
  8022aa:	eb 28                	jmp    8022d4 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  8022ac:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8022b3:	00 
  8022b4:	eb 1e                	jmp    8022d4 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8022b6:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8022bd:	40 
  8022be:	eb 14                	jmp    8022d4 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  8022c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c4:	48 c1 e8 27          	shr    $0x27,%rax
  8022c8:	48 83 c0 01          	add    $0x1,%rax
  8022cc:	48 c1 e0 27          	shl    $0x27,%rax
  8022d0:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8022d4:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8022db:	00 
  8022dc:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8022e3:	00 
  8022e4:	0f 87 13 ff ff ff    	ja     8021fd <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8022ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022ed:	ba 07 00 00 00       	mov    $0x7,%edx
  8022f2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8022f7:	89 c7                	mov    %eax,%edi
  8022f9:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  802300:	00 00 00 
  802303:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802305:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802308:	ba 07 00 00 00       	mov    $0x7,%edx
  80230d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802312:	89 c7                	mov    %eax,%edi
  802314:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  80231b:	00 00 00 
  80231e:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802323:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802329:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80232e:	ba 00 00 00 00       	mov    $0x0,%edx
  802333:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802338:	89 c7                	mov    %eax,%edi
  80233a:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802346:	ba 00 10 00 00       	mov    $0x1000,%edx
  80234b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802350:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802355:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  80235c:	00 00 00 
  80235f:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802361:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802366:	bf 00 00 00 00       	mov    $0x0,%edi
  80236b:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802377:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80237e:	00 00 00 
  802381:	48 8b 00             	mov    (%rax),%rax
  802384:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80238b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80238e:	48 89 d6             	mov    %rdx,%rsi
  802391:	89 c7                	mov    %eax,%edi
  802393:	48 b8 fb 1c 80 00 00 	movabs $0x801cfb,%rax
  80239a:	00 00 00 
  80239d:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80239f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023a2:	be 02 00 00 00       	mov    $0x2,%esi
  8023a7:	89 c7                	mov    %eax,%edi
  8023a9:	48 b8 66 1c 80 00 00 	movabs $0x801c66,%rax
  8023b0:	00 00 00 
  8023b3:	ff d0                	callq  *%rax

	return envid;
  8023b5:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8023b8:	c9                   	leaveq 
  8023b9:	c3                   	retq   

00000000008023ba <sfork>:

// Challenge!
int
sfork(void)
{
  8023ba:	55                   	push   %rbp
  8023bb:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8023be:	48 ba 73 47 80 00 00 	movabs $0x804773,%rdx
  8023c5:	00 00 00 
  8023c8:	be b8 00 00 00       	mov    $0xb8,%esi
  8023cd:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  8023d4:	00 00 00 
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  8023e3:	00 00 00 
  8023e6:	ff d1                	callq  *%rcx

00000000008023e8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023e8:	55                   	push   %rbp
  8023e9:	48 89 e5             	mov    %rsp,%rbp
  8023ec:	48 83 ec 30          	sub    $0x30,%rsp
  8023f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8023fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802401:	75 0e                	jne    802411 <ipc_recv+0x29>
        pg = (void *)UTOP;
  802403:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80240a:	00 00 00 
  80240d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  802411:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802415:	48 89 c7             	mov    %rax,%rdi
  802418:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80241f:	00 00 00 
  802422:	ff d0                	callq  *%rax
  802424:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802427:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242b:	79 27                	jns    802454 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80242d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802432:	74 0a                	je     80243e <ipc_recv+0x56>
            *from_env_store = 0;
  802434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802438:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80243e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802443:	74 0a                	je     80244f <ipc_recv+0x67>
            *perm_store = 0;
  802445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802449:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80244f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802452:	eb 53                	jmp    8024a7 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  802454:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802459:	74 19                	je     802474 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80245b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802462:	00 00 00 
  802465:	48 8b 00             	mov    (%rax),%rax
  802468:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80246e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802472:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  802474:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802479:	74 19                	je     802494 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  80247b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802482:	00 00 00 
  802485:	48 8b 00             	mov    (%rax),%rax
  802488:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80248e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802492:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  802494:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80249b:	00 00 00 
  80249e:	48 8b 00             	mov    (%rax),%rax
  8024a1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	48 83 ec 30          	sub    $0x30,%rsp
  8024b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8024b7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8024bb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8024be:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024c3:	75 0e                	jne    8024d3 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8024c5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024cc:	00 00 00 
  8024cf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  8024d3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8024d6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8024d9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
  8024ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  8024f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f5:	79 36                	jns    80252d <ipc_send+0x84>
  8024f7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8024fb:	74 30                	je     80252d <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	89 c1                	mov    %eax,%ecx
  802502:	48 ba 89 47 80 00 00 	movabs $0x804789,%rdx
  802509:	00 00 00 
  80250c:	be 49 00 00 00       	mov    $0x49,%esi
  802511:	48 bf 96 47 80 00 00 	movabs $0x804796,%rdi
  802518:	00 00 00 
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
  802520:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  802527:	00 00 00 
  80252a:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80252d:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
    } while(r != 0);
  802539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253d:	75 94                	jne    8024d3 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80253f:	c9                   	leaveq 
  802540:	c3                   	retq   

0000000000802541 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802541:	55                   	push   %rbp
  802542:	48 89 e5             	mov    %rsp,%rbp
  802545:	48 83 ec 14          	sub    $0x14,%rsp
  802549:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80254c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802553:	eb 5e                	jmp    8025b3 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802555:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80255c:	00 00 00 
  80255f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802562:	48 63 d0             	movslq %eax,%rdx
  802565:	48 89 d0             	mov    %rdx,%rax
  802568:	48 c1 e0 03          	shl    $0x3,%rax
  80256c:	48 01 d0             	add    %rdx,%rax
  80256f:	48 c1 e0 05          	shl    $0x5,%rax
  802573:	48 01 c8             	add    %rcx,%rax
  802576:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80257c:	8b 00                	mov    (%rax),%eax
  80257e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802581:	75 2c                	jne    8025af <ipc_find_env+0x6e>
			return envs[i].env_id;
  802583:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80258a:	00 00 00 
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	48 63 d0             	movslq %eax,%rdx
  802593:	48 89 d0             	mov    %rdx,%rax
  802596:	48 c1 e0 03          	shl    $0x3,%rax
  80259a:	48 01 d0             	add    %rdx,%rax
  80259d:	48 c1 e0 05          	shl    $0x5,%rax
  8025a1:	48 01 c8             	add    %rcx,%rax
  8025a4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8025aa:	8b 40 08             	mov    0x8(%rax),%eax
  8025ad:	eb 12                	jmp    8025c1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8025af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8025ba:	7e 99                	jle    802555 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c1:	c9                   	leaveq 
  8025c2:	c3                   	retq   

00000000008025c3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025c3:	55                   	push   %rbp
  8025c4:	48 89 e5             	mov    %rsp,%rbp
  8025c7:	48 83 ec 08          	sub    $0x8,%rsp
  8025cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025da:	ff ff ff 
  8025dd:	48 01 d0             	add    %rdx,%rax
  8025e0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025e4:	c9                   	leaveq 
  8025e5:	c3                   	retq   

00000000008025e6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025e6:	55                   	push   %rbp
  8025e7:	48 89 e5             	mov    %rsp,%rbp
  8025ea:	48 83 ec 08          	sub    $0x8,%rsp
  8025ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025f6:	48 89 c7             	mov    %rax,%rdi
  8025f9:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80260b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80260f:	c9                   	leaveq 
  802610:	c3                   	retq   

0000000000802611 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 83 ec 18          	sub    $0x18,%rsp
  802619:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80261d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802624:	eb 6b                	jmp    802691 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802629:	48 98                	cltq   
  80262b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802631:	48 c1 e0 0c          	shl    $0xc,%rax
  802635:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802639:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263d:	48 c1 e8 15          	shr    $0x15,%rax
  802641:	48 89 c2             	mov    %rax,%rdx
  802644:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80264b:	01 00 00 
  80264e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802652:	83 e0 01             	and    $0x1,%eax
  802655:	48 85 c0             	test   %rax,%rax
  802658:	74 21                	je     80267b <fd_alloc+0x6a>
  80265a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265e:	48 c1 e8 0c          	shr    $0xc,%rax
  802662:	48 89 c2             	mov    %rax,%rdx
  802665:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80266c:	01 00 00 
  80266f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802673:	83 e0 01             	and    $0x1,%eax
  802676:	48 85 c0             	test   %rax,%rax
  802679:	75 12                	jne    80268d <fd_alloc+0x7c>
			*fd_store = fd;
  80267b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802683:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
  80268b:	eb 1a                	jmp    8026a7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80268d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802691:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802695:	7e 8f                	jle    802626 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026a2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026a7:	c9                   	leaveq 
  8026a8:	c3                   	retq   

00000000008026a9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026a9:	55                   	push   %rbp
  8026aa:	48 89 e5             	mov    %rsp,%rbp
  8026ad:	48 83 ec 20          	sub    $0x20,%rsp
  8026b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026bc:	78 06                	js     8026c4 <fd_lookup+0x1b>
  8026be:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026c2:	7e 07                	jle    8026cb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c9:	eb 6c                	jmp    802737 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ce:	48 98                	cltq   
  8026d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8026da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026e2:	48 c1 e8 15          	shr    $0x15,%rax
  8026e6:	48 89 c2             	mov    %rax,%rdx
  8026e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026f0:	01 00 00 
  8026f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f7:	83 e0 01             	and    $0x1,%eax
  8026fa:	48 85 c0             	test   %rax,%rax
  8026fd:	74 21                	je     802720 <fd_lookup+0x77>
  8026ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802703:	48 c1 e8 0c          	shr    $0xc,%rax
  802707:	48 89 c2             	mov    %rax,%rdx
  80270a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802711:	01 00 00 
  802714:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802718:	83 e0 01             	and    $0x1,%eax
  80271b:	48 85 c0             	test   %rax,%rax
  80271e:	75 07                	jne    802727 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802720:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802725:	eb 10                	jmp    802737 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802727:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80272f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802737:	c9                   	leaveq 
  802738:	c3                   	retq   

0000000000802739 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802739:	55                   	push   %rbp
  80273a:	48 89 e5             	mov    %rsp,%rbp
  80273d:	48 83 ec 30          	sub    $0x30,%rsp
  802741:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802745:	89 f0                	mov    %esi,%eax
  802747:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80274a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80274e:	48 89 c7             	mov    %rax,%rdi
  802751:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802761:	48 89 d6             	mov    %rdx,%rsi
  802764:	89 c7                	mov    %eax,%edi
  802766:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
  802772:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802775:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802779:	78 0a                	js     802785 <fd_close+0x4c>
	    || fd != fd2)
  80277b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80277f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802783:	74 12                	je     802797 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802785:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802789:	74 05                	je     802790 <fd_close+0x57>
  80278b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278e:	eb 05                	jmp    802795 <fd_close+0x5c>
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
  802795:	eb 69                	jmp    802800 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80279b:	8b 00                	mov    (%rax),%eax
  80279d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027a1:	48 89 d6             	mov    %rdx,%rsi
  8027a4:	89 c7                	mov    %eax,%edi
  8027a6:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
  8027b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b9:	78 2a                	js     8027e5 <fd_close+0xac>
		if (dev->dev_close)
  8027bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bf:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027c3:	48 85 c0             	test   %rax,%rax
  8027c6:	74 16                	je     8027de <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d4:	48 89 d7             	mov    %rdx,%rdi
  8027d7:	ff d0                	callq  *%rax
  8027d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027dc:	eb 07                	jmp    8027e5 <fd_close+0xac>
		else
			r = 0;
  8027de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e9:	48 89 c6             	mov    %rax,%rsi
  8027ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f1:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
	return r;
  8027fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802800:	c9                   	leaveq 
  802801:	c3                   	retq   

0000000000802802 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802802:	55                   	push   %rbp
  802803:	48 89 e5             	mov    %rsp,%rbp
  802806:	48 83 ec 20          	sub    $0x20,%rsp
  80280a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80280d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802811:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802818:	eb 41                	jmp    80285b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80281a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802821:	00 00 00 
  802824:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802827:	48 63 d2             	movslq %edx,%rdx
  80282a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282e:	8b 00                	mov    (%rax),%eax
  802830:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802833:	75 22                	jne    802857 <dev_lookup+0x55>
			*dev = devtab[i];
  802835:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80283c:	00 00 00 
  80283f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802842:	48 63 d2             	movslq %edx,%rdx
  802845:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802849:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
  802855:	eb 60                	jmp    8028b7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802857:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80285b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802862:	00 00 00 
  802865:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802868:	48 63 d2             	movslq %edx,%rdx
  80286b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286f:	48 85 c0             	test   %rax,%rax
  802872:	75 a6                	jne    80281a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802874:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80287b:	00 00 00 
  80287e:	48 8b 00             	mov    (%rax),%rax
  802881:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802887:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80288a:	89 c6                	mov    %eax,%esi
  80288c:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  802893:	00 00 00 
  802896:	b8 00 00 00 00       	mov    $0x0,%eax
  80289b:	48 b9 7a 06 80 00 00 	movabs $0x80067a,%rcx
  8028a2:	00 00 00 
  8028a5:	ff d1                	callq  *%rcx
	*dev = 0;
  8028a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028b7:	c9                   	leaveq 
  8028b8:	c3                   	retq   

00000000008028b9 <close>:

int
close(int fdnum)
{
  8028b9:	55                   	push   %rbp
  8028ba:	48 89 e5             	mov    %rsp,%rbp
  8028bd:	48 83 ec 20          	sub    $0x20,%rsp
  8028c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028c4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028cb:	48 89 d6             	mov    %rdx,%rsi
  8028ce:	89 c7                	mov    %eax,%edi
  8028d0:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
  8028dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e3:	79 05                	jns    8028ea <close+0x31>
		return r;
  8028e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e8:	eb 18                	jmp    802902 <close+0x49>
	else
		return fd_close(fd, 1);
  8028ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ee:	be 01 00 00 00       	mov    $0x1,%esi
  8028f3:	48 89 c7             	mov    %rax,%rdi
  8028f6:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
}
  802902:	c9                   	leaveq 
  802903:	c3                   	retq   

0000000000802904 <close_all>:

void
close_all(void)
{
  802904:	55                   	push   %rbp
  802905:	48 89 e5             	mov    %rsp,%rbp
  802908:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80290c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802913:	eb 15                	jmp    80292a <close_all+0x26>
		close(i);
  802915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802918:	89 c7                	mov    %eax,%edi
  80291a:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802921:	00 00 00 
  802924:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802926:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80292a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80292e:	7e e5                	jle    802915 <close_all+0x11>
		close(i);
}
  802930:	c9                   	leaveq 
  802931:	c3                   	retq   

0000000000802932 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802932:	55                   	push   %rbp
  802933:	48 89 e5             	mov    %rsp,%rbp
  802936:	48 83 ec 40          	sub    $0x40,%rsp
  80293a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80293d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802940:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802944:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802947:	48 89 d6             	mov    %rdx,%rsi
  80294a:	89 c7                	mov    %eax,%edi
  80294c:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802953:	00 00 00 
  802956:	ff d0                	callq  *%rax
  802958:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295f:	79 08                	jns    802969 <dup+0x37>
		return r;
  802961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802964:	e9 70 01 00 00       	jmpq   802ad9 <dup+0x1a7>
	close(newfdnum);
  802969:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80296c:	89 c7                	mov    %eax,%edi
  80296e:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802975:	00 00 00 
  802978:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80297a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80297d:	48 98                	cltq   
  80297f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802985:	48 c1 e0 0c          	shl    $0xc,%rax
  802989:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80298d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802991:	48 89 c7             	mov    %rax,%rdi
  802994:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
  8029a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a8:	48 89 c7             	mov    %rax,%rdi
  8029ab:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax
  8029b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	48 c1 e8 15          	shr    $0x15,%rax
  8029c3:	48 89 c2             	mov    %rax,%rdx
  8029c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029cd:	01 00 00 
  8029d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d4:	83 e0 01             	and    $0x1,%eax
  8029d7:	48 85 c0             	test   %rax,%rax
  8029da:	74 73                	je     802a4f <dup+0x11d>
  8029dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8029e4:	48 89 c2             	mov    %rax,%rdx
  8029e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ee:	01 00 00 
  8029f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f5:	83 e0 01             	and    $0x1,%eax
  8029f8:	48 85 c0             	test   %rax,%rax
  8029fb:	74 52                	je     802a4f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a01:	48 c1 e8 0c          	shr    $0xc,%rax
  802a05:	48 89 c2             	mov    %rax,%rdx
  802a08:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a0f:	01 00 00 
  802a12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a16:	25 07 0e 00 00       	and    $0xe07,%eax
  802a1b:	89 c1                	mov    %eax,%ecx
  802a1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a25:	41 89 c8             	mov    %ecx,%r8d
  802a28:	48 89 d1             	mov    %rdx,%rcx
  802a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a30:	48 89 c6             	mov    %rax,%rsi
  802a33:	bf 00 00 00 00       	mov    $0x0,%edi
  802a38:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	callq  *%rax
  802a44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4b:	79 02                	jns    802a4f <dup+0x11d>
			goto err;
  802a4d:	eb 57                	jmp    802aa6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a53:	48 c1 e8 0c          	shr    $0xc,%rax
  802a57:	48 89 c2             	mov    %rax,%rdx
  802a5a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a61:	01 00 00 
  802a64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a68:	25 07 0e 00 00       	and    $0xe07,%eax
  802a6d:	89 c1                	mov    %eax,%ecx
  802a6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a77:	41 89 c8             	mov    %ecx,%r8d
  802a7a:	48 89 d1             	mov    %rdx,%rcx
  802a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a82:	48 89 c6             	mov    %rax,%rsi
  802a85:	bf 00 00 00 00       	mov    $0x0,%edi
  802a8a:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	callq  *%rax
  802a96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9d:	79 02                	jns    802aa1 <dup+0x16f>
		goto err;
  802a9f:	eb 05                	jmp    802aa6 <dup+0x174>

	return newfdnum;
  802aa1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802aa4:	eb 33                	jmp    802ad9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaa:	48 89 c6             	mov    %rax,%rsi
  802aad:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab2:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802abe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
	return r;
  802ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ad9:	c9                   	leaveq 
  802ada:	c3                   	retq   

0000000000802adb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802adb:	55                   	push   %rbp
  802adc:	48 89 e5             	mov    %rsp,%rbp
  802adf:	48 83 ec 40          	sub    $0x40,%rsp
  802ae3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ae6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802aea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802af2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802af5:	48 89 d6             	mov    %rdx,%rsi
  802af8:	89 c7                	mov    %eax,%edi
  802afa:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
  802b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0d:	78 24                	js     802b33 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b13:	8b 00                	mov    (%rax),%eax
  802b15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b19:	48 89 d6             	mov    %rdx,%rsi
  802b1c:	89 c7                	mov    %eax,%edi
  802b1e:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
  802b2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b31:	79 05                	jns    802b38 <read+0x5d>
		return r;
  802b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b36:	eb 76                	jmp    802bae <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3c:	8b 40 08             	mov    0x8(%rax),%eax
  802b3f:	83 e0 03             	and    $0x3,%eax
  802b42:	83 f8 01             	cmp    $0x1,%eax
  802b45:	75 3a                	jne    802b81 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b47:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b4e:	00 00 00 
  802b51:	48 8b 00             	mov    (%rax),%rax
  802b54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b5d:	89 c6                	mov    %eax,%esi
  802b5f:	48 bf bf 47 80 00 00 	movabs $0x8047bf,%rdi
  802b66:	00 00 00 
  802b69:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6e:	48 b9 7a 06 80 00 00 	movabs $0x80067a,%rcx
  802b75:	00 00 00 
  802b78:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b7f:	eb 2d                	jmp    802bae <read+0xd3>
	}
	if (!dev->dev_read)
  802b81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b85:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b89:	48 85 c0             	test   %rax,%rax
  802b8c:	75 07                	jne    802b95 <read+0xba>
		return -E_NOT_SUPP;
  802b8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b93:	eb 19                	jmp    802bae <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b99:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b9d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ba1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ba5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ba9:	48 89 cf             	mov    %rcx,%rdi
  802bac:	ff d0                	callq  *%rax
}
  802bae:	c9                   	leaveq 
  802baf:	c3                   	retq   

0000000000802bb0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bb0:	55                   	push   %rbp
  802bb1:	48 89 e5             	mov    %rsp,%rbp
  802bb4:	48 83 ec 30          	sub    $0x30,%rsp
  802bb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bbf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bca:	eb 49                	jmp    802c15 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcf:	48 98                	cltq   
  802bd1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bd5:	48 29 c2             	sub    %rax,%rdx
  802bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdb:	48 63 c8             	movslq %eax,%rcx
  802bde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be2:	48 01 c1             	add    %rax,%rcx
  802be5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802be8:	48 89 ce             	mov    %rcx,%rsi
  802beb:	89 c7                	mov    %eax,%edi
  802bed:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
  802bf9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bfc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c00:	79 05                	jns    802c07 <readn+0x57>
			return m;
  802c02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c05:	eb 1c                	jmp    802c23 <readn+0x73>
		if (m == 0)
  802c07:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c0b:	75 02                	jne    802c0f <readn+0x5f>
			break;
  802c0d:	eb 11                	jmp    802c20 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c12:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	48 98                	cltq   
  802c1a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c1e:	72 ac                	jb     802bcc <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c23:	c9                   	leaveq 
  802c24:	c3                   	retq   

0000000000802c25 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	48 83 ec 40          	sub    $0x40,%rsp
  802c2d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c34:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c38:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c3f:	48 89 d6             	mov    %rdx,%rsi
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
  802c50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c57:	78 24                	js     802c7d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5d:	8b 00                	mov    (%rax),%eax
  802c5f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c63:	48 89 d6             	mov    %rdx,%rsi
  802c66:	89 c7                	mov    %eax,%edi
  802c68:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	callq  *%rax
  802c74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7b:	79 05                	jns    802c82 <write+0x5d>
		return r;
  802c7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c80:	eb 75                	jmp    802cf7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c86:	8b 40 08             	mov    0x8(%rax),%eax
  802c89:	83 e0 03             	and    $0x3,%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	75 3a                	jne    802cca <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c90:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c97:	00 00 00 
  802c9a:	48 8b 00             	mov    (%rax),%rax
  802c9d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ca3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ca6:	89 c6                	mov    %eax,%esi
  802ca8:	48 bf db 47 80 00 00 	movabs $0x8047db,%rdi
  802caf:	00 00 00 
  802cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb7:	48 b9 7a 06 80 00 00 	movabs $0x80067a,%rcx
  802cbe:	00 00 00 
  802cc1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cc8:	eb 2d                	jmp    802cf7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cce:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cd2:	48 85 c0             	test   %rax,%rax
  802cd5:	75 07                	jne    802cde <write+0xb9>
		return -E_NOT_SUPP;
  802cd7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cdc:	eb 19                	jmp    802cf7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce2:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ce6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cee:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cf2:	48 89 cf             	mov    %rcx,%rdi
  802cf5:	ff d0                	callq  *%rax
}
  802cf7:	c9                   	leaveq 
  802cf8:	c3                   	retq   

0000000000802cf9 <seek>:

int
seek(int fdnum, off_t offset)
{
  802cf9:	55                   	push   %rbp
  802cfa:	48 89 e5             	mov    %rsp,%rbp
  802cfd:	48 83 ec 18          	sub    $0x18,%rsp
  802d01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d04:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d0e:	48 89 d6             	mov    %rdx,%rsi
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
  802d1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d26:	79 05                	jns    802d2d <seek+0x34>
		return r;
  802d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2b:	eb 0f                	jmp    802d3c <seek+0x43>
	fd->fd_offset = offset;
  802d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d31:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d34:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3c:	c9                   	leaveq 
  802d3d:	c3                   	retq   

0000000000802d3e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d3e:	55                   	push   %rbp
  802d3f:	48 89 e5             	mov    %rsp,%rbp
  802d42:	48 83 ec 30          	sub    $0x30,%rsp
  802d46:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d49:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d4c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d50:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d53:	48 89 d6             	mov    %rdx,%rsi
  802d56:	89 c7                	mov    %eax,%edi
  802d58:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802d5f:	00 00 00 
  802d62:	ff d0                	callq  *%rax
  802d64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6b:	78 24                	js     802d91 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d71:	8b 00                	mov    (%rax),%eax
  802d73:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d77:	48 89 d6             	mov    %rdx,%rsi
  802d7a:	89 c7                	mov    %eax,%edi
  802d7c:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
  802d88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8f:	79 05                	jns    802d96 <ftruncate+0x58>
		return r;
  802d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d94:	eb 72                	jmp    802e08 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9a:	8b 40 08             	mov    0x8(%rax),%eax
  802d9d:	83 e0 03             	and    $0x3,%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	75 3a                	jne    802dde <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802da4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802dab:	00 00 00 
  802dae:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802db1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802db7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dba:	89 c6                	mov    %eax,%esi
  802dbc:	48 bf f8 47 80 00 00 	movabs $0x8047f8,%rdi
  802dc3:	00 00 00 
  802dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcb:	48 b9 7a 06 80 00 00 	movabs $0x80067a,%rcx
  802dd2:	00 00 00 
  802dd5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ddc:	eb 2a                	jmp    802e08 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802de6:	48 85 c0             	test   %rax,%rax
  802de9:	75 07                	jne    802df2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802deb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df0:	eb 16                	jmp    802e08 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dfa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dfe:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e01:	89 ce                	mov    %ecx,%esi
  802e03:	48 89 d7             	mov    %rdx,%rdi
  802e06:	ff d0                	callq  *%rax
}
  802e08:	c9                   	leaveq 
  802e09:	c3                   	retq   

0000000000802e0a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e0a:	55                   	push   %rbp
  802e0b:	48 89 e5             	mov    %rsp,%rbp
  802e0e:	48 83 ec 30          	sub    $0x30,%rsp
  802e12:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e1d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e20:	48 89 d6             	mov    %rdx,%rsi
  802e23:	89 c7                	mov    %eax,%edi
  802e25:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e38:	78 24                	js     802e5e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3e:	8b 00                	mov    (%rax),%eax
  802e40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e44:	48 89 d6             	mov    %rdx,%rsi
  802e47:	89 c7                	mov    %eax,%edi
  802e49:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
  802e55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5c:	79 05                	jns    802e63 <fstat+0x59>
		return r;
  802e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e61:	eb 5e                	jmp    802ec1 <fstat+0xb7>
	if (!dev->dev_stat)
  802e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e67:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e6b:	48 85 c0             	test   %rax,%rax
  802e6e:	75 07                	jne    802e77 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e70:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e75:	eb 4a                	jmp    802ec1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e82:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e89:	00 00 00 
	stat->st_isdir = 0;
  802e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e90:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e97:	00 00 00 
	stat->st_dev = dev;
  802e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ea2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ead:	48 8b 40 28          	mov    0x28(%rax),%rax
  802eb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eb5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802eb9:	48 89 ce             	mov    %rcx,%rsi
  802ebc:	48 89 d7             	mov    %rdx,%rdi
  802ebf:	ff d0                	callq  *%rax
}
  802ec1:	c9                   	leaveq 
  802ec2:	c3                   	retq   

0000000000802ec3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ec3:	55                   	push   %rbp
  802ec4:	48 89 e5             	mov    %rsp,%rbp
  802ec7:	48 83 ec 20          	sub    $0x20,%rsp
  802ecb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ecf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed7:	be 00 00 00 00       	mov    $0x0,%esi
  802edc:	48 89 c7             	mov    %rax,%rdi
  802edf:	48 b8 b1 2f 80 00 00 	movabs $0x802fb1,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
  802eeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef2:	79 05                	jns    802ef9 <stat+0x36>
		return fd;
  802ef4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef7:	eb 2f                	jmp    802f28 <stat+0x65>
	r = fstat(fd, stat);
  802ef9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802efd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f00:	48 89 d6             	mov    %rdx,%rsi
  802f03:	89 c7                	mov    %eax,%edi
  802f05:	48 b8 0a 2e 80 00 00 	movabs $0x802e0a,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f17:	89 c7                	mov    %eax,%edi
  802f19:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
	return r;
  802f25:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f28:	c9                   	leaveq 
  802f29:	c3                   	retq   

0000000000802f2a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f2a:	55                   	push   %rbp
  802f2b:	48 89 e5             	mov    %rsp,%rbp
  802f2e:	48 83 ec 10          	sub    $0x10,%rsp
  802f32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f39:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f40:	00 00 00 
  802f43:	8b 00                	mov    (%rax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	75 1d                	jne    802f66 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f49:	bf 01 00 00 00       	mov    $0x1,%edi
  802f4e:	48 b8 41 25 80 00 00 	movabs $0x802541,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
  802f5a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802f61:	00 00 00 
  802f64:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f66:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f6d:	00 00 00 
  802f70:	8b 00                	mov    (%rax),%eax
  802f72:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f75:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f7a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f81:	00 00 00 
  802f84:	89 c7                	mov    %eax,%edi
  802f86:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f96:	ba 00 00 00 00       	mov    $0x0,%edx
  802f9b:	48 89 c6             	mov    %rax,%rsi
  802f9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa3:	48 b8 e8 23 80 00 00 	movabs $0x8023e8,%rax
  802faa:	00 00 00 
  802fad:	ff d0                	callq  *%rax
}
  802faf:	c9                   	leaveq 
  802fb0:	c3                   	retq   

0000000000802fb1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fb1:	55                   	push   %rbp
  802fb2:	48 89 e5             	mov    %rsp,%rbp
  802fb5:	48 83 ec 20          	sub    $0x20,%rsp
  802fb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fbd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc4:	48 89 c7             	mov    %rax,%rdi
  802fc7:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802fce:	00 00 00 
  802fd1:	ff d0                	callq  *%rax
  802fd3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fd8:	7e 0a                	jle    802fe4 <open+0x33>
		return -E_BAD_PATH;
  802fda:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fdf:	e9 a5 00 00 00       	jmpq   803089 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802fe4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fe8:	48 89 c7             	mov    %rax,%rdi
  802feb:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
  802ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffe:	79 08                	jns    803008 <open+0x57>
		return r;
  803000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803003:	e9 81 00 00 00       	jmpq   803089 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300c:	48 89 c6             	mov    %rax,%rsi
  80300f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803016:	00 00 00 
  803019:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803025:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80302c:	00 00 00 
  80302f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803032:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303c:	48 89 c6             	mov    %rax,%rsi
  80303f:	bf 01 00 00 00       	mov    $0x1,%edi
  803044:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
  803050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803057:	79 1d                	jns    803076 <open+0xc5>
		fd_close(fd, 0);
  803059:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305d:	be 00 00 00 00       	mov    $0x0,%esi
  803062:	48 89 c7             	mov    %rax,%rdi
  803065:	48 b8 39 27 80 00 00 	movabs $0x802739,%rax
  80306c:	00 00 00 
  80306f:	ff d0                	callq  *%rax
		return r;
  803071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803074:	eb 13                	jmp    803089 <open+0xd8>
	}

	return fd2num(fd);
  803076:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307a:	48 89 c7             	mov    %rax,%rdi
  80307d:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  803089:	c9                   	leaveq 
  80308a:	c3                   	retq   

000000000080308b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80308b:	55                   	push   %rbp
  80308c:	48 89 e5             	mov    %rsp,%rbp
  80308f:	48 83 ec 10          	sub    $0x10,%rsp
  803093:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803097:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309b:	8b 50 0c             	mov    0xc(%rax),%edx
  80309e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a5:	00 00 00 
  8030a8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030aa:	be 00 00 00 00       	mov    $0x0,%esi
  8030af:	bf 06 00 00 00       	mov    $0x6,%edi
  8030b4:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
}
  8030c0:	c9                   	leaveq 
  8030c1:	c3                   	retq   

00000000008030c2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030c2:	55                   	push   %rbp
  8030c3:	48 89 e5             	mov    %rsp,%rbp
  8030c6:	48 83 ec 30          	sub    $0x30,%rsp
  8030ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030da:	8b 50 0c             	mov    0xc(%rax),%edx
  8030dd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e4:	00 00 00 
  8030e7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030e9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f0:	00 00 00 
  8030f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030f7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8030fb:	be 00 00 00 00       	mov    $0x0,%esi
  803100:	bf 03 00 00 00       	mov    $0x3,%edi
  803105:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
  803111:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803114:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803118:	79 08                	jns    803122 <devfile_read+0x60>
		return r;
  80311a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311d:	e9 a4 00 00 00       	jmpq   8031c6 <devfile_read+0x104>
	assert(r <= n);
  803122:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803125:	48 98                	cltq   
  803127:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80312b:	76 35                	jbe    803162 <devfile_read+0xa0>
  80312d:	48 b9 25 48 80 00 00 	movabs $0x804825,%rcx
  803134:	00 00 00 
  803137:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  80313e:	00 00 00 
  803141:	be 84 00 00 00       	mov    $0x84,%esi
  803146:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  80314d:	00 00 00 
  803150:	b8 00 00 00 00       	mov    $0x0,%eax
  803155:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  80315c:	00 00 00 
  80315f:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803162:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803169:	7e 35                	jle    8031a0 <devfile_read+0xde>
  80316b:	48 b9 4c 48 80 00 00 	movabs $0x80484c,%rcx
  803172:	00 00 00 
  803175:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  80317c:	00 00 00 
  80317f:	be 85 00 00 00       	mov    $0x85,%esi
  803184:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  80318b:	00 00 00 
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
  803193:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  80319a:	00 00 00 
  80319d:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8031a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a3:	48 63 d0             	movslq %eax,%rdx
  8031a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031aa:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031b1:	00 00 00 
  8031b4:	48 89 c7             	mov    %rax,%rdi
  8031b7:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
	return r;
  8031c3:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8031c6:	c9                   	leaveq 
  8031c7:	c3                   	retq   

00000000008031c8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	48 83 ec 30          	sub    $0x30,%rsp
  8031d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e0:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031ea:	00 00 00 
  8031ed:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8031ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f6:	00 00 00 
  8031f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031fd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  803201:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803208:	00 
  803209:	76 35                	jbe    803240 <devfile_write+0x78>
  80320b:	48 b9 58 48 80 00 00 	movabs $0x804858,%rcx
  803212:	00 00 00 
  803215:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  80321c:	00 00 00 
  80321f:	be 9e 00 00 00       	mov    $0x9e,%esi
  803224:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  80322b:	00 00 00 
  80322e:	b8 00 00 00 00       	mov    $0x0,%eax
  803233:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  80323a:	00 00 00 
  80323d:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803240:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803244:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803248:	48 89 c6             	mov    %rax,%rsi
  80324b:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803252:	00 00 00 
  803255:	48 b8 7d 16 80 00 00 	movabs $0x80167d,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803261:	be 00 00 00 00       	mov    $0x0,%esi
  803266:	bf 04 00 00 00       	mov    $0x4,%edi
  80326b:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
  803277:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327e:	79 05                	jns    803285 <devfile_write+0xbd>
		return r;
  803280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803283:	eb 43                	jmp    8032c8 <devfile_write+0x100>
	assert(r <= n);
  803285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803288:	48 98                	cltq   
  80328a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80328e:	76 35                	jbe    8032c5 <devfile_write+0xfd>
  803290:	48 b9 25 48 80 00 00 	movabs $0x804825,%rcx
  803297:	00 00 00 
  80329a:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  8032a1:	00 00 00 
  8032a4:	be a2 00 00 00       	mov    $0xa2,%esi
  8032a9:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  8032b0:	00 00 00 
  8032b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b8:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  8032bf:	00 00 00 
  8032c2:	41 ff d0             	callq  *%r8
	return r;
  8032c5:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  8032c8:	c9                   	leaveq 
  8032c9:	c3                   	retq   

00000000008032ca <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032ca:	55                   	push   %rbp
  8032cb:	48 89 e5             	mov    %rsp,%rbp
  8032ce:	48 83 ec 20          	sub    $0x20,%rsp
  8032d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032de:	8b 50 0c             	mov    0xc(%rax),%edx
  8032e1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032e8:	00 00 00 
  8032eb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032ed:	be 00 00 00 00       	mov    $0x0,%esi
  8032f2:	bf 05 00 00 00       	mov    $0x5,%edi
  8032f7:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
  803303:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803306:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330a:	79 05                	jns    803311 <devfile_stat+0x47>
		return r;
  80330c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330f:	eb 56                	jmp    803367 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803315:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80331c:	00 00 00 
  80331f:	48 89 c7             	mov    %rax,%rdi
  803322:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  803329:	00 00 00 
  80332c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80332e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803335:	00 00 00 
  803338:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80333e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803342:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803348:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80334f:	00 00 00 
  803352:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803358:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803362:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803367:	c9                   	leaveq 
  803368:	c3                   	retq   

0000000000803369 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803369:	55                   	push   %rbp
  80336a:	48 89 e5             	mov    %rsp,%rbp
  80336d:	48 83 ec 10          	sub    $0x10,%rsp
  803371:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803375:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80337c:	8b 50 0c             	mov    0xc(%rax),%edx
  80337f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803386:	00 00 00 
  803389:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80338b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803392:	00 00 00 
  803395:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803398:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80339b:	be 00 00 00 00       	mov    $0x0,%esi
  8033a0:	bf 02 00 00 00       	mov    $0x2,%edi
  8033a5:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
}
  8033b1:	c9                   	leaveq 
  8033b2:	c3                   	retq   

00000000008033b3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8033b3:	55                   	push   %rbp
  8033b4:	48 89 e5             	mov    %rsp,%rbp
  8033b7:	48 83 ec 10          	sub    $0x10,%rsp
  8033bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c3:	48 89 c7             	mov    %rax,%rdi
  8033c6:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  8033cd:	00 00 00 
  8033d0:	ff d0                	callq  *%rax
  8033d2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033d7:	7e 07                	jle    8033e0 <remove+0x2d>
		return -E_BAD_PATH;
  8033d9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033de:	eb 33                	jmp    803413 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e4:	48 89 c6             	mov    %rax,%rsi
  8033e7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8033ee:	00 00 00 
  8033f1:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  8033f8:	00 00 00 
  8033fb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033fd:	be 00 00 00 00       	mov    $0x0,%esi
  803402:	bf 07 00 00 00       	mov    $0x7,%edi
  803407:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  80340e:	00 00 00 
  803411:	ff d0                	callq  *%rax
}
  803413:	c9                   	leaveq 
  803414:	c3                   	retq   

0000000000803415 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803415:	55                   	push   %rbp
  803416:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803419:	be 00 00 00 00       	mov    $0x0,%esi
  80341e:	bf 08 00 00 00       	mov    $0x8,%edi
  803423:	48 b8 2a 2f 80 00 00 	movabs $0x802f2a,%rax
  80342a:	00 00 00 
  80342d:	ff d0                	callq  *%rax
}
  80342f:	5d                   	pop    %rbp
  803430:	c3                   	retq   

0000000000803431 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80343c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803443:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80344a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803451:	be 00 00 00 00       	mov    $0x0,%esi
  803456:	48 89 c7             	mov    %rax,%rdi
  803459:	48 b8 b1 2f 80 00 00 	movabs $0x802fb1,%rax
  803460:	00 00 00 
  803463:	ff d0                	callq  *%rax
  803465:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803468:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346c:	79 28                	jns    803496 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80346e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803471:	89 c6                	mov    %eax,%esi
  803473:	48 bf 85 48 80 00 00 	movabs $0x804885,%rdi
  80347a:	00 00 00 
  80347d:	b8 00 00 00 00       	mov    $0x0,%eax
  803482:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  803489:	00 00 00 
  80348c:	ff d2                	callq  *%rdx
		return fd_src;
  80348e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803491:	e9 74 01 00 00       	jmpq   80360a <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803496:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80349d:	be 01 01 00 00       	mov    $0x101,%esi
  8034a2:	48 89 c7             	mov    %rax,%rdi
  8034a5:	48 b8 b1 2f 80 00 00 	movabs $0x802fb1,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
  8034b1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8034b4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034b8:	79 39                	jns    8034f3 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8034ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034bd:	89 c6                	mov    %eax,%esi
  8034bf:	48 bf 9b 48 80 00 00 	movabs $0x80489b,%rdi
  8034c6:	00 00 00 
  8034c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ce:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  8034d5:	00 00 00 
  8034d8:	ff d2                	callq  *%rdx
		close(fd_src);
  8034da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034dd:	89 c7                	mov    %eax,%edi
  8034df:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
		return fd_dest;
  8034eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ee:	e9 17 01 00 00       	jmpq   80360a <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8034f3:	eb 74                	jmp    803569 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8034f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034f8:	48 63 d0             	movslq %eax,%rdx
  8034fb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803502:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803505:	48 89 ce             	mov    %rcx,%rsi
  803508:	89 c7                	mov    %eax,%edi
  80350a:	48 b8 25 2c 80 00 00 	movabs $0x802c25,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
  803516:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803519:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80351d:	79 4a                	jns    803569 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80351f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803522:	89 c6                	mov    %eax,%esi
  803524:	48 bf b5 48 80 00 00 	movabs $0x8048b5,%rdi
  80352b:	00 00 00 
  80352e:	b8 00 00 00 00       	mov    $0x0,%eax
  803533:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  80353a:	00 00 00 
  80353d:	ff d2                	callq  *%rdx
			close(fd_src);
  80353f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803542:	89 c7                	mov    %eax,%edi
  803544:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
			close(fd_dest);
  803550:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803553:	89 c7                	mov    %eax,%edi
  803555:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
			return write_size;
  803561:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803564:	e9 a1 00 00 00       	jmpq   80360a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803569:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803573:	ba 00 02 00 00       	mov    $0x200,%edx
  803578:	48 89 ce             	mov    %rcx,%rsi
  80357b:	89 c7                	mov    %eax,%edi
  80357d:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80358c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803590:	0f 8f 5f ff ff ff    	jg     8034f5 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803596:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80359a:	79 47                	jns    8035e3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80359c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80359f:	89 c6                	mov    %eax,%esi
  8035a1:	48 bf c8 48 80 00 00 	movabs $0x8048c8,%rdi
  8035a8:	00 00 00 
  8035ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b0:	48 ba 7a 06 80 00 00 	movabs $0x80067a,%rdx
  8035b7:	00 00 00 
  8035ba:	ff d2                	callq  *%rdx
		close(fd_src);
  8035bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bf:	89 c7                	mov    %eax,%edi
  8035c1:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  8035c8:	00 00 00 
  8035cb:	ff d0                	callq  *%rax
		close(fd_dest);
  8035cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035d0:	89 c7                	mov    %eax,%edi
  8035d2:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
		return read_size;
  8035de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035e1:	eb 27                	jmp    80360a <copy+0x1d9>
	}
	close(fd_src);
  8035e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e6:	89 c7                	mov    %eax,%edi
  8035e8:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  8035ef:	00 00 00 
  8035f2:	ff d0                	callq  *%rax
	close(fd_dest);
  8035f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f7:	89 c7                	mov    %eax,%edi
  8035f9:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  803600:	00 00 00 
  803603:	ff d0                	callq  *%rax
	return 0;
  803605:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80360a:	c9                   	leaveq 
  80360b:	c3                   	retq   

000000000080360c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80360c:	55                   	push   %rbp
  80360d:	48 89 e5             	mov    %rsp,%rbp
  803610:	48 83 ec 18          	sub    $0x18,%rsp
  803614:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361c:	48 c1 e8 15          	shr    $0x15,%rax
  803620:	48 89 c2             	mov    %rax,%rdx
  803623:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80362a:	01 00 00 
  80362d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803631:	83 e0 01             	and    $0x1,%eax
  803634:	48 85 c0             	test   %rax,%rax
  803637:	75 07                	jne    803640 <pageref+0x34>
		return 0;
  803639:	b8 00 00 00 00       	mov    $0x0,%eax
  80363e:	eb 53                	jmp    803693 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803644:	48 c1 e8 0c          	shr    $0xc,%rax
  803648:	48 89 c2             	mov    %rax,%rdx
  80364b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803652:	01 00 00 
  803655:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803659:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80365d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803661:	83 e0 01             	and    $0x1,%eax
  803664:	48 85 c0             	test   %rax,%rax
  803667:	75 07                	jne    803670 <pageref+0x64>
		return 0;
  803669:	b8 00 00 00 00       	mov    $0x0,%eax
  80366e:	eb 23                	jmp    803693 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803674:	48 c1 e8 0c          	shr    $0xc,%rax
  803678:	48 89 c2             	mov    %rax,%rdx
  80367b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803682:	00 00 00 
  803685:	48 c1 e2 04          	shl    $0x4,%rdx
  803689:	48 01 d0             	add    %rdx,%rax
  80368c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803690:	0f b7 c0             	movzwl %ax,%eax
}
  803693:	c9                   	leaveq 
  803694:	c3                   	retq   

0000000000803695 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803695:	55                   	push   %rbp
  803696:	48 89 e5             	mov    %rsp,%rbp
  803699:	53                   	push   %rbx
  80369a:	48 83 ec 38          	sub    $0x38,%rsp
  80369e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036a2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8036a6:	48 89 c7             	mov    %rax,%rdi
  8036a9:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8036b0:	00 00 00 
  8036b3:	ff d0                	callq  *%rax
  8036b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036bc:	0f 88 bf 01 00 00    	js     803881 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036cb:	48 89 c6             	mov    %rax,%rsi
  8036ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d3:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036e6:	0f 88 95 01 00 00    	js     803881 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036ec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036f0:	48 89 c7             	mov    %rax,%rdi
  8036f3:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
  8036ff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803702:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803706:	0f 88 5d 01 00 00    	js     803869 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80370c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803710:	ba 07 04 00 00       	mov    $0x407,%edx
  803715:	48 89 c6             	mov    %rax,%rsi
  803718:	bf 00 00 00 00       	mov    $0x0,%edi
  80371d:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80372c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803730:	0f 88 33 01 00 00    	js     803869 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373a:	48 89 c7             	mov    %rax,%rdi
  80373d:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803744:	00 00 00 
  803747:	ff d0                	callq  *%rax
  803749:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80374d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803751:	ba 07 04 00 00       	mov    $0x407,%edx
  803756:	48 89 c6             	mov    %rax,%rsi
  803759:	bf 00 00 00 00       	mov    $0x0,%edi
  80375e:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
  80376a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80376d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803771:	79 05                	jns    803778 <pipe+0xe3>
		goto err2;
  803773:	e9 d9 00 00 00       	jmpq   803851 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803778:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80377c:	48 89 c7             	mov    %rax,%rdi
  80377f:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
  80378b:	48 89 c2             	mov    %rax,%rdx
  80378e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803792:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803798:	48 89 d1             	mov    %rdx,%rcx
  80379b:	ba 00 00 00 00       	mov    $0x0,%edx
  8037a0:	48 89 c6             	mov    %rax,%rsi
  8037a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a8:	48 b8 c1 1b 80 00 00 	movabs $0x801bc1,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
  8037b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037bb:	79 1b                	jns    8037d8 <pipe+0x143>
		goto err3;
  8037bd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c2:	48 89 c6             	mov    %rax,%rsi
  8037c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ca:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
  8037d6:	eb 79                	jmp    803851 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037dc:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8037e3:	00 00 00 
  8037e6:	8b 12                	mov    (%rdx),%edx
  8037e8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f9:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803800:	00 00 00 
  803803:	8b 12                	mov    (%rdx),%edx
  803805:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803807:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803816:	48 89 c7             	mov    %rax,%rdi
  803819:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
  803825:	89 c2                	mov    %eax,%edx
  803827:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80382b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80382d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803831:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803835:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803839:	48 89 c7             	mov    %rax,%rdi
  80383c:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
  803848:	89 03                	mov    %eax,(%rbx)
	return 0;
  80384a:	b8 00 00 00 00       	mov    $0x0,%eax
  80384f:	eb 33                	jmp    803884 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803851:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803855:	48 89 c6             	mov    %rax,%rsi
  803858:	bf 00 00 00 00       	mov    $0x0,%edi
  80385d:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  803864:	00 00 00 
  803867:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803869:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80386d:	48 89 c6             	mov    %rax,%rsi
  803870:	bf 00 00 00 00       	mov    $0x0,%edi
  803875:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
err:
	return r;
  803881:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803884:	48 83 c4 38          	add    $0x38,%rsp
  803888:	5b                   	pop    %rbx
  803889:	5d                   	pop    %rbp
  80388a:	c3                   	retq   

000000000080388b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80388b:	55                   	push   %rbp
  80388c:	48 89 e5             	mov    %rsp,%rbp
  80388f:	53                   	push   %rbx
  803890:	48 83 ec 28          	sub    $0x28,%rsp
  803894:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803898:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80389c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038a3:	00 00 00 
  8038a6:	48 8b 00             	mov    (%rax),%rax
  8038a9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038af:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b6:	48 89 c7             	mov    %rax,%rdi
  8038b9:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
  8038c5:	89 c3                	mov    %eax,%ebx
  8038c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038cb:	48 89 c7             	mov    %rax,%rdi
  8038ce:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  8038d5:	00 00 00 
  8038d8:	ff d0                	callq  *%rax
  8038da:	39 c3                	cmp    %eax,%ebx
  8038dc:	0f 94 c0             	sete   %al
  8038df:	0f b6 c0             	movzbl %al,%eax
  8038e2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038ec:	00 00 00 
  8038ef:	48 8b 00             	mov    (%rax),%rax
  8038f2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038f8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038fe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803901:	75 05                	jne    803908 <_pipeisclosed+0x7d>
			return ret;
  803903:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803906:	eb 4f                	jmp    803957 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803908:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80390b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80390e:	74 42                	je     803952 <_pipeisclosed+0xc7>
  803910:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803914:	75 3c                	jne    803952 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803916:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80391d:	00 00 00 
  803920:	48 8b 00             	mov    (%rax),%rax
  803923:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803929:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80392c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80392f:	89 c6                	mov    %eax,%esi
  803931:	48 bf e3 48 80 00 00 	movabs $0x8048e3,%rdi
  803938:	00 00 00 
  80393b:	b8 00 00 00 00       	mov    $0x0,%eax
  803940:	49 b8 7a 06 80 00 00 	movabs $0x80067a,%r8
  803947:	00 00 00 
  80394a:	41 ff d0             	callq  *%r8
	}
  80394d:	e9 4a ff ff ff       	jmpq   80389c <_pipeisclosed+0x11>
  803952:	e9 45 ff ff ff       	jmpq   80389c <_pipeisclosed+0x11>
}
  803957:	48 83 c4 28          	add    $0x28,%rsp
  80395b:	5b                   	pop    %rbx
  80395c:	5d                   	pop    %rbp
  80395d:	c3                   	retq   

000000000080395e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80395e:	55                   	push   %rbp
  80395f:	48 89 e5             	mov    %rsp,%rbp
  803962:	48 83 ec 30          	sub    $0x30,%rsp
  803966:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803969:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80396d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803970:	48 89 d6             	mov    %rdx,%rsi
  803973:	89 c7                	mov    %eax,%edi
  803975:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
  803981:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803984:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803988:	79 05                	jns    80398f <pipeisclosed+0x31>
		return r;
  80398a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398d:	eb 31                	jmp    8039c0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80398f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803993:	48 89 c7             	mov    %rax,%rdi
  803996:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  80399d:	00 00 00 
  8039a0:	ff d0                	callq  *%rax
  8039a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039ae:	48 89 d6             	mov    %rdx,%rsi
  8039b1:	48 89 c7             	mov    %rax,%rdi
  8039b4:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
}
  8039c0:	c9                   	leaveq 
  8039c1:	c3                   	retq   

00000000008039c2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039c2:	55                   	push   %rbp
  8039c3:	48 89 e5             	mov    %rsp,%rbp
  8039c6:	48 83 ec 40          	sub    $0x40,%rsp
  8039ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039da:	48 89 c7             	mov    %rax,%rdi
  8039dd:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  8039e4:	00 00 00 
  8039e7:	ff d0                	callq  *%rax
  8039e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039fc:	00 
  8039fd:	e9 92 00 00 00       	jmpq   803a94 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803a02:	eb 41                	jmp    803a45 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a04:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a09:	74 09                	je     803a14 <devpipe_read+0x52>
				return i;
  803a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0f:	e9 92 00 00 00       	jmpq   803aa6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a1c:	48 89 d6             	mov    %rdx,%rsi
  803a1f:	48 89 c7             	mov    %rax,%rdi
  803a22:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
  803a2e:	85 c0                	test   %eax,%eax
  803a30:	74 07                	je     803a39 <devpipe_read+0x77>
				return 0;
  803a32:	b8 00 00 00 00       	mov    $0x0,%eax
  803a37:	eb 6d                	jmp    803aa6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a39:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a49:	8b 10                	mov    (%rax),%edx
  803a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4f:	8b 40 04             	mov    0x4(%rax),%eax
  803a52:	39 c2                	cmp    %eax,%edx
  803a54:	74 ae                	je     803a04 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a5e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a66:	8b 00                	mov    (%rax),%eax
  803a68:	99                   	cltd   
  803a69:	c1 ea 1b             	shr    $0x1b,%edx
  803a6c:	01 d0                	add    %edx,%eax
  803a6e:	83 e0 1f             	and    $0x1f,%eax
  803a71:	29 d0                	sub    %edx,%eax
  803a73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a77:	48 98                	cltq   
  803a79:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a7e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a84:	8b 00                	mov    (%rax),%eax
  803a86:	8d 50 01             	lea    0x1(%rax),%edx
  803a89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a8f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a98:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a9c:	0f 82 60 ff ff ff    	jb     803a02 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803aa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803aa6:	c9                   	leaveq 
  803aa7:	c3                   	retq   

0000000000803aa8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803aa8:	55                   	push   %rbp
  803aa9:	48 89 e5             	mov    %rsp,%rbp
  803aac:	48 83 ec 40          	sub    $0x40,%rsp
  803ab0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ab4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ab8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803abc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac0:	48 89 c7             	mov    %rax,%rdi
  803ac3:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803aca:	00 00 00 
  803acd:	ff d0                	callq  *%rax
  803acf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ad3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ad7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803adb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ae2:	00 
  803ae3:	e9 8e 00 00 00       	jmpq   803b76 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ae8:	eb 31                	jmp    803b1b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803aea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af2:	48 89 d6             	mov    %rdx,%rsi
  803af5:	48 89 c7             	mov    %rax,%rdi
  803af8:	48 b8 8b 38 80 00 00 	movabs $0x80388b,%rax
  803aff:	00 00 00 
  803b02:	ff d0                	callq  *%rax
  803b04:	85 c0                	test   %eax,%eax
  803b06:	74 07                	je     803b0f <devpipe_write+0x67>
				return 0;
  803b08:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0d:	eb 79                	jmp    803b88 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b0f:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  803b16:	00 00 00 
  803b19:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1f:	8b 40 04             	mov    0x4(%rax),%eax
  803b22:	48 63 d0             	movslq %eax,%rdx
  803b25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b29:	8b 00                	mov    (%rax),%eax
  803b2b:	48 98                	cltq   
  803b2d:	48 83 c0 20          	add    $0x20,%rax
  803b31:	48 39 c2             	cmp    %rax,%rdx
  803b34:	73 b4                	jae    803aea <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3a:	8b 40 04             	mov    0x4(%rax),%eax
  803b3d:	99                   	cltd   
  803b3e:	c1 ea 1b             	shr    $0x1b,%edx
  803b41:	01 d0                	add    %edx,%eax
  803b43:	83 e0 1f             	and    $0x1f,%eax
  803b46:	29 d0                	sub    %edx,%eax
  803b48:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b4c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b50:	48 01 ca             	add    %rcx,%rdx
  803b53:	0f b6 0a             	movzbl (%rdx),%ecx
  803b56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b5a:	48 98                	cltq   
  803b5c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b64:	8b 40 04             	mov    0x4(%rax),%eax
  803b67:	8d 50 01             	lea    0x1(%rax),%edx
  803b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b71:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b7a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b7e:	0f 82 64 ff ff ff    	jb     803ae8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b88:	c9                   	leaveq 
  803b89:	c3                   	retq   

0000000000803b8a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b8a:	55                   	push   %rbp
  803b8b:	48 89 e5             	mov    %rsp,%rbp
  803b8e:	48 83 ec 20          	sub    $0x20,%rsp
  803b92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b9e:	48 89 c7             	mov    %rax,%rdi
  803ba1:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
  803bad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803bb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bb5:	48 be f6 48 80 00 00 	movabs $0x8048f6,%rsi
  803bbc:	00 00 00 
  803bbf:	48 89 c7             	mov    %rax,%rdi
  803bc2:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd2:	8b 50 04             	mov    0x4(%rax),%edx
  803bd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd9:	8b 00                	mov    (%rax),%eax
  803bdb:	29 c2                	sub    %eax,%edx
  803bdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803be1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803be7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803beb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803bf2:	00 00 00 
	stat->st_dev = &devpipe;
  803bf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf9:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803c00:	00 00 00 
  803c03:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c0f:	c9                   	leaveq 
  803c10:	c3                   	retq   

0000000000803c11 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c11:	55                   	push   %rbp
  803c12:	48 89 e5             	mov    %rsp,%rbp
  803c15:	48 83 ec 10          	sub    $0x10,%rsp
  803c19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c21:	48 89 c6             	mov    %rax,%rsi
  803c24:	bf 00 00 00 00       	mov    $0x0,%edi
  803c29:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c39:	48 89 c7             	mov    %rax,%rdi
  803c3c:	48 b8 e6 25 80 00 00 	movabs $0x8025e6,%rax
  803c43:	00 00 00 
  803c46:	ff d0                	callq  *%rax
  803c48:	48 89 c6             	mov    %rax,%rsi
  803c4b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c50:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
}
  803c5c:	c9                   	leaveq 
  803c5d:	c3                   	retq   

0000000000803c5e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c5e:	55                   	push   %rbp
  803c5f:	48 89 e5             	mov    %rsp,%rbp
  803c62:	48 83 ec 20          	sub    $0x20,%rsp
  803c66:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c6c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c6f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c73:	be 01 00 00 00       	mov    $0x1,%esi
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 29 1a 80 00 00 	movabs $0x801a29,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
}
  803c87:	c9                   	leaveq 
  803c88:	c3                   	retq   

0000000000803c89 <getchar>:

int
getchar(void)
{
  803c89:	55                   	push   %rbp
  803c8a:	48 89 e5             	mov    %rsp,%rbp
  803c8d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c91:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c95:	ba 01 00 00 00       	mov    $0x1,%edx
  803c9a:	48 89 c6             	mov    %rax,%rsi
  803c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca2:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
  803cae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803cb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb5:	79 05                	jns    803cbc <getchar+0x33>
		return r;
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cba:	eb 14                	jmp    803cd0 <getchar+0x47>
	if (r < 1)
  803cbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc0:	7f 07                	jg     803cc9 <getchar+0x40>
		return -E_EOF;
  803cc2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cc7:	eb 07                	jmp    803cd0 <getchar+0x47>
	return c;
  803cc9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ccd:	0f b6 c0             	movzbl %al,%eax
}
  803cd0:	c9                   	leaveq 
  803cd1:	c3                   	retq   

0000000000803cd2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cd2:	55                   	push   %rbp
  803cd3:	48 89 e5             	mov    %rsp,%rbp
  803cd6:	48 83 ec 20          	sub    $0x20,%rsp
  803cda:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ce1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ce4:	48 89 d6             	mov    %rdx,%rsi
  803ce7:	89 c7                	mov    %eax,%edi
  803ce9:	48 b8 a9 26 80 00 00 	movabs $0x8026a9,%rax
  803cf0:	00 00 00 
  803cf3:	ff d0                	callq  *%rax
  803cf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfc:	79 05                	jns    803d03 <iscons+0x31>
		return r;
  803cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d01:	eb 1a                	jmp    803d1d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d07:	8b 10                	mov    (%rax),%edx
  803d09:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803d10:	00 00 00 
  803d13:	8b 00                	mov    (%rax),%eax
  803d15:	39 c2                	cmp    %eax,%edx
  803d17:	0f 94 c0             	sete   %al
  803d1a:	0f b6 c0             	movzbl %al,%eax
}
  803d1d:	c9                   	leaveq 
  803d1e:	c3                   	retq   

0000000000803d1f <opencons>:

int
opencons(void)
{
  803d1f:	55                   	push   %rbp
  803d20:	48 89 e5             	mov    %rsp,%rbp
  803d23:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d27:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d2b:	48 89 c7             	mov    %rax,%rdi
  803d2e:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
  803d3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d41:	79 05                	jns    803d48 <opencons+0x29>
		return r;
  803d43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d46:	eb 5b                	jmp    803da3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d4c:	ba 07 04 00 00       	mov    $0x407,%edx
  803d51:	48 89 c6             	mov    %rax,%rsi
  803d54:	bf 00 00 00 00       	mov    $0x0,%edi
  803d59:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  803d60:	00 00 00 
  803d63:	ff d0                	callq  *%rax
  803d65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6c:	79 05                	jns    803d73 <opencons+0x54>
		return r;
  803d6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d71:	eb 30                	jmp    803da3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d77:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803d7e:	00 00 00 
  803d81:	8b 12                	mov    (%rdx),%edx
  803d83:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d89:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d94:	48 89 c7             	mov    %rax,%rdi
  803d97:	48 b8 c3 25 80 00 00 	movabs $0x8025c3,%rax
  803d9e:	00 00 00 
  803da1:	ff d0                	callq  *%rax
}
  803da3:	c9                   	leaveq 
  803da4:	c3                   	retq   

0000000000803da5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803da5:	55                   	push   %rbp
  803da6:	48 89 e5             	mov    %rsp,%rbp
  803da9:	48 83 ec 30          	sub    $0x30,%rsp
  803dad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803db1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803db5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803db9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dbe:	75 07                	jne    803dc7 <devcons_read+0x22>
		return 0;
  803dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc5:	eb 4b                	jmp    803e12 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803dc7:	eb 0c                	jmp    803dd5 <devcons_read+0x30>
		sys_yield();
  803dc9:	48 b8 33 1b 80 00 00 	movabs $0x801b33,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dd5:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803ddc:	00 00 00 
  803ddf:	ff d0                	callq  *%rax
  803de1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de8:	74 df                	je     803dc9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dee:	79 05                	jns    803df5 <devcons_read+0x50>
		return c;
  803df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df3:	eb 1d                	jmp    803e12 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803df5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803df9:	75 07                	jne    803e02 <devcons_read+0x5d>
		return 0;
  803dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803e00:	eb 10                	jmp    803e12 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e05:	89 c2                	mov    %eax,%edx
  803e07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e0b:	88 10                	mov    %dl,(%rax)
	return 1;
  803e0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e12:	c9                   	leaveq 
  803e13:	c3                   	retq   

0000000000803e14 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e14:	55                   	push   %rbp
  803e15:	48 89 e5             	mov    %rsp,%rbp
  803e18:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e1f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e26:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e2d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e3b:	eb 76                	jmp    803eb3 <devcons_write+0x9f>
		m = n - tot;
  803e3d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e44:	89 c2                	mov    %eax,%edx
  803e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e49:	29 c2                	sub    %eax,%edx
  803e4b:	89 d0                	mov    %edx,%eax
  803e4d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e53:	83 f8 7f             	cmp    $0x7f,%eax
  803e56:	76 07                	jbe    803e5f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e58:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e62:	48 63 d0             	movslq %eax,%rdx
  803e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e68:	48 63 c8             	movslq %eax,%rcx
  803e6b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e72:	48 01 c1             	add    %rax,%rcx
  803e75:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e7c:	48 89 ce             	mov    %rcx,%rsi
  803e7f:	48 89 c7             	mov    %rax,%rdi
  803e82:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e91:	48 63 d0             	movslq %eax,%rdx
  803e94:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e9b:	48 89 d6             	mov    %rdx,%rsi
  803e9e:	48 89 c7             	mov    %rax,%rdi
  803ea1:	48 b8 29 1a 80 00 00 	movabs $0x801a29,%rax
  803ea8:	00 00 00 
  803eab:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ead:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eb0:	01 45 fc             	add    %eax,-0x4(%rbp)
  803eb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb6:	48 98                	cltq   
  803eb8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ebf:	0f 82 78 ff ff ff    	jb     803e3d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ec8:	c9                   	leaveq 
  803ec9:	c3                   	retq   

0000000000803eca <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803eca:	55                   	push   %rbp
  803ecb:	48 89 e5             	mov    %rsp,%rbp
  803ece:	48 83 ec 08          	sub    $0x8,%rsp
  803ed2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803edb:	c9                   	leaveq 
  803edc:	c3                   	retq   

0000000000803edd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803edd:	55                   	push   %rbp
  803ede:	48 89 e5             	mov    %rsp,%rbp
  803ee1:	48 83 ec 10          	sub    $0x10,%rsp
  803ee5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ee9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef1:	48 be 02 49 80 00 00 	movabs $0x804902,%rsi
  803ef8:	00 00 00 
  803efb:	48 89 c7             	mov    %rax,%rdi
  803efe:	48 b8 42 12 80 00 00 	movabs $0x801242,%rax
  803f05:	00 00 00 
  803f08:	ff d0                	callq  *%rax
	return 0;
  803f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f0f:	c9                   	leaveq 
  803f10:	c3                   	retq   

0000000000803f11 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803f11:	55                   	push   %rbp
  803f12:	48 89 e5             	mov    %rsp,%rbp
  803f15:	48 83 ec 10          	sub    $0x10,%rsp
  803f19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803f1d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f24:	00 00 00 
  803f27:	48 8b 00             	mov    (%rax),%rax
  803f2a:	48 85 c0             	test   %rax,%rax
  803f2d:	75 49                	jne    803f78 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803f2f:	ba 07 00 00 00       	mov    $0x7,%edx
  803f34:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803f39:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3e:	48 b8 71 1b 80 00 00 	movabs $0x801b71,%rax
  803f45:	00 00 00 
  803f48:	ff d0                	callq  *%rax
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	79 2a                	jns    803f78 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803f4e:	48 ba 10 49 80 00 00 	movabs $0x804910,%rdx
  803f55:	00 00 00 
  803f58:	be 21 00 00 00       	mov    $0x21,%esi
  803f5d:	48 bf 3b 49 80 00 00 	movabs $0x80493b,%rdi
  803f64:	00 00 00 
  803f67:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6c:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  803f73:	00 00 00 
  803f76:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803f78:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f7f:	00 00 00 
  803f82:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f86:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803f89:	48 be d4 3f 80 00 00 	movabs $0x803fd4,%rsi
  803f90:	00 00 00 
  803f93:	bf 00 00 00 00       	mov    $0x0,%edi
  803f98:	48 b8 fb 1c 80 00 00 	movabs $0x801cfb,%rax
  803f9f:	00 00 00 
  803fa2:	ff d0                	callq  *%rax
  803fa4:	85 c0                	test   %eax,%eax
  803fa6:	79 2a                	jns    803fd2 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803fa8:	48 ba 50 49 80 00 00 	movabs $0x804950,%rdx
  803faf:	00 00 00 
  803fb2:	be 27 00 00 00       	mov    $0x27,%esi
  803fb7:	48 bf 3b 49 80 00 00 	movabs $0x80493b,%rdi
  803fbe:	00 00 00 
  803fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803fc6:	48 b9 41 04 80 00 00 	movabs $0x800441,%rcx
  803fcd:	00 00 00 
  803fd0:	ff d1                	callq  *%rcx
}
  803fd2:	c9                   	leaveq 
  803fd3:	c3                   	retq   

0000000000803fd4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803fd4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803fd7:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803fde:	00 00 00 
call *%rax
  803fe1:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803fe3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803fea:	00 
    movq 152(%rsp), %rcx
  803feb:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803ff2:	00 
    subq $8, %rcx
  803ff3:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803ff7:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803ffa:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804001:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  804002:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804006:	4c 8b 3c 24          	mov    (%rsp),%r15
  80400a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80400f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804014:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804019:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80401e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804023:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804028:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80402d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804032:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804037:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80403c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804041:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804046:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80404b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804050:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  804054:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  804058:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  804059:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  80405a:	c3                   	retq   
