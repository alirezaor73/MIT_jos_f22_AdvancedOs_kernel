
obj/user/stresssched:     file format elf64-x86-64


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
  80003c:	e8 74 01 00 00       	callq  8001b5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800052:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 16                	jmp    800080 <umain+0x3d>
		if (fork() == 0)
  80006a:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	85 c0                	test   %eax,%eax
  800078:	75 02                	jne    80007c <umain+0x39>
			break;
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800084:	7e e4                	jle    80006a <umain+0x27>
		if (fork() == 0)
			break;
	if (i == 20) {
  800086:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008a:	75 11                	jne    80009d <umain+0x5a>
		sys_yield();
  80008c:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
		return;
  800098:	e9 16 01 00 00       	jmpq   8001b3 <umain+0x170>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80009d:	eb 02                	jmp    8000a1 <umain+0x5e>
		asm volatile("pause");
  80009f:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000b0:	00 00 00 
  8000b3:	48 63 d0             	movslq %eax,%rdx
  8000b6:	48 89 d0             	mov    %rdx,%rax
  8000b9:	48 c1 e0 03          	shl    $0x3,%rax
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 c1 e0 05          	shl    $0x5,%rax
  8000c4:	48 01 c8             	add    %rcx,%rax
  8000c7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8000cd:	8b 40 04             	mov    0x4(%rax),%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	75 cb                	jne    80009f <umain+0x5c>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000db:	eb 41                	jmp    80011e <umain+0xdb>
		sys_yield();
  8000dd:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f0:	eb 1f                	jmp    800111 <umain+0xce>
			counter++;
  8000f2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  800108:	00 00 00 
  80010b:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80010d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800111:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  800118:	7e d8                	jle    8000f2 <umain+0xaf>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800122:	7e b9                	jle    8000dd <umain+0x9a>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800124:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba a0 3e 80 00 00 	movabs $0x803ea0,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf c8 3e 80 00 00 	movabs $0x803ec8,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf db 3e 80 00 00 	movabs $0x803edb,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 b9 a2 04 80 00 00 	movabs $0x8004a2,%rcx
  8001ae:	00 00 00 
  8001b1:	ff d1                	callq  *%rcx

}
  8001b3:	c9                   	leaveq 
  8001b4:	c3                   	retq   

00000000008001b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %rbp
  8001b6:	48 89 e5             	mov    %rsp,%rbp
  8001b9:	48 83 ec 20          	sub    $0x20,%rsp
  8001bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8001c4:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
  8001d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8001d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001db:	48 63 d0             	movslq %eax,%rdx
  8001de:	48 89 d0             	mov    %rdx,%rax
  8001e1:	48 c1 e0 03          	shl    $0x3,%rax
  8001e5:	48 01 d0             	add    %rdx,%rax
  8001e8:	48 c1 e0 05          	shl    $0x5,%rax
  8001ec:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001f3:	00 00 00 
  8001f6:	48 01 c2             	add    %rax,%rdx
  8001f9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800200:	00 00 00 
  800203:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800206:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80020a:	7e 14                	jle    800220 <libmain+0x6b>
		binaryname = argv[0];
  80020c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800210:	48 8b 10             	mov    (%rax),%rdx
  800213:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80021a:	00 00 00 
  80021d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800220:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800224:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800227:	48 89 d6             	mov    %rdx,%rsi
  80022a:	89 c7                	mov    %eax,%edi
  80022c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800233:	00 00 00 
  800236:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800238:	48 b8 46 02 80 00 00 	movabs $0x800246,%rax
  80023f:	00 00 00 
  800242:	ff d0                	callq  *%rax
}
  800244:	c9                   	leaveq 
  800245:	c3                   	retq   

0000000000800246 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800246:	55                   	push   %rbp
  800247:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80024a:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800256:	bf 00 00 00 00       	mov    $0x0,%edi
  80025b:	48 b8 d9 18 80 00 00 	movabs $0x8018d9,%rax
  800262:	00 00 00 
  800265:	ff d0                	callq  *%rax
}
  800267:	5d                   	pop    %rbp
  800268:	c3                   	retq   

0000000000800269 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800269:	55                   	push   %rbp
  80026a:	48 89 e5             	mov    %rsp,%rbp
  80026d:	53                   	push   %rbx
  80026e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800275:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80027c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800282:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800289:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800290:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800297:	84 c0                	test   %al,%al
  800299:	74 23                	je     8002be <_panic+0x55>
  80029b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002a2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002aa:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002ae:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002b2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ba:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002be:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002c5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002cc:	00 00 00 
  8002cf:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d6:	00 00 00 
  8002d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002dd:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002e4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002eb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f9:	00 00 00 
  8002fc:	48 8b 18             	mov    (%rax),%rbx
  8002ff:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
  80030b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800311:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800318:	41 89 c8             	mov    %ecx,%r8d
  80031b:	48 89 d1             	mov    %rdx,%rcx
  80031e:	48 89 da             	mov    %rbx,%rdx
  800321:	89 c6                	mov    %eax,%esi
  800323:	48 bf 08 3f 80 00 00 	movabs $0x803f08,%rdi
  80032a:	00 00 00 
  80032d:	b8 00 00 00 00       	mov    $0x0,%eax
  800332:	49 b9 a2 04 80 00 00 	movabs $0x8004a2,%r9
  800339:	00 00 00 
  80033c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800346:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80034d:	48 89 d6             	mov    %rdx,%rsi
  800350:	48 89 c7             	mov    %rax,%rdi
  800353:	48 b8 f6 03 80 00 00 	movabs $0x8003f6,%rax
  80035a:	00 00 00 
  80035d:	ff d0                	callq  *%rax
	cprintf("\n");
  80035f:	48 bf 2b 3f 80 00 00 	movabs $0x803f2b,%rdi
  800366:	00 00 00 
  800369:	b8 00 00 00 00       	mov    $0x0,%eax
  80036e:	48 ba a2 04 80 00 00 	movabs $0x8004a2,%rdx
  800375:	00 00 00 
  800378:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037a:	cc                   	int3   
  80037b:	eb fd                	jmp    80037a <_panic+0x111>

000000000080037d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80037d:	55                   	push   %rbp
  80037e:	48 89 e5             	mov    %rsp,%rbp
  800381:	48 83 ec 10          	sub    $0x10,%rsp
  800385:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800388:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80038c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800390:	8b 00                	mov    (%rax),%eax
  800392:	8d 48 01             	lea    0x1(%rax),%ecx
  800395:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800399:	89 0a                	mov    %ecx,(%rdx)
  80039b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80039e:	89 d1                	mov    %edx,%ecx
  8003a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a4:	48 98                	cltq   
  8003a6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	8b 00                	mov    (%rax),%eax
  8003b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b5:	75 2c                	jne    8003e3 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bb:	8b 00                	mov    (%rax),%eax
  8003bd:	48 98                	cltq   
  8003bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c3:	48 83 c2 08          	add    $0x8,%rdx
  8003c7:	48 89 c6             	mov    %rax,%rsi
  8003ca:	48 89 d7             	mov    %rdx,%rdi
  8003cd:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  8003d4:	00 00 00 
  8003d7:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003dd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e7:	8b 40 04             	mov    0x4(%rax),%eax
  8003ea:	8d 50 01             	lea    0x1(%rax),%edx
  8003ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003f4:	c9                   	leaveq 
  8003f5:	c3                   	retq   

00000000008003f6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f6:	55                   	push   %rbp
  8003f7:	48 89 e5             	mov    %rsp,%rbp
  8003fa:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800401:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800408:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80040f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800416:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80041d:	48 8b 0a             	mov    (%rdx),%rcx
  800420:	48 89 08             	mov    %rcx,(%rax)
  800423:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800427:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800433:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80043a:	00 00 00 
    b.cnt = 0;
  80043d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800444:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800447:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80044e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800455:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80045c:	48 89 c6             	mov    %rax,%rsi
  80045f:	48 bf 7d 03 80 00 00 	movabs $0x80037d,%rdi
  800466:	00 00 00 
  800469:	48 b8 55 08 80 00 00 	movabs $0x800855,%rax
  800470:	00 00 00 
  800473:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800475:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80047b:	48 98                	cltq   
  80047d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800484:	48 83 c2 08          	add    $0x8,%rdx
  800488:	48 89 c6             	mov    %rax,%rsi
  80048b:	48 89 d7             	mov    %rdx,%rdi
  80048e:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  800495:	00 00 00 
  800498:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80049a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004a0:	c9                   	leaveq 
  8004a1:	c3                   	retq   

00000000008004a2 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ad:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004b4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004bb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004c2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004d0:	84 c0                	test   %al,%al
  8004d2:	74 20                	je     8004f4 <cprintf+0x52>
  8004d4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004dc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004e0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004e4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004ec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004f0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004f4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004fb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800502:	00 00 00 
  800505:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80050c:	00 00 00 
  80050f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800513:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80051a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800521:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800528:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80052f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800536:	48 8b 0a             	mov    (%rdx),%rcx
  800539:	48 89 08             	mov    %rcx,(%rax)
  80053c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800540:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800544:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800548:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80054c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800553:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80055a:	48 89 d6             	mov    %rdx,%rsi
  80055d:	48 89 c7             	mov    %rax,%rdi
  800560:	48 b8 f6 03 80 00 00 	movabs $0x8003f6,%rax
  800567:	00 00 00 
  80056a:	ff d0                	callq  *%rax
  80056c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800572:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800578:	c9                   	leaveq 
  800579:	c3                   	retq   

000000000080057a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057a:	55                   	push   %rbp
  80057b:	48 89 e5             	mov    %rsp,%rbp
  80057e:	53                   	push   %rbx
  80057f:	48 83 ec 38          	sub    $0x38,%rsp
  800583:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800587:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80058b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80058f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800592:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800596:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80059d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005a1:	77 3b                	ja     8005de <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a3:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a6:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005aa:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b6:	48 f7 f3             	div    %rbx
  8005b9:	48 89 c2             	mov    %rax,%rdx
  8005bc:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005bf:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c2:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ca:	41 89 f9             	mov    %edi,%r9d
  8005cd:	48 89 c7             	mov    %rax,%rdi
  8005d0:	48 b8 7a 05 80 00 00 	movabs $0x80057a,%rax
  8005d7:	00 00 00 
  8005da:	ff d0                	callq  *%rax
  8005dc:	eb 1e                	jmp    8005fc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005de:	eb 12                	jmp    8005f2 <printnum+0x78>
			putch(padc, putdat);
  8005e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005eb:	48 89 ce             	mov    %rcx,%rsi
  8005ee:	89 d7                	mov    %edx,%edi
  8005f0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005fa:	7f e4                	jg     8005e0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800603:	ba 00 00 00 00       	mov    $0x0,%edx
  800608:	48 f7 f1             	div    %rcx
  80060b:	48 89 d0             	mov    %rdx,%rax
  80060e:	48 ba 30 41 80 00 00 	movabs $0x804130,%rdx
  800615:	00 00 00 
  800618:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80061c:	0f be d0             	movsbl %al,%edx
  80061f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800627:	48 89 ce             	mov    %rcx,%rsi
  80062a:	89 d7                	mov    %edx,%edi
  80062c:	ff d0                	callq  *%rax
}
  80062e:	48 83 c4 38          	add    $0x38,%rsp
  800632:	5b                   	pop    %rbx
  800633:	5d                   	pop    %rbp
  800634:	c3                   	retq   

0000000000800635 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800635:	55                   	push   %rbp
  800636:	48 89 e5             	mov    %rsp,%rbp
  800639:	48 83 ec 1c          	sub    $0x1c,%rsp
  80063d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800641:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800644:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800648:	7e 52                	jle    80069c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80064a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064e:	8b 00                	mov    (%rax),%eax
  800650:	83 f8 30             	cmp    $0x30,%eax
  800653:	73 24                	jae    800679 <getuint+0x44>
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800661:	8b 00                	mov    (%rax),%eax
  800663:	89 c0                	mov    %eax,%eax
  800665:	48 01 d0             	add    %rdx,%rax
  800668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066c:	8b 12                	mov    (%rdx),%edx
  80066e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800671:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800675:	89 0a                	mov    %ecx,(%rdx)
  800677:	eb 17                	jmp    800690 <getuint+0x5b>
  800679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800681:	48 89 d0             	mov    %rdx,%rax
  800684:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800690:	48 8b 00             	mov    (%rax),%rax
  800693:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800697:	e9 a3 00 00 00       	jmpq   80073f <getuint+0x10a>
	else if (lflag)
  80069c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a0:	74 4f                	je     8006f1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	8b 00                	mov    (%rax),%eax
  8006a8:	83 f8 30             	cmp    $0x30,%eax
  8006ab:	73 24                	jae    8006d1 <getuint+0x9c>
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	8b 00                	mov    (%rax),%eax
  8006bb:	89 c0                	mov    %eax,%eax
  8006bd:	48 01 d0             	add    %rdx,%rax
  8006c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c4:	8b 12                	mov    (%rdx),%edx
  8006c6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cd:	89 0a                	mov    %ecx,(%rdx)
  8006cf:	eb 17                	jmp    8006e8 <getuint+0xb3>
  8006d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d9:	48 89 d0             	mov    %rdx,%rax
  8006dc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e8:	48 8b 00             	mov    (%rax),%rax
  8006eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ef:	eb 4e                	jmp    80073f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	83 f8 30             	cmp    $0x30,%eax
  8006fa:	73 24                	jae    800720 <getuint+0xeb>
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	8b 00                	mov    (%rax),%eax
  80070a:	89 c0                	mov    %eax,%eax
  80070c:	48 01 d0             	add    %rdx,%rax
  80070f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800713:	8b 12                	mov    (%rdx),%edx
  800715:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	89 0a                	mov    %ecx,(%rdx)
  80071e:	eb 17                	jmp    800737 <getuint+0x102>
  800720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800724:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800728:	48 89 d0             	mov    %rdx,%rax
  80072b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800733:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800737:	8b 00                	mov    (%rax),%eax
  800739:	89 c0                	mov    %eax,%eax
  80073b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800743:	c9                   	leaveq 
  800744:	c3                   	retq   

0000000000800745 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800745:	55                   	push   %rbp
  800746:	48 89 e5             	mov    %rsp,%rbp
  800749:	48 83 ec 1c          	sub    $0x1c,%rsp
  80074d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800751:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800754:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800758:	7e 52                	jle    8007ac <getint+0x67>
		x=va_arg(*ap, long long);
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	8b 00                	mov    (%rax),%eax
  800760:	83 f8 30             	cmp    $0x30,%eax
  800763:	73 24                	jae    800789 <getint+0x44>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	89 c0                	mov    %eax,%eax
  800775:	48 01 d0             	add    %rdx,%rax
  800778:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077c:	8b 12                	mov    (%rdx),%edx
  80077e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800785:	89 0a                	mov    %ecx,(%rdx)
  800787:	eb 17                	jmp    8007a0 <getint+0x5b>
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800791:	48 89 d0             	mov    %rdx,%rax
  800794:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800798:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a0:	48 8b 00             	mov    (%rax),%rax
  8007a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a7:	e9 a3 00 00 00       	jmpq   80084f <getint+0x10a>
	else if (lflag)
  8007ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007b0:	74 4f                	je     800801 <getint+0xbc>
		x=va_arg(*ap, long);
  8007b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b6:	8b 00                	mov    (%rax),%eax
  8007b8:	83 f8 30             	cmp    $0x30,%eax
  8007bb:	73 24                	jae    8007e1 <getint+0x9c>
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	8b 00                	mov    (%rax),%eax
  8007cb:	89 c0                	mov    %eax,%eax
  8007cd:	48 01 d0             	add    %rdx,%rax
  8007d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d4:	8b 12                	mov    (%rdx),%edx
  8007d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dd:	89 0a                	mov    %ecx,(%rdx)
  8007df:	eb 17                	jmp    8007f8 <getint+0xb3>
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e9:	48 89 d0             	mov    %rdx,%rax
  8007ec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f8:	48 8b 00             	mov    (%rax),%rax
  8007fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ff:	eb 4e                	jmp    80084f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800805:	8b 00                	mov    (%rax),%eax
  800807:	83 f8 30             	cmp    $0x30,%eax
  80080a:	73 24                	jae    800830 <getint+0xeb>
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	89 c0                	mov    %eax,%eax
  80081c:	48 01 d0             	add    %rdx,%rax
  80081f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800823:	8b 12                	mov    (%rdx),%edx
  800825:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800828:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082c:	89 0a                	mov    %ecx,(%rdx)
  80082e:	eb 17                	jmp    800847 <getint+0x102>
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800838:	48 89 d0             	mov    %rdx,%rax
  80083b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800847:	8b 00                	mov    (%rax),%eax
  800849:	48 98                	cltq   
  80084b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800853:	c9                   	leaveq 
  800854:	c3                   	retq   

