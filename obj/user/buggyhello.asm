
obj/user/buggyhello:     file format elf64-x86-64


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
  80003c:	e8 29 00 00 00       	callq  80006a <libmain>
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
	sys_cputs((char*)1, 1);
  800052:	be 01 00 00 00       	mov    $0x1,%esi
  800057:	bf 01 00 00 00       	mov    $0x1,%edi
  80005c:	48 b8 6f 01 80 00 00 	movabs $0x80016f,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
}
  800068:	c9                   	leaveq 
  800069:	c3                   	retq   

000000000080006a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006a:	55                   	push   %rbp
  80006b:	48 89 e5             	mov    %rsp,%rbp
  80006e:	48 83 ec 10          	sub    $0x10,%rsp
  800072:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800075:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800079:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800080:	00 00 00 
  800083:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80008e:	7e 14                	jle    8000a4 <libmain+0x3a>
		binaryname = argv[0];
  800090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800094:	48 8b 10             	mov    (%rax),%rdx
  800097:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80009e:	00 00 00 
  8000a1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ab:	48 89 d6             	mov    %rdx,%rsi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000bc:	48 b8 ca 00 80 00 00 	movabs $0x8000ca,%rax
  8000c3:	00 00 00 
  8000c6:	ff d0                	callq  *%rax
}
  8000c8:	c9                   	leaveq 
  8000c9:	c3                   	retq   

00000000008000ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ca:	55                   	push   %rbp
  8000cb:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8000d3:	48 b8 f7 01 80 00 00 	movabs $0x8001f7,%rax
  8000da:	00 00 00 
  8000dd:	ff d0                	callq  *%rax
}
  8000df:	5d                   	pop    %rbp
  8000e0:	c3                   	retq   

00000000008000e1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000e1:	55                   	push   %rbp
  8000e2:	48 89 e5             	mov    %rsp,%rbp
  8000e5:	53                   	push   %rbx
  8000e6:	48 83 ec 48          	sub    $0x48,%rsp
  8000ea:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000ed:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000f0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000f4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000f8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000fc:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800100:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800103:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800107:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80010b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80010f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800113:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800117:	4c 89 c3             	mov    %r8,%rbx
  80011a:	cd 30                	int    $0x30
  80011c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800120:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800124:	74 3e                	je     800164 <syscall+0x83>
  800126:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80012b:	7e 37                	jle    800164 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80012d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800131:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800134:	49 89 d0             	mov    %rdx,%r8
  800137:	89 c1                	mov    %eax,%ecx
  800139:	48 ba ea 17 80 00 00 	movabs $0x8017ea,%rdx
  800140:	00 00 00 
  800143:	be 23 00 00 00       	mov    $0x23,%esi
  800148:	48 bf 07 18 80 00 00 	movabs $0x801807,%rdi
  80014f:	00 00 00 
  800152:	b8 00 00 00 00       	mov    $0x0,%eax
  800157:	49 b9 79 02 80 00 00 	movabs $0x800279,%r9
  80015e:	00 00 00 
  800161:	41 ff d1             	callq  *%r9

	return ret;
  800164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800168:	48 83 c4 48          	add    $0x48,%rsp
  80016c:	5b                   	pop    %rbx
  80016d:	5d                   	pop    %rbp
  80016e:	c3                   	retq   

000000000080016f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80016f:	55                   	push   %rbp
  800170:	48 89 e5             	mov    %rsp,%rbp
  800173:	48 83 ec 20          	sub    $0x20,%rsp
  800177:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80017b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80017f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800183:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800187:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80018e:	00 
  80018f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800195:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80019b:	48 89 d1             	mov    %rdx,%rcx
  80019e:	48 89 c2             	mov    %rax,%rdx
  8001a1:	be 00 00 00 00       	mov    $0x0,%esi
  8001a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ab:	48 b8 e1 00 80 00 00 	movabs $0x8000e1,%rax
  8001b2:	00 00 00 
  8001b5:	ff d0                	callq  *%rax
}
  8001b7:	c9                   	leaveq 
  8001b8:	c3                   	retq   

00000000008001b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001b9:	55                   	push   %rbp
  8001ba:	48 89 e5             	mov    %rsp,%rbp
  8001bd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c8:	00 
  8001c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001da:	ba 00 00 00 00       	mov    $0x0,%edx
  8001df:	be 00 00 00 00       	mov    $0x0,%esi
  8001e4:	bf 01 00 00 00       	mov    $0x1,%edi
  8001e9:	48 b8 e1 00 80 00 00 	movabs $0x8000e1,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	callq  *%rax
}
  8001f5:	c9                   	leaveq 
  8001f6:	c3                   	retq   

00000000008001f7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800205:	48 98                	cltq   
  800207:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020e:	00 
  80020f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800215:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800220:	48 89 c2             	mov    %rax,%rdx
  800223:	be 01 00 00 00       	mov    $0x1,%esi
  800228:	bf 03 00 00 00       	mov    $0x3,%edi
  80022d:	48 b8 e1 00 80 00 00 	movabs $0x8000e1,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
}
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800243:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80024a:	00 
  80024b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800251:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800257:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025c:	ba 00 00 00 00       	mov    $0x0,%edx
  800261:	be 00 00 00 00       	mov    $0x0,%esi
  800266:	bf 02 00 00 00       	mov    $0x2,%edi
  80026b:	48 b8 e1 00 80 00 00 	movabs $0x8000e1,%rax
  800272:	00 00 00 
  800275:	ff d0                	callq  *%rax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	53                   	push   %rbx
  80027e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800285:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80028c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800292:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800299:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a7:	84 c0                	test   %al,%al
  8002a9:	74 23                	je     8002ce <_panic+0x55>
  8002ab:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002ba:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002be:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ca:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002ce:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002dc:	00 00 00 
  8002df:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e6:	00 00 00 
  8002e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002ed:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002f4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002fb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800302:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800309:	00 00 00 
  80030c:	48 8b 18             	mov    (%rax),%rbx
  80030f:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  800316:	00 00 00 
  800319:	ff d0                	callq  *%rax
  80031b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800321:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800328:	41 89 c8             	mov    %ecx,%r8d
  80032b:	48 89 d1             	mov    %rdx,%rcx
  80032e:	48 89 da             	mov    %rbx,%rdx
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 18 18 80 00 00 	movabs $0x801818,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	49 b9 b2 04 80 00 00 	movabs $0x8004b2,%r9
  800349:	00 00 00 
  80034c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800356:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80035d:	48 89 d6             	mov    %rdx,%rsi
  800360:	48 89 c7             	mov    %rax,%rdi
  800363:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  80036a:	00 00 00 
  80036d:	ff d0                	callq  *%rax
	cprintf("\n");
  80036f:	48 bf 3b 18 80 00 00 	movabs $0x80183b,%rdi
  800376:	00 00 00 
  800379:	b8 00 00 00 00       	mov    $0x0,%eax
  80037e:	48 ba b2 04 80 00 00 	movabs $0x8004b2,%rdx
  800385:	00 00 00 
  800388:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038a:	cc                   	int3   
  80038b:	eb fd                	jmp    80038a <_panic+0x111>

