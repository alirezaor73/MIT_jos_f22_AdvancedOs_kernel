
obj/user/softint:     file format elf64-x86-64


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
  80003c:	e8 15 00 00 00       	callq  800056 <libmain>
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
	asm volatile("int $14");	// page fault
  800052:	cd 0e                	int    $0xe
}
  800054:	c9                   	leaveq 
  800055:	c3                   	retq   

0000000000800056 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800056:	55                   	push   %rbp
  800057:	48 89 e5             	mov    %rsp,%rbp
  80005a:	48 83 ec 10          	sub    $0x10,%rsp
  80005e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800061:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800065:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80006c:	00 00 00 
  80006f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007a:	7e 14                	jle    800090 <libmain+0x3a>
		binaryname = argv[0];
  80007c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800080:	48 8b 10             	mov    (%rax),%rdx
  800083:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80008a:	00 00 00 
  80008d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800090:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800094:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800097:	48 89 d6             	mov    %rdx,%rsi
  80009a:	89 c7                	mov    %eax,%edi
  80009c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000a3:	00 00 00 
  8000a6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000a8:	48 b8 b6 00 80 00 00 	movabs $0x8000b6,%rax
  8000af:	00 00 00 
  8000b2:	ff d0                	callq  *%rax
}
  8000b4:	c9                   	leaveq 
  8000b5:	c3                   	retq   

00000000008000b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b6:	55                   	push   %rbp
  8000b7:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8000bf:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8000c6:	00 00 00 
  8000c9:	ff d0                	callq  *%rax
}
  8000cb:	5d                   	pop    %rbp
  8000cc:	c3                   	retq   

00000000008000cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8000cd:	55                   	push   %rbp
  8000ce:	48 89 e5             	mov    %rsp,%rbp
  8000d1:	53                   	push   %rbx
  8000d2:	48 83 ec 48          	sub    $0x48,%rsp
  8000d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8000d9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8000dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8000e0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8000e4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8000e8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8000ef:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8000f3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8000f7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8000fb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8000ff:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800103:	4c 89 c3             	mov    %r8,%rbx
  800106:	cd 30                	int    $0x30
  800108:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80010c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800110:	74 3e                	je     800150 <syscall+0x83>
  800112:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800117:	7e 37                	jle    800150 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800119:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80011d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800120:	49 89 d0             	mov    %rdx,%r8
  800123:	89 c1                	mov    %eax,%ecx
  800125:	48 ba ca 17 80 00 00 	movabs $0x8017ca,%rdx
  80012c:	00 00 00 
  80012f:	be 23 00 00 00       	mov    $0x23,%esi
  800134:	48 bf e7 17 80 00 00 	movabs $0x8017e7,%rdi
  80013b:	00 00 00 
  80013e:	b8 00 00 00 00       	mov    $0x0,%eax
  800143:	49 b9 65 02 80 00 00 	movabs $0x800265,%r9
  80014a:	00 00 00 
  80014d:	41 ff d1             	callq  *%r9

	return ret;
  800150:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800154:	48 83 c4 48          	add    $0x48,%rsp
  800158:	5b                   	pop    %rbx
  800159:	5d                   	pop    %rbp
  80015a:	c3                   	retq   

000000000080015b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80015b:	55                   	push   %rbp
  80015c:	48 89 e5             	mov    %rsp,%rbp
  80015f:	48 83 ec 20          	sub    $0x20,%rsp
  800163:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800167:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80016b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80016f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800173:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80017a:	00 
  80017b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800181:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800187:	48 89 d1             	mov    %rdx,%rcx
  80018a:	48 89 c2             	mov    %rax,%rdx
  80018d:	be 00 00 00 00       	mov    $0x0,%esi
  800192:	bf 00 00 00 00       	mov    $0x0,%edi
  800197:	48 b8 cd 00 80 00 00 	movabs $0x8000cd,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax
}
  8001a3:	c9                   	leaveq 
  8001a4:	c3                   	retq   

00000000008001a5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001a5:	55                   	push   %rbp
  8001a6:	48 89 e5             	mov    %rsp,%rbp
  8001a9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001b4:	00 
  8001b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8001cb:	be 00 00 00 00       	mov    $0x0,%esi
  8001d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001d5:	48 b8 cd 00 80 00 00 	movabs $0x8000cd,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
  8001eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f1:	48 98                	cltq   
  8001f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fa:	00 
  8001fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800201:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800207:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020c:	48 89 c2             	mov    %rax,%rdx
  80020f:	be 01 00 00 00       	mov    $0x1,%esi
  800214:	bf 03 00 00 00       	mov    $0x3,%edi
  800219:	48 b8 cd 00 80 00 00 	movabs $0x8000cd,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
}
  800225:	c9                   	leaveq 
  800226:	c3                   	retq   

0000000000800227 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800227:	55                   	push   %rbp
  800228:	48 89 e5             	mov    %rsp,%rbp
  80022b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80022f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800236:	00 
  800237:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80023d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800243:	b9 00 00 00 00       	mov    $0x0,%ecx
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	be 00 00 00 00       	mov    $0x0,%esi
  800252:	bf 02 00 00 00       	mov    $0x2,%edi
  800257:	48 b8 cd 00 80 00 00 	movabs $0x8000cd,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
}
  800263:	c9                   	leaveq 
  800264:	c3                   	retq   

0000000000800265 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800265:	55                   	push   %rbp
  800266:	48 89 e5             	mov    %rsp,%rbp
  800269:	53                   	push   %rbx
  80026a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800271:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800278:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80027e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800285:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800293:	84 c0                	test   %al,%al
  800295:	74 23                	je     8002ba <_panic+0x55>
  800297:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80029e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002aa:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ae:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002ba:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002c1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002c8:	00 00 00 
  8002cb:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d2:	00 00 00 
  8002d5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d9:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002e0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002e7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ee:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002f5:	00 00 00 
  8002f8:	48 8b 18             	mov    (%rax),%rbx
  8002fb:	48 b8 27 02 80 00 00 	movabs $0x800227,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
  800307:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80030d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800314:	41 89 c8             	mov    %ecx,%r8d
  800317:	48 89 d1             	mov    %rdx,%rcx
  80031a:	48 89 da             	mov    %rbx,%rdx
  80031d:	89 c6                	mov    %eax,%esi
  80031f:	48 bf f8 17 80 00 00 	movabs $0x8017f8,%rdi
  800326:	00 00 00 
  800329:	b8 00 00 00 00       	mov    $0x0,%eax
  80032e:	49 b9 9e 04 80 00 00 	movabs $0x80049e,%r9
  800335:	00 00 00 
  800338:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800342:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800349:	48 89 d6             	mov    %rdx,%rsi
  80034c:	48 89 c7             	mov    %rax,%rdi
  80034f:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  800356:	00 00 00 
  800359:	ff d0                	callq  *%rax
	cprintf("\n");
  80035b:	48 bf 1b 18 80 00 00 	movabs $0x80181b,%rdi
  800362:	00 00 00 
  800365:	b8 00 00 00 00       	mov    $0x0,%eax
  80036a:	48 ba 9e 04 80 00 00 	movabs $0x80049e,%rdx
  800371:	00 00 00 
  800374:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800376:	cc                   	int3   
  800377:	eb fd                	jmp    800376 <_panic+0x111>

