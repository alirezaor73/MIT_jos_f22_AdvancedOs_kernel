
obj/user/testshell:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf 60 4d 80 00 00 	movabs $0x804d60,%rdi
  800098:	00 00 00 
  80009b:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba 6d 4d 80 00 00 	movabs $0x804d6d,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 44 43 80 00 00 	movabs $0x804344,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba 94 4d 80 00 00 	movabs $0x804d94,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf a0 4d 80 00 00 	movabs $0x804da0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba c4 4d 80 00 00 	movabs $0x804dc4,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 00 2c 80 00 00 	movabs $0x802c00,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 00 2c 80 00 00 	movabs $0x802c00,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba cd 4d 80 00 00 	movabs $0x804dcd,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be d0 4d 80 00 00 	movabs $0x804dd0,%rsi
  800200:	00 00 00 
  800203:	48 bf d3 4d 80 00 00 	movabs $0x804dd3,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 35 3c 80 00 00 	movabs $0x803c35,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba db 4d 80 00 00 	movabs $0x804ddb,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 0d 49 80 00 00 	movabs $0x80490d,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 c7 08 80 00 00 	movabs $0x8008c7,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba f8 4d 80 00 00 	movabs $0x804df8,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 1b 4e 80 00 00 	movabs $0x804e1b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba 35 4e 80 00 00 	movabs $0x804e35,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf 4f 4e 80 00 00 	movabs $0x804e4f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 c7 2f 80 00 00 	movabs $0x802fc7,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 c7 2f 80 00 00 	movabs $0x802fc7,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf 68 4e 80 00 00 	movabs $0x804e68,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf 8a 4e 80 00 00 	movabs $0x804e8a,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf 99 4e 80 00 00 	movabs $0x804e99,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf a7 4e 80 00 00 	movabs $0x804ea7,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 c7 08 80 00 00 	movabs $0x8008c7,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 91 28 80 00 00 	movabs $0x802891,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 1c 1f 80 00 00 	movabs $0x801f1c,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be b1 4e 80 00 00 	movabs $0x804eb1,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 20          	sub    $0x20,%rsp
  80083e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800841:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800845:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800854:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800857:	25 ff 03 00 00       	and    $0x3ff,%eax
  80085c:	48 63 d0             	movslq %eax,%rdx
  80085f:	48 89 d0             	mov    %rdx,%rax
  800862:	48 c1 e0 03          	shl    $0x3,%rax
  800866:	48 01 d0             	add    %rdx,%rax
  800869:	48 c1 e0 05          	shl    $0x5,%rax
  80086d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800874:	00 00 00 
  800877:	48 01 c2             	add    %rax,%rdx
  80087a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800881:	00 00 00 
  800884:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800887:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80088b:	7e 14                	jle    8008a1 <libmain+0x6b>
		binaryname = argv[0];
  80088d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800891:	48 8b 10             	mov    (%rax),%rdx
  800894:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80089b:	00 00 00 
  80089e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8008a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008a8:	48 89 d6             	mov    %rdx,%rsi
  8008ab:	89 c7                	mov    %eax,%edi
  8008ad:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008b4:	00 00 00 
  8008b7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008b9:	48 b8 c7 08 80 00 00 	movabs $0x8008c7,%rax
  8008c0:	00 00 00 
  8008c3:	ff d0                	callq  *%rax
}
  8008c5:	c9                   	leaveq 
  8008c6:	c3                   	retq   

00000000008008c7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008c7:	55                   	push   %rbp
  8008c8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008cb:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  8008d2:	00 00 00 
  8008d5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8008dc:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  8008e3:	00 00 00 
  8008e6:	ff d0                	callq  *%rax
}
  8008e8:	5d                   	pop    %rbp
  8008e9:	c3                   	retq   

00000000008008ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008ea:	55                   	push   %rbp
  8008eb:	48 89 e5             	mov    %rsp,%rbp
  8008ee:	53                   	push   %rbx
  8008ef:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008f6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008fd:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800903:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80090a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800911:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800918:	84 c0                	test   %al,%al
  80091a:	74 23                	je     80093f <_panic+0x55>
  80091c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800923:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800927:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80092b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80092f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800933:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800937:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80093b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80093f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800946:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80094d:	00 00 00 
  800950:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800957:	00 00 00 
  80095a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80095e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800965:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80096c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800973:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80097a:	00 00 00 
  80097d:	48 8b 18             	mov    (%rax),%rbx
  800980:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  800987:	00 00 00 
  80098a:	ff d0                	callq  *%rax
  80098c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800992:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800999:	41 89 c8             	mov    %ecx,%r8d
  80099c:	48 89 d1             	mov    %rdx,%rcx
  80099f:	48 89 da             	mov    %rbx,%rdx
  8009a2:	89 c6                	mov    %eax,%esi
  8009a4:	48 bf c8 4e 80 00 00 	movabs $0x804ec8,%rdi
  8009ab:	00 00 00 
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b3:	49 b9 23 0b 80 00 00 	movabs $0x800b23,%r9
  8009ba:	00 00 00 
  8009bd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009c0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009c7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009ce:	48 89 d6             	mov    %rdx,%rsi
  8009d1:	48 89 c7             	mov    %rax,%rdi
  8009d4:	48 b8 77 0a 80 00 00 	movabs $0x800a77,%rax
  8009db:	00 00 00 
  8009de:	ff d0                	callq  *%rax
	cprintf("\n");
  8009e0:	48 bf eb 4e 80 00 00 	movabs $0x804eeb,%rdi
  8009e7:	00 00 00 
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ef:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  8009f6:	00 00 00 
  8009f9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009fb:	cc                   	int3   
  8009fc:	eb fd                	jmp    8009fb <_panic+0x111>

00000000008009fe <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009fe:	55                   	push   %rbp
  8009ff:	48 89 e5             	mov    %rsp,%rbp
  800a02:	48 83 ec 10          	sub    $0x10,%rsp
  800a06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a11:	8b 00                	mov    (%rax),%eax
  800a13:	8d 48 01             	lea    0x1(%rax),%ecx
  800a16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a1a:	89 0a                	mov    %ecx,(%rdx)
  800a1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a1f:	89 d1                	mov    %edx,%ecx
  800a21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a25:	48 98                	cltq   
  800a27:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2f:	8b 00                	mov    (%rax),%eax
  800a31:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a36:	75 2c                	jne    800a64 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a3c:	8b 00                	mov    (%rax),%eax
  800a3e:	48 98                	cltq   
  800a40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a44:	48 83 c2 08          	add    $0x8,%rdx
  800a48:	48 89 c6             	mov    %rax,%rsi
  800a4b:	48 89 d7             	mov    %rdx,%rdi
  800a4e:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  800a55:	00 00 00 
  800a58:	ff d0                	callq  *%rax
        b->idx = 0;
  800a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a68:	8b 40 04             	mov    0x4(%rax),%eax
  800a6b:	8d 50 01             	lea    0x1(%rax),%edx
  800a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a72:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a75:	c9                   	leaveq 
  800a76:	c3                   	retq   

0000000000800a77 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a77:	55                   	push   %rbp
  800a78:	48 89 e5             	mov    %rsp,%rbp
  800a7b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a82:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a89:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a90:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a97:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a9e:	48 8b 0a             	mov    (%rdx),%rcx
  800aa1:	48 89 08             	mov    %rcx,(%rax)
  800aa4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800aa8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aac:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ab0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ab4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800abb:	00 00 00 
    b.cnt = 0;
  800abe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ac5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ac8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800acf:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ad6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800add:	48 89 c6             	mov    %rax,%rsi
  800ae0:	48 bf fe 09 80 00 00 	movabs $0x8009fe,%rdi
  800ae7:	00 00 00 
  800aea:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  800af1:	00 00 00 
  800af4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800af6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800afc:	48 98                	cltq   
  800afe:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b05:	48 83 c2 08          	add    $0x8,%rdx
  800b09:	48 89 c6             	mov    %rax,%rsi
  800b0c:	48 89 d7             	mov    %rdx,%rdi
  800b0f:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  800b16:	00 00 00 
  800b19:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800b1b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b21:	c9                   	leaveq 
  800b22:	c3                   	retq   

0000000000800b23 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800b23:	55                   	push   %rbp
  800b24:	48 89 e5             	mov    %rsp,%rbp
  800b27:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b2e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b35:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b3c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b43:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b4a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b51:	84 c0                	test   %al,%al
  800b53:	74 20                	je     800b75 <cprintf+0x52>
  800b55:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b59:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b5d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b61:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b65:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b69:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b6d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b71:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b75:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b7c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b83:	00 00 00 
  800b86:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b8d:	00 00 00 
  800b90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b94:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b9b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800ba9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800bb0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bb7:	48 8b 0a             	mov    (%rdx),%rcx
  800bba:	48 89 08             	mov    %rcx,(%rax)
  800bbd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bc1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bc5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800bcd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bd4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bdb:	48 89 d6             	mov    %rdx,%rsi
  800bde:	48 89 c7             	mov    %rax,%rdi
  800be1:	48 b8 77 0a 80 00 00 	movabs $0x800a77,%rax
  800be8:	00 00 00 
  800beb:	ff d0                	callq  *%rax
  800bed:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800bf3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bf9:	c9                   	leaveq 
  800bfa:	c3                   	retq   

0000000000800bfb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bfb:	55                   	push   %rbp
  800bfc:	48 89 e5             	mov    %rsp,%rbp
  800bff:	53                   	push   %rbx
  800c00:	48 83 ec 38          	sub    $0x38,%rsp
  800c04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c10:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c13:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c17:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c1b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c1e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c22:	77 3b                	ja     800c5f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c24:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c27:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c2b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	48 f7 f3             	div    %rbx
  800c3a:	48 89 c2             	mov    %rax,%rdx
  800c3d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c40:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c43:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4b:	41 89 f9             	mov    %edi,%r9d
  800c4e:	48 89 c7             	mov    %rax,%rdi
  800c51:	48 b8 fb 0b 80 00 00 	movabs $0x800bfb,%rax
  800c58:	00 00 00 
  800c5b:	ff d0                	callq  *%rax
  800c5d:	eb 1e                	jmp    800c7d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5f:	eb 12                	jmp    800c73 <printnum+0x78>
			putch(padc, putdat);
  800c61:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c65:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6c:	48 89 ce             	mov    %rcx,%rsi
  800c6f:	89 d7                	mov    %edx,%edi
  800c71:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c73:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c77:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c7b:	7f e4                	jg     800c61 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c7d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
  800c89:	48 f7 f1             	div    %rcx
  800c8c:	48 89 d0             	mov    %rdx,%rax
  800c8f:	48 ba f0 50 80 00 00 	movabs $0x8050f0,%rdx
  800c96:	00 00 00 
  800c99:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c9d:	0f be d0             	movsbl %al,%edx
  800ca0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca8:	48 89 ce             	mov    %rcx,%rsi
  800cab:	89 d7                	mov    %edx,%edi
  800cad:	ff d0                	callq  *%rax
}
  800caf:	48 83 c4 38          	add    $0x38,%rsp
  800cb3:	5b                   	pop    %rbx
  800cb4:	5d                   	pop    %rbp
  800cb5:	c3                   	retq   

0000000000800cb6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb6:	55                   	push   %rbp
  800cb7:	48 89 e5             	mov    %rsp,%rbp
  800cba:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cc2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800cc5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cc9:	7e 52                	jle    800d1d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccf:	8b 00                	mov    (%rax),%eax
  800cd1:	83 f8 30             	cmp    $0x30,%eax
  800cd4:	73 24                	jae    800cfa <getuint+0x44>
  800cd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cda:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce2:	8b 00                	mov    (%rax),%eax
  800ce4:	89 c0                	mov    %eax,%eax
  800ce6:	48 01 d0             	add    %rdx,%rax
  800ce9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ced:	8b 12                	mov    (%rdx),%edx
  800cef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cf2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf6:	89 0a                	mov    %ecx,(%rdx)
  800cf8:	eb 17                	jmp    800d11 <getuint+0x5b>
  800cfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d02:	48 89 d0             	mov    %rdx,%rax
  800d05:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d11:	48 8b 00             	mov    (%rax),%rax
  800d14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d18:	e9 a3 00 00 00       	jmpq   800dc0 <getuint+0x10a>
	else if (lflag)
  800d1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d21:	74 4f                	je     800d72 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d27:	8b 00                	mov    (%rax),%eax
  800d29:	83 f8 30             	cmp    $0x30,%eax
  800d2c:	73 24                	jae    800d52 <getuint+0x9c>
  800d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d32:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3a:	8b 00                	mov    (%rax),%eax
  800d3c:	89 c0                	mov    %eax,%eax
  800d3e:	48 01 d0             	add    %rdx,%rax
  800d41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d45:	8b 12                	mov    (%rdx),%edx
  800d47:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4e:	89 0a                	mov    %ecx,(%rdx)
  800d50:	eb 17                	jmp    800d69 <getuint+0xb3>
  800d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d56:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d5a:	48 89 d0             	mov    %rdx,%rax
  800d5d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d65:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d69:	48 8b 00             	mov    (%rax),%rax
  800d6c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d70:	eb 4e                	jmp    800dc0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d76:	8b 00                	mov    (%rax),%eax
  800d78:	83 f8 30             	cmp    $0x30,%eax
  800d7b:	73 24                	jae    800da1 <getuint+0xeb>
  800d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d81:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d89:	8b 00                	mov    (%rax),%eax
  800d8b:	89 c0                	mov    %eax,%eax
  800d8d:	48 01 d0             	add    %rdx,%rax
  800d90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d94:	8b 12                	mov    (%rdx),%edx
  800d96:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9d:	89 0a                	mov    %ecx,(%rdx)
  800d9f:	eb 17                	jmp    800db8 <getuint+0x102>
  800da1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800da9:	48 89 d0             	mov    %rdx,%rax
  800dac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800db0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800db8:	8b 00                	mov    (%rax),%eax
  800dba:	89 c0                	mov    %eax,%eax
  800dbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dc4:	c9                   	leaveq 
  800dc5:	c3                   	retq   

0000000000800dc6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc6:	55                   	push   %rbp
  800dc7:	48 89 e5             	mov    %rsp,%rbp
  800dca:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dd2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dd5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dd9:	7e 52                	jle    800e2d <getint+0x67>
		x=va_arg(*ap, long long);
  800ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddf:	8b 00                	mov    (%rax),%eax
  800de1:	83 f8 30             	cmp    $0x30,%eax
  800de4:	73 24                	jae    800e0a <getint+0x44>
  800de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df2:	8b 00                	mov    (%rax),%eax
  800df4:	89 c0                	mov    %eax,%eax
  800df6:	48 01 d0             	add    %rdx,%rax
  800df9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dfd:	8b 12                	mov    (%rdx),%edx
  800dff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e06:	89 0a                	mov    %ecx,(%rdx)
  800e08:	eb 17                	jmp    800e21 <getint+0x5b>
  800e0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e12:	48 89 d0             	mov    %rdx,%rax
  800e15:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e21:	48 8b 00             	mov    (%rax),%rax
  800e24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e28:	e9 a3 00 00 00       	jmpq   800ed0 <getint+0x10a>
	else if (lflag)
  800e2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e31:	74 4f                	je     800e82 <getint+0xbc>
		x=va_arg(*ap, long);
  800e33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e37:	8b 00                	mov    (%rax),%eax
  800e39:	83 f8 30             	cmp    $0x30,%eax
  800e3c:	73 24                	jae    800e62 <getint+0x9c>
  800e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e42:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	8b 00                	mov    (%rax),%eax
  800e4c:	89 c0                	mov    %eax,%eax
  800e4e:	48 01 d0             	add    %rdx,%rax
  800e51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e55:	8b 12                	mov    (%rdx),%edx
  800e57:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5e:	89 0a                	mov    %ecx,(%rdx)
  800e60:	eb 17                	jmp    800e79 <getint+0xb3>
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e6a:	48 89 d0             	mov    %rdx,%rax
  800e6d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e75:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e79:	48 8b 00             	mov    (%rax),%rax
  800e7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e80:	eb 4e                	jmp    800ed0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	8b 00                	mov    (%rax),%eax
  800e88:	83 f8 30             	cmp    $0x30,%eax
  800e8b:	73 24                	jae    800eb1 <getint+0xeb>
  800e8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e91:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e99:	8b 00                	mov    (%rax),%eax
  800e9b:	89 c0                	mov    %eax,%eax
  800e9d:	48 01 d0             	add    %rdx,%rax
  800ea0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea4:	8b 12                	mov    (%rdx),%edx
  800ea6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ea9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ead:	89 0a                	mov    %ecx,(%rdx)
  800eaf:	eb 17                	jmp    800ec8 <getint+0x102>
  800eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eb9:	48 89 d0             	mov    %rdx,%rax
  800ebc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ec0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ec8:	8b 00                	mov    (%rax),%eax
  800eca:	48 98                	cltq   
  800ecc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ed0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ed4:	c9                   	leaveq 
  800ed5:	c3                   	retq   

