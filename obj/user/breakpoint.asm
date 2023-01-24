
obj/user/breakpoint:     file format elf64-x86-64


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
  80003c:	e8 14 00 00 00       	callq  800055 <libmain>
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
	asm volatile("int $3");
  800052:	cc                   	int3   
}
  800053:	c9                   	leaveq 
  800054:	c3                   	retq   

0000000000800055 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800055:	55                   	push   %rbp
  800056:	48 89 e5             	mov    %rsp,%rbp
  800059:	48 83 ec 10          	sub    $0x10,%rsp
  80005d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800060:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800064:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80006b:	00 00 00 
  80006e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800079:	7e 14                	jle    80008f <libmain+0x3a>
		binaryname = argv[0];
  80007b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80007f:	48 8b 10             	mov    (%rax),%rdx
  800082:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800089:	00 00 00 
  80008c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80008f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800093:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800096:	48 89 d6             	mov    %rdx,%rsi
  800099:	89 c7                	mov    %eax,%edi
  80009b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000a7:	48 b8 b5 00 80 00 00 	movabs $0x8000b5,%rax
  8000ae:	00 00 00 
  8000b1:	ff d0                	callq  *%rax
}
  8000b3:	c9                   	leaveq 
  8000b4:	c3                   	retq   

00000000008000b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b5:	55                   	push   %rbp
  8000b6:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8000be:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
}
  8000ca:	5d                   	pop    %rbp
  8000cb:	c3                   	retq   

00000000008000cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000cc:	55                   	push   %rbp
  8000cd:	48 89 e5             	mov    %rsp,%rbp
  8000d0:	53                   	push   %rbx
  8000d1:	48 83 ec 48          	sub    $0x48,%rsp
  8000d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000d8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000db:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000df:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000e3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000e7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8000ee:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8000f2:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8000f6:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8000fa:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8000fe:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800102:	4c 89 c3             	mov    %r8,%rbx
  800105:	cd 30                	int    $0x30
  800107:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80010b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80010f:	74 3e                	je     80014f <syscall+0x83>
  800111:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800116:	7e 37                	jle    80014f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800118:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80011c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80011f:	49 89 d0             	mov    %rdx,%r8
  800122:	89 c1                	mov    %eax,%ecx
  800124:	48 ba ca 17 80 00 00 	movabs $0x8017ca,%rdx
  80012b:	00 00 00 
  80012e:	be 23 00 00 00       	mov    $0x23,%esi
  800133:	48 bf e7 17 80 00 00 	movabs $0x8017e7,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	49 b9 64 02 80 00 00 	movabs $0x800264,%r9
  800149:	00 00 00 
  80014c:	41 ff d1             	callq  *%r9

	return ret;
  80014f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800153:	48 83 c4 48          	add    $0x48,%rsp
  800157:	5b                   	pop    %rbx
  800158:	5d                   	pop    %rbp
  800159:	c3                   	retq   

000000000080015a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80015a:	55                   	push   %rbp
  80015b:	48 89 e5             	mov    %rsp,%rbp
  80015e:	48 83 ec 20          	sub    $0x20,%rsp
  800162:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800166:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80016a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80016e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800172:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800179:	00 
  80017a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800180:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800186:	48 89 d1             	mov    %rdx,%rcx
  800189:	48 89 c2             	mov    %rax,%rdx
  80018c:	be 00 00 00 00       	mov    $0x0,%esi
  800191:	bf 00 00 00 00       	mov    $0x0,%edi
  800196:	48 b8 cc 00 80 00 00 	movabs $0x8000cc,%rax
  80019d:	00 00 00 
  8001a0:	ff d0                	callq  *%rax
}
  8001a2:	c9                   	leaveq 
  8001a3:	c3                   	retq   

00000000008001a4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001a4:	55                   	push   %rbp
  8001a5:	48 89 e5             	mov    %rsp,%rbp
  8001a8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b3:	00 
  8001b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ca:	be 00 00 00 00       	mov    $0x0,%esi
  8001cf:	bf 01 00 00 00       	mov    $0x1,%edi
  8001d4:	48 b8 cc 00 80 00 00 	movabs $0x8000cc,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	callq  *%rax
}
  8001e0:	c9                   	leaveq 
  8001e1:	c3                   	retq   

00000000008001e2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001e2:	55                   	push   %rbp
  8001e3:	48 89 e5             	mov    %rsp,%rbp
  8001e6:	48 83 ec 10          	sub    $0x10,%rsp
  8001ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f0:	48 98                	cltq   
  8001f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f9:	00 
  8001fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800200:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800206:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020b:	48 89 c2             	mov    %rax,%rdx
  80020e:	be 01 00 00 00       	mov    $0x1,%esi
  800213:	bf 03 00 00 00       	mov    $0x3,%edi
  800218:	48 b8 cc 00 80 00 00 	movabs $0x8000cc,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   

0000000000800226 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800226:	55                   	push   %rbp
  800227:	48 89 e5             	mov    %rsp,%rbp
  80022a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80022e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800235:	00 
  800236:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	ba 00 00 00 00       	mov    $0x0,%edx
  80024c:	be 00 00 00 00       	mov    $0x0,%esi
  800251:	bf 02 00 00 00       	mov    $0x2,%edi
  800256:	48 b8 cc 00 80 00 00 	movabs $0x8000cc,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
}
  800262:	c9                   	leaveq 
  800263:	c3                   	retq   

0000000000800264 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800264:	55                   	push   %rbp
  800265:	48 89 e5             	mov    %rsp,%rbp
  800268:	53                   	push   %rbx
  800269:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800270:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800277:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80027d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800284:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800292:	84 c0                	test   %al,%al
  800294:	74 23                	je     8002b9 <_panic+0x55>
  800296:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80029d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ad:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002c0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002c7:	00 00 00 
  8002ca:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d1:	00 00 00 
  8002d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002df:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002e6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ed:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 18             	mov    (%rax),%rbx
  8002fa:	48 b8 26 02 80 00 00 	movabs $0x800226,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
  800306:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80030c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800313:	41 89 c8             	mov    %ecx,%r8d
  800316:	48 89 d1             	mov    %rdx,%rcx
  800319:	48 89 da             	mov    %rbx,%rdx
  80031c:	89 c6                	mov    %eax,%esi
  80031e:	48 bf f8 17 80 00 00 	movabs $0x8017f8,%rdi
  800325:	00 00 00 
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	49 b9 9d 04 80 00 00 	movabs $0x80049d,%r9
  800334:	00 00 00 
  800337:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800341:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800348:	48 89 d6             	mov    %rdx,%rsi
  80034b:	48 89 c7             	mov    %rax,%rdi
  80034e:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
	cprintf("\n");
  80035a:	48 bf 1b 18 80 00 00 	movabs $0x80181b,%rdi
  800361:	00 00 00 
  800364:	b8 00 00 00 00       	mov    $0x0,%eax
  800369:	48 ba 9d 04 80 00 00 	movabs $0x80049d,%rdx
  800370:	00 00 00 
  800373:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800375:	cc                   	int3   
  800376:	eb fd                	jmp    800375 <_panic+0x111>