0000000000800855 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800855:	55                   	push   %rbp
  800856:	48 89 e5             	mov    %rsp,%rbp
  800859:	41 54                	push   %r12
  80085b:	53                   	push   %rbx
  80085c:	48 83 ec 60          	sub    $0x60,%rsp
  800860:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800864:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800868:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80086c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800870:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800874:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800878:	48 8b 0a             	mov    (%rdx),%rcx
  80087b:	48 89 08             	mov    %rcx,(%rax)
  80087e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800882:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800886:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80088a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088e:	eb 17                	jmp    8008a7 <vprintfmt+0x52>
			if (ch == '\0')
  800890:	85 db                	test   %ebx,%ebx
  800892:	0f 84 df 04 00 00    	je     800d77 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800898:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80089c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a0:	48 89 d6             	mov    %rdx,%rsi
  8008a3:	89 df                	mov    %ebx,%edi
  8008a5:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008af:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d2                	jne    800890 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008c2:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ea:	0f b6 00             	movzbl (%rax),%eax
  8008ed:	0f b6 d8             	movzbl %al,%ebx
  8008f0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008f3:	83 f8 55             	cmp    $0x55,%eax
  8008f6:	0f 87 47 04 00 00    	ja     800d43 <vprintfmt+0x4ee>
  8008fc:	89 c0                	mov    %eax,%eax
  8008fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800905:	00 
  800906:	48 b8 58 41 80 00 00 	movabs $0x804158,%rax
  80090d:	00 00 00 
  800910:	48 01 d0             	add    %rdx,%rax
  800913:	48 8b 00             	mov    (%rax),%rax
  800916:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800918:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80091c:	eb c0                	jmp    8008de <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80091e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800922:	eb ba                	jmp    8008de <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800924:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80092b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80092e:	89 d0                	mov    %edx,%eax
  800930:	c1 e0 02             	shl    $0x2,%eax
  800933:	01 d0                	add    %edx,%eax
  800935:	01 c0                	add    %eax,%eax
  800937:	01 d8                	add    %ebx,%eax
  800939:	83 e8 30             	sub    $0x30,%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80093f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800943:	0f b6 00             	movzbl (%rax),%eax
  800946:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800949:	83 fb 2f             	cmp    $0x2f,%ebx
  80094c:	7e 0c                	jle    80095a <vprintfmt+0x105>
  80094e:	83 fb 39             	cmp    $0x39,%ebx
  800951:	7f 07                	jg     80095a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800953:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800958:	eb d1                	jmp    80092b <vprintfmt+0xd6>
			goto process_precision;
  80095a:	eb 58                	jmp    8009b4 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80095c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095f:	83 f8 30             	cmp    $0x30,%eax
  800962:	73 17                	jae    80097b <vprintfmt+0x126>
  800964:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800968:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096b:	89 c0                	mov    %eax,%eax
  80096d:	48 01 d0             	add    %rdx,%rax
  800970:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800973:	83 c2 08             	add    $0x8,%edx
  800976:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800979:	eb 0f                	jmp    80098a <vprintfmt+0x135>
  80097b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097f:	48 89 d0             	mov    %rdx,%rax
  800982:	48 83 c2 08          	add    $0x8,%rdx
  800986:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80098f:	eb 23                	jmp    8009b4 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800991:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800995:	79 0c                	jns    8009a3 <vprintfmt+0x14e>
				width = 0;
  800997:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80099e:	e9 3b ff ff ff       	jmpq   8008de <vprintfmt+0x89>
  8009a3:	e9 36 ff ff ff       	jmpq   8008de <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009af:	e9 2a ff ff ff       	jmpq   8008de <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b8:	79 12                	jns    8009cc <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009bd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c7:	e9 12 ff ff ff       	jmpq   8008de <vprintfmt+0x89>
  8009cc:	e9 0d ff ff ff       	jmpq   8008de <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009d1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009d5:	e9 04 ff ff ff       	jmpq   8008de <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dd:	83 f8 30             	cmp    $0x30,%eax
  8009e0:	73 17                	jae    8009f9 <vprintfmt+0x1a4>
  8009e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 01 d0             	add    %rdx,%rax
  8009ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f1:	83 c2 08             	add    $0x8,%edx
  8009f4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f7:	eb 0f                	jmp    800a08 <vprintfmt+0x1b3>
  8009f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fd:	48 89 d0             	mov    %rdx,%rax
  800a00:	48 83 c2 08          	add    $0x8,%rdx
  800a04:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a08:	8b 10                	mov    (%rax),%edx
  800a0a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a12:	48 89 ce             	mov    %rcx,%rsi
  800a15:	89 d7                	mov    %edx,%edi
  800a17:	ff d0                	callq  *%rax
			break;
  800a19:	e9 53 03 00 00       	jmpq   800d71 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a21:	83 f8 30             	cmp    $0x30,%eax
  800a24:	73 17                	jae    800a3d <vprintfmt+0x1e8>
  800a26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2d:	89 c0                	mov    %eax,%eax
  800a2f:	48 01 d0             	add    %rdx,%rax
  800a32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a35:	83 c2 08             	add    $0x8,%edx
  800a38:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a3b:	eb 0f                	jmp    800a4c <vprintfmt+0x1f7>
  800a3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a41:	48 89 d0             	mov    %rdx,%rax
  800a44:	48 83 c2 08          	add    $0x8,%rdx
  800a48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a4c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	79 02                	jns    800a54 <vprintfmt+0x1ff>
				err = -err;
  800a52:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a54:	83 fb 15             	cmp    $0x15,%ebx
  800a57:	7f 16                	jg     800a6f <vprintfmt+0x21a>
  800a59:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  800a60:	00 00 00 
  800a63:	48 63 d3             	movslq %ebx,%rdx
  800a66:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a6a:	4d 85 e4             	test   %r12,%r12
  800a6d:	75 2e                	jne    800a9d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a6f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a77:	89 d9                	mov    %ebx,%ecx
  800a79:	48 ba 41 41 80 00 00 	movabs $0x804141,%rdx
  800a80:	00 00 00 
  800a83:	48 89 c7             	mov    %rax,%rdi
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	49 b8 80 0d 80 00 00 	movabs $0x800d80,%r8
  800a92:	00 00 00 
  800a95:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a98:	e9 d4 02 00 00       	jmpq   800d71 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa5:	4c 89 e1             	mov    %r12,%rcx
  800aa8:	48 ba 4a 41 80 00 00 	movabs $0x80414a,%rdx
  800aaf:	00 00 00 
  800ab2:	48 89 c7             	mov    %rax,%rdi
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aba:	49 b8 80 0d 80 00 00 	movabs $0x800d80,%r8
  800ac1:	00 00 00 
  800ac4:	41 ff d0             	callq  *%r8
			break;
  800ac7:	e9 a5 02 00 00       	jmpq   800d71 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acf:	83 f8 30             	cmp    $0x30,%eax
  800ad2:	73 17                	jae    800aeb <vprintfmt+0x296>
  800ad4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adb:	89 c0                	mov    %eax,%eax
  800add:	48 01 d0             	add    %rdx,%rax
  800ae0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae3:	83 c2 08             	add    $0x8,%edx
  800ae6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae9:	eb 0f                	jmp    800afa <vprintfmt+0x2a5>
  800aeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aef:	48 89 d0             	mov    %rdx,%rax
  800af2:	48 83 c2 08          	add    $0x8,%rdx
  800af6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afa:	4c 8b 20             	mov    (%rax),%r12
  800afd:	4d 85 e4             	test   %r12,%r12
  800b00:	75 0a                	jne    800b0c <vprintfmt+0x2b7>
				p = "(null)";
  800b02:	49 bc 4d 41 80 00 00 	movabs $0x80414d,%r12
  800b09:	00 00 00 
			if (width > 0 && padc != '-')
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b10:	7e 3f                	jle    800b51 <vprintfmt+0x2fc>
  800b12:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b16:	74 39                	je     800b51 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b18:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b1b:	48 98                	cltq   
  800b1d:	48 89 c6             	mov    %rax,%rsi
  800b20:	4c 89 e7             	mov    %r12,%rdi
  800b23:	48 b8 2c 10 80 00 00 	movabs $0x80102c,%rax
  800b2a:	00 00 00 
  800b2d:	ff d0                	callq  *%rax
  800b2f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b32:	eb 17                	jmp    800b4b <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b34:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b38:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	48 89 ce             	mov    %rcx,%rsi
  800b43:	89 d7                	mov    %edx,%edi
  800b45:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b47:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4f:	7f e3                	jg     800b34 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b51:	eb 37                	jmp    800b8a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b53:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b57:	74 1e                	je     800b77 <vprintfmt+0x322>
  800b59:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5c:	7e 05                	jle    800b63 <vprintfmt+0x30e>
  800b5e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b61:	7e 14                	jle    800b77 <vprintfmt+0x322>
					putch('?', putdat);
  800b63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6b:	48 89 d6             	mov    %rdx,%rsi
  800b6e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b73:	ff d0                	callq  *%rax
  800b75:	eb 0f                	jmp    800b86 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7f:	48 89 d6             	mov    %rdx,%rsi
  800b82:	89 df                	mov    %ebx,%edi
  800b84:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b86:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8a:	4c 89 e0             	mov    %r12,%rax
  800b8d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b91:	0f b6 00             	movzbl (%rax),%eax
  800b94:	0f be d8             	movsbl %al,%ebx
  800b97:	85 db                	test   %ebx,%ebx
  800b99:	74 10                	je     800bab <vprintfmt+0x356>
  800b9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9f:	78 b2                	js     800b53 <vprintfmt+0x2fe>
  800ba1:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ba5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba9:	79 a8                	jns    800b53 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bab:	eb 16                	jmp    800bc3 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb5:	48 89 d6             	mov    %rdx,%rsi
  800bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  800bbd:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc7:	7f e4                	jg     800bad <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc9:	e9 a3 01 00 00       	jmpq   800d71 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bce:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd2:	be 03 00 00 00       	mov    $0x3,%esi
  800bd7:	48 89 c7             	mov    %rax,%rdi
  800bda:	48 b8 45 07 80 00 00 	movabs $0x800745,%rax
  800be1:	00 00 00 
  800be4:	ff d0                	callq  *%rax
  800be6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bee:	48 85 c0             	test   %rax,%rax
  800bf1:	79 1d                	jns    800c10 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bf3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfb:	48 89 d6             	mov    %rdx,%rsi
  800bfe:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c03:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c09:	48 f7 d8             	neg    %rax
  800c0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c10:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c17:	e9 e8 00 00 00       	jmpq   800d04 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c1c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c20:	be 03 00 00 00       	mov    $0x3,%esi
  800c25:	48 89 c7             	mov    %rax,%rdi
  800c28:	48 b8 35 06 80 00 00 	movabs $0x800635,%rax
  800c2f:	00 00 00 
  800c32:	ff d0                	callq  *%rax
  800c34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c38:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3f:	e9 c0 00 00 00       	jmpq   800d04 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	48 89 d6             	mov    %rdx,%rsi
  800c4f:	bf 58 00 00 00       	mov    $0x58,%edi
  800c54:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 58 00 00 00       	mov    $0x58,%edi
  800c66:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c70:	48 89 d6             	mov    %rdx,%rsi
  800c73:	bf 58 00 00 00       	mov    $0x58,%edi
  800c78:	ff d0                	callq  *%rax
			break;
  800c7a:	e9 f2 00 00 00       	jmpq   800d71 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c87:	48 89 d6             	mov    %rdx,%rsi
  800c8a:	bf 30 00 00 00       	mov    $0x30,%edi
  800c8f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c99:	48 89 d6             	mov    %rdx,%rsi
  800c9c:	bf 78 00 00 00       	mov    $0x78,%edi
  800ca1:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	83 f8 30             	cmp    $0x30,%eax
  800ca9:	73 17                	jae    800cc2 <vprintfmt+0x46d>
  800cab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb2:	89 c0                	mov    %eax,%eax
  800cb4:	48 01 d0             	add    %rdx,%rax
  800cb7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cba:	83 c2 08             	add    $0x8,%edx
  800cbd:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc0:	eb 0f                	jmp    800cd1 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cc2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc6:	48 89 d0             	mov    %rdx,%rax
  800cc9:	48 83 c2 08          	add    $0x8,%rdx
  800ccd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd1:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cdf:	eb 23                	jmp    800d04 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ce1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce5:	be 03 00 00 00       	mov    $0x3,%esi
  800cea:	48 89 c7             	mov    %rax,%rdi
  800ced:	48 b8 35 06 80 00 00 	movabs $0x800635,%rax
  800cf4:	00 00 00 
  800cf7:	ff d0                	callq  *%rax
  800cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cfd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d04:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d09:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d0c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d13:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1b:	45 89 c1             	mov    %r8d,%r9d
  800d1e:	41 89 f8             	mov    %edi,%r8d
  800d21:	48 89 c7             	mov    %rax,%rdi
  800d24:	48 b8 7a 05 80 00 00 	movabs $0x80057a,%rax
  800d2b:	00 00 00 
  800d2e:	ff d0                	callq  *%rax
			break;
  800d30:	eb 3f                	jmp    800d71 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	89 df                	mov    %ebx,%edi
  800d3f:	ff d0                	callq  *%rax
			break;
  800d41:	eb 2e                	jmp    800d71 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4b:	48 89 d6             	mov    %rdx,%rsi
  800d4e:	bf 25 00 00 00       	mov    $0x25,%edi
  800d53:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d55:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5a:	eb 05                	jmp    800d61 <vprintfmt+0x50c>
  800d5c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d65:	48 83 e8 01          	sub    $0x1,%rax
  800d69:	0f b6 00             	movzbl (%rax),%eax
  800d6c:	3c 25                	cmp    $0x25,%al
  800d6e:	75 ec                	jne    800d5c <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d70:	90                   	nop
		}
	}
  800d71:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d72:	e9 30 fb ff ff       	jmpq   8008a7 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d77:	48 83 c4 60          	add    $0x60,%rsp
  800d7b:	5b                   	pop    %rbx
  800d7c:	41 5c                	pop    %r12
  800d7e:	5d                   	pop    %rbp
  800d7f:	c3                   	retq   

0000000000800d80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d80:	55                   	push   %rbp
  800d81:	48 89 e5             	mov    %rsp,%rbp
  800d84:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d8b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d92:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d99:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dae:	84 c0                	test   %al,%al
  800db0:	74 20                	je     800dd2 <printfmt+0x52>
  800db2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dbe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dce:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800de0:	00 00 00 
  800de3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dea:	00 00 00 
  800ded:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dff:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e06:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e0d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e14:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e1b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e22:	48 89 c7             	mov    %rax,%rdi
  800e25:	48 b8 55 08 80 00 00 	movabs $0x800855,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e31:	c9                   	leaveq 
  800e32:	c3                   	retq   

0000000000800e33 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e33:	55                   	push   %rbp
  800e34:	48 89 e5             	mov    %rsp,%rbp
  800e37:	48 83 ec 10          	sub    $0x10,%rsp
  800e3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e46:	8b 40 10             	mov    0x10(%rax),%eax
  800e49:	8d 50 01             	lea    0x1(%rax),%edx
  800e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e50:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 10             	mov    (%rax),%rdx
  800e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e62:	48 39 c2             	cmp    %rax,%rdx
  800e65:	73 17                	jae    800e7e <sprintputch+0x4b>
		*b->buf++ = ch;
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	48 8b 00             	mov    (%rax),%rax
  800e6e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e76:	48 89 0a             	mov    %rcx,(%rdx)
  800e79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e7c:	88 10                	mov    %dl,(%rax)
}
  800e7e:	c9                   	leaveq 
  800e7f:	c3                   	retq   

0000000000800e80 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e80:	55                   	push   %rbp
  800e81:	48 89 e5             	mov    %rsp,%rbp
  800e84:	48 83 ec 50          	sub    $0x50,%rsp
  800e88:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e8c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e8f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e93:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e97:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e9b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e9f:	48 8b 0a             	mov    (%rdx),%rcx
  800ea2:	48 89 08             	mov    %rcx,(%rax)
  800ea5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ead:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ebd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ec0:	48 98                	cltq   
  800ec2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ec6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eca:	48 01 d0             	add    %rdx,%rax
  800ecd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ed1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800edd:	74 06                	je     800ee5 <vsnprintf+0x65>
  800edf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ee3:	7f 07                	jg     800eec <vsnprintf+0x6c>
		return -E_INVAL;
  800ee5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eea:	eb 2f                	jmp    800f1b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eec:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ef0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ef4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef8:	48 89 c6             	mov    %rax,%rsi
  800efb:	48 bf 33 0e 80 00 00 	movabs $0x800e33,%rdi
  800f02:	00 00 00 
  800f05:	48 b8 55 08 80 00 00 	movabs $0x800855,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f15:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f18:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f1b:	c9                   	leaveq 
  800f1c:	c3                   	retq   

0000000000800f1d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f1d:	55                   	push   %rbp
  800f1e:	48 89 e5             	mov    %rsp,%rbp
  800f21:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f28:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f2f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4a:	84 c0                	test   %al,%al
  800f4c:	74 20                	je     800f6e <snprintf+0x51>
  800f4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f6e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f75:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f7c:	00 00 00 
  800f7f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f86:	00 00 00 
  800f89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f8d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f9b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fa2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fb0:	48 8b 0a             	mov    (%rdx),%rcx
  800fb3:	48 89 08             	mov    %rcx,(%rax)
  800fb6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fbe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fc6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fcd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fd4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fda:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fe1:	48 89 c7             	mov    %rax,%rdi
  800fe4:	48 b8 80 0e 80 00 00 	movabs $0x800e80,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
  800ff0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ff6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ffc:	c9                   	leaveq 
  800ffd:	c3                   	retq   