0000000000800379 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800379:	55                   	push   %rbp
  80037a:	48 89 e5             	mov    %rsp,%rbp
  80037d:	48 83 ec 10          	sub    $0x10,%rsp
  800381:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800384:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038c:	8b 00                	mov    (%rax),%eax
  80038e:	8d 48 01             	lea    0x1(%rax),%ecx
  800391:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800395:	89 0a                	mov    %ecx,(%rdx)
  800397:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80039a:	89 d1                	mov    %edx,%ecx
  80039c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a0:	48 98                	cltq   
  8003a2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003aa:	8b 00                	mov    (%rax),%eax
  8003ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b1:	75 2c                	jne    8003df <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b7:	8b 00                	mov    (%rax),%eax
  8003b9:	48 98                	cltq   
  8003bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bf:	48 83 c2 08          	add    $0x8,%rdx
  8003c3:	48 89 c6             	mov    %rax,%rsi
  8003c6:	48 89 d7             	mov    %rdx,%rdi
  8003c9:	48 b8 5b 01 80 00 00 	movabs $0x80015b,%rax
  8003d0:	00 00 00 
  8003d3:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e3:	8b 40 04             	mov    0x4(%rax),%eax
  8003e6:	8d 50 01             	lea    0x1(%rax),%edx
  8003e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ed:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003f0:	c9                   	leaveq 
  8003f1:	c3                   	retq   

00000000008003f2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f2:	55                   	push   %rbp
  8003f3:	48 89 e5             	mov    %rsp,%rbp
  8003f6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003fd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800404:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80040b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800412:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800419:	48 8b 0a             	mov    (%rdx),%rcx
  80041c:	48 89 08             	mov    %rcx,(%rax)
  80041f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800423:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800427:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80042f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800436:	00 00 00 
    b.cnt = 0;
  800439:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800440:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800443:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80044a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800451:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800458:	48 89 c6             	mov    %rax,%rsi
  80045b:	48 bf 79 03 80 00 00 	movabs $0x800379,%rdi
  800462:	00 00 00 
  800465:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  80046c:	00 00 00 
  80046f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800471:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800477:	48 98                	cltq   
  800479:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800480:	48 83 c2 08          	add    $0x8,%rdx
  800484:	48 89 c6             	mov    %rax,%rsi
  800487:	48 89 d7             	mov    %rdx,%rdi
  80048a:	48 b8 5b 01 80 00 00 	movabs $0x80015b,%rax
  800491:	00 00 00 
  800494:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800496:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049c:	c9                   	leaveq 
  80049d:	c3                   	retq   

000000000080049e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80049e:	55                   	push   %rbp
  80049f:	48 89 e5             	mov    %rsp,%rbp
  8004a2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004a9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004b0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004b7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004be:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004cc:	84 c0                	test   %al,%al
  8004ce:	74 20                	je     8004f0 <cprintf+0x52>
  8004d0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004d8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004dc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004e0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004e8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ec:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004f0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004f7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004fe:	00 00 00 
  800501:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800508:	00 00 00 
  80050b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80050f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800516:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80051d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800524:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80052b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800532:	48 8b 0a             	mov    (%rdx),%rcx
  800535:	48 89 08             	mov    %rcx,(%rax)
  800538:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800540:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800544:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800548:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80054f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800556:	48 89 d6             	mov    %rdx,%rsi
  800559:	48 89 c7             	mov    %rax,%rdi
  80055c:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  800563:	00 00 00 
  800566:	ff d0                	callq  *%rax
  800568:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80056e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800574:	c9                   	leaveq 
  800575:	c3                   	retq   

0000000000800576 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800576:	55                   	push   %rbp
  800577:	48 89 e5             	mov    %rsp,%rbp
  80057a:	53                   	push   %rbx
  80057b:	48 83 ec 38          	sub    $0x38,%rsp
  80057f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800583:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800587:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80058b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80058e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800592:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800596:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800599:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80059d:	77 3b                	ja     8005da <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a2:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a6:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	48 f7 f3             	div    %rbx
  8005b5:	48 89 c2             	mov    %rax,%rdx
  8005b8:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005bb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005be:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c6:	41 89 f9             	mov    %edi,%r9d
  8005c9:	48 89 c7             	mov    %rax,%rdi
  8005cc:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  8005d3:	00 00 00 
  8005d6:	ff d0                	callq  *%rax
  8005d8:	eb 1e                	jmp    8005f8 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005da:	eb 12                	jmp    8005ee <printnum+0x78>
			putch(padc, putdat);
  8005dc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	48 89 ce             	mov    %rcx,%rsi
  8005ea:	89 d7                	mov    %edx,%edi
  8005ec:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ee:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f2:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f6:	7f e4                	jg     8005dc <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800604:	48 f7 f1             	div    %rcx
  800607:	48 89 d0             	mov    %rdx,%rax
  80060a:	48 ba 50 19 80 00 00 	movabs $0x801950,%rdx
  800611:	00 00 00 
  800614:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800618:	0f be d0             	movsbl %al,%edx
  80061b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 89 ce             	mov    %rcx,%rsi
  800626:	89 d7                	mov    %edx,%edi
  800628:	ff d0                	callq  *%rax
}
  80062a:	48 83 c4 38          	add    $0x38,%rsp
  80062e:	5b                   	pop    %rbx
  80062f:	5d                   	pop    %rbp
  800630:	c3                   	retq   

0000000000800631 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800631:	55                   	push   %rbp
  800632:	48 89 e5             	mov    %rsp,%rbp
  800635:	48 83 ec 1c          	sub    $0x1c,%rsp
  800639:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80063d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800640:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800644:	7e 52                	jle    800698 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	83 f8 30             	cmp    $0x30,%eax
  80064f:	73 24                	jae    800675 <getuint+0x44>
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	8b 00                	mov    (%rax),%eax
  80065f:	89 c0                	mov    %eax,%eax
  800661:	48 01 d0             	add    %rdx,%rax
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	8b 12                	mov    (%rdx),%edx
  80066a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	89 0a                	mov    %ecx,(%rdx)
  800673:	eb 17                	jmp    80068c <getuint+0x5b>
  800675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800679:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067d:	48 89 d0             	mov    %rdx,%rax
  800680:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800688:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068c:	48 8b 00             	mov    (%rax),%rax
  80068f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800693:	e9 a3 00 00 00       	jmpq   80073b <getuint+0x10a>
	else if (lflag)
  800698:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069c:	74 4f                	je     8006ed <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80069e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a2:	8b 00                	mov    (%rax),%eax
  8006a4:	83 f8 30             	cmp    $0x30,%eax
  8006a7:	73 24                	jae    8006cd <getuint+0x9c>
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	8b 00                	mov    (%rax),%eax
  8006b7:	89 c0                	mov    %eax,%eax
  8006b9:	48 01 d0             	add    %rdx,%rax
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	8b 12                	mov    (%rdx),%edx
  8006c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	89 0a                	mov    %ecx,(%rdx)
  8006cb:	eb 17                	jmp    8006e4 <getuint+0xb3>
  8006cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d5:	48 89 d0             	mov    %rdx,%rax
  8006d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e4:	48 8b 00             	mov    (%rax),%rax
  8006e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006eb:	eb 4e                	jmp    80073b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	8b 00                	mov    (%rax),%eax
  8006f3:	83 f8 30             	cmp    $0x30,%eax
  8006f6:	73 24                	jae    80071c <getuint+0xeb>
  8006f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	8b 00                	mov    (%rax),%eax
  800706:	89 c0                	mov    %eax,%eax
  800708:	48 01 d0             	add    %rdx,%rax
  80070b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070f:	8b 12                	mov    (%rdx),%edx
  800711:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800718:	89 0a                	mov    %ecx,(%rdx)
  80071a:	eb 17                	jmp    800733 <getuint+0x102>
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800724:	48 89 d0             	mov    %rdx,%rax
  800727:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800733:	8b 00                	mov    (%rax),%eax
  800735:	89 c0                	mov    %eax,%eax
  800737:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80073f:	c9                   	leaveq 
  800740:	c3                   	retq   