0000000000800378 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	48 83 ec 10          	sub    $0x10,%rsp
  800380:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800383:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038b:	8b 00                	mov    (%rax),%eax
  80038d:	8d 48 01             	lea    0x1(%rax),%ecx
  800390:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800394:	89 0a                	mov    %ecx,(%rdx)
  800396:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800399:	89 d1                	mov    %edx,%ecx
  80039b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039f:	48 98                	cltq   
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a9:	8b 00                	mov    (%rax),%eax
  8003ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b0:	75 2c                	jne    8003de <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b6:	8b 00                	mov    (%rax),%eax
  8003b8:	48 98                	cltq   
  8003ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003be:	48 83 c2 08          	add    $0x8,%rdx
  8003c2:	48 89 c6             	mov    %rax,%rsi
  8003c5:	48 89 d7             	mov    %rdx,%rdi
  8003c8:	48 b8 5a 01 80 00 00 	movabs $0x80015a,%rax
  8003cf:	00 00 00 
  8003d2:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e2:	8b 40 04             	mov    0x4(%rax),%eax
  8003e5:	8d 50 01             	lea    0x1(%rax),%edx
  8003e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ec:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ef:	c9                   	leaveq 
  8003f0:	c3                   	retq   

00000000008003f1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f1:	55                   	push   %rbp
  8003f2:	48 89 e5             	mov    %rsp,%rbp
  8003f5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003fc:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800403:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80040a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800411:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800418:	48 8b 0a             	mov    (%rdx),%rcx
  80041b:	48 89 08             	mov    %rcx,(%rax)
  80041e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800422:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800426:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80042e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800435:	00 00 00 
    b.cnt = 0;
  800438:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80043f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800442:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800449:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800450:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800457:	48 89 c6             	mov    %rax,%rsi
  80045a:	48 bf 78 03 80 00 00 	movabs $0x800378,%rdi
  800461:	00 00 00 
  800464:	48 b8 50 08 80 00 00 	movabs $0x800850,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800470:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800476:	48 98                	cltq   
  800478:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80047f:	48 83 c2 08          	add    $0x8,%rdx
  800483:	48 89 c6             	mov    %rax,%rsi
  800486:	48 89 d7             	mov    %rdx,%rdi
  800489:	48 b8 5a 01 80 00 00 	movabs $0x80015a,%rax
  800490:	00 00 00 
  800493:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800495:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049b:	c9                   	leaveq 
  80049c:	c3                   	retq   

000000000080049d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80049d:	55                   	push   %rbp
  80049e:	48 89 e5             	mov    %rsp,%rbp
  8004a1:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004af:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004bd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004cb:	84 c0                	test   %al,%al
  8004cd:	74 20                	je     8004ef <cprintf+0x52>
  8004cf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004db:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004df:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004eb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ef:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004f6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004fd:	00 00 00 
  800500:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800507:	00 00 00 
  80050a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800515:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80051c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800523:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80052a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800531:	48 8b 0a             	mov    (%rdx),%rcx
  800534:	48 89 08             	mov    %rcx,(%rax)
  800537:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80053f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800543:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800547:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80054e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800555:	48 89 d6             	mov    %rdx,%rsi
  800558:	48 89 c7             	mov    %rax,%rdi
  80055b:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  800562:	00 00 00 
  800565:	ff d0                	callq  *%rax
  800567:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80056d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800573:	c9                   	leaveq 
  800574:	c3                   	retq   

0000000000800575 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800575:	55                   	push   %rbp
  800576:	48 89 e5             	mov    %rsp,%rbp
  800579:	53                   	push   %rbx
  80057a:	48 83 ec 38          	sub    $0x38,%rsp
  80057e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800582:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800586:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80058a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80058d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800591:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800598:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80059c:	77 3b                	ja     8005d9 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a1:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a5:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b1:	48 f7 f3             	div    %rbx
  8005b4:	48 89 c2             	mov    %rax,%rdx
  8005b7:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005ba:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005bd:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	41 89 f9             	mov    %edi,%r9d
  8005c8:	48 89 c7             	mov    %rax,%rdi
  8005cb:	48 b8 75 05 80 00 00 	movabs $0x800575,%rax
  8005d2:	00 00 00 
  8005d5:	ff d0                	callq  *%rax
  8005d7:	eb 1e                	jmp    8005f7 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d9:	eb 12                	jmp    8005ed <printnum+0x78>
			putch(padc, putdat);
  8005db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005df:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 89 ce             	mov    %rcx,%rsi
  8005e9:	89 d7                	mov    %edx,%edi
  8005eb:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ed:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f5:	7f e4                	jg     8005db <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800603:	48 f7 f1             	div    %rcx
  800606:	48 89 d0             	mov    %rdx,%rax
  800609:	48 ba 50 19 80 00 00 	movabs $0x801950,%rdx
  800610:	00 00 00 
  800613:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800617:	0f be d0             	movsbl %al,%edx
  80061a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	48 89 ce             	mov    %rcx,%rsi
  800625:	89 d7                	mov    %edx,%edi
  800627:	ff d0                	callq  *%rax
}
  800629:	48 83 c4 38          	add    $0x38,%rsp
  80062d:	5b                   	pop    %rbx
  80062e:	5d                   	pop    %rbp
  80062f:	c3                   	retq   

0000000000800630 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800630:	55                   	push   %rbp
  800631:	48 89 e5             	mov    %rsp,%rbp
  800634:	48 83 ec 1c          	sub    $0x1c,%rsp
  800638:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80063f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800643:	7e 52                	jle    800697 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800649:	8b 00                	mov    (%rax),%eax
  80064b:	83 f8 30             	cmp    $0x30,%eax
  80064e:	73 24                	jae    800674 <getuint+0x44>
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065c:	8b 00                	mov    (%rax),%eax
  80065e:	89 c0                	mov    %eax,%eax
  800660:	48 01 d0             	add    %rdx,%rax
  800663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800667:	8b 12                	mov    (%rdx),%edx
  800669:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800670:	89 0a                	mov    %ecx,(%rdx)
  800672:	eb 17                	jmp    80068b <getuint+0x5b>
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067c:	48 89 d0             	mov    %rdx,%rax
  80067f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800683:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800687:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068b:	48 8b 00             	mov    (%rax),%rax
  80068e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800692:	e9 a3 00 00 00       	jmpq   80073a <getuint+0x10a>
	else if (lflag)
  800697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069b:	74 4f                	je     8006ec <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80069d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a1:	8b 00                	mov    (%rax),%eax
  8006a3:	83 f8 30             	cmp    $0x30,%eax
  8006a6:	73 24                	jae    8006cc <getuint+0x9c>
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	8b 00                	mov    (%rax),%eax
  8006b6:	89 c0                	mov    %eax,%eax
  8006b8:	48 01 d0             	add    %rdx,%rax
  8006bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bf:	8b 12                	mov    (%rdx),%edx
  8006c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	89 0a                	mov    %ecx,(%rdx)
  8006ca:	eb 17                	jmp    8006e3 <getuint+0xb3>
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d4:	48 89 d0             	mov    %rdx,%rax
  8006d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e3:	48 8b 00             	mov    (%rax),%rax
  8006e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ea:	eb 4e                	jmp    80073a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	8b 00                	mov    (%rax),%eax
  8006f2:	83 f8 30             	cmp    $0x30,%eax
  8006f5:	73 24                	jae    80071b <getuint+0xeb>
  8006f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	8b 00                	mov    (%rax),%eax
  800705:	89 c0                	mov    %eax,%eax
  800707:	48 01 d0             	add    %rdx,%rax
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	8b 12                	mov    (%rdx),%edx
  800710:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800717:	89 0a                	mov    %ecx,(%rdx)
  800719:	eb 17                	jmp    800732 <getuint+0x102>
  80071b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800723:	48 89 d0             	mov    %rdx,%rax
  800726:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800732:	8b 00                	mov    (%rax),%eax
  800734:	89 c0                	mov    %eax,%eax
  800736:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80073e:	c9                   	leaveq 
  80073f:	c3                   	retq   

