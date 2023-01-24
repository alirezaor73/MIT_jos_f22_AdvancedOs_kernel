
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
  800052:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 16                	jmp    800080 <umain+0x3d>
		if (fork() == 0)
  80006a:	48 b8 09 1f 80 00 00 	movabs $0x801f09,%rax
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
  80008c:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
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
  8000dd:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f0:	eb 1f                	jmp    800111 <umain+0xce>
			counter++;
  8000f2:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
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
  800124:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba 20 23 80 00 00 	movabs $0x802320,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf 48 23 80 00 00 	movabs $0x802348,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 5d 02 80 00 00 	movabs $0x80025d,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf 5b 23 80 00 00 	movabs $0x80235b,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 b9 96 04 80 00 00 	movabs $0x800496,%rcx
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
	envid_t id = sys_getenvid();
  8001c4:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
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
  8001f9:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  800200:	00 00 00 
  800203:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800206:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80020a:	7e 14                	jle    800220 <libmain+0x6b>
		binaryname = argv[0];
  80020c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800210:	48 8b 10             	mov    (%rax),%rdx
  800213:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
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
	sys_env_destroy(0);
  80024a:	bf 00 00 00 00       	mov    $0x0,%edi
  80024f:	48 b8 cd 18 80 00 00 	movabs $0x8018cd,%rax
  800256:	00 00 00 
  800259:	ff d0                	callq  *%rax
}
  80025b:	5d                   	pop    %rbp
  80025c:	c3                   	retq   

000000000080025d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025d:	55                   	push   %rbp
  80025e:	48 89 e5             	mov    %rsp,%rbp
  800261:	53                   	push   %rbx
  800262:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800269:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800270:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800276:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80027d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800284:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80028b:	84 c0                	test   %al,%al
  80028d:	74 23                	je     8002b2 <_panic+0x55>
  80028f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800296:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80029a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80029e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002aa:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ae:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002b9:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002c0:	00 00 00 
  8002c3:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002ca:	00 00 00 
  8002cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002d8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002df:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002e6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002ed:	00 00 00 
  8002f0:	48 8b 18             	mov    (%rax),%rbx
  8002f3:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8002fa:	00 00 00 
  8002fd:	ff d0                	callq  *%rax
  8002ff:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800305:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80030c:	41 89 c8             	mov    %ecx,%r8d
  80030f:	48 89 d1             	mov    %rdx,%rcx
  800312:	48 89 da             	mov    %rbx,%rdx
  800315:	89 c6                	mov    %eax,%esi
  800317:	48 bf 88 23 80 00 00 	movabs $0x802388,%rdi
  80031e:	00 00 00 
  800321:	b8 00 00 00 00       	mov    $0x0,%eax
  800326:	49 b9 96 04 80 00 00 	movabs $0x800496,%r9
  80032d:	00 00 00 
  800330:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800333:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80033a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800341:	48 89 d6             	mov    %rdx,%rsi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	cprintf("\n");
  800353:	48 bf ab 23 80 00 00 	movabs $0x8023ab,%rdi
  80035a:	00 00 00 
  80035d:	b8 00 00 00 00       	mov    $0x0,%eax
  800362:	48 ba 96 04 80 00 00 	movabs $0x800496,%rdx
  800369:	00 00 00 
  80036c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036e:	cc                   	int3   
  80036f:	eb fd                	jmp    80036e <_panic+0x111>

0000000000800371 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800371:	55                   	push   %rbp
  800372:	48 89 e5             	mov    %rsp,%rbp
  800375:	48 83 ec 10          	sub    $0x10,%rsp
  800379:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80037c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800384:	8b 00                	mov    (%rax),%eax
  800386:	8d 48 01             	lea    0x1(%rax),%ecx
  800389:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038d:	89 0a                	mov    %ecx,(%rdx)
  80038f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800392:	89 d1                	mov    %edx,%ecx
  800394:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800398:	48 98                	cltq   
  80039a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80039e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a2:	8b 00                	mov    (%rax),%eax
  8003a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a9:	75 2c                	jne    8003d7 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003af:	8b 00                	mov    (%rax),%eax
  8003b1:	48 98                	cltq   
  8003b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b7:	48 83 c2 08          	add    $0x8,%rdx
  8003bb:	48 89 c6             	mov    %rax,%rsi
  8003be:	48 89 d7             	mov    %rdx,%rdi
  8003c1:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  8003c8:	00 00 00 
  8003cb:	ff d0                	callq  *%rax
        b->idx = 0;
  8003cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003db:	8b 40 04             	mov    0x4(%rax),%eax
  8003de:	8d 50 01             	lea    0x1(%rax),%edx
  8003e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e8:	c9                   	leaveq 
  8003e9:	c3                   	retq   

00000000008003ea <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003ea:	55                   	push   %rbp
  8003eb:	48 89 e5             	mov    %rsp,%rbp
  8003ee:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003f5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003fc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800403:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80040a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800411:	48 8b 0a             	mov    (%rdx),%rcx
  800414:	48 89 08             	mov    %rcx,(%rax)
  800417:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80041b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80041f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800423:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800427:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80042e:	00 00 00 
    b.cnt = 0;
  800431:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800438:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80043b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800442:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800449:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800450:	48 89 c6             	mov    %rax,%rsi
  800453:	48 bf 71 03 80 00 00 	movabs $0x800371,%rdi
  80045a:	00 00 00 
  80045d:	48 b8 49 08 80 00 00 	movabs $0x800849,%rax
  800464:	00 00 00 
  800467:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800469:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80046f:	48 98                	cltq   
  800471:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800478:	48 83 c2 08          	add    $0x8,%rdx
  80047c:	48 89 c6             	mov    %rax,%rsi
  80047f:	48 89 d7             	mov    %rdx,%rdi
  800482:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80048e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800494:	c9                   	leaveq 
  800495:	c3                   	retq   

0000000000800496 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800496:	55                   	push   %rbp
  800497:	48 89 e5             	mov    %rsp,%rbp
  80049a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004af:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004bd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c4:	84 c0                	test   %al,%al
  8004c6:	74 20                	je     8004e8 <cprintf+0x52>
  8004c8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004cc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004dc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004e8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004ef:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004f6:	00 00 00 
  8004f9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800500:	00 00 00 
  800503:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800507:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80050e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800515:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80051c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800523:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80052a:	48 8b 0a             	mov    (%rdx),%rcx
  80052d:	48 89 08             	mov    %rcx,(%rax)
  800530:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800534:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800538:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80053c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800540:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800547:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80054e:	48 89 d6             	mov    %rdx,%rsi
  800551:	48 89 c7             	mov    %rax,%rdi
  800554:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  80055b:	00 00 00 
  80055e:	ff d0                	callq  *%rax
  800560:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800566:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80056c:	c9                   	leaveq 
  80056d:	c3                   	retq   

000000000080056e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056e:	55                   	push   %rbp
  80056f:	48 89 e5             	mov    %rsp,%rbp
  800572:	53                   	push   %rbx
  800573:	48 83 ec 38          	sub    $0x38,%rsp
  800577:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80057b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80057f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800583:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800586:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80058a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800591:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800595:	77 3b                	ja     8005d2 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800597:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80059a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80059e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005aa:	48 f7 f3             	div    %rbx
  8005ad:	48 89 c2             	mov    %rax,%rdx
  8005b0:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005b3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005b6:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005be:	41 89 f9             	mov    %edi,%r9d
  8005c1:	48 89 c7             	mov    %rax,%rdi
  8005c4:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  8005cb:	00 00 00 
  8005ce:	ff d0                	callq  *%rax
  8005d0:	eb 1e                	jmp    8005f0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d2:	eb 12                	jmp    8005e6 <printnum+0x78>
			putch(padc, putdat);
  8005d4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005d8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005df:	48 89 ce             	mov    %rcx,%rsi
  8005e2:	89 d7                	mov    %edx,%edi
  8005e4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005ea:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005ee:	7f e4                	jg     8005d4 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	48 f7 f1             	div    %rcx
  8005ff:	48 89 d0             	mov    %rdx,%rax
  800602:	48 ba 10 25 80 00 00 	movabs $0x802510,%rdx
  800609:	00 00 00 
  80060c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800610:	0f be d0             	movsbl %al,%edx
  800613:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061b:	48 89 ce             	mov    %rcx,%rsi
  80061e:	89 d7                	mov    %edx,%edi
  800620:	ff d0                	callq  *%rax
}
  800622:	48 83 c4 38          	add    $0x38,%rsp
  800626:	5b                   	pop    %rbx
  800627:	5d                   	pop    %rbp
  800628:	c3                   	retq   

