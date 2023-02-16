
obj/user/init:     file format elf64-x86-64


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
  80003c:	e8 6c 06 00 00       	callq  8006ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 1c          	sub    $0x1c,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf 90 44 80 00 00 	movabs $0x804490,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 9a 09 80 00 00 	movabs $0x80099a,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf c9 44 80 00 00 	movabs $0x8044c9,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 80 80 00 00 	movabs $0x808020,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf e0 44 80 00 00 	movabs $0x8044e0,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 0f 45 80 00 00 	movabs $0x80450f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be 25 45 80 00 00 	movabs $0x804525,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 a5 15 80 00 00 	movabs $0x8015a5,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be 31 45 80 00 00 	movabs $0x804531,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 a5 15 80 00 00 	movabs $0x8015a5,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 a5 15 80 00 00 	movabs $0x8015a5,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be 34 45 80 00 00 	movabs $0x804534,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 a5 15 80 00 00 	movabs $0x8015a5,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf 36 45 80 00 00 	movabs $0x804536,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf 3a 45 80 00 00 	movabs $0x80453a,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba 4c 45 80 00 00 	movabs $0x80454c,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf 59 45 80 00 00 	movabs $0x804559,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba 65 45 80 00 00 	movabs $0x804565,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf 59 45 80 00 00 	movabs $0x804559,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 6d 24 80 00 00 	movabs $0x80246d,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 7f 45 80 00 00 	movabs $0x80457f,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf 59 45 80 00 00 	movabs $0x804559,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 87 45 80 00 00 	movabs $0x804587,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 9a 45 80 00 00 	movabs $0x80459a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 9d 45 80 00 00 	movabs $0x80459d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 a2 34 80 00 00 	movabs $0x8034a2,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 23                	jns    8003c9 <umain+0x33c>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf a5 45 80 00 00 	movabs $0x8045a5,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	90                   	nop
		}
		cprintf("init waiting\n");
		wait(r);
	}
  8003c7:	eb 8f                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		cprintf("init waiting\n");
  8003c9:	48 bf b9 45 80 00 00 	movabs $0x8045b9,%rdi
  8003d0:	00 00 00 
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  8003df:	00 00 00 
  8003e2:	ff d2                	callq  *%rdx
		wait(r);
  8003e4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003e7:	89 c7                	mov    %eax,%edi
  8003e9:	48 b8 7a 41 80 00 00 	movabs $0x80417a,%rax
  8003f0:	00 00 00 
  8003f3:	ff d0                	callq  *%rax
	}
  8003f5:	e9 5e ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003fa <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	48 83 ec 20          	sub    $0x20,%rsp
  800402:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800405:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800408:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80040b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80040f:	be 01 00 00 00       	mov    $0x1,%esi
  800414:	48 89 c7             	mov    %rax,%rdi
  800417:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
}
  800423:	c9                   	leaveq 
  800424:	c3                   	retq   

0000000000800425 <getchar>:

int
getchar(void)
{
  800425:	55                   	push   %rbp
  800426:	48 89 e5             	mov    %rsp,%rbp
  800429:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80042d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800431:	ba 01 00 00 00       	mov    $0x1,%edx
  800436:	48 89 c6             	mov    %rax,%rsi
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  800445:	00 00 00 
  800448:	ff d0                	callq  *%rax
  80044a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80044d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800451:	79 05                	jns    800458 <getchar+0x33>
		return r;
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	eb 14                	jmp    80046c <getchar+0x47>
	if (r < 1)
  800458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045c:	7f 07                	jg     800465 <getchar+0x40>
		return -E_EOF;
  80045e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800463:	eb 07                	jmp    80046c <getchar+0x47>
	return c;
  800465:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800469:	0f b6 c0             	movzbl %al,%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	48 83 ec 20          	sub    $0x20,%rsp
  800476:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800479:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80047d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800480:	48 89 d6             	mov    %rdx,%rsi
  800483:	89 c7                	mov    %eax,%edi
  800485:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 05                	jns    80049f <iscons+0x31>
		return r;
  80049a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049d:	eb 1a                	jmp    8004b9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80049f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a3:	8b 10                	mov    (%rax),%edx
  8004a5:	48 b8 80 77 80 00 00 	movabs $0x807780,%rax
  8004ac:	00 00 00 
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	39 c2                	cmp    %eax,%edx
  8004b3:	0f 94 c0             	sete   %al
  8004b6:	0f b6 c0             	movzbl %al,%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <opencons>:

int
opencons(void)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004c3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004c7:	48 89 c7             	mov    %rax,%rdi
  8004ca:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  8004d1:	00 00 00 
  8004d4:	ff d0                	callq  *%rax
  8004d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004dd:	79 05                	jns    8004e4 <opencons+0x29>
		return r;
  8004df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e2:	eb 5b                	jmp    80053f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004f5:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
  800501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800508:	79 05                	jns    80050f <opencons+0x54>
		return r;
  80050a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050d:	eb 30                	jmp    80053f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	48 ba 80 77 80 00 00 	movabs $0x807780,%rdx
  80051a:	00 00 00 
  80051d:	8b 12                	mov    (%rdx),%edx
  80051f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800525:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	48 89 c7             	mov    %rax,%rdi
  800533:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  80053a:	00 00 00 
  80053d:	ff d0                	callq  *%rax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 83 ec 30          	sub    $0x30,%rsp
  800549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800551:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800555:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80055a:	75 07                	jne    800563 <devcons_read+0x22>
		return 0;
  80055c:	b8 00 00 00 00       	mov    $0x0,%eax
  800561:	eb 4b                	jmp    8005ae <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800563:	eb 0c                	jmp    800571 <devcons_read+0x30>
		sys_yield();
  800565:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  80056c:	00 00 00 
  80056f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800571:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  800578:	00 00 00 
  80057b:	ff d0                	callq  *%rax
  80057d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800584:	74 df                	je     800565 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80058a:	79 05                	jns    800591 <devcons_read+0x50>
		return c;
  80058c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058f:	eb 1d                	jmp    8005ae <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800591:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800595:	75 07                	jne    80059e <devcons_read+0x5d>
		return 0;
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	eb 10                	jmp    8005ae <devcons_read+0x6d>
	*(char*)vbuf = c;
  80059e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a1:	89 c2                	mov    %eax,%edx
  8005a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a7:	88 10                	mov    %dl,(%rax)
	return 1;
  8005a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
  8005b4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005bb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005c2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005c9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005d7:	eb 76                	jmp    80064f <devcons_write+0x9f>
		m = n - tot;
  8005d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005e0:	89 c2                	mov    %eax,%edx
  8005e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e5:	29 c2                	sub    %eax,%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005ef:	83 f8 7f             	cmp    $0x7f,%eax
  8005f2:	76 07                	jbe    8005fb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005f4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fe:	48 63 d0             	movslq %eax,%rdx
  800601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800604:	48 63 c8             	movslq %eax,%rcx
  800607:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80060e:	48 01 c1             	add    %rax,%rcx
  800611:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800618:	48 89 ce             	mov    %rcx,%rsi
  80061b:	48 89 c7             	mov    %rax,%rdi
  80061e:	48 b8 86 18 80 00 00 	movabs $0x801886,%rax
  800625:	00 00 00 
  800628:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80062a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062d:	48 63 d0             	movslq %eax,%rdx
  800630:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800637:	48 89 d6             	mov    %rdx,%rsi
  80063a:	48 89 c7             	mov    %rax,%rdi
  80063d:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  800644:	00 00 00 
  800647:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800649:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80064c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80064f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800652:	48 98                	cltq   
  800654:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80065b:	0f 82 78 ff ff ff    	jb     8005d9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800661:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800664:	c9                   	leaveq 
  800665:	c3                   	retq   

0000000000800666 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	48 83 ec 08          	sub    $0x8,%rsp
  80066e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800677:	c9                   	leaveq 
  800678:	c3                   	retq   

0000000000800679 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	48 83 ec 10          	sub    $0x10,%rsp
  800681:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800685:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	48 be cc 45 80 00 00 	movabs $0x8045cc,%rsi
  800694:	00 00 00 
  800697:	48 89 c7             	mov    %rax,%rdi
  80069a:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  8006a1:	00 00 00 
  8006a4:	ff d0                	callq  *%rax
	return 0;
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ab:	c9                   	leaveq 
  8006ac:	c3                   	retq   

00000000008006ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8006ad:	55                   	push   %rbp
  8006ae:	48 89 e5             	mov    %rsp,%rbp
  8006b1:	48 83 ec 20          	sub    $0x20,%rsp
  8006b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8006b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8006bc:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
  8006c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8006cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006d3:	48 63 d0             	movslq %eax,%rdx
  8006d6:	48 89 d0             	mov    %rdx,%rax
  8006d9:	48 c1 e0 03          	shl    $0x3,%rax
  8006dd:	48 01 d0             	add    %rdx,%rax
  8006e0:	48 c1 e0 05          	shl    $0x5,%rax
  8006e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8006eb:	00 00 00 
  8006ee:	48 01 c2             	add    %rax,%rdx
  8006f1:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8006f8:	00 00 00 
  8006fb:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800702:	7e 14                	jle    800718 <libmain+0x6b>
		binaryname = argv[0];
  800704:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800708:	48 8b 10             	mov    (%rax),%rdx
  80070b:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  800712:	00 00 00 
  800715:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800718:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80071c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80071f:	48 89 d6             	mov    %rdx,%rsi
  800722:	89 c7                	mov    %eax,%edi
  800724:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80072b:	00 00 00 
  80072e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800730:	48 b8 3e 07 80 00 00 	movabs $0x80073e,%rax
  800737:	00 00 00 
  80073a:	ff d0                	callq  *%rax
}
  80073c:	c9                   	leaveq 
  80073d:	c3                   	retq   

000000000080073e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80073e:	55                   	push   %rbp
  80073f:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800742:	48 b8 3f 24 80 00 00 	movabs $0x80243f,%rax
  800749:	00 00 00 
  80074c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80074e:	bf 00 00 00 00       	mov    $0x0,%edi
  800753:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  80075a:	00 00 00 
  80075d:	ff d0                	callq  *%rax
}
  80075f:	5d                   	pop    %rbp
  800760:	c3                   	retq   

0000000000800761 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800761:	55                   	push   %rbp
  800762:	48 89 e5             	mov    %rsp,%rbp
  800765:	53                   	push   %rbx
  800766:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80076d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800774:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80077a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800781:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800788:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80078f:	84 c0                	test   %al,%al
  800791:	74 23                	je     8007b6 <_panic+0x55>
  800793:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80079a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80079e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8007a2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8007a6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8007aa:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8007ae:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8007b2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8007b6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007bd:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007c4:	00 00 00 
  8007c7:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007ce:	00 00 00 
  8007d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007d5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007dc:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007e3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007ea:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8007f1:	00 00 00 
  8007f4:	48 8b 18             	mov    (%rax),%rbx
  8007f7:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  8007fe:	00 00 00 
  800801:	ff d0                	callq  *%rax
  800803:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800809:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800810:	41 89 c8             	mov    %ecx,%r8d
  800813:	48 89 d1             	mov    %rdx,%rcx
  800816:	48 89 da             	mov    %rbx,%rdx
  800819:	89 c6                	mov    %eax,%esi
  80081b:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  800822:	00 00 00 
  800825:	b8 00 00 00 00       	mov    $0x0,%eax
  80082a:	49 b9 9a 09 80 00 00 	movabs $0x80099a,%r9
  800831:	00 00 00 
  800834:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800837:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80083e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800845:	48 89 d6             	mov    %rdx,%rsi
  800848:	48 89 c7             	mov    %rax,%rdi
  80084b:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800852:	00 00 00 
  800855:	ff d0                	callq  *%rax
	cprintf("\n");
  800857:	48 bf 03 46 80 00 00 	movabs $0x804603,%rdi
  80085e:	00 00 00 
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  80086d:	00 00 00 
  800870:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800872:	cc                   	int3   
  800873:	eb fd                	jmp    800872 <_panic+0x111>

0000000000800875 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800875:	55                   	push   %rbp
  800876:	48 89 e5             	mov    %rsp,%rbp
  800879:	48 83 ec 10          	sub    $0x10,%rsp
  80087d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800880:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800888:	8b 00                	mov    (%rax),%eax
  80088a:	8d 48 01             	lea    0x1(%rax),%ecx
  80088d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800891:	89 0a                	mov    %ecx,(%rdx)
  800893:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800896:	89 d1                	mov    %edx,%ecx
  800898:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089c:	48 98                	cltq   
  80089e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8008a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a6:	8b 00                	mov    (%rax),%eax
  8008a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ad:	75 2c                	jne    8008db <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8008af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b3:	8b 00                	mov    (%rax),%eax
  8008b5:	48 98                	cltq   
  8008b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008bb:	48 83 c2 08          	add    $0x8,%rdx
  8008bf:	48 89 c6             	mov    %rax,%rsi
  8008c2:	48 89 d7             	mov    %rdx,%rdi
  8008c5:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
        b->idx = 0;
  8008d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8008db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008df:	8b 40 04             	mov    0x4(%rax),%eax
  8008e2:	8d 50 01             	lea    0x1(%rax),%edx
  8008e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008e9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008ec:	c9                   	leaveq 
  8008ed:	c3                   	retq   

00000000008008ee <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8008ee:	55                   	push   %rbp
  8008ef:	48 89 e5             	mov    %rsp,%rbp
  8008f2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008f9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800900:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800907:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80090e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800915:	48 8b 0a             	mov    (%rdx),%rcx
  800918:	48 89 08             	mov    %rcx,(%rax)
  80091b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80091f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800923:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800927:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80092b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800932:	00 00 00 
    b.cnt = 0;
  800935:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80093c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80093f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800946:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80094d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800954:	48 89 c6             	mov    %rax,%rsi
  800957:	48 bf 75 08 80 00 00 	movabs $0x800875,%rdi
  80095e:	00 00 00 
  800961:	48 b8 4d 0d 80 00 00 	movabs $0x800d4d,%rax
  800968:	00 00 00 
  80096b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80096d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800973:	48 98                	cltq   
  800975:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80097c:	48 83 c2 08          	add    $0x8,%rdx
  800980:	48 89 c6             	mov    %rax,%rsi
  800983:	48 89 d7             	mov    %rdx,%rdi
  800986:	48 b8 49 1d 80 00 00 	movabs $0x801d49,%rax
  80098d:	00 00 00 
  800990:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800992:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800998:	c9                   	leaveq 
  800999:	c3                   	retq   

000000000080099a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80099a:	55                   	push   %rbp
  80099b:	48 89 e5             	mov    %rsp,%rbp
  80099e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8009a5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8009ac:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8009b3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8009ba:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009c1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009c8:	84 c0                	test   %al,%al
  8009ca:	74 20                	je     8009ec <cprintf+0x52>
  8009cc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009d0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009d4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009d8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009dc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009e0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009e4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009e8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009ec:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8009f3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009fa:	00 00 00 
  8009fd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800a04:	00 00 00 
  800a07:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800a0b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800a12:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800a19:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800a20:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a27:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a2e:	48 8b 0a             	mov    (%rdx),%rcx
  800a31:	48 89 08             	mov    %rcx,(%rax)
  800a34:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a38:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a3c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a40:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800a44:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a4b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a52:	48 89 d6             	mov    %rdx,%rsi
  800a55:	48 89 c7             	mov    %rax,%rdi
  800a58:	48 b8 ee 08 80 00 00 	movabs $0x8008ee,%rax
  800a5f:	00 00 00 
  800a62:	ff d0                	callq  *%rax
  800a64:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800a6a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a70:	c9                   	leaveq 
  800a71:	c3                   	retq   

0000000000800a72 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a72:	55                   	push   %rbp
  800a73:	48 89 e5             	mov    %rsp,%rbp
  800a76:	53                   	push   %rbx
  800a77:	48 83 ec 38          	sub    $0x38,%rsp
  800a7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a83:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a87:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a8a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a8e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a92:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a95:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a99:	77 3b                	ja     800ad6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a9b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a9e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800aa2:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aa9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aae:	48 f7 f3             	div    %rbx
  800ab1:	48 89 c2             	mov    %rax,%rdx
  800ab4:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800ab7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800aba:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac2:	41 89 f9             	mov    %edi,%r9d
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	48 b8 72 0a 80 00 00 	movabs $0x800a72,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	eb 1e                	jmp    800af4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad6:	eb 12                	jmp    800aea <printnum+0x78>
			putch(padc, putdat);
  800ad8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800adc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800adf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae3:	48 89 ce             	mov    %rcx,%rsi
  800ae6:	89 d7                	mov    %edx,%edi
  800ae8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aea:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800aee:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800af2:	7f e4                	jg     800ad8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800af4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800af7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
  800b00:	48 f7 f1             	div    %rcx
  800b03:	48 89 d0             	mov    %rdx,%rax
  800b06:	48 ba 10 48 80 00 00 	movabs $0x804810,%rdx
  800b0d:	00 00 00 
  800b10:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800b14:	0f be d0             	movsbl %al,%edx
  800b17:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1f:	48 89 ce             	mov    %rcx,%rsi
  800b22:	89 d7                	mov    %edx,%edi
  800b24:	ff d0                	callq  *%rax
}
  800b26:	48 83 c4 38          	add    $0x38,%rsp
  800b2a:	5b                   	pop    %rbx
  800b2b:	5d                   	pop    %rbp
  800b2c:	c3                   	retq   

0000000000800b2d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b2d:	55                   	push   %rbp
  800b2e:	48 89 e5             	mov    %rsp,%rbp
  800b31:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b39:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800b3c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b40:	7e 52                	jle    800b94 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b46:	8b 00                	mov    (%rax),%eax
  800b48:	83 f8 30             	cmp    $0x30,%eax
  800b4b:	73 24                	jae    800b71 <getuint+0x44>
  800b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b51:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b59:	8b 00                	mov    (%rax),%eax
  800b5b:	89 c0                	mov    %eax,%eax
  800b5d:	48 01 d0             	add    %rdx,%rax
  800b60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b64:	8b 12                	mov    (%rdx),%edx
  800b66:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6d:	89 0a                	mov    %ecx,(%rdx)
  800b6f:	eb 17                	jmp    800b88 <getuint+0x5b>
  800b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b75:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b79:	48 89 d0             	mov    %rdx,%rax
  800b7c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b84:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b88:	48 8b 00             	mov    (%rax),%rax
  800b8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b8f:	e9 a3 00 00 00       	jmpq   800c37 <getuint+0x10a>
	else if (lflag)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b98:	74 4f                	je     800be9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9e:	8b 00                	mov    (%rax),%eax
  800ba0:	83 f8 30             	cmp    $0x30,%eax
  800ba3:	73 24                	jae    800bc9 <getuint+0x9c>
  800ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb1:	8b 00                	mov    (%rax),%eax
  800bb3:	89 c0                	mov    %eax,%eax
  800bb5:	48 01 d0             	add    %rdx,%rax
  800bb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bbc:	8b 12                	mov    (%rdx),%edx
  800bbe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc5:	89 0a                	mov    %ecx,(%rdx)
  800bc7:	eb 17                	jmp    800be0 <getuint+0xb3>
  800bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bd1:	48 89 d0             	mov    %rdx,%rax
  800bd4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bd8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bdc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800be0:	48 8b 00             	mov    (%rax),%rax
  800be3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800be7:	eb 4e                	jmp    800c37 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bed:	8b 00                	mov    (%rax),%eax
  800bef:	83 f8 30             	cmp    $0x30,%eax
  800bf2:	73 24                	jae    800c18 <getuint+0xeb>
  800bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c00:	8b 00                	mov    (%rax),%eax
  800c02:	89 c0                	mov    %eax,%eax
  800c04:	48 01 d0             	add    %rdx,%rax
  800c07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0b:	8b 12                	mov    (%rdx),%edx
  800c0d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c14:	89 0a                	mov    %ecx,(%rdx)
  800c16:	eb 17                	jmp    800c2f <getuint+0x102>
  800c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c20:	48 89 d0             	mov    %rdx,%rax
  800c23:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c2f:	8b 00                	mov    (%rax),%eax
  800c31:	89 c0                	mov    %eax,%eax
  800c33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c3b:	c9                   	leaveq 
  800c3c:	c3                   	retq   