0000000000800740 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800740:	55                   	push   %rbp
  800741:	48 89 e5             	mov    %rsp,%rbp
  800744:	48 83 ec 1c          	sub    $0x1c,%rsp
  800748:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80074f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800753:	7e 52                	jle    8007a7 <getint+0x67>
		x=va_arg(*ap, long long);
  800755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800759:	8b 00                	mov    (%rax),%eax
  80075b:	83 f8 30             	cmp    $0x30,%eax
  80075e:	73 24                	jae    800784 <getint+0x44>
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	89 c0                	mov    %eax,%eax
  800770:	48 01 d0             	add    %rdx,%rax
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	8b 12                	mov    (%rdx),%edx
  800779:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800780:	89 0a                	mov    %ecx,(%rdx)
  800782:	eb 17                	jmp    80079b <getint+0x5b>
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078c:	48 89 d0             	mov    %rdx,%rax
  80078f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800797:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079b:	48 8b 00             	mov    (%rax),%rax
  80079e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a2:	e9 a3 00 00 00       	jmpq   80084a <getint+0x10a>
	else if (lflag)
  8007a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ab:	74 4f                	je     8007fc <getint+0xbc>
		x=va_arg(*ap, long);
  8007ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b1:	8b 00                	mov    (%rax),%eax
  8007b3:	83 f8 30             	cmp    $0x30,%eax
  8007b6:	73 24                	jae    8007dc <getint+0x9c>
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c4:	8b 00                	mov    (%rax),%eax
  8007c6:	89 c0                	mov    %eax,%eax
  8007c8:	48 01 d0             	add    %rdx,%rax
  8007cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cf:	8b 12                	mov    (%rdx),%edx
  8007d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d8:	89 0a                	mov    %ecx,(%rdx)
  8007da:	eb 17                	jmp    8007f3 <getint+0xb3>
  8007dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e4:	48 89 d0             	mov    %rdx,%rax
  8007e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f3:	48 8b 00             	mov    (%rax),%rax
  8007f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fa:	eb 4e                	jmp    80084a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	8b 00                	mov    (%rax),%eax
  800802:	83 f8 30             	cmp    $0x30,%eax
  800805:	73 24                	jae    80082b <getint+0xeb>
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	8b 00                	mov    (%rax),%eax
  800815:	89 c0                	mov    %eax,%eax
  800817:	48 01 d0             	add    %rdx,%rax
  80081a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081e:	8b 12                	mov    (%rdx),%edx
  800820:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	89 0a                	mov    %ecx,(%rdx)
  800829:	eb 17                	jmp    800842 <getint+0x102>
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800833:	48 89 d0             	mov    %rdx,%rax
  800836:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800842:	8b 00                	mov    (%rax),%eax
  800844:	48 98                	cltq   
  800846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084e:	c9                   	leaveq 
  80084f:	c3                   	retq   