000000000080038d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 10          	sub    $0x10,%rsp
  800395:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	8b 00                	mov    (%rax),%eax
  8003a2:	8d 48 01             	lea    0x1(%rax),%ecx
  8003a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a9:	89 0a                	mov    %ecx,(%rdx)
  8003ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003ae:	89 d1                	mov    %edx,%ecx
  8003b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b4:	48 98                	cltq   
  8003b6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003be:	8b 00                	mov    (%rax),%eax
  8003c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c5:	75 2c                	jne    8003f3 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cb:	8b 00                	mov    (%rax),%eax
  8003cd:	48 98                	cltq   
  8003cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d3:	48 83 c2 08          	add    $0x8,%rdx
  8003d7:	48 89 c6             	mov    %rax,%rsi
  8003da:	48 89 d7             	mov    %rdx,%rdi
  8003dd:	48 b8 6f 01 80 00 00 	movabs $0x80016f,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	callq  *%rax
        b->idx = 0;
  8003e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ed:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f7:	8b 40 04             	mov    0x4(%rax),%eax
  8003fa:	8d 50 01             	lea    0x1(%rax),%edx
  8003fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800401:	89 50 04             	mov    %edx,0x4(%rax)
}
  800404:	c9                   	leaveq 
  800405:	c3                   	retq   

0000000000800406 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800411:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800418:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80041f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800426:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80042d:	48 8b 0a             	mov    (%rdx),%rcx
  800430:	48 89 08             	mov    %rcx,(%rax)
  800433:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800437:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80043b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800443:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80044a:	00 00 00 
    b.cnt = 0;
  80044d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800454:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800457:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80045e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800465:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80046c:	48 89 c6             	mov    %rax,%rsi
  80046f:	48 bf 8d 03 80 00 00 	movabs $0x80038d,%rdi
  800476:	00 00 00 
  800479:	48 b8 65 08 80 00 00 	movabs $0x800865,%rax
  800480:	00 00 00 
  800483:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800485:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80048b:	48 98                	cltq   
  80048d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800494:	48 83 c2 08          	add    $0x8,%rdx
  800498:	48 89 c6             	mov    %rax,%rsi
  80049b:	48 89 d7             	mov    %rdx,%rdi
  80049e:	48 b8 6f 01 80 00 00 	movabs $0x80016f,%rax
  8004a5:	00 00 00 
  8004a8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b0:	c9                   	leaveq 
  8004b1:	c3                   	retq   

00000000008004b2 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004bd:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004cb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004d2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e0:	84 c0                	test   %al,%al
  8004e2:	74 20                	je     800504 <cprintf+0x52>
  8004e4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ec:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004fc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800500:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800504:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80050b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800512:	00 00 00 
  800515:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80051c:	00 00 00 
  80051f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800523:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80052a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800531:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800538:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80053f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800546:	48 8b 0a             	mov    (%rdx),%rcx
  800549:	48 89 08             	mov    %rcx,(%rax)
  80054c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800550:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800554:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800558:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80055c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800563:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80056a:	48 89 d6             	mov    %rdx,%rsi
  80056d:	48 89 c7             	mov    %rax,%rdi
  800570:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  800577:	00 00 00 
  80057a:	ff d0                	callq  *%rax
  80057c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800582:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800588:	c9                   	leaveq 
  800589:	c3                   	retq   

000000000080058a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058a:	55                   	push   %rbp
  80058b:	48 89 e5             	mov    %rsp,%rbp
  80058e:	53                   	push   %rbx
  80058f:	48 83 ec 38          	sub    $0x38,%rsp
  800593:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800597:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80059b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80059f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005a2:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005a6:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005aa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005ad:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005b1:	77 3b                	ja     8005ee <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b3:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005b6:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005ba:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c6:	48 f7 f3             	div    %rbx
  8005c9:	48 89 c2             	mov    %rax,%rdx
  8005cc:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005cf:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005d2:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005da:	41 89 f9             	mov    %edi,%r9d
  8005dd:	48 89 c7             	mov    %rax,%rdi
  8005e0:	48 b8 8a 05 80 00 00 	movabs $0x80058a,%rax
  8005e7:	00 00 00 
  8005ea:	ff d0                	callq  *%rax
  8005ec:	eb 1e                	jmp    80060c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ee:	eb 12                	jmp    800602 <printnum+0x78>
			putch(padc, putdat);
  8005f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005f4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fb:	48 89 ce             	mov    %rcx,%rsi
  8005fe:	89 d7                	mov    %edx,%edi
  800600:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800602:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800606:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80060a:	7f e4                	jg     8005f0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80060f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	48 f7 f1             	div    %rcx
  80061b:	48 89 d0             	mov    %rdx,%rax
  80061e:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
  800625:	00 00 00 
  800628:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80062c:	0f be d0             	movsbl %al,%edx
  80062f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800637:	48 89 ce             	mov    %rcx,%rsi
  80063a:	89 d7                	mov    %edx,%edi
  80063c:	ff d0                	callq  *%rax
}
  80063e:	48 83 c4 38          	add    $0x38,%rsp
  800642:	5b                   	pop    %rbx
  800643:	5d                   	pop    %rbp
  800644:	c3                   	retq   

0000000000800645 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800645:	55                   	push   %rbp
  800646:	48 89 e5             	mov    %rsp,%rbp
  800649:	48 83 ec 1c          	sub    $0x1c,%rsp
  80064d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800651:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800654:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800658:	7e 52                	jle    8006ac <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	8b 00                	mov    (%rax),%eax
  800660:	83 f8 30             	cmp    $0x30,%eax
  800663:	73 24                	jae    800689 <getuint+0x44>
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	8b 00                	mov    (%rax),%eax
  800673:	89 c0                	mov    %eax,%eax
  800675:	48 01 d0             	add    %rdx,%rax
  800678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067c:	8b 12                	mov    (%rdx),%edx
  80067e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800685:	89 0a                	mov    %ecx,(%rdx)
  800687:	eb 17                	jmp    8006a0 <getuint+0x5b>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800691:	48 89 d0             	mov    %rdx,%rax
  800694:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a0:	48 8b 00             	mov    (%rax),%rax
  8006a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a7:	e9 a3 00 00 00       	jmpq   80074f <getuint+0x10a>
	else if (lflag)
  8006ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b0:	74 4f                	je     800701 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b6:	8b 00                	mov    (%rax),%eax
  8006b8:	83 f8 30             	cmp    $0x30,%eax
  8006bb:	73 24                	jae    8006e1 <getuint+0x9c>
  8006bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c9:	8b 00                	mov    (%rax),%eax
  8006cb:	89 c0                	mov    %eax,%eax
  8006cd:	48 01 d0             	add    %rdx,%rax
  8006d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d4:	8b 12                	mov    (%rdx),%edx
  8006d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dd:	89 0a                	mov    %ecx,(%rdx)
  8006df:	eb 17                	jmp    8006f8 <getuint+0xb3>
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e9:	48 89 d0             	mov    %rdx,%rax
  8006ec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f8:	48 8b 00             	mov    (%rax),%rax
  8006fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ff:	eb 4e                	jmp    80074f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800705:	8b 00                	mov    (%rax),%eax
  800707:	83 f8 30             	cmp    $0x30,%eax
  80070a:	73 24                	jae    800730 <getuint+0xeb>
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	8b 00                	mov    (%rax),%eax
  80071a:	89 c0                	mov    %eax,%eax
  80071c:	48 01 d0             	add    %rdx,%rax
  80071f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800723:	8b 12                	mov    (%rdx),%edx
  800725:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072c:	89 0a                	mov    %ecx,(%rdx)
  80072e:	eb 17                	jmp    800747 <getuint+0x102>
  800730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800734:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800738:	48 89 d0             	mov    %rdx,%rax
  80073b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800743:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800747:	8b 00                	mov    (%rax),%eax
  800749:	89 c0                	mov    %eax,%eax
  80074b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80074f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800753:	c9                   	leaveq 
  800754:	c3                   	retq   

