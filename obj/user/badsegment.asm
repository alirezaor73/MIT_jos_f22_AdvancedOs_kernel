
obj/user/badsegment:     file format elf64-x86-64


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
  80003c:	e8 19 00 00 00       	callq  80005a <libmain>
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
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800052:	66 b8 28 00          	mov    $0x28,%ax
  800056:	8e d8                	mov    %eax,%ds
}
  800058:	c9                   	leaveq 
  800059:	c3                   	retq   

000000000080005a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005a:	55                   	push   %rbp
  80005b:	48 89 e5             	mov    %rsp,%rbp
  80005e:	48 83 ec 10          	sub    $0x10,%rsp
  800062:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800065:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800069:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800070:	00 00 00 
  800073:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007e:	7e 14                	jle    800094 <libmain+0x3a>
		binaryname = argv[0];
  800080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800084:	48 8b 10             	mov    (%rax),%rdx
  800087:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80008e:	00 00 00 
  800091:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800094:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009b:	48 89 d6             	mov    %rdx,%rsi
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000a7:	00 00 00 
  8000aa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000ac:	48 b8 ba 00 80 00 00 	movabs $0x8000ba,%rax
  8000b3:	00 00 00 
  8000b6:	ff d0                	callq  *%rax
}
  8000b8:	c9                   	leaveq 
  8000b9:	c3                   	retq   

00000000008000ba <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ba:	55                   	push   %rbp
  8000bb:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000be:	bf 00 00 00 00       	mov    $0x0,%edi
  8000c3:	48 b8 e7 01 80 00 00 	movabs $0x8001e7,%rax
  8000ca:	00 00 00 
  8000cd:	ff d0                	callq  *%rax
}
  8000cf:	5d                   	pop    %rbp
  8000d0:	c3                   	retq   

00000000008000d1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000d1:	55                   	push   %rbp
  8000d2:	48 89 e5             	mov    %rsp,%rbp
  8000d5:	53                   	push   %rbx
  8000d6:	48 83 ec 48          	sub    $0x48,%rsp
  8000da:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000dd:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000e0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000e4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000e8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000ec:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8000f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8000f7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8000fb:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8000ff:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800103:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800107:	4c 89 c3             	mov    %r8,%rbx
  80010a:	cd 30                	int    $0x30
  80010c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800110:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800114:	74 3e                	je     800154 <syscall+0x83>
  800116:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80011b:	7e 37                	jle    800154 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80011d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800121:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800124:	49 89 d0             	mov    %rdx,%r8
  800127:	89 c1                	mov    %eax,%ecx
  800129:	48 ba ea 17 80 00 00 	movabs $0x8017ea,%rdx
  800130:	00 00 00 
  800133:	be 23 00 00 00       	mov    $0x23,%esi
  800138:	48 bf 07 18 80 00 00 	movabs $0x801807,%rdi
  80013f:	00 00 00 
  800142:	b8 00 00 00 00       	mov    $0x0,%eax
  800147:	49 b9 69 02 80 00 00 	movabs $0x800269,%r9
  80014e:	00 00 00 
  800151:	41 ff d1             	callq  *%r9

	return ret;
  800154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800158:	48 83 c4 48          	add    $0x48,%rsp
  80015c:	5b                   	pop    %rbx
  80015d:	5d                   	pop    %rbp
  80015e:	c3                   	retq   

000000000080015f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80015f:	55                   	push   %rbp
  800160:	48 89 e5             	mov    %rsp,%rbp
  800163:	48 83 ec 20          	sub    $0x20,%rsp
  800167:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80016b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80016f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800173:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800177:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80017e:	00 
  80017f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800185:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80018b:	48 89 d1             	mov    %rdx,%rcx
  80018e:	48 89 c2             	mov    %rax,%rdx
  800191:	be 00 00 00 00       	mov    $0x0,%esi
  800196:	bf 00 00 00 00       	mov    $0x0,%edi
  80019b:	48 b8 d1 00 80 00 00 	movabs $0x8000d1,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	callq  *%rax
}
  8001a7:	c9                   	leaveq 
  8001a8:	c3                   	retq   

00000000008001a9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001a9:	55                   	push   %rbp
  8001aa:	48 89 e5             	mov    %rsp,%rbp
  8001ad:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b8:	00 
  8001b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8001cf:	be 00 00 00 00       	mov    $0x0,%esi
  8001d4:	bf 01 00 00 00       	mov    $0x1,%edi
  8001d9:	48 b8 d1 00 80 00 00 	movabs $0x8000d1,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
}
  8001e5:	c9                   	leaveq 
  8001e6:	c3                   	retq   

00000000008001e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001e7:	55                   	push   %rbp
  8001e8:	48 89 e5             	mov    %rsp,%rbp
  8001eb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f5:	48 98                	cltq   
  8001f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fe:	00 
  8001ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800205:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800210:	48 89 c2             	mov    %rax,%rdx
  800213:	be 01 00 00 00       	mov    $0x1,%esi
  800218:	bf 03 00 00 00       	mov    $0x3,%edi
  80021d:	48 b8 d1 00 80 00 00 	movabs $0x8000d1,%rax
  800224:	00 00 00 
  800227:	ff d0                	callq  *%rax
}
  800229:	c9                   	leaveq 
  80022a:	c3                   	retq   

000000000080022b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80022b:	55                   	push   %rbp
  80022c:	48 89 e5             	mov    %rsp,%rbp
  80022f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800233:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80023a:	00 
  80023b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800241:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800247:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024c:	ba 00 00 00 00       	mov    $0x0,%edx
  800251:	be 00 00 00 00       	mov    $0x0,%esi
  800256:	bf 02 00 00 00       	mov    $0x2,%edi
  80025b:	48 b8 d1 00 80 00 00 	movabs $0x8000d1,%rax
  800262:	00 00 00 
  800265:	ff d0                	callq  *%rax
}
  800267:	c9                   	leaveq 
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
  8002f2:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002f9:	00 00 00 
  8002fc:	48 8b 18             	mov    (%rax),%rbx
  8002ff:	48 b8 2b 02 80 00 00 	movabs $0x80022b,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
  80030b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800311:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800318:	41 89 c8             	mov    %ecx,%r8d
  80031b:	48 89 d1             	mov    %rdx,%rcx
  80031e:	48 89 da             	mov    %rbx,%rdx
  800321:	89 c6                	mov    %eax,%esi
  800323:	48 bf 18 18 80 00 00 	movabs $0x801818,%rdi
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
  80035f:	48 bf 3b 18 80 00 00 	movabs $0x80183b,%rdi
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
  8003cd:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
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
  80048e:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
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
  80060e:	48 ba 70 19 80 00 00 	movabs $0x801970,%rdx
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
  800906:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
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
  800a59:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  800a60:	00 00 00 
  800a63:	48 63 d3             	movslq %ebx,%rdx
  800a66:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a6a:	4d 85 e4             	test   %r12,%r12
  800a6d:	75 2e                	jne    800a9d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a6f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a77:	89 d9                	mov    %ebx,%ecx
  800a79:	48 ba 81 19 80 00 00 	movabs $0x801981,%rdx
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
  800aa8:	48 ba 8a 19 80 00 00 	movabs $0x80198a,%rdx
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
  800b02:	49 bc 8d 19 80 00 00 	movabs $0x80198d,%r12
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