0000000000800850 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800850:	55                   	push   %rbp
  800851:	48 89 e5             	mov    %rsp,%rbp
  800854:	41 54                	push   %r12
  800856:	53                   	push   %rbx
  800857:	48 83 ec 60          	sub    $0x60,%rsp
  80085b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80085f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800863:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800867:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80086f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800873:	48 8b 0a             	mov    (%rdx),%rcx
  800876:	48 89 08             	mov    %rcx,(%rax)
  800879:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80087d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800881:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800885:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800889:	eb 17                	jmp    8008a2 <vprintfmt+0x52>
			if (ch == '\0')
  80088b:	85 db                	test   %ebx,%ebx
  80088d:	0f 84 df 04 00 00    	je     800d72 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800893:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800897:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089b:	48 89 d6             	mov    %rdx,%rsi
  80089e:	89 df                	mov    %ebx,%edi
  8008a0:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008aa:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ae:	0f b6 00             	movzbl (%rax),%eax
  8008b1:	0f b6 d8             	movzbl %al,%ebx
  8008b4:	83 fb 25             	cmp    $0x25,%ebx
  8008b7:	75 d2                	jne    80088b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008bd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e5:	0f b6 00             	movzbl (%rax),%eax
  8008e8:	0f b6 d8             	movzbl %al,%ebx
  8008eb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ee:	83 f8 55             	cmp    $0x55,%eax
  8008f1:	0f 87 47 04 00 00    	ja     800d3e <vprintfmt+0x4ee>
  8008f7:	89 c0                	mov    %eax,%eax
  8008f9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800900:	00 
  800901:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  800908:	00 00 00 
  80090b:	48 01 d0             	add    %rdx,%rax
  80090e:	48 8b 00             	mov    (%rax),%rax
  800911:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800913:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800917:	eb c0                	jmp    8008d9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800919:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80091d:	eb ba                	jmp    8008d9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800926:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800929:	89 d0                	mov    %edx,%eax
  80092b:	c1 e0 02             	shl    $0x2,%eax
  80092e:	01 d0                	add    %edx,%eax
  800930:	01 c0                	add    %eax,%eax
  800932:	01 d8                	add    %ebx,%eax
  800934:	83 e8 30             	sub    $0x30,%eax
  800937:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80093a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093e:	0f b6 00             	movzbl (%rax),%eax
  800941:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800944:	83 fb 2f             	cmp    $0x2f,%ebx
  800947:	7e 0c                	jle    800955 <vprintfmt+0x105>
  800949:	83 fb 39             	cmp    $0x39,%ebx
  80094c:	7f 07                	jg     800955 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800953:	eb d1                	jmp    800926 <vprintfmt+0xd6>
			goto process_precision;
  800955:	eb 58                	jmp    8009af <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800957:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095a:	83 f8 30             	cmp    $0x30,%eax
  80095d:	73 17                	jae    800976 <vprintfmt+0x126>
  80095f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800963:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800966:	89 c0                	mov    %eax,%eax
  800968:	48 01 d0             	add    %rdx,%rax
  80096b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096e:	83 c2 08             	add    $0x8,%edx
  800971:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800974:	eb 0f                	jmp    800985 <vprintfmt+0x135>
  800976:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097a:	48 89 d0             	mov    %rdx,%rax
  80097d:	48 83 c2 08          	add    $0x8,%rdx
  800981:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800985:	8b 00                	mov    (%rax),%eax
  800987:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80098a:	eb 23                	jmp    8009af <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80098c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800990:	79 0c                	jns    80099e <vprintfmt+0x14e>
				width = 0;
  800992:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800999:	e9 3b ff ff ff       	jmpq   8008d9 <vprintfmt+0x89>
  80099e:	e9 36 ff ff ff       	jmpq   8008d9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009aa:	e9 2a ff ff ff       	jmpq   8008d9 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009af:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b3:	79 12                	jns    8009c7 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009b5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b8:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c2:	e9 12 ff ff ff       	jmpq   8008d9 <vprintfmt+0x89>
  8009c7:	e9 0d ff ff ff       	jmpq   8008d9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009d0:	e9 04 ff ff ff       	jmpq   8008d9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d8:	83 f8 30             	cmp    $0x30,%eax
  8009db:	73 17                	jae    8009f4 <vprintfmt+0x1a4>
  8009dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e4:	89 c0                	mov    %eax,%eax
  8009e6:	48 01 d0             	add    %rdx,%rax
  8009e9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ec:	83 c2 08             	add    $0x8,%edx
  8009ef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f2:	eb 0f                	jmp    800a03 <vprintfmt+0x1b3>
  8009f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f8:	48 89 d0             	mov    %rdx,%rax
  8009fb:	48 83 c2 08          	add    $0x8,%rdx
  8009ff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a03:	8b 10                	mov    (%rax),%edx
  800a05:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0d:	48 89 ce             	mov    %rcx,%rsi
  800a10:	89 d7                	mov    %edx,%edi
  800a12:	ff d0                	callq  *%rax
			break;
  800a14:	e9 53 03 00 00       	jmpq   800d6c <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1c:	83 f8 30             	cmp    $0x30,%eax
  800a1f:	73 17                	jae    800a38 <vprintfmt+0x1e8>
  800a21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	89 c0                	mov    %eax,%eax
  800a2a:	48 01 d0             	add    %rdx,%rax
  800a2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a30:	83 c2 08             	add    $0x8,%edx
  800a33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a36:	eb 0f                	jmp    800a47 <vprintfmt+0x1f7>
  800a38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3c:	48 89 d0             	mov    %rdx,%rax
  800a3f:	48 83 c2 08          	add    $0x8,%rdx
  800a43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a47:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a49:	85 db                	test   %ebx,%ebx
  800a4b:	79 02                	jns    800a4f <vprintfmt+0x1ff>
				err = -err;
  800a4d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a4f:	83 fb 15             	cmp    $0x15,%ebx
  800a52:	7f 16                	jg     800a6a <vprintfmt+0x21a>
  800a54:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  800a5b:	00 00 00 
  800a5e:	48 63 d3             	movslq %ebx,%rdx
  800a61:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a65:	4d 85 e4             	test   %r12,%r12
  800a68:	75 2e                	jne    800a98 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a6a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a72:	89 d9                	mov    %ebx,%ecx
  800a74:	48 ba 61 19 80 00 00 	movabs $0x801961,%rdx
  800a7b:	00 00 00 
  800a7e:	48 89 c7             	mov    %rax,%rdi
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	49 b8 7b 0d 80 00 00 	movabs $0x800d7b,%r8
  800a8d:	00 00 00 
  800a90:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a93:	e9 d4 02 00 00       	jmpq   800d6c <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a98:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa0:	4c 89 e1             	mov    %r12,%rcx
  800aa3:	48 ba 6a 19 80 00 00 	movabs $0x80196a,%rdx
  800aaa:	00 00 00 
  800aad:	48 89 c7             	mov    %rax,%rdi
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	49 b8 7b 0d 80 00 00 	movabs $0x800d7b,%r8
  800abc:	00 00 00 
  800abf:	41 ff d0             	callq  *%r8
			break;
  800ac2:	e9 a5 02 00 00       	jmpq   800d6c <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aca:	83 f8 30             	cmp    $0x30,%eax
  800acd:	73 17                	jae    800ae6 <vprintfmt+0x296>
  800acf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad6:	89 c0                	mov    %eax,%eax
  800ad8:	48 01 d0             	add    %rdx,%rax
  800adb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ade:	83 c2 08             	add    $0x8,%edx
  800ae1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae4:	eb 0f                	jmp    800af5 <vprintfmt+0x2a5>
  800ae6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aea:	48 89 d0             	mov    %rdx,%rax
  800aed:	48 83 c2 08          	add    $0x8,%rdx
  800af1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af5:	4c 8b 20             	mov    (%rax),%r12
  800af8:	4d 85 e4             	test   %r12,%r12
  800afb:	75 0a                	jne    800b07 <vprintfmt+0x2b7>
				p = "(null)";
  800afd:	49 bc 6d 19 80 00 00 	movabs $0x80196d,%r12
  800b04:	00 00 00 
			if (width > 0 && padc != '-')
  800b07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0b:	7e 3f                	jle    800b4c <vprintfmt+0x2fc>
  800b0d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b11:	74 39                	je     800b4c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b16:	48 98                	cltq   
  800b18:	48 89 c6             	mov    %rax,%rsi
  800b1b:	4c 89 e7             	mov    %r12,%rdi
  800b1e:	48 b8 27 10 80 00 00 	movabs $0x801027,%rax
  800b25:	00 00 00 
  800b28:	ff d0                	callq  *%rax
  800b2a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b2d:	eb 17                	jmp    800b46 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b2f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b33:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3b:	48 89 ce             	mov    %rcx,%rsi
  800b3e:	89 d7                	mov    %edx,%edi
  800b40:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b46:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4a:	7f e3                	jg     800b2f <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4c:	eb 37                	jmp    800b85 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b52:	74 1e                	je     800b72 <vprintfmt+0x322>
  800b54:	83 fb 1f             	cmp    $0x1f,%ebx
  800b57:	7e 05                	jle    800b5e <vprintfmt+0x30e>
  800b59:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5c:	7e 14                	jle    800b72 <vprintfmt+0x322>
					putch('?', putdat);
  800b5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b66:	48 89 d6             	mov    %rdx,%rsi
  800b69:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b6e:	ff d0                	callq  *%rax
  800b70:	eb 0f                	jmp    800b81 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7a:	48 89 d6             	mov    %rdx,%rsi
  800b7d:	89 df                	mov    %ebx,%edi
  800b7f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b85:	4c 89 e0             	mov    %r12,%rax
  800b88:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b8c:	0f b6 00             	movzbl (%rax),%eax
  800b8f:	0f be d8             	movsbl %al,%ebx
  800b92:	85 db                	test   %ebx,%ebx
  800b94:	74 10                	je     800ba6 <vprintfmt+0x356>
  800b96:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9a:	78 b2                	js     800b4e <vprintfmt+0x2fe>
  800b9c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ba0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba4:	79 a8                	jns    800b4e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba6:	eb 16                	jmp    800bbe <vprintfmt+0x36e>
				putch(' ', putdat);
  800ba8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb0:	48 89 d6             	mov    %rdx,%rsi
  800bb3:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc2:	7f e4                	jg     800ba8 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc4:	e9 a3 01 00 00       	jmpq   800d6c <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bcd:	be 03 00 00 00       	mov    $0x3,%esi
  800bd2:	48 89 c7             	mov    %rax,%rdi
  800bd5:	48 b8 40 07 80 00 00 	movabs $0x800740,%rax
  800bdc:	00 00 00 
  800bdf:	ff d0                	callq  *%rax
  800be1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be9:	48 85 c0             	test   %rax,%rax
  800bec:	79 1d                	jns    800c0b <vprintfmt+0x3bb>
				putch('-', putdat);
  800bee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf6:	48 89 d6             	mov    %rdx,%rsi
  800bf9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bfe:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c04:	48 f7 d8             	neg    %rax
  800c07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c12:	e9 e8 00 00 00       	jmpq   800cff <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1b:	be 03 00 00 00       	mov    $0x3,%esi
  800c20:	48 89 c7             	mov    %rax,%rdi
  800c23:	48 b8 30 06 80 00 00 	movabs $0x800630,%rax
  800c2a:	00 00 00 
  800c2d:	ff d0                	callq  *%rax
  800c2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c33:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3a:	e9 c0 00 00 00       	jmpq   800cff <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c47:	48 89 d6             	mov    %rdx,%rsi
  800c4a:	bf 58 00 00 00       	mov    $0x58,%edi
  800c4f:	ff d0                	callq  *%rax
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
			break;
  800c75:	e9 f2 00 00 00       	jmpq   800d6c <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c82:	48 89 d6             	mov    %rdx,%rsi
  800c85:	bf 30 00 00 00       	mov    $0x30,%edi
  800c8a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c94:	48 89 d6             	mov    %rdx,%rsi
  800c97:	bf 78 00 00 00       	mov    $0x78,%edi
  800c9c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca1:	83 f8 30             	cmp    $0x30,%eax
  800ca4:	73 17                	jae    800cbd <vprintfmt+0x46d>
  800ca6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800caa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cad:	89 c0                	mov    %eax,%eax
  800caf:	48 01 d0             	add    %rdx,%rax
  800cb2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb5:	83 c2 08             	add    $0x8,%edx
  800cb8:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	eb 0f                	jmp    800ccc <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cbd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc1:	48 89 d0             	mov    %rdx,%rax
  800cc4:	48 83 c2 08          	add    $0x8,%rdx
  800cc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccc:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cda:	eb 23                	jmp    800cff <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cdc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce0:	be 03 00 00 00       	mov    $0x3,%esi
  800ce5:	48 89 c7             	mov    %rax,%rdi
  800ce8:	48 b8 30 06 80 00 00 	movabs $0x800630,%rax
  800cef:	00 00 00 
  800cf2:	ff d0                	callq  *%rax
  800cf4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cff:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d04:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d07:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d16:	45 89 c1             	mov    %r8d,%r9d
  800d19:	41 89 f8             	mov    %edi,%r8d
  800d1c:	48 89 c7             	mov    %rax,%rdi
  800d1f:	48 b8 75 05 80 00 00 	movabs $0x800575,%rax
  800d26:	00 00 00 
  800d29:	ff d0                	callq  *%rax
			break;
  800d2b:	eb 3f                	jmp    800d6c <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d35:	48 89 d6             	mov    %rdx,%rsi
  800d38:	89 df                	mov    %ebx,%edi
  800d3a:	ff d0                	callq  *%rax
			break;
  800d3c:	eb 2e                	jmp    800d6c <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d46:	48 89 d6             	mov    %rdx,%rsi
  800d49:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d50:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d55:	eb 05                	jmp    800d5c <vprintfmt+0x50c>
  800d57:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d60:	48 83 e8 01          	sub    $0x1,%rax
  800d64:	0f b6 00             	movzbl (%rax),%eax
  800d67:	3c 25                	cmp    $0x25,%al
  800d69:	75 ec                	jne    800d57 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d6b:	90                   	nop
		}
	}
  800d6c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	e9 30 fb ff ff       	jmpq   8008a2 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d72:	48 83 c4 60          	add    $0x60,%rsp
  800d76:	5b                   	pop    %rbx
  800d77:	41 5c                	pop    %r12
  800d79:	5d                   	pop    %rbp
  800d7a:	c3                   	retq   