0000000000800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %rbp
  800756:	48 89 e5             	mov    %rsp,%rbp
  800759:	48 83 ec 1c          	sub    $0x1c,%rsp
  80075d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800761:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800764:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800768:	7e 52                	jle    8007bc <getint+0x67>
		x=va_arg(*ap, long long);
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	8b 00                	mov    (%rax),%eax
  800770:	83 f8 30             	cmp    $0x30,%eax
  800773:	73 24                	jae    800799 <getint+0x44>
  800775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800779:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	8b 00                	mov    (%rax),%eax
  800783:	89 c0                	mov    %eax,%eax
  800785:	48 01 d0             	add    %rdx,%rax
  800788:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078c:	8b 12                	mov    (%rdx),%edx
  80078e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800795:	89 0a                	mov    %ecx,(%rdx)
  800797:	eb 17                	jmp    8007b0 <getint+0x5b>
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a1:	48 89 d0             	mov    %rdx,%rax
  8007a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b0:	48 8b 00             	mov    (%rax),%rax
  8007b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b7:	e9 a3 00 00 00       	jmpq   80085f <getint+0x10a>
	else if (lflag)
  8007bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c0:	74 4f                	je     800811 <getint+0xbc>
		x=va_arg(*ap, long);
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	83 f8 30             	cmp    $0x30,%eax
  8007cb:	73 24                	jae    8007f1 <getint+0x9c>
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	89 c0                	mov    %eax,%eax
  8007dd:	48 01 d0             	add    %rdx,%rax
  8007e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e4:	8b 12                	mov    (%rdx),%edx
  8007e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	89 0a                	mov    %ecx,(%rdx)
  8007ef:	eb 17                	jmp    800808 <getint+0xb3>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f9:	48 89 d0             	mov    %rdx,%rax
  8007fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800808:	48 8b 00             	mov    (%rax),%rax
  80080b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080f:	eb 4e                	jmp    80085f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	8b 00                	mov    (%rax),%eax
  800817:	83 f8 30             	cmp    $0x30,%eax
  80081a:	73 24                	jae    800840 <getint+0xeb>
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	8b 00                	mov    (%rax),%eax
  80082a:	89 c0                	mov    %eax,%eax
  80082c:	48 01 d0             	add    %rdx,%rax
  80082f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800833:	8b 12                	mov    (%rdx),%edx
  800835:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800838:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083c:	89 0a                	mov    %ecx,(%rdx)
  80083e:	eb 17                	jmp    800857 <getint+0x102>
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800848:	48 89 d0             	mov    %rdx,%rax
  80084b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800853:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800857:	8b 00                	mov    (%rax),%eax
  800859:	48 98                	cltq   
  80085b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800863:	c9                   	leaveq 
  800864:	c3                   	retq   

