
obj/user/buggyhello2:     file format elf64-x86-64


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
  80003c:	e8 34 00 00 00       	callq  800075 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_cputs(hello, 1024*1024);
  800052:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	be 00 00 10 00       	mov    $0x100000,%esi
  800064:	48 89 c7             	mov    %rax,%rdi
  800067:	48 b8 7a 01 80 00 00 	movabs $0x80017a,%rax
  80006e:	00 00 00 
  800071:	ff d0                	callq  *%rax
}
  800073:	c9                   	leaveq 
  800074:	c3                   	retq   

0000000000800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %rbp
  800076:	48 89 e5             	mov    %rsp,%rbp
  800079:	48 83 ec 10          	sub    $0x10,%rsp
  80007d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800080:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800084:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  80008b:	00 00 00 
  80008e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800099:	7e 14                	jle    8000af <libmain+0x3a>
		binaryname = argv[0];
  80009b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80009f:	48 8b 10             	mov    (%rax),%rdx
  8000a2:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000a9:	00 00 00 
  8000ac:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b6:	48 89 d6             	mov    %rdx,%rsi
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000c7:	48 b8 d5 00 80 00 00 	movabs $0x8000d5,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
}
  8000d3:	c9                   	leaveq 
  8000d4:	c3                   	retq   

00000000008000d5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d5:	55                   	push   %rbp
  8000d6:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8000de:	48 b8 02 02 80 00 00 	movabs $0x800202,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
}
  8000ea:	5d                   	pop    %rbp
  8000eb:	c3                   	retq   

00000000008000ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000ec:	55                   	push   %rbp
  8000ed:	48 89 e5             	mov    %rsp,%rbp
  8000f0:	53                   	push   %rbx
  8000f1:	48 83 ec 48          	sub    $0x48,%rsp
  8000f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000f8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000fb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000ff:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800103:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800107:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80010b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80010e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800112:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800116:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80011a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80011e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800122:	4c 89 c3             	mov    %r8,%rbx
  800125:	cd 30                	int    $0x30
  800127:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80012b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80012f:	74 3e                	je     80016f <syscall+0x83>
  800131:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800136:	7e 37                	jle    80016f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800138:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80013c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013f:	49 89 d0             	mov    %rdx,%r8
  800142:	89 c1                	mov    %eax,%ecx
  800144:	48 ba f8 17 80 00 00 	movabs $0x8017f8,%rdx
  80014b:	00 00 00 
  80014e:	be 23 00 00 00       	mov    $0x23,%esi
  800153:	48 bf 15 18 80 00 00 	movabs $0x801815,%rdi
  80015a:	00 00 00 
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 b9 84 02 80 00 00 	movabs $0x800284,%r9
  800169:	00 00 00 
  80016c:	41 ff d1             	callq  *%r9

	return ret;
  80016f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800173:	48 83 c4 48          	add    $0x48,%rsp
  800177:	5b                   	pop    %rbx
  800178:	5d                   	pop    %rbp
  800179:	c3                   	retq   

000000000080017a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80017a:	55                   	push   %rbp
  80017b:	48 89 e5             	mov    %rsp,%rbp
  80017e:	48 83 ec 20          	sub    $0x20,%rsp
  800182:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800186:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80018a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80018e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800192:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800199:	00 
  80019a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001a6:	48 89 d1             	mov    %rdx,%rcx
  8001a9:	48 89 c2             	mov    %rax,%rdx
  8001ac:	be 00 00 00 00       	mov    $0x0,%esi
  8001b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001b6:	48 b8 ec 00 80 00 00 	movabs $0x8000ec,%rax
  8001bd:	00 00 00 
  8001c0:	ff d0                	callq  *%rax
}
  8001c2:	c9                   	leaveq 
  8001c3:	c3                   	retq   

00000000008001c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001c4:	55                   	push   %rbp
  8001c5:	48 89 e5             	mov    %rsp,%rbp
  8001c8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d3:	00 
  8001d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ea:	be 00 00 00 00       	mov    $0x0,%esi
  8001ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8001f4:	48 b8 ec 00 80 00 00 	movabs $0x8000ec,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
}
  800200:	c9                   	leaveq 
  800201:	c3                   	retq   

0000000000800202 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800202:	55                   	push   %rbp
  800203:	48 89 e5             	mov    %rsp,%rbp
  800206:	48 83 ec 10          	sub    $0x10,%rsp
  80020a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80020d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800210:	48 98                	cltq   
  800212:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800219:	00 
  80021a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800220:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800226:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022b:	48 89 c2             	mov    %rax,%rdx
  80022e:	be 01 00 00 00       	mov    $0x1,%esi
  800233:	bf 03 00 00 00       	mov    $0x3,%edi
  800238:	48 b8 ec 00 80 00 00 	movabs $0x8000ec,%rax
  80023f:	00 00 00 
  800242:	ff d0                	callq  *%rax
}
  800244:	c9                   	leaveq 
  800245:	c3                   	retq   

0000000000800246 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800246:	55                   	push   %rbp
  800247:	48 89 e5             	mov    %rsp,%rbp
  80024a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80024e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800255:	00 
  800256:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800262:	b9 00 00 00 00       	mov    $0x0,%ecx
  800267:	ba 00 00 00 00       	mov    $0x0,%edx
  80026c:	be 00 00 00 00       	mov    $0x0,%esi
  800271:	bf 02 00 00 00       	mov    $0x2,%edi
  800276:	48 b8 ec 00 80 00 00 	movabs $0x8000ec,%rax
  80027d:	00 00 00 
  800280:	ff d0                	callq  *%rax
}
  800282:	c9                   	leaveq 
  800283:	c3                   	retq   

0000000000800284 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800284:	55                   	push   %rbp
  800285:	48 89 e5             	mov    %rsp,%rbp
  800288:	53                   	push   %rbx
  800289:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800290:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800297:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80029d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002a4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002ab:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002b2:	84 c0                	test   %al,%al
  8002b4:	74 23                	je     8002d9 <_panic+0x55>
  8002b6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002bd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002c1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002c5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002cd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002d1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002d5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002e0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002e7:	00 00 00 
  8002ea:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002f1:	00 00 00 
  8002f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ff:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800306:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80030d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800314:	00 00 00 
  800317:	48 8b 18             	mov    (%rax),%rbx
  80031a:	48 b8 46 02 80 00 00 	movabs $0x800246,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
  800326:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80032c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800333:	41 89 c8             	mov    %ecx,%r8d
  800336:	48 89 d1             	mov    %rdx,%rcx
  800339:	48 89 da             	mov    %rbx,%rdx
  80033c:	89 c6                	mov    %eax,%esi
  80033e:	48 bf 28 18 80 00 00 	movabs $0x801828,%rdi
  800345:	00 00 00 
  800348:	b8 00 00 00 00       	mov    $0x0,%eax
  80034d:	49 b9 bd 04 80 00 00 	movabs $0x8004bd,%r9
  800354:	00 00 00 
  800357:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800361:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800368:	48 89 d6             	mov    %rdx,%rsi
  80036b:	48 89 c7             	mov    %rax,%rdi
  80036e:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
	cprintf("\n");
  80037a:	48 bf 4b 18 80 00 00 	movabs $0x80184b,%rdi
  800381:	00 00 00 
  800384:	b8 00 00 00 00       	mov    $0x0,%eax
  800389:	48 ba bd 04 80 00 00 	movabs $0x8004bd,%rdx
  800390:	00 00 00 
  800393:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800395:	cc                   	int3   
  800396:	eb fd                	jmp    800395 <_panic+0x111>