0000000000800741 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800741:	55                   	push   %rbp
  800742:	48 89 e5             	mov    %rsp,%rbp
  800745:	48 83 ec 1c          	sub    $0x1c,%rsp
  800749:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800750:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800754:	7e 52                	jle    8007a8 <getint+0x67>
		x=va_arg(*ap, long long);
  800756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075a:	8b 00                	mov    (%rax),%eax
  80075c:	83 f8 30             	cmp    $0x30,%eax
  80075f:	73 24                	jae    800785 <getint+0x44>
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	89 c0                	mov    %eax,%eax
  800771:	48 01 d0             	add    %rdx,%rax
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	8b 12                	mov    (%rdx),%edx
  80077a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	89 0a                	mov    %ecx,(%rdx)
  800783:	eb 17                	jmp    80079c <getint+0x5b>
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078d:	48 89 d0             	mov    %rdx,%rax
  800790:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800798:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079c:	48 8b 00             	mov    (%rax),%rax
  80079f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a3:	e9 a3 00 00 00       	jmpq   80084b <getint+0x10a>
	else if (lflag)
  8007a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ac:	74 4f                	je     8007fd <getint+0xbc>
		x=va_arg(*ap, long);
  8007ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b2:	8b 00                	mov    (%rax),%eax
  8007b4:	83 f8 30             	cmp    $0x30,%eax
  8007b7:	73 24                	jae    8007dd <getint+0x9c>
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	89 c0                	mov    %eax,%eax
  8007c9:	48 01 d0             	add    %rdx,%rax
  8007cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d0:	8b 12                	mov    (%rdx),%edx
  8007d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	89 0a                	mov    %ecx,(%rdx)
  8007db:	eb 17                	jmp    8007f4 <getint+0xb3>
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e5:	48 89 d0             	mov    %rdx,%rax
  8007e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f4:	48 8b 00             	mov    (%rax),%rax
  8007f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fb:	eb 4e                	jmp    80084b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800801:	8b 00                	mov    (%rax),%eax
  800803:	83 f8 30             	cmp    $0x30,%eax
  800806:	73 24                	jae    80082c <getint+0xeb>
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	8b 00                	mov    (%rax),%eax
  800816:	89 c0                	mov    %eax,%eax
  800818:	48 01 d0             	add    %rdx,%rax
  80081b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081f:	8b 12                	mov    (%rdx),%edx
  800821:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800824:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800828:	89 0a                	mov    %ecx,(%rdx)
  80082a:	eb 17                	jmp    800843 <getint+0x102>
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800834:	48 89 d0             	mov    %rdx,%rax
  800837:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800843:	8b 00                	mov    (%rax),%eax
  800845:	48 98                	cltq   
  800847:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084f:	c9                   	leaveq 
  800850:	c3                   	retq   