0000000000800629 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800629:	55                   	push   %rbp
  80062a:	48 89 e5             	mov    %rsp,%rbp
  80062d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800631:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800635:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800638:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063c:	7e 52                	jle    800690 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	83 f8 30             	cmp    $0x30,%eax
  800647:	73 24                	jae    80066d <getuint+0x44>
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	8b 00                	mov    (%rax),%eax
  800657:	89 c0                	mov    %eax,%eax
  800659:	48 01 d0             	add    %rdx,%rax
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	8b 12                	mov    (%rdx),%edx
  800662:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800669:	89 0a                	mov    %ecx,(%rdx)
  80066b:	eb 17                	jmp    800684 <getuint+0x5b>
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800675:	48 89 d0             	mov    %rdx,%rax
  800678:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800684:	48 8b 00             	mov    (%rax),%rax
  800687:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068b:	e9 a3 00 00 00       	jmpq   800733 <getuint+0x10a>
	else if (lflag)
  800690:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800694:	74 4f                	je     8006e5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069a:	8b 00                	mov    (%rax),%eax
  80069c:	83 f8 30             	cmp    $0x30,%eax
  80069f:	73 24                	jae    8006c5 <getuint+0x9c>
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	8b 00                	mov    (%rax),%eax
  8006af:	89 c0                	mov    %eax,%eax
  8006b1:	48 01 d0             	add    %rdx,%rax
  8006b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b8:	8b 12                	mov    (%rdx),%edx
  8006ba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c1:	89 0a                	mov    %ecx,(%rdx)
  8006c3:	eb 17                	jmp    8006dc <getuint+0xb3>
  8006c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cd:	48 89 d0             	mov    %rdx,%rax
  8006d0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006dc:	48 8b 00             	mov    (%rax),%rax
  8006df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e3:	eb 4e                	jmp    800733 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e9:	8b 00                	mov    (%rax),%eax
  8006eb:	83 f8 30             	cmp    $0x30,%eax
  8006ee:	73 24                	jae    800714 <getuint+0xeb>
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fc:	8b 00                	mov    (%rax),%eax
  8006fe:	89 c0                	mov    %eax,%eax
  800700:	48 01 d0             	add    %rdx,%rax
  800703:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800707:	8b 12                	mov    (%rdx),%edx
  800709:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800710:	89 0a                	mov    %ecx,(%rdx)
  800712:	eb 17                	jmp    80072b <getuint+0x102>
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071c:	48 89 d0             	mov    %rdx,%rax
  80071f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800727:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072b:	8b 00                	mov    (%rax),%eax
  80072d:	89 c0                	mov    %eax,%eax
  80072f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800741:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800745:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800748:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80074c:	7e 52                	jle    8007a0 <getint+0x67>
		x=va_arg(*ap, long long);
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	8b 00                	mov    (%rax),%eax
  800754:	83 f8 30             	cmp    $0x30,%eax
  800757:	73 24                	jae    80077d <getint+0x44>
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	8b 00                	mov    (%rax),%eax
  800767:	89 c0                	mov    %eax,%eax
  800769:	48 01 d0             	add    %rdx,%rax
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	8b 12                	mov    (%rdx),%edx
  800772:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800779:	89 0a                	mov    %ecx,(%rdx)
  80077b:	eb 17                	jmp    800794 <getint+0x5b>
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800785:	48 89 d0             	mov    %rdx,%rax
  800788:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800790:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800794:	48 8b 00             	mov    (%rax),%rax
  800797:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079b:	e9 a3 00 00 00       	jmpq   800843 <getint+0x10a>
	else if (lflag)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007a4:	74 4f                	je     8007f5 <getint+0xbc>
		x=va_arg(*ap, long);
  8007a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007aa:	8b 00                	mov    (%rax),%eax
  8007ac:	83 f8 30             	cmp    $0x30,%eax
  8007af:	73 24                	jae    8007d5 <getint+0x9c>
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	8b 00                	mov    (%rax),%eax
  8007bf:	89 c0                	mov    %eax,%eax
  8007c1:	48 01 d0             	add    %rdx,%rax
  8007c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c8:	8b 12                	mov    (%rdx),%edx
  8007ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	89 0a                	mov    %ecx,(%rdx)
  8007d3:	eb 17                	jmp    8007ec <getint+0xb3>
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007dd:	48 89 d0             	mov    %rdx,%rax
  8007e0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ec:	48 8b 00             	mov    (%rax),%rax
  8007ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f3:	eb 4e                	jmp    800843 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f9:	8b 00                	mov    (%rax),%eax
  8007fb:	83 f8 30             	cmp    $0x30,%eax
  8007fe:	73 24                	jae    800824 <getint+0xeb>
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	8b 00                	mov    (%rax),%eax
  80080e:	89 c0                	mov    %eax,%eax
  800810:	48 01 d0             	add    %rdx,%rax
  800813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800817:	8b 12                	mov    (%rdx),%edx
  800819:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	89 0a                	mov    %ecx,(%rdx)
  800822:	eb 17                	jmp    80083b <getint+0x102>
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80082c:	48 89 d0             	mov    %rdx,%rax
  80082f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083b:	8b 00                	mov    (%rax),%eax
  80083d:	48 98                	cltq   
  80083f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800843:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800847:	c9                   	leaveq 
  800848:	c3                   	retq   