0000000000800865 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800865:	55                   	push   %rbp
  800866:	48 89 e5             	mov    %rsp,%rbp
  800869:	41 54                	push   %r12
  80086b:	53                   	push   %rbx
  80086c:	48 83 ec 60          	sub    $0x60,%rsp
  800870:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800874:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800878:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80087c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800880:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800884:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800888:	48 8b 0a             	mov    (%rdx),%rcx
  80088b:	48 89 08             	mov    %rcx,(%rax)
  80088e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800892:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800896:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80089a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089e:	eb 17                	jmp    8008b7 <vprintfmt+0x52>
			if (ch == '\0')
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	0f 84 df 04 00 00    	je     800d87 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008a8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008ac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b0:	48 89 d6             	mov    %rdx,%rsi
  8008b3:	89 df                	mov    %ebx,%edi
  8008b5:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008bf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c3:	0f b6 00             	movzbl (%rax),%eax
  8008c6:	0f b6 d8             	movzbl %al,%ebx
  8008c9:	83 fb 25             	cmp    $0x25,%ebx
  8008cc:	75 d2                	jne    8008a0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ce:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008d2:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fa:	0f b6 00             	movzbl (%rax),%eax
  8008fd:	0f b6 d8             	movzbl %al,%ebx
  800900:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800903:	83 f8 55             	cmp    $0x55,%eax
  800906:	0f 87 47 04 00 00    	ja     800d53 <vprintfmt+0x4ee>
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800915:	00 
  800916:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80091d:	00 00 00 
  800920:	48 01 d0             	add    %rdx,%rax
  800923:	48 8b 00             	mov    (%rax),%rax
  800926:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800928:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80092c:	eb c0                	jmp    8008ee <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80092e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800932:	eb ba                	jmp    8008ee <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800934:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80093b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	c1 e0 02             	shl    $0x2,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	01 c0                	add    %eax,%eax
  800947:	01 d8                	add    %ebx,%eax
  800949:	83 e8 30             	sub    $0x30,%eax
  80094c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80094f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800953:	0f b6 00             	movzbl (%rax),%eax
  800956:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800959:	83 fb 2f             	cmp    $0x2f,%ebx
  80095c:	7e 0c                	jle    80096a <vprintfmt+0x105>
  80095e:	83 fb 39             	cmp    $0x39,%ebx
  800961:	7f 07                	jg     80096a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800963:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800968:	eb d1                	jmp    80093b <vprintfmt+0xd6>
			goto process_precision;
  80096a:	eb 58                	jmp    8009c4 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80096c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096f:	83 f8 30             	cmp    $0x30,%eax
  800972:	73 17                	jae    80098b <vprintfmt+0x126>
  800974:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800978:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097b:	89 c0                	mov    %eax,%eax
  80097d:	48 01 d0             	add    %rdx,%rax
  800980:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800983:	83 c2 08             	add    $0x8,%edx
  800986:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800989:	eb 0f                	jmp    80099a <vprintfmt+0x135>
  80098b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098f:	48 89 d0             	mov    %rdx,%rax
  800992:	48 83 c2 08          	add    $0x8,%rdx
  800996:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80099a:	8b 00                	mov    (%rax),%eax
  80099c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80099f:	eb 23                	jmp    8009c4 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a5:	79 0c                	jns    8009b3 <vprintfmt+0x14e>
				width = 0;
  8009a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009ae:	e9 3b ff ff ff       	jmpq   8008ee <vprintfmt+0x89>
  8009b3:	e9 36 ff ff ff       	jmpq   8008ee <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009bf:	e9 2a ff ff ff       	jmpq   8008ee <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c8:	79 12                	jns    8009dc <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ca:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009cd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009d7:	e9 12 ff ff ff       	jmpq   8008ee <vprintfmt+0x89>
  8009dc:	e9 0d ff ff ff       	jmpq   8008ee <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e5:	e9 04 ff ff ff       	jmpq   8008ee <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ed:	83 f8 30             	cmp    $0x30,%eax
  8009f0:	73 17                	jae    800a09 <vprintfmt+0x1a4>
  8009f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f9:	89 c0                	mov    %eax,%eax
  8009fb:	48 01 d0             	add    %rdx,%rax
  8009fe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a01:	83 c2 08             	add    $0x8,%edx
  800a04:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a07:	eb 0f                	jmp    800a18 <vprintfmt+0x1b3>
  800a09:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0d:	48 89 d0             	mov    %rdx,%rax
  800a10:	48 83 c2 08          	add    $0x8,%rdx
  800a14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a18:	8b 10                	mov    (%rax),%edx
  800a1a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a22:	48 89 ce             	mov    %rcx,%rsi
  800a25:	89 d7                	mov    %edx,%edi
  800a27:	ff d0                	callq  *%rax
			break;
  800a29:	e9 53 03 00 00       	jmpq   800d81 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a31:	83 f8 30             	cmp    $0x30,%eax
  800a34:	73 17                	jae    800a4d <vprintfmt+0x1e8>
  800a36:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3d:	89 c0                	mov    %eax,%eax
  800a3f:	48 01 d0             	add    %rdx,%rax
  800a42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a45:	83 c2 08             	add    $0x8,%edx
  800a48:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a4b:	eb 0f                	jmp    800a5c <vprintfmt+0x1f7>
  800a4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a51:	48 89 d0             	mov    %rdx,%rax
  800a54:	48 83 c2 08          	add    $0x8,%rdx
  800a58:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	79 02                	jns    800a64 <vprintfmt+0x1ff>
				err = -err;
  800a62:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a64:	83 fb 15             	cmp    $0x15,%ebx
  800a67:	7f 16                	jg     800a7f <vprintfmt+0x21a>
  800a69:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  800a70:	00 00 00 
  800a73:	48 63 d3             	movslq %ebx,%rdx
  800a76:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a7a:	4d 85 e4             	test   %r12,%r12
  800a7d:	75 2e                	jne    800aad <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a7f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a87:	89 d9                	mov    %ebx,%ecx
  800a89:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
  800a90:	00 00 00 
  800a93:	48 89 c7             	mov    %rax,%rdi
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	49 b8 90 0d 80 00 00 	movabs $0x800d90,%r8
  800aa2:	00 00 00 
  800aa5:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa8:	e9 d4 02 00 00       	jmpq   800d81 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aad:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab5:	4c 89 e1             	mov    %r12,%rcx
  800ab8:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
  800abf:	00 00 00 
  800ac2:	48 89 c7             	mov    %rax,%rdi
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	49 b8 90 0d 80 00 00 	movabs $0x800d90,%r8
  800ad1:	00 00 00 
  800ad4:	41 ff d0             	callq  *%r8
			break;
  800ad7:	e9 a5 02 00 00       	jmpq   800d81 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800adc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adf:	83 f8 30             	cmp    $0x30,%eax
  800ae2:	73 17                	jae    800afb <vprintfmt+0x296>
  800ae4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aeb:	89 c0                	mov    %eax,%eax
  800aed:	48 01 d0             	add    %rdx,%rax
  800af0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af3:	83 c2 08             	add    $0x8,%edx
  800af6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af9:	eb 0f                	jmp    800b0a <vprintfmt+0x2a5>
  800afb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aff:	48 89 d0             	mov    %rdx,%rax
  800b02:	48 83 c2 08          	add    $0x8,%rdx
  800b06:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0a:	4c 8b 20             	mov    (%rax),%r12
  800b0d:	4d 85 e4             	test   %r12,%r12
  800b10:	75 0a                	jne    800b1c <vprintfmt+0x2b7>
				p = "(null)";
  800b12:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
  800b19:	00 00 00 
			if (width > 0 && padc != '-')
  800b1c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b20:	7e 3f                	jle    800b61 <vprintfmt+0x2fc>
  800b22:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b26:	74 39                	je     800b61 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2b:	48 98                	cltq   
  800b2d:	48 89 c6             	mov    %rax,%rsi
  800b30:	4c 89 e7             	mov    %r12,%rdi
  800b33:	48 b8 3c 10 80 00 00 	movabs $0x80103c,%rax
  800b3a:	00 00 00 
  800b3d:	ff d0                	callq  *%rax
  800b3f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b42:	eb 17                	jmp    800b5b <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b44:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b48:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 ce             	mov    %rcx,%rsi
  800b53:	89 d7                	mov    %edx,%edi
  800b55:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b57:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5f:	7f e3                	jg     800b44 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b61:	eb 37                	jmp    800b9a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b63:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b67:	74 1e                	je     800b87 <vprintfmt+0x322>
  800b69:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6c:	7e 05                	jle    800b73 <vprintfmt+0x30e>
  800b6e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b71:	7e 14                	jle    800b87 <vprintfmt+0x322>
					putch('?', putdat);
  800b73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7b:	48 89 d6             	mov    %rdx,%rsi
  800b7e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b83:	ff d0                	callq  *%rax
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b87:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8f:	48 89 d6             	mov    %rdx,%rsi
  800b92:	89 df                	mov    %ebx,%edi
  800b94:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9a:	4c 89 e0             	mov    %r12,%rax
  800b9d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ba1:	0f b6 00             	movzbl (%rax),%eax
  800ba4:	0f be d8             	movsbl %al,%ebx
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	74 10                	je     800bbb <vprintfmt+0x356>
  800bab:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800baf:	78 b2                	js     800b63 <vprintfmt+0x2fe>
  800bb1:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bb5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb9:	79 a8                	jns    800b63 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbb:	eb 16                	jmp    800bd3 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bbd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc5:	48 89 d6             	mov    %rdx,%rsi
  800bc8:	bf 20 00 00 00       	mov    $0x20,%edi
  800bcd:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd7:	7f e4                	jg     800bbd <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bd9:	e9 a3 01 00 00       	jmpq   800d81 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be2:	be 03 00 00 00       	mov    $0x3,%esi
  800be7:	48 89 c7             	mov    %rax,%rdi
  800bea:	48 b8 55 07 80 00 00 	movabs $0x800755,%rax
  800bf1:	00 00 00 
  800bf4:	ff d0                	callq  *%rax
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfe:	48 85 c0             	test   %rax,%rax
  800c01:	79 1d                	jns    800c20 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0b:	48 89 d6             	mov    %rdx,%rsi
  800c0e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c13:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c19:	48 f7 d8             	neg    %rax
  800c1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c20:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c27:	e9 e8 00 00 00       	jmpq   800d14 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c30:	be 03 00 00 00       	mov    $0x3,%esi
  800c35:	48 89 c7             	mov    %rax,%rdi
  800c38:	48 b8 45 06 80 00 00 	movabs $0x800645,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	callq  *%rax
  800c44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c48:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c4f:	e9 c0 00 00 00       	jmpq   800d14 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	bf 58 00 00 00       	mov    $0x58,%edi
  800c64:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6e:	48 89 d6             	mov    %rdx,%rsi
  800c71:	bf 58 00 00 00       	mov    $0x58,%edi
  800c76:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 58 00 00 00       	mov    $0x58,%edi
  800c88:	ff d0                	callq  *%rax
			break;
  800c8a:	e9 f2 00 00 00       	jmpq   800d81 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c97:	48 89 d6             	mov    %rdx,%rsi
  800c9a:	bf 30 00 00 00       	mov    $0x30,%edi
  800c9f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ca1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca9:	48 89 d6             	mov    %rdx,%rsi
  800cac:	bf 78 00 00 00       	mov    $0x78,%edi
  800cb1:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb6:	83 f8 30             	cmp    $0x30,%eax
  800cb9:	73 17                	jae    800cd2 <vprintfmt+0x46d>
  800cbb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc2:	89 c0                	mov    %eax,%eax
  800cc4:	48 01 d0             	add    %rdx,%rax
  800cc7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cca:	83 c2 08             	add    $0x8,%edx
  800ccd:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd0:	eb 0f                	jmp    800ce1 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cd2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd6:	48 89 d0             	mov    %rdx,%rax
  800cd9:	48 83 c2 08          	add    $0x8,%rdx
  800cdd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce1:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ce8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cef:	eb 23                	jmp    800d14 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cf1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf5:	be 03 00 00 00       	mov    $0x3,%esi
  800cfa:	48 89 c7             	mov    %rax,%rdi
  800cfd:	48 b8 45 06 80 00 00 	movabs $0x800645,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
  800d09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d0d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d14:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d19:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d1c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d23:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2b:	45 89 c1             	mov    %r8d,%r9d
  800d2e:	41 89 f8             	mov    %edi,%r8d
  800d31:	48 89 c7             	mov    %rax,%rdi
  800d34:	48 b8 8a 05 80 00 00 	movabs $0x80058a,%rax
  800d3b:	00 00 00 
  800d3e:	ff d0                	callq  *%rax
			break;
  800d40:	eb 3f                	jmp    800d81 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4a:	48 89 d6             	mov    %rdx,%rsi
  800d4d:	89 df                	mov    %ebx,%edi
  800d4f:	ff d0                	callq  *%rax
			break;
  800d51:	eb 2e                	jmp    800d81 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5b:	48 89 d6             	mov    %rdx,%rsi
  800d5e:	bf 25 00 00 00       	mov    $0x25,%edi
  800d63:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d65:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d6a:	eb 05                	jmp    800d71 <vprintfmt+0x50c>
  800d6c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d71:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d75:	48 83 e8 01          	sub    $0x1,%rax
  800d79:	0f b6 00             	movzbl (%rax),%eax
  800d7c:	3c 25                	cmp    $0x25,%al
  800d7e:	75 ec                	jne    800d6c <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d80:	90                   	nop
		}
	}
  800d81:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d82:	e9 30 fb ff ff       	jmpq   8008b7 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d87:	48 83 c4 60          	add    $0x60,%rsp
  800d8b:	5b                   	pop    %rbx
  800d8c:	41 5c                	pop    %r12
  800d8e:	5d                   	pop    %rbp
  800d8f:	c3                   	retq   