0000000000800d7b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d7b:	55                   	push   %rbp
  800d7c:	48 89 e5             	mov    %rsp,%rbp
  800d7f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d86:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d8d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d94:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d9b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da9:	84 c0                	test   %al,%al
  800dab:	74 20                	je     800dcd <printfmt+0x52>
  800dad:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800db5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dbd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dc5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dcd:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ddb:	00 00 00 
  800dde:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800de5:	00 00 00 
  800de8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dec:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dfa:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e01:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e08:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e0f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e16:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e1d:	48 89 c7             	mov    %rax,%rdi
  800e20:	48 b8 50 08 80 00 00 	movabs $0x800850,%rax
  800e27:	00 00 00 
  800e2a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e2c:	c9                   	leaveq 
  800e2d:	c3                   	retq   

0000000000800e2e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2e:	55                   	push   %rbp
  800e2f:	48 89 e5             	mov    %rsp,%rbp
  800e32:	48 83 ec 10          	sub    $0x10,%rsp
  800e36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e41:	8b 40 10             	mov    0x10(%rax),%eax
  800e44:	8d 50 01             	lea    0x1(%rax),%edx
  800e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	48 8b 10             	mov    (%rax),%rdx
  800e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e59:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e5d:	48 39 c2             	cmp    %rax,%rdx
  800e60:	73 17                	jae    800e79 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e66:	48 8b 00             	mov    (%rax),%rax
  800e69:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e71:	48 89 0a             	mov    %rcx,(%rdx)
  800e74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e77:	88 10                	mov    %dl,(%rax)
}
  800e79:	c9                   	leaveq 
  800e7a:	c3                   	retq   

0000000000800e7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e7b:	55                   	push   %rbp
  800e7c:	48 89 e5             	mov    %rsp,%rbp
  800e7f:	48 83 ec 50          	sub    $0x50,%rsp
  800e83:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e87:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e8a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e8e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e92:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e96:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e9a:	48 8b 0a             	mov    (%rdx),%rcx
  800e9d:	48 89 08             	mov    %rcx,(%rax)
  800ea0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ebb:	48 98                	cltq   
  800ebd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ec1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec5:	48 01 d0             	add    %rdx,%rax
  800ec8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ecc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed8:	74 06                	je     800ee0 <vsnprintf+0x65>
  800eda:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ede:	7f 07                	jg     800ee7 <vsnprintf+0x6c>
		return -E_INVAL;
  800ee0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee5:	eb 2f                	jmp    800f16 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ee7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eeb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef3:	48 89 c6             	mov    %rax,%rsi
  800ef6:	48 bf 2e 0e 80 00 00 	movabs $0x800e2e,%rdi
  800efd:	00 00 00 
  800f00:	48 b8 50 08 80 00 00 	movabs $0x800850,%rax
  800f07:	00 00 00 
  800f0a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f10:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f13:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f16:	c9                   	leaveq 
  800f17:	c3                   	retq   