0000000000800ffe <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ffe:	55                   	push   %rbp
  800fff:	48 89 e5             	mov    %rsp,%rbp
  801002:	48 83 ec 18          	sub    $0x18,%rsp
  801006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801011:	eb 09                	jmp    80101c <strlen+0x1e>
		n++;
  801013:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80101c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801020:	0f b6 00             	movzbl (%rax),%eax
  801023:	84 c0                	test   %al,%al
  801025:	75 ec                	jne    801013 <strlen+0x15>
		n++;
	return n;
  801027:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102a:	c9                   	leaveq 
  80102b:	c3                   	retq   

000000000080102c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 83 ec 20          	sub    $0x20,%rsp
  801034:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801038:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801043:	eb 0e                	jmp    801053 <strnlen+0x27>
		n++;
  801045:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801049:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801053:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801058:	74 0b                	je     801065 <strnlen+0x39>
  80105a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105e:	0f b6 00             	movzbl (%rax),%eax
  801061:	84 c0                	test   %al,%al
  801063:	75 e0                	jne    801045 <strnlen+0x19>
		n++;
	return n;
  801065:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801068:	c9                   	leaveq 
  801069:	c3                   	retq   

000000000080106a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106a:	55                   	push   %rbp
  80106b:	48 89 e5             	mov    %rsp,%rbp
  80106e:	48 83 ec 20          	sub    $0x20,%rsp
  801072:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801076:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801082:	90                   	nop
  801083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801087:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80108b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80108f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801093:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801097:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80109b:	0f b6 12             	movzbl (%rdx),%edx
  80109e:	88 10                	mov    %dl,(%rax)
  8010a0:	0f b6 00             	movzbl (%rax),%eax
  8010a3:	84 c0                	test   %al,%al
  8010a5:	75 dc                	jne    801083 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ab:	c9                   	leaveq 
  8010ac:	c3                   	retq   

00000000008010ad <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010ad:	55                   	push   %rbp
  8010ae:	48 89 e5             	mov    %rsp,%rbp
  8010b1:	48 83 ec 20          	sub    $0x20,%rsp
  8010b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c1:	48 89 c7             	mov    %rax,%rdi
  8010c4:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	callq  *%rax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d6:	48 63 d0             	movslq %eax,%rdx
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 01 c2             	add    %rax,%rdx
  8010e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e4:	48 89 c6             	mov    %rax,%rsi
  8010e7:	48 89 d7             	mov    %rdx,%rdi
  8010ea:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  8010f1:	00 00 00 
  8010f4:	ff d0                	callq  *%rax
	return dst;
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010fa:	c9                   	leaveq 
  8010fb:	c3                   	retq   

00000000008010fc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010fc:	55                   	push   %rbp
  8010fd:	48 89 e5             	mov    %rsp,%rbp
  801100:	48 83 ec 28          	sub    $0x28,%rsp
  801104:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801108:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801118:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80111f:	00 
  801120:	eb 2a                	jmp    80114c <strncpy+0x50>
		*dst++ = *src;
  801122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80112e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801132:	0f b6 12             	movzbl (%rdx),%edx
  801135:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801137:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	84 c0                	test   %al,%al
  801140:	74 05                	je     801147 <strncpy+0x4b>
			src++;
  801142:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801147:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80114c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801150:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801154:	72 cc                	jb     801122 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80115a:	c9                   	leaveq 
  80115b:	c3                   	retq   

000000000080115c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80115c:	55                   	push   %rbp
  80115d:	48 89 e5             	mov    %rsp,%rbp
  801160:	48 83 ec 28          	sub    $0x28,%rsp
  801164:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801168:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801178:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117d:	74 3d                	je     8011bc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80117f:	eb 1d                	jmp    80119e <strlcpy+0x42>
			*dst++ = *src++;
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801189:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80118d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801191:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801195:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801199:	0f b6 12             	movzbl (%rdx),%edx
  80119c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80119e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011a3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a8:	74 0b                	je     8011b5 <strlcpy+0x59>
  8011aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ae:	0f b6 00             	movzbl (%rax),%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	75 cc                	jne    801181 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c4:	48 29 c2             	sub    %rax,%rdx
  8011c7:	48 89 d0             	mov    %rdx,%rax
}
  8011ca:	c9                   	leaveq 
  8011cb:	c3                   	retq   

00000000008011cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011cc:	55                   	push   %rbp
  8011cd:	48 89 e5             	mov    %rsp,%rbp
  8011d0:	48 83 ec 10          	sub    $0x10,%rsp
  8011d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011dc:	eb 0a                	jmp    8011e8 <strcmp+0x1c>
		p++, q++;
  8011de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ec:	0f b6 00             	movzbl (%rax),%eax
  8011ef:	84 c0                	test   %al,%al
  8011f1:	74 12                	je     801205 <strcmp+0x39>
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f7:	0f b6 10             	movzbl (%rax),%edx
  8011fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fe:	0f b6 00             	movzbl (%rax),%eax
  801201:	38 c2                	cmp    %al,%dl
  801203:	74 d9                	je     8011de <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	0f b6 00             	movzbl (%rax),%eax
  80120c:	0f b6 d0             	movzbl %al,%edx
  80120f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	0f b6 c0             	movzbl %al,%eax
  801219:	29 c2                	sub    %eax,%edx
  80121b:	89 d0                	mov    %edx,%eax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 83 ec 18          	sub    $0x18,%rsp
  801227:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801233:	eb 0f                	jmp    801244 <strncmp+0x25>
		n--, p++, q++;
  801235:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80123a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801244:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801249:	74 1d                	je     801268 <strncmp+0x49>
  80124b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	84 c0                	test   %al,%al
  801254:	74 12                	je     801268 <strncmp+0x49>
  801256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125a:	0f b6 10             	movzbl (%rax),%edx
  80125d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	38 c2                	cmp    %al,%dl
  801266:	74 cd                	je     801235 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801268:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126d:	75 07                	jne    801276 <strncmp+0x57>
		return 0;
  80126f:	b8 00 00 00 00       	mov    $0x0,%eax
  801274:	eb 18                	jmp    80128e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	0f b6 00             	movzbl (%rax),%eax
  80127d:	0f b6 d0             	movzbl %al,%edx
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 c0             	movzbl %al,%eax
  80128a:	29 c2                	sub    %eax,%edx
  80128c:	89 d0                	mov    %edx,%eax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 0c          	sub    $0xc,%rsp
  801298:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129c:	89 f0                	mov    %esi,%eax
  80129e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a1:	eb 17                	jmp    8012ba <strchr+0x2a>
		if (*s == c)
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	0f b6 00             	movzbl (%rax),%eax
  8012aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ad:	75 06                	jne    8012b5 <strchr+0x25>
			return (char *) s;
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	eb 15                	jmp    8012ca <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	84 c0                	test   %al,%al
  8012c3:	75 de                	jne    8012a3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ca:	c9                   	leaveq 
  8012cb:	c3                   	retq   

00000000008012cc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012cc:	55                   	push   %rbp
  8012cd:	48 89 e5             	mov    %rsp,%rbp
  8012d0:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d8:	89 f0                	mov    %esi,%eax
  8012da:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012dd:	eb 13                	jmp    8012f2 <strfind+0x26>
		if (*s == c)
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e9:	75 02                	jne    8012ed <strfind+0x21>
			break;
  8012eb:	eb 10                	jmp    8012fd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	0f b6 00             	movzbl (%rax),%eax
  8012f9:	84 c0                	test   %al,%al
  8012fb:	75 e2                	jne    8012df <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 18          	sub    $0x18,%rsp
  80130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801312:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131b:	75 06                	jne    801323 <memset+0x20>
		return v;
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	eb 69                	jmp    80138c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	83 e0 03             	and    $0x3,%eax
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	75 48                	jne    801377 <memset+0x74>
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	48 85 c0             	test   %rax,%rax
  801339:	75 3c                	jne    801377 <memset+0x74>
		c &= 0xFF;
  80133b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801342:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801345:	c1 e0 18             	shl    $0x18,%eax
  801348:	89 c2                	mov    %eax,%edx
  80134a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134d:	c1 e0 10             	shl    $0x10,%eax
  801350:	09 c2                	or     %eax,%edx
  801352:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801355:	c1 e0 08             	shl    $0x8,%eax
  801358:	09 d0                	or     %edx,%eax
  80135a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801361:	48 c1 e8 02          	shr    $0x2,%rax
  801365:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801368:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136f:	48 89 d7             	mov    %rdx,%rdi
  801372:	fc                   	cld    
  801373:	f3 ab                	rep stos %eax,%es:(%rdi)
  801375:	eb 11                	jmp    801388 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801377:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801382:	48 89 d7             	mov    %rdx,%rdi
  801385:	fc                   	cld    
  801386:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 28          	sub    $0x28,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ba:	0f 83 88 00 00 00    	jae    801448 <memmove+0xba>
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c8:	48 01 d0             	add    %rdx,%rax
  8013cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013cf:	76 77                	jbe    801448 <memmove+0xba>
		s += n;
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 3b                	jne    801428 <memmove+0x9a>
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 2f                	jne    801428 <memmove+0x9a>
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 23                	jne    801428 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801409:	48 83 e8 04          	sub    $0x4,%rax
  80140d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801411:	48 83 ea 04          	sub    $0x4,%rdx
  801415:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801419:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80141d:	48 89 c7             	mov    %rax,%rdi
  801420:	48 89 d6             	mov    %rdx,%rsi
  801423:	fd                   	std    
  801424:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801426:	eb 1d                	jmp    801445 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	48 89 d7             	mov    %rdx,%rdi
  80143f:	48 89 c1             	mov    %rax,%rcx
  801442:	fd                   	std    
  801443:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801445:	fc                   	cld    
  801446:	eb 57                	jmp    80149f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	83 e0 03             	and    $0x3,%eax
  80144f:	48 85 c0             	test   %rax,%rax
  801452:	75 36                	jne    80148a <memmove+0xfc>
  801454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 2a                	jne    80148a <memmove+0xfc>
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 1e                	jne    80148a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	48 c1 e8 02          	shr    $0x2,%rax
  801474:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147f:	48 89 c7             	mov    %rax,%rdi
  801482:	48 89 d6             	mov    %rdx,%rsi
  801485:	fc                   	cld    
  801486:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801488:	eb 15                	jmp    80149f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80148a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801492:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801496:	48 89 c7             	mov    %rax,%rdi
  801499:	48 89 d6             	mov    %rdx,%rsi
  80149c:	fc                   	cld    
  80149d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a3:	c9                   	leaveq 
  8014a4:	c3                   	retq   

00000000008014a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a5:	55                   	push   %rbp
  8014a6:	48 89 e5             	mov    %rsp,%rbp
  8014a9:	48 83 ec 18          	sub    $0x18,%rsp
  8014ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	48 89 ce             	mov    %rcx,%rsi
  8014c8:	48 89 c7             	mov    %rax,%rdi
  8014cb:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8014d2:	00 00 00 
  8014d5:	ff d0                	callq  *%rax
}
  8014d7:	c9                   	leaveq 
  8014d8:	c3                   	retq   

00000000008014d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	48 83 ec 28          	sub    $0x28,%rsp
  8014e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014fd:	eb 36                	jmp    801535 <memcmp+0x5c>
		if (*s1 != *s2)
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 10             	movzbl (%rax),%edx
  801506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	38 c2                	cmp    %al,%dl
  80150f:	74 1a                	je     80152b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	0f b6 d0             	movzbl %al,%edx
  80151b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f b6 c0             	movzbl %al,%eax
  801525:	29 c2                	sub    %eax,%edx
  801527:	89 d0                	mov    %edx,%eax
  801529:	eb 20                	jmp    80154b <memcmp+0x72>
		s1++, s2++;
  80152b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801530:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801539:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801541:	48 85 c0             	test   %rax,%rax
  801544:	75 b9                	jne    8014ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	c9                   	leaveq 
  80154c:	c3                   	retq   

000000000080154d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80154d:	55                   	push   %rbp
  80154e:	48 89 e5             	mov    %rsp,%rbp
  801551:	48 83 ec 28          	sub    $0x28,%rsp
  801555:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801559:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80155c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801568:	48 01 d0             	add    %rdx,%rax
  80156b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80156f:	eb 15                	jmp    801586 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801575:	0f b6 10             	movzbl (%rax),%edx
  801578:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80157b:	38 c2                	cmp    %al,%dl
  80157d:	75 02                	jne    801581 <memfind+0x34>
			break;
  80157f:	eb 0f                	jmp    801590 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801581:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80158e:	72 e1                	jb     801571 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801594:	c9                   	leaveq 
  801595:	c3                   	retq   

0000000000801596 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	48 83 ec 34          	sub    $0x34,%rsp
  80159e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015a6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015b0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015b7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b8:	eb 05                	jmp    8015bf <strtol+0x29>
		s++;
  8015ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	3c 20                	cmp    $0x20,%al
  8015c8:	74 f0                	je     8015ba <strtol+0x24>
  8015ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ce:	0f b6 00             	movzbl (%rax),%eax
  8015d1:	3c 09                	cmp    $0x9,%al
  8015d3:	74 e5                	je     8015ba <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	3c 2b                	cmp    $0x2b,%al
  8015de:	75 07                	jne    8015e7 <strtol+0x51>
		s++;
  8015e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e5:	eb 17                	jmp    8015fe <strtol+0x68>
	else if (*s == '-')
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	3c 2d                	cmp    $0x2d,%al
  8015f0:	75 0c                	jne    8015fe <strtol+0x68>
		s++, neg = 1;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801602:	74 06                	je     80160a <strtol+0x74>
  801604:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801608:	75 28                	jne    801632 <strtol+0x9c>
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	3c 30                	cmp    $0x30,%al
  801613:	75 1d                	jne    801632 <strtol+0x9c>
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	48 83 c0 01          	add    $0x1,%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3c 78                	cmp    $0x78,%al
  801622:	75 0e                	jne    801632 <strtol+0x9c>
		s += 2, base = 16;
  801624:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801629:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801630:	eb 2c                	jmp    80165e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801632:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801636:	75 19                	jne    801651 <strtol+0xbb>
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	0f b6 00             	movzbl (%rax),%eax
  80163f:	3c 30                	cmp    $0x30,%al
  801641:	75 0e                	jne    801651 <strtol+0xbb>
		s++, base = 8;
  801643:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801648:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80164f:	eb 0d                	jmp    80165e <strtol+0xc8>
	else if (base == 0)
  801651:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801655:	75 07                	jne    80165e <strtol+0xc8>
		base = 10;
  801657:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 2f                	cmp    $0x2f,%al
  801667:	7e 1d                	jle    801686 <strtol+0xf0>
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 12                	jg     801686 <strtol+0xf0>
			dig = *s - '0';
  801674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 30             	sub    $0x30,%eax
  801681:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801684:	eb 4e                	jmp    8016d4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	3c 60                	cmp    $0x60,%al
  80168f:	7e 1d                	jle    8016ae <strtol+0x118>
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	3c 7a                	cmp    $0x7a,%al
  80169a:	7f 12                	jg     8016ae <strtol+0x118>
			dig = *s - 'a' + 10;
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	0f be c0             	movsbl %al,%eax
  8016a6:	83 e8 57             	sub    $0x57,%eax
  8016a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ac:	eb 26                	jmp    8016d4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	3c 40                	cmp    $0x40,%al
  8016b7:	7e 48                	jle    801701 <strtol+0x16b>
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	3c 5a                	cmp    $0x5a,%al
  8016c2:	7f 3d                	jg     801701 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	0f b6 00             	movzbl (%rax),%eax
  8016cb:	0f be c0             	movsbl %al,%eax
  8016ce:	83 e8 37             	sub    $0x37,%eax
  8016d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016da:	7c 02                	jl     8016de <strtol+0x148>
			break;
  8016dc:	eb 23                	jmp    801701 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016e6:	48 98                	cltq   
  8016e8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016ed:	48 89 c2             	mov    %rax,%rdx
  8016f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f3:	48 98                	cltq   
  8016f5:	48 01 d0             	add    %rdx,%rax
  8016f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016fc:	e9 5d ff ff ff       	jmpq   80165e <strtol+0xc8>

	if (endptr)
  801701:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801706:	74 0b                	je     801713 <strtol+0x17d>
		*endptr = (char *) s;
  801708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801710:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801717:	74 09                	je     801722 <strtol+0x18c>
  801719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171d:	48 f7 d8             	neg    %rax
  801720:	eb 04                	jmp    801726 <strtol+0x190>
  801722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801726:	c9                   	leaveq 
  801727:	c3                   	retq   

0000000000801728 <strstr>:

char * strstr(const char *in, const char *str)
{
  801728:	55                   	push   %rbp
  801729:	48 89 e5             	mov    %rsp,%rbp
  80172c:	48 83 ec 30          	sub    $0x30,%rsp
  801730:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801734:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801738:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801740:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80174a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80174e:	75 06                	jne    801756 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	eb 6b                	jmp    8017c1 <strstr+0x99>

	len = strlen(str);
  801756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175a:	48 89 c7             	mov    %rax,%rdi
  80175d:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  801764:	00 00 00 
  801767:	ff d0                	callq  *%rax
  801769:	48 98                	cltq   
  80176b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801777:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801781:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801785:	75 07                	jne    80178e <strstr+0x66>
				return (char *) 0;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
  80178c:	eb 33                	jmp    8017c1 <strstr+0x99>
		} while (sc != c);
  80178e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801792:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801795:	75 d8                	jne    80176f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801797:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80179b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80179f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a3:	48 89 ce             	mov    %rcx,%rsi
  8017a6:	48 89 c7             	mov    %rax,%rdi
  8017a9:	48 b8 1f 12 80 00 00 	movabs $0x80121f,%rax
  8017b0:	00 00 00 
  8017b3:	ff d0                	callq  *%rax
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	75 b6                	jne    80176f <strstr+0x47>

	return (char *) (in - 1);
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	48 83 e8 01          	sub    $0x1,%rax
}
  8017c1:	c9                   	leaveq 
  8017c2:	c3                   	retq   