0000000000800d90 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d90:	55                   	push   %rbp
  800d91:	48 89 e5             	mov    %rsp,%rbp
  800d94:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d9b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800da2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800db0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbe:	84 c0                	test   %al,%al
  800dc0:	74 20                	je     800de2 <printfmt+0x52>
  800dc2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dda:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dde:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800df0:	00 00 00 
  800df3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dfa:	00 00 00 
  800dfd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e01:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e08:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e16:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e1d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e24:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e2b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e32:	48 89 c7             	mov    %rax,%rdi
  800e35:	48 b8 65 08 80 00 00 	movabs $0x800865,%rax
  800e3c:	00 00 00 
  800e3f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e41:	c9                   	leaveq 
  800e42:	c3                   	retq   

0000000000800e43 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e43:	55                   	push   %rbp
  800e44:	48 89 e5             	mov    %rsp,%rbp
  800e47:	48 83 ec 10          	sub    $0x10,%rsp
  800e4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e56:	8b 40 10             	mov    0x10(%rax),%eax
  800e59:	8d 50 01             	lea    0x1(%rax),%edx
  800e5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e60:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e67:	48 8b 10             	mov    (%rax),%rdx
  800e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e72:	48 39 c2             	cmp    %rax,%rdx
  800e75:	73 17                	jae    800e8e <sprintputch+0x4b>
		*b->buf++ = ch;
  800e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7b:	48 8b 00             	mov    (%rax),%rax
  800e7e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e86:	48 89 0a             	mov    %rcx,(%rdx)
  800e89:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e8c:	88 10                	mov    %dl,(%rax)
}
  800e8e:	c9                   	leaveq 
  800e8f:	c3                   	retq   

0000000000800e90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e90:	55                   	push   %rbp
  800e91:	48 89 e5             	mov    %rsp,%rbp
  800e94:	48 83 ec 50          	sub    $0x50,%rsp
  800e98:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e9c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e9f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eab:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eaf:	48 8b 0a             	mov    (%rdx),%rcx
  800eb2:	48 89 08             	mov    %rcx,(%rax)
  800eb5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ebd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ec1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ecd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ed0:	48 98                	cltq   
  800ed2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ed6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eda:	48 01 d0             	add    %rdx,%rax
  800edd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ee1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eed:	74 06                	je     800ef5 <vsnprintf+0x65>
  800eef:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef3:	7f 07                	jg     800efc <vsnprintf+0x6c>
		return -E_INVAL;
  800ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efa:	eb 2f                	jmp    800f2b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800efc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f00:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f04:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f08:	48 89 c6             	mov    %rax,%rsi
  800f0b:	48 bf 43 0e 80 00 00 	movabs $0x800e43,%rdi
  800f12:	00 00 00 
  800f15:	48 b8 65 08 80 00 00 	movabs $0x800865,%rax
  800f1c:	00 00 00 
  800f1f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f25:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f28:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f2b:	c9                   	leaveq 
  800f2c:	c3                   	retq   

