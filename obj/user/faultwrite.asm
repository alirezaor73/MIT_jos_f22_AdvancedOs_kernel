
obj/user/faultwrite:     file format elf64-x86-64


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
  80003c:	e8 1e 00 00 00       	callq  80005f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	*(unsigned*)0 = 0;
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80005d:	c9                   	leaveq 
  80005e:	c3                   	retq   

000000000080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %rbp
  800060:	48 89 e5             	mov    %rsp,%rbp
  800063:	48 83 ec 10          	sub    $0x10,%rsp
  800067:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80006a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80006e:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800075:	00 00 00 
  800078:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	7e 14                	jle    800099 <libmain+0x3a>
		binaryname = argv[0];
  800085:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800089:	48 8b 10             	mov    (%rax),%rdx
  80008c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800093:	00 00 00 
  800096:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800099:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	48 89 d6             	mov    %rdx,%rsi
  8000a3:	89 c7                	mov    %eax,%edi
  8000a5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ac:	00 00 00 
  8000af:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000b1:	48 b8 bf 00 80 00 00 	movabs $0x8000bf,%rax
  8000b8:	00 00 00 
  8000bb:	ff d0                	callq  *%rax
}
  8000bd:	c9                   	leaveq 
  8000be:	c3                   	retq   

00000000008000bf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bf:	55                   	push   %rbp
  8000c0:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8000c8:	48 b8 ec 01 80 00 00 	movabs $0x8001ec,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
}
  8000d4:	5d                   	pop    %rbp
  8000d5:	c3                   	retq   

00000000008000d6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000d6:	55                   	push   %rbp
  8000d7:	48 89 e5             	mov    %rsp,%rbp
  8000da:	53                   	push   %rbx
  8000db:	48 83 ec 48          	sub    $0x48,%rsp
  8000df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000e2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000e5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000e9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000ed:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000f1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8000f8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8000fc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800100:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800104:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800108:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80010c:	4c 89 c3             	mov    %r8,%rbx
  80010f:	cd 30                	int    $0x30
  800111:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800115:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800119:	74 3e                	je     800159 <syscall+0x83>
  80011b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800120:	7e 37                	jle    800159 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800122:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800126:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800129:	49 89 d0             	mov    %rdx,%r8
  80012c:	89 c1                	mov    %eax,%ecx
  80012e:	48 ba ea 17 80 00 00 	movabs $0x8017ea,%rdx
  800135:	00 00 00 
  800138:	be 23 00 00 00       	mov    $0x23,%esi
  80013d:	48 bf 07 18 80 00 00 	movabs $0x801807,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	49 b9 6e 02 80 00 00 	movabs $0x80026e,%r9
  800153:	00 00 00 
  800156:	41 ff d1             	callq  *%r9

	return ret;
  800159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80015d:	48 83 c4 48          	add    $0x48,%rsp
  800161:	5b                   	pop    %rbx
  800162:	5d                   	pop    %rbp
  800163:	c3                   	retq   

0000000000800164 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800164:	55                   	push   %rbp
  800165:	48 89 e5             	mov    %rsp,%rbp
  800168:	48 83 ec 20          	sub    $0x20,%rsp
  80016c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800178:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80017c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800183:	00 
  800184:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80018a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800190:	48 89 d1             	mov    %rdx,%rcx
  800193:	48 89 c2             	mov    %rax,%rdx
  800196:	be 00 00 00 00       	mov    $0x0,%esi
  80019b:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a0:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
}
  8001ac:	c9                   	leaveq 
  8001ad:	c3                   	retq   

00000000008001ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ae:	55                   	push   %rbp
  8001af:	48 89 e5             	mov    %rsp,%rbp
  8001b2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001bd:	00 
  8001be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8001d4:	be 00 00 00 00       	mov    $0x0,%esi
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
  8001de:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
}
  8001ea:	c9                   	leaveq 
  8001eb:	c3                   	retq   

00000000008001ec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001ec:	55                   	push   %rbp
  8001ed:	48 89 e5             	mov    %rsp,%rbp
  8001f0:	48 83 ec 10          	sub    $0x10,%rsp
  8001f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001fa:	48 98                	cltq   
  8001fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800203:	00 
  800204:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800210:	b9 00 00 00 00       	mov    $0x0,%ecx
  800215:	48 89 c2             	mov    %rax,%rdx
  800218:	be 01 00 00 00       	mov    $0x1,%esi
  80021d:	bf 03 00 00 00       	mov    $0x3,%edi
  800222:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
}
  80022e:	c9                   	leaveq 
  80022f:	c3                   	retq   

0000000000800230 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800238:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80023f:	00 
  800240:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800246:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800251:	ba 00 00 00 00       	mov    $0x0,%edx
  800256:	be 00 00 00 00       	mov    $0x0,%esi
  80025b:	bf 02 00 00 00       	mov    $0x2,%edi
  800260:	48 b8 d6 00 80 00 00 	movabs $0x8000d6,%rax
  800267:	00 00 00 
  80026a:	ff d0                	callq  *%rax
}
  80026c:	c9                   	leaveq 
  80026d:	c3                   	retq   

000000000080026e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80026e:	55                   	push   %rbp
  80026f:	48 89 e5             	mov    %rsp,%rbp
  800272:	53                   	push   %rbx
  800273:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80027a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800281:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800287:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80028e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800295:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80029c:	84 c0                	test   %al,%al
  80029e:	74 23                	je     8002c3 <_panic+0x55>
  8002a0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002a7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002ab:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002af:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002b3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002b7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002bb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002bf:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002c3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002ca:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d1:	00 00 00 
  8002d4:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002db:	00 00 00 
  8002de:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002e9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002fe:	00 00 00 
  800301:	48 8b 18             	mov    (%rax),%rbx
  800304:	48 b8 30 02 80 00 00 	movabs $0x800230,%rax
  80030b:	00 00 00 
  80030e:	ff d0                	callq  *%rax
  800310:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800316:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80031d:	41 89 c8             	mov    %ecx,%r8d
  800320:	48 89 d1             	mov    %rdx,%rcx
  800323:	48 89 da             	mov    %rbx,%rdx
  800326:	89 c6                	mov    %eax,%esi
  800328:	48 bf 18 18 80 00 00 	movabs $0x801818,%rdi
  80032f:	00 00 00 
  800332:	b8 00 00 00 00       	mov    $0x0,%eax
  800337:	49 b9 a7 04 80 00 00 	movabs $0x8004a7,%r9
  80033e:	00 00 00 
  800341:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800344:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80034b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800352:	48 89 d6             	mov    %rdx,%rsi
  800355:	48 89 c7             	mov    %rax,%rdi
  800358:	48 b8 fb 03 80 00 00 	movabs $0x8003fb,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	cprintf("\n");
  800364:	48 bf 3b 18 80 00 00 	movabs $0x80183b,%rdi
  80036b:	00 00 00 
  80036e:	b8 00 00 00 00       	mov    $0x0,%eax
  800373:	48 ba a7 04 80 00 00 	movabs $0x8004a7,%rdx
  80037a:	00 00 00 
  80037d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037f:	cc                   	int3   
  800380:	eb fd                	jmp    80037f <_panic+0x111>