0000000000800849 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800849:	55                   	push   %rbp
  80084a:	48 89 e5             	mov    %rsp,%rbp
  80084d:	41 54                	push   %r12
  80084f:	53                   	push   %rbx
  800850:	48 83 ec 60          	sub    $0x60,%rsp
  800854:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800858:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80085c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800860:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800864:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800868:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80086c:	48 8b 0a             	mov    (%rdx),%rcx
  80086f:	48 89 08             	mov    %rcx,(%rax)
  800872:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800876:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80087a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800882:	eb 17                	jmp    80089b <vprintfmt+0x52>
			if (ch == '\0')
  800884:	85 db                	test   %ebx,%ebx
  800886:	0f 84 df 04 00 00    	je     800d6b <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80088c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800890:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800894:	48 89 d6             	mov    %rdx,%rsi
  800897:	89 df                	mov    %ebx,%edi
  800899:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a7:	0f b6 00             	movzbl (%rax),%eax
  8008aa:	0f b6 d8             	movzbl %al,%ebx
  8008ad:	83 fb 25             	cmp    $0x25,%ebx
  8008b0:	75 d2                	jne    800884 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b2:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b6:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008cb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008da:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008de:	0f b6 00             	movzbl (%rax),%eax
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 47 04 00 00    	ja     800d37 <vprintfmt+0x4ee>
  8008f0:	89 c0                	mov    %eax,%eax
  8008f2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008f9:	00 
  8008fa:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  800901:	00 00 00 
  800904:	48 01 d0             	add    %rdx,%rax
  800907:	48 8b 00             	mov    (%rax),%rax
  80090a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80090c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800910:	eb c0                	jmp    8008d2 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800912:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800916:	eb ba                	jmp    8008d2 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800918:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80091f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800922:	89 d0                	mov    %edx,%eax
  800924:	c1 e0 02             	shl    $0x2,%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	01 c0                	add    %eax,%eax
  80092b:	01 d8                	add    %ebx,%eax
  80092d:	83 e8 30             	sub    $0x30,%eax
  800930:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800933:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800937:	0f b6 00             	movzbl (%rax),%eax
  80093a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093d:	83 fb 2f             	cmp    $0x2f,%ebx
  800940:	7e 0c                	jle    80094e <vprintfmt+0x105>
  800942:	83 fb 39             	cmp    $0x39,%ebx
  800945:	7f 07                	jg     80094e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800947:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094c:	eb d1                	jmp    80091f <vprintfmt+0xd6>
			goto process_precision;
  80094e:	eb 58                	jmp    8009a8 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800950:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800953:	83 f8 30             	cmp    $0x30,%eax
  800956:	73 17                	jae    80096f <vprintfmt+0x126>
  800958:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095f:	89 c0                	mov    %eax,%eax
  800961:	48 01 d0             	add    %rdx,%rax
  800964:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800967:	83 c2 08             	add    $0x8,%edx
  80096a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096d:	eb 0f                	jmp    80097e <vprintfmt+0x135>
  80096f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800973:	48 89 d0             	mov    %rdx,%rax
  800976:	48 83 c2 08          	add    $0x8,%rdx
  80097a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097e:	8b 00                	mov    (%rax),%eax
  800980:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800983:	eb 23                	jmp    8009a8 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800985:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800989:	79 0c                	jns    800997 <vprintfmt+0x14e>
				width = 0;
  80098b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800992:	e9 3b ff ff ff       	jmpq   8008d2 <vprintfmt+0x89>
  800997:	e9 36 ff ff ff       	jmpq   8008d2 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80099c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a3:	e9 2a ff ff ff       	jmpq   8008d2 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ac:	79 12                	jns    8009c0 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009b4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009bb:	e9 12 ff ff ff       	jmpq   8008d2 <vprintfmt+0x89>
  8009c0:	e9 0d ff ff ff       	jmpq   8008d2 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009c9:	e9 04 ff ff ff       	jmpq   8008d2 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d1:	83 f8 30             	cmp    $0x30,%eax
  8009d4:	73 17                	jae    8009ed <vprintfmt+0x1a4>
  8009d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dd:	89 c0                	mov    %eax,%eax
  8009df:	48 01 d0             	add    %rdx,%rax
  8009e2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e5:	83 c2 08             	add    $0x8,%edx
  8009e8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009eb:	eb 0f                	jmp    8009fc <vprintfmt+0x1b3>
  8009ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f1:	48 89 d0             	mov    %rdx,%rax
  8009f4:	48 83 c2 08          	add    $0x8,%rdx
  8009f8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009fc:	8b 10                	mov    (%rax),%edx
  8009fe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a06:	48 89 ce             	mov    %rcx,%rsi
  800a09:	89 d7                	mov    %edx,%edi
  800a0b:	ff d0                	callq  *%rax
			break;
  800a0d:	e9 53 03 00 00       	jmpq   800d65 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a15:	83 f8 30             	cmp    $0x30,%eax
  800a18:	73 17                	jae    800a31 <vprintfmt+0x1e8>
  800a1a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a21:	89 c0                	mov    %eax,%eax
  800a23:	48 01 d0             	add    %rdx,%rax
  800a26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a29:	83 c2 08             	add    $0x8,%edx
  800a2c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a2f:	eb 0f                	jmp    800a40 <vprintfmt+0x1f7>
  800a31:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a35:	48 89 d0             	mov    %rdx,%rax
  800a38:	48 83 c2 08          	add    $0x8,%rdx
  800a3c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a40:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a42:	85 db                	test   %ebx,%ebx
  800a44:	79 02                	jns    800a48 <vprintfmt+0x1ff>
				err = -err;
  800a46:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a48:	83 fb 15             	cmp    $0x15,%ebx
  800a4b:	7f 16                	jg     800a63 <vprintfmt+0x21a>
  800a4d:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  800a54:	00 00 00 
  800a57:	48 63 d3             	movslq %ebx,%rdx
  800a5a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a5e:	4d 85 e4             	test   %r12,%r12
  800a61:	75 2e                	jne    800a91 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a63:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6b:	89 d9                	mov    %ebx,%ecx
  800a6d:	48 ba 21 25 80 00 00 	movabs $0x802521,%rdx
  800a74:	00 00 00 
  800a77:	48 89 c7             	mov    %rax,%rdi
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7f:	49 b8 74 0d 80 00 00 	movabs $0x800d74,%r8
  800a86:	00 00 00 
  800a89:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8c:	e9 d4 02 00 00       	jmpq   800d65 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a91:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a99:	4c 89 e1             	mov    %r12,%rcx
  800a9c:	48 ba 2a 25 80 00 00 	movabs $0x80252a,%rdx
  800aa3:	00 00 00 
  800aa6:	48 89 c7             	mov    %rax,%rdi
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	49 b8 74 0d 80 00 00 	movabs $0x800d74,%r8
  800ab5:	00 00 00 
  800ab8:	41 ff d0             	callq  *%r8
			break;
  800abb:	e9 a5 02 00 00       	jmpq   800d65 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac3:	83 f8 30             	cmp    $0x30,%eax
  800ac6:	73 17                	jae    800adf <vprintfmt+0x296>
  800ac8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acf:	89 c0                	mov    %eax,%eax
  800ad1:	48 01 d0             	add    %rdx,%rax
  800ad4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad7:	83 c2 08             	add    $0x8,%edx
  800ada:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800add:	eb 0f                	jmp    800aee <vprintfmt+0x2a5>
  800adf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae3:	48 89 d0             	mov    %rdx,%rax
  800ae6:	48 83 c2 08          	add    $0x8,%rdx
  800aea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aee:	4c 8b 20             	mov    (%rax),%r12
  800af1:	4d 85 e4             	test   %r12,%r12
  800af4:	75 0a                	jne    800b00 <vprintfmt+0x2b7>
				p = "(null)";
  800af6:	49 bc 2d 25 80 00 00 	movabs $0x80252d,%r12
  800afd:	00 00 00 
			if (width > 0 && padc != '-')
  800b00:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b04:	7e 3f                	jle    800b45 <vprintfmt+0x2fc>
  800b06:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b0a:	74 39                	je     800b45 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b0f:	48 98                	cltq   
  800b11:	48 89 c6             	mov    %rax,%rsi
  800b14:	4c 89 e7             	mov    %r12,%rdi
  800b17:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  800b1e:	00 00 00 
  800b21:	ff d0                	callq  *%rax
  800b23:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b26:	eb 17                	jmp    800b3f <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b28:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b2c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b34:	48 89 ce             	mov    %rcx,%rsi
  800b37:	89 d7                	mov    %edx,%edi
  800b39:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b43:	7f e3                	jg     800b28 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b45:	eb 37                	jmp    800b7e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b47:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b4b:	74 1e                	je     800b6b <vprintfmt+0x322>
  800b4d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b50:	7e 05                	jle    800b57 <vprintfmt+0x30e>
  800b52:	83 fb 7e             	cmp    $0x7e,%ebx
  800b55:	7e 14                	jle    800b6b <vprintfmt+0x322>
					putch('?', putdat);
  800b57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5f:	48 89 d6             	mov    %rdx,%rsi
  800b62:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b67:	ff d0                	callq  *%rax
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b73:	48 89 d6             	mov    %rdx,%rsi
  800b76:	89 df                	mov    %ebx,%edi
  800b78:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7e:	4c 89 e0             	mov    %r12,%rax
  800b81:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b85:	0f b6 00             	movzbl (%rax),%eax
  800b88:	0f be d8             	movsbl %al,%ebx
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	74 10                	je     800b9f <vprintfmt+0x356>
  800b8f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b93:	78 b2                	js     800b47 <vprintfmt+0x2fe>
  800b95:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b99:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9d:	79 a8                	jns    800b47 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9f:	eb 16                	jmp    800bb7 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ba1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 d6             	mov    %rdx,%rsi
  800bac:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bbb:	7f e4                	jg     800ba1 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bbd:	e9 a3 01 00 00       	jmpq   800d65 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc6:	be 03 00 00 00       	mov    $0x3,%esi
  800bcb:	48 89 c7             	mov    %rax,%rdi
  800bce:	48 b8 39 07 80 00 00 	movabs $0x800739,%rax
  800bd5:	00 00 00 
  800bd8:	ff d0                	callq  *%rax
  800bda:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be2:	48 85 c0             	test   %rax,%rax
  800be5:	79 1d                	jns    800c04 <vprintfmt+0x3bb>
				putch('-', putdat);
  800be7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	48 89 d6             	mov    %rdx,%rsi
  800bf2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bf7:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfd:	48 f7 d8             	neg    %rax
  800c00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c04:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c0b:	e9 e8 00 00 00       	jmpq   800cf8 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c14:	be 03 00 00 00       	mov    $0x3,%esi
  800c19:	48 89 c7             	mov    %rax,%rdi
  800c1c:	48 b8 29 06 80 00 00 	movabs $0x800629,%rax
  800c23:	00 00 00 
  800c26:	ff d0                	callq  *%rax
  800c28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c2c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c33:	e9 c0 00 00 00       	jmpq   800cf8 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c40:	48 89 d6             	mov    %rdx,%rsi
  800c43:	bf 58 00 00 00       	mov    $0x58,%edi
  800c48:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c52:	48 89 d6             	mov    %rdx,%rsi
  800c55:	bf 58 00 00 00       	mov    $0x58,%edi
  800c5a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	bf 58 00 00 00       	mov    $0x58,%edi
  800c6c:	ff d0                	callq  *%rax
			break;
  800c6e:	e9 f2 00 00 00       	jmpq   800d65 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7b:	48 89 d6             	mov    %rdx,%rsi
  800c7e:	bf 30 00 00 00       	mov    $0x30,%edi
  800c83:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8d:	48 89 d6             	mov    %rdx,%rsi
  800c90:	bf 78 00 00 00       	mov    $0x78,%edi
  800c95:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9a:	83 f8 30             	cmp    $0x30,%eax
  800c9d:	73 17                	jae    800cb6 <vprintfmt+0x46d>
  800c9f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	89 c0                	mov    %eax,%eax
  800ca8:	48 01 d0             	add    %rdx,%rax
  800cab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cae:	83 c2 08             	add    $0x8,%edx
  800cb1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb4:	eb 0f                	jmp    800cc5 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cb6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cba:	48 89 d0             	mov    %rdx,%rax
  800cbd:	48 83 c2 08          	add    $0x8,%rdx
  800cc1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ccc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cd3:	eb 23                	jmp    800cf8 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd9:	be 03 00 00 00       	mov    $0x3,%esi
  800cde:	48 89 c7             	mov    %rax,%rdi
  800ce1:	48 b8 29 06 80 00 00 	movabs $0x800629,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	callq  *%rax
  800ced:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cfd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d00:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d07:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0f:	45 89 c1             	mov    %r8d,%r9d
  800d12:	41 89 f8             	mov    %edi,%r8d
  800d15:	48 89 c7             	mov    %rax,%rdi
  800d18:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  800d1f:	00 00 00 
  800d22:	ff d0                	callq  *%rax
			break;
  800d24:	eb 3f                	jmp    800d65 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2e:	48 89 d6             	mov    %rdx,%rsi
  800d31:	89 df                	mov    %ebx,%edi
  800d33:	ff d0                	callq  *%rax
			break;
  800d35:	eb 2e                	jmp    800d65 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3f:	48 89 d6             	mov    %rdx,%rsi
  800d42:	bf 25 00 00 00       	mov    $0x25,%edi
  800d47:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d49:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d4e:	eb 05                	jmp    800d55 <vprintfmt+0x50c>
  800d50:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d55:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d59:	48 83 e8 01          	sub    $0x1,%rax
  800d5d:	0f b6 00             	movzbl (%rax),%eax
  800d60:	3c 25                	cmp    $0x25,%al
  800d62:	75 ec                	jne    800d50 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d64:	90                   	nop
		}
	}
  800d65:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d66:	e9 30 fb ff ff       	jmpq   80089b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d6b:	48 83 c4 60          	add    $0x60,%rsp
  800d6f:	5b                   	pop    %rbx
  800d70:	41 5c                	pop    %r12
  800d72:	5d                   	pop    %rbp
  800d73:	c3                   	retq   

