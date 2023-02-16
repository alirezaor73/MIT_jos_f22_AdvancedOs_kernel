
obj/user/testpiperace2:     file format elf64-x86-64


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
  80003c:	e8 ea 02 00 00       	callq  80032b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 cf 33 80 00 00 	movabs $0x8033cf,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 22 40 80 00 00 	movabs $0x804022,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 40 40 80 00 00 	movabs $0x804040,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf 49 40 80 00 00 	movabs $0x804049,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 f5 26 80 00 00 	movabs $0x8026f5,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 bc 03 80 00 00 	movabs $0x8003bc,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 63 d0             	movslq %eax,%rdx
  8001d3:	48 89 d0             	mov    %rdx,%rax
  8001d6:	48 c1 e0 03          	shl    $0x3,%rax
  8001da:	48 01 d0             	add    %rdx,%rax
  8001dd:	48 c1 e0 05          	shl    $0x5,%rax
  8001e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e8:	00 00 00 
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001f2:	eb 4d                	jmp    800241 <umain+0x1fe>
		if (pipeisclosed(p[0]) != 0) {
  8001f4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001f7:	89 c7                	mov    %eax,%edi
  8001f9:	48 b8 98 36 80 00 00 	movabs $0x803698,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
  800205:	85 c0                	test   %eax,%eax
  800207:	74 38                	je     800241 <umain+0x1fe>
			cprintf("\nRACE: pipe appears closed\n");
  800209:	48 bf 4d 40 80 00 00 	movabs $0x80404d,%rdi
  800210:	00 00 00 
  800213:	b8 00 00 00 00       	mov    $0x0,%eax
  800218:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  80021f:	00 00 00 
  800222:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  800224:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800227:	89 c7                	mov    %eax,%edi
  800229:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
			exit();
  800235:	48 b8 bc 03 80 00 00 	movabs $0x8003bc,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80024b:	83 f8 02             	cmp    $0x2,%eax
  80024e:	74 a4                	je     8001f4 <umain+0x1b1>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800250:	48 bf 69 40 80 00 00 	movabs $0x804069,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  800266:	00 00 00 
  800269:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80026b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 98 36 80 00 00 	movabs $0x803698,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	74 2a                	je     8002aa <umain+0x267>
		panic("somehow the other end of p[0] got closed!");
  800280:	48 ba 80 40 80 00 00 	movabs $0x804080,%rdx
  800287:	00 00 00 
  80028a:	be 40 00 00 00       	mov    $0x40,%esi
  80028f:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  800296:	00 00 00 
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
  80029e:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  8002a5:	00 00 00 
  8002a8:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002b1:	48 89 d6             	mov    %rdx,%rsi
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c9:	79 30                	jns    8002fb <umain+0x2b8>
		panic("cannot look up p[0]: %e", r);
  8002cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba aa 40 80 00 00 	movabs $0x8040aa,%rdx
  8002d7:	00 00 00 
  8002da:	be 42 00 00 00       	mov    $0x42,%esi
  8002df:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002ff:	48 89 c7             	mov    %rax,%rdi
  800302:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80030e:	48 bf c2 40 80 00 00 	movabs $0x8040c2,%rdi
  800315:	00 00 00 
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  800324:	00 00 00 
  800327:	ff d2                	callq  *%rdx
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 83 ec 20          	sub    $0x20,%rsp
  800333:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800336:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80033a:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
  800346:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800351:	48 63 d0             	movslq %eax,%rdx
  800354:	48 89 d0             	mov    %rdx,%rax
  800357:	48 c1 e0 03          	shl    $0x3,%rax
  80035b:	48 01 d0             	add    %rdx,%rax
  80035e:	48 c1 e0 05          	shl    $0x5,%rax
  800362:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800369:	00 00 00 
  80036c:	48 01 c2             	add    %rax,%rdx
  80036f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800376:	00 00 00 
  800379:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800380:	7e 14                	jle    800396 <libmain+0x6b>
		binaryname = argv[0];
  800382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800386:	48 8b 10             	mov    (%rax),%rdx
  800389:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800390:	00 00 00 
  800393:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800396:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80039a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80039d:	48 89 d6             	mov    %rdx,%rsi
  8003a0:	89 c7                	mov    %eax,%edi
  8003a2:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003a9:	00 00 00 
  8003ac:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003ae:	48 b8 bc 03 80 00 00 	movabs $0x8003bc,%rax
  8003b5:	00 00 00 
  8003b8:	ff d0                	callq  *%rax
}
  8003ba:	c9                   	leaveq 
  8003bb:	c3                   	retq   

00000000008003bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003bc:	55                   	push   %rbp
  8003bd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003c0:	48 b8 c7 26 80 00 00 	movabs $0x8026c7,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d1:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	callq  *%rax
}
  8003dd:	5d                   	pop    %rbp
  8003de:	c3                   	retq   

00000000008003df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003df:	55                   	push   %rbp
  8003e0:	48 89 e5             	mov    %rsp,%rbp
  8003e3:	53                   	push   %rbx
  8003e4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003eb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003f2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003f8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003ff:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800406:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80040d:	84 c0                	test   %al,%al
  80040f:	74 23                	je     800434 <_panic+0x55>
  800411:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800418:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80041c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800420:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800424:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800428:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80042c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800430:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800434:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80043b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800442:	00 00 00 
  800445:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80044c:	00 00 00 
  80044f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800453:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80045a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800461:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800468:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80046f:	00 00 00 
  800472:	48 8b 18             	mov    (%rax),%rbx
  800475:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
  800481:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800487:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80048e:	41 89 c8             	mov    %ecx,%r8d
  800491:	48 89 d1             	mov    %rdx,%rcx
  800494:	48 89 da             	mov    %rbx,%rdx
  800497:	89 c6                	mov    %eax,%esi
  800499:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
  8004a0:	00 00 00 
  8004a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a8:	49 b9 18 06 80 00 00 	movabs $0x800618,%r9
  8004af:	00 00 00 
  8004b2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004b5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004bc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	cprintf("\n");
  8004d5:	48 bf 03 41 80 00 00 	movabs $0x804103,%rdi
  8004dc:	00 00 00 
  8004df:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e4:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  8004eb:	00 00 00 
  8004ee:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004f0:	cc                   	int3   
  8004f1:	eb fd                	jmp    8004f0 <_panic+0x111>

00000000008004f3 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004f3:	55                   	push   %rbp
  8004f4:	48 89 e5             	mov    %rsp,%rbp
  8004f7:	48 83 ec 10          	sub    $0x10,%rsp
  8004fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800506:	8b 00                	mov    (%rax),%eax
  800508:	8d 48 01             	lea    0x1(%rax),%ecx
  80050b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80050f:	89 0a                	mov    %ecx,(%rdx)
  800511:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800514:	89 d1                	mov    %edx,%ecx
  800516:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051a:	48 98                	cltq   
  80051c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052b:	75 2c                	jne    800559 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80052d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	48 98                	cltq   
  800535:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800539:	48 83 c2 08          	add    $0x8,%rdx
  80053d:	48 89 c6             	mov    %rax,%rsi
  800540:	48 89 d7             	mov    %rdx,%rdi
  800543:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  80054a:	00 00 00 
  80054d:	ff d0                	callq  *%rax
        b->idx = 0;
  80054f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800553:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055d:	8b 40 04             	mov    0x4(%rax),%eax
  800560:	8d 50 01             	lea    0x1(%rax),%edx
  800563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800567:	89 50 04             	mov    %edx,0x4(%rax)
}
  80056a:	c9                   	leaveq 
  80056b:	c3                   	retq   

000000000080056c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80056c:	55                   	push   %rbp
  80056d:	48 89 e5             	mov    %rsp,%rbp
  800570:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800577:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80057e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800585:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80058c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800593:	48 8b 0a             	mov    (%rdx),%rcx
  800596:	48 89 08             	mov    %rcx,(%rax)
  800599:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80059d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005b0:	00 00 00 
    b.cnt = 0;
  8005b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005ba:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005bd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005c4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005cb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005d2:	48 89 c6             	mov    %rax,%rsi
  8005d5:	48 bf f3 04 80 00 00 	movabs $0x8004f3,%rdi
  8005dc:	00 00 00 
  8005df:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  8005e6:	00 00 00 
  8005e9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005eb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005f1:	48 98                	cltq   
  8005f3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005fa:	48 83 c2 08          	add    $0x8,%rdx
  8005fe:	48 89 c6             	mov    %rax,%rsi
  800601:	48 89 d7             	mov    %rdx,%rdi
  800604:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  80060b:	00 00 00 
  80060e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800610:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800616:	c9                   	leaveq 
  800617:	c3                   	retq   

0000000000800618 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800618:	55                   	push   %rbp
  800619:	48 89 e5             	mov    %rsp,%rbp
  80061c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800623:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80062a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800631:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800638:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80063f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800646:	84 c0                	test   %al,%al
  800648:	74 20                	je     80066a <cprintf+0x52>
  80064a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80064e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800652:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800656:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80065a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80065e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800662:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800666:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80066a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800671:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800678:	00 00 00 
  80067b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800682:	00 00 00 
  800685:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800689:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800690:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800697:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80069e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006a5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ac:	48 8b 0a             	mov    (%rdx),%rcx
  8006af:	48 89 08             	mov    %rcx,(%rax)
  8006b2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006be:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006c2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006c9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d0:	48 89 d6             	mov    %rdx,%rsi
  8006d3:	48 89 c7             	mov    %rax,%rdi
  8006d6:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  8006dd:	00 00 00 
  8006e0:	ff d0                	callq  *%rax
  8006e2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006e8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006ee:	c9                   	leaveq 
  8006ef:	c3                   	retq   

00000000008006f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f0:	55                   	push   %rbp
  8006f1:	48 89 e5             	mov    %rsp,%rbp
  8006f4:	53                   	push   %rbx
  8006f5:	48 83 ec 38          	sub    $0x38,%rsp
  8006f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800701:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800705:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800708:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80070c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800710:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800713:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800717:	77 3b                	ja     800754 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800719:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80071c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800720:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	48 f7 f3             	div    %rbx
  80072f:	48 89 c2             	mov    %rax,%rdx
  800732:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800735:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800738:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	41 89 f9             	mov    %edi,%r9d
  800743:	48 89 c7             	mov    %rax,%rdi
  800746:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  80074d:	00 00 00 
  800750:	ff d0                	callq  *%rax
  800752:	eb 1e                	jmp    800772 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800754:	eb 12                	jmp    800768 <printnum+0x78>
			putch(padc, putdat);
  800756:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80075a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 89 ce             	mov    %rcx,%rsi
  800764:	89 d7                	mov    %edx,%edi
  800766:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800768:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80076c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800770:	7f e4                	jg     800756 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800772:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800779:	ba 00 00 00 00       	mov    $0x0,%edx
  80077e:	48 f7 f1             	div    %rcx
  800781:	48 89 d0             	mov    %rdx,%rax
  800784:	48 ba 10 43 80 00 00 	movabs $0x804310,%rdx
  80078b:	00 00 00 
  80078e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800792:	0f be d0             	movsbl %al,%edx
  800795:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	48 89 ce             	mov    %rcx,%rsi
  8007a0:	89 d7                	mov    %edx,%edi
  8007a2:	ff d0                	callq  *%rax
}
  8007a4:	48 83 c4 38          	add    $0x38,%rsp
  8007a8:	5b                   	pop    %rbx
  8007a9:	5d                   	pop    %rbp
  8007aa:	c3                   	retq   

00000000008007ab <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ab:	55                   	push   %rbp
  8007ac:	48 89 e5             	mov    %rsp,%rbp
  8007af:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8007ba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007be:	7e 52                	jle    800812 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c4:	8b 00                	mov    (%rax),%eax
  8007c6:	83 f8 30             	cmp    $0x30,%eax
  8007c9:	73 24                	jae    8007ef <getuint+0x44>
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d7:	8b 00                	mov    (%rax),%eax
  8007d9:	89 c0                	mov    %eax,%eax
  8007db:	48 01 d0             	add    %rdx,%rax
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	8b 12                	mov    (%rdx),%edx
  8007e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007eb:	89 0a                	mov    %ecx,(%rdx)
  8007ed:	eb 17                	jmp    800806 <getuint+0x5b>
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f7:	48 89 d0             	mov    %rdx,%rax
  8007fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800802:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800806:	48 8b 00             	mov    (%rax),%rax
  800809:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080d:	e9 a3 00 00 00       	jmpq   8008b5 <getuint+0x10a>
	else if (lflag)
  800812:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800816:	74 4f                	je     800867 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	8b 00                	mov    (%rax),%eax
  80081e:	83 f8 30             	cmp    $0x30,%eax
  800821:	73 24                	jae    800847 <getuint+0x9c>
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	8b 00                	mov    (%rax),%eax
  800831:	89 c0                	mov    %eax,%eax
  800833:	48 01 d0             	add    %rdx,%rax
  800836:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083a:	8b 12                	mov    (%rdx),%edx
  80083c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	89 0a                	mov    %ecx,(%rdx)
  800845:	eb 17                	jmp    80085e <getuint+0xb3>
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084f:	48 89 d0             	mov    %rdx,%rax
  800852:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085e:	48 8b 00             	mov    (%rax),%rax
  800861:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800865:	eb 4e                	jmp    8008b5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	8b 00                	mov    (%rax),%eax
  80086d:	83 f8 30             	cmp    $0x30,%eax
  800870:	73 24                	jae    800896 <getuint+0xeb>
  800872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800876:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087e:	8b 00                	mov    (%rax),%eax
  800880:	89 c0                	mov    %eax,%eax
  800882:	48 01 d0             	add    %rdx,%rax
  800885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800889:	8b 12                	mov    (%rdx),%edx
  80088b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800892:	89 0a                	mov    %ecx,(%rdx)
  800894:	eb 17                	jmp    8008ad <getuint+0x102>
  800896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089e:	48 89 d0             	mov    %rdx,%rax
  8008a1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ad:	8b 00                	mov    (%rax),%eax
  8008af:	89 c0                	mov    %eax,%eax
  8008b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b9:	c9                   	leaveq 
  8008ba:	c3                   	retq   

00000000008008bb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008bb:	55                   	push   %rbp
  8008bc:	48 89 e5             	mov    %rsp,%rbp
  8008bf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008ca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ce:	7e 52                	jle    800922 <getint+0x67>
		x=va_arg(*ap, long long);
  8008d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d4:	8b 00                	mov    (%rax),%eax
  8008d6:	83 f8 30             	cmp    $0x30,%eax
  8008d9:	73 24                	jae    8008ff <getint+0x44>
  8008db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e7:	8b 00                	mov    (%rax),%eax
  8008e9:	89 c0                	mov    %eax,%eax
  8008eb:	48 01 d0             	add    %rdx,%rax
  8008ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f2:	8b 12                	mov    (%rdx),%edx
  8008f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fb:	89 0a                	mov    %ecx,(%rdx)
  8008fd:	eb 17                	jmp    800916 <getint+0x5b>
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800907:	48 89 d0             	mov    %rdx,%rax
  80090a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800912:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800916:	48 8b 00             	mov    (%rax),%rax
  800919:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091d:	e9 a3 00 00 00       	jmpq   8009c5 <getint+0x10a>
	else if (lflag)
  800922:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800926:	74 4f                	je     800977 <getint+0xbc>
		x=va_arg(*ap, long);
  800928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092c:	8b 00                	mov    (%rax),%eax
  80092e:	83 f8 30             	cmp    $0x30,%eax
  800931:	73 24                	jae    800957 <getint+0x9c>
  800933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800937:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093f:	8b 00                	mov    (%rax),%eax
  800941:	89 c0                	mov    %eax,%eax
  800943:	48 01 d0             	add    %rdx,%rax
  800946:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094a:	8b 12                	mov    (%rdx),%edx
  80094c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	89 0a                	mov    %ecx,(%rdx)
  800955:	eb 17                	jmp    80096e <getint+0xb3>
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095f:	48 89 d0             	mov    %rdx,%rax
  800962:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800966:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80096e:	48 8b 00             	mov    (%rax),%rax
  800971:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800975:	eb 4e                	jmp    8009c5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097b:	8b 00                	mov    (%rax),%eax
  80097d:	83 f8 30             	cmp    $0x30,%eax
  800980:	73 24                	jae    8009a6 <getint+0xeb>
  800982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800986:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80098a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098e:	8b 00                	mov    (%rax),%eax
  800990:	89 c0                	mov    %eax,%eax
  800992:	48 01 d0             	add    %rdx,%rax
  800995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800999:	8b 12                	mov    (%rdx),%edx
  80099b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a2:	89 0a                	mov    %ecx,(%rdx)
  8009a4:	eb 17                	jmp    8009bd <getint+0x102>
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ae:	48 89 d0             	mov    %rdx,%rax
  8009b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009bd:	8b 00                	mov    (%rax),%eax
  8009bf:	48 98                	cltq   
  8009c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c9:	c9                   	leaveq 
  8009ca:	c3                   	retq   

