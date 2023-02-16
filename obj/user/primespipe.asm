
obj/user/primespipe:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 5c 2a 80 00 00 	movabs $0x802a5c,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 00 41 80 00 00 	movabs $0x804100,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c8 04 80 00 00 	movabs $0x8004c8,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 41 41 80 00 00 	movabs $0x804141,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba 01 07 80 00 00 	movabs $0x800701,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 b8 34 80 00 00 	movabs $0x8034b8,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 45 41 80 00 00 	movabs $0x804145,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 4e 41 80 00 00 	movabs $0x80414e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 5c 2a 80 00 00 	movabs $0x802a5c,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba 57 41 80 00 00 	movabs $0x804157,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba c8 04 80 00 00 	movabs $0x8004c8,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 73 41 80 00 00 	movabs $0x804173,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba c8 04 80 00 00 	movabs $0x8004c8,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 8d 41 80 00 00 	movabs $0x80418d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 b8 34 80 00 00 	movabs $0x8034b8,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 45 41 80 00 00 	movabs $0x804145,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 be 21 80 00 00 	movabs $0x8021be,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 4e 41 80 00 00 	movabs $0x80414e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 98 41 80 00 00 	movabs $0x804198,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 c8 04 80 00 00 	movabs $0x8004c8,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 20          	sub    $0x20,%rsp
  80041c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80041f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800423:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800435:	25 ff 03 00 00       	and    $0x3ff,%eax
  80043a:	48 63 d0             	movslq %eax,%rdx
  80043d:	48 89 d0             	mov    %rdx,%rax
  800440:	48 c1 e0 03          	shl    $0x3,%rax
  800444:	48 01 d0             	add    %rdx,%rax
  800447:	48 c1 e0 05          	shl    $0x5,%rax
  80044b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800452:	00 00 00 
  800455:	48 01 c2             	add    %rax,%rdx
  800458:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80045f:	00 00 00 
  800462:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800465:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800469:	7e 14                	jle    80047f <libmain+0x6b>
		binaryname = argv[0];
  80046b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80046f:	48 8b 10             	mov    (%rax),%rdx
  800472:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800479:	00 00 00 
  80047c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80047f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800483:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800486:	48 89 d6             	mov    %rdx,%rsi
  800489:	89 c7                	mov    %eax,%edi
  80048b:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  800492:	00 00 00 
  800495:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800497:	48 b8 a5 04 80 00 00 	movabs $0x8004a5,%rax
  80049e:	00 00 00 
  8004a1:	ff d0                	callq  *%rax
}
  8004a3:	c9                   	leaveq 
  8004a4:	c3                   	retq   

00000000008004a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004a5:	55                   	push   %rbp
  8004a6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004a9:	48 b8 b0 27 80 00 00 	movabs $0x8027b0,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8004ba:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
}
  8004c6:	5d                   	pop    %rbp
  8004c7:	c3                   	retq   

00000000008004c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004c8:	55                   	push   %rbp
  8004c9:	48 89 e5             	mov    %rsp,%rbp
  8004cc:	53                   	push   %rbx
  8004cd:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004d4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004db:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004e1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004e8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004ef:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004f6:	84 c0                	test   %al,%al
  8004f8:	74 23                	je     80051d <_panic+0x55>
  8004fa:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800501:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800505:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800509:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80050d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800511:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800515:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800519:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80051d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800524:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80052b:	00 00 00 
  80052e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800535:	00 00 00 
  800538:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800543:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80054a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800551:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800558:	00 00 00 
  80055b:	48 8b 18             	mov    (%rax),%rbx
  80055e:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  800565:	00 00 00 
  800568:	ff d0                	callq  *%rax
  80056a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800570:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800577:	41 89 c8             	mov    %ecx,%r8d
  80057a:	48 89 d1             	mov    %rdx,%rcx
  80057d:	48 89 da             	mov    %rbx,%rdx
  800580:	89 c6                	mov    %eax,%esi
  800582:	48 bf c0 41 80 00 00 	movabs $0x8041c0,%rdi
  800589:	00 00 00 
  80058c:	b8 00 00 00 00       	mov    $0x0,%eax
  800591:	49 b9 01 07 80 00 00 	movabs $0x800701,%r9
  800598:	00 00 00 
  80059b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80059e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005a5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ac:	48 89 d6             	mov    %rdx,%rsi
  8005af:	48 89 c7             	mov    %rax,%rdi
  8005b2:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  8005b9:	00 00 00 
  8005bc:	ff d0                	callq  *%rax
	cprintf("\n");
  8005be:	48 bf e3 41 80 00 00 	movabs $0x8041e3,%rdi
  8005c5:	00 00 00 
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cd:	48 ba 01 07 80 00 00 	movabs $0x800701,%rdx
  8005d4:	00 00 00 
  8005d7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005d9:	cc                   	int3   
  8005da:	eb fd                	jmp    8005d9 <_panic+0x111>

00000000008005dc <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005dc:	55                   	push   %rbp
  8005dd:	48 89 e5             	mov    %rsp,%rbp
  8005e0:	48 83 ec 10          	sub    $0x10,%rsp
  8005e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	8d 48 01             	lea    0x1(%rax),%ecx
  8005f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f8:	89 0a                	mov    %ecx,(%rdx)
  8005fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005fd:	89 d1                	mov    %edx,%ecx
  8005ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800603:	48 98                	cltq   
  800605:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060d:	8b 00                	mov    (%rax),%eax
  80060f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800614:	75 2c                	jne    800642 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80061a:	8b 00                	mov    (%rax),%eax
  80061c:	48 98                	cltq   
  80061e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800622:	48 83 c2 08          	add    $0x8,%rdx
  800626:	48 89 c6             	mov    %rax,%rsi
  800629:	48 89 d7             	mov    %rdx,%rdi
  80062c:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  800633:	00 00 00 
  800636:	ff d0                	callq  *%rax
        b->idx = 0;
  800638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800646:	8b 40 04             	mov    0x4(%rax),%eax
  800649:	8d 50 01             	lea    0x1(%rax),%edx
  80064c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800650:	89 50 04             	mov    %edx,0x4(%rax)
}
  800653:	c9                   	leaveq 
  800654:	c3                   	retq   

0000000000800655 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800655:	55                   	push   %rbp
  800656:	48 89 e5             	mov    %rsp,%rbp
  800659:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800660:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800667:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80066e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800675:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80067c:	48 8b 0a             	mov    (%rdx),%rcx
  80067f:	48 89 08             	mov    %rcx,(%rax)
  800682:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800686:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80068a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80068e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800692:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800699:	00 00 00 
    b.cnt = 0;
  80069c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006a3:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006a6:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ad:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006b4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006bb:	48 89 c6             	mov    %rax,%rsi
  8006be:	48 bf dc 05 80 00 00 	movabs $0x8005dc,%rdi
  8006c5:	00 00 00 
  8006c8:	48 b8 b4 0a 80 00 00 	movabs $0x800ab4,%rax
  8006cf:	00 00 00 
  8006d2:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006d4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006da:	48 98                	cltq   
  8006dc:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006e3:	48 83 c2 08          	add    $0x8,%rdx
  8006e7:	48 89 c6             	mov    %rax,%rsi
  8006ea:	48 89 d7             	mov    %rdx,%rdi
  8006ed:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8006f4:	00 00 00 
  8006f7:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006ff:	c9                   	leaveq 
  800700:	c3                   	retq   

0000000000800701 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800701:	55                   	push   %rbp
  800702:	48 89 e5             	mov    %rsp,%rbp
  800705:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80070c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800713:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80071a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800721:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800728:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80072f:	84 c0                	test   %al,%al
  800731:	74 20                	je     800753 <cprintf+0x52>
  800733:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800737:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80073b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80073f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800743:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800747:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80074b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80074f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800753:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80075a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800761:	00 00 00 
  800764:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80076b:	00 00 00 
  80076e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800772:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800779:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800780:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800787:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80078e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800795:	48 8b 0a             	mov    (%rdx),%rcx
  800798:	48 89 08             	mov    %rcx,(%rax)
  80079b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80079f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007ab:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007b2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b9:	48 89 d6             	mov    %rdx,%rsi
  8007bc:	48 89 c7             	mov    %rax,%rdi
  8007bf:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  8007c6:	00 00 00 
  8007c9:	ff d0                	callq  *%rax
  8007cb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007d1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007d7:	c9                   	leaveq 
  8007d8:	c3                   	retq   

00000000008007d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d9:	55                   	push   %rbp
  8007da:	48 89 e5             	mov    %rsp,%rbp
  8007dd:	53                   	push   %rbx
  8007de:	48 83 ec 38          	sub    $0x38,%rsp
  8007e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007ee:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007f1:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007f5:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007fc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800800:	77 3b                	ja     80083d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800802:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800805:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800809:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80080c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800810:	ba 00 00 00 00       	mov    $0x0,%edx
  800815:	48 f7 f3             	div    %rbx
  800818:	48 89 c2             	mov    %rax,%rdx
  80081b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80081e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800821:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800829:	41 89 f9             	mov    %edi,%r9d
  80082c:	48 89 c7             	mov    %rax,%rdi
  80082f:	48 b8 d9 07 80 00 00 	movabs $0x8007d9,%rax
  800836:	00 00 00 
  800839:	ff d0                	callq  *%rax
  80083b:	eb 1e                	jmp    80085b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80083d:	eb 12                	jmp    800851 <printnum+0x78>
			putch(padc, putdat);
  80083f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800843:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 89 ce             	mov    %rcx,%rsi
  80084d:	89 d7                	mov    %edx,%edi
  80084f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800851:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800855:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800859:	7f e4                	jg     80083f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80085e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800862:	ba 00 00 00 00       	mov    $0x0,%edx
  800867:	48 f7 f1             	div    %rcx
  80086a:	48 89 d0             	mov    %rdx,%rax
  80086d:	48 ba f0 43 80 00 00 	movabs $0x8043f0,%rdx
  800874:	00 00 00 
  800877:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80087b:	0f be d0             	movsbl %al,%edx
  80087e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800886:	48 89 ce             	mov    %rcx,%rsi
  800889:	89 d7                	mov    %edx,%edi
  80088b:	ff d0                	callq  *%rax
}
  80088d:	48 83 c4 38          	add    $0x38,%rsp
  800891:	5b                   	pop    %rbx
  800892:	5d                   	pop    %rbp
  800893:	c3                   	retq   

0000000000800894 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800894:	55                   	push   %rbp
  800895:	48 89 e5             	mov    %rsp,%rbp
  800898:	48 83 ec 1c          	sub    $0x1c,%rsp
  80089c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008a0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8008a3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008a7:	7e 52                	jle    8008fb <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ad:	8b 00                	mov    (%rax),%eax
  8008af:	83 f8 30             	cmp    $0x30,%eax
  8008b2:	73 24                	jae    8008d8 <getuint+0x44>
  8008b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c0:	8b 00                	mov    (%rax),%eax
  8008c2:	89 c0                	mov    %eax,%eax
  8008c4:	48 01 d0             	add    %rdx,%rax
  8008c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cb:	8b 12                	mov    (%rdx),%edx
  8008cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d4:	89 0a                	mov    %ecx,(%rdx)
  8008d6:	eb 17                	jmp    8008ef <getuint+0x5b>
  8008d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e0:	48 89 d0             	mov    %rdx,%rax
  8008e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ef:	48 8b 00             	mov    (%rax),%rax
  8008f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f6:	e9 a3 00 00 00       	jmpq   80099e <getuint+0x10a>
	else if (lflag)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008ff:	74 4f                	je     800950 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	8b 00                	mov    (%rax),%eax
  800907:	83 f8 30             	cmp    $0x30,%eax
  80090a:	73 24                	jae    800930 <getuint+0x9c>
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800918:	8b 00                	mov    (%rax),%eax
  80091a:	89 c0                	mov    %eax,%eax
  80091c:	48 01 d0             	add    %rdx,%rax
  80091f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800923:	8b 12                	mov    (%rdx),%edx
  800925:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092c:	89 0a                	mov    %ecx,(%rdx)
  80092e:	eb 17                	jmp    800947 <getuint+0xb3>
  800930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800934:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800938:	48 89 d0             	mov    %rdx,%rax
  80093b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800943:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800947:	48 8b 00             	mov    (%rax),%rax
  80094a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094e:	eb 4e                	jmp    80099e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800954:	8b 00                	mov    (%rax),%eax
  800956:	83 f8 30             	cmp    $0x30,%eax
  800959:	73 24                	jae    80097f <getuint+0xeb>
  80095b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800967:	8b 00                	mov    (%rax),%eax
  800969:	89 c0                	mov    %eax,%eax
  80096b:	48 01 d0             	add    %rdx,%rax
  80096e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800972:	8b 12                	mov    (%rdx),%edx
  800974:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800977:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097b:	89 0a                	mov    %ecx,(%rdx)
  80097d:	eb 17                	jmp    800996 <getuint+0x102>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800987:	48 89 d0             	mov    %rdx,%rax
  80098a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800992:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800996:	8b 00                	mov    (%rax),%eax
  800998:	89 c0                	mov    %eax,%eax
  80099a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80099e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009a2:	c9                   	leaveq 
  8009a3:	c3                   	retq   

00000000008009a4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a4:	55                   	push   %rbp
  8009a5:	48 89 e5             	mov    %rsp,%rbp
  8009a8:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009b0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009b7:	7e 52                	jle    800a0b <getint+0x67>
		x=va_arg(*ap, long long);
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	8b 00                	mov    (%rax),%eax
  8009bf:	83 f8 30             	cmp    $0x30,%eax
  8009c2:	73 24                	jae    8009e8 <getint+0x44>
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d0:	8b 00                	mov    (%rax),%eax
  8009d2:	89 c0                	mov    %eax,%eax
  8009d4:	48 01 d0             	add    %rdx,%rax
  8009d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009db:	8b 12                	mov    (%rdx),%edx
  8009dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	89 0a                	mov    %ecx,(%rdx)
  8009e6:	eb 17                	jmp    8009ff <getint+0x5b>
  8009e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f0:	48 89 d0             	mov    %rdx,%rax
  8009f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ff:	48 8b 00             	mov    (%rax),%rax
  800a02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a06:	e9 a3 00 00 00       	jmpq   800aae <getint+0x10a>
	else if (lflag)
  800a0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a0f:	74 4f                	je     800a60 <getint+0xbc>
		x=va_arg(*ap, long);
  800a11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a15:	8b 00                	mov    (%rax),%eax
  800a17:	83 f8 30             	cmp    $0x30,%eax
  800a1a:	73 24                	jae    800a40 <getint+0x9c>
  800a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a20:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a28:	8b 00                	mov    (%rax),%eax
  800a2a:	89 c0                	mov    %eax,%eax
  800a2c:	48 01 d0             	add    %rdx,%rax
  800a2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a33:	8b 12                	mov    (%rdx),%edx
  800a35:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3c:	89 0a                	mov    %ecx,(%rdx)
  800a3e:	eb 17                	jmp    800a57 <getint+0xb3>
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a48:	48 89 d0             	mov    %rdx,%rax
  800a4b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a53:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a57:	48 8b 00             	mov    (%rax),%rax
  800a5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5e:	eb 4e                	jmp    800aae <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a64:	8b 00                	mov    (%rax),%eax
  800a66:	83 f8 30             	cmp    $0x30,%eax
  800a69:	73 24                	jae    800a8f <getint+0xeb>
  800a6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	89 c0                	mov    %eax,%eax
  800a7b:	48 01 d0             	add    %rdx,%rax
  800a7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a82:	8b 12                	mov    (%rdx),%edx
  800a84:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8b:	89 0a                	mov    %ecx,(%rdx)
  800a8d:	eb 17                	jmp    800aa6 <getint+0x102>
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a97:	48 89 d0             	mov    %rdx,%rax
  800a9a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa6:	8b 00                	mov    (%rax),%eax
  800aa8:	48 98                	cltq   
  800aaa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ab2:	c9                   	leaveq 
  800ab3:	c3                   	retq   