0000000000800c3d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c3d:	55                   	push   %rbp
  800c3e:	48 89 e5             	mov    %rsp,%rbp
  800c41:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c49:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c4c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c50:	7e 52                	jle    800ca4 <getint+0x67>
		x=va_arg(*ap, long long);
  800c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c56:	8b 00                	mov    (%rax),%eax
  800c58:	83 f8 30             	cmp    $0x30,%eax
  800c5b:	73 24                	jae    800c81 <getint+0x44>
  800c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c61:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c69:	8b 00                	mov    (%rax),%eax
  800c6b:	89 c0                	mov    %eax,%eax
  800c6d:	48 01 d0             	add    %rdx,%rax
  800c70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c74:	8b 12                	mov    (%rdx),%edx
  800c76:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c7d:	89 0a                	mov    %ecx,(%rdx)
  800c7f:	eb 17                	jmp    800c98 <getint+0x5b>
  800c81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c85:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c89:	48 89 d0             	mov    %rdx,%rax
  800c8c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c94:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c98:	48 8b 00             	mov    (%rax),%rax
  800c9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c9f:	e9 a3 00 00 00       	jmpq   800d47 <getint+0x10a>
	else if (lflag)
  800ca4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ca8:	74 4f                	je     800cf9 <getint+0xbc>
		x=va_arg(*ap, long);
  800caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cae:	8b 00                	mov    (%rax),%eax
  800cb0:	83 f8 30             	cmp    $0x30,%eax
  800cb3:	73 24                	jae    800cd9 <getint+0x9c>
  800cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc1:	8b 00                	mov    (%rax),%eax
  800cc3:	89 c0                	mov    %eax,%eax
  800cc5:	48 01 d0             	add    %rdx,%rax
  800cc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccc:	8b 12                	mov    (%rdx),%edx
  800cce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd5:	89 0a                	mov    %ecx,(%rdx)
  800cd7:	eb 17                	jmp    800cf0 <getint+0xb3>
  800cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ce1:	48 89 d0             	mov    %rdx,%rax
  800ce4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ce8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cf0:	48 8b 00             	mov    (%rax),%rax
  800cf3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cf7:	eb 4e                	jmp    800d47 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfd:	8b 00                	mov    (%rax),%eax
  800cff:	83 f8 30             	cmp    $0x30,%eax
  800d02:	73 24                	jae    800d28 <getint+0xeb>
  800d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d08:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d10:	8b 00                	mov    (%rax),%eax
  800d12:	89 c0                	mov    %eax,%eax
  800d14:	48 01 d0             	add    %rdx,%rax
  800d17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1b:	8b 12                	mov    (%rdx),%edx
  800d1d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d24:	89 0a                	mov    %ecx,(%rdx)
  800d26:	eb 17                	jmp    800d3f <getint+0x102>
  800d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d30:	48 89 d0             	mov    %rdx,%rax
  800d33:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d3f:	8b 00                	mov    (%rax),%eax
  800d41:	48 98                	cltq   
  800d43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d4b:	c9                   	leaveq 
  800d4c:	c3                   	retq   

0000000000800d4d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %rbp
  800d4e:	48 89 e5             	mov    %rsp,%rbp
  800d51:	41 54                	push   %r12
  800d53:	53                   	push   %rbx
  800d54:	48 83 ec 60          	sub    $0x60,%rsp
  800d58:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d5c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d60:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d64:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d68:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d70:	48 8b 0a             	mov    (%rdx),%rcx
  800d73:	48 89 08             	mov    %rcx,(%rax)
  800d76:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d7a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d7e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d82:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	eb 17                	jmp    800d9f <vprintfmt+0x52>
			if (ch == '\0')
  800d88:	85 db                	test   %ebx,%ebx
  800d8a:	0f 84 df 04 00 00    	je     80126f <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800d90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d98:	48 89 d6             	mov    %rdx,%rsi
  800d9b:	89 df                	mov    %ebx,%edi
  800d9d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800da3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800da7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800dab:	0f b6 00             	movzbl (%rax),%eax
  800dae:	0f b6 d8             	movzbl %al,%ebx
  800db1:	83 fb 25             	cmp    $0x25,%ebx
  800db4:	75 d2                	jne    800d88 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db6:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800dba:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800dc1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800dc8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800dcf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dda:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800dde:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800de2:	0f b6 00             	movzbl (%rax),%eax
  800de5:	0f b6 d8             	movzbl %al,%ebx
  800de8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800deb:	83 f8 55             	cmp    $0x55,%eax
  800dee:	0f 87 47 04 00 00    	ja     80123b <vprintfmt+0x4ee>
  800df4:	89 c0                	mov    %eax,%eax
  800df6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800dfd:	00 
  800dfe:	48 b8 38 48 80 00 00 	movabs $0x804838,%rax
  800e05:	00 00 00 
  800e08:	48 01 d0             	add    %rdx,%rax
  800e0b:	48 8b 00             	mov    (%rax),%rax
  800e0e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800e10:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e14:	eb c0                	jmp    800dd6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e16:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e1a:	eb ba                	jmp    800dd6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e23:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e26:	89 d0                	mov    %edx,%eax
  800e28:	c1 e0 02             	shl    $0x2,%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	01 c0                	add    %eax,%eax
  800e2f:	01 d8                	add    %ebx,%eax
  800e31:	83 e8 30             	sub    $0x30,%eax
  800e34:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e37:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e3b:	0f b6 00             	movzbl (%rax),%eax
  800e3e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e41:	83 fb 2f             	cmp    $0x2f,%ebx
  800e44:	7e 0c                	jle    800e52 <vprintfmt+0x105>
  800e46:	83 fb 39             	cmp    $0x39,%ebx
  800e49:	7f 07                	jg     800e52 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e50:	eb d1                	jmp    800e23 <vprintfmt+0xd6>
			goto process_precision;
  800e52:	eb 58                	jmp    800eac <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800e54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e57:	83 f8 30             	cmp    $0x30,%eax
  800e5a:	73 17                	jae    800e73 <vprintfmt+0x126>
  800e5c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e63:	89 c0                	mov    %eax,%eax
  800e65:	48 01 d0             	add    %rdx,%rax
  800e68:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6b:	83 c2 08             	add    $0x8,%edx
  800e6e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e71:	eb 0f                	jmp    800e82 <vprintfmt+0x135>
  800e73:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e77:	48 89 d0             	mov    %rdx,%rax
  800e7a:	48 83 c2 08          	add    $0x8,%rdx
  800e7e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e82:	8b 00                	mov    (%rax),%eax
  800e84:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e87:	eb 23                	jmp    800eac <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800e89:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e8d:	79 0c                	jns    800e9b <vprintfmt+0x14e>
				width = 0;
  800e8f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e96:	e9 3b ff ff ff       	jmpq   800dd6 <vprintfmt+0x89>
  800e9b:	e9 36 ff ff ff       	jmpq   800dd6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ea0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ea7:	e9 2a ff ff ff       	jmpq   800dd6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800eac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eb0:	79 12                	jns    800ec4 <vprintfmt+0x177>
				width = precision, precision = -1;
  800eb2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800eb5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800eb8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ebf:	e9 12 ff ff ff       	jmpq   800dd6 <vprintfmt+0x89>
  800ec4:	e9 0d ff ff ff       	jmpq   800dd6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ec9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ecd:	e9 04 ff ff ff       	jmpq   800dd6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ed2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed5:	83 f8 30             	cmp    $0x30,%eax
  800ed8:	73 17                	jae    800ef1 <vprintfmt+0x1a4>
  800eda:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ede:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ee1:	89 c0                	mov    %eax,%eax
  800ee3:	48 01 d0             	add    %rdx,%rax
  800ee6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ee9:	83 c2 08             	add    $0x8,%edx
  800eec:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800eef:	eb 0f                	jmp    800f00 <vprintfmt+0x1b3>
  800ef1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ef5:	48 89 d0             	mov    %rdx,%rax
  800ef8:	48 83 c2 08          	add    $0x8,%rdx
  800efc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f00:	8b 10                	mov    (%rax),%edx
  800f02:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0a:	48 89 ce             	mov    %rcx,%rsi
  800f0d:	89 d7                	mov    %edx,%edi
  800f0f:	ff d0                	callq  *%rax
			break;
  800f11:	e9 53 03 00 00       	jmpq   801269 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800f16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f19:	83 f8 30             	cmp    $0x30,%eax
  800f1c:	73 17                	jae    800f35 <vprintfmt+0x1e8>
  800f1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f25:	89 c0                	mov    %eax,%eax
  800f27:	48 01 d0             	add    %rdx,%rax
  800f2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2d:	83 c2 08             	add    $0x8,%edx
  800f30:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f33:	eb 0f                	jmp    800f44 <vprintfmt+0x1f7>
  800f35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f39:	48 89 d0             	mov    %rdx,%rax
  800f3c:	48 83 c2 08          	add    $0x8,%rdx
  800f40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f44:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f46:	85 db                	test   %ebx,%ebx
  800f48:	79 02                	jns    800f4c <vprintfmt+0x1ff>
				err = -err;
  800f4a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f4c:	83 fb 15             	cmp    $0x15,%ebx
  800f4f:	7f 16                	jg     800f67 <vprintfmt+0x21a>
  800f51:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  800f58:	00 00 00 
  800f5b:	48 63 d3             	movslq %ebx,%rdx
  800f5e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f62:	4d 85 e4             	test   %r12,%r12
  800f65:	75 2e                	jne    800f95 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800f67:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6f:	89 d9                	mov    %ebx,%ecx
  800f71:	48 ba 21 48 80 00 00 	movabs $0x804821,%rdx
  800f78:	00 00 00 
  800f7b:	48 89 c7             	mov    %rax,%rdi
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f83:	49 b8 78 12 80 00 00 	movabs $0x801278,%r8
  800f8a:	00 00 00 
  800f8d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f90:	e9 d4 02 00 00       	jmpq   801269 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f95:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9d:	4c 89 e1             	mov    %r12,%rcx
  800fa0:	48 ba 2a 48 80 00 00 	movabs $0x80482a,%rdx
  800fa7:	00 00 00 
  800faa:	48 89 c7             	mov    %rax,%rdi
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	49 b8 78 12 80 00 00 	movabs $0x801278,%r8
  800fb9:	00 00 00 
  800fbc:	41 ff d0             	callq  *%r8
			break;
  800fbf:	e9 a5 02 00 00       	jmpq   801269 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fc4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc7:	83 f8 30             	cmp    $0x30,%eax
  800fca:	73 17                	jae    800fe3 <vprintfmt+0x296>
  800fcc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fd0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fd3:	89 c0                	mov    %eax,%eax
  800fd5:	48 01 d0             	add    %rdx,%rax
  800fd8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fdb:	83 c2 08             	add    $0x8,%edx
  800fde:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fe1:	eb 0f                	jmp    800ff2 <vprintfmt+0x2a5>
  800fe3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fe7:	48 89 d0             	mov    %rdx,%rax
  800fea:	48 83 c2 08          	add    $0x8,%rdx
  800fee:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ff2:	4c 8b 20             	mov    (%rax),%r12
  800ff5:	4d 85 e4             	test   %r12,%r12
  800ff8:	75 0a                	jne    801004 <vprintfmt+0x2b7>
				p = "(null)";
  800ffa:	49 bc 2d 48 80 00 00 	movabs $0x80482d,%r12
  801001:	00 00 00 
			if (width > 0 && padc != '-')
  801004:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801008:	7e 3f                	jle    801049 <vprintfmt+0x2fc>
  80100a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80100e:	74 39                	je     801049 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801010:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801013:	48 98                	cltq   
  801015:	48 89 c6             	mov    %rax,%rsi
  801018:	4c 89 e7             	mov    %r12,%rdi
  80101b:	48 b8 24 15 80 00 00 	movabs $0x801524,%rax
  801022:	00 00 00 
  801025:	ff d0                	callq  *%rax
  801027:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80102a:	eb 17                	jmp    801043 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80102c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801030:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801034:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801038:	48 89 ce             	mov    %rcx,%rsi
  80103b:	89 d7                	mov    %edx,%edi
  80103d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80103f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801043:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801047:	7f e3                	jg     80102c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801049:	eb 37                	jmp    801082 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80104b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80104f:	74 1e                	je     80106f <vprintfmt+0x322>
  801051:	83 fb 1f             	cmp    $0x1f,%ebx
  801054:	7e 05                	jle    80105b <vprintfmt+0x30e>
  801056:	83 fb 7e             	cmp    $0x7e,%ebx
  801059:	7e 14                	jle    80106f <vprintfmt+0x322>
					putch('?', putdat);
  80105b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80105f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801063:	48 89 d6             	mov    %rdx,%rsi
  801066:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80106b:	ff d0                	callq  *%rax
  80106d:	eb 0f                	jmp    80107e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80106f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801073:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801077:	48 89 d6             	mov    %rdx,%rsi
  80107a:	89 df                	mov    %ebx,%edi
  80107c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80107e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801082:	4c 89 e0             	mov    %r12,%rax
  801085:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801089:	0f b6 00             	movzbl (%rax),%eax
  80108c:	0f be d8             	movsbl %al,%ebx
  80108f:	85 db                	test   %ebx,%ebx
  801091:	74 10                	je     8010a3 <vprintfmt+0x356>
  801093:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801097:	78 b2                	js     80104b <vprintfmt+0x2fe>
  801099:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80109d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010a1:	79 a8                	jns    80104b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010a3:	eb 16                	jmp    8010bb <vprintfmt+0x36e>
				putch(' ', putdat);
  8010a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ad:	48 89 d6             	mov    %rdx,%rsi
  8010b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8010b5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010b7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010bf:	7f e4                	jg     8010a5 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8010c1:	e9 a3 01 00 00       	jmpq   801269 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8010c6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010ca:	be 03 00 00 00       	mov    $0x3,%esi
  8010cf:	48 89 c7             	mov    %rax,%rdi
  8010d2:	48 b8 3d 0c 80 00 00 	movabs $0x800c3d,%rax
  8010d9:	00 00 00 
  8010dc:	ff d0                	callq  *%rax
  8010de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e6:	48 85 c0             	test   %rax,%rax
  8010e9:	79 1d                	jns    801108 <vprintfmt+0x3bb>
				putch('-', putdat);
  8010eb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f3:	48 89 d6             	mov    %rdx,%rsi
  8010f6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010fb:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801101:	48 f7 d8             	neg    %rax
  801104:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801108:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80110f:	e9 e8 00 00 00       	jmpq   8011fc <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801114:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801118:	be 03 00 00 00       	mov    $0x3,%esi
  80111d:	48 89 c7             	mov    %rax,%rdi
  801120:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  801127:	00 00 00 
  80112a:	ff d0                	callq  *%rax
  80112c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801130:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801137:	e9 c0 00 00 00       	jmpq   8011fc <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80113c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801140:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801144:	48 89 d6             	mov    %rdx,%rsi
  801147:	bf 58 00 00 00       	mov    $0x58,%edi
  80114c:	ff d0                	callq  *%rax
			putch('X', putdat);
  80114e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801152:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801156:	48 89 d6             	mov    %rdx,%rsi
  801159:	bf 58 00 00 00       	mov    $0x58,%edi
  80115e:	ff d0                	callq  *%rax
			putch('X', putdat);
  801160:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801164:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801168:	48 89 d6             	mov    %rdx,%rsi
  80116b:	bf 58 00 00 00       	mov    $0x58,%edi
  801170:	ff d0                	callq  *%rax
			break;
  801172:	e9 f2 00 00 00       	jmpq   801269 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  801177:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80117b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80117f:	48 89 d6             	mov    %rdx,%rsi
  801182:	bf 30 00 00 00       	mov    $0x30,%edi
  801187:	ff d0                	callq  *%rax
			putch('x', putdat);
  801189:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80118d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801191:	48 89 d6             	mov    %rdx,%rsi
  801194:	bf 78 00 00 00       	mov    $0x78,%edi
  801199:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80119b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80119e:	83 f8 30             	cmp    $0x30,%eax
  8011a1:	73 17                	jae    8011ba <vprintfmt+0x46d>
  8011a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011aa:	89 c0                	mov    %eax,%eax
  8011ac:	48 01 d0             	add    %rdx,%rax
  8011af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011b2:	83 c2 08             	add    $0x8,%edx
  8011b5:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011b8:	eb 0f                	jmp    8011c9 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  8011ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011be:	48 89 d0             	mov    %rdx,%rax
  8011c1:	48 83 c2 08          	add    $0x8,%rdx
  8011c5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011c9:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8011d0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8011d7:	eb 23                	jmp    8011fc <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8011d9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011dd:	be 03 00 00 00       	mov    $0x3,%esi
  8011e2:	48 89 c7             	mov    %rax,%rdi
  8011e5:	48 b8 2d 0b 80 00 00 	movabs $0x800b2d,%rax
  8011ec:	00 00 00 
  8011ef:	ff d0                	callq  *%rax
  8011f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8011f5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011fc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801201:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801204:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801207:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80120b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80120f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801213:	45 89 c1             	mov    %r8d,%r9d
  801216:	41 89 f8             	mov    %edi,%r8d
  801219:	48 89 c7             	mov    %rax,%rdi
  80121c:	48 b8 72 0a 80 00 00 	movabs $0x800a72,%rax
  801223:	00 00 00 
  801226:	ff d0                	callq  *%rax
			break;
  801228:	eb 3f                	jmp    801269 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80122a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80122e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801232:	48 89 d6             	mov    %rdx,%rsi
  801235:	89 df                	mov    %ebx,%edi
  801237:	ff d0                	callq  *%rax
			break;
  801239:	eb 2e                	jmp    801269 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80123b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80123f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801243:	48 89 d6             	mov    %rdx,%rsi
  801246:	bf 25 00 00 00       	mov    $0x25,%edi
  80124b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80124d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801252:	eb 05                	jmp    801259 <vprintfmt+0x50c>
  801254:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801259:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80125d:	48 83 e8 01          	sub    $0x1,%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	3c 25                	cmp    $0x25,%al
  801266:	75 ec                	jne    801254 <vprintfmt+0x507>
				/* do nothing */;
			break;
  801268:	90                   	nop
		}
	}
  801269:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80126a:	e9 30 fb ff ff       	jmpq   800d9f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80126f:	48 83 c4 60          	add    $0x60,%rsp
  801273:	5b                   	pop    %rbx
  801274:	41 5c                	pop    %r12
  801276:	5d                   	pop    %rbp
  801277:	c3                   	retq   

0000000000801278 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801278:	55                   	push   %rbp
  801279:	48 89 e5             	mov    %rsp,%rbp
  80127c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801283:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80128a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801291:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801298:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80129f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012a6:	84 c0                	test   %al,%al
  8012a8:	74 20                	je     8012ca <printfmt+0x52>
  8012aa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012ae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012b2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012b6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012ba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012be:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012c2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012c6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012ca:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8012d1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8012d8:	00 00 00 
  8012db:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8012e2:	00 00 00 
  8012e5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8012f0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012f7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8012fe:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801305:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80130c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801313:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80131a:	48 89 c7             	mov    %rax,%rdi
  80131d:	48 b8 4d 0d 80 00 00 	movabs $0x800d4d,%rax
  801324:	00 00 00 
  801327:	ff d0                	callq  *%rax
	va_end(ap);
}
  801329:	c9                   	leaveq 
  80132a:	c3                   	retq   