0000000000800f18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f18:	55                   	push   %rbp
  800f19:	48 89 e5             	mov    %rsp,%rbp
  800f1c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f23:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f2a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f45:	84 c0                	test   %al,%al
  800f47:	74 20                	je     800f69 <snprintf+0x51>
  800f49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f69:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f70:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f77:	00 00 00 
  800f7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f81:	00 00 00 
  800f84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fab:	48 8b 0a             	mov    (%rdx),%rcx
  800fae:	48 89 08             	mov    %rcx,(%rax)
  800fb1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fc1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fcf:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fd5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fdc:	48 89 c7             	mov    %rax,%rdi
  800fdf:	48 b8 7b 0e 80 00 00 	movabs $0x800e7b,%rax
  800fe6:	00 00 00 
  800fe9:	ff d0                	callq  *%rax
  800feb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ff1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ff7:	c9                   	leaveq 
  800ff8:	c3                   	retq   

0000000000800ff9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff9:	55                   	push   %rbp
  800ffa:	48 89 e5             	mov    %rsp,%rbp
  800ffd:	48 83 ec 18          	sub    $0x18,%rsp
  801001:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80100c:	eb 09                	jmp    801017 <strlen+0x1e>
		n++;
  80100e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801012:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801017:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101b:	0f b6 00             	movzbl (%rax),%eax
  80101e:	84 c0                	test   %al,%al
  801020:	75 ec                	jne    80100e <strlen+0x15>
		n++;
	return n;
  801022:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 83 ec 20          	sub    $0x20,%rsp
  80102f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801033:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103e:	eb 0e                	jmp    80104e <strnlen+0x27>
		n++;
  801040:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801044:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801049:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80104e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801053:	74 0b                	je     801060 <strnlen+0x39>
  801055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801059:	0f b6 00             	movzbl (%rax),%eax
  80105c:	84 c0                	test   %al,%al
  80105e:	75 e0                	jne    801040 <strnlen+0x19>
		n++;
	return n;
  801060:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801063:	c9                   	leaveq 
  801064:	c3                   	retq   

0000000000801065 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801065:	55                   	push   %rbp
  801066:	48 89 e5             	mov    %rsp,%rbp
  801069:	48 83 ec 20          	sub    $0x20,%rsp
  80106d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801071:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801079:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80107d:	90                   	nop
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801086:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80108a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80108e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801092:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801096:	0f b6 12             	movzbl (%rdx),%edx
  801099:	88 10                	mov    %dl,(%rax)
  80109b:	0f b6 00             	movzbl (%rax),%eax
  80109e:	84 c0                	test   %al,%al
  8010a0:	75 dc                	jne    80107e <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a6:	c9                   	leaveq 
  8010a7:	c3                   	retq   

00000000008010a8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a8:	55                   	push   %rbp
  8010a9:	48 89 e5             	mov    %rsp,%rbp
  8010ac:	48 83 ec 20          	sub    $0x20,%rsp
  8010b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	48 89 c7             	mov    %rax,%rdi
  8010bf:	48 b8 f9 0f 80 00 00 	movabs $0x800ff9,%rax
  8010c6:	00 00 00 
  8010c9:	ff d0                	callq  *%rax
  8010cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d1:	48 63 d0             	movslq %eax,%rdx
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	48 01 c2             	add    %rax,%rdx
  8010db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010df:	48 89 c6             	mov    %rax,%rsi
  8010e2:	48 89 d7             	mov    %rdx,%rdi
  8010e5:	48 b8 65 10 80 00 00 	movabs $0x801065,%rax
  8010ec:	00 00 00 
  8010ef:	ff d0                	callq  *%rax
	return dst;
  8010f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010f5:	c9                   	leaveq 
  8010f6:	c3                   	retq   

00000000008010f7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010f7:	55                   	push   %rbp
  8010f8:	48 89 e5             	mov    %rsp,%rbp
  8010fb:	48 83 ec 28          	sub    $0x28,%rsp
  8010ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801103:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801107:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80110b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801113:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80111a:	00 
  80111b:	eb 2a                	jmp    801147 <strncpy+0x50>
		*dst++ = *src;
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801125:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801129:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112d:	0f b6 12             	movzbl (%rdx),%edx
  801130:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801132:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	84 c0                	test   %al,%al
  80113b:	74 05                	je     801142 <strncpy+0x4b>
			src++;
  80113d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801142:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80114f:	72 cc                	jb     80111d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801155:	c9                   	leaveq 
  801156:	c3                   	retq   

0000000000801157 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801157:	55                   	push   %rbp
  801158:	48 89 e5             	mov    %rsp,%rbp
  80115b:	48 83 ec 28          	sub    $0x28,%rsp
  80115f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801163:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801167:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80116b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801173:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801178:	74 3d                	je     8011b7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80117a:	eb 1d                	jmp    801199 <strlcpy+0x42>
			*dst++ = *src++;
  80117c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801180:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801184:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801188:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80118c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801190:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801194:	0f b6 12             	movzbl (%rdx),%edx
  801197:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801199:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80119e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a3:	74 0b                	je     8011b0 <strlcpy+0x59>
  8011a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a9:	0f b6 00             	movzbl (%rax),%eax
  8011ac:	84 c0                	test   %al,%al
  8011ae:	75 cc                	jne    80117c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bf:	48 29 c2             	sub    %rax,%rdx
  8011c2:	48 89 d0             	mov    %rdx,%rax
}
  8011c5:	c9                   	leaveq 
  8011c6:	c3                   	retq   

00000000008011c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c7:	55                   	push   %rbp
  8011c8:	48 89 e5             	mov    %rsp,%rbp
  8011cb:	48 83 ec 10          	sub    $0x10,%rsp
  8011cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d7:	eb 0a                	jmp    8011e3 <strcmp+0x1c>
		p++, q++;
  8011d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e7:	0f b6 00             	movzbl (%rax),%eax
  8011ea:	84 c0                	test   %al,%al
  8011ec:	74 12                	je     801200 <strcmp+0x39>
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f2:	0f b6 10             	movzbl (%rax),%edx
  8011f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	38 c2                	cmp    %al,%dl
  8011fe:	74 d9                	je     8011d9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	0f b6 d0             	movzbl %al,%edx
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	0f b6 c0             	movzbl %al,%eax
  801214:	29 c2                	sub    %eax,%edx
  801216:	89 d0                	mov    %edx,%eax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 18          	sub    $0x18,%rsp
  801222:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801226:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80122e:	eb 0f                	jmp    80123f <strncmp+0x25>
		n--, p++, q++;
  801230:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801235:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80123f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801244:	74 1d                	je     801263 <strncmp+0x49>
  801246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124a:	0f b6 00             	movzbl (%rax),%eax
  80124d:	84 c0                	test   %al,%al
  80124f:	74 12                	je     801263 <strncmp+0x49>
  801251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801255:	0f b6 10             	movzbl (%rax),%edx
  801258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125c:	0f b6 00             	movzbl (%rax),%eax
  80125f:	38 c2                	cmp    %al,%dl
  801261:	74 cd                	je     801230 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801263:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801268:	75 07                	jne    801271 <strncmp+0x57>
		return 0;
  80126a:	b8 00 00 00 00       	mov    $0x0,%eax
  80126f:	eb 18                	jmp    801289 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	0f b6 00             	movzbl (%rax),%eax
  801278:	0f b6 d0             	movzbl %al,%edx
  80127b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	0f b6 c0             	movzbl %al,%eax
  801285:	29 c2                	sub    %eax,%edx
  801287:	89 d0                	mov    %edx,%eax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 0c          	sub    $0xc,%rsp
  801293:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801297:	89 f0                	mov    %esi,%eax
  801299:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80129c:	eb 17                	jmp    8012b5 <strchr+0x2a>
		if (*s == c)
  80129e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a8:	75 06                	jne    8012b0 <strchr+0x25>
			return (char *) s;
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	eb 15                	jmp    8012c5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b9:	0f b6 00             	movzbl (%rax),%eax
  8012bc:	84 c0                	test   %al,%al
  8012be:	75 de                	jne    80129e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c5:	c9                   	leaveq 
  8012c6:	c3                   	retq   