0000000000800ed6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed6:	55                   	push   %rbp
  800ed7:	48 89 e5             	mov    %rsp,%rbp
  800eda:	41 54                	push   %r12
  800edc:	53                   	push   %rbx
  800edd:	48 83 ec 60          	sub    $0x60,%rsp
  800ee1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ee5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ee9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800eed:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ef1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ef9:	48 8b 0a             	mov    (%rdx),%rcx
  800efc:	48 89 08             	mov    %rcx,(%rax)
  800eff:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f03:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f07:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f0b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f0f:	eb 17                	jmp    800f28 <vprintfmt+0x52>
			if (ch == '\0')
  800f11:	85 db                	test   %ebx,%ebx
  800f13:	0f 84 df 04 00 00    	je     8013f8 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800f19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f21:	48 89 d6             	mov    %rdx,%rsi
  800f24:	89 df                	mov    %ebx,%edi
  800f26:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f28:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f2c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f30:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f34:	0f b6 00             	movzbl (%rax),%eax
  800f37:	0f b6 d8             	movzbl %al,%ebx
  800f3a:	83 fb 25             	cmp    $0x25,%ebx
  800f3d:	75 d2                	jne    800f11 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f3f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f43:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f4a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f51:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f58:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f5f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f63:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f67:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f6b:	0f b6 00             	movzbl (%rax),%eax
  800f6e:	0f b6 d8             	movzbl %al,%ebx
  800f71:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f74:	83 f8 55             	cmp    $0x55,%eax
  800f77:	0f 87 47 04 00 00    	ja     8013c4 <vprintfmt+0x4ee>
  800f7d:	89 c0                	mov    %eax,%eax
  800f7f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f86:	00 
  800f87:	48 b8 18 51 80 00 00 	movabs $0x805118,%rax
  800f8e:	00 00 00 
  800f91:	48 01 d0             	add    %rdx,%rax
  800f94:	48 8b 00             	mov    (%rax),%rax
  800f97:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f99:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f9d:	eb c0                	jmp    800f5f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f9f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800fa3:	eb ba                	jmp    800f5f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fa5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fac:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800faf:	89 d0                	mov    %edx,%eax
  800fb1:	c1 e0 02             	shl    $0x2,%eax
  800fb4:	01 d0                	add    %edx,%eax
  800fb6:	01 c0                	add    %eax,%eax
  800fb8:	01 d8                	add    %ebx,%eax
  800fba:	83 e8 30             	sub    $0x30,%eax
  800fbd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fc0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fc4:	0f b6 00             	movzbl (%rax),%eax
  800fc7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fca:	83 fb 2f             	cmp    $0x2f,%ebx
  800fcd:	7e 0c                	jle    800fdb <vprintfmt+0x105>
  800fcf:	83 fb 39             	cmp    $0x39,%ebx
  800fd2:	7f 07                	jg     800fdb <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fd4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fd9:	eb d1                	jmp    800fac <vprintfmt+0xd6>
			goto process_precision;
  800fdb:	eb 58                	jmp    801035 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800fdd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fe0:	83 f8 30             	cmp    $0x30,%eax
  800fe3:	73 17                	jae    800ffc <vprintfmt+0x126>
  800fe5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fe9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fec:	89 c0                	mov    %eax,%eax
  800fee:	48 01 d0             	add    %rdx,%rax
  800ff1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ff4:	83 c2 08             	add    $0x8,%edx
  800ff7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ffa:	eb 0f                	jmp    80100b <vprintfmt+0x135>
  800ffc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801000:	48 89 d0             	mov    %rdx,%rax
  801003:	48 83 c2 08          	add    $0x8,%rdx
  801007:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80100b:	8b 00                	mov    (%rax),%eax
  80100d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801010:	eb 23                	jmp    801035 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801012:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801016:	79 0c                	jns    801024 <vprintfmt+0x14e>
				width = 0;
  801018:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80101f:	e9 3b ff ff ff       	jmpq   800f5f <vprintfmt+0x89>
  801024:	e9 36 ff ff ff       	jmpq   800f5f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801029:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801030:	e9 2a ff ff ff       	jmpq   800f5f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801035:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801039:	79 12                	jns    80104d <vprintfmt+0x177>
				width = precision, precision = -1;
  80103b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80103e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801041:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801048:	e9 12 ff ff ff       	jmpq   800f5f <vprintfmt+0x89>
  80104d:	e9 0d ff ff ff       	jmpq   800f5f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801052:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801056:	e9 04 ff ff ff       	jmpq   800f5f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80105b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80105e:	83 f8 30             	cmp    $0x30,%eax
  801061:	73 17                	jae    80107a <vprintfmt+0x1a4>
  801063:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801067:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80106a:	89 c0                	mov    %eax,%eax
  80106c:	48 01 d0             	add    %rdx,%rax
  80106f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801072:	83 c2 08             	add    $0x8,%edx
  801075:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801078:	eb 0f                	jmp    801089 <vprintfmt+0x1b3>
  80107a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80107e:	48 89 d0             	mov    %rdx,%rax
  801081:	48 83 c2 08          	add    $0x8,%rdx
  801085:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801089:	8b 10                	mov    (%rax),%edx
  80108b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80108f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801093:	48 89 ce             	mov    %rcx,%rsi
  801096:	89 d7                	mov    %edx,%edi
  801098:	ff d0                	callq  *%rax
			break;
  80109a:	e9 53 03 00 00       	jmpq   8013f2 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80109f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010a2:	83 f8 30             	cmp    $0x30,%eax
  8010a5:	73 17                	jae    8010be <vprintfmt+0x1e8>
  8010a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ae:	89 c0                	mov    %eax,%eax
  8010b0:	48 01 d0             	add    %rdx,%rax
  8010b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010b6:	83 c2 08             	add    $0x8,%edx
  8010b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010bc:	eb 0f                	jmp    8010cd <vprintfmt+0x1f7>
  8010be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010c2:	48 89 d0             	mov    %rdx,%rax
  8010c5:	48 83 c2 08          	add    $0x8,%rdx
  8010c9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010cd:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010cf:	85 db                	test   %ebx,%ebx
  8010d1:	79 02                	jns    8010d5 <vprintfmt+0x1ff>
				err = -err;
  8010d3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010d5:	83 fb 15             	cmp    $0x15,%ebx
  8010d8:	7f 16                	jg     8010f0 <vprintfmt+0x21a>
  8010da:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  8010e1:	00 00 00 
  8010e4:	48 63 d3             	movslq %ebx,%rdx
  8010e7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8010eb:	4d 85 e4             	test   %r12,%r12
  8010ee:	75 2e                	jne    80111e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8010f0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f8:	89 d9                	mov    %ebx,%ecx
  8010fa:	48 ba 01 51 80 00 00 	movabs $0x805101,%rdx
  801101:	00 00 00 
  801104:	48 89 c7             	mov    %rax,%rdi
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
  80110c:	49 b8 01 14 80 00 00 	movabs $0x801401,%r8
  801113:	00 00 00 
  801116:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801119:	e9 d4 02 00 00       	jmpq   8013f2 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80111e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801122:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801126:	4c 89 e1             	mov    %r12,%rcx
  801129:	48 ba 0a 51 80 00 00 	movabs $0x80510a,%rdx
  801130:	00 00 00 
  801133:	48 89 c7             	mov    %rax,%rdi
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
  80113b:	49 b8 01 14 80 00 00 	movabs $0x801401,%r8
  801142:	00 00 00 
  801145:	41 ff d0             	callq  *%r8
			break;
  801148:	e9 a5 02 00 00       	jmpq   8013f2 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80114d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801150:	83 f8 30             	cmp    $0x30,%eax
  801153:	73 17                	jae    80116c <vprintfmt+0x296>
  801155:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801159:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80115c:	89 c0                	mov    %eax,%eax
  80115e:	48 01 d0             	add    %rdx,%rax
  801161:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801164:	83 c2 08             	add    $0x8,%edx
  801167:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80116a:	eb 0f                	jmp    80117b <vprintfmt+0x2a5>
  80116c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801170:	48 89 d0             	mov    %rdx,%rax
  801173:	48 83 c2 08          	add    $0x8,%rdx
  801177:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80117b:	4c 8b 20             	mov    (%rax),%r12
  80117e:	4d 85 e4             	test   %r12,%r12
  801181:	75 0a                	jne    80118d <vprintfmt+0x2b7>
				p = "(null)";
  801183:	49 bc 0d 51 80 00 00 	movabs $0x80510d,%r12
  80118a:	00 00 00 
			if (width > 0 && padc != '-')
  80118d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801191:	7e 3f                	jle    8011d2 <vprintfmt+0x2fc>
  801193:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801197:	74 39                	je     8011d2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801199:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80119c:	48 98                	cltq   
  80119e:	48 89 c6             	mov    %rax,%rsi
  8011a1:	4c 89 e7             	mov    %r12,%rdi
  8011a4:	48 b8 ad 16 80 00 00 	movabs $0x8016ad,%rax
  8011ab:	00 00 00 
  8011ae:	ff d0                	callq  *%rax
  8011b0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011b3:	eb 17                	jmp    8011cc <vprintfmt+0x2f6>
					putch(padc, putdat);
  8011b5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011b9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011c1:	48 89 ce             	mov    %rcx,%rsi
  8011c4:	89 d7                	mov    %edx,%edi
  8011c6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011c8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011d0:	7f e3                	jg     8011b5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011d2:	eb 37                	jmp    80120b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8011d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011d8:	74 1e                	je     8011f8 <vprintfmt+0x322>
  8011da:	83 fb 1f             	cmp    $0x1f,%ebx
  8011dd:	7e 05                	jle    8011e4 <vprintfmt+0x30e>
  8011df:	83 fb 7e             	cmp    $0x7e,%ebx
  8011e2:	7e 14                	jle    8011f8 <vprintfmt+0x322>
					putch('?', putdat);
  8011e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ec:	48 89 d6             	mov    %rdx,%rsi
  8011ef:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8011f4:	ff d0                	callq  *%rax
  8011f6:	eb 0f                	jmp    801207 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8011f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801200:	48 89 d6             	mov    %rdx,%rsi
  801203:	89 df                	mov    %ebx,%edi
  801205:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801207:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80120b:	4c 89 e0             	mov    %r12,%rax
  80120e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801212:	0f b6 00             	movzbl (%rax),%eax
  801215:	0f be d8             	movsbl %al,%ebx
  801218:	85 db                	test   %ebx,%ebx
  80121a:	74 10                	je     80122c <vprintfmt+0x356>
  80121c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801220:	78 b2                	js     8011d4 <vprintfmt+0x2fe>
  801222:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801226:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80122a:	79 a8                	jns    8011d4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80122c:	eb 16                	jmp    801244 <vprintfmt+0x36e>
				putch(' ', putdat);
  80122e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801232:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801236:	48 89 d6             	mov    %rdx,%rsi
  801239:	bf 20 00 00 00       	mov    $0x20,%edi
  80123e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801240:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801244:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801248:	7f e4                	jg     80122e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80124a:	e9 a3 01 00 00       	jmpq   8013f2 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80124f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801253:	be 03 00 00 00       	mov    $0x3,%esi
  801258:	48 89 c7             	mov    %rax,%rdi
  80125b:	48 b8 c6 0d 80 00 00 	movabs $0x800dc6,%rax
  801262:	00 00 00 
  801265:	ff d0                	callq  *%rax
  801267:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126f:	48 85 c0             	test   %rax,%rax
  801272:	79 1d                	jns    801291 <vprintfmt+0x3bb>
				putch('-', putdat);
  801274:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801278:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80127c:	48 89 d6             	mov    %rdx,%rsi
  80127f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801284:	ff d0                	callq  *%rax
				num = -(long long) num;
  801286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128a:	48 f7 d8             	neg    %rax
  80128d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801291:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801298:	e9 e8 00 00 00       	jmpq   801385 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80129d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012a1:	be 03 00 00 00       	mov    $0x3,%esi
  8012a6:	48 89 c7             	mov    %rax,%rdi
  8012a9:	48 b8 b6 0c 80 00 00 	movabs $0x800cb6,%rax
  8012b0:	00 00 00 
  8012b3:	ff d0                	callq  *%rax
  8012b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012b9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012c0:	e9 c0 00 00 00       	jmpq   801385 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8012c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012cd:	48 89 d6             	mov    %rdx,%rsi
  8012d0:	bf 58 00 00 00       	mov    $0x58,%edi
  8012d5:	ff d0                	callq  *%rax
			putch('X', putdat);
  8012d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012df:	48 89 d6             	mov    %rdx,%rsi
  8012e2:	bf 58 00 00 00       	mov    $0x58,%edi
  8012e7:	ff d0                	callq  *%rax
			putch('X', putdat);
  8012e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f1:	48 89 d6             	mov    %rdx,%rsi
  8012f4:	bf 58 00 00 00       	mov    $0x58,%edi
  8012f9:	ff d0                	callq  *%rax
			break;
  8012fb:	e9 f2 00 00 00       	jmpq   8013f2 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  801300:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801304:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801308:	48 89 d6             	mov    %rdx,%rsi
  80130b:	bf 30 00 00 00       	mov    $0x30,%edi
  801310:	ff d0                	callq  *%rax
			putch('x', putdat);
  801312:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801316:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80131a:	48 89 d6             	mov    %rdx,%rsi
  80131d:	bf 78 00 00 00       	mov    $0x78,%edi
  801322:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801324:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801327:	83 f8 30             	cmp    $0x30,%eax
  80132a:	73 17                	jae    801343 <vprintfmt+0x46d>
  80132c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801330:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801333:	89 c0                	mov    %eax,%eax
  801335:	48 01 d0             	add    %rdx,%rax
  801338:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80133b:	83 c2 08             	add    $0x8,%edx
  80133e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801341:	eb 0f                	jmp    801352 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  801343:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801347:	48 89 d0             	mov    %rdx,%rax
  80134a:	48 83 c2 08          	add    $0x8,%rdx
  80134e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801352:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801355:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801359:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801360:	eb 23                	jmp    801385 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801362:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801366:	be 03 00 00 00       	mov    $0x3,%esi
  80136b:	48 89 c7             	mov    %rax,%rdi
  80136e:	48 b8 b6 0c 80 00 00 	movabs $0x800cb6,%rax
  801375:	00 00 00 
  801378:	ff d0                	callq  *%rax
  80137a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80137e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801385:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80138a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80138d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801390:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801394:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801398:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80139c:	45 89 c1             	mov    %r8d,%r9d
  80139f:	41 89 f8             	mov    %edi,%r8d
  8013a2:	48 89 c7             	mov    %rax,%rdi
  8013a5:	48 b8 fb 0b 80 00 00 	movabs $0x800bfb,%rax
  8013ac:	00 00 00 
  8013af:	ff d0                	callq  *%rax
			break;
  8013b1:	eb 3f                	jmp    8013f2 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8013b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013bb:	48 89 d6             	mov    %rdx,%rsi
  8013be:	89 df                	mov    %ebx,%edi
  8013c0:	ff d0                	callq  *%rax
			break;
  8013c2:	eb 2e                	jmp    8013f2 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013cc:	48 89 d6             	mov    %rdx,%rsi
  8013cf:	bf 25 00 00 00       	mov    $0x25,%edi
  8013d4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013d6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013db:	eb 05                	jmp    8013e2 <vprintfmt+0x50c>
  8013dd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013e6:	48 83 e8 01          	sub    $0x1,%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	3c 25                	cmp    $0x25,%al
  8013ef:	75 ec                	jne    8013dd <vprintfmt+0x507>
				/* do nothing */;
			break;
  8013f1:	90                   	nop
		}
	}
  8013f2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013f3:	e9 30 fb ff ff       	jmpq   800f28 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8013f8:	48 83 c4 60          	add    $0x60,%rsp
  8013fc:	5b                   	pop    %rbx
  8013fd:	41 5c                	pop    %r12
  8013ff:	5d                   	pop    %rbp
  801400:	c3                   	retq   

0000000000801401 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80140c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801413:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80141a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801421:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801428:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80142f:	84 c0                	test   %al,%al
  801431:	74 20                	je     801453 <printfmt+0x52>
  801433:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801437:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80143b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80143f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801443:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801447:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80144b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80144f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801453:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80145a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801461:	00 00 00 
  801464:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80146b:	00 00 00 
  80146e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801472:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801479:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801480:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801487:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80148e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801495:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80149c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014a3:	48 89 c7             	mov    %rax,%rdi
  8014a6:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  8014ad:	00 00 00 
  8014b0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8014b2:	c9                   	leaveq 
  8014b3:	c3                   	retq   

00000000008014b4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014b4:	55                   	push   %rbp
  8014b5:	48 89 e5             	mov    %rsp,%rbp
  8014b8:	48 83 ec 10          	sub    $0x10,%rsp
  8014bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c7:	8b 40 10             	mov    0x10(%rax),%eax
  8014ca:	8d 50 01             	lea    0x1(%rax),%edx
  8014cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d8:	48 8b 10             	mov    (%rax),%rdx
  8014db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014df:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014e3:	48 39 c2             	cmp    %rax,%rdx
  8014e6:	73 17                	jae    8014ff <sprintputch+0x4b>
		*b->buf++ = ch;
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	48 8b 00             	mov    (%rax),%rax
  8014ef:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8014f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014f7:	48 89 0a             	mov    %rcx,(%rdx)
  8014fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8014fd:	88 10                	mov    %dl,(%rax)
}
  8014ff:	c9                   	leaveq 
  801500:	c3                   	retq   

0000000000801501 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801501:	55                   	push   %rbp
  801502:	48 89 e5             	mov    %rsp,%rbp
  801505:	48 83 ec 50          	sub    $0x50,%rsp
  801509:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80150d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801510:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801514:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801518:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80151c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801520:	48 8b 0a             	mov    (%rdx),%rcx
  801523:	48 89 08             	mov    %rcx,(%rax)
  801526:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80152a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80152e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801532:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801536:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80153a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80153e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801541:	48 98                	cltq   
  801543:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801547:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80154b:	48 01 d0             	add    %rdx,%rax
  80154e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801552:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801559:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80155e:	74 06                	je     801566 <vsnprintf+0x65>
  801560:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801564:	7f 07                	jg     80156d <vsnprintf+0x6c>
		return -E_INVAL;
  801566:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156b:	eb 2f                	jmp    80159c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80156d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801571:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801575:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801579:	48 89 c6             	mov    %rax,%rsi
  80157c:	48 bf b4 14 80 00 00 	movabs $0x8014b4,%rdi
  801583:	00 00 00 
  801586:	48 b8 d6 0e 80 00 00 	movabs $0x800ed6,%rax
  80158d:	00 00 00 
  801590:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801592:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801596:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801599:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80159c:	c9                   	leaveq 
  80159d:	c3                   	retq   

000000000080159e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80159e:	55                   	push   %rbp
  80159f:	48 89 e5             	mov    %rsp,%rbp
  8015a2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015b0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8015b6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015bd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015c4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015cb:	84 c0                	test   %al,%al
  8015cd:	74 20                	je     8015ef <snprintf+0x51>
  8015cf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015d3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015d7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015db:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015df:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015e3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015e7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015eb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015ef:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8015f6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8015fd:	00 00 00 
  801600:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801607:	00 00 00 
  80160a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80160e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801615:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80161c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801623:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80162a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801631:	48 8b 0a             	mov    (%rdx),%rcx
  801634:	48 89 08             	mov    %rcx,(%rax)
  801637:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80163b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80163f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801643:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801647:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80164e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801655:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80165b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801662:	48 89 c7             	mov    %rax,%rdi
  801665:	48 b8 01 15 80 00 00 	movabs $0x801501,%rax
  80166c:	00 00 00 
  80166f:	ff d0                	callq  *%rax
  801671:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801677:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80167d:	c9                   	leaveq 
  80167e:	c3                   	retq   

000000000080167f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80167f:	55                   	push   %rbp
  801680:	48 89 e5             	mov    %rsp,%rbp
  801683:	48 83 ec 18          	sub    $0x18,%rsp
  801687:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80168b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801692:	eb 09                	jmp    80169d <strlen+0x1e>
		n++;
  801694:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801698:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80169d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a1:	0f b6 00             	movzbl (%rax),%eax
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 ec                	jne    801694 <strlen+0x15>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016ab:	c9                   	leaveq 
  8016ac:	c3                   	retq   

00000000008016ad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016ad:	55                   	push   %rbp
  8016ae:	48 89 e5             	mov    %rsp,%rbp
  8016b1:	48 83 ec 20          	sub    $0x20,%rsp
  8016b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016c4:	eb 0e                	jmp    8016d4 <strnlen+0x27>
		n++;
  8016c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016cf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016d4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016d9:	74 0b                	je     8016e6 <strnlen+0x39>
  8016db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016df:	0f b6 00             	movzbl (%rax),%eax
  8016e2:	84 c0                	test   %al,%al
  8016e4:	75 e0                	jne    8016c6 <strnlen+0x19>
		n++;
	return n;
  8016e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016e9:	c9                   	leaveq 
  8016ea:	c3                   	retq   

00000000008016eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	48 83 ec 20          	sub    $0x20,%rsp
  8016f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801703:	90                   	nop
  801704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801708:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80170c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801710:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801714:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801718:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80171c:	0f b6 12             	movzbl (%rdx),%edx
  80171f:	88 10                	mov    %dl,(%rax)
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	84 c0                	test   %al,%al
  801726:	75 dc                	jne    801704 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80172c:	c9                   	leaveq 
  80172d:	c3                   	retq   

000000000080172e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80172e:	55                   	push   %rbp
  80172f:	48 89 e5             	mov    %rsp,%rbp
  801732:	48 83 ec 20          	sub    $0x20,%rsp
  801736:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80173a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80173e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801742:	48 89 c7             	mov    %rax,%rdi
  801745:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80174c:	00 00 00 
  80174f:	ff d0                	callq  *%rax
  801751:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801757:	48 63 d0             	movslq %eax,%rdx
  80175a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175e:	48 01 c2             	add    %rax,%rdx
  801761:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801765:	48 89 c6             	mov    %rax,%rsi
  801768:	48 89 d7             	mov    %rdx,%rdi
  80176b:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  801772:	00 00 00 
  801775:	ff d0                	callq  *%rax
	return dst;
  801777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80177b:	c9                   	leaveq 
  80177c:	c3                   	retq   

000000000080177d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80177d:	55                   	push   %rbp
  80177e:	48 89 e5             	mov    %rsp,%rbp
  801781:	48 83 ec 28          	sub    $0x28,%rsp
  801785:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801789:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80178d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801795:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801799:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017a0:	00 
  8017a1:	eb 2a                	jmp    8017cd <strncpy+0x50>
		*dst++ = *src;
  8017a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017b3:	0f b6 12             	movzbl (%rdx),%edx
  8017b6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	84 c0                	test   %al,%al
  8017c1:	74 05                	je     8017c8 <strncpy+0x4b>
			src++;
  8017c3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017d5:	72 cc                	jb     8017a3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017db:	c9                   	leaveq 
  8017dc:	c3                   	retq   

00000000008017dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017dd:	55                   	push   %rbp
  8017de:	48 89 e5             	mov    %rsp,%rbp
  8017e1:	48 83 ec 28          	sub    $0x28,%rsp
  8017e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8017f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017fe:	74 3d                	je     80183d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801800:	eb 1d                	jmp    80181f <strlcpy+0x42>
			*dst++ = *src++;
  801802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801806:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80180a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80180e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801812:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801816:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80181a:	0f b6 12             	movzbl (%rdx),%edx
  80181d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80181f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801824:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801829:	74 0b                	je     801836 <strlcpy+0x59>
  80182b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	84 c0                	test   %al,%al
  801834:	75 cc                	jne    801802 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80183d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801845:	48 29 c2             	sub    %rax,%rdx
  801848:	48 89 d0             	mov    %rdx,%rax
}
  80184b:	c9                   	leaveq 
  80184c:	c3                   	retq   

000000000080184d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80184d:	55                   	push   %rbp
  80184e:	48 89 e5             	mov    %rsp,%rbp
  801851:	48 83 ec 10          	sub    $0x10,%rsp
  801855:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801859:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80185d:	eb 0a                	jmp    801869 <strcmp+0x1c>
		p++, q++;
  80185f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801864:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801869:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186d:	0f b6 00             	movzbl (%rax),%eax
  801870:	84 c0                	test   %al,%al
  801872:	74 12                	je     801886 <strcmp+0x39>
  801874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801878:	0f b6 10             	movzbl (%rax),%edx
  80187b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80187f:	0f b6 00             	movzbl (%rax),%eax
  801882:	38 c2                	cmp    %al,%dl
  801884:	74 d9                	je     80185f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	0f b6 d0             	movzbl %al,%edx
  801890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801894:	0f b6 00             	movzbl (%rax),%eax
  801897:	0f b6 c0             	movzbl %al,%eax
  80189a:	29 c2                	sub    %eax,%edx
  80189c:	89 d0                	mov    %edx,%eax
}
  80189e:	c9                   	leaveq 
  80189f:	c3                   	retq   

00000000008018a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	48 83 ec 18          	sub    $0x18,%rsp
  8018a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018b4:	eb 0f                	jmp    8018c5 <strncmp+0x25>
		n--, p++, q++;
  8018b6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018c0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ca:	74 1d                	je     8018e9 <strncmp+0x49>
  8018cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d0:	0f b6 00             	movzbl (%rax),%eax
  8018d3:	84 c0                	test   %al,%al
  8018d5:	74 12                	je     8018e9 <strncmp+0x49>
  8018d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018db:	0f b6 10             	movzbl (%rax),%edx
  8018de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e2:	0f b6 00             	movzbl (%rax),%eax
  8018e5:	38 c2                	cmp    %al,%dl
  8018e7:	74 cd                	je     8018b6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ee:	75 07                	jne    8018f7 <strncmp+0x57>
		return 0;
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f5:	eb 18                	jmp    80190f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	0f b6 d0             	movzbl %al,%edx
  801901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801905:	0f b6 00             	movzbl (%rax),%eax
  801908:	0f b6 c0             	movzbl %al,%eax
  80190b:	29 c2                	sub    %eax,%edx
  80190d:	89 d0                	mov    %edx,%eax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 0c          	sub    $0xc,%rsp
  801919:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80191d:	89 f0                	mov    %esi,%eax
  80191f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801922:	eb 17                	jmp    80193b <strchr+0x2a>
		if (*s == c)
  801924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801928:	0f b6 00             	movzbl (%rax),%eax
  80192b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80192e:	75 06                	jne    801936 <strchr+0x25>
			return (char *) s;
  801930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801934:	eb 15                	jmp    80194b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801936:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80193b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	84 c0                	test   %al,%al
  801944:	75 de                	jne    801924 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194b:	c9                   	leaveq 
  80194c:	c3                   	retq   