000000000080132b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80132b:	55                   	push   %rbp
  80132c:	48 89 e5             	mov    %rsp,%rbp
  80132f:	48 83 ec 10          	sub    $0x10,%rsp
  801333:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801336:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80133a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133e:	8b 40 10             	mov    0x10(%rax),%eax
  801341:	8d 50 01             	lea    0x1(%rax),%edx
  801344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801348:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80134b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134f:	48 8b 10             	mov    (%rax),%rdx
  801352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801356:	48 8b 40 08          	mov    0x8(%rax),%rax
  80135a:	48 39 c2             	cmp    %rax,%rdx
  80135d:	73 17                	jae    801376 <sprintputch+0x4b>
		*b->buf++ = ch;
  80135f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801363:	48 8b 00             	mov    (%rax),%rax
  801366:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80136a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80136e:	48 89 0a             	mov    %rcx,(%rdx)
  801371:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801374:	88 10                	mov    %dl,(%rax)
}
  801376:	c9                   	leaveq 
  801377:	c3                   	retq   

0000000000801378 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	48 83 ec 50          	sub    $0x50,%rsp
  801380:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801384:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801387:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80138b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80138f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801393:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801397:	48 8b 0a             	mov    (%rdx),%rcx
  80139a:	48 89 08             	mov    %rcx,(%rax)
  80139d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013a1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013a5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013a9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013b1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8013b5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8013b8:	48 98                	cltq   
  8013ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013c2:	48 01 d0             	add    %rdx,%rax
  8013c5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8013c9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8013d0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8013d5:	74 06                	je     8013dd <vsnprintf+0x65>
  8013d7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8013db:	7f 07                	jg     8013e4 <vsnprintf+0x6c>
		return -E_INVAL;
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e2:	eb 2f                	jmp    801413 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8013e4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8013e8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8013ec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013f0:	48 89 c6             	mov    %rax,%rsi
  8013f3:	48 bf 2b 13 80 00 00 	movabs $0x80132b,%rdi
  8013fa:	00 00 00 
  8013fd:	48 b8 4d 0d 80 00 00 	movabs $0x800d4d,%rax
  801404:	00 00 00 
  801407:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801409:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80140d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801410:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801413:	c9                   	leaveq 
  801414:	c3                   	retq   

0000000000801415 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801415:	55                   	push   %rbp
  801416:	48 89 e5             	mov    %rsp,%rbp
  801419:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801420:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801427:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80142d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801434:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80143b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801442:	84 c0                	test   %al,%al
  801444:	74 20                	je     801466 <snprintf+0x51>
  801446:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80144a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80144e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801452:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801456:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80145a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80145e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801462:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801466:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80146d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801474:	00 00 00 
  801477:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80147e:	00 00 00 
  801481:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801485:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80148c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801493:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80149a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014a1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014a8:	48 8b 0a             	mov    (%rdx),%rcx
  8014ab:	48 89 08             	mov    %rcx,(%rax)
  8014ae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014b2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014b6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014ba:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8014be:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8014c5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8014cc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8014d2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014d9:	48 89 c7             	mov    %rax,%rdi
  8014dc:	48 b8 78 13 80 00 00 	movabs $0x801378,%rax
  8014e3:	00 00 00 
  8014e6:	ff d0                	callq  *%rax
  8014e8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8014ee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8014f4:	c9                   	leaveq 
  8014f5:	c3                   	retq   

00000000008014f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8014f6:	55                   	push   %rbp
  8014f7:	48 89 e5             	mov    %rsp,%rbp
  8014fa:	48 83 ec 18          	sub    $0x18,%rsp
  8014fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801502:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801509:	eb 09                	jmp    801514 <strlen+0x1e>
		n++;
  80150b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80150f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	84 c0                	test   %al,%al
  80151d:	75 ec                	jne    80150b <strlen+0x15>
		n++;
	return n;
  80151f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801522:	c9                   	leaveq 
  801523:	c3                   	retq   

0000000000801524 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801524:	55                   	push   %rbp
  801525:	48 89 e5             	mov    %rsp,%rbp
  801528:	48 83 ec 20          	sub    $0x20,%rsp
  80152c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801530:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80153b:	eb 0e                	jmp    80154b <strnlen+0x27>
		n++;
  80153d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801541:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801546:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80154b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801550:	74 0b                	je     80155d <strnlen+0x39>
  801552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	84 c0                	test   %al,%al
  80155b:	75 e0                	jne    80153d <strnlen+0x19>
		n++;
	return n;
  80155d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801560:	c9                   	leaveq 
  801561:	c3                   	retq   

0000000000801562 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801562:	55                   	push   %rbp
  801563:	48 89 e5             	mov    %rsp,%rbp
  801566:	48 83 ec 20          	sub    $0x20,%rsp
  80156a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80156e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801576:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80157a:	90                   	nop
  80157b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801583:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801587:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80158b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80158f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801593:	0f b6 12             	movzbl (%rdx),%edx
  801596:	88 10                	mov    %dl,(%rax)
  801598:	0f b6 00             	movzbl (%rax),%eax
  80159b:	84 c0                	test   %al,%al
  80159d:	75 dc                	jne    80157b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80159f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a3:	c9                   	leaveq 
  8015a4:	c3                   	retq   

00000000008015a5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 20          	sub    $0x20,%rsp
  8015ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8015b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b9:	48 89 c7             	mov    %rax,%rdi
  8015bc:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  8015c3:	00 00 00 
  8015c6:	ff d0                	callq  *%rax
  8015c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8015cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015ce:	48 63 d0             	movslq %eax,%rdx
  8015d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d5:	48 01 c2             	add    %rax,%rdx
  8015d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015dc:	48 89 c6             	mov    %rax,%rsi
  8015df:	48 89 d7             	mov    %rdx,%rdi
  8015e2:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  8015e9:	00 00 00 
  8015ec:	ff d0                	callq  *%rax
	return dst;
  8015ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 28          	sub    $0x28,%rsp
  8015fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801600:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801604:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801610:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801617:	00 
  801618:	eb 2a                	jmp    801644 <strncpy+0x50>
		*dst++ = *src;
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801622:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801626:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80162a:	0f b6 12             	movzbl (%rdx),%edx
  80162d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80162f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801633:	0f b6 00             	movzbl (%rax),%eax
  801636:	84 c0                	test   %al,%al
  801638:	74 05                	je     80163f <strncpy+0x4b>
			src++;
  80163a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80163f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80164c:	72 cc                	jb     80161a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80164e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 28          	sub    $0x28,%rsp
  80165c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801660:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801664:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801670:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801675:	74 3d                	je     8016b4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801677:	eb 1d                	jmp    801696 <strlcpy+0x42>
			*dst++ = *src++;
  801679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801681:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801685:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801689:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80168d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801691:	0f b6 12             	movzbl (%rdx),%edx
  801694:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801696:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80169b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016a0:	74 0b                	je     8016ad <strlcpy+0x59>
  8016a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	84 c0                	test   %al,%al
  8016ab:	75 cc                	jne    801679 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8016ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8016b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bc:	48 29 c2             	sub    %rax,%rdx
  8016bf:	48 89 d0             	mov    %rdx,%rax
}
  8016c2:	c9                   	leaveq 
  8016c3:	c3                   	retq   

00000000008016c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c4:	55                   	push   %rbp
  8016c5:	48 89 e5             	mov    %rsp,%rbp
  8016c8:	48 83 ec 10          	sub    $0x10,%rsp
  8016cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8016d4:	eb 0a                	jmp    8016e0 <strcmp+0x1c>
		p++, q++;
  8016d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e4:	0f b6 00             	movzbl (%rax),%eax
  8016e7:	84 c0                	test   %al,%al
  8016e9:	74 12                	je     8016fd <strcmp+0x39>
  8016eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ef:	0f b6 10             	movzbl (%rax),%edx
  8016f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	38 c2                	cmp    %al,%dl
  8016fb:	74 d9                	je     8016d6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	0f b6 d0             	movzbl %al,%edx
  801707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170b:	0f b6 00             	movzbl (%rax),%eax
  80170e:	0f b6 c0             	movzbl %al,%eax
  801711:	29 c2                	sub    %eax,%edx
  801713:	89 d0                	mov    %edx,%eax
}
  801715:	c9                   	leaveq 
  801716:	c3                   	retq   

0000000000801717 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801717:	55                   	push   %rbp
  801718:	48 89 e5             	mov    %rsp,%rbp
  80171b:	48 83 ec 18          	sub    $0x18,%rsp
  80171f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801723:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801727:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80172b:	eb 0f                	jmp    80173c <strncmp+0x25>
		n--, p++, q++;
  80172d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801732:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801737:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80173c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801741:	74 1d                	je     801760 <strncmp+0x49>
  801743:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801747:	0f b6 00             	movzbl (%rax),%eax
  80174a:	84 c0                	test   %al,%al
  80174c:	74 12                	je     801760 <strncmp+0x49>
  80174e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801752:	0f b6 10             	movzbl (%rax),%edx
  801755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	38 c2                	cmp    %al,%dl
  80175e:	74 cd                	je     80172d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801760:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801765:	75 07                	jne    80176e <strncmp+0x57>
		return 0;
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	eb 18                	jmp    801786 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80176e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	0f b6 d0             	movzbl %al,%edx
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	0f b6 c0             	movzbl %al,%eax
  801782:	29 c2                	sub    %eax,%edx
  801784:	89 d0                	mov    %edx,%eax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	48 83 ec 0c          	sub    $0xc,%rsp
  801790:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801794:	89 f0                	mov    %esi,%eax
  801796:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801799:	eb 17                	jmp    8017b2 <strchr+0x2a>
		if (*s == c)
  80179b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179f:	0f b6 00             	movzbl (%rax),%eax
  8017a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017a5:	75 06                	jne    8017ad <strchr+0x25>
			return (char *) s;
  8017a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ab:	eb 15                	jmp    8017c2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8017ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b6:	0f b6 00             	movzbl (%rax),%eax
  8017b9:	84 c0                	test   %al,%al
  8017bb:	75 de                	jne    80179b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c2:	c9                   	leaveq 
  8017c3:	c3                   	retq   

00000000008017c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	48 83 ec 0c          	sub    $0xc,%rsp
  8017cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017d0:	89 f0                	mov    %esi,%eax
  8017d2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017d5:	eb 13                	jmp    8017ea <strfind+0x26>
		if (*s == c)
  8017d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017db:	0f b6 00             	movzbl (%rax),%eax
  8017de:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017e1:	75 02                	jne    8017e5 <strfind+0x21>
			break;
  8017e3:	eb 10                	jmp    8017f5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ee:	0f b6 00             	movzbl (%rax),%eax
  8017f1:	84 c0                	test   %al,%al
  8017f3:	75 e2                	jne    8017d7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8017f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 18          	sub    $0x18,%rsp
  801803:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801807:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80180a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80180e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801813:	75 06                	jne    80181b <memset+0x20>
		return v;
  801815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801819:	eb 69                	jmp    801884 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80181b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181f:	83 e0 03             	and    $0x3,%eax
  801822:	48 85 c0             	test   %rax,%rax
  801825:	75 48                	jne    80186f <memset+0x74>
  801827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182b:	83 e0 03             	and    $0x3,%eax
  80182e:	48 85 c0             	test   %rax,%rax
  801831:	75 3c                	jne    80186f <memset+0x74>
		c &= 0xFF;
  801833:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80183a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80183d:	c1 e0 18             	shl    $0x18,%eax
  801840:	89 c2                	mov    %eax,%edx
  801842:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801845:	c1 e0 10             	shl    $0x10,%eax
  801848:	09 c2                	or     %eax,%edx
  80184a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80184d:	c1 e0 08             	shl    $0x8,%eax
  801850:	09 d0                	or     %edx,%eax
  801852:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801859:	48 c1 e8 02          	shr    $0x2,%rax
  80185d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801860:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801864:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801867:	48 89 d7             	mov    %rdx,%rdi
  80186a:	fc                   	cld    
  80186b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80186d:	eb 11                	jmp    801880 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80186f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801873:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801876:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80187a:	48 89 d7             	mov    %rdx,%rdi
  80187d:	fc                   	cld    
  80187e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801884:	c9                   	leaveq 
  801885:	c3                   	retq   

0000000000801886 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801886:	55                   	push   %rbp
  801887:	48 89 e5             	mov    %rsp,%rbp
  80188a:	48 83 ec 28          	sub    $0x28,%rsp
  80188e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801892:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801896:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80189a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80189e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8018a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8018aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018b2:	0f 83 88 00 00 00    	jae    801940 <memmove+0xba>
  8018b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c0:	48 01 d0             	add    %rdx,%rax
  8018c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018c7:	76 77                	jbe    801940 <memmove+0xba>
		s += n;
  8018c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018dd:	83 e0 03             	and    $0x3,%eax
  8018e0:	48 85 c0             	test   %rax,%rax
  8018e3:	75 3b                	jne    801920 <memmove+0x9a>
  8018e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e9:	83 e0 03             	and    $0x3,%eax
  8018ec:	48 85 c0             	test   %rax,%rax
  8018ef:	75 2f                	jne    801920 <memmove+0x9a>
  8018f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f5:	83 e0 03             	and    $0x3,%eax
  8018f8:	48 85 c0             	test   %rax,%rax
  8018fb:	75 23                	jne    801920 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801901:	48 83 e8 04          	sub    $0x4,%rax
  801905:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801909:	48 83 ea 04          	sub    $0x4,%rdx
  80190d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801911:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801915:	48 89 c7             	mov    %rax,%rdi
  801918:	48 89 d6             	mov    %rdx,%rsi
  80191b:	fd                   	std    
  80191c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80191e:	eb 1d                	jmp    80193d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801924:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801928:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	48 89 d7             	mov    %rdx,%rdi
  801937:	48 89 c1             	mov    %rax,%rcx
  80193a:	fd                   	std    
  80193b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80193d:	fc                   	cld    
  80193e:	eb 57                	jmp    801997 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801940:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801944:	83 e0 03             	and    $0x3,%eax
  801947:	48 85 c0             	test   %rax,%rax
  80194a:	75 36                	jne    801982 <memmove+0xfc>
  80194c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801950:	83 e0 03             	and    $0x3,%eax
  801953:	48 85 c0             	test   %rax,%rax
  801956:	75 2a                	jne    801982 <memmove+0xfc>
  801958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195c:	83 e0 03             	and    $0x3,%eax
  80195f:	48 85 c0             	test   %rax,%rax
  801962:	75 1e                	jne    801982 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801968:	48 c1 e8 02          	shr    $0x2,%rax
  80196c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80196f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801973:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801977:	48 89 c7             	mov    %rax,%rdi
  80197a:	48 89 d6             	mov    %rdx,%rsi
  80197d:	fc                   	cld    
  80197e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801980:	eb 15                	jmp    801997 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801986:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80198a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80198e:	48 89 c7             	mov    %rax,%rdi
  801991:	48 89 d6             	mov    %rdx,%rsi
  801994:	fc                   	cld    
  801995:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 18          	sub    $0x18,%rsp
  8019a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8019b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8019b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bd:	48 89 ce             	mov    %rcx,%rsi
  8019c0:	48 89 c7             	mov    %rax,%rdi
  8019c3:	48 b8 86 18 80 00 00 	movabs $0x801886,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	callq  *%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 28          	sub    $0x28,%rsp
  8019d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8019e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8019ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8019f5:	eb 36                	jmp    801a2d <memcmp+0x5c>
		if (*s1 != *s2)
  8019f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fb:	0f b6 10             	movzbl (%rax),%edx
  8019fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a02:	0f b6 00             	movzbl (%rax),%eax
  801a05:	38 c2                	cmp    %al,%dl
  801a07:	74 1a                	je     801a23 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0d:	0f b6 00             	movzbl (%rax),%eax
  801a10:	0f b6 d0             	movzbl %al,%edx
  801a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	0f b6 c0             	movzbl %al,%eax
  801a1d:	29 c2                	sub    %eax,%edx
  801a1f:	89 d0                	mov    %edx,%eax
  801a21:	eb 20                	jmp    801a43 <memcmp+0x72>
		s1++, s2++;
  801a23:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a28:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a39:	48 85 c0             	test   %rax,%rax
  801a3c:	75 b9                	jne    8019f7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 28          	sub    $0x28,%rsp
  801a4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a51:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801a54:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a60:	48 01 d0             	add    %rdx,%rax
  801a63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801a67:	eb 15                	jmp    801a7e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a6d:	0f b6 10             	movzbl (%rax),%edx
  801a70:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a73:	38 c2                	cmp    %al,%dl
  801a75:	75 02                	jne    801a79 <memfind+0x34>
			break;
  801a77:	eb 0f                	jmp    801a88 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a79:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a82:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801a86:	72 e1                	jb     801a69 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	48 83 ec 34          	sub    $0x34,%rsp
  801a96:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a9a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801a9e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801aa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801aa8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801aaf:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ab0:	eb 05                	jmp    801ab7 <strtol+0x29>
		s++;
  801ab2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ab7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abb:	0f b6 00             	movzbl (%rax),%eax
  801abe:	3c 20                	cmp    $0x20,%al
  801ac0:	74 f0                	je     801ab2 <strtol+0x24>
  801ac2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac6:	0f b6 00             	movzbl (%rax),%eax
  801ac9:	3c 09                	cmp    $0x9,%al
  801acb:	74 e5                	je     801ab2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad1:	0f b6 00             	movzbl (%rax),%eax
  801ad4:	3c 2b                	cmp    $0x2b,%al
  801ad6:	75 07                	jne    801adf <strtol+0x51>
		s++;
  801ad8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801add:	eb 17                	jmp    801af6 <strtol+0x68>
	else if (*s == '-')
  801adf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae3:	0f b6 00             	movzbl (%rax),%eax
  801ae6:	3c 2d                	cmp    $0x2d,%al
  801ae8:	75 0c                	jne    801af6 <strtol+0x68>
		s++, neg = 1;
  801aea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801aef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801af6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801afa:	74 06                	je     801b02 <strtol+0x74>
  801afc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801b00:	75 28                	jne    801b2a <strtol+0x9c>
  801b02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b06:	0f b6 00             	movzbl (%rax),%eax
  801b09:	3c 30                	cmp    $0x30,%al
  801b0b:	75 1d                	jne    801b2a <strtol+0x9c>
  801b0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b11:	48 83 c0 01          	add    $0x1,%rax
  801b15:	0f b6 00             	movzbl (%rax),%eax
  801b18:	3c 78                	cmp    $0x78,%al
  801b1a:	75 0e                	jne    801b2a <strtol+0x9c>
		s += 2, base = 16;
  801b1c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b21:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b28:	eb 2c                	jmp    801b56 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b2a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b2e:	75 19                	jne    801b49 <strtol+0xbb>
  801b30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b34:	0f b6 00             	movzbl (%rax),%eax
  801b37:	3c 30                	cmp    $0x30,%al
  801b39:	75 0e                	jne    801b49 <strtol+0xbb>
		s++, base = 8;
  801b3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b40:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b47:	eb 0d                	jmp    801b56 <strtol+0xc8>
	else if (base == 0)
  801b49:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b4d:	75 07                	jne    801b56 <strtol+0xc8>
		base = 10;
  801b4f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5a:	0f b6 00             	movzbl (%rax),%eax
  801b5d:	3c 2f                	cmp    $0x2f,%al
  801b5f:	7e 1d                	jle    801b7e <strtol+0xf0>
  801b61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b65:	0f b6 00             	movzbl (%rax),%eax
  801b68:	3c 39                	cmp    $0x39,%al
  801b6a:	7f 12                	jg     801b7e <strtol+0xf0>
			dig = *s - '0';
  801b6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b70:	0f b6 00             	movzbl (%rax),%eax
  801b73:	0f be c0             	movsbl %al,%eax
  801b76:	83 e8 30             	sub    $0x30,%eax
  801b79:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b7c:	eb 4e                	jmp    801bcc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801b7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	3c 60                	cmp    $0x60,%al
  801b87:	7e 1d                	jle    801ba6 <strtol+0x118>
  801b89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8d:	0f b6 00             	movzbl (%rax),%eax
  801b90:	3c 7a                	cmp    $0x7a,%al
  801b92:	7f 12                	jg     801ba6 <strtol+0x118>
			dig = *s - 'a' + 10;
  801b94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b98:	0f b6 00             	movzbl (%rax),%eax
  801b9b:	0f be c0             	movsbl %al,%eax
  801b9e:	83 e8 57             	sub    $0x57,%eax
  801ba1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ba4:	eb 26                	jmp    801bcc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801ba6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801baa:	0f b6 00             	movzbl (%rax),%eax
  801bad:	3c 40                	cmp    $0x40,%al
  801baf:	7e 48                	jle    801bf9 <strtol+0x16b>
  801bb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb5:	0f b6 00             	movzbl (%rax),%eax
  801bb8:	3c 5a                	cmp    $0x5a,%al
  801bba:	7f 3d                	jg     801bf9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801bbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc0:	0f b6 00             	movzbl (%rax),%eax
  801bc3:	0f be c0             	movsbl %al,%eax
  801bc6:	83 e8 37             	sub    $0x37,%eax
  801bc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801bcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bcf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801bd2:	7c 02                	jl     801bd6 <strtol+0x148>
			break;
  801bd4:	eb 23                	jmp    801bf9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801bd6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bdb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801bde:	48 98                	cltq   
  801be0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801be5:	48 89 c2             	mov    %rax,%rdx
  801be8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801beb:	48 98                	cltq   
  801bed:	48 01 d0             	add    %rdx,%rax
  801bf0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801bf4:	e9 5d ff ff ff       	jmpq   801b56 <strtol+0xc8>

	if (endptr)
  801bf9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801bfe:	74 0b                	je     801c0b <strtol+0x17d>
		*endptr = (char *) s;
  801c00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c04:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c08:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c0f:	74 09                	je     801c1a <strtol+0x18c>
  801c11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c15:	48 f7 d8             	neg    %rax
  801c18:	eb 04                	jmp    801c1e <strtol+0x190>
  801c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c1e:	c9                   	leaveq 
  801c1f:	c3                   	retq   