00000000008012c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012c7:	55                   	push   %rbp
  8012c8:	48 89 e5             	mov    %rsp,%rbp
  8012cb:	48 83 ec 0c          	sub    $0xc,%rsp
  8012cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d3:	89 f0                	mov    %esi,%eax
  8012d5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d8:	eb 13                	jmp    8012ed <strfind+0x26>
		if (*s == c)
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	0f b6 00             	movzbl (%rax),%eax
  8012e1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e4:	75 02                	jne    8012e8 <strfind+0x21>
			break;
  8012e6:	eb 10                	jmp    8012f8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f1:	0f b6 00             	movzbl (%rax),%eax
  8012f4:	84 c0                	test   %al,%al
  8012f6:	75 e2                	jne    8012da <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012fc:	c9                   	leaveq 
  8012fd:	c3                   	retq   

00000000008012fe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012fe:	55                   	push   %rbp
  8012ff:	48 89 e5             	mov    %rsp,%rbp
  801302:	48 83 ec 18          	sub    $0x18,%rsp
  801306:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80130d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801311:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801316:	75 06                	jne    80131e <memset+0x20>
		return v;
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	eb 69                	jmp    801387 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	83 e0 03             	and    $0x3,%eax
  801325:	48 85 c0             	test   %rax,%rax
  801328:	75 48                	jne    801372 <memset+0x74>
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	83 e0 03             	and    $0x3,%eax
  801331:	48 85 c0             	test   %rax,%rax
  801334:	75 3c                	jne    801372 <memset+0x74>
		c &= 0xFF;
  801336:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80133d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801340:	c1 e0 18             	shl    $0x18,%eax
  801343:	89 c2                	mov    %eax,%edx
  801345:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801348:	c1 e0 10             	shl    $0x10,%eax
  80134b:	09 c2                	or     %eax,%edx
  80134d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801350:	c1 e0 08             	shl    $0x8,%eax
  801353:	09 d0                	or     %edx,%eax
  801355:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135c:	48 c1 e8 02          	shr    $0x2,%rax
  801360:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801363:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801367:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136a:	48 89 d7             	mov    %rdx,%rdi
  80136d:	fc                   	cld    
  80136e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801370:	eb 11                	jmp    801383 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801372:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801376:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801379:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80137d:	48 89 d7             	mov    %rdx,%rdi
  801380:	fc                   	cld    
  801381:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 83 ec 28          	sub    $0x28,%rsp
  801391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80139d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b5:	0f 83 88 00 00 00    	jae    801443 <memmove+0xba>
  8013bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c3:	48 01 d0             	add    %rdx,%rax
  8013c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ca:	76 77                	jbe    801443 <memmove+0xba>
		s += n;
  8013cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e0:	83 e0 03             	and    $0x3,%eax
  8013e3:	48 85 c0             	test   %rax,%rax
  8013e6:	75 3b                	jne    801423 <memmove+0x9a>
  8013e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ec:	83 e0 03             	and    $0x3,%eax
  8013ef:	48 85 c0             	test   %rax,%rax
  8013f2:	75 2f                	jne    801423 <memmove+0x9a>
  8013f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f8:	83 e0 03             	and    $0x3,%eax
  8013fb:	48 85 c0             	test   %rax,%rax
  8013fe:	75 23                	jne    801423 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801404:	48 83 e8 04          	sub    $0x4,%rax
  801408:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140c:	48 83 ea 04          	sub    $0x4,%rdx
  801410:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801414:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801418:	48 89 c7             	mov    %rax,%rdi
  80141b:	48 89 d6             	mov    %rdx,%rsi
  80141e:	fd                   	std    
  80141f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801421:	eb 1d                	jmp    801440 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801427:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80142b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	48 89 d7             	mov    %rdx,%rdi
  80143a:	48 89 c1             	mov    %rax,%rcx
  80143d:	fd                   	std    
  80143e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801440:	fc                   	cld    
  801441:	eb 57                	jmp    80149a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801447:	83 e0 03             	and    $0x3,%eax
  80144a:	48 85 c0             	test   %rax,%rax
  80144d:	75 36                	jne    801485 <memmove+0xfc>
  80144f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801453:	83 e0 03             	and    $0x3,%eax
  801456:	48 85 c0             	test   %rax,%rax
  801459:	75 2a                	jne    801485 <memmove+0xfc>
  80145b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145f:	83 e0 03             	and    $0x3,%eax
  801462:	48 85 c0             	test   %rax,%rax
  801465:	75 1e                	jne    801485 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	48 c1 e8 02          	shr    $0x2,%rax
  80146f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801476:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147a:	48 89 c7             	mov    %rax,%rdi
  80147d:	48 89 d6             	mov    %rdx,%rsi
  801480:	fc                   	cld    
  801481:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801483:	eb 15                	jmp    80149a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801489:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801491:	48 89 c7             	mov    %rax,%rdi
  801494:	48 89 d6             	mov    %rdx,%rsi
  801497:	fc                   	cld    
  801498:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80149a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80149e:	c9                   	leaveq 
  80149f:	c3                   	retq   

00000000008014a0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a0:	55                   	push   %rbp
  8014a1:	48 89 e5             	mov    %rsp,%rbp
  8014a4:	48 83 ec 18          	sub    $0x18,%rsp
  8014a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	48 89 ce             	mov    %rcx,%rsi
  8014c3:	48 89 c7             	mov    %rax,%rdi
  8014c6:	48 b8 89 13 80 00 00 	movabs $0x801389,%rax
  8014cd:	00 00 00 
  8014d0:	ff d0                	callq  *%rax
}
  8014d2:	c9                   	leaveq 
  8014d3:	c3                   	retq   

00000000008014d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d4:	55                   	push   %rbp
  8014d5:	48 89 e5             	mov    %rsp,%rbp
  8014d8:	48 83 ec 28          	sub    $0x28,%rsp
  8014dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f8:	eb 36                	jmp    801530 <memcmp+0x5c>
		if (*s1 != *s2)
  8014fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fe:	0f b6 10             	movzbl (%rax),%edx
  801501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801505:	0f b6 00             	movzbl (%rax),%eax
  801508:	38 c2                	cmp    %al,%dl
  80150a:	74 1a                	je     801526 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80150c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	0f b6 d0             	movzbl %al,%edx
  801516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	0f b6 c0             	movzbl %al,%eax
  801520:	29 c2                	sub    %eax,%edx
  801522:	89 d0                	mov    %edx,%eax
  801524:	eb 20                	jmp    801546 <memcmp+0x72>
		s1++, s2++;
  801526:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801538:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80153c:	48 85 c0             	test   %rax,%rax
  80153f:	75 b9                	jne    8014fa <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801546:	c9                   	leaveq 
  801547:	c3                   	retq   