00000000008009cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009cb:	55                   	push   %rbp
  8009cc:	48 89 e5             	mov    %rsp,%rbp
  8009cf:	41 54                	push   %r12
  8009d1:	53                   	push   %rbx
  8009d2:	48 83 ec 60          	sub    $0x60,%rsp
  8009d6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009da:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009de:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ea:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009ee:	48 8b 0a             	mov    (%rdx),%rcx
  8009f1:	48 89 08             	mov    %rcx,(%rax)
  8009f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a00:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a04:	eb 17                	jmp    800a1d <vprintfmt+0x52>
			if (ch == '\0')
  800a06:	85 db                	test   %ebx,%ebx
  800a08:	0f 84 df 04 00 00    	je     800eed <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800a0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a16:	48 89 d6             	mov    %rdx,%rsi
  800a19:	89 df                	mov    %ebx,%edi
  800a1b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a1d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a21:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a25:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a29:	0f b6 00             	movzbl (%rax),%eax
  800a2c:	0f b6 d8             	movzbl %al,%ebx
  800a2f:	83 fb 25             	cmp    $0x25,%ebx
  800a32:	75 d2                	jne    800a06 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a34:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a38:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a3f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a4d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a54:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a58:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a5c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a60:	0f b6 00             	movzbl (%rax),%eax
  800a63:	0f b6 d8             	movzbl %al,%ebx
  800a66:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a69:	83 f8 55             	cmp    $0x55,%eax
  800a6c:	0f 87 47 04 00 00    	ja     800eb9 <vprintfmt+0x4ee>
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a7b:	00 
  800a7c:	48 b8 38 43 80 00 00 	movabs $0x804338,%rax
  800a83:	00 00 00 
  800a86:	48 01 d0             	add    %rdx,%rax
  800a89:	48 8b 00             	mov    (%rax),%rax
  800a8c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a8e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a92:	eb c0                	jmp    800a54 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a94:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a98:	eb ba                	jmp    800a54 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a9a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aa1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aa4:	89 d0                	mov    %edx,%eax
  800aa6:	c1 e0 02             	shl    $0x2,%eax
  800aa9:	01 d0                	add    %edx,%eax
  800aab:	01 c0                	add    %eax,%eax
  800aad:	01 d8                	add    %ebx,%eax
  800aaf:	83 e8 30             	sub    $0x30,%eax
  800ab2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ab5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab9:	0f b6 00             	movzbl (%rax),%eax
  800abc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800abf:	83 fb 2f             	cmp    $0x2f,%ebx
  800ac2:	7e 0c                	jle    800ad0 <vprintfmt+0x105>
  800ac4:	83 fb 39             	cmp    $0x39,%ebx
  800ac7:	7f 07                	jg     800ad0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ace:	eb d1                	jmp    800aa1 <vprintfmt+0xd6>
			goto process_precision;
  800ad0:	eb 58                	jmp    800b2a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ad2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad5:	83 f8 30             	cmp    $0x30,%eax
  800ad8:	73 17                	jae    800af1 <vprintfmt+0x126>
  800ada:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ade:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae1:	89 c0                	mov    %eax,%eax
  800ae3:	48 01 d0             	add    %rdx,%rax
  800ae6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae9:	83 c2 08             	add    $0x8,%edx
  800aec:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aef:	eb 0f                	jmp    800b00 <vprintfmt+0x135>
  800af1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af5:	48 89 d0             	mov    %rdx,%rax
  800af8:	48 83 c2 08          	add    $0x8,%rdx
  800afc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b00:	8b 00                	mov    (%rax),%eax
  800b02:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b05:	eb 23                	jmp    800b2a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0b:	79 0c                	jns    800b19 <vprintfmt+0x14e>
				width = 0;
  800b0d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b14:	e9 3b ff ff ff       	jmpq   800a54 <vprintfmt+0x89>
  800b19:	e9 36 ff ff ff       	jmpq   800a54 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b1e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b25:	e9 2a ff ff ff       	jmpq   800a54 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2e:	79 12                	jns    800b42 <vprintfmt+0x177>
				width = precision, precision = -1;
  800b30:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b33:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b36:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b3d:	e9 12 ff ff ff       	jmpq   800a54 <vprintfmt+0x89>
  800b42:	e9 0d ff ff ff       	jmpq   800a54 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b47:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b4b:	e9 04 ff ff ff       	jmpq   800a54 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b53:	83 f8 30             	cmp    $0x30,%eax
  800b56:	73 17                	jae    800b6f <vprintfmt+0x1a4>
  800b58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5f:	89 c0                	mov    %eax,%eax
  800b61:	48 01 d0             	add    %rdx,%rax
  800b64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b67:	83 c2 08             	add    $0x8,%edx
  800b6a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6d:	eb 0f                	jmp    800b7e <vprintfmt+0x1b3>
  800b6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b73:	48 89 d0             	mov    %rdx,%rax
  800b76:	48 83 c2 08          	add    $0x8,%rdx
  800b7a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b7e:	8b 10                	mov    (%rax),%edx
  800b80:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b88:	48 89 ce             	mov    %rcx,%rsi
  800b8b:	89 d7                	mov    %edx,%edi
  800b8d:	ff d0                	callq  *%rax
			break;
  800b8f:	e9 53 03 00 00       	jmpq   800ee7 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b97:	83 f8 30             	cmp    $0x30,%eax
  800b9a:	73 17                	jae    800bb3 <vprintfmt+0x1e8>
  800b9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba3:	89 c0                	mov    %eax,%eax
  800ba5:	48 01 d0             	add    %rdx,%rax
  800ba8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bab:	83 c2 08             	add    $0x8,%edx
  800bae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb1:	eb 0f                	jmp    800bc2 <vprintfmt+0x1f7>
  800bb3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb7:	48 89 d0             	mov    %rdx,%rax
  800bba:	48 83 c2 08          	add    $0x8,%rdx
  800bbe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bc4:	85 db                	test   %ebx,%ebx
  800bc6:	79 02                	jns    800bca <vprintfmt+0x1ff>
				err = -err;
  800bc8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bca:	83 fb 15             	cmp    $0x15,%ebx
  800bcd:	7f 16                	jg     800be5 <vprintfmt+0x21a>
  800bcf:	48 b8 60 42 80 00 00 	movabs $0x804260,%rax
  800bd6:	00 00 00 
  800bd9:	48 63 d3             	movslq %ebx,%rdx
  800bdc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800be0:	4d 85 e4             	test   %r12,%r12
  800be3:	75 2e                	jne    800c13 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800be5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bed:	89 d9                	mov    %ebx,%ecx
  800bef:	48 ba 21 43 80 00 00 	movabs $0x804321,%rdx
  800bf6:	00 00 00 
  800bf9:	48 89 c7             	mov    %rax,%rdi
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	49 b8 f6 0e 80 00 00 	movabs $0x800ef6,%r8
  800c08:	00 00 00 
  800c0b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c0e:	e9 d4 02 00 00       	jmpq   800ee7 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c13:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1b:	4c 89 e1             	mov    %r12,%rcx
  800c1e:	48 ba 2a 43 80 00 00 	movabs $0x80432a,%rdx
  800c25:	00 00 00 
  800c28:	48 89 c7             	mov    %rax,%rdi
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	49 b8 f6 0e 80 00 00 	movabs $0x800ef6,%r8
  800c37:	00 00 00 
  800c3a:	41 ff d0             	callq  *%r8
			break;
  800c3d:	e9 a5 02 00 00       	jmpq   800ee7 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c45:	83 f8 30             	cmp    $0x30,%eax
  800c48:	73 17                	jae    800c61 <vprintfmt+0x296>
  800c4a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c51:	89 c0                	mov    %eax,%eax
  800c53:	48 01 d0             	add    %rdx,%rax
  800c56:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c59:	83 c2 08             	add    $0x8,%edx
  800c5c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c5f:	eb 0f                	jmp    800c70 <vprintfmt+0x2a5>
  800c61:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c65:	48 89 d0             	mov    %rdx,%rax
  800c68:	48 83 c2 08          	add    $0x8,%rdx
  800c6c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c70:	4c 8b 20             	mov    (%rax),%r12
  800c73:	4d 85 e4             	test   %r12,%r12
  800c76:	75 0a                	jne    800c82 <vprintfmt+0x2b7>
				p = "(null)";
  800c78:	49 bc 2d 43 80 00 00 	movabs $0x80432d,%r12
  800c7f:	00 00 00 
			if (width > 0 && padc != '-')
  800c82:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c86:	7e 3f                	jle    800cc7 <vprintfmt+0x2fc>
  800c88:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c8c:	74 39                	je     800cc7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c8e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c91:	48 98                	cltq   
  800c93:	48 89 c6             	mov    %rax,%rsi
  800c96:	4c 89 e7             	mov    %r12,%rdi
  800c99:	48 b8 a2 11 80 00 00 	movabs $0x8011a2,%rax
  800ca0:	00 00 00 
  800ca3:	ff d0                	callq  *%rax
  800ca5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca8:	eb 17                	jmp    800cc1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800caa:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cae:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb6:	48 89 ce             	mov    %rcx,%rsi
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cbd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cc1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc5:	7f e3                	jg     800caa <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc7:	eb 37                	jmp    800d00 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ccd:	74 1e                	je     800ced <vprintfmt+0x322>
  800ccf:	83 fb 1f             	cmp    $0x1f,%ebx
  800cd2:	7e 05                	jle    800cd9 <vprintfmt+0x30e>
  800cd4:	83 fb 7e             	cmp    $0x7e,%ebx
  800cd7:	7e 14                	jle    800ced <vprintfmt+0x322>
					putch('?', putdat);
  800cd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce1:	48 89 d6             	mov    %rdx,%rsi
  800ce4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce9:	ff d0                	callq  *%rax
  800ceb:	eb 0f                	jmp    800cfc <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ced:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf5:	48 89 d6             	mov    %rdx,%rsi
  800cf8:	89 df                	mov    %ebx,%edi
  800cfa:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d00:	4c 89 e0             	mov    %r12,%rax
  800d03:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d07:	0f b6 00             	movzbl (%rax),%eax
  800d0a:	0f be d8             	movsbl %al,%ebx
  800d0d:	85 db                	test   %ebx,%ebx
  800d0f:	74 10                	je     800d21 <vprintfmt+0x356>
  800d11:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d15:	78 b2                	js     800cc9 <vprintfmt+0x2fe>
  800d17:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d1f:	79 a8                	jns    800cc9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d21:	eb 16                	jmp    800d39 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2b:	48 89 d6             	mov    %rdx,%rsi
  800d2e:	bf 20 00 00 00       	mov    $0x20,%edi
  800d33:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3d:	7f e4                	jg     800d23 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d3f:	e9 a3 01 00 00       	jmpq   800ee7 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d48:	be 03 00 00 00       	mov    $0x3,%esi
  800d4d:	48 89 c7             	mov    %rax,%rdi
  800d50:	48 b8 bb 08 80 00 00 	movabs $0x8008bb,%rax
  800d57:	00 00 00 
  800d5a:	ff d0                	callq  *%rax
  800d5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d64:	48 85 c0             	test   %rax,%rax
  800d67:	79 1d                	jns    800d86 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d71:	48 89 d6             	mov    %rdx,%rsi
  800d74:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d79:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7f:	48 f7 d8             	neg    %rax
  800d82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d86:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d8d:	e9 e8 00 00 00       	jmpq   800e7a <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d96:	be 03 00 00 00       	mov    $0x3,%esi
  800d9b:	48 89 c7             	mov    %rax,%rdi
  800d9e:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800da5:	00 00 00 
  800da8:	ff d0                	callq  *%rax
  800daa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db5:	e9 c0 00 00 00       	jmpq   800e7a <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc2:	48 89 d6             	mov    %rdx,%rsi
  800dc5:	bf 58 00 00 00       	mov    $0x58,%edi
  800dca:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd4:	48 89 d6             	mov    %rdx,%rsi
  800dd7:	bf 58 00 00 00       	mov    $0x58,%edi
  800ddc:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de6:	48 89 d6             	mov    %rdx,%rsi
  800de9:	bf 58 00 00 00       	mov    $0x58,%edi
  800dee:	ff d0                	callq  *%rax
			break;
  800df0:	e9 f2 00 00 00       	jmpq   800ee7 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800df5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfd:	48 89 d6             	mov    %rdx,%rsi
  800e00:	bf 30 00 00 00       	mov    $0x30,%edi
  800e05:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0f:	48 89 d6             	mov    %rdx,%rsi
  800e12:	bf 78 00 00 00       	mov    $0x78,%edi
  800e17:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1c:	83 f8 30             	cmp    $0x30,%eax
  800e1f:	73 17                	jae    800e38 <vprintfmt+0x46d>
  800e21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e28:	89 c0                	mov    %eax,%eax
  800e2a:	48 01 d0             	add    %rdx,%rax
  800e2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e30:	83 c2 08             	add    $0x8,%edx
  800e33:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e36:	eb 0f                	jmp    800e47 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800e38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3c:	48 89 d0             	mov    %rdx,%rax
  800e3f:	48 83 c2 08          	add    $0x8,%rdx
  800e43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e47:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e4e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e55:	eb 23                	jmp    800e7a <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e5b:	be 03 00 00 00       	mov    $0x3,%esi
  800e60:	48 89 c7             	mov    %rax,%rdi
  800e63:	48 b8 ab 07 80 00 00 	movabs $0x8007ab,%rax
  800e6a:	00 00 00 
  800e6d:	ff d0                	callq  *%rax
  800e6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e73:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e7a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e7f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e82:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e89:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e91:	45 89 c1             	mov    %r8d,%r9d
  800e94:	41 89 f8             	mov    %edi,%r8d
  800e97:	48 89 c7             	mov    %rax,%rdi
  800e9a:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
			break;
  800ea6:	eb 3f                	jmp    800ee7 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb0:	48 89 d6             	mov    %rdx,%rsi
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	ff d0                	callq  *%rax
			break;
  800eb7:	eb 2e                	jmp    800ee7 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eb9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ebd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec1:	48 89 d6             	mov    %rdx,%rsi
  800ec4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ec9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ecb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ed0:	eb 05                	jmp    800ed7 <vprintfmt+0x50c>
  800ed2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ed7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800edb:	48 83 e8 01          	sub    $0x1,%rax
  800edf:	0f b6 00             	movzbl (%rax),%eax
  800ee2:	3c 25                	cmp    $0x25,%al
  800ee4:	75 ec                	jne    800ed2 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800ee6:	90                   	nop
		}
	}
  800ee7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee8:	e9 30 fb ff ff       	jmpq   800a1d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800eed:	48 83 c4 60          	add    $0x60,%rsp
  800ef1:	5b                   	pop    %rbx
  800ef2:	41 5c                	pop    %r12
  800ef4:	5d                   	pop    %rbp
  800ef5:	c3                   	retq   

0000000000800ef6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ef6:	55                   	push   %rbp
  800ef7:	48 89 e5             	mov    %rsp,%rbp
  800efa:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f01:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f08:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f0f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f16:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f1d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f24:	84 c0                	test   %al,%al
  800f26:	74 20                	je     800f48 <printfmt+0x52>
  800f28:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f2c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f30:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f34:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f38:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f3c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f40:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f44:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f48:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f4f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f56:	00 00 00 
  800f59:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f60:	00 00 00 
  800f63:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f67:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f6e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f75:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f7c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f83:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f8a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f91:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fa7:	c9                   	leaveq 
  800fa8:	c3                   	retq   

0000000000800fa9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa9:	55                   	push   %rbp
  800faa:	48 89 e5             	mov    %rsp,%rbp
  800fad:	48 83 ec 10          	sub    $0x10,%rsp
  800fb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fb4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbc:	8b 40 10             	mov    0x10(%rax),%eax
  800fbf:	8d 50 01             	lea    0x1(%rax),%edx
  800fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcd:	48 8b 10             	mov    (%rax),%rdx
  800fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd4:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fd8:	48 39 c2             	cmp    %rax,%rdx
  800fdb:	73 17                	jae    800ff4 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe1:	48 8b 00             	mov    (%rax),%rax
  800fe4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fe8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fec:	48 89 0a             	mov    %rcx,(%rdx)
  800fef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ff2:	88 10                	mov    %dl,(%rax)
}
  800ff4:	c9                   	leaveq 
  800ff5:	c3                   	retq   

0000000000800ff6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ff6:	55                   	push   %rbp
  800ff7:	48 89 e5             	mov    %rsp,%rbp
  800ffa:	48 83 ec 50          	sub    $0x50,%rsp
  800ffe:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801002:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801005:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801009:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80100d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801011:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801015:	48 8b 0a             	mov    (%rdx),%rcx
  801018:	48 89 08             	mov    %rcx,(%rax)
  80101b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80101f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801023:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801027:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80102b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801033:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801036:	48 98                	cltq   
  801038:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80103c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801040:	48 01 d0             	add    %rdx,%rax
  801043:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801047:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80104e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801053:	74 06                	je     80105b <vsnprintf+0x65>
  801055:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801059:	7f 07                	jg     801062 <vsnprintf+0x6c>
		return -E_INVAL;
  80105b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801060:	eb 2f                	jmp    801091 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801062:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801066:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80106a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80106e:	48 89 c6             	mov    %rax,%rsi
  801071:	48 bf a9 0f 80 00 00 	movabs $0x800fa9,%rdi
  801078:	00 00 00 
  80107b:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801087:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80108b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80108e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801091:	c9                   	leaveq 
  801092:	c3                   	retq   

0000000000801093 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801093:	55                   	push   %rbp
  801094:	48 89 e5             	mov    %rsp,%rbp
  801097:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80109e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010a5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010ab:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010b2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010c0:	84 c0                	test   %al,%al
  8010c2:	74 20                	je     8010e4 <snprintf+0x51>
  8010c4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010c8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010cc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010d0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010d4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010d8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010dc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010e0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010e4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010eb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010f2:	00 00 00 
  8010f5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010fc:	00 00 00 
  8010ff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801103:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80110a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801111:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801118:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80111f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801126:	48 8b 0a             	mov    (%rdx),%rcx
  801129:	48 89 08             	mov    %rcx,(%rax)
  80112c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801130:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801134:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801138:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80113c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801143:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80114a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801150:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801157:	48 89 c7             	mov    %rax,%rdi
  80115a:	48 b8 f6 0f 80 00 00 	movabs $0x800ff6,%rax
  801161:	00 00 00 
  801164:	ff d0                	callq  *%rax
  801166:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80116c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801172:	c9                   	leaveq 
  801173:	c3                   	retq   

0000000000801174 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801174:	55                   	push   %rbp
  801175:	48 89 e5             	mov    %rsp,%rbp
  801178:	48 83 ec 18          	sub    $0x18,%rsp
  80117c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801187:	eb 09                	jmp    801192 <strlen+0x1e>
		n++;
  801189:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80118d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801196:	0f b6 00             	movzbl (%rax),%eax
  801199:	84 c0                	test   %al,%al
  80119b:	75 ec                	jne    801189 <strlen+0x15>
		n++;
	return n;
  80119d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011a0:	c9                   	leaveq 
  8011a1:	c3                   	retq   

00000000008011a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011a2:	55                   	push   %rbp
  8011a3:	48 89 e5             	mov    %rsp,%rbp
  8011a6:	48 83 ec 20          	sub    $0x20,%rsp
  8011aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b9:	eb 0e                	jmp    8011c9 <strnlen+0x27>
		n++;
  8011bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011ce:	74 0b                	je     8011db <strnlen+0x39>
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	0f b6 00             	movzbl (%rax),%eax
  8011d7:	84 c0                	test   %al,%al
  8011d9:	75 e0                	jne    8011bb <strnlen+0x19>
		n++;
	return n;
  8011db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011de:	c9                   	leaveq 
  8011df:	c3                   	retq   