0000000000800d74 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d74:	55                   	push   %rbp
  800d75:	48 89 e5             	mov    %rsp,%rbp
  800d78:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d7f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d86:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d8d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d94:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d9b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da2:	84 c0                	test   %al,%al
  800da4:	74 20                	je     800dc6 <printfmt+0x52>
  800da6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800daa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800db6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dbe:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dc6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dcd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dd4:	00 00 00 
  800dd7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dde:	00 00 00 
  800de1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dfa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e01:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e08:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e0f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e16:	48 89 c7             	mov    %rax,%rdi
  800e19:	48 b8 49 08 80 00 00 	movabs $0x800849,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   

0000000000800e27 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e27:	55                   	push   %rbp
  800e28:	48 89 e5             	mov    %rsp,%rbp
  800e2b:	48 83 ec 10          	sub    $0x10,%rsp
  800e2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3a:	8b 40 10             	mov    0x10(%rax),%eax
  800e3d:	8d 50 01             	lea    0x1(%rax),%edx
  800e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e44:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4b:	48 8b 10             	mov    (%rax),%rdx
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e56:	48 39 c2             	cmp    %rax,%rdx
  800e59:	73 17                	jae    800e72 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5f:	48 8b 00             	mov    (%rax),%rax
  800e62:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e6a:	48 89 0a             	mov    %rcx,(%rdx)
  800e6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e70:	88 10                	mov    %dl,(%rax)
}
  800e72:	c9                   	leaveq 
  800e73:	c3                   	retq   

0000000000800e74 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e74:	55                   	push   %rbp
  800e75:	48 89 e5             	mov    %rsp,%rbp
  800e78:	48 83 ec 50          	sub    $0x50,%rsp
  800e7c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e80:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e83:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e87:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e8b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e8f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e93:	48 8b 0a             	mov    (%rdx),%rcx
  800e96:	48 89 08             	mov    %rcx,(%rax)
  800e99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ead:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eb4:	48 98                	cltq   
  800eb6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebe:	48 01 d0             	add    %rdx,%rax
  800ec1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ec5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ecc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed1:	74 06                	je     800ed9 <vsnprintf+0x65>
  800ed3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ed7:	7f 07                	jg     800ee0 <vsnprintf+0x6c>
		return -E_INVAL;
  800ed9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ede:	eb 2f                	jmp    800f0f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ee0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ee4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ee8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eec:	48 89 c6             	mov    %rax,%rsi
  800eef:	48 bf 27 0e 80 00 00 	movabs $0x800e27,%rdi
  800ef6:	00 00 00 
  800ef9:	48 b8 49 08 80 00 00 	movabs $0x800849,%rax
  800f00:	00 00 00 
  800f03:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f09:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f0c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f0f:	c9                   	leaveq 
  800f10:	c3                   	retq   

0000000000800f11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f11:	55                   	push   %rbp
  800f12:	48 89 e5             	mov    %rsp,%rbp
  800f15:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f1c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f23:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f29:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f30:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f37:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3e:	84 c0                	test   %al,%al
  800f40:	74 20                	je     800f62 <snprintf+0x51>
  800f42:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f46:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f4a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f52:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f56:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f5a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f62:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f69:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f70:	00 00 00 
  800f73:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f7a:	00 00 00 
  800f7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f81:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f88:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f96:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f9d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fa4:	48 8b 0a             	mov    (%rdx),%rcx
  800fa7:	48 89 08             	mov    %rcx,(%rax)
  800faa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fba:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fc8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fd5:	48 89 c7             	mov    %rax,%rdi
  800fd8:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
  800fe4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ff0:	c9                   	leaveq 
  800ff1:	c3                   	retq   

0000000000800ff2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	48 83 ec 18          	sub    $0x18,%rsp
  800ffa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801005:	eb 09                	jmp    801010 <strlen+0x1e>
		n++;
  801007:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801014:	0f b6 00             	movzbl (%rax),%eax
  801017:	84 c0                	test   %al,%al
  801019:	75 ec                	jne    801007 <strlen+0x15>
		n++;
	return n;
  80101b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101e:	c9                   	leaveq 
  80101f:	c3                   	retq   

0000000000801020 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801020:	55                   	push   %rbp
  801021:	48 89 e5             	mov    %rsp,%rbp
  801024:	48 83 ec 20          	sub    $0x20,%rsp
  801028:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801030:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801037:	eb 0e                	jmp    801047 <strnlen+0x27>
		n++;
  801039:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801042:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801047:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80104c:	74 0b                	je     801059 <strnlen+0x39>
  80104e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	84 c0                	test   %al,%al
  801057:	75 e0                	jne    801039 <strnlen+0x19>
		n++;
	return n;
  801059:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80105c:	c9                   	leaveq 
  80105d:	c3                   	retq   

000000000080105e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80105e:	55                   	push   %rbp
  80105f:	48 89 e5             	mov    %rsp,%rbp
  801062:	48 83 ec 20          	sub    $0x20,%rsp
  801066:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801076:	90                   	nop
  801077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80107f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801083:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801087:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80108b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80108f:	0f b6 12             	movzbl (%rdx),%edx
  801092:	88 10                	mov    %dl,(%rax)
  801094:	0f b6 00             	movzbl (%rax),%eax
  801097:	84 c0                	test   %al,%al
  801099:	75 dc                	jne    801077 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80109b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80109f:	c9                   	leaveq 
  8010a0:	c3                   	retq   

00000000008010a1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a1:	55                   	push   %rbp
  8010a2:	48 89 e5             	mov    %rsp,%rbp
  8010a5:	48 83 ec 20          	sub    $0x20,%rsp
  8010a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b5:	48 89 c7             	mov    %rax,%rdi
  8010b8:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  8010bf:	00 00 00 
  8010c2:	ff d0                	callq  *%rax
  8010c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ca:	48 63 d0             	movslq %eax,%rdx
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d1:	48 01 c2             	add    %rax,%rdx
  8010d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d8:	48 89 c6             	mov    %rax,%rsi
  8010db:	48 89 d7             	mov    %rdx,%rdi
  8010de:	48 b8 5e 10 80 00 00 	movabs $0x80105e,%rax
  8010e5:	00 00 00 
  8010e8:	ff d0                	callq  *%rax
	return dst;
  8010ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ee:	c9                   	leaveq 
  8010ef:	c3                   	retq   

00000000008010f0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010f0:	55                   	push   %rbp
  8010f1:	48 89 e5             	mov    %rsp,%rbp
  8010f4:	48 83 ec 28          	sub    $0x28,%rsp
  8010f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801100:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801104:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801108:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80110c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801113:	00 
  801114:	eb 2a                	jmp    801140 <strncpy+0x50>
		*dst++ = *src;
  801116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801122:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801126:	0f b6 12             	movzbl (%rdx),%edx
  801129:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80112b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80112f:	0f b6 00             	movzbl (%rax),%eax
  801132:	84 c0                	test   %al,%al
  801134:	74 05                	je     80113b <strncpy+0x4b>
			src++;
  801136:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801144:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801148:	72 cc                	jb     801116 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80114a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80114e:	c9                   	leaveq 
  80114f:	c3                   	retq   

0000000000801150 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801150:	55                   	push   %rbp
  801151:	48 89 e5             	mov    %rsp,%rbp
  801154:	48 83 ec 28          	sub    $0x28,%rsp
  801158:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801160:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801168:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80116c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801171:	74 3d                	je     8011b0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801173:	eb 1d                	jmp    801192 <strlcpy+0x42>
			*dst++ = *src++;
  801175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801179:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80117d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801181:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801185:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801189:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80118d:	0f b6 12             	movzbl (%rdx),%edx
  801190:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801192:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801197:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80119c:	74 0b                	je     8011a9 <strlcpy+0x59>
  80119e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a2:	0f b6 00             	movzbl (%rax),%eax
  8011a5:	84 c0                	test   %al,%al
  8011a7:	75 cc                	jne    801175 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ad:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b8:	48 29 c2             	sub    %rax,%rdx
  8011bb:	48 89 d0             	mov    %rdx,%rax
}
  8011be:	c9                   	leaveq 
  8011bf:	c3                   	retq   

00000000008011c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	48 83 ec 10          	sub    $0x10,%rsp
  8011c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d0:	eb 0a                	jmp    8011dc <strcmp+0x1c>
		p++, q++;
  8011d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	0f b6 00             	movzbl (%rax),%eax
  8011e3:	84 c0                	test   %al,%al
  8011e5:	74 12                	je     8011f9 <strcmp+0x39>
  8011e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011eb:	0f b6 10             	movzbl (%rax),%edx
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	0f b6 00             	movzbl (%rax),%eax
  8011f5:	38 c2                	cmp    %al,%dl
  8011f7:	74 d9                	je     8011d2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fd:	0f b6 00             	movzbl (%rax),%eax
  801200:	0f b6 d0             	movzbl %al,%edx
  801203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	0f b6 c0             	movzbl %al,%eax
  80120d:	29 c2                	sub    %eax,%edx
  80120f:	89 d0                	mov    %edx,%eax
}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 18          	sub    $0x18,%rsp
  80121b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80121f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801223:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801227:	eb 0f                	jmp    801238 <strncmp+0x25>
		n--, p++, q++;
  801229:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80122e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801233:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801238:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123d:	74 1d                	je     80125c <strncmp+0x49>
  80123f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	84 c0                	test   %al,%al
  801248:	74 12                	je     80125c <strncmp+0x49>
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	0f b6 10             	movzbl (%rax),%edx
  801251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801255:	0f b6 00             	movzbl (%rax),%eax
  801258:	38 c2                	cmp    %al,%dl
  80125a:	74 cd                	je     801229 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80125c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801261:	75 07                	jne    80126a <strncmp+0x57>
		return 0;
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
  801268:	eb 18                	jmp    801282 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126e:	0f b6 00             	movzbl (%rax),%eax
  801271:	0f b6 d0             	movzbl %al,%edx
  801274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	c9                   	leaveq 
  801283:	c3                   	retq   