0000000000801c20 <strstr>:

char * strstr(const char *in, const char *str)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 30          	sub    $0x30,%rsp
  801c28:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c2c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801c30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c34:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c38:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c3c:	0f b6 00             	movzbl (%rax),%eax
  801c3f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801c42:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c46:	75 06                	jne    801c4e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801c48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4c:	eb 6b                	jmp    801cb9 <strstr+0x99>

	len = strlen(str);
  801c4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c52:	48 89 c7             	mov    %rax,%rdi
  801c55:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  801c5c:	00 00 00 
  801c5f:	ff d0                	callq  *%rax
  801c61:	48 98                	cltq   
  801c63:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801c67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c6b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c6f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801c73:	0f b6 00             	movzbl (%rax),%eax
  801c76:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801c79:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801c7d:	75 07                	jne    801c86 <strstr+0x66>
				return (char *) 0;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	eb 33                	jmp    801cb9 <strstr+0x99>
		} while (sc != c);
  801c86:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801c8a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801c8d:	75 d8                	jne    801c67 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801c8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c93:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9b:	48 89 ce             	mov    %rcx,%rsi
  801c9e:	48 89 c7             	mov    %rax,%rdi
  801ca1:	48 b8 17 17 80 00 00 	movabs $0x801717,%rax
  801ca8:	00 00 00 
  801cab:	ff d0                	callq  *%rax
  801cad:	85 c0                	test   %eax,%eax
  801caf:	75 b6                	jne    801c67 <strstr+0x47>

	return (char *) (in - 1);
  801cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb5:	48 83 e8 01          	sub    $0x1,%rax
}
  801cb9:	c9                   	leaveq 
  801cba:	c3                   	retq   

0000000000801cbb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801cbb:	55                   	push   %rbp
  801cbc:	48 89 e5             	mov    %rsp,%rbp
  801cbf:	53                   	push   %rbx
  801cc0:	48 83 ec 48          	sub    $0x48,%rsp
  801cc4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801cc7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801cca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801cce:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801cd2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801cd6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cda:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801cdd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ce1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ce5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ce9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ced:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801cf1:	4c 89 c3             	mov    %r8,%rbx
  801cf4:	cd 30                	int    $0x30
  801cf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801cfa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801cfe:	74 3e                	je     801d3e <syscall+0x83>
  801d00:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d05:	7e 37                	jle    801d3e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801d07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d0e:	49 89 d0             	mov    %rdx,%r8
  801d11:	89 c1                	mov    %eax,%ecx
  801d13:	48 ba e8 4a 80 00 00 	movabs $0x804ae8,%rdx
  801d1a:	00 00 00 
  801d1d:	be 23 00 00 00       	mov    $0x23,%esi
  801d22:	48 bf 05 4b 80 00 00 	movabs $0x804b05,%rdi
  801d29:	00 00 00 
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d31:	49 b9 61 07 80 00 00 	movabs $0x800761,%r9
  801d38:	00 00 00 
  801d3b:	41 ff d1             	callq  *%r9

	return ret;
  801d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d42:	48 83 c4 48          	add    $0x48,%rsp
  801d46:	5b                   	pop    %rbx
  801d47:	5d                   	pop    %rbp
  801d48:	c3                   	retq   

0000000000801d49 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d49:	55                   	push   %rbp
  801d4a:	48 89 e5             	mov    %rsp,%rbp
  801d4d:	48 83 ec 20          	sub    $0x20,%rsp
  801d51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801d59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d68:	00 
  801d69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d75:	48 89 d1             	mov    %rdx,%rcx
  801d78:	48 89 c2             	mov    %rax,%rdx
  801d7b:	be 00 00 00 00       	mov    $0x0,%esi
  801d80:	bf 00 00 00 00       	mov    $0x0,%edi
  801d85:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	callq  *%rax
}
  801d91:	c9                   	leaveq 
  801d92:	c3                   	retq   

0000000000801d93 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801d9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801da2:	00 
  801da3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801daf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db4:	ba 00 00 00 00       	mov    $0x0,%edx
  801db9:	be 00 00 00 00       	mov    $0x0,%esi
  801dbe:	bf 01 00 00 00       	mov    $0x1,%edi
  801dc3:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801dca:	00 00 00 
  801dcd:	ff d0                	callq  *%rax
}
  801dcf:	c9                   	leaveq 
  801dd0:	c3                   	retq   

0000000000801dd1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801dd1:	55                   	push   %rbp
  801dd2:	48 89 e5             	mov    %rsp,%rbp
  801dd5:	48 83 ec 10          	sub    $0x10,%rsp
  801dd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ddf:	48 98                	cltq   
  801de1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801de8:	00 
  801de9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801def:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dfa:	48 89 c2             	mov    %rax,%rdx
  801dfd:	be 01 00 00 00       	mov    $0x1,%esi
  801e02:	bf 03 00 00 00       	mov    $0x3,%edi
  801e07:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801e0e:	00 00 00 
  801e11:	ff d0                	callq  *%rax
}
  801e13:	c9                   	leaveq 
  801e14:	c3                   	retq   

0000000000801e15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801e15:	55                   	push   %rbp
  801e16:	48 89 e5             	mov    %rsp,%rbp
  801e19:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e24:	00 
  801e25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e36:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3b:	be 00 00 00 00       	mov    $0x0,%esi
  801e40:	bf 02 00 00 00       	mov    $0x2,%edi
  801e45:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801e4c:	00 00 00 
  801e4f:	ff d0                	callq  *%rax
}
  801e51:	c9                   	leaveq 
  801e52:	c3                   	retq   

0000000000801e53 <sys_yield>:

void
sys_yield(void)
{
  801e53:	55                   	push   %rbp
  801e54:	48 89 e5             	mov    %rsp,%rbp
  801e57:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801e5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e62:	00 
  801e63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e74:	ba 00 00 00 00       	mov    $0x0,%edx
  801e79:	be 00 00 00 00       	mov    $0x0,%esi
  801e7e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801e83:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	callq  *%rax
}
  801e8f:	c9                   	leaveq 
  801e90:	c3                   	retq   

0000000000801e91 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801e91:	55                   	push   %rbp
  801e92:	48 89 e5             	mov    %rsp,%rbp
  801e95:	48 83 ec 20          	sub    $0x20,%rsp
  801e99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ea0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ea3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ea6:	48 63 c8             	movslq %eax,%rcx
  801ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb0:	48 98                	cltq   
  801eb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eb9:	00 
  801eba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec0:	49 89 c8             	mov    %rcx,%r8
  801ec3:	48 89 d1             	mov    %rdx,%rcx
  801ec6:	48 89 c2             	mov    %rax,%rdx
  801ec9:	be 01 00 00 00       	mov    $0x1,%esi
  801ece:	bf 04 00 00 00       	mov    $0x4,%edi
  801ed3:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801eda:	00 00 00 
  801edd:	ff d0                	callq  *%rax
}
  801edf:	c9                   	leaveq 
  801ee0:	c3                   	retq   

0000000000801ee1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ee1:	55                   	push   %rbp
  801ee2:	48 89 e5             	mov    %rsp,%rbp
  801ee5:	48 83 ec 30          	sub    $0x30,%rsp
  801ee9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ef0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ef3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ef7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801efb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801efe:	48 63 c8             	movslq %eax,%rcx
  801f01:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f08:	48 63 f0             	movslq %eax,%rsi
  801f0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f12:	48 98                	cltq   
  801f14:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f18:	49 89 f9             	mov    %rdi,%r9
  801f1b:	49 89 f0             	mov    %rsi,%r8
  801f1e:	48 89 d1             	mov    %rdx,%rcx
  801f21:	48 89 c2             	mov    %rax,%rdx
  801f24:	be 01 00 00 00       	mov    $0x1,%esi
  801f29:	bf 05 00 00 00       	mov    $0x5,%edi
  801f2e:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801f35:	00 00 00 
  801f38:	ff d0                	callq  *%rax
}
  801f3a:	c9                   	leaveq 
  801f3b:	c3                   	retq   

0000000000801f3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f3c:	55                   	push   %rbp
  801f3d:	48 89 e5             	mov    %rsp,%rbp
  801f40:	48 83 ec 20          	sub    $0x20,%rsp
  801f44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f52:	48 98                	cltq   
  801f54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f5b:	00 
  801f5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f68:	48 89 d1             	mov    %rdx,%rcx
  801f6b:	48 89 c2             	mov    %rax,%rdx
  801f6e:	be 01 00 00 00       	mov    $0x1,%esi
  801f73:	bf 06 00 00 00       	mov    $0x6,%edi
  801f78:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	callq  *%rax
}
  801f84:	c9                   	leaveq 
  801f85:	c3                   	retq   

0000000000801f86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801f86:	55                   	push   %rbp
  801f87:	48 89 e5             	mov    %rsp,%rbp
  801f8a:	48 83 ec 10          	sub    $0x10,%rsp
  801f8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f91:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801f94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f97:	48 63 d0             	movslq %eax,%rdx
  801f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f9d:	48 98                	cltq   
  801f9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fa6:	00 
  801fa7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb3:	48 89 d1             	mov    %rdx,%rcx
  801fb6:	48 89 c2             	mov    %rax,%rdx
  801fb9:	be 01 00 00 00       	mov    $0x1,%esi
  801fbe:	bf 08 00 00 00       	mov    $0x8,%edi
  801fc3:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	callq  *%rax
}
  801fcf:	c9                   	leaveq 
  801fd0:	c3                   	retq   

0000000000801fd1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801fd1:	55                   	push   %rbp
  801fd2:	48 89 e5             	mov    %rsp,%rbp
  801fd5:	48 83 ec 20          	sub    $0x20,%rsp
  801fd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fdc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801fe0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe7:	48 98                	cltq   
  801fe9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff0:	00 
  801ff1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ff7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ffd:	48 89 d1             	mov    %rdx,%rcx
  802000:	48 89 c2             	mov    %rax,%rdx
  802003:	be 01 00 00 00       	mov    $0x1,%esi
  802008:	bf 09 00 00 00       	mov    $0x9,%edi
  80200d:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  802014:	00 00 00 
  802017:	ff d0                	callq  *%rax
}
  802019:	c9                   	leaveq 
  80201a:	c3                   	retq   

000000000080201b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80201b:	55                   	push   %rbp
  80201c:	48 89 e5             	mov    %rsp,%rbp
  80201f:	48 83 ec 20          	sub    $0x20,%rsp
  802023:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802026:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80202a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80202e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802031:	48 98                	cltq   
  802033:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80203a:	00 
  80203b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802041:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802047:	48 89 d1             	mov    %rdx,%rcx
  80204a:	48 89 c2             	mov    %rax,%rdx
  80204d:	be 01 00 00 00       	mov    $0x1,%esi
  802052:	bf 0a 00 00 00       	mov    $0xa,%edi
  802057:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  80205e:	00 00 00 
  802061:	ff d0                	callq  *%rax
}
  802063:	c9                   	leaveq 
  802064:	c3                   	retq   

0000000000802065 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802065:	55                   	push   %rbp
  802066:	48 89 e5             	mov    %rsp,%rbp
  802069:	48 83 ec 20          	sub    $0x20,%rsp
  80206d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802070:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802074:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802078:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80207b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80207e:	48 63 f0             	movslq %eax,%rsi
  802081:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802085:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802088:	48 98                	cltq   
  80208a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80208e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802095:	00 
  802096:	49 89 f1             	mov    %rsi,%r9
  802099:	49 89 c8             	mov    %rcx,%r8
  80209c:	48 89 d1             	mov    %rdx,%rcx
  80209f:	48 89 c2             	mov    %rax,%rdx
  8020a2:	be 00 00 00 00       	mov    $0x0,%esi
  8020a7:	bf 0c 00 00 00       	mov    $0xc,%edi
  8020ac:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8020b3:	00 00 00 
  8020b6:	ff d0                	callq  *%rax
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	48 83 ec 10          	sub    $0x10,%rsp
  8020c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8020c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020d1:	00 
  8020d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020e3:	48 89 c2             	mov    %rax,%rdx
  8020e6:	be 01 00 00 00       	mov    $0x1,%esi
  8020eb:	bf 0d 00 00 00       	mov    $0xd,%edi
  8020f0:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8020f7:	00 00 00 
  8020fa:	ff d0                	callq  *%rax
}
  8020fc:	c9                   	leaveq 
  8020fd:	c3                   	retq   

00000000008020fe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	48 83 ec 08          	sub    $0x8,%rsp
  802106:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80210a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80210e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802115:	ff ff ff 
  802118:	48 01 d0             	add    %rdx,%rax
  80211b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80211f:	c9                   	leaveq 
  802120:	c3                   	retq   

0000000000802121 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802121:	55                   	push   %rbp
  802122:	48 89 e5             	mov    %rsp,%rbp
  802125:	48 83 ec 08          	sub    $0x8,%rsp
  802129:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80212d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802131:	48 89 c7             	mov    %rax,%rdi
  802134:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	callq  *%rax
  802140:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802146:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80214a:	c9                   	leaveq 
  80214b:	c3                   	retq   

000000000080214c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80214c:	55                   	push   %rbp
  80214d:	48 89 e5             	mov    %rsp,%rbp
  802150:	48 83 ec 18          	sub    $0x18,%rsp
  802154:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80215f:	eb 6b                	jmp    8021cc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802161:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802164:	48 98                	cltq   
  802166:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80216c:	48 c1 e0 0c          	shl    $0xc,%rax
  802170:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802178:	48 c1 e8 15          	shr    $0x15,%rax
  80217c:	48 89 c2             	mov    %rax,%rdx
  80217f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802186:	01 00 00 
  802189:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218d:	83 e0 01             	and    $0x1,%eax
  802190:	48 85 c0             	test   %rax,%rax
  802193:	74 21                	je     8021b6 <fd_alloc+0x6a>
  802195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802199:	48 c1 e8 0c          	shr    $0xc,%rax
  80219d:	48 89 c2             	mov    %rax,%rdx
  8021a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a7:	01 00 00 
  8021aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ae:	83 e0 01             	and    $0x1,%eax
  8021b1:	48 85 c0             	test   %rax,%rax
  8021b4:	75 12                	jne    8021c8 <fd_alloc+0x7c>
			*fd_store = fd;
  8021b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021be:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c6:	eb 1a                	jmp    8021e2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021cc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021d0:	7e 8f                	jle    802161 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021dd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021e2:	c9                   	leaveq 
  8021e3:	c3                   	retq   

00000000008021e4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021e4:	55                   	push   %rbp
  8021e5:	48 89 e5             	mov    %rsp,%rbp
  8021e8:	48 83 ec 20          	sub    $0x20,%rsp
  8021ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021f7:	78 06                	js     8021ff <fd_lookup+0x1b>
  8021f9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021fd:	7e 07                	jle    802206 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802204:	eb 6c                	jmp    802272 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802206:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802209:	48 98                	cltq   
  80220b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802211:	48 c1 e0 0c          	shl    $0xc,%rax
  802215:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221d:	48 c1 e8 15          	shr    $0x15,%rax
  802221:	48 89 c2             	mov    %rax,%rdx
  802224:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80222b:	01 00 00 
  80222e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802232:	83 e0 01             	and    $0x1,%eax
  802235:	48 85 c0             	test   %rax,%rax
  802238:	74 21                	je     80225b <fd_lookup+0x77>
  80223a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223e:	48 c1 e8 0c          	shr    $0xc,%rax
  802242:	48 89 c2             	mov    %rax,%rdx
  802245:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80224c:	01 00 00 
  80224f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802253:	83 e0 01             	and    $0x1,%eax
  802256:	48 85 c0             	test   %rax,%rax
  802259:	75 07                	jne    802262 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80225b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802260:	eb 10                	jmp    802272 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802262:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802266:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80226a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802272:	c9                   	leaveq 
  802273:	c3                   	retq   

0000000000802274 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802274:	55                   	push   %rbp
  802275:	48 89 e5             	mov    %rsp,%rbp
  802278:	48 83 ec 30          	sub    $0x30,%rsp
  80227c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802280:	89 f0                	mov    %esi,%eax
  802282:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802289:	48 89 c7             	mov    %rax,%rdi
  80228c:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  802293:	00 00 00 
  802296:	ff d0                	callq  *%rax
  802298:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80229c:	48 89 d6             	mov    %rdx,%rsi
  80229f:	89 c7                	mov    %eax,%edi
  8022a1:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b4:	78 0a                	js     8022c0 <fd_close+0x4c>
	    || fd != fd2)
  8022b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ba:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022be:	74 12                	je     8022d2 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022c0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022c4:	74 05                	je     8022cb <fd_close+0x57>
  8022c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c9:	eb 05                	jmp    8022d0 <fd_close+0x5c>
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	eb 69                	jmp    80233b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d6:	8b 00                	mov    (%rax),%eax
  8022d8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022dc:	48 89 d6             	mov    %rdx,%rsi
  8022df:	89 c7                	mov    %eax,%edi
  8022e1:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  8022e8:	00 00 00 
  8022eb:	ff d0                	callq  *%rax
  8022ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f4:	78 2a                	js     802320 <fd_close+0xac>
		if (dev->dev_close)
  8022f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fa:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022fe:	48 85 c0             	test   %rax,%rax
  802301:	74 16                	je     802319 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802307:	48 8b 40 20          	mov    0x20(%rax),%rax
  80230b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80230f:	48 89 d7             	mov    %rdx,%rdi
  802312:	ff d0                	callq  *%rax
  802314:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802317:	eb 07                	jmp    802320 <fd_close+0xac>
		else
			r = 0;
  802319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802320:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802324:	48 89 c6             	mov    %rax,%rsi
  802327:	bf 00 00 00 00       	mov    $0x0,%edi
  80232c:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  802333:	00 00 00 
  802336:	ff d0                	callq  *%rax
	return r;
  802338:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80233b:	c9                   	leaveq 
  80233c:	c3                   	retq   