0000000000800f2d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2d:	55                   	push   %rbp
  800f2e:	48 89 e5             	mov    %rsp,%rbp
  800f31:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f38:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f3f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f45:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f53:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f5a:	84 c0                	test   %al,%al
  800f5c:	74 20                	je     800f7e <snprintf+0x51>
  800f5e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f62:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f66:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f6a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f72:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f76:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f7a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f85:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f8c:	00 00 00 
  800f8f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f96:	00 00 00 
  800f99:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fab:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fb2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fc0:	48 8b 0a             	mov    (%rdx),%rcx
  800fc3:	48 89 08             	mov    %rcx,(%rax)
  800fc6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fca:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fce:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fd2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fdd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fea:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ff1:	48 89 c7             	mov    %rax,%rdi
  800ff4:	48 b8 90 0e 80 00 00 	movabs $0x800e90,%rax
  800ffb:	00 00 00 
  800ffe:	ff d0                	callq  *%rax
  801000:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801006:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80100c:	c9                   	leaveq 
  80100d:	c3                   	retq   

000000000080100e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 83 ec 18          	sub    $0x18,%rsp
  801016:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801021:	eb 09                	jmp    80102c <strlen+0x1e>
		n++;
  801023:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801027:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	0f b6 00             	movzbl (%rax),%eax
  801033:	84 c0                	test   %al,%al
  801035:	75 ec                	jne    801023 <strlen+0x15>
		n++;
	return n;
  801037:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80103a:	c9                   	leaveq 
  80103b:	c3                   	retq   

000000000080103c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	48 83 ec 20          	sub    $0x20,%rsp
  801044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801053:	eb 0e                	jmp    801063 <strnlen+0x27>
		n++;
  801055:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801059:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801063:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801068:	74 0b                	je     801075 <strnlen+0x39>
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	84 c0                	test   %al,%al
  801073:	75 e0                	jne    801055 <strnlen+0x19>
		n++;
	return n;
  801075:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 20          	sub    $0x20,%rsp
  801082:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801086:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80108a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801092:	90                   	nop
  801093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801097:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80109f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010a7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ab:	0f b6 12             	movzbl (%rdx),%edx
  8010ae:	88 10                	mov    %dl,(%rax)
  8010b0:	0f b6 00             	movzbl (%rax),%eax
  8010b3:	84 c0                	test   %al,%al
  8010b5:	75 dc                	jne    801093 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010bb:	c9                   	leaveq 
  8010bc:	c3                   	retq   

00000000008010bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010bd:	55                   	push   %rbp
  8010be:	48 89 e5             	mov    %rsp,%rbp
  8010c1:	48 83 ec 20          	sub    $0x20,%rsp
  8010c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d1:	48 89 c7             	mov    %rax,%rdi
  8010d4:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  8010db:	00 00 00 
  8010de:	ff d0                	callq  *%rax
  8010e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e6:	48 63 d0             	movslq %eax,%rdx
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ed:	48 01 c2             	add    %rax,%rdx
  8010f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f4:	48 89 c6             	mov    %rax,%rsi
  8010f7:	48 89 d7             	mov    %rdx,%rdi
  8010fa:	48 b8 7a 10 80 00 00 	movabs $0x80107a,%rax
  801101:	00 00 00 
  801104:	ff d0                	callq  *%rax
	return dst;
  801106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80110a:	c9                   	leaveq 
  80110b:	c3                   	retq   

000000000080110c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80110c:	55                   	push   %rbp
  80110d:	48 89 e5             	mov    %rsp,%rbp
  801110:	48 83 ec 28          	sub    $0x28,%rsp
  801114:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801118:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801124:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801128:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112f:	00 
  801130:	eb 2a                	jmp    80115c <strncpy+0x50>
		*dst++ = *src;
  801132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801136:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801142:	0f b6 12             	movzbl (%rdx),%edx
  801145:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801147:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114b:	0f b6 00             	movzbl (%rax),%eax
  80114e:	84 c0                	test   %al,%al
  801150:	74 05                	je     801157 <strncpy+0x4b>
			src++;
  801152:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801157:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80115c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801160:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801164:	72 cc                	jb     801132 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 28          	sub    $0x28,%rsp
  801174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801184:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801188:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118d:	74 3d                	je     8011cc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80118f:	eb 1d                	jmp    8011ae <strlcpy+0x42>
			*dst++ = *src++;
  801191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801195:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801199:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a9:	0f b6 12             	movzbl (%rdx),%edx
  8011ac:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b8:	74 0b                	je     8011c5 <strlcpy+0x59>
  8011ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	84 c0                	test   %al,%al
  8011c3:	75 cc                	jne    801191 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d4:	48 29 c2             	sub    %rax,%rdx
  8011d7:	48 89 d0             	mov    %rdx,%rax
}
  8011da:	c9                   	leaveq 
  8011db:	c3                   	retq   

00000000008011dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	48 83 ec 10          	sub    $0x10,%rsp
  8011e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011ec:	eb 0a                	jmp    8011f8 <strcmp+0x1c>
		p++, q++;
  8011ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 00             	movzbl (%rax),%eax
  8011ff:	84 c0                	test   %al,%al
  801201:	74 12                	je     801215 <strcmp+0x39>
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	0f b6 10             	movzbl (%rax),%edx
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	38 c2                	cmp    %al,%dl
  801213:	74 d9                	je     8011ee <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	0f b6 d0             	movzbl %al,%edx
  80121f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801223:	0f b6 00             	movzbl (%rax),%eax
  801226:	0f b6 c0             	movzbl %al,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
}
  80122d:	c9                   	leaveq 
  80122e:	c3                   	retq   

000000000080122f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80122f:	55                   	push   %rbp
  801230:	48 89 e5             	mov    %rsp,%rbp
  801233:	48 83 ec 18          	sub    $0x18,%rsp
  801237:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80123b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80123f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801243:	eb 0f                	jmp    801254 <strncmp+0x25>
		n--, p++, q++;
  801245:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80124a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801254:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801259:	74 1d                	je     801278 <strncmp+0x49>
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	84 c0                	test   %al,%al
  801264:	74 12                	je     801278 <strncmp+0x49>
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	0f b6 10             	movzbl (%rax),%edx
  80126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	38 c2                	cmp    %al,%dl
  801276:	74 cd                	je     801245 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801278:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127d:	75 07                	jne    801286 <strncmp+0x57>
		return 0;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	eb 18                	jmp    80129e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128a:	0f b6 00             	movzbl (%rax),%eax
  80128d:	0f b6 d0             	movzbl %al,%edx
  801290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801294:	0f b6 00             	movzbl (%rax),%eax
  801297:	0f b6 c0             	movzbl %al,%eax
  80129a:	29 c2                	sub    %eax,%edx
  80129c:	89 d0                	mov    %edx,%eax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 0c          	sub    $0xc,%rsp
  8012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ac:	89 f0                	mov    %esi,%eax
  8012ae:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b1:	eb 17                	jmp    8012ca <strchr+0x2a>
		if (*s == c)
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	0f b6 00             	movzbl (%rax),%eax
  8012ba:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012bd:	75 06                	jne    8012c5 <strchr+0x25>
			return (char *) s;
  8012bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c3:	eb 15                	jmp    8012da <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	0f b6 00             	movzbl (%rax),%eax
  8012d1:	84 c0                	test   %al,%al
  8012d3:	75 de                	jne    8012b3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012da:	c9                   	leaveq 
  8012db:	c3                   	retq   