0000000000800ab4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ab4:	55                   	push   %rbp
  800ab5:	48 89 e5             	mov    %rsp,%rbp
  800ab8:	41 54                	push   %r12
  800aba:	53                   	push   %rbx
  800abb:	48 83 ec 60          	sub    $0x60,%rsp
  800abf:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ac3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ac7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800acb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800acf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ad3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ad7:	48 8b 0a             	mov    (%rdx),%rcx
  800ada:	48 89 08             	mov    %rcx,(%rax)
  800add:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ae1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ae5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ae9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aed:	eb 17                	jmp    800b06 <vprintfmt+0x52>
			if (ch == '\0')
  800aef:	85 db                	test   %ebx,%ebx
  800af1:	0f 84 df 04 00 00    	je     800fd6 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800af7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 d6             	mov    %rdx,%rsi
  800b02:	89 df                	mov    %ebx,%edi
  800b04:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b06:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b0a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b0e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b12:	0f b6 00             	movzbl (%rax),%eax
  800b15:	0f b6 d8             	movzbl %al,%ebx
  800b18:	83 fb 25             	cmp    $0x25,%ebx
  800b1b:	75 d2                	jne    800aef <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b1d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b21:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b28:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b36:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b45:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b49:	0f b6 00             	movzbl (%rax),%eax
  800b4c:	0f b6 d8             	movzbl %al,%ebx
  800b4f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b52:	83 f8 55             	cmp    $0x55,%eax
  800b55:	0f 87 47 04 00 00    	ja     800fa2 <vprintfmt+0x4ee>
  800b5b:	89 c0                	mov    %eax,%eax
  800b5d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b64:	00 
  800b65:	48 b8 18 44 80 00 00 	movabs $0x804418,%rax
  800b6c:	00 00 00 
  800b6f:	48 01 d0             	add    %rdx,%rax
  800b72:	48 8b 00             	mov    (%rax),%rax
  800b75:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b77:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b7b:	eb c0                	jmp    800b3d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b7d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b81:	eb ba                	jmp    800b3d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b83:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b8a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b8d:	89 d0                	mov    %edx,%eax
  800b8f:	c1 e0 02             	shl    $0x2,%eax
  800b92:	01 d0                	add    %edx,%eax
  800b94:	01 c0                	add    %eax,%eax
  800b96:	01 d8                	add    %ebx,%eax
  800b98:	83 e8 30             	sub    $0x30,%eax
  800b9b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba2:	0f b6 00             	movzbl (%rax),%eax
  800ba5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ba8:	83 fb 2f             	cmp    $0x2f,%ebx
  800bab:	7e 0c                	jle    800bb9 <vprintfmt+0x105>
  800bad:	83 fb 39             	cmp    $0x39,%ebx
  800bb0:	7f 07                	jg     800bb9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bb7:	eb d1                	jmp    800b8a <vprintfmt+0xd6>
			goto process_precision;
  800bb9:	eb 58                	jmp    800c13 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbe:	83 f8 30             	cmp    $0x30,%eax
  800bc1:	73 17                	jae    800bda <vprintfmt+0x126>
  800bc3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bca:	89 c0                	mov    %eax,%eax
  800bcc:	48 01 d0             	add    %rdx,%rax
  800bcf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd2:	83 c2 08             	add    $0x8,%edx
  800bd5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd8:	eb 0f                	jmp    800be9 <vprintfmt+0x135>
  800bda:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bde:	48 89 d0             	mov    %rdx,%rax
  800be1:	48 83 c2 08          	add    $0x8,%rdx
  800be5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be9:	8b 00                	mov    (%rax),%eax
  800beb:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bee:	eb 23                	jmp    800c13 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800bf0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf4:	79 0c                	jns    800c02 <vprintfmt+0x14e>
				width = 0;
  800bf6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bfd:	e9 3b ff ff ff       	jmpq   800b3d <vprintfmt+0x89>
  800c02:	e9 36 ff ff ff       	jmpq   800b3d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c07:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c0e:	e9 2a ff ff ff       	jmpq   800b3d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c13:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c17:	79 12                	jns    800c2b <vprintfmt+0x177>
				width = precision, precision = -1;
  800c19:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c1c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c1f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c26:	e9 12 ff ff ff       	jmpq   800b3d <vprintfmt+0x89>
  800c2b:	e9 0d ff ff ff       	jmpq   800b3d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c30:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c34:	e9 04 ff ff ff       	jmpq   800b3d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3c:	83 f8 30             	cmp    $0x30,%eax
  800c3f:	73 17                	jae    800c58 <vprintfmt+0x1a4>
  800c41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c48:	89 c0                	mov    %eax,%eax
  800c4a:	48 01 d0             	add    %rdx,%rax
  800c4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c50:	83 c2 08             	add    $0x8,%edx
  800c53:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c56:	eb 0f                	jmp    800c67 <vprintfmt+0x1b3>
  800c58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5c:	48 89 d0             	mov    %rdx,%rax
  800c5f:	48 83 c2 08          	add    $0x8,%rdx
  800c63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c67:	8b 10                	mov    (%rax),%edx
  800c69:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c71:	48 89 ce             	mov    %rcx,%rsi
  800c74:	89 d7                	mov    %edx,%edi
  800c76:	ff d0                	callq  *%rax
			break;
  800c78:	e9 53 03 00 00       	jmpq   800fd0 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c80:	83 f8 30             	cmp    $0x30,%eax
  800c83:	73 17                	jae    800c9c <vprintfmt+0x1e8>
  800c85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8c:	89 c0                	mov    %eax,%eax
  800c8e:	48 01 d0             	add    %rdx,%rax
  800c91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c94:	83 c2 08             	add    $0x8,%edx
  800c97:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9a:	eb 0f                	jmp    800cab <vprintfmt+0x1f7>
  800c9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca0:	48 89 d0             	mov    %rdx,%rax
  800ca3:	48 83 c2 08          	add    $0x8,%rdx
  800ca7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cab:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cad:	85 db                	test   %ebx,%ebx
  800caf:	79 02                	jns    800cb3 <vprintfmt+0x1ff>
				err = -err;
  800cb1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cb3:	83 fb 15             	cmp    $0x15,%ebx
  800cb6:	7f 16                	jg     800cce <vprintfmt+0x21a>
  800cb8:	48 b8 40 43 80 00 00 	movabs $0x804340,%rax
  800cbf:	00 00 00 
  800cc2:	48 63 d3             	movslq %ebx,%rdx
  800cc5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc9:	4d 85 e4             	test   %r12,%r12
  800ccc:	75 2e                	jne    800cfc <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800cce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd6:	89 d9                	mov    %ebx,%ecx
  800cd8:	48 ba 01 44 80 00 00 	movabs $0x804401,%rdx
  800cdf:	00 00 00 
  800ce2:	48 89 c7             	mov    %rax,%rdi
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cea:	49 b8 df 0f 80 00 00 	movabs $0x800fdf,%r8
  800cf1:	00 00 00 
  800cf4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf7:	e9 d4 02 00 00       	jmpq   800fd0 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cfc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	4c 89 e1             	mov    %r12,%rcx
  800d07:	48 ba 0a 44 80 00 00 	movabs $0x80440a,%rdx
  800d0e:	00 00 00 
  800d11:	48 89 c7             	mov    %rax,%rdi
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
  800d19:	49 b8 df 0f 80 00 00 	movabs $0x800fdf,%r8
  800d20:	00 00 00 
  800d23:	41 ff d0             	callq  *%r8
			break;
  800d26:	e9 a5 02 00 00       	jmpq   800fd0 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2e:	83 f8 30             	cmp    $0x30,%eax
  800d31:	73 17                	jae    800d4a <vprintfmt+0x296>
  800d33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3a:	89 c0                	mov    %eax,%eax
  800d3c:	48 01 d0             	add    %rdx,%rax
  800d3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d42:	83 c2 08             	add    $0x8,%edx
  800d45:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d48:	eb 0f                	jmp    800d59 <vprintfmt+0x2a5>
  800d4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4e:	48 89 d0             	mov    %rdx,%rax
  800d51:	48 83 c2 08          	add    $0x8,%rdx
  800d55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d59:	4c 8b 20             	mov    (%rax),%r12
  800d5c:	4d 85 e4             	test   %r12,%r12
  800d5f:	75 0a                	jne    800d6b <vprintfmt+0x2b7>
				p = "(null)";
  800d61:	49 bc 0d 44 80 00 00 	movabs $0x80440d,%r12
  800d68:	00 00 00 
			if (width > 0 && padc != '-')
  800d6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6f:	7e 3f                	jle    800db0 <vprintfmt+0x2fc>
  800d71:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d75:	74 39                	je     800db0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d77:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d7a:	48 98                	cltq   
  800d7c:	48 89 c6             	mov    %rax,%rsi
  800d7f:	4c 89 e7             	mov    %r12,%rdi
  800d82:	48 b8 8b 12 80 00 00 	movabs $0x80128b,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	callq  *%rax
  800d8e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d91:	eb 17                	jmp    800daa <vprintfmt+0x2f6>
					putch(padc, putdat);
  800d93:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d97:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9f:	48 89 ce             	mov    %rcx,%rsi
  800da2:	89 d7                	mov    %edx,%edi
  800da4:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800daa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dae:	7f e3                	jg     800d93 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db0:	eb 37                	jmp    800de9 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800db2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db6:	74 1e                	je     800dd6 <vprintfmt+0x322>
  800db8:	83 fb 1f             	cmp    $0x1f,%ebx
  800dbb:	7e 05                	jle    800dc2 <vprintfmt+0x30e>
  800dbd:	83 fb 7e             	cmp    $0x7e,%ebx
  800dc0:	7e 14                	jle    800dd6 <vprintfmt+0x322>
					putch('?', putdat);
  800dc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dca:	48 89 d6             	mov    %rdx,%rsi
  800dcd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dd2:	ff d0                	callq  *%rax
  800dd4:	eb 0f                	jmp    800de5 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800dd6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dde:	48 89 d6             	mov    %rdx,%rsi
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de9:	4c 89 e0             	mov    %r12,%rax
  800dec:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800df0:	0f b6 00             	movzbl (%rax),%eax
  800df3:	0f be d8             	movsbl %al,%ebx
  800df6:	85 db                	test   %ebx,%ebx
  800df8:	74 10                	je     800e0a <vprintfmt+0x356>
  800dfa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dfe:	78 b2                	js     800db2 <vprintfmt+0x2fe>
  800e00:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e08:	79 a8                	jns    800db2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0a:	eb 16                	jmp    800e22 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e14:	48 89 d6             	mov    %rdx,%rsi
  800e17:	bf 20 00 00 00       	mov    $0x20,%edi
  800e1c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e26:	7f e4                	jg     800e0c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e28:	e9 a3 01 00 00       	jmpq   800fd0 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e2d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e31:	be 03 00 00 00       	mov    $0x3,%esi
  800e36:	48 89 c7             	mov    %rax,%rdi
  800e39:	48 b8 a4 09 80 00 00 	movabs $0x8009a4,%rax
  800e40:	00 00 00 
  800e43:	ff d0                	callq  *%rax
  800e45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4d:	48 85 c0             	test   %rax,%rax
  800e50:	79 1d                	jns    800e6f <vprintfmt+0x3bb>
				putch('-', putdat);
  800e52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5a:	48 89 d6             	mov    %rdx,%rsi
  800e5d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e62:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e68:	48 f7 d8             	neg    %rax
  800e6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e6f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e76:	e9 e8 00 00 00       	jmpq   800f63 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e7b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7f:	be 03 00 00 00       	mov    $0x3,%esi
  800e84:	48 89 c7             	mov    %rax,%rdi
  800e87:	48 b8 94 08 80 00 00 	movabs $0x800894,%rax
  800e8e:	00 00 00 
  800e91:	ff d0                	callq  *%rax
  800e93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e97:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e9e:	e9 c0 00 00 00       	jmpq   800f63 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ea3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eab:	48 89 d6             	mov    %rdx,%rsi
  800eae:	bf 58 00 00 00       	mov    $0x58,%edi
  800eb3:	ff d0                	callq  *%rax
			putch('X', putdat);
  800eb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebd:	48 89 d6             	mov    %rdx,%rsi
  800ec0:	bf 58 00 00 00       	mov    $0x58,%edi
  800ec5:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ec7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ecb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecf:	48 89 d6             	mov    %rdx,%rsi
  800ed2:	bf 58 00 00 00       	mov    $0x58,%edi
  800ed7:	ff d0                	callq  *%rax
			break;
  800ed9:	e9 f2 00 00 00       	jmpq   800fd0 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ede:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee6:	48 89 d6             	mov    %rdx,%rsi
  800ee9:	bf 30 00 00 00       	mov    $0x30,%edi
  800eee:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ef0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef8:	48 89 d6             	mov    %rdx,%rsi
  800efb:	bf 78 00 00 00       	mov    $0x78,%edi
  800f00:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f05:	83 f8 30             	cmp    $0x30,%eax
  800f08:	73 17                	jae    800f21 <vprintfmt+0x46d>
  800f0a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f11:	89 c0                	mov    %eax,%eax
  800f13:	48 01 d0             	add    %rdx,%rax
  800f16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f19:	83 c2 08             	add    $0x8,%edx
  800f1c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f1f:	eb 0f                	jmp    800f30 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f21:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f25:	48 89 d0             	mov    %rdx,%rax
  800f28:	48 83 c2 08          	add    $0x8,%rdx
  800f2c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f30:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f37:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f3e:	eb 23                	jmp    800f63 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f44:	be 03 00 00 00       	mov    $0x3,%esi
  800f49:	48 89 c7             	mov    %rax,%rdi
  800f4c:	48 b8 94 08 80 00 00 	movabs $0x800894,%rax
  800f53:	00 00 00 
  800f56:	ff d0                	callq  *%rax
  800f58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f5c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f63:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f68:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f6b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f72:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f7a:	45 89 c1             	mov    %r8d,%r9d
  800f7d:	41 89 f8             	mov    %edi,%r8d
  800f80:	48 89 c7             	mov    %rax,%rdi
  800f83:	48 b8 d9 07 80 00 00 	movabs $0x8007d9,%rax
  800f8a:	00 00 00 
  800f8d:	ff d0                	callq  *%rax
			break;
  800f8f:	eb 3f                	jmp    800fd0 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f99:	48 89 d6             	mov    %rdx,%rsi
  800f9c:	89 df                	mov    %ebx,%edi
  800f9e:	ff d0                	callq  *%rax
			break;
  800fa0:	eb 2e                	jmp    800fd0 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800faa:	48 89 d6             	mov    %rdx,%rsi
  800fad:	bf 25 00 00 00       	mov    $0x25,%edi
  800fb2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fb9:	eb 05                	jmp    800fc0 <vprintfmt+0x50c>
  800fbb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fc0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc4:	48 83 e8 01          	sub    $0x1,%rax
  800fc8:	0f b6 00             	movzbl (%rax),%eax
  800fcb:	3c 25                	cmp    $0x25,%al
  800fcd:	75 ec                	jne    800fbb <vprintfmt+0x507>
				/* do nothing */;
			break;
  800fcf:	90                   	nop
		}
	}
  800fd0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fd1:	e9 30 fb ff ff       	jmpq   800b06 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800fd6:	48 83 c4 60          	add    $0x60,%rsp
  800fda:	5b                   	pop    %rbx
  800fdb:	41 5c                	pop    %r12
  800fdd:	5d                   	pop    %rbp
  800fde:	c3                   	retq   

0000000000800fdf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fea:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ff1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ff8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801006:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80100d:	84 c0                	test   %al,%al
  80100f:	74 20                	je     801031 <printfmt+0x52>
  801011:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801015:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801019:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80101d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801021:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801025:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801029:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80102d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801031:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801038:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80103f:	00 00 00 
  801042:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801049:	00 00 00 
  80104c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801050:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801057:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80105e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801065:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80106c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801073:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80107a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801081:	48 89 c7             	mov    %rax,%rdi
  801084:	48 b8 b4 0a 80 00 00 	movabs $0x800ab4,%rax
  80108b:	00 00 00 
  80108e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 10          	sub    $0x10,%rsp
  80109a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80109d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a5:	8b 40 10             	mov    0x10(%rax),%eax
  8010a8:	8d 50 01             	lea    0x1(%rax),%edx
  8010ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010af:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b6:	48 8b 10             	mov    (%rax),%rdx
  8010b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010bd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010c1:	48 39 c2             	cmp    %rax,%rdx
  8010c4:	73 17                	jae    8010dd <sprintputch+0x4b>
		*b->buf++ = ch;
  8010c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ca:	48 8b 00             	mov    (%rax),%rax
  8010cd:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010d5:	48 89 0a             	mov    %rcx,(%rdx)
  8010d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010db:	88 10                	mov    %dl,(%rax)
}
  8010dd:	c9                   	leaveq 
  8010de:	c3                   	retq   

00000000008010df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010df:	55                   	push   %rbp
  8010e0:	48 89 e5             	mov    %rsp,%rbp
  8010e3:	48 83 ec 50          	sub    $0x50,%rsp
  8010e7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010eb:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010ee:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010f2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010f6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010fa:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010fe:	48 8b 0a             	mov    (%rdx),%rcx
  801101:	48 89 08             	mov    %rcx,(%rax)
  801104:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801108:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80110c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801110:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801114:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801118:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80111c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80111f:	48 98                	cltq   
  801121:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801125:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801129:	48 01 d0             	add    %rdx,%rax
  80112c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801137:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80113c:	74 06                	je     801144 <vsnprintf+0x65>
  80113e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801142:	7f 07                	jg     80114b <vsnprintf+0x6c>
		return -E_INVAL;
  801144:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801149:	eb 2f                	jmp    80117a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80114b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80114f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801153:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801157:	48 89 c6             	mov    %rax,%rsi
  80115a:	48 bf 92 10 80 00 00 	movabs $0x801092,%rdi
  801161:	00 00 00 
  801164:	48 b8 b4 0a 80 00 00 	movabs $0x800ab4,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801170:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801174:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801177:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80117a:	c9                   	leaveq 
  80117b:	c3                   	retq   

000000000080117c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80117c:	55                   	push   %rbp
  80117d:	48 89 e5             	mov    %rsp,%rbp
  801180:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801187:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80118e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801194:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80119b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011a2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011a9:	84 c0                	test   %al,%al
  8011ab:	74 20                	je     8011cd <snprintf+0x51>
  8011ad:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011b1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011b5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011b9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011bd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011c1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011c5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011c9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011cd:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011d4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011db:	00 00 00 
  8011de:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011e5:	00 00 00 
  8011e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011ec:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011f3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011fa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801201:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801208:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80120f:	48 8b 0a             	mov    (%rdx),%rcx
  801212:	48 89 08             	mov    %rcx,(%rax)
  801215:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801219:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80121d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801221:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801225:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80122c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801233:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801239:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801240:	48 89 c7             	mov    %rax,%rdi
  801243:	48 b8 df 10 80 00 00 	movabs $0x8010df,%rax
  80124a:	00 00 00 
  80124d:	ff d0                	callq  *%rax
  80124f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801255:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80125b:	c9                   	leaveq 
  80125c:	c3                   	retq   

000000000080125d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80125d:	55                   	push   %rbp
  80125e:	48 89 e5             	mov    %rsp,%rbp
  801261:	48 83 ec 18          	sub    $0x18,%rsp
  801265:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801270:	eb 09                	jmp    80127b <strlen+0x1e>
		n++;
  801272:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801276:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80127b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	84 c0                	test   %al,%al
  801284:	75 ec                	jne    801272 <strlen+0x15>
		n++;
	return n;
  801286:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 20          	sub    $0x20,%rsp
  801293:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801297:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80129b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012a2:	eb 0e                	jmp    8012b2 <strnlen+0x27>
		n++;
  8012a4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012a8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012ad:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012b2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012b7:	74 0b                	je     8012c4 <strnlen+0x39>
  8012b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	84 c0                	test   %al,%al
  8012c2:	75 e0                	jne    8012a4 <strnlen+0x19>
		n++;
	return n;
  8012c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 20          	sub    $0x20,%rsp
  8012d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012e1:	90                   	nop
  8012e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012f6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012fa:	0f b6 12             	movzbl (%rdx),%edx
  8012fd:	88 10                	mov    %dl,(%rax)
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	84 c0                	test   %al,%al
  801304:	75 dc                	jne    8012e2 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	48 83 ec 20          	sub    $0x20,%rsp
  801314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801318:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80131c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801320:	48 89 c7             	mov    %rax,%rdi
  801323:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  80132a:	00 00 00 
  80132d:	ff d0                	callq  *%rax
  80132f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801335:	48 63 d0             	movslq %eax,%rdx
  801338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133c:	48 01 c2             	add    %rax,%rdx
  80133f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801343:	48 89 c6             	mov    %rax,%rsi
  801346:	48 89 d7             	mov    %rdx,%rdi
  801349:	48 b8 c9 12 80 00 00 	movabs $0x8012c9,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
	return dst;
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   