00000000008017c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017c3:	55                   	push   %rbp
  8017c4:	48 89 e5             	mov    %rsp,%rbp
  8017c7:	53                   	push   %rbx
  8017c8:	48 83 ec 48          	sub    $0x48,%rsp
  8017cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017cf:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017d2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017da:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017de:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017f9:	4c 89 c3             	mov    %r8,%rbx
  8017fc:	cd 30                	int    $0x30
  8017fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801802:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801806:	74 3e                	je     801846 <syscall+0x83>
  801808:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80180d:	7e 37                	jle    801846 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80180f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801813:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801816:	49 89 d0             	mov    %rdx,%r8
  801819:	89 c1                	mov    %eax,%ecx
  80181b:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  801822:	00 00 00 
  801825:	be 23 00 00 00       	mov    $0x23,%esi
  80182a:	48 bf 25 44 80 00 00 	movabs $0x804425,%rdi
  801831:	00 00 00 
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
  801839:	49 b9 69 02 80 00 00 	movabs $0x800269,%r9
  801840:	00 00 00 
  801843:	41 ff d1             	callq  *%r9

	return ret;
  801846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80184a:	48 83 c4 48          	add    $0x48,%rsp
  80184e:	5b                   	pop    %rbx
  80184f:	5d                   	pop    %rbp
  801850:	c3                   	retq   

0000000000801851 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	48 83 ec 20          	sub    $0x20,%rsp
  801859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80185d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801861:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801865:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801869:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801870:	00 
  801871:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801877:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187d:	48 89 d1             	mov    %rdx,%rcx
  801880:	48 89 c2             	mov    %rax,%rdx
  801883:	be 00 00 00 00       	mov    $0x0,%esi
  801888:	bf 00 00 00 00       	mov    $0x0,%edi
  80188d:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801894:	00 00 00 
  801897:	ff d0                	callq  *%rax
}
  801899:	c9                   	leaveq 
  80189a:	c3                   	retq   

000000000080189b <sys_cgetc>:

int
sys_cgetc(void)
{
  80189b:	55                   	push   %rbp
  80189c:	48 89 e5             	mov    %rsp,%rbp
  80189f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018aa:	00 
  8018ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c1:	be 00 00 00 00       	mov    $0x0,%esi
  8018c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8018cb:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  8018d2:	00 00 00 
  8018d5:	ff d0                	callq  *%rax
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	48 83 ec 10          	sub    $0x10,%rsp
  8018e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e7:	48 98                	cltq   
  8018e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f0:	00 
  8018f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801902:	48 89 c2             	mov    %rax,%rdx
  801905:	be 01 00 00 00       	mov    $0x1,%esi
  80190a:	bf 03 00 00 00       	mov    $0x3,%edi
  80190f:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801916:	00 00 00 
  801919:	ff d0                	callq  *%rax
}
  80191b:	c9                   	leaveq 
  80191c:	c3                   	retq   

000000000080191d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80191d:	55                   	push   %rbp
  80191e:	48 89 e5             	mov    %rsp,%rbp
  801921:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801925:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192c:	00 
  80192d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801933:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801939:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	be 00 00 00 00       	mov    $0x0,%esi
  801948:	bf 02 00 00 00       	mov    $0x2,%edi
  80194d:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801954:	00 00 00 
  801957:	ff d0                	callq  *%rax
}
  801959:	c9                   	leaveq 
  80195a:	c3                   	retq   

000000000080195b <sys_yield>:

void
sys_yield(void)
{
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
  80195f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801963:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196a:	00 
  80196b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801971:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801977:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197c:	ba 00 00 00 00       	mov    $0x0,%edx
  801981:	be 00 00 00 00       	mov    $0x0,%esi
  801986:	bf 0b 00 00 00       	mov    $0xb,%edi
  80198b:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801992:	00 00 00 
  801995:	ff d0                	callq  *%rax
}
  801997:	c9                   	leaveq 
  801998:	c3                   	retq   

0000000000801999 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	48 83 ec 20          	sub    $0x20,%rsp
  8019a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ae:	48 63 c8             	movslq %eax,%rcx
  8019b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b8:	48 98                	cltq   
  8019ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c1:	00 
  8019c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c8:	49 89 c8             	mov    %rcx,%r8
  8019cb:	48 89 d1             	mov    %rdx,%rcx
  8019ce:	48 89 c2             	mov    %rax,%rdx
  8019d1:	be 01 00 00 00       	mov    $0x1,%esi
  8019d6:	bf 04 00 00 00       	mov    $0x4,%edi
  8019db:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  8019e2:	00 00 00 
  8019e5:	ff d0                	callq  *%rax
}
  8019e7:	c9                   	leaveq 
  8019e8:	c3                   	retq   

00000000008019e9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019e9:	55                   	push   %rbp
  8019ea:	48 89 e5             	mov    %rsp,%rbp
  8019ed:	48 83 ec 30          	sub    $0x30,%rsp
  8019f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019ff:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a03:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a06:	48 63 c8             	movslq %eax,%rcx
  801a09:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a10:	48 63 f0             	movslq %eax,%rsi
  801a13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1a:	48 98                	cltq   
  801a1c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a20:	49 89 f9             	mov    %rdi,%r9
  801a23:	49 89 f0             	mov    %rsi,%r8
  801a26:	48 89 d1             	mov    %rdx,%rcx
  801a29:	48 89 c2             	mov    %rax,%rdx
  801a2c:	be 01 00 00 00       	mov    $0x1,%esi
  801a31:	bf 05 00 00 00       	mov    $0x5,%edi
  801a36:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801a3d:	00 00 00 
  801a40:	ff d0                	callq  *%rax
}
  801a42:	c9                   	leaveq 
  801a43:	c3                   	retq   

0000000000801a44 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a44:	55                   	push   %rbp
  801a45:	48 89 e5             	mov    %rsp,%rbp
  801a48:	48 83 ec 20          	sub    $0x20,%rsp
  801a4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5a:	48 98                	cltq   
  801a5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a63:	00 
  801a64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a70:	48 89 d1             	mov    %rdx,%rcx
  801a73:	48 89 c2             	mov    %rax,%rdx
  801a76:	be 01 00 00 00       	mov    $0x1,%esi
  801a7b:	bf 06 00 00 00       	mov    $0x6,%edi
  801a80:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	callq  *%rax
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	48 83 ec 10          	sub    $0x10,%rsp
  801a96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a99:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9f:	48 63 d0             	movslq %eax,%rdx
  801aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa5:	48 98                	cltq   
  801aa7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aae:	00 
  801aaf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abb:	48 89 d1             	mov    %rdx,%rcx
  801abe:	48 89 c2             	mov    %rax,%rdx
  801ac1:	be 01 00 00 00       	mov    $0x1,%esi
  801ac6:	bf 08 00 00 00       	mov    $0x8,%edi
  801acb:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
}
  801ad7:	c9                   	leaveq 
  801ad8:	c3                   	retq   

0000000000801ad9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ad9:	55                   	push   %rbp
  801ada:	48 89 e5             	mov    %rsp,%rbp
  801add:	48 83 ec 20          	sub    $0x20,%rsp
  801ae1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ae8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aef:	48 98                	cltq   
  801af1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af8:	00 
  801af9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b05:	48 89 d1             	mov    %rdx,%rcx
  801b08:	48 89 c2             	mov    %rax,%rdx
  801b0b:	be 01 00 00 00       	mov    $0x1,%esi
  801b10:	bf 09 00 00 00       	mov    $0x9,%edi
  801b15:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	callq  *%rax
}
  801b21:	c9                   	leaveq 
  801b22:	c3                   	retq   

0000000000801b23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b23:	55                   	push   %rbp
  801b24:	48 89 e5             	mov    %rsp,%rbp
  801b27:	48 83 ec 20          	sub    $0x20,%rsp
  801b2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b39:	48 98                	cltq   
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	48 89 d1             	mov    %rdx,%rcx
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	be 01 00 00 00       	mov    $0x1,%esi
  801b5a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b5f:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 20          	sub    $0x20,%rsp
  801b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b7c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b80:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b86:	48 63 f0             	movslq %eax,%rsi
  801b89:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b90:	48 98                	cltq   
  801b92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9d:	00 
  801b9e:	49 89 f1             	mov    %rsi,%r9
  801ba1:	49 89 c8             	mov    %rcx,%r8
  801ba4:	48 89 d1             	mov    %rdx,%rcx
  801ba7:	48 89 c2             	mov    %rax,%rdx
  801baa:	be 00 00 00 00       	mov    $0x0,%esi
  801baf:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bb4:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	callq  *%rax
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 10          	sub    $0x10,%rsp
  801bca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd9:	00 
  801bda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801beb:	48 89 c2             	mov    %rax,%rdx
  801bee:	be 01 00 00 00       	mov    $0x1,%esi
  801bf3:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bf8:	48 b8 c3 17 80 00 00 	movabs $0x8017c3,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
}
  801c04:	c9                   	leaveq 
  801c05:	c3                   	retq   

0000000000801c06 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	48 83 ec 30          	sub    $0x30,%rsp
  801c0e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c16:	48 8b 00             	mov    (%rax),%rax
  801c19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c21:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c25:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c2b:	83 e0 02             	and    $0x2,%eax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	75 4d                	jne    801c7f <pgfault+0x79>
  801c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c36:	48 c1 e8 0c          	shr    $0xc,%rax
  801c3a:	48 89 c2             	mov    %rax,%rdx
  801c3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c44:	01 00 00 
  801c47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c4b:	25 00 08 00 00       	and    $0x800,%eax
  801c50:	48 85 c0             	test   %rax,%rax
  801c53:	74 2a                	je     801c7f <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801c55:	48 ba 38 44 80 00 00 	movabs $0x804438,%rdx
  801c5c:	00 00 00 
  801c5f:	be 1e 00 00 00       	mov    $0x1e,%esi
  801c64:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801c6b:	00 00 00 
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c73:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801c7a:	00 00 00 
  801c7d:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801c7f:	ba 07 00 00 00       	mov    $0x7,%edx
  801c84:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c89:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8e:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	0f 85 cd 00 00 00    	jne    801d6f <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cae:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801cb4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cbc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cc1:	48 89 c6             	mov    %rax,%rsi
  801cc4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801cc9:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  801cd0:	00 00 00 
  801cd3:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cd9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cdf:	48 89 c1             	mov    %rax,%rcx
  801ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cec:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf1:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	79 2a                	jns    801d2b <pgfault+0x125>
				panic("Page map at temp address failed");
  801d01:	48 ba 68 44 80 00 00 	movabs $0x804468,%rdx
  801d08:	00 00 00 
  801d0b:	be 2f 00 00 00       	mov    $0x2f,%esi
  801d10:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801d17:	00 00 00 
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801d26:	00 00 00 
  801d29:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d2b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d30:	bf 00 00 00 00       	mov    $0x0,%edi
  801d35:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
  801d41:	85 c0                	test   %eax,%eax
  801d43:	79 54                	jns    801d99 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d45:	48 ba 88 44 80 00 00 	movabs $0x804488,%rdx
  801d4c:	00 00 00 
  801d4f:	be 31 00 00 00       	mov    $0x31,%esi
  801d54:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801d5b:	00 00 00 
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d63:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801d6a:	00 00 00 
  801d6d:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801d6f:	48 ba b0 44 80 00 00 	movabs $0x8044b0,%rdx
  801d76:	00 00 00 
  801d79:	be 35 00 00 00       	mov    $0x35,%esi
  801d7e:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801d85:	00 00 00 
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801d94:	00 00 00 
  801d97:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801d99:	c9                   	leaveq 
  801d9a:	c3                   	retq   

0000000000801d9b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d9b:	55                   	push   %rbp
  801d9c:	48 89 e5             	mov    %rsp,%rbp
  801d9f:	48 83 ec 20          	sub    $0x20,%rsp
  801da3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801da6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801da9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801db0:	01 00 00 
  801db3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801db6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dba:	25 07 0e 00 00       	and    $0xe07,%eax
  801dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801dc2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801dc5:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd0:	25 00 04 00 00       	and    $0x400,%eax
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	74 57                	je     801e30 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801dd9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ddc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801de0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de7:	41 89 f0             	mov    %esi,%r8d
  801dea:	48 89 c6             	mov    %rax,%rsi
  801ded:	bf 00 00 00 00       	mov    $0x0,%edi
  801df2:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	callq  *%rax
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	0f 8e 52 01 00 00    	jle    801f58 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801e06:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801e0d:	00 00 00 
  801e10:	be 52 00 00 00       	mov    $0x52,%esi
  801e15:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801e1c:	00 00 00 
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801e2b:	00 00 00 
  801e2e:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e33:	83 e0 02             	and    $0x2,%eax
  801e36:	85 c0                	test   %eax,%eax
  801e38:	75 10                	jne    801e4a <duppage+0xaf>
  801e3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3d:	25 00 08 00 00       	and    $0x800,%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	0f 84 bb 00 00 00    	je     801f05 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4d:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e52:	80 cc 08             	or     $0x8,%ah
  801e55:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e5b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e66:	41 89 f0             	mov    %esi,%r8d
  801e69:	48 89 c6             	mov    %rax,%rsi
  801e6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e71:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	7e 2a                	jle    801eab <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801e81:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801e88:	00 00 00 
  801e8b:	be 5a 00 00 00       	mov    $0x5a,%esi
  801e90:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801e97:	00 00 00 
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9f:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801ea6:	00 00 00 
  801ea9:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801eab:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801eae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb6:	41 89 c8             	mov    %ecx,%r8d
  801eb9:	48 89 d1             	mov    %rdx,%rcx
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec1:	48 89 c6             	mov    %rax,%rsi
  801ec4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec9:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	7e 2a                	jle    801f03 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801ed9:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801ee0:	00 00 00 
  801ee3:	be 5d 00 00 00       	mov    $0x5d,%esi
  801ee8:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801eef:	00 00 00 
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801efe:	00 00 00 
  801f01:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f03:	eb 53                	jmp    801f58 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f05:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f08:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f0c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f13:	41 89 f0             	mov    %esi,%r8d
  801f16:	48 89 c6             	mov    %rax,%rsi
  801f19:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1e:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	7e 2a                	jle    801f58 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801f2e:	48 ba dd 44 80 00 00 	movabs $0x8044dd,%rdx
  801f35:	00 00 00 
  801f38:	be 61 00 00 00       	mov    $0x61,%esi
  801f3d:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801f44:	00 00 00 
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  801f53:	00 00 00 
  801f56:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5d:	c9                   	leaveq 
  801f5e:	c3                   	retq   