0000000000800382 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800382:	55                   	push   %rbp
  800383:	48 89 e5             	mov    %rsp,%rbp
  800386:	48 83 ec 10          	sub    $0x10,%rsp
  80038a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80038d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800395:	8b 00                	mov    (%rax),%eax
  800397:	8d 48 01             	lea    0x1(%rax),%ecx
  80039a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039e:	89 0a                	mov    %ecx,(%rdx)
  8003a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a3:	89 d1                	mov    %edx,%ecx
  8003a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a9:	48 98                	cltq   
  8003ab:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b3:	8b 00                	mov    (%rax),%eax
  8003b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ba:	75 2c                	jne    8003e8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c0:	8b 00                	mov    (%rax),%eax
  8003c2:	48 98                	cltq   
  8003c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c8:	48 83 c2 08          	add    $0x8,%rdx
  8003cc:	48 89 c6             	mov    %rax,%rsi
  8003cf:	48 89 d7             	mov    %rdx,%rdi
  8003d2:	48 b8 64 01 80 00 00 	movabs $0x800164,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	callq  *%rax
        b->idx = 0;
  8003de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ec:	8b 40 04             	mov    0x4(%rax),%eax
  8003ef:	8d 50 01             	lea    0x1(%rax),%edx
  8003f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003f9:	c9                   	leaveq 
  8003fa:	c3                   	retq   

00000000008003fb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003fb:	55                   	push   %rbp
  8003fc:	48 89 e5             	mov    %rsp,%rbp
  8003ff:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800406:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80040d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800414:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80041b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800422:	48 8b 0a             	mov    (%rdx),%rcx
  800425:	48 89 08             	mov    %rcx,(%rax)
  800428:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800430:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800434:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800438:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80043f:	00 00 00 
    b.cnt = 0;
  800442:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800449:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80044c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800453:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80045a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800461:	48 89 c6             	mov    %rax,%rsi
  800464:	48 bf 82 03 80 00 00 	movabs $0x800382,%rdi
  80046b:	00 00 00 
  80046e:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800475:	00 00 00 
  800478:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80047a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800480:	48 98                	cltq   
  800482:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800489:	48 83 c2 08          	add    $0x8,%rdx
  80048d:	48 89 c6             	mov    %rax,%rsi
  800490:	48 89 d7             	mov    %rdx,%rdi
  800493:	48 b8 64 01 80 00 00 	movabs $0x800164,%rax
  80049a:	00 00 00 
  80049d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80049f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004a5:	c9                   	leaveq 
  8004a6:	c3                   	retq   

00000000008004a7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004a7:	55                   	push   %rbp
  8004a8:	48 89 e5             	mov    %rsp,%rbp
  8004ab:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004b2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004b9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004d5:	84 c0                	test   %al,%al
  8004d7:	74 20                	je     8004f9 <cprintf+0x52>
  8004d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004f9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800500:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800507:	00 00 00 
  80050a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800511:	00 00 00 
  800514:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800518:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80051f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800526:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80052d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800534:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80053b:	48 8b 0a             	mov    (%rdx),%rcx
  80053e:	48 89 08             	mov    %rcx,(%rax)
  800541:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800545:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800549:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80054d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800551:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800558:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80055f:	48 89 d6             	mov    %rdx,%rsi
  800562:	48 89 c7             	mov    %rax,%rdi
  800565:	48 b8 fb 03 80 00 00 	movabs $0x8003fb,%rax
  80056c:	00 00 00 
  80056f:	ff d0                	callq  *%rax
  800571:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800577:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80057d:	c9                   	leaveq 
  80057e:	c3                   	retq   

000000000080057f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057f:	55                   	push   %rbp
  800580:	48 89 e5             	mov    %rsp,%rbp
  800583:	53                   	push   %rbx
  800584:	48 83 ec 38          	sub    $0x38,%rsp
  800588:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80058c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800590:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800594:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800597:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80059b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005a2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005a6:	77 3b                	ja     8005e3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005ab:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005af:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	48 f7 f3             	div    %rbx
  8005be:	48 89 c2             	mov    %rax,%rdx
  8005c1:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005c4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c7:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cf:	41 89 f9             	mov    %edi,%r9d
  8005d2:	48 89 c7             	mov    %rax,%rdi
  8005d5:	48 b8 7f 05 80 00 00 	movabs $0x80057f,%rax
  8005dc:	00 00 00 
  8005df:	ff d0                	callq  *%rax
  8005e1:	eb 1e                	jmp    800601 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e3:	eb 12                	jmp    8005f7 <printnum+0x78>
			putch(padc, putdat);
  8005e5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f0:	48 89 ce             	mov    %rcx,%rsi
  8005f3:	89 d7                	mov    %edx,%edi
  8005f5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005fb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005ff:	7f e4                	jg     8005e5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800601:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800608:	ba 00 00 00 00       	mov    $0x0,%edx
  80060d:	48 f7 f1             	div    %rcx
  800610:	48 89 d0             	mov    %rdx,%rax
  800613:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  80061a:	00 00 00 
  80061d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800621:	0f be d0             	movsbl %al,%edx
  800624:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	48 89 ce             	mov    %rcx,%rsi
  80062f:	89 d7                	mov    %edx,%edi
  800631:	ff d0                	callq  *%rax
}
  800633:	48 83 c4 38          	add    $0x38,%rsp
  800637:	5b                   	pop    %rbx
  800638:	5d                   	pop    %rbp
  800639:	c3                   	retq   