000000000080194d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80194d:	55                   	push   %rbp
  80194e:	48 89 e5             	mov    %rsp,%rbp
  801951:	48 83 ec 0c          	sub    $0xc,%rsp
  801955:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801959:	89 f0                	mov    %esi,%eax
  80195b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80195e:	eb 13                	jmp    801973 <strfind+0x26>
		if (*s == c)
  801960:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80196a:	75 02                	jne    80196e <strfind+0x21>
			break;
  80196c:	eb 10                	jmp    80197e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80196e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801973:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801977:	0f b6 00             	movzbl (%rax),%eax
  80197a:	84 c0                	test   %al,%al
  80197c:	75 e2                	jne    801960 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80197e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801982:	c9                   	leaveq 
  801983:	c3                   	retq   

0000000000801984 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801984:	55                   	push   %rbp
  801985:	48 89 e5             	mov    %rsp,%rbp
  801988:	48 83 ec 18          	sub    $0x18,%rsp
  80198c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801990:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801993:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801997:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80199c:	75 06                	jne    8019a4 <memset+0x20>
		return v;
  80199e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a2:	eb 69                	jmp    801a0d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a8:	83 e0 03             	and    $0x3,%eax
  8019ab:	48 85 c0             	test   %rax,%rax
  8019ae:	75 48                	jne    8019f8 <memset+0x74>
  8019b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b4:	83 e0 03             	and    $0x3,%eax
  8019b7:	48 85 c0             	test   %rax,%rax
  8019ba:	75 3c                	jne    8019f8 <memset+0x74>
		c &= 0xFF;
  8019bc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019c6:	c1 e0 18             	shl    $0x18,%eax
  8019c9:	89 c2                	mov    %eax,%edx
  8019cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ce:	c1 e0 10             	shl    $0x10,%eax
  8019d1:	09 c2                	or     %eax,%edx
  8019d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019d6:	c1 e0 08             	shl    $0x8,%eax
  8019d9:	09 d0                	or     %edx,%eax
  8019db:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8019de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e2:	48 c1 e8 02          	shr    $0x2,%rax
  8019e6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019f0:	48 89 d7             	mov    %rdx,%rdi
  8019f3:	fc                   	cld    
  8019f4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8019f6:	eb 11                	jmp    801a09 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a03:	48 89 d7             	mov    %rdx,%rdi
  801a06:	fc                   	cld    
  801a07:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   

0000000000801a0f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	48 83 ec 28          	sub    $0x28,%rsp
  801a17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a37:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a3b:	0f 83 88 00 00 00    	jae    801ac9 <memmove+0xba>
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a49:	48 01 d0             	add    %rdx,%rax
  801a4c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a50:	76 77                	jbe    801ac9 <memmove+0xba>
		s += n;
  801a52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a56:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a66:	83 e0 03             	and    $0x3,%eax
  801a69:	48 85 c0             	test   %rax,%rax
  801a6c:	75 3b                	jne    801aa9 <memmove+0x9a>
  801a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a72:	83 e0 03             	and    $0x3,%eax
  801a75:	48 85 c0             	test   %rax,%rax
  801a78:	75 2f                	jne    801aa9 <memmove+0x9a>
  801a7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7e:	83 e0 03             	and    $0x3,%eax
  801a81:	48 85 c0             	test   %rax,%rax
  801a84:	75 23                	jne    801aa9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8a:	48 83 e8 04          	sub    $0x4,%rax
  801a8e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a92:	48 83 ea 04          	sub    $0x4,%rdx
  801a96:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a9a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a9e:	48 89 c7             	mov    %rax,%rdi
  801aa1:	48 89 d6             	mov    %rdx,%rsi
  801aa4:	fd                   	std    
  801aa5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801aa7:	eb 1d                	jmp    801ac6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aad:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abd:	48 89 d7             	mov    %rdx,%rdi
  801ac0:	48 89 c1             	mov    %rax,%rcx
  801ac3:	fd                   	std    
  801ac4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ac6:	fc                   	cld    
  801ac7:	eb 57                	jmp    801b20 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acd:	83 e0 03             	and    $0x3,%eax
  801ad0:	48 85 c0             	test   %rax,%rax
  801ad3:	75 36                	jne    801b0b <memmove+0xfc>
  801ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad9:	83 e0 03             	and    $0x3,%eax
  801adc:	48 85 c0             	test   %rax,%rax
  801adf:	75 2a                	jne    801b0b <memmove+0xfc>
  801ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae5:	83 e0 03             	and    $0x3,%eax
  801ae8:	48 85 c0             	test   %rax,%rax
  801aeb:	75 1e                	jne    801b0b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801aed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af1:	48 c1 e8 02          	shr    $0x2,%rax
  801af5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801af8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b00:	48 89 c7             	mov    %rax,%rdi
  801b03:	48 89 d6             	mov    %rdx,%rsi
  801b06:	fc                   	cld    
  801b07:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b09:	eb 15                	jmp    801b20 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b13:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b17:	48 89 c7             	mov    %rax,%rdi
  801b1a:	48 89 d6             	mov    %rdx,%rsi
  801b1d:	fc                   	cld    
  801b1e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b24:	c9                   	leaveq 
  801b25:	c3                   	retq   

0000000000801b26 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b26:	55                   	push   %rbp
  801b27:	48 89 e5             	mov    %rsp,%rbp
  801b2a:	48 83 ec 18          	sub    $0x18,%rsp
  801b2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b36:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b3e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b46:	48 89 ce             	mov    %rcx,%rsi
  801b49:	48 89 c7             	mov    %rax,%rdi
  801b4c:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
}
  801b58:	c9                   	leaveq 
  801b59:	c3                   	retq   

0000000000801b5a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b5a:	55                   	push   %rbp
  801b5b:	48 89 e5             	mov    %rsp,%rbp
  801b5e:	48 83 ec 28          	sub    $0x28,%rsp
  801b62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b7e:	eb 36                	jmp    801bb6 <memcmp+0x5c>
		if (*s1 != *s2)
  801b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b84:	0f b6 10             	movzbl (%rax),%edx
  801b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b8b:	0f b6 00             	movzbl (%rax),%eax
  801b8e:	38 c2                	cmp    %al,%dl
  801b90:	74 1a                	je     801bac <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b96:	0f b6 00             	movzbl (%rax),%eax
  801b99:	0f b6 d0             	movzbl %al,%edx
  801b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba0:	0f b6 00             	movzbl (%rax),%eax
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 20                	jmp    801bcc <memcmp+0x72>
		s1++, s2++;
  801bac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bb1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801bbe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bc2:	48 85 c0             	test   %rax,%rax
  801bc5:	75 b9                	jne    801b80 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcc:	c9                   	leaveq 
  801bcd:	c3                   	retq   

0000000000801bce <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bce:	55                   	push   %rbp
  801bcf:	48 89 e5             	mov    %rsp,%rbp
  801bd2:	48 83 ec 28          	sub    $0x28,%rsp
  801bd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bda:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bdd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801be9:	48 01 d0             	add    %rdx,%rax
  801bec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bf0:	eb 15                	jmp    801c07 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf6:	0f b6 10             	movzbl (%rax),%edx
  801bf9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bfc:	38 c2                	cmp    %al,%dl
  801bfe:	75 02                	jne    801c02 <memfind+0x34>
			break;
  801c00:	eb 0f                	jmp    801c11 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c02:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c0f:	72 e1                	jb     801bf2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c15:	c9                   	leaveq 
  801c16:	c3                   	retq   

0000000000801c17 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c17:	55                   	push   %rbp
  801c18:	48 89 e5             	mov    %rsp,%rbp
  801c1b:	48 83 ec 34          	sub    $0x34,%rsp
  801c1f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c27:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c31:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c38:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c39:	eb 05                	jmp    801c40 <strtol+0x29>
		s++;
  801c3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c44:	0f b6 00             	movzbl (%rax),%eax
  801c47:	3c 20                	cmp    $0x20,%al
  801c49:	74 f0                	je     801c3b <strtol+0x24>
  801c4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4f:	0f b6 00             	movzbl (%rax),%eax
  801c52:	3c 09                	cmp    $0x9,%al
  801c54:	74 e5                	je     801c3b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5a:	0f b6 00             	movzbl (%rax),%eax
  801c5d:	3c 2b                	cmp    $0x2b,%al
  801c5f:	75 07                	jne    801c68 <strtol+0x51>
		s++;
  801c61:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c66:	eb 17                	jmp    801c7f <strtol+0x68>
	else if (*s == '-')
  801c68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c6c:	0f b6 00             	movzbl (%rax),%eax
  801c6f:	3c 2d                	cmp    $0x2d,%al
  801c71:	75 0c                	jne    801c7f <strtol+0x68>
		s++, neg = 1;
  801c73:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c78:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c7f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c83:	74 06                	je     801c8b <strtol+0x74>
  801c85:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c89:	75 28                	jne    801cb3 <strtol+0x9c>
  801c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8f:	0f b6 00             	movzbl (%rax),%eax
  801c92:	3c 30                	cmp    $0x30,%al
  801c94:	75 1d                	jne    801cb3 <strtol+0x9c>
  801c96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9a:	48 83 c0 01          	add    $0x1,%rax
  801c9e:	0f b6 00             	movzbl (%rax),%eax
  801ca1:	3c 78                	cmp    $0x78,%al
  801ca3:	75 0e                	jne    801cb3 <strtol+0x9c>
		s += 2, base = 16;
  801ca5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801caa:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801cb1:	eb 2c                	jmp    801cdf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801cb3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cb7:	75 19                	jne    801cd2 <strtol+0xbb>
  801cb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbd:	0f b6 00             	movzbl (%rax),%eax
  801cc0:	3c 30                	cmp    $0x30,%al
  801cc2:	75 0e                	jne    801cd2 <strtol+0xbb>
		s++, base = 8;
  801cc4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cc9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801cd0:	eb 0d                	jmp    801cdf <strtol+0xc8>
	else if (base == 0)
  801cd2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cd6:	75 07                	jne    801cdf <strtol+0xc8>
		base = 10;
  801cd8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce3:	0f b6 00             	movzbl (%rax),%eax
  801ce6:	3c 2f                	cmp    $0x2f,%al
  801ce8:	7e 1d                	jle    801d07 <strtol+0xf0>
  801cea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cee:	0f b6 00             	movzbl (%rax),%eax
  801cf1:	3c 39                	cmp    $0x39,%al
  801cf3:	7f 12                	jg     801d07 <strtol+0xf0>
			dig = *s - '0';
  801cf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf9:	0f b6 00             	movzbl (%rax),%eax
  801cfc:	0f be c0             	movsbl %al,%eax
  801cff:	83 e8 30             	sub    $0x30,%eax
  801d02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d05:	eb 4e                	jmp    801d55 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0b:	0f b6 00             	movzbl (%rax),%eax
  801d0e:	3c 60                	cmp    $0x60,%al
  801d10:	7e 1d                	jle    801d2f <strtol+0x118>
  801d12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d16:	0f b6 00             	movzbl (%rax),%eax
  801d19:	3c 7a                	cmp    $0x7a,%al
  801d1b:	7f 12                	jg     801d2f <strtol+0x118>
			dig = *s - 'a' + 10;
  801d1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d21:	0f b6 00             	movzbl (%rax),%eax
  801d24:	0f be c0             	movsbl %al,%eax
  801d27:	83 e8 57             	sub    $0x57,%eax
  801d2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d2d:	eb 26                	jmp    801d55 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d33:	0f b6 00             	movzbl (%rax),%eax
  801d36:	3c 40                	cmp    $0x40,%al
  801d38:	7e 48                	jle    801d82 <strtol+0x16b>
  801d3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3e:	0f b6 00             	movzbl (%rax),%eax
  801d41:	3c 5a                	cmp    $0x5a,%al
  801d43:	7f 3d                	jg     801d82 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d49:	0f b6 00             	movzbl (%rax),%eax
  801d4c:	0f be c0             	movsbl %al,%eax
  801d4f:	83 e8 37             	sub    $0x37,%eax
  801d52:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d58:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d5b:	7c 02                	jl     801d5f <strtol+0x148>
			break;
  801d5d:	eb 23                	jmp    801d82 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d5f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d64:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d67:	48 98                	cltq   
  801d69:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d6e:	48 89 c2             	mov    %rax,%rdx
  801d71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d74:	48 98                	cltq   
  801d76:	48 01 d0             	add    %rdx,%rax
  801d79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d7d:	e9 5d ff ff ff       	jmpq   801cdf <strtol+0xc8>

	if (endptr)
  801d82:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d87:	74 0b                	je     801d94 <strtol+0x17d>
		*endptr = (char *) s;
  801d89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d91:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d98:	74 09                	je     801da3 <strtol+0x18c>
  801d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d9e:	48 f7 d8             	neg    %rax
  801da1:	eb 04                	jmp    801da7 <strtol+0x190>
  801da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801da7:	c9                   	leaveq 
  801da8:	c3                   	retq   

0000000000801da9 <strstr>:

char * strstr(const char *in, const char *str)
{
  801da9:	55                   	push   %rbp
  801daa:	48 89 e5             	mov    %rsp,%rbp
  801dad:	48 83 ec 30          	sub    $0x30,%rsp
  801db1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801db5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801db9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dbd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dc1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801dc5:	0f b6 00             	movzbl (%rax),%eax
  801dc8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801dcb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801dcf:	75 06                	jne    801dd7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801dd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd5:	eb 6b                	jmp    801e42 <strstr+0x99>

	len = strlen(str);
  801dd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ddb:	48 89 c7             	mov    %rax,%rdi
  801dde:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
  801dea:	48 98                	cltq   
  801dec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801df0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801df8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801dfc:	0f b6 00             	movzbl (%rax),%eax
  801dff:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801e02:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e06:	75 07                	jne    801e0f <strstr+0x66>
				return (char *) 0;
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0d:	eb 33                	jmp    801e42 <strstr+0x99>
		} while (sc != c);
  801e0f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e13:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e16:	75 d8                	jne    801df0 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801e18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e1c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e24:	48 89 ce             	mov    %rcx,%rsi
  801e27:	48 89 c7             	mov    %rax,%rdi
  801e2a:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801e31:	00 00 00 
  801e34:	ff d0                	callq  *%rax
  801e36:	85 c0                	test   %eax,%eax
  801e38:	75 b6                	jne    801df0 <strstr+0x47>

	return (char *) (in - 1);
  801e3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3e:	48 83 e8 01          	sub    $0x1,%rax
}
  801e42:	c9                   	leaveq 
  801e43:	c3                   	retq   

0000000000801e44 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e44:	55                   	push   %rbp
  801e45:	48 89 e5             	mov    %rsp,%rbp
  801e48:	53                   	push   %rbx
  801e49:	48 83 ec 48          	sub    $0x48,%rsp
  801e4d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e50:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e53:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e57:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e5b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e5f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e63:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e66:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e6a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e6e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e72:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e76:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e7a:	4c 89 c3             	mov    %r8,%rbx
  801e7d:	cd 30                	int    $0x30
  801e7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e83:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e87:	74 3e                	je     801ec7 <syscall+0x83>
  801e89:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e8e:	7e 37                	jle    801ec7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e94:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e97:	49 89 d0             	mov    %rdx,%r8
  801e9a:	89 c1                	mov    %eax,%ecx
  801e9c:	48 ba c8 53 80 00 00 	movabs $0x8053c8,%rdx
  801ea3:	00 00 00 
  801ea6:	be 23 00 00 00       	mov    $0x23,%esi
  801eab:	48 bf e5 53 80 00 00 	movabs $0x8053e5,%rdi
  801eb2:	00 00 00 
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eba:	49 b9 ea 08 80 00 00 	movabs $0x8008ea,%r9
  801ec1:	00 00 00 
  801ec4:	41 ff d1             	callq  *%r9

	return ret;
  801ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ecb:	48 83 c4 48          	add    $0x48,%rsp
  801ecf:	5b                   	pop    %rbx
  801ed0:	5d                   	pop    %rbp
  801ed1:	c3                   	retq   

0000000000801ed2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	48 83 ec 20          	sub    $0x20,%rsp
  801eda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ede:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ef1:	00 
  801ef2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801efe:	48 89 d1             	mov    %rdx,%rcx
  801f01:	48 89 c2             	mov    %rax,%rdx
  801f04:	be 00 00 00 00       	mov    $0x0,%esi
  801f09:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0e:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  801f15:	00 00 00 
  801f18:	ff d0                	callq  *%rax
}
  801f1a:	c9                   	leaveq 
  801f1b:	c3                   	retq   

0000000000801f1c <sys_cgetc>:

int
sys_cgetc(void)
{
  801f1c:	55                   	push   %rbp
  801f1d:	48 89 e5             	mov    %rsp,%rbp
  801f20:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f24:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2b:	00 
  801f2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f32:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f42:	be 00 00 00 00       	mov    $0x0,%esi
  801f47:	bf 01 00 00 00       	mov    $0x1,%edi
  801f4c:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  801f53:	00 00 00 
  801f56:	ff d0                	callq  *%rax
}
  801f58:	c9                   	leaveq 
  801f59:	c3                   	retq   

0000000000801f5a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f5a:	55                   	push   %rbp
  801f5b:	48 89 e5             	mov    %rsp,%rbp
  801f5e:	48 83 ec 10          	sub    $0x10,%rsp
  801f62:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f68:	48 98                	cltq   
  801f6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f71:	00 
  801f72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f83:	48 89 c2             	mov    %rax,%rdx
  801f86:	be 01 00 00 00       	mov    $0x1,%esi
  801f8b:	bf 03 00 00 00       	mov    $0x3,%edi
  801f90:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  801f97:	00 00 00 
  801f9a:	ff d0                	callq  *%rax
}
  801f9c:	c9                   	leaveq 
  801f9d:	c3                   	retq   

0000000000801f9e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f9e:	55                   	push   %rbp
  801f9f:	48 89 e5             	mov    %rsp,%rbp
  801fa2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801fa6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fad:	00 
  801fae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc4:	be 00 00 00 00       	mov    $0x0,%esi
  801fc9:	bf 02 00 00 00       	mov    $0x2,%edi
  801fce:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax
}
  801fda:	c9                   	leaveq 
  801fdb:	c3                   	retq   

0000000000801fdc <sys_yield>:

void
sys_yield(void)
{
  801fdc:	55                   	push   %rbp
  801fdd:	48 89 e5             	mov    %rsp,%rbp
  801fe0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801fe4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801feb:	00 
  801fec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ff2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ffd:	ba 00 00 00 00       	mov    $0x0,%edx
  802002:	be 00 00 00 00       	mov    $0x0,%esi
  802007:	bf 0b 00 00 00       	mov    $0xb,%edi
  80200c:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  802013:	00 00 00 
  802016:	ff d0                	callq  *%rax
}
  802018:	c9                   	leaveq 
  802019:	c3                   	retq   

000000000080201a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80201a:	55                   	push   %rbp
  80201b:	48 89 e5             	mov    %rsp,%rbp
  80201e:	48 83 ec 20          	sub    $0x20,%rsp
  802022:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802025:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802029:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80202c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80202f:	48 63 c8             	movslq %eax,%rcx
  802032:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802039:	48 98                	cltq   
  80203b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802042:	00 
  802043:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802049:	49 89 c8             	mov    %rcx,%r8
  80204c:	48 89 d1             	mov    %rdx,%rcx
  80204f:	48 89 c2             	mov    %rax,%rdx
  802052:	be 01 00 00 00       	mov    $0x1,%esi
  802057:	bf 04 00 00 00       	mov    $0x4,%edi
  80205c:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  802063:	00 00 00 
  802066:	ff d0                	callq  *%rax
}
  802068:	c9                   	leaveq 
  802069:	c3                   	retq   

000000000080206a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80206a:	55                   	push   %rbp
  80206b:	48 89 e5             	mov    %rsp,%rbp
  80206e:	48 83 ec 30          	sub    $0x30,%rsp
  802072:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802075:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802079:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80207c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802080:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802084:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802087:	48 63 c8             	movslq %eax,%rcx
  80208a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80208e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802091:	48 63 f0             	movslq %eax,%rsi
  802094:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209b:	48 98                	cltq   
  80209d:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020a1:	49 89 f9             	mov    %rdi,%r9
  8020a4:	49 89 f0             	mov    %rsi,%r8
  8020a7:	48 89 d1             	mov    %rdx,%rcx
  8020aa:	48 89 c2             	mov    %rax,%rdx
  8020ad:	be 01 00 00 00       	mov    $0x1,%esi
  8020b2:	bf 05 00 00 00       	mov    $0x5,%edi
  8020b7:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax
}
  8020c3:	c9                   	leaveq 
  8020c4:	c3                   	retq   