00000000008011e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011e0:	55                   	push   %rbp
  8011e1:	48 89 e5             	mov    %rsp,%rbp
  8011e4:	48 83 ec 20          	sub    $0x20,%rsp
  8011e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011f8:	90                   	nop
  8011f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801201:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801205:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801209:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80120d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801211:	0f b6 12             	movzbl (%rdx),%edx
  801214:	88 10                	mov    %dl,(%rax)
  801216:	0f b6 00             	movzbl (%rax),%eax
  801219:	84 c0                	test   %al,%al
  80121b:	75 dc                	jne    8011f9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801221:	c9                   	leaveq 
  801222:	c3                   	retq   

0000000000801223 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801223:	55                   	push   %rbp
  801224:	48 89 e5             	mov    %rsp,%rbp
  801227:	48 83 ec 20          	sub    $0x20,%rsp
  80122b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801233:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801237:	48 89 c7             	mov    %rax,%rdi
  80123a:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  801241:	00 00 00 
  801244:	ff d0                	callq  *%rax
  801246:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80124c:	48 63 d0             	movslq %eax,%rdx
  80124f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801253:	48 01 c2             	add    %rax,%rdx
  801256:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80125a:	48 89 c6             	mov    %rax,%rsi
  80125d:	48 89 d7             	mov    %rdx,%rdi
  801260:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  801267:	00 00 00 
  80126a:	ff d0                	callq  *%rax
	return dst;
  80126c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801270:	c9                   	leaveq 
  801271:	c3                   	retq   

0000000000801272 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	48 83 ec 28          	sub    $0x28,%rsp
  80127a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80128e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801295:	00 
  801296:	eb 2a                	jmp    8012c2 <strncpy+0x50>
		*dst++ = *src;
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a8:	0f b6 12             	movzbl (%rdx),%edx
  8012ab:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b1:	0f b6 00             	movzbl (%rax),%eax
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 05                	je     8012bd <strncpy+0x4b>
			src++;
  8012b8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012ca:	72 cc                	jb     801298 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012d0:	c9                   	leaveq 
  8012d1:	c3                   	retq   

00000000008012d2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012d2:	55                   	push   %rbp
  8012d3:	48 89 e5             	mov    %rsp,%rbp
  8012d6:	48 83 ec 28          	sub    $0x28,%rsp
  8012da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012f3:	74 3d                	je     801332 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012f5:	eb 1d                	jmp    801314 <strlcpy+0x42>
			*dst++ = *src++;
  8012f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801303:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801307:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80130b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80130f:	0f b6 12             	movzbl (%rdx),%edx
  801312:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801314:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801319:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80131e:	74 0b                	je     80132b <strlcpy+0x59>
  801320:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801324:	0f b6 00             	movzbl (%rax),%eax
  801327:	84 c0                	test   %al,%al
  801329:	75 cc                	jne    8012f7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801332:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133a:	48 29 c2             	sub    %rax,%rdx
  80133d:	48 89 d0             	mov    %rdx,%rax
}
  801340:	c9                   	leaveq 
  801341:	c3                   	retq   

0000000000801342 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801342:	55                   	push   %rbp
  801343:	48 89 e5             	mov    %rsp,%rbp
  801346:	48 83 ec 10          	sub    $0x10,%rsp
  80134a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801352:	eb 0a                	jmp    80135e <strcmp+0x1c>
		p++, q++;
  801354:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801359:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80135e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801362:	0f b6 00             	movzbl (%rax),%eax
  801365:	84 c0                	test   %al,%al
  801367:	74 12                	je     80137b <strcmp+0x39>
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	0f b6 10             	movzbl (%rax),%edx
  801370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801374:	0f b6 00             	movzbl (%rax),%eax
  801377:	38 c2                	cmp    %al,%dl
  801379:	74 d9                	je     801354 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80137b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137f:	0f b6 00             	movzbl (%rax),%eax
  801382:	0f b6 d0             	movzbl %al,%edx
  801385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 c0             	movzbl %al,%eax
  80138f:	29 c2                	sub    %eax,%edx
  801391:	89 d0                	mov    %edx,%eax
}
  801393:	c9                   	leaveq 
  801394:	c3                   	retq   

0000000000801395 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
  801399:	48 83 ec 18          	sub    $0x18,%rsp
  80139d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 0f                	jmp    8013ba <strncmp+0x25>
		n--, p++, q++;
  8013ab:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013bf:	74 1d                	je     8013de <strncmp+0x49>
  8013c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c5:	0f b6 00             	movzbl (%rax),%eax
  8013c8:	84 c0                	test   %al,%al
  8013ca:	74 12                	je     8013de <strncmp+0x49>
  8013cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d0:	0f b6 10             	movzbl (%rax),%edx
  8013d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	38 c2                	cmp    %al,%dl
  8013dc:	74 cd                	je     8013ab <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013e3:	75 07                	jne    8013ec <strncmp+0x57>
		return 0;
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	eb 18                	jmp    801404 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	0f b6 d0             	movzbl %al,%edx
  8013f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f b6 c0             	movzbl %al,%eax
  801400:	29 c2                	sub    %eax,%edx
  801402:	89 d0                	mov    %edx,%eax
}
  801404:	c9                   	leaveq 
  801405:	c3                   	retq   

0000000000801406 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801406:	55                   	push   %rbp
  801407:	48 89 e5             	mov    %rsp,%rbp
  80140a:	48 83 ec 0c          	sub    $0xc,%rsp
  80140e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801412:	89 f0                	mov    %esi,%eax
  801414:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801417:	eb 17                	jmp    801430 <strchr+0x2a>
		if (*s == c)
  801419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141d:	0f b6 00             	movzbl (%rax),%eax
  801420:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801423:	75 06                	jne    80142b <strchr+0x25>
			return (char *) s;
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	eb 15                	jmp    801440 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80142b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	84 c0                	test   %al,%al
  801439:	75 de                	jne    801419 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80143b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801440:	c9                   	leaveq 
  801441:	c3                   	retq   

0000000000801442 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801442:	55                   	push   %rbp
  801443:	48 89 e5             	mov    %rsp,%rbp
  801446:	48 83 ec 0c          	sub    $0xc,%rsp
  80144a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144e:	89 f0                	mov    %esi,%eax
  801450:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801453:	eb 13                	jmp    801468 <strfind+0x26>
		if (*s == c)
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80145f:	75 02                	jne    801463 <strfind+0x21>
			break;
  801461:	eb 10                	jmp    801473 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801463:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146c:	0f b6 00             	movzbl (%rax),%eax
  80146f:	84 c0                	test   %al,%al
  801471:	75 e2                	jne    801455 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801477:	c9                   	leaveq 
  801478:	c3                   	retq   

0000000000801479 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801479:	55                   	push   %rbp
  80147a:	48 89 e5             	mov    %rsp,%rbp
  80147d:	48 83 ec 18          	sub    $0x18,%rsp
  801481:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801485:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801488:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80148c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801491:	75 06                	jne    801499 <memset+0x20>
		return v;
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	eb 69                	jmp    801502 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	83 e0 03             	and    $0x3,%eax
  8014a0:	48 85 c0             	test   %rax,%rax
  8014a3:	75 48                	jne    8014ed <memset+0x74>
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a9:	83 e0 03             	and    $0x3,%eax
  8014ac:	48 85 c0             	test   %rax,%rax
  8014af:	75 3c                	jne    8014ed <memset+0x74>
		c &= 0xFF;
  8014b1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014bb:	c1 e0 18             	shl    $0x18,%eax
  8014be:	89 c2                	mov    %eax,%edx
  8014c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c3:	c1 e0 10             	shl    $0x10,%eax
  8014c6:	09 c2                	or     %eax,%edx
  8014c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cb:	c1 e0 08             	shl    $0x8,%eax
  8014ce:	09 d0                	or     %edx,%eax
  8014d0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d7:	48 c1 e8 02          	shr    $0x2,%rax
  8014db:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e5:	48 89 d7             	mov    %rdx,%rdi
  8014e8:	fc                   	cld    
  8014e9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014eb:	eb 11                	jmp    8014fe <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014f8:	48 89 d7             	mov    %rdx,%rdi
  8014fb:	fc                   	cld    
  8014fc:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801502:	c9                   	leaveq 
  801503:	c3                   	retq   

0000000000801504 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	48 83 ec 28          	sub    $0x28,%rsp
  80150c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801510:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801514:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801518:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80151c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801524:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801530:	0f 83 88 00 00 00    	jae    8015be <memmove+0xba>
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153e:	48 01 d0             	add    %rdx,%rax
  801541:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801545:	76 77                	jbe    8015be <memmove+0xba>
		s += n;
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80154f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801553:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	83 e0 03             	and    $0x3,%eax
  80155e:	48 85 c0             	test   %rax,%rax
  801561:	75 3b                	jne    80159e <memmove+0x9a>
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801567:	83 e0 03             	and    $0x3,%eax
  80156a:	48 85 c0             	test   %rax,%rax
  80156d:	75 2f                	jne    80159e <memmove+0x9a>
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	83 e0 03             	and    $0x3,%eax
  801576:	48 85 c0             	test   %rax,%rax
  801579:	75 23                	jne    80159e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80157b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157f:	48 83 e8 04          	sub    $0x4,%rax
  801583:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801587:	48 83 ea 04          	sub    $0x4,%rdx
  80158b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80158f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801593:	48 89 c7             	mov    %rax,%rdi
  801596:	48 89 d6             	mov    %rdx,%rsi
  801599:	fd                   	std    
  80159a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80159c:	eb 1d                	jmp    8015bb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80159e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015aa:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b2:	48 89 d7             	mov    %rdx,%rdi
  8015b5:	48 89 c1             	mov    %rax,%rcx
  8015b8:	fd                   	std    
  8015b9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015bb:	fc                   	cld    
  8015bc:	eb 57                	jmp    801615 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c2:	83 e0 03             	and    $0x3,%eax
  8015c5:	48 85 c0             	test   %rax,%rax
  8015c8:	75 36                	jne    801600 <memmove+0xfc>
  8015ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ce:	83 e0 03             	and    $0x3,%eax
  8015d1:	48 85 c0             	test   %rax,%rax
  8015d4:	75 2a                	jne    801600 <memmove+0xfc>
  8015d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015da:	83 e0 03             	and    $0x3,%eax
  8015dd:	48 85 c0             	test   %rax,%rax
  8015e0:	75 1e                	jne    801600 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	48 c1 e8 02          	shr    $0x2,%rax
  8015ea:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f5:	48 89 c7             	mov    %rax,%rdi
  8015f8:	48 89 d6             	mov    %rdx,%rsi
  8015fb:	fc                   	cld    
  8015fc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015fe:	eb 15                	jmp    801615 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801604:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801608:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80160c:	48 89 c7             	mov    %rax,%rdi
  80160f:	48 89 d6             	mov    %rdx,%rsi
  801612:	fc                   	cld    
  801613:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801619:	c9                   	leaveq 
  80161a:	c3                   	retq   

000000000080161b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80161b:	55                   	push   %rbp
  80161c:	48 89 e5             	mov    %rsp,%rbp
  80161f:	48 83 ec 18          	sub    $0x18,%rsp
  801623:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801627:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80162b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80162f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801633:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163b:	48 89 ce             	mov    %rcx,%rsi
  80163e:	48 89 c7             	mov    %rax,%rdi
  801641:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  801648:	00 00 00 
  80164b:	ff d0                	callq  *%rax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 28          	sub    $0x28,%rsp
  801657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80165b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80165f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801667:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80166b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80166f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801673:	eb 36                	jmp    8016ab <memcmp+0x5c>
		if (*s1 != *s2)
  801675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801679:	0f b6 10             	movzbl (%rax),%edx
  80167c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	38 c2                	cmp    %al,%dl
  801685:	74 1a                	je     8016a1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168b:	0f b6 00             	movzbl (%rax),%eax
  80168e:	0f b6 d0             	movzbl %al,%edx
  801691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	0f b6 c0             	movzbl %al,%eax
  80169b:	29 c2                	sub    %eax,%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	eb 20                	jmp    8016c1 <memcmp+0x72>
		s1++, s2++;
  8016a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016b7:	48 85 c0             	test   %rax,%rax
  8016ba:	75 b9                	jne    801675 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c1:	c9                   	leaveq 
  8016c2:	c3                   	retq   

00000000008016c3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016c3:	55                   	push   %rbp
  8016c4:	48 89 e5             	mov    %rsp,%rbp
  8016c7:	48 83 ec 28          	sub    $0x28,%rsp
  8016cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016de:	48 01 d0             	add    %rdx,%rax
  8016e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016e5:	eb 15                	jmp    8016fc <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016eb:	0f b6 10             	movzbl (%rax),%edx
  8016ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016f1:	38 c2                	cmp    %al,%dl
  8016f3:	75 02                	jne    8016f7 <memfind+0x34>
			break;
  8016f5:	eb 0f                	jmp    801706 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016f7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801700:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801704:	72 e1                	jb     8016e7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80170a:	c9                   	leaveq 
  80170b:	c3                   	retq   

000000000080170c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80170c:	55                   	push   %rbp
  80170d:	48 89 e5             	mov    %rsp,%rbp
  801710:	48 83 ec 34          	sub    $0x34,%rsp
  801714:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801718:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80171c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80171f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801726:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80172d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172e:	eb 05                	jmp    801735 <strtol+0x29>
		s++;
  801730:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	0f b6 00             	movzbl (%rax),%eax
  80173c:	3c 20                	cmp    $0x20,%al
  80173e:	74 f0                	je     801730 <strtol+0x24>
  801740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	3c 09                	cmp    $0x9,%al
  801749:	74 e5                	je     801730 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80174b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174f:	0f b6 00             	movzbl (%rax),%eax
  801752:	3c 2b                	cmp    $0x2b,%al
  801754:	75 07                	jne    80175d <strtol+0x51>
		s++;
  801756:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175b:	eb 17                	jmp    801774 <strtol+0x68>
	else if (*s == '-')
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	0f b6 00             	movzbl (%rax),%eax
  801764:	3c 2d                	cmp    $0x2d,%al
  801766:	75 0c                	jne    801774 <strtol+0x68>
		s++, neg = 1;
  801768:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80176d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801774:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801778:	74 06                	je     801780 <strtol+0x74>
  80177a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80177e:	75 28                	jne    8017a8 <strtol+0x9c>
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	3c 30                	cmp    $0x30,%al
  801789:	75 1d                	jne    8017a8 <strtol+0x9c>
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	48 83 c0 01          	add    $0x1,%rax
  801793:	0f b6 00             	movzbl (%rax),%eax
  801796:	3c 78                	cmp    $0x78,%al
  801798:	75 0e                	jne    8017a8 <strtol+0x9c>
		s += 2, base = 16;
  80179a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80179f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017a6:	eb 2c                	jmp    8017d4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ac:	75 19                	jne    8017c7 <strtol+0xbb>
  8017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b2:	0f b6 00             	movzbl (%rax),%eax
  8017b5:	3c 30                	cmp    $0x30,%al
  8017b7:	75 0e                	jne    8017c7 <strtol+0xbb>
		s++, base = 8;
  8017b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017be:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017c5:	eb 0d                	jmp    8017d4 <strtol+0xc8>
	else if (base == 0)
  8017c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017cb:	75 07                	jne    8017d4 <strtol+0xc8>
		base = 10;
  8017cd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	3c 2f                	cmp    $0x2f,%al
  8017dd:	7e 1d                	jle    8017fc <strtol+0xf0>
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	3c 39                	cmp    $0x39,%al
  8017e8:	7f 12                	jg     8017fc <strtol+0xf0>
			dig = *s - '0';
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	0f b6 00             	movzbl (%rax),%eax
  8017f1:	0f be c0             	movsbl %al,%eax
  8017f4:	83 e8 30             	sub    $0x30,%eax
  8017f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017fa:	eb 4e                	jmp    80184a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	0f b6 00             	movzbl (%rax),%eax
  801803:	3c 60                	cmp    $0x60,%al
  801805:	7e 1d                	jle    801824 <strtol+0x118>
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	0f b6 00             	movzbl (%rax),%eax
  80180e:	3c 7a                	cmp    $0x7a,%al
  801810:	7f 12                	jg     801824 <strtol+0x118>
			dig = *s - 'a' + 10;
  801812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801816:	0f b6 00             	movzbl (%rax),%eax
  801819:	0f be c0             	movsbl %al,%eax
  80181c:	83 e8 57             	sub    $0x57,%eax
  80181f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801822:	eb 26                	jmp    80184a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	0f b6 00             	movzbl (%rax),%eax
  80182b:	3c 40                	cmp    $0x40,%al
  80182d:	7e 48                	jle    801877 <strtol+0x16b>
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	0f b6 00             	movzbl (%rax),%eax
  801836:	3c 5a                	cmp    $0x5a,%al
  801838:	7f 3d                	jg     801877 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80183a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	0f be c0             	movsbl %al,%eax
  801844:	83 e8 37             	sub    $0x37,%eax
  801847:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80184a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80184d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801850:	7c 02                	jl     801854 <strtol+0x148>
			break;
  801852:	eb 23                	jmp    801877 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801854:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801859:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80185c:	48 98                	cltq   
  80185e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801863:	48 89 c2             	mov    %rax,%rdx
  801866:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801869:	48 98                	cltq   
  80186b:	48 01 d0             	add    %rdx,%rax
  80186e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801872:	e9 5d ff ff ff       	jmpq   8017d4 <strtol+0xc8>

	if (endptr)
  801877:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80187c:	74 0b                	je     801889 <strtol+0x17d>
		*endptr = (char *) s;
  80187e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801882:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801886:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801889:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80188d:	74 09                	je     801898 <strtol+0x18c>
  80188f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801893:	48 f7 d8             	neg    %rax
  801896:	eb 04                	jmp    80189c <strtol+0x190>
  801898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80189c:	c9                   	leaveq 
  80189d:	c3                   	retq   

000000000080189e <strstr>:

char * strstr(const char *in, const char *str)
{
  80189e:	55                   	push   %rbp
  80189f:	48 89 e5             	mov    %rsp,%rbp
  8018a2:	48 83 ec 30          	sub    $0x30,%rsp
  8018a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018b6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ba:	0f b6 00             	movzbl (%rax),%eax
  8018bd:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018c0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018c4:	75 06                	jne    8018cc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	eb 6b                	jmp    801937 <strstr+0x99>

	len = strlen(str);
  8018cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d0:	48 89 c7             	mov    %rax,%rdi
  8018d3:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  8018da:	00 00 00 
  8018dd:	ff d0                	callq  *%rax
  8018df:	48 98                	cltq   
  8018e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018f1:	0f b6 00             	movzbl (%rax),%eax
  8018f4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018f7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018fb:	75 07                	jne    801904 <strstr+0x66>
				return (char *) 0;
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801902:	eb 33                	jmp    801937 <strstr+0x99>
		} while (sc != c);
  801904:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801908:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80190b:	75 d8                	jne    8018e5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80190d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801911:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801919:	48 89 ce             	mov    %rcx,%rsi
  80191c:	48 89 c7             	mov    %rax,%rdi
  80191f:	48 b8 95 13 80 00 00 	movabs $0x801395,%rax
  801926:	00 00 00 
  801929:	ff d0                	callq  *%rax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 b6                	jne    8018e5 <strstr+0x47>

	return (char *) (in - 1);
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	48 83 e8 01          	sub    $0x1,%rax
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	53                   	push   %rbx
  80193e:	48 83 ec 48          	sub    $0x48,%rsp
  801942:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801945:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801948:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80194c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801950:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801954:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801958:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80195b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80195f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801963:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801967:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80196b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80196f:	4c 89 c3             	mov    %r8,%rbx
  801972:	cd 30                	int    $0x30
  801974:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801978:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80197c:	74 3e                	je     8019bc <syscall+0x83>
  80197e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801983:	7e 37                	jle    8019bc <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801985:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801989:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198c:	49 89 d0             	mov    %rdx,%r8
  80198f:	89 c1                	mov    %eax,%ecx
  801991:	48 ba e8 45 80 00 00 	movabs $0x8045e8,%rdx
  801998:	00 00 00 
  80199b:	be 23 00 00 00       	mov    $0x23,%esi
  8019a0:	48 bf 05 46 80 00 00 	movabs $0x804605,%rdi
  8019a7:	00 00 00 
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019af:	49 b9 df 03 80 00 00 	movabs $0x8003df,%r9
  8019b6:	00 00 00 
  8019b9:	41 ff d1             	callq  *%r9

	return ret;
  8019bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019c0:	48 83 c4 48          	add    $0x48,%rsp
  8019c4:	5b                   	pop    %rbx
  8019c5:	5d                   	pop    %rbp
  8019c6:	c3                   	retq   

00000000008019c7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019c7:	55                   	push   %rbp
  8019c8:	48 89 e5             	mov    %rsp,%rbp
  8019cb:	48 83 ec 20          	sub    $0x20,%rsp
  8019cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e6:	00 
  8019e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f3:	48 89 d1             	mov    %rdx,%rcx
  8019f6:	48 89 c2             	mov    %rax,%rdx
  8019f9:	be 00 00 00 00       	mov    $0x0,%esi
  8019fe:	bf 00 00 00 00       	mov    $0x0,%edi
  801a03:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801a0a:	00 00 00 
  801a0d:	ff d0                	callq  *%rax
}
  801a0f:	c9                   	leaveq 
  801a10:	c3                   	retq   

0000000000801a11 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a11:	55                   	push   %rbp
  801a12:	48 89 e5             	mov    %rsp,%rbp
  801a15:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a20:	00 
  801a21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	be 00 00 00 00       	mov    $0x0,%esi
  801a3c:	bf 01 00 00 00       	mov    $0x1,%edi
  801a41:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	callq  *%rax
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   

0000000000801a4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a4f:	55                   	push   %rbp
  801a50:	48 89 e5             	mov    %rsp,%rbp
  801a53:	48 83 ec 10          	sub    $0x10,%rsp
  801a57:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5d:	48 98                	cltq   
  801a5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a66:	00 
  801a67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a78:	48 89 c2             	mov    %rax,%rdx
  801a7b:	be 01 00 00 00       	mov    $0x1,%esi
  801a80:	bf 03 00 00 00       	mov    $0x3,%edi
  801a85:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	callq  *%rax
}
  801a91:	c9                   	leaveq 
  801a92:	c3                   	retq   

0000000000801a93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a93:	55                   	push   %rbp
  801a94:	48 89 e5             	mov    %rsp,%rbp
  801a97:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa2:	00 
  801aa3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aaf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab9:	be 00 00 00 00       	mov    $0x0,%esi
  801abe:	bf 02 00 00 00       	mov    $0x2,%edi
  801ac3:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
}
  801acf:	c9                   	leaveq 
  801ad0:	c3                   	retq   

0000000000801ad1 <sys_yield>:

void
sys_yield(void)
{
  801ad1:	55                   	push   %rbp
  801ad2:	48 89 e5             	mov    %rsp,%rbp
  801ad5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ad9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae0:	00 
  801ae1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aed:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af2:	ba 00 00 00 00       	mov    $0x0,%edx
  801af7:	be 00 00 00 00       	mov    $0x0,%esi
  801afc:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b01:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	callq  *%rax
}
  801b0d:	c9                   	leaveq 
  801b0e:	c3                   	retq   

0000000000801b0f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b0f:	55                   	push   %rbp
  801b10:	48 89 e5             	mov    %rsp,%rbp
  801b13:	48 83 ec 20          	sub    $0x20,%rsp
  801b17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b24:	48 63 c8             	movslq %eax,%rcx
  801b27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2e:	48 98                	cltq   
  801b30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b37:	00 
  801b38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3e:	49 89 c8             	mov    %rcx,%r8
  801b41:	48 89 d1             	mov    %rdx,%rcx
  801b44:	48 89 c2             	mov    %rax,%rdx
  801b47:	be 01 00 00 00       	mov    $0x1,%esi
  801b4c:	bf 04 00 00 00       	mov    $0x4,%edi
  801b51:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801b58:	00 00 00 
  801b5b:	ff d0                	callq  *%rax
}
  801b5d:	c9                   	leaveq 
  801b5e:	c3                   	retq   

0000000000801b5f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b5f:	55                   	push   %rbp
  801b60:	48 89 e5             	mov    %rsp,%rbp
  801b63:	48 83 ec 30          	sub    $0x30,%rsp
  801b67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b6e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b71:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b75:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b79:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b7c:	48 63 c8             	movslq %eax,%rcx
  801b7f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b86:	48 63 f0             	movslq %eax,%rsi
  801b89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b90:	48 98                	cltq   
  801b92:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b96:	49 89 f9             	mov    %rdi,%r9
  801b99:	49 89 f0             	mov    %rsi,%r8
  801b9c:	48 89 d1             	mov    %rdx,%rcx
  801b9f:	48 89 c2             	mov    %rax,%rdx
  801ba2:	be 01 00 00 00       	mov    $0x1,%esi
  801ba7:	bf 05 00 00 00       	mov    $0x5,%edi
  801bac:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	callq  *%rax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 20          	sub    $0x20,%rsp
  801bc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd0:	48 98                	cltq   
  801bd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd9:	00 
  801bda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be6:	48 89 d1             	mov    %rdx,%rcx
  801be9:	48 89 c2             	mov    %rax,%rdx
  801bec:	be 01 00 00 00       	mov    $0x1,%esi
  801bf1:	bf 06 00 00 00       	mov    $0x6,%edi
  801bf6:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801bfd:	00 00 00 
  801c00:	ff d0                	callq  *%rax
}
  801c02:	c9                   	leaveq 
  801c03:	c3                   	retq   

0000000000801c04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c04:	55                   	push   %rbp
  801c05:	48 89 e5             	mov    %rsp,%rbp
  801c08:	48 83 ec 10          	sub    $0x10,%rsp
  801c0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c15:	48 63 d0             	movslq %eax,%rdx
  801c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1b:	48 98                	cltq   
  801c1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c24:	00 
  801c25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c31:	48 89 d1             	mov    %rdx,%rcx
  801c34:	48 89 c2             	mov    %rax,%rdx
  801c37:	be 01 00 00 00       	mov    $0x1,%esi
  801c3c:	bf 08 00 00 00       	mov    $0x8,%edi
  801c41:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 20          	sub    $0x20,%rsp
  801c57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c65:	48 98                	cltq   
  801c67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6e:	00 
  801c6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7b:	48 89 d1             	mov    %rdx,%rcx
  801c7e:	48 89 c2             	mov    %rax,%rdx
  801c81:	be 01 00 00 00       	mov    $0x1,%esi
  801c86:	bf 09 00 00 00       	mov    $0x9,%edi
  801c8b:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	callq  *%rax
}
  801c97:	c9                   	leaveq 
  801c98:	c3                   	retq   

0000000000801c99 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c99:	55                   	push   %rbp
  801c9a:	48 89 e5             	mov    %rsp,%rbp
  801c9d:	48 83 ec 20          	sub    $0x20,%rsp
  801ca1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ca8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801caf:	48 98                	cltq   
  801cb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb8:	00 
  801cb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc5:	48 89 d1             	mov    %rdx,%rcx
  801cc8:	48 89 c2             	mov    %rax,%rdx
  801ccb:	be 01 00 00 00       	mov    $0x1,%esi
  801cd0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cd5:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   

0000000000801ce3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	48 83 ec 20          	sub    $0x20,%rsp
  801ceb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cf6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cf9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cfc:	48 63 f0             	movslq %eax,%rsi
  801cff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d06:	48 98                	cltq   
  801d08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d13:	00 
  801d14:	49 89 f1             	mov    %rsi,%r9
  801d17:	49 89 c8             	mov    %rcx,%r8
  801d1a:	48 89 d1             	mov    %rdx,%rcx
  801d1d:	48 89 c2             	mov    %rax,%rdx
  801d20:	be 00 00 00 00       	mov    $0x0,%esi
  801d25:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d2a:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801d31:	00 00 00 
  801d34:	ff d0                	callq  *%rax
}
  801d36:	c9                   	leaveq 
  801d37:	c3                   	retq   

0000000000801d38 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d38:	55                   	push   %rbp
  801d39:	48 89 e5             	mov    %rsp,%rbp
  801d3c:	48 83 ec 10          	sub    $0x10,%rsp
  801d40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4f:	00 
  801d50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d61:	48 89 c2             	mov    %rax,%rdx
  801d64:	be 01 00 00 00       	mov    $0x1,%esi
  801d69:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d6e:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  801d75:	00 00 00 
  801d78:	ff d0                	callq  *%rax
}
  801d7a:	c9                   	leaveq 
  801d7b:	c3                   	retq   

0000000000801d7c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d7c:	55                   	push   %rbp
  801d7d:	48 89 e5             	mov    %rsp,%rbp
  801d80:	48 83 ec 30          	sub    $0x30,%rsp
  801d84:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d8c:	48 8b 00             	mov    (%rax),%rax
  801d8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d97:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d9b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801d9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801da1:	83 e0 02             	and    $0x2,%eax
  801da4:	85 c0                	test   %eax,%eax
  801da6:	75 4d                	jne    801df5 <pgfault+0x79>
  801da8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dac:	48 c1 e8 0c          	shr    $0xc,%rax
  801db0:	48 89 c2             	mov    %rax,%rdx
  801db3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dba:	01 00 00 
  801dbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dc1:	25 00 08 00 00       	and    $0x800,%eax
  801dc6:	48 85 c0             	test   %rax,%rax
  801dc9:	74 2a                	je     801df5 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801dcb:	48 ba 18 46 80 00 00 	movabs $0x804618,%rdx
  801dd2:	00 00 00 
  801dd5:	be 1e 00 00 00       	mov    $0x1e,%esi
  801dda:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  801de1:	00 00 00 
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  801df0:	00 00 00 
  801df3:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801df5:	ba 07 00 00 00       	mov    $0x7,%edx
  801dfa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801dff:	bf 00 00 00 00       	mov    $0x0,%edi
  801e04:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  801e0b:	00 00 00 
  801e0e:	ff d0                	callq  *%rax
  801e10:	85 c0                	test   %eax,%eax
  801e12:	0f 85 cd 00 00 00    	jne    801ee5 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e24:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e2a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e32:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e37:	48 89 c6             	mov    %rax,%rsi
  801e3a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e3f:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  801e46:	00 00 00 
  801e49:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e55:	48 89 c1             	mov    %rax,%rcx
  801e58:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e62:	bf 00 00 00 00       	mov    $0x0,%edi
  801e67:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  801e6e:	00 00 00 
  801e71:	ff d0                	callq  *%rax
  801e73:	85 c0                	test   %eax,%eax
  801e75:	79 2a                	jns    801ea1 <pgfault+0x125>
				panic("Page map at temp address failed");
  801e77:	48 ba 48 46 80 00 00 	movabs $0x804648,%rdx
  801e7e:	00 00 00 
  801e81:	be 2f 00 00 00       	mov    $0x2f,%esi
  801e86:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  801e8d:	00 00 00 
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
  801e95:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  801e9c:	00 00 00 
  801e9f:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801ea1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ea6:	bf 00 00 00 00       	mov    $0x0,%edi
  801eab:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	79 54                	jns    801f0f <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ebb:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  801ec2:	00 00 00 
  801ec5:	be 31 00 00 00       	mov    $0x31,%esi
  801eca:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  801ed1:	00 00 00 
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  801ee0:	00 00 00 
  801ee3:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801ee5:	48 ba 90 46 80 00 00 	movabs $0x804690,%rdx
  801eec:	00 00 00 
  801eef:	be 35 00 00 00       	mov    $0x35,%esi
  801ef4:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  801efb:	00 00 00 
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  801f0a:	00 00 00 
  801f0d:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801f0f:	c9                   	leaveq 
  801f10:	c3                   	retq   

0000000000801f11 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f11:	55                   	push   %rbp
  801f12:	48 89 e5             	mov    %rsp,%rbp
  801f15:	48 83 ec 20          	sub    $0x20,%rsp
  801f19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f1c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801f1f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f26:	01 00 00 
  801f29:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f30:	25 07 0e 00 00       	and    $0xe07,%eax
  801f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f38:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f3b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f3f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f46:	25 00 04 00 00       	and    $0x400,%eax
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	74 57                	je     801fa6 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f4f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f52:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f56:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5d:	41 89 f0             	mov    %esi,%r8d
  801f60:	48 89 c6             	mov    %rax,%rsi
  801f63:	bf 00 00 00 00       	mov    $0x0,%edi
  801f68:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  801f6f:	00 00 00 
  801f72:	ff d0                	callq  *%rax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	0f 8e 52 01 00 00    	jle    8020ce <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801f7c:	48 ba bd 46 80 00 00 	movabs $0x8046bd,%rdx
  801f83:	00 00 00 
  801f86:	be 52 00 00 00       	mov    $0x52,%esi
  801f8b:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  801f92:	00 00 00 
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  801fa1:	00 00 00 
  801fa4:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa9:	83 e0 02             	and    $0x2,%eax
  801fac:	85 c0                	test   %eax,%eax
  801fae:	75 10                	jne    801fc0 <duppage+0xaf>
  801fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb3:	25 00 08 00 00       	and    $0x800,%eax
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	0f 84 bb 00 00 00    	je     80207b <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc3:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801fc8:	80 cc 08             	or     $0x8,%ah
  801fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fce:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fd1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fd5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fdc:	41 89 f0             	mov    %esi,%r8d
  801fdf:	48 89 c6             	mov    %rax,%rsi
  801fe2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe7:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  801fee:	00 00 00 
  801ff1:	ff d0                	callq  *%rax
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	7e 2a                	jle    802021 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801ff7:	48 ba bd 46 80 00 00 	movabs $0x8046bd,%rdx
  801ffe:	00 00 00 
  802001:	be 5a 00 00 00       	mov    $0x5a,%esi
  802006:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  80200d:	00 00 00 
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  80201c:	00 00 00 
  80201f:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802021:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802024:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80202c:	41 89 c8             	mov    %ecx,%r8d
  80202f:	48 89 d1             	mov    %rdx,%rcx
  802032:	ba 00 00 00 00       	mov    $0x0,%edx
  802037:	48 89 c6             	mov    %rax,%rsi
  80203a:	bf 00 00 00 00       	mov    $0x0,%edi
  80203f:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  802046:	00 00 00 
  802049:	ff d0                	callq  *%rax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	7e 2a                	jle    802079 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  80204f:	48 ba bd 46 80 00 00 	movabs $0x8046bd,%rdx
  802056:	00 00 00 
  802059:	be 5d 00 00 00       	mov    $0x5d,%esi
  80205e:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  802065:	00 00 00 
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
  80206d:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  802074:	00 00 00 
  802077:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802079:	eb 53                	jmp    8020ce <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  80207b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80207e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802082:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802085:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802089:	41 89 f0             	mov    %esi,%r8d
  80208c:	48 89 c6             	mov    %rax,%rsi
  80208f:	bf 00 00 00 00       	mov    $0x0,%edi
  802094:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	7e 2a                	jle    8020ce <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  8020a4:	48 ba bd 46 80 00 00 	movabs $0x8046bd,%rdx
  8020ab:	00 00 00 
  8020ae:	be 61 00 00 00       	mov    $0x61,%esi
  8020b3:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  8020ba:	00 00 00 
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  8020c9:	00 00 00 
  8020cc:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d3:	c9                   	leaveq 
  8020d4:	c3                   	retq   