0000000000800851 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800851:	55                   	push   %rbp
  800852:	48 89 e5             	mov    %rsp,%rbp
  800855:	41 54                	push   %r12
  800857:	53                   	push   %rbx
  800858:	48 83 ec 60          	sub    $0x60,%rsp
  80085c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800860:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800864:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800868:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800870:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800874:	48 8b 0a             	mov    (%rdx),%rcx
  800877:	48 89 08             	mov    %rcx,(%rax)
  80087a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80087e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800882:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800886:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x52>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 df 04 00 00    	je     800d73 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800894:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800898:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089c:	48 89 d6             	mov    %rdx,%rsi
  80089f:	89 df                	mov    %ebx,%edi
  8008a1:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ab:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008af:	0f b6 00             	movzbl (%rax),%eax
  8008b2:	0f b6 d8             	movzbl %al,%ebx
  8008b5:	83 fb 25             	cmp    $0x25,%ebx
  8008b8:	75 d2                	jne    80088c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ba:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008be:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008da:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e6:	0f b6 00             	movzbl (%rax),%eax
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 47 04 00 00    	ja     800d3f <vprintfmt+0x4ee>
  8008f8:	89 c0                	mov    %eax,%eax
  8008fa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800901:	00 
  800902:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  800909:	00 00 00 
  80090c:	48 01 d0             	add    %rdx,%rax
  80090f:	48 8b 00             	mov    (%rax),%rax
  800912:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800914:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800918:	eb c0                	jmp    8008da <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80091a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80091e:	eb ba                	jmp    8008da <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800920:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800927:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80092a:	89 d0                	mov    %edx,%eax
  80092c:	c1 e0 02             	shl    $0x2,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	01 c0                	add    %eax,%eax
  800933:	01 d8                	add    %ebx,%eax
  800935:	83 e8 30             	sub    $0x30,%eax
  800938:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80093b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093f:	0f b6 00             	movzbl (%rax),%eax
  800942:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800945:	83 fb 2f             	cmp    $0x2f,%ebx
  800948:	7e 0c                	jle    800956 <vprintfmt+0x105>
  80094a:	83 fb 39             	cmp    $0x39,%ebx
  80094d:	7f 07                	jg     800956 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800954:	eb d1                	jmp    800927 <vprintfmt+0xd6>
			goto process_precision;
  800956:	eb 58                	jmp    8009b0 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800958:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095b:	83 f8 30             	cmp    $0x30,%eax
  80095e:	73 17                	jae    800977 <vprintfmt+0x126>
  800960:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800964:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800967:	89 c0                	mov    %eax,%eax
  800969:	48 01 d0             	add    %rdx,%rax
  80096c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80096f:	83 c2 08             	add    $0x8,%edx
  800972:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800975:	eb 0f                	jmp    800986 <vprintfmt+0x135>
  800977:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097b:	48 89 d0             	mov    %rdx,%rax
  80097e:	48 83 c2 08          	add    $0x8,%rdx
  800982:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800986:	8b 00                	mov    (%rax),%eax
  800988:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80098b:	eb 23                	jmp    8009b0 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80098d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800991:	79 0c                	jns    80099f <vprintfmt+0x14e>
				width = 0;
  800993:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80099a:	e9 3b ff ff ff       	jmpq   8008da <vprintfmt+0x89>
  80099f:	e9 36 ff ff ff       	jmpq   8008da <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ab:	e9 2a ff ff ff       	jmpq   8008da <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b4:	79 12                	jns    8009c8 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009b6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c3:	e9 12 ff ff ff       	jmpq   8008da <vprintfmt+0x89>
  8009c8:	e9 0d ff ff ff       	jmpq   8008da <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cd:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009d1:	e9 04 ff ff ff       	jmpq   8008da <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d9:	83 f8 30             	cmp    $0x30,%eax
  8009dc:	73 17                	jae    8009f5 <vprintfmt+0x1a4>
  8009de:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e5:	89 c0                	mov    %eax,%eax
  8009e7:	48 01 d0             	add    %rdx,%rax
  8009ea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ed:	83 c2 08             	add    $0x8,%edx
  8009f0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f3:	eb 0f                	jmp    800a04 <vprintfmt+0x1b3>
  8009f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f9:	48 89 d0             	mov    %rdx,%rax
  8009fc:	48 83 c2 08          	add    $0x8,%rdx
  800a00:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a04:	8b 10                	mov    (%rax),%edx
  800a06:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0e:	48 89 ce             	mov    %rcx,%rsi
  800a11:	89 d7                	mov    %edx,%edi
  800a13:	ff d0                	callq  *%rax
			break;
  800a15:	e9 53 03 00 00       	jmpq   800d6d <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1d:	83 f8 30             	cmp    $0x30,%eax
  800a20:	73 17                	jae    800a39 <vprintfmt+0x1e8>
  800a22:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a29:	89 c0                	mov    %eax,%eax
  800a2b:	48 01 d0             	add    %rdx,%rax
  800a2e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a31:	83 c2 08             	add    $0x8,%edx
  800a34:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a37:	eb 0f                	jmp    800a48 <vprintfmt+0x1f7>
  800a39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3d:	48 89 d0             	mov    %rdx,%rax
  800a40:	48 83 c2 08          	add    $0x8,%rdx
  800a44:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a48:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a4a:	85 db                	test   %ebx,%ebx
  800a4c:	79 02                	jns    800a50 <vprintfmt+0x1ff>
				err = -err;
  800a4e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a50:	83 fb 15             	cmp    $0x15,%ebx
  800a53:	7f 16                	jg     800a6b <vprintfmt+0x21a>
  800a55:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  800a5c:	00 00 00 
  800a5f:	48 63 d3             	movslq %ebx,%rdx
  800a62:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a66:	4d 85 e4             	test   %r12,%r12
  800a69:	75 2e                	jne    800a99 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a6b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	89 d9                	mov    %ebx,%ecx
  800a75:	48 ba 61 19 80 00 00 	movabs $0x801961,%rdx
  800a7c:	00 00 00 
  800a7f:	48 89 c7             	mov    %rax,%rdi
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
  800a87:	49 b8 7c 0d 80 00 00 	movabs $0x800d7c,%r8
  800a8e:	00 00 00 
  800a91:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a94:	e9 d4 02 00 00       	jmpq   800d6d <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a99:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa1:	4c 89 e1             	mov    %r12,%rcx
  800aa4:	48 ba 6a 19 80 00 00 	movabs $0x80196a,%rdx
  800aab:	00 00 00 
  800aae:	48 89 c7             	mov    %rax,%rdi
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	49 b8 7c 0d 80 00 00 	movabs $0x800d7c,%r8
  800abd:	00 00 00 
  800ac0:	41 ff d0             	callq  *%r8
			break;
  800ac3:	e9 a5 02 00 00       	jmpq   800d6d <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ac8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acb:	83 f8 30             	cmp    $0x30,%eax
  800ace:	73 17                	jae    800ae7 <vprintfmt+0x296>
  800ad0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad7:	89 c0                	mov    %eax,%eax
  800ad9:	48 01 d0             	add    %rdx,%rax
  800adc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800adf:	83 c2 08             	add    $0x8,%edx
  800ae2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae5:	eb 0f                	jmp    800af6 <vprintfmt+0x2a5>
  800ae7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aeb:	48 89 d0             	mov    %rdx,%rax
  800aee:	48 83 c2 08          	add    $0x8,%rdx
  800af2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af6:	4c 8b 20             	mov    (%rax),%r12
  800af9:	4d 85 e4             	test   %r12,%r12
  800afc:	75 0a                	jne    800b08 <vprintfmt+0x2b7>
				p = "(null)";
  800afe:	49 bc 6d 19 80 00 00 	movabs $0x80196d,%r12
  800b05:	00 00 00 
			if (width > 0 && padc != '-')
  800b08:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0c:	7e 3f                	jle    800b4d <vprintfmt+0x2fc>
  800b0e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b12:	74 39                	je     800b4d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b14:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b17:	48 98                	cltq   
  800b19:	48 89 c6             	mov    %rax,%rsi
  800b1c:	4c 89 e7             	mov    %r12,%rdi
  800b1f:	48 b8 28 10 80 00 00 	movabs $0x801028,%rax
  800b26:	00 00 00 
  800b29:	ff d0                	callq  *%rax
  800b2b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b2e:	eb 17                	jmp    800b47 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b30:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b34:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	48 89 ce             	mov    %rcx,%rsi
  800b3f:	89 d7                	mov    %edx,%edi
  800b41:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b43:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4b:	7f e3                	jg     800b30 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4d:	eb 37                	jmp    800b86 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b53:	74 1e                	je     800b73 <vprintfmt+0x322>
  800b55:	83 fb 1f             	cmp    $0x1f,%ebx
  800b58:	7e 05                	jle    800b5f <vprintfmt+0x30e>
  800b5a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5d:	7e 14                	jle    800b73 <vprintfmt+0x322>
					putch('?', putdat);
  800b5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b67:	48 89 d6             	mov    %rdx,%rsi
  800b6a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b6f:	ff d0                	callq  *%rax
  800b71:	eb 0f                	jmp    800b82 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7b:	48 89 d6             	mov    %rdx,%rsi
  800b7e:	89 df                	mov    %ebx,%edi
  800b80:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b82:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b86:	4c 89 e0             	mov    %r12,%rax
  800b89:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b8d:	0f b6 00             	movzbl (%rax),%eax
  800b90:	0f be d8             	movsbl %al,%ebx
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	74 10                	je     800ba7 <vprintfmt+0x356>
  800b97:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9b:	78 b2                	js     800b4f <vprintfmt+0x2fe>
  800b9d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ba1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba5:	79 a8                	jns    800b4f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba7:	eb 16                	jmp    800bbf <vprintfmt+0x36e>
				putch(' ', putdat);
  800ba9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb1:	48 89 d6             	mov    %rdx,%rsi
  800bb4:	bf 20 00 00 00       	mov    $0x20,%edi
  800bb9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc3:	7f e4                	jg     800ba9 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc5:	e9 a3 01 00 00       	jmpq   800d6d <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bca:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bce:	be 03 00 00 00       	mov    $0x3,%esi
  800bd3:	48 89 c7             	mov    %rax,%rdi
  800bd6:	48 b8 41 07 80 00 00 	movabs $0x800741,%rax
  800bdd:	00 00 00 
  800be0:	ff d0                	callq  *%rax
  800be2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bea:	48 85 c0             	test   %rax,%rax
  800bed:	79 1d                	jns    800c0c <vprintfmt+0x3bb>
				putch('-', putdat);
  800bef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf7:	48 89 d6             	mov    %rdx,%rsi
  800bfa:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bff:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c05:	48 f7 d8             	neg    %rax
  800c08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c13:	e9 e8 00 00 00       	jmpq   800d00 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c18:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1c:	be 03 00 00 00       	mov    $0x3,%esi
  800c21:	48 89 c7             	mov    %rax,%rdi
  800c24:	48 b8 31 06 80 00 00 	movabs $0x800631,%rax
  800c2b:	00 00 00 
  800c2e:	ff d0                	callq  *%rax
  800c30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c34:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3b:	e9 c0 00 00 00       	jmpq   800d00 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c48:	48 89 d6             	mov    %rdx,%rsi
  800c4b:	bf 58 00 00 00       	mov    $0x58,%edi
  800c50:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5a:	48 89 d6             	mov    %rdx,%rsi
  800c5d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c62:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6c:	48 89 d6             	mov    %rdx,%rsi
  800c6f:	bf 58 00 00 00       	mov    $0x58,%edi
  800c74:	ff d0                	callq  *%rax
			break;
  800c76:	e9 f2 00 00 00       	jmpq   800d6d <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c7b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c83:	48 89 d6             	mov    %rdx,%rsi
  800c86:	bf 30 00 00 00       	mov    $0x30,%edi
  800c8b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c95:	48 89 d6             	mov    %rdx,%rsi
  800c98:	bf 78 00 00 00       	mov    $0x78,%edi
  800c9d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	83 f8 30             	cmp    $0x30,%eax
  800ca5:	73 17                	jae    800cbe <vprintfmt+0x46d>
  800ca7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	89 c0                	mov    %eax,%eax
  800cb0:	48 01 d0             	add    %rdx,%rax
  800cb3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb6:	83 c2 08             	add    $0x8,%edx
  800cb9:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbc:	eb 0f                	jmp    800ccd <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800cbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc2:	48 89 d0             	mov    %rdx,%rax
  800cc5:	48 83 c2 08          	add    $0x8,%rdx
  800cc9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccd:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cd4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cdb:	eb 23                	jmp    800d00 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cdd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce1:	be 03 00 00 00       	mov    $0x3,%esi
  800ce6:	48 89 c7             	mov    %rax,%rdi
  800ce9:	48 b8 31 06 80 00 00 	movabs $0x800631,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
  800cf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d00:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d05:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d08:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d17:	45 89 c1             	mov    %r8d,%r9d
  800d1a:	41 89 f8             	mov    %edi,%r8d
  800d1d:	48 89 c7             	mov    %rax,%rdi
  800d20:	48 b8 76 05 80 00 00 	movabs $0x800576,%rax
  800d27:	00 00 00 
  800d2a:	ff d0                	callq  *%rax
			break;
  800d2c:	eb 3f                	jmp    800d6d <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d36:	48 89 d6             	mov    %rdx,%rsi
  800d39:	89 df                	mov    %ebx,%edi
  800d3b:	ff d0                	callq  *%rax
			break;
  800d3d:	eb 2e                	jmp    800d6d <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d47:	48 89 d6             	mov    %rdx,%rsi
  800d4a:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d51:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d56:	eb 05                	jmp    800d5d <vprintfmt+0x50c>
  800d58:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d61:	48 83 e8 01          	sub    $0x1,%rax
  800d65:	0f b6 00             	movzbl (%rax),%eax
  800d68:	3c 25                	cmp    $0x25,%al
  800d6a:	75 ec                	jne    800d58 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d6c:	90                   	nop
		}
	}
  800d6d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6e:	e9 30 fb ff ff       	jmpq   8008a3 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d73:	48 83 c4 60          	add    $0x60,%rsp
  800d77:	5b                   	pop    %rbx
  800d78:	41 5c                	pop    %r12
  800d7a:	5d                   	pop    %rbp
  800d7b:	c3                   	retq   