00000000008012dc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	48 83 ec 0c          	sub    $0xc,%rsp
  8012e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e8:	89 f0                	mov    %esi,%eax
  8012ea:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ed:	eb 13                	jmp    801302 <strfind+0x26>
		if (*s == c)
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 00             	movzbl (%rax),%eax
  8012f6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f9:	75 02                	jne    8012fd <strfind+0x21>
			break;
  8012fb:	eb 10                	jmp    80130d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	0f b6 00             	movzbl (%rax),%eax
  801309:	84 c0                	test   %al,%al
  80130b:	75 e2                	jne    8012ef <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80130d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801311:	c9                   	leaveq 
  801312:	c3                   	retq   

0000000000801313 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801313:	55                   	push   %rbp
  801314:	48 89 e5             	mov    %rsp,%rbp
  801317:	48 83 ec 18          	sub    $0x18,%rsp
  80131b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801322:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801326:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80132b:	75 06                	jne    801333 <memset+0x20>
		return v;
  80132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801331:	eb 69                	jmp    80139c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801337:	83 e0 03             	and    $0x3,%eax
  80133a:	48 85 c0             	test   %rax,%rax
  80133d:	75 48                	jne    801387 <memset+0x74>
  80133f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801343:	83 e0 03             	and    $0x3,%eax
  801346:	48 85 c0             	test   %rax,%rax
  801349:	75 3c                	jne    801387 <memset+0x74>
		c &= 0xFF;
  80134b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801352:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801355:	c1 e0 18             	shl    $0x18,%eax
  801358:	89 c2                	mov    %eax,%edx
  80135a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135d:	c1 e0 10             	shl    $0x10,%eax
  801360:	09 c2                	or     %eax,%edx
  801362:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801365:	c1 e0 08             	shl    $0x8,%eax
  801368:	09 d0                	or     %edx,%eax
  80136a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80136d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801371:	48 c1 e8 02          	shr    $0x2,%rax
  801375:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801378:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137f:	48 89 d7             	mov    %rdx,%rdi
  801382:	fc                   	cld    
  801383:	f3 ab                	rep stos %eax,%es:(%rdi)
  801385:	eb 11                	jmp    801398 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801387:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80138b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801392:	48 89 d7             	mov    %rdx,%rdi
  801395:	fc                   	cld    
  801396:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80139c:	c9                   	leaveq 
  80139d:	c3                   	retq   

000000000080139e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139e:	55                   	push   %rbp
  80139f:	48 89 e5             	mov    %rsp,%rbp
  8013a2:	48 83 ec 28          	sub    $0x28,%rsp
  8013a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ca:	0f 83 88 00 00 00    	jae    801458 <memmove+0xba>
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d8:	48 01 d0             	add    %rdx,%rax
  8013db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013df:	76 77                	jbe    801458 <memmove+0xba>
		s += n;
  8013e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ed:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f5:	83 e0 03             	and    $0x3,%eax
  8013f8:	48 85 c0             	test   %rax,%rax
  8013fb:	75 3b                	jne    801438 <memmove+0x9a>
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801401:	83 e0 03             	and    $0x3,%eax
  801404:	48 85 c0             	test   %rax,%rax
  801407:	75 2f                	jne    801438 <memmove+0x9a>
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	83 e0 03             	and    $0x3,%eax
  801410:	48 85 c0             	test   %rax,%rax
  801413:	75 23                	jne    801438 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801419:	48 83 e8 04          	sub    $0x4,%rax
  80141d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801421:	48 83 ea 04          	sub    $0x4,%rdx
  801425:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801429:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80142d:	48 89 c7             	mov    %rax,%rdi
  801430:	48 89 d6             	mov    %rdx,%rsi
  801433:	fd                   	std    
  801434:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801436:	eb 1d                	jmp    801455 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801444:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	48 89 d7             	mov    %rdx,%rdi
  80144f:	48 89 c1             	mov    %rax,%rcx
  801452:	fd                   	std    
  801453:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801455:	fc                   	cld    
  801456:	eb 57                	jmp    8014af <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145c:	83 e0 03             	and    $0x3,%eax
  80145f:	48 85 c0             	test   %rax,%rax
  801462:	75 36                	jne    80149a <memmove+0xfc>
  801464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801468:	83 e0 03             	and    $0x3,%eax
  80146b:	48 85 c0             	test   %rax,%rax
  80146e:	75 2a                	jne    80149a <memmove+0xfc>
  801470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801474:	83 e0 03             	and    $0x3,%eax
  801477:	48 85 c0             	test   %rax,%rax
  80147a:	75 1e                	jne    80149a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	48 c1 e8 02          	shr    $0x2,%rax
  801484:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148f:	48 89 c7             	mov    %rax,%rdi
  801492:	48 89 d6             	mov    %rdx,%rsi
  801495:	fc                   	cld    
  801496:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801498:	eb 15                	jmp    8014af <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80149a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a6:	48 89 c7             	mov    %rax,%rdi
  8014a9:	48 89 d6             	mov    %rdx,%rsi
  8014ac:	fc                   	cld    
  8014ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b3:	c9                   	leaveq 
  8014b4:	c3                   	retq   

00000000008014b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b5:	55                   	push   %rbp
  8014b6:	48 89 e5             	mov    %rsp,%rbp
  8014b9:	48 83 ec 18          	sub    $0x18,%rsp
  8014bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d5:	48 89 ce             	mov    %rcx,%rsi
  8014d8:	48 89 c7             	mov    %rax,%rdi
  8014db:	48 b8 9e 13 80 00 00 	movabs $0x80139e,%rax
  8014e2:	00 00 00 
  8014e5:	ff d0                	callq  *%rax
}
  8014e7:	c9                   	leaveq 
  8014e8:	c3                   	retq   