000000000080063a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063a:	55                   	push   %rbp
  80063b:	48 89 e5             	mov    %rsp,%rbp
  80063e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800642:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800646:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800649:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80064d:	7e 52                	jle    8006a1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	83 f8 30             	cmp    $0x30,%eax
  800658:	73 24                	jae    80067e <getuint+0x44>
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	8b 00                	mov    (%rax),%eax
  800668:	89 c0                	mov    %eax,%eax
  80066a:	48 01 d0             	add    %rdx,%rax
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	8b 12                	mov    (%rdx),%edx
  800673:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	89 0a                	mov    %ecx,(%rdx)
  80067c:	eb 17                	jmp    800695 <getuint+0x5b>
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800686:	48 89 d0             	mov    %rdx,%rax
  800689:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800691:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800695:	48 8b 00             	mov    (%rax),%rax
  800698:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069c:	e9 a3 00 00 00       	jmpq   800744 <getuint+0x10a>
	else if (lflag)
  8006a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a5:	74 4f                	je     8006f6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	8b 00                	mov    (%rax),%eax
  8006ad:	83 f8 30             	cmp    $0x30,%eax
  8006b0:	73 24                	jae    8006d6 <getuint+0x9c>
  8006b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	8b 00                	mov    (%rax),%eax
  8006c0:	89 c0                	mov    %eax,%eax
  8006c2:	48 01 d0             	add    %rdx,%rax
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	8b 12                	mov    (%rdx),%edx
  8006cb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d2:	89 0a                	mov    %ecx,(%rdx)
  8006d4:	eb 17                	jmp    8006ed <getuint+0xb3>
  8006d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006da:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006de:	48 89 d0             	mov    %rdx,%rax
  8006e1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ed:	48 8b 00             	mov    (%rax),%rax
  8006f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f4:	eb 4e                	jmp    800744 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	8b 00                	mov    (%rax),%eax
  8006fc:	83 f8 30             	cmp    $0x30,%eax
  8006ff:	73 24                	jae    800725 <getuint+0xeb>
  800701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800705:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	89 c0                	mov    %eax,%eax
  800711:	48 01 d0             	add    %rdx,%rax
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	8b 12                	mov    (%rdx),%edx
  80071a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	89 0a                	mov    %ecx,(%rdx)
  800723:	eb 17                	jmp    80073c <getuint+0x102>
  800725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800729:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072d:	48 89 d0             	mov    %rdx,%rax
  800730:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800734:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800738:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073c:	8b 00                	mov    (%rax),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800748:	c9                   	leaveq 
  800749:	c3                   	retq   

000000000080074a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800752:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800756:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800759:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80075d:	7e 52                	jle    8007b1 <getint+0x67>
		x=va_arg(*ap, long long);
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	83 f8 30             	cmp    $0x30,%eax
  800768:	73 24                	jae    80078e <getint+0x44>
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	8b 12                	mov    (%rdx),%edx
  800783:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	89 0a                	mov    %ecx,(%rdx)
  80078c:	eb 17                	jmp    8007a5 <getint+0x5b>
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800796:	48 89 d0             	mov    %rdx,%rax
  800799:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80079d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a5:	48 8b 00             	mov    (%rax),%rax
  8007a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ac:	e9 a3 00 00 00       	jmpq   800854 <getint+0x10a>
	else if (lflag)
  8007b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007b5:	74 4f                	je     800806 <getint+0xbc>
		x=va_arg(*ap, long);
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	83 f8 30             	cmp    $0x30,%eax
  8007c0:	73 24                	jae    8007e6 <getint+0x9c>
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	89 c0                	mov    %eax,%eax
  8007d2:	48 01 d0             	add    %rdx,%rax
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	8b 12                	mov    (%rdx),%edx
  8007db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	89 0a                	mov    %ecx,(%rdx)
  8007e4:	eb 17                	jmp    8007fd <getint+0xb3>
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ee:	48 89 d0             	mov    %rdx,%rax
  8007f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007fd:	48 8b 00             	mov    (%rax),%rax
  800800:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800804:	eb 4e                	jmp    800854 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 24                	jae    800835 <getint+0xeb>
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	89 c0                	mov    %eax,%eax
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	8b 12                	mov    (%rdx),%edx
  80082a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	89 0a                	mov    %ecx,(%rdx)
  800833:	eb 17                	jmp    80084c <getint+0x102>
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80083d:	48 89 d0             	mov    %rdx,%rax
  800840:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800844:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800848:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80084c:	8b 00                	mov    (%rax),%eax
  80084e:	48 98                	cltq   
  800850:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800858:	c9                   	leaveq 
  800859:	c3                   	retq   