0000000000801f5f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f5f:	55                   	push   %rbp
  801f60:	48 89 e5             	mov    %rsp,%rbp
  801f63:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801f67:	48 bf 06 1c 80 00 00 	movabs $0x801c06,%rdi
  801f6e:	00 00 00 
  801f71:	48 b8 d5 3a 80 00 00 	movabs $0x803ad5,%rax
  801f78:	00 00 00 
  801f7b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f7d:	b8 07 00 00 00       	mov    $0x7,%eax
  801f82:	cd 30                	int    $0x30
  801f84:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f87:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f8a:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f91:	79 30                	jns    801fc3 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f93:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f96:	89 c1                	mov    %eax,%ecx
  801f98:	48 ba fb 44 80 00 00 	movabs $0x8044fb,%rdx
  801f9f:	00 00 00 
  801fa2:	be 89 00 00 00       	mov    $0x89,%esi
  801fa7:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  801fae:	00 00 00 
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  801fbd:	00 00 00 
  801fc0:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fc7:	75 46                	jne    80200f <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801fc9:	48 b8 1d 19 80 00 00 	movabs $0x80191d,%rax
  801fd0:	00 00 00 
  801fd3:	ff d0                	callq  *%rax
  801fd5:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fda:	48 63 d0             	movslq %eax,%rdx
  801fdd:	48 89 d0             	mov    %rdx,%rax
  801fe0:	48 c1 e0 03          	shl    $0x3,%rax
  801fe4:	48 01 d0             	add    %rdx,%rax
  801fe7:	48 c1 e0 05          	shl    $0x5,%rax
  801feb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ff2:	00 00 00 
  801ff5:	48 01 c2             	add    %rax,%rdx
  801ff8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fff:	00 00 00 
  802002:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	e9 d1 01 00 00       	jmpq   8021e0 <fork+0x281>
	}

	uint64_t ad = 0;
  80200f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802016:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802017:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80201c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802020:	e9 df 00 00 00       	jmpq   802104 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802029:	48 c1 e8 27          	shr    $0x27,%rax
  80202d:	48 89 c2             	mov    %rax,%rdx
  802030:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802037:	01 00 00 
  80203a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203e:	83 e0 01             	and    $0x1,%eax
  802041:	48 85 c0             	test   %rax,%rax
  802044:	0f 84 9e 00 00 00    	je     8020e8 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80204a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802052:	48 89 c2             	mov    %rax,%rdx
  802055:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80205c:	01 00 00 
  80205f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802063:	83 e0 01             	and    $0x1,%eax
  802066:	48 85 c0             	test   %rax,%rax
  802069:	74 73                	je     8020de <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80206b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206f:	48 c1 e8 15          	shr    $0x15,%rax
  802073:	48 89 c2             	mov    %rax,%rdx
  802076:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80207d:	01 00 00 
  802080:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802084:	83 e0 01             	and    $0x1,%eax
  802087:	48 85 c0             	test   %rax,%rax
  80208a:	74 48                	je     8020d4 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80208c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802090:	48 c1 e8 0c          	shr    $0xc,%rax
  802094:	48 89 c2             	mov    %rax,%rdx
  802097:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80209e:	01 00 00 
  8020a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ad:	83 e0 01             	and    $0x1,%eax
  8020b0:	48 85 c0             	test   %rax,%rax
  8020b3:	74 47                	je     8020fc <fork+0x19d>
						duppage(envid, VPN(addr));
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8020bd:	89 c2                	mov    %eax,%edx
  8020bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c2:	89 d6                	mov    %edx,%esi
  8020c4:	89 c7                	mov    %eax,%edi
  8020c6:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax
  8020d2:	eb 28                	jmp    8020fc <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  8020d4:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8020db:	00 
  8020dc:	eb 1e                	jmp    8020fc <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020de:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020e5:	40 
  8020e6:	eb 14                	jmp    8020fc <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  8020e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ec:	48 c1 e8 27          	shr    $0x27,%rax
  8020f0:	48 83 c0 01          	add    $0x1,%rax
  8020f4:	48 c1 e0 27          	shl    $0x27,%rax
  8020f8:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8020fc:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802103:	00 
  802104:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80210b:	00 
  80210c:	0f 87 13 ff ff ff    	ja     802025 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802112:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802115:	ba 07 00 00 00       	mov    $0x7,%edx
  80211a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80211f:	89 c7                	mov    %eax,%edi
  802121:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  802128:	00 00 00 
  80212b:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80212d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802130:	ba 07 00 00 00       	mov    $0x7,%edx
  802135:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80213a:	89 c7                	mov    %eax,%edi
  80213c:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  802143:	00 00 00 
  802146:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802148:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80214b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802151:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802156:	ba 00 00 00 00       	mov    $0x0,%edx
  80215b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802160:	89 c7                	mov    %eax,%edi
  802162:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  802169:	00 00 00 
  80216c:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80216e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802173:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802178:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80217d:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802189:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80218e:	bf 00 00 00 00       	mov    $0x0,%edi
  802193:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  80219f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021a6:	00 00 00 
  8021a9:	48 8b 00             	mov    (%rax),%rax
  8021ac:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8021b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021b6:	48 89 d6             	mov    %rdx,%rsi
  8021b9:	89 c7                	mov    %eax,%edi
  8021bb:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8021c2:	00 00 00 
  8021c5:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  8021c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021ca:	be 02 00 00 00       	mov    $0x2,%esi
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax

	return envid;
  8021dd:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8021e0:	c9                   	leaveq 
  8021e1:	c3                   	retq   

00000000008021e2 <sfork>:

// Challenge!
int
sfork(void)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021e6:	48 ba 13 45 80 00 00 	movabs $0x804513,%rdx
  8021ed:	00 00 00 
  8021f0:	be b8 00 00 00       	mov    $0xb8,%esi
  8021f5:	48 bf 5d 44 80 00 00 	movabs $0x80445d,%rdi
  8021fc:	00 00 00 
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802204:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  80220b:	00 00 00 
  80220e:	ff d1                	callq  *%rcx

0000000000802210 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 08          	sub    $0x8,%rsp
  802218:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80221c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802220:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802227:	ff ff ff 
  80222a:	48 01 d0             	add    %rdx,%rax
  80222d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802231:	c9                   	leaveq 
  802232:	c3                   	retq   

0000000000802233 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802233:	55                   	push   %rbp
  802234:	48 89 e5             	mov    %rsp,%rbp
  802237:	48 83 ec 08          	sub    $0x8,%rsp
  80223b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80223f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802243:	48 89 c7             	mov    %rax,%rdi
  802246:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax
  802252:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802258:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	48 83 ec 18          	sub    $0x18,%rsp
  802266:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80226a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802271:	eb 6b                	jmp    8022de <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802273:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802276:	48 98                	cltq   
  802278:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80227e:	48 c1 e0 0c          	shl    $0xc,%rax
  802282:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228a:	48 c1 e8 15          	shr    $0x15,%rax
  80228e:	48 89 c2             	mov    %rax,%rdx
  802291:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802298:	01 00 00 
  80229b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229f:	83 e0 01             	and    $0x1,%eax
  8022a2:	48 85 c0             	test   %rax,%rax
  8022a5:	74 21                	je     8022c8 <fd_alloc+0x6a>
  8022a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8022af:	48 89 c2             	mov    %rax,%rdx
  8022b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022b9:	01 00 00 
  8022bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c0:	83 e0 01             	and    $0x1,%eax
  8022c3:	48 85 c0             	test   %rax,%rax
  8022c6:	75 12                	jne    8022da <fd_alloc+0x7c>
			*fd_store = fd;
  8022c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	eb 1a                	jmp    8022f4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022de:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022e2:	7e 8f                	jle    802273 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022ef:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022f4:	c9                   	leaveq 
  8022f5:	c3                   	retq   

00000000008022f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022f6:	55                   	push   %rbp
  8022f7:	48 89 e5             	mov    %rsp,%rbp
  8022fa:	48 83 ec 20          	sub    $0x20,%rsp
  8022fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802301:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802305:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802309:	78 06                	js     802311 <fd_lookup+0x1b>
  80230b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80230f:	7e 07                	jle    802318 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802311:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802316:	eb 6c                	jmp    802384 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802318:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231b:	48 98                	cltq   
  80231d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802323:	48 c1 e0 0c          	shl    $0xc,%rax
  802327:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80232b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232f:	48 c1 e8 15          	shr    $0x15,%rax
  802333:	48 89 c2             	mov    %rax,%rdx
  802336:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80233d:	01 00 00 
  802340:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802344:	83 e0 01             	and    $0x1,%eax
  802347:	48 85 c0             	test   %rax,%rax
  80234a:	74 21                	je     80236d <fd_lookup+0x77>
  80234c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802350:	48 c1 e8 0c          	shr    $0xc,%rax
  802354:	48 89 c2             	mov    %rax,%rdx
  802357:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80235e:	01 00 00 
  802361:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802365:	83 e0 01             	and    $0x1,%eax
  802368:	48 85 c0             	test   %rax,%rax
  80236b:	75 07                	jne    802374 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80236d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802372:	eb 10                	jmp    802384 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802378:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80237c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802384:	c9                   	leaveq 
  802385:	c3                   	retq   

0000000000802386 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802386:	55                   	push   %rbp
  802387:	48 89 e5             	mov    %rsp,%rbp
  80238a:	48 83 ec 30          	sub    $0x30,%rsp
  80238e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802392:	89 f0                	mov    %esi,%eax
  802394:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802397:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80239b:	48 89 c7             	mov    %rax,%rdi
  80239e:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8023a5:	00 00 00 
  8023a8:	ff d0                	callq  *%rax
  8023aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ae:	48 89 d6             	mov    %rdx,%rsi
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
  8023bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c6:	78 0a                	js     8023d2 <fd_close+0x4c>
	    || fd != fd2)
  8023c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023cc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023d0:	74 12                	je     8023e4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023d2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023d6:	74 05                	je     8023dd <fd_close+0x57>
  8023d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023db:	eb 05                	jmp    8023e2 <fd_close+0x5c>
  8023dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e2:	eb 69                	jmp    80244d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e8:	8b 00                	mov    (%rax),%eax
  8023ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023ee:	48 89 d6             	mov    %rdx,%rsi
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax
  8023ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802406:	78 2a                	js     802432 <fd_close+0xac>
		if (dev->dev_close)
  802408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802410:	48 85 c0             	test   %rax,%rax
  802413:	74 16                	je     80242b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802419:	48 8b 40 20          	mov    0x20(%rax),%rax
  80241d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802421:	48 89 d7             	mov    %rdx,%rdi
  802424:	ff d0                	callq  *%rax
  802426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802429:	eb 07                	jmp    802432 <fd_close+0xac>
		else
			r = 0;
  80242b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802436:	48 89 c6             	mov    %rax,%rsi
  802439:	bf 00 00 00 00       	mov    $0x0,%edi
  80243e:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  802445:	00 00 00 
  802448:	ff d0                	callq  *%rax
	return r;
  80244a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80244d:	c9                   	leaveq 
  80244e:	c3                   	retq   

000000000080244f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80244f:	55                   	push   %rbp
  802450:	48 89 e5             	mov    %rsp,%rbp
  802453:	48 83 ec 20          	sub    $0x20,%rsp
  802457:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80245a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80245e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802465:	eb 41                	jmp    8024a8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802467:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80246e:	00 00 00 
  802471:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802474:	48 63 d2             	movslq %edx,%rdx
  802477:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247b:	8b 00                	mov    (%rax),%eax
  80247d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802480:	75 22                	jne    8024a4 <dev_lookup+0x55>
			*dev = devtab[i];
  802482:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802489:	00 00 00 
  80248c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80248f:	48 63 d2             	movslq %edx,%rdx
  802492:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802496:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80249a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	eb 60                	jmp    802504 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024a4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024a8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024af:	00 00 00 
  8024b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b5:	48 63 d2             	movslq %edx,%rdx
  8024b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bc:	48 85 c0             	test   %rax,%rax
  8024bf:	75 a6                	jne    802467 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024c1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024c8:	00 00 00 
  8024cb:	48 8b 00             	mov    (%rax),%rax
  8024ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024d4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024d7:	89 c6                	mov    %eax,%esi
  8024d9:	48 bf 30 45 80 00 00 	movabs $0x804530,%rdi
  8024e0:	00 00 00 
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e8:	48 b9 a2 04 80 00 00 	movabs $0x8004a2,%rcx
  8024ef:	00 00 00 
  8024f2:	ff d1                	callq  *%rcx
	*dev = 0;
  8024f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024f8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802504:	c9                   	leaveq 
  802505:	c3                   	retq   

0000000000802506 <close>:

int
close(int fdnum)
{
  802506:	55                   	push   %rbp
  802507:	48 89 e5             	mov    %rsp,%rbp
  80250a:	48 83 ec 20          	sub    $0x20,%rsp
  80250e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802511:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802515:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802518:	48 89 d6             	mov    %rdx,%rsi
  80251b:	89 c7                	mov    %eax,%edi
  80251d:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
  802529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802530:	79 05                	jns    802537 <close+0x31>
		return r;
  802532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802535:	eb 18                	jmp    80254f <close+0x49>
	else
		return fd_close(fd, 1);
  802537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253b:	be 01 00 00 00       	mov    $0x1,%esi
  802540:	48 89 c7             	mov    %rax,%rdi
  802543:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  80254a:	00 00 00 
  80254d:	ff d0                	callq  *%rax
}
  80254f:	c9                   	leaveq 
  802550:	c3                   	retq   

0000000000802551 <close_all>:

void
close_all(void)
{
  802551:	55                   	push   %rbp
  802552:	48 89 e5             	mov    %rsp,%rbp
  802555:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802559:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802560:	eb 15                	jmp    802577 <close_all+0x26>
		close(i);
  802562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802565:	89 c7                	mov    %eax,%edi
  802567:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  80256e:	00 00 00 
  802571:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802573:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802577:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80257b:	7e e5                	jle    802562 <close_all+0x11>
		close(i);
}
  80257d:	c9                   	leaveq 
  80257e:	c3                   	retq   

000000000080257f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80257f:	55                   	push   %rbp
  802580:	48 89 e5             	mov    %rsp,%rbp
  802583:	48 83 ec 40          	sub    $0x40,%rsp
  802587:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80258a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80258d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802591:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802594:	48 89 d6             	mov    %rdx,%rsi
  802597:	89 c7                	mov    %eax,%edi
  802599:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8025a0:	00 00 00 
  8025a3:	ff d0                	callq  *%rax
  8025a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ac:	79 08                	jns    8025b6 <dup+0x37>
		return r;
  8025ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b1:	e9 70 01 00 00       	jmpq   802726 <dup+0x1a7>
	close(newfdnum);
  8025b6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025b9:	89 c7                	mov    %eax,%edi
  8025bb:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  8025c2:	00 00 00 
  8025c5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025c7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025ca:	48 98                	cltq   
  8025cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8025d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025de:	48 89 c7             	mov    %rax,%rdi
  8025e1:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  8025e8:	00 00 00 
  8025eb:	ff d0                	callq  *%rax
  8025ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f5:	48 89 c7             	mov    %rax,%rdi
  8025f8:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  8025ff:	00 00 00 
  802602:	ff d0                	callq  *%rax
  802604:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	48 c1 e8 15          	shr    $0x15,%rax
  802610:	48 89 c2             	mov    %rax,%rdx
  802613:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80261a:	01 00 00 
  80261d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802621:	83 e0 01             	and    $0x1,%eax
  802624:	48 85 c0             	test   %rax,%rax
  802627:	74 73                	je     80269c <dup+0x11d>
  802629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262d:	48 c1 e8 0c          	shr    $0xc,%rax
  802631:	48 89 c2             	mov    %rax,%rdx
  802634:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80263b:	01 00 00 
  80263e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802642:	83 e0 01             	and    $0x1,%eax
  802645:	48 85 c0             	test   %rax,%rax
  802648:	74 52                	je     80269c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80264a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264e:	48 c1 e8 0c          	shr    $0xc,%rax
  802652:	48 89 c2             	mov    %rax,%rdx
  802655:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265c:	01 00 00 
  80265f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802663:	25 07 0e 00 00       	and    $0xe07,%eax
  802668:	89 c1                	mov    %eax,%ecx
  80266a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80266e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802672:	41 89 c8             	mov    %ecx,%r8d
  802675:	48 89 d1             	mov    %rdx,%rcx
  802678:	ba 00 00 00 00       	mov    $0x0,%edx
  80267d:	48 89 c6             	mov    %rax,%rsi
  802680:	bf 00 00 00 00       	mov    $0x0,%edi
  802685:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	79 02                	jns    80269c <dup+0x11d>
			goto err;
  80269a:	eb 57                	jmp    8026f3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80269c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8026a4:	48 89 c2             	mov    %rax,%rdx
  8026a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ae:	01 00 00 
  8026b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026b5:	25 07 0e 00 00       	and    $0xe07,%eax
  8026ba:	89 c1                	mov    %eax,%ecx
  8026bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c4:	41 89 c8             	mov    %ecx,%r8d
  8026c7:	48 89 d1             	mov    %rdx,%rcx
  8026ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cf:	48 89 c6             	mov    %rax,%rsi
  8026d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d7:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ea:	79 02                	jns    8026ee <dup+0x16f>
		goto err;
  8026ec:	eb 05                	jmp    8026f3 <dup+0x174>

	return newfdnum;
  8026ee:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026f1:	eb 33                	jmp    802726 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f7:	48 89 c6             	mov    %rax,%rsi
  8026fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ff:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80270b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80270f:	48 89 c6             	mov    %rax,%rsi
  802712:	bf 00 00 00 00       	mov    $0x0,%edi
  802717:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  80271e:	00 00 00 
  802721:	ff d0                	callq  *%rax
	return r;
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802726:	c9                   	leaveq 
  802727:	c3                   	retq   

0000000000802728 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802728:	55                   	push   %rbp
  802729:	48 89 e5             	mov    %rsp,%rbp
  80272c:	48 83 ec 40          	sub    $0x40,%rsp
  802730:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802733:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802737:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80273b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80273f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802742:	48 89 d6             	mov    %rdx,%rsi
  802745:	89 c7                	mov    %eax,%edi
  802747:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax
  802753:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802756:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275a:	78 24                	js     802780 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802760:	8b 00                	mov    (%rax),%eax
  802762:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	89 c7                	mov    %eax,%edi
  80276b:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277e:	79 05                	jns    802785 <read+0x5d>
		return r;
  802780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802783:	eb 76                	jmp    8027fb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802789:	8b 40 08             	mov    0x8(%rax),%eax
  80278c:	83 e0 03             	and    $0x3,%eax
  80278f:	83 f8 01             	cmp    $0x1,%eax
  802792:	75 3a                	jne    8027ce <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802794:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80279b:	00 00 00 
  80279e:	48 8b 00             	mov    (%rax),%rax
  8027a1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027aa:	89 c6                	mov    %eax,%esi
  8027ac:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  8027b3:	00 00 00 
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	48 b9 a2 04 80 00 00 	movabs $0x8004a2,%rcx
  8027c2:	00 00 00 
  8027c5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027cc:	eb 2d                	jmp    8027fb <read+0xd3>
	}
	if (!dev->dev_read)
  8027ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027d6:	48 85 c0             	test   %rax,%rax
  8027d9:	75 07                	jne    8027e2 <read+0xba>
		return -E_NOT_SUPP;
  8027db:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027e0:	eb 19                	jmp    8027fb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027ea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027f6:	48 89 cf             	mov    %rcx,%rdi
  8027f9:	ff d0                	callq  *%rax
}
  8027fb:	c9                   	leaveq 
  8027fc:	c3                   	retq   