00000000008014e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014e9:	55                   	push   %rbp
  8014ea:	48 89 e5             	mov    %rsp,%rbp
  8014ed:	48 83 ec 28          	sub    $0x28,%rsp
  8014f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801501:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801505:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801509:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80150d:	eb 36                	jmp    801545 <memcmp+0x5c>
		if (*s1 != *s2)
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	0f b6 10             	movzbl (%rax),%edx
  801516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 1a                	je     80153b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801521:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	0f b6 d0             	movzbl %al,%edx
  80152b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	0f b6 c0             	movzbl %al,%eax
  801535:	29 c2                	sub    %eax,%edx
  801537:	89 d0                	mov    %edx,%eax
  801539:	eb 20                	jmp    80155b <memcmp+0x72>
		s1++, s2++;
  80153b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801540:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801549:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80154d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801551:	48 85 c0             	test   %rax,%rax
  801554:	75 b9                	jne    80150f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155b:	c9                   	leaveq 
  80155c:	c3                   	retq   

000000000080155d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80155d:	55                   	push   %rbp
  80155e:	48 89 e5             	mov    %rsp,%rbp
  801561:	48 83 ec 28          	sub    $0x28,%rsp
  801565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801569:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80156c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801574:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801578:	48 01 d0             	add    %rdx,%rax
  80157b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80157f:	eb 15                	jmp    801596 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	0f b6 10             	movzbl (%rax),%edx
  801588:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80158b:	38 c2                	cmp    %al,%dl
  80158d:	75 02                	jne    801591 <memfind+0x34>
			break;
  80158f:	eb 0f                	jmp    8015a0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801591:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80159e:	72 e1                	jb     801581 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a4:	c9                   	leaveq 
  8015a5:	c3                   	retq   

00000000008015a6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a6:	55                   	push   %rbp
  8015a7:	48 89 e5             	mov    %rsp,%rbp
  8015aa:	48 83 ec 34          	sub    $0x34,%rsp
  8015ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015b6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015c0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015c7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c8:	eb 05                	jmp    8015cf <strtol+0x29>
		s++;
  8015ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	3c 20                	cmp    $0x20,%al
  8015d8:	74 f0                	je     8015ca <strtol+0x24>
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 09                	cmp    $0x9,%al
  8015e3:	74 e5                	je     8015ca <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	3c 2b                	cmp    $0x2b,%al
  8015ee:	75 07                	jne    8015f7 <strtol+0x51>
		s++;
  8015f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f5:	eb 17                	jmp    80160e <strtol+0x68>
	else if (*s == '-')
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 2d                	cmp    $0x2d,%al
  801600:	75 0c                	jne    80160e <strtol+0x68>
		s++, neg = 1;
  801602:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801612:	74 06                	je     80161a <strtol+0x74>
  801614:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801618:	75 28                	jne    801642 <strtol+0x9c>
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	3c 30                	cmp    $0x30,%al
  801623:	75 1d                	jne    801642 <strtol+0x9c>
  801625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801629:	48 83 c0 01          	add    $0x1,%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	3c 78                	cmp    $0x78,%al
  801632:	75 0e                	jne    801642 <strtol+0x9c>
		s += 2, base = 16;
  801634:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801639:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801640:	eb 2c                	jmp    80166e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801642:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801646:	75 19                	jne    801661 <strtol+0xbb>
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 30                	cmp    $0x30,%al
  801651:	75 0e                	jne    801661 <strtol+0xbb>
		s++, base = 8;
  801653:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801658:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80165f:	eb 0d                	jmp    80166e <strtol+0xc8>
	else if (base == 0)
  801661:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801665:	75 07                	jne    80166e <strtol+0xc8>
		base = 10;
  801667:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 2f                	cmp    $0x2f,%al
  801677:	7e 1d                	jle    801696 <strtol+0xf0>
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	3c 39                	cmp    $0x39,%al
  801682:	7f 12                	jg     801696 <strtol+0xf0>
			dig = *s - '0';
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	0f be c0             	movsbl %al,%eax
  80168e:	83 e8 30             	sub    $0x30,%eax
  801691:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801694:	eb 4e                	jmp    8016e4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 60                	cmp    $0x60,%al
  80169f:	7e 1d                	jle    8016be <strtol+0x118>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 7a                	cmp    $0x7a,%al
  8016aa:	7f 12                	jg     8016be <strtol+0x118>
			dig = *s - 'a' + 10;
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	0f be c0             	movsbl %al,%eax
  8016b6:	83 e8 57             	sub    $0x57,%eax
  8016b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016bc:	eb 26                	jmp    8016e4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	3c 40                	cmp    $0x40,%al
  8016c7:	7e 48                	jle    801711 <strtol+0x16b>
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 5a                	cmp    $0x5a,%al
  8016d2:	7f 3d                	jg     801711 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	0f be c0             	movsbl %al,%eax
  8016de:	83 e8 37             	sub    $0x37,%eax
  8016e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016ea:	7c 02                	jl     8016ee <strtol+0x148>
			break;
  8016ec:	eb 23                	jmp    801711 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016f6:	48 98                	cltq   
  8016f8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016fd:	48 89 c2             	mov    %rax,%rdx
  801700:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801703:	48 98                	cltq   
  801705:	48 01 d0             	add    %rdx,%rax
  801708:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80170c:	e9 5d ff ff ff       	jmpq   80166e <strtol+0xc8>

	if (endptr)
  801711:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801716:	74 0b                	je     801723 <strtol+0x17d>
		*endptr = (char *) s;
  801718:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801720:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801723:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801727:	74 09                	je     801732 <strtol+0x18c>
  801729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172d:	48 f7 d8             	neg    %rax
  801730:	eb 04                	jmp    801736 <strtol+0x190>
  801732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801736:	c9                   	leaveq 
  801737:	c3                   	retq   

0000000000801738 <strstr>:

char * strstr(const char *in, const char *str)
{
  801738:	55                   	push   %rbp
  801739:	48 89 e5             	mov    %rsp,%rbp
  80173c:	48 83 ec 30          	sub    $0x30,%rsp
  801740:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801744:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801748:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801750:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80175a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80175e:	75 06                	jne    801766 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	eb 6b                	jmp    8017d1 <strstr+0x99>

	len = strlen(str);
  801766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176a:	48 89 c7             	mov    %rax,%rdi
  80176d:	48 b8 0e 10 80 00 00 	movabs $0x80100e,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
  801779:	48 98                	cltq   
  80177b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80177f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801783:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801787:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80178b:	0f b6 00             	movzbl (%rax),%eax
  80178e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801791:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801795:	75 07                	jne    80179e <strstr+0x66>
				return (char *) 0;
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
  80179c:	eb 33                	jmp    8017d1 <strstr+0x99>
		} while (sc != c);
  80179e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017a2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017a5:	75 d8                	jne    80177f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ab:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b3:	48 89 ce             	mov    %rcx,%rsi
  8017b6:	48 89 c7             	mov    %rax,%rdi
  8017b9:	48 b8 2f 12 80 00 00 	movabs $0x80122f,%rax
  8017c0:	00 00 00 
  8017c3:	ff d0                	callq  *%rax
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	75 b6                	jne    80177f <strstr+0x47>

	return (char *) (in - 1);
  8017c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cd:	48 83 e8 01          	sub    $0x1,%rax
}
  8017d1:	c9                   	leaveq 
  8017d2:	c3                   	retq   