000000000080233d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80233d:	55                   	push   %rbp
  80233e:	48 89 e5             	mov    %rsp,%rbp
  802341:	48 83 ec 20          	sub    $0x20,%rsp
  802345:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80234c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802353:	eb 41                	jmp    802396 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802355:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  80235c:	00 00 00 
  80235f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802362:	48 63 d2             	movslq %edx,%rdx
  802365:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802369:	8b 00                	mov    (%rax),%eax
  80236b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80236e:	75 22                	jne    802392 <dev_lookup+0x55>
			*dev = devtab[i];
  802370:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  802377:	00 00 00 
  80237a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80237d:	48 63 d2             	movslq %edx,%rdx
  802380:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802388:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
  802390:	eb 60                	jmp    8023f2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802392:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802396:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  80239d:	00 00 00 
  8023a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023a3:	48 63 d2             	movslq %edx,%rdx
  8023a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023aa:	48 85 c0             	test   %rax,%rax
  8023ad:	75 a6                	jne    802355 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023af:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8023b6:	00 00 00 
  8023b9:	48 8b 00             	mov    (%rax),%rax
  8023bc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023c2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023c5:	89 c6                	mov    %eax,%esi
  8023c7:	48 bf 18 4b 80 00 00 	movabs $0x804b18,%rdi
  8023ce:	00 00 00 
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	48 b9 9a 09 80 00 00 	movabs $0x80099a,%rcx
  8023dd:	00 00 00 
  8023e0:	ff d1                	callq  *%rcx
	*dev = 0;
  8023e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023f2:	c9                   	leaveq 
  8023f3:	c3                   	retq   

00000000008023f4 <close>:

int
close(int fdnum)
{
  8023f4:	55                   	push   %rbp
  8023f5:	48 89 e5             	mov    %rsp,%rbp
  8023f8:	48 83 ec 20          	sub    $0x20,%rsp
  8023fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802403:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802406:	48 89 d6             	mov    %rdx,%rsi
  802409:	89 c7                	mov    %eax,%edi
  80240b:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  802412:	00 00 00 
  802415:	ff d0                	callq  *%rax
  802417:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80241a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241e:	79 05                	jns    802425 <close+0x31>
		return r;
  802420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802423:	eb 18                	jmp    80243d <close+0x49>
	else
		return fd_close(fd, 1);
  802425:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802429:	be 01 00 00 00       	mov    $0x1,%esi
  80242e:	48 89 c7             	mov    %rax,%rdi
  802431:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
}
  80243d:	c9                   	leaveq 
  80243e:	c3                   	retq   

000000000080243f <close_all>:

void
close_all(void)
{
  80243f:	55                   	push   %rbp
  802440:	48 89 e5             	mov    %rsp,%rbp
  802443:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80244e:	eb 15                	jmp    802465 <close_all+0x26>
		close(i);
  802450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802453:	89 c7                	mov    %eax,%edi
  802455:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802461:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802465:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802469:	7e e5                	jle    802450 <close_all+0x11>
		close(i);
}
  80246b:	c9                   	leaveq 
  80246c:	c3                   	retq   

000000000080246d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80246d:	55                   	push   %rbp
  80246e:	48 89 e5             	mov    %rsp,%rbp
  802471:	48 83 ec 40          	sub    $0x40,%rsp
  802475:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802478:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80247b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80247f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802482:	48 89 d6             	mov    %rdx,%rsi
  802485:	89 c7                	mov    %eax,%edi
  802487:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
  802493:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802496:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249a:	79 08                	jns    8024a4 <dup+0x37>
		return r;
  80249c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249f:	e9 70 01 00 00       	jmpq   802614 <dup+0x1a7>
	close(newfdnum);
  8024a4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024a7:	89 c7                	mov    %eax,%edi
  8024a9:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8024b0:	00 00 00 
  8024b3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024b5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024b8:	48 98                	cltq   
  8024ba:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024c0:	48 c1 e0 0c          	shl    $0xc,%rax
  8024c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024cc:	48 89 c7             	mov    %rax,%rdi
  8024cf:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  8024d6:	00 00 00 
  8024d9:	ff d0                	callq  *%rax
  8024db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e3:	48 89 c7             	mov    %rax,%rdi
  8024e6:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  8024ed:	00 00 00 
  8024f0:	ff d0                	callq  *%rax
  8024f2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fa:	48 c1 e8 15          	shr    $0x15,%rax
  8024fe:	48 89 c2             	mov    %rax,%rdx
  802501:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802508:	01 00 00 
  80250b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250f:	83 e0 01             	and    $0x1,%eax
  802512:	48 85 c0             	test   %rax,%rax
  802515:	74 73                	je     80258a <dup+0x11d>
  802517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251b:	48 c1 e8 0c          	shr    $0xc,%rax
  80251f:	48 89 c2             	mov    %rax,%rdx
  802522:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802529:	01 00 00 
  80252c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802530:	83 e0 01             	and    $0x1,%eax
  802533:	48 85 c0             	test   %rax,%rax
  802536:	74 52                	je     80258a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253c:	48 c1 e8 0c          	shr    $0xc,%rax
  802540:	48 89 c2             	mov    %rax,%rdx
  802543:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80254a:	01 00 00 
  80254d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802551:	25 07 0e 00 00       	and    $0xe07,%eax
  802556:	89 c1                	mov    %eax,%ecx
  802558:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80255c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802560:	41 89 c8             	mov    %ecx,%r8d
  802563:	48 89 d1             	mov    %rdx,%rcx
  802566:	ba 00 00 00 00       	mov    $0x0,%edx
  80256b:	48 89 c6             	mov    %rax,%rsi
  80256e:	bf 00 00 00 00       	mov    $0x0,%edi
  802573:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  80257a:	00 00 00 
  80257d:	ff d0                	callq  *%rax
  80257f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802582:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802586:	79 02                	jns    80258a <dup+0x11d>
			goto err;
  802588:	eb 57                	jmp    8025e1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80258a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258e:	48 c1 e8 0c          	shr    $0xc,%rax
  802592:	48 89 c2             	mov    %rax,%rdx
  802595:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80259c:	01 00 00 
  80259f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8025a8:	89 c1                	mov    %eax,%ecx
  8025aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025b2:	41 89 c8             	mov    %ecx,%r8d
  8025b5:	48 89 d1             	mov    %rdx,%rcx
  8025b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025bd:	48 89 c6             	mov    %rax,%rsi
  8025c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c5:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	callq  *%rax
  8025d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d8:	79 02                	jns    8025dc <dup+0x16f>
		goto err;
  8025da:	eb 05                	jmp    8025e1 <dup+0x174>

	return newfdnum;
  8025dc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025df:	eb 33                	jmp    802614 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e5:	48 89 c6             	mov    %rax,%rsi
  8025e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ed:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  8025f4:	00 00 00 
  8025f7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025fd:	48 89 c6             	mov    %rax,%rsi
  802600:	bf 00 00 00 00       	mov    $0x0,%edi
  802605:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	callq  *%rax
	return r;
  802611:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802614:	c9                   	leaveq 
  802615:	c3                   	retq   

0000000000802616 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802616:	55                   	push   %rbp
  802617:	48 89 e5             	mov    %rsp,%rbp
  80261a:	48 83 ec 40          	sub    $0x40,%rsp
  80261e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802621:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802625:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802629:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80262d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802630:	48 89 d6             	mov    %rdx,%rsi
  802633:	89 c7                	mov    %eax,%edi
  802635:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
  802641:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802644:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802648:	78 24                	js     80266e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80264a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264e:	8b 00                	mov    (%rax),%eax
  802650:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802654:	48 89 d6             	mov    %rdx,%rsi
  802657:	89 c7                	mov    %eax,%edi
  802659:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  802660:	00 00 00 
  802663:	ff d0                	callq  *%rax
  802665:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802668:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266c:	79 05                	jns    802673 <read+0x5d>
		return r;
  80266e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802671:	eb 76                	jmp    8026e9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802677:	8b 40 08             	mov    0x8(%rax),%eax
  80267a:	83 e0 03             	and    $0x3,%eax
  80267d:	83 f8 01             	cmp    $0x1,%eax
  802680:	75 3a                	jne    8026bc <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802682:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802689:	00 00 00 
  80268c:	48 8b 00             	mov    (%rax),%rax
  80268f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802695:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802698:	89 c6                	mov    %eax,%esi
  80269a:	48 bf 37 4b 80 00 00 	movabs $0x804b37,%rdi
  8026a1:	00 00 00 
  8026a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a9:	48 b9 9a 09 80 00 00 	movabs $0x80099a,%rcx
  8026b0:	00 00 00 
  8026b3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ba:	eb 2d                	jmp    8026e9 <read+0xd3>
	}
	if (!dev->dev_read)
  8026bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026c4:	48 85 c0             	test   %rax,%rax
  8026c7:	75 07                	jne    8026d0 <read+0xba>
		return -E_NOT_SUPP;
  8026c9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026ce:	eb 19                	jmp    8026e9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8026d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026d8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026e0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026e4:	48 89 cf             	mov    %rcx,%rdi
  8026e7:	ff d0                	callq  *%rax
}
  8026e9:	c9                   	leaveq 
  8026ea:	c3                   	retq   

00000000008026eb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026eb:	55                   	push   %rbp
  8026ec:	48 89 e5             	mov    %rsp,%rbp
  8026ef:	48 83 ec 30          	sub    $0x30,%rsp
  8026f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802705:	eb 49                	jmp    802750 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270a:	48 98                	cltq   
  80270c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802710:	48 29 c2             	sub    %rax,%rdx
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802716:	48 63 c8             	movslq %eax,%rcx
  802719:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80271d:	48 01 c1             	add    %rax,%rcx
  802720:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802723:	48 89 ce             	mov    %rcx,%rsi
  802726:	89 c7                	mov    %eax,%edi
  802728:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
  802734:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802737:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80273b:	79 05                	jns    802742 <readn+0x57>
			return m;
  80273d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802740:	eb 1c                	jmp    80275e <readn+0x73>
		if (m == 0)
  802742:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802746:	75 02                	jne    80274a <readn+0x5f>
			break;
  802748:	eb 11                	jmp    80275b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80274a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80274d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802753:	48 98                	cltq   
  802755:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802759:	72 ac                	jb     802707 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80275b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80275e:	c9                   	leaveq 
  80275f:	c3                   	retq   

0000000000802760 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802760:	55                   	push   %rbp
  802761:	48 89 e5             	mov    %rsp,%rbp
  802764:	48 83 ec 40          	sub    $0x40,%rsp
  802768:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80276b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80276f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802773:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802777:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80277a:	48 89 d6             	mov    %rdx,%rsi
  80277d:	89 c7                	mov    %eax,%edi
  80277f:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
  80278b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802792:	78 24                	js     8027b8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802798:	8b 00                	mov    (%rax),%eax
  80279a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80279e:	48 89 d6             	mov    %rdx,%rsi
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
  8027af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b6:	79 05                	jns    8027bd <write+0x5d>
		return r;
  8027b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bb:	eb 75                	jmp    802832 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c1:	8b 40 08             	mov    0x8(%rax),%eax
  8027c4:	83 e0 03             	and    $0x3,%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	75 3a                	jne    802805 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8027cb:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8027d2:	00 00 00 
  8027d5:	48 8b 00             	mov    (%rax),%rax
  8027d8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027de:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027e1:	89 c6                	mov    %eax,%esi
  8027e3:	48 bf 53 4b 80 00 00 	movabs $0x804b53,%rdi
  8027ea:	00 00 00 
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	48 b9 9a 09 80 00 00 	movabs $0x80099a,%rcx
  8027f9:	00 00 00 
  8027fc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802803:	eb 2d                	jmp    802832 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802809:	48 8b 40 18          	mov    0x18(%rax),%rax
  80280d:	48 85 c0             	test   %rax,%rax
  802810:	75 07                	jne    802819 <write+0xb9>
		return -E_NOT_SUPP;
  802812:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802817:	eb 19                	jmp    802832 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802819:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802821:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802825:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802829:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80282d:	48 89 cf             	mov    %rcx,%rdi
  802830:	ff d0                	callq  *%rax
}
  802832:	c9                   	leaveq 
  802833:	c3                   	retq   

0000000000802834 <seek>:

int
seek(int fdnum, off_t offset)
{
  802834:	55                   	push   %rbp
  802835:	48 89 e5             	mov    %rsp,%rbp
  802838:	48 83 ec 18          	sub    $0x18,%rsp
  80283c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80283f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802842:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802846:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802849:	48 89 d6             	mov    %rdx,%rsi
  80284c:	89 c7                	mov    %eax,%edi
  80284e:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
  80285a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802861:	79 05                	jns    802868 <seek+0x34>
		return r;
  802863:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802866:	eb 0f                	jmp    802877 <seek+0x43>
	fd->fd_offset = offset;
  802868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80286f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802877:	c9                   	leaveq 
  802878:	c3                   	retq   

0000000000802879 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 83 ec 30          	sub    $0x30,%rsp
  802881:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802884:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802887:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80288b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80288e:	48 89 d6             	mov    %rdx,%rsi
  802891:	89 c7                	mov    %eax,%edi
  802893:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
  80289f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a6:	78 24                	js     8028cc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ac:	8b 00                	mov    (%rax),%eax
  8028ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b2:	48 89 d6             	mov    %rdx,%rsi
  8028b5:	89 c7                	mov    %eax,%edi
  8028b7:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
  8028c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ca:	79 05                	jns    8028d1 <ftruncate+0x58>
		return r;
  8028cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cf:	eb 72                	jmp    802943 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d5:	8b 40 08             	mov    0x8(%rax),%eax
  8028d8:	83 e0 03             	and    $0x3,%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	75 3a                	jne    802919 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028df:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8028e6:	00 00 00 
  8028e9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028ec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028f5:	89 c6                	mov    %eax,%esi
  8028f7:	48 bf 70 4b 80 00 00 	movabs $0x804b70,%rdi
  8028fe:	00 00 00 
  802901:	b8 00 00 00 00       	mov    $0x0,%eax
  802906:	48 b9 9a 09 80 00 00 	movabs $0x80099a,%rcx
  80290d:	00 00 00 
  802910:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802912:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802917:	eb 2a                	jmp    802943 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802921:	48 85 c0             	test   %rax,%rax
  802924:	75 07                	jne    80292d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802926:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80292b:	eb 16                	jmp    802943 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80292d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802931:	48 8b 40 30          	mov    0x30(%rax),%rax
  802935:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802939:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80293c:	89 ce                	mov    %ecx,%esi
  80293e:	48 89 d7             	mov    %rdx,%rdi
  802941:	ff d0                	callq  *%rax
}
  802943:	c9                   	leaveq 
  802944:	c3                   	retq   

0000000000802945 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802945:	55                   	push   %rbp
  802946:	48 89 e5             	mov    %rsp,%rbp
  802949:	48 83 ec 30          	sub    $0x30,%rsp
  80294d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802950:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802954:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802958:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80295b:	48 89 d6             	mov    %rdx,%rsi
  80295e:	89 c7                	mov    %eax,%edi
  802960:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  802967:	00 00 00 
  80296a:	ff d0                	callq  *%rax
  80296c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802973:	78 24                	js     802999 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802979:	8b 00                	mov    (%rax),%eax
  80297b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297f:	48 89 d6             	mov    %rdx,%rsi
  802982:	89 c7                	mov    %eax,%edi
  802984:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  80298b:	00 00 00 
  80298e:	ff d0                	callq  *%rax
  802990:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802993:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802997:	79 05                	jns    80299e <fstat+0x59>
		return r;
  802999:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299c:	eb 5e                	jmp    8029fc <fstat+0xb7>
	if (!dev->dev_stat)
  80299e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029a6:	48 85 c0             	test   %rax,%rax
  8029a9:	75 07                	jne    8029b2 <fstat+0x6d>
		return -E_NOT_SUPP;
  8029ab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029b0:	eb 4a                	jmp    8029fc <fstat+0xb7>
	stat->st_name[0] = 0;
  8029b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029b6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029bd:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8029c4:	00 00 00 
	stat->st_isdir = 0;
  8029c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029cb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8029d2:	00 00 00 
	stat->st_dev = dev;
  8029d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029dd:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029f0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029f4:	48 89 ce             	mov    %rcx,%rsi
  8029f7:	48 89 d7             	mov    %rdx,%rdi
  8029fa:	ff d0                	callq  *%rax
}
  8029fc:	c9                   	leaveq 
  8029fd:	c3                   	retq   

00000000008029fe <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029fe:	55                   	push   %rbp
  8029ff:	48 89 e5             	mov    %rsp,%rbp
  802a02:	48 83 ec 20          	sub    $0x20,%rsp
  802a06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a0a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a12:	be 00 00 00 00       	mov    $0x0,%esi
  802a17:	48 89 c7             	mov    %rax,%rdi
  802a1a:	48 b8 ec 2a 80 00 00 	movabs $0x802aec,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2d:	79 05                	jns    802a34 <stat+0x36>
		return fd;
  802a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a32:	eb 2f                	jmp    802a63 <stat+0x65>
	r = fstat(fd, stat);
  802a34:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3b:	48 89 d6             	mov    %rdx,%rsi
  802a3e:	89 c7                	mov    %eax,%edi
  802a40:	48 b8 45 29 80 00 00 	movabs $0x802945,%rax
  802a47:	00 00 00 
  802a4a:	ff d0                	callq  *%rax
  802a4c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a52:	89 c7                	mov    %eax,%edi
  802a54:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
	return r;
  802a60:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a63:	c9                   	leaveq 
  802a64:	c3                   	retq   

0000000000802a65 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a65:	55                   	push   %rbp
  802a66:	48 89 e5             	mov    %rsp,%rbp
  802a69:	48 83 ec 10          	sub    $0x10,%rsp
  802a6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a74:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a7b:	00 00 00 
  802a7e:	8b 00                	mov    (%rax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	75 1d                	jne    802aa1 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a84:	bf 01 00 00 00       	mov    $0x1,%edi
  802a89:	48 b8 70 43 80 00 00 	movabs $0x804370,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
  802a95:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a9c:	00 00 00 
  802a9f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802aa1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa8:	00 00 00 
  802aab:	8b 00                	mov    (%rax),%eax
  802aad:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ab0:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ab5:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802abc:	00 00 00 
  802abf:	89 c7                	mov    %eax,%edi
  802ac1:	48 b8 d8 42 80 00 00 	movabs $0x8042d8,%rax
  802ac8:	00 00 00 
  802acb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802acd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad6:	48 89 c6             	mov    %rax,%rsi
  802ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ade:	48 b8 17 42 80 00 00 	movabs $0x804217,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
}
  802aea:	c9                   	leaveq 
  802aeb:	c3                   	retq   

0000000000802aec <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802aec:	55                   	push   %rbp
  802aed:	48 89 e5             	mov    %rsp,%rbp
  802af0:	48 83 ec 20          	sub    $0x20,%rsp
  802af4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aff:	48 89 c7             	mov    %rax,%rdi
  802b02:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
  802b0e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b13:	7e 0a                	jle    802b1f <open+0x33>
		return -E_BAD_PATH;
  802b15:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b1a:	e9 a5 00 00 00       	jmpq   802bc4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802b1f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b23:	48 89 c7             	mov    %rax,%rdi
  802b26:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  802b2d:	00 00 00 
  802b30:	ff d0                	callq  *%rax
  802b32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b39:	79 08                	jns    802b43 <open+0x57>
		return r;
  802b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3e:	e9 81 00 00 00       	jmpq   802bc4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802b43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b47:	48 89 c6             	mov    %rax,%rsi
  802b4a:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802b51:	00 00 00 
  802b54:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802b60:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802b67:	00 00 00 
  802b6a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b6d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802b73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b77:	48 89 c6             	mov    %rax,%rsi
  802b7a:	bf 01 00 00 00       	mov    $0x1,%edi
  802b7f:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
  802b8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b92:	79 1d                	jns    802bb1 <open+0xc5>
		fd_close(fd, 0);
  802b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b98:	be 00 00 00 00       	mov    $0x0,%esi
  802b9d:	48 89 c7             	mov    %rax,%rdi
  802ba0:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802ba7:	00 00 00 
  802baa:	ff d0                	callq  *%rax
		return r;
  802bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802baf:	eb 13                	jmp    802bc4 <open+0xd8>
	}

	return fd2num(fd);
  802bb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb5:	48 89 c7             	mov    %rax,%rdi
  802bb8:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802bc4:	c9                   	leaveq 
  802bc5:	c3                   	retq   