00000000008020c5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020c5:	55                   	push   %rbp
  8020c6:	48 89 e5             	mov    %rsp,%rbp
  8020c9:	48 83 ec 20          	sub    $0x20,%rsp
  8020cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020db:	48 98                	cltq   
  8020dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e4:	00 
  8020e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f1:	48 89 d1             	mov    %rdx,%rcx
  8020f4:	48 89 c2             	mov    %rax,%rdx
  8020f7:	be 01 00 00 00       	mov    $0x1,%esi
  8020fc:	bf 06 00 00 00       	mov    $0x6,%edi
  802101:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  802108:	00 00 00 
  80210b:	ff d0                	callq  *%rax
}
  80210d:	c9                   	leaveq 
  80210e:	c3                   	retq   

000000000080210f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80210f:	55                   	push   %rbp
  802110:	48 89 e5             	mov    %rsp,%rbp
  802113:	48 83 ec 10          	sub    $0x10,%rsp
  802117:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80211a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80211d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802120:	48 63 d0             	movslq %eax,%rdx
  802123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802126:	48 98                	cltq   
  802128:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80212f:	00 
  802130:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802136:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80213c:	48 89 d1             	mov    %rdx,%rcx
  80213f:	48 89 c2             	mov    %rax,%rdx
  802142:	be 01 00 00 00       	mov    $0x1,%esi
  802147:	bf 08 00 00 00       	mov    $0x8,%edi
  80214c:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  802153:	00 00 00 
  802156:	ff d0                	callq  *%rax
}
  802158:	c9                   	leaveq 
  802159:	c3                   	retq   

000000000080215a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	48 83 ec 20          	sub    $0x20,%rsp
  802162:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802165:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802169:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80216d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802170:	48 98                	cltq   
  802172:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802179:	00 
  80217a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802180:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802186:	48 89 d1             	mov    %rdx,%rcx
  802189:	48 89 c2             	mov    %rax,%rdx
  80218c:	be 01 00 00 00       	mov    $0x1,%esi
  802191:	bf 09 00 00 00       	mov    $0x9,%edi
  802196:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	callq  *%rax
}
  8021a2:	c9                   	leaveq 
  8021a3:	c3                   	retq   

00000000008021a4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021a4:	55                   	push   %rbp
  8021a5:	48 89 e5             	mov    %rsp,%rbp
  8021a8:	48 83 ec 20          	sub    $0x20,%rsp
  8021ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8021b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ba:	48 98                	cltq   
  8021bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021c3:	00 
  8021c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d0:	48 89 d1             	mov    %rdx,%rcx
  8021d3:	48 89 c2             	mov    %rax,%rdx
  8021d6:	be 01 00 00 00       	mov    $0x1,%esi
  8021db:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021e0:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	callq  *%rax
}
  8021ec:	c9                   	leaveq 
  8021ed:	c3                   	retq   

00000000008021ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8021ee:	55                   	push   %rbp
  8021ef:	48 89 e5             	mov    %rsp,%rbp
  8021f2:	48 83 ec 20          	sub    $0x20,%rsp
  8021f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802201:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802204:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802207:	48 63 f0             	movslq %eax,%rsi
  80220a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80220e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802211:	48 98                	cltq   
  802213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802217:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80221e:	00 
  80221f:	49 89 f1             	mov    %rsi,%r9
  802222:	49 89 c8             	mov    %rcx,%r8
  802225:	48 89 d1             	mov    %rdx,%rcx
  802228:	48 89 c2             	mov    %rax,%rdx
  80222b:	be 00 00 00 00       	mov    $0x0,%esi
  802230:	bf 0c 00 00 00       	mov    $0xc,%edi
  802235:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  80223c:	00 00 00 
  80223f:	ff d0                	callq  *%rax
}
  802241:	c9                   	leaveq 
  802242:	c3                   	retq   

0000000000802243 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802243:	55                   	push   %rbp
  802244:	48 89 e5             	mov    %rsp,%rbp
  802247:	48 83 ec 10          	sub    $0x10,%rsp
  80224b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80224f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802253:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80225a:	00 
  80225b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802261:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802267:	b9 00 00 00 00       	mov    $0x0,%ecx
  80226c:	48 89 c2             	mov    %rax,%rdx
  80226f:	be 01 00 00 00       	mov    $0x1,%esi
  802274:	bf 0d 00 00 00       	mov    $0xd,%edi
  802279:	48 b8 44 1e 80 00 00 	movabs $0x801e44,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
}
  802285:	c9                   	leaveq 
  802286:	c3                   	retq   

0000000000802287 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802287:	55                   	push   %rbp
  802288:	48 89 e5             	mov    %rsp,%rbp
  80228b:	48 83 ec 30          	sub    $0x30,%rsp
  80228f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802293:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802297:	48 8b 00             	mov    (%rax),%rax
  80229a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80229e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022a6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  8022a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022ac:	83 e0 02             	and    $0x2,%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	75 4d                	jne    802300 <pgfault+0x79>
  8022b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bb:	48 89 c2             	mov    %rax,%rdx
  8022be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c5:	01 00 00 
  8022c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cc:	25 00 08 00 00       	and    $0x800,%eax
  8022d1:	48 85 c0             	test   %rax,%rax
  8022d4:	74 2a                	je     802300 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  8022d6:	48 ba f8 53 80 00 00 	movabs $0x8053f8,%rdx
  8022dd:	00 00 00 
  8022e0:	be 1e 00 00 00       	mov    $0x1e,%esi
  8022e5:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  8022ec:	00 00 00 
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  8022fb:	00 00 00 
  8022fe:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  802300:	ba 07 00 00 00       	mov    $0x7,%edx
  802305:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80230a:	bf 00 00 00 00       	mov    $0x0,%edi
  80230f:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  802316:	00 00 00 
  802319:	ff d0                	callq  *%rax
  80231b:	85 c0                	test   %eax,%eax
  80231d:	0f 85 cd 00 00 00    	jne    8023f0 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802327:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80232b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802335:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80233d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802342:	48 89 c6             	mov    %rax,%rsi
  802345:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80234a:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802351:	00 00 00 
  802354:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802356:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80235a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802360:	48 89 c1             	mov    %rax,%rcx
  802363:	ba 00 00 00 00       	mov    $0x0,%edx
  802368:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80236d:	bf 00 00 00 00       	mov    $0x0,%edi
  802372:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
  80237e:	85 c0                	test   %eax,%eax
  802380:	79 2a                	jns    8023ac <pgfault+0x125>
				panic("Page map at temp address failed");
  802382:	48 ba 28 54 80 00 00 	movabs $0x805428,%rdx
  802389:	00 00 00 
  80238c:	be 2f 00 00 00       	mov    $0x2f,%esi
  802391:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  802398:	00 00 00 
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a0:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  8023a7:	00 00 00 
  8023aa:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  8023ac:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b6:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  8023bd:	00 00 00 
  8023c0:	ff d0                	callq  *%rax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	79 54                	jns    80241a <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8023c6:	48 ba 48 54 80 00 00 	movabs $0x805448,%rdx
  8023cd:	00 00 00 
  8023d0:	be 31 00 00 00       	mov    $0x31,%esi
  8023d5:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  8023dc:	00 00 00 
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  8023eb:	00 00 00 
  8023ee:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  8023f0:	48 ba 70 54 80 00 00 	movabs $0x805470,%rdx
  8023f7:	00 00 00 
  8023fa:	be 35 00 00 00       	mov    $0x35,%esi
  8023ff:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  802406:	00 00 00 
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  802415:	00 00 00 
  802418:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  80241a:	c9                   	leaveq 
  80241b:	c3                   	retq   

000000000080241c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80241c:	55                   	push   %rbp
  80241d:	48 89 e5             	mov    %rsp,%rbp
  802420:	48 83 ec 20          	sub    $0x20,%rsp
  802424:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802427:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  80242a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802431:	01 00 00 
  802434:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802437:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243b:	25 07 0e 00 00       	and    $0xe07,%eax
  802440:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802443:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802446:	48 c1 e0 0c          	shl    $0xc,%rax
  80244a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  80244e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802451:	25 00 04 00 00       	and    $0x400,%eax
  802456:	85 c0                	test   %eax,%eax
  802458:	74 57                	je     8024b1 <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  80245a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80245d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802461:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802468:	41 89 f0             	mov    %esi,%r8d
  80246b:	48 89 c6             	mov    %rax,%rsi
  80246e:	bf 00 00 00 00       	mov    $0x0,%edi
  802473:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	callq  *%rax
  80247f:	85 c0                	test   %eax,%eax
  802481:	0f 8e 52 01 00 00    	jle    8025d9 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  802487:	48 ba 9d 54 80 00 00 	movabs $0x80549d,%rdx
  80248e:	00 00 00 
  802491:	be 52 00 00 00       	mov    $0x52,%esi
  802496:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  80249d:	00 00 00 
  8024a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a5:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  8024ac:	00 00 00 
  8024af:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  8024b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b4:	83 e0 02             	and    $0x2,%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	75 10                	jne    8024cb <duppage+0xaf>
  8024bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024be:	25 00 08 00 00       	and    $0x800,%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	0f 84 bb 00 00 00    	je     802586 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  8024cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ce:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8024d3:	80 cc 08             	or     $0x8,%ah
  8024d6:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  8024d9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024dc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8024e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e7:	41 89 f0             	mov    %esi,%r8d
  8024ea:	48 89 c6             	mov    %rax,%rsi
  8024ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f2:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	7e 2a                	jle    80252c <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  802502:	48 ba 9d 54 80 00 00 	movabs $0x80549d,%rdx
  802509:	00 00 00 
  80250c:	be 5a 00 00 00       	mov    $0x5a,%esi
  802511:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  802518:	00 00 00 
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
  802520:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  802527:	00 00 00 
  80252a:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  80252c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80252f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802537:	41 89 c8             	mov    %ecx,%r8d
  80253a:	48 89 d1             	mov    %rdx,%rcx
  80253d:	ba 00 00 00 00       	mov    $0x0,%edx
  802542:	48 89 c6             	mov    %rax,%rsi
  802545:	bf 00 00 00 00       	mov    $0x0,%edi
  80254a:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  802551:	00 00 00 
  802554:	ff d0                	callq  *%rax
  802556:	85 c0                	test   %eax,%eax
  802558:	7e 2a                	jle    802584 <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  80255a:	48 ba 9d 54 80 00 00 	movabs $0x80549d,%rdx
  802561:	00 00 00 
  802564:	be 5d 00 00 00       	mov    $0x5d,%esi
  802569:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  802570:	00 00 00 
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  80257f:	00 00 00 
  802582:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802584:	eb 53                	jmp    8025d9 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  802586:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802589:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80258d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802594:	41 89 f0             	mov    %esi,%r8d
  802597:	48 89 c6             	mov    %rax,%rsi
  80259a:	bf 00 00 00 00       	mov    $0x0,%edi
  80259f:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  8025a6:	00 00 00 
  8025a9:	ff d0                	callq  *%rax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	7e 2a                	jle    8025d9 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  8025af:	48 ba 9d 54 80 00 00 	movabs $0x80549d,%rdx
  8025b6:	00 00 00 
  8025b9:	be 61 00 00 00       	mov    $0x61,%esi
  8025be:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  8025c5:	00 00 00 
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  8025d4:	00 00 00 
  8025d7:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025de:	c9                   	leaveq 
  8025df:	c3                   	retq   

00000000008025e0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8025e0:	55                   	push   %rbp
  8025e1:	48 89 e5             	mov    %rsp,%rbp
  8025e4:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  8025e8:	48 bf 87 22 80 00 00 	movabs $0x802287,%rdi
  8025ef:	00 00 00 
  8025f2:	48 b8 aa 49 80 00 00 	movabs $0x8049aa,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8025fe:	b8 07 00 00 00       	mov    $0x7,%eax
  802603:	cd 30                	int    $0x30
  802605:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802608:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80260b:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  80260e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802612:	79 30                	jns    802644 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802614:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802617:	89 c1                	mov    %eax,%ecx
  802619:	48 ba bb 54 80 00 00 	movabs $0x8054bb,%rdx
  802620:	00 00 00 
  802623:	be 89 00 00 00       	mov    $0x89,%esi
  802628:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  80262f:	00 00 00 
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  80263e:	00 00 00 
  802641:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  802644:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802648:	75 46                	jne    802690 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  80264a:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	25 ff 03 00 00       	and    $0x3ff,%eax
  80265b:	48 63 d0             	movslq %eax,%rdx
  80265e:	48 89 d0             	mov    %rdx,%rax
  802661:	48 c1 e0 03          	shl    $0x3,%rax
  802665:	48 01 d0             	add    %rdx,%rax
  802668:	48 c1 e0 05          	shl    $0x5,%rax
  80266c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802673:	00 00 00 
  802676:	48 01 c2             	add    %rax,%rdx
  802679:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802680:	00 00 00 
  802683:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
  80268b:	e9 d1 01 00 00       	jmpq   802861 <fork+0x281>
	}

	uint64_t ad = 0;
  802690:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802697:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802698:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80269d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8026a1:	e9 df 00 00 00       	jmpq   802785 <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8026a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026aa:	48 c1 e8 27          	shr    $0x27,%rax
  8026ae:	48 89 c2             	mov    %rax,%rdx
  8026b1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8026b8:	01 00 00 
  8026bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026bf:	83 e0 01             	and    $0x1,%eax
  8026c2:	48 85 c0             	test   %rax,%rax
  8026c5:	0f 84 9e 00 00 00    	je     802769 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8026cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026cf:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026d3:	48 89 c2             	mov    %rax,%rdx
  8026d6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8026dd:	01 00 00 
  8026e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e4:	83 e0 01             	and    $0x1,%eax
  8026e7:	48 85 c0             	test   %rax,%rax
  8026ea:	74 73                	je     80275f <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8026ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f0:	48 c1 e8 15          	shr    $0x15,%rax
  8026f4:	48 89 c2             	mov    %rax,%rdx
  8026f7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026fe:	01 00 00 
  802701:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802705:	83 e0 01             	and    $0x1,%eax
  802708:	48 85 c0             	test   %rax,%rax
  80270b:	74 48                	je     802755 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80270d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802711:	48 c1 e8 0c          	shr    $0xc,%rax
  802715:	48 89 c2             	mov    %rax,%rdx
  802718:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80271f:	01 00 00 
  802722:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802726:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80272a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272e:	83 e0 01             	and    $0x1,%eax
  802731:	48 85 c0             	test   %rax,%rax
  802734:	74 47                	je     80277d <fork+0x19d>
						duppage(envid, VPN(addr));
  802736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80273a:	48 c1 e8 0c          	shr    $0xc,%rax
  80273e:	89 c2                	mov    %eax,%edx
  802740:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802743:	89 d6                	mov    %edx,%esi
  802745:	89 c7                	mov    %eax,%edi
  802747:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  80274e:	00 00 00 
  802751:	ff d0                	callq  *%rax
  802753:	eb 28                	jmp    80277d <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  802755:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80275c:	00 
  80275d:	eb 1e                	jmp    80277d <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80275f:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802766:	40 
  802767:	eb 14                	jmp    80277d <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80276d:	48 c1 e8 27          	shr    $0x27,%rax
  802771:	48 83 c0 01          	add    $0x1,%rax
  802775:	48 c1 e0 27          	shl    $0x27,%rax
  802779:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  80277d:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802784:	00 
  802785:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80278c:	00 
  80278d:	0f 87 13 ff ff ff    	ja     8026a6 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  802793:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802796:	ba 07 00 00 00       	mov    $0x7,%edx
  80279b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8027a0:	89 c7                	mov    %eax,%edi
  8027a2:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8027ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027b1:	ba 07 00 00 00       	mov    $0x7,%edx
  8027b6:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8027bb:	89 c7                	mov    %eax,%edi
  8027bd:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8027c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027cc:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8027d2:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8027d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027dc:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8027e1:	89 c7                	mov    %eax,%edi
  8027e3:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8027ef:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027f4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8027f9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8027fe:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  802805:	00 00 00 
  802808:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80280a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80280f:	bf 00 00 00 00       	mov    $0x0,%edi
  802814:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802820:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802827:	00 00 00 
  80282a:	48 8b 00             	mov    (%rax),%rax
  80282d:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802834:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802837:	48 89 d6             	mov    %rdx,%rsi
  80283a:	89 c7                	mov    %eax,%edi
  80283c:	48 b8 a4 21 80 00 00 	movabs $0x8021a4,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802848:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80284b:	be 02 00 00 00       	mov    $0x2,%esi
  802850:	89 c7                	mov    %eax,%edi
  802852:	48 b8 0f 21 80 00 00 	movabs $0x80210f,%rax
  802859:	00 00 00 
  80285c:	ff d0                	callq  *%rax

	return envid;
  80285e:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  802861:	c9                   	leaveq 
  802862:	c3                   	retq   

0000000000802863 <sfork>:

// Challenge!
int
sfork(void)
{
  802863:	55                   	push   %rbp
  802864:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802867:	48 ba d3 54 80 00 00 	movabs $0x8054d3,%rdx
  80286e:	00 00 00 
  802871:	be b8 00 00 00       	mov    $0xb8,%esi
  802876:	48 bf 1d 54 80 00 00 	movabs $0x80541d,%rdi
  80287d:	00 00 00 
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
  802885:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  80288c:	00 00 00 
  80288f:	ff d1                	callq  *%rcx

0000000000802891 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802891:	55                   	push   %rbp
  802892:	48 89 e5             	mov    %rsp,%rbp
  802895:	48 83 ec 08          	sub    $0x8,%rsp
  802899:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80289d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028a1:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8028a8:	ff ff ff 
  8028ab:	48 01 d0             	add    %rdx,%rax
  8028ae:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028b2:	c9                   	leaveq 
  8028b3:	c3                   	retq   

00000000008028b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028b4:	55                   	push   %rbp
  8028b5:	48 89 e5             	mov    %rsp,%rbp
  8028b8:	48 83 ec 08          	sub    $0x8,%rsp
  8028bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c4:	48 89 c7             	mov    %rax,%rdi
  8028c7:	48 b8 91 28 80 00 00 	movabs $0x802891,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax
  8028d3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028d9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028dd:	c9                   	leaveq 
  8028de:	c3                   	retq   

00000000008028df <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	48 83 ec 18          	sub    $0x18,%rsp
  8028e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028f2:	eb 6b                	jmp    80295f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f7:	48 98                	cltq   
  8028f9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028ff:	48 c1 e0 0c          	shl    $0xc,%rax
  802903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290b:	48 c1 e8 15          	shr    $0x15,%rax
  80290f:	48 89 c2             	mov    %rax,%rdx
  802912:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802919:	01 00 00 
  80291c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802920:	83 e0 01             	and    $0x1,%eax
  802923:	48 85 c0             	test   %rax,%rax
  802926:	74 21                	je     802949 <fd_alloc+0x6a>
  802928:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292c:	48 c1 e8 0c          	shr    $0xc,%rax
  802930:	48 89 c2             	mov    %rax,%rdx
  802933:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80293a:	01 00 00 
  80293d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802941:	83 e0 01             	and    $0x1,%eax
  802944:	48 85 c0             	test   %rax,%rax
  802947:	75 12                	jne    80295b <fd_alloc+0x7c>
			*fd_store = fd;
  802949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802951:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802954:	b8 00 00 00 00       	mov    $0x0,%eax
  802959:	eb 1a                	jmp    802975 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80295b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80295f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802963:	7e 8f                	jle    8028f4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802969:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802970:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802975:	c9                   	leaveq 
  802976:	c3                   	retq   

0000000000802977 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802977:	55                   	push   %rbp
  802978:	48 89 e5             	mov    %rsp,%rbp
  80297b:	48 83 ec 20          	sub    $0x20,%rsp
  80297f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802982:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802986:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80298a:	78 06                	js     802992 <fd_lookup+0x1b>
  80298c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802990:	7e 07                	jle    802999 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802992:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802997:	eb 6c                	jmp    802a05 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802999:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80299c:	48 98                	cltq   
  80299e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029a4:	48 c1 e0 0c          	shl    $0xc,%rax
  8029a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b0:	48 c1 e8 15          	shr    $0x15,%rax
  8029b4:	48 89 c2             	mov    %rax,%rdx
  8029b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029be:	01 00 00 
  8029c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c5:	83 e0 01             	and    $0x1,%eax
  8029c8:	48 85 c0             	test   %rax,%rax
  8029cb:	74 21                	je     8029ee <fd_lookup+0x77>
  8029cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8029d5:	48 89 c2             	mov    %rax,%rdx
  8029d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029df:	01 00 00 
  8029e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e6:	83 e0 01             	and    $0x1,%eax
  8029e9:	48 85 c0             	test   %rax,%rax
  8029ec:	75 07                	jne    8029f5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029f3:	eb 10                	jmp    802a05 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8029f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029fd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a05:	c9                   	leaveq 
  802a06:	c3                   	retq   

0000000000802a07 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a07:	55                   	push   %rbp
  802a08:	48 89 e5             	mov    %rsp,%rbp
  802a0b:	48 83 ec 30          	sub    $0x30,%rsp
  802a0f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a13:	89 f0                	mov    %esi,%eax
  802a15:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a1c:	48 89 c7             	mov    %rax,%rdi
  802a1f:	48 b8 91 28 80 00 00 	movabs $0x802891,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
  802a2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a2f:	48 89 d6             	mov    %rdx,%rsi
  802a32:	89 c7                	mov    %eax,%edi
  802a34:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax
  802a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a47:	78 0a                	js     802a53 <fd_close+0x4c>
	    || fd != fd2)
  802a49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a51:	74 12                	je     802a65 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a53:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a57:	74 05                	je     802a5e <fd_close+0x57>
  802a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5c:	eb 05                	jmp    802a63 <fd_close+0x5c>
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a63:	eb 69                	jmp    802ace <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a69:	8b 00                	mov    (%rax),%eax
  802a6b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a6f:	48 89 d6             	mov    %rdx,%rsi
  802a72:	89 c7                	mov    %eax,%edi
  802a74:	48 b8 d0 2a 80 00 00 	movabs $0x802ad0,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
  802a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a87:	78 2a                	js     802ab3 <fd_close+0xac>
		if (dev->dev_close)
  802a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a91:	48 85 c0             	test   %rax,%rax
  802a94:	74 16                	je     802aac <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9a:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a9e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aa2:	48 89 d7             	mov    %rdx,%rdi
  802aa5:	ff d0                	callq  *%rax
  802aa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aaa:	eb 07                	jmp    802ab3 <fd_close+0xac>
		else
			r = 0;
  802aac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ab7:	48 89 c6             	mov    %rax,%rsi
  802aba:	bf 00 00 00 00       	mov    $0x0,%edi
  802abf:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
	return r;
  802acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ace:	c9                   	leaveq 
  802acf:	c3                   	retq   