000000000080085a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085a:	55                   	push   %rbp
  80085b:	48 89 e5             	mov    %rsp,%rbp
  80085e:	41 54                	push   %r12
  800860:	53                   	push   %rbx
  800861:	48 83 ec 60          	sub    $0x60,%rsp
  800865:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800869:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80086d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800871:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800875:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800879:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80087d:	48 8b 0a             	mov    (%rdx),%rcx
  800880:	48 89 08             	mov    %rcx,(%rax)
  800883:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800887:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80088b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80088f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800893:	eb 17                	jmp    8008ac <vprintfmt+0x52>
			if (ch == '\0')
  800895:	85 db                	test   %ebx,%ebx
  800897:	0f 84 df 04 00 00    	je     800d7c <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80089d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a5:	48 89 d6             	mov    %rdx,%rsi
  8008a8:	89 df                	mov    %ebx,%edi
  8008aa:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b8:	0f b6 00             	movzbl (%rax),%eax
  8008bb:	0f b6 d8             	movzbl %al,%ebx
  8008be:	83 fb 25             	cmp    $0x25,%ebx
  8008c1:	75 d2                	jne    800895 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008c7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008dc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008eb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ef:	0f b6 00             	movzbl (%rax),%eax
  8008f2:	0f b6 d8             	movzbl %al,%ebx
  8008f5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008f8:	83 f8 55             	cmp    $0x55,%eax
  8008fb:	0f 87 47 04 00 00    	ja     800d48 <vprintfmt+0x4ee>
  800901:	89 c0                	mov    %eax,%eax
  800903:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80090a:	00 
  80090b:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  800912:	00 00 00 
  800915:	48 01 d0             	add    %rdx,%rax
  800918:	48 8b 00             	mov    (%rax),%rax
  80091b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80091d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800921:	eb c0                	jmp    8008e3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800923:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800927:	eb ba                	jmp    8008e3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800929:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800930:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800933:	89 d0                	mov    %edx,%eax
  800935:	c1 e0 02             	shl    $0x2,%eax
  800938:	01 d0                	add    %edx,%eax
  80093a:	01 c0                	add    %eax,%eax
  80093c:	01 d8                	add    %ebx,%eax
  80093e:	83 e8 30             	sub    $0x30,%eax
  800941:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800944:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800948:	0f b6 00             	movzbl (%rax),%eax
  80094b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80094e:	83 fb 2f             	cmp    $0x2f,%ebx
  800951:	7e 0c                	jle    80095f <vprintfmt+0x105>
  800953:	83 fb 39             	cmp    $0x39,%ebx
  800956:	7f 07                	jg     80095f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800958:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80095d:	eb d1                	jmp    800930 <vprintfmt+0xd6>
			goto process_precision;
  80095f:	eb 58                	jmp    8009b9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800961:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800964:	83 f8 30             	cmp    $0x30,%eax
  800967:	73 17                	jae    800980 <vprintfmt+0x126>
  800969:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80096d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800970:	89 c0                	mov    %eax,%eax
  800972:	48 01 d0             	add    %rdx,%rax
  800975:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800978:	83 c2 08             	add    $0x8,%edx
  80097b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80097e:	eb 0f                	jmp    80098f <vprintfmt+0x135>
  800980:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800984:	48 89 d0             	mov    %rdx,%rax
  800987:	48 83 c2 08          	add    $0x8,%rdx
  80098b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80098f:	8b 00                	mov    (%rax),%eax
  800991:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800994:	eb 23                	jmp    8009b9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800996:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099a:	79 0c                	jns    8009a8 <vprintfmt+0x14e>
				width = 0;
  80099c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009a3:	e9 3b ff ff ff       	jmpq   8008e3 <vprintfmt+0x89>
  8009a8:	e9 36 ff ff ff       	jmpq   8008e3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009ad:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009b4:	e9 2a ff ff ff       	jmpq   8008e3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009bd:	79 12                	jns    8009d1 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009bf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009c2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009c5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009cc:	e9 12 ff ff ff       	jmpq   8008e3 <vprintfmt+0x89>
  8009d1:	e9 0d ff ff ff       	jmpq   8008e3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009d6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009da:	e9 04 ff ff ff       	jmpq   8008e3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e2:	83 f8 30             	cmp    $0x30,%eax
  8009e5:	73 17                	jae    8009fe <vprintfmt+0x1a4>
  8009e7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ee:	89 c0                	mov    %eax,%eax
  8009f0:	48 01 d0             	add    %rdx,%rax
  8009f3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f6:	83 c2 08             	add    $0x8,%edx
  8009f9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009fc:	eb 0f                	jmp    800a0d <vprintfmt+0x1b3>
  8009fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a02:	48 89 d0             	mov    %rdx,%rax
  800a05:	48 83 c2 08          	add    $0x8,%rdx
  800a09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a0d:	8b 10                	mov    (%rax),%edx
  800a0f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a17:	48 89 ce             	mov    %rcx,%rsi
  800a1a:	89 d7                	mov    %edx,%edi
  800a1c:	ff d0                	callq  *%rax
			break;
  800a1e:	e9 53 03 00 00       	jmpq   800d76 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a26:	83 f8 30             	cmp    $0x30,%eax
  800a29:	73 17                	jae    800a42 <vprintfmt+0x1e8>
  800a2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a32:	89 c0                	mov    %eax,%eax
  800a34:	48 01 d0             	add    %rdx,%rax
  800a37:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3a:	83 c2 08             	add    $0x8,%edx
  800a3d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a40:	eb 0f                	jmp    800a51 <vprintfmt+0x1f7>
  800a42:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a46:	48 89 d0             	mov    %rdx,%rax
  800a49:	48 83 c2 08          	add    $0x8,%rdx
  800a4d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a51:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a53:	85 db                	test   %ebx,%ebx
  800a55:	79 02                	jns    800a59 <vprintfmt+0x1ff>
				err = -err;
  800a57:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a59:	83 fb 15             	cmp    $0x15,%ebx
  800a5c:	7f 16                	jg     800a74 <vprintfmt+0x21a>
  800a5e:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  800a65:	00 00 00 
  800a68:	48 63 d3             	movslq %ebx,%rdx
  800a6b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a6f:	4d 85 e4             	test   %r12,%r12
  800a72:	75 2e                	jne    800aa2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a74:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7c:	89 d9                	mov    %ebx,%ecx
  800a7e:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
  800a85:	00 00 00 
  800a88:	48 89 c7             	mov    %rax,%rdi
  800a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a90:	49 b8 85 0d 80 00 00 	movabs $0x800d85,%r8
  800a97:	00 00 00 
  800a9a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a9d:	e9 d4 02 00 00       	jmpq   800d76 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aaa:	4c 89 e1             	mov    %r12,%rcx
  800aad:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
  800ab4:	00 00 00 
  800ab7:	48 89 c7             	mov    %rax,%rdi
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
  800abf:	49 b8 85 0d 80 00 00 	movabs $0x800d85,%r8
  800ac6:	00 00 00 
  800ac9:	41 ff d0             	callq  *%r8
			break;
  800acc:	e9 a5 02 00 00       	jmpq   800d76 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ad1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad4:	83 f8 30             	cmp    $0x30,%eax
  800ad7:	73 17                	jae    800af0 <vprintfmt+0x296>
  800ad9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800add:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae0:	89 c0                	mov    %eax,%eax
  800ae2:	48 01 d0             	add    %rdx,%rax
  800ae5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae8:	83 c2 08             	add    $0x8,%edx
  800aeb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aee:	eb 0f                	jmp    800aff <vprintfmt+0x2a5>
  800af0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af4:	48 89 d0             	mov    %rdx,%rax
  800af7:	48 83 c2 08          	add    $0x8,%rdx
  800afb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aff:	4c 8b 20             	mov    (%rax),%r12
  800b02:	4d 85 e4             	test   %r12,%r12
  800b05:	75 0a                	jne    800b11 <vprintfmt+0x2b7>
				p = "(null)";
  800b07:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
  800b0e:	00 00 00 
			if (width > 0 && padc != '-')
  800b11:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b15:	7e 3f                	jle    800b56 <vprintfmt+0x2fc>
  800b17:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b1b:	74 39                	je     800b56 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b20:	48 98                	cltq   
  800b22:	48 89 c6             	mov    %rax,%rsi
  800b25:	4c 89 e7             	mov    %r12,%rdi
  800b28:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  800b2f:	00 00 00 
  800b32:	ff d0                	callq  *%rax
  800b34:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b37:	eb 17                	jmp    800b50 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b39:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b3d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b45:	48 89 ce             	mov    %rcx,%rsi
  800b48:	89 d7                	mov    %edx,%edi
  800b4a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b54:	7f e3                	jg     800b39 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b56:	eb 37                	jmp    800b8f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b5c:	74 1e                	je     800b7c <vprintfmt+0x322>
  800b5e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b61:	7e 05                	jle    800b68 <vprintfmt+0x30e>
  800b63:	83 fb 7e             	cmp    $0x7e,%ebx
  800b66:	7e 14                	jle    800b7c <vprintfmt+0x322>
					putch('?', putdat);
  800b68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b70:	48 89 d6             	mov    %rdx,%rsi
  800b73:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b78:	ff d0                	callq  *%rax
  800b7a:	eb 0f                	jmp    800b8b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b84:	48 89 d6             	mov    %rdx,%rsi
  800b87:	89 df                	mov    %ebx,%edi
  800b89:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8f:	4c 89 e0             	mov    %r12,%rax
  800b92:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b96:	0f b6 00             	movzbl (%rax),%eax
  800b99:	0f be d8             	movsbl %al,%ebx
  800b9c:	85 db                	test   %ebx,%ebx
  800b9e:	74 10                	je     800bb0 <vprintfmt+0x356>
  800ba0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba4:	78 b2                	js     800b58 <vprintfmt+0x2fe>
  800ba6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800baa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bae:	79 a8                	jns    800b58 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb0:	eb 16                	jmp    800bc8 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bb2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	48 89 d6             	mov    %rdx,%rsi
  800bbd:	bf 20 00 00 00       	mov    $0x20,%edi
  800bc2:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bcc:	7f e4                	jg     800bb2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bce:	e9 a3 01 00 00       	jmpq   800d76 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bd3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd7:	be 03 00 00 00       	mov    $0x3,%esi
  800bdc:	48 89 c7             	mov    %rax,%rdi
  800bdf:	48 b8 4a 07 80 00 00 	movabs $0x80074a,%rax
  800be6:	00 00 00 
  800be9:	ff d0                	callq  *%rax
  800beb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf3:	48 85 c0             	test   %rax,%rax
  800bf6:	79 1d                	jns    800c15 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	48 89 d6             	mov    %rdx,%rsi
  800c03:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c08:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0e:	48 f7 d8             	neg    %rax
  800c11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c15:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c1c:	e9 e8 00 00 00       	jmpq   800d09 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c25:	be 03 00 00 00       	mov    $0x3,%esi
  800c2a:	48 89 c7             	mov    %rax,%rdi
  800c2d:	48 b8 3a 06 80 00 00 	movabs $0x80063a,%rax
  800c34:	00 00 00 
  800c37:	ff d0                	callq  *%rax
  800c39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c3d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c44:	e9 c0 00 00 00       	jmpq   800d09 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c51:	48 89 d6             	mov    %rdx,%rsi
  800c54:	bf 58 00 00 00       	mov    $0x58,%edi
  800c59:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c63:	48 89 d6             	mov    %rdx,%rsi
  800c66:	bf 58 00 00 00       	mov    $0x58,%edi
  800c6b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c75:	48 89 d6             	mov    %rdx,%rsi
  800c78:	bf 58 00 00 00       	mov    $0x58,%edi
  800c7d:	ff d0                	callq  *%rax
			break;
  800c7f:	e9 f2 00 00 00       	jmpq   800d76 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8c:	48 89 d6             	mov    %rdx,%rsi
  800c8f:	bf 30 00 00 00       	mov    $0x30,%edi
  800c94:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c9e:	48 89 d6             	mov    %rdx,%rsi
  800ca1:	bf 78 00 00 00       	mov    $0x78,%edi
  800ca6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ca8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cab:	83 f8 30             	cmp    $0x30,%eax
  800cae:	73 17                	jae    800cc7 <vprintfmt+0x46d>
  800cb0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb7:	89 c0                	mov    %eax,%eax
  800cb9:	48 01 d0             	add    %rdx,%rax
  800cbc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cbf:	83 c2 08             	add    $0x8,%edx
  800cc2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc5:	eb 0f                	jmp    800cd6 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cc7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ccb:	48 89 d0             	mov    %rdx,%rax
  800cce:	48 83 c2 08          	add    $0x8,%rdx
  800cd2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cdd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ce4:	eb 23                	jmp    800d09 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ce6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cea:	be 03 00 00 00       	mov    $0x3,%esi
  800cef:	48 89 c7             	mov    %rax,%rdi
  800cf2:	48 b8 3a 06 80 00 00 	movabs $0x80063a,%rax
  800cf9:	00 00 00 
  800cfc:	ff d0                	callq  *%rax
  800cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d02:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d09:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d0e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d11:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d18:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d20:	45 89 c1             	mov    %r8d,%r9d
  800d23:	41 89 f8             	mov    %edi,%r8d
  800d26:	48 89 c7             	mov    %rax,%rdi
  800d29:	48 b8 7f 05 80 00 00 	movabs $0x80057f,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	callq  *%rax
			break;
  800d35:	eb 3f                	jmp    800d76 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3f:	48 89 d6             	mov    %rdx,%rsi
  800d42:	89 df                	mov    %ebx,%edi
  800d44:	ff d0                	callq  *%rax
			break;
  800d46:	eb 2e                	jmp    800d76 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d50:	48 89 d6             	mov    %rdx,%rsi
  800d53:	bf 25 00 00 00       	mov    $0x25,%edi
  800d58:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d5a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5f:	eb 05                	jmp    800d66 <vprintfmt+0x50c>
  800d61:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d66:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d6a:	48 83 e8 01          	sub    $0x1,%rax
  800d6e:	0f b6 00             	movzbl (%rax),%eax
  800d71:	3c 25                	cmp    $0x25,%al
  800d73:	75 ec                	jne    800d61 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d75:	90                   	nop
		}
	}
  800d76:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d77:	e9 30 fb ff ff       	jmpq   8008ac <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d7c:	48 83 c4 60          	add    $0x60,%rsp
  800d80:	5b                   	pop    %rbx
  800d81:	41 5c                	pop    %r12
  800d83:	5d                   	pop    %rbp
  800d84:	c3                   	retq   