0000000000800398 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800398:	55                   	push   %rbp
  800399:	48 89 e5             	mov    %rsp,%rbp
  80039c:	48 83 ec 10          	sub    $0x10,%rsp
  8003a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ab:	8b 00                	mov    (%rax),%eax
  8003ad:	8d 48 01             	lea    0x1(%rax),%ecx
  8003b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b4:	89 0a                	mov    %ecx,(%rdx)
  8003b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003b9:	89 d1                	mov    %edx,%ecx
  8003bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bf:	48 98                	cltq   
  8003c1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c9:	8b 00                	mov    (%rax),%eax
  8003cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d0:	75 2c                	jne    8003fe <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d6:	8b 00                	mov    (%rax),%eax
  8003d8:	48 98                	cltq   
  8003da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003de:	48 83 c2 08          	add    $0x8,%rdx
  8003e2:	48 89 c6             	mov    %rax,%rsi
  8003e5:	48 89 d7             	mov    %rdx,%rdi
  8003e8:	48 b8 7a 01 80 00 00 	movabs $0x80017a,%rax
  8003ef:	00 00 00 
  8003f2:	ff d0                	callq  *%rax
        b->idx = 0;
  8003f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800402:	8b 40 04             	mov    0x4(%rax),%eax
  800405:	8d 50 01             	lea    0x1(%rax),%edx
  800408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80040f:	c9                   	leaveq 
  800410:	c3                   	retq   

0000000000800411 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800411:	55                   	push   %rbp
  800412:	48 89 e5             	mov    %rsp,%rbp
  800415:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80041c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800423:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80042a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800431:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800438:	48 8b 0a             	mov    (%rdx),%rcx
  80043b:	48 89 08             	mov    %rcx,(%rax)
  80043e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800442:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800446:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80044a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80044e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800455:	00 00 00 
    b.cnt = 0;
  800458:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80045f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800462:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800469:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800470:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800477:	48 89 c6             	mov    %rax,%rsi
  80047a:	48 bf 98 03 80 00 00 	movabs $0x800398,%rdi
  800481:	00 00 00 
  800484:	48 b8 70 08 80 00 00 	movabs $0x800870,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800490:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800496:	48 98                	cltq   
  800498:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80049f:	48 83 c2 08          	add    $0x8,%rdx
  8004a3:	48 89 c6             	mov    %rax,%rsi
  8004a6:	48 89 d7             	mov    %rdx,%rdi
  8004a9:	48 b8 7a 01 80 00 00 	movabs $0x80017a,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004bb:	c9                   	leaveq 
  8004bc:	c3                   	retq   

00000000008004bd <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004bd:	55                   	push   %rbp
  8004be:	48 89 e5             	mov    %rsp,%rbp
  8004c1:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004cf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004eb:	84 c0                	test   %al,%al
  8004ed:	74 20                	je     80050f <cprintf+0x52>
  8004ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800503:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800507:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80050b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80050f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800516:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80051d:	00 00 00 
  800520:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800527:	00 00 00 
  80052a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800535:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80053c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800543:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80054a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800551:	48 8b 0a             	mov    (%rdx),%rcx
  800554:	48 89 08             	mov    %rcx,(%rax)
  800557:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80055b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80055f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800563:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800567:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80056e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800575:	48 89 d6             	mov    %rdx,%rsi
  800578:	48 89 c7             	mov    %rax,%rdi
  80057b:	48 b8 11 04 80 00 00 	movabs $0x800411,%rax
  800582:	00 00 00 
  800585:	ff d0                	callq  *%rax
  800587:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80058d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	53                   	push   %rbx
  80059a:	48 83 ec 38          	sub    $0x38,%rsp
  80059e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005aa:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005ad:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005b1:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005bc:	77 3b                	ja     8005f9 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005be:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005c1:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005c5:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d1:	48 f7 f3             	div    %rbx
  8005d4:	48 89 c2             	mov    %rax,%rdx
  8005d7:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005da:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005dd:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	41 89 f9             	mov    %edi,%r9d
  8005e8:	48 89 c7             	mov    %rax,%rdi
  8005eb:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  8005f2:	00 00 00 
  8005f5:	ff d0                	callq  *%rax
  8005f7:	eb 1e                	jmp    800617 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f9:	eb 12                	jmp    80060d <printnum+0x78>
			putch(padc, putdat);
  8005fb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ff:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800606:	48 89 ce             	mov    %rcx,%rsi
  800609:	89 d7                	mov    %edx,%edi
  80060b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800611:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800615:	7f e4                	jg     8005fb <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800617:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80061a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80061e:	ba 00 00 00 00       	mov    $0x0,%edx
  800623:	48 f7 f1             	div    %rcx
  800626:	48 89 d0             	mov    %rdx,%rax
  800629:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  800630:	00 00 00 
  800633:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800637:	0f be d0             	movsbl %al,%edx
  80063a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 89 ce             	mov    %rcx,%rsi
  800645:	89 d7                	mov    %edx,%edi
  800647:	ff d0                	callq  *%rax
}
  800649:	48 83 c4 38          	add    $0x38,%rsp
  80064d:	5b                   	pop    %rbx
  80064e:	5d                   	pop    %rbp
  80064f:	c3                   	retq   

0000000000800650 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800650:	55                   	push   %rbp
  800651:	48 89 e5             	mov    %rsp,%rbp
  800654:	48 83 ec 1c          	sub    $0x1c,%rsp
  800658:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80065c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80065f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800663:	7e 52                	jle    8006b7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800669:	8b 00                	mov    (%rax),%eax
  80066b:	83 f8 30             	cmp    $0x30,%eax
  80066e:	73 24                	jae    800694 <getuint+0x44>
  800670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800674:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	8b 00                	mov    (%rax),%eax
  80067e:	89 c0                	mov    %eax,%eax
  800680:	48 01 d0             	add    %rdx,%rax
  800683:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800687:	8b 12                	mov    (%rdx),%edx
  800689:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80068c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800690:	89 0a                	mov    %ecx,(%rdx)
  800692:	eb 17                	jmp    8006ab <getuint+0x5b>
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80069c:	48 89 d0             	mov    %rdx,%rax
  80069f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ab:	48 8b 00             	mov    (%rax),%rax
  8006ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b2:	e9 a3 00 00 00       	jmpq   80075a <getuint+0x10a>
	else if (lflag)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006bb:	74 4f                	je     80070c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c1:	8b 00                	mov    (%rax),%eax
  8006c3:	83 f8 30             	cmp    $0x30,%eax
  8006c6:	73 24                	jae    8006ec <getuint+0x9c>
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	8b 00                	mov    (%rax),%eax
  8006d6:	89 c0                	mov    %eax,%eax
  8006d8:	48 01 d0             	add    %rdx,%rax
  8006db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006df:	8b 12                	mov    (%rdx),%edx
  8006e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e8:	89 0a                	mov    %ecx,(%rdx)
  8006ea:	eb 17                	jmp    800703 <getuint+0xb3>
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f4:	48 89 d0             	mov    %rdx,%rax
  8006f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800703:	48 8b 00             	mov    (%rax),%rax
  800706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80070a:	eb 4e                	jmp    80075a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	8b 00                	mov    (%rax),%eax
  800712:	83 f8 30             	cmp    $0x30,%eax
  800715:	73 24                	jae    80073b <getuint+0xeb>
  800717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	8b 00                	mov    (%rax),%eax
  800725:	89 c0                	mov    %eax,%eax
  800727:	48 01 d0             	add    %rdx,%rax
  80072a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072e:	8b 12                	mov    (%rdx),%edx
  800730:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800737:	89 0a                	mov    %ecx,(%rdx)
  800739:	eb 17                	jmp    800752 <getuint+0x102>
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800743:	48 89 d0             	mov    %rdx,%rax
  800746:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80074a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800752:	8b 00                	mov    (%rax),%eax
  800754:	89 c0                	mov    %eax,%eax
  800756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80075a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075e:	c9                   	leaveq 
  80075f:	c3                   	retq   