0000000000801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %rbp
  801285:	48 89 e5             	mov    %rsp,%rbp
  801288:	48 83 ec 0c          	sub    $0xc,%rsp
  80128c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801290:	89 f0                	mov    %esi,%eax
  801292:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801295:	eb 17                	jmp    8012ae <strchr+0x2a>
		if (*s == c)
  801297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129b:	0f b6 00             	movzbl (%rax),%eax
  80129e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a1:	75 06                	jne    8012a9 <strchr+0x25>
			return (char *) s;
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	eb 15                	jmp    8012be <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	84 c0                	test   %al,%al
  8012b7:	75 de                	jne    801297 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012be:	c9                   	leaveq 
  8012bf:	c3                   	retq   

00000000008012c0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012c0:	55                   	push   %rbp
  8012c1:	48 89 e5             	mov    %rsp,%rbp
  8012c4:	48 83 ec 0c          	sub    $0xc,%rsp
  8012c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cc:	89 f0                	mov    %esi,%eax
  8012ce:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d1:	eb 13                	jmp    8012e6 <strfind+0x26>
		if (*s == c)
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012dd:	75 02                	jne    8012e1 <strfind+0x21>
			break;
  8012df:	eb 10                	jmp    8012f1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ea:	0f b6 00             	movzbl (%rax),%eax
  8012ed:	84 c0                	test   %al,%al
  8012ef:	75 e2                	jne    8012d3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f5:	c9                   	leaveq 
  8012f6:	c3                   	retq   

00000000008012f7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	48 83 ec 18          	sub    $0x18,%rsp
  8012ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801303:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801306:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80130a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80130f:	75 06                	jne    801317 <memset+0x20>
		return v;
  801311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801315:	eb 69                	jmp    801380 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131b:	83 e0 03             	and    $0x3,%eax
  80131e:	48 85 c0             	test   %rax,%rax
  801321:	75 48                	jne    80136b <memset+0x74>
  801323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801327:	83 e0 03             	and    $0x3,%eax
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	75 3c                	jne    80136b <memset+0x74>
		c &= 0xFF;
  80132f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801336:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801339:	c1 e0 18             	shl    $0x18,%eax
  80133c:	89 c2                	mov    %eax,%edx
  80133e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801341:	c1 e0 10             	shl    $0x10,%eax
  801344:	09 c2                	or     %eax,%edx
  801346:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801349:	c1 e0 08             	shl    $0x8,%eax
  80134c:	09 d0                	or     %edx,%eax
  80134e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801355:	48 c1 e8 02          	shr    $0x2,%rax
  801359:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80135c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801360:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801363:	48 89 d7             	mov    %rdx,%rdi
  801366:	fc                   	cld    
  801367:	f3 ab                	rep stos %eax,%es:(%rdi)
  801369:	eb 11                	jmp    80137c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80136b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801372:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801376:	48 89 d7             	mov    %rdx,%rdi
  801379:	fc                   	cld    
  80137a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80137c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801380:	c9                   	leaveq 
  801381:	c3                   	retq   

0000000000801382 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801382:	55                   	push   %rbp
  801383:	48 89 e5             	mov    %rsp,%rbp
  801386:	48 83 ec 28          	sub    $0x28,%rsp
  80138a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801392:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80139e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ae:	0f 83 88 00 00 00    	jae    80143c <memmove+0xba>
  8013b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013bc:	48 01 d0             	add    %rdx,%rax
  8013bf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c3:	76 77                	jbe    80143c <memmove+0xba>
		s += n;
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d9:	83 e0 03             	and    $0x3,%eax
  8013dc:	48 85 c0             	test   %rax,%rax
  8013df:	75 3b                	jne    80141c <memmove+0x9a>
  8013e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 2f                	jne    80141c <memmove+0x9a>
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 23                	jne    80141c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fd:	48 83 e8 04          	sub    $0x4,%rax
  801401:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801405:	48 83 ea 04          	sub    $0x4,%rdx
  801409:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80140d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801411:	48 89 c7             	mov    %rax,%rdi
  801414:	48 89 d6             	mov    %rdx,%rsi
  801417:	fd                   	std    
  801418:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80141a:	eb 1d                	jmp    801439 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801428:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80142c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801430:	48 89 d7             	mov    %rdx,%rdi
  801433:	48 89 c1             	mov    %rax,%rcx
  801436:	fd                   	std    
  801437:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801439:	fc                   	cld    
  80143a:	eb 57                	jmp    801493 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80143c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801440:	83 e0 03             	and    $0x3,%eax
  801443:	48 85 c0             	test   %rax,%rax
  801446:	75 36                	jne    80147e <memmove+0xfc>
  801448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144c:	83 e0 03             	and    $0x3,%eax
  80144f:	48 85 c0             	test   %rax,%rax
  801452:	75 2a                	jne    80147e <memmove+0xfc>
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 1e                	jne    80147e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	48 c1 e8 02          	shr    $0x2,%rax
  801468:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80146b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801473:	48 89 c7             	mov    %rax,%rdi
  801476:	48 89 d6             	mov    %rdx,%rsi
  801479:	fc                   	cld    
  80147a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80147c:	eb 15                	jmp    801493 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80147e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801482:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801486:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80148a:	48 89 c7             	mov    %rax,%rdi
  80148d:	48 89 d6             	mov    %rdx,%rsi
  801490:	fc                   	cld    
  801491:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801497:	c9                   	leaveq 
  801498:	c3                   	retq   

0000000000801499 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801499:	55                   	push   %rbp
  80149a:	48 89 e5             	mov    %rsp,%rbp
  80149d:	48 83 ec 18          	sub    $0x18,%rsp
  8014a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b9:	48 89 ce             	mov    %rcx,%rsi
  8014bc:	48 89 c7             	mov    %rax,%rdi
  8014bf:	48 b8 82 13 80 00 00 	movabs $0x801382,%rax
  8014c6:	00 00 00 
  8014c9:	ff d0                	callq  *%rax
}
  8014cb:	c9                   	leaveq 
  8014cc:	c3                   	retq   

00000000008014cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014cd:	55                   	push   %rbp
  8014ce:	48 89 e5             	mov    %rsp,%rbp
  8014d1:	48 83 ec 28          	sub    $0x28,%rsp
  8014d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f1:	eb 36                	jmp    801529 <memcmp+0x5c>
		if (*s1 != *s2)
  8014f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f7:	0f b6 10             	movzbl (%rax),%edx
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	38 c2                	cmp    %al,%dl
  801503:	74 1a                	je     80151f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	0f b6 c0             	movzbl %al,%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
  80151d:	eb 20                	jmp    80153f <memcmp+0x72>
		s1++, s2++;
  80151f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801524:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801531:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801535:	48 85 c0             	test   %rax,%rax
  801538:	75 b9                	jne    8014f3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153f:	c9                   	leaveq 
  801540:	c3                   	retq   

0000000000801541 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801541:	55                   	push   %rbp
  801542:	48 89 e5             	mov    %rsp,%rbp
  801545:	48 83 ec 28          	sub    $0x28,%rsp
  801549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801550:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80155c:	48 01 d0             	add    %rdx,%rax
  80155f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801563:	eb 15                	jmp    80157a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801569:	0f b6 10             	movzbl (%rax),%edx
  80156c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80156f:	38 c2                	cmp    %al,%dl
  801571:	75 02                	jne    801575 <memfind+0x34>
			break;
  801573:	eb 0f                	jmp    801584 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801575:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80157a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801582:	72 e1                	jb     801565 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801588:	c9                   	leaveq 
  801589:	c3                   	retq   