0000000000800d85 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d85:	55                   	push   %rbp
  800d86:	48 89 e5             	mov    %rsp,%rbp
  800d89:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d90:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d97:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d9e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db3:	84 c0                	test   %al,%al
  800db5:	74 20                	je     800dd7 <printfmt+0x52>
  800db7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dbb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dcb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dde:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800de5:	00 00 00 
  800de8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800def:	00 00 00 
  800df2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dfd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e04:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e0b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e12:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e19:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e20:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e27:	48 89 c7             	mov    %rax,%rdi
  800e2a:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e36:	c9                   	leaveq 
  800e37:	c3                   	retq   

0000000000800e38 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e38:	55                   	push   %rbp
  800e39:	48 89 e5             	mov    %rsp,%rbp
  800e3c:	48 83 ec 10          	sub    $0x10,%rsp
  800e40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4b:	8b 40 10             	mov    0x10(%rax),%eax
  800e4e:	8d 50 01             	lea    0x1(%rax),%edx
  800e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e55:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5c:	48 8b 10             	mov    (%rax),%rdx
  800e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e63:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e67:	48 39 c2             	cmp    %rax,%rdx
  800e6a:	73 17                	jae    800e83 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e70:	48 8b 00             	mov    (%rax),%rax
  800e73:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e7b:	48 89 0a             	mov    %rcx,(%rdx)
  800e7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e81:	88 10                	mov    %dl,(%rax)
}
  800e83:	c9                   	leaveq 
  800e84:	c3                   	retq   

0000000000800e85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e85:	55                   	push   %rbp
  800e86:	48 89 e5             	mov    %rsp,%rbp
  800e89:	48 83 ec 50          	sub    $0x50,%rsp
  800e8d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e91:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e94:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e98:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e9c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ea0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ea4:	48 8b 0a             	mov    (%rdx),%rcx
  800ea7:	48 89 08             	mov    %rcx,(%rax)
  800eaa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eb2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ec2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ec5:	48 98                	cltq   
  800ec7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ecb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ecf:	48 01 d0             	add    %rdx,%rax
  800ed2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ed6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800edd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ee2:	74 06                	je     800eea <vsnprintf+0x65>
  800ee4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ee8:	7f 07                	jg     800ef1 <vsnprintf+0x6c>
		return -E_INVAL;
  800eea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eef:	eb 2f                	jmp    800f20 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ef1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ef5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ef9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800efd:	48 89 c6             	mov    %rax,%rsi
  800f00:	48 bf 38 0e 80 00 00 	movabs $0x800e38,%rdi
  800f07:	00 00 00 
  800f0a:	48 b8 5a 08 80 00 00 	movabs $0x80085a,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f1a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f1d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f20:	c9                   	leaveq 
  800f21:	c3                   	retq   