0000000000800760 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800760:	55                   	push   %rbp
  800761:	48 89 e5             	mov    %rsp,%rbp
  800764:	48 83 ec 1c          	sub    $0x1c,%rsp
  800768:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80076c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80076f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800773:	7e 52                	jle    8007c7 <getint+0x67>
		x=va_arg(*ap, long long);
  800775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800779:	8b 00                	mov    (%rax),%eax
  80077b:	83 f8 30             	cmp    $0x30,%eax
  80077e:	73 24                	jae    8007a4 <getint+0x44>
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	8b 00                	mov    (%rax),%eax
  80078e:	89 c0                	mov    %eax,%eax
  800790:	48 01 d0             	add    %rdx,%rax
  800793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800797:	8b 12                	mov    (%rdx),%edx
  800799:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a0:	89 0a                	mov    %ecx,(%rdx)
  8007a2:	eb 17                	jmp    8007bb <getint+0x5b>
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ac:	48 89 d0             	mov    %rdx,%rax
  8007af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007bb:	48 8b 00             	mov    (%rax),%rax
  8007be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007c2:	e9 a3 00 00 00       	jmpq   80086a <getint+0x10a>
	else if (lflag)
  8007c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007cb:	74 4f                	je     80081c <getint+0xbc>
		x=va_arg(*ap, long);
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	8b 00                	mov    (%rax),%eax
  8007d3:	83 f8 30             	cmp    $0x30,%eax
  8007d6:	73 24                	jae    8007fc <getint+0x9c>
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	8b 00                	mov    (%rax),%eax
  8007e6:	89 c0                	mov    %eax,%eax
  8007e8:	48 01 d0             	add    %rdx,%rax
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	8b 12                	mov    (%rdx),%edx
  8007f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f8:	89 0a                	mov    %ecx,(%rdx)
  8007fa:	eb 17                	jmp    800813 <getint+0xb3>
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800804:	48 89 d0             	mov    %rdx,%rax
  800807:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800813:	48 8b 00             	mov    (%rax),%rax
  800816:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80081a:	eb 4e                	jmp    80086a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	8b 00                	mov    (%rax),%eax
  800822:	83 f8 30             	cmp    $0x30,%eax
  800825:	73 24                	jae    80084b <getint+0xeb>
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	8b 00                	mov    (%rax),%eax
  800835:	89 c0                	mov    %eax,%eax
  800837:	48 01 d0             	add    %rdx,%rax
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	8b 12                	mov    (%rdx),%edx
  800840:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800847:	89 0a                	mov    %ecx,(%rdx)
  800849:	eb 17                	jmp    800862 <getint+0x102>
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800853:	48 89 d0             	mov    %rdx,%rax
  800856:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800862:	8b 00                	mov    (%rax),%eax
  800864:	48 98                	cltq   
  800866:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80086a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80086e:	c9                   	leaveq 
  80086f:	c3                   	retq   