0000000000801548 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801548:	55                   	push   %rbp
  801549:	48 89 e5             	mov    %rsp,%rbp
  80154c:	48 83 ec 28          	sub    $0x28,%rsp
  801550:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801554:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801557:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80155b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801563:	48 01 d0             	add    %rdx,%rax
  801566:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80156a:	eb 15                	jmp    801581 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801570:	0f b6 10             	movzbl (%rax),%edx
  801573:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801576:	38 c2                	cmp    %al,%dl
  801578:	75 02                	jne    80157c <memfind+0x34>
			break;
  80157a:	eb 0f                	jmp    80158b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80157c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801589:	72 e1                	jb     80156c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80158b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80158f:	c9                   	leaveq 
  801590:	c3                   	retq   

0000000000801591 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801591:	55                   	push   %rbp
  801592:	48 89 e5             	mov    %rsp,%rbp
  801595:	48 83 ec 34          	sub    $0x34,%rsp
  801599:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015a1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015ab:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015b2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b3:	eb 05                	jmp    8015ba <strtol+0x29>
		s++;
  8015b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015be:	0f b6 00             	movzbl (%rax),%eax
  8015c1:	3c 20                	cmp    $0x20,%al
  8015c3:	74 f0                	je     8015b5 <strtol+0x24>
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	3c 09                	cmp    $0x9,%al
  8015ce:	74 e5                	je     8015b5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3c 2b                	cmp    $0x2b,%al
  8015d9:	75 07                	jne    8015e2 <strtol+0x51>
		s++;
  8015db:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e0:	eb 17                	jmp    8015f9 <strtol+0x68>
	else if (*s == '-')
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	3c 2d                	cmp    $0x2d,%al
  8015eb:	75 0c                	jne    8015f9 <strtol+0x68>
		s++, neg = 1;
  8015ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fd:	74 06                	je     801605 <strtol+0x74>
  8015ff:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801603:	75 28                	jne    80162d <strtol+0x9c>
  801605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 1d                	jne    80162d <strtol+0x9c>
  801610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801614:	48 83 c0 01          	add    $0x1,%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	3c 78                	cmp    $0x78,%al
  80161d:	75 0e                	jne    80162d <strtol+0x9c>
		s += 2, base = 16;
  80161f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801624:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80162b:	eb 2c                	jmp    801659 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80162d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801631:	75 19                	jne    80164c <strtol+0xbb>
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	3c 30                	cmp    $0x30,%al
  80163c:	75 0e                	jne    80164c <strtol+0xbb>
		s++, base = 8;
  80163e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801643:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80164a:	eb 0d                	jmp    801659 <strtol+0xc8>
	else if (base == 0)
  80164c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801650:	75 07                	jne    801659 <strtol+0xc8>
		base = 10;
  801652:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	3c 2f                	cmp    $0x2f,%al
  801662:	7e 1d                	jle    801681 <strtol+0xf0>
  801664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801668:	0f b6 00             	movzbl (%rax),%eax
  80166b:	3c 39                	cmp    $0x39,%al
  80166d:	7f 12                	jg     801681 <strtol+0xf0>
			dig = *s - '0';
  80166f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801673:	0f b6 00             	movzbl (%rax),%eax
  801676:	0f be c0             	movsbl %al,%eax
  801679:	83 e8 30             	sub    $0x30,%eax
  80167c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80167f:	eb 4e                	jmp    8016cf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	0f b6 00             	movzbl (%rax),%eax
  801688:	3c 60                	cmp    $0x60,%al
  80168a:	7e 1d                	jle    8016a9 <strtol+0x118>
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	3c 7a                	cmp    $0x7a,%al
  801695:	7f 12                	jg     8016a9 <strtol+0x118>
			dig = *s - 'a' + 10;
  801697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169b:	0f b6 00             	movzbl (%rax),%eax
  80169e:	0f be c0             	movsbl %al,%eax
  8016a1:	83 e8 57             	sub    $0x57,%eax
  8016a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a7:	eb 26                	jmp    8016cf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	3c 40                	cmp    $0x40,%al
  8016b2:	7e 48                	jle    8016fc <strtol+0x16b>
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	3c 5a                	cmp    $0x5a,%al
  8016bd:	7f 3d                	jg     8016fc <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	0f be c0             	movsbl %al,%eax
  8016c9:	83 e8 37             	sub    $0x37,%eax
  8016cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016d5:	7c 02                	jl     8016d9 <strtol+0x148>
			break;
  8016d7:	eb 23                	jmp    8016fc <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016de:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016e1:	48 98                	cltq   
  8016e3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e8:	48 89 c2             	mov    %rax,%rdx
  8016eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ee:	48 98                	cltq   
  8016f0:	48 01 d0             	add    %rdx,%rax
  8016f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016f7:	e9 5d ff ff ff       	jmpq   801659 <strtol+0xc8>

	if (endptr)
  8016fc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801701:	74 0b                	je     80170e <strtol+0x17d>
		*endptr = (char *) s;
  801703:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801707:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80170b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80170e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801712:	74 09                	je     80171d <strtol+0x18c>
  801714:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801718:	48 f7 d8             	neg    %rax
  80171b:	eb 04                	jmp    801721 <strtol+0x190>
  80171d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801721:	c9                   	leaveq 
  801722:	c3                   	retq   

0000000000801723 <strstr>:

char * strstr(const char *in, const char *str)
{
  801723:	55                   	push   %rbp
  801724:	48 89 e5             	mov    %rsp,%rbp
  801727:	48 83 ec 30          	sub    $0x30,%rsp
  80172b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80172f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801733:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801737:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80173b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801745:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801749:	75 06                	jne    801751 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80174b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174f:	eb 6b                	jmp    8017bc <strstr+0x99>

	len = strlen(str);
  801751:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801755:	48 89 c7             	mov    %rax,%rdi
  801758:	48 b8 f9 0f 80 00 00 	movabs $0x800ff9,%rax
  80175f:	00 00 00 
  801762:	ff d0                	callq  *%rax
  801764:	48 98                	cltq   
  801766:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801772:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801776:	0f b6 00             	movzbl (%rax),%eax
  801779:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80177c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801780:	75 07                	jne    801789 <strstr+0x66>
				return (char *) 0;
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
  801787:	eb 33                	jmp    8017bc <strstr+0x99>
		} while (sc != c);
  801789:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80178d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801790:	75 d8                	jne    80176a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801792:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801796:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179e:	48 89 ce             	mov    %rcx,%rsi
  8017a1:	48 89 c7             	mov    %rax,%rdi
  8017a4:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  8017ab:	00 00 00 
  8017ae:	ff d0                	callq  *%rax
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	75 b6                	jne    80176a <strstr+0x47>

	return (char *) (in - 1);
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	48 83 e8 01          	sub    $0x1,%rax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   