0000000000800f22 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f22:	55                   	push   %rbp
  800f23:	48 89 e5             	mov    %rsp,%rbp
  800f26:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f2d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f34:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4f:	84 c0                	test   %al,%al
  800f51:	74 20                	je     800f73 <snprintf+0x51>
  800f53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f73:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f7a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f81:	00 00 00 
  800f84:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f8b:	00 00 00 
  800f8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f92:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fa7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fae:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fb5:	48 8b 0a             	mov    (%rdx),%rcx
  800fb8:	48 89 08             	mov    %rcx,(%rax)
  800fbb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fbf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fcb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fd2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fd9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fdf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fe6:	48 89 c7             	mov    %rax,%rdi
  800fe9:	48 b8 85 0e 80 00 00 	movabs $0x800e85,%rax
  800ff0:	00 00 00 
  800ff3:	ff d0                	callq  *%rax
  800ff5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ffb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801001:	c9                   	leaveq 
  801002:	c3                   	retq   

0000000000801003 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801003:	55                   	push   %rbp
  801004:	48 89 e5             	mov    %rsp,%rbp
  801007:	48 83 ec 18          	sub    $0x18,%rsp
  80100b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80100f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801016:	eb 09                	jmp    801021 <strlen+0x1e>
		n++;
  801018:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80101c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801021:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801025:	0f b6 00             	movzbl (%rax),%eax
  801028:	84 c0                	test   %al,%al
  80102a:	75 ec                	jne    801018 <strlen+0x15>
		n++;
	return n;
  80102c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	48 83 ec 20          	sub    $0x20,%rsp
  801039:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801048:	eb 0e                	jmp    801058 <strnlen+0x27>
		n++;
  80104a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801053:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801058:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80105d:	74 0b                	je     80106a <strnlen+0x39>
  80105f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801063:	0f b6 00             	movzbl (%rax),%eax
  801066:	84 c0                	test   %al,%al
  801068:	75 e0                	jne    80104a <strnlen+0x19>
		n++;
	return n;
  80106a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80106d:	c9                   	leaveq 
  80106e:	c3                   	retq   

000000000080106f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	48 83 ec 20          	sub    $0x20,%rsp
  801077:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80107f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801083:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801087:	90                   	nop
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801090:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801094:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801098:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80109c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010a0:	0f b6 12             	movzbl (%rdx),%edx
  8010a3:	88 10                	mov    %dl,(%rax)
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	84 c0                	test   %al,%al
  8010aa:	75 dc                	jne    801088 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 89 c7             	mov    %rax,%rdi
  8010c9:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
  8010d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010db:	48 63 d0             	movslq %eax,%rdx
  8010de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e2:	48 01 c2             	add    %rax,%rdx
  8010e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e9:	48 89 c6             	mov    %rax,%rsi
  8010ec:	48 89 d7             	mov    %rdx,%rdi
  8010ef:	48 b8 6f 10 80 00 00 	movabs $0x80106f,%rax
  8010f6:	00 00 00 
  8010f9:	ff d0                	callq  *%rax
	return dst;
  8010fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ff:	c9                   	leaveq 
  801100:	c3                   	retq   

0000000000801101 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801101:	55                   	push   %rbp
  801102:	48 89 e5             	mov    %rsp,%rbp
  801105:	48 83 ec 28          	sub    $0x28,%rsp
  801109:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801111:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801119:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80111d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801124:	00 
  801125:	eb 2a                	jmp    801151 <strncpy+0x50>
		*dst++ = *src;
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801133:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801137:	0f b6 12             	movzbl (%rdx),%edx
  80113a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80113c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801140:	0f b6 00             	movzbl (%rax),%eax
  801143:	84 c0                	test   %al,%al
  801145:	74 05                	je     80114c <strncpy+0x4b>
			src++;
  801147:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80114c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801155:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801159:	72 cc                	jb     801127 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80115b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 28          	sub    $0x28,%rsp
  801169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80116d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801171:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801179:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80117d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801182:	74 3d                	je     8011c1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801184:	eb 1d                	jmp    8011a3 <strlcpy+0x42>
			*dst++ = *src++;
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80118e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801192:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801196:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80119a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80119e:	0f b6 12             	movzbl (%rdx),%edx
  8011a1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011a3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ad:	74 0b                	je     8011ba <strlcpy+0x59>
  8011af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	84 c0                	test   %al,%al
  8011b8:	75 cc                	jne    801186 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011be:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	48 29 c2             	sub    %rax,%rdx
  8011cc:	48 89 d0             	mov    %rdx,%rax
}
  8011cf:	c9                   	leaveq 
  8011d0:	c3                   	retq   

00000000008011d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d1:	55                   	push   %rbp
  8011d2:	48 89 e5             	mov    %rsp,%rbp
  8011d5:	48 83 ec 10          	sub    $0x10,%rsp
  8011d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011e1:	eb 0a                	jmp    8011ed <strcmp+0x1c>
		p++, q++;
  8011e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f1:	0f b6 00             	movzbl (%rax),%eax
  8011f4:	84 c0                	test   %al,%al
  8011f6:	74 12                	je     80120a <strcmp+0x39>
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 10             	movzbl (%rax),%edx
  8011ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801203:	0f b6 00             	movzbl (%rax),%eax
  801206:	38 c2                	cmp    %al,%dl
  801208:	74 d9                	je     8011e3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	0f b6 d0             	movzbl %al,%edx
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	0f b6 c0             	movzbl %al,%eax
  80121e:	29 c2                	sub    %eax,%edx
  801220:	89 d0                	mov    %edx,%eax
}
  801222:	c9                   	leaveq 
  801223:	c3                   	retq   

0000000000801224 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	48 83 ec 18          	sub    $0x18,%rsp
  80122c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801230:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801234:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801238:	eb 0f                	jmp    801249 <strncmp+0x25>
		n--, p++, q++;
  80123a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80123f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801244:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801249:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80124e:	74 1d                	je     80126d <strncmp+0x49>
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	0f b6 00             	movzbl (%rax),%eax
  801257:	84 c0                	test   %al,%al
  801259:	74 12                	je     80126d <strncmp+0x49>
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 10             	movzbl (%rax),%edx
  801262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	38 c2                	cmp    %al,%dl
  80126b:	74 cd                	je     80123a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80126d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801272:	75 07                	jne    80127b <strncmp+0x57>
		return 0;
  801274:	b8 00 00 00 00       	mov    $0x0,%eax
  801279:	eb 18                	jmp    801293 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	0f b6 d0             	movzbl %al,%edx
  801285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	0f b6 c0             	movzbl %al,%eax
  80128f:	29 c2                	sub    %eax,%edx
  801291:	89 d0                	mov    %edx,%eax
}
  801293:	c9                   	leaveq 
  801294:	c3                   	retq   