00000000008020d5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8020d5:	55                   	push   %rbp
  8020d6:	48 89 e5             	mov    %rsp,%rbp
  8020d9:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  8020dd:	48 bf 7c 1d 80 00 00 	movabs $0x801d7c,%rdi
  8020e4:	00 00 00 
  8020e7:	48 b8 4b 3c 80 00 00 	movabs $0x803c4b,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8020f8:	cd 30                	int    $0x30
  8020fa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802100:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  802103:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802107:	79 30                	jns    802139 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802109:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210c:	89 c1                	mov    %eax,%ecx
  80210e:	48 ba db 46 80 00 00 	movabs $0x8046db,%rdx
  802115:	00 00 00 
  802118:	be 89 00 00 00       	mov    $0x89,%esi
  80211d:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  802124:	00 00 00 
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  802133:	00 00 00 
  802136:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  802139:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80213d:	75 46                	jne    802185 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  80213f:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  802146:	00 00 00 
  802149:	ff d0                	callq  *%rax
  80214b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802150:	48 63 d0             	movslq %eax,%rdx
  802153:	48 89 d0             	mov    %rdx,%rax
  802156:	48 c1 e0 03          	shl    $0x3,%rax
  80215a:	48 01 d0             	add    %rdx,%rax
  80215d:	48 c1 e0 05          	shl    $0x5,%rax
  802161:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802168:	00 00 00 
  80216b:	48 01 c2             	add    %rax,%rdx
  80216e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802175:	00 00 00 
  802178:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	e9 d1 01 00 00       	jmpq   802356 <fork+0x281>
	}

	uint64_t ad = 0;
  802185:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80218c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  80218d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802192:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802196:	e9 df 00 00 00       	jmpq   80227a <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80219b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219f:	48 c1 e8 27          	shr    $0x27,%rax
  8021a3:	48 89 c2             	mov    %rax,%rdx
  8021a6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021ad:	01 00 00 
  8021b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b4:	83 e0 01             	and    $0x1,%eax
  8021b7:	48 85 c0             	test   %rax,%rax
  8021ba:	0f 84 9e 00 00 00    	je     80225e <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8021c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c4:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021c8:	48 89 c2             	mov    %rax,%rdx
  8021cb:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021d2:	01 00 00 
  8021d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d9:	83 e0 01             	and    $0x1,%eax
  8021dc:	48 85 c0             	test   %rax,%rax
  8021df:	74 73                	je     802254 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8021e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e5:	48 c1 e8 15          	shr    $0x15,%rax
  8021e9:	48 89 c2             	mov    %rax,%rdx
  8021ec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f3:	01 00 00 
  8021f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fa:	83 e0 01             	and    $0x1,%eax
  8021fd:	48 85 c0             	test   %rax,%rax
  802200:	74 48                	je     80224a <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802206:	48 c1 e8 0c          	shr    $0xc,%rax
  80220a:	48 89 c2             	mov    %rax,%rdx
  80220d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802214:	01 00 00 
  802217:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	83 e0 01             	and    $0x1,%eax
  802226:	48 85 c0             	test   %rax,%rax
  802229:	74 47                	je     802272 <fork+0x19d>
						duppage(envid, VPN(addr));
  80222b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80222f:	48 c1 e8 0c          	shr    $0xc,%rax
  802233:	89 c2                	mov    %eax,%edx
  802235:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802238:	89 d6                	mov    %edx,%esi
  80223a:	89 c7                	mov    %eax,%edi
  80223c:	48 b8 11 1f 80 00 00 	movabs $0x801f11,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
  802248:	eb 28                	jmp    802272 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  80224a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802251:	00 
  802252:	eb 1e                	jmp    802272 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802254:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80225b:	40 
  80225c:	eb 14                	jmp    802272 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  80225e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802262:	48 c1 e8 27          	shr    $0x27,%rax
  802266:	48 83 c0 01          	add    $0x1,%rax
  80226a:	48 c1 e0 27          	shl    $0x27,%rax
  80226e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802272:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802279:	00 
  80227a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802281:	00 
  802282:	0f 87 13 ff ff ff    	ja     80219b <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802288:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80228b:	ba 07 00 00 00       	mov    $0x7,%edx
  802290:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802295:	89 c7                	mov    %eax,%edi
  802297:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8022a3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022a6:	ba 07 00 00 00       	mov    $0x7,%edx
  8022ab:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022b0:	89 c7                	mov    %eax,%edi
  8022b2:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8022be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022c1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8022c7:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8022cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022d6:	89 c7                	mov    %eax,%edi
  8022d8:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8022e4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022e9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022ee:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8022f3:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  8022fa:	00 00 00 
  8022fd:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022ff:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802304:	bf 00 00 00 00       	mov    $0x0,%edi
  802309:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802315:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80231c:	00 00 00 
  80231f:	48 8b 00             	mov    (%rax),%rax
  802322:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80232c:	48 89 d6             	mov    %rdx,%rsi
  80232f:	89 c7                	mov    %eax,%edi
  802331:	48 b8 99 1c 80 00 00 	movabs $0x801c99,%rax
  802338:	00 00 00 
  80233b:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  80233d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802340:	be 02 00 00 00       	mov    $0x2,%esi
  802345:	89 c7                	mov    %eax,%edi
  802347:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax

	return envid;
  802353:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  802356:	c9                   	leaveq 
  802357:	c3                   	retq   

0000000000802358 <sfork>:

// Challenge!
int
sfork(void)
{
  802358:	55                   	push   %rbp
  802359:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80235c:	48 ba f3 46 80 00 00 	movabs $0x8046f3,%rdx
  802363:	00 00 00 
  802366:	be b8 00 00 00       	mov    $0xb8,%esi
  80236b:	48 bf 3d 46 80 00 00 	movabs $0x80463d,%rdi
  802372:	00 00 00 
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  802381:	00 00 00 
  802384:	ff d1                	callq  *%rcx

0000000000802386 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802386:	55                   	push   %rbp
  802387:	48 89 e5             	mov    %rsp,%rbp
  80238a:	48 83 ec 08          	sub    $0x8,%rsp
  80238e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802392:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802396:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80239d:	ff ff ff 
  8023a0:	48 01 d0             	add    %rdx,%rax
  8023a3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023a7:	c9                   	leaveq 
  8023a8:	c3                   	retq   

00000000008023a9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023a9:	55                   	push   %rbp
  8023aa:	48 89 e5             	mov    %rsp,%rbp
  8023ad:	48 83 ec 08          	sub    $0x8,%rsp
  8023b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b9:	48 89 c7             	mov    %rax,%rdi
  8023bc:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	callq  *%rax
  8023c8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023ce:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023d2:	c9                   	leaveq 
  8023d3:	c3                   	retq   

00000000008023d4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023d4:	55                   	push   %rbp
  8023d5:	48 89 e5             	mov    %rsp,%rbp
  8023d8:	48 83 ec 18          	sub    $0x18,%rsp
  8023dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e7:	eb 6b                	jmp    802454 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ec:	48 98                	cltq   
  8023ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8023f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802400:	48 c1 e8 15          	shr    $0x15,%rax
  802404:	48 89 c2             	mov    %rax,%rdx
  802407:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80240e:	01 00 00 
  802411:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802415:	83 e0 01             	and    $0x1,%eax
  802418:	48 85 c0             	test   %rax,%rax
  80241b:	74 21                	je     80243e <fd_alloc+0x6a>
  80241d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802421:	48 c1 e8 0c          	shr    $0xc,%rax
  802425:	48 89 c2             	mov    %rax,%rdx
  802428:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80242f:	01 00 00 
  802432:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802436:	83 e0 01             	and    $0x1,%eax
  802439:	48 85 c0             	test   %rax,%rax
  80243c:	75 12                	jne    802450 <fd_alloc+0x7c>
			*fd_store = fd;
  80243e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802442:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802446:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802449:	b8 00 00 00 00       	mov    $0x0,%eax
  80244e:	eb 1a                	jmp    80246a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802450:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802454:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802458:	7e 8f                	jle    8023e9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80245a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802465:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80246a:	c9                   	leaveq 
  80246b:	c3                   	retq   

000000000080246c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80246c:	55                   	push   %rbp
  80246d:	48 89 e5             	mov    %rsp,%rbp
  802470:	48 83 ec 20          	sub    $0x20,%rsp
  802474:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802477:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80247b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80247f:	78 06                	js     802487 <fd_lookup+0x1b>
  802481:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802485:	7e 07                	jle    80248e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80248c:	eb 6c                	jmp    8024fa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80248e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802491:	48 98                	cltq   
  802493:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802499:	48 c1 e0 0c          	shl    $0xc,%rax
  80249d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a5:	48 c1 e8 15          	shr    $0x15,%rax
  8024a9:	48 89 c2             	mov    %rax,%rdx
  8024ac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024b3:	01 00 00 
  8024b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ba:	83 e0 01             	and    $0x1,%eax
  8024bd:	48 85 c0             	test   %rax,%rax
  8024c0:	74 21                	je     8024e3 <fd_lookup+0x77>
  8024c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ca:	48 89 c2             	mov    %rax,%rdx
  8024cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024d4:	01 00 00 
  8024d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024db:	83 e0 01             	and    $0x1,%eax
  8024de:	48 85 c0             	test   %rax,%rax
  8024e1:	75 07                	jne    8024ea <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e8:	eb 10                	jmp    8024fa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024f2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fa:	c9                   	leaveq 
  8024fb:	c3                   	retq   

00000000008024fc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024fc:	55                   	push   %rbp
  8024fd:	48 89 e5             	mov    %rsp,%rbp
  802500:	48 83 ec 30          	sub    $0x30,%rsp
  802504:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802508:	89 f0                	mov    %esi,%eax
  80250a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80250d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802511:	48 89 c7             	mov    %rax,%rdi
  802514:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  80251b:	00 00 00 
  80251e:	ff d0                	callq  *%rax
  802520:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802524:	48 89 d6             	mov    %rdx,%rsi
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802538:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253c:	78 0a                	js     802548 <fd_close+0x4c>
	    || fd != fd2)
  80253e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802542:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802546:	74 12                	je     80255a <fd_close+0x5e>
		return (must_exist ? r : 0);
  802548:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80254c:	74 05                	je     802553 <fd_close+0x57>
  80254e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802551:	eb 05                	jmp    802558 <fd_close+0x5c>
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	eb 69                	jmp    8025c3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80255a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80255e:	8b 00                	mov    (%rax),%eax
  802560:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802564:	48 89 d6             	mov    %rdx,%rsi
  802567:	89 c7                	mov    %eax,%edi
  802569:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
  802575:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802578:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257c:	78 2a                	js     8025a8 <fd_close+0xac>
		if (dev->dev_close)
  80257e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802582:	48 8b 40 20          	mov    0x20(%rax),%rax
  802586:	48 85 c0             	test   %rax,%rax
  802589:	74 16                	je     8025a1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80258b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802593:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802597:	48 89 d7             	mov    %rdx,%rdi
  80259a:	ff d0                	callq  *%rax
  80259c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259f:	eb 07                	jmp    8025a8 <fd_close+0xac>
		else
			r = 0;
  8025a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ac:	48 89 c6             	mov    %rax,%rsi
  8025af:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b4:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
	return r;
  8025c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025c3:	c9                   	leaveq 
  8025c4:	c3                   	retq   

00000000008025c5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025c5:	55                   	push   %rbp
  8025c6:	48 89 e5             	mov    %rsp,%rbp
  8025c9:	48 83 ec 20          	sub    $0x20,%rsp
  8025cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025db:	eb 41                	jmp    80261e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025dd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025e4:	00 00 00 
  8025e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ea:	48 63 d2             	movslq %edx,%rdx
  8025ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f1:	8b 00                	mov    (%rax),%eax
  8025f3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025f6:	75 22                	jne    80261a <dev_lookup+0x55>
			*dev = devtab[i];
  8025f8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025ff:	00 00 00 
  802602:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802605:	48 63 d2             	movslq %edx,%rdx
  802608:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80260c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802610:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	eb 60                	jmp    80267a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80261a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80261e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802625:	00 00 00 
  802628:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80262b:	48 63 d2             	movslq %edx,%rdx
  80262e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802632:	48 85 c0             	test   %rax,%rax
  802635:	75 a6                	jne    8025dd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802637:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80263e:	00 00 00 
  802641:	48 8b 00             	mov    (%rax),%rax
  802644:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80264a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80264d:	89 c6                	mov    %eax,%esi
  80264f:	48 bf 10 47 80 00 00 	movabs $0x804710,%rdi
  802656:	00 00 00 
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	48 b9 18 06 80 00 00 	movabs $0x800618,%rcx
  802665:	00 00 00 
  802668:	ff d1                	callq  *%rcx
	*dev = 0;
  80266a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80266e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802675:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80267a:	c9                   	leaveq 
  80267b:	c3                   	retq   

000000000080267c <close>:

int
close(int fdnum)
{
  80267c:	55                   	push   %rbp
  80267d:	48 89 e5             	mov    %rsp,%rbp
  802680:	48 83 ec 20          	sub    $0x20,%rsp
  802684:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802687:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80268b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80268e:	48 89 d6             	mov    %rdx,%rsi
  802691:	89 c7                	mov    %eax,%edi
  802693:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
  80269f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026a6:	79 05                	jns    8026ad <close+0x31>
		return r;
  8026a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ab:	eb 18                	jmp    8026c5 <close+0x49>
	else
		return fd_close(fd, 1);
  8026ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b1:	be 01 00 00 00       	mov    $0x1,%esi
  8026b6:	48 89 c7             	mov    %rax,%rdi
  8026b9:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	callq  *%rax
}
  8026c5:	c9                   	leaveq 
  8026c6:	c3                   	retq   

00000000008026c7 <close_all>:

void
close_all(void)
{
  8026c7:	55                   	push   %rbp
  8026c8:	48 89 e5             	mov    %rsp,%rbp
  8026cb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d6:	eb 15                	jmp    8026ed <close_all+0x26>
		close(i);
  8026d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026ed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026f1:	7e e5                	jle    8026d8 <close_all+0x11>
		close(i);
}
  8026f3:	c9                   	leaveq 
  8026f4:	c3                   	retq   

00000000008026f5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026f5:	55                   	push   %rbp
  8026f6:	48 89 e5             	mov    %rsp,%rbp
  8026f9:	48 83 ec 40          	sub    $0x40,%rsp
  8026fd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802700:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802703:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802707:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80270a:	48 89 d6             	mov    %rdx,%rsi
  80270d:	89 c7                	mov    %eax,%edi
  80270f:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  802716:	00 00 00 
  802719:	ff d0                	callq  *%rax
  80271b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802722:	79 08                	jns    80272c <dup+0x37>
		return r;
  802724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802727:	e9 70 01 00 00       	jmpq   80289c <dup+0x1a7>
	close(newfdnum);
  80272c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80272f:	89 c7                	mov    %eax,%edi
  802731:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802738:	00 00 00 
  80273b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80273d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802740:	48 98                	cltq   
  802742:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802748:	48 c1 e0 0c          	shl    $0xc,%rax
  80274c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802754:	48 89 c7             	mov    %rax,%rdi
  802757:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80275e:	00 00 00 
  802761:	ff d0                	callq  *%rax
  802763:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276b:	48 89 c7             	mov    %rax,%rdi
  80276e:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
  80277a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80277e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802782:	48 c1 e8 15          	shr    $0x15,%rax
  802786:	48 89 c2             	mov    %rax,%rdx
  802789:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802790:	01 00 00 
  802793:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802797:	83 e0 01             	and    $0x1,%eax
  80279a:	48 85 c0             	test   %rax,%rax
  80279d:	74 73                	je     802812 <dup+0x11d>
  80279f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8027a7:	48 89 c2             	mov    %rax,%rdx
  8027aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027b1:	01 00 00 
  8027b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b8:	83 e0 01             	and    $0x1,%eax
  8027bb:	48 85 c0             	test   %rax,%rax
  8027be:	74 52                	je     802812 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8027c8:	48 89 c2             	mov    %rax,%rdx
  8027cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027d2:	01 00 00 
  8027d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8027de:	89 c1                	mov    %eax,%ecx
  8027e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e8:	41 89 c8             	mov    %ecx,%r8d
  8027eb:	48 89 d1             	mov    %rdx,%rcx
  8027ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f3:	48 89 c6             	mov    %rax,%rsi
  8027f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fb:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
  802807:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80280a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280e:	79 02                	jns    802812 <dup+0x11d>
			goto err;
  802810:	eb 57                	jmp    802869 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802816:	48 c1 e8 0c          	shr    $0xc,%rax
  80281a:	48 89 c2             	mov    %rax,%rdx
  80281d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802824:	01 00 00 
  802827:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282b:	25 07 0e 00 00       	and    $0xe07,%eax
  802830:	89 c1                	mov    %eax,%ecx
  802832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802836:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80283a:	41 89 c8             	mov    %ecx,%r8d
  80283d:	48 89 d1             	mov    %rdx,%rcx
  802840:	ba 00 00 00 00       	mov    $0x0,%edx
  802845:	48 89 c6             	mov    %rax,%rsi
  802848:	bf 00 00 00 00       	mov    $0x0,%edi
  80284d:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  802854:	00 00 00 
  802857:	ff d0                	callq  *%rax
  802859:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802860:	79 02                	jns    802864 <dup+0x16f>
		goto err;
  802862:	eb 05                	jmp    802869 <dup+0x174>

	return newfdnum;
  802864:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802867:	eb 33                	jmp    80289c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802869:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286d:	48 89 c6             	mov    %rax,%rsi
  802870:	bf 00 00 00 00       	mov    $0x0,%edi
  802875:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802885:	48 89 c6             	mov    %rax,%rsi
  802888:	bf 00 00 00 00       	mov    $0x0,%edi
  80288d:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  802894:	00 00 00 
  802897:	ff d0                	callq  *%rax
	return r;
  802899:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80289c:	c9                   	leaveq 
  80289d:	c3                   	retq   

000000000080289e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80289e:	55                   	push   %rbp
  80289f:	48 89 e5             	mov    %rsp,%rbp
  8028a2:	48 83 ec 40          	sub    $0x40,%rsp
  8028a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028b8:	48 89 d6             	mov    %rdx,%rsi
  8028bb:	89 c7                	mov    %eax,%edi
  8028bd:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  8028c4:	00 00 00 
  8028c7:	ff d0                	callq  *%rax
  8028c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d0:	78 24                	js     8028f6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d6:	8b 00                	mov    (%rax),%eax
  8028d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028dc:	48 89 d6             	mov    %rdx,%rsi
  8028df:	89 c7                	mov    %eax,%edi
  8028e1:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  8028e8:	00 00 00 
  8028eb:	ff d0                	callq  *%rax
  8028ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f4:	79 05                	jns    8028fb <read+0x5d>
		return r;
  8028f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f9:	eb 76                	jmp    802971 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ff:	8b 40 08             	mov    0x8(%rax),%eax
  802902:	83 e0 03             	and    $0x3,%eax
  802905:	83 f8 01             	cmp    $0x1,%eax
  802908:	75 3a                	jne    802944 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80290a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802911:	00 00 00 
  802914:	48 8b 00             	mov    (%rax),%rax
  802917:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80291d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802920:	89 c6                	mov    %eax,%esi
  802922:	48 bf 2f 47 80 00 00 	movabs $0x80472f,%rdi
  802929:	00 00 00 
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	48 b9 18 06 80 00 00 	movabs $0x800618,%rcx
  802938:	00 00 00 
  80293b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80293d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802942:	eb 2d                	jmp    802971 <read+0xd3>
	}
	if (!dev->dev_read)
  802944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802948:	48 8b 40 10          	mov    0x10(%rax),%rax
  80294c:	48 85 c0             	test   %rax,%rax
  80294f:	75 07                	jne    802958 <read+0xba>
		return -E_NOT_SUPP;
  802951:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802956:	eb 19                	jmp    802971 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802960:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802964:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802968:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80296c:	48 89 cf             	mov    %rcx,%rdi
  80296f:	ff d0                	callq  *%rax
}
  802971:	c9                   	leaveq 
  802972:	c3                   	retq   