000000000080158a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80158a:	55                   	push   %rbp
  80158b:	48 89 e5             	mov    %rsp,%rbp
  80158e:	48 83 ec 34          	sub    $0x34,%rsp
  801592:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801596:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80159a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80159d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015a4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015ab:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ac:	eb 05                	jmp    8015b3 <strtol+0x29>
		s++;
  8015ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	3c 20                	cmp    $0x20,%al
  8015bc:	74 f0                	je     8015ae <strtol+0x24>
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	0f b6 00             	movzbl (%rax),%eax
  8015c5:	3c 09                	cmp    $0x9,%al
  8015c7:	74 e5                	je     8015ae <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	0f b6 00             	movzbl (%rax),%eax
  8015d0:	3c 2b                	cmp    $0x2b,%al
  8015d2:	75 07                	jne    8015db <strtol+0x51>
		s++;
  8015d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d9:	eb 17                	jmp    8015f2 <strtol+0x68>
	else if (*s == '-')
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	3c 2d                	cmp    $0x2d,%al
  8015e4:	75 0c                	jne    8015f2 <strtol+0x68>
		s++, neg = 1;
  8015e6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015eb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f6:	74 06                	je     8015fe <strtol+0x74>
  8015f8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015fc:	75 28                	jne    801626 <strtol+0x9c>
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 30                	cmp    $0x30,%al
  801607:	75 1d                	jne    801626 <strtol+0x9c>
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	48 83 c0 01          	add    $0x1,%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 78                	cmp    $0x78,%al
  801616:	75 0e                	jne    801626 <strtol+0x9c>
		s += 2, base = 16;
  801618:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80161d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801624:	eb 2c                	jmp    801652 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801626:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80162a:	75 19                	jne    801645 <strtol+0xbb>
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	3c 30                	cmp    $0x30,%al
  801635:	75 0e                	jne    801645 <strtol+0xbb>
		s++, base = 8;
  801637:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801643:	eb 0d                	jmp    801652 <strtol+0xc8>
	else if (base == 0)
  801645:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801649:	75 07                	jne    801652 <strtol+0xc8>
		base = 10;
  80164b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	3c 2f                	cmp    $0x2f,%al
  80165b:	7e 1d                	jle    80167a <strtol+0xf0>
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	3c 39                	cmp    $0x39,%al
  801666:	7f 12                	jg     80167a <strtol+0xf0>
			dig = *s - '0';
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	0f be c0             	movsbl %al,%eax
  801672:	83 e8 30             	sub    $0x30,%eax
  801675:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801678:	eb 4e                	jmp    8016c8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	0f b6 00             	movzbl (%rax),%eax
  801681:	3c 60                	cmp    $0x60,%al
  801683:	7e 1d                	jle    8016a2 <strtol+0x118>
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	0f b6 00             	movzbl (%rax),%eax
  80168c:	3c 7a                	cmp    $0x7a,%al
  80168e:	7f 12                	jg     8016a2 <strtol+0x118>
			dig = *s - 'a' + 10;
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	0f be c0             	movsbl %al,%eax
  80169a:	83 e8 57             	sub    $0x57,%eax
  80169d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a0:	eb 26                	jmp    8016c8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	3c 40                	cmp    $0x40,%al
  8016ab:	7e 48                	jle    8016f5 <strtol+0x16b>
  8016ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 3d                	jg     8016f5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bc:	0f b6 00             	movzbl (%rax),%eax
  8016bf:	0f be c0             	movsbl %al,%eax
  8016c2:	83 e8 37             	sub    $0x37,%eax
  8016c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016cb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016ce:	7c 02                	jl     8016d2 <strtol+0x148>
			break;
  8016d0:	eb 23                	jmp    8016f5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016da:	48 98                	cltq   
  8016dc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e1:	48 89 c2             	mov    %rax,%rdx
  8016e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e7:	48 98                	cltq   
  8016e9:	48 01 d0             	add    %rdx,%rax
  8016ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016f0:	e9 5d ff ff ff       	jmpq   801652 <strtol+0xc8>

	if (endptr)
  8016f5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016fa:	74 0b                	je     801707 <strtol+0x17d>
		*endptr = (char *) s;
  8016fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801700:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801704:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801707:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80170b:	74 09                	je     801716 <strtol+0x18c>
  80170d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801711:	48 f7 d8             	neg    %rax
  801714:	eb 04                	jmp    80171a <strtol+0x190>
  801716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80171a:	c9                   	leaveq 
  80171b:	c3                   	retq   

000000000080171c <strstr>:

char * strstr(const char *in, const char *str)
{
  80171c:	55                   	push   %rbp
  80171d:	48 89 e5             	mov    %rsp,%rbp
  801720:	48 83 ec 30          	sub    $0x30,%rsp
  801724:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801728:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80172c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801730:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801734:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80173e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801742:	75 06                	jne    80174a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801748:	eb 6b                	jmp    8017b5 <strstr+0x99>

	len = strlen(str);
  80174a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174e:	48 89 c7             	mov    %rax,%rdi
  801751:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  801758:	00 00 00 
  80175b:	ff d0                	callq  *%rax
  80175d:	48 98                	cltq   
  80175f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801767:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801775:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801779:	75 07                	jne    801782 <strstr+0x66>
				return (char *) 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	eb 33                	jmp    8017b5 <strstr+0x99>
		} while (sc != c);
  801782:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801786:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801789:	75 d8                	jne    801763 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80178b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	48 89 ce             	mov    %rcx,%rsi
  80179a:	48 89 c7             	mov    %rax,%rdi
  80179d:	48 b8 13 12 80 00 00 	movabs $0x801213,%rax
  8017a4:	00 00 00 
  8017a7:	ff d0                	callq  *%rax
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	75 b6                	jne    801763 <strstr+0x47>

	return (char *) (in - 1);
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	48 83 e8 01          	sub    $0x1,%rax
}
  8017b5:	c9                   	leaveq 
  8017b6:	c3                   	retq   

00000000008017b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017b7:	55                   	push   %rbp
  8017b8:	48 89 e5             	mov    %rsp,%rbp
  8017bb:	53                   	push   %rbx
  8017bc:	48 83 ec 48          	sub    $0x48,%rsp
  8017c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017c3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017c6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ca:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017ce:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017d2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017dd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017e1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017e5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017e9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017ed:	4c 89 c3             	mov    %r8,%rbx
  8017f0:	cd 30                	int    $0x30
  8017f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017fa:	74 3e                	je     80183a <syscall+0x83>
  8017fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801801:	7e 37                	jle    80183a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801807:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80180a:	49 89 d0             	mov    %rdx,%r8
  80180d:	89 c1                	mov    %eax,%ecx
  80180f:	48 ba e8 27 80 00 00 	movabs $0x8027e8,%rdx
  801816:	00 00 00 
  801819:	be 23 00 00 00       	mov    $0x23,%esi
  80181e:	48 bf 05 28 80 00 00 	movabs $0x802805,%rdi
  801825:	00 00 00 
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
  80182d:	49 b9 5d 02 80 00 00 	movabs $0x80025d,%r9
  801834:	00 00 00 
  801837:	41 ff d1             	callq  *%r9

	return ret;
  80183a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183e:	48 83 c4 48          	add    $0x48,%rsp
  801842:	5b                   	pop    %rbx
  801843:	5d                   	pop    %rbp
  801844:	c3                   	retq   

0000000000801845 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801845:	55                   	push   %rbp
  801846:	48 89 e5             	mov    %rsp,%rbp
  801849:	48 83 ec 20          	sub    $0x20,%rsp
  80184d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801851:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801859:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801864:	00 
  801865:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801871:	48 89 d1             	mov    %rdx,%rcx
  801874:	48 89 c2             	mov    %rax,%rdx
  801877:	be 00 00 00 00       	mov    $0x0,%esi
  80187c:	bf 00 00 00 00       	mov    $0x0,%edi
  801881:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801888:	00 00 00 
  80188b:	ff d0                	callq  *%rax
}
  80188d:	c9                   	leaveq 
  80188e:	c3                   	retq   

000000000080188f <sys_cgetc>:

int
sys_cgetc(void)
{
  80188f:	55                   	push   %rbp
  801890:	48 89 e5             	mov    %rsp,%rbp
  801893:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801897:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189e:	00 
  80189f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b5:	be 00 00 00 00       	mov    $0x0,%esi
  8018ba:	bf 01 00 00 00       	mov    $0x1,%edi
  8018bf:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  8018c6:	00 00 00 
  8018c9:	ff d0                	callq  *%rax
}
  8018cb:	c9                   	leaveq 
  8018cc:	c3                   	retq   

00000000008018cd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018cd:	55                   	push   %rbp
  8018ce:	48 89 e5             	mov    %rsp,%rbp
  8018d1:	48 83 ec 10          	sub    $0x10,%rsp
  8018d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018db:	48 98                	cltq   
  8018dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e4:	00 
  8018e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f6:	48 89 c2             	mov    %rax,%rdx
  8018f9:	be 01 00 00 00       	mov    $0x1,%esi
  8018fe:	bf 03 00 00 00       	mov    $0x3,%edi
  801903:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801919:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801920:	00 
  801921:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801927:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801932:	ba 00 00 00 00       	mov    $0x0,%edx
  801937:	be 00 00 00 00       	mov    $0x0,%esi
  80193c:	bf 02 00 00 00       	mov    $0x2,%edi
  801941:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801948:	00 00 00 
  80194b:	ff d0                	callq  *%rax
}
  80194d:	c9                   	leaveq 
  80194e:	c3                   	retq   

000000000080194f <sys_yield>:

void
sys_yield(void)
{
  80194f:	55                   	push   %rbp
  801950:	48 89 e5             	mov    %rsp,%rbp
  801953:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801957:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195e:	00 
  80195f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801970:	ba 00 00 00 00       	mov    $0x0,%edx
  801975:	be 00 00 00 00       	mov    $0x0,%esi
  80197a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80197f:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 20          	sub    $0x20,%rsp
  801995:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801998:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80199c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80199f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a2:	48 63 c8             	movslq %eax,%rcx
  8019a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ac:	48 98                	cltq   
  8019ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b5:	00 
  8019b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bc:	49 89 c8             	mov    %rcx,%r8
  8019bf:	48 89 d1             	mov    %rdx,%rcx
  8019c2:	48 89 c2             	mov    %rax,%rdx
  8019c5:	be 01 00 00 00       	mov    $0x1,%esi
  8019ca:	bf 04 00 00 00       	mov    $0x4,%edi
  8019cf:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  8019d6:	00 00 00 
  8019d9:	ff d0                	callq  *%rax
}
  8019db:	c9                   	leaveq 
  8019dc:	c3                   	retq   