0000000000802bc6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bc6:	55                   	push   %rbp
  802bc7:	48 89 e5             	mov    %rsp,%rbp
  802bca:	48 83 ec 10          	sub    $0x10,%rsp
  802bce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd6:	8b 50 0c             	mov    0xc(%rax),%edx
  802bd9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802be0:	00 00 00 
  802be3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802be5:	be 00 00 00 00       	mov    $0x0,%esi
  802bea:	bf 06 00 00 00       	mov    $0x6,%edi
  802bef:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	callq  *%rax
}
  802bfb:	c9                   	leaveq 
  802bfc:	c3                   	retq   

0000000000802bfd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802bfd:	55                   	push   %rbp
  802bfe:	48 89 e5             	mov    %rsp,%rbp
  802c01:	48 83 ec 30          	sub    $0x30,%rsp
  802c05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c15:	8b 50 0c             	mov    0xc(%rax),%edx
  802c18:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c1f:	00 00 00 
  802c22:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c24:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c2b:	00 00 00 
  802c2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c32:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802c36:	be 00 00 00 00       	mov    $0x0,%esi
  802c3b:	bf 03 00 00 00       	mov    $0x3,%edi
  802c40:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802c47:	00 00 00 
  802c4a:	ff d0                	callq  *%rax
  802c4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c53:	79 08                	jns    802c5d <devfile_read+0x60>
		return r;
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c58:	e9 a4 00 00 00       	jmpq   802d01 <devfile_read+0x104>
	assert(r <= n);
  802c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c60:	48 98                	cltq   
  802c62:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c66:	76 35                	jbe    802c9d <devfile_read+0xa0>
  802c68:	48 b9 9d 4b 80 00 00 	movabs $0x804b9d,%rcx
  802c6f:	00 00 00 
  802c72:	48 ba a4 4b 80 00 00 	movabs $0x804ba4,%rdx
  802c79:	00 00 00 
  802c7c:	be 84 00 00 00       	mov    $0x84,%esi
  802c81:	48 bf b9 4b 80 00 00 	movabs $0x804bb9,%rdi
  802c88:	00 00 00 
  802c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c90:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  802c97:	00 00 00 
  802c9a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802c9d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802ca4:	7e 35                	jle    802cdb <devfile_read+0xde>
  802ca6:	48 b9 c4 4b 80 00 00 	movabs $0x804bc4,%rcx
  802cad:	00 00 00 
  802cb0:	48 ba a4 4b 80 00 00 	movabs $0x804ba4,%rdx
  802cb7:	00 00 00 
  802cba:	be 85 00 00 00       	mov    $0x85,%esi
  802cbf:	48 bf b9 4b 80 00 00 	movabs $0x804bb9,%rdi
  802cc6:	00 00 00 
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cce:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  802cd5:	00 00 00 
  802cd8:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cde:	48 63 d0             	movslq %eax,%rdx
  802ce1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802cec:	00 00 00 
  802cef:	48 89 c7             	mov    %rax,%rdi
  802cf2:	48 b8 86 18 80 00 00 	movabs $0x801886,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
	return r;
  802cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802d01:	c9                   	leaveq 
  802d02:	c3                   	retq   

0000000000802d03 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d03:	55                   	push   %rbp
  802d04:	48 89 e5             	mov    %rsp,%rbp
  802d07:	48 83 ec 30          	sub    $0x30,%rsp
  802d0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1b:	8b 50 0c             	mov    0xc(%rax),%edx
  802d1e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d25:	00 00 00 
  802d28:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802d2a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d31:	00 00 00 
  802d34:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d38:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802d3c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d43:	00 
  802d44:	76 35                	jbe    802d7b <devfile_write+0x78>
  802d46:	48 b9 d0 4b 80 00 00 	movabs $0x804bd0,%rcx
  802d4d:	00 00 00 
  802d50:	48 ba a4 4b 80 00 00 	movabs $0x804ba4,%rdx
  802d57:	00 00 00 
  802d5a:	be 9e 00 00 00       	mov    $0x9e,%esi
  802d5f:	48 bf b9 4b 80 00 00 	movabs $0x804bb9,%rdi
  802d66:	00 00 00 
  802d69:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6e:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  802d75:	00 00 00 
  802d78:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802d7b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d83:	48 89 c6             	mov    %rax,%rsi
  802d86:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802d8d:	00 00 00 
  802d90:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802d9c:	be 00 00 00 00       	mov    $0x0,%esi
  802da1:	bf 04 00 00 00       	mov    $0x4,%edi
  802da6:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db9:	79 05                	jns    802dc0 <devfile_write+0xbd>
		return r;
  802dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbe:	eb 43                	jmp    802e03 <devfile_write+0x100>
	assert(r <= n);
  802dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc3:	48 98                	cltq   
  802dc5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802dc9:	76 35                	jbe    802e00 <devfile_write+0xfd>
  802dcb:	48 b9 9d 4b 80 00 00 	movabs $0x804b9d,%rcx
  802dd2:	00 00 00 
  802dd5:	48 ba a4 4b 80 00 00 	movabs $0x804ba4,%rdx
  802ddc:	00 00 00 
  802ddf:	be a2 00 00 00       	mov    $0xa2,%esi
  802de4:	48 bf b9 4b 80 00 00 	movabs $0x804bb9,%rdi
  802deb:	00 00 00 
  802dee:	b8 00 00 00 00       	mov    $0x0,%eax
  802df3:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  802dfa:	00 00 00 
  802dfd:	41 ff d0             	callq  *%r8
	return r;
  802e00:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802e03:	c9                   	leaveq 
  802e04:	c3                   	retq   

0000000000802e05 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e05:	55                   	push   %rbp
  802e06:	48 89 e5             	mov    %rsp,%rbp
  802e09:	48 83 ec 20          	sub    $0x20,%rsp
  802e0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e19:	8b 50 0c             	mov    0xc(%rax),%edx
  802e1c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e23:	00 00 00 
  802e26:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e28:	be 00 00 00 00       	mov    $0x0,%esi
  802e2d:	bf 05 00 00 00       	mov    $0x5,%edi
  802e32:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
  802e3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e45:	79 05                	jns    802e4c <devfile_stat+0x47>
		return r;
  802e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4a:	eb 56                	jmp    802ea2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e50:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802e57:	00 00 00 
  802e5a:	48 89 c7             	mov    %rax,%rdi
  802e5d:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e69:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e70:	00 00 00 
  802e73:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e7d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e83:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e8a:	00 00 00 
  802e8d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e97:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea2:	c9                   	leaveq 
  802ea3:	c3                   	retq   

0000000000802ea4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ea4:	55                   	push   %rbp
  802ea5:	48 89 e5             	mov    %rsp,%rbp
  802ea8:	48 83 ec 10          	sub    $0x10,%rsp
  802eac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802eb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb7:	8b 50 0c             	mov    0xc(%rax),%edx
  802eba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ec1:	00 00 00 
  802ec4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ec6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ecd:	00 00 00 
  802ed0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ed3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ed6:	be 00 00 00 00       	mov    $0x0,%esi
  802edb:	bf 02 00 00 00       	mov    $0x2,%edi
  802ee0:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802ee7:	00 00 00 
  802eea:	ff d0                	callq  *%rax
}
  802eec:	c9                   	leaveq 
  802eed:	c3                   	retq   

0000000000802eee <remove>:

// Delete a file
int
remove(const char *path)
{
  802eee:	55                   	push   %rbp
  802eef:	48 89 e5             	mov    %rsp,%rbp
  802ef2:	48 83 ec 10          	sub    $0x10,%rsp
  802ef6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802efe:	48 89 c7             	mov    %rax,%rdi
  802f01:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  802f08:	00 00 00 
  802f0b:	ff d0                	callq  *%rax
  802f0d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f12:	7e 07                	jle    802f1b <remove+0x2d>
		return -E_BAD_PATH;
  802f14:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f19:	eb 33                	jmp    802f4e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1f:	48 89 c6             	mov    %rax,%rsi
  802f22:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802f29:	00 00 00 
  802f2c:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f38:	be 00 00 00 00       	mov    $0x0,%esi
  802f3d:	bf 07 00 00 00       	mov    $0x7,%edi
  802f42:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
}
  802f4e:	c9                   	leaveq 
  802f4f:	c3                   	retq   

0000000000802f50 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f50:	55                   	push   %rbp
  802f51:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f54:	be 00 00 00 00       	mov    $0x0,%esi
  802f59:	bf 08 00 00 00       	mov    $0x8,%edi
  802f5e:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	callq  *%rax
}
  802f6a:	5d                   	pop    %rbp
  802f6b:	c3                   	retq   

0000000000802f6c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802f6c:	55                   	push   %rbp
  802f6d:	48 89 e5             	mov    %rsp,%rbp
  802f70:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802f77:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f7e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f85:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f8c:	be 00 00 00 00       	mov    $0x0,%esi
  802f91:	48 89 c7             	mov    %rax,%rdi
  802f94:	48 b8 ec 2a 80 00 00 	movabs $0x802aec,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
  802fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa7:	79 28                	jns    802fd1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fac:	89 c6                	mov    %eax,%esi
  802fae:	48 bf fd 4b 80 00 00 	movabs $0x804bfd,%rdi
  802fb5:	00 00 00 
  802fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbd:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  802fc4:	00 00 00 
  802fc7:	ff d2                	callq  *%rdx
		return fd_src;
  802fc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcc:	e9 74 01 00 00       	jmpq   803145 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802fd1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802fd8:	be 01 01 00 00       	mov    $0x101,%esi
  802fdd:	48 89 c7             	mov    %rax,%rdi
  802fe0:	48 b8 ec 2a 80 00 00 	movabs $0x802aec,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
  802fec:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802fef:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ff3:	79 39                	jns    80302e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ff5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ff8:	89 c6                	mov    %eax,%esi
  802ffa:	48 bf 13 4c 80 00 00 	movabs $0x804c13,%rdi
  803001:	00 00 00 
  803004:	b8 00 00 00 00       	mov    $0x0,%eax
  803009:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  803010:	00 00 00 
  803013:	ff d2                	callq  *%rdx
		close(fd_src);
  803015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803018:	89 c7                	mov    %eax,%edi
  80301a:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
		return fd_dest;
  803026:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803029:	e9 17 01 00 00       	jmpq   803145 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80302e:	eb 74                	jmp    8030a4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803030:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803033:	48 63 d0             	movslq %eax,%rdx
  803036:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80303d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803040:	48 89 ce             	mov    %rcx,%rsi
  803043:	89 c7                	mov    %eax,%edi
  803045:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
  803051:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803054:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803058:	79 4a                	jns    8030a4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80305a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80305d:	89 c6                	mov    %eax,%esi
  80305f:	48 bf 2d 4c 80 00 00 	movabs $0x804c2d,%rdi
  803066:	00 00 00 
  803069:	b8 00 00 00 00       	mov    $0x0,%eax
  80306e:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  803075:	00 00 00 
  803078:	ff d2                	callq  *%rdx
			close(fd_src);
  80307a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307d:	89 c7                	mov    %eax,%edi
  80307f:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
			close(fd_dest);
  80308b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80308e:	89 c7                	mov    %eax,%edi
  803090:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803097:	00 00 00 
  80309a:	ff d0                	callq  *%rax
			return write_size;
  80309c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80309f:	e9 a1 00 00 00       	jmpq   803145 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030a4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8030b3:	48 89 ce             	mov    %rcx,%rsi
  8030b6:	89 c7                	mov    %eax,%edi
  8030b8:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
  8030c4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8030cb:	0f 8f 5f ff ff ff    	jg     803030 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8030d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8030d5:	79 47                	jns    80311e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8030d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030da:	89 c6                	mov    %eax,%esi
  8030dc:	48 bf 40 4c 80 00 00 	movabs $0x804c40,%rdi
  8030e3:	00 00 00 
  8030e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030eb:	48 ba 9a 09 80 00 00 	movabs $0x80099a,%rdx
  8030f2:	00 00 00 
  8030f5:	ff d2                	callq  *%rdx
		close(fd_src);
  8030f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fa:	89 c7                	mov    %eax,%edi
  8030fc:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803103:	00 00 00 
  803106:	ff d0                	callq  *%rax
		close(fd_dest);
  803108:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80310b:	89 c7                	mov    %eax,%edi
  80310d:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  803114:	00 00 00 
  803117:	ff d0                	callq  *%rax
		return read_size;
  803119:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80311c:	eb 27                	jmp    803145 <copy+0x1d9>
	}
	close(fd_src);
  80311e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803121:	89 c7                	mov    %eax,%edi
  803123:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80312a:	00 00 00 
  80312d:	ff d0                	callq  *%rax
	close(fd_dest);
  80312f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803132:	89 c7                	mov    %eax,%edi
  803134:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	callq  *%rax
	return 0;
  803140:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803145:	c9                   	leaveq 
  803146:	c3                   	retq   

0000000000803147 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803147:	55                   	push   %rbp
  803148:	48 89 e5             	mov    %rsp,%rbp
  80314b:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803152:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803159:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803160:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803167:	be 00 00 00 00       	mov    $0x0,%esi
  80316c:	48 89 c7             	mov    %rax,%rdi
  80316f:	48 b8 ec 2a 80 00 00 	movabs $0x802aec,%rax
  803176:	00 00 00 
  803179:	ff d0                	callq  *%rax
  80317b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80317e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803182:	79 08                	jns    80318c <spawn+0x45>
		return r;
  803184:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803187:	e9 14 03 00 00       	jmpq   8034a0 <spawn+0x359>
	fd = r;
  80318c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80318f:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803192:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803199:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80319d:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8031a4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031a7:	ba 00 02 00 00       	mov    $0x200,%edx
  8031ac:	48 89 ce             	mov    %rcx,%rsi
  8031af:	89 c7                	mov    %eax,%edi
  8031b1:	48 b8 eb 26 80 00 00 	movabs $0x8026eb,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
  8031bd:	3d 00 02 00 00       	cmp    $0x200,%eax
  8031c2:	75 0d                	jne    8031d1 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8031c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c8:	8b 00                	mov    (%rax),%eax
  8031ca:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8031cf:	74 43                	je     803214 <spawn+0xcd>
		close(fd);
  8031d1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031d4:	89 c7                	mov    %eax,%edi
  8031d6:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8031e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e6:	8b 00                	mov    (%rax),%eax
  8031e8:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8031ed:	89 c6                	mov    %eax,%esi
  8031ef:	48 bf 58 4c 80 00 00 	movabs $0x804c58,%rdi
  8031f6:	00 00 00 
  8031f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fe:	48 b9 9a 09 80 00 00 	movabs $0x80099a,%rcx
  803205:	00 00 00 
  803208:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80320a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80320f:	e9 8c 02 00 00       	jmpq   8034a0 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803214:	b8 07 00 00 00       	mov    $0x7,%eax
  803219:	cd 30                	int    $0x30
  80321b:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80321e:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803221:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803224:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803228:	79 08                	jns    803232 <spawn+0xeb>
		return r;
  80322a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80322d:	e9 6e 02 00 00       	jmpq   8034a0 <spawn+0x359>
	child = r;
  803232:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803235:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803238:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80323b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803240:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803247:	00 00 00 
  80324a:	48 63 d0             	movslq %eax,%rdx
  80324d:	48 89 d0             	mov    %rdx,%rax
  803250:	48 c1 e0 03          	shl    $0x3,%rax
  803254:	48 01 d0             	add    %rdx,%rax
  803257:	48 c1 e0 05          	shl    $0x5,%rax
  80325b:	48 01 c8             	add    %rcx,%rax
  80325e:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803265:	48 89 c6             	mov    %rax,%rsi
  803268:	b8 18 00 00 00       	mov    $0x18,%eax
  80326d:	48 89 d7             	mov    %rdx,%rdi
  803270:	48 89 c1             	mov    %rax,%rcx
  803273:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80327e:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803285:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80328c:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803293:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80329a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80329d:	48 89 ce             	mov    %rcx,%rsi
  8032a0:	89 c7                	mov    %eax,%edi
  8032a2:	48 b8 0a 37 80 00 00 	movabs $0x80370a,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
  8032ae:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032b5:	79 08                	jns    8032bf <spawn+0x178>
		return r;
  8032b7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032ba:	e9 e1 01 00 00       	jmpq   8034a0 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8032bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8032c7:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8032ce:	48 01 d0             	add    %rdx,%rax
  8032d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8032d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032dc:	e9 a3 00 00 00       	jmpq   803384 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8032e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e5:	8b 00                	mov    (%rax),%eax
  8032e7:	83 f8 01             	cmp    $0x1,%eax
  8032ea:	74 05                	je     8032f1 <spawn+0x1aa>
			continue;
  8032ec:	e9 8a 00 00 00       	jmpq   80337b <spawn+0x234>
		perm = PTE_P | PTE_U;
  8032f1:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8032f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fc:	8b 40 04             	mov    0x4(%rax),%eax
  8032ff:	83 e0 02             	and    $0x2,%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	74 04                	je     80330a <spawn+0x1c3>
			perm |= PTE_W;
  803306:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80330a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330e:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803312:	41 89 c1             	mov    %eax,%r9d
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80331d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803321:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803325:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803329:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80332d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803330:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803333:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803336:	89 3c 24             	mov    %edi,(%rsp)
  803339:	89 c7                	mov    %eax,%edi
  80333b:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80334a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80334e:	79 2b                	jns    80337b <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803350:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803351:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803354:	89 c7                	mov    %eax,%edi
  803356:	48 b8 d1 1d 80 00 00 	movabs $0x801dd1,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
	close(fd);
  803362:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803365:	89 c7                	mov    %eax,%edi
  803367:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
	return r;
  803373:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803376:	e9 25 01 00 00       	jmpq   8034a0 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80337b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80337f:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803388:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80338c:	0f b7 c0             	movzwl %ax,%eax
  80338f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803392:	0f 8f 49 ff ff ff    	jg     8032e1 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803398:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80339b:	89 c7                	mov    %eax,%edi
  80339d:	48 b8 f4 23 80 00 00 	movabs $0x8023f4,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
	fd = -1;
  8033a9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8033b0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033b3:	89 c7                	mov    %eax,%edi
  8033b5:	48 b8 9f 3b 80 00 00 	movabs $0x803b9f,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
  8033c1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033c8:	79 30                	jns    8033fa <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8033ca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033cd:	89 c1                	mov    %eax,%ecx
  8033cf:	48 ba 72 4c 80 00 00 	movabs $0x804c72,%rdx
  8033d6:	00 00 00 
  8033d9:	be 82 00 00 00       	mov    $0x82,%esi
  8033de:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  8033e5:	00 00 00 
  8033e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ed:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  8033f4:	00 00 00 
  8033f7:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8033fa:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803401:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803404:	48 89 d6             	mov    %rdx,%rsi
  803407:	89 c7                	mov    %eax,%edi
  803409:	48 b8 d1 1f 80 00 00 	movabs $0x801fd1,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803418:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80341c:	79 30                	jns    80344e <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  80341e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803421:	89 c1                	mov    %eax,%ecx
  803423:	48 ba 94 4c 80 00 00 	movabs $0x804c94,%rdx
  80342a:	00 00 00 
  80342d:	be 85 00 00 00       	mov    $0x85,%esi
  803432:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  803439:	00 00 00 
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
  803441:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  803448:	00 00 00 
  80344b:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80344e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803451:	be 02 00 00 00       	mov    $0x2,%esi
  803456:	89 c7                	mov    %eax,%edi
  803458:	48 b8 86 1f 80 00 00 	movabs $0x801f86,%rax
  80345f:	00 00 00 
  803462:	ff d0                	callq  *%rax
  803464:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803467:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80346b:	79 30                	jns    80349d <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  80346d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803470:	89 c1                	mov    %eax,%ecx
  803472:	48 ba ae 4c 80 00 00 	movabs $0x804cae,%rdx
  803479:	00 00 00 
  80347c:	be 88 00 00 00       	mov    $0x88,%esi
  803481:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  803488:	00 00 00 
  80348b:	b8 00 00 00 00       	mov    $0x0,%eax
  803490:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  803497:	00 00 00 
  80349a:	41 ff d0             	callq  *%r8

	return child;
  80349d:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8034a0:	c9                   	leaveq 
  8034a1:	c3                   	retq   