0000000000802ad0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	48 83 ec 20          	sub    $0x20,%rsp
  802ad8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802adb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802adf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae6:	eb 41                	jmp    802b29 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802ae8:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802aef:	00 00 00 
  802af2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802af5:	48 63 d2             	movslq %edx,%rdx
  802af8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802afc:	8b 00                	mov    (%rax),%eax
  802afe:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b01:	75 22                	jne    802b25 <dev_lookup+0x55>
			*dev = devtab[i];
  802b03:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802b0a:	00 00 00 
  802b0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b10:	48 63 d2             	movslq %edx,%rdx
  802b13:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b1b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b23:	eb 60                	jmp    802b85 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b25:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b29:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802b30:	00 00 00 
  802b33:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b36:	48 63 d2             	movslq %edx,%rdx
  802b39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b3d:	48 85 c0             	test   %rax,%rax
  802b40:	75 a6                	jne    802ae8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b42:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b49:	00 00 00 
  802b4c:	48 8b 00             	mov    (%rax),%rax
  802b4f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b55:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b58:	89 c6                	mov    %eax,%esi
  802b5a:	48 bf f0 54 80 00 00 	movabs $0x8054f0,%rdi
  802b61:	00 00 00 
  802b64:	b8 00 00 00 00       	mov    $0x0,%eax
  802b69:	48 b9 23 0b 80 00 00 	movabs $0x800b23,%rcx
  802b70:	00 00 00 
  802b73:	ff d1                	callq  *%rcx
	*dev = 0;
  802b75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b79:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <close>:

int
close(int fdnum)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 20          	sub    $0x20,%rsp
  802b8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b96:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b99:	48 89 d6             	mov    %rdx,%rsi
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
  802baa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb1:	79 05                	jns    802bb8 <close+0x31>
		return r;
  802bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb6:	eb 18                	jmp    802bd0 <close+0x49>
	else
		return fd_close(fd, 1);
  802bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbc:	be 01 00 00 00       	mov    $0x1,%esi
  802bc1:	48 89 c7             	mov    %rax,%rdi
  802bc4:	48 b8 07 2a 80 00 00 	movabs $0x802a07,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
}
  802bd0:	c9                   	leaveq 
  802bd1:	c3                   	retq   

0000000000802bd2 <close_all>:

void
close_all(void)
{
  802bd2:	55                   	push   %rbp
  802bd3:	48 89 e5             	mov    %rsp,%rbp
  802bd6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802be1:	eb 15                	jmp    802bf8 <close_all+0x26>
		close(i);
  802be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be6:	89 c7                	mov    %eax,%edi
  802be8:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  802bef:	00 00 00 
  802bf2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802bf4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bf8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802bfc:	7e e5                	jle    802be3 <close_all+0x11>
		close(i);
}
  802bfe:	c9                   	leaveq 
  802bff:	c3                   	retq   

0000000000802c00 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c00:	55                   	push   %rbp
  802c01:	48 89 e5             	mov    %rsp,%rbp
  802c04:	48 83 ec 40          	sub    $0x40,%rsp
  802c08:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c0b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c0e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c12:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c15:	48 89 d6             	mov    %rdx,%rsi
  802c18:	89 c7                	mov    %eax,%edi
  802c1a:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
  802c26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2d:	79 08                	jns    802c37 <dup+0x37>
		return r;
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	e9 70 01 00 00       	jmpq   802da7 <dup+0x1a7>
	close(newfdnum);
  802c37:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c3a:	89 c7                	mov    %eax,%edi
  802c3c:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  802c43:	00 00 00 
  802c46:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c48:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c4b:	48 98                	cltq   
  802c4d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c53:	48 c1 e0 0c          	shl    $0xc,%rax
  802c57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5f:	48 89 c7             	mov    %rax,%rdi
  802c62:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
  802c6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c76:	48 89 c7             	mov    %rax,%rdi
  802c79:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8d:	48 c1 e8 15          	shr    $0x15,%rax
  802c91:	48 89 c2             	mov    %rax,%rdx
  802c94:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c9b:	01 00 00 
  802c9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ca2:	83 e0 01             	and    $0x1,%eax
  802ca5:	48 85 c0             	test   %rax,%rax
  802ca8:	74 73                	je     802d1d <dup+0x11d>
  802caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cae:	48 c1 e8 0c          	shr    $0xc,%rax
  802cb2:	48 89 c2             	mov    %rax,%rdx
  802cb5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cbc:	01 00 00 
  802cbf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cc3:	83 e0 01             	and    $0x1,%eax
  802cc6:	48 85 c0             	test   %rax,%rax
  802cc9:	74 52                	je     802d1d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccf:	48 c1 e8 0c          	shr    $0xc,%rax
  802cd3:	48 89 c2             	mov    %rax,%rdx
  802cd6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cdd:	01 00 00 
  802ce0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ce4:	25 07 0e 00 00       	and    $0xe07,%eax
  802ce9:	89 c1                	mov    %eax,%ecx
  802ceb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf3:	41 89 c8             	mov    %ecx,%r8d
  802cf6:	48 89 d1             	mov    %rdx,%rcx
  802cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfe:	48 89 c6             	mov    %rax,%rsi
  802d01:	bf 00 00 00 00       	mov    $0x0,%edi
  802d06:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	callq  *%rax
  802d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d19:	79 02                	jns    802d1d <dup+0x11d>
			goto err;
  802d1b:	eb 57                	jmp    802d74 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d21:	48 c1 e8 0c          	shr    $0xc,%rax
  802d25:	48 89 c2             	mov    %rax,%rdx
  802d28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d2f:	01 00 00 
  802d32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d36:	25 07 0e 00 00       	and    $0xe07,%eax
  802d3b:	89 c1                	mov    %eax,%ecx
  802d3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d45:	41 89 c8             	mov    %ecx,%r8d
  802d48:	48 89 d1             	mov    %rdx,%rcx
  802d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d50:	48 89 c6             	mov    %rax,%rsi
  802d53:	bf 00 00 00 00       	mov    $0x0,%edi
  802d58:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  802d5f:	00 00 00 
  802d62:	ff d0                	callq  *%rax
  802d64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6b:	79 02                	jns    802d6f <dup+0x16f>
		goto err;
  802d6d:	eb 05                	jmp    802d74 <dup+0x174>

	return newfdnum;
  802d6f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d72:	eb 33                	jmp    802da7 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d78:	48 89 c6             	mov    %rax,%rsi
  802d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d80:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d90:	48 89 c6             	mov    %rax,%rsi
  802d93:	bf 00 00 00 00       	mov    $0x0,%edi
  802d98:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
	return r;
  802da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802da7:	c9                   	leaveq 
  802da8:	c3                   	retq   

0000000000802da9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	48 83 ec 40          	sub    $0x40,%rsp
  802db1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802db4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802db8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dc3:	48 89 d6             	mov    %rdx,%rsi
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
  802dd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddb:	78 24                	js     802e01 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ddd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de1:	8b 00                	mov    (%rax),%eax
  802de3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802de7:	48 89 d6             	mov    %rdx,%rsi
  802dea:	89 c7                	mov    %eax,%edi
  802dec:	48 b8 d0 2a 80 00 00 	movabs $0x802ad0,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
  802df8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dff:	79 05                	jns    802e06 <read+0x5d>
		return r;
  802e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e04:	eb 76                	jmp    802e7c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0a:	8b 40 08             	mov    0x8(%rax),%eax
  802e0d:	83 e0 03             	and    $0x3,%eax
  802e10:	83 f8 01             	cmp    $0x1,%eax
  802e13:	75 3a                	jne    802e4f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e15:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e1c:	00 00 00 
  802e1f:	48 8b 00             	mov    (%rax),%rax
  802e22:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e28:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e2b:	89 c6                	mov    %eax,%esi
  802e2d:	48 bf 0f 55 80 00 00 	movabs $0x80550f,%rdi
  802e34:	00 00 00 
  802e37:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3c:	48 b9 23 0b 80 00 00 	movabs $0x800b23,%rcx
  802e43:	00 00 00 
  802e46:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e4d:	eb 2d                	jmp    802e7c <read+0xd3>
	}
	if (!dev->dev_read)
  802e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e53:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e57:	48 85 c0             	test   %rax,%rax
  802e5a:	75 07                	jne    802e63 <read+0xba>
		return -E_NOT_SUPP;
  802e5c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e61:	eb 19                	jmp    802e7c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e67:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e6b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e6f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e73:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e77:	48 89 cf             	mov    %rcx,%rdi
  802e7a:	ff d0                	callq  *%rax
}
  802e7c:	c9                   	leaveq 
  802e7d:	c3                   	retq   

0000000000802e7e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e7e:	55                   	push   %rbp
  802e7f:	48 89 e5             	mov    %rsp,%rbp
  802e82:	48 83 ec 30          	sub    $0x30,%rsp
  802e86:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e8d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e98:	eb 49                	jmp    802ee3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9d:	48 98                	cltq   
  802e9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ea3:	48 29 c2             	sub    %rax,%rdx
  802ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea9:	48 63 c8             	movslq %eax,%rcx
  802eac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eb0:	48 01 c1             	add    %rax,%rcx
  802eb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eb6:	48 89 ce             	mov    %rcx,%rsi
  802eb9:	89 c7                	mov    %eax,%edi
  802ebb:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  802ec2:	00 00 00 
  802ec5:	ff d0                	callq  *%rax
  802ec7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802eca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ece:	79 05                	jns    802ed5 <readn+0x57>
			return m;
  802ed0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ed3:	eb 1c                	jmp    802ef1 <readn+0x73>
		if (m == 0)
  802ed5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ed9:	75 02                	jne    802edd <readn+0x5f>
			break;
  802edb:	eb 11                	jmp    802eee <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802edd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ee0:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee6:	48 98                	cltq   
  802ee8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802eec:	72 ac                	jb     802e9a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ef1:	c9                   	leaveq 
  802ef2:	c3                   	retq   

0000000000802ef3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	48 83 ec 40          	sub    $0x40,%rsp
  802efb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802efe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f02:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f0d:	48 89 d6             	mov    %rdx,%rsi
  802f10:	89 c7                	mov    %eax,%edi
  802f12:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
  802f1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f25:	78 24                	js     802f4b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2b:	8b 00                	mov    (%rax),%eax
  802f2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f31:	48 89 d6             	mov    %rdx,%rsi
  802f34:	89 c7                	mov    %eax,%edi
  802f36:	48 b8 d0 2a 80 00 00 	movabs $0x802ad0,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
  802f42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f49:	79 05                	jns    802f50 <write+0x5d>
		return r;
  802f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4e:	eb 75                	jmp    802fc5 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f54:	8b 40 08             	mov    0x8(%rax),%eax
  802f57:	83 e0 03             	and    $0x3,%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	75 3a                	jne    802f98 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f5e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802f65:	00 00 00 
  802f68:	48 8b 00             	mov    (%rax),%rax
  802f6b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f71:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f74:	89 c6                	mov    %eax,%esi
  802f76:	48 bf 2b 55 80 00 00 	movabs $0x80552b,%rdi
  802f7d:	00 00 00 
  802f80:	b8 00 00 00 00       	mov    $0x0,%eax
  802f85:	48 b9 23 0b 80 00 00 	movabs $0x800b23,%rcx
  802f8c:	00 00 00 
  802f8f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f96:	eb 2d                	jmp    802fc5 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fa0:	48 85 c0             	test   %rax,%rax
  802fa3:	75 07                	jne    802fac <write+0xb9>
		return -E_NOT_SUPP;
  802fa5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802faa:	eb 19                	jmp    802fc5 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb0:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fb4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fb8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fbc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fc0:	48 89 cf             	mov    %rcx,%rdi
  802fc3:	ff d0                	callq  *%rax
}
  802fc5:	c9                   	leaveq 
  802fc6:	c3                   	retq   

0000000000802fc7 <seek>:

int
seek(int fdnum, off_t offset)
{
  802fc7:	55                   	push   %rbp
  802fc8:	48 89 e5             	mov    %rsp,%rbp
  802fcb:	48 83 ec 18          	sub    $0x18,%rsp
  802fcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fd5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fdc:	48 89 d6             	mov    %rdx,%rsi
  802fdf:	89 c7                	mov    %eax,%edi
  802fe1:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
  802fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff4:	79 05                	jns    802ffb <seek+0x34>
		return r;
  802ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff9:	eb 0f                	jmp    80300a <seek+0x43>
	fd->fd_offset = offset;
  802ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803002:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80300a:	c9                   	leaveq 
  80300b:	c3                   	retq   

000000000080300c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80300c:	55                   	push   %rbp
  80300d:	48 89 e5             	mov    %rsp,%rbp
  803010:	48 83 ec 30          	sub    $0x30,%rsp
  803014:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803017:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80301a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80301e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803021:	48 89 d6             	mov    %rdx,%rsi
  803024:	89 c7                	mov    %eax,%edi
  803026:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  80302d:	00 00 00 
  803030:	ff d0                	callq  *%rax
  803032:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803035:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803039:	78 24                	js     80305f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80303b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303f:	8b 00                	mov    (%rax),%eax
  803041:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803045:	48 89 d6             	mov    %rdx,%rsi
  803048:	89 c7                	mov    %eax,%edi
  80304a:	48 b8 d0 2a 80 00 00 	movabs $0x802ad0,%rax
  803051:	00 00 00 
  803054:	ff d0                	callq  *%rax
  803056:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803059:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80305d:	79 05                	jns    803064 <ftruncate+0x58>
		return r;
  80305f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803062:	eb 72                	jmp    8030d6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803068:	8b 40 08             	mov    0x8(%rax),%eax
  80306b:	83 e0 03             	and    $0x3,%eax
  80306e:	85 c0                	test   %eax,%eax
  803070:	75 3a                	jne    8030ac <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803072:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803079:	00 00 00 
  80307c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80307f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803085:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803088:	89 c6                	mov    %eax,%esi
  80308a:	48 bf 48 55 80 00 00 	movabs $0x805548,%rdi
  803091:	00 00 00 
  803094:	b8 00 00 00 00       	mov    $0x0,%eax
  803099:	48 b9 23 0b 80 00 00 	movabs $0x800b23,%rcx
  8030a0:	00 00 00 
  8030a3:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8030a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030aa:	eb 2a                	jmp    8030d6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8030ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030b4:	48 85 c0             	test   %rax,%rax
  8030b7:	75 07                	jne    8030c0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030be:	eb 16                	jmp    8030d6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030cc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030cf:	89 ce                	mov    %ecx,%esi
  8030d1:	48 89 d7             	mov    %rdx,%rdi
  8030d4:	ff d0                	callq  *%rax
}
  8030d6:	c9                   	leaveq 
  8030d7:	c3                   	retq   

00000000008030d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030d8:	55                   	push   %rbp
  8030d9:	48 89 e5             	mov    %rsp,%rbp
  8030dc:	48 83 ec 30          	sub    $0x30,%rsp
  8030e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030ee:	48 89 d6             	mov    %rdx,%rsi
  8030f1:	89 c7                	mov    %eax,%edi
  8030f3:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803106:	78 24                	js     80312c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	8b 00                	mov    (%rax),%eax
  80310e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803112:	48 89 d6             	mov    %rdx,%rsi
  803115:	89 c7                	mov    %eax,%edi
  803117:	48 b8 d0 2a 80 00 00 	movabs $0x802ad0,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
  803123:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803126:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312a:	79 05                	jns    803131 <fstat+0x59>
		return r;
  80312c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312f:	eb 5e                	jmp    80318f <fstat+0xb7>
	if (!dev->dev_stat)
  803131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803135:	48 8b 40 28          	mov    0x28(%rax),%rax
  803139:	48 85 c0             	test   %rax,%rax
  80313c:	75 07                	jne    803145 <fstat+0x6d>
		return -E_NOT_SUPP;
  80313e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803143:	eb 4a                	jmp    80318f <fstat+0xb7>
	stat->st_name[0] = 0;
  803145:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803149:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80314c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803150:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803157:	00 00 00 
	stat->st_isdir = 0;
  80315a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803165:	00 00 00 
	stat->st_dev = dev;
  803168:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80316c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803170:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80317f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803183:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803187:	48 89 ce             	mov    %rcx,%rsi
  80318a:	48 89 d7             	mov    %rdx,%rdi
  80318d:	ff d0                	callq  *%rax
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 20          	sub    $0x20,%rsp
  803199:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80319d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a5:	be 00 00 00 00       	mov    $0x0,%esi
  8031aa:	48 89 c7             	mov    %rax,%rdi
  8031ad:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  8031b4:	00 00 00 
  8031b7:	ff d0                	callq  *%rax
  8031b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c0:	79 05                	jns    8031c7 <stat+0x36>
		return fd;
  8031c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c5:	eb 2f                	jmp    8031f6 <stat+0x65>
	r = fstat(fd, stat);
  8031c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ce:	48 89 d6             	mov    %rdx,%rsi
  8031d1:	89 c7                	mov    %eax,%edi
  8031d3:	48 b8 d8 30 80 00 00 	movabs $0x8030d8,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
  8031df:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e5:	89 c7                	mov    %eax,%edi
  8031e7:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8031ee:	00 00 00 
  8031f1:	ff d0                	callq  *%rax
	return r;
  8031f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8031f6:	c9                   	leaveq 
  8031f7:	c3                   	retq   

00000000008031f8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8031f8:	55                   	push   %rbp
  8031f9:	48 89 e5             	mov    %rsp,%rbp
  8031fc:	48 83 ec 10          	sub    $0x10,%rsp
  803200:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803203:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803207:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320e:	00 00 00 
  803211:	8b 00                	mov    (%rax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	75 1d                	jne    803234 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803217:	bf 01 00 00 00       	mov    $0x1,%edi
  80321c:	48 b8 4d 4c 80 00 00 	movabs $0x804c4d,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80322f:	00 00 00 
  803232:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803234:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80323b:	00 00 00 
  80323e:	8b 00                	mov    (%rax),%eax
  803240:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803243:	b9 07 00 00 00       	mov    $0x7,%ecx
  803248:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80324f:	00 00 00 
  803252:	89 c7                	mov    %eax,%edi
  803254:	48 b8 b5 4b 80 00 00 	movabs $0x804bb5,%rax
  80325b:	00 00 00 
  80325e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803264:	ba 00 00 00 00       	mov    $0x0,%edx
  803269:	48 89 c6             	mov    %rax,%rsi
  80326c:	bf 00 00 00 00       	mov    $0x0,%edi
  803271:	48 b8 f4 4a 80 00 00 	movabs $0x804af4,%rax
  803278:	00 00 00 
  80327b:	ff d0                	callq  *%rax
}
  80327d:	c9                   	leaveq 
  80327e:	c3                   	retq   

000000000080327f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80327f:	55                   	push   %rbp
  803280:	48 89 e5             	mov    %rsp,%rbp
  803283:	48 83 ec 20          	sub    $0x20,%rsp
  803287:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80328b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80328e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803292:	48 89 c7             	mov    %rax,%rdi
  803295:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
  8032a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032a6:	7e 0a                	jle    8032b2 <open+0x33>
		return -E_BAD_PATH;
  8032a8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032ad:	e9 a5 00 00 00       	jmpq   803357 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8032b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032b6:	48 89 c7             	mov    %rax,%rdi
  8032b9:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  8032c0:	00 00 00 
  8032c3:	ff d0                	callq  *%rax
  8032c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cc:	79 08                	jns    8032d6 <open+0x57>
		return r;
  8032ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d1:	e9 81 00 00 00       	jmpq   803357 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8032d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032da:	48 89 c6             	mov    %rax,%rsi
  8032dd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032e4:	00 00 00 
  8032e7:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  8032ee:	00 00 00 
  8032f1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8032f3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032fa:	00 00 00 
  8032fd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803300:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330a:	48 89 c6             	mov    %rax,%rsi
  80330d:	bf 01 00 00 00       	mov    $0x1,%edi
  803312:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
  80331e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803325:	79 1d                	jns    803344 <open+0xc5>
		fd_close(fd, 0);
  803327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332b:	be 00 00 00 00       	mov    $0x0,%esi
  803330:	48 89 c7             	mov    %rax,%rdi
  803333:	48 b8 07 2a 80 00 00 	movabs $0x802a07,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
		return r;
  80333f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803342:	eb 13                	jmp    803357 <open+0xd8>
	}

	return fd2num(fd);
  803344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803348:	48 89 c7             	mov    %rax,%rdi
  80334b:	48 b8 91 28 80 00 00 	movabs $0x802891,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  803357:	c9                   	leaveq 
  803358:	c3                   	retq   