00000000008019dd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019dd:	55                   	push   %rbp
  8019de:	48 89 e5             	mov    %rsp,%rbp
  8019e1:	48 83 ec 30          	sub    $0x30,%rsp
  8019e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ec:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019ef:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019f7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019fa:	48 63 c8             	movslq %eax,%rcx
  8019fd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a04:	48 63 f0             	movslq %eax,%rsi
  801a07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0e:	48 98                	cltq   
  801a10:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a14:	49 89 f9             	mov    %rdi,%r9
  801a17:	49 89 f0             	mov    %rsi,%r8
  801a1a:	48 89 d1             	mov    %rdx,%rcx
  801a1d:	48 89 c2             	mov    %rax,%rdx
  801a20:	be 01 00 00 00       	mov    $0x1,%esi
  801a25:	bf 05 00 00 00       	mov    $0x5,%edi
  801a2a:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 20          	sub    $0x20,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4e:	48 98                	cltq   
  801a50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a57:	00 
  801a58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a64:	48 89 d1             	mov    %rdx,%rcx
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	be 01 00 00 00       	mov    $0x1,%esi
  801a6f:	bf 06 00 00 00       	mov    $0x6,%edi
  801a74:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 10          	sub    $0x10,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a93:	48 63 d0             	movslq %eax,%rdx
  801a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a99:	48 98                	cltq   
  801a9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa2:	00 
  801aa3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aaf:	48 89 d1             	mov    %rdx,%rcx
  801ab2:	48 89 c2             	mov    %rax,%rdx
  801ab5:	be 01 00 00 00       	mov    $0x1,%esi
  801aba:	bf 08 00 00 00       	mov    $0x8,%edi
  801abf:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801ac6:	00 00 00 
  801ac9:	ff d0                	callq  *%rax
}
  801acb:	c9                   	leaveq 
  801acc:	c3                   	retq   

0000000000801acd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801acd:	55                   	push   %rbp
  801ace:	48 89 e5             	mov    %rsp,%rbp
  801ad1:	48 83 ec 20          	sub    $0x20,%rsp
  801ad5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801adc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae3:	48 98                	cltq   
  801ae5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aec:	00 
  801aed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af9:	48 89 d1             	mov    %rdx,%rcx
  801afc:	48 89 c2             	mov    %rax,%rdx
  801aff:	be 01 00 00 00       	mov    $0x1,%esi
  801b04:	bf 09 00 00 00       	mov    $0x9,%edi
  801b09:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 20          	sub    $0x20,%rsp
  801b1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b26:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b2a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b30:	48 63 f0             	movslq %eax,%rsi
  801b33:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3a:	48 98                	cltq   
  801b3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b47:	00 
  801b48:	49 89 f1             	mov    %rsi,%r9
  801b4b:	49 89 c8             	mov    %rcx,%r8
  801b4e:	48 89 d1             	mov    %rdx,%rcx
  801b51:	48 89 c2             	mov    %rax,%rdx
  801b54:	be 00 00 00 00       	mov    $0x0,%esi
  801b59:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b5e:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	callq  *%rax
}
  801b6a:	c9                   	leaveq 
  801b6b:	c3                   	retq   

0000000000801b6c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b6c:	55                   	push   %rbp
  801b6d:	48 89 e5             	mov    %rsp,%rbp
  801b70:	48 83 ec 10          	sub    $0x10,%rsp
  801b74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b83:	00 
  801b84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b90:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b95:	48 89 c2             	mov    %rax,%rdx
  801b98:	be 01 00 00 00       	mov    $0x1,%esi
  801b9d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ba2:	48 b8 b7 17 80 00 00 	movabs $0x8017b7,%rax
  801ba9:	00 00 00 
  801bac:	ff d0                	callq  *%rax
}
  801bae:	c9                   	leaveq 
  801baf:	c3                   	retq   

0000000000801bb0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bb0:	55                   	push   %rbp
  801bb1:	48 89 e5             	mov    %rsp,%rbp
  801bb4:	48 83 ec 30          	sub    $0x30,%rsp
  801bb8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc0:	48 8b 00             	mov    (%rax),%rax
  801bc3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801bc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcb:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bcf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801bd2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd5:	83 e0 02             	and    $0x2,%eax
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	75 4d                	jne    801c29 <pgfault+0x79>
  801bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be0:	48 c1 e8 0c          	shr    $0xc,%rax
  801be4:	48 89 c2             	mov    %rax,%rdx
  801be7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bee:	01 00 00 
  801bf1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bf5:	25 00 08 00 00       	and    $0x800,%eax
  801bfa:	48 85 c0             	test   %rax,%rax
  801bfd:	74 2a                	je     801c29 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801bff:	48 ba 18 28 80 00 00 	movabs $0x802818,%rdx
  801c06:	00 00 00 
  801c09:	be 1e 00 00 00       	mov    $0x1e,%esi
  801c0e:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801c15:	00 00 00 
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1d:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801c24:	00 00 00 
  801c27:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801c29:	ba 07 00 00 00       	mov    $0x7,%edx
  801c2e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c33:	bf 00 00 00 00       	mov    $0x0,%edi
  801c38:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	callq  *%rax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	0f 85 cd 00 00 00    	jne    801d19 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c58:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c66:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c6b:	48 89 c6             	mov    %rax,%rsi
  801c6e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c73:	48 b8 82 13 80 00 00 	movabs $0x801382,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c83:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c89:	48 89 c1             	mov    %rax,%rcx
  801c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c91:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c96:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9b:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801ca2:	00 00 00 
  801ca5:	ff d0                	callq  *%rax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	79 2a                	jns    801cd5 <pgfault+0x125>
				panic("Page map at temp address failed");
  801cab:	48 ba 48 28 80 00 00 	movabs $0x802848,%rdx
  801cb2:	00 00 00 
  801cb5:	be 2f 00 00 00       	mov    $0x2f,%esi
  801cba:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801cc1:	00 00 00 
  801cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc9:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801cd0:	00 00 00 
  801cd3:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801cd5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cda:	bf 00 00 00 00       	mov    $0x0,%edi
  801cdf:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	79 54                	jns    801d43 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801cef:	48 ba 68 28 80 00 00 	movabs $0x802868,%rdx
  801cf6:	00 00 00 
  801cf9:	be 31 00 00 00       	mov    $0x31,%esi
  801cfe:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801d05:	00 00 00 
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801d14:	00 00 00 
  801d17:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801d19:	48 ba 90 28 80 00 00 	movabs $0x802890,%rdx
  801d20:	00 00 00 
  801d23:	be 35 00 00 00       	mov    $0x35,%esi
  801d28:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801d2f:	00 00 00 
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801d3e:	00 00 00 
  801d41:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801d43:	c9                   	leaveq 
  801d44:	c3                   	retq   

0000000000801d45 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d45:	55                   	push   %rbp
  801d46:	48 89 e5             	mov    %rsp,%rbp
  801d49:	48 83 ec 20          	sub    $0x20,%rsp
  801d4d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d50:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  801d53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d5a:	01 00 00 
  801d5d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d64:	25 07 0e 00 00       	and    $0xe07,%eax
  801d69:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d6c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d6f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  801d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7a:	25 00 04 00 00       	and    $0x400,%eax
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	74 57                	je     801dda <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d83:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d86:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d8a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d91:	41 89 f0             	mov    %esi,%r8d
  801d94:	48 89 c6             	mov    %rax,%rsi
  801d97:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9c:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
  801da8:	85 c0                	test   %eax,%eax
  801daa:	0f 8e 52 01 00 00    	jle    801f02 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  801db0:	48 ba bd 28 80 00 00 	movabs $0x8028bd,%rdx
  801db7:	00 00 00 
  801dba:	be 52 00 00 00       	mov    $0x52,%esi
  801dbf:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801dc6:	00 00 00 
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801dd5:	00 00 00 
  801dd8:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  801dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddd:	83 e0 02             	and    $0x2,%eax
  801de0:	85 c0                	test   %eax,%eax
  801de2:	75 10                	jne    801df4 <duppage+0xaf>
  801de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de7:	25 00 08 00 00       	and    $0x800,%eax
  801dec:	85 c0                	test   %eax,%eax
  801dee:	0f 84 bb 00 00 00    	je     801eaf <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  801df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df7:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801dfc:	80 cc 08             	or     $0x8,%ah
  801dff:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e02:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e05:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e09:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e10:	41 89 f0             	mov    %esi,%r8d
  801e13:	48 89 c6             	mov    %rax,%rsi
  801e16:	bf 00 00 00 00       	mov    $0x0,%edi
  801e1b:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax
  801e27:	85 c0                	test   %eax,%eax
  801e29:	7e 2a                	jle    801e55 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  801e2b:	48 ba bd 28 80 00 00 	movabs $0x8028bd,%rdx
  801e32:	00 00 00 
  801e35:	be 5a 00 00 00       	mov    $0x5a,%esi
  801e3a:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801e41:	00 00 00 
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801e50:	00 00 00 
  801e53:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e55:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e60:	41 89 c8             	mov    %ecx,%r8d
  801e63:	48 89 d1             	mov    %rdx,%rcx
  801e66:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6b:	48 89 c6             	mov    %rax,%rsi
  801e6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801e73:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801e7a:	00 00 00 
  801e7d:	ff d0                	callq  *%rax
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	7e 2a                	jle    801ead <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  801e83:	48 ba bd 28 80 00 00 	movabs $0x8028bd,%rdx
  801e8a:	00 00 00 
  801e8d:	be 5d 00 00 00       	mov    $0x5d,%esi
  801e92:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801e99:	00 00 00 
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801ea8:	00 00 00 
  801eab:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ead:	eb 53                	jmp    801f02 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  801eaf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eb2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801eb6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ebd:	41 89 f0             	mov    %esi,%r8d
  801ec0:	48 89 c6             	mov    %rax,%rsi
  801ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec8:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	7e 2a                	jle    801f02 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  801ed8:	48 ba bd 28 80 00 00 	movabs $0x8028bd,%rdx
  801edf:	00 00 00 
  801ee2:	be 61 00 00 00       	mov    $0x61,%esi
  801ee7:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801eee:	00 00 00 
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  801efd:	00 00 00 
  801f00:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  801f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f07:	c9                   	leaveq 
  801f08:	c3                   	retq   