000000000080135b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80135b:	55                   	push   %rbp
  80135c:	48 89 e5             	mov    %rsp,%rbp
  80135f:	48 83 ec 28          	sub    $0x28,%rsp
  801363:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801367:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80136b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80136f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801373:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801377:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80137e:	00 
  80137f:	eb 2a                	jmp    8013ab <strncpy+0x50>
		*dst++ = *src;
  801381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801385:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801389:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80138d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801391:	0f b6 12             	movzbl (%rdx),%edx
  801394:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	84 c0                	test   %al,%al
  80139f:	74 05                	je     8013a6 <strncpy+0x4b>
			src++;
  8013a1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013af:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013b3:	72 cc                	jb     801381 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013b9:	c9                   	leaveq 
  8013ba:	c3                   	retq   

00000000008013bb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013bb:	55                   	push   %rbp
  8013bc:	48 89 e5             	mov    %rsp,%rbp
  8013bf:	48 83 ec 28          	sub    $0x28,%rsp
  8013c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013dc:	74 3d                	je     80141b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013de:	eb 1d                	jmp    8013fd <strlcpy+0x42>
			*dst++ = *src++;
  8013e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013f0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013f4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013f8:	0f b6 12             	movzbl (%rdx),%edx
  8013fb:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013fd:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801402:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801407:	74 0b                	je     801414 <strlcpy+0x59>
  801409:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140d:	0f b6 00             	movzbl (%rax),%eax
  801410:	84 c0                	test   %al,%al
  801412:	75 cc                	jne    8013e0 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801418:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80141b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80141f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801423:	48 29 c2             	sub    %rax,%rdx
  801426:	48 89 d0             	mov    %rdx,%rax
}
  801429:	c9                   	leaveq 
  80142a:	c3                   	retq   

000000000080142b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80142b:	55                   	push   %rbp
  80142c:	48 89 e5             	mov    %rsp,%rbp
  80142f:	48 83 ec 10          	sub    $0x10,%rsp
  801433:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801437:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80143b:	eb 0a                	jmp    801447 <strcmp+0x1c>
		p++, q++;
  80143d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801442:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801447:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144b:	0f b6 00             	movzbl (%rax),%eax
  80144e:	84 c0                	test   %al,%al
  801450:	74 12                	je     801464 <strcmp+0x39>
  801452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801456:	0f b6 10             	movzbl (%rax),%edx
  801459:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	38 c2                	cmp    %al,%dl
  801462:	74 d9                	je     80143d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	0f b6 d0             	movzbl %al,%edx
  80146e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	0f b6 c0             	movzbl %al,%eax
  801478:	29 c2                	sub    %eax,%edx
  80147a:	89 d0                	mov    %edx,%eax
}
  80147c:	c9                   	leaveq 
  80147d:	c3                   	retq   

000000000080147e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80147e:	55                   	push   %rbp
  80147f:	48 89 e5             	mov    %rsp,%rbp
  801482:	48 83 ec 18          	sub    $0x18,%rsp
  801486:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80148a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80148e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801492:	eb 0f                	jmp    8014a3 <strncmp+0x25>
		n--, p++, q++;
  801494:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801499:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014a8:	74 1d                	je     8014c7 <strncmp+0x49>
  8014aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	84 c0                	test   %al,%al
  8014b3:	74 12                	je     8014c7 <strncmp+0x49>
  8014b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b9:	0f b6 10             	movzbl (%rax),%edx
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	38 c2                	cmp    %al,%dl
  8014c5:	74 cd                	je     801494 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014cc:	75 07                	jne    8014d5 <strncmp+0x57>
		return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	eb 18                	jmp    8014ed <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d9:	0f b6 00             	movzbl (%rax),%eax
  8014dc:	0f b6 d0             	movzbl %al,%edx
  8014df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	c9                   	leaveq 
  8014ee:	c3                   	retq   

00000000008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %rbp
  8014f0:	48 89 e5             	mov    %rsp,%rbp
  8014f3:	48 83 ec 0c          	sub    $0xc,%rsp
  8014f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014fb:	89 f0                	mov    %esi,%eax
  8014fd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801500:	eb 17                	jmp    801519 <strchr+0x2a>
		if (*s == c)
  801502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80150c:	75 06                	jne    801514 <strchr+0x25>
			return (char *) s;
  80150e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801512:	eb 15                	jmp    801529 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801514:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151d:	0f b6 00             	movzbl (%rax),%eax
  801520:	84 c0                	test   %al,%al
  801522:	75 de                	jne    801502 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801529:	c9                   	leaveq 
  80152a:	c3                   	retq   

000000000080152b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	48 83 ec 0c          	sub    $0xc,%rsp
  801533:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801537:	89 f0                	mov    %esi,%eax
  801539:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80153c:	eb 13                	jmp    801551 <strfind+0x26>
		if (*s == c)
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	0f b6 00             	movzbl (%rax),%eax
  801545:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801548:	75 02                	jne    80154c <strfind+0x21>
			break;
  80154a:	eb 10                	jmp    80155c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80154c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	84 c0                	test   %al,%al
  80155a:	75 e2                	jne    80153e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801560:	c9                   	leaveq 
  801561:	c3                   	retq   

0000000000801562 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801562:	55                   	push   %rbp
  801563:	48 89 e5             	mov    %rsp,%rbp
  801566:	48 83 ec 18          	sub    $0x18,%rsp
  80156a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80156e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801571:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801575:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80157a:	75 06                	jne    801582 <memset+0x20>
		return v;
  80157c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801580:	eb 69                	jmp    8015eb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	83 e0 03             	and    $0x3,%eax
  801589:	48 85 c0             	test   %rax,%rax
  80158c:	75 48                	jne    8015d6 <memset+0x74>
  80158e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801592:	83 e0 03             	and    $0x3,%eax
  801595:	48 85 c0             	test   %rax,%rax
  801598:	75 3c                	jne    8015d6 <memset+0x74>
		c &= 0xFF;
  80159a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015a4:	c1 e0 18             	shl    $0x18,%eax
  8015a7:	89 c2                	mov    %eax,%edx
  8015a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ac:	c1 e0 10             	shl    $0x10,%eax
  8015af:	09 c2                	or     %eax,%edx
  8015b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b4:	c1 e0 08             	shl    $0x8,%eax
  8015b7:	09 d0                	or     %edx,%eax
  8015b9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8015bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c0:	48 c1 e8 02          	shr    $0x2,%rax
  8015c4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015c7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ce:	48 89 d7             	mov    %rdx,%rdi
  8015d1:	fc                   	cld    
  8015d2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015d4:	eb 11                	jmp    8015e7 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015e1:	48 89 d7             	mov    %rdx,%rdi
  8015e4:	fc                   	cld    
  8015e5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015eb:	c9                   	leaveq 
  8015ec:	c3                   	retq   

00000000008015ed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 83 ec 28          	sub    $0x28,%rsp
  8015f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801601:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801605:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801615:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801619:	0f 83 88 00 00 00    	jae    8016a7 <memmove+0xba>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801627:	48 01 d0             	add    %rdx,%rax
  80162a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80162e:	76 77                	jbe    8016a7 <memmove+0xba>
		s += n;
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801644:	83 e0 03             	and    $0x3,%eax
  801647:	48 85 c0             	test   %rax,%rax
  80164a:	75 3b                	jne    801687 <memmove+0x9a>
  80164c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801650:	83 e0 03             	and    $0x3,%eax
  801653:	48 85 c0             	test   %rax,%rax
  801656:	75 2f                	jne    801687 <memmove+0x9a>
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	83 e0 03             	and    $0x3,%eax
  80165f:	48 85 c0             	test   %rax,%rax
  801662:	75 23                	jne    801687 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801668:	48 83 e8 04          	sub    $0x4,%rax
  80166c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801670:	48 83 ea 04          	sub    $0x4,%rdx
  801674:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801678:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80167c:	48 89 c7             	mov    %rax,%rdi
  80167f:	48 89 d6             	mov    %rdx,%rsi
  801682:	fd                   	std    
  801683:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801685:	eb 1d                	jmp    8016a4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80168f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801693:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801697:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169b:	48 89 d7             	mov    %rdx,%rdi
  80169e:	48 89 c1             	mov    %rax,%rcx
  8016a1:	fd                   	std    
  8016a2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016a4:	fc                   	cld    
  8016a5:	eb 57                	jmp    8016fe <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ab:	83 e0 03             	and    $0x3,%eax
  8016ae:	48 85 c0             	test   %rax,%rax
  8016b1:	75 36                	jne    8016e9 <memmove+0xfc>
  8016b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b7:	83 e0 03             	and    $0x3,%eax
  8016ba:	48 85 c0             	test   %rax,%rax
  8016bd:	75 2a                	jne    8016e9 <memmove+0xfc>
  8016bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c3:	83 e0 03             	and    $0x3,%eax
  8016c6:	48 85 c0             	test   %rax,%rax
  8016c9:	75 1e                	jne    8016e9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	48 c1 e8 02          	shr    $0x2,%rax
  8016d3:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016de:	48 89 c7             	mov    %rax,%rdi
  8016e1:	48 89 d6             	mov    %rdx,%rsi
  8016e4:	fc                   	cld    
  8016e5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016e7:	eb 15                	jmp    8016fe <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016f5:	48 89 c7             	mov    %rax,%rdi
  8016f8:	48 89 d6             	mov    %rdx,%rsi
  8016fb:	fc                   	cld    
  8016fc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801702:	c9                   	leaveq 
  801703:	c3                   	retq   

0000000000801704 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801704:	55                   	push   %rbp
  801705:	48 89 e5             	mov    %rsp,%rbp
  801708:	48 83 ec 18          	sub    $0x18,%rsp
  80170c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801710:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801714:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80171c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801724:	48 89 ce             	mov    %rcx,%rsi
  801727:	48 89 c7             	mov    %rax,%rdi
  80172a:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  801731:	00 00 00 
  801734:	ff d0                	callq  *%rax
}
  801736:	c9                   	leaveq 
  801737:	c3                   	retq   

0000000000801738 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801738:	55                   	push   %rbp
  801739:	48 89 e5             	mov    %rsp,%rbp
  80173c:	48 83 ec 28          	sub    $0x28,%rsp
  801740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801744:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801748:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80174c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801750:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801754:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801758:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80175c:	eb 36                	jmp    801794 <memcmp+0x5c>
		if (*s1 != *s2)
  80175e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801762:	0f b6 10             	movzbl (%rax),%edx
  801765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801769:	0f b6 00             	movzbl (%rax),%eax
  80176c:	38 c2                	cmp    %al,%dl
  80176e:	74 1a                	je     80178a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801774:	0f b6 00             	movzbl (%rax),%eax
  801777:	0f b6 d0             	movzbl %al,%edx
  80177a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	0f b6 c0             	movzbl %al,%eax
  801784:	29 c2                	sub    %eax,%edx
  801786:	89 d0                	mov    %edx,%eax
  801788:	eb 20                	jmp    8017aa <memcmp+0x72>
		s1++, s2++;
  80178a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80178f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80179c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017a0:	48 85 c0             	test   %rax,%rax
  8017a3:	75 b9                	jne    80175e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leaveq 
  8017ab:	c3                   	retq   

00000000008017ac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017ac:	55                   	push   %rbp
  8017ad:	48 89 e5             	mov    %rsp,%rbp
  8017b0:	48 83 ec 28          	sub    $0x28,%rsp
  8017b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017b8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c7:	48 01 d0             	add    %rdx,%rax
  8017ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017ce:	eb 15                	jmp    8017e5 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d4:	0f b6 10             	movzbl (%rax),%edx
  8017d7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017da:	38 c2                	cmp    %al,%dl
  8017dc:	75 02                	jne    8017e0 <memfind+0x34>
			break;
  8017de:	eb 0f                	jmp    8017ef <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017e0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e9:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017ed:	72 e1                	jb     8017d0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8017ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017f3:	c9                   	leaveq 
  8017f4:	c3                   	retq   

00000000008017f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017f5:	55                   	push   %rbp
  8017f6:	48 89 e5             	mov    %rsp,%rbp
  8017f9:	48 83 ec 34          	sub    $0x34,%rsp
  8017fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801801:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801805:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801808:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80180f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801816:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801817:	eb 05                	jmp    80181e <strtol+0x29>
		s++;
  801819:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80181e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801822:	0f b6 00             	movzbl (%rax),%eax
  801825:	3c 20                	cmp    $0x20,%al
  801827:	74 f0                	je     801819 <strtol+0x24>
  801829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182d:	0f b6 00             	movzbl (%rax),%eax
  801830:	3c 09                	cmp    $0x9,%al
  801832:	74 e5                	je     801819 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	0f b6 00             	movzbl (%rax),%eax
  80183b:	3c 2b                	cmp    $0x2b,%al
  80183d:	75 07                	jne    801846 <strtol+0x51>
		s++;
  80183f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801844:	eb 17                	jmp    80185d <strtol+0x68>
	else if (*s == '-')
  801846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184a:	0f b6 00             	movzbl (%rax),%eax
  80184d:	3c 2d                	cmp    $0x2d,%al
  80184f:	75 0c                	jne    80185d <strtol+0x68>
		s++, neg = 1;
  801851:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801856:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80185d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801861:	74 06                	je     801869 <strtol+0x74>
  801863:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801867:	75 28                	jne    801891 <strtol+0x9c>
  801869:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186d:	0f b6 00             	movzbl (%rax),%eax
  801870:	3c 30                	cmp    $0x30,%al
  801872:	75 1d                	jne    801891 <strtol+0x9c>
  801874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801878:	48 83 c0 01          	add    $0x1,%rax
  80187c:	0f b6 00             	movzbl (%rax),%eax
  80187f:	3c 78                	cmp    $0x78,%al
  801881:	75 0e                	jne    801891 <strtol+0x9c>
		s += 2, base = 16;
  801883:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801888:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80188f:	eb 2c                	jmp    8018bd <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801891:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801895:	75 19                	jne    8018b0 <strtol+0xbb>
  801897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189b:	0f b6 00             	movzbl (%rax),%eax
  80189e:	3c 30                	cmp    $0x30,%al
  8018a0:	75 0e                	jne    8018b0 <strtol+0xbb>
		s++, base = 8;
  8018a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018ae:	eb 0d                	jmp    8018bd <strtol+0xc8>
	else if (base == 0)
  8018b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018b4:	75 07                	jne    8018bd <strtol+0xc8>
		base = 10;
  8018b6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c1:	0f b6 00             	movzbl (%rax),%eax
  8018c4:	3c 2f                	cmp    $0x2f,%al
  8018c6:	7e 1d                	jle    8018e5 <strtol+0xf0>
  8018c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cc:	0f b6 00             	movzbl (%rax),%eax
  8018cf:	3c 39                	cmp    $0x39,%al
  8018d1:	7f 12                	jg     8018e5 <strtol+0xf0>
			dig = *s - '0';
  8018d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d7:	0f b6 00             	movzbl (%rax),%eax
  8018da:	0f be c0             	movsbl %al,%eax
  8018dd:	83 e8 30             	sub    $0x30,%eax
  8018e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018e3:	eb 4e                	jmp    801933 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	0f b6 00             	movzbl (%rax),%eax
  8018ec:	3c 60                	cmp    $0x60,%al
  8018ee:	7e 1d                	jle    80190d <strtol+0x118>
  8018f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f4:	0f b6 00             	movzbl (%rax),%eax
  8018f7:	3c 7a                	cmp    $0x7a,%al
  8018f9:	7f 12                	jg     80190d <strtol+0x118>
			dig = *s - 'a' + 10;
  8018fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	0f be c0             	movsbl %al,%eax
  801905:	83 e8 57             	sub    $0x57,%eax
  801908:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80190b:	eb 26                	jmp    801933 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	0f b6 00             	movzbl (%rax),%eax
  801914:	3c 40                	cmp    $0x40,%al
  801916:	7e 48                	jle    801960 <strtol+0x16b>
  801918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	3c 5a                	cmp    $0x5a,%al
  801921:	7f 3d                	jg     801960 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801927:	0f b6 00             	movzbl (%rax),%eax
  80192a:	0f be c0             	movsbl %al,%eax
  80192d:	83 e8 37             	sub    $0x37,%eax
  801930:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801933:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801936:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801939:	7c 02                	jl     80193d <strtol+0x148>
			break;
  80193b:	eb 23                	jmp    801960 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80193d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801942:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801945:	48 98                	cltq   
  801947:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80194c:	48 89 c2             	mov    %rax,%rdx
  80194f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801952:	48 98                	cltq   
  801954:	48 01 d0             	add    %rdx,%rax
  801957:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80195b:	e9 5d ff ff ff       	jmpq   8018bd <strtol+0xc8>

	if (endptr)
  801960:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801965:	74 0b                	je     801972 <strtol+0x17d>
		*endptr = (char *) s;
  801967:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80196b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80196f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801976:	74 09                	je     801981 <strtol+0x18c>
  801978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80197c:	48 f7 d8             	neg    %rax
  80197f:	eb 04                	jmp    801985 <strtol+0x190>
  801981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801985:	c9                   	leaveq 
  801986:	c3                   	retq   

0000000000801987 <strstr>:

char * strstr(const char *in, const char *str)
{
  801987:	55                   	push   %rbp
  801988:	48 89 e5             	mov    %rsp,%rbp
  80198b:	48 83 ec 30          	sub    $0x30,%rsp
  80198f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801993:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801997:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80199b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80199f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019a3:	0f b6 00             	movzbl (%rax),%eax
  8019a6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8019a9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019ad:	75 06                	jne    8019b5 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8019af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b3:	eb 6b                	jmp    801a20 <strstr+0x99>

	len = strlen(str);
  8019b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b9:	48 89 c7             	mov    %rax,%rdi
  8019bc:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  8019c3:	00 00 00 
  8019c6:	ff d0                	callq  *%rax
  8019c8:	48 98                	cltq   
  8019ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8019ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019da:	0f b6 00             	movzbl (%rax),%eax
  8019dd:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019e0:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019e4:	75 07                	jne    8019ed <strstr+0x66>
				return (char *) 0;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019eb:	eb 33                	jmp    801a20 <strstr+0x99>
		} while (sc != c);
  8019ed:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019f1:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019f4:	75 d8                	jne    8019ce <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a02:	48 89 ce             	mov    %rcx,%rsi
  801a05:	48 89 c7             	mov    %rax,%rdi
  801a08:	48 b8 7e 14 80 00 00 	movabs $0x80147e,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
  801a14:	85 c0                	test   %eax,%eax
  801a16:	75 b6                	jne    8019ce <strstr+0x47>

	return (char *) (in - 1);
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	48 83 e8 01          	sub    $0x1,%rax
}
  801a20:	c9                   	leaveq 
  801a21:	c3                   	retq   

0000000000801a22 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a22:	55                   	push   %rbp
  801a23:	48 89 e5             	mov    %rsp,%rbp
  801a26:	53                   	push   %rbx
  801a27:	48 83 ec 48          	sub    $0x48,%rsp
  801a2b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a2e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a31:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a35:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a39:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a3d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a41:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a44:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a48:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a4c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a50:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a54:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a58:	4c 89 c3             	mov    %r8,%rbx
  801a5b:	cd 30                	int    $0x30
  801a5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a65:	74 3e                	je     801aa5 <syscall+0x83>
  801a67:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a6c:	7e 37                	jle    801aa5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a75:	49 89 d0             	mov    %rdx,%r8
  801a78:	89 c1                	mov    %eax,%ecx
  801a7a:	48 ba c8 46 80 00 00 	movabs $0x8046c8,%rdx
  801a81:	00 00 00 
  801a84:	be 23 00 00 00       	mov    $0x23,%esi
  801a89:	48 bf e5 46 80 00 00 	movabs $0x8046e5,%rdi
  801a90:	00 00 00 
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
  801a98:	49 b9 c8 04 80 00 00 	movabs $0x8004c8,%r9
  801a9f:	00 00 00 
  801aa2:	41 ff d1             	callq  *%r9

	return ret;
  801aa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801aa9:	48 83 c4 48          	add    $0x48,%rsp
  801aad:	5b                   	pop    %rbx
  801aae:	5d                   	pop    %rbp
  801aaf:	c3                   	retq   

0000000000801ab0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ab0:	55                   	push   %rbp
  801ab1:	48 89 e5             	mov    %rsp,%rbp
  801ab4:	48 83 ec 20          	sub    $0x20,%rsp
  801ab8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801abc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acf:	00 
  801ad0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adc:	48 89 d1             	mov    %rdx,%rcx
  801adf:	48 89 c2             	mov    %rax,%rdx
  801ae2:	be 00 00 00 00       	mov    $0x0,%esi
  801ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  801aec:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <sys_cgetc>:

int
sys_cgetc(void)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b09:	00 
  801b0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b16:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b20:	be 00 00 00 00       	mov    $0x0,%esi
  801b25:	bf 01 00 00 00       	mov    $0x1,%edi
  801b2a:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 10          	sub    $0x10,%rsp
  801b40:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b46:	48 98                	cltq   
  801b48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4f:	00 
  801b50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b61:	48 89 c2             	mov    %rax,%rdx
  801b64:	be 01 00 00 00       	mov    $0x1,%esi
  801b69:	bf 03 00 00 00       	mov    $0x3,%edi
  801b6e:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801b75:	00 00 00 
  801b78:	ff d0                	callq  *%rax
}
  801b7a:	c9                   	leaveq 
  801b7b:	c3                   	retq   

0000000000801b7c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b7c:	55                   	push   %rbp
  801b7d:	48 89 e5             	mov    %rsp,%rbp
  801b80:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8b:	00 
  801b8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba2:	be 00 00 00 00       	mov    $0x0,%esi
  801ba7:	bf 02 00 00 00       	mov    $0x2,%edi
  801bac:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801bb3:	00 00 00 
  801bb6:	ff d0                	callq  *%rax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <sys_yield>:

void
sys_yield(void)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801bc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc9:	00 
  801bca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801be0:	be 00 00 00 00       	mov    $0x0,%esi
  801be5:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bea:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801bf1:	00 00 00 
  801bf4:	ff d0                	callq  *%rax
}
  801bf6:	c9                   	leaveq 
  801bf7:	c3                   	retq   

0000000000801bf8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bf8:	55                   	push   %rbp
  801bf9:	48 89 e5             	mov    %rsp,%rbp
  801bfc:	48 83 ec 20          	sub    $0x20,%rsp
  801c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c07:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c0d:	48 63 c8             	movslq %eax,%rcx
  801c10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c17:	48 98                	cltq   
  801c19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c20:	00 
  801c21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c27:	49 89 c8             	mov    %rcx,%r8
  801c2a:	48 89 d1             	mov    %rdx,%rcx
  801c2d:	48 89 c2             	mov    %rax,%rdx
  801c30:	be 01 00 00 00       	mov    $0x1,%esi
  801c35:	bf 04 00 00 00       	mov    $0x4,%edi
  801c3a:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
}
  801c46:	c9                   	leaveq 
  801c47:	c3                   	retq   

0000000000801c48 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	48 83 ec 30          	sub    $0x30,%rsp
  801c50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c57:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c5a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c5e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c62:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c65:	48 63 c8             	movslq %eax,%rcx
  801c68:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c6f:	48 63 f0             	movslq %eax,%rsi
  801c72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c79:	48 98                	cltq   
  801c7b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c7f:	49 89 f9             	mov    %rdi,%r9
  801c82:	49 89 f0             	mov    %rsi,%r8
  801c85:	48 89 d1             	mov    %rdx,%rcx
  801c88:	48 89 c2             	mov    %rax,%rdx
  801c8b:	be 01 00 00 00       	mov    $0x1,%esi
  801c90:	bf 05 00 00 00       	mov    $0x5,%edi
  801c95:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
}
  801ca1:	c9                   	leaveq 
  801ca2:	c3                   	retq   

0000000000801ca3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ca3:	55                   	push   %rbp
  801ca4:	48 89 e5             	mov    %rsp,%rbp
  801ca7:	48 83 ec 20          	sub    $0x20,%rsp
  801cab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb9:	48 98                	cltq   
  801cbb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc2:	00 
  801cc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ccf:	48 89 d1             	mov    %rdx,%rcx
  801cd2:	48 89 c2             	mov    %rax,%rdx
  801cd5:	be 01 00 00 00       	mov    $0x1,%esi
  801cda:	bf 06 00 00 00       	mov    $0x6,%edi
  801cdf:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
}
  801ceb:	c9                   	leaveq 
  801cec:	c3                   	retq   

0000000000801ced <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ced:	55                   	push   %rbp
  801cee:	48 89 e5             	mov    %rsp,%rbp
  801cf1:	48 83 ec 10          	sub    $0x10,%rsp
  801cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801cfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cfe:	48 63 d0             	movslq %eax,%rdx
  801d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d04:	48 98                	cltq   
  801d06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0d:	00 
  801d0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1a:	48 89 d1             	mov    %rdx,%rcx
  801d1d:	48 89 c2             	mov    %rax,%rdx
  801d20:	be 01 00 00 00       	mov    $0x1,%esi
  801d25:	bf 08 00 00 00       	mov    $0x8,%edi
  801d2a:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801d31:	00 00 00 
  801d34:	ff d0                	callq  *%rax
}
  801d36:	c9                   	leaveq 
  801d37:	c3                   	retq   

0000000000801d38 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d38:	55                   	push   %rbp
  801d39:	48 89 e5             	mov    %rsp,%rbp
  801d3c:	48 83 ec 20          	sub    $0x20,%rsp
  801d40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4e:	48 98                	cltq   
  801d50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d57:	00 
  801d58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d64:	48 89 d1             	mov    %rdx,%rcx
  801d67:	48 89 c2             	mov    %rax,%rdx
  801d6a:	be 01 00 00 00       	mov    $0x1,%esi
  801d6f:	bf 09 00 00 00       	mov    $0x9,%edi
  801d74:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	callq  *%rax
}
  801d80:	c9                   	leaveq 
  801d81:	c3                   	retq   

0000000000801d82 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d82:	55                   	push   %rbp
  801d83:	48 89 e5             	mov    %rsp,%rbp
  801d86:	48 83 ec 20          	sub    $0x20,%rsp
  801d8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d98:	48 98                	cltq   
  801d9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801da1:	00 
  801da2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dae:	48 89 d1             	mov    %rdx,%rcx
  801db1:	48 89 c2             	mov    %rax,%rdx
  801db4:	be 01 00 00 00       	mov    $0x1,%esi
  801db9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801dbe:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801dc5:	00 00 00 
  801dc8:	ff d0                	callq  *%rax
}
  801dca:	c9                   	leaveq 
  801dcb:	c3                   	retq   

0000000000801dcc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801dcc:	55                   	push   %rbp
  801dcd:	48 89 e5             	mov    %rsp,%rbp
  801dd0:	48 83 ec 20          	sub    $0x20,%rsp
  801dd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ddb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ddf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801de2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801de5:	48 63 f0             	movslq %eax,%rsi
  801de8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801def:	48 98                	cltq   
  801df1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfc:	00 
  801dfd:	49 89 f1             	mov    %rsi,%r9
  801e00:	49 89 c8             	mov    %rcx,%r8
  801e03:	48 89 d1             	mov    %rdx,%rcx
  801e06:	48 89 c2             	mov    %rax,%rdx
  801e09:	be 00 00 00 00       	mov    $0x0,%esi
  801e0e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e13:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	callq  *%rax
}
  801e1f:	c9                   	leaveq 
  801e20:	c3                   	retq   

0000000000801e21 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e21:	55                   	push   %rbp
  801e22:	48 89 e5             	mov    %rsp,%rbp
  801e25:	48 83 ec 10          	sub    $0x10,%rsp
  801e29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e38:	00 
  801e39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e45:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e4a:	48 89 c2             	mov    %rax,%rdx
  801e4d:	be 01 00 00 00       	mov    $0x1,%esi
  801e52:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e57:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  801e5e:	00 00 00 
  801e61:	ff d0                	callq  *%rax
}
  801e63:	c9                   	leaveq 
  801e64:	c3                   	retq   

0000000000801e65 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e65:	55                   	push   %rbp
  801e66:	48 89 e5             	mov    %rsp,%rbp
  801e69:	48 83 ec 30          	sub    $0x30,%rsp
  801e6d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e75:	48 8b 00             	mov    (%rax),%rax
  801e78:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e80:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e84:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801e87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e8a:	83 e0 02             	and    $0x2,%eax
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	75 4d                	jne    801ede <pgfault+0x79>
  801e91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e95:	48 c1 e8 0c          	shr    $0xc,%rax
  801e99:	48 89 c2             	mov    %rax,%rdx
  801e9c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea3:	01 00 00 
  801ea6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eaa:	25 00 08 00 00       	and    $0x800,%eax
  801eaf:	48 85 c0             	test   %rax,%rax
  801eb2:	74 2a                	je     801ede <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801eb4:	48 ba f8 46 80 00 00 	movabs $0x8046f8,%rdx
  801ebb:	00 00 00 
  801ebe:	be 1e 00 00 00       	mov    $0x1e,%esi
  801ec3:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  801eca:	00 00 00 
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed2:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  801ed9:	00 00 00 
  801edc:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  801ede:	ba 07 00 00 00       	mov    $0x7,%edx
  801ee3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  801eed:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	0f 85 cd 00 00 00    	jne    801fce <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801f01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f13:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801f17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f1b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f20:	48 89 c6             	mov    %rax,%rsi
  801f23:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f28:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  801f2f:	00 00 00 
  801f32:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801f34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f38:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f3e:	48 89 c1             	mov    %rax,%rcx
  801f41:	ba 00 00 00 00       	mov    $0x0,%edx
  801f46:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f50:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  801f57:	00 00 00 
  801f5a:	ff d0                	callq  *%rax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	79 2a                	jns    801f8a <pgfault+0x125>
				panic("Page map at temp address failed");
  801f60:	48 ba 28 47 80 00 00 	movabs $0x804728,%rdx
  801f67:	00 00 00 
  801f6a:	be 2f 00 00 00       	mov    $0x2f,%esi
  801f6f:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  801f76:	00 00 00 
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7e:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  801f85:	00 00 00 
  801f88:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801f8a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f94:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  801f9b:	00 00 00 
  801f9e:	ff d0                	callq  *%rax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	79 54                	jns    801ff8 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801fa4:	48 ba 48 47 80 00 00 	movabs $0x804748,%rdx
  801fab:	00 00 00 
  801fae:	be 31 00 00 00       	mov    $0x31,%esi
  801fb3:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  801fba:	00 00 00 
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  801fc9:	00 00 00 
  801fcc:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  801fce:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  801fd5:	00 00 00 
  801fd8:	be 35 00 00 00       	mov    $0x35,%esi
  801fdd:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  801fe4:	00 00 00 
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  801ff3:	00 00 00 
  801ff6:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  801ff8:	c9                   	leaveq 
  801ff9:	c3                   	retq   

0000000000801ffa <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ffa:	55                   	push   %rbp
  801ffb:	48 89 e5             	mov    %rsp,%rbp
  801ffe:	48 83 ec 20          	sub    $0x20,%rsp
  802002:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802005:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  802008:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80200f:	01 00 00 
  802012:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802015:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802019:	25 07 0e 00 00       	and    $0xe07,%eax
  80201e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802021:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802024:	48 c1 e0 0c          	shl    $0xc,%rax
  802028:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  80202c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202f:	25 00 04 00 00       	and    $0x400,%eax
  802034:	85 c0                	test   %eax,%eax
  802036:	74 57                	je     80208f <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  802038:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80203b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80203f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802046:	41 89 f0             	mov    %esi,%r8d
  802049:	48 89 c6             	mov    %rax,%rsi
  80204c:	bf 00 00 00 00       	mov    $0x0,%edi
  802051:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	0f 8e 52 01 00 00    	jle    8021b7 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  802065:	48 ba 9d 47 80 00 00 	movabs $0x80479d,%rdx
  80206c:	00 00 00 
  80206f:	be 52 00 00 00       	mov    $0x52,%esi
  802074:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  80207b:	00 00 00 
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  80208a:	00 00 00 
  80208d:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  80208f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802092:	83 e0 02             	and    $0x2,%eax
  802095:	85 c0                	test   %eax,%eax
  802097:	75 10                	jne    8020a9 <duppage+0xaf>
  802099:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209c:	25 00 08 00 00       	and    $0x800,%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	0f 84 bb 00 00 00    	je     802164 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  8020a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ac:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8020b1:	80 cc 08             	or     $0x8,%ah
  8020b4:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020b7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ba:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c5:	41 89 f0             	mov    %esi,%r8d
  8020c8:	48 89 c6             	mov    %rax,%rsi
  8020cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d0:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8020d7:	00 00 00 
  8020da:	ff d0                	callq  *%rax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	7e 2a                	jle    80210a <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  8020e0:	48 ba 9d 47 80 00 00 	movabs $0x80479d,%rdx
  8020e7:	00 00 00 
  8020ea:	be 5a 00 00 00       	mov    $0x5a,%esi
  8020ef:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  8020f6:	00 00 00 
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  802105:	00 00 00 
  802108:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  80210a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80210d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802111:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802115:	41 89 c8             	mov    %ecx,%r8d
  802118:	48 89 d1             	mov    %rdx,%rcx
  80211b:	ba 00 00 00 00       	mov    $0x0,%edx
  802120:	48 89 c6             	mov    %rax,%rsi
  802123:	bf 00 00 00 00       	mov    $0x0,%edi
  802128:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  80212f:	00 00 00 
  802132:	ff d0                	callq  *%rax
  802134:	85 c0                	test   %eax,%eax
  802136:	7e 2a                	jle    802162 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  802138:	48 ba 9d 47 80 00 00 	movabs $0x80479d,%rdx
  80213f:	00 00 00 
  802142:	be 5d 00 00 00       	mov    $0x5d,%esi
  802147:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  80214e:	00 00 00 
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  80215d:	00 00 00 
  802160:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802162:	eb 53                	jmp    8021b7 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  802164:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802167:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80216b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80216e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802172:	41 89 f0             	mov    %esi,%r8d
  802175:	48 89 c6             	mov    %rax,%rsi
  802178:	bf 00 00 00 00       	mov    $0x0,%edi
  80217d:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
  802189:	85 c0                	test   %eax,%eax
  80218b:	7e 2a                	jle    8021b7 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  80218d:	48 ba 9d 47 80 00 00 	movabs $0x80479d,%rdx
  802194:	00 00 00 
  802197:	be 61 00 00 00       	mov    $0x61,%esi
  80219c:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  8021a3:	00 00 00 
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  8021b2:	00 00 00 
  8021b5:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bc:	c9                   	leaveq 
  8021bd:	c3                   	retq   