0000000000800870 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800870:	55                   	push   %rbp
  800871:	48 89 e5             	mov    %rsp,%rbp
  800874:	41 54                	push   %r12
  800876:	53                   	push   %rbx
  800877:	48 83 ec 60          	sub    $0x60,%rsp
  80087b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80087f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800883:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800887:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80088b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80088f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800893:	48 8b 0a             	mov    (%rdx),%rcx
  800896:	48 89 08             	mov    %rcx,(%rax)
  800899:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80089d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	eb 17                	jmp    8008c2 <vprintfmt+0x52>
			if (ch == '\0')
  8008ab:	85 db                	test   %ebx,%ebx
  8008ad:	0f 84 df 04 00 00    	je     800d92 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008bb:	48 89 d6             	mov    %rdx,%rsi
  8008be:	89 df                	mov    %ebx,%edi
  8008c0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ca:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ce:	0f b6 00             	movzbl (%rax),%eax
  8008d1:	0f b6 d8             	movzbl %al,%ebx
  8008d4:	83 fb 25             	cmp    $0x25,%ebx
  8008d7:	75 d2                	jne    8008ab <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008dd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008e4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008f2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008fd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800901:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800905:	0f b6 00             	movzbl (%rax),%eax
  800908:	0f b6 d8             	movzbl %al,%ebx
  80090b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80090e:	83 f8 55             	cmp    $0x55,%eax
  800911:	0f 87 47 04 00 00    	ja     800d5e <vprintfmt+0x4ee>
  800917:	89 c0                	mov    %eax,%eax
  800919:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800920:	00 
  800921:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800928:	00 00 00 
  80092b:	48 01 d0             	add    %rdx,%rax
  80092e:	48 8b 00             	mov    (%rax),%rax
  800931:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800933:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800937:	eb c0                	jmp    8008f9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800939:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80093d:	eb ba                	jmp    8008f9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800946:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800949:	89 d0                	mov    %edx,%eax
  80094b:	c1 e0 02             	shl    $0x2,%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	01 c0                	add    %eax,%eax
  800952:	01 d8                	add    %ebx,%eax
  800954:	83 e8 30             	sub    $0x30,%eax
  800957:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80095a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80095e:	0f b6 00             	movzbl (%rax),%eax
  800961:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800964:	83 fb 2f             	cmp    $0x2f,%ebx
  800967:	7e 0c                	jle    800975 <vprintfmt+0x105>
  800969:	83 fb 39             	cmp    $0x39,%ebx
  80096c:	7f 07                	jg     800975 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800973:	eb d1                	jmp    800946 <vprintfmt+0xd6>
			goto process_precision;
  800975:	eb 58                	jmp    8009cf <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800977:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097a:	83 f8 30             	cmp    $0x30,%eax
  80097d:	73 17                	jae    800996 <vprintfmt+0x126>
  80097f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800983:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800986:	89 c0                	mov    %eax,%eax
  800988:	48 01 d0             	add    %rdx,%rax
  80098b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098e:	83 c2 08             	add    $0x8,%edx
  800991:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800994:	eb 0f                	jmp    8009a5 <vprintfmt+0x135>
  800996:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099a:	48 89 d0             	mov    %rdx,%rax
  80099d:	48 83 c2 08          	add    $0x8,%rdx
  8009a1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a5:	8b 00                	mov    (%rax),%eax
  8009a7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009aa:	eb 23                	jmp    8009cf <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b0:	79 0c                	jns    8009be <vprintfmt+0x14e>
				width = 0;
  8009b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b9:	e9 3b ff ff ff       	jmpq   8008f9 <vprintfmt+0x89>
  8009be:	e9 36 ff ff ff       	jmpq   8008f9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009c3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ca:	e9 2a ff ff ff       	jmpq   8008f9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d3:	79 12                	jns    8009e7 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009d5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d8:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009e2:	e9 12 ff ff ff       	jmpq   8008f9 <vprintfmt+0x89>
  8009e7:	e9 0d ff ff ff       	jmpq   8008f9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009ec:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009f0:	e9 04 ff ff ff       	jmpq   8008f9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f8:	83 f8 30             	cmp    $0x30,%eax
  8009fb:	73 17                	jae    800a14 <vprintfmt+0x1a4>
  8009fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a04:	89 c0                	mov    %eax,%eax
  800a06:	48 01 d0             	add    %rdx,%rax
  800a09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0c:	83 c2 08             	add    $0x8,%edx
  800a0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a12:	eb 0f                	jmp    800a23 <vprintfmt+0x1b3>
  800a14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a18:	48 89 d0             	mov    %rdx,%rax
  800a1b:	48 83 c2 08          	add    $0x8,%rdx
  800a1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a23:	8b 10                	mov    (%rax),%edx
  800a25:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2d:	48 89 ce             	mov    %rcx,%rsi
  800a30:	89 d7                	mov    %edx,%edi
  800a32:	ff d0                	callq  *%rax
			break;
  800a34:	e9 53 03 00 00       	jmpq   800d8c <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3c:	83 f8 30             	cmp    $0x30,%eax
  800a3f:	73 17                	jae    800a58 <vprintfmt+0x1e8>
  800a41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a48:	89 c0                	mov    %eax,%eax
  800a4a:	48 01 d0             	add    %rdx,%rax
  800a4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a50:	83 c2 08             	add    $0x8,%edx
  800a53:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a56:	eb 0f                	jmp    800a67 <vprintfmt+0x1f7>
  800a58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a5c:	48 89 d0             	mov    %rdx,%rax
  800a5f:	48 83 c2 08          	add    $0x8,%rdx
  800a63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a67:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a69:	85 db                	test   %ebx,%ebx
  800a6b:	79 02                	jns    800a6f <vprintfmt+0x1ff>
				err = -err;
  800a6d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a6f:	83 fb 15             	cmp    $0x15,%ebx
  800a72:	7f 16                	jg     800a8a <vprintfmt+0x21a>
  800a74:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800a7b:	00 00 00 
  800a7e:	48 63 d3             	movslq %ebx,%rdx
  800a81:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a85:	4d 85 e4             	test   %r12,%r12
  800a88:	75 2e                	jne    800ab8 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a92:	89 d9                	mov    %ebx,%ecx
  800a94:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800a9b:	00 00 00 
  800a9e:	48 89 c7             	mov    %rax,%rdi
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	49 b8 9b 0d 80 00 00 	movabs $0x800d9b,%r8
  800aad:	00 00 00 
  800ab0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab3:	e9 d4 02 00 00       	jmpq   800d8c <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac0:	4c 89 e1             	mov    %r12,%rcx
  800ac3:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800aca:	00 00 00 
  800acd:	48 89 c7             	mov    %rax,%rdi
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad5:	49 b8 9b 0d 80 00 00 	movabs $0x800d9b,%r8
  800adc:	00 00 00 
  800adf:	41 ff d0             	callq  *%r8
			break;
  800ae2:	e9 a5 02 00 00       	jmpq   800d8c <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ae7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aea:	83 f8 30             	cmp    $0x30,%eax
  800aed:	73 17                	jae    800b06 <vprintfmt+0x296>
  800aef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af6:	89 c0                	mov    %eax,%eax
  800af8:	48 01 d0             	add    %rdx,%rax
  800afb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afe:	83 c2 08             	add    $0x8,%edx
  800b01:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b04:	eb 0f                	jmp    800b15 <vprintfmt+0x2a5>
  800b06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0a:	48 89 d0             	mov    %rdx,%rax
  800b0d:	48 83 c2 08          	add    $0x8,%rdx
  800b11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b15:	4c 8b 20             	mov    (%rax),%r12
  800b18:	4d 85 e4             	test   %r12,%r12
  800b1b:	75 0a                	jne    800b27 <vprintfmt+0x2b7>
				p = "(null)";
  800b1d:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  800b24:	00 00 00 
			if (width > 0 && padc != '-')
  800b27:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2b:	7e 3f                	jle    800b6c <vprintfmt+0x2fc>
  800b2d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b31:	74 39                	je     800b6c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b33:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b36:	48 98                	cltq   
  800b38:	48 89 c6             	mov    %rax,%rsi
  800b3b:	4c 89 e7             	mov    %r12,%rdi
  800b3e:	48 b8 47 10 80 00 00 	movabs $0x801047,%rax
  800b45:	00 00 00 
  800b48:	ff d0                	callq  *%rax
  800b4a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b4d:	eb 17                	jmp    800b66 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b4f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b53:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5b:	48 89 ce             	mov    %rcx,%rsi
  800b5e:	89 d7                	mov    %edx,%edi
  800b60:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b62:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b66:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6a:	7f e3                	jg     800b4f <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6c:	eb 37                	jmp    800ba5 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b72:	74 1e                	je     800b92 <vprintfmt+0x322>
  800b74:	83 fb 1f             	cmp    $0x1f,%ebx
  800b77:	7e 05                	jle    800b7e <vprintfmt+0x30e>
  800b79:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7c:	7e 14                	jle    800b92 <vprintfmt+0x322>
					putch('?', putdat);
  800b7e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b86:	48 89 d6             	mov    %rdx,%rsi
  800b89:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b8e:	ff d0                	callq  *%rax
  800b90:	eb 0f                	jmp    800ba1 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b92:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9a:	48 89 d6             	mov    %rdx,%rsi
  800b9d:	89 df                	mov    %ebx,%edi
  800b9f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba5:	4c 89 e0             	mov    %r12,%rax
  800ba8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bac:	0f b6 00             	movzbl (%rax),%eax
  800baf:	0f be d8             	movsbl %al,%ebx
  800bb2:	85 db                	test   %ebx,%ebx
  800bb4:	74 10                	je     800bc6 <vprintfmt+0x356>
  800bb6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bba:	78 b2                	js     800b6e <vprintfmt+0x2fe>
  800bbc:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bc0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc4:	79 a8                	jns    800b6e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc6:	eb 16                	jmp    800bde <vprintfmt+0x36e>
				putch(' ', putdat);
  800bc8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd0:	48 89 d6             	mov    %rdx,%rsi
  800bd3:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bda:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bde:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be2:	7f e4                	jg     800bc8 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800be4:	e9 a3 01 00 00       	jmpq   800d8c <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bed:	be 03 00 00 00       	mov    $0x3,%esi
  800bf2:	48 89 c7             	mov    %rax,%rdi
  800bf5:	48 b8 60 07 80 00 00 	movabs $0x800760,%rax
  800bfc:	00 00 00 
  800bff:	ff d0                	callq  *%rax
  800c01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c09:	48 85 c0             	test   %rax,%rax
  800c0c:	79 1d                	jns    800c2b <vprintfmt+0x3bb>
				putch('-', putdat);
  800c0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	48 89 d6             	mov    %rdx,%rsi
  800c19:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c1e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c24:	48 f7 d8             	neg    %rax
  800c27:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c2b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c32:	e9 e8 00 00 00       	jmpq   800d1f <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3b:	be 03 00 00 00       	mov    $0x3,%esi
  800c40:	48 89 c7             	mov    %rax,%rdi
  800c43:	48 b8 50 06 80 00 00 	movabs $0x800650,%rax
  800c4a:	00 00 00 
  800c4d:	ff d0                	callq  *%rax
  800c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c53:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c5a:	e9 c0 00 00 00       	jmpq   800d1f <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c67:	48 89 d6             	mov    %rdx,%rsi
  800c6a:	bf 58 00 00 00       	mov    $0x58,%edi
  800c6f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c79:	48 89 d6             	mov    %rdx,%rsi
  800c7c:	bf 58 00 00 00       	mov    $0x58,%edi
  800c81:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8b:	48 89 d6             	mov    %rdx,%rsi
  800c8e:	bf 58 00 00 00       	mov    $0x58,%edi
  800c93:	ff d0                	callq  *%rax
			break;
  800c95:	e9 f2 00 00 00       	jmpq   800d8c <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca2:	48 89 d6             	mov    %rdx,%rsi
  800ca5:	bf 30 00 00 00       	mov    $0x30,%edi
  800caa:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb4:	48 89 d6             	mov    %rdx,%rsi
  800cb7:	bf 78 00 00 00       	mov    $0x78,%edi
  800cbc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc1:	83 f8 30             	cmp    $0x30,%eax
  800cc4:	73 17                	jae    800cdd <vprintfmt+0x46d>
  800cc6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccd:	89 c0                	mov    %eax,%eax
  800ccf:	48 01 d0             	add    %rdx,%rax
  800cd2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd5:	83 c2 08             	add    $0x8,%edx
  800cd8:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cdb:	eb 0f                	jmp    800cec <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cdd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce1:	48 89 d0             	mov    %rdx,%rax
  800ce4:	48 83 c2 08          	add    $0x8,%rdx
  800ce8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cec:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cf3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cfa:	eb 23                	jmp    800d1f <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cfc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d00:	be 03 00 00 00       	mov    $0x3,%esi
  800d05:	48 89 c7             	mov    %rax,%rdi
  800d08:	48 b8 50 06 80 00 00 	movabs $0x800650,%rax
  800d0f:	00 00 00 
  800d12:	ff d0                	callq  *%rax
  800d14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d18:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d1f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d24:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d27:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d36:	45 89 c1             	mov    %r8d,%r9d
  800d39:	41 89 f8             	mov    %edi,%r8d
  800d3c:	48 89 c7             	mov    %rax,%rdi
  800d3f:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  800d46:	00 00 00 
  800d49:	ff d0                	callq  *%rax
			break;
  800d4b:	eb 3f                	jmp    800d8c <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d55:	48 89 d6             	mov    %rdx,%rsi
  800d58:	89 df                	mov    %ebx,%edi
  800d5a:	ff d0                	callq  *%rax
			break;
  800d5c:	eb 2e                	jmp    800d8c <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d66:	48 89 d6             	mov    %rdx,%rsi
  800d69:	bf 25 00 00 00       	mov    $0x25,%edi
  800d6e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d70:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d75:	eb 05                	jmp    800d7c <vprintfmt+0x50c>
  800d77:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d7c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d80:	48 83 e8 01          	sub    $0x1,%rax
  800d84:	0f b6 00             	movzbl (%rax),%eax
  800d87:	3c 25                	cmp    $0x25,%al
  800d89:	75 ec                	jne    800d77 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d8b:	90                   	nop
		}
	}
  800d8c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8d:	e9 30 fb ff ff       	jmpq   8008c2 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d92:	48 83 c4 60          	add    $0x60,%rsp
  800d96:	5b                   	pop    %rbx
  800d97:	41 5c                	pop    %r12
  800d99:	5d                   	pop    %rbp
  800d9a:	c3                   	retq   