0000000000800d7c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d7c:	55                   	push   %rbp
  800d7d:	48 89 e5             	mov    %rsp,%rbp
  800d80:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d87:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d8e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d95:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d9c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800daa:	84 c0                	test   %al,%al
  800dac:	74 20                	je     800dce <printfmt+0x52>
  800dae:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800db6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dba:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dbe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dc6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dca:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dce:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dd5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ddc:	00 00 00 
  800ddf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800de6:	00 00 00 
  800de9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ded:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800df4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dfb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e02:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e09:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e10:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e17:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e1e:	48 89 c7             	mov    %rax,%rdi
  800e21:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  800e28:	00 00 00 
  800e2b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e2d:	c9                   	leaveq 
  800e2e:	c3                   	retq   

0000000000800e2f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2f:	55                   	push   %rbp
  800e30:	48 89 e5             	mov    %rsp,%rbp
  800e33:	48 83 ec 10          	sub    $0x10,%rsp
  800e37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e42:	8b 40 10             	mov    0x10(%rax),%eax
  800e45:	8d 50 01             	lea    0x1(%rax),%edx
  800e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e53:	48 8b 10             	mov    (%rax),%rdx
  800e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e5e:	48 39 c2             	cmp    %rax,%rdx
  800e61:	73 17                	jae    800e7a <sprintputch+0x4b>
		*b->buf++ = ch;
  800e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e67:	48 8b 00             	mov    (%rax),%rax
  800e6a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e72:	48 89 0a             	mov    %rcx,(%rdx)
  800e75:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e78:	88 10                	mov    %dl,(%rax)
}
  800e7a:	c9                   	leaveq 
  800e7b:	c3                   	retq   

0000000000800e7c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e7c:	55                   	push   %rbp
  800e7d:	48 89 e5             	mov    %rsp,%rbp
  800e80:	48 83 ec 50          	sub    $0x50,%rsp
  800e84:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e88:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e8b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e8f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e93:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e97:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e9b:	48 8b 0a             	mov    (%rdx),%rcx
  800e9e:	48 89 08             	mov    %rcx,(%rax)
  800ea1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ea5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ead:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ebc:	48 98                	cltq   
  800ebe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ec2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec6:	48 01 d0             	add    %rdx,%rax
  800ec9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ecd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed9:	74 06                	je     800ee1 <vsnprintf+0x65>
  800edb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800edf:	7f 07                	jg     800ee8 <vsnprintf+0x6c>
		return -E_INVAL;
  800ee1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee6:	eb 2f                	jmp    800f17 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ee8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eec:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ef0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef4:	48 89 c6             	mov    %rax,%rsi
  800ef7:	48 bf 2f 0e 80 00 00 	movabs $0x800e2f,%rdi
  800efe:	00 00 00 
  800f01:	48 b8 51 08 80 00 00 	movabs $0x800851,%rax
  800f08:	00 00 00 
  800f0b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f11:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f14:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f17:	c9                   	leaveq 
  800f18:	c3                   	retq   