00000000008021be <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  8021c6:	48 bf 65 1e 80 00 00 	movabs $0x801e65,%rdi
  8021cd:	00 00 00 
  8021d0:	48 b8 34 3d 80 00 00 	movabs $0x803d34,%rax
  8021d7:	00 00 00 
  8021da:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8021e1:	cd 30                	int    $0x30
  8021e3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021e6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8021e9:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  8021ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021f0:	79 30                	jns    802222 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8021f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021f5:	89 c1                	mov    %eax,%ecx
  8021f7:	48 ba bb 47 80 00 00 	movabs $0x8047bb,%rdx
  8021fe:	00 00 00 
  802201:	be 89 00 00 00       	mov    $0x89,%esi
  802206:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  80220d:	00 00 00 
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
  802215:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  80221c:	00 00 00 
  80221f:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  802222:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802226:	75 46                	jne    80226e <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  802228:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  80222f:	00 00 00 
  802232:	ff d0                	callq  *%rax
  802234:	25 ff 03 00 00       	and    $0x3ff,%eax
  802239:	48 63 d0             	movslq %eax,%rdx
  80223c:	48 89 d0             	mov    %rdx,%rax
  80223f:	48 c1 e0 03          	shl    $0x3,%rax
  802243:	48 01 d0             	add    %rdx,%rax
  802246:	48 c1 e0 05          	shl    $0x5,%rax
  80224a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802251:	00 00 00 
  802254:	48 01 c2             	add    %rax,%rdx
  802257:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80225e:	00 00 00 
  802261:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
  802269:	e9 d1 01 00 00       	jmpq   80243f <fork+0x281>
	}

	uint64_t ad = 0;
  80226e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802275:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802276:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80227b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80227f:	e9 df 00 00 00       	jmpq   802363 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802288:	48 c1 e8 27          	shr    $0x27,%rax
  80228c:	48 89 c2             	mov    %rax,%rdx
  80228f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802296:	01 00 00 
  802299:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229d:	83 e0 01             	and    $0x1,%eax
  8022a0:	48 85 c0             	test   %rax,%rax
  8022a3:	0f 84 9e 00 00 00    	je     802347 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8022a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ad:	48 c1 e8 1e          	shr    $0x1e,%rax
  8022b1:	48 89 c2             	mov    %rax,%rdx
  8022b4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022bb:	01 00 00 
  8022be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c2:	83 e0 01             	and    $0x1,%eax
  8022c5:	48 85 c0             	test   %rax,%rax
  8022c8:	74 73                	je     80233d <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8022ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ce:	48 c1 e8 15          	shr    $0x15,%rax
  8022d2:	48 89 c2             	mov    %rax,%rdx
  8022d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022dc:	01 00 00 
  8022df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e3:	83 e0 01             	and    $0x1,%eax
  8022e6:	48 85 c0             	test   %rax,%rax
  8022e9:	74 48                	je     802333 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8022eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f3:	48 89 c2             	mov    %rax,%rdx
  8022f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022fd:	01 00 00 
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230c:	83 e0 01             	and    $0x1,%eax
  80230f:	48 85 c0             	test   %rax,%rax
  802312:	74 47                	je     80235b <fork+0x19d>
						duppage(envid, VPN(addr));
  802314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802318:	48 c1 e8 0c          	shr    $0xc,%rax
  80231c:	89 c2                	mov    %eax,%edx
  80231e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802321:	89 d6                	mov    %edx,%esi
  802323:	89 c7                	mov    %eax,%edi
  802325:	48 b8 fa 1f 80 00 00 	movabs $0x801ffa,%rax
  80232c:	00 00 00 
  80232f:	ff d0                	callq  *%rax
  802331:	eb 28                	jmp    80235b <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  802333:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80233a:	00 
  80233b:	eb 1e                	jmp    80235b <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80233d:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802344:	40 
  802345:	eb 14                	jmp    80235b <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234b:	48 c1 e8 27          	shr    $0x27,%rax
  80234f:	48 83 c0 01          	add    $0x1,%rax
  802353:	48 c1 e0 27          	shl    $0x27,%rax
  802357:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  80235b:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802362:	00 
  802363:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80236a:	00 
  80236b:	0f 87 13 ff ff ff    	ja     802284 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802371:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802374:	ba 07 00 00 00       	mov    $0x7,%edx
  802379:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80237e:	89 c7                	mov    %eax,%edi
  802380:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80238c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80238f:	ba 07 00 00 00       	mov    $0x7,%edx
  802394:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802399:	89 c7                	mov    %eax,%edi
  80239b:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  8023a2:	00 00 00 
  8023a5:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8023a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023aa:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8023b0:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8023b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ba:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8023cd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023d2:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023d7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023dc:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8023e3:	00 00 00 
  8023e6:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8023e8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f2:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8023fe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802405:	00 00 00 
  802408:	48 8b 00             	mov    (%rax),%rax
  80240b:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802412:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802415:	48 89 d6             	mov    %rdx,%rsi
  802418:	89 c7                	mov    %eax,%edi
  80241a:	48 b8 82 1d 80 00 00 	movabs $0x801d82,%rax
  802421:	00 00 00 
  802424:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802426:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802429:	be 02 00 00 00       	mov    $0x2,%esi
  80242e:	89 c7                	mov    %eax,%edi
  802430:	48 b8 ed 1c 80 00 00 	movabs $0x801ced,%rax
  802437:	00 00 00 
  80243a:	ff d0                	callq  *%rax

	return envid;
  80243c:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80243f:	c9                   	leaveq 
  802440:	c3                   	retq   

0000000000802441 <sfork>:

// Challenge!
int
sfork(void)
{
  802441:	55                   	push   %rbp
  802442:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802445:	48 ba d3 47 80 00 00 	movabs $0x8047d3,%rdx
  80244c:	00 00 00 
  80244f:	be b8 00 00 00       	mov    $0xb8,%esi
  802454:	48 bf 1d 47 80 00 00 	movabs $0x80471d,%rdi
  80245b:	00 00 00 
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
  802463:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  80246a:	00 00 00 
  80246d:	ff d1                	callq  *%rcx

000000000080246f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80246f:	55                   	push   %rbp
  802470:	48 89 e5             	mov    %rsp,%rbp
  802473:	48 83 ec 08          	sub    $0x8,%rsp
  802477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80247b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802486:	ff ff ff 
  802489:	48 01 d0             	add    %rdx,%rax
  80248c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 08          	sub    $0x8,%rsp
  80249a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80249e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a2:	48 89 c7             	mov    %rax,%rdi
  8024a5:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024b7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024bb:	c9                   	leaveq 
  8024bc:	c3                   	retq   

00000000008024bd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024bd:	55                   	push   %rbp
  8024be:	48 89 e5             	mov    %rsp,%rbp
  8024c1:	48 83 ec 18          	sub    $0x18,%rsp
  8024c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024d0:	eb 6b                	jmp    80253d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d5:	48 98                	cltq   
  8024d7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8024e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e9:	48 c1 e8 15          	shr    $0x15,%rax
  8024ed:	48 89 c2             	mov    %rax,%rdx
  8024f0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f7:	01 00 00 
  8024fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fe:	83 e0 01             	and    $0x1,%eax
  802501:	48 85 c0             	test   %rax,%rax
  802504:	74 21                	je     802527 <fd_alloc+0x6a>
  802506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250a:	48 c1 e8 0c          	shr    $0xc,%rax
  80250e:	48 89 c2             	mov    %rax,%rdx
  802511:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802518:	01 00 00 
  80251b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251f:	83 e0 01             	and    $0x1,%eax
  802522:	48 85 c0             	test   %rax,%rax
  802525:	75 12                	jne    802539 <fd_alloc+0x7c>
			*fd_store = fd;
  802527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80252f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	eb 1a                	jmp    802553 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802539:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80253d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802541:	7e 8f                	jle    8024d2 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802547:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80254e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802553:	c9                   	leaveq 
  802554:	c3                   	retq   

0000000000802555 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802555:	55                   	push   %rbp
  802556:	48 89 e5             	mov    %rsp,%rbp
  802559:	48 83 ec 20          	sub    $0x20,%rsp
  80255d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802560:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802564:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802568:	78 06                	js     802570 <fd_lookup+0x1b>
  80256a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80256e:	7e 07                	jle    802577 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802570:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802575:	eb 6c                	jmp    8025e3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802577:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80257a:	48 98                	cltq   
  80257c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802582:	48 c1 e0 0c          	shl    $0xc,%rax
  802586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80258a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258e:	48 c1 e8 15          	shr    $0x15,%rax
  802592:	48 89 c2             	mov    %rax,%rdx
  802595:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80259c:	01 00 00 
  80259f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a3:	83 e0 01             	and    $0x1,%eax
  8025a6:	48 85 c0             	test   %rax,%rax
  8025a9:	74 21                	je     8025cc <fd_lookup+0x77>
  8025ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025af:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b3:	48 89 c2             	mov    %rax,%rdx
  8025b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025bd:	01 00 00 
  8025c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c4:	83 e0 01             	and    $0x1,%eax
  8025c7:	48 85 c0             	test   %rax,%rax
  8025ca:	75 07                	jne    8025d3 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025d1:	eb 10                	jmp    8025e3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025db:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e3:	c9                   	leaveq 
  8025e4:	c3                   	retq   

00000000008025e5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025e5:	55                   	push   %rbp
  8025e6:	48 89 e5             	mov    %rsp,%rbp
  8025e9:	48 83 ec 30          	sub    $0x30,%rsp
  8025ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025f1:	89 f0                	mov    %esi,%eax
  8025f3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025fa:	48 89 c7             	mov    %rax,%rdi
  8025fd:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  802604:	00 00 00 
  802607:	ff d0                	callq  *%rax
  802609:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80260d:	48 89 d6             	mov    %rdx,%rsi
  802610:	89 c7                	mov    %eax,%edi
  802612:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802625:	78 0a                	js     802631 <fd_close+0x4c>
	    || fd != fd2)
  802627:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80262f:	74 12                	je     802643 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802631:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802635:	74 05                	je     80263c <fd_close+0x57>
  802637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263a:	eb 05                	jmp    802641 <fd_close+0x5c>
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
  802641:	eb 69                	jmp    8026ac <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802647:	8b 00                	mov    (%rax),%eax
  802649:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80264d:	48 89 d6             	mov    %rdx,%rsi
  802650:	89 c7                	mov    %eax,%edi
  802652:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  802659:	00 00 00 
  80265c:	ff d0                	callq  *%rax
  80265e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802661:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802665:	78 2a                	js     802691 <fd_close+0xac>
		if (dev->dev_close)
  802667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80266f:	48 85 c0             	test   %rax,%rax
  802672:	74 16                	je     80268a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802678:	48 8b 40 20          	mov    0x20(%rax),%rax
  80267c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802680:	48 89 d7             	mov    %rdx,%rdi
  802683:	ff d0                	callq  *%rax
  802685:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802688:	eb 07                	jmp    802691 <fd_close+0xac>
		else
			r = 0;
  80268a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802695:	48 89 c6             	mov    %rax,%rsi
  802698:	bf 00 00 00 00       	mov    $0x0,%edi
  80269d:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
	return r;
  8026a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026ac:	c9                   	leaveq 
  8026ad:	c3                   	retq   

00000000008026ae <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026ae:	55                   	push   %rbp
  8026af:	48 89 e5             	mov    %rsp,%rbp
  8026b2:	48 83 ec 20          	sub    $0x20,%rsp
  8026b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026c4:	eb 41                	jmp    802707 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026c6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026cd:	00 00 00 
  8026d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026d3:	48 63 d2             	movslq %edx,%rdx
  8026d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026da:	8b 00                	mov    (%rax),%eax
  8026dc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026df:	75 22                	jne    802703 <dev_lookup+0x55>
			*dev = devtab[i];
  8026e1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026e8:	00 00 00 
  8026eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ee:	48 63 d2             	movslq %edx,%rdx
  8026f1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	eb 60                	jmp    802763 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802703:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802707:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80270e:	00 00 00 
  802711:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802714:	48 63 d2             	movslq %edx,%rdx
  802717:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80271b:	48 85 c0             	test   %rax,%rax
  80271e:	75 a6                	jne    8026c6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802720:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802727:	00 00 00 
  80272a:	48 8b 00             	mov    (%rax),%rax
  80272d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802733:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802736:	89 c6                	mov    %eax,%esi
  802738:	48 bf f0 47 80 00 00 	movabs $0x8047f0,%rdi
  80273f:	00 00 00 
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
  802747:	48 b9 01 07 80 00 00 	movabs $0x800701,%rcx
  80274e:	00 00 00 
  802751:	ff d1                	callq  *%rcx
	*dev = 0;
  802753:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802757:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80275e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802763:	c9                   	leaveq 
  802764:	c3                   	retq   

0000000000802765 <close>:

int
close(int fdnum)
{
  802765:	55                   	push   %rbp
  802766:	48 89 e5             	mov    %rsp,%rbp
  802769:	48 83 ec 20          	sub    $0x20,%rsp
  80276d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802770:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802774:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802777:	48 89 d6             	mov    %rdx,%rsi
  80277a:	89 c7                	mov    %eax,%edi
  80277c:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  802783:	00 00 00 
  802786:	ff d0                	callq  *%rax
  802788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278f:	79 05                	jns    802796 <close+0x31>
		return r;
  802791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802794:	eb 18                	jmp    8027ae <close+0x49>
	else
		return fd_close(fd, 1);
  802796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279a:	be 01 00 00 00       	mov    $0x1,%esi
  80279f:	48 89 c7             	mov    %rax,%rdi
  8027a2:	48 b8 e5 25 80 00 00 	movabs $0x8025e5,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
}
  8027ae:	c9                   	leaveq 
  8027af:	c3                   	retq   

00000000008027b0 <close_all>:

void
close_all(void)
{
  8027b0:	55                   	push   %rbp
  8027b1:	48 89 e5             	mov    %rsp,%rbp
  8027b4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027bf:	eb 15                	jmp    8027d6 <close_all+0x26>
		close(i);
  8027c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c4:	89 c7                	mov    %eax,%edi
  8027c6:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  8027cd:	00 00 00 
  8027d0:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027d2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027d6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027da:	7e e5                	jle    8027c1 <close_all+0x11>
		close(i);
}
  8027dc:	c9                   	leaveq 
  8027dd:	c3                   	retq   

00000000008027de <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027de:	55                   	push   %rbp
  8027df:	48 89 e5             	mov    %rsp,%rbp
  8027e2:	48 83 ec 40          	sub    $0x40,%rsp
  8027e6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027e9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027ec:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027f3:	48 89 d6             	mov    %rdx,%rsi
  8027f6:	89 c7                	mov    %eax,%edi
  8027f8:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  8027ff:	00 00 00 
  802802:	ff d0                	callq  *%rax
  802804:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802807:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280b:	79 08                	jns    802815 <dup+0x37>
		return r;
  80280d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802810:	e9 70 01 00 00       	jmpq   802985 <dup+0x1a7>
	close(newfdnum);
  802815:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802818:	89 c7                	mov    %eax,%edi
  80281a:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802826:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802829:	48 98                	cltq   
  80282b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802831:	48 c1 e0 0c          	shl    $0xc,%rax
  802835:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80283d:	48 89 c7             	mov    %rax,%rdi
  802840:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
  80284c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802850:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802854:	48 89 c7             	mov    %rax,%rdi
  802857:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
  802863:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286b:	48 c1 e8 15          	shr    $0x15,%rax
  80286f:	48 89 c2             	mov    %rax,%rdx
  802872:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802879:	01 00 00 
  80287c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802880:	83 e0 01             	and    $0x1,%eax
  802883:	48 85 c0             	test   %rax,%rax
  802886:	74 73                	je     8028fb <dup+0x11d>
  802888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288c:	48 c1 e8 0c          	shr    $0xc,%rax
  802890:	48 89 c2             	mov    %rax,%rdx
  802893:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80289a:	01 00 00 
  80289d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a1:	83 e0 01             	and    $0x1,%eax
  8028a4:	48 85 c0             	test   %rax,%rax
  8028a7:	74 52                	je     8028fb <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8028b1:	48 89 c2             	mov    %rax,%rdx
  8028b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028bb:	01 00 00 
  8028be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8028c7:	89 c1                	mov    %eax,%ecx
  8028c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d1:	41 89 c8             	mov    %ecx,%r8d
  8028d4:	48 89 d1             	mov    %rdx,%rcx
  8028d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028dc:	48 89 c6             	mov    %rax,%rsi
  8028df:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e4:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8028eb:	00 00 00 
  8028ee:	ff d0                	callq  *%rax
  8028f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f7:	79 02                	jns    8028fb <dup+0x11d>
			goto err;
  8028f9:	eb 57                	jmp    802952 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ff:	48 c1 e8 0c          	shr    $0xc,%rax
  802903:	48 89 c2             	mov    %rax,%rdx
  802906:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290d:	01 00 00 
  802910:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802914:	25 07 0e 00 00       	and    $0xe07,%eax
  802919:	89 c1                	mov    %eax,%ecx
  80291b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802923:	41 89 c8             	mov    %ecx,%r8d
  802926:	48 89 d1             	mov    %rdx,%rcx
  802929:	ba 00 00 00 00       	mov    $0x0,%edx
  80292e:	48 89 c6             	mov    %rax,%rsi
  802931:	bf 00 00 00 00       	mov    $0x0,%edi
  802936:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  80293d:	00 00 00 
  802940:	ff d0                	callq  *%rax
  802942:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802945:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802949:	79 02                	jns    80294d <dup+0x16f>
		goto err;
  80294b:	eb 05                	jmp    802952 <dup+0x174>

	return newfdnum;
  80294d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802950:	eb 33                	jmp    802985 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802952:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802956:	48 89 c6             	mov    %rax,%rsi
  802959:	bf 00 00 00 00       	mov    $0x0,%edi
  80295e:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80296a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296e:	48 89 c6             	mov    %rax,%rsi
  802971:	bf 00 00 00 00       	mov    $0x0,%edi
  802976:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
	return r;
  802982:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802985:	c9                   	leaveq 
  802986:	c3                   	retq   

0000000000802987 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802987:	55                   	push   %rbp
  802988:	48 89 e5             	mov    %rsp,%rbp
  80298b:	48 83 ec 40          	sub    $0x40,%rsp
  80298f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802992:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802996:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80299a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029a1:	48 89 d6             	mov    %rdx,%rsi
  8029a4:	89 c7                	mov    %eax,%edi
  8029a6:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	callq  *%rax
  8029b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b9:	78 24                	js     8029df <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	8b 00                	mov    (%rax),%eax
  8029c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c5:	48 89 d6             	mov    %rdx,%rsi
  8029c8:	89 c7                	mov    %eax,%edi
  8029ca:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	callq  *%rax
  8029d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dd:	79 05                	jns    8029e4 <read+0x5d>
		return r;
  8029df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e2:	eb 76                	jmp    802a5a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e8:	8b 40 08             	mov    0x8(%rax),%eax
  8029eb:	83 e0 03             	and    $0x3,%eax
  8029ee:	83 f8 01             	cmp    $0x1,%eax
  8029f1:	75 3a                	jne    802a2d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029f3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029fa:	00 00 00 
  8029fd:	48 8b 00             	mov    (%rax),%rax
  802a00:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a06:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a09:	89 c6                	mov    %eax,%esi
  802a0b:	48 bf 0f 48 80 00 00 	movabs $0x80480f,%rdi
  802a12:	00 00 00 
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	48 b9 01 07 80 00 00 	movabs $0x800701,%rcx
  802a21:	00 00 00 
  802a24:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a2b:	eb 2d                	jmp    802a5a <read+0xd3>
	}
	if (!dev->dev_read)
  802a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a31:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a35:	48 85 c0             	test   %rax,%rax
  802a38:	75 07                	jne    802a41 <read+0xba>
		return -E_NOT_SUPP;
  802a3a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a3f:	eb 19                	jmp    802a5a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a45:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a49:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a4d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a51:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a55:	48 89 cf             	mov    %rcx,%rdi
  802a58:	ff d0                	callq  *%rax
}
  802a5a:	c9                   	leaveq 
  802a5b:	c3                   	retq   