0000000000800d9b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d9b:	55                   	push   %rbp
  800d9c:	48 89 e5             	mov    %rsp,%rbp
  800d9f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800da6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dad:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800db4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dbb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dc9:	84 c0                	test   %al,%al
  800dcb:	74 20                	je     800ded <printfmt+0x52>
  800dcd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dd9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ddd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800de9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ded:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800df4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dfb:	00 00 00 
  800dfe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e05:	00 00 00 
  800e08:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e13:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e1a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e21:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e28:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e2f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e36:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e3d:	48 89 c7             	mov    %rax,%rdi
  800e40:	48 b8 70 08 80 00 00 	movabs $0x800870,%rax
  800e47:	00 00 00 
  800e4a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e4c:	c9                   	leaveq 
  800e4d:	c3                   	retq   

0000000000800e4e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e4e:	55                   	push   %rbp
  800e4f:	48 89 e5             	mov    %rsp,%rbp
  800e52:	48 83 ec 10          	sub    $0x10,%rsp
  800e56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e61:	8b 40 10             	mov    0x10(%rax),%eax
  800e64:	8d 50 01             	lea    0x1(%rax),%edx
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	48 8b 10             	mov    (%rax),%rdx
  800e75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e79:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e7d:	48 39 c2             	cmp    %rax,%rdx
  800e80:	73 17                	jae    800e99 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e86:	48 8b 00             	mov    (%rax),%rax
  800e89:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e91:	48 89 0a             	mov    %rcx,(%rdx)
  800e94:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e97:	88 10                	mov    %dl,(%rax)
}
  800e99:	c9                   	leaveq 
  800e9a:	c3                   	retq   

0000000000800e9b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9b:	55                   	push   %rbp
  800e9c:	48 89 e5             	mov    %rsp,%rbp
  800e9f:	48 83 ec 50          	sub    $0x50,%rsp
  800ea3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ea7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eaa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eae:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800eb2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eb6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eba:	48 8b 0a             	mov    (%rdx),%rcx
  800ebd:	48 89 08             	mov    %rcx,(%rax)
  800ec0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ec4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ecc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ed0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ed8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800edb:	48 98                	cltq   
  800edd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ee1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee5:	48 01 d0             	add    %rdx,%rax
  800ee8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ef3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ef8:	74 06                	je     800f00 <vsnprintf+0x65>
  800efa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800efe:	7f 07                	jg     800f07 <vsnprintf+0x6c>
		return -E_INVAL;
  800f00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f05:	eb 2f                	jmp    800f36 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f07:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f0b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f0f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f13:	48 89 c6             	mov    %rax,%rsi
  800f16:	48 bf 4e 0e 80 00 00 	movabs $0x800e4e,%rdi
  800f1d:	00 00 00 
  800f20:	48 b8 70 08 80 00 00 	movabs $0x800870,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f30:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f33:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f36:	c9                   	leaveq 
  800f37:	c3                   	retq   