0000000000800f19 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f19:	55                   	push   %rbp
  800f1a:	48 89 e5             	mov    %rsp,%rbp
  800f1d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f24:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f2b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f31:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f38:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f46:	84 c0                	test   %al,%al
  800f48:	74 20                	je     800f6a <snprintf+0x51>
  800f4a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f52:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f56:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f5a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f62:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f66:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f6a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f71:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f78:	00 00 00 
  800f7b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f82:	00 00 00 
  800f85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f89:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f90:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f97:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f9e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fa5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fac:	48 8b 0a             	mov    (%rdx),%rcx
  800faf:	48 89 08             	mov    %rcx,(%rax)
  800fb2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fc2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fd0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fd6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fdd:	48 89 c7             	mov    %rax,%rdi
  800fe0:	48 b8 7c 0e 80 00 00 	movabs $0x800e7c,%rax
  800fe7:	00 00 00 
  800fea:	ff d0                	callq  *%rax
  800fec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ff2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ff8:	c9                   	leaveq 
  800ff9:	c3                   	retq   

0000000000800ffa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ffa:	55                   	push   %rbp
  800ffb:	48 89 e5             	mov    %rsp,%rbp
  800ffe:	48 83 ec 18          	sub    $0x18,%rsp
  801002:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80100d:	eb 09                	jmp    801018 <strlen+0x1e>
		n++;
  80100f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801013:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101c:	0f b6 00             	movzbl (%rax),%eax
  80101f:	84 c0                	test   %al,%al
  801021:	75 ec                	jne    80100f <strlen+0x15>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801026:	c9                   	leaveq 
  801027:	c3                   	retq   

0000000000801028 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801028:	55                   	push   %rbp
  801029:	48 89 e5             	mov    %rsp,%rbp
  80102c:	48 83 ec 20          	sub    $0x20,%rsp
  801030:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801034:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103f:	eb 0e                	jmp    80104f <strnlen+0x27>
		n++;
  801041:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801045:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80104f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801054:	74 0b                	je     801061 <strnlen+0x39>
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	0f b6 00             	movzbl (%rax),%eax
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e0                	jne    801041 <strnlen+0x19>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801064:	c9                   	leaveq 
  801065:	c3                   	retq   

0000000000801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	48 83 ec 20          	sub    $0x20,%rsp
  80106e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801072:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80107e:	90                   	nop
  80107f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801083:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801087:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80108b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80108f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801093:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801097:	0f b6 12             	movzbl (%rdx),%edx
  80109a:	88 10                	mov    %dl,(%rax)
  80109c:	0f b6 00             	movzbl (%rax),%eax
  80109f:	84 c0                	test   %al,%al
  8010a1:	75 dc                	jne    80107f <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a7:	c9                   	leaveq 
  8010a8:	c3                   	retq   

00000000008010a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a9:	55                   	push   %rbp
  8010aa:	48 89 e5             	mov    %rsp,%rbp
  8010ad:	48 83 ec 20          	sub    $0x20,%rsp
  8010b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bd:	48 89 c7             	mov    %rax,%rdi
  8010c0:	48 b8 fa 0f 80 00 00 	movabs $0x800ffa,%rax
  8010c7:	00 00 00 
  8010ca:	ff d0                	callq  *%rax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d2:	48 63 d0             	movslq %eax,%rdx
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	48 01 c2             	add    %rax,%rdx
  8010dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e0:	48 89 c6             	mov    %rax,%rsi
  8010e3:	48 89 d7             	mov    %rdx,%rdi
  8010e6:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  8010ed:	00 00 00 
  8010f0:	ff d0                	callq  *%rax
	return dst;
  8010f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010f6:	c9                   	leaveq 
  8010f7:	c3                   	retq   

00000000008010f8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010f8:	55                   	push   %rbp
  8010f9:	48 89 e5             	mov    %rsp,%rbp
  8010fc:	48 83 ec 28          	sub    $0x28,%rsp
  801100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801108:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80110c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801110:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801114:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80111b:	00 
  80111c:	eb 2a                	jmp    801148 <strncpy+0x50>
		*dst++ = *src;
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801126:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80112a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112e:	0f b6 12             	movzbl (%rdx),%edx
  801131:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801137:	0f b6 00             	movzbl (%rax),%eax
  80113a:	84 c0                	test   %al,%al
  80113c:	74 05                	je     801143 <strncpy+0x4b>
			src++;
  80113e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801143:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801150:	72 cc                	jb     80111e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 28          	sub    $0x28,%rsp
  801160:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801164:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801168:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801174:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801179:	74 3d                	je     8011b8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80117b:	eb 1d                	jmp    80119a <strlcpy+0x42>
			*dst++ = *src++;
  80117d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801181:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801185:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801189:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80118d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801191:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801195:	0f b6 12             	movzbl (%rdx),%edx
  801198:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80119a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80119f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a4:	74 0b                	je     8011b1 <strlcpy+0x59>
  8011a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011aa:	0f b6 00             	movzbl (%rax),%eax
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 cc                	jne    80117d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c0:	48 29 c2             	sub    %rax,%rdx
  8011c3:	48 89 d0             	mov    %rdx,%rax
}
  8011c6:	c9                   	leaveq 
  8011c7:	c3                   	retq   

00000000008011c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c8:	55                   	push   %rbp
  8011c9:	48 89 e5             	mov    %rsp,%rbp
  8011cc:	48 83 ec 10          	sub    $0x10,%rsp
  8011d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d8:	eb 0a                	jmp    8011e4 <strcmp+0x1c>
		p++, q++;
  8011da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	84 c0                	test   %al,%al
  8011ed:	74 12                	je     801201 <strcmp+0x39>
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	0f b6 10             	movzbl (%rax),%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	38 c2                	cmp    %al,%dl
  8011ff:	74 d9                	je     8011da <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	0f b6 d0             	movzbl %al,%edx
  80120b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120f:	0f b6 00             	movzbl (%rax),%eax
  801212:	0f b6 c0             	movzbl %al,%eax
  801215:	29 c2                	sub    %eax,%edx
  801217:	89 d0                	mov    %edx,%eax
}
  801219:	c9                   	leaveq 
  80121a:	c3                   	retq   