00000000008034a2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8034a2:	55                   	push   %rbp
  8034a3:	48 89 e5             	mov    %rsp,%rbp
  8034a6:	41 55                	push   %r13
  8034a8:	41 54                	push   %r12
  8034aa:	53                   	push   %rbx
  8034ab:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8034b2:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8034b9:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8034c0:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8034c7:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8034ce:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8034d5:	84 c0                	test   %al,%al
  8034d7:	74 26                	je     8034ff <spawnl+0x5d>
  8034d9:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8034e0:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8034e7:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8034eb:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8034ef:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8034f3:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8034f7:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8034fb:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8034ff:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803506:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80350d:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803510:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803517:	00 00 00 
  80351a:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803521:	00 00 00 
  803524:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803528:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80352f:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803536:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80353d:	eb 07                	jmp    803546 <spawnl+0xa4>
		argc++;
  80353f:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803546:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80354c:	83 f8 30             	cmp    $0x30,%eax
  80354f:	73 23                	jae    803574 <spawnl+0xd2>
  803551:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803558:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80355e:	89 c0                	mov    %eax,%eax
  803560:	48 01 d0             	add    %rdx,%rax
  803563:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803569:	83 c2 08             	add    $0x8,%edx
  80356c:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803572:	eb 15                	jmp    803589 <spawnl+0xe7>
  803574:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80357b:	48 89 d0             	mov    %rdx,%rax
  80357e:	48 83 c2 08          	add    $0x8,%rdx
  803582:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803589:	48 8b 00             	mov    (%rax),%rax
  80358c:	48 85 c0             	test   %rax,%rax
  80358f:	75 ae                	jne    80353f <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803591:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803597:	83 c0 02             	add    $0x2,%eax
  80359a:	48 89 e2             	mov    %rsp,%rdx
  80359d:	48 89 d3             	mov    %rdx,%rbx
  8035a0:	48 63 d0             	movslq %eax,%rdx
  8035a3:	48 83 ea 01          	sub    $0x1,%rdx
  8035a7:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8035ae:	48 63 d0             	movslq %eax,%rdx
  8035b1:	49 89 d4             	mov    %rdx,%r12
  8035b4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8035ba:	48 63 d0             	movslq %eax,%rdx
  8035bd:	49 89 d2             	mov    %rdx,%r10
  8035c0:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8035c6:	48 98                	cltq   
  8035c8:	48 c1 e0 03          	shl    $0x3,%rax
  8035cc:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8035d0:	b8 10 00 00 00       	mov    $0x10,%eax
  8035d5:	48 83 e8 01          	sub    $0x1,%rax
  8035d9:	48 01 d0             	add    %rdx,%rax
  8035dc:	bf 10 00 00 00       	mov    $0x10,%edi
  8035e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8035e6:	48 f7 f7             	div    %rdi
  8035e9:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8035ed:	48 29 c4             	sub    %rax,%rsp
  8035f0:	48 89 e0             	mov    %rsp,%rax
  8035f3:	48 83 c0 07          	add    $0x7,%rax
  8035f7:	48 c1 e8 03          	shr    $0x3,%rax
  8035fb:	48 c1 e0 03          	shl    $0x3,%rax
  8035ff:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803606:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80360d:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803614:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803617:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80361d:	8d 50 01             	lea    0x1(%rax),%edx
  803620:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803627:	48 63 d2             	movslq %edx,%rdx
  80362a:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803631:	00 

	va_start(vl, arg0);
  803632:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803639:	00 00 00 
  80363c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803643:	00 00 00 
  803646:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80364a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803651:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803658:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  80365f:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803666:	00 00 00 
  803669:	eb 63                	jmp    8036ce <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80366b:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803671:	8d 70 01             	lea    0x1(%rax),%esi
  803674:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80367a:	83 f8 30             	cmp    $0x30,%eax
  80367d:	73 23                	jae    8036a2 <spawnl+0x200>
  80367f:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803686:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80368c:	89 c0                	mov    %eax,%eax
  80368e:	48 01 d0             	add    %rdx,%rax
  803691:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803697:	83 c2 08             	add    $0x8,%edx
  80369a:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036a0:	eb 15                	jmp    8036b7 <spawnl+0x215>
  8036a2:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8036a9:	48 89 d0             	mov    %rdx,%rax
  8036ac:	48 83 c2 08          	add    $0x8,%rdx
  8036b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8036b7:	48 8b 08             	mov    (%rax),%rcx
  8036ba:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8036c1:	89 f2                	mov    %esi,%edx
  8036c3:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8036c7:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8036ce:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8036d4:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8036da:	77 8f                	ja     80366b <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8036dc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8036e3:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8036ea:	48 89 d6             	mov    %rdx,%rsi
  8036ed:	48 89 c7             	mov    %rax,%rdi
  8036f0:	48 b8 47 31 80 00 00 	movabs $0x803147,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
  8036fc:	48 89 dc             	mov    %rbx,%rsp
}
  8036ff:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803703:	5b                   	pop    %rbx
  803704:	41 5c                	pop    %r12
  803706:	41 5d                	pop    %r13
  803708:	5d                   	pop    %rbp
  803709:	c3                   	retq   

000000000080370a <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  80370a:	55                   	push   %rbp
  80370b:	48 89 e5             	mov    %rsp,%rbp
  80370e:	48 83 ec 50          	sub    $0x50,%rsp
  803712:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803715:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803719:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80371d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803724:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80372c:	eb 33                	jmp    803761 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80372e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803731:	48 98                	cltq   
  803733:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80373a:	00 
  80373b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80373f:	48 01 d0             	add    %rdx,%rax
  803742:	48 8b 00             	mov    (%rax),%rax
  803745:	48 89 c7             	mov    %rax,%rdi
  803748:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	83 c0 01             	add    $0x1,%eax
  803757:	48 98                	cltq   
  803759:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80375d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803761:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803764:	48 98                	cltq   
  803766:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80376d:	00 
  80376e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803772:	48 01 d0             	add    %rdx,%rax
  803775:	48 8b 00             	mov    (%rax),%rax
  803778:	48 85 c0             	test   %rax,%rax
  80377b:	75 b1                	jne    80372e <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80377d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803781:	48 f7 d8             	neg    %rax
  803784:	48 05 00 10 40 00    	add    $0x401000,%rax
  80378a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80378e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803792:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803796:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379a:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80379e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037a1:	83 c2 01             	add    $0x1,%edx
  8037a4:	c1 e2 03             	shl    $0x3,%edx
  8037a7:	48 63 d2             	movslq %edx,%rdx
  8037aa:	48 f7 da             	neg    %rdx
  8037ad:	48 01 d0             	add    %rdx,%rax
  8037b0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8037b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037b8:	48 83 e8 10          	sub    $0x10,%rax
  8037bc:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8037c2:	77 0a                	ja     8037ce <init_stack+0xc4>
		return -E_NO_MEM;
  8037c4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8037c9:	e9 e3 01 00 00       	jmpq   8039b1 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8037ce:	ba 07 00 00 00       	mov    $0x7,%edx
  8037d3:	be 00 00 40 00       	mov    $0x400000,%esi
  8037d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8037dd:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
  8037e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037f0:	79 08                	jns    8037fa <init_stack+0xf0>
		return r;
  8037f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f5:	e9 b7 01 00 00       	jmpq   8039b1 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8037fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803801:	e9 8a 00 00 00       	jmpq   803890 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803806:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803809:	48 98                	cltq   
  80380b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803812:	00 
  803813:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803817:	48 01 c2             	add    %rax,%rdx
  80381a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80381f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803823:	48 01 c8             	add    %rcx,%rax
  803826:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80382c:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80382f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803832:	48 98                	cltq   
  803834:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80383b:	00 
  80383c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803840:	48 01 d0             	add    %rdx,%rax
  803843:	48 8b 10             	mov    (%rax),%rdx
  803846:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80384a:	48 89 d6             	mov    %rdx,%rsi
  80384d:	48 89 c7             	mov    %rax,%rdi
  803850:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80385c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80385f:	48 98                	cltq   
  803861:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803868:	00 
  803869:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80386d:	48 01 d0             	add    %rdx,%rax
  803870:	48 8b 00             	mov    (%rax),%rax
  803873:	48 89 c7             	mov    %rax,%rdi
  803876:	48 b8 f6 14 80 00 00 	movabs $0x8014f6,%rax
  80387d:	00 00 00 
  803880:	ff d0                	callq  *%rax
  803882:	48 98                	cltq   
  803884:	48 83 c0 01          	add    $0x1,%rax
  803888:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80388c:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803890:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803893:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803896:	0f 8c 6a ff ff ff    	jl     803806 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80389c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80389f:	48 98                	cltq   
  8038a1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038a8:	00 
  8038a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038ad:	48 01 d0             	add    %rdx,%rax
  8038b0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8038b7:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8038be:	00 
  8038bf:	74 35                	je     8038f6 <init_stack+0x1ec>
  8038c1:	48 b9 c8 4c 80 00 00 	movabs $0x804cc8,%rcx
  8038c8:	00 00 00 
  8038cb:	48 ba ee 4c 80 00 00 	movabs $0x804cee,%rdx
  8038d2:	00 00 00 
  8038d5:	be f1 00 00 00       	mov    $0xf1,%esi
  8038da:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  8038e1:	00 00 00 
  8038e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e9:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  8038f0:	00 00 00 
  8038f3:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8038f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038fa:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8038fe:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803903:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803907:	48 01 c8             	add    %rcx,%rax
  80390a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803910:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803913:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803917:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80391b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80391e:	48 98                	cltq   
  803920:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  803923:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803928:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80392c:	48 01 d0             	add    %rdx,%rax
  80392f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803935:	48 89 c2             	mov    %rax,%rdx
  803938:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80393c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80393f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803942:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803948:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80394d:	89 c2                	mov    %eax,%edx
  80394f:	be 00 00 40 00       	mov    $0x400000,%esi
  803954:	bf 00 00 00 00       	mov    $0x0,%edi
  803959:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  803960:	00 00 00 
  803963:	ff d0                	callq  *%rax
  803965:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803968:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80396c:	79 02                	jns    803970 <init_stack+0x266>
		goto error;
  80396e:	eb 28                	jmp    803998 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803970:	be 00 00 40 00       	mov    $0x400000,%esi
  803975:	bf 00 00 00 00       	mov    $0x0,%edi
  80397a:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
  803986:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803989:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80398d:	79 02                	jns    803991 <init_stack+0x287>
		goto error;
  80398f:	eb 07                	jmp    803998 <init_stack+0x28e>

	return 0;
  803991:	b8 00 00 00 00       	mov    $0x0,%eax
  803996:	eb 19                	jmp    8039b1 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803998:	be 00 00 40 00       	mov    $0x400000,%esi
  80399d:	bf 00 00 00 00       	mov    $0x0,%edi
  8039a2:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
	return r;
  8039ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039b1:	c9                   	leaveq 
  8039b2:	c3                   	retq   

00000000008039b3 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8039b3:	55                   	push   %rbp
  8039b4:	48 89 e5             	mov    %rsp,%rbp
  8039b7:	48 83 ec 50          	sub    $0x50,%rsp
  8039bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8039c6:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8039c9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8039cd:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8039d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039d5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8039da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e1:	74 21                	je     803a04 <map_segment+0x51>
		va -= i;
  8039e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e6:	48 98                	cltq   
  8039e8:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8039ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ef:	48 98                	cltq   
  8039f1:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8039f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f8:	48 98                	cltq   
  8039fa:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8039fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a01:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a0b:	e9 79 01 00 00       	jmpq   803b89 <map_segment+0x1d6>
		if (i >= filesz) {
  803a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a13:	48 98                	cltq   
  803a15:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a19:	72 3c                	jb     803a57 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a1e:	48 63 d0             	movslq %eax,%rdx
  803a21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a25:	48 01 d0             	add    %rdx,%rax
  803a28:	48 89 c1             	mov    %rax,%rcx
  803a2b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a2e:	8b 55 10             	mov    0x10(%rbp),%edx
  803a31:	48 89 ce             	mov    %rcx,%rsi
  803a34:	89 c7                	mov    %eax,%edi
  803a36:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  803a3d:	00 00 00 
  803a40:	ff d0                	callq  *%rax
  803a42:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a45:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a49:	0f 89 33 01 00 00    	jns    803b82 <map_segment+0x1cf>
				return r;
  803a4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a52:	e9 46 01 00 00       	jmpq   803b9d <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a57:	ba 07 00 00 00       	mov    $0x7,%edx
  803a5c:	be 00 00 40 00       	mov    $0x400000,%esi
  803a61:	bf 00 00 00 00       	mov    $0x0,%edi
  803a66:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
  803a72:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a75:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a79:	79 08                	jns    803a83 <map_segment+0xd0>
				return r;
  803a7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a7e:	e9 1a 01 00 00       	jmpq   803b9d <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a86:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803a89:	01 c2                	add    %eax,%edx
  803a8b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a8e:	89 d6                	mov    %edx,%esi
  803a90:	89 c7                	mov    %eax,%edi
  803a92:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
  803a9e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803aa1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803aa5:	79 08                	jns    803aaf <map_segment+0xfc>
				return r;
  803aa7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aaa:	e9 ee 00 00 00       	jmpq   803b9d <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803aaf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab9:	48 98                	cltq   
  803abb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803abf:	48 29 c2             	sub    %rax,%rdx
  803ac2:	48 89 d0             	mov    %rdx,%rax
  803ac5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803ac9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803acc:	48 63 d0             	movslq %eax,%rdx
  803acf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ad3:	48 39 c2             	cmp    %rax,%rdx
  803ad6:	48 0f 47 d0          	cmova  %rax,%rdx
  803ada:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803add:	be 00 00 40 00       	mov    $0x400000,%esi
  803ae2:	89 c7                	mov    %eax,%edi
  803ae4:	48 b8 eb 26 80 00 00 	movabs $0x8026eb,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
  803af0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803af3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803af7:	79 08                	jns    803b01 <map_segment+0x14e>
				return r;
  803af9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803afc:	e9 9c 00 00 00       	jmpq   803b9d <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b04:	48 63 d0             	movslq %eax,%rdx
  803b07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b0b:	48 01 d0             	add    %rdx,%rax
  803b0e:	48 89 c2             	mov    %rax,%rdx
  803b11:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b14:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b18:	48 89 d1             	mov    %rdx,%rcx
  803b1b:	89 c2                	mov    %eax,%edx
  803b1d:	be 00 00 40 00       	mov    $0x400000,%esi
  803b22:	bf 00 00 00 00       	mov    $0x0,%edi
  803b27:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b36:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b3a:	79 30                	jns    803b6c <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803b3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b3f:	89 c1                	mov    %eax,%ecx
  803b41:	48 ba 03 4d 80 00 00 	movabs $0x804d03,%rdx
  803b48:	00 00 00 
  803b4b:	be 24 01 00 00       	mov    $0x124,%esi
  803b50:	48 bf 88 4c 80 00 00 	movabs $0x804c88,%rdi
  803b57:	00 00 00 
  803b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b5f:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  803b66:	00 00 00 
  803b69:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803b6c:	be 00 00 40 00       	mov    $0x400000,%esi
  803b71:	bf 00 00 00 00       	mov    $0x0,%edi
  803b76:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803b82:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8c:	48 98                	cltq   
  803b8e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b92:	0f 82 78 fe ff ff    	jb     803a10 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b9d:	c9                   	leaveq 
  803b9e:	c3                   	retq   

0000000000803b9f <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803b9f:	55                   	push   %rbp
  803ba0:	48 89 e5             	mov    %rsp,%rbp
  803ba3:	48 83 ec 04          	sub    $0x4,%rsp
  803ba7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  803baa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803baf:	c9                   	leaveq 
  803bb0:	c3                   	retq   

0000000000803bb1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803bb1:	55                   	push   %rbp
  803bb2:	48 89 e5             	mov    %rsp,%rbp
  803bb5:	53                   	push   %rbx
  803bb6:	48 83 ec 38          	sub    $0x38,%rsp
  803bba:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803bbe:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803bc2:	48 89 c7             	mov    %rax,%rdi
  803bc5:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
  803bd1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bd8:	0f 88 bf 01 00 00    	js     803d9d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be2:	ba 07 04 00 00       	mov    $0x407,%edx
  803be7:	48 89 c6             	mov    %rax,%rsi
  803bea:	bf 00 00 00 00       	mov    $0x0,%edi
  803bef:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
  803bfb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c02:	0f 88 95 01 00 00    	js     803d9d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c0c:	48 89 c7             	mov    %rax,%rdi
  803c0f:	48 b8 4c 21 80 00 00 	movabs $0x80214c,%rax
  803c16:	00 00 00 
  803c19:	ff d0                	callq  *%rax
  803c1b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c22:	0f 88 5d 01 00 00    	js     803d85 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c2c:	ba 07 04 00 00       	mov    $0x407,%edx
  803c31:	48 89 c6             	mov    %rax,%rsi
  803c34:	bf 00 00 00 00       	mov    $0x0,%edi
  803c39:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  803c40:	00 00 00 
  803c43:	ff d0                	callq  *%rax
  803c45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c4c:	0f 88 33 01 00 00    	js     803d85 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c56:	48 89 c7             	mov    %rax,%rdi
  803c59:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
  803c65:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c6d:	ba 07 04 00 00       	mov    $0x407,%edx
  803c72:	48 89 c6             	mov    %rax,%rsi
  803c75:	bf 00 00 00 00       	mov    $0x0,%edi
  803c7a:	48 b8 91 1e 80 00 00 	movabs $0x801e91,%rax
  803c81:	00 00 00 
  803c84:	ff d0                	callq  *%rax
  803c86:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c8d:	79 05                	jns    803c94 <pipe+0xe3>
		goto err2;
  803c8f:	e9 d9 00 00 00       	jmpq   803d6d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c98:	48 89 c7             	mov    %rax,%rdi
  803c9b:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  803ca2:	00 00 00 
  803ca5:	ff d0                	callq  *%rax
  803ca7:	48 89 c2             	mov    %rax,%rdx
  803caa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cae:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803cb4:	48 89 d1             	mov    %rdx,%rcx
  803cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  803cbc:	48 89 c6             	mov    %rax,%rsi
  803cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc4:	48 b8 e1 1e 80 00 00 	movabs $0x801ee1,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
  803cd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd7:	79 1b                	jns    803cf4 <pipe+0x143>
		goto err3;
  803cd9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803cda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cde:	48 89 c6             	mov    %rax,%rsi
  803ce1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ce6:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803ced:	00 00 00 
  803cf0:	ff d0                	callq  *%rax
  803cf2:	eb 79                	jmp    803d6d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803cf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cf8:	48 ba 20 78 80 00 00 	movabs $0x807820,%rdx
  803cff:	00 00 00 
  803d02:	8b 12                	mov    (%rdx),%edx
  803d04:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d15:	48 ba 20 78 80 00 00 	movabs $0x807820,%rdx
  803d1c:	00 00 00 
  803d1f:	8b 12                	mov    (%rdx),%edx
  803d21:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d32:	48 89 c7             	mov    %rax,%rdi
  803d35:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
  803d41:	89 c2                	mov    %eax,%edx
  803d43:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d47:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d4d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d55:	48 89 c7             	mov    %rax,%rdi
  803d58:	48 b8 fe 20 80 00 00 	movabs $0x8020fe,%rax
  803d5f:	00 00 00 
  803d62:	ff d0                	callq  *%rax
  803d64:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d66:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6b:	eb 33                	jmp    803da0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d71:	48 89 c6             	mov    %rax,%rsi
  803d74:	bf 00 00 00 00       	mov    $0x0,%edi
  803d79:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803d80:	00 00 00 
  803d83:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803d85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d89:	48 89 c6             	mov    %rax,%rsi
  803d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d91:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  803d98:	00 00 00 
  803d9b:	ff d0                	callq  *%rax
err:
	return r;
  803d9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803da0:	48 83 c4 38          	add    $0x38,%rsp
  803da4:	5b                   	pop    %rbx
  803da5:	5d                   	pop    %rbp
  803da6:	c3                   	retq   

0000000000803da7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803da7:	55                   	push   %rbp
  803da8:	48 89 e5             	mov    %rsp,%rbp
  803dab:	53                   	push   %rbx
  803dac:	48 83 ec 28          	sub    $0x28,%rsp
  803db0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803db4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803db8:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803dbf:	00 00 00 
  803dc2:	48 8b 00             	mov    (%rax),%rax
  803dc5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803dcb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803dce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd2:	48 89 c7             	mov    %rax,%rdi
  803dd5:	48 b8 f2 43 80 00 00 	movabs $0x8043f2,%rax
  803ddc:	00 00 00 
  803ddf:	ff d0                	callq  *%rax
  803de1:	89 c3                	mov    %eax,%ebx
  803de3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803de7:	48 89 c7             	mov    %rax,%rdi
  803dea:	48 b8 f2 43 80 00 00 	movabs $0x8043f2,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
  803df6:	39 c3                	cmp    %eax,%ebx
  803df8:	0f 94 c0             	sete   %al
  803dfb:	0f b6 c0             	movzbl %al,%eax
  803dfe:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e01:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803e08:	00 00 00 
  803e0b:	48 8b 00             	mov    (%rax),%rax
  803e0e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e14:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e1a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e1d:	75 05                	jne    803e24 <_pipeisclosed+0x7d>
			return ret;
  803e1f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e22:	eb 4f                	jmp    803e73 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803e24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e27:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e2a:	74 42                	je     803e6e <_pipeisclosed+0xc7>
  803e2c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e30:	75 3c                	jne    803e6e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e32:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803e39:	00 00 00 
  803e3c:	48 8b 00             	mov    (%rax),%rax
  803e3f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e45:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e4b:	89 c6                	mov    %eax,%esi
  803e4d:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  803e54:	00 00 00 
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5c:	49 b8 9a 09 80 00 00 	movabs $0x80099a,%r8
  803e63:	00 00 00 
  803e66:	41 ff d0             	callq  *%r8
	}
  803e69:	e9 4a ff ff ff       	jmpq   803db8 <_pipeisclosed+0x11>
  803e6e:	e9 45 ff ff ff       	jmpq   803db8 <_pipeisclosed+0x11>
}
  803e73:	48 83 c4 28          	add    $0x28,%rsp
  803e77:	5b                   	pop    %rbx
  803e78:	5d                   	pop    %rbp
  803e79:	c3                   	retq   