0000000000802a5c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a5c:	55                   	push   %rbp
  802a5d:	48 89 e5             	mov    %rsp,%rbp
  802a60:	48 83 ec 30          	sub    $0x30,%rsp
  802a64:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a6b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a76:	eb 49                	jmp    802ac1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7b:	48 98                	cltq   
  802a7d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a81:	48 29 c2             	sub    %rax,%rdx
  802a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a87:	48 63 c8             	movslq %eax,%rcx
  802a8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8e:	48 01 c1             	add    %rax,%rcx
  802a91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a94:	48 89 ce             	mov    %rcx,%rsi
  802a97:	89 c7                	mov    %eax,%edi
  802a99:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
  802aa5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802aa8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aac:	79 05                	jns    802ab3 <readn+0x57>
			return m;
  802aae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab1:	eb 1c                	jmp    802acf <readn+0x73>
		if (m == 0)
  802ab3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ab7:	75 02                	jne    802abb <readn+0x5f>
			break;
  802ab9:	eb 11                	jmp    802acc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802abb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802abe:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac4:	48 98                	cltq   
  802ac6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802aca:	72 ac                	jb     802a78 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802acf:	c9                   	leaveq 
  802ad0:	c3                   	retq   

0000000000802ad1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ad1:	55                   	push   %rbp
  802ad2:	48 89 e5             	mov    %rsp,%rbp
  802ad5:	48 83 ec 40          	sub    $0x40,%rsp
  802ad9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802adc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ae0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ae4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aeb:	48 89 d6             	mov    %rdx,%rsi
  802aee:	89 c7                	mov    %eax,%edi
  802af0:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  802af7:	00 00 00 
  802afa:	ff d0                	callq  *%rax
  802afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b03:	78 24                	js     802b29 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b09:	8b 00                	mov    (%rax),%eax
  802b0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0f:	48 89 d6             	mov    %rdx,%rsi
  802b12:	89 c7                	mov    %eax,%edi
  802b14:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
  802b20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b27:	79 05                	jns    802b2e <write+0x5d>
		return r;
  802b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2c:	eb 75                	jmp    802ba3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b32:	8b 40 08             	mov    0x8(%rax),%eax
  802b35:	83 e0 03             	and    $0x3,%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	75 3a                	jne    802b76 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b3c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b43:	00 00 00 
  802b46:	48 8b 00             	mov    (%rax),%rax
  802b49:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b4f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b52:	89 c6                	mov    %eax,%esi
  802b54:	48 bf 2b 48 80 00 00 	movabs $0x80482b,%rdi
  802b5b:	00 00 00 
  802b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b63:	48 b9 01 07 80 00 00 	movabs $0x800701,%rcx
  802b6a:	00 00 00 
  802b6d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b74:	eb 2d                	jmp    802ba3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b7e:	48 85 c0             	test   %rax,%rax
  802b81:	75 07                	jne    802b8a <write+0xb9>
		return -E_NOT_SUPP;
  802b83:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b88:	eb 19                	jmp    802ba3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b92:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b9a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b9e:	48 89 cf             	mov    %rcx,%rdi
  802ba1:	ff d0                	callq  *%rax
}
  802ba3:	c9                   	leaveq 
  802ba4:	c3                   	retq   

0000000000802ba5 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ba5:	55                   	push   %rbp
  802ba6:	48 89 e5             	mov    %rsp,%rbp
  802ba9:	48 83 ec 18          	sub    $0x18,%rsp
  802bad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bba:	48 89 d6             	mov    %rdx,%rsi
  802bbd:	89 c7                	mov    %eax,%edi
  802bbf:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
  802bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd2:	79 05                	jns    802bd9 <seek+0x34>
		return r;
  802bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd7:	eb 0f                	jmp    802be8 <seek+0x43>
	fd->fd_offset = offset;
  802bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be8:	c9                   	leaveq 
  802be9:	c3                   	retq   

0000000000802bea <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 83 ec 30          	sub    $0x30,%rsp
  802bf2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bfc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bff:	48 89 d6             	mov    %rdx,%rsi
  802c02:	89 c7                	mov    %eax,%edi
  802c04:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c17:	78 24                	js     802c3d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1d:	8b 00                	mov    (%rax),%eax
  802c1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c23:	48 89 d6             	mov    %rdx,%rsi
  802c26:	89 c7                	mov    %eax,%edi
  802c28:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  802c2f:	00 00 00 
  802c32:	ff d0                	callq  *%rax
  802c34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3b:	79 05                	jns    802c42 <ftruncate+0x58>
		return r;
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c40:	eb 72                	jmp    802cb4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c46:	8b 40 08             	mov    0x8(%rax),%eax
  802c49:	83 e0 03             	and    $0x3,%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	75 3a                	jne    802c8a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c50:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c57:	00 00 00 
  802c5a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c5d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c63:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c66:	89 c6                	mov    %eax,%esi
  802c68:	48 bf 48 48 80 00 00 	movabs $0x804848,%rdi
  802c6f:	00 00 00 
  802c72:	b8 00 00 00 00       	mov    $0x0,%eax
  802c77:	48 b9 01 07 80 00 00 	movabs $0x800701,%rcx
  802c7e:	00 00 00 
  802c81:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c88:	eb 2a                	jmp    802cb4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c92:	48 85 c0             	test   %rax,%rax
  802c95:	75 07                	jne    802c9e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c97:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c9c:	eb 16                	jmp    802cb4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ca6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802caa:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802cad:	89 ce                	mov    %ecx,%esi
  802caf:	48 89 d7             	mov    %rdx,%rdi
  802cb2:	ff d0                	callq  *%rax
}
  802cb4:	c9                   	leaveq 
  802cb5:	c3                   	retq   

0000000000802cb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cb6:	55                   	push   %rbp
  802cb7:	48 89 e5             	mov    %rsp,%rbp
  802cba:	48 83 ec 30          	sub    $0x30,%rsp
  802cbe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cc1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ccc:	48 89 d6             	mov    %rdx,%rsi
  802ccf:	89 c7                	mov    %eax,%edi
  802cd1:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  802cd8:	00 00 00 
  802cdb:	ff d0                	callq  *%rax
  802cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce4:	78 24                	js     802d0a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cea:	8b 00                	mov    (%rax),%eax
  802cec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf0:	48 89 d6             	mov    %rdx,%rsi
  802cf3:	89 c7                	mov    %eax,%edi
  802cf5:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
  802d01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d08:	79 05                	jns    802d0f <fstat+0x59>
		return r;
  802d0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0d:	eb 5e                	jmp    802d6d <fstat+0xb7>
	if (!dev->dev_stat)
  802d0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d13:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d17:	48 85 c0             	test   %rax,%rax
  802d1a:	75 07                	jne    802d23 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d1c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d21:	eb 4a                	jmp    802d6d <fstat+0xb7>
	stat->st_name[0] = 0;
  802d23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d27:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d35:	00 00 00 
	stat->st_isdir = 0;
  802d38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d3c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d43:	00 00 00 
	stat->st_dev = dev;
  802d46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d4e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d59:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d61:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d65:	48 89 ce             	mov    %rcx,%rsi
  802d68:	48 89 d7             	mov    %rdx,%rdi
  802d6b:	ff d0                	callq  *%rax
}
  802d6d:	c9                   	leaveq 
  802d6e:	c3                   	retq   

0000000000802d6f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d6f:	55                   	push   %rbp
  802d70:	48 89 e5             	mov    %rsp,%rbp
  802d73:	48 83 ec 20          	sub    $0x20,%rsp
  802d77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d83:	be 00 00 00 00       	mov    $0x0,%esi
  802d88:	48 89 c7             	mov    %rax,%rdi
  802d8b:	48 b8 5d 2e 80 00 00 	movabs $0x802e5d,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
  802d97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9e:	79 05                	jns    802da5 <stat+0x36>
		return fd;
  802da0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da3:	eb 2f                	jmp    802dd4 <stat+0x65>
	r = fstat(fd, stat);
  802da5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dac:	48 89 d6             	mov    %rdx,%rsi
  802daf:	89 c7                	mov    %eax,%edi
  802db1:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	callq  *%rax
  802dbd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc3:	89 c7                	mov    %eax,%edi
  802dc5:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  802dcc:	00 00 00 
  802dcf:	ff d0                	callq  *%rax
	return r;
  802dd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dd4:	c9                   	leaveq 
  802dd5:	c3                   	retq   

0000000000802dd6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dd6:	55                   	push   %rbp
  802dd7:	48 89 e5             	mov    %rsp,%rbp
  802dda:	48 83 ec 10          	sub    $0x10,%rsp
  802dde:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802de1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802de5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dec:	00 00 00 
  802def:	8b 00                	mov    (%rax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	75 1d                	jne    802e12 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802df5:	bf 01 00 00 00       	mov    $0x1,%edi
  802dfa:	48 b8 d7 3f 80 00 00 	movabs $0x803fd7,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
  802e06:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e0d:	00 00 00 
  802e10:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e12:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e19:	00 00 00 
  802e1c:	8b 00                	mov    (%rax),%eax
  802e1e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e21:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e26:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e2d:	00 00 00 
  802e30:	89 c7                	mov    %eax,%edi
  802e32:	48 b8 3f 3f 80 00 00 	movabs $0x803f3f,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e42:	ba 00 00 00 00       	mov    $0x0,%edx
  802e47:	48 89 c6             	mov    %rax,%rsi
  802e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4f:	48 b8 7e 3e 80 00 00 	movabs $0x803e7e,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
}
  802e5b:	c9                   	leaveq 
  802e5c:	c3                   	retq   

0000000000802e5d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e5d:	55                   	push   %rbp
  802e5e:	48 89 e5             	mov    %rsp,%rbp
  802e61:	48 83 ec 20          	sub    $0x20,%rsp
  802e65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e69:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e70:	48 89 c7             	mov    %rax,%rdi
  802e73:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
  802e7f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e84:	7e 0a                	jle    802e90 <open+0x33>
		return -E_BAD_PATH;
  802e86:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e8b:	e9 a5 00 00 00       	jmpq   802f35 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e90:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e94:	48 89 c7             	mov    %rax,%rdi
  802e97:	48 b8 bd 24 80 00 00 	movabs $0x8024bd,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eaa:	79 08                	jns    802eb4 <open+0x57>
		return r;
  802eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaf:	e9 81 00 00 00       	jmpq   802f35 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb8:	48 89 c6             	mov    %rax,%rsi
  802ebb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ec2:	00 00 00 
  802ec5:	48 b8 c9 12 80 00 00 	movabs $0x8012c9,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ed1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ed8:	00 00 00 
  802edb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ede:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee8:	48 89 c6             	mov    %rax,%rsi
  802eeb:	bf 01 00 00 00       	mov    $0x1,%edi
  802ef0:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f03:	79 1d                	jns    802f22 <open+0xc5>
		fd_close(fd, 0);
  802f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f09:	be 00 00 00 00       	mov    $0x0,%esi
  802f0e:	48 89 c7             	mov    %rax,%rdi
  802f11:	48 b8 e5 25 80 00 00 	movabs $0x8025e5,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
		return r;
  802f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f20:	eb 13                	jmp    802f35 <open+0xd8>
	}

	return fd2num(fd);
  802f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f26:	48 89 c7             	mov    %rax,%rdi
  802f29:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802f35:	c9                   	leaveq 
  802f36:	c3                   	retq   

0000000000802f37 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f37:	55                   	push   %rbp
  802f38:	48 89 e5             	mov    %rsp,%rbp
  802f3b:	48 83 ec 10          	sub    $0x10,%rsp
  802f3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f47:	8b 50 0c             	mov    0xc(%rax),%edx
  802f4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f51:	00 00 00 
  802f54:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f56:	be 00 00 00 00       	mov    $0x0,%esi
  802f5b:	bf 06 00 00 00       	mov    $0x6,%edi
  802f60:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
}
  802f6c:	c9                   	leaveq 
  802f6d:	c3                   	retq   

0000000000802f6e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f6e:	55                   	push   %rbp
  802f6f:	48 89 e5             	mov    %rsp,%rbp
  802f72:	48 83 ec 30          	sub    $0x30,%rsp
  802f76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f86:	8b 50 0c             	mov    0xc(%rax),%edx
  802f89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f90:	00 00 00 
  802f93:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f95:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f9c:	00 00 00 
  802f9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fa3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802fa7:	be 00 00 00 00       	mov    $0x0,%esi
  802fac:	bf 03 00 00 00       	mov    $0x3,%edi
  802fb1:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  802fb8:	00 00 00 
  802fbb:	ff d0                	callq  *%rax
  802fbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc4:	79 08                	jns    802fce <devfile_read+0x60>
		return r;
  802fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc9:	e9 a4 00 00 00       	jmpq   803072 <devfile_read+0x104>
	assert(r <= n);
  802fce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd1:	48 98                	cltq   
  802fd3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fd7:	76 35                	jbe    80300e <devfile_read+0xa0>
  802fd9:	48 b9 75 48 80 00 00 	movabs $0x804875,%rcx
  802fe0:	00 00 00 
  802fe3:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  802fea:	00 00 00 
  802fed:	be 84 00 00 00       	mov    $0x84,%esi
  802ff2:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  802ff9:	00 00 00 
  802ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  803001:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  803008:	00 00 00 
  80300b:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80300e:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803015:	7e 35                	jle    80304c <devfile_read+0xde>
  803017:	48 b9 9c 48 80 00 00 	movabs $0x80489c,%rcx
  80301e:	00 00 00 
  803021:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  803028:	00 00 00 
  80302b:	be 85 00 00 00       	mov    $0x85,%esi
  803030:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  803037:	00 00 00 
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
  80303f:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  803046:	00 00 00 
  803049:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80304c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304f:	48 63 d0             	movslq %eax,%rdx
  803052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803056:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80305d:	00 00 00 
  803060:	48 89 c7             	mov    %rax,%rdi
  803063:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  80306a:	00 00 00 
  80306d:	ff d0                	callq  *%rax
	return r;
  80306f:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  803072:	c9                   	leaveq 
  803073:	c3                   	retq   

0000000000803074 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803074:	55                   	push   %rbp
  803075:	48 89 e5             	mov    %rsp,%rbp
  803078:	48 83 ec 30          	sub    $0x30,%rsp
  80307c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803080:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803084:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308c:	8b 50 0c             	mov    0xc(%rax),%edx
  80308f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803096:	00 00 00 
  803099:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80309b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a2:	00 00 00 
  8030a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8030ad:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030b4:	00 
  8030b5:	76 35                	jbe    8030ec <devfile_write+0x78>
  8030b7:	48 b9 a8 48 80 00 00 	movabs $0x8048a8,%rcx
  8030be:	00 00 00 
  8030c1:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  8030c8:	00 00 00 
  8030cb:	be 9e 00 00 00       	mov    $0x9e,%esi
  8030d0:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  8030d7:	00 00 00 
  8030da:	b8 00 00 00 00       	mov    $0x0,%eax
  8030df:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  8030e6:	00 00 00 
  8030e9:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8030ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f4:	48 89 c6             	mov    %rax,%rsi
  8030f7:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030fe:	00 00 00 
  803101:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80310d:	be 00 00 00 00       	mov    $0x0,%esi
  803112:	bf 04 00 00 00       	mov    $0x4,%edi
  803117:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803126:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312a:	79 05                	jns    803131 <devfile_write+0xbd>
		return r;
  80312c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312f:	eb 43                	jmp    803174 <devfile_write+0x100>
	assert(r <= n);
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	48 98                	cltq   
  803136:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80313a:	76 35                	jbe    803171 <devfile_write+0xfd>
  80313c:	48 b9 75 48 80 00 00 	movabs $0x804875,%rcx
  803143:	00 00 00 
  803146:	48 ba 7c 48 80 00 00 	movabs $0x80487c,%rdx
  80314d:	00 00 00 
  803150:	be a2 00 00 00       	mov    $0xa2,%esi
  803155:	48 bf 91 48 80 00 00 	movabs $0x804891,%rdi
  80315c:	00 00 00 
  80315f:	b8 00 00 00 00       	mov    $0x0,%eax
  803164:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  80316b:	00 00 00 
  80316e:	41 ff d0             	callq  *%r8
	return r;
  803171:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  803174:	c9                   	leaveq 
  803175:	c3                   	retq   

0000000000803176 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803176:	55                   	push   %rbp
  803177:	48 89 e5             	mov    %rsp,%rbp
  80317a:	48 83 ec 20          	sub    $0x20,%rsp
  80317e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803182:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80318a:	8b 50 0c             	mov    0xc(%rax),%edx
  80318d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803194:	00 00 00 
  803197:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803199:	be 00 00 00 00       	mov    $0x0,%esi
  80319e:	bf 05 00 00 00       	mov    $0x5,%edi
  8031a3:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b6:	79 05                	jns    8031bd <devfile_stat+0x47>
		return r;
  8031b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031bb:	eb 56                	jmp    803213 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031c8:	00 00 00 
  8031cb:	48 89 c7             	mov    %rax,%rdi
  8031ce:	48 b8 c9 12 80 00 00 	movabs $0x8012c9,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e1:	00 00 00 
  8031e4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ee:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031fb:	00 00 00 
  8031fe:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803204:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803208:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80320e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803213:	c9                   	leaveq 
  803214:	c3                   	retq   