0000000000801f09 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f09:	55                   	push   %rbp
  801f0a:	48 89 e5             	mov    %rsp,%rbp
  801f0d:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  801f11:	48 bf b0 1b 80 00 00 	movabs $0x801bb0,%rdi
  801f18:	00 00 00 
  801f1b:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f27:	b8 07 00 00 00       	mov    $0x7,%eax
  801f2c:	cd 30                	int    $0x30
  801f2e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f31:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f34:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  801f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f3b:	79 30                	jns    801f6d <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f3d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f40:	89 c1                	mov    %eax,%ecx
  801f42:	48 ba db 28 80 00 00 	movabs $0x8028db,%rdx
  801f49:	00 00 00 
  801f4c:	be 89 00 00 00       	mov    $0x89,%esi
  801f51:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  801f58:	00 00 00 
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	49 b8 5d 02 80 00 00 	movabs $0x80025d,%r8
  801f67:	00 00 00 
  801f6a:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  801f6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f71:	75 46                	jne    801fb9 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f73:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  801f7a:	00 00 00 
  801f7d:	ff d0                	callq  *%rax
  801f7f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f84:	48 63 d0             	movslq %eax,%rdx
  801f87:	48 89 d0             	mov    %rdx,%rax
  801f8a:	48 c1 e0 03          	shl    $0x3,%rax
  801f8e:	48 01 d0             	add    %rdx,%rax
  801f91:	48 c1 e0 05          	shl    $0x5,%rax
  801f95:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f9c:	00 00 00 
  801f9f:	48 01 c2             	add    %rax,%rdx
  801fa2:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801fa9:	00 00 00 
  801fac:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	e9 d1 01 00 00       	jmpq   80218a <fork+0x281>
	}

	uint64_t ad = 0;
  801fb9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801fc0:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  801fc1:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fca:	e9 df 00 00 00       	jmpq   8020ae <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd3:	48 c1 e8 27          	shr    $0x27,%rax
  801fd7:	48 89 c2             	mov    %rax,%rdx
  801fda:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fe1:	01 00 00 
  801fe4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe8:	83 e0 01             	and    $0x1,%eax
  801feb:	48 85 c0             	test   %rax,%rax
  801fee:	0f 84 9e 00 00 00    	je     802092 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801ff4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff8:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ffc:	48 89 c2             	mov    %rax,%rdx
  801fff:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802006:	01 00 00 
  802009:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80200d:	83 e0 01             	and    $0x1,%eax
  802010:	48 85 c0             	test   %rax,%rax
  802013:	74 73                	je     802088 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802019:	48 c1 e8 15          	shr    $0x15,%rax
  80201d:	48 89 c2             	mov    %rax,%rdx
  802020:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802027:	01 00 00 
  80202a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202e:	83 e0 01             	and    $0x1,%eax
  802031:	48 85 c0             	test   %rax,%rax
  802034:	74 48                	je     80207e <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802036:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80203a:	48 c1 e8 0c          	shr    $0xc,%rax
  80203e:	48 89 c2             	mov    %rax,%rdx
  802041:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802048:	01 00 00 
  80204b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802057:	83 e0 01             	and    $0x1,%eax
  80205a:	48 85 c0             	test   %rax,%rax
  80205d:	74 47                	je     8020a6 <fork+0x19d>
						duppage(envid, VPN(addr));
  80205f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802063:	48 c1 e8 0c          	shr    $0xc,%rax
  802067:	89 c2                	mov    %eax,%edx
  802069:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80206c:	89 d6                	mov    %edx,%esi
  80206e:	89 c7                	mov    %eax,%edi
  802070:	48 b8 45 1d 80 00 00 	movabs $0x801d45,%rax
  802077:	00 00 00 
  80207a:	ff d0                	callq  *%rax
  80207c:	eb 28                	jmp    8020a6 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  80207e:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802085:	00 
  802086:	eb 1e                	jmp    8020a6 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802088:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80208f:	40 
  802090:	eb 14                	jmp    8020a6 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802096:	48 c1 e8 27          	shr    $0x27,%rax
  80209a:	48 83 c0 01          	add    $0x1,%rax
  80209e:	48 c1 e0 27          	shl    $0x27,%rax
  8020a2:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8020a6:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020ad:	00 
  8020ae:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020b5:	00 
  8020b6:	0f 87 13 ff ff ff    	ja     801fcf <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8020bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020bf:	ba 07 00 00 00       	mov    $0x7,%edx
  8020c4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020c9:	89 c7                	mov    %eax,%edi
  8020cb:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  8020d2:	00 00 00 
  8020d5:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8020d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020da:	ba 07 00 00 00       	mov    $0x7,%edx
  8020df:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020e4:	89 c7                	mov    %eax,%edi
  8020e6:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8020f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020fb:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802100:	ba 00 00 00 00       	mov    $0x0,%edx
  802105:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80210a:	89 c7                	mov    %eax,%edi
  80210c:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  802113:	00 00 00 
  802116:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802118:	ba 00 10 00 00       	mov    $0x1000,%edx
  80211d:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802122:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802127:	48 b8 82 13 80 00 00 	movabs $0x801382,%rax
  80212e:	00 00 00 
  802131:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802133:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802138:	bf 00 00 00 00       	mov    $0x0,%edi
  80213d:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802149:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  802150:	00 00 00 
  802153:	48 8b 00             	mov    (%rax),%rax
  802156:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80215d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802160:	48 89 d6             	mov    %rdx,%rsi
  802163:	89 c7                	mov    %eax,%edi
  802165:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  80216c:	00 00 00 
  80216f:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802171:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802174:	be 02 00 00 00       	mov    $0x2,%esi
  802179:	89 c7                	mov    %eax,%edi
  80217b:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  802182:	00 00 00 
  802185:	ff d0                	callq  *%rax

	return envid;
  802187:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80218a:	c9                   	leaveq 
  80218b:	c3                   	retq   

000000000080218c <sfork>:

// Challenge!
int
sfork(void)
{
  80218c:	55                   	push   %rbp
  80218d:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802190:	48 ba f3 28 80 00 00 	movabs $0x8028f3,%rdx
  802197:	00 00 00 
  80219a:	be b8 00 00 00       	mov    $0xb8,%esi
  80219f:	48 bf 3d 28 80 00 00 	movabs $0x80283d,%rdi
  8021a6:	00 00 00 
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  8021b5:	00 00 00 
  8021b8:	ff d1                	callq  *%rcx

00000000008021ba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 10          	sub    $0x10,%rsp
  8021c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8021c6:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  8021cd:	00 00 00 
  8021d0:	48 8b 00             	mov    (%rax),%rax
  8021d3:	48 85 c0             	test   %rax,%rax
  8021d6:	75 49                	jne    802221 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8021d8:	ba 07 00 00 00       	mov    $0x7,%edx
  8021dd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8021e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e7:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	79 2a                	jns    802221 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8021f7:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  8021fe:	00 00 00 
  802201:	be 21 00 00 00       	mov    $0x21,%esi
  802206:	48 bf 3b 29 80 00 00 	movabs $0x80293b,%rdi
  80220d:	00 00 00 
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
  802215:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  80221c:	00 00 00 
  80221f:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802221:	48 b8 18 30 80 00 00 	movabs $0x803018,%rax
  802228:	00 00 00 
  80222b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80222f:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802232:	48 be 7d 22 80 00 00 	movabs $0x80227d,%rsi
  802239:	00 00 00 
  80223c:	bf 00 00 00 00       	mov    $0x0,%edi
  802241:	48 b8 cd 1a 80 00 00 	movabs $0x801acd,%rax
  802248:	00 00 00 
  80224b:	ff d0                	callq  *%rax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	79 2a                	jns    80227b <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  802251:	48 ba 50 29 80 00 00 	movabs $0x802950,%rdx
  802258:	00 00 00 
  80225b:	be 27 00 00 00       	mov    $0x27,%esi
  802260:	48 bf 3b 29 80 00 00 	movabs $0x80293b,%rdi
  802267:	00 00 00 
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	48 b9 5d 02 80 00 00 	movabs $0x80025d,%rcx
  802276:	00 00 00 
  802279:	ff d1                	callq  *%rcx
}
  80227b:	c9                   	leaveq 
  80227c:	c3                   	retq   

000000000080227d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80227d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  802280:	48 a1 18 30 80 00 00 	movabs 0x803018,%rax
  802287:	00 00 00 
call *%rax
  80228a:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  80228c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802293:	00 
    movq 152(%rsp), %rcx
  802294:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  80229b:	00 
    subq $8, %rcx
  80229c:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  8022a0:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  8022a3:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8022aa:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  8022ab:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8022af:	4c 8b 3c 24          	mov    (%rsp),%r15
  8022b3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8022b8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8022bd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8022c2:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8022c7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8022cc:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8022d1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8022d6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8022db:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8022e0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8022e5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8022ea:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8022ef:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8022f4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8022f9:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  8022fd:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  802301:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  802302:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  802303:	c3                   	retq   