00000000008027fd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027fd:	55                   	push   %rbp
  8027fe:	48 89 e5             	mov    %rsp,%rbp
  802801:	48 83 ec 30          	sub    $0x30,%rsp
  802805:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802808:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80280c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802810:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802817:	eb 49                	jmp    802862 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281c:	48 98                	cltq   
  80281e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802822:	48 29 c2             	sub    %rax,%rdx
  802825:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802828:	48 63 c8             	movslq %eax,%rcx
  80282b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80282f:	48 01 c1             	add    %rax,%rcx
  802832:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802835:	48 89 ce             	mov    %rcx,%rsi
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 28 27 80 00 00 	movabs $0x802728,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
  802846:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802849:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80284d:	79 05                	jns    802854 <readn+0x57>
			return m;
  80284f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802852:	eb 1c                	jmp    802870 <readn+0x73>
		if (m == 0)
  802854:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802858:	75 02                	jne    80285c <readn+0x5f>
			break;
  80285a:	eb 11                	jmp    80286d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80285c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80285f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802862:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802865:	48 98                	cltq   
  802867:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80286b:	72 ac                	jb     802819 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802870:	c9                   	leaveq 
  802871:	c3                   	retq   

0000000000802872 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802872:	55                   	push   %rbp
  802873:	48 89 e5             	mov    %rsp,%rbp
  802876:	48 83 ec 40          	sub    $0x40,%rsp
  80287a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80287d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802881:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802885:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802889:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80288c:	48 89 d6             	mov    %rdx,%rsi
  80288f:	89 c7                	mov    %eax,%edi
  802891:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
  80289d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a4:	78 24                	js     8028ca <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028aa:	8b 00                	mov    (%rax),%eax
  8028ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b0:	48 89 d6             	mov    %rdx,%rsi
  8028b3:	89 c7                	mov    %eax,%edi
  8028b5:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c8:	79 05                	jns    8028cf <write+0x5d>
		return r;
  8028ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cd:	eb 75                	jmp    802944 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d3:	8b 40 08             	mov    0x8(%rax),%eax
  8028d6:	83 e0 03             	and    $0x3,%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	75 3a                	jne    802917 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8028dd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028e4:	00 00 00 
  8028e7:	48 8b 00             	mov    (%rax),%rax
  8028ea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028f0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028f3:	89 c6                	mov    %eax,%esi
  8028f5:	48 bf 6b 45 80 00 00 	movabs $0x80456b,%rdi
  8028fc:	00 00 00 
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	48 b9 a2 04 80 00 00 	movabs $0x8004a2,%rcx
  80290b:	00 00 00 
  80290e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802910:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802915:	eb 2d                	jmp    802944 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802917:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80291f:	48 85 c0             	test   %rax,%rax
  802922:	75 07                	jne    80292b <write+0xb9>
		return -E_NOT_SUPP;
  802924:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802929:	eb 19                	jmp    802944 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80292b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802933:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802937:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80293b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80293f:	48 89 cf             	mov    %rcx,%rdi
  802942:	ff d0                	callq  *%rax
}
  802944:	c9                   	leaveq 
  802945:	c3                   	retq   

0000000000802946 <seek>:

int
seek(int fdnum, off_t offset)
{
  802946:	55                   	push   %rbp
  802947:	48 89 e5             	mov    %rsp,%rbp
  80294a:	48 83 ec 18          	sub    $0x18,%rsp
  80294e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802951:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802954:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802958:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80295b:	48 89 d6             	mov    %rdx,%rsi
  80295e:	89 c7                	mov    %eax,%edi
  802960:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  802967:	00 00 00 
  80296a:	ff d0                	callq  *%rax
  80296c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802973:	79 05                	jns    80297a <seek+0x34>
		return r;
  802975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802978:	eb 0f                	jmp    802989 <seek+0x43>
	fd->fd_offset = offset;
  80297a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802981:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802989:	c9                   	leaveq 
  80298a:	c3                   	retq   

000000000080298b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80298b:	55                   	push   %rbp
  80298c:	48 89 e5             	mov    %rsp,%rbp
  80298f:	48 83 ec 30          	sub    $0x30,%rsp
  802993:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802996:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802999:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029a0:	48 89 d6             	mov    %rdx,%rsi
  8029a3:	89 c7                	mov    %eax,%edi
  8029a5:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
  8029b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b8:	78 24                	js     8029de <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029be:	8b 00                	mov    (%rax),%eax
  8029c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c4:	48 89 d6             	mov    %rdx,%rsi
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
  8029d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dc:	79 05                	jns    8029e3 <ftruncate+0x58>
		return r;
  8029de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e1:	eb 72                	jmp    802a55 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e7:	8b 40 08             	mov    0x8(%rax),%eax
  8029ea:	83 e0 03             	and    $0x3,%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	75 3a                	jne    802a2b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029f1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029f8:	00 00 00 
  8029fb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029fe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a04:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a07:	89 c6                	mov    %eax,%esi
  802a09:	48 bf 88 45 80 00 00 	movabs $0x804588,%rdi
  802a10:	00 00 00 
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	48 b9 a2 04 80 00 00 	movabs $0x8004a2,%rcx
  802a1f:	00 00 00 
  802a22:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a29:	eb 2a                	jmp    802a55 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a33:	48 85 c0             	test   %rax,%rax
  802a36:	75 07                	jne    802a3f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a3d:	eb 16                	jmp    802a55 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a43:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a4b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a4e:	89 ce                	mov    %ecx,%esi
  802a50:	48 89 d7             	mov    %rdx,%rdi
  802a53:	ff d0                	callq  *%rax
}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 30          	sub    $0x30,%rsp
  802a5f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a62:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a66:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a6d:	48 89 d6             	mov    %rdx,%rsi
  802a70:	89 c7                	mov    %eax,%edi
  802a72:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  802a79:	00 00 00 
  802a7c:	ff d0                	callq  *%rax
  802a7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a85:	78 24                	js     802aab <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8b:	8b 00                	mov    (%rax),%eax
  802a8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a91:	48 89 d6             	mov    %rdx,%rsi
  802a94:	89 c7                	mov    %eax,%edi
  802a96:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  802a9d:	00 00 00 
  802aa0:	ff d0                	callq  *%rax
  802aa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa9:	79 05                	jns    802ab0 <fstat+0x59>
		return r;
  802aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aae:	eb 5e                	jmp    802b0e <fstat+0xb7>
	if (!dev->dev_stat)
  802ab0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ab8:	48 85 c0             	test   %rax,%rax
  802abb:	75 07                	jne    802ac4 <fstat+0x6d>
		return -E_NOT_SUPP;
  802abd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ac2:	eb 4a                	jmp    802b0e <fstat+0xb7>
	stat->st_name[0] = 0;
  802ac4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802acb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802acf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ad6:	00 00 00 
	stat->st_isdir = 0;
  802ad9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802add:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ae4:	00 00 00 
	stat->st_dev = dev;
  802ae7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aeb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aef:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802af6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afa:	48 8b 40 28          	mov    0x28(%rax),%rax
  802afe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b02:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b06:	48 89 ce             	mov    %rcx,%rsi
  802b09:	48 89 d7             	mov    %rdx,%rdi
  802b0c:	ff d0                	callq  *%rax
}
  802b0e:	c9                   	leaveq 
  802b0f:	c3                   	retq   

0000000000802b10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b10:	55                   	push   %rbp
  802b11:	48 89 e5             	mov    %rsp,%rbp
  802b14:	48 83 ec 20          	sub    $0x20,%rsp
  802b18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b24:	be 00 00 00 00       	mov    $0x0,%esi
  802b29:	48 89 c7             	mov    %rax,%rdi
  802b2c:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3f:	79 05                	jns    802b46 <stat+0x36>
		return fd;
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b44:	eb 2f                	jmp    802b75 <stat+0x65>
	r = fstat(fd, stat);
  802b46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4d:	48 89 d6             	mov    %rdx,%rsi
  802b50:	89 c7                	mov    %eax,%edi
  802b52:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
  802b5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b64:	89 c7                	mov    %eax,%edi
  802b66:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  802b6d:	00 00 00 
  802b70:	ff d0                	callq  *%rax
	return r;
  802b72:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b75:	c9                   	leaveq 
  802b76:	c3                   	retq   

0000000000802b77 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b77:	55                   	push   %rbp
  802b78:	48 89 e5             	mov    %rsp,%rbp
  802b7b:	48 83 ec 10          	sub    $0x10,%rsp
  802b7f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b86:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b8d:	00 00 00 
  802b90:	8b 00                	mov    (%rax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	75 1d                	jne    802bb3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b96:	bf 01 00 00 00       	mov    $0x1,%edi
  802b9b:	48 b8 78 3d 80 00 00 	movabs $0x803d78,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
  802ba7:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802bae:	00 00 00 
  802bb1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bb3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bba:	00 00 00 
  802bbd:	8b 00                	mov    (%rax),%eax
  802bbf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802bc2:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bc7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bce:	00 00 00 
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	48 b8 e0 3c 80 00 00 	movabs $0x803ce0,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802bdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be3:	ba 00 00 00 00       	mov    $0x0,%edx
  802be8:	48 89 c6             	mov    %rax,%rsi
  802beb:	bf 00 00 00 00       	mov    $0x0,%edi
  802bf0:	48 b8 1f 3c 80 00 00 	movabs $0x803c1f,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
}
  802bfc:	c9                   	leaveq 
  802bfd:	c3                   	retq   

0000000000802bfe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bfe:	55                   	push   %rbp
  802bff:	48 89 e5             	mov    %rsp,%rbp
  802c02:	48 83 ec 20          	sub    $0x20,%rsp
  802c06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c0a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802c0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c11:	48 89 c7             	mov    %rax,%rdi
  802c14:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
  802c20:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c25:	7e 0a                	jle    802c31 <open+0x33>
		return -E_BAD_PATH;
  802c27:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c2c:	e9 a5 00 00 00       	jmpq   802cd6 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c31:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c35:	48 89 c7             	mov    %rax,%rdi
  802c38:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
  802c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4b:	79 08                	jns    802c55 <open+0x57>
		return r;
  802c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c50:	e9 81 00 00 00       	jmpq   802cd6 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c59:	48 89 c6             	mov    %rax,%rsi
  802c5c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c63:	00 00 00 
  802c66:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802c72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c79:	00 00 00 
  802c7c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c7f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	48 89 c6             	mov    %rax,%rsi
  802c8c:	bf 01 00 00 00       	mov    $0x1,%edi
  802c91:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca4:	79 1d                	jns    802cc3 <open+0xc5>
		fd_close(fd, 0);
  802ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802caa:	be 00 00 00 00       	mov    $0x0,%esi
  802caf:	48 89 c7             	mov    %rax,%rdi
  802cb2:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
		return r;
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	eb 13                	jmp    802cd6 <open+0xd8>
	}

	return fd2num(fd);
  802cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc7:	48 89 c7             	mov    %rax,%rdi
  802cca:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802cd6:	c9                   	leaveq 
  802cd7:	c3                   	retq   

0000000000802cd8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cd8:	55                   	push   %rbp
  802cd9:	48 89 e5             	mov    %rsp,%rbp
  802cdc:	48 83 ec 10          	sub    $0x10,%rsp
  802ce0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ce4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce8:	8b 50 0c             	mov    0xc(%rax),%edx
  802ceb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cf2:	00 00 00 
  802cf5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cf7:	be 00 00 00 00       	mov    $0x0,%esi
  802cfc:	bf 06 00 00 00       	mov    $0x6,%edi
  802d01:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
}
  802d0d:	c9                   	leaveq 
  802d0e:	c3                   	retq   

0000000000802d0f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d0f:	55                   	push   %rbp
  802d10:	48 89 e5             	mov    %rsp,%rbp
  802d13:	48 83 ec 30          	sub    $0x30,%rsp
  802d17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d27:	8b 50 0c             	mov    0xc(%rax),%edx
  802d2a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d31:	00 00 00 
  802d34:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d36:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d3d:	00 00 00 
  802d40:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d44:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d48:	be 00 00 00 00       	mov    $0x0,%esi
  802d4d:	bf 03 00 00 00       	mov    $0x3,%edi
  802d52:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
  802d5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d65:	79 08                	jns    802d6f <devfile_read+0x60>
		return r;
  802d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6a:	e9 a4 00 00 00       	jmpq   802e13 <devfile_read+0x104>
	assert(r <= n);
  802d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d72:	48 98                	cltq   
  802d74:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d78:	76 35                	jbe    802daf <devfile_read+0xa0>
  802d7a:	48 b9 b5 45 80 00 00 	movabs $0x8045b5,%rcx
  802d81:	00 00 00 
  802d84:	48 ba bc 45 80 00 00 	movabs $0x8045bc,%rdx
  802d8b:	00 00 00 
  802d8e:	be 84 00 00 00       	mov    $0x84,%esi
  802d93:	48 bf d1 45 80 00 00 	movabs $0x8045d1,%rdi
  802d9a:	00 00 00 
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  802da9:	00 00 00 
  802dac:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802daf:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802db6:	7e 35                	jle    802ded <devfile_read+0xde>
  802db8:	48 b9 dc 45 80 00 00 	movabs $0x8045dc,%rcx
  802dbf:	00 00 00 
  802dc2:	48 ba bc 45 80 00 00 	movabs $0x8045bc,%rdx
  802dc9:	00 00 00 
  802dcc:	be 85 00 00 00       	mov    $0x85,%esi
  802dd1:	48 bf d1 45 80 00 00 	movabs $0x8045d1,%rdi
  802dd8:	00 00 00 
  802ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  802de0:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  802de7:	00 00 00 
  802dea:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df0:	48 63 d0             	movslq %eax,%rdx
  802df3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df7:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dfe:	00 00 00 
  802e01:	48 89 c7             	mov    %rax,%rdi
  802e04:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
	return r;
  802e10:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802e13:	c9                   	leaveq 
  802e14:	c3                   	retq   

0000000000802e15 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e15:	55                   	push   %rbp
  802e16:	48 89 e5             	mov    %rsp,%rbp
  802e19:	48 83 ec 30          	sub    $0x30,%rsp
  802e1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2d:	8b 50 0c             	mov    0xc(%rax),%edx
  802e30:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e37:	00 00 00 
  802e3a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e3c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e43:	00 00 00 
  802e46:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e4a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802e4e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e55:	00 
  802e56:	76 35                	jbe    802e8d <devfile_write+0x78>
  802e58:	48 b9 e8 45 80 00 00 	movabs $0x8045e8,%rcx
  802e5f:	00 00 00 
  802e62:	48 ba bc 45 80 00 00 	movabs $0x8045bc,%rdx
  802e69:	00 00 00 
  802e6c:	be 9e 00 00 00       	mov    $0x9e,%esi
  802e71:	48 bf d1 45 80 00 00 	movabs $0x8045d1,%rdi
  802e78:	00 00 00 
  802e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e80:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  802e87:	00 00 00 
  802e8a:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802e8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e95:	48 89 c6             	mov    %rax,%rsi
  802e98:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e9f:	00 00 00 
  802ea2:	48 b8 a5 14 80 00 00 	movabs $0x8014a5,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802eae:	be 00 00 00 00       	mov    $0x0,%esi
  802eb3:	bf 04 00 00 00       	mov    $0x4,%edi
  802eb8:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
  802ec4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecb:	79 05                	jns    802ed2 <devfile_write+0xbd>
		return r;
  802ecd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed0:	eb 43                	jmp    802f15 <devfile_write+0x100>
	assert(r <= n);
  802ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed5:	48 98                	cltq   
  802ed7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802edb:	76 35                	jbe    802f12 <devfile_write+0xfd>
  802edd:	48 b9 b5 45 80 00 00 	movabs $0x8045b5,%rcx
  802ee4:	00 00 00 
  802ee7:	48 ba bc 45 80 00 00 	movabs $0x8045bc,%rdx
  802eee:	00 00 00 
  802ef1:	be a2 00 00 00       	mov    $0xa2,%esi
  802ef6:	48 bf d1 45 80 00 00 	movabs $0x8045d1,%rdi
  802efd:	00 00 00 
  802f00:	b8 00 00 00 00       	mov    $0x0,%eax
  802f05:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  802f0c:	00 00 00 
  802f0f:	41 ff d0             	callq  *%r8
	return r;
  802f12:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802f15:	c9                   	leaveq 
  802f16:	c3                   	retq   

0000000000802f17 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f17:	55                   	push   %rbp
  802f18:	48 89 e5             	mov    %rsp,%rbp
  802f1b:	48 83 ec 20          	sub    $0x20,%rsp
  802f1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2b:	8b 50 0c             	mov    0xc(%rax),%edx
  802f2e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f35:	00 00 00 
  802f38:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f3a:	be 00 00 00 00       	mov    $0x0,%esi
  802f3f:	bf 05 00 00 00       	mov    $0x5,%edi
  802f44:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
  802f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f57:	79 05                	jns    802f5e <devfile_stat+0x47>
		return r;
  802f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5c:	eb 56                	jmp    802fb4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f62:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f69:	00 00 00 
  802f6c:	48 89 c7             	mov    %rax,%rdi
  802f6f:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  802f76:	00 00 00 
  802f79:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f7b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f82:	00 00 00 
  802f85:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f95:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f9c:	00 00 00 
  802f9f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb4:	c9                   	leaveq 
  802fb5:	c3                   	retq   