0000000000802973 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 83 ec 30          	sub    $0x30,%rsp
  80297b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80297e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802982:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802986:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80298d:	eb 49                	jmp    8029d8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80298f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802992:	48 98                	cltq   
  802994:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802998:	48 29 c2             	sub    %rax,%rdx
  80299b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299e:	48 63 c8             	movslq %eax,%rcx
  8029a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a5:	48 01 c1             	add    %rax,%rcx
  8029a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ab:	48 89 ce             	mov    %rcx,%rsi
  8029ae:	89 c7                	mov    %eax,%edi
  8029b0:	48 b8 9e 28 80 00 00 	movabs $0x80289e,%rax
  8029b7:	00 00 00 
  8029ba:	ff d0                	callq  *%rax
  8029bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029c3:	79 05                	jns    8029ca <readn+0x57>
			return m;
  8029c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029c8:	eb 1c                	jmp    8029e6 <readn+0x73>
		if (m == 0)
  8029ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029ce:	75 02                	jne    8029d2 <readn+0x5f>
			break;
  8029d0:	eb 11                	jmp    8029e3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029db:	48 98                	cltq   
  8029dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029e1:	72 ac                	jb     80298f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029e6:	c9                   	leaveq 
  8029e7:	c3                   	retq   

00000000008029e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029e8:	55                   	push   %rbp
  8029e9:	48 89 e5             	mov    %rsp,%rbp
  8029ec:	48 83 ec 40          	sub    $0x40,%rsp
  8029f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a02:	48 89 d6             	mov    %rdx,%rsi
  802a05:	89 c7                	mov    %eax,%edi
  802a07:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
  802a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1a:	78 24                	js     802a40 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a20:	8b 00                	mov    (%rax),%eax
  802a22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a26:	48 89 d6             	mov    %rdx,%rsi
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax
  802a37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3e:	79 05                	jns    802a45 <write+0x5d>
		return r;
  802a40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a43:	eb 75                	jmp    802aba <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a49:	8b 40 08             	mov    0x8(%rax),%eax
  802a4c:	83 e0 03             	and    $0x3,%eax
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	75 3a                	jne    802a8d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a53:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a5a:	00 00 00 
  802a5d:	48 8b 00             	mov    (%rax),%rax
  802a60:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a66:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a69:	89 c6                	mov    %eax,%esi
  802a6b:	48 bf 4b 47 80 00 00 	movabs $0x80474b,%rdi
  802a72:	00 00 00 
  802a75:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7a:	48 b9 18 06 80 00 00 	movabs $0x800618,%rcx
  802a81:	00 00 00 
  802a84:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a8b:	eb 2d                	jmp    802aba <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a91:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a95:	48 85 c0             	test   %rax,%rax
  802a98:	75 07                	jne    802aa1 <write+0xb9>
		return -E_NOT_SUPP;
  802a9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a9f:	eb 19                	jmp    802aba <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa5:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aa9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ab1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ab5:	48 89 cf             	mov    %rcx,%rdi
  802ab8:	ff d0                	callq  *%rax
}
  802aba:	c9                   	leaveq 
  802abb:	c3                   	retq   

0000000000802abc <seek>:

int
seek(int fdnum, off_t offset)
{
  802abc:	55                   	push   %rbp
  802abd:	48 89 e5             	mov    %rsp,%rbp
  802ac0:	48 83 ec 18          	sub    $0x18,%rsp
  802ac4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802aca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ace:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ad1:	48 89 d6             	mov    %rdx,%rsi
  802ad4:	89 c7                	mov    %eax,%edi
  802ad6:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  802add:	00 00 00 
  802ae0:	ff d0                	callq  *%rax
  802ae2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae9:	79 05                	jns    802af0 <seek+0x34>
		return r;
  802aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aee:	eb 0f                	jmp    802aff <seek+0x43>
	fd->fd_offset = offset;
  802af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aff:	c9                   	leaveq 
  802b00:	c3                   	retq   

0000000000802b01 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b01:	55                   	push   %rbp
  802b02:	48 89 e5             	mov    %rsp,%rbp
  802b05:	48 83 ec 30          	sub    $0x30,%rsp
  802b09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b0c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b16:	48 89 d6             	mov    %rdx,%rsi
  802b19:	89 c7                	mov    %eax,%edi
  802b1b:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  802b22:	00 00 00 
  802b25:	ff d0                	callq  *%rax
  802b27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2e:	78 24                	js     802b54 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b34:	8b 00                	mov    (%rax),%eax
  802b36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b3a:	48 89 d6             	mov    %rdx,%rsi
  802b3d:	89 c7                	mov    %eax,%edi
  802b3f:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax
  802b4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b52:	79 05                	jns    802b59 <ftruncate+0x58>
		return r;
  802b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b57:	eb 72                	jmp    802bcb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5d:	8b 40 08             	mov    0x8(%rax),%eax
  802b60:	83 e0 03             	and    $0x3,%eax
  802b63:	85 c0                	test   %eax,%eax
  802b65:	75 3a                	jne    802ba1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b67:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b6e:	00 00 00 
  802b71:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b74:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b7a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b7d:	89 c6                	mov    %eax,%esi
  802b7f:	48 bf 68 47 80 00 00 	movabs $0x804768,%rdi
  802b86:	00 00 00 
  802b89:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8e:	48 b9 18 06 80 00 00 	movabs $0x800618,%rcx
  802b95:	00 00 00 
  802b98:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b9f:	eb 2a                	jmp    802bcb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ba9:	48 85 c0             	test   %rax,%rax
  802bac:	75 07                	jne    802bb5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb3:	eb 16                	jmp    802bcb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb9:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bc1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bc4:	89 ce                	mov    %ecx,%esi
  802bc6:	48 89 d7             	mov    %rdx,%rdi
  802bc9:	ff d0                	callq  *%rax
}
  802bcb:	c9                   	leaveq 
  802bcc:	c3                   	retq   

0000000000802bcd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802bcd:	55                   	push   %rbp
  802bce:	48 89 e5             	mov    %rsp,%rbp
  802bd1:	48 83 ec 30          	sub    $0x30,%rsp
  802bd5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bd8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bdc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802be0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802be3:	48 89 d6             	mov    %rdx,%rsi
  802be6:	89 c7                	mov    %eax,%edi
  802be8:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  802bef:	00 00 00 
  802bf2:	ff d0                	callq  *%rax
  802bf4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfb:	78 24                	js     802c21 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c01:	8b 00                	mov    (%rax),%eax
  802c03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c07:	48 89 d6             	mov    %rdx,%rsi
  802c0a:	89 c7                	mov    %eax,%edi
  802c0c:	48 b8 c5 25 80 00 00 	movabs $0x8025c5,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
  802c18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1f:	79 05                	jns    802c26 <fstat+0x59>
		return r;
  802c21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c24:	eb 5e                	jmp    802c84 <fstat+0xb7>
	if (!dev->dev_stat)
  802c26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c2e:	48 85 c0             	test   %rax,%rax
  802c31:	75 07                	jne    802c3a <fstat+0x6d>
		return -E_NOT_SUPP;
  802c33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c38:	eb 4a                	jmp    802c84 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c3e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c45:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c4c:	00 00 00 
	stat->st_isdir = 0;
  802c4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c53:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c5a:	00 00 00 
	stat->st_dev = dev;
  802c5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c65:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c70:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c78:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c7c:	48 89 ce             	mov    %rcx,%rsi
  802c7f:	48 89 d7             	mov    %rdx,%rdi
  802c82:	ff d0                	callq  *%rax
}
  802c84:	c9                   	leaveq 
  802c85:	c3                   	retq   

0000000000802c86 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c86:	55                   	push   %rbp
  802c87:	48 89 e5             	mov    %rsp,%rbp
  802c8a:	48 83 ec 20          	sub    $0x20,%rsp
  802c8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9a:	be 00 00 00 00       	mov    $0x0,%esi
  802c9f:	48 89 c7             	mov    %rax,%rdi
  802ca2:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
  802cae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb5:	79 05                	jns    802cbc <stat+0x36>
		return fd;
  802cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cba:	eb 2f                	jmp    802ceb <stat+0x65>
	r = fstat(fd, stat);
  802cbc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc3:	48 89 d6             	mov    %rdx,%rsi
  802cc6:	89 c7                	mov    %eax,%edi
  802cc8:	48 b8 cd 2b 80 00 00 	movabs $0x802bcd,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
	return r;
  802ce8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ceb:	c9                   	leaveq 
  802cec:	c3                   	retq   

0000000000802ced <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ced:	55                   	push   %rbp
  802cee:	48 89 e5             	mov    %rsp,%rbp
  802cf1:	48 83 ec 10          	sub    $0x10,%rsp
  802cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cfc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d03:	00 00 00 
  802d06:	8b 00                	mov    (%rax),%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	75 1d                	jne    802d29 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d0c:	bf 01 00 00 00       	mov    $0x1,%edi
  802d11:	48 b8 ee 3e 80 00 00 	movabs $0x803eee,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d24:	00 00 00 
  802d27:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d29:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d30:	00 00 00 
  802d33:	8b 00                	mov    (%rax),%eax
  802d35:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d38:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d3d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d44:	00 00 00 
  802d47:	89 c7                	mov    %eax,%edi
  802d49:	48 b8 56 3e 80 00 00 	movabs $0x803e56,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d59:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5e:	48 89 c6             	mov    %rax,%rsi
  802d61:	bf 00 00 00 00       	mov    $0x0,%edi
  802d66:	48 b8 95 3d 80 00 00 	movabs $0x803d95,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
}
  802d72:	c9                   	leaveq 
  802d73:	c3                   	retq   

0000000000802d74 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d74:	55                   	push   %rbp
  802d75:	48 89 e5             	mov    %rsp,%rbp
  802d78:	48 83 ec 20          	sub    $0x20,%rsp
  802d7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d80:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802d83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d87:	48 89 c7             	mov    %rax,%rdi
  802d8a:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
  802d96:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d9b:	7e 0a                	jle    802da7 <open+0x33>
		return -E_BAD_PATH;
  802d9d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802da2:	e9 a5 00 00 00       	jmpq   802e4c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802da7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dab:	48 89 c7             	mov    %rax,%rdi
  802dae:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  802db5:	00 00 00 
  802db8:	ff d0                	callq  *%rax
  802dba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc1:	79 08                	jns    802dcb <open+0x57>
		return r;
  802dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc6:	e9 81 00 00 00       	jmpq   802e4c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcf:	48 89 c6             	mov    %rax,%rsi
  802dd2:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802dd9:	00 00 00 
  802ddc:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802de8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802def:	00 00 00 
  802df2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802df5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dff:	48 89 c6             	mov    %rax,%rsi
  802e02:	bf 01 00 00 00       	mov    $0x1,%edi
  802e07:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
  802e13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1a:	79 1d                	jns    802e39 <open+0xc5>
		fd_close(fd, 0);
  802e1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e20:	be 00 00 00 00       	mov    $0x0,%esi
  802e25:	48 89 c7             	mov    %rax,%rdi
  802e28:	48 b8 fc 24 80 00 00 	movabs $0x8024fc,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
		return r;
  802e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e37:	eb 13                	jmp    802e4c <open+0xd8>
	}

	return fd2num(fd);
  802e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3d:	48 89 c7             	mov    %rax,%rdi
  802e40:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802e47:	00 00 00 
  802e4a:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802e4c:	c9                   	leaveq 
  802e4d:	c3                   	retq   

0000000000802e4e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e4e:	55                   	push   %rbp
  802e4f:	48 89 e5             	mov    %rsp,%rbp
  802e52:	48 83 ec 10          	sub    $0x10,%rsp
  802e56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5e:	8b 50 0c             	mov    0xc(%rax),%edx
  802e61:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e68:	00 00 00 
  802e6b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e6d:	be 00 00 00 00       	mov    $0x0,%esi
  802e72:	bf 06 00 00 00       	mov    $0x6,%edi
  802e77:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
}
  802e83:	c9                   	leaveq 
  802e84:	c3                   	retq   

0000000000802e85 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e85:	55                   	push   %rbp
  802e86:	48 89 e5             	mov    %rsp,%rbp
  802e89:	48 83 ec 30          	sub    $0x30,%rsp
  802e8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9d:	8b 50 0c             	mov    0xc(%rax),%edx
  802ea0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ea7:	00 00 00 
  802eaa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802eac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb3:	00 00 00 
  802eb6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802ebe:	be 00 00 00 00       	mov    $0x0,%esi
  802ec3:	bf 03 00 00 00       	mov    $0x3,%edi
  802ec8:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
  802ed4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edb:	79 08                	jns    802ee5 <devfile_read+0x60>
		return r;
  802edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee0:	e9 a4 00 00 00       	jmpq   802f89 <devfile_read+0x104>
	assert(r <= n);
  802ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee8:	48 98                	cltq   
  802eea:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802eee:	76 35                	jbe    802f25 <devfile_read+0xa0>
  802ef0:	48 b9 95 47 80 00 00 	movabs $0x804795,%rcx
  802ef7:	00 00 00 
  802efa:	48 ba 9c 47 80 00 00 	movabs $0x80479c,%rdx
  802f01:	00 00 00 
  802f04:	be 84 00 00 00       	mov    $0x84,%esi
  802f09:	48 bf b1 47 80 00 00 	movabs $0x8047b1,%rdi
  802f10:	00 00 00 
  802f13:	b8 00 00 00 00       	mov    $0x0,%eax
  802f18:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  802f1f:	00 00 00 
  802f22:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802f25:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802f2c:	7e 35                	jle    802f63 <devfile_read+0xde>
  802f2e:	48 b9 bc 47 80 00 00 	movabs $0x8047bc,%rcx
  802f35:	00 00 00 
  802f38:	48 ba 9c 47 80 00 00 	movabs $0x80479c,%rdx
  802f3f:	00 00 00 
  802f42:	be 85 00 00 00       	mov    $0x85,%esi
  802f47:	48 bf b1 47 80 00 00 	movabs $0x8047b1,%rdi
  802f4e:	00 00 00 
  802f51:	b8 00 00 00 00       	mov    $0x0,%eax
  802f56:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  802f5d:	00 00 00 
  802f60:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f66:	48 63 d0             	movslq %eax,%rdx
  802f69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f6d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f74:	00 00 00 
  802f77:	48 89 c7             	mov    %rax,%rdi
  802f7a:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	callq  *%rax
	return r;
  802f86:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802f89:	c9                   	leaveq 
  802f8a:	c3                   	retq   

0000000000802f8b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f8b:	55                   	push   %rbp
  802f8c:	48 89 e5             	mov    %rsp,%rbp
  802f8f:	48 83 ec 30          	sub    $0x30,%rsp
  802f93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f9b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa3:	8b 50 0c             	mov    0xc(%rax),%edx
  802fa6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fad:	00 00 00 
  802fb0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802fb2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fb9:	00 00 00 
  802fbc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fc0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802fc4:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802fcb:	00 
  802fcc:	76 35                	jbe    803003 <devfile_write+0x78>
  802fce:	48 b9 c8 47 80 00 00 	movabs $0x8047c8,%rcx
  802fd5:	00 00 00 
  802fd8:	48 ba 9c 47 80 00 00 	movabs $0x80479c,%rdx
  802fdf:	00 00 00 
  802fe2:	be 9e 00 00 00       	mov    $0x9e,%esi
  802fe7:	48 bf b1 47 80 00 00 	movabs $0x8047b1,%rdi
  802fee:	00 00 00 
  802ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff6:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  802ffd:	00 00 00 
  803000:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803003:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803007:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300b:	48 89 c6             	mov    %rax,%rsi
  80300e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803015:	00 00 00 
  803018:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803024:	be 00 00 00 00       	mov    $0x0,%esi
  803029:	bf 04 00 00 00       	mov    $0x4,%edi
  80302e:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
  80303a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803041:	79 05                	jns    803048 <devfile_write+0xbd>
		return r;
  803043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803046:	eb 43                	jmp    80308b <devfile_write+0x100>
	assert(r <= n);
  803048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304b:	48 98                	cltq   
  80304d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803051:	76 35                	jbe    803088 <devfile_write+0xfd>
  803053:	48 b9 95 47 80 00 00 	movabs $0x804795,%rcx
  80305a:	00 00 00 
  80305d:	48 ba 9c 47 80 00 00 	movabs $0x80479c,%rdx
  803064:	00 00 00 
  803067:	be a2 00 00 00       	mov    $0xa2,%esi
  80306c:	48 bf b1 47 80 00 00 	movabs $0x8047b1,%rdi
  803073:	00 00 00 
  803076:	b8 00 00 00 00       	mov    $0x0,%eax
  80307b:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  803082:	00 00 00 
  803085:	41 ff d0             	callq  *%r8
	return r;
  803088:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80308b:	c9                   	leaveq 
  80308c:	c3                   	retq   

000000000080308d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80308d:	55                   	push   %rbp
  80308e:	48 89 e5             	mov    %rsp,%rbp
  803091:	48 83 ec 20          	sub    $0x20,%rsp
  803095:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803099:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80309d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a1:	8b 50 0c             	mov    0xc(%rax),%edx
  8030a4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ab:	00 00 00 
  8030ae:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030b0:	be 00 00 00 00       	mov    $0x0,%esi
  8030b5:	bf 05 00 00 00       	mov    $0x5,%edi
  8030ba:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8030c1:	00 00 00 
  8030c4:	ff d0                	callq  *%rax
  8030c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cd:	79 05                	jns    8030d4 <devfile_stat+0x47>
		return r;
  8030cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d2:	eb 56                	jmp    80312a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030df:	00 00 00 
  8030e2:	48 89 c7             	mov    %rax,%rdi
  8030e5:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  8030ec:	00 00 00 
  8030ef:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f8:	00 00 00 
  8030fb:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803105:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80310b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803112:	00 00 00 
  803115:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80311b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80312a:	c9                   	leaveq 
  80312b:	c3                   	retq   