0000000000801295 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801295:	55                   	push   %rbp
  801296:	48 89 e5             	mov    %rsp,%rbp
  801299:	48 83 ec 0c          	sub    $0xc,%rsp
  80129d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a1:	89 f0                	mov    %esi,%eax
  8012a3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a6:	eb 17                	jmp    8012bf <strchr+0x2a>
		if (*s == c)
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ac:	0f b6 00             	movzbl (%rax),%eax
  8012af:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b2:	75 06                	jne    8012ba <strchr+0x25>
			return (char *) s;
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	eb 15                	jmp    8012cf <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	84 c0                	test   %al,%al
  8012c8:	75 de                	jne    8012a8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012dd:	89 f0                	mov    %esi,%eax
  8012df:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e2:	eb 13                	jmp    8012f7 <strfind+0x26>
		if (*s == c)
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ee:	75 02                	jne    8012f2 <strfind+0x21>
			break;
  8012f0:	eb 10                	jmp    801302 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	75 e2                	jne    8012e4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801306:	c9                   	leaveq 
  801307:	c3                   	retq   

0000000000801308 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801308:	55                   	push   %rbp
  801309:	48 89 e5             	mov    %rsp,%rbp
  80130c:	48 83 ec 18          	sub    $0x18,%rsp
  801310:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801314:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801317:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80131b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801320:	75 06                	jne    801328 <memset+0x20>
		return v;
  801322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801326:	eb 69                	jmp    801391 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	83 e0 03             	and    $0x3,%eax
  80132f:	48 85 c0             	test   %rax,%rax
  801332:	75 48                	jne    80137c <memset+0x74>
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	83 e0 03             	and    $0x3,%eax
  80133b:	48 85 c0             	test   %rax,%rax
  80133e:	75 3c                	jne    80137c <memset+0x74>
		c &= 0xFF;
  801340:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801347:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134a:	c1 e0 18             	shl    $0x18,%eax
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801352:	c1 e0 10             	shl    $0x10,%eax
  801355:	09 c2                	or     %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135a:	c1 e0 08             	shl    $0x8,%eax
  80135d:	09 d0                	or     %edx,%eax
  80135f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801366:	48 c1 e8 02          	shr    $0x2,%rax
  80136a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80136d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801371:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801374:	48 89 d7             	mov    %rdx,%rdi
  801377:	fc                   	cld    
  801378:	f3 ab                	rep stos %eax,%es:(%rdi)
  80137a:	eb 11                	jmp    80138d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80137c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801380:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801383:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801387:	48 89 d7             	mov    %rdx,%rdi
  80138a:	fc                   	cld    
  80138b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80138d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801391:	c9                   	leaveq 
  801392:	c3                   	retq   

0000000000801393 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801393:	55                   	push   %rbp
  801394:	48 89 e5             	mov    %rsp,%rbp
  801397:	48 83 ec 28          	sub    $0x28,%rsp
  80139b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013bf:	0f 83 88 00 00 00    	jae    80144d <memmove+0xba>
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013cd:	48 01 d0             	add    %rdx,%rax
  8013d0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d4:	76 77                	jbe    80144d <memmove+0xba>
		s += n;
  8013d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013da:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	83 e0 03             	and    $0x3,%eax
  8013ed:	48 85 c0             	test   %rax,%rax
  8013f0:	75 3b                	jne    80142d <memmove+0x9a>
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f6:	83 e0 03             	and    $0x3,%eax
  8013f9:	48 85 c0             	test   %rax,%rax
  8013fc:	75 2f                	jne    80142d <memmove+0x9a>
  8013fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801402:	83 e0 03             	and    $0x3,%eax
  801405:	48 85 c0             	test   %rax,%rax
  801408:	75 23                	jne    80142d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80140a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140e:	48 83 e8 04          	sub    $0x4,%rax
  801412:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801416:	48 83 ea 04          	sub    $0x4,%rdx
  80141a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80141e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801422:	48 89 c7             	mov    %rax,%rdi
  801425:	48 89 d6             	mov    %rdx,%rsi
  801428:	fd                   	std    
  801429:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80142b:	eb 1d                	jmp    80144a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80142d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801431:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	48 89 d7             	mov    %rdx,%rdi
  801444:	48 89 c1             	mov    %rax,%rcx
  801447:	fd                   	std    
  801448:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80144a:	fc                   	cld    
  80144b:	eb 57                	jmp    8014a4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	83 e0 03             	and    $0x3,%eax
  801454:	48 85 c0             	test   %rax,%rax
  801457:	75 36                	jne    80148f <memmove+0xfc>
  801459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145d:	83 e0 03             	and    $0x3,%eax
  801460:	48 85 c0             	test   %rax,%rax
  801463:	75 2a                	jne    80148f <memmove+0xfc>
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	83 e0 03             	and    $0x3,%eax
  80146c:	48 85 c0             	test   %rax,%rax
  80146f:	75 1e                	jne    80148f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	48 c1 e8 02          	shr    $0x2,%rax
  801479:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80147c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801484:	48 89 c7             	mov    %rax,%rdi
  801487:	48 89 d6             	mov    %rdx,%rsi
  80148a:	fc                   	cld    
  80148b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80148d:	eb 15                	jmp    8014a4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80148f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801493:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801497:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80149b:	48 89 c7             	mov    %rax,%rdi
  80149e:	48 89 d6             	mov    %rdx,%rsi
  8014a1:	fc                   	cld    
  8014a2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a8:	c9                   	leaveq 
  8014a9:	c3                   	retq   

00000000008014aa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014aa:	55                   	push   %rbp
  8014ab:	48 89 e5             	mov    %rsp,%rbp
  8014ae:	48 83 ec 18          	sub    $0x18,%rsp
  8014b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	48 89 ce             	mov    %rcx,%rsi
  8014cd:	48 89 c7             	mov    %rax,%rdi
  8014d0:	48 b8 93 13 80 00 00 	movabs $0x801393,%rax
  8014d7:	00 00 00 
  8014da:	ff d0                	callq  *%rax
}
  8014dc:	c9                   	leaveq 
  8014dd:	c3                   	retq   