0000000000803359 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803359:	55                   	push   %rbp
  80335a:	48 89 e5             	mov    %rsp,%rbp
  80335d:	48 83 ec 10          	sub    $0x10,%rsp
  803361:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803369:	8b 50 0c             	mov    0xc(%rax),%edx
  80336c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803373:	00 00 00 
  803376:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803378:	be 00 00 00 00       	mov    $0x0,%esi
  80337d:	bf 06 00 00 00       	mov    $0x6,%edi
  803382:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  803389:	00 00 00 
  80338c:	ff d0                	callq  *%rax
}
  80338e:	c9                   	leaveq 
  80338f:	c3                   	retq   

0000000000803390 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803390:	55                   	push   %rbp
  803391:	48 89 e5             	mov    %rsp,%rbp
  803394:	48 83 ec 30          	sub    $0x30,%rsp
  803398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80339c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8033a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8033ab:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033b2:	00 00 00 
  8033b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033b7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033be:	00 00 00 
  8033c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033c5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8033c9:	be 00 00 00 00       	mov    $0x0,%esi
  8033ce:	bf 03 00 00 00       	mov    $0x3,%edi
  8033d3:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e6:	79 08                	jns    8033f0 <devfile_read+0x60>
		return r;
  8033e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033eb:	e9 a4 00 00 00       	jmpq   803494 <devfile_read+0x104>
	assert(r <= n);
  8033f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f3:	48 98                	cltq   
  8033f5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8033f9:	76 35                	jbe    803430 <devfile_read+0xa0>
  8033fb:	48 b9 75 55 80 00 00 	movabs $0x805575,%rcx
  803402:	00 00 00 
  803405:	48 ba 7c 55 80 00 00 	movabs $0x80557c,%rdx
  80340c:	00 00 00 
  80340f:	be 84 00 00 00       	mov    $0x84,%esi
  803414:	48 bf 91 55 80 00 00 	movabs $0x805591,%rdi
  80341b:	00 00 00 
  80341e:	b8 00 00 00 00       	mov    $0x0,%eax
  803423:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  80342a:	00 00 00 
  80342d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803430:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803437:	7e 35                	jle    80346e <devfile_read+0xde>
  803439:	48 b9 9c 55 80 00 00 	movabs $0x80559c,%rcx
  803440:	00 00 00 
  803443:	48 ba 7c 55 80 00 00 	movabs $0x80557c,%rdx
  80344a:	00 00 00 
  80344d:	be 85 00 00 00       	mov    $0x85,%esi
  803452:	48 bf 91 55 80 00 00 	movabs $0x805591,%rdi
  803459:	00 00 00 
  80345c:	b8 00 00 00 00       	mov    $0x0,%eax
  803461:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  803468:	00 00 00 
  80346b:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80346e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803471:	48 63 d0             	movslq %eax,%rdx
  803474:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803478:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80347f:	00 00 00 
  803482:	48 89 c7             	mov    %rax,%rdi
  803485:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  80348c:	00 00 00 
  80348f:	ff d0                	callq  *%rax
	return r;
  803491:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  803494:	c9                   	leaveq 
  803495:	c3                   	retq   

0000000000803496 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803496:	55                   	push   %rbp
  803497:	48 89 e5             	mov    %rsp,%rbp
  80349a:	48 83 ec 30          	sub    $0x30,%rsp
  80349e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8034aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ae:	8b 50 0c             	mov    0xc(%rax),%edx
  8034b1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034b8:	00 00 00 
  8034bb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8034bd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034c4:	00 00 00 
  8034c7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034cb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8034cf:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8034d6:	00 
  8034d7:	76 35                	jbe    80350e <devfile_write+0x78>
  8034d9:	48 b9 a8 55 80 00 00 	movabs $0x8055a8,%rcx
  8034e0:	00 00 00 
  8034e3:	48 ba 7c 55 80 00 00 	movabs $0x80557c,%rdx
  8034ea:	00 00 00 
  8034ed:	be 9e 00 00 00       	mov    $0x9e,%esi
  8034f2:	48 bf 91 55 80 00 00 	movabs $0x805591,%rdi
  8034f9:	00 00 00 
  8034fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803501:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  803508:	00 00 00 
  80350b:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80350e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803512:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803516:	48 89 c6             	mov    %rax,%rsi
  803519:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803520:	00 00 00 
  803523:	48 b8 26 1b 80 00 00 	movabs $0x801b26,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80352f:	be 00 00 00 00       	mov    $0x0,%esi
  803534:	bf 04 00 00 00       	mov    $0x4,%edi
  803539:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
  803545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354c:	79 05                	jns    803553 <devfile_write+0xbd>
		return r;
  80354e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803551:	eb 43                	jmp    803596 <devfile_write+0x100>
	assert(r <= n);
  803553:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803556:	48 98                	cltq   
  803558:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80355c:	76 35                	jbe    803593 <devfile_write+0xfd>
  80355e:	48 b9 75 55 80 00 00 	movabs $0x805575,%rcx
  803565:	00 00 00 
  803568:	48 ba 7c 55 80 00 00 	movabs $0x80557c,%rdx
  80356f:	00 00 00 
  803572:	be a2 00 00 00       	mov    $0xa2,%esi
  803577:	48 bf 91 55 80 00 00 	movabs $0x805591,%rdi
  80357e:	00 00 00 
  803581:	b8 00 00 00 00       	mov    $0x0,%eax
  803586:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  80358d:	00 00 00 
  803590:	41 ff d0             	callq  *%r8
	return r;
  803593:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  803596:	c9                   	leaveq 
  803597:	c3                   	retq   

0000000000803598 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803598:	55                   	push   %rbp
  803599:	48 89 e5             	mov    %rsp,%rbp
  80359c:	48 83 ec 20          	sub    $0x20,%rsp
  8035a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8035a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ac:	8b 50 0c             	mov    0xc(%rax),%edx
  8035af:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035b6:	00 00 00 
  8035b9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035bb:	be 00 00 00 00       	mov    $0x0,%esi
  8035c0:	bf 05 00 00 00       	mov    $0x5,%edi
  8035c5:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
  8035d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d8:	79 05                	jns    8035df <devfile_stat+0x47>
		return r;
  8035da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035dd:	eb 56                	jmp    803635 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e3:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8035ea:	00 00 00 
  8035ed:	48 89 c7             	mov    %rax,%rdi
  8035f0:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8035fc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803603:	00 00 00 
  803606:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80360c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803610:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803616:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80361d:	00 00 00 
  803620:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803626:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80362a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803635:	c9                   	leaveq 
  803636:	c3                   	retq   

0000000000803637 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803637:	55                   	push   %rbp
  803638:	48 89 e5             	mov    %rsp,%rbp
  80363b:	48 83 ec 10          	sub    $0x10,%rsp
  80363f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803643:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364a:	8b 50 0c             	mov    0xc(%rax),%edx
  80364d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803654:	00 00 00 
  803657:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803659:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803660:	00 00 00 
  803663:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803666:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803669:	be 00 00 00 00       	mov    $0x0,%esi
  80366e:	bf 02 00 00 00       	mov    $0x2,%edi
  803673:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
}
  80367f:	c9                   	leaveq 
  803680:	c3                   	retq   

0000000000803681 <remove>:

// Delete a file
int
remove(const char *path)
{
  803681:	55                   	push   %rbp
  803682:	48 89 e5             	mov    %rsp,%rbp
  803685:	48 83 ec 10          	sub    $0x10,%rsp
  803689:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80368d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803691:	48 89 c7             	mov    %rax,%rdi
  803694:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
  8036a0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8036a5:	7e 07                	jle    8036ae <remove+0x2d>
		return -E_BAD_PATH;
  8036a7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8036ac:	eb 33                	jmp    8036e1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8036ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b2:	48 89 c6             	mov    %rax,%rsi
  8036b5:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8036bc:	00 00 00 
  8036bf:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8036cb:	be 00 00 00 00       	mov    $0x0,%esi
  8036d0:	bf 07 00 00 00       	mov    $0x7,%edi
  8036d5:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
}
  8036e1:	c9                   	leaveq 
  8036e2:	c3                   	retq   

00000000008036e3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8036e3:	55                   	push   %rbp
  8036e4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036e7:	be 00 00 00 00       	mov    $0x0,%esi
  8036ec:	bf 08 00 00 00       	mov    $0x8,%edi
  8036f1:	48 b8 f8 31 80 00 00 	movabs $0x8031f8,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
}
  8036fd:	5d                   	pop    %rbp
  8036fe:	c3                   	retq   

00000000008036ff <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8036ff:	55                   	push   %rbp
  803700:	48 89 e5             	mov    %rsp,%rbp
  803703:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80370a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803711:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803718:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80371f:	be 00 00 00 00       	mov    $0x0,%esi
  803724:	48 89 c7             	mov    %rax,%rdi
  803727:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
  803733:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803736:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80373a:	79 28                	jns    803764 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80373c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373f:	89 c6                	mov    %eax,%esi
  803741:	48 bf d5 55 80 00 00 	movabs $0x8055d5,%rdi
  803748:	00 00 00 
  80374b:	b8 00 00 00 00       	mov    $0x0,%eax
  803750:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  803757:	00 00 00 
  80375a:	ff d2                	callq  *%rdx
		return fd_src;
  80375c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375f:	e9 74 01 00 00       	jmpq   8038d8 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803764:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80376b:	be 01 01 00 00       	mov    $0x101,%esi
  803770:	48 89 c7             	mov    %rax,%rdi
  803773:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  80377a:	00 00 00 
  80377d:	ff d0                	callq  *%rax
  80377f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803782:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803786:	79 39                	jns    8037c1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803788:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80378b:	89 c6                	mov    %eax,%esi
  80378d:	48 bf eb 55 80 00 00 	movabs $0x8055eb,%rdi
  803794:	00 00 00 
  803797:	b8 00 00 00 00       	mov    $0x0,%eax
  80379c:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  8037a3:	00 00 00 
  8037a6:	ff d2                	callq  *%rdx
		close(fd_src);
  8037a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ab:	89 c7                	mov    %eax,%edi
  8037ad:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8037b4:	00 00 00 
  8037b7:	ff d0                	callq  *%rax
		return fd_dest;
  8037b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037bc:	e9 17 01 00 00       	jmpq   8038d8 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8037c1:	eb 74                	jmp    803837 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8037c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c6:	48 63 d0             	movslq %eax,%rdx
  8037c9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8037d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037d3:	48 89 ce             	mov    %rcx,%rsi
  8037d6:	89 c7                	mov    %eax,%edi
  8037d8:	48 b8 f3 2e 80 00 00 	movabs $0x802ef3,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
  8037e4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8037e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8037eb:	79 4a                	jns    803837 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8037ed:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8037f0:	89 c6                	mov    %eax,%esi
  8037f2:	48 bf 05 56 80 00 00 	movabs $0x805605,%rdi
  8037f9:	00 00 00 
  8037fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803801:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  803808:	00 00 00 
  80380b:	ff d2                	callq  *%rdx
			close(fd_src);
  80380d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803810:	89 c7                	mov    %eax,%edi
  803812:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
			close(fd_dest);
  80381e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803821:	89 c7                	mov    %eax,%edi
  803823:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
			return write_size;
  80382f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803832:	e9 a1 00 00 00       	jmpq   8038d8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803837:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80383e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803841:	ba 00 02 00 00       	mov    $0x200,%edx
  803846:	48 89 ce             	mov    %rcx,%rsi
  803849:	89 c7                	mov    %eax,%edi
  80384b:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
  803857:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80385a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80385e:	0f 8f 5f ff ff ff    	jg     8037c3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803864:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803868:	79 47                	jns    8038b1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80386a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80386d:	89 c6                	mov    %eax,%esi
  80386f:	48 bf 18 56 80 00 00 	movabs $0x805618,%rdi
  803876:	00 00 00 
  803879:	b8 00 00 00 00       	mov    $0x0,%eax
  80387e:	48 ba 23 0b 80 00 00 	movabs $0x800b23,%rdx
  803885:	00 00 00 
  803888:	ff d2                	callq  *%rdx
		close(fd_src);
  80388a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388d:	89 c7                	mov    %eax,%edi
  80388f:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
		close(fd_dest);
  80389b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80389e:	89 c7                	mov    %eax,%edi
  8038a0:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8038a7:	00 00 00 
  8038aa:	ff d0                	callq  *%rax
		return read_size;
  8038ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038af:	eb 27                	jmp    8038d8 <copy+0x1d9>
	}
	close(fd_src);
  8038b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b4:	89 c7                	mov    %eax,%edi
  8038b6:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
	close(fd_dest);
  8038c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038c5:	89 c7                	mov    %eax,%edi
  8038c7:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
	return 0;
  8038d3:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8038d8:	c9                   	leaveq 
  8038d9:	c3                   	retq   

00000000008038da <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8038da:	55                   	push   %rbp
  8038db:	48 89 e5             	mov    %rsp,%rbp
  8038de:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8038e5:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8038ec:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8038f3:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8038fa:	be 00 00 00 00       	mov    $0x0,%esi
  8038ff:	48 89 c7             	mov    %rax,%rdi
  803902:	48 b8 7f 32 80 00 00 	movabs $0x80327f,%rax
  803909:	00 00 00 
  80390c:	ff d0                	callq  *%rax
  80390e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803911:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803915:	79 08                	jns    80391f <spawn+0x45>
		return r;
  803917:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80391a:	e9 14 03 00 00       	jmpq   803c33 <spawn+0x359>
	fd = r;
  80391f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803922:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803925:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80392c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803930:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803937:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80393a:	ba 00 02 00 00       	mov    $0x200,%edx
  80393f:	48 89 ce             	mov    %rcx,%rsi
  803942:	89 c7                	mov    %eax,%edi
  803944:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
  803950:	3d 00 02 00 00       	cmp    $0x200,%eax
  803955:	75 0d                	jne    803964 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  803957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80395b:	8b 00                	mov    (%rax),%eax
  80395d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803962:	74 43                	je     8039a7 <spawn+0xcd>
		close(fd);
  803964:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803967:	89 c7                	mov    %eax,%edi
  803969:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803975:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803979:	8b 00                	mov    (%rax),%eax
  80397b:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803980:	89 c6                	mov    %eax,%esi
  803982:	48 bf 30 56 80 00 00 	movabs $0x805630,%rdi
  803989:	00 00 00 
  80398c:	b8 00 00 00 00       	mov    $0x0,%eax
  803991:	48 b9 23 0b 80 00 00 	movabs $0x800b23,%rcx
  803998:	00 00 00 
  80399b:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80399d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8039a2:	e9 8c 02 00 00       	jmpq   803c33 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8039a7:	b8 07 00 00 00       	mov    $0x7,%eax
  8039ac:	cd 30                	int    $0x30
  8039ae:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8039b1:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8039b4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8039b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8039bb:	79 08                	jns    8039c5 <spawn+0xeb>
		return r;
  8039bd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039c0:	e9 6e 02 00 00       	jmpq   803c33 <spawn+0x359>
	child = r;
  8039c5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039c8:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8039cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8039ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8039d3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8039da:	00 00 00 
  8039dd:	48 63 d0             	movslq %eax,%rdx
  8039e0:	48 89 d0             	mov    %rdx,%rax
  8039e3:	48 c1 e0 03          	shl    $0x3,%rax
  8039e7:	48 01 d0             	add    %rdx,%rax
  8039ea:	48 c1 e0 05          	shl    $0x5,%rax
  8039ee:	48 01 c8             	add    %rcx,%rax
  8039f1:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8039f8:	48 89 c6             	mov    %rax,%rsi
  8039fb:	b8 18 00 00 00       	mov    $0x18,%eax
  803a00:	48 89 d7             	mov    %rdx,%rdi
  803a03:	48 89 c1             	mov    %rax,%rcx
  803a06:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803a11:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803a18:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803a1f:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803a26:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803a2d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803a30:	48 89 ce             	mov    %rcx,%rsi
  803a33:	89 c7                	mov    %eax,%edi
  803a35:	48 b8 9d 3e 80 00 00 	movabs $0x803e9d,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
  803a41:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a44:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a48:	79 08                	jns    803a52 <spawn+0x178>
		return r;
  803a4a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a4d:	e9 e1 01 00 00       	jmpq   803c33 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803a52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a56:	48 8b 40 20          	mov    0x20(%rax),%rax
  803a5a:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803a61:	48 01 d0             	add    %rdx,%rax
  803a64:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803a68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a6f:	e9 a3 00 00 00       	jmpq   803b17 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  803a74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a78:	8b 00                	mov    (%rax),%eax
  803a7a:	83 f8 01             	cmp    $0x1,%eax
  803a7d:	74 05                	je     803a84 <spawn+0x1aa>
			continue;
  803a7f:	e9 8a 00 00 00       	jmpq   803b0e <spawn+0x234>
		perm = PTE_P | PTE_U;
  803a84:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8f:	8b 40 04             	mov    0x4(%rax),%eax
  803a92:	83 e0 02             	and    $0x2,%eax
  803a95:	85 c0                	test   %eax,%eax
  803a97:	74 04                	je     803a9d <spawn+0x1c3>
			perm |= PTE_W;
  803a99:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa1:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803aa5:	41 89 c1             	mov    %eax,%r9d
  803aa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aac:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803ab0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab4:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abc:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803ac0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803ac3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803ac6:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803ac9:	89 3c 24             	mov    %edi,(%rsp)
  803acc:	89 c7                	mov    %eax,%edi
  803ace:	48 b8 46 41 80 00 00 	movabs $0x804146,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
  803ada:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803add:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803ae1:	79 2b                	jns    803b0e <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803ae3:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803ae4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803ae7:	89 c7                	mov    %eax,%edi
  803ae9:	48 b8 5a 1f 80 00 00 	movabs $0x801f5a,%rax
  803af0:	00 00 00 
  803af3:	ff d0                	callq  *%rax
	close(fd);
  803af5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803af8:	89 c7                	mov    %eax,%edi
  803afa:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  803b01:	00 00 00 
  803b04:	ff d0                	callq  *%rax
	return r;
  803b06:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b09:	e9 25 01 00 00       	jmpq   803c33 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803b0e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b12:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803b17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1b:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803b1f:	0f b7 c0             	movzwl %ax,%eax
  803b22:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803b25:	0f 8f 49 ff ff ff    	jg     803a74 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803b2b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803b2e:	89 c7                	mov    %eax,%edi
  803b30:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  803b37:	00 00 00 
  803b3a:	ff d0                	callq  *%rax
	fd = -1;
  803b3c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803b43:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b46:	89 c7                	mov    %eax,%edi
  803b48:	48 b8 32 43 80 00 00 	movabs $0x804332,%rax
  803b4f:	00 00 00 
  803b52:	ff d0                	callq  *%rax
  803b54:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803b57:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803b5b:	79 30                	jns    803b8d <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803b5d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b60:	89 c1                	mov    %eax,%ecx
  803b62:	48 ba 4a 56 80 00 00 	movabs $0x80564a,%rdx
  803b69:	00 00 00 
  803b6c:	be 82 00 00 00       	mov    $0x82,%esi
  803b71:	48 bf 60 56 80 00 00 	movabs $0x805660,%rdi
  803b78:	00 00 00 
  803b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b80:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  803b87:	00 00 00 
  803b8a:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803b8d:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803b94:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803b97:	48 89 d6             	mov    %rdx,%rsi
  803b9a:	89 c7                	mov    %eax,%edi
  803b9c:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
  803ba8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803bab:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803baf:	79 30                	jns    803be1 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803bb1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803bb4:	89 c1                	mov    %eax,%ecx
  803bb6:	48 ba 6c 56 80 00 00 	movabs $0x80566c,%rdx
  803bbd:	00 00 00 
  803bc0:	be 85 00 00 00       	mov    $0x85,%esi
  803bc5:	48 bf 60 56 80 00 00 	movabs $0x805660,%rdi
  803bcc:	00 00 00 
  803bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd4:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  803bdb:	00 00 00 
  803bde:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803be1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803be4:	be 02 00 00 00       	mov    $0x2,%esi
  803be9:	89 c7                	mov    %eax,%edi
  803beb:	48 b8 0f 21 80 00 00 	movabs $0x80210f,%rax
  803bf2:	00 00 00 
  803bf5:	ff d0                	callq  *%rax
  803bf7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803bfa:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803bfe:	79 30                	jns    803c30 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803c00:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c03:	89 c1                	mov    %eax,%ecx
  803c05:	48 ba 86 56 80 00 00 	movabs $0x805686,%rdx
  803c0c:	00 00 00 
  803c0f:	be 88 00 00 00       	mov    $0x88,%esi
  803c14:	48 bf 60 56 80 00 00 	movabs $0x805660,%rdi
  803c1b:	00 00 00 
  803c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c23:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  803c2a:	00 00 00 
  803c2d:	41 ff d0             	callq  *%r8

	return child;
  803c30:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803c33:	c9                   	leaveq 
  803c34:	c3                   	retq   