0000000000800f38 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f38:	55                   	push   %rbp
  800f39:	48 89 e5             	mov    %rsp,%rbp
  800f3c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f43:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f4a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f50:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f57:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f5e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f65:	84 c0                	test   %al,%al
  800f67:	74 20                	je     800f89 <snprintf+0x51>
  800f69:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f6d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f71:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f75:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f79:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f7d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f81:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f85:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f89:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f90:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f97:	00 00 00 
  800f9a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fa1:	00 00 00 
  800fa4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800faf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fb6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fbd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fc4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fcb:	48 8b 0a             	mov    (%rdx),%rcx
  800fce:	48 89 08             	mov    %rcx,(%rax)
  800fd1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fdd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fe1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fe8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fef:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ff5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ffc:	48 89 c7             	mov    %rax,%rdi
  800fff:	48 b8 9b 0e 80 00 00 	movabs $0x800e9b,%rax
  801006:	00 00 00 
  801009:	ff d0                	callq  *%rax
  80100b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801011:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801017:	c9                   	leaveq 
  801018:	c3                   	retq   

0000000000801019 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801019:	55                   	push   %rbp
  80101a:	48 89 e5             	mov    %rsp,%rbp
  80101d:	48 83 ec 18          	sub    $0x18,%rsp
  801021:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801025:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102c:	eb 09                	jmp    801037 <strlen+0x1e>
		n++;
  80102e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801032:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801037:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103b:	0f b6 00             	movzbl (%rax),%eax
  80103e:	84 c0                	test   %al,%al
  801040:	75 ec                	jne    80102e <strlen+0x15>
		n++;
	return n;
  801042:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801045:	c9                   	leaveq 
  801046:	c3                   	retq   

0000000000801047 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801047:	55                   	push   %rbp
  801048:	48 89 e5             	mov    %rsp,%rbp
  80104b:	48 83 ec 20          	sub    $0x20,%rsp
  80104f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801053:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801057:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105e:	eb 0e                	jmp    80106e <strnlen+0x27>
		n++;
  801060:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801064:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801069:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80106e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801073:	74 0b                	je     801080 <strnlen+0x39>
  801075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801079:	0f b6 00             	movzbl (%rax),%eax
  80107c:	84 c0                	test   %al,%al
  80107e:	75 e0                	jne    801060 <strnlen+0x19>
		n++;
	return n;
  801080:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801083:	c9                   	leaveq 
  801084:	c3                   	retq   

0000000000801085 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 83 ec 20          	sub    $0x20,%rsp
  80108d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801091:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801099:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80109d:	90                   	nop
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ae:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010b2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b6:	0f b6 12             	movzbl (%rdx),%edx
  8010b9:	88 10                	mov    %dl,(%rax)
  8010bb:	0f b6 00             	movzbl (%rax),%eax
  8010be:	84 c0                	test   %al,%al
  8010c0:	75 dc                	jne    80109e <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c6:	c9                   	leaveq 
  8010c7:	c3                   	retq   

00000000008010c8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010c8:	55                   	push   %rbp
  8010c9:	48 89 e5             	mov    %rsp,%rbp
  8010cc:	48 83 ec 20          	sub    $0x20,%rsp
  8010d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dc:	48 89 c7             	mov    %rax,%rdi
  8010df:	48 b8 19 10 80 00 00 	movabs $0x801019,%rax
  8010e6:	00 00 00 
  8010e9:	ff d0                	callq  *%rax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010f1:	48 63 d0             	movslq %eax,%rdx
  8010f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f8:	48 01 c2             	add    %rax,%rdx
  8010fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ff:	48 89 c6             	mov    %rax,%rsi
  801102:	48 89 d7             	mov    %rdx,%rdi
  801105:	48 b8 85 10 80 00 00 	movabs $0x801085,%rax
  80110c:	00 00 00 
  80110f:	ff d0                	callq  *%rax
	return dst;
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801115:	c9                   	leaveq 
  801116:	c3                   	retq   

0000000000801117 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	48 83 ec 28          	sub    $0x28,%rsp
  80111f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801123:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801127:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80112b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801133:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80113a:	00 
  80113b:	eb 2a                	jmp    801167 <strncpy+0x50>
		*dst++ = *src;
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801145:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801149:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80114d:	0f b6 12             	movzbl (%rdx),%edx
  801150:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801152:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801156:	0f b6 00             	movzbl (%rax),%eax
  801159:	84 c0                	test   %al,%al
  80115b:	74 05                	je     801162 <strncpy+0x4b>
			src++;
  80115d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801162:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80116f:	72 cc                	jb     80113d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 28          	sub    $0x28,%rsp
  80117f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801187:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801193:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801198:	74 3d                	je     8011d7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80119a:	eb 1d                	jmp    8011b9 <strlcpy+0x42>
			*dst++ = *src++;
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011b0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011b4:	0f b6 12             	movzbl (%rdx),%edx
  8011b7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011c3:	74 0b                	je     8011d0 <strlcpy+0x59>
  8011c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 cc                	jne    80119c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011df:	48 29 c2             	sub    %rax,%rdx
  8011e2:	48 89 d0             	mov    %rdx,%rax
}
  8011e5:	c9                   	leaveq 
  8011e6:	c3                   	retq   

00000000008011e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011e7:	55                   	push   %rbp
  8011e8:	48 89 e5             	mov    %rsp,%rbp
  8011eb:	48 83 ec 10          	sub    $0x10,%rsp
  8011ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011f7:	eb 0a                	jmp    801203 <strcmp+0x1c>
		p++, q++;
  8011f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	84 c0                	test   %al,%al
  80120c:	74 12                	je     801220 <strcmp+0x39>
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	0f b6 10             	movzbl (%rax),%edx
  801215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 d9                	je     8011f9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801224:	0f b6 00             	movzbl (%rax),%eax
  801227:	0f b6 d0             	movzbl %al,%edx
  80122a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	0f b6 c0             	movzbl %al,%eax
  801234:	29 c2                	sub    %eax,%edx
  801236:	89 d0                	mov    %edx,%eax
}
  801238:	c9                   	leaveq 
  801239:	c3                   	retq   