00000000008014de <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014de:	55                   	push   %rbp
  8014df:	48 89 e5             	mov    %rsp,%rbp
  8014e2:	48 83 ec 28          	sub    $0x28,%rsp
  8014e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801502:	eb 36                	jmp    80153a <memcmp+0x5c>
		if (*s1 != *s2)
  801504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801508:	0f b6 10             	movzbl (%rax),%edx
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	0f b6 00             	movzbl (%rax),%eax
  801512:	38 c2                	cmp    %al,%dl
  801514:	74 1a                	je     801530 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	0f b6 d0             	movzbl %al,%edx
  801520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	0f b6 c0             	movzbl %al,%eax
  80152a:	29 c2                	sub    %eax,%edx
  80152c:	89 d0                	mov    %edx,%eax
  80152e:	eb 20                	jmp    801550 <memcmp+0x72>
		s1++, s2++;
  801530:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801535:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801542:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801546:	48 85 c0             	test   %rax,%rax
  801549:	75 b9                	jne    801504 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801550:	c9                   	leaveq 
  801551:	c3                   	retq   

0000000000801552 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801552:	55                   	push   %rbp
  801553:	48 89 e5             	mov    %rsp,%rbp
  801556:	48 83 ec 28          	sub    $0x28,%rsp
  80155a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801561:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80156d:	48 01 d0             	add    %rdx,%rax
  801570:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801574:	eb 15                	jmp    80158b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157a:	0f b6 10             	movzbl (%rax),%edx
  80157d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801580:	38 c2                	cmp    %al,%dl
  801582:	75 02                	jne    801586 <memfind+0x34>
			break;
  801584:	eb 0f                	jmp    801595 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801586:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80158b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801593:	72 e1                	jb     801576 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801599:	c9                   	leaveq 
  80159a:	c3                   	retq   

000000000080159b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80159b:	55                   	push   %rbp
  80159c:	48 89 e5             	mov    %rsp,%rbp
  80159f:	48 83 ec 34          	sub    $0x34,%rsp
  8015a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015ab:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015b5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015bc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bd:	eb 05                	jmp    8015c4 <strtol+0x29>
		s++;
  8015bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	3c 20                	cmp    $0x20,%al
  8015cd:	74 f0                	je     8015bf <strtol+0x24>
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	3c 09                	cmp    $0x9,%al
  8015d8:	74 e5                	je     8015bf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 2b                	cmp    $0x2b,%al
  8015e3:	75 07                	jne    8015ec <strtol+0x51>
		s++;
  8015e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ea:	eb 17                	jmp    801603 <strtol+0x68>
	else if (*s == '-')
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	0f b6 00             	movzbl (%rax),%eax
  8015f3:	3c 2d                	cmp    $0x2d,%al
  8015f5:	75 0c                	jne    801603 <strtol+0x68>
		s++, neg = 1;
  8015f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801603:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801607:	74 06                	je     80160f <strtol+0x74>
  801609:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80160d:	75 28                	jne    801637 <strtol+0x9c>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 30                	cmp    $0x30,%al
  801618:	75 1d                	jne    801637 <strtol+0x9c>
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	48 83 c0 01          	add    $0x1,%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	3c 78                	cmp    $0x78,%al
  801627:	75 0e                	jne    801637 <strtol+0x9c>
		s += 2, base = 16;
  801629:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80162e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801635:	eb 2c                	jmp    801663 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801637:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163b:	75 19                	jne    801656 <strtol+0xbb>
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 30                	cmp    $0x30,%al
  801646:	75 0e                	jne    801656 <strtol+0xbb>
		s++, base = 8;
  801648:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80164d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801654:	eb 0d                	jmp    801663 <strtol+0xc8>
	else if (base == 0)
  801656:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80165a:	75 07                	jne    801663 <strtol+0xc8>
		base = 10;
  80165c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 2f                	cmp    $0x2f,%al
  80166c:	7e 1d                	jle    80168b <strtol+0xf0>
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 39                	cmp    $0x39,%al
  801677:	7f 12                	jg     80168b <strtol+0xf0>
			dig = *s - '0';
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	0f be c0             	movsbl %al,%eax
  801683:	83 e8 30             	sub    $0x30,%eax
  801686:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801689:	eb 4e                	jmp    8016d9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	3c 60                	cmp    $0x60,%al
  801694:	7e 1d                	jle    8016b3 <strtol+0x118>
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 7a                	cmp    $0x7a,%al
  80169f:	7f 12                	jg     8016b3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	0f be c0             	movsbl %al,%eax
  8016ab:	83 e8 57             	sub    $0x57,%eax
  8016ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b1:	eb 26                	jmp    8016d9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 40                	cmp    $0x40,%al
  8016bc:	7e 48                	jle    801706 <strtol+0x16b>
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 5a                	cmp    $0x5a,%al
  8016c7:	7f 3d                	jg     801706 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	0f be c0             	movsbl %al,%eax
  8016d3:	83 e8 37             	sub    $0x37,%eax
  8016d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016dc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016df:	7c 02                	jl     8016e3 <strtol+0x148>
			break;
  8016e1:	eb 23                	jmp    801706 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016eb:	48 98                	cltq   
  8016ed:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016f2:	48 89 c2             	mov    %rax,%rdx
  8016f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f8:	48 98                	cltq   
  8016fa:	48 01 d0             	add    %rdx,%rax
  8016fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801701:	e9 5d ff ff ff       	jmpq   801663 <strtol+0xc8>

	if (endptr)
  801706:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80170b:	74 0b                	je     801718 <strtol+0x17d>
		*endptr = (char *) s;
  80170d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801711:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801715:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801718:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80171c:	74 09                	je     801727 <strtol+0x18c>
  80171e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801722:	48 f7 d8             	neg    %rax
  801725:	eb 04                	jmp    80172b <strtol+0x190>
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80172b:	c9                   	leaveq 
  80172c:	c3                   	retq   

000000000080172d <strstr>:

char * strstr(const char *in, const char *str)
{
  80172d:	55                   	push   %rbp
  80172e:	48 89 e5             	mov    %rsp,%rbp
  801731:	48 83 ec 30          	sub    $0x30,%rsp
  801735:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801739:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80173d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801741:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801745:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80174f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801753:	75 06                	jne    80175b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	eb 6b                	jmp    8017c6 <strstr+0x99>

	len = strlen(str);
  80175b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80175f:	48 89 c7             	mov    %rax,%rdi
  801762:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  801769:	00 00 00 
  80176c:	ff d0                	callq  *%rax
  80176e:	48 98                	cltq   
  801770:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801778:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80177c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801786:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80178a:	75 07                	jne    801793 <strstr+0x66>
				return (char *) 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 33                	jmp    8017c6 <strstr+0x99>
		} while (sc != c);
  801793:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801797:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80179a:	75 d8                	jne    801774 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80179c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	48 89 ce             	mov    %rcx,%rsi
  8017ab:	48 89 c7             	mov    %rax,%rdi
  8017ae:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  8017b5:	00 00 00 
  8017b8:	ff d0                	callq  *%rax
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	75 b6                	jne    801774 <strstr+0x47>

	return (char *) (in - 1);
  8017be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c2:	48 83 e8 01          	sub    $0x1,%rax
}
  8017c6:	c9                   	leaveq 
  8017c7:	c3                   	retq   