000000000080312c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80312c:	55                   	push   %rbp
  80312d:	48 89 e5             	mov    %rsp,%rbp
  803130:	48 83 ec 10          	sub    $0x10,%rsp
  803134:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803138:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80313b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313f:	8b 50 0c             	mov    0xc(%rax),%edx
  803142:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803149:	00 00 00 
  80314c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80314e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803155:	00 00 00 
  803158:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80315b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80315e:	be 00 00 00 00       	mov    $0x0,%esi
  803163:	bf 02 00 00 00       	mov    $0x2,%edi
  803168:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
}
  803174:	c9                   	leaveq 
  803175:	c3                   	retq   

0000000000803176 <remove>:

// Delete a file
int
remove(const char *path)
{
  803176:	55                   	push   %rbp
  803177:	48 89 e5             	mov    %rsp,%rbp
  80317a:	48 83 ec 10          	sub    $0x10,%rsp
  80317e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803186:	48 89 c7             	mov    %rax,%rdi
  803189:	48 b8 74 11 80 00 00 	movabs $0x801174,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
  803195:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80319a:	7e 07                	jle    8031a3 <remove+0x2d>
		return -E_BAD_PATH;
  80319c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031a1:	eb 33                	jmp    8031d6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a7:	48 89 c6             	mov    %rax,%rsi
  8031aa:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031b1:	00 00 00 
  8031b4:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031c0:	be 00 00 00 00       	mov    $0x0,%esi
  8031c5:	bf 07 00 00 00       	mov    $0x7,%edi
  8031ca:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
}
  8031d6:	c9                   	leaveq 
  8031d7:	c3                   	retq   

00000000008031d8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031d8:	55                   	push   %rbp
  8031d9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031dc:	be 00 00 00 00       	mov    $0x0,%esi
  8031e1:	bf 08 00 00 00       	mov    $0x8,%edi
  8031e6:	48 b8 ed 2c 80 00 00 	movabs $0x802ced,%rax
  8031ed:	00 00 00 
  8031f0:	ff d0                	callq  *%rax
}
  8031f2:	5d                   	pop    %rbp
  8031f3:	c3                   	retq   

00000000008031f4 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8031f4:	55                   	push   %rbp
  8031f5:	48 89 e5             	mov    %rsp,%rbp
  8031f8:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8031ff:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803206:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80320d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803214:	be 00 00 00 00       	mov    $0x0,%esi
  803219:	48 89 c7             	mov    %rax,%rdi
  80321c:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80322b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322f:	79 28                	jns    803259 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803234:	89 c6                	mov    %eax,%esi
  803236:	48 bf f5 47 80 00 00 	movabs $0x8047f5,%rdi
  80323d:	00 00 00 
  803240:	b8 00 00 00 00       	mov    $0x0,%eax
  803245:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  80324c:	00 00 00 
  80324f:	ff d2                	callq  *%rdx
		return fd_src;
  803251:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803254:	e9 74 01 00 00       	jmpq   8033cd <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803259:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803260:	be 01 01 00 00       	mov    $0x101,%esi
  803265:	48 89 c7             	mov    %rax,%rdi
  803268:	48 b8 74 2d 80 00 00 	movabs $0x802d74,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
  803274:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803277:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80327b:	79 39                	jns    8032b6 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80327d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803280:	89 c6                	mov    %eax,%esi
  803282:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  803289:	00 00 00 
  80328c:	b8 00 00 00 00       	mov    $0x0,%eax
  803291:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  803298:	00 00 00 
  80329b:	ff d2                	callq  *%rdx
		close(fd_src);
  80329d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a0:	89 c7                	mov    %eax,%edi
  8032a2:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
		return fd_dest;
  8032ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032b1:	e9 17 01 00 00       	jmpq   8033cd <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032b6:	eb 74                	jmp    80332c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8032b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032bb:	48 63 d0             	movslq %eax,%rdx
  8032be:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032c8:	48 89 ce             	mov    %rcx,%rsi
  8032cb:	89 c7                	mov    %eax,%edi
  8032cd:	48 b8 e8 29 80 00 00 	movabs $0x8029e8,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	callq  *%rax
  8032d9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8032dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8032e0:	79 4a                	jns    80332c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8032e2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032e5:	89 c6                	mov    %eax,%esi
  8032e7:	48 bf 25 48 80 00 00 	movabs $0x804825,%rdi
  8032ee:	00 00 00 
  8032f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f6:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  8032fd:	00 00 00 
  803300:	ff d2                	callq  *%rdx
			close(fd_src);
  803302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803305:	89 c7                	mov    %eax,%edi
  803307:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80330e:	00 00 00 
  803311:	ff d0                	callq  *%rax
			close(fd_dest);
  803313:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803316:	89 c7                	mov    %eax,%edi
  803318:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
			return write_size;
  803324:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803327:	e9 a1 00 00 00       	jmpq   8033cd <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80332c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803336:	ba 00 02 00 00       	mov    $0x200,%edx
  80333b:	48 89 ce             	mov    %rcx,%rsi
  80333e:	89 c7                	mov    %eax,%edi
  803340:	48 b8 9e 28 80 00 00 	movabs $0x80289e,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax
  80334c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80334f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803353:	0f 8f 5f ff ff ff    	jg     8032b8 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803359:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80335d:	79 47                	jns    8033a6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80335f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803362:	89 c6                	mov    %eax,%esi
  803364:	48 bf 38 48 80 00 00 	movabs $0x804838,%rdi
  80336b:	00 00 00 
  80336e:	b8 00 00 00 00       	mov    $0x0,%eax
  803373:	48 ba 18 06 80 00 00 	movabs $0x800618,%rdx
  80337a:	00 00 00 
  80337d:	ff d2                	callq  *%rdx
		close(fd_src);
  80337f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803382:	89 c7                	mov    %eax,%edi
  803384:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
		close(fd_dest);
  803390:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803393:	89 c7                	mov    %eax,%edi
  803395:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
		return read_size;
  8033a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a4:	eb 27                	jmp    8033cd <copy+0x1d9>
	}
	close(fd_src);
  8033a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a9:	89 c7                	mov    %eax,%edi
  8033ab:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  8033b2:	00 00 00 
  8033b5:	ff d0                	callq  *%rax
	close(fd_dest);
  8033b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ba:	89 c7                	mov    %eax,%edi
  8033bc:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
	return 0;
  8033c8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8033cd:	c9                   	leaveq 
  8033ce:	c3                   	retq   

00000000008033cf <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033cf:	55                   	push   %rbp
  8033d0:	48 89 e5             	mov    %rsp,%rbp
  8033d3:	53                   	push   %rbx
  8033d4:	48 83 ec 38          	sub    $0x38,%rsp
  8033d8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033dc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8033e0:	48 89 c7             	mov    %rax,%rdi
  8033e3:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  8033ea:	00 00 00 
  8033ed:	ff d0                	callq  *%rax
  8033ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033f6:	0f 88 bf 01 00 00    	js     8035bb <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803400:	ba 07 04 00 00       	mov    $0x407,%edx
  803405:	48 89 c6             	mov    %rax,%rsi
  803408:	bf 00 00 00 00       	mov    $0x0,%edi
  80340d:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803414:	00 00 00 
  803417:	ff d0                	callq  *%rax
  803419:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80341c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803420:	0f 88 95 01 00 00    	js     8035bb <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803426:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80342a:	48 89 c7             	mov    %rax,%rdi
  80342d:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
  803439:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80343c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803440:	0f 88 5d 01 00 00    	js     8035a3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344a:	ba 07 04 00 00       	mov    $0x407,%edx
  80344f:	48 89 c6             	mov    %rax,%rsi
  803452:	bf 00 00 00 00       	mov    $0x0,%edi
  803457:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
  803463:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803466:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80346a:	0f 88 33 01 00 00    	js     8035a3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803474:	48 89 c7             	mov    %rax,%rdi
  803477:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
  803483:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803487:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348b:	ba 07 04 00 00       	mov    $0x407,%edx
  803490:	48 89 c6             	mov    %rax,%rsi
  803493:	bf 00 00 00 00       	mov    $0x0,%edi
  803498:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ab:	79 05                	jns    8034b2 <pipe+0xe3>
		goto err2;
  8034ad:	e9 d9 00 00 00       	jmpq   80358b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
  8034c5:	48 89 c2             	mov    %rax,%rdx
  8034c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034cc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034d2:	48 89 d1             	mov    %rdx,%rcx
  8034d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034da:	48 89 c6             	mov    %rax,%rsi
  8034dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e2:	48 b8 5f 1b 80 00 00 	movabs $0x801b5f,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
  8034ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034f5:	79 1b                	jns    803512 <pipe+0x143>
		goto err3;
  8034f7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8034f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034fc:	48 89 c6             	mov    %rax,%rsi
  8034ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803504:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80350b:	00 00 00 
  80350e:	ff d0                	callq  *%rax
  803510:	eb 79                	jmp    80358b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803512:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803516:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80351d:	00 00 00 
  803520:	8b 12                	mov    (%rdx),%edx
  803522:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803528:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80352f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803533:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80353a:	00 00 00 
  80353d:	8b 12                	mov    (%rdx),%edx
  80353f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803541:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803545:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80354c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803550:	48 89 c7             	mov    %rax,%rdi
  803553:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
  80355f:	89 c2                	mov    %eax,%edx
  803561:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803565:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803567:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80356b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80356f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803573:	48 89 c7             	mov    %rax,%rdi
  803576:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
  803582:	89 03                	mov    %eax,(%rbx)
	return 0;
  803584:	b8 00 00 00 00       	mov    $0x0,%eax
  803589:	eb 33                	jmp    8035be <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80358b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80358f:	48 89 c6             	mov    %rax,%rsi
  803592:	bf 00 00 00 00       	mov    $0x0,%edi
  803597:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80359e:	00 00 00 
  8035a1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8035a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a7:	48 89 c6             	mov    %rax,%rsi
  8035aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8035af:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8035b6:	00 00 00 
  8035b9:	ff d0                	callq  *%rax
err:
	return r;
  8035bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035be:	48 83 c4 38          	add    $0x38,%rsp
  8035c2:	5b                   	pop    %rbx
  8035c3:	5d                   	pop    %rbp
  8035c4:	c3                   	retq   

00000000008035c5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035c5:	55                   	push   %rbp
  8035c6:	48 89 e5             	mov    %rsp,%rbp
  8035c9:	53                   	push   %rbx
  8035ca:	48 83 ec 28          	sub    $0x28,%rsp
  8035ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035d6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8035dd:	00 00 00 
  8035e0:	48 8b 00             	mov    (%rax),%rax
  8035e3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8035ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f0:	48 89 c7             	mov    %rax,%rdi
  8035f3:	48 b8 70 3f 80 00 00 	movabs $0x803f70,%rax
  8035fa:	00 00 00 
  8035fd:	ff d0                	callq  *%rax
  8035ff:	89 c3                	mov    %eax,%ebx
  803601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803605:	48 89 c7             	mov    %rax,%rdi
  803608:	48 b8 70 3f 80 00 00 	movabs $0x803f70,%rax
  80360f:	00 00 00 
  803612:	ff d0                	callq  *%rax
  803614:	39 c3                	cmp    %eax,%ebx
  803616:	0f 94 c0             	sete   %al
  803619:	0f b6 c0             	movzbl %al,%eax
  80361c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80361f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803626:	00 00 00 
  803629:	48 8b 00             	mov    (%rax),%rax
  80362c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803632:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803635:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803638:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80363b:	75 05                	jne    803642 <_pipeisclosed+0x7d>
			return ret;
  80363d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803640:	eb 4f                	jmp    803691 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803642:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803645:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803648:	74 42                	je     80368c <_pipeisclosed+0xc7>
  80364a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80364e:	75 3c                	jne    80368c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803650:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803657:	00 00 00 
  80365a:	48 8b 00             	mov    (%rax),%rax
  80365d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803663:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803666:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803669:	89 c6                	mov    %eax,%esi
  80366b:	48 bf 53 48 80 00 00 	movabs $0x804853,%rdi
  803672:	00 00 00 
  803675:	b8 00 00 00 00       	mov    $0x0,%eax
  80367a:	49 b8 18 06 80 00 00 	movabs $0x800618,%r8
  803681:	00 00 00 
  803684:	41 ff d0             	callq  *%r8
	}
  803687:	e9 4a ff ff ff       	jmpq   8035d6 <_pipeisclosed+0x11>
  80368c:	e9 45 ff ff ff       	jmpq   8035d6 <_pipeisclosed+0x11>
}
  803691:	48 83 c4 28          	add    $0x28,%rsp
  803695:	5b                   	pop    %rbx
  803696:	5d                   	pop    %rbp
  803697:	c3                   	retq   

0000000000803698 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803698:	55                   	push   %rbp
  803699:	48 89 e5             	mov    %rsp,%rbp
  80369c:	48 83 ec 30          	sub    $0x30,%rsp
  8036a0:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036aa:	48 89 d6             	mov    %rdx,%rsi
  8036ad:	89 c7                	mov    %eax,%edi
  8036af:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c2:	79 05                	jns    8036c9 <pipeisclosed+0x31>
		return r;
  8036c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c7:	eb 31                	jmp    8036fa <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cd:	48 89 c7             	mov    %rax,%rdi
  8036d0:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
  8036dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8036e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e8:	48 89 d6             	mov    %rdx,%rsi
  8036eb:	48 89 c7             	mov    %rax,%rdi
  8036ee:	48 b8 c5 35 80 00 00 	movabs $0x8035c5,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
}
  8036fa:	c9                   	leaveq 
  8036fb:	c3                   	retq   

00000000008036fc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036fc:	55                   	push   %rbp
  8036fd:	48 89 e5             	mov    %rsp,%rbp
  803700:	48 83 ec 40          	sub    $0x40,%rsp
  803704:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803708:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80370c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803714:	48 89 c7             	mov    %rax,%rdi
  803717:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80371e:	00 00 00 
  803721:	ff d0                	callq  *%rax
  803723:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803727:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80372b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80372f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803736:	00 
  803737:	e9 92 00 00 00       	jmpq   8037ce <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80373c:	eb 41                	jmp    80377f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80373e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803743:	74 09                	je     80374e <devpipe_read+0x52>
				return i;
  803745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803749:	e9 92 00 00 00       	jmpq   8037e0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80374e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803756:	48 89 d6             	mov    %rdx,%rsi
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 c5 35 80 00 00 	movabs $0x8035c5,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
  803768:	85 c0                	test   %eax,%eax
  80376a:	74 07                	je     803773 <devpipe_read+0x77>
				return 0;
  80376c:	b8 00 00 00 00       	mov    $0x0,%eax
  803771:	eb 6d                	jmp    8037e0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803773:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  80377a:	00 00 00 
  80377d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80377f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803783:	8b 10                	mov    (%rax),%edx
  803785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803789:	8b 40 04             	mov    0x4(%rax),%eax
  80378c:	39 c2                	cmp    %eax,%edx
  80378e:	74 ae                	je     80373e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803798:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80379c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a0:	8b 00                	mov    (%rax),%eax
  8037a2:	99                   	cltd   
  8037a3:	c1 ea 1b             	shr    $0x1b,%edx
  8037a6:	01 d0                	add    %edx,%eax
  8037a8:	83 e0 1f             	and    $0x1f,%eax
  8037ab:	29 d0                	sub    %edx,%eax
  8037ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037b1:	48 98                	cltq   
  8037b3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037b8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037be:	8b 00                	mov    (%rax),%eax
  8037c0:	8d 50 01             	lea    0x1(%rax),%edx
  8037c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037d6:	0f 82 60 ff ff ff    	jb     80373c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037e0:	c9                   	leaveq 
  8037e1:	c3                   	retq   

00000000008037e2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037e2:	55                   	push   %rbp
  8037e3:	48 89 e5             	mov    %rsp,%rbp
  8037e6:	48 83 ec 40          	sub    $0x40,%rsp
  8037ea:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037f2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8037f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037fa:	48 89 c7             	mov    %rax,%rdi
  8037fd:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  803804:	00 00 00 
  803807:	ff d0                	callq  *%rax
  803809:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80380d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803811:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803815:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80381c:	00 
  80381d:	e9 8e 00 00 00       	jmpq   8038b0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803822:	eb 31                	jmp    803855 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803824:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382c:	48 89 d6             	mov    %rdx,%rsi
  80382f:	48 89 c7             	mov    %rax,%rdi
  803832:	48 b8 c5 35 80 00 00 	movabs $0x8035c5,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	85 c0                	test   %eax,%eax
  803840:	74 07                	je     803849 <devpipe_write+0x67>
				return 0;
  803842:	b8 00 00 00 00       	mov    $0x0,%eax
  803847:	eb 79                	jmp    8038c2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803849:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803855:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803859:	8b 40 04             	mov    0x4(%rax),%eax
  80385c:	48 63 d0             	movslq %eax,%rdx
  80385f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803863:	8b 00                	mov    (%rax),%eax
  803865:	48 98                	cltq   
  803867:	48 83 c0 20          	add    $0x20,%rax
  80386b:	48 39 c2             	cmp    %rax,%rdx
  80386e:	73 b4                	jae    803824 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803870:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803874:	8b 40 04             	mov    0x4(%rax),%eax
  803877:	99                   	cltd   
  803878:	c1 ea 1b             	shr    $0x1b,%edx
  80387b:	01 d0                	add    %edx,%eax
  80387d:	83 e0 1f             	and    $0x1f,%eax
  803880:	29 d0                	sub    %edx,%eax
  803882:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803886:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80388a:	48 01 ca             	add    %rcx,%rdx
  80388d:	0f b6 0a             	movzbl (%rdx),%ecx
  803890:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803894:	48 98                	cltq   
  803896:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80389a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389e:	8b 40 04             	mov    0x4(%rax),%eax
  8038a1:	8d 50 01             	lea    0x1(%rax),%edx
  8038a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038b8:	0f 82 64 ff ff ff    	jb     803822 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8038be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038c2:	c9                   	leaveq 
  8038c3:	c3                   	retq   