000000000080121b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80121b:	55                   	push   %rbp
  80121c:	48 89 e5             	mov    %rsp,%rbp
  80121f:	48 83 ec 18          	sub    $0x18,%rsp
  801223:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801227:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80122f:	eb 0f                	jmp    801240 <strncmp+0x25>
		n--, p++, q++;
  801231:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801236:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801240:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801245:	74 1d                	je     801264 <strncmp+0x49>
  801247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124b:	0f b6 00             	movzbl (%rax),%eax
  80124e:	84 c0                	test   %al,%al
  801250:	74 12                	je     801264 <strncmp+0x49>
  801252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801256:	0f b6 10             	movzbl (%rax),%edx
  801259:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125d:	0f b6 00             	movzbl (%rax),%eax
  801260:	38 c2                	cmp    %al,%dl
  801262:	74 cd                	je     801231 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801264:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801269:	75 07                	jne    801272 <strncmp+0x57>
		return 0;
  80126b:	b8 00 00 00 00       	mov    $0x0,%eax
  801270:	eb 18                	jmp    80128a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801276:	0f b6 00             	movzbl (%rax),%eax
  801279:	0f b6 d0             	movzbl %al,%edx
  80127c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	0f b6 c0             	movzbl %al,%eax
  801286:	29 c2                	sub    %eax,%edx
  801288:	89 d0                	mov    %edx,%eax
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 0c          	sub    $0xc,%rsp
  801294:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801298:	89 f0                	mov    %esi,%eax
  80129a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80129d:	eb 17                	jmp    8012b6 <strchr+0x2a>
		if (*s == c)
  80129f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a3:	0f b6 00             	movzbl (%rax),%eax
  8012a6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a9:	75 06                	jne    8012b1 <strchr+0x25>
			return (char *) s;
  8012ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012af:	eb 15                	jmp    8012c6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ba:	0f b6 00             	movzbl (%rax),%eax
  8012bd:	84 c0                	test   %al,%al
  8012bf:	75 de                	jne    80129f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 0c          	sub    $0xc,%rsp
  8012d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d4:	89 f0                	mov    %esi,%eax
  8012d6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d9:	eb 13                	jmp    8012ee <strfind+0x26>
		if (*s == c)
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e5:	75 02                	jne    8012e9 <strfind+0x21>
			break;
  8012e7:	eb 10                	jmp    8012f9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	84 c0                	test   %al,%al
  8012f7:	75 e2                	jne    8012db <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012fd:	c9                   	leaveq 
  8012fe:	c3                   	retq   

00000000008012ff <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ff:	55                   	push   %rbp
  801300:	48 89 e5             	mov    %rsp,%rbp
  801303:	48 83 ec 18          	sub    $0x18,%rsp
  801307:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80130e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801312:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801317:	75 06                	jne    80131f <memset+0x20>
		return v;
  801319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131d:	eb 69                	jmp    801388 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80131f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801323:	83 e0 03             	and    $0x3,%eax
  801326:	48 85 c0             	test   %rax,%rax
  801329:	75 48                	jne    801373 <memset+0x74>
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132f:	83 e0 03             	and    $0x3,%eax
  801332:	48 85 c0             	test   %rax,%rax
  801335:	75 3c                	jne    801373 <memset+0x74>
		c &= 0xFF;
  801337:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80133e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801341:	c1 e0 18             	shl    $0x18,%eax
  801344:	89 c2                	mov    %eax,%edx
  801346:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801349:	c1 e0 10             	shl    $0x10,%eax
  80134c:	09 c2                	or     %eax,%edx
  80134e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801351:	c1 e0 08             	shl    $0x8,%eax
  801354:	09 d0                	or     %edx,%eax
  801356:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	48 c1 e8 02          	shr    $0x2,%rax
  801361:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801364:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801368:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136b:	48 89 d7             	mov    %rdx,%rdi
  80136e:	fc                   	cld    
  80136f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801371:	eb 11                	jmp    801384 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801373:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801377:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80137e:	48 89 d7             	mov    %rdx,%rdi
  801381:	fc                   	cld    
  801382:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801388:	c9                   	leaveq 
  801389:	c3                   	retq   

000000000080138a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80138a:	55                   	push   %rbp
  80138b:	48 89 e5             	mov    %rsp,%rbp
  80138e:	48 83 ec 28          	sub    $0x28,%rsp
  801392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801396:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80139e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b6:	0f 83 88 00 00 00    	jae    801444 <memmove+0xba>
  8013bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c4:	48 01 d0             	add    %rdx,%rax
  8013c7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013cb:	76 77                	jbe    801444 <memmove+0xba>
		s += n;
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e1:	83 e0 03             	and    $0x3,%eax
  8013e4:	48 85 c0             	test   %rax,%rax
  8013e7:	75 3b                	jne    801424 <memmove+0x9a>
  8013e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ed:	83 e0 03             	and    $0x3,%eax
  8013f0:	48 85 c0             	test   %rax,%rax
  8013f3:	75 2f                	jne    801424 <memmove+0x9a>
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	48 85 c0             	test   %rax,%rax
  8013ff:	75 23                	jne    801424 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801405:	48 83 e8 04          	sub    $0x4,%rax
  801409:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140d:	48 83 ea 04          	sub    $0x4,%rdx
  801411:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801415:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801419:	48 89 c7             	mov    %rax,%rdi
  80141c:	48 89 d6             	mov    %rdx,%rsi
  80141f:	fd                   	std    
  801420:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801422:	eb 1d                	jmp    801441 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801428:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	48 89 d7             	mov    %rdx,%rdi
  80143b:	48 89 c1             	mov    %rax,%rcx
  80143e:	fd                   	std    
  80143f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801441:	fc                   	cld    
  801442:	eb 57                	jmp    80149b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	83 e0 03             	and    $0x3,%eax
  80144b:	48 85 c0             	test   %rax,%rax
  80144e:	75 36                	jne    801486 <memmove+0xfc>
  801450:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801454:	83 e0 03             	and    $0x3,%eax
  801457:	48 85 c0             	test   %rax,%rax
  80145a:	75 2a                	jne    801486 <memmove+0xfc>
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	83 e0 03             	and    $0x3,%eax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 1e                	jne    801486 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146c:	48 c1 e8 02          	shr    $0x2,%rax
  801470:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801477:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147b:	48 89 c7             	mov    %rax,%rdi
  80147e:	48 89 d6             	mov    %rdx,%rsi
  801481:	fc                   	cld    
  801482:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801484:	eb 15                	jmp    80149b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801492:	48 89 c7             	mov    %rax,%rdi
  801495:	48 89 d6             	mov    %rdx,%rsi
  801498:	fc                   	cld    
  801499:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80149b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80149f:	c9                   	leaveq 
  8014a0:	c3                   	retq   

00000000008014a1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a1:	55                   	push   %rbp
  8014a2:	48 89 e5             	mov    %rsp,%rbp
  8014a5:	48 83 ec 18          	sub    $0x18,%rsp
  8014a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c1:	48 89 ce             	mov    %rcx,%rsi
  8014c4:	48 89 c7             	mov    %rax,%rdi
  8014c7:	48 b8 8a 13 80 00 00 	movabs $0x80138a,%rax
  8014ce:	00 00 00 
  8014d1:	ff d0                	callq  *%rax
}
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 28          	sub    $0x28,%rsp
  8014dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f9:	eb 36                	jmp    801531 <memcmp+0x5c>
		if (*s1 != *s2)
  8014fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ff:	0f b6 10             	movzbl (%rax),%edx
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	38 c2                	cmp    %al,%dl
  80150b:	74 1a                	je     801527 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	0f b6 d0             	movzbl %al,%edx
  801517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151b:	0f b6 00             	movzbl (%rax),%eax
  80151e:	0f b6 c0             	movzbl %al,%eax
  801521:	29 c2                	sub    %eax,%edx
  801523:	89 d0                	mov    %edx,%eax
  801525:	eb 20                	jmp    801547 <memcmp+0x72>
		s1++, s2++;
  801527:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801535:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801539:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80153d:	48 85 c0             	test   %rax,%rax
  801540:	75 b9                	jne    8014fb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801547:	c9                   	leaveq 
  801548:	c3                   	retq   