0000000000803c35 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803c35:	55                   	push   %rbp
  803c36:	48 89 e5             	mov    %rsp,%rbp
  803c39:	41 55                	push   %r13
  803c3b:	41 54                	push   %r12
  803c3d:	53                   	push   %rbx
  803c3e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803c45:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803c4c:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803c53:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803c5a:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803c61:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803c68:	84 c0                	test   %al,%al
  803c6a:	74 26                	je     803c92 <spawnl+0x5d>
  803c6c:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803c73:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803c7a:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803c7e:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803c82:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803c86:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803c8a:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803c8e:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803c92:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803c99:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803ca0:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803ca3:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803caa:	00 00 00 
  803cad:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803cb4:	00 00 00 
  803cb7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803cbb:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803cc2:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803cc9:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803cd0:	eb 07                	jmp    803cd9 <spawnl+0xa4>
		argc++;
  803cd2:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803cd9:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803cdf:	83 f8 30             	cmp    $0x30,%eax
  803ce2:	73 23                	jae    803d07 <spawnl+0xd2>
  803ce4:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803ceb:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803cf1:	89 c0                	mov    %eax,%eax
  803cf3:	48 01 d0             	add    %rdx,%rax
  803cf6:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803cfc:	83 c2 08             	add    $0x8,%edx
  803cff:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803d05:	eb 15                	jmp    803d1c <spawnl+0xe7>
  803d07:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803d0e:	48 89 d0             	mov    %rdx,%rax
  803d11:	48 83 c2 08          	add    $0x8,%rdx
  803d15:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803d1c:	48 8b 00             	mov    (%rax),%rax
  803d1f:	48 85 c0             	test   %rax,%rax
  803d22:	75 ae                	jne    803cd2 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803d24:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803d2a:	83 c0 02             	add    $0x2,%eax
  803d2d:	48 89 e2             	mov    %rsp,%rdx
  803d30:	48 89 d3             	mov    %rdx,%rbx
  803d33:	48 63 d0             	movslq %eax,%rdx
  803d36:	48 83 ea 01          	sub    $0x1,%rdx
  803d3a:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803d41:	48 63 d0             	movslq %eax,%rdx
  803d44:	49 89 d4             	mov    %rdx,%r12
  803d47:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803d4d:	48 63 d0             	movslq %eax,%rdx
  803d50:	49 89 d2             	mov    %rdx,%r10
  803d53:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803d59:	48 98                	cltq   
  803d5b:	48 c1 e0 03          	shl    $0x3,%rax
  803d5f:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803d63:	b8 10 00 00 00       	mov    $0x10,%eax
  803d68:	48 83 e8 01          	sub    $0x1,%rax
  803d6c:	48 01 d0             	add    %rdx,%rax
  803d6f:	bf 10 00 00 00       	mov    $0x10,%edi
  803d74:	ba 00 00 00 00       	mov    $0x0,%edx
  803d79:	48 f7 f7             	div    %rdi
  803d7c:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803d80:	48 29 c4             	sub    %rax,%rsp
  803d83:	48 89 e0             	mov    %rsp,%rax
  803d86:	48 83 c0 07          	add    $0x7,%rax
  803d8a:	48 c1 e8 03          	shr    $0x3,%rax
  803d8e:	48 c1 e0 03          	shl    $0x3,%rax
  803d92:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803d99:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803da0:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803da7:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803daa:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803db0:	8d 50 01             	lea    0x1(%rax),%edx
  803db3:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803dba:	48 63 d2             	movslq %edx,%rdx
  803dbd:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803dc4:	00 

	va_start(vl, arg0);
  803dc5:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803dcc:	00 00 00 
  803dcf:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803dd6:	00 00 00 
  803dd9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ddd:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803de4:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803deb:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803df2:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803df9:	00 00 00 
  803dfc:	eb 63                	jmp    803e61 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803dfe:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803e04:	8d 70 01             	lea    0x1(%rax),%esi
  803e07:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803e0d:	83 f8 30             	cmp    $0x30,%eax
  803e10:	73 23                	jae    803e35 <spawnl+0x200>
  803e12:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803e19:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803e1f:	89 c0                	mov    %eax,%eax
  803e21:	48 01 d0             	add    %rdx,%rax
  803e24:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803e2a:	83 c2 08             	add    $0x8,%edx
  803e2d:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803e33:	eb 15                	jmp    803e4a <spawnl+0x215>
  803e35:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803e3c:	48 89 d0             	mov    %rdx,%rax
  803e3f:	48 83 c2 08          	add    $0x8,%rdx
  803e43:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e4a:	48 8b 08             	mov    (%rax),%rcx
  803e4d:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803e54:	89 f2                	mov    %esi,%edx
  803e56:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803e5a:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803e61:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803e67:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803e6d:	77 8f                	ja     803dfe <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803e6f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e76:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803e7d:	48 89 d6             	mov    %rdx,%rsi
  803e80:	48 89 c7             	mov    %rax,%rdi
  803e83:	48 b8 da 38 80 00 00 	movabs $0x8038da,%rax
  803e8a:	00 00 00 
  803e8d:	ff d0                	callq  *%rax
  803e8f:	48 89 dc             	mov    %rbx,%rsp
}
  803e92:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803e96:	5b                   	pop    %rbx
  803e97:	41 5c                	pop    %r12
  803e99:	41 5d                	pop    %r13
  803e9b:	5d                   	pop    %rbp
  803e9c:	c3                   	retq   

0000000000803e9d <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  803e9d:	55                   	push   %rbp
  803e9e:	48 89 e5             	mov    %rsp,%rbp
  803ea1:	48 83 ec 50          	sub    $0x50,%rsp
  803ea5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803ea8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803eac:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803eb0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803eb7:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803ebf:	eb 33                	jmp    803ef4 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803ec1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ec4:	48 98                	cltq   
  803ec6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ecd:	00 
  803ece:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ed2:	48 01 d0             	add    %rdx,%rax
  803ed5:	48 8b 00             	mov    (%rax),%rax
  803ed8:	48 89 c7             	mov    %rax,%rdi
  803edb:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  803ee2:	00 00 00 
  803ee5:	ff d0                	callq  *%rax
  803ee7:	83 c0 01             	add    $0x1,%eax
  803eea:	48 98                	cltq   
  803eec:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803ef0:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803ef4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ef7:	48 98                	cltq   
  803ef9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803f00:	00 
  803f01:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803f05:	48 01 d0             	add    %rdx,%rax
  803f08:	48 8b 00             	mov    (%rax),%rax
  803f0b:	48 85 c0             	test   %rax,%rax
  803f0e:	75 b1                	jne    803ec1 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803f10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f14:	48 f7 d8             	neg    %rax
  803f17:	48 05 00 10 40 00    	add    $0x401000,%rax
  803f1d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803f21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f25:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803f29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f2d:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803f31:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f34:	83 c2 01             	add    $0x1,%edx
  803f37:	c1 e2 03             	shl    $0x3,%edx
  803f3a:	48 63 d2             	movslq %edx,%rdx
  803f3d:	48 f7 da             	neg    %rdx
  803f40:	48 01 d0             	add    %rdx,%rax
  803f43:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803f47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f4b:	48 83 e8 10          	sub    $0x10,%rax
  803f4f:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803f55:	77 0a                	ja     803f61 <init_stack+0xc4>
		return -E_NO_MEM;
  803f57:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803f5c:	e9 e3 01 00 00       	jmpq   804144 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803f61:	ba 07 00 00 00       	mov    $0x7,%edx
  803f66:	be 00 00 40 00       	mov    $0x400000,%esi
  803f6b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f70:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  803f77:	00 00 00 
  803f7a:	ff d0                	callq  *%rax
  803f7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f83:	79 08                	jns    803f8d <init_stack+0xf0>
		return r;
  803f85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f88:	e9 b7 01 00 00       	jmpq   804144 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803f8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803f94:	e9 8a 00 00 00       	jmpq   804023 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803f99:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803f9c:	48 98                	cltq   
  803f9e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803fa5:	00 
  803fa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803faa:	48 01 c2             	add    %rax,%rdx
  803fad:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803fb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb6:	48 01 c8             	add    %rcx,%rax
  803fb9:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803fbf:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803fc2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803fc5:	48 98                	cltq   
  803fc7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803fce:	00 
  803fcf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803fd3:	48 01 d0             	add    %rdx,%rax
  803fd6:	48 8b 10             	mov    (%rax),%rdx
  803fd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fdd:	48 89 d6             	mov    %rdx,%rsi
  803fe0:	48 89 c7             	mov    %rax,%rdi
  803fe3:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  803fea:	00 00 00 
  803fed:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803fef:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ff2:	48 98                	cltq   
  803ff4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ffb:	00 
  803ffc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804000:	48 01 d0             	add    %rdx,%rax
  804003:	48 8b 00             	mov    (%rax),%rax
  804006:	48 89 c7             	mov    %rax,%rdi
  804009:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  804010:	00 00 00 
  804013:	ff d0                	callq  *%rax
  804015:	48 98                	cltq   
  804017:	48 83 c0 01          	add    $0x1,%rax
  80401b:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80401f:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804023:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804026:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804029:	0f 8c 6a ff ff ff    	jl     803f99 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80402f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804032:	48 98                	cltq   
  804034:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80403b:	00 
  80403c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804040:	48 01 d0             	add    %rdx,%rax
  804043:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80404a:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804051:	00 
  804052:	74 35                	je     804089 <init_stack+0x1ec>
  804054:	48 b9 a0 56 80 00 00 	movabs $0x8056a0,%rcx
  80405b:	00 00 00 
  80405e:	48 ba c6 56 80 00 00 	movabs $0x8056c6,%rdx
  804065:	00 00 00 
  804068:	be f1 00 00 00       	mov    $0xf1,%esi
  80406d:	48 bf 60 56 80 00 00 	movabs $0x805660,%rdi
  804074:	00 00 00 
  804077:	b8 00 00 00 00       	mov    $0x0,%eax
  80407c:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  804083:	00 00 00 
  804086:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804089:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80408d:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804091:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804096:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80409a:	48 01 c8             	add    %rcx,%rax
  80409d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8040a3:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8040a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040aa:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8040ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040b1:	48 98                	cltq   
  8040b3:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  8040b6:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8040bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040bf:	48 01 d0             	add    %rdx,%rax
  8040c2:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8040c8:	48 89 c2             	mov    %rax,%rdx
  8040cb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8040cf:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8040d2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8040d5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8040db:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8040e0:	89 c2                	mov    %eax,%edx
  8040e2:	be 00 00 40 00       	mov    $0x400000,%esi
  8040e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ec:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  8040f3:	00 00 00 
  8040f6:	ff d0                	callq  *%rax
  8040f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040ff:	79 02                	jns    804103 <init_stack+0x266>
		goto error;
  804101:	eb 28                	jmp    80412b <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804103:	be 00 00 40 00       	mov    $0x400000,%esi
  804108:	bf 00 00 00 00       	mov    $0x0,%edi
  80410d:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  804114:	00 00 00 
  804117:	ff d0                	callq  *%rax
  804119:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80411c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804120:	79 02                	jns    804124 <init_stack+0x287>
		goto error;
  804122:	eb 07                	jmp    80412b <init_stack+0x28e>

	return 0;
  804124:	b8 00 00 00 00       	mov    $0x0,%eax
  804129:	eb 19                	jmp    804144 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80412b:	be 00 00 40 00       	mov    $0x400000,%esi
  804130:	bf 00 00 00 00       	mov    $0x0,%edi
  804135:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
	return r;
  804141:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804144:	c9                   	leaveq 
  804145:	c3                   	retq   

0000000000804146 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804146:	55                   	push   %rbp
  804147:	48 89 e5             	mov    %rsp,%rbp
  80414a:	48 83 ec 50          	sub    $0x50,%rsp
  80414e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804151:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804155:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804159:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80415c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804160:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804164:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804168:	25 ff 0f 00 00       	and    $0xfff,%eax
  80416d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804174:	74 21                	je     804197 <map_segment+0x51>
		va -= i;
  804176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804179:	48 98                	cltq   
  80417b:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80417f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804182:	48 98                	cltq   
  804184:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418b:	48 98                	cltq   
  80418d:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  804191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804194:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80419e:	e9 79 01 00 00       	jmpq   80431c <map_segment+0x1d6>
		if (i >= filesz) {
  8041a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a6:	48 98                	cltq   
  8041a8:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8041ac:	72 3c                	jb     8041ea <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8041ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b1:	48 63 d0             	movslq %eax,%rdx
  8041b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b8:	48 01 d0             	add    %rdx,%rax
  8041bb:	48 89 c1             	mov    %rax,%rcx
  8041be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041c1:	8b 55 10             	mov    0x10(%rbp),%edx
  8041c4:	48 89 ce             	mov    %rcx,%rsi
  8041c7:	89 c7                	mov    %eax,%edi
  8041c9:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  8041d0:	00 00 00 
  8041d3:	ff d0                	callq  *%rax
  8041d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8041d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8041dc:	0f 89 33 01 00 00    	jns    804315 <map_segment+0x1cf>
				return r;
  8041e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041e5:	e9 46 01 00 00       	jmpq   804330 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8041ea:	ba 07 00 00 00       	mov    $0x7,%edx
  8041ef:	be 00 00 40 00       	mov    $0x400000,%esi
  8041f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8041f9:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  804200:	00 00 00 
  804203:	ff d0                	callq  *%rax
  804205:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804208:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80420c:	79 08                	jns    804216 <map_segment+0xd0>
				return r;
  80420e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804211:	e9 1a 01 00 00       	jmpq   804330 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804219:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80421c:	01 c2                	add    %eax,%edx
  80421e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804221:	89 d6                	mov    %edx,%esi
  804223:	89 c7                	mov    %eax,%edi
  804225:	48 b8 c7 2f 80 00 00 	movabs $0x802fc7,%rax
  80422c:	00 00 00 
  80422f:	ff d0                	callq  *%rax
  804231:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804234:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804238:	79 08                	jns    804242 <map_segment+0xfc>
				return r;
  80423a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80423d:	e9 ee 00 00 00       	jmpq   804330 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804242:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424c:	48 98                	cltq   
  80424e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804252:	48 29 c2             	sub    %rax,%rdx
  804255:	48 89 d0             	mov    %rdx,%rax
  804258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80425c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80425f:	48 63 d0             	movslq %eax,%rdx
  804262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804266:	48 39 c2             	cmp    %rax,%rdx
  804269:	48 0f 47 d0          	cmova  %rax,%rdx
  80426d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804270:	be 00 00 40 00       	mov    $0x400000,%esi
  804275:	89 c7                	mov    %eax,%edi
  804277:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  80427e:	00 00 00 
  804281:	ff d0                	callq  *%rax
  804283:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804286:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80428a:	79 08                	jns    804294 <map_segment+0x14e>
				return r;
  80428c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80428f:	e9 9c 00 00 00       	jmpq   804330 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  804294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804297:	48 63 d0             	movslq %eax,%rdx
  80429a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80429e:	48 01 d0             	add    %rdx,%rax
  8042a1:	48 89 c2             	mov    %rax,%rdx
  8042a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042a7:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8042ab:	48 89 d1             	mov    %rdx,%rcx
  8042ae:	89 c2                	mov    %eax,%edx
  8042b0:	be 00 00 40 00       	mov    $0x400000,%esi
  8042b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8042ba:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  8042c1:	00 00 00 
  8042c4:	ff d0                	callq  *%rax
  8042c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8042c9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8042cd:	79 30                	jns    8042ff <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8042cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042d2:	89 c1                	mov    %eax,%ecx
  8042d4:	48 ba db 56 80 00 00 	movabs $0x8056db,%rdx
  8042db:	00 00 00 
  8042de:	be 24 01 00 00       	mov    $0x124,%esi
  8042e3:	48 bf 60 56 80 00 00 	movabs $0x805660,%rdi
  8042ea:	00 00 00 
  8042ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f2:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  8042f9:	00 00 00 
  8042fc:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8042ff:	be 00 00 40 00       	mov    $0x400000,%esi
  804304:	bf 00 00 00 00       	mov    $0x0,%edi
  804309:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  804310:	00 00 00 
  804313:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804315:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80431c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80431f:	48 98                	cltq   
  804321:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804325:	0f 82 78 fe ff ff    	jb     8041a3 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80432b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804330:	c9                   	leaveq 
  804331:	c3                   	retq   

0000000000804332 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804332:	55                   	push   %rbp
  804333:	48 89 e5             	mov    %rsp,%rbp
  804336:	48 83 ec 04          	sub    $0x4,%rsp
  80433a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  80433d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804342:	c9                   	leaveq 
  804343:	c3                   	retq   

0000000000804344 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804344:	55                   	push   %rbp
  804345:	48 89 e5             	mov    %rsp,%rbp
  804348:	53                   	push   %rbx
  804349:	48 83 ec 38          	sub    $0x38,%rsp
  80434d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804351:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804355:	48 89 c7             	mov    %rax,%rdi
  804358:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  80435f:	00 00 00 
  804362:	ff d0                	callq  *%rax
  804364:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804367:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80436b:	0f 88 bf 01 00 00    	js     804530 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804375:	ba 07 04 00 00       	mov    $0x407,%edx
  80437a:	48 89 c6             	mov    %rax,%rsi
  80437d:	bf 00 00 00 00       	mov    $0x0,%edi
  804382:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  804389:	00 00 00 
  80438c:	ff d0                	callq  *%rax
  80438e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804391:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804395:	0f 88 95 01 00 00    	js     804530 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80439b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80439f:	48 89 c7             	mov    %rax,%rdi
  8043a2:	48 b8 df 28 80 00 00 	movabs $0x8028df,%rax
  8043a9:	00 00 00 
  8043ac:	ff d0                	callq  *%rax
  8043ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043b5:	0f 88 5d 01 00 00    	js     804518 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043bf:	ba 07 04 00 00       	mov    $0x407,%edx
  8043c4:	48 89 c6             	mov    %rax,%rsi
  8043c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cc:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  8043d3:	00 00 00 
  8043d6:	ff d0                	callq  *%rax
  8043d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043df:	0f 88 33 01 00 00    	js     804518 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8043e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043e9:	48 89 c7             	mov    %rax,%rdi
  8043ec:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  8043f3:	00 00 00 
  8043f6:	ff d0                	callq  *%rax
  8043f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804400:	ba 07 04 00 00       	mov    $0x407,%edx
  804405:	48 89 c6             	mov    %rax,%rsi
  804408:	bf 00 00 00 00       	mov    $0x0,%edi
  80440d:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  804414:	00 00 00 
  804417:	ff d0                	callq  *%rax
  804419:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80441c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804420:	79 05                	jns    804427 <pipe+0xe3>
		goto err2;
  804422:	e9 d9 00 00 00       	jmpq   804500 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804427:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80442b:	48 89 c7             	mov    %rax,%rdi
  80442e:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  804435:	00 00 00 
  804438:	ff d0                	callq  *%rax
  80443a:	48 89 c2             	mov    %rax,%rdx
  80443d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804441:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804447:	48 89 d1             	mov    %rdx,%rcx
  80444a:	ba 00 00 00 00       	mov    $0x0,%edx
  80444f:	48 89 c6             	mov    %rax,%rsi
  804452:	bf 00 00 00 00       	mov    $0x0,%edi
  804457:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  80445e:	00 00 00 
  804461:	ff d0                	callq  *%rax
  804463:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804466:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80446a:	79 1b                	jns    804487 <pipe+0x143>
		goto err3;
  80446c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80446d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804471:	48 89 c6             	mov    %rax,%rsi
  804474:	bf 00 00 00 00       	mov    $0x0,%edi
  804479:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  804480:	00 00 00 
  804483:	ff d0                	callq  *%rax
  804485:	eb 79                	jmp    804500 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80448b:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  804492:	00 00 00 
  804495:	8b 12                	mov    (%rdx),%edx
  804497:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80449d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8044a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044a8:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8044af:	00 00 00 
  8044b2:	8b 12                	mov    (%rdx),%edx
  8044b4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8044b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044ba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8044c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c5:	48 89 c7             	mov    %rax,%rdi
  8044c8:	48 b8 91 28 80 00 00 	movabs $0x802891,%rax
  8044cf:	00 00 00 
  8044d2:	ff d0                	callq  *%rax
  8044d4:	89 c2                	mov    %eax,%edx
  8044d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044da:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8044dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044e0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8044e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044e8:	48 89 c7             	mov    %rax,%rdi
  8044eb:	48 b8 91 28 80 00 00 	movabs $0x802891,%rax
  8044f2:	00 00 00 
  8044f5:	ff d0                	callq  *%rax
  8044f7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8044f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044fe:	eb 33                	jmp    804533 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804500:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804504:	48 89 c6             	mov    %rax,%rsi
  804507:	bf 00 00 00 00       	mov    $0x0,%edi
  80450c:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  804513:	00 00 00 
  804516:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80451c:	48 89 c6             	mov    %rax,%rsi
  80451f:	bf 00 00 00 00       	mov    $0x0,%edi
  804524:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  80452b:	00 00 00 
  80452e:	ff d0                	callq  *%rax
err:
	return r;
  804530:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804533:	48 83 c4 38          	add    $0x38,%rsp
  804537:	5b                   	pop    %rbx
  804538:	5d                   	pop    %rbp
  804539:	c3                   	retq   

000000000080453a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80453a:	55                   	push   %rbp
  80453b:	48 89 e5             	mov    %rsp,%rbp
  80453e:	53                   	push   %rbx
  80453f:	48 83 ec 28          	sub    $0x28,%rsp
  804543:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804547:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80454b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804552:	00 00 00 
  804555:	48 8b 00             	mov    (%rax),%rax
  804558:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80455e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804565:	48 89 c7             	mov    %rax,%rdi
  804568:	48 b8 cf 4c 80 00 00 	movabs $0x804ccf,%rax
  80456f:	00 00 00 
  804572:	ff d0                	callq  *%rax
  804574:	89 c3                	mov    %eax,%ebx
  804576:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80457a:	48 89 c7             	mov    %rax,%rdi
  80457d:	48 b8 cf 4c 80 00 00 	movabs $0x804ccf,%rax
  804584:	00 00 00 
  804587:	ff d0                	callq  *%rax
  804589:	39 c3                	cmp    %eax,%ebx
  80458b:	0f 94 c0             	sete   %al
  80458e:	0f b6 c0             	movzbl %al,%eax
  804591:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804594:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80459b:	00 00 00 
  80459e:	48 8b 00             	mov    (%rax),%rax
  8045a1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8045a7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8045aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ad:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045b0:	75 05                	jne    8045b7 <_pipeisclosed+0x7d>
			return ret;
  8045b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8045b5:	eb 4f                	jmp    804606 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8045b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045bd:	74 42                	je     804601 <_pipeisclosed+0xc7>
  8045bf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8045c3:	75 3c                	jne    804601 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8045c5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8045cc:	00 00 00 
  8045cf:	48 8b 00             	mov    (%rax),%rax
  8045d2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8045d8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8045db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045de:	89 c6                	mov    %eax,%esi
  8045e0:	48 bf fd 56 80 00 00 	movabs $0x8056fd,%rdi
  8045e7:	00 00 00 
  8045ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ef:	49 b8 23 0b 80 00 00 	movabs $0x800b23,%r8
  8045f6:	00 00 00 
  8045f9:	41 ff d0             	callq  *%r8
	}
  8045fc:	e9 4a ff ff ff       	jmpq   80454b <_pipeisclosed+0x11>
  804601:	e9 45 ff ff ff       	jmpq   80454b <_pipeisclosed+0x11>
}
  804606:	48 83 c4 28          	add    $0x28,%rsp
  80460a:	5b                   	pop    %rbx
  80460b:	5d                   	pop    %rbp
  80460c:	c3                   	retq   