00000000008038c4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038c4:	55                   	push   %rbp
  8038c5:	48 89 e5             	mov    %rsp,%rbp
  8038c8:	48 83 ec 20          	sub    $0x20,%rsp
  8038cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d8:	48 89 c7             	mov    %rax,%rdi
  8038db:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  8038e2:	00 00 00 
  8038e5:	ff d0                	callq  *%rax
  8038e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8038eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ef:	48 be 66 48 80 00 00 	movabs $0x804866,%rsi
  8038f6:	00 00 00 
  8038f9:	48 89 c7             	mov    %rax,%rdi
  8038fc:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  803903:	00 00 00 
  803906:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390c:	8b 50 04             	mov    0x4(%rax),%edx
  80390f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803913:	8b 00                	mov    (%rax),%eax
  803915:	29 c2                	sub    %eax,%edx
  803917:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803921:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803925:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80392c:	00 00 00 
	stat->st_dev = &devpipe;
  80392f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803933:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80393a:	00 00 00 
  80393d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803949:	c9                   	leaveq 
  80394a:	c3                   	retq   

000000000080394b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80394b:	55                   	push   %rbp
  80394c:	48 89 e5             	mov    %rsp,%rbp
  80394f:	48 83 ec 10          	sub    $0x10,%rsp
  803953:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395b:	48 89 c6             	mov    %rax,%rsi
  80395e:	bf 00 00 00 00       	mov    $0x0,%edi
  803963:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80396f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803973:	48 89 c7             	mov    %rax,%rdi
  803976:	48 b8 a9 23 80 00 00 	movabs $0x8023a9,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
  803982:	48 89 c6             	mov    %rax,%rsi
  803985:	bf 00 00 00 00       	mov    $0x0,%edi
  80398a:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
}
  803996:	c9                   	leaveq 
  803997:	c3                   	retq   

0000000000803998 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803998:	55                   	push   %rbp
  803999:	48 89 e5             	mov    %rsp,%rbp
  80399c:	48 83 ec 20          	sub    $0x20,%rsp
  8039a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8039a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039a6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8039a9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8039ad:	be 01 00 00 00       	mov    $0x1,%esi
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
}
  8039c1:	c9                   	leaveq 
  8039c2:	c3                   	retq   

00000000008039c3 <getchar>:

int
getchar(void)
{
  8039c3:	55                   	push   %rbp
  8039c4:	48 89 e5             	mov    %rsp,%rbp
  8039c7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8039cb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8039cf:	ba 01 00 00 00       	mov    $0x1,%edx
  8039d4:	48 89 c6             	mov    %rax,%rsi
  8039d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8039dc:	48 b8 9e 28 80 00 00 	movabs $0x80289e,%rax
  8039e3:	00 00 00 
  8039e6:	ff d0                	callq  *%rax
  8039e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8039eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ef:	79 05                	jns    8039f6 <getchar+0x33>
		return r;
  8039f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f4:	eb 14                	jmp    803a0a <getchar+0x47>
	if (r < 1)
  8039f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039fa:	7f 07                	jg     803a03 <getchar+0x40>
		return -E_EOF;
  8039fc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803a01:	eb 07                	jmp    803a0a <getchar+0x47>
	return c;
  803a03:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803a07:	0f b6 c0             	movzbl %al,%eax
}
  803a0a:	c9                   	leaveq 
  803a0b:	c3                   	retq   

0000000000803a0c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803a0c:	55                   	push   %rbp
  803a0d:	48 89 e5             	mov    %rsp,%rbp
  803a10:	48 83 ec 20          	sub    $0x20,%rsp
  803a14:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a17:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a1e:	48 89 d6             	mov    %rdx,%rsi
  803a21:	89 c7                	mov    %eax,%edi
  803a23:	48 b8 6c 24 80 00 00 	movabs $0x80246c,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
  803a2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a36:	79 05                	jns    803a3d <iscons+0x31>
		return r;
  803a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3b:	eb 1a                	jmp    803a57 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a41:	8b 10                	mov    (%rax),%edx
  803a43:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803a4a:	00 00 00 
  803a4d:	8b 00                	mov    (%rax),%eax
  803a4f:	39 c2                	cmp    %eax,%edx
  803a51:	0f 94 c0             	sete   %al
  803a54:	0f b6 c0             	movzbl %al,%eax
}
  803a57:	c9                   	leaveq 
  803a58:	c3                   	retq   

0000000000803a59 <opencons>:

int
opencons(void)
{
  803a59:	55                   	push   %rbp
  803a5a:	48 89 e5             	mov    %rsp,%rbp
  803a5d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803a61:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a65:	48 89 c7             	mov    %rax,%rdi
  803a68:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a7b:	79 05                	jns    803a82 <opencons+0x29>
		return r;
  803a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a80:	eb 5b                	jmp    803add <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a86:	ba 07 04 00 00       	mov    $0x407,%edx
  803a8b:	48 89 c6             	mov    %rax,%rsi
  803a8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a93:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
  803a9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa6:	79 05                	jns    803aad <opencons+0x54>
		return r;
  803aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aab:	eb 30                	jmp    803add <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803aad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab1:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ab8:	00 00 00 
  803abb:	8b 12                	mov    (%rdx),%edx
  803abd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803abf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ace:	48 89 c7             	mov    %rax,%rdi
  803ad1:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
}
  803add:	c9                   	leaveq 
  803ade:	c3                   	retq   

0000000000803adf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803adf:	55                   	push   %rbp
  803ae0:	48 89 e5             	mov    %rsp,%rbp
  803ae3:	48 83 ec 30          	sub    $0x30,%rsp
  803ae7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aeb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803aef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803af3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803af8:	75 07                	jne    803b01 <devcons_read+0x22>
		return 0;
  803afa:	b8 00 00 00 00       	mov    $0x0,%eax
  803aff:	eb 4b                	jmp    803b4c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803b01:	eb 0c                	jmp    803b0f <devcons_read+0x30>
		sys_yield();
  803b03:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  803b0a:	00 00 00 
  803b0d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b0f:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  803b16:	00 00 00 
  803b19:	ff d0                	callq  *%rax
  803b1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b22:	74 df                	je     803b03 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b28:	79 05                	jns    803b2f <devcons_read+0x50>
		return c;
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	eb 1d                	jmp    803b4c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803b2f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803b33:	75 07                	jne    803b3c <devcons_read+0x5d>
		return 0;
  803b35:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3a:	eb 10                	jmp    803b4c <devcons_read+0x6d>
	*(char*)vbuf = c;
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	89 c2                	mov    %eax,%edx
  803b41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b45:	88 10                	mov    %dl,(%rax)
	return 1;
  803b47:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803b4c:	c9                   	leaveq 
  803b4d:	c3                   	retq   

0000000000803b4e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b4e:	55                   	push   %rbp
  803b4f:	48 89 e5             	mov    %rsp,%rbp
  803b52:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803b59:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803b60:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803b67:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b75:	eb 76                	jmp    803bed <devcons_write+0x9f>
		m = n - tot;
  803b77:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803b7e:	89 c2                	mov    %eax,%edx
  803b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b83:	29 c2                	sub    %eax,%edx
  803b85:	89 d0                	mov    %edx,%eax
  803b87:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803b8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b8d:	83 f8 7f             	cmp    $0x7f,%eax
  803b90:	76 07                	jbe    803b99 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803b92:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803b99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b9c:	48 63 d0             	movslq %eax,%rdx
  803b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba2:	48 63 c8             	movslq %eax,%rcx
  803ba5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803bac:	48 01 c1             	add    %rax,%rcx
  803baf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803bb6:	48 89 ce             	mov    %rcx,%rsi
  803bb9:	48 89 c7             	mov    %rax,%rdi
  803bbc:	48 b8 04 15 80 00 00 	movabs $0x801504,%rax
  803bc3:	00 00 00 
  803bc6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803bc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bcb:	48 63 d0             	movslq %eax,%rdx
  803bce:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803bd5:	48 89 d6             	mov    %rdx,%rsi
  803bd8:	48 89 c7             	mov    %rax,%rdi
  803bdb:	48 b8 c7 19 80 00 00 	movabs $0x8019c7,%rax
  803be2:	00 00 00 
  803be5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803be7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bea:	01 45 fc             	add    %eax,-0x4(%rbp)
  803bed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf0:	48 98                	cltq   
  803bf2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803bf9:	0f 82 78 ff ff ff    	jb     803b77 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c02:	c9                   	leaveq 
  803c03:	c3                   	retq   

0000000000803c04 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803c04:	55                   	push   %rbp
  803c05:	48 89 e5             	mov    %rsp,%rbp
  803c08:	48 83 ec 08          	sub    $0x8,%rsp
  803c0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c15:	c9                   	leaveq 
  803c16:	c3                   	retq   

0000000000803c17 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803c17:	55                   	push   %rbp
  803c18:	48 89 e5             	mov    %rsp,%rbp
  803c1b:	48 83 ec 10          	sub    $0x10,%rsp
  803c1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2b:	48 be 72 48 80 00 00 	movabs $0x804872,%rsi
  803c32:	00 00 00 
  803c35:	48 89 c7             	mov    %rax,%rdi
  803c38:	48 b8 e0 11 80 00 00 	movabs $0x8011e0,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
	return 0;
  803c44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c49:	c9                   	leaveq 
  803c4a:	c3                   	retq   

0000000000803c4b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c4b:	55                   	push   %rbp
  803c4c:	48 89 e5             	mov    %rsp,%rbp
  803c4f:	48 83 ec 10          	sub    $0x10,%rsp
  803c53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803c57:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c5e:	00 00 00 
  803c61:	48 8b 00             	mov    (%rax),%rax
  803c64:	48 85 c0             	test   %rax,%rax
  803c67:	75 49                	jne    803cb2 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803c69:	ba 07 00 00 00       	mov    $0x7,%edx
  803c6e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803c73:	bf 00 00 00 00       	mov    $0x0,%edi
  803c78:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
  803c84:	85 c0                	test   %eax,%eax
  803c86:	79 2a                	jns    803cb2 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803c88:	48 ba 80 48 80 00 00 	movabs $0x804880,%rdx
  803c8f:	00 00 00 
  803c92:	be 21 00 00 00       	mov    $0x21,%esi
  803c97:	48 bf ab 48 80 00 00 	movabs $0x8048ab,%rdi
  803c9e:	00 00 00 
  803ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca6:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  803cad:	00 00 00 
  803cb0:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803cb2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803cb9:	00 00 00 
  803cbc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803cc0:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803cc3:	48 be 0e 3d 80 00 00 	movabs $0x803d0e,%rsi
  803cca:	00 00 00 
  803ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd2:	48 b8 99 1c 80 00 00 	movabs $0x801c99,%rax
  803cd9:	00 00 00 
  803cdc:	ff d0                	callq  *%rax
  803cde:	85 c0                	test   %eax,%eax
  803ce0:	79 2a                	jns    803d0c <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803ce2:	48 ba c0 48 80 00 00 	movabs $0x8048c0,%rdx
  803ce9:	00 00 00 
  803cec:	be 27 00 00 00       	mov    $0x27,%esi
  803cf1:	48 bf ab 48 80 00 00 	movabs $0x8048ab,%rdi
  803cf8:	00 00 00 
  803cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803d00:	48 b9 df 03 80 00 00 	movabs $0x8003df,%rcx
  803d07:	00 00 00 
  803d0a:	ff d1                	callq  *%rcx
}
  803d0c:	c9                   	leaveq 
  803d0d:	c3                   	retq   

0000000000803d0e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803d0e:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803d11:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803d18:	00 00 00 
call *%rax
  803d1b:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803d1d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803d24:	00 
    movq 152(%rsp), %rcx
  803d25:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803d2c:	00 
    subq $8, %rcx
  803d2d:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803d31:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803d34:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803d3b:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803d3c:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803d40:	4c 8b 3c 24          	mov    (%rsp),%r15
  803d44:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803d49:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803d4e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803d53:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803d58:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803d5d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803d62:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803d67:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803d6c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803d71:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803d76:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803d7b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803d80:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803d85:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803d8a:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803d8e:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803d92:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803d93:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803d94:	c3                   	retq   

0000000000803d95 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d95:	55                   	push   %rbp
  803d96:	48 89 e5             	mov    %rsp,%rbp
  803d99:	48 83 ec 30          	sub    $0x30,%rsp
  803d9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803da1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803da9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803dae:	75 0e                	jne    803dbe <ipc_recv+0x29>
        pg = (void *)UTOP;
  803db0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803db7:	00 00 00 
  803dba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803dbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc2:	48 89 c7             	mov    %rax,%rdi
  803dc5:	48 b8 38 1d 80 00 00 	movabs $0x801d38,%rax
  803dcc:	00 00 00 
  803dcf:	ff d0                	callq  *%rax
  803dd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd8:	79 27                	jns    803e01 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803dda:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ddf:	74 0a                	je     803deb <ipc_recv+0x56>
            *from_env_store = 0;
  803de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803deb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803df0:	74 0a                	je     803dfc <ipc_recv+0x67>
            *perm_store = 0;
  803df2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803df6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dff:	eb 53                	jmp    803e54 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803e01:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e06:	74 19                	je     803e21 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803e08:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e0f:	00 00 00 
  803e12:	48 8b 00             	mov    (%rax),%rax
  803e15:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e1f:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803e21:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e26:	74 19                	je     803e41 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803e28:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e2f:	00 00 00 
  803e32:	48 8b 00             	mov    (%rax),%rax
  803e35:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3f:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803e41:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e48:	00 00 00 
  803e4b:	48 8b 00             	mov    (%rax),%rax
  803e4e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803e54:	c9                   	leaveq 
  803e55:	c3                   	retq   

0000000000803e56 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e56:	55                   	push   %rbp
  803e57:	48 89 e5             	mov    %rsp,%rbp
  803e5a:	48 83 ec 30          	sub    $0x30,%rsp
  803e5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e61:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e64:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e68:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803e6b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e70:	75 0e                	jne    803e80 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803e72:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e79:	00 00 00 
  803e7c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803e80:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e83:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e86:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e8d:	89 c7                	mov    %eax,%edi
  803e8f:	48 b8 e3 1c 80 00 00 	movabs $0x801ce3,%rax
  803e96:	00 00 00 
  803e99:	ff d0                	callq  *%rax
  803e9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803e9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea2:	79 36                	jns    803eda <ipc_send+0x84>
  803ea4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ea8:	74 30                	je     803eda <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ead:	89 c1                	mov    %eax,%ecx
  803eaf:	48 ba f7 48 80 00 00 	movabs $0x8048f7,%rdx
  803eb6:	00 00 00 
  803eb9:	be 49 00 00 00       	mov    $0x49,%esi
  803ebe:	48 bf 04 49 80 00 00 	movabs $0x804904,%rdi
  803ec5:	00 00 00 
  803ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ecd:	49 b8 df 03 80 00 00 	movabs $0x8003df,%r8
  803ed4:	00 00 00 
  803ed7:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803eda:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  803ee1:	00 00 00 
  803ee4:	ff d0                	callq  *%rax
    } while(r != 0);
  803ee6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eea:	75 94                	jne    803e80 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803eec:	c9                   	leaveq 
  803eed:	c3                   	retq   

0000000000803eee <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803eee:	55                   	push   %rbp
  803eef:	48 89 e5             	mov    %rsp,%rbp
  803ef2:	48 83 ec 14          	sub    $0x14,%rsp
  803ef6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ef9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f00:	eb 5e                	jmp    803f60 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803f02:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f09:	00 00 00 
  803f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0f:	48 63 d0             	movslq %eax,%rdx
  803f12:	48 89 d0             	mov    %rdx,%rax
  803f15:	48 c1 e0 03          	shl    $0x3,%rax
  803f19:	48 01 d0             	add    %rdx,%rax
  803f1c:	48 c1 e0 05          	shl    $0x5,%rax
  803f20:	48 01 c8             	add    %rcx,%rax
  803f23:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f29:	8b 00                	mov    (%rax),%eax
  803f2b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f2e:	75 2c                	jne    803f5c <ipc_find_env+0x6e>
			return envs[i].env_id;
  803f30:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f37:	00 00 00 
  803f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3d:	48 63 d0             	movslq %eax,%rdx
  803f40:	48 89 d0             	mov    %rdx,%rax
  803f43:	48 c1 e0 03          	shl    $0x3,%rax
  803f47:	48 01 d0             	add    %rdx,%rax
  803f4a:	48 c1 e0 05          	shl    $0x5,%rax
  803f4e:	48 01 c8             	add    %rcx,%rax
  803f51:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f57:	8b 40 08             	mov    0x8(%rax),%eax
  803f5a:	eb 12                	jmp    803f6e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f5c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f60:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f67:	7e 99                	jle    803f02 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f6e:	c9                   	leaveq 
  803f6f:	c3                   	retq   

0000000000803f70 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f70:	55                   	push   %rbp
  803f71:	48 89 e5             	mov    %rsp,%rbp
  803f74:	48 83 ec 18          	sub    $0x18,%rsp
  803f78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f80:	48 c1 e8 15          	shr    $0x15,%rax
  803f84:	48 89 c2             	mov    %rax,%rdx
  803f87:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f8e:	01 00 00 
  803f91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f95:	83 e0 01             	and    $0x1,%eax
  803f98:	48 85 c0             	test   %rax,%rax
  803f9b:	75 07                	jne    803fa4 <pageref+0x34>
		return 0;
  803f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa2:	eb 53                	jmp    803ff7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa8:	48 c1 e8 0c          	shr    $0xc,%rax
  803fac:	48 89 c2             	mov    %rax,%rdx
  803faf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fb6:	01 00 00 
  803fb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc5:	83 e0 01             	and    $0x1,%eax
  803fc8:	48 85 c0             	test   %rax,%rax
  803fcb:	75 07                	jne    803fd4 <pageref+0x64>
		return 0;
  803fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd2:	eb 23                	jmp    803ff7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd8:	48 c1 e8 0c          	shr    $0xc,%rax
  803fdc:	48 89 c2             	mov    %rax,%rdx
  803fdf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fe6:	00 00 00 
  803fe9:	48 c1 e2 04          	shl    $0x4,%rdx
  803fed:	48 01 d0             	add    %rdx,%rax
  803ff0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803ff4:	0f b7 c0             	movzwl %ax,%eax
}
  803ff7:	c9                   	leaveq 
  803ff8:	c3                   	retq   