0000000000802fb6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fb6:	55                   	push   %rbp
  802fb7:	48 89 e5             	mov    %rsp,%rbp
  802fba:	48 83 ec 10          	sub    $0x10,%rsp
  802fbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fc2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc9:	8b 50 0c             	mov    0xc(%rax),%edx
  802fcc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fd3:	00 00 00 
  802fd6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802fd8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdf:	00 00 00 
  802fe2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fe5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fe8:	be 00 00 00 00       	mov    $0x0,%esi
  802fed:	bf 02 00 00 00       	mov    $0x2,%edi
  802ff2:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
}
  802ffe:	c9                   	leaveq 
  802fff:	c3                   	retq   

0000000000803000 <remove>:

// Delete a file
int
remove(const char *path)
{
  803000:	55                   	push   %rbp
  803001:	48 89 e5             	mov    %rsp,%rbp
  803004:	48 83 ec 10          	sub    $0x10,%rsp
  803008:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80300c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803010:	48 89 c7             	mov    %rax,%rdi
  803013:	48 b8 fe 0f 80 00 00 	movabs $0x800ffe,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803024:	7e 07                	jle    80302d <remove+0x2d>
		return -E_BAD_PATH;
  803026:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80302b:	eb 33                	jmp    803060 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80302d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803031:	48 89 c6             	mov    %rax,%rsi
  803034:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80303b:	00 00 00 
  80303e:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80304a:	be 00 00 00 00       	mov    $0x0,%esi
  80304f:	bf 07 00 00 00       	mov    $0x7,%edi
  803054:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803066:	be 00 00 00 00       	mov    $0x0,%esi
  80306b:	bf 08 00 00 00       	mov    $0x8,%edi
  803070:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
}
  80307c:	5d                   	pop    %rbp
  80307d:	c3                   	retq   

000000000080307e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80307e:	55                   	push   %rbp
  80307f:	48 89 e5             	mov    %rsp,%rbp
  803082:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803089:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803090:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803097:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80309e:	be 00 00 00 00       	mov    $0x0,%esi
  8030a3:	48 89 c7             	mov    %rax,%rdi
  8030a6:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
  8030b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b9:	79 28                	jns    8030e3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030be:	89 c6                	mov    %eax,%esi
  8030c0:	48 bf 15 46 80 00 00 	movabs $0x804615,%rdi
  8030c7:	00 00 00 
  8030ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cf:	48 ba a2 04 80 00 00 	movabs $0x8004a2,%rdx
  8030d6:	00 00 00 
  8030d9:	ff d2                	callq  *%rdx
		return fd_src;
  8030db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030de:	e9 74 01 00 00       	jmpq   803257 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8030e3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8030ea:	be 01 01 00 00       	mov    $0x101,%esi
  8030ef:	48 89 c7             	mov    %rax,%rdi
  8030f2:	48 b8 fe 2b 80 00 00 	movabs $0x802bfe,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
  8030fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803101:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803105:	79 39                	jns    803140 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803107:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80310a:	89 c6                	mov    %eax,%esi
  80310c:	48 bf 2b 46 80 00 00 	movabs $0x80462b,%rdi
  803113:	00 00 00 
  803116:	b8 00 00 00 00       	mov    $0x0,%eax
  80311b:	48 ba a2 04 80 00 00 	movabs $0x8004a2,%rdx
  803122:	00 00 00 
  803125:	ff d2                	callq  *%rdx
		close(fd_src);
  803127:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312a:	89 c7                	mov    %eax,%edi
  80312c:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
		return fd_dest;
  803138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313b:	e9 17 01 00 00       	jmpq   803257 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803140:	eb 74                	jmp    8031b6 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803145:	48 63 d0             	movslq %eax,%rdx
  803148:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80314f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803152:	48 89 ce             	mov    %rcx,%rsi
  803155:	89 c7                	mov    %eax,%edi
  803157:	48 b8 72 28 80 00 00 	movabs $0x802872,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
  803163:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803166:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80316a:	79 4a                	jns    8031b6 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80316c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80316f:	89 c6                	mov    %eax,%esi
  803171:	48 bf 45 46 80 00 00 	movabs $0x804645,%rdi
  803178:	00 00 00 
  80317b:	b8 00 00 00 00       	mov    $0x0,%eax
  803180:	48 ba a2 04 80 00 00 	movabs $0x8004a2,%rdx
  803187:	00 00 00 
  80318a:	ff d2                	callq  *%rdx
			close(fd_src);
  80318c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318f:	89 c7                	mov    %eax,%edi
  803191:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
			close(fd_dest);
  80319d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031a0:	89 c7                	mov    %eax,%edi
  8031a2:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
			return write_size;
  8031ae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031b1:	e9 a1 00 00 00       	jmpq   803257 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031b6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c0:	ba 00 02 00 00       	mov    $0x200,%edx
  8031c5:	48 89 ce             	mov    %rcx,%rsi
  8031c8:	89 c7                	mov    %eax,%edi
  8031ca:	48 b8 28 27 80 00 00 	movabs $0x802728,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
  8031d6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8031d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031dd:	0f 8f 5f ff ff ff    	jg     803142 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8031e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031e7:	79 47                	jns    803230 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8031e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031ec:	89 c6                	mov    %eax,%esi
  8031ee:	48 bf 58 46 80 00 00 	movabs $0x804658,%rdi
  8031f5:	00 00 00 
  8031f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fd:	48 ba a2 04 80 00 00 	movabs $0x8004a2,%rdx
  803204:	00 00 00 
  803207:	ff d2                	callq  *%rdx
		close(fd_src);
  803209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320c:	89 c7                	mov    %eax,%edi
  80320e:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
		close(fd_dest);
  80321a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80321d:	89 c7                	mov    %eax,%edi
  80321f:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
		return read_size;
  80322b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80322e:	eb 27                	jmp    803257 <copy+0x1d9>
	}
	close(fd_src);
  803230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
	close(fd_dest);
  803241:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803244:	89 c7                	mov    %eax,%edi
  803246:	48 b8 06 25 80 00 00 	movabs $0x802506,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
	return 0;
  803252:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803257:	c9                   	leaveq 
  803258:	c3                   	retq   

0000000000803259 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803259:	55                   	push   %rbp
  80325a:	48 89 e5             	mov    %rsp,%rbp
  80325d:	53                   	push   %rbx
  80325e:	48 83 ec 38          	sub    $0x38,%rsp
  803262:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803266:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80326a:	48 89 c7             	mov    %rax,%rdi
  80326d:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  803274:	00 00 00 
  803277:	ff d0                	callq  *%rax
  803279:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80327c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803280:	0f 88 bf 01 00 00    	js     803445 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803286:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80328a:	ba 07 04 00 00       	mov    $0x407,%edx
  80328f:	48 89 c6             	mov    %rax,%rsi
  803292:	bf 00 00 00 00       	mov    $0x0,%edi
  803297:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  80329e:	00 00 00 
  8032a1:	ff d0                	callq  *%rax
  8032a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032aa:	0f 88 95 01 00 00    	js     803445 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032b4:	48 89 c7             	mov    %rax,%rdi
  8032b7:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ca:	0f 88 5d 01 00 00    	js     80342d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d4:	ba 07 04 00 00       	mov    $0x407,%edx
  8032d9:	48 89 c6             	mov    %rax,%rsi
  8032dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e1:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032f4:	0f 88 33 01 00 00    	js     80342d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fe:	48 89 c7             	mov    %rax,%rdi
  803301:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
  80330d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803315:	ba 07 04 00 00       	mov    $0x407,%edx
  80331a:	48 89 c6             	mov    %rax,%rsi
  80331d:	bf 00 00 00 00       	mov    $0x0,%edi
  803322:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  803329:	00 00 00 
  80332c:	ff d0                	callq  *%rax
  80332e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803331:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803335:	79 05                	jns    80333c <pipe+0xe3>
		goto err2;
  803337:	e9 d9 00 00 00       	jmpq   803415 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80333c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803340:	48 89 c7             	mov    %rax,%rdi
  803343:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
  80334f:	48 89 c2             	mov    %rax,%rdx
  803352:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803356:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80335c:	48 89 d1             	mov    %rdx,%rcx
  80335f:	ba 00 00 00 00       	mov    $0x0,%edx
  803364:	48 89 c6             	mov    %rax,%rsi
  803367:	bf 00 00 00 00       	mov    $0x0,%edi
  80336c:	48 b8 e9 19 80 00 00 	movabs $0x8019e9,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80337b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80337f:	79 1b                	jns    80339c <pipe+0x143>
		goto err3;
  803381:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803386:	48 89 c6             	mov    %rax,%rsi
  803389:	bf 00 00 00 00       	mov    $0x0,%edi
  80338e:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803395:	00 00 00 
  803398:	ff d0                	callq  *%rax
  80339a:	eb 79                	jmp    803415 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80339c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a0:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033a7:	00 00 00 
  8033aa:	8b 12                	mov    (%rdx),%edx
  8033ac:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bd:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8033c4:	00 00 00 
  8033c7:	8b 12                	mov    (%rdx),%edx
  8033c9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033cf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033da:	48 89 c7             	mov    %rax,%rdi
  8033dd:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
  8033e9:	89 c2                	mov    %eax,%edx
  8033eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033ef:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033f1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033f5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fd:	48 89 c7             	mov    %rax,%rdi
  803400:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
  80340c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80340e:	b8 00 00 00 00       	mov    $0x0,%eax
  803413:	eb 33                	jmp    803448 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803415:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803419:	48 89 c6             	mov    %rax,%rsi
  80341c:	bf 00 00 00 00       	mov    $0x0,%edi
  803421:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803428:	00 00 00 
  80342b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80342d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803431:	48 89 c6             	mov    %rax,%rsi
  803434:	bf 00 00 00 00       	mov    $0x0,%edi
  803439:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
err:
	return r;
  803445:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803448:	48 83 c4 38          	add    $0x38,%rsp
  80344c:	5b                   	pop    %rbx
  80344d:	5d                   	pop    %rbp
  80344e:	c3                   	retq   

000000000080344f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80344f:	55                   	push   %rbp
  803450:	48 89 e5             	mov    %rsp,%rbp
  803453:	53                   	push   %rbx
  803454:	48 83 ec 28          	sub    $0x28,%rsp
  803458:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80345c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803460:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803467:	00 00 00 
  80346a:	48 8b 00             	mov    (%rax),%rax
  80346d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803473:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80347a:	48 89 c7             	mov    %rax,%rdi
  80347d:	48 b8 fa 3d 80 00 00 	movabs $0x803dfa,%rax
  803484:	00 00 00 
  803487:	ff d0                	callq  *%rax
  803489:	89 c3                	mov    %eax,%ebx
  80348b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80348f:	48 89 c7             	mov    %rax,%rdi
  803492:	48 b8 fa 3d 80 00 00 	movabs $0x803dfa,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
  80349e:	39 c3                	cmp    %eax,%ebx
  8034a0:	0f 94 c0             	sete   %al
  8034a3:	0f b6 c0             	movzbl %al,%eax
  8034a6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034a9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034b0:	00 00 00 
  8034b3:	48 8b 00             	mov    (%rax),%rax
  8034b6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034bc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034c5:	75 05                	jne    8034cc <_pipeisclosed+0x7d>
			return ret;
  8034c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034ca:	eb 4f                	jmp    80351b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034cf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034d2:	74 42                	je     803516 <_pipeisclosed+0xc7>
  8034d4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034d8:	75 3c                	jne    803516 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034da:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034e1:	00 00 00 
  8034e4:	48 8b 00             	mov    (%rax),%rax
  8034e7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034ed:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034f3:	89 c6                	mov    %eax,%esi
  8034f5:	48 bf 73 46 80 00 00 	movabs $0x804673,%rdi
  8034fc:	00 00 00 
  8034ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803504:	49 b8 a2 04 80 00 00 	movabs $0x8004a2,%r8
  80350b:	00 00 00 
  80350e:	41 ff d0             	callq  *%r8
	}
  803511:	e9 4a ff ff ff       	jmpq   803460 <_pipeisclosed+0x11>
  803516:	e9 45 ff ff ff       	jmpq   803460 <_pipeisclosed+0x11>
}
  80351b:	48 83 c4 28          	add    $0x28,%rsp
  80351f:	5b                   	pop    %rbx
  803520:	5d                   	pop    %rbp
  803521:	c3                   	retq   

0000000000803522 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803522:	55                   	push   %rbp
  803523:	48 89 e5             	mov    %rsp,%rbp
  803526:	48 83 ec 30          	sub    $0x30,%rsp
  80352a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80352d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803531:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803534:	48 89 d6             	mov    %rdx,%rsi
  803537:	89 c7                	mov    %eax,%edi
  803539:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
  803545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354c:	79 05                	jns    803553 <pipeisclosed+0x31>
		return r;
  80354e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803551:	eb 31                	jmp    803584 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803557:	48 89 c7             	mov    %rax,%rdi
  80355a:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80356a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803572:	48 89 d6             	mov    %rdx,%rsi
  803575:	48 89 c7             	mov    %rax,%rdi
  803578:	48 b8 4f 34 80 00 00 	movabs $0x80344f,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
}
  803584:	c9                   	leaveq 
  803585:	c3                   	retq   

0000000000803586 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803586:	55                   	push   %rbp
  803587:	48 89 e5             	mov    %rsp,%rbp
  80358a:	48 83 ec 40          	sub    $0x40,%rsp
  80358e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803592:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803596:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80359a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80359e:	48 89 c7             	mov    %rax,%rdi
  8035a1:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
  8035ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035c0:	00 
  8035c1:	e9 92 00 00 00       	jmpq   803658 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035c6:	eb 41                	jmp    803609 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035c8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035cd:	74 09                	je     8035d8 <devpipe_read+0x52>
				return i;
  8035cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d3:	e9 92 00 00 00       	jmpq   80366a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e0:	48 89 d6             	mov    %rdx,%rsi
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 4f 34 80 00 00 	movabs $0x80344f,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 07                	je     8035fd <devpipe_read+0x77>
				return 0;
  8035f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fb:	eb 6d                	jmp    80366a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035fd:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360d:	8b 10                	mov    (%rax),%edx
  80360f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803613:	8b 40 04             	mov    0x4(%rax),%eax
  803616:	39 c2                	cmp    %eax,%edx
  803618:	74 ae                	je     8035c8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80361a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803622:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362a:	8b 00                	mov    (%rax),%eax
  80362c:	99                   	cltd   
  80362d:	c1 ea 1b             	shr    $0x1b,%edx
  803630:	01 d0                	add    %edx,%eax
  803632:	83 e0 1f             	and    $0x1f,%eax
  803635:	29 d0                	sub    %edx,%eax
  803637:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80363b:	48 98                	cltq   
  80363d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803642:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803648:	8b 00                	mov    (%rax),%eax
  80364a:	8d 50 01             	lea    0x1(%rax),%edx
  80364d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803651:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803653:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803660:	0f 82 60 ff ff ff    	jb     8035c6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80366a:	c9                   	leaveq 
  80366b:	c3                   	retq   

000000000080366c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80366c:	55                   	push   %rbp
  80366d:	48 89 e5             	mov    %rsp,%rbp
  803670:	48 83 ec 40          	sub    $0x40,%rsp
  803674:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803678:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80367c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803684:	48 89 c7             	mov    %rax,%rdi
  803687:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
  803693:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803697:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80369b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80369f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036a6:	00 
  8036a7:	e9 8e 00 00 00       	jmpq   80373a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036ac:	eb 31                	jmp    8036df <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b6:	48 89 d6             	mov    %rdx,%rsi
  8036b9:	48 89 c7             	mov    %rax,%rdi
  8036bc:	48 b8 4f 34 80 00 00 	movabs $0x80344f,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 07                	je     8036d3 <devpipe_write+0x67>
				return 0;
  8036cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d1:	eb 79                	jmp    80374c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036d3:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e3:	8b 40 04             	mov    0x4(%rax),%eax
  8036e6:	48 63 d0             	movslq %eax,%rdx
  8036e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ed:	8b 00                	mov    (%rax),%eax
  8036ef:	48 98                	cltq   
  8036f1:	48 83 c0 20          	add    $0x20,%rax
  8036f5:	48 39 c2             	cmp    %rax,%rdx
  8036f8:	73 b4                	jae    8036ae <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fe:	8b 40 04             	mov    0x4(%rax),%eax
  803701:	99                   	cltd   
  803702:	c1 ea 1b             	shr    $0x1b,%edx
  803705:	01 d0                	add    %edx,%eax
  803707:	83 e0 1f             	and    $0x1f,%eax
  80370a:	29 d0                	sub    %edx,%eax
  80370c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803710:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803714:	48 01 ca             	add    %rcx,%rdx
  803717:	0f b6 0a             	movzbl (%rdx),%ecx
  80371a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80371e:	48 98                	cltq   
  803720:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803728:	8b 40 04             	mov    0x4(%rax),%eax
  80372b:	8d 50 01             	lea    0x1(%rax),%edx
  80372e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803732:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803735:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80373a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803742:	0f 82 64 ff ff ff    	jb     8036ac <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803748:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80374c:	c9                   	leaveq 
  80374d:	c3                   	retq   