000000000080123a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80123a:	55                   	push   %rbp
  80123b:	48 89 e5             	mov    %rsp,%rbp
  80123e:	48 83 ec 18          	sub    $0x18,%rsp
  801242:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801246:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80124a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80124e:	eb 0f                	jmp    80125f <strncmp+0x25>
		n--, p++, q++;
  801250:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801255:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80125f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801264:	74 1d                	je     801283 <strncmp+0x49>
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	0f b6 00             	movzbl (%rax),%eax
  80126d:	84 c0                	test   %al,%al
  80126f:	74 12                	je     801283 <strncmp+0x49>
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	0f b6 10             	movzbl (%rax),%edx
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	38 c2                	cmp    %al,%dl
  801281:	74 cd                	je     801250 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801283:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801288:	75 07                	jne    801291 <strncmp+0x57>
		return 0;
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
  80128f:	eb 18                	jmp    8012a9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	0f b6 d0             	movzbl %al,%edx
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	0f b6 c0             	movzbl %al,%eax
  8012a5:	29 c2                	sub    %eax,%edx
  8012a7:	89 d0                	mov    %edx,%eax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 0c          	sub    $0xc,%rsp
  8012b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b7:	89 f0                	mov    %esi,%eax
  8012b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012bc:	eb 17                	jmp    8012d5 <strchr+0x2a>
		if (*s == c)
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c8:	75 06                	jne    8012d0 <strchr+0x25>
			return (char *) s;
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	eb 15                	jmp    8012e5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012d0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	0f b6 00             	movzbl (%rax),%eax
  8012dc:	84 c0                	test   %al,%al
  8012de:	75 de                	jne    8012be <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e5:	c9                   	leaveq 
  8012e6:	c3                   	retq   

00000000008012e7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e7:	55                   	push   %rbp
  8012e8:	48 89 e5             	mov    %rsp,%rbp
  8012eb:	48 83 ec 0c          	sub    $0xc,%rsp
  8012ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f3:	89 f0                	mov    %esi,%eax
  8012f5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012f8:	eb 13                	jmp    80130d <strfind+0x26>
		if (*s == c)
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	0f b6 00             	movzbl (%rax),%eax
  801301:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801304:	75 02                	jne    801308 <strfind+0x21>
			break;
  801306:	eb 10                	jmp    801318 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801308:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	84 c0                	test   %al,%al
  801316:	75 e2                	jne    8012fa <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80131c:	c9                   	leaveq 
  80131d:	c3                   	retq   

000000000080131e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80131e:	55                   	push   %rbp
  80131f:	48 89 e5             	mov    %rsp,%rbp
  801322:	48 83 ec 18          	sub    $0x18,%rsp
  801326:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80132d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801331:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801336:	75 06                	jne    80133e <memset+0x20>
		return v;
  801338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133c:	eb 69                	jmp    8013a7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80133e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801342:	83 e0 03             	and    $0x3,%eax
  801345:	48 85 c0             	test   %rax,%rax
  801348:	75 48                	jne    801392 <memset+0x74>
  80134a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134e:	83 e0 03             	and    $0x3,%eax
  801351:	48 85 c0             	test   %rax,%rax
  801354:	75 3c                	jne    801392 <memset+0x74>
		c &= 0xFF;
  801356:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80135d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801360:	c1 e0 18             	shl    $0x18,%eax
  801363:	89 c2                	mov    %eax,%edx
  801365:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801368:	c1 e0 10             	shl    $0x10,%eax
  80136b:	09 c2                	or     %eax,%edx
  80136d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801370:	c1 e0 08             	shl    $0x8,%eax
  801373:	09 d0                	or     %edx,%eax
  801375:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801378:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137c:	48 c1 e8 02          	shr    $0x2,%rax
  801380:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801383:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801387:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138a:	48 89 d7             	mov    %rdx,%rdi
  80138d:	fc                   	cld    
  80138e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801390:	eb 11                	jmp    8013a3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801392:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801396:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801399:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80139d:	48 89 d7             	mov    %rdx,%rdi
  8013a0:	fc                   	cld    
  8013a1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013a7:	c9                   	leaveq 
  8013a8:	c3                   	retq   

00000000008013a9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013a9:	55                   	push   %rbp
  8013aa:	48 89 e5             	mov    %rsp,%rbp
  8013ad:	48 83 ec 28          	sub    $0x28,%rsp
  8013b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d5:	0f 83 88 00 00 00    	jae    801463 <memmove+0xba>
  8013db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e3:	48 01 d0             	add    %rdx,%rax
  8013e6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ea:	76 77                	jbe    801463 <memmove+0xba>
		s += n;
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	83 e0 03             	and    $0x3,%eax
  801403:	48 85 c0             	test   %rax,%rax
  801406:	75 3b                	jne    801443 <memmove+0x9a>
  801408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140c:	83 e0 03             	and    $0x3,%eax
  80140f:	48 85 c0             	test   %rax,%rax
  801412:	75 2f                	jne    801443 <memmove+0x9a>
  801414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801418:	83 e0 03             	and    $0x3,%eax
  80141b:	48 85 c0             	test   %rax,%rax
  80141e:	75 23                	jne    801443 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801424:	48 83 e8 04          	sub    $0x4,%rax
  801428:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142c:	48 83 ea 04          	sub    $0x4,%rdx
  801430:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801434:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801438:	48 89 c7             	mov    %rax,%rdi
  80143b:	48 89 d6             	mov    %rdx,%rsi
  80143e:	fd                   	std    
  80143f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801441:	eb 1d                	jmp    801460 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801447:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80144b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	48 89 d7             	mov    %rdx,%rdi
  80145a:	48 89 c1             	mov    %rax,%rcx
  80145d:	fd                   	std    
  80145e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801460:	fc                   	cld    
  801461:	eb 57                	jmp    8014ba <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801467:	83 e0 03             	and    $0x3,%eax
  80146a:	48 85 c0             	test   %rax,%rax
  80146d:	75 36                	jne    8014a5 <memmove+0xfc>
  80146f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801473:	83 e0 03             	and    $0x3,%eax
  801476:	48 85 c0             	test   %rax,%rax
  801479:	75 2a                	jne    8014a5 <memmove+0xfc>
  80147b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147f:	83 e0 03             	and    $0x3,%eax
  801482:	48 85 c0             	test   %rax,%rax
  801485:	75 1e                	jne    8014a5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148b:	48 c1 e8 02          	shr    $0x2,%rax
  80148f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801496:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149a:	48 89 c7             	mov    %rax,%rdi
  80149d:	48 89 d6             	mov    %rdx,%rsi
  8014a0:	fc                   	cld    
  8014a1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a3:	eb 15                	jmp    8014ba <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ad:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014b1:	48 89 c7             	mov    %rax,%rdi
  8014b4:	48 89 d6             	mov    %rdx,%rsi
  8014b7:	fc                   	cld    
  8014b8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 18          	sub    $0x18,%rsp
  8014c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	48 89 ce             	mov    %rcx,%rsi
  8014e3:	48 89 c7             	mov    %rax,%rdi
  8014e6:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  8014ed:	00 00 00 
  8014f0:	ff d0                	callq  *%rax
}
  8014f2:	c9                   	leaveq 
  8014f3:	c3                   	retq   