0000000000803215 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803215:	55                   	push   %rbp
  803216:	48 89 e5             	mov    %rsp,%rbp
  803219:	48 83 ec 10          	sub    $0x10,%rsp
  80321d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803221:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803228:	8b 50 0c             	mov    0xc(%rax),%edx
  80322b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803232:	00 00 00 
  803235:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803237:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80323e:	00 00 00 
  803241:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803244:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803247:	be 00 00 00 00       	mov    $0x0,%esi
  80324c:	bf 02 00 00 00       	mov    $0x2,%edi
  803251:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
}
  80325d:	c9                   	leaveq 
  80325e:	c3                   	retq   

000000000080325f <remove>:

// Delete a file
int
remove(const char *path)
{
  80325f:	55                   	push   %rbp
  803260:	48 89 e5             	mov    %rsp,%rbp
  803263:	48 83 ec 10          	sub    $0x10,%rsp
  803267:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80326b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326f:	48 89 c7             	mov    %rax,%rdi
  803272:	48 b8 5d 12 80 00 00 	movabs $0x80125d,%rax
  803279:	00 00 00 
  80327c:	ff d0                	callq  *%rax
  80327e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803283:	7e 07                	jle    80328c <remove+0x2d>
		return -E_BAD_PATH;
  803285:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80328a:	eb 33                	jmp    8032bf <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80328c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803290:	48 89 c6             	mov    %rax,%rsi
  803293:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80329a:	00 00 00 
  80329d:	48 b8 c9 12 80 00 00 	movabs $0x8012c9,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032a9:	be 00 00 00 00       	mov    $0x0,%esi
  8032ae:	bf 07 00 00 00       	mov    $0x7,%edi
  8032b3:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  8032ba:	00 00 00 
  8032bd:	ff d0                	callq  *%rax
}
  8032bf:	c9                   	leaveq 
  8032c0:	c3                   	retq   

00000000008032c1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032c1:	55                   	push   %rbp
  8032c2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032c5:	be 00 00 00 00       	mov    $0x0,%esi
  8032ca:	bf 08 00 00 00       	mov    $0x8,%edi
  8032cf:	48 b8 d6 2d 80 00 00 	movabs $0x802dd6,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
}
  8032db:	5d                   	pop    %rbp
  8032dc:	c3                   	retq   

00000000008032dd <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032dd:	55                   	push   %rbp
  8032de:	48 89 e5             	mov    %rsp,%rbp
  8032e1:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032e8:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032ef:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032f6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032fd:	be 00 00 00 00       	mov    $0x0,%esi
  803302:	48 89 c7             	mov    %rax,%rdi
  803305:	48 b8 5d 2e 80 00 00 	movabs $0x802e5d,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
  803311:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803314:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803318:	79 28                	jns    803342 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80331a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331d:	89 c6                	mov    %eax,%esi
  80331f:	48 bf d5 48 80 00 00 	movabs $0x8048d5,%rdi
  803326:	00 00 00 
  803329:	b8 00 00 00 00       	mov    $0x0,%eax
  80332e:	48 ba 01 07 80 00 00 	movabs $0x800701,%rdx
  803335:	00 00 00 
  803338:	ff d2                	callq  *%rdx
		return fd_src;
  80333a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333d:	e9 74 01 00 00       	jmpq   8034b6 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803342:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803349:	be 01 01 00 00       	mov    $0x101,%esi
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 5d 2e 80 00 00 	movabs $0x802e5d,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
  80335d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803360:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803364:	79 39                	jns    80339f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803366:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803369:	89 c6                	mov    %eax,%esi
  80336b:	48 bf eb 48 80 00 00 	movabs $0x8048eb,%rdi
  803372:	00 00 00 
  803375:	b8 00 00 00 00       	mov    $0x0,%eax
  80337a:	48 ba 01 07 80 00 00 	movabs $0x800701,%rdx
  803381:	00 00 00 
  803384:	ff d2                	callq  *%rdx
		close(fd_src);
  803386:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803389:	89 c7                	mov    %eax,%edi
  80338b:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
		return fd_dest;
  803397:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80339a:	e9 17 01 00 00       	jmpq   8034b6 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80339f:	eb 74                	jmp    803415 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8033a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a4:	48 63 d0             	movslq %eax,%rdx
  8033a7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b1:	48 89 ce             	mov    %rcx,%rsi
  8033b4:	89 c7                	mov    %eax,%edi
  8033b6:	48 b8 d1 2a 80 00 00 	movabs $0x802ad1,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033c9:	79 4a                	jns    803415 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033ce:	89 c6                	mov    %eax,%esi
  8033d0:	48 bf 05 49 80 00 00 	movabs $0x804905,%rdi
  8033d7:	00 00 00 
  8033da:	b8 00 00 00 00       	mov    $0x0,%eax
  8033df:	48 ba 01 07 80 00 00 	movabs $0x800701,%rdx
  8033e6:	00 00 00 
  8033e9:	ff d2                	callq  *%rdx
			close(fd_src);
  8033eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ee:	89 c7                	mov    %eax,%edi
  8033f0:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  8033f7:	00 00 00 
  8033fa:	ff d0                	callq  *%rax
			close(fd_dest);
  8033fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ff:	89 c7                	mov    %eax,%edi
  803401:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
			return write_size;
  80340d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803410:	e9 a1 00 00 00       	jmpq   8034b6 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803415:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80341c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341f:	ba 00 02 00 00       	mov    $0x200,%edx
  803424:	48 89 ce             	mov    %rcx,%rsi
  803427:	89 c7                	mov    %eax,%edi
  803429:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803438:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80343c:	0f 8f 5f ff ff ff    	jg     8033a1 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803442:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803446:	79 47                	jns    80348f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803448:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80344b:	89 c6                	mov    %eax,%esi
  80344d:	48 bf 18 49 80 00 00 	movabs $0x804918,%rdi
  803454:	00 00 00 
  803457:	b8 00 00 00 00       	mov    $0x0,%eax
  80345c:	48 ba 01 07 80 00 00 	movabs $0x800701,%rdx
  803463:	00 00 00 
  803466:	ff d2                	callq  *%rdx
		close(fd_src);
  803468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346b:	89 c7                	mov    %eax,%edi
  80346d:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
		close(fd_dest);
  803479:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80347c:	89 c7                	mov    %eax,%edi
  80347e:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
		return read_size;
  80348a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80348d:	eb 27                	jmp    8034b6 <copy+0x1d9>
	}
	close(fd_src);
  80348f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803492:	89 c7                	mov    %eax,%edi
  803494:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  80349b:	00 00 00 
  80349e:	ff d0                	callq  *%rax
	close(fd_dest);
  8034a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a3:	89 c7                	mov    %eax,%edi
  8034a5:	48 b8 65 27 80 00 00 	movabs $0x802765,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
	return 0;
  8034b1:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8034b6:	c9                   	leaveq 
  8034b7:	c3                   	retq   

00000000008034b8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034b8:	55                   	push   %rbp
  8034b9:	48 89 e5             	mov    %rsp,%rbp
  8034bc:	53                   	push   %rbx
  8034bd:	48 83 ec 38          	sub    $0x38,%rsp
  8034c1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034c5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034c9:	48 89 c7             	mov    %rax,%rdi
  8034cc:	48 b8 bd 24 80 00 00 	movabs $0x8024bd,%rax
  8034d3:	00 00 00 
  8034d6:	ff d0                	callq  *%rax
  8034d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034df:	0f 88 bf 01 00 00    	js     8036a4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e9:	ba 07 04 00 00       	mov    $0x407,%edx
  8034ee:	48 89 c6             	mov    %rax,%rsi
  8034f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f6:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  8034fd:	00 00 00 
  803500:	ff d0                	callq  *%rax
  803502:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803505:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803509:	0f 88 95 01 00 00    	js     8036a4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80350f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803513:	48 89 c7             	mov    %rax,%rdi
  803516:	48 b8 bd 24 80 00 00 	movabs $0x8024bd,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
  803522:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803525:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803529:	0f 88 5d 01 00 00    	js     80368c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80352f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803533:	ba 07 04 00 00       	mov    $0x407,%edx
  803538:	48 89 c6             	mov    %rax,%rsi
  80353b:	bf 00 00 00 00       	mov    $0x0,%edi
  803540:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  803547:	00 00 00 
  80354a:	ff d0                	callq  *%rax
  80354c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80354f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803553:	0f 88 33 01 00 00    	js     80368c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80355d:	48 89 c7             	mov    %rax,%rdi
  803560:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  803567:	00 00 00 
  80356a:	ff d0                	callq  *%rax
  80356c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803570:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803574:	ba 07 04 00 00       	mov    $0x407,%edx
  803579:	48 89 c6             	mov    %rax,%rsi
  80357c:	bf 00 00 00 00       	mov    $0x0,%edi
  803581:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  803588:	00 00 00 
  80358b:	ff d0                	callq  *%rax
  80358d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803590:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803594:	79 05                	jns    80359b <pipe+0xe3>
		goto err2;
  803596:	e9 d9 00 00 00       	jmpq   803674 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80359b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359f:	48 89 c7             	mov    %rax,%rdi
  8035a2:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
  8035ae:	48 89 c2             	mov    %rax,%rdx
  8035b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035bb:	48 89 d1             	mov    %rdx,%rcx
  8035be:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c3:	48 89 c6             	mov    %rax,%rsi
  8035c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cb:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8035d2:	00 00 00 
  8035d5:	ff d0                	callq  *%rax
  8035d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035da:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035de:	79 1b                	jns    8035fb <pipe+0x143>
		goto err3;
  8035e0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e5:	48 89 c6             	mov    %rax,%rsi
  8035e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ed:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  8035f4:	00 00 00 
  8035f7:	ff d0                	callq  *%rax
  8035f9:	eb 79                	jmp    803674 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ff:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803606:	00 00 00 
  803609:	8b 12                	mov    (%rdx),%edx
  80360b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80360d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803611:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803618:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80361c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803623:	00 00 00 
  803626:	8b 12                	mov    (%rdx),%edx
  803628:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80362a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80362e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803639:	48 89 c7             	mov    %rax,%rdi
  80363c:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 c2                	mov    %eax,%edx
  80364a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80364e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803650:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803654:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803658:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80365c:	48 89 c7             	mov    %rax,%rdi
  80365f:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
  80366b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80366d:	b8 00 00 00 00       	mov    $0x0,%eax
  803672:	eb 33                	jmp    8036a7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803678:	48 89 c6             	mov    %rax,%rsi
  80367b:	bf 00 00 00 00       	mov    $0x0,%edi
  803680:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80368c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803690:	48 89 c6             	mov    %rax,%rsi
  803693:	bf 00 00 00 00       	mov    $0x0,%edi
  803698:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  80369f:	00 00 00 
  8036a2:	ff d0                	callq  *%rax
err:
	return r;
  8036a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036a7:	48 83 c4 38          	add    $0x38,%rsp
  8036ab:	5b                   	pop    %rbx
  8036ac:	5d                   	pop    %rbp
  8036ad:	c3                   	retq   

00000000008036ae <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036ae:	55                   	push   %rbp
  8036af:	48 89 e5             	mov    %rsp,%rbp
  8036b2:	53                   	push   %rbx
  8036b3:	48 83 ec 28          	sub    $0x28,%rsp
  8036b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036bf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036c6:	00 00 00 
  8036c9:	48 8b 00             	mov    (%rax),%rax
  8036cc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d9:	48 89 c7             	mov    %rax,%rdi
  8036dc:	48 b8 59 40 80 00 00 	movabs $0x804059,%rax
  8036e3:	00 00 00 
  8036e6:	ff d0                	callq  *%rax
  8036e8:	89 c3                	mov    %eax,%ebx
  8036ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ee:	48 89 c7             	mov    %rax,%rdi
  8036f1:	48 b8 59 40 80 00 00 	movabs $0x804059,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	39 c3                	cmp    %eax,%ebx
  8036ff:	0f 94 c0             	sete   %al
  803702:	0f b6 c0             	movzbl %al,%eax
  803705:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803708:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80370f:	00 00 00 
  803712:	48 8b 00             	mov    (%rax),%rax
  803715:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80371b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80371e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803721:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803724:	75 05                	jne    80372b <_pipeisclosed+0x7d>
			return ret;
  803726:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803729:	eb 4f                	jmp    80377a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80372b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803731:	74 42                	je     803775 <_pipeisclosed+0xc7>
  803733:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803737:	75 3c                	jne    803775 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803739:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803740:	00 00 00 
  803743:	48 8b 00             	mov    (%rax),%rax
  803746:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80374c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80374f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803752:	89 c6                	mov    %eax,%esi
  803754:	48 bf 33 49 80 00 00 	movabs $0x804933,%rdi
  80375b:	00 00 00 
  80375e:	b8 00 00 00 00       	mov    $0x0,%eax
  803763:	49 b8 01 07 80 00 00 	movabs $0x800701,%r8
  80376a:	00 00 00 
  80376d:	41 ff d0             	callq  *%r8
	}
  803770:	e9 4a ff ff ff       	jmpq   8036bf <_pipeisclosed+0x11>
  803775:	e9 45 ff ff ff       	jmpq   8036bf <_pipeisclosed+0x11>
}
  80377a:	48 83 c4 28          	add    $0x28,%rsp
  80377e:	5b                   	pop    %rbx
  80377f:	5d                   	pop    %rbp
  803780:	c3                   	retq   

0000000000803781 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803781:	55                   	push   %rbp
  803782:	48 89 e5             	mov    %rsp,%rbp
  803785:	48 83 ec 30          	sub    $0x30,%rsp
  803789:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80378c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803790:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803793:	48 89 d6             	mov    %rdx,%rsi
  803796:	89 c7                	mov    %eax,%edi
  803798:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
  8037a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ab:	79 05                	jns    8037b2 <pipeisclosed+0x31>
		return r;
  8037ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b0:	eb 31                	jmp    8037e3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b6:	48 89 c7             	mov    %rax,%rdi
  8037b9:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
  8037c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037d1:	48 89 d6             	mov    %rdx,%rsi
  8037d4:	48 89 c7             	mov    %rax,%rdi
  8037d7:	48 b8 ae 36 80 00 00 	movabs $0x8036ae,%rax
  8037de:	00 00 00 
  8037e1:	ff d0                	callq  *%rax
}
  8037e3:	c9                   	leaveq 
  8037e4:	c3                   	retq   

00000000008037e5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037e5:	55                   	push   %rbp
  8037e6:	48 89 e5             	mov    %rsp,%rbp
  8037e9:	48 83 ec 40          	sub    $0x40,%rsp
  8037ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037fd:	48 89 c7             	mov    %rax,%rdi
  803800:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
  80380c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803810:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803814:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803818:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80381f:	00 
  803820:	e9 92 00 00 00       	jmpq   8038b7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803825:	eb 41                	jmp    803868 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803827:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80382c:	74 09                	je     803837 <devpipe_read+0x52>
				return i;
  80382e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803832:	e9 92 00 00 00       	jmpq   8038c9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803837:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80383b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383f:	48 89 d6             	mov    %rdx,%rsi
  803842:	48 89 c7             	mov    %rax,%rdi
  803845:	48 b8 ae 36 80 00 00 	movabs $0x8036ae,%rax
  80384c:	00 00 00 
  80384f:	ff d0                	callq  *%rax
  803851:	85 c0                	test   %eax,%eax
  803853:	74 07                	je     80385c <devpipe_read+0x77>
				return 0;
  803855:	b8 00 00 00 00       	mov    $0x0,%eax
  80385a:	eb 6d                	jmp    8038c9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80385c:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803863:	00 00 00 
  803866:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386c:	8b 10                	mov    (%rax),%edx
  80386e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803872:	8b 40 04             	mov    0x4(%rax),%eax
  803875:	39 c2                	cmp    %eax,%edx
  803877:	74 ae                	je     803827 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803879:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803881:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803889:	8b 00                	mov    (%rax),%eax
  80388b:	99                   	cltd   
  80388c:	c1 ea 1b             	shr    $0x1b,%edx
  80388f:	01 d0                	add    %edx,%eax
  803891:	83 e0 1f             	and    $0x1f,%eax
  803894:	29 d0                	sub    %edx,%eax
  803896:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80389a:	48 98                	cltq   
  80389c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038a1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a7:	8b 00                	mov    (%rax),%eax
  8038a9:	8d 50 01             	lea    0x1(%rax),%edx
  8038ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038bb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038bf:	0f 82 60 ff ff ff    	jb     803825 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038c9:	c9                   	leaveq 
  8038ca:	c3                   	retq   

00000000008038cb <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038cb:	55                   	push   %rbp
  8038cc:	48 89 e5             	mov    %rsp,%rbp
  8038cf:	48 83 ec 40          	sub    $0x40,%rsp
  8038d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038db:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e3:	48 89 c7             	mov    %rax,%rdi
  8038e6:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  8038ed:	00 00 00 
  8038f0:	ff d0                	callq  *%rax
  8038f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038fe:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803905:	00 
  803906:	e9 8e 00 00 00       	jmpq   803999 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80390b:	eb 31                	jmp    80393e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80390d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803915:	48 89 d6             	mov    %rdx,%rsi
  803918:	48 89 c7             	mov    %rax,%rdi
  80391b:	48 b8 ae 36 80 00 00 	movabs $0x8036ae,%rax
  803922:	00 00 00 
  803925:	ff d0                	callq  *%rax
  803927:	85 c0                	test   %eax,%eax
  803929:	74 07                	je     803932 <devpipe_write+0x67>
				return 0;
  80392b:	b8 00 00 00 00       	mov    $0x0,%eax
  803930:	eb 79                	jmp    8039ab <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803932:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803939:	00 00 00 
  80393c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80393e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803942:	8b 40 04             	mov    0x4(%rax),%eax
  803945:	48 63 d0             	movslq %eax,%rdx
  803948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394c:	8b 00                	mov    (%rax),%eax
  80394e:	48 98                	cltq   
  803950:	48 83 c0 20          	add    $0x20,%rax
  803954:	48 39 c2             	cmp    %rax,%rdx
  803957:	73 b4                	jae    80390d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395d:	8b 40 04             	mov    0x4(%rax),%eax
  803960:	99                   	cltd   
  803961:	c1 ea 1b             	shr    $0x1b,%edx
  803964:	01 d0                	add    %edx,%eax
  803966:	83 e0 1f             	and    $0x1f,%eax
  803969:	29 d0                	sub    %edx,%eax
  80396b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80396f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803973:	48 01 ca             	add    %rcx,%rdx
  803976:	0f b6 0a             	movzbl (%rdx),%ecx
  803979:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80397d:	48 98                	cltq   
  80397f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803983:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803987:	8b 40 04             	mov    0x4(%rax),%eax
  80398a:	8d 50 01             	lea    0x1(%rax),%edx
  80398d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803991:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803994:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803999:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80399d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039a1:	0f 82 64 ff ff ff    	jb     80390b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039ab:	c9                   	leaveq 
  8039ac:	c3                   	retq   