0000000000801549 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801549:	55                   	push   %rbp
  80154a:	48 89 e5             	mov    %rsp,%rbp
  80154d:	48 83 ec 28          	sub    $0x28,%rsp
  801551:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801555:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801558:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801564:	48 01 d0             	add    %rdx,%rax
  801567:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80156b:	eb 15                	jmp    801582 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801571:	0f b6 10             	movzbl (%rax),%edx
  801574:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801577:	38 c2                	cmp    %al,%dl
  801579:	75 02                	jne    80157d <memfind+0x34>
			break;
  80157b:	eb 0f                	jmp    80158c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80157d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801586:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80158a:	72 e1                	jb     80156d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80158c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 34          	sub    $0x34,%rsp
  80159a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015a2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015ac:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015b3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b4:	eb 05                	jmp    8015bb <strtol+0x29>
		s++;
  8015b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bf:	0f b6 00             	movzbl (%rax),%eax
  8015c2:	3c 20                	cmp    $0x20,%al
  8015c4:	74 f0                	je     8015b6 <strtol+0x24>
  8015c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	3c 09                	cmp    $0x9,%al
  8015cf:	74 e5                	je     8015b6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	0f b6 00             	movzbl (%rax),%eax
  8015d8:	3c 2b                	cmp    $0x2b,%al
  8015da:	75 07                	jne    8015e3 <strtol+0x51>
		s++;
  8015dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e1:	eb 17                	jmp    8015fa <strtol+0x68>
	else if (*s == '-')
  8015e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	3c 2d                	cmp    $0x2d,%al
  8015ec:	75 0c                	jne    8015fa <strtol+0x68>
		s++, neg = 1;
  8015ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fe:	74 06                	je     801606 <strtol+0x74>
  801600:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801604:	75 28                	jne    80162e <strtol+0x9c>
  801606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160a:	0f b6 00             	movzbl (%rax),%eax
  80160d:	3c 30                	cmp    $0x30,%al
  80160f:	75 1d                	jne    80162e <strtol+0x9c>
  801611:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801615:	48 83 c0 01          	add    $0x1,%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	3c 78                	cmp    $0x78,%al
  80161e:	75 0e                	jne    80162e <strtol+0x9c>
		s += 2, base = 16;
  801620:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801625:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80162c:	eb 2c                	jmp    80165a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80162e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801632:	75 19                	jne    80164d <strtol+0xbb>
  801634:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3c 30                	cmp    $0x30,%al
  80163d:	75 0e                	jne    80164d <strtol+0xbb>
		s++, base = 8;
  80163f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801644:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80164b:	eb 0d                	jmp    80165a <strtol+0xc8>
	else if (base == 0)
  80164d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801651:	75 07                	jne    80165a <strtol+0xc8>
		base = 10;
  801653:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80165a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	3c 2f                	cmp    $0x2f,%al
  801663:	7e 1d                	jle    801682 <strtol+0xf0>
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	3c 39                	cmp    $0x39,%al
  80166e:	7f 12                	jg     801682 <strtol+0xf0>
			dig = *s - '0';
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	0f be c0             	movsbl %al,%eax
  80167a:	83 e8 30             	sub    $0x30,%eax
  80167d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801680:	eb 4e                	jmp    8016d0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801686:	0f b6 00             	movzbl (%rax),%eax
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 1d                	jle    8016aa <strtol+0x118>
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 7a                	cmp    $0x7a,%al
  801696:	7f 12                	jg     8016aa <strtol+0x118>
			dig = *s - 'a' + 10;
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	0f be c0             	movsbl %al,%eax
  8016a2:	83 e8 57             	sub    $0x57,%eax
  8016a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a8:	eb 26                	jmp    8016d0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	3c 40                	cmp    $0x40,%al
  8016b3:	7e 48                	jle    8016fd <strtol+0x16b>
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	3c 5a                	cmp    $0x5a,%al
  8016be:	7f 3d                	jg     8016fd <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	83 e8 37             	sub    $0x37,%eax
  8016cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016d6:	7c 02                	jl     8016da <strtol+0x148>
			break;
  8016d8:	eb 23                	jmp    8016fd <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016df:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016e2:	48 98                	cltq   
  8016e4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e9:	48 89 c2             	mov    %rax,%rdx
  8016ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ef:	48 98                	cltq   
  8016f1:	48 01 d0             	add    %rdx,%rax
  8016f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016f8:	e9 5d ff ff ff       	jmpq   80165a <strtol+0xc8>

	if (endptr)
  8016fd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801702:	74 0b                	je     80170f <strtol+0x17d>
		*endptr = (char *) s;
  801704:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801708:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80170c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80170f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801713:	74 09                	je     80171e <strtol+0x18c>
  801715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801719:	48 f7 d8             	neg    %rax
  80171c:	eb 04                	jmp    801722 <strtol+0x190>
  80171e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801722:	c9                   	leaveq 
  801723:	c3                   	retq   

0000000000801724 <strstr>:

char * strstr(const char *in, const char *str)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 30          	sub    $0x30,%rsp
  80172c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801730:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801734:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801738:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80173c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801746:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80174a:	75 06                	jne    801752 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80174c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801750:	eb 6b                	jmp    8017bd <strstr+0x99>

	len = strlen(str);
  801752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801756:	48 89 c7             	mov    %rax,%rdi
  801759:	48 b8 fa 0f 80 00 00 	movabs $0x800ffa,%rax
  801760:	00 00 00 
  801763:	ff d0                	callq  *%rax
  801765:	48 98                	cltq   
  801767:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801773:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801777:	0f b6 00             	movzbl (%rax),%eax
  80177a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80177d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801781:	75 07                	jne    80178a <strstr+0x66>
				return (char *) 0;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	eb 33                	jmp    8017bd <strstr+0x99>
		} while (sc != c);
  80178a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80178e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801791:	75 d8                	jne    80176b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801793:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801797:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	48 89 ce             	mov    %rcx,%rsi
  8017a2:	48 89 c7             	mov    %rax,%rdi
  8017a5:	48 b8 1b 12 80 00 00 	movabs $0x80121b,%rax
  8017ac:	00 00 00 
  8017af:	ff d0                	callq  *%rax
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 b6                	jne    80176b <strstr+0x47>

	return (char *) (in - 1);
  8017b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b9:	48 83 e8 01          	sub    $0x1,%rax
}
  8017bd:	c9                   	leaveq 
  8017be:	c3                   	retq   