00000000008014f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014f4:	55                   	push   %rbp
  8014f5:	48 89 e5             	mov    %rsp,%rbp
  8014f8:	48 83 ec 28          	sub    $0x28,%rsp
  8014fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801510:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801514:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801518:	eb 36                	jmp    801550 <memcmp+0x5c>
		if (*s1 != *s2)
  80151a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151e:	0f b6 10             	movzbl (%rax),%edx
  801521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	38 c2                	cmp    %al,%dl
  80152a:	74 1a                	je     801546 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80152c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	0f b6 d0             	movzbl %al,%edx
  801536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	0f b6 c0             	movzbl %al,%eax
  801540:	29 c2                	sub    %eax,%edx
  801542:	89 d0                	mov    %edx,%eax
  801544:	eb 20                	jmp    801566 <memcmp+0x72>
		s1++, s2++;
  801546:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801554:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801558:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80155c:	48 85 c0             	test   %rax,%rax
  80155f:	75 b9                	jne    80151a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801566:	c9                   	leaveq 
  801567:	c3                   	retq   

0000000000801568 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801568:	55                   	push   %rbp
  801569:	48 89 e5             	mov    %rsp,%rbp
  80156c:	48 83 ec 28          	sub    $0x28,%rsp
  801570:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801574:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801577:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801583:	48 01 d0             	add    %rdx,%rax
  801586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80158a:	eb 15                	jmp    8015a1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80158c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801590:	0f b6 10             	movzbl (%rax),%edx
  801593:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801596:	38 c2                	cmp    %al,%dl
  801598:	75 02                	jne    80159c <memfind+0x34>
			break;
  80159a:	eb 0f                	jmp    8015ab <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80159c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015a9:	72 e1                	jb     80158c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015af:	c9                   	leaveq 
  8015b0:	c3                   	retq   

00000000008015b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015b1:	55                   	push   %rbp
  8015b2:	48 89 e5             	mov    %rsp,%rbp
  8015b5:	48 83 ec 34          	sub    $0x34,%rsp
  8015b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015c1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015cb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015d2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d3:	eb 05                	jmp    8015da <strtol+0x29>
		s++;
  8015d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 20                	cmp    $0x20,%al
  8015e3:	74 f0                	je     8015d5 <strtol+0x24>
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	3c 09                	cmp    $0x9,%al
  8015ee:	74 e5                	je     8015d5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3c 2b                	cmp    $0x2b,%al
  8015f9:	75 07                	jne    801602 <strtol+0x51>
		s++;
  8015fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801600:	eb 17                	jmp    801619 <strtol+0x68>
	else if (*s == '-')
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 2d                	cmp    $0x2d,%al
  80160b:	75 0c                	jne    801619 <strtol+0x68>
		s++, neg = 1;
  80160d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801612:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801619:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161d:	74 06                	je     801625 <strtol+0x74>
  80161f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801623:	75 28                	jne    80164d <strtol+0x9c>
  801625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801629:	0f b6 00             	movzbl (%rax),%eax
  80162c:	3c 30                	cmp    $0x30,%al
  80162e:	75 1d                	jne    80164d <strtol+0x9c>
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	48 83 c0 01          	add    $0x1,%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 78                	cmp    $0x78,%al
  80163d:	75 0e                	jne    80164d <strtol+0x9c>
		s += 2, base = 16;
  80163f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801644:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80164b:	eb 2c                	jmp    801679 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80164d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801651:	75 19                	jne    80166c <strtol+0xbb>
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	3c 30                	cmp    $0x30,%al
  80165c:	75 0e                	jne    80166c <strtol+0xbb>
		s++, base = 8;
  80165e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801663:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80166a:	eb 0d                	jmp    801679 <strtol+0xc8>
	else if (base == 0)
  80166c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801670:	75 07                	jne    801679 <strtol+0xc8>
		base = 10;
  801672:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	3c 2f                	cmp    $0x2f,%al
  801682:	7e 1d                	jle    8016a1 <strtol+0xf0>
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	3c 39                	cmp    $0x39,%al
  80168d:	7f 12                	jg     8016a1 <strtol+0xf0>
			dig = *s - '0';
  80168f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801693:	0f b6 00             	movzbl (%rax),%eax
  801696:	0f be c0             	movsbl %al,%eax
  801699:	83 e8 30             	sub    $0x30,%eax
  80169c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169f:	eb 4e                	jmp    8016ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 60                	cmp    $0x60,%al
  8016aa:	7e 1d                	jle    8016c9 <strtol+0x118>
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	3c 7a                	cmp    $0x7a,%al
  8016b5:	7f 12                	jg     8016c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f be c0             	movsbl %al,%eax
  8016c1:	83 e8 57             	sub    $0x57,%eax
  8016c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c7:	eb 26                	jmp    8016ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cd:	0f b6 00             	movzbl (%rax),%eax
  8016d0:	3c 40                	cmp    $0x40,%al
  8016d2:	7e 48                	jle    80171c <strtol+0x16b>
  8016d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	3c 5a                	cmp    $0x5a,%al
  8016dd:	7f 3d                	jg     80171c <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	0f b6 00             	movzbl (%rax),%eax
  8016e6:	0f be c0             	movsbl %al,%eax
  8016e9:	83 e8 37             	sub    $0x37,%eax
  8016ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016f5:	7c 02                	jl     8016f9 <strtol+0x148>
			break;
  8016f7:	eb 23                	jmp    80171c <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016fe:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801701:	48 98                	cltq   
  801703:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801708:	48 89 c2             	mov    %rax,%rdx
  80170b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170e:	48 98                	cltq   
  801710:	48 01 d0             	add    %rdx,%rax
  801713:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801717:	e9 5d ff ff ff       	jmpq   801679 <strtol+0xc8>

	if (endptr)
  80171c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801721:	74 0b                	je     80172e <strtol+0x17d>
		*endptr = (char *) s;
  801723:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801727:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80172b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80172e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801732:	74 09                	je     80173d <strtol+0x18c>
  801734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801738:	48 f7 d8             	neg    %rax
  80173b:	eb 04                	jmp    801741 <strtol+0x190>
  80173d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801741:	c9                   	leaveq 
  801742:	c3                   	retq   

0000000000801743 <strstr>:

char * strstr(const char *in, const char *str)
{
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	48 83 ec 30          	sub    $0x30,%rsp
  80174b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801753:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801757:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80175b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801765:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801769:	75 06                	jne    801771 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	eb 6b                	jmp    8017dc <strstr+0x99>

	len = strlen(str);
  801771:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801775:	48 89 c7             	mov    %rax,%rdi
  801778:	48 b8 19 10 80 00 00 	movabs $0x801019,%rax
  80177f:	00 00 00 
  801782:	ff d0                	callq  *%rax
  801784:	48 98                	cltq   
  801786:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80178a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801792:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80179c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017a0:	75 07                	jne    8017a9 <strstr+0x66>
				return (char *) 0;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a7:	eb 33                	jmp    8017dc <strstr+0x99>
		} while (sc != c);
  8017a9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ad:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017b0:	75 d8                	jne    80178a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017be:	48 89 ce             	mov    %rcx,%rsi
  8017c1:	48 89 c7             	mov    %rax,%rdi
  8017c4:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  8017cb:	00 00 00 
  8017ce:	ff d0                	callq  *%rax
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	75 b6                	jne    80178a <strstr+0x47>

	return (char *) (in - 1);
  8017d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d8:	48 83 e8 01          	sub    $0x1,%rax
}
  8017dc:	c9                   	leaveq 
  8017dd:	c3                   	retq   