000000000080374e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80374e:	55                   	push   %rbp
  80374f:	48 89 e5             	mov    %rsp,%rbp
  803752:	48 83 ec 20          	sub    $0x20,%rsp
  803756:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80375a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80375e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803762:	48 89 c7             	mov    %rax,%rdi
  803765:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  80376c:	00 00 00 
  80376f:	ff d0                	callq  *%rax
  803771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803775:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803779:	48 be 86 46 80 00 00 	movabs $0x804686,%rsi
  803780:	00 00 00 
  803783:	48 89 c7             	mov    %rax,%rdi
  803786:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803796:	8b 50 04             	mov    0x4(%rax),%edx
  803799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379d:	8b 00                	mov    (%rax),%eax
  80379f:	29 c2                	sub    %eax,%edx
  8037a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037af:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037b6:	00 00 00 
	stat->st_dev = &devpipe;
  8037b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037bd:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8037c4:	00 00 00 
  8037c7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d3:	c9                   	leaveq 
  8037d4:	c3                   	retq   

00000000008037d5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037d5:	55                   	push   %rbp
  8037d6:	48 89 e5             	mov    %rsp,%rbp
  8037d9:	48 83 ec 10          	sub    $0x10,%rsp
  8037dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e5:	48 89 c6             	mov    %rax,%rsi
  8037e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ed:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fd:	48 89 c7             	mov    %rax,%rdi
  803800:	48 b8 33 22 80 00 00 	movabs $0x802233,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
  80380c:	48 89 c6             	mov    %rax,%rsi
  80380f:	bf 00 00 00 00       	mov    $0x0,%edi
  803814:	48 b8 44 1a 80 00 00 	movabs $0x801a44,%rax
  80381b:	00 00 00 
  80381e:	ff d0                	callq  *%rax
}
  803820:	c9                   	leaveq 
  803821:	c3                   	retq   

0000000000803822 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803822:	55                   	push   %rbp
  803823:	48 89 e5             	mov    %rsp,%rbp
  803826:	48 83 ec 20          	sub    $0x20,%rsp
  80382a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80382d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803830:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803833:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803837:	be 01 00 00 00       	mov    $0x1,%esi
  80383c:	48 89 c7             	mov    %rax,%rdi
  80383f:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  803846:	00 00 00 
  803849:	ff d0                	callq  *%rax
}
  80384b:	c9                   	leaveq 
  80384c:	c3                   	retq   

000000000080384d <getchar>:

int
getchar(void)
{
  80384d:	55                   	push   %rbp
  80384e:	48 89 e5             	mov    %rsp,%rbp
  803851:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803855:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803859:	ba 01 00 00 00       	mov    $0x1,%edx
  80385e:	48 89 c6             	mov    %rax,%rsi
  803861:	bf 00 00 00 00       	mov    $0x0,%edi
  803866:	48 b8 28 27 80 00 00 	movabs $0x802728,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
  803872:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803879:	79 05                	jns    803880 <getchar+0x33>
		return r;
  80387b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387e:	eb 14                	jmp    803894 <getchar+0x47>
	if (r < 1)
  803880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803884:	7f 07                	jg     80388d <getchar+0x40>
		return -E_EOF;
  803886:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80388b:	eb 07                	jmp    803894 <getchar+0x47>
	return c;
  80388d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803891:	0f b6 c0             	movzbl %al,%eax
}
  803894:	c9                   	leaveq 
  803895:	c3                   	retq   

0000000000803896 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803896:	55                   	push   %rbp
  803897:	48 89 e5             	mov    %rsp,%rbp
  80389a:	48 83 ec 20          	sub    $0x20,%rsp
  80389e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a8:	48 89 d6             	mov    %rdx,%rsi
  8038ab:	89 c7                	mov    %eax,%edi
  8038ad:	48 b8 f6 22 80 00 00 	movabs $0x8022f6,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
  8038b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c0:	79 05                	jns    8038c7 <iscons+0x31>
		return r;
  8038c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c5:	eb 1a                	jmp    8038e1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cb:	8b 10                	mov    (%rax),%edx
  8038cd:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8038d4:	00 00 00 
  8038d7:	8b 00                	mov    (%rax),%eax
  8038d9:	39 c2                	cmp    %eax,%edx
  8038db:	0f 94 c0             	sete   %al
  8038de:	0f b6 c0             	movzbl %al,%eax
}
  8038e1:	c9                   	leaveq 
  8038e2:	c3                   	retq   

00000000008038e3 <opencons>:

int
opencons(void)
{
  8038e3:	55                   	push   %rbp
  8038e4:	48 89 e5             	mov    %rsp,%rbp
  8038e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038eb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038ef:	48 89 c7             	mov    %rax,%rdi
  8038f2:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  8038f9:	00 00 00 
  8038fc:	ff d0                	callq  *%rax
  8038fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803901:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803905:	79 05                	jns    80390c <opencons+0x29>
		return r;
  803907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80390a:	eb 5b                	jmp    803967 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80390c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803910:	ba 07 04 00 00       	mov    $0x407,%edx
  803915:	48 89 c6             	mov    %rax,%rsi
  803918:	bf 00 00 00 00       	mov    $0x0,%edi
  80391d:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803930:	79 05                	jns    803937 <opencons+0x54>
		return r;
  803932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803935:	eb 30                	jmp    803967 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393b:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803942:	00 00 00 
  803945:	8b 12                	mov    (%rdx),%edx
  803947:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803949:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803958:	48 89 c7             	mov    %rax,%rdi
  80395b:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803962:	00 00 00 
  803965:	ff d0                	callq  *%rax
}
  803967:	c9                   	leaveq 
  803968:	c3                   	retq   

0000000000803969 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803969:	55                   	push   %rbp
  80396a:	48 89 e5             	mov    %rsp,%rbp
  80396d:	48 83 ec 30          	sub    $0x30,%rsp
  803971:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803975:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803979:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80397d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803982:	75 07                	jne    80398b <devcons_read+0x22>
		return 0;
  803984:	b8 00 00 00 00       	mov    $0x0,%eax
  803989:	eb 4b                	jmp    8039d6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80398b:	eb 0c                	jmp    803999 <devcons_read+0x30>
		sys_yield();
  80398d:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803999:	48 b8 9b 18 80 00 00 	movabs $0x80189b,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ac:	74 df                	je     80398d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b2:	79 05                	jns    8039b9 <devcons_read+0x50>
		return c;
  8039b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b7:	eb 1d                	jmp    8039d6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039bd:	75 07                	jne    8039c6 <devcons_read+0x5d>
		return 0;
  8039bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c4:	eb 10                	jmp    8039d6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c9:	89 c2                	mov    %eax,%edx
  8039cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039cf:	88 10                	mov    %dl,(%rax)
	return 1;
  8039d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039d6:	c9                   	leaveq 
  8039d7:	c3                   	retq   

00000000008039d8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039d8:	55                   	push   %rbp
  8039d9:	48 89 e5             	mov    %rsp,%rbp
  8039dc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039e3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039ea:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039f1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039ff:	eb 76                	jmp    803a77 <devcons_write+0x9f>
		m = n - tot;
  803a01:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a08:	89 c2                	mov    %eax,%edx
  803a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0d:	29 c2                	sub    %eax,%edx
  803a0f:	89 d0                	mov    %edx,%eax
  803a11:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a17:	83 f8 7f             	cmp    $0x7f,%eax
  803a1a:	76 07                	jbe    803a23 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a1c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a26:	48 63 d0             	movslq %eax,%rdx
  803a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2c:	48 63 c8             	movslq %eax,%rcx
  803a2f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a36:	48 01 c1             	add    %rax,%rcx
  803a39:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a40:	48 89 ce             	mov    %rcx,%rsi
  803a43:	48 89 c7             	mov    %rax,%rdi
  803a46:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a55:	48 63 d0             	movslq %eax,%rdx
  803a58:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a5f:	48 89 d6             	mov    %rdx,%rsi
  803a62:	48 89 c7             	mov    %rax,%rdi
  803a65:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a74:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7a:	48 98                	cltq   
  803a7c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a83:	0f 82 78 ff ff ff    	jb     803a01 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a8c:	c9                   	leaveq 
  803a8d:	c3                   	retq   

0000000000803a8e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a8e:	55                   	push   %rbp
  803a8f:	48 89 e5             	mov    %rsp,%rbp
  803a92:	48 83 ec 08          	sub    $0x8,%rsp
  803a96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a9f:	c9                   	leaveq 
  803aa0:	c3                   	retq   

0000000000803aa1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803aa1:	55                   	push   %rbp
  803aa2:	48 89 e5             	mov    %rsp,%rbp
  803aa5:	48 83 ec 10          	sub    $0x10,%rsp
  803aa9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ab1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab5:	48 be 92 46 80 00 00 	movabs $0x804692,%rsi
  803abc:	00 00 00 
  803abf:	48 89 c7             	mov    %rax,%rdi
  803ac2:	48 b8 6a 10 80 00 00 	movabs $0x80106a,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
	return 0;
  803ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad3:	c9                   	leaveq 
  803ad4:	c3                   	retq   

0000000000803ad5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803ad5:	55                   	push   %rbp
  803ad6:	48 89 e5             	mov    %rsp,%rbp
  803ad9:	48 83 ec 10          	sub    $0x10,%rsp
  803add:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803ae1:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ae8:	00 00 00 
  803aeb:	48 8b 00             	mov    (%rax),%rax
  803aee:	48 85 c0             	test   %rax,%rax
  803af1:	75 49                	jne    803b3c <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803af3:	ba 07 00 00 00       	mov    $0x7,%edx
  803af8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803afd:	bf 00 00 00 00       	mov    $0x0,%edi
  803b02:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	79 2a                	jns    803b3c <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803b12:	48 ba a0 46 80 00 00 	movabs $0x8046a0,%rdx
  803b19:	00 00 00 
  803b1c:	be 21 00 00 00       	mov    $0x21,%esi
  803b21:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  803b28:	00 00 00 
  803b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b30:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  803b37:	00 00 00 
  803b3a:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b3c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b43:	00 00 00 
  803b46:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b4a:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803b4d:	48 be 98 3b 80 00 00 	movabs $0x803b98,%rsi
  803b54:	00 00 00 
  803b57:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5c:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  803b63:	00 00 00 
  803b66:	ff d0                	callq  *%rax
  803b68:	85 c0                	test   %eax,%eax
  803b6a:	79 2a                	jns    803b96 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803b6c:	48 ba e0 46 80 00 00 	movabs $0x8046e0,%rdx
  803b73:	00 00 00 
  803b76:	be 27 00 00 00       	mov    $0x27,%esi
  803b7b:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  803b82:	00 00 00 
  803b85:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8a:	48 b9 69 02 80 00 00 	movabs $0x800269,%rcx
  803b91:	00 00 00 
  803b94:	ff d1                	callq  *%rcx
}
  803b96:	c9                   	leaveq 
  803b97:	c3                   	retq   

0000000000803b98 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803b98:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803b9b:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803ba2:	00 00 00 
call *%rax
  803ba5:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803ba7:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803bae:	00 
    movq 152(%rsp), %rcx
  803baf:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803bb6:	00 
    subq $8, %rcx
  803bb7:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803bbb:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803bbe:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803bc5:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803bc6:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803bca:	4c 8b 3c 24          	mov    (%rsp),%r15
  803bce:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803bd3:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803bd8:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803bdd:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803be2:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803be7:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803bec:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803bf1:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bf6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bfb:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c00:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c05:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c0a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c0f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c14:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803c18:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803c1c:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803c1d:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803c1e:	c3                   	retq   

0000000000803c1f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c1f:	55                   	push   %rbp
  803c20:	48 89 e5             	mov    %rsp,%rbp
  803c23:	48 83 ec 30          	sub    $0x30,%rsp
  803c27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803c33:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c38:	75 0e                	jne    803c48 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803c3a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c41:	00 00 00 
  803c44:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803c48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c4c:	48 89 c7             	mov    %rax,%rdi
  803c4f:	48 b8 c2 1b 80 00 00 	movabs $0x801bc2,%rax
  803c56:	00 00 00 
  803c59:	ff d0                	callq  *%rax
  803c5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c62:	79 27                	jns    803c8b <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803c64:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c69:	74 0a                	je     803c75 <ipc_recv+0x56>
            *from_env_store = 0;
  803c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c6f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803c75:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c7a:	74 0a                	je     803c86 <ipc_recv+0x67>
            *perm_store = 0;
  803c7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c80:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803c86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c89:	eb 53                	jmp    803cde <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803c8b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c90:	74 19                	je     803cab <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803c92:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c99:	00 00 00 
  803c9c:	48 8b 00             	mov    (%rax),%rax
  803c9f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca9:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803cab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cb0:	74 19                	je     803ccb <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803cb2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cb9:	00 00 00 
  803cbc:	48 8b 00             	mov    (%rax),%rax
  803cbf:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803cc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc9:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803ccb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cd2:	00 00 00 
  803cd5:	48 8b 00             	mov    (%rax),%rax
  803cd8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803cde:	c9                   	leaveq 
  803cdf:	c3                   	retq   

0000000000803ce0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ce0:	55                   	push   %rbp
  803ce1:	48 89 e5             	mov    %rsp,%rbp
  803ce4:	48 83 ec 30          	sub    $0x30,%rsp
  803ce8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ceb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cee:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cf2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803cf5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803cfa:	75 0e                	jne    803d0a <ipc_send+0x2a>
        pg = (void *)UTOP;
  803cfc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d03:	00 00 00 
  803d06:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803d0a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d0d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d10:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d17:	89 c7                	mov    %eax,%edi
  803d19:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
  803d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2c:	79 36                	jns    803d64 <ipc_send+0x84>
  803d2e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d32:	74 30                	je     803d64 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d37:	89 c1                	mov    %eax,%ecx
  803d39:	48 ba 17 47 80 00 00 	movabs $0x804717,%rdx
  803d40:	00 00 00 
  803d43:	be 49 00 00 00       	mov    $0x49,%esi
  803d48:	48 bf 24 47 80 00 00 	movabs $0x804724,%rdi
  803d4f:	00 00 00 
  803d52:	b8 00 00 00 00       	mov    $0x0,%eax
  803d57:	49 b8 69 02 80 00 00 	movabs $0x800269,%r8
  803d5e:	00 00 00 
  803d61:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803d64:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803d6b:	00 00 00 
  803d6e:	ff d0                	callq  *%rax
    } while(r != 0);
  803d70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d74:	75 94                	jne    803d0a <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803d76:	c9                   	leaveq 
  803d77:	c3                   	retq   

0000000000803d78 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d78:	55                   	push   %rbp
  803d79:	48 89 e5             	mov    %rsp,%rbp
  803d7c:	48 83 ec 14          	sub    $0x14,%rsp
  803d80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d8a:	eb 5e                	jmp    803dea <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d8c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d93:	00 00 00 
  803d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d99:	48 63 d0             	movslq %eax,%rdx
  803d9c:	48 89 d0             	mov    %rdx,%rax
  803d9f:	48 c1 e0 03          	shl    $0x3,%rax
  803da3:	48 01 d0             	add    %rdx,%rax
  803da6:	48 c1 e0 05          	shl    $0x5,%rax
  803daa:	48 01 c8             	add    %rcx,%rax
  803dad:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803db3:	8b 00                	mov    (%rax),%eax
  803db5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803db8:	75 2c                	jne    803de6 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803dba:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dc1:	00 00 00 
  803dc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc7:	48 63 d0             	movslq %eax,%rdx
  803dca:	48 89 d0             	mov    %rdx,%rax
  803dcd:	48 c1 e0 03          	shl    $0x3,%rax
  803dd1:	48 01 d0             	add    %rdx,%rax
  803dd4:	48 c1 e0 05          	shl    $0x5,%rax
  803dd8:	48 01 c8             	add    %rcx,%rax
  803ddb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803de1:	8b 40 08             	mov    0x8(%rax),%eax
  803de4:	eb 12                	jmp    803df8 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803de6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dea:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803df1:	7e 99                	jle    803d8c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803df8:	c9                   	leaveq 
  803df9:	c3                   	retq   

0000000000803dfa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803dfa:	55                   	push   %rbp
  803dfb:	48 89 e5             	mov    %rsp,%rbp
  803dfe:	48 83 ec 18          	sub    $0x18,%rsp
  803e02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e0a:	48 c1 e8 15          	shr    $0x15,%rax
  803e0e:	48 89 c2             	mov    %rax,%rdx
  803e11:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e18:	01 00 00 
  803e1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e1f:	83 e0 01             	and    $0x1,%eax
  803e22:	48 85 c0             	test   %rax,%rax
  803e25:	75 07                	jne    803e2e <pageref+0x34>
		return 0;
  803e27:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2c:	eb 53                	jmp    803e81 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e32:	48 c1 e8 0c          	shr    $0xc,%rax
  803e36:	48 89 c2             	mov    %rax,%rdx
  803e39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e40:	01 00 00 
  803e43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e4f:	83 e0 01             	and    $0x1,%eax
  803e52:	48 85 c0             	test   %rax,%rax
  803e55:	75 07                	jne    803e5e <pageref+0x64>
		return 0;
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5c:	eb 23                	jmp    803e81 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e62:	48 c1 e8 0c          	shr    $0xc,%rax
  803e66:	48 89 c2             	mov    %rax,%rdx
  803e69:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e70:	00 00 00 
  803e73:	48 c1 e2 04          	shl    $0x4,%rdx
  803e77:	48 01 d0             	add    %rdx,%rax
  803e7a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e7e:	0f b7 c0             	movzwl %ax,%eax
}
  803e81:	c9                   	leaveq 
  803e82:	c3                   	retq   