0000000000803e7a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803e7a:	55                   	push   %rbp
  803e7b:	48 89 e5             	mov    %rsp,%rbp
  803e7e:	48 83 ec 30          	sub    $0x30,%rsp
  803e82:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e85:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e8c:	48 89 d6             	mov    %rdx,%rsi
  803e8f:	89 c7                	mov    %eax,%edi
  803e91:	48 b8 e4 21 80 00 00 	movabs $0x8021e4,%rax
  803e98:	00 00 00 
  803e9b:	ff d0                	callq  *%rax
  803e9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ea0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea4:	79 05                	jns    803eab <pipeisclosed+0x31>
		return r;
  803ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea9:	eb 31                	jmp    803edc <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
  803ebe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803eca:	48 89 d6             	mov    %rdx,%rsi
  803ecd:	48 89 c7             	mov    %rax,%rdi
  803ed0:	48 b8 a7 3d 80 00 00 	movabs $0x803da7,%rax
  803ed7:	00 00 00 
  803eda:	ff d0                	callq  *%rax
}
  803edc:	c9                   	leaveq 
  803edd:	c3                   	retq   

0000000000803ede <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ede:	55                   	push   %rbp
  803edf:	48 89 e5             	mov    %rsp,%rbp
  803ee2:	48 83 ec 40          	sub    $0x40,%rsp
  803ee6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803eea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803eee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ef2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef6:	48 89 c7             	mov    %rax,%rdi
  803ef9:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  803f00:	00 00 00 
  803f03:	ff d0                	callq  *%rax
  803f05:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f11:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f18:	00 
  803f19:	e9 92 00 00 00       	jmpq   803fb0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f1e:	eb 41                	jmp    803f61 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f20:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f25:	74 09                	je     803f30 <devpipe_read+0x52>
				return i;
  803f27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f2b:	e9 92 00 00 00       	jmpq   803fc2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f38:	48 89 d6             	mov    %rdx,%rsi
  803f3b:	48 89 c7             	mov    %rax,%rdi
  803f3e:	48 b8 a7 3d 80 00 00 	movabs $0x803da7,%rax
  803f45:	00 00 00 
  803f48:	ff d0                	callq  *%rax
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	74 07                	je     803f55 <devpipe_read+0x77>
				return 0;
  803f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f53:	eb 6d                	jmp    803fc2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f55:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  803f5c:	00 00 00 
  803f5f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f65:	8b 10                	mov    (%rax),%edx
  803f67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f6b:	8b 40 04             	mov    0x4(%rax),%eax
  803f6e:	39 c2                	cmp    %eax,%edx
  803f70:	74 ae                	je     803f20 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f7a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f82:	8b 00                	mov    (%rax),%eax
  803f84:	99                   	cltd   
  803f85:	c1 ea 1b             	shr    $0x1b,%edx
  803f88:	01 d0                	add    %edx,%eax
  803f8a:	83 e0 1f             	and    $0x1f,%eax
  803f8d:	29 d0                	sub    %edx,%eax
  803f8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f93:	48 98                	cltq   
  803f95:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f9a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa0:	8b 00                	mov    (%rax),%eax
  803fa2:	8d 50 01             	lea    0x1(%rax),%edx
  803fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fb4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fb8:	0f 82 60 ff ff ff    	jb     803f1e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fc2:	c9                   	leaveq 
  803fc3:	c3                   	retq   

0000000000803fc4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803fc4:	55                   	push   %rbp
  803fc5:	48 89 e5             	mov    %rsp,%rbp
  803fc8:	48 83 ec 40          	sub    $0x40,%rsp
  803fcc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fd0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fd4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fdc:	48 89 c7             	mov    %rax,%rdi
  803fdf:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  803fe6:	00 00 00 
  803fe9:	ff d0                	callq  *%rax
  803feb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ff7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ffe:	00 
  803fff:	e9 8e 00 00 00       	jmpq   804092 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804004:	eb 31                	jmp    804037 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804006:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80400a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80400e:	48 89 d6             	mov    %rdx,%rsi
  804011:	48 89 c7             	mov    %rax,%rdi
  804014:	48 b8 a7 3d 80 00 00 	movabs $0x803da7,%rax
  80401b:	00 00 00 
  80401e:	ff d0                	callq  *%rax
  804020:	85 c0                	test   %eax,%eax
  804022:	74 07                	je     80402b <devpipe_write+0x67>
				return 0;
  804024:	b8 00 00 00 00       	mov    $0x0,%eax
  804029:	eb 79                	jmp    8040a4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80402b:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  804032:	00 00 00 
  804035:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403b:	8b 40 04             	mov    0x4(%rax),%eax
  80403e:	48 63 d0             	movslq %eax,%rdx
  804041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804045:	8b 00                	mov    (%rax),%eax
  804047:	48 98                	cltq   
  804049:	48 83 c0 20          	add    $0x20,%rax
  80404d:	48 39 c2             	cmp    %rax,%rdx
  804050:	73 b4                	jae    804006 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804056:	8b 40 04             	mov    0x4(%rax),%eax
  804059:	99                   	cltd   
  80405a:	c1 ea 1b             	shr    $0x1b,%edx
  80405d:	01 d0                	add    %edx,%eax
  80405f:	83 e0 1f             	and    $0x1f,%eax
  804062:	29 d0                	sub    %edx,%eax
  804064:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804068:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80406c:	48 01 ca             	add    %rcx,%rdx
  80406f:	0f b6 0a             	movzbl (%rdx),%ecx
  804072:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804076:	48 98                	cltq   
  804078:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80407c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804080:	8b 40 04             	mov    0x4(%rax),%eax
  804083:	8d 50 01             	lea    0x1(%rax),%edx
  804086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80408d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804096:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80409a:	0f 82 64 ff ff ff    	jb     804004 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8040a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040a4:	c9                   	leaveq 
  8040a5:	c3                   	retq   

00000000008040a6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040a6:	55                   	push   %rbp
  8040a7:	48 89 e5             	mov    %rsp,%rbp
  8040aa:	48 83 ec 20          	sub    $0x20,%rsp
  8040ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8040b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040ba:	48 89 c7             	mov    %rax,%rdi
  8040bd:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  8040c4:	00 00 00 
  8040c7:	ff d0                	callq  *%rax
  8040c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8040cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040d1:	48 be 38 4d 80 00 00 	movabs $0x804d38,%rsi
  8040d8:	00 00 00 
  8040db:	48 89 c7             	mov    %rax,%rdi
  8040de:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  8040e5:	00 00 00 
  8040e8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8040ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ee:	8b 50 04             	mov    0x4(%rax),%edx
  8040f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f5:	8b 00                	mov    (%rax),%eax
  8040f7:	29 c2                	sub    %eax,%edx
  8040f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040fd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804103:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804107:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80410e:	00 00 00 
	stat->st_dev = &devpipe;
  804111:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804115:	48 b9 20 78 80 00 00 	movabs $0x807820,%rcx
  80411c:	00 00 00 
  80411f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80412b:	c9                   	leaveq 
  80412c:	c3                   	retq   

000000000080412d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80412d:	55                   	push   %rbp
  80412e:	48 89 e5             	mov    %rsp,%rbp
  804131:	48 83 ec 10          	sub    $0x10,%rsp
  804135:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413d:	48 89 c6             	mov    %rax,%rsi
  804140:	bf 00 00 00 00       	mov    $0x0,%edi
  804145:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  80414c:	00 00 00 
  80414f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804155:	48 89 c7             	mov    %rax,%rdi
  804158:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  80415f:	00 00 00 
  804162:	ff d0                	callq  *%rax
  804164:	48 89 c6             	mov    %rax,%rsi
  804167:	bf 00 00 00 00       	mov    $0x0,%edi
  80416c:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
  804173:	00 00 00 
  804176:	ff d0                	callq  *%rax
}
  804178:	c9                   	leaveq 
  804179:	c3                   	retq   

000000000080417a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80417a:	55                   	push   %rbp
  80417b:	48 89 e5             	mov    %rsp,%rbp
  80417e:	48 83 ec 20          	sub    $0x20,%rsp
  804182:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804185:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804189:	75 35                	jne    8041c0 <wait+0x46>
  80418b:	48 b9 3f 4d 80 00 00 	movabs $0x804d3f,%rcx
  804192:	00 00 00 
  804195:	48 ba 4a 4d 80 00 00 	movabs $0x804d4a,%rdx
  80419c:	00 00 00 
  80419f:	be 09 00 00 00       	mov    $0x9,%esi
  8041a4:	48 bf 5f 4d 80 00 00 	movabs $0x804d5f,%rdi
  8041ab:	00 00 00 
  8041ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b3:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  8041ba:	00 00 00 
  8041bd:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8041c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8041c8:	48 63 d0             	movslq %eax,%rdx
  8041cb:	48 89 d0             	mov    %rdx,%rax
  8041ce:	48 c1 e0 03          	shl    $0x3,%rax
  8041d2:	48 01 d0             	add    %rdx,%rax
  8041d5:	48 c1 e0 05          	shl    $0x5,%rax
  8041d9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041e0:	00 00 00 
  8041e3:	48 01 d0             	add    %rdx,%rax
  8041e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8041ea:	eb 0c                	jmp    8041f8 <wait+0x7e>
		sys_yield();
  8041ec:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8041f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804202:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804205:	75 0e                	jne    804215 <wait+0x9b>
  804207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804211:	85 c0                	test   %eax,%eax
  804213:	75 d7                	jne    8041ec <wait+0x72>
		sys_yield();
}
  804215:	c9                   	leaveq 
  804216:	c3                   	retq   

0000000000804217 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804217:	55                   	push   %rbp
  804218:	48 89 e5             	mov    %rsp,%rbp
  80421b:	48 83 ec 30          	sub    $0x30,%rsp
  80421f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804223:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804227:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80422b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804230:	75 0e                	jne    804240 <ipc_recv+0x29>
        pg = (void *)UTOP;
  804232:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804239:	00 00 00 
  80423c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  804240:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804244:	48 89 c7             	mov    %rax,%rdi
  804247:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80424e:	00 00 00 
  804251:	ff d0                	callq  *%rax
  804253:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804256:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80425a:	79 27                	jns    804283 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80425c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804261:	74 0a                	je     80426d <ipc_recv+0x56>
            *from_env_store = 0;
  804263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804267:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80426d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804272:	74 0a                	je     80427e <ipc_recv+0x67>
            *perm_store = 0;
  804274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804278:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  80427e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804281:	eb 53                	jmp    8042d6 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  804283:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804288:	74 19                	je     8042a3 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80428a:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804291:	00 00 00 
  804294:	48 8b 00             	mov    (%rax),%rax
  804297:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80429d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042a1:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8042a3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042a8:	74 19                	je     8042c3 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8042aa:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8042b1:	00 00 00 
  8042b4:	48 8b 00             	mov    (%rax),%rax
  8042b7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042c1:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8042c3:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8042ca:	00 00 00 
  8042cd:	48 8b 00             	mov    (%rax),%rax
  8042d0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8042d6:	c9                   	leaveq 
  8042d7:	c3                   	retq   

00000000008042d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042d8:	55                   	push   %rbp
  8042d9:	48 89 e5             	mov    %rsp,%rbp
  8042dc:	48 83 ec 30          	sub    $0x30,%rsp
  8042e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042e3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042e6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8042ea:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8042ed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042f2:	75 0e                	jne    804302 <ipc_send+0x2a>
        pg = (void *)UTOP;
  8042f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8042fb:	00 00 00 
  8042fe:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  804302:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804305:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804308:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80430c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80430f:	89 c7                	mov    %eax,%edi
  804311:	48 b8 65 20 80 00 00 	movabs $0x802065,%rax
  804318:	00 00 00 
  80431b:	ff d0                	callq  *%rax
  80431d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  804320:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804324:	79 36                	jns    80435c <ipc_send+0x84>
  804326:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80432a:	74 30                	je     80435c <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80432c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432f:	89 c1                	mov    %eax,%ecx
  804331:	48 ba 6a 4d 80 00 00 	movabs $0x804d6a,%rdx
  804338:	00 00 00 
  80433b:	be 49 00 00 00       	mov    $0x49,%esi
  804340:	48 bf 77 4d 80 00 00 	movabs $0x804d77,%rdi
  804347:	00 00 00 
  80434a:	b8 00 00 00 00       	mov    $0x0,%eax
  80434f:	49 b8 61 07 80 00 00 	movabs $0x800761,%r8
  804356:	00 00 00 
  804359:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80435c:	48 b8 53 1e 80 00 00 	movabs $0x801e53,%rax
  804363:	00 00 00 
  804366:	ff d0                	callq  *%rax
    } while(r != 0);
  804368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80436c:	75 94                	jne    804302 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80436e:	c9                   	leaveq 
  80436f:	c3                   	retq   

0000000000804370 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804370:	55                   	push   %rbp
  804371:	48 89 e5             	mov    %rsp,%rbp
  804374:	48 83 ec 14          	sub    $0x14,%rsp
  804378:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80437b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804382:	eb 5e                	jmp    8043e2 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804384:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80438b:	00 00 00 
  80438e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804391:	48 63 d0             	movslq %eax,%rdx
  804394:	48 89 d0             	mov    %rdx,%rax
  804397:	48 c1 e0 03          	shl    $0x3,%rax
  80439b:	48 01 d0             	add    %rdx,%rax
  80439e:	48 c1 e0 05          	shl    $0x5,%rax
  8043a2:	48 01 c8             	add    %rcx,%rax
  8043a5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8043ab:	8b 00                	mov    (%rax),%eax
  8043ad:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043b0:	75 2c                	jne    8043de <ipc_find_env+0x6e>
			return envs[i].env_id;
  8043b2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8043b9:	00 00 00 
  8043bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043bf:	48 63 d0             	movslq %eax,%rdx
  8043c2:	48 89 d0             	mov    %rdx,%rax
  8043c5:	48 c1 e0 03          	shl    $0x3,%rax
  8043c9:	48 01 d0             	add    %rdx,%rax
  8043cc:	48 c1 e0 05          	shl    $0x5,%rax
  8043d0:	48 01 c8             	add    %rcx,%rax
  8043d3:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8043d9:	8b 40 08             	mov    0x8(%rax),%eax
  8043dc:	eb 12                	jmp    8043f0 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8043de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8043e2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8043e9:	7e 99                	jle    804384 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8043eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043f0:	c9                   	leaveq 
  8043f1:	c3                   	retq   

00000000008043f2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8043f2:	55                   	push   %rbp
  8043f3:	48 89 e5             	mov    %rsp,%rbp
  8043f6:	48 83 ec 18          	sub    $0x18,%rsp
  8043fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8043fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804402:	48 c1 e8 15          	shr    $0x15,%rax
  804406:	48 89 c2             	mov    %rax,%rdx
  804409:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804410:	01 00 00 
  804413:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804417:	83 e0 01             	and    $0x1,%eax
  80441a:	48 85 c0             	test   %rax,%rax
  80441d:	75 07                	jne    804426 <pageref+0x34>
		return 0;
  80441f:	b8 00 00 00 00       	mov    $0x0,%eax
  804424:	eb 53                	jmp    804479 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80442a:	48 c1 e8 0c          	shr    $0xc,%rax
  80442e:	48 89 c2             	mov    %rax,%rdx
  804431:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804438:	01 00 00 
  80443b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80443f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804447:	83 e0 01             	and    $0x1,%eax
  80444a:	48 85 c0             	test   %rax,%rax
  80444d:	75 07                	jne    804456 <pageref+0x64>
		return 0;
  80444f:	b8 00 00 00 00       	mov    $0x0,%eax
  804454:	eb 23                	jmp    804479 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80445a:	48 c1 e8 0c          	shr    $0xc,%rax
  80445e:	48 89 c2             	mov    %rax,%rdx
  804461:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804468:	00 00 00 
  80446b:	48 c1 e2 04          	shl    $0x4,%rdx
  80446f:	48 01 d0             	add    %rdx,%rax
  804472:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804476:	0f b7 c0             	movzwl %ax,%eax
}
  804479:	c9                   	leaveq 
  80447a:	c3                   	retq   