00000000008039ad <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039ad:	55                   	push   %rbp
  8039ae:	48 89 e5             	mov    %rsp,%rbp
  8039b1:	48 83 ec 20          	sub    $0x20,%rsp
  8039b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c1:	48 89 c7             	mov    %rax,%rdi
  8039c4:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  8039cb:	00 00 00 
  8039ce:	ff d0                	callq  *%rax
  8039d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d8:	48 be 46 49 80 00 00 	movabs $0x804946,%rsi
  8039df:	00 00 00 
  8039e2:	48 89 c7             	mov    %rax,%rdi
  8039e5:	48 b8 c9 12 80 00 00 	movabs $0x8012c9,%rax
  8039ec:	00 00 00 
  8039ef:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f5:	8b 50 04             	mov    0x4(%rax),%edx
  8039f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fc:	8b 00                	mov    (%rax),%eax
  8039fe:	29 c2                	sub    %eax,%edx
  803a00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a04:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a0e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a15:	00 00 00 
	stat->st_dev = &devpipe;
  803a18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1c:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a23:	00 00 00 
  803a26:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a32:	c9                   	leaveq 
  803a33:	c3                   	retq   

0000000000803a34 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a34:	55                   	push   %rbp
  803a35:	48 89 e5             	mov    %rsp,%rbp
  803a38:	48 83 ec 10          	sub    $0x10,%rsp
  803a3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a44:	48 89 c6             	mov    %rax,%rsi
  803a47:	bf 00 00 00 00       	mov    $0x0,%edi
  803a4c:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  803a53:	00 00 00 
  803a56:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5c:	48 89 c7             	mov    %rax,%rdi
  803a5f:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
  803a6b:	48 89 c6             	mov    %rax,%rsi
  803a6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a73:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  803a7a:	00 00 00 
  803a7d:	ff d0                	callq  *%rax
}
  803a7f:	c9                   	leaveq 
  803a80:	c3                   	retq   

0000000000803a81 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a81:	55                   	push   %rbp
  803a82:	48 89 e5             	mov    %rsp,%rbp
  803a85:	48 83 ec 20          	sub    $0x20,%rsp
  803a89:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a8f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a92:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a96:	be 01 00 00 00       	mov    $0x1,%esi
  803a9b:	48 89 c7             	mov    %rax,%rdi
  803a9e:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	callq  *%rax
}
  803aaa:	c9                   	leaveq 
  803aab:	c3                   	retq   

0000000000803aac <getchar>:

int
getchar(void)
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ab4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ab8:	ba 01 00 00 00       	mov    $0x1,%edx
  803abd:	48 89 c6             	mov    %rax,%rsi
  803ac0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac5:	48 b8 87 29 80 00 00 	movabs $0x802987,%rax
  803acc:	00 00 00 
  803acf:	ff d0                	callq  *%rax
  803ad1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ad4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad8:	79 05                	jns    803adf <getchar+0x33>
		return r;
  803ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803add:	eb 14                	jmp    803af3 <getchar+0x47>
	if (r < 1)
  803adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae3:	7f 07                	jg     803aec <getchar+0x40>
		return -E_EOF;
  803ae5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803aea:	eb 07                	jmp    803af3 <getchar+0x47>
	return c;
  803aec:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803af0:	0f b6 c0             	movzbl %al,%eax
}
  803af3:	c9                   	leaveq 
  803af4:	c3                   	retq   

0000000000803af5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803af5:	55                   	push   %rbp
  803af6:	48 89 e5             	mov    %rsp,%rbp
  803af9:	48 83 ec 20          	sub    $0x20,%rsp
  803afd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b00:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b07:	48 89 d6             	mov    %rdx,%rsi
  803b0a:	89 c7                	mov    %eax,%edi
  803b0c:	48 b8 55 25 80 00 00 	movabs $0x802555,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
  803b18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b1f:	79 05                	jns    803b26 <iscons+0x31>
		return r;
  803b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b24:	eb 1a                	jmp    803b40 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2a:	8b 10                	mov    (%rax),%edx
  803b2c:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b33:	00 00 00 
  803b36:	8b 00                	mov    (%rax),%eax
  803b38:	39 c2                	cmp    %eax,%edx
  803b3a:	0f 94 c0             	sete   %al
  803b3d:	0f b6 c0             	movzbl %al,%eax
}
  803b40:	c9                   	leaveq 
  803b41:	c3                   	retq   

0000000000803b42 <opencons>:

int
opencons(void)
{
  803b42:	55                   	push   %rbp
  803b43:	48 89 e5             	mov    %rsp,%rbp
  803b46:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b4a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b4e:	48 89 c7             	mov    %rax,%rdi
  803b51:	48 b8 bd 24 80 00 00 	movabs $0x8024bd,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
  803b5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b64:	79 05                	jns    803b6b <opencons+0x29>
		return r;
  803b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b69:	eb 5b                	jmp    803bc6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6f:	ba 07 04 00 00       	mov    $0x407,%edx
  803b74:	48 89 c6             	mov    %rax,%rsi
  803b77:	bf 00 00 00 00       	mov    $0x0,%edi
  803b7c:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
  803b88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8f:	79 05                	jns    803b96 <opencons+0x54>
		return r;
  803b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b94:	eb 30                	jmp    803bc6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9a:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ba1:	00 00 00 
  803ba4:	8b 12                	mov    (%rdx),%edx
  803ba6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ba8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bac:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb7:	48 89 c7             	mov    %rax,%rdi
  803bba:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
}
  803bc6:	c9                   	leaveq 
  803bc7:	c3                   	retq   

0000000000803bc8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bc8:	55                   	push   %rbp
  803bc9:	48 89 e5             	mov    %rsp,%rbp
  803bcc:	48 83 ec 30          	sub    $0x30,%rsp
  803bd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bdc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803be1:	75 07                	jne    803bea <devcons_read+0x22>
		return 0;
  803be3:	b8 00 00 00 00       	mov    $0x0,%eax
  803be8:	eb 4b                	jmp    803c35 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bea:	eb 0c                	jmp    803bf8 <devcons_read+0x30>
		sys_yield();
  803bec:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803bf3:	00 00 00 
  803bf6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bf8:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  803bff:	00 00 00 
  803c02:	ff d0                	callq  *%rax
  803c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0b:	74 df                	je     803bec <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c11:	79 05                	jns    803c18 <devcons_read+0x50>
		return c;
  803c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c16:	eb 1d                	jmp    803c35 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c18:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c1c:	75 07                	jne    803c25 <devcons_read+0x5d>
		return 0;
  803c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c23:	eb 10                	jmp    803c35 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c28:	89 c2                	mov    %eax,%edx
  803c2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c2e:	88 10                	mov    %dl,(%rax)
	return 1;
  803c30:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c35:	c9                   	leaveq 
  803c36:	c3                   	retq   

0000000000803c37 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c37:	55                   	push   %rbp
  803c38:	48 89 e5             	mov    %rsp,%rbp
  803c3b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c42:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c49:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c50:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c5e:	eb 76                	jmp    803cd6 <devcons_write+0x9f>
		m = n - tot;
  803c60:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c67:	89 c2                	mov    %eax,%edx
  803c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6c:	29 c2                	sub    %eax,%edx
  803c6e:	89 d0                	mov    %edx,%eax
  803c70:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c76:	83 f8 7f             	cmp    $0x7f,%eax
  803c79:	76 07                	jbe    803c82 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c7b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c85:	48 63 d0             	movslq %eax,%rdx
  803c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8b:	48 63 c8             	movslq %eax,%rcx
  803c8e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c95:	48 01 c1             	add    %rax,%rcx
  803c98:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c9f:	48 89 ce             	mov    %rcx,%rsi
  803ca2:	48 89 c7             	mov    %rax,%rdi
  803ca5:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb4:	48 63 d0             	movslq %eax,%rdx
  803cb7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cbe:	48 89 d6             	mov    %rdx,%rsi
  803cc1:	48 89 c7             	mov    %rax,%rdi
  803cc4:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd3:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd9:	48 98                	cltq   
  803cdb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ce2:	0f 82 78 ff ff ff    	jb     803c60 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ceb:	c9                   	leaveq 
  803cec:	c3                   	retq   

0000000000803ced <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ced:	55                   	push   %rbp
  803cee:	48 89 e5             	mov    %rsp,%rbp
  803cf1:	48 83 ec 08          	sub    $0x8,%rsp
  803cf5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cfe:	c9                   	leaveq 
  803cff:	c3                   	retq   

0000000000803d00 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d00:	55                   	push   %rbp
  803d01:	48 89 e5             	mov    %rsp,%rbp
  803d04:	48 83 ec 10          	sub    $0x10,%rsp
  803d08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d14:	48 be 52 49 80 00 00 	movabs $0x804952,%rsi
  803d1b:	00 00 00 
  803d1e:	48 89 c7             	mov    %rax,%rdi
  803d21:	48 b8 c9 12 80 00 00 	movabs $0x8012c9,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
	return 0;
  803d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d32:	c9                   	leaveq 
  803d33:	c3                   	retq   

0000000000803d34 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d34:	55                   	push   %rbp
  803d35:	48 89 e5             	mov    %rsp,%rbp
  803d38:	48 83 ec 10          	sub    $0x10,%rsp
  803d3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803d40:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d47:	00 00 00 
  803d4a:	48 8b 00             	mov    (%rax),%rax
  803d4d:	48 85 c0             	test   %rax,%rax
  803d50:	75 49                	jne    803d9b <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803d52:	ba 07 00 00 00       	mov    $0x7,%edx
  803d57:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d61:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  803d68:	00 00 00 
  803d6b:	ff d0                	callq  *%rax
  803d6d:	85 c0                	test   %eax,%eax
  803d6f:	79 2a                	jns    803d9b <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803d71:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  803d78:	00 00 00 
  803d7b:	be 21 00 00 00       	mov    $0x21,%esi
  803d80:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  803d87:	00 00 00 
  803d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8f:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  803d96:	00 00 00 
  803d99:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803d9b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803da2:	00 00 00 
  803da5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803da9:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803dac:	48 be f7 3d 80 00 00 	movabs $0x803df7,%rsi
  803db3:	00 00 00 
  803db6:	bf 00 00 00 00       	mov    $0x0,%edi
  803dbb:	48 b8 82 1d 80 00 00 	movabs $0x801d82,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
  803dc7:	85 c0                	test   %eax,%eax
  803dc9:	79 2a                	jns    803df5 <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803dcb:	48 ba a0 49 80 00 00 	movabs $0x8049a0,%rdx
  803dd2:	00 00 00 
  803dd5:	be 27 00 00 00       	mov    $0x27,%esi
  803dda:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  803de1:	00 00 00 
  803de4:	b8 00 00 00 00       	mov    $0x0,%eax
  803de9:	48 b9 c8 04 80 00 00 	movabs $0x8004c8,%rcx
  803df0:	00 00 00 
  803df3:	ff d1                	callq  *%rcx
}
  803df5:	c9                   	leaveq 
  803df6:	c3                   	retq   

0000000000803df7 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803df7:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803dfa:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803e01:	00 00 00 
call *%rax
  803e04:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803e06:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803e0d:	00 
    movq 152(%rsp), %rcx
  803e0e:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803e15:	00 
    subq $8, %rcx
  803e16:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803e1a:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803e1d:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803e24:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803e25:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803e29:	4c 8b 3c 24          	mov    (%rsp),%r15
  803e2d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803e32:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803e37:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e3c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e41:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e46:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e4b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e50:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e55:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e5a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e5f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e64:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e69:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e6e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e73:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  803e77:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  803e7b:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  803e7c:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  803e7d:	c3                   	retq   

0000000000803e7e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e7e:	55                   	push   %rbp
  803e7f:	48 89 e5             	mov    %rsp,%rbp
  803e82:	48 83 ec 30          	sub    $0x30,%rsp
  803e86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e8e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803e92:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e97:	75 0e                	jne    803ea7 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803e99:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ea0:	00 00 00 
  803ea3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803ea7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eab:	48 89 c7             	mov    %rax,%rdi
  803eae:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  803eb5:	00 00 00 
  803eb8:	ff d0                	callq  *%rax
  803eba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec1:	79 27                	jns    803eea <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803ec3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ec8:	74 0a                	je     803ed4 <ipc_recv+0x56>
            *from_env_store = 0;
  803eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ece:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803ed4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ed9:	74 0a                	je     803ee5 <ipc_recv+0x67>
            *perm_store = 0;
  803edb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803edf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee8:	eb 53                	jmp    803f3d <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803eea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803eef:	74 19                	je     803f0a <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803ef1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ef8:	00 00 00 
  803efb:	48 8b 00             	mov    (%rax),%rax
  803efe:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f08:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803f0a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f0f:	74 19                	je     803f2a <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803f11:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f18:	00 00 00 
  803f1b:	48 8b 00             	mov    (%rax),%rax
  803f1e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f28:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803f2a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f31:	00 00 00 
  803f34:	48 8b 00             	mov    (%rax),%rax
  803f37:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803f3d:	c9                   	leaveq 
  803f3e:	c3                   	retq   

0000000000803f3f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f3f:	55                   	push   %rbp
  803f40:	48 89 e5             	mov    %rsp,%rbp
  803f43:	48 83 ec 30          	sub    $0x30,%rsp
  803f47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f4a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f4d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f51:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803f54:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f59:	75 0e                	jne    803f69 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803f5b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f62:	00 00 00 
  803f65:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803f69:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f6c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f76:	89 c7                	mov    %eax,%edi
  803f78:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  803f7f:	00 00 00 
  803f82:	ff d0                	callq  *%rax
  803f84:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803f87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f8b:	79 36                	jns    803fc3 <ipc_send+0x84>
  803f8d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f91:	74 30                	je     803fc3 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803f93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f96:	89 c1                	mov    %eax,%ecx
  803f98:	48 ba d7 49 80 00 00 	movabs $0x8049d7,%rdx
  803f9f:	00 00 00 
  803fa2:	be 49 00 00 00       	mov    $0x49,%esi
  803fa7:	48 bf e4 49 80 00 00 	movabs $0x8049e4,%rdi
  803fae:	00 00 00 
  803fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb6:	49 b8 c8 04 80 00 00 	movabs $0x8004c8,%r8
  803fbd:	00 00 00 
  803fc0:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803fc3:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  803fca:	00 00 00 
  803fcd:	ff d0                	callq  *%rax
    } while(r != 0);
  803fcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd3:	75 94                	jne    803f69 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803fd5:	c9                   	leaveq 
  803fd6:	c3                   	retq   

0000000000803fd7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fd7:	55                   	push   %rbp
  803fd8:	48 89 e5             	mov    %rsp,%rbp
  803fdb:	48 83 ec 14          	sub    $0x14,%rsp
  803fdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fe9:	eb 5e                	jmp    804049 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803feb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ff2:	00 00 00 
  803ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff8:	48 63 d0             	movslq %eax,%rdx
  803ffb:	48 89 d0             	mov    %rdx,%rax
  803ffe:	48 c1 e0 03          	shl    $0x3,%rax
  804002:	48 01 d0             	add    %rdx,%rax
  804005:	48 c1 e0 05          	shl    $0x5,%rax
  804009:	48 01 c8             	add    %rcx,%rax
  80400c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804012:	8b 00                	mov    (%rax),%eax
  804014:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804017:	75 2c                	jne    804045 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804019:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804020:	00 00 00 
  804023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804026:	48 63 d0             	movslq %eax,%rdx
  804029:	48 89 d0             	mov    %rdx,%rax
  80402c:	48 c1 e0 03          	shl    $0x3,%rax
  804030:	48 01 d0             	add    %rdx,%rax
  804033:	48 c1 e0 05          	shl    $0x5,%rax
  804037:	48 01 c8             	add    %rcx,%rax
  80403a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804040:	8b 40 08             	mov    0x8(%rax),%eax
  804043:	eb 12                	jmp    804057 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804045:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804049:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804050:	7e 99                	jle    803feb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804057:	c9                   	leaveq 
  804058:	c3                   	retq   

0000000000804059 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804059:	55                   	push   %rbp
  80405a:	48 89 e5             	mov    %rsp,%rbp
  80405d:	48 83 ec 18          	sub    $0x18,%rsp
  804061:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804069:	48 c1 e8 15          	shr    $0x15,%rax
  80406d:	48 89 c2             	mov    %rax,%rdx
  804070:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804077:	01 00 00 
  80407a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80407e:	83 e0 01             	and    $0x1,%eax
  804081:	48 85 c0             	test   %rax,%rax
  804084:	75 07                	jne    80408d <pageref+0x34>
		return 0;
  804086:	b8 00 00 00 00       	mov    $0x0,%eax
  80408b:	eb 53                	jmp    8040e0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80408d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804091:	48 c1 e8 0c          	shr    $0xc,%rax
  804095:	48 89 c2             	mov    %rax,%rdx
  804098:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80409f:	01 00 00 
  8040a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ae:	83 e0 01             	and    $0x1,%eax
  8040b1:	48 85 c0             	test   %rax,%rax
  8040b4:	75 07                	jne    8040bd <pageref+0x64>
		return 0;
  8040b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bb:	eb 23                	jmp    8040e0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c1:	48 c1 e8 0c          	shr    $0xc,%rax
  8040c5:	48 89 c2             	mov    %rax,%rdx
  8040c8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040cf:	00 00 00 
  8040d2:	48 c1 e2 04          	shl    $0x4,%rdx
  8040d6:	48 01 d0             	add    %rdx,%rax
  8040d9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040dd:	0f b7 c0             	movzwl %ax,%eax
}
  8040e0:	c9                   	leaveq 
  8040e1:	c3                   	retq   