000000000080460d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80460d:	55                   	push   %rbp
  80460e:	48 89 e5             	mov    %rsp,%rbp
  804611:	48 83 ec 30          	sub    $0x30,%rsp
  804615:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804618:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80461c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80461f:	48 89 d6             	mov    %rdx,%rsi
  804622:	89 c7                	mov    %eax,%edi
  804624:	48 b8 77 29 80 00 00 	movabs $0x802977,%rax
  80462b:	00 00 00 
  80462e:	ff d0                	callq  *%rax
  804630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804637:	79 05                	jns    80463e <pipeisclosed+0x31>
		return r;
  804639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463c:	eb 31                	jmp    80466f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80463e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804642:	48 89 c7             	mov    %rax,%rdi
  804645:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  80464c:	00 00 00 
  80464f:	ff d0                	callq  *%rax
  804651:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804659:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80465d:	48 89 d6             	mov    %rdx,%rsi
  804660:	48 89 c7             	mov    %rax,%rdi
  804663:	48 b8 3a 45 80 00 00 	movabs $0x80453a,%rax
  80466a:	00 00 00 
  80466d:	ff d0                	callq  *%rax
}
  80466f:	c9                   	leaveq 
  804670:	c3                   	retq   

0000000000804671 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804671:	55                   	push   %rbp
  804672:	48 89 e5             	mov    %rsp,%rbp
  804675:	48 83 ec 40          	sub    $0x40,%rsp
  804679:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80467d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804681:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804689:	48 89 c7             	mov    %rax,%rdi
  80468c:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  804693:	00 00 00 
  804696:	ff d0                	callq  *%rax
  804698:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80469c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046a4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046ab:	00 
  8046ac:	e9 92 00 00 00       	jmpq   804743 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8046b1:	eb 41                	jmp    8046f4 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8046b3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8046b8:	74 09                	je     8046c3 <devpipe_read+0x52>
				return i;
  8046ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046be:	e9 92 00 00 00       	jmpq   804755 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8046c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046cb:	48 89 d6             	mov    %rdx,%rsi
  8046ce:	48 89 c7             	mov    %rax,%rdi
  8046d1:	48 b8 3a 45 80 00 00 	movabs $0x80453a,%rax
  8046d8:	00 00 00 
  8046db:	ff d0                	callq  *%rax
  8046dd:	85 c0                	test   %eax,%eax
  8046df:	74 07                	je     8046e8 <devpipe_read+0x77>
				return 0;
  8046e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e6:	eb 6d                	jmp    804755 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8046e8:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  8046ef:	00 00 00 
  8046f2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8046f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f8:	8b 10                	mov    (%rax),%edx
  8046fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046fe:	8b 40 04             	mov    0x4(%rax),%eax
  804701:	39 c2                	cmp    %eax,%edx
  804703:	74 ae                	je     8046b3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804705:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804709:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80470d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804715:	8b 00                	mov    (%rax),%eax
  804717:	99                   	cltd   
  804718:	c1 ea 1b             	shr    $0x1b,%edx
  80471b:	01 d0                	add    %edx,%eax
  80471d:	83 e0 1f             	and    $0x1f,%eax
  804720:	29 d0                	sub    %edx,%eax
  804722:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804726:	48 98                	cltq   
  804728:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80472d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80472f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804733:	8b 00                	mov    (%rax),%eax
  804735:	8d 50 01             	lea    0x1(%rax),%edx
  804738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80473c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80473e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804743:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804747:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80474b:	0f 82 60 ff ff ff    	jb     8046b1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804751:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804755:	c9                   	leaveq 
  804756:	c3                   	retq   

0000000000804757 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804757:	55                   	push   %rbp
  804758:	48 89 e5             	mov    %rsp,%rbp
  80475b:	48 83 ec 40          	sub    $0x40,%rsp
  80475f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804763:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804767:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80476b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80476f:	48 89 c7             	mov    %rax,%rdi
  804772:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  804779:	00 00 00 
  80477c:	ff d0                	callq  *%rax
  80477e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804782:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804786:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80478a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804791:	00 
  804792:	e9 8e 00 00 00       	jmpq   804825 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804797:	eb 31                	jmp    8047ca <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804799:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80479d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047a1:	48 89 d6             	mov    %rdx,%rsi
  8047a4:	48 89 c7             	mov    %rax,%rdi
  8047a7:	48 b8 3a 45 80 00 00 	movabs $0x80453a,%rax
  8047ae:	00 00 00 
  8047b1:	ff d0                	callq  *%rax
  8047b3:	85 c0                	test   %eax,%eax
  8047b5:	74 07                	je     8047be <devpipe_write+0x67>
				return 0;
  8047b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8047bc:	eb 79                	jmp    804837 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8047be:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  8047c5:	00 00 00 
  8047c8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8047ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047ce:	8b 40 04             	mov    0x4(%rax),%eax
  8047d1:	48 63 d0             	movslq %eax,%rdx
  8047d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047d8:	8b 00                	mov    (%rax),%eax
  8047da:	48 98                	cltq   
  8047dc:	48 83 c0 20          	add    $0x20,%rax
  8047e0:	48 39 c2             	cmp    %rax,%rdx
  8047e3:	73 b4                	jae    804799 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8047e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047e9:	8b 40 04             	mov    0x4(%rax),%eax
  8047ec:	99                   	cltd   
  8047ed:	c1 ea 1b             	shr    $0x1b,%edx
  8047f0:	01 d0                	add    %edx,%eax
  8047f2:	83 e0 1f             	and    $0x1f,%eax
  8047f5:	29 d0                	sub    %edx,%eax
  8047f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047fb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8047ff:	48 01 ca             	add    %rcx,%rdx
  804802:	0f b6 0a             	movzbl (%rdx),%ecx
  804805:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804809:	48 98                	cltq   
  80480b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80480f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804813:	8b 40 04             	mov    0x4(%rax),%eax
  804816:	8d 50 01             	lea    0x1(%rax),%edx
  804819:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80481d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804820:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804829:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80482d:	0f 82 64 ff ff ff    	jb     804797 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804833:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804837:	c9                   	leaveq 
  804838:	c3                   	retq   

0000000000804839 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804839:	55                   	push   %rbp
  80483a:	48 89 e5             	mov    %rsp,%rbp
  80483d:	48 83 ec 20          	sub    $0x20,%rsp
  804841:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804845:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80484d:	48 89 c7             	mov    %rax,%rdi
  804850:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  804857:	00 00 00 
  80485a:	ff d0                	callq  *%rax
  80485c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804860:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804864:	48 be 10 57 80 00 00 	movabs $0x805710,%rsi
  80486b:	00 00 00 
  80486e:	48 89 c7             	mov    %rax,%rdi
  804871:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  804878:	00 00 00 
  80487b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80487d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804881:	8b 50 04             	mov    0x4(%rax),%edx
  804884:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804888:	8b 00                	mov    (%rax),%eax
  80488a:	29 c2                	sub    %eax,%edx
  80488c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804890:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80489a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8048a1:	00 00 00 
	stat->st_dev = &devpipe;
  8048a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048a8:	48 b9 a0 70 80 00 00 	movabs $0x8070a0,%rcx
  8048af:	00 00 00 
  8048b2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8048b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048be:	c9                   	leaveq 
  8048bf:	c3                   	retq   

00000000008048c0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8048c0:	55                   	push   %rbp
  8048c1:	48 89 e5             	mov    %rsp,%rbp
  8048c4:	48 83 ec 10          	sub    $0x10,%rsp
  8048c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8048cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d0:	48 89 c6             	mov    %rax,%rsi
  8048d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8048d8:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  8048df:	00 00 00 
  8048e2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8048e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e8:	48 89 c7             	mov    %rax,%rdi
  8048eb:	48 b8 b4 28 80 00 00 	movabs $0x8028b4,%rax
  8048f2:	00 00 00 
  8048f5:	ff d0                	callq  *%rax
  8048f7:	48 89 c6             	mov    %rax,%rsi
  8048fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8048ff:	48 b8 c5 20 80 00 00 	movabs $0x8020c5,%rax
  804906:	00 00 00 
  804909:	ff d0                	callq  *%rax
}
  80490b:	c9                   	leaveq 
  80490c:	c3                   	retq   

000000000080490d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80490d:	55                   	push   %rbp
  80490e:	48 89 e5             	mov    %rsp,%rbp
  804911:	48 83 ec 20          	sub    $0x20,%rsp
  804915:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804918:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80491c:	75 35                	jne    804953 <wait+0x46>
  80491e:	48 b9 17 57 80 00 00 	movabs $0x805717,%rcx
  804925:	00 00 00 
  804928:	48 ba 22 57 80 00 00 	movabs $0x805722,%rdx
  80492f:	00 00 00 
  804932:	be 09 00 00 00       	mov    $0x9,%esi
  804937:	48 bf 37 57 80 00 00 	movabs $0x805737,%rdi
  80493e:	00 00 00 
  804941:	b8 00 00 00 00       	mov    $0x0,%eax
  804946:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  80494d:	00 00 00 
  804950:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804953:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804956:	25 ff 03 00 00       	and    $0x3ff,%eax
  80495b:	48 63 d0             	movslq %eax,%rdx
  80495e:	48 89 d0             	mov    %rdx,%rax
  804961:	48 c1 e0 03          	shl    $0x3,%rax
  804965:	48 01 d0             	add    %rdx,%rax
  804968:	48 c1 e0 05          	shl    $0x5,%rax
  80496c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804973:	00 00 00 
  804976:	48 01 d0             	add    %rdx,%rax
  804979:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80497d:	eb 0c                	jmp    80498b <wait+0x7e>
		sys_yield();
  80497f:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  804986:	00 00 00 
  804989:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80498b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80498f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804995:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804998:	75 0e                	jne    8049a8 <wait+0x9b>
  80499a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80499e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8049a4:	85 c0                	test   %eax,%eax
  8049a6:	75 d7                	jne    80497f <wait+0x72>
		sys_yield();
}
  8049a8:	c9                   	leaveq 
  8049a9:	c3                   	retq   

00000000008049aa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8049aa:	55                   	push   %rbp
  8049ab:	48 89 e5             	mov    %rsp,%rbp
  8049ae:	48 83 ec 10          	sub    $0x10,%rsp
  8049b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8049b6:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  8049bd:	00 00 00 
  8049c0:	48 8b 00             	mov    (%rax),%rax
  8049c3:	48 85 c0             	test   %rax,%rax
  8049c6:	75 49                	jne    804a11 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  8049c8:	ba 07 00 00 00       	mov    $0x7,%edx
  8049cd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8049d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8049d7:	48 b8 1a 20 80 00 00 	movabs $0x80201a,%rax
  8049de:	00 00 00 
  8049e1:	ff d0                	callq  *%rax
  8049e3:	85 c0                	test   %eax,%eax
  8049e5:	79 2a                	jns    804a11 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  8049e7:	48 ba 48 57 80 00 00 	movabs $0x805748,%rdx
  8049ee:	00 00 00 
  8049f1:	be 21 00 00 00       	mov    $0x21,%esi
  8049f6:	48 bf 73 57 80 00 00 	movabs $0x805773,%rdi
  8049fd:	00 00 00 
  804a00:	b8 00 00 00 00       	mov    $0x0,%eax
  804a05:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  804a0c:	00 00 00 
  804a0f:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804a11:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804a18:	00 00 00 
  804a1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804a1f:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  804a22:	48 be 6d 4a 80 00 00 	movabs $0x804a6d,%rsi
  804a29:	00 00 00 
  804a2c:	bf 00 00 00 00       	mov    $0x0,%edi
  804a31:	48 b8 a4 21 80 00 00 	movabs $0x8021a4,%rax
  804a38:	00 00 00 
  804a3b:	ff d0                	callq  *%rax
  804a3d:	85 c0                	test   %eax,%eax
  804a3f:	79 2a                	jns    804a6b <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  804a41:	48 ba 88 57 80 00 00 	movabs $0x805788,%rdx
  804a48:	00 00 00 
  804a4b:	be 27 00 00 00       	mov    $0x27,%esi
  804a50:	48 bf 73 57 80 00 00 	movabs $0x805773,%rdi
  804a57:	00 00 00 
  804a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  804a5f:	48 b9 ea 08 80 00 00 	movabs $0x8008ea,%rcx
  804a66:	00 00 00 
  804a69:	ff d1                	callq  *%rcx
}
  804a6b:	c9                   	leaveq 
  804a6c:	c3                   	retq   

0000000000804a6d <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804a6d:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804a70:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  804a77:	00 00 00 
call *%rax
  804a7a:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  804a7c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804a83:	00 
    movq 152(%rsp), %rcx
  804a84:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804a8b:	00 
    subq $8, %rcx
  804a8c:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  804a90:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  804a93:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804a9a:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  804a9b:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804a9f:	4c 8b 3c 24          	mov    (%rsp),%r15
  804aa3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804aa8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804aad:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804ab2:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804ab7:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804abc:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804ac1:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804ac6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804acb:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804ad0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804ad5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804ada:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804adf:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804ae4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804ae9:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  804aed:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  804af1:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  804af2:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  804af3:	c3                   	retq   

0000000000804af4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804af4:	55                   	push   %rbp
  804af5:	48 89 e5             	mov    %rsp,%rbp
  804af8:	48 83 ec 30          	sub    $0x30,%rsp
  804afc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804b00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804b04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  804b08:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b0d:	75 0e                	jne    804b1d <ipc_recv+0x29>
        pg = (void *)UTOP;
  804b0f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b16:	00 00 00 
  804b19:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  804b1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b21:	48 89 c7             	mov    %rax,%rdi
  804b24:	48 b8 43 22 80 00 00 	movabs $0x802243,%rax
  804b2b:	00 00 00 
  804b2e:	ff d0                	callq  *%rax
  804b30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b37:	79 27                	jns    804b60 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  804b39:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804b3e:	74 0a                	je     804b4a <ipc_recv+0x56>
            *from_env_store = 0;
  804b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b44:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  804b4a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b4f:	74 0a                	je     804b5b <ipc_recv+0x67>
            *perm_store = 0;
  804b51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b55:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  804b5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b5e:	eb 53                	jmp    804bb3 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  804b60:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804b65:	74 19                	je     804b80 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  804b67:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b6e:	00 00 00 
  804b71:	48 8b 00             	mov    (%rax),%rax
  804b74:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b7e:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  804b80:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b85:	74 19                	je     804ba0 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  804b87:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804b8e:	00 00 00 
  804b91:	48 8b 00             	mov    (%rax),%rax
  804b94:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804b9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b9e:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  804ba0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ba7:	00 00 00 
  804baa:	48 8b 00             	mov    (%rax),%rax
  804bad:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  804bb3:	c9                   	leaveq 
  804bb4:	c3                   	retq   

0000000000804bb5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804bb5:	55                   	push   %rbp
  804bb6:	48 89 e5             	mov    %rsp,%rbp
  804bb9:	48 83 ec 30          	sub    $0x30,%rsp
  804bbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804bc0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804bc3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804bc7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  804bca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804bcf:	75 0e                	jne    804bdf <ipc_send+0x2a>
        pg = (void *)UTOP;
  804bd1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804bd8:	00 00 00 
  804bdb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  804bdf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804be2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804be5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804be9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bec:	89 c7                	mov    %eax,%edi
  804bee:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  804bf5:	00 00 00 
  804bf8:	ff d0                	callq  *%rax
  804bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  804bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c01:	79 36                	jns    804c39 <ipc_send+0x84>
  804c03:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804c07:	74 30                	je     804c39 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  804c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c0c:	89 c1                	mov    %eax,%ecx
  804c0e:	48 ba bf 57 80 00 00 	movabs $0x8057bf,%rdx
  804c15:	00 00 00 
  804c18:	be 49 00 00 00       	mov    $0x49,%esi
  804c1d:	48 bf cc 57 80 00 00 	movabs $0x8057cc,%rdi
  804c24:	00 00 00 
  804c27:	b8 00 00 00 00       	mov    $0x0,%eax
  804c2c:	49 b8 ea 08 80 00 00 	movabs $0x8008ea,%r8
  804c33:	00 00 00 
  804c36:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  804c39:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  804c40:	00 00 00 
  804c43:	ff d0                	callq  *%rax
    } while(r != 0);
  804c45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c49:	75 94                	jne    804bdf <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  804c4b:	c9                   	leaveq 
  804c4c:	c3                   	retq   

0000000000804c4d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804c4d:	55                   	push   %rbp
  804c4e:	48 89 e5             	mov    %rsp,%rbp
  804c51:	48 83 ec 14          	sub    $0x14,%rsp
  804c55:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804c58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c5f:	eb 5e                	jmp    804cbf <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804c61:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804c68:	00 00 00 
  804c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c6e:	48 63 d0             	movslq %eax,%rdx
  804c71:	48 89 d0             	mov    %rdx,%rax
  804c74:	48 c1 e0 03          	shl    $0x3,%rax
  804c78:	48 01 d0             	add    %rdx,%rax
  804c7b:	48 c1 e0 05          	shl    $0x5,%rax
  804c7f:	48 01 c8             	add    %rcx,%rax
  804c82:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804c88:	8b 00                	mov    (%rax),%eax
  804c8a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c8d:	75 2c                	jne    804cbb <ipc_find_env+0x6e>
			return envs[i].env_id;
  804c8f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804c96:	00 00 00 
  804c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c9c:	48 63 d0             	movslq %eax,%rdx
  804c9f:	48 89 d0             	mov    %rdx,%rax
  804ca2:	48 c1 e0 03          	shl    $0x3,%rax
  804ca6:	48 01 d0             	add    %rdx,%rax
  804ca9:	48 c1 e0 05          	shl    $0x5,%rax
  804cad:	48 01 c8             	add    %rcx,%rax
  804cb0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804cb6:	8b 40 08             	mov    0x8(%rax),%eax
  804cb9:	eb 12                	jmp    804ccd <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804cbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804cbf:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804cc6:	7e 99                	jle    804c61 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ccd:	c9                   	leaveq 
  804cce:	c3                   	retq   

0000000000804ccf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804ccf:	55                   	push   %rbp
  804cd0:	48 89 e5             	mov    %rsp,%rbp
  804cd3:	48 83 ec 18          	sub    $0x18,%rsp
  804cd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804cdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cdf:	48 c1 e8 15          	shr    $0x15,%rax
  804ce3:	48 89 c2             	mov    %rax,%rdx
  804ce6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804ced:	01 00 00 
  804cf0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cf4:	83 e0 01             	and    $0x1,%eax
  804cf7:	48 85 c0             	test   %rax,%rax
  804cfa:	75 07                	jne    804d03 <pageref+0x34>
		return 0;
  804cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  804d01:	eb 53                	jmp    804d56 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804d03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d07:	48 c1 e8 0c          	shr    $0xc,%rax
  804d0b:	48 89 c2             	mov    %rax,%rdx
  804d0e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d15:	01 00 00 
  804d18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d24:	83 e0 01             	and    $0x1,%eax
  804d27:	48 85 c0             	test   %rax,%rax
  804d2a:	75 07                	jne    804d33 <pageref+0x64>
		return 0;
  804d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  804d31:	eb 23                	jmp    804d56 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d37:	48 c1 e8 0c          	shr    $0xc,%rax
  804d3b:	48 89 c2             	mov    %rax,%rdx
  804d3e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804d45:	00 00 00 
  804d48:	48 c1 e2 04          	shl    $0x4,%rdx
  804d4c:	48 01 d0             	add    %rdx,%rax
  804d4f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804d53:	0f b7 c0             	movzwl %ax,%eax
}
  804d56:	c9                   	leaveq 
  804d57:	c3                   	retq   
