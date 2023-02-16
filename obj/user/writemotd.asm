
obj/user/writemotd:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 00 39 80 00 00 	movabs $0x803900,%rdi
  800067:	00 00 00 
  80006a:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 09 39 80 00 00 	movabs $0x803909,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf 2c 39 80 00 00 	movabs $0x80392c,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 32 39 80 00 00 	movabs $0x803932,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf 41 39 80 00 00 	movabs $0x803941,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba 60 39 80 00 00 	movabs $0x803960,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 2b 04 80 00 00 	movabs $0x80042b,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 92 39 80 00 00 	movabs $0x803992,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 e0 22 80 00 00 	movabs $0x8022e0,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf a0 39 80 00 00 	movabs $0x8039a0,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 fe 24 80 00 00 	movabs $0x8024fe,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 43 25 80 00 00 	movabs $0x802543,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba a5 39 80 00 00 	movabs $0x8039a5,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf b8 39 80 00 00 	movabs $0x8039b8,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba c6 39 80 00 00 	movabs $0x8039c6,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 e0 22 80 00 00 	movabs $0x8022e0,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf a0 39 80 00 00 	movabs $0x8039a0,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba d6 39 80 00 00 	movabs $0x8039d6,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 1b 39 80 00 00 	movabs $0x80391b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 20          	sub    $0x20,%rsp
  80037f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800382:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800386:	48 b8 df 1a 80 00 00 	movabs $0x801adf,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800398:	25 ff 03 00 00       	and    $0x3ff,%eax
  80039d:	48 63 d0             	movslq %eax,%rdx
  8003a0:	48 89 d0             	mov    %rdx,%rax
  8003a3:	48 c1 e0 03          	shl    $0x3,%rax
  8003a7:	48 01 d0             	add    %rdx,%rax
  8003aa:	48 c1 e0 05          	shl    $0x5,%rax
  8003ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8003b5:	00 00 00 
  8003b8:	48 01 c2             	add    %rax,%rdx
  8003bb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003c2:	00 00 00 
  8003c5:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003cc:	7e 14                	jle    8003e2 <libmain+0x6b>
		binaryname = argv[0];
  8003ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003d2:	48 8b 10             	mov    (%rax),%rdx
  8003d5:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003dc:	00 00 00 
  8003df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8003e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e9:	48 89 d6             	mov    %rdx,%rsi
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f5:	00 00 00 
  8003f8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003fa:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
}
  800406:	c9                   	leaveq 
  800407:	c3                   	retq   

0000000000800408 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80040c:	48 b8 09 21 80 00 00 	movabs $0x802109,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800418:	bf 00 00 00 00       	mov    $0x0,%edi
  80041d:	48 b8 9b 1a 80 00 00 	movabs $0x801a9b,%rax
  800424:	00 00 00 
  800427:	ff d0                	callq  *%rax
}
  800429:	5d                   	pop    %rbp
  80042a:	c3                   	retq   

000000000080042b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042b:	55                   	push   %rbp
  80042c:	48 89 e5             	mov    %rsp,%rbp
  80042f:	53                   	push   %rbx
  800430:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800437:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80043e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800444:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80044b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800452:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800459:	84 c0                	test   %al,%al
  80045b:	74 23                	je     800480 <_panic+0x55>
  80045d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800464:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800468:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80046c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800470:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800474:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800478:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80047c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800480:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800487:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80048e:	00 00 00 
  800491:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800498:	00 00 00 
  80049b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80049f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004bb:	00 00 00 
  8004be:	48 8b 18             	mov    (%rax),%rbx
  8004c1:	48 b8 df 1a 80 00 00 	movabs $0x801adf,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
  8004cd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004d3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004da:	41 89 c8             	mov    %ecx,%r8d
  8004dd:	48 89 d1             	mov    %rdx,%rcx
  8004e0:	48 89 da             	mov    %rbx,%rdx
  8004e3:	89 c6                	mov    %eax,%esi
  8004e5:	48 bf f8 39 80 00 00 	movabs $0x8039f8,%rdi
  8004ec:	00 00 00 
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	49 b9 64 06 80 00 00 	movabs $0x800664,%r9
  8004fb:	00 00 00 
  8004fe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800501:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800508:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80050f:	48 89 d6             	mov    %rdx,%rsi
  800512:	48 89 c7             	mov    %rax,%rdi
  800515:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	callq  *%rax
	cprintf("\n");
  800521:	48 bf 1b 3a 80 00 00 	movabs $0x803a1b,%rdi
  800528:	00 00 00 
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  800537:	00 00 00 
  80053a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053c:	cc                   	int3   
  80053d:	eb fd                	jmp    80053c <_panic+0x111>

000000000080053f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80054e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800552:	8b 00                	mov    (%rax),%eax
  800554:	8d 48 01             	lea    0x1(%rax),%ecx
  800557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055b:	89 0a                	mov    %ecx,(%rdx)
  80055d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800560:	89 d1                	mov    %edx,%ecx
  800562:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800566:	48 98                	cltq   
  800568:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80056c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057d:	8b 00                	mov    (%rax),%eax
  80057f:	48 98                	cltq   
  800581:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800585:	48 83 c2 08          	add    $0x8,%rdx
  800589:	48 89 c6             	mov    %rax,%rsi
  80058c:	48 89 d7             	mov    %rdx,%rdi
  80058f:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  800596:	00 00 00 
  800599:	ff d0                	callq  *%rax
        b->idx = 0;
  80059b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8005a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a9:	8b 40 04             	mov    0x4(%rax),%eax
  8005ac:	8d 50 01             	lea    0x1(%rax),%edx
  8005af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b6:	c9                   	leaveq 
  8005b7:	c3                   	retq   

00000000008005b8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005ca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005d1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005df:	48 8b 0a             	mov    (%rdx),%rcx
  8005e2:	48 89 08             	mov    %rcx,(%rax)
  8005e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005fc:	00 00 00 
    b.cnt = 0;
  8005ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800606:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800609:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800610:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800617:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80061e:	48 89 c6             	mov    %rax,%rsi
  800621:	48 bf 3f 05 80 00 00 	movabs $0x80053f,%rdi
  800628:	00 00 00 
  80062b:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800637:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80063d:	48 98                	cltq   
  80063f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800646:	48 83 c2 08          	add    $0x8,%rdx
  80064a:	48 89 c6             	mov    %rax,%rsi
  80064d:	48 89 d7             	mov    %rdx,%rdi
  800650:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  800657:	00 00 00 
  80065a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80065c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800662:	c9                   	leaveq 
  800663:	c3                   	retq   

0000000000800664 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800664:	55                   	push   %rbp
  800665:	48 89 e5             	mov    %rsp,%rbp
  800668:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80066f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800676:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800684:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80068b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800692:	84 c0                	test   %al,%al
  800694:	74 20                	je     8006b6 <cprintf+0x52>
  800696:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80069a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8006bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c4:	00 00 00 
  8006c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ce:	00 00 00 
  8006d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f8:	48 8b 0a             	mov    (%rdx),%rcx
  8006fb:	48 89 08             	mov    %rcx,(%rax)
  8006fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800702:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800706:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80070e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800715:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80071c:	48 89 d6             	mov    %rdx,%rsi
  80071f:	48 89 c7             	mov    %rax,%rdi
  800722:	48 b8 b8 05 80 00 00 	movabs $0x8005b8,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
  80072e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800734:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80073a:	c9                   	leaveq 
  80073b:	c3                   	retq   

000000000080073c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073c:	55                   	push   %rbp
  80073d:	48 89 e5             	mov    %rsp,%rbp
  800740:	53                   	push   %rbx
  800741:	48 83 ec 38          	sub    $0x38,%rsp
  800745:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800749:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80074d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800751:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800754:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800758:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80075f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800763:	77 3b                	ja     8007a0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800765:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800768:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80076c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80076f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	48 f7 f3             	div    %rbx
  80077b:	48 89 c2             	mov    %rax,%rdx
  80077e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800781:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800784:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	41 89 f9             	mov    %edi,%r9d
  80078f:	48 89 c7             	mov    %rax,%rdi
  800792:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800799:	00 00 00 
  80079c:	ff d0                	callq  *%rax
  80079e:	eb 1e                	jmp    8007be <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a0:	eb 12                	jmp    8007b4 <printnum+0x78>
			putch(padc, putdat);
  8007a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	48 89 ce             	mov    %rcx,%rsi
  8007b0:	89 d7                	mov    %edx,%edi
  8007b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007bc:	7f e4                	jg     8007a2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	48 f7 f1             	div    %rcx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 ba 10 3c 80 00 00 	movabs $0x803c10,%rdx
  8007d7:	00 00 00 
  8007da:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007de:	0f be d0             	movsbl %al,%edx
  8007e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	48 89 ce             	mov    %rcx,%rsi
  8007ec:	89 d7                	mov    %edx,%edi
  8007ee:	ff d0                	callq  *%rax
}
  8007f0:	48 83 c4 38          	add    $0x38,%rsp
  8007f4:	5b                   	pop    %rbx
  8007f5:	5d                   	pop    %rbp
  8007f6:	c3                   	retq   

00000000008007f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f7:	55                   	push   %rbp
  8007f8:	48 89 e5             	mov    %rsp,%rbp
  8007fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800803:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800806:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80080a:	7e 52                	jle    80085e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getuint+0x44>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	8b 12                	mov    (%rdx),%edx
  800830:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	89 0a                	mov    %ecx,(%rdx)
  800839:	eb 17                	jmp    800852 <getuint+0x5b>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	48 8b 00             	mov    (%rax),%rax
  800855:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800859:	e9 a3 00 00 00       	jmpq   800901 <getuint+0x10a>
	else if (lflag)
  80085e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800862:	74 4f                	je     8008b3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	83 f8 30             	cmp    $0x30,%eax
  80086d:	73 24                	jae    800893 <getuint+0x9c>
  80086f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800873:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087b:	8b 00                	mov    (%rax),%eax
  80087d:	89 c0                	mov    %eax,%eax
  80087f:	48 01 d0             	add    %rdx,%rax
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	8b 12                	mov    (%rdx),%edx
  800888:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088f:	89 0a                	mov    %ecx,(%rdx)
  800891:	eb 17                	jmp    8008aa <getuint+0xb3>
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089b:	48 89 d0             	mov    %rdx,%rax
  80089e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008aa:	48 8b 00             	mov    (%rax),%rax
  8008ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b1:	eb 4e                	jmp    800901 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	83 f8 30             	cmp    $0x30,%eax
  8008bc:	73 24                	jae    8008e2 <getuint+0xeb>
  8008be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ca:	8b 00                	mov    (%rax),%eax
  8008cc:	89 c0                	mov    %eax,%eax
  8008ce:	48 01 d0             	add    %rdx,%rax
  8008d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d5:	8b 12                	mov    (%rdx),%edx
  8008d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008de:	89 0a                	mov    %ecx,(%rdx)
  8008e0:	eb 17                	jmp    8008f9 <getuint+0x102>
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ea:	48 89 d0             	mov    %rdx,%rax
  8008ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	89 c0                	mov    %eax,%eax
  8008fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800905:	c9                   	leaveq 
  800906:	c3                   	retq   

0000000000800907 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800907:	55                   	push   %rbp
  800908:	48 89 e5             	mov    %rsp,%rbp
  80090b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80090f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800913:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800916:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80091a:	7e 52                	jle    80096e <getint+0x67>
		x=va_arg(*ap, long long);
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	8b 00                	mov    (%rax),%eax
  800922:	83 f8 30             	cmp    $0x30,%eax
  800925:	73 24                	jae    80094b <getint+0x44>
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	8b 00                	mov    (%rax),%eax
  800935:	89 c0                	mov    %eax,%eax
  800937:	48 01 d0             	add    %rdx,%rax
  80093a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093e:	8b 12                	mov    (%rdx),%edx
  800940:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800943:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800947:	89 0a                	mov    %ecx,(%rdx)
  800949:	eb 17                	jmp    800962 <getint+0x5b>
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800953:	48 89 d0             	mov    %rdx,%rax
  800956:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800962:	48 8b 00             	mov    (%rax),%rax
  800965:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800969:	e9 a3 00 00 00       	jmpq   800a11 <getint+0x10a>
	else if (lflag)
  80096e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800972:	74 4f                	je     8009c3 <getint+0xbc>
		x=va_arg(*ap, long);
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	8b 00                	mov    (%rax),%eax
  80097a:	83 f8 30             	cmp    $0x30,%eax
  80097d:	73 24                	jae    8009a3 <getint+0x9c>
  80097f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800983:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	8b 00                	mov    (%rax),%eax
  80098d:	89 c0                	mov    %eax,%eax
  80098f:	48 01 d0             	add    %rdx,%rax
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	8b 12                	mov    (%rdx),%edx
  800998:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099f:	89 0a                	mov    %ecx,(%rdx)
  8009a1:	eb 17                	jmp    8009ba <getint+0xb3>
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ab:	48 89 d0             	mov    %rdx,%rax
  8009ae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ba:	48 8b 00             	mov    (%rax),%rax
  8009bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c1:	eb 4e                	jmp    800a11 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	83 f8 30             	cmp    $0x30,%eax
  8009cc:	73 24                	jae    8009f2 <getint+0xeb>
  8009ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009da:	8b 00                	mov    (%rax),%eax
  8009dc:	89 c0                	mov    %eax,%eax
  8009de:	48 01 d0             	add    %rdx,%rax
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	8b 12                	mov    (%rdx),%edx
  8009e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ee:	89 0a                	mov    %ecx,(%rdx)
  8009f0:	eb 17                	jmp    800a09 <getint+0x102>
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fa:	48 89 d0             	mov    %rdx,%rax
  8009fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a09:	8b 00                	mov    (%rax),%eax
  800a0b:	48 98                	cltq   
  800a0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a15:	c9                   	leaveq 
  800a16:	c3                   	retq   

0000000000800a17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a17:	55                   	push   %rbp
  800a18:	48 89 e5             	mov    %rsp,%rbp
  800a1b:	41 54                	push   %r12
  800a1d:	53                   	push   %rbx
  800a1e:	48 83 ec 60          	sub    $0x60,%rsp
  800a22:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a26:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a36:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a3a:	48 8b 0a             	mov    (%rdx),%rcx
  800a3d:	48 89 08             	mov    %rcx,(%rax)
  800a40:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a44:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a48:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a50:	eb 17                	jmp    800a69 <vprintfmt+0x52>
			if (ch == '\0')
  800a52:	85 db                	test   %ebx,%ebx
  800a54:	0f 84 df 04 00 00    	je     800f39 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800a5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a62:	48 89 d6             	mov    %rdx,%rsi
  800a65:	89 df                	mov    %ebx,%edi
  800a67:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a75:	0f b6 00             	movzbl (%rax),%eax
  800a78:	0f b6 d8             	movzbl %al,%ebx
  800a7b:	83 fb 25             	cmp    $0x25,%ebx
  800a7e:	75 d2                	jne    800a52 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a80:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a84:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a8b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a99:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800aa8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aac:	0f b6 00             	movzbl (%rax),%eax
  800aaf:	0f b6 d8             	movzbl %al,%ebx
  800ab2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ab5:	83 f8 55             	cmp    $0x55,%eax
  800ab8:	0f 87 47 04 00 00    	ja     800f05 <vprintfmt+0x4ee>
  800abe:	89 c0                	mov    %eax,%eax
  800ac0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ac7:	00 
  800ac8:	48 b8 38 3c 80 00 00 	movabs $0x803c38,%rax
  800acf:	00 00 00 
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	48 8b 00             	mov    (%rax),%rax
  800ad8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ada:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ade:	eb c0                	jmp    800aa0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ae0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ae4:	eb ba                	jmp    800aa0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ae6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800af0:	89 d0                	mov    %edx,%eax
  800af2:	c1 e0 02             	shl    $0x2,%eax
  800af5:	01 d0                	add    %edx,%eax
  800af7:	01 c0                	add    %eax,%eax
  800af9:	01 d8                	add    %ebx,%eax
  800afb:	83 e8 30             	sub    $0x30,%eax
  800afe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b05:	0f b6 00             	movzbl (%rax),%eax
  800b08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800b0e:	7e 0c                	jle    800b1c <vprintfmt+0x105>
  800b10:	83 fb 39             	cmp    $0x39,%ebx
  800b13:	7f 07                	jg     800b1c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b15:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b1a:	eb d1                	jmp    800aed <vprintfmt+0xd6>
			goto process_precision;
  800b1c:	eb 58                	jmp    800b76 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800b1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b21:	83 f8 30             	cmp    $0x30,%eax
  800b24:	73 17                	jae    800b3d <vprintfmt+0x126>
  800b26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2d:	89 c0                	mov    %eax,%eax
  800b2f:	48 01 d0             	add    %rdx,%rax
  800b32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b35:	83 c2 08             	add    $0x8,%edx
  800b38:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b3b:	eb 0f                	jmp    800b4c <vprintfmt+0x135>
  800b3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b41:	48 89 d0             	mov    %rdx,%rax
  800b44:	48 83 c2 08          	add    $0x8,%rdx
  800b48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4c:	8b 00                	mov    (%rax),%eax
  800b4e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b51:	eb 23                	jmp    800b76 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b53:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b57:	79 0c                	jns    800b65 <vprintfmt+0x14e>
				width = 0;
  800b59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b60:	e9 3b ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>
  800b65:	e9 36 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b6a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b71:	e9 2a ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7a:	79 12                	jns    800b8e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b7c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b7f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b89:	e9 12 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>
  800b8e:	e9 0d ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b93:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b97:	e9 04 ff ff ff       	jmpq   800aa0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9f:	83 f8 30             	cmp    $0x30,%eax
  800ba2:	73 17                	jae    800bbb <vprintfmt+0x1a4>
  800ba4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bab:	89 c0                	mov    %eax,%eax
  800bad:	48 01 d0             	add    %rdx,%rax
  800bb0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb3:	83 c2 08             	add    $0x8,%edx
  800bb6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bb9:	eb 0f                	jmp    800bca <vprintfmt+0x1b3>
  800bbb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bbf:	48 89 d0             	mov    %rdx,%rax
  800bc2:	48 83 c2 08          	add    $0x8,%rdx
  800bc6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bca:	8b 10                	mov    (%rax),%edx
  800bcc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd4:	48 89 ce             	mov    %rcx,%rsi
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	ff d0                	callq  *%rax
			break;
  800bdb:	e9 53 03 00 00       	jmpq   800f33 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800be0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be3:	83 f8 30             	cmp    $0x30,%eax
  800be6:	73 17                	jae    800bff <vprintfmt+0x1e8>
  800be8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bef:	89 c0                	mov    %eax,%eax
  800bf1:	48 01 d0             	add    %rdx,%rax
  800bf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf7:	83 c2 08             	add    $0x8,%edx
  800bfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bfd:	eb 0f                	jmp    800c0e <vprintfmt+0x1f7>
  800bff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c03:	48 89 d0             	mov    %rdx,%rax
  800c06:	48 83 c2 08          	add    $0x8,%rdx
  800c0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c0e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c10:	85 db                	test   %ebx,%ebx
  800c12:	79 02                	jns    800c16 <vprintfmt+0x1ff>
				err = -err;
  800c14:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c16:	83 fb 15             	cmp    $0x15,%ebx
  800c19:	7f 16                	jg     800c31 <vprintfmt+0x21a>
  800c1b:	48 b8 60 3b 80 00 00 	movabs $0x803b60,%rax
  800c22:	00 00 00 
  800c25:	48 63 d3             	movslq %ebx,%rdx
  800c28:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c2c:	4d 85 e4             	test   %r12,%r12
  800c2f:	75 2e                	jne    800c5f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	89 d9                	mov    %ebx,%ecx
  800c3b:	48 ba 21 3c 80 00 00 	movabs $0x803c21,%rdx
  800c42:	00 00 00 
  800c45:	48 89 c7             	mov    %rax,%rdi
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	49 b8 42 0f 80 00 00 	movabs $0x800f42,%r8
  800c54:	00 00 00 
  800c57:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c5a:	e9 d4 02 00 00       	jmpq   800f33 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c5f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c67:	4c 89 e1             	mov    %r12,%rcx
  800c6a:	48 ba 2a 3c 80 00 00 	movabs $0x803c2a,%rdx
  800c71:	00 00 00 
  800c74:	48 89 c7             	mov    %rax,%rdi
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	49 b8 42 0f 80 00 00 	movabs $0x800f42,%r8
  800c83:	00 00 00 
  800c86:	41 ff d0             	callq  *%r8
			break;
  800c89:	e9 a5 02 00 00       	jmpq   800f33 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	83 f8 30             	cmp    $0x30,%eax
  800c94:	73 17                	jae    800cad <vprintfmt+0x296>
  800c96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9d:	89 c0                	mov    %eax,%eax
  800c9f:	48 01 d0             	add    %rdx,%rax
  800ca2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca5:	83 c2 08             	add    $0x8,%edx
  800ca8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cab:	eb 0f                	jmp    800cbc <vprintfmt+0x2a5>
  800cad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb1:	48 89 d0             	mov    %rdx,%rax
  800cb4:	48 83 c2 08          	add    $0x8,%rdx
  800cb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbc:	4c 8b 20             	mov    (%rax),%r12
  800cbf:	4d 85 e4             	test   %r12,%r12
  800cc2:	75 0a                	jne    800cce <vprintfmt+0x2b7>
				p = "(null)";
  800cc4:	49 bc 2d 3c 80 00 00 	movabs $0x803c2d,%r12
  800ccb:	00 00 00 
			if (width > 0 && padc != '-')
  800cce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd2:	7e 3f                	jle    800d13 <vprintfmt+0x2fc>
  800cd4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cd8:	74 39                	je     800d13 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cda:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cdd:	48 98                	cltq   
  800cdf:	48 89 c6             	mov    %rax,%rsi
  800ce2:	4c 89 e7             	mov    %r12,%rdi
  800ce5:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	callq  *%rax
  800cf1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cf4:	eb 17                	jmp    800d0d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cf6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cfa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 ce             	mov    %rcx,%rsi
  800d05:	89 d7                	mov    %edx,%edi
  800d07:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d09:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d11:	7f e3                	jg     800cf6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d13:	eb 37                	jmp    800d4c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800d15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d19:	74 1e                	je     800d39 <vprintfmt+0x322>
  800d1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d1e:	7e 05                	jle    800d25 <vprintfmt+0x30e>
  800d20:	83 fb 7e             	cmp    $0x7e,%ebx
  800d23:	7e 14                	jle    800d39 <vprintfmt+0x322>
					putch('?', putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d35:	ff d0                	callq  *%rax
  800d37:	eb 0f                	jmp    800d48 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d41:	48 89 d6             	mov    %rdx,%rsi
  800d44:	89 df                	mov    %ebx,%edi
  800d46:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d4c:	4c 89 e0             	mov    %r12,%rax
  800d4f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d53:	0f b6 00             	movzbl (%rax),%eax
  800d56:	0f be d8             	movsbl %al,%ebx
  800d59:	85 db                	test   %ebx,%ebx
  800d5b:	74 10                	je     800d6d <vprintfmt+0x356>
  800d5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d61:	78 b2                	js     800d15 <vprintfmt+0x2fe>
  800d63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d6b:	79 a8                	jns    800d15 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6d:	eb 16                	jmp    800d85 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d77:	48 89 d6             	mov    %rdx,%rsi
  800d7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d7f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d89:	7f e4                	jg     800d6f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d8b:	e9 a3 01 00 00       	jmpq   800f33 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d94:	be 03 00 00 00       	mov    $0x3,%esi
  800d99:	48 89 c7             	mov    %rax,%rdi
  800d9c:	48 b8 07 09 80 00 00 	movabs $0x800907,%rax
  800da3:	00 00 00 
  800da6:	ff d0                	callq  *%rax
  800da8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db0:	48 85 c0             	test   %rax,%rax
  800db3:	79 1d                	jns    800dd2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800db5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dbd:	48 89 d6             	mov    %rdx,%rsi
  800dc0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dc5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dcb:	48 f7 d8             	neg    %rax
  800dce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd9:	e9 e8 00 00 00       	jmpq   800ec6 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de2:	be 03 00 00 00       	mov    $0x3,%esi
  800de7:	48 89 c7             	mov    %rax,%rdi
  800dea:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	callq  *%rax
  800df6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dfa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e01:	e9 c0 00 00 00       	jmpq   800ec6 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	48 89 d6             	mov    %rdx,%rsi
  800e11:	bf 58 00 00 00       	mov    $0x58,%edi
  800e16:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e20:	48 89 d6             	mov    %rdx,%rsi
  800e23:	bf 58 00 00 00       	mov    $0x58,%edi
  800e28:	ff d0                	callq  *%rax
			putch('X', putdat);
  800e2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e32:	48 89 d6             	mov    %rdx,%rsi
  800e35:	bf 58 00 00 00       	mov    $0x58,%edi
  800e3a:	ff d0                	callq  *%rax
			break;
  800e3c:	e9 f2 00 00 00       	jmpq   800f33 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800e41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e49:	48 89 d6             	mov    %rdx,%rsi
  800e4c:	bf 30 00 00 00       	mov    $0x30,%edi
  800e51:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5b:	48 89 d6             	mov    %rdx,%rsi
  800e5e:	bf 78 00 00 00       	mov    $0x78,%edi
  800e63:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e68:	83 f8 30             	cmp    $0x30,%eax
  800e6b:	73 17                	jae    800e84 <vprintfmt+0x46d>
  800e6d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e74:	89 c0                	mov    %eax,%eax
  800e76:	48 01 d0             	add    %rdx,%rax
  800e79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e7c:	83 c2 08             	add    $0x8,%edx
  800e7f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e82:	eb 0f                	jmp    800e93 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800e84:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e88:	48 89 d0             	mov    %rdx,%rax
  800e8b:	48 83 c2 08          	add    $0x8,%rdx
  800e8f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e93:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e9a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ea1:	eb 23                	jmp    800ec6 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ea3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea7:	be 03 00 00 00       	mov    $0x3,%esi
  800eac:	48 89 c7             	mov    %rax,%rdi
  800eaf:	48 b8 f7 07 80 00 00 	movabs $0x8007f7,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
  800ebb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ebf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ecb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ece:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ed1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ed9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edd:	45 89 c1             	mov    %r8d,%r9d
  800ee0:	41 89 f8             	mov    %edi,%r8d
  800ee3:	48 89 c7             	mov    %rax,%rdi
  800ee6:	48 b8 3c 07 80 00 00 	movabs $0x80073c,%rax
  800eed:	00 00 00 
  800ef0:	ff d0                	callq  *%rax
			break;
  800ef2:	eb 3f                	jmp    800f33 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efc:	48 89 d6             	mov    %rdx,%rsi
  800eff:	89 df                	mov    %ebx,%edi
  800f01:	ff d0                	callq  *%rax
			break;
  800f03:	eb 2e                	jmp    800f33 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0d:	48 89 d6             	mov    %rdx,%rsi
  800f10:	bf 25 00 00 00       	mov    $0x25,%edi
  800f15:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f17:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f1c:	eb 05                	jmp    800f23 <vprintfmt+0x50c>
  800f1e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f23:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f27:	48 83 e8 01          	sub    $0x1,%rax
  800f2b:	0f b6 00             	movzbl (%rax),%eax
  800f2e:	3c 25                	cmp    $0x25,%al
  800f30:	75 ec                	jne    800f1e <vprintfmt+0x507>
				/* do nothing */;
			break;
  800f32:	90                   	nop
		}
	}
  800f33:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f34:	e9 30 fb ff ff       	jmpq   800a69 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f39:	48 83 c4 60          	add    $0x60,%rsp
  800f3d:	5b                   	pop    %rbx
  800f3e:	41 5c                	pop    %r12
  800f40:	5d                   	pop    %rbp
  800f41:	c3                   	retq   

0000000000800f42 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f42:	55                   	push   %rbp
  800f43:	48 89 e5             	mov    %rsp,%rbp
  800f46:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f4d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f54:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f5b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f62:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f69:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f70:	84 c0                	test   %al,%al
  800f72:	74 20                	je     800f94 <printfmt+0x52>
  800f74:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f78:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f7c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f80:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f84:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f88:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f8c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f90:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f94:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f9b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fa2:	00 00 00 
  800fa5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fac:	00 00 00 
  800faf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fb3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fc1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fc8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fcf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fd6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fdd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fe4:	48 89 c7             	mov    %rax,%rdi
  800fe7:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  800fee:	00 00 00 
  800ff1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ff3:	c9                   	leaveq 
  800ff4:	c3                   	retq   

0000000000800ff5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff5:	55                   	push   %rbp
  800ff6:	48 89 e5             	mov    %rsp,%rbp
  800ff9:	48 83 ec 10          	sub    $0x10,%rsp
  800ffd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801000:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801008:	8b 40 10             	mov    0x10(%rax),%eax
  80100b:	8d 50 01             	lea    0x1(%rax),%edx
  80100e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801012:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801019:	48 8b 10             	mov    (%rax),%rdx
  80101c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801020:	48 8b 40 08          	mov    0x8(%rax),%rax
  801024:	48 39 c2             	cmp    %rax,%rdx
  801027:	73 17                	jae    801040 <sprintputch+0x4b>
		*b->buf++ = ch;
  801029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102d:	48 8b 00             	mov    (%rax),%rax
  801030:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801034:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801038:	48 89 0a             	mov    %rcx,(%rdx)
  80103b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80103e:	88 10                	mov    %dl,(%rax)
}
  801040:	c9                   	leaveq 
  801041:	c3                   	retq   

0000000000801042 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801042:	55                   	push   %rbp
  801043:	48 89 e5             	mov    %rsp,%rbp
  801046:	48 83 ec 50          	sub    $0x50,%rsp
  80104a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80104e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801051:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801055:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801059:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80105d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801061:	48 8b 0a             	mov    (%rdx),%rcx
  801064:	48 89 08             	mov    %rcx,(%rax)
  801067:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80106b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80106f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801073:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801077:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80107b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80107f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801082:	48 98                	cltq   
  801084:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801088:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80108c:	48 01 d0             	add    %rdx,%rax
  80108f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801093:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80109a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80109f:	74 06                	je     8010a7 <vsnprintf+0x65>
  8010a1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010a5:	7f 07                	jg     8010ae <vsnprintf+0x6c>
		return -E_INVAL;
  8010a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ac:	eb 2f                	jmp    8010dd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010ae:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010b2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010b6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010ba:	48 89 c6             	mov    %rax,%rsi
  8010bd:	48 bf f5 0f 80 00 00 	movabs $0x800ff5,%rdi
  8010c4:	00 00 00 
  8010c7:	48 b8 17 0a 80 00 00 	movabs $0x800a17,%rax
  8010ce:	00 00 00 
  8010d1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010d7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010da:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010dd:	c9                   	leaveq 
  8010de:	c3                   	retq   

00000000008010df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010df:	55                   	push   %rbp
  8010e0:	48 89 e5             	mov    %rsp,%rbp
  8010e3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010ea:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010f1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010f7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010fe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801105:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80110c:	84 c0                	test   %al,%al
  80110e:	74 20                	je     801130 <snprintf+0x51>
  801110:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801114:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801118:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80111c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801120:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801124:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801128:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80112c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801130:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801137:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80113e:	00 00 00 
  801141:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801148:	00 00 00 
  80114b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80114f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801156:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80115d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801164:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80116b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801172:	48 8b 0a             	mov    (%rdx),%rcx
  801175:	48 89 08             	mov    %rcx,(%rax)
  801178:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80117c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801180:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801184:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801188:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80118f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801196:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80119c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011a3:	48 89 c7             	mov    %rax,%rdi
  8011a6:	48 b8 42 10 80 00 00 	movabs $0x801042,%rax
  8011ad:	00 00 00 
  8011b0:	ff d0                	callq  *%rax
  8011b2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011b8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011be:	c9                   	leaveq 
  8011bf:	c3                   	retq   

00000000008011c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	48 83 ec 18          	sub    $0x18,%rsp
  8011c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d3:	eb 09                	jmp    8011de <strlen+0x1e>
		n++;
  8011d5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011d9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e2:	0f b6 00             	movzbl (%rax),%eax
  8011e5:	84 c0                	test   %al,%al
  8011e7:	75 ec                	jne    8011d5 <strlen+0x15>
		n++;
	return n;
  8011e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 20          	sub    $0x20,%rsp
  8011f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801205:	eb 0e                	jmp    801215 <strnlen+0x27>
		n++;
  801207:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80120b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801210:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801215:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80121a:	74 0b                	je     801227 <strnlen+0x39>
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	84 c0                	test   %al,%al
  801225:	75 e0                	jne    801207 <strnlen+0x19>
		n++;
	return n;
  801227:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80122a:	c9                   	leaveq 
  80122b:	c3                   	retq   

000000000080122c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80122c:	55                   	push   %rbp
  80122d:	48 89 e5             	mov    %rsp,%rbp
  801230:	48 83 ec 20          	sub    $0x20,%rsp
  801234:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801238:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801244:	90                   	nop
  801245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801249:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80124d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801251:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801255:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801259:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80125d:	0f b6 12             	movzbl (%rdx),%edx
  801260:	88 10                	mov    %dl,(%rax)
  801262:	0f b6 00             	movzbl (%rax),%eax
  801265:	84 c0                	test   %al,%al
  801267:	75 dc                	jne    801245 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 20          	sub    $0x20,%rsp
  801277:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 89 c7             	mov    %rax,%rdi
  801286:	48 b8 c0 11 80 00 00 	movabs $0x8011c0,%rax
  80128d:	00 00 00 
  801290:	ff d0                	callq  *%rax
  801292:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801295:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801298:	48 63 d0             	movslq %eax,%rdx
  80129b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129f:	48 01 c2             	add    %rax,%rdx
  8012a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a6:	48 89 c6             	mov    %rax,%rsi
  8012a9:	48 89 d7             	mov    %rdx,%rdi
  8012ac:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  8012b3:	00 00 00 
  8012b6:	ff d0                	callq  *%rax
	return dst;
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 83 ec 28          	sub    $0x28,%rsp
  8012c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012e1:	00 
  8012e2:	eb 2a                	jmp    80130e <strncpy+0x50>
		*dst++ = *src;
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f4:	0f b6 12             	movzbl (%rdx),%edx
  8012f7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	84 c0                	test   %al,%al
  801302:	74 05                	je     801309 <strncpy+0x4b>
			src++;
  801304:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801309:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801312:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801316:	72 cc                	jb     8012e4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80131c:	c9                   	leaveq 
  80131d:	c3                   	retq   

000000000080131e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80131e:	55                   	push   %rbp
  80131f:	48 89 e5             	mov    %rsp,%rbp
  801322:	48 83 ec 28          	sub    $0x28,%rsp
  801326:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801336:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80133a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80133f:	74 3d                	je     80137e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801341:	eb 1d                	jmp    801360 <strlcpy+0x42>
			*dst++ = *src++;
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80134b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80134f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801353:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801357:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80135b:	0f b6 12             	movzbl (%rdx),%edx
  80135e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801360:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801365:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80136a:	74 0b                	je     801377 <strlcpy+0x59>
  80136c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	84 c0                	test   %al,%al
  801375:	75 cc                	jne    801343 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80137e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	48 29 c2             	sub    %rax,%rdx
  801389:	48 89 d0             	mov    %rdx,%rax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 10          	sub    $0x10,%rsp
  801396:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80139e:	eb 0a                	jmp    8013aa <strcmp+0x1c>
		p++, q++;
  8013a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	84 c0                	test   %al,%al
  8013b3:	74 12                	je     8013c7 <strcmp+0x39>
  8013b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b9:	0f b6 10             	movzbl (%rax),%edx
  8013bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c0:	0f b6 00             	movzbl (%rax),%eax
  8013c3:	38 c2                	cmp    %al,%dl
  8013c5:	74 d9                	je     8013a0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d5:	0f b6 00             	movzbl (%rax),%eax
  8013d8:	0f b6 c0             	movzbl %al,%eax
  8013db:	29 c2                	sub    %eax,%edx
  8013dd:	89 d0                	mov    %edx,%eax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 83 ec 18          	sub    $0x18,%rsp
  8013e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013f5:	eb 0f                	jmp    801406 <strncmp+0x25>
		n--, p++, q++;
  8013f7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801401:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801406:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80140b:	74 1d                	je     80142a <strncmp+0x49>
  80140d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	84 c0                	test   %al,%al
  801416:	74 12                	je     80142a <strncmp+0x49>
  801418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141c:	0f b6 10             	movzbl (%rax),%edx
  80141f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	38 c2                	cmp    %al,%dl
  801428:	74 cd                	je     8013f7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80142a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142f:	75 07                	jne    801438 <strncmp+0x57>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 18                	jmp    801450 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	0f b6 d0             	movzbl %al,%edx
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	0f b6 c0             	movzbl %al,%eax
  80144c:	29 c2                	sub    %eax,%edx
  80144e:	89 d0                	mov    %edx,%eax
}
  801450:	c9                   	leaveq 
  801451:	c3                   	retq   

0000000000801452 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801452:	55                   	push   %rbp
  801453:	48 89 e5             	mov    %rsp,%rbp
  801456:	48 83 ec 0c          	sub    $0xc,%rsp
  80145a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145e:	89 f0                	mov    %esi,%eax
  801460:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801463:	eb 17                	jmp    80147c <strchr+0x2a>
		if (*s == c)
  801465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801469:	0f b6 00             	movzbl (%rax),%eax
  80146c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80146f:	75 06                	jne    801477 <strchr+0x25>
			return (char *) s;
  801471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801475:	eb 15                	jmp    80148c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801477:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	84 c0                	test   %al,%al
  801485:	75 de                	jne    801465 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148c:	c9                   	leaveq 
  80148d:	c3                   	retq   

000000000080148e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148e:	55                   	push   %rbp
  80148f:	48 89 e5             	mov    %rsp,%rbp
  801492:	48 83 ec 0c          	sub    $0xc,%rsp
  801496:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80149f:	eb 13                	jmp    8014b4 <strfind+0x26>
		if (*s == c)
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014ab:	75 02                	jne    8014af <strfind+0x21>
			break;
  8014ad:	eb 10                	jmp    8014bf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	84 c0                	test   %al,%al
  8014bd:	75 e2                	jne    8014a1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014c3:	c9                   	leaveq 
  8014c4:	c3                   	retq   

00000000008014c5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	48 83 ec 18          	sub    $0x18,%rsp
  8014cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014dd:	75 06                	jne    8014e5 <memset+0x20>
		return v;
  8014df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e3:	eb 69                	jmp    80154e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e9:	83 e0 03             	and    $0x3,%eax
  8014ec:	48 85 c0             	test   %rax,%rax
  8014ef:	75 48                	jne    801539 <memset+0x74>
  8014f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f5:	83 e0 03             	and    $0x3,%eax
  8014f8:	48 85 c0             	test   %rax,%rax
  8014fb:	75 3c                	jne    801539 <memset+0x74>
		c &= 0xFF;
  8014fd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801504:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801507:	c1 e0 18             	shl    $0x18,%eax
  80150a:	89 c2                	mov    %eax,%edx
  80150c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150f:	c1 e0 10             	shl    $0x10,%eax
  801512:	09 c2                	or     %eax,%edx
  801514:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801517:	c1 e0 08             	shl    $0x8,%eax
  80151a:	09 d0                	or     %edx,%eax
  80151c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80151f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801523:	48 c1 e8 02          	shr    $0x2,%rax
  801527:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80152a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80152e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801531:	48 89 d7             	mov    %rdx,%rdi
  801534:	fc                   	cld    
  801535:	f3 ab                	rep stos %eax,%es:(%rdi)
  801537:	eb 11                	jmp    80154a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801539:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801540:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801544:	48 89 d7             	mov    %rdx,%rdi
  801547:	fc                   	cld    
  801548:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80154e:	c9                   	leaveq 
  80154f:	c3                   	retq   

0000000000801550 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801550:	55                   	push   %rbp
  801551:	48 89 e5             	mov    %rsp,%rbp
  801554:	48 83 ec 28          	sub    $0x28,%rsp
  801558:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801560:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801564:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801568:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801570:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801578:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80157c:	0f 83 88 00 00 00    	jae    80160a <memmove+0xba>
  801582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801586:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158a:	48 01 d0             	add    %rdx,%rax
  80158d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801591:	76 77                	jbe    80160a <memmove+0xba>
		s += n;
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80159b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a7:	83 e0 03             	and    $0x3,%eax
  8015aa:	48 85 c0             	test   %rax,%rax
  8015ad:	75 3b                	jne    8015ea <memmove+0x9a>
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	83 e0 03             	and    $0x3,%eax
  8015b6:	48 85 c0             	test   %rax,%rax
  8015b9:	75 2f                	jne    8015ea <memmove+0x9a>
  8015bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bf:	83 e0 03             	and    $0x3,%eax
  8015c2:	48 85 c0             	test   %rax,%rax
  8015c5:	75 23                	jne    8015ea <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cb:	48 83 e8 04          	sub    $0x4,%rax
  8015cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015d3:	48 83 ea 04          	sub    $0x4,%rdx
  8015d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015db:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015df:	48 89 c7             	mov    %rax,%rdi
  8015e2:	48 89 d6             	mov    %rdx,%rsi
  8015e5:	fd                   	std    
  8015e6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015e8:	eb 1d                	jmp    801607 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ee:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	48 89 d7             	mov    %rdx,%rdi
  801601:	48 89 c1             	mov    %rax,%rcx
  801604:	fd                   	std    
  801605:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801607:	fc                   	cld    
  801608:	eb 57                	jmp    801661 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160e:	83 e0 03             	and    $0x3,%eax
  801611:	48 85 c0             	test   %rax,%rax
  801614:	75 36                	jne    80164c <memmove+0xfc>
  801616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161a:	83 e0 03             	and    $0x3,%eax
  80161d:	48 85 c0             	test   %rax,%rax
  801620:	75 2a                	jne    80164c <memmove+0xfc>
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	83 e0 03             	and    $0x3,%eax
  801629:	48 85 c0             	test   %rax,%rax
  80162c:	75 1e                	jne    80164c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	48 c1 e8 02          	shr    $0x2,%rax
  801636:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801639:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801641:	48 89 c7             	mov    %rax,%rdi
  801644:	48 89 d6             	mov    %rdx,%rsi
  801647:	fc                   	cld    
  801648:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80164a:	eb 15                	jmp    801661 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80164c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801650:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801654:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801658:	48 89 c7             	mov    %rax,%rdi
  80165b:	48 89 d6             	mov    %rdx,%rsi
  80165e:	fc                   	cld    
  80165f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801665:	c9                   	leaveq 
  801666:	c3                   	retq   

0000000000801667 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801667:	55                   	push   %rbp
  801668:	48 89 e5             	mov    %rsp,%rbp
  80166b:	48 83 ec 18          	sub    $0x18,%rsp
  80166f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801673:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801677:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80167b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801687:	48 89 ce             	mov    %rcx,%rsi
  80168a:	48 89 c7             	mov    %rax,%rdi
  80168d:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
}
  801699:	c9                   	leaveq 
  80169a:	c3                   	retq   

000000000080169b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	48 83 ec 28          	sub    $0x28,%rsp
  8016a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016bf:	eb 36                	jmp    8016f7 <memcmp+0x5c>
		if (*s1 != *s2)
  8016c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c5:	0f b6 10             	movzbl (%rax),%edx
  8016c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	38 c2                	cmp    %al,%dl
  8016d1:	74 1a                	je     8016ed <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	0f b6 d0             	movzbl %al,%edx
  8016dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	0f b6 c0             	movzbl %al,%eax
  8016e7:	29 c2                	sub    %eax,%edx
  8016e9:	89 d0                	mov    %edx,%eax
  8016eb:	eb 20                	jmp    80170d <memcmp+0x72>
		s1++, s2++;
  8016ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801703:	48 85 c0             	test   %rax,%rax
  801706:	75 b9                	jne    8016c1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 28          	sub    $0x28,%rsp
  801717:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80171b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80171e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172a:	48 01 d0             	add    %rdx,%rax
  80172d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801731:	eb 15                	jmp    801748 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801737:	0f b6 10             	movzbl (%rax),%edx
  80173a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80173d:	38 c2                	cmp    %al,%dl
  80173f:	75 02                	jne    801743 <memfind+0x34>
			break;
  801741:	eb 0f                	jmp    801752 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801743:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801750:	72 e1                	jb     801733 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801756:	c9                   	leaveq 
  801757:	c3                   	retq   

0000000000801758 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	48 83 ec 34          	sub    $0x34,%rsp
  801760:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801764:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801768:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80176b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801772:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801779:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80177a:	eb 05                	jmp    801781 <strtol+0x29>
		s++;
  80177c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	3c 20                	cmp    $0x20,%al
  80178a:	74 f0                	je     80177c <strtol+0x24>
  80178c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801790:	0f b6 00             	movzbl (%rax),%eax
  801793:	3c 09                	cmp    $0x9,%al
  801795:	74 e5                	je     80177c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	3c 2b                	cmp    $0x2b,%al
  8017a0:	75 07                	jne    8017a9 <strtol+0x51>
		s++;
  8017a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a7:	eb 17                	jmp    8017c0 <strtol+0x68>
	else if (*s == '-')
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	3c 2d                	cmp    $0x2d,%al
  8017b2:	75 0c                	jne    8017c0 <strtol+0x68>
		s++, neg = 1;
  8017b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c4:	74 06                	je     8017cc <strtol+0x74>
  8017c6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017ca:	75 28                	jne    8017f4 <strtol+0x9c>
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	0f b6 00             	movzbl (%rax),%eax
  8017d3:	3c 30                	cmp    $0x30,%al
  8017d5:	75 1d                	jne    8017f4 <strtol+0x9c>
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	48 83 c0 01          	add    $0x1,%rax
  8017df:	0f b6 00             	movzbl (%rax),%eax
  8017e2:	3c 78                	cmp    $0x78,%al
  8017e4:	75 0e                	jne    8017f4 <strtol+0x9c>
		s += 2, base = 16;
  8017e6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017eb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017f2:	eb 2c                	jmp    801820 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f8:	75 19                	jne    801813 <strtol+0xbb>
  8017fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fe:	0f b6 00             	movzbl (%rax),%eax
  801801:	3c 30                	cmp    $0x30,%al
  801803:	75 0e                	jne    801813 <strtol+0xbb>
		s++, base = 8;
  801805:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80180a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801811:	eb 0d                	jmp    801820 <strtol+0xc8>
	else if (base == 0)
  801813:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801817:	75 07                	jne    801820 <strtol+0xc8>
		base = 10;
  801819:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801824:	0f b6 00             	movzbl (%rax),%eax
  801827:	3c 2f                	cmp    $0x2f,%al
  801829:	7e 1d                	jle    801848 <strtol+0xf0>
  80182b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	3c 39                	cmp    $0x39,%al
  801834:	7f 12                	jg     801848 <strtol+0xf0>
			dig = *s - '0';
  801836:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	0f be c0             	movsbl %al,%eax
  801840:	83 e8 30             	sub    $0x30,%eax
  801843:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801846:	eb 4e                	jmp    801896 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3c 60                	cmp    $0x60,%al
  801851:	7e 1d                	jle    801870 <strtol+0x118>
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	3c 7a                	cmp    $0x7a,%al
  80185c:	7f 12                	jg     801870 <strtol+0x118>
			dig = *s - 'a' + 10;
  80185e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801862:	0f b6 00             	movzbl (%rax),%eax
  801865:	0f be c0             	movsbl %al,%eax
  801868:	83 e8 57             	sub    $0x57,%eax
  80186b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80186e:	eb 26                	jmp    801896 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801874:	0f b6 00             	movzbl (%rax),%eax
  801877:	3c 40                	cmp    $0x40,%al
  801879:	7e 48                	jle    8018c3 <strtol+0x16b>
  80187b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187f:	0f b6 00             	movzbl (%rax),%eax
  801882:	3c 5a                	cmp    $0x5a,%al
  801884:	7f 3d                	jg     8018c3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	0f be c0             	movsbl %al,%eax
  801890:	83 e8 37             	sub    $0x37,%eax
  801893:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801896:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801899:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80189c:	7c 02                	jl     8018a0 <strtol+0x148>
			break;
  80189e:	eb 23                	jmp    8018c3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018a8:	48 98                	cltq   
  8018aa:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018af:	48 89 c2             	mov    %rax,%rdx
  8018b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b5:	48 98                	cltq   
  8018b7:	48 01 d0             	add    %rdx,%rax
  8018ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018be:	e9 5d ff ff ff       	jmpq   801820 <strtol+0xc8>

	if (endptr)
  8018c3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018c8:	74 0b                	je     8018d5 <strtol+0x17d>
		*endptr = (char *) s;
  8018ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ce:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018d2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018d9:	74 09                	je     8018e4 <strtol+0x18c>
  8018db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018df:	48 f7 d8             	neg    %rax
  8018e2:	eb 04                	jmp    8018e8 <strtol+0x190>
  8018e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018e8:	c9                   	leaveq 
  8018e9:	c3                   	retq   

00000000008018ea <strstr>:

char * strstr(const char *in, const char *str)
{
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	48 83 ec 30          	sub    $0x30,%rsp
  8018f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801902:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80190c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801910:	75 06                	jne    801918 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801916:	eb 6b                	jmp    801983 <strstr+0x99>

	len = strlen(str);
  801918:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80191c:	48 89 c7             	mov    %rax,%rdi
  80191f:	48 b8 c0 11 80 00 00 	movabs $0x8011c0,%rax
  801926:	00 00 00 
  801929:	ff d0                	callq  *%rax
  80192b:	48 98                	cltq   
  80192d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801935:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801939:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80193d:	0f b6 00             	movzbl (%rax),%eax
  801940:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801943:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801947:	75 07                	jne    801950 <strstr+0x66>
				return (char *) 0;
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
  80194e:	eb 33                	jmp    801983 <strstr+0x99>
		} while (sc != c);
  801950:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801954:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801957:	75 d8                	jne    801931 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801959:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801961:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801965:	48 89 ce             	mov    %rcx,%rsi
  801968:	48 89 c7             	mov    %rax,%rdi
  80196b:	48 b8 e1 13 80 00 00 	movabs $0x8013e1,%rax
  801972:	00 00 00 
  801975:	ff d0                	callq  *%rax
  801977:	85 c0                	test   %eax,%eax
  801979:	75 b6                	jne    801931 <strstr+0x47>

	return (char *) (in - 1);
  80197b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197f:	48 83 e8 01          	sub    $0x1,%rax
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	53                   	push   %rbx
  80198a:	48 83 ec 48          	sub    $0x48,%rsp
  80198e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801991:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801994:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801998:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80199c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019a0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019ab:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019af:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019b3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019b7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019bb:	4c 89 c3             	mov    %r8,%rbx
  8019be:	cd 30                	int    $0x30
  8019c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019c8:	74 3e                	je     801a08 <syscall+0x83>
  8019ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019cf:	7e 37                	jle    801a08 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019d8:	49 89 d0             	mov    %rdx,%r8
  8019db:	89 c1                	mov    %eax,%ecx
  8019dd:	48 ba e8 3e 80 00 00 	movabs $0x803ee8,%rdx
  8019e4:	00 00 00 
  8019e7:	be 23 00 00 00       	mov    $0x23,%esi
  8019ec:	48 bf 05 3f 80 00 00 	movabs $0x803f05,%rdi
  8019f3:	00 00 00 
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	49 b9 2b 04 80 00 00 	movabs $0x80042b,%r9
  801a02:	00 00 00 
  801a05:	41 ff d1             	callq  *%r9

	return ret;
  801a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a0c:	48 83 c4 48          	add    $0x48,%rsp
  801a10:	5b                   	pop    %rbx
  801a11:	5d                   	pop    %rbp
  801a12:	c3                   	retq   

0000000000801a13 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a13:	55                   	push   %rbp
  801a14:	48 89 e5             	mov    %rsp,%rbp
  801a17:	48 83 ec 20          	sub    $0x20,%rsp
  801a1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a32:	00 
  801a33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3f:	48 89 d1             	mov    %rdx,%rcx
  801a42:	48 89 c2             	mov    %rax,%rdx
  801a45:	be 00 00 00 00       	mov    $0x0,%esi
  801a4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4f:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801a56:	00 00 00 
  801a59:	ff d0                	callq  *%rax
}
  801a5b:	c9                   	leaveq 
  801a5c:	c3                   	retq   

0000000000801a5d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5d:	55                   	push   %rbp
  801a5e:	48 89 e5             	mov    %rsp,%rbp
  801a61:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6c:	00 
  801a6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a79:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a83:	be 00 00 00 00       	mov    $0x0,%esi
  801a88:	bf 01 00 00 00       	mov    $0x1,%edi
  801a8d:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a9b:	55                   	push   %rbp
  801a9c:	48 89 e5             	mov    %rsp,%rbp
  801a9f:	48 83 ec 10          	sub    $0x10,%rsp
  801aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab2:	00 
  801ab3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac4:	48 89 c2             	mov    %rax,%rdx
  801ac7:	be 01 00 00 00       	mov    $0x1,%esi
  801acc:	bf 03 00 00 00       	mov    $0x3,%edi
  801ad1:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801ad8:	00 00 00 
  801adb:	ff d0                	callq  *%rax
}
  801add:	c9                   	leaveq 
  801ade:	c3                   	retq   

0000000000801adf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801adf:	55                   	push   %rbp
  801ae0:	48 89 e5             	mov    %rsp,%rbp
  801ae3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ae7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aee:	00 
  801aef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b00:	ba 00 00 00 00       	mov    $0x0,%edx
  801b05:	be 00 00 00 00       	mov    $0x0,%esi
  801b0a:	bf 02 00 00 00       	mov    $0x2,%edi
  801b0f:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801b16:	00 00 00 
  801b19:	ff d0                	callq  *%rax
}
  801b1b:	c9                   	leaveq 
  801b1c:	c3                   	retq   

0000000000801b1d <sys_yield>:

void
sys_yield(void)
{
  801b1d:	55                   	push   %rbp
  801b1e:	48 89 e5             	mov    %rsp,%rbp
  801b21:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2c:	00 
  801b2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b43:	be 00 00 00 00       	mov    $0x0,%esi
  801b48:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b4d:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
}
  801b59:	c9                   	leaveq 
  801b5a:	c3                   	retq   

0000000000801b5b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b5b:	55                   	push   %rbp
  801b5c:	48 89 e5             	mov    %rsp,%rbp
  801b5f:	48 83 ec 20          	sub    $0x20,%rsp
  801b63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b6a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b70:	48 63 c8             	movslq %eax,%rcx
  801b73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7a:	48 98                	cltq   
  801b7c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b83:	00 
  801b84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8a:	49 89 c8             	mov    %rcx,%r8
  801b8d:	48 89 d1             	mov    %rdx,%rcx
  801b90:	48 89 c2             	mov    %rax,%rdx
  801b93:	be 01 00 00 00       	mov    $0x1,%esi
  801b98:	bf 04 00 00 00       	mov    $0x4,%edi
  801b9d:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 30          	sub    $0x30,%rsp
  801bb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bba:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bbd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bc1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bc5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc8:	48 63 c8             	movslq %eax,%rcx
  801bcb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bcf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd2:	48 63 f0             	movslq %eax,%rsi
  801bd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdc:	48 98                	cltq   
  801bde:	48 89 0c 24          	mov    %rcx,(%rsp)
  801be2:	49 89 f9             	mov    %rdi,%r9
  801be5:	49 89 f0             	mov    %rsi,%r8
  801be8:	48 89 d1             	mov    %rdx,%rcx
  801beb:	48 89 c2             	mov    %rax,%rdx
  801bee:	be 01 00 00 00       	mov    $0x1,%esi
  801bf3:	bf 05 00 00 00       	mov    $0x5,%edi
  801bf8:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
}
  801c04:	c9                   	leaveq 
  801c05:	c3                   	retq   

0000000000801c06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c06:	55                   	push   %rbp
  801c07:	48 89 e5             	mov    %rsp,%rbp
  801c0a:	48 83 ec 20          	sub    $0x20,%rsp
  801c0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1c:	48 98                	cltq   
  801c1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c25:	00 
  801c26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c32:	48 89 d1             	mov    %rdx,%rcx
  801c35:	48 89 c2             	mov    %rax,%rdx
  801c38:	be 01 00 00 00       	mov    $0x1,%esi
  801c3d:	bf 06 00 00 00       	mov    $0x6,%edi
  801c42:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801c49:	00 00 00 
  801c4c:	ff d0                	callq  *%rax
}
  801c4e:	c9                   	leaveq 
  801c4f:	c3                   	retq   

0000000000801c50 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c50:	55                   	push   %rbp
  801c51:	48 89 e5             	mov    %rsp,%rbp
  801c54:	48 83 ec 10          	sub    $0x10,%rsp
  801c58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c5b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c61:	48 63 d0             	movslq %eax,%rdx
  801c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c67:	48 98                	cltq   
  801c69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c70:	00 
  801c71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7d:	48 89 d1             	mov    %rdx,%rcx
  801c80:	48 89 c2             	mov    %rax,%rdx
  801c83:	be 01 00 00 00       	mov    $0x1,%esi
  801c88:	bf 08 00 00 00       	mov    $0x8,%edi
  801c8d:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	callq  *%rax
}
  801c99:	c9                   	leaveq 
  801c9a:	c3                   	retq   

0000000000801c9b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
  801c9f:	48 83 ec 20          	sub    $0x20,%rsp
  801ca3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801caa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb1:	48 98                	cltq   
  801cb3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cba:	00 
  801cbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc7:	48 89 d1             	mov    %rdx,%rcx
  801cca:	48 89 c2             	mov    %rax,%rdx
  801ccd:	be 01 00 00 00       	mov    $0x1,%esi
  801cd2:	bf 09 00 00 00       	mov    $0x9,%edi
  801cd7:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
}
  801ce3:	c9                   	leaveq 
  801ce4:	c3                   	retq   

0000000000801ce5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ce5:	55                   	push   %rbp
  801ce6:	48 89 e5             	mov    %rsp,%rbp
  801ce9:	48 83 ec 20          	sub    $0x20,%rsp
  801ced:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfb:	48 98                	cltq   
  801cfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d04:	00 
  801d05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d11:	48 89 d1             	mov    %rdx,%rcx
  801d14:	48 89 c2             	mov    %rax,%rdx
  801d17:	be 01 00 00 00       	mov    $0x1,%esi
  801d1c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d21:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
}
  801d2d:	c9                   	leaveq 
  801d2e:	c3                   	retq   

0000000000801d2f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d2f:	55                   	push   %rbp
  801d30:	48 89 e5             	mov    %rsp,%rbp
  801d33:	48 83 ec 20          	sub    $0x20,%rsp
  801d37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d42:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d48:	48 63 f0             	movslq %eax,%rsi
  801d4b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d52:	48 98                	cltq   
  801d54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5f:	00 
  801d60:	49 89 f1             	mov    %rsi,%r9
  801d63:	49 89 c8             	mov    %rcx,%r8
  801d66:	48 89 d1             	mov    %rdx,%rcx
  801d69:	48 89 c2             	mov    %rax,%rdx
  801d6c:	be 00 00 00 00       	mov    $0x0,%esi
  801d71:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d76:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801d7d:	00 00 00 
  801d80:	ff d0                	callq  *%rax
}
  801d82:	c9                   	leaveq 
  801d83:	c3                   	retq   

0000000000801d84 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d84:	55                   	push   %rbp
  801d85:	48 89 e5             	mov    %rsp,%rbp
  801d88:	48 83 ec 10          	sub    $0x10,%rsp
  801d8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d9b:	00 
  801d9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dad:	48 89 c2             	mov    %rax,%rdx
  801db0:	be 01 00 00 00       	mov    $0x1,%esi
  801db5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dba:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
}
  801dc6:	c9                   	leaveq 
  801dc7:	c3                   	retq   

0000000000801dc8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dc8:	55                   	push   %rbp
  801dc9:	48 89 e5             	mov    %rsp,%rbp
  801dcc:	48 83 ec 08          	sub    $0x8,%rsp
  801dd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dd4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dd8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ddf:	ff ff ff 
  801de2:	48 01 d0             	add    %rdx,%rax
  801de5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801de9:	c9                   	leaveq 
  801dea:	c3                   	retq   

0000000000801deb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801deb:	55                   	push   %rbp
  801dec:	48 89 e5             	mov    %rsp,%rbp
  801def:	48 83 ec 08          	sub    $0x8,%rsp
  801df3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801df7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfb:	48 89 c7             	mov    %rax,%rdi
  801dfe:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	callq  *%rax
  801e0a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e10:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e14:	c9                   	leaveq 
  801e15:	c3                   	retq   

0000000000801e16 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e16:	55                   	push   %rbp
  801e17:	48 89 e5             	mov    %rsp,%rbp
  801e1a:	48 83 ec 18          	sub    $0x18,%rsp
  801e1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e29:	eb 6b                	jmp    801e96 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2e:	48 98                	cltq   
  801e30:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e36:	48 c1 e0 0c          	shl    $0xc,%rax
  801e3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e42:	48 c1 e8 15          	shr    $0x15,%rax
  801e46:	48 89 c2             	mov    %rax,%rdx
  801e49:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e50:	01 00 00 
  801e53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e57:	83 e0 01             	and    $0x1,%eax
  801e5a:	48 85 c0             	test   %rax,%rax
  801e5d:	74 21                	je     801e80 <fd_alloc+0x6a>
  801e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e63:	48 c1 e8 0c          	shr    $0xc,%rax
  801e67:	48 89 c2             	mov    %rax,%rdx
  801e6a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e71:	01 00 00 
  801e74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e78:	83 e0 01             	and    $0x1,%eax
  801e7b:	48 85 c0             	test   %rax,%rax
  801e7e:	75 12                	jne    801e92 <fd_alloc+0x7c>
			*fd_store = fd;
  801e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e88:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e90:	eb 1a                	jmp    801eac <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e92:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e96:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e9a:	7e 8f                	jle    801e2b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ea7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801eac:	c9                   	leaveq 
  801ead:	c3                   	retq   

0000000000801eae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801eae:	55                   	push   %rbp
  801eaf:	48 89 e5             	mov    %rsp,%rbp
  801eb2:	48 83 ec 20          	sub    $0x20,%rsp
  801eb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ebd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ec1:	78 06                	js     801ec9 <fd_lookup+0x1b>
  801ec3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ec7:	7e 07                	jle    801ed0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ece:	eb 6c                	jmp    801f3c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ed0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ed3:	48 98                	cltq   
  801ed5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801edb:	48 c1 e0 0c          	shl    $0xc,%rax
  801edf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee7:	48 c1 e8 15          	shr    $0x15,%rax
  801eeb:	48 89 c2             	mov    %rax,%rdx
  801eee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ef5:	01 00 00 
  801ef8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efc:	83 e0 01             	and    $0x1,%eax
  801eff:	48 85 c0             	test   %rax,%rax
  801f02:	74 21                	je     801f25 <fd_lookup+0x77>
  801f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f08:	48 c1 e8 0c          	shr    $0xc,%rax
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f16:	01 00 00 
  801f19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1d:	83 e0 01             	and    $0x1,%eax
  801f20:	48 85 c0             	test   %rax,%rax
  801f23:	75 07                	jne    801f2c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f2a:	eb 10                	jmp    801f3c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f30:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f34:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 30          	sub    $0x30,%rsp
  801f46:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f4a:	89 f0                	mov    %esi,%eax
  801f4c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f53:	48 89 c7             	mov    %rax,%rdi
  801f56:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
  801f62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f66:	48 89 d6             	mov    %rdx,%rsi
  801f69:	89 c7                	mov    %eax,%edi
  801f6b:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	callq  *%rax
  801f77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7e:	78 0a                	js     801f8a <fd_close+0x4c>
	    || fd != fd2)
  801f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f84:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f88:	74 12                	je     801f9c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f8a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f8e:	74 05                	je     801f95 <fd_close+0x57>
  801f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f93:	eb 05                	jmp    801f9a <fd_close+0x5c>
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	eb 69                	jmp    802005 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa0:	8b 00                	mov    (%rax),%eax
  801fa2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fa6:	48 89 d6             	mov    %rdx,%rsi
  801fa9:	89 c7                	mov    %eax,%edi
  801fab:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax
  801fb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbe:	78 2a                	js     801fea <fd_close+0xac>
		if (dev->dev_close)
  801fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fc8:	48 85 c0             	test   %rax,%rax
  801fcb:	74 16                	je     801fe3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd1:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fd5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fd9:	48 89 d7             	mov    %rdx,%rdi
  801fdc:	ff d0                	callq  *%rax
  801fde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe1:	eb 07                	jmp    801fea <fd_close+0xac>
		else
			r = 0;
  801fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fee:	48 89 c6             	mov    %rax,%rsi
  801ff1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff6:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  801ffd:	00 00 00 
  802000:	ff d0                	callq  *%rax
	return r;
  802002:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802005:	c9                   	leaveq 
  802006:	c3                   	retq   

0000000000802007 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802007:	55                   	push   %rbp
  802008:	48 89 e5             	mov    %rsp,%rbp
  80200b:	48 83 ec 20          	sub    $0x20,%rsp
  80200f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802012:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80201d:	eb 41                	jmp    802060 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80201f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802026:	00 00 00 
  802029:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80202c:	48 63 d2             	movslq %edx,%rdx
  80202f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802033:	8b 00                	mov    (%rax),%eax
  802035:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802038:	75 22                	jne    80205c <dev_lookup+0x55>
			*dev = devtab[i];
  80203a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802041:	00 00 00 
  802044:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802047:	48 63 d2             	movslq %edx,%rdx
  80204a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80204e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802052:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	eb 60                	jmp    8020bc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80205c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802060:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802067:	00 00 00 
  80206a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80206d:	48 63 d2             	movslq %edx,%rdx
  802070:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802074:	48 85 c0             	test   %rax,%rax
  802077:	75 a6                	jne    80201f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802079:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802080:	00 00 00 
  802083:	48 8b 00             	mov    (%rax),%rax
  802086:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80208c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80208f:	89 c6                	mov    %eax,%esi
  802091:	48 bf 18 3f 80 00 00 	movabs $0x803f18,%rdi
  802098:	00 00 00 
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  8020a7:	00 00 00 
  8020aa:	ff d1                	callq  *%rcx
	*dev = 0;
  8020ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020b0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020bc:	c9                   	leaveq 
  8020bd:	c3                   	retq   

00000000008020be <close>:

int
close(int fdnum)
{
  8020be:	55                   	push   %rbp
  8020bf:	48 89 e5             	mov    %rsp,%rbp
  8020c2:	48 83 ec 20          	sub    $0x20,%rsp
  8020c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020d0:	48 89 d6             	mov    %rdx,%rsi
  8020d3:	89 c7                	mov    %eax,%edi
  8020d5:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	callq  *%rax
  8020e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e8:	79 05                	jns    8020ef <close+0x31>
		return r;
  8020ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ed:	eb 18                	jmp    802107 <close+0x49>
	else
		return fd_close(fd, 1);
  8020ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f3:	be 01 00 00 00       	mov    $0x1,%esi
  8020f8:	48 89 c7             	mov    %rax,%rdi
  8020fb:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  802102:	00 00 00 
  802105:	ff d0                	callq  *%rax
}
  802107:	c9                   	leaveq 
  802108:	c3                   	retq   

0000000000802109 <close_all>:

void
close_all(void)
{
  802109:	55                   	push   %rbp
  80210a:	48 89 e5             	mov    %rsp,%rbp
  80210d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802118:	eb 15                	jmp    80212f <close_all+0x26>
		close(i);
  80211a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211d:	89 c7                	mov    %eax,%edi
  80211f:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802126:	00 00 00 
  802129:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80212b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80212f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802133:	7e e5                	jle    80211a <close_all+0x11>
		close(i);
}
  802135:	c9                   	leaveq 
  802136:	c3                   	retq   

0000000000802137 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802137:	55                   	push   %rbp
  802138:	48 89 e5             	mov    %rsp,%rbp
  80213b:	48 83 ec 40          	sub    $0x40,%rsp
  80213f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802142:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802145:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802149:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80214c:	48 89 d6             	mov    %rdx,%rsi
  80214f:	89 c7                	mov    %eax,%edi
  802151:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  802158:	00 00 00 
  80215b:	ff d0                	callq  *%rax
  80215d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802160:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802164:	79 08                	jns    80216e <dup+0x37>
		return r;
  802166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802169:	e9 70 01 00 00       	jmpq   8022de <dup+0x1a7>
	close(newfdnum);
  80216e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802171:	89 c7                	mov    %eax,%edi
  802173:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80217f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802182:	48 98                	cltq   
  802184:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80218a:	48 c1 e0 0c          	shl    $0xc,%rax
  80218e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802196:	48 89 c7             	mov    %rax,%rdi
  802199:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
  8021a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ad:	48 89 c7             	mov    %rax,%rdi
  8021b0:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
  8021bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c4:	48 c1 e8 15          	shr    $0x15,%rax
  8021c8:	48 89 c2             	mov    %rax,%rdx
  8021cb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d2:	01 00 00 
  8021d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d9:	83 e0 01             	and    $0x1,%eax
  8021dc:	48 85 c0             	test   %rax,%rax
  8021df:	74 73                	je     802254 <dup+0x11d>
  8021e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e9:	48 89 c2             	mov    %rax,%rdx
  8021ec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021f3:	01 00 00 
  8021f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fa:	83 e0 01             	and    $0x1,%eax
  8021fd:	48 85 c0             	test   %rax,%rax
  802200:	74 52                	je     802254 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802206:	48 c1 e8 0c          	shr    $0xc,%rax
  80220a:	48 89 c2             	mov    %rax,%rdx
  80220d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802214:	01 00 00 
  802217:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221b:	25 07 0e 00 00       	and    $0xe07,%eax
  802220:	89 c1                	mov    %eax,%ecx
  802222:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222a:	41 89 c8             	mov    %ecx,%r8d
  80222d:	48 89 d1             	mov    %rdx,%rcx
  802230:	ba 00 00 00 00       	mov    $0x0,%edx
  802235:	48 89 c6             	mov    %rax,%rsi
  802238:	bf 00 00 00 00       	mov    $0x0,%edi
  80223d:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  802244:	00 00 00 
  802247:	ff d0                	callq  *%rax
  802249:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802250:	79 02                	jns    802254 <dup+0x11d>
			goto err;
  802252:	eb 57                	jmp    8022ab <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802258:	48 c1 e8 0c          	shr    $0xc,%rax
  80225c:	48 89 c2             	mov    %rax,%rdx
  80225f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802266:	01 00 00 
  802269:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226d:	25 07 0e 00 00       	and    $0xe07,%eax
  802272:	89 c1                	mov    %eax,%ecx
  802274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802278:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227c:	41 89 c8             	mov    %ecx,%r8d
  80227f:	48 89 d1             	mov    %rdx,%rcx
  802282:	ba 00 00 00 00       	mov    $0x0,%edx
  802287:	48 89 c6             	mov    %rax,%rsi
  80228a:	bf 00 00 00 00       	mov    $0x0,%edi
  80228f:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
  80229b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a2:	79 02                	jns    8022a6 <dup+0x16f>
		goto err;
  8022a4:	eb 05                	jmp    8022ab <dup+0x174>

	return newfdnum;
  8022a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a9:	eb 33                	jmp    8022de <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022af:	48 89 c6             	mov    %rax,%rsi
  8022b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b7:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  8022be:	00 00 00 
  8022c1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c7:	48 89 c6             	mov    %rax,%rsi
  8022ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cf:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  8022d6:	00 00 00 
  8022d9:	ff d0                	callq  *%rax
	return r;
  8022db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022de:	c9                   	leaveq 
  8022df:	c3                   	retq   

00000000008022e0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022e0:	55                   	push   %rbp
  8022e1:	48 89 e5             	mov    %rsp,%rbp
  8022e4:	48 83 ec 40          	sub    $0x40,%rsp
  8022e8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022fa:	48 89 d6             	mov    %rdx,%rsi
  8022fd:	89 c7                	mov    %eax,%edi
  8022ff:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  802306:	00 00 00 
  802309:	ff d0                	callq  *%rax
  80230b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802312:	78 24                	js     802338 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802318:	8b 00                	mov    (%rax),%eax
  80231a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231e:	48 89 d6             	mov    %rdx,%rsi
  802321:	89 c7                	mov    %eax,%edi
  802323:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  80232a:	00 00 00 
  80232d:	ff d0                	callq  *%rax
  80232f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802336:	79 05                	jns    80233d <read+0x5d>
		return r;
  802338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233b:	eb 76                	jmp    8023b3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80233d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802341:	8b 40 08             	mov    0x8(%rax),%eax
  802344:	83 e0 03             	and    $0x3,%eax
  802347:	83 f8 01             	cmp    $0x1,%eax
  80234a:	75 3a                	jne    802386 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80234c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802353:	00 00 00 
  802356:	48 8b 00             	mov    (%rax),%rax
  802359:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80235f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802362:	89 c6                	mov    %eax,%esi
  802364:	48 bf 37 3f 80 00 00 	movabs $0x803f37,%rdi
  80236b:	00 00 00 
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  80237a:	00 00 00 
  80237d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80237f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802384:	eb 2d                	jmp    8023b3 <read+0xd3>
	}
	if (!dev->dev_read)
  802386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80238e:	48 85 c0             	test   %rax,%rax
  802391:	75 07                	jne    80239a <read+0xba>
		return -E_NOT_SUPP;
  802393:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802398:	eb 19                	jmp    8023b3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80239a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239e:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023aa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023ae:	48 89 cf             	mov    %rcx,%rdi
  8023b1:	ff d0                	callq  *%rax
}
  8023b3:	c9                   	leaveq 
  8023b4:	c3                   	retq   

00000000008023b5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023b5:	55                   	push   %rbp
  8023b6:	48 89 e5             	mov    %rsp,%rbp
  8023b9:	48 83 ec 30          	sub    $0x30,%rsp
  8023bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023cf:	eb 49                	jmp    80241a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d4:	48 98                	cltq   
  8023d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023da:	48 29 c2             	sub    %rax,%rdx
  8023dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e0:	48 63 c8             	movslq %eax,%rcx
  8023e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e7:	48 01 c1             	add    %rax,%rcx
  8023ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ed:	48 89 ce             	mov    %rcx,%rsi
  8023f0:	89 c7                	mov    %eax,%edi
  8023f2:	48 b8 e0 22 80 00 00 	movabs $0x8022e0,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
  8023fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802401:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802405:	79 05                	jns    80240c <readn+0x57>
			return m;
  802407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80240a:	eb 1c                	jmp    802428 <readn+0x73>
		if (m == 0)
  80240c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802410:	75 02                	jne    802414 <readn+0x5f>
			break;
  802412:	eb 11                	jmp    802425 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802414:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802417:	01 45 fc             	add    %eax,-0x4(%rbp)
  80241a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241d:	48 98                	cltq   
  80241f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802423:	72 ac                	jb     8023d1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802425:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802428:	c9                   	leaveq 
  802429:	c3                   	retq   

000000000080242a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
  80242e:	48 83 ec 40          	sub    $0x40,%rsp
  802432:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802435:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802439:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802441:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802444:	48 89 d6             	mov    %rdx,%rsi
  802447:	89 c7                	mov    %eax,%edi
  802449:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  802450:	00 00 00 
  802453:	ff d0                	callq  *%rax
  802455:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245c:	78 24                	js     802482 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802462:	8b 00                	mov    (%rax),%eax
  802464:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802468:	48 89 d6             	mov    %rdx,%rsi
  80246b:	89 c7                	mov    %eax,%edi
  80246d:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802474:	00 00 00 
  802477:	ff d0                	callq  *%rax
  802479:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802480:	79 05                	jns    802487 <write+0x5d>
		return r;
  802482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802485:	eb 75                	jmp    8024fc <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248b:	8b 40 08             	mov    0x8(%rax),%eax
  80248e:	83 e0 03             	and    $0x3,%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	75 3a                	jne    8024cf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802495:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80249c:	00 00 00 
  80249f:	48 8b 00             	mov    (%rax),%rax
  8024a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ab:	89 c6                	mov    %eax,%esi
  8024ad:	48 bf 53 3f 80 00 00 	movabs $0x803f53,%rdi
  8024b4:	00 00 00 
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  8024c3:	00 00 00 
  8024c6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024cd:	eb 2d                	jmp    8024fc <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d7:	48 85 c0             	test   %rax,%rax
  8024da:	75 07                	jne    8024e3 <write+0xb9>
		return -E_NOT_SUPP;
  8024dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e1:	eb 19                	jmp    8024fc <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024f3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024f7:	48 89 cf             	mov    %rcx,%rdi
  8024fa:	ff d0                	callq  *%rax
}
  8024fc:	c9                   	leaveq 
  8024fd:	c3                   	retq   

00000000008024fe <seek>:

int
seek(int fdnum, off_t offset)
{
  8024fe:	55                   	push   %rbp
  8024ff:	48 89 e5             	mov    %rsp,%rbp
  802502:	48 83 ec 18          	sub    $0x18,%rsp
  802506:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802509:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80250c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802513:	48 89 d6             	mov    %rdx,%rsi
  802516:	89 c7                	mov    %eax,%edi
  802518:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  80251f:	00 00 00 
  802522:	ff d0                	callq  *%rax
  802524:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802527:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252b:	79 05                	jns    802532 <seek+0x34>
		return r;
  80252d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802530:	eb 0f                	jmp    802541 <seek+0x43>
	fd->fd_offset = offset;
  802532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802536:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802539:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802541:	c9                   	leaveq 
  802542:	c3                   	retq   

0000000000802543 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802543:	55                   	push   %rbp
  802544:	48 89 e5             	mov    %rsp,%rbp
  802547:	48 83 ec 30          	sub    $0x30,%rsp
  80254b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80254e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802551:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802555:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802558:	48 89 d6             	mov    %rdx,%rsi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802570:	78 24                	js     802596 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802576:	8b 00                	mov    (%rax),%eax
  802578:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80257c:	48 89 d6             	mov    %rdx,%rsi
  80257f:	89 c7                	mov    %eax,%edi
  802581:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802588:	00 00 00 
  80258b:	ff d0                	callq  *%rax
  80258d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802590:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802594:	79 05                	jns    80259b <ftruncate+0x58>
		return r;
  802596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802599:	eb 72                	jmp    80260d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80259b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259f:	8b 40 08             	mov    0x8(%rax),%eax
  8025a2:	83 e0 03             	and    $0x3,%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 3a                	jne    8025e3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8025b0:	00 00 00 
  8025b3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025bf:	89 c6                	mov    %eax,%esi
  8025c1:	48 bf 70 3f 80 00 00 	movabs $0x803f70,%rdi
  8025c8:	00 00 00 
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d0:	48 b9 64 06 80 00 00 	movabs $0x800664,%rcx
  8025d7:	00 00 00 
  8025da:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e1:	eb 2a                	jmp    80260d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025eb:	48 85 c0             	test   %rax,%rax
  8025ee:	75 07                	jne    8025f7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f5:	eb 16                	jmp    80260d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802603:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802606:	89 ce                	mov    %ecx,%esi
  802608:	48 89 d7             	mov    %rdx,%rdi
  80260b:	ff d0                	callq  *%rax
}
  80260d:	c9                   	leaveq 
  80260e:	c3                   	retq   

000000000080260f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80260f:	55                   	push   %rbp
  802610:	48 89 e5             	mov    %rsp,%rbp
  802613:	48 83 ec 30          	sub    $0x30,%rsp
  802617:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80261a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80261e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802622:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802625:	48 89 d6             	mov    %rdx,%rsi
  802628:	89 c7                	mov    %eax,%edi
  80262a:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  802631:	00 00 00 
  802634:	ff d0                	callq  *%rax
  802636:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802639:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263d:	78 24                	js     802663 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802643:	8b 00                	mov    (%rax),%eax
  802645:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802649:	48 89 d6             	mov    %rdx,%rsi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	48 b8 07 20 80 00 00 	movabs $0x802007,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
  80265a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802661:	79 05                	jns    802668 <fstat+0x59>
		return r;
  802663:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802666:	eb 5e                	jmp    8026c6 <fstat+0xb7>
	if (!dev->dev_stat)
  802668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802670:	48 85 c0             	test   %rax,%rax
  802673:	75 07                	jne    80267c <fstat+0x6d>
		return -E_NOT_SUPP;
  802675:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80267a:	eb 4a                	jmp    8026c6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80267c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802680:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802683:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802687:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80268e:	00 00 00 
	stat->st_isdir = 0;
  802691:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802695:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80269c:	00 00 00 
	stat->st_dev = dev;
  80269f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026ba:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026be:	48 89 ce             	mov    %rcx,%rsi
  8026c1:	48 89 d7             	mov    %rdx,%rdi
  8026c4:	ff d0                	callq  *%rax
}
  8026c6:	c9                   	leaveq 
  8026c7:	c3                   	retq   

00000000008026c8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026c8:	55                   	push   %rbp
  8026c9:	48 89 e5             	mov    %rsp,%rbp
  8026cc:	48 83 ec 20          	sub    $0x20,%rsp
  8026d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dc:	be 00 00 00 00       	mov    $0x0,%esi
  8026e1:	48 89 c7             	mov    %rax,%rdi
  8026e4:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	callq  *%rax
  8026f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f7:	79 05                	jns    8026fe <stat+0x36>
		return fd;
  8026f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fc:	eb 2f                	jmp    80272d <stat+0x65>
	r = fstat(fd, stat);
  8026fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802702:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802705:	48 89 d6             	mov    %rdx,%rsi
  802708:	89 c7                	mov    %eax,%edi
  80270a:	48 b8 0f 26 80 00 00 	movabs $0x80260f,%rax
  802711:	00 00 00 
  802714:	ff d0                	callq  *%rax
  802716:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271c:	89 c7                	mov    %eax,%edi
  80271e:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802725:	00 00 00 
  802728:	ff d0                	callq  *%rax
	return r;
  80272a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80272d:	c9                   	leaveq 
  80272e:	c3                   	retq   

000000000080272f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80272f:	55                   	push   %rbp
  802730:	48 89 e5             	mov    %rsp,%rbp
  802733:	48 83 ec 10          	sub    $0x10,%rsp
  802737:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80273a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80273e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802745:	00 00 00 
  802748:	8b 00                	mov    (%rax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	75 1d                	jne    80276b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80274e:	bf 01 00 00 00       	mov    $0x1,%edi
  802753:	48 b8 e6 37 80 00 00 	movabs $0x8037e6,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
  80275f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802766:	00 00 00 
  802769:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80276b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802772:	00 00 00 
  802775:	8b 00                	mov    (%rax),%eax
  802777:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80277a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80277f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802786:	00 00 00 
  802789:	89 c7                	mov    %eax,%edi
  80278b:	48 b8 4e 37 80 00 00 	movabs $0x80374e,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80279b:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a0:	48 89 c6             	mov    %rax,%rsi
  8027a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a8:	48 b8 8d 36 80 00 00 	movabs $0x80368d,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	callq  *%rax
}
  8027b4:	c9                   	leaveq 
  8027b5:	c3                   	retq   

00000000008027b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027b6:	55                   	push   %rbp
  8027b7:	48 89 e5             	mov    %rsp,%rbp
  8027ba:	48 83 ec 20          	sub    $0x20,%rsp
  8027be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027c2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c9:	48 89 c7             	mov    %rax,%rdi
  8027cc:	48 b8 c0 11 80 00 00 	movabs $0x8011c0,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	callq  *%rax
  8027d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027dd:	7e 0a                	jle    8027e9 <open+0x33>
		return -E_BAD_PATH;
  8027df:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027e4:	e9 a5 00 00 00       	jmpq   80288e <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8027e9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802803:	79 08                	jns    80280d <open+0x57>
		return r;
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802808:	e9 81 00 00 00       	jmpq   80288e <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80280d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802811:	48 89 c6             	mov    %rax,%rsi
  802814:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80281b:	00 00 00 
  80281e:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80282a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802831:	00 00 00 
  802834:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802837:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80283d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802841:	48 89 c6             	mov    %rax,%rsi
  802844:	bf 01 00 00 00       	mov    $0x1,%edi
  802849:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802850:	00 00 00 
  802853:	ff d0                	callq  *%rax
  802855:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802858:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285c:	79 1d                	jns    80287b <open+0xc5>
		fd_close(fd, 0);
  80285e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802862:	be 00 00 00 00       	mov    $0x0,%esi
  802867:	48 89 c7             	mov    %rax,%rdi
  80286a:	48 b8 3e 1f 80 00 00 	movabs $0x801f3e,%rax
  802871:	00 00 00 
  802874:	ff d0                	callq  *%rax
		return r;
  802876:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802879:	eb 13                	jmp    80288e <open+0xd8>
	}

	return fd2num(fd);
  80287b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287f:	48 89 c7             	mov    %rax,%rdi
  802882:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  80288e:	c9                   	leaveq 
  80288f:	c3                   	retq   

0000000000802890 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802890:	55                   	push   %rbp
  802891:	48 89 e5             	mov    %rsp,%rbp
  802894:	48 83 ec 10          	sub    $0x10,%rsp
  802898:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80289c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028aa:	00 00 00 
  8028ad:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028af:	be 00 00 00 00       	mov    $0x0,%esi
  8028b4:	bf 06 00 00 00       	mov    $0x6,%edi
  8028b9:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
}
  8028c5:	c9                   	leaveq 
  8028c6:	c3                   	retq   

00000000008028c7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028c7:	55                   	push   %rbp
  8028c8:	48 89 e5             	mov    %rsp,%rbp
  8028cb:	48 83 ec 30          	sub    $0x30,%rsp
  8028cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028df:	8b 50 0c             	mov    0xc(%rax),%edx
  8028e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028e9:	00 00 00 
  8028ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f5:	00 00 00 
  8028f8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028fc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802900:	be 00 00 00 00       	mov    $0x0,%esi
  802905:	bf 03 00 00 00       	mov    $0x3,%edi
  80290a:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802911:	00 00 00 
  802914:	ff d0                	callq  *%rax
  802916:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802919:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291d:	79 08                	jns    802927 <devfile_read+0x60>
		return r;
  80291f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802922:	e9 a4 00 00 00       	jmpq   8029cb <devfile_read+0x104>
	assert(r <= n);
  802927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292a:	48 98                	cltq   
  80292c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802930:	76 35                	jbe    802967 <devfile_read+0xa0>
  802932:	48 b9 9d 3f 80 00 00 	movabs $0x803f9d,%rcx
  802939:	00 00 00 
  80293c:	48 ba a4 3f 80 00 00 	movabs $0x803fa4,%rdx
  802943:	00 00 00 
  802946:	be 84 00 00 00       	mov    $0x84,%esi
  80294b:	48 bf b9 3f 80 00 00 	movabs $0x803fb9,%rdi
  802952:	00 00 00 
  802955:	b8 00 00 00 00       	mov    $0x0,%eax
  80295a:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  802961:	00 00 00 
  802964:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802967:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80296e:	7e 35                	jle    8029a5 <devfile_read+0xde>
  802970:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  802977:	00 00 00 
  80297a:	48 ba a4 3f 80 00 00 	movabs $0x803fa4,%rdx
  802981:	00 00 00 
  802984:	be 85 00 00 00       	mov    $0x85,%esi
  802989:	48 bf b9 3f 80 00 00 	movabs $0x803fb9,%rdi
  802990:	00 00 00 
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  80299f:	00 00 00 
  8029a2:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8029a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a8:	48 63 d0             	movslq %eax,%rdx
  8029ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029af:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8029b6:	00 00 00 
  8029b9:	48 89 c7             	mov    %rax,%rdi
  8029bc:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax
	return r;
  8029c8:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8029cb:	c9                   	leaveq 
  8029cc:	c3                   	retq   

00000000008029cd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029cd:	55                   	push   %rbp
  8029ce:	48 89 e5             	mov    %rsp,%rbp
  8029d1:	48 83 ec 30          	sub    $0x30,%rsp
  8029d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029ef:	00 00 00 
  8029f2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8029f4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029fb:	00 00 00 
  8029fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a02:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802a06:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a0d:	00 
  802a0e:	76 35                	jbe    802a45 <devfile_write+0x78>
  802a10:	48 b9 d0 3f 80 00 00 	movabs $0x803fd0,%rcx
  802a17:	00 00 00 
  802a1a:	48 ba a4 3f 80 00 00 	movabs $0x803fa4,%rdx
  802a21:	00 00 00 
  802a24:	be 9e 00 00 00       	mov    $0x9e,%esi
  802a29:	48 bf b9 3f 80 00 00 	movabs $0x803fb9,%rdi
  802a30:	00 00 00 
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  802a3f:	00 00 00 
  802a42:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802a45:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4d:	48 89 c6             	mov    %rax,%rsi
  802a50:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802a57:	00 00 00 
  802a5a:	48 b8 67 16 80 00 00 	movabs $0x801667,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a66:	be 00 00 00 00       	mov    $0x0,%esi
  802a6b:	bf 04 00 00 00       	mov    $0x4,%edi
  802a70:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax
  802a7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a83:	79 05                	jns    802a8a <devfile_write+0xbd>
		return r;
  802a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a88:	eb 43                	jmp    802acd <devfile_write+0x100>
	assert(r <= n);
  802a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8d:	48 98                	cltq   
  802a8f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a93:	76 35                	jbe    802aca <devfile_write+0xfd>
  802a95:	48 b9 9d 3f 80 00 00 	movabs $0x803f9d,%rcx
  802a9c:	00 00 00 
  802a9f:	48 ba a4 3f 80 00 00 	movabs $0x803fa4,%rdx
  802aa6:	00 00 00 
  802aa9:	be a2 00 00 00       	mov    $0xa2,%esi
  802aae:	48 bf b9 3f 80 00 00 	movabs $0x803fb9,%rdi
  802ab5:	00 00 00 
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  802abd:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  802ac4:	00 00 00 
  802ac7:	41 ff d0             	callq  *%r8
	return r;
  802aca:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802acd:	c9                   	leaveq 
  802ace:	c3                   	retq   

0000000000802acf <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802acf:	55                   	push   %rbp
  802ad0:	48 89 e5             	mov    %rsp,%rbp
  802ad3:	48 83 ec 20          	sub    $0x20,%rsp
  802ad7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802adb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802adf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae3:	8b 50 0c             	mov    0xc(%rax),%edx
  802ae6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aed:	00 00 00 
  802af0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802af2:	be 00 00 00 00       	mov    $0x0,%esi
  802af7:	bf 05 00 00 00       	mov    $0x5,%edi
  802afc:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802b03:	00 00 00 
  802b06:	ff d0                	callq  *%rax
  802b08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0f:	79 05                	jns    802b16 <devfile_stat+0x47>
		return r;
  802b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b14:	eb 56                	jmp    802b6c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b1a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b21:	00 00 00 
  802b24:	48 89 c7             	mov    %rax,%rdi
  802b27:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  802b2e:	00 00 00 
  802b31:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b33:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b3a:	00 00 00 
  802b3d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b47:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b4d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b54:	00 00 00 
  802b57:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b61:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6c:	c9                   	leaveq 
  802b6d:	c3                   	retq   

0000000000802b6e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b6e:	55                   	push   %rbp
  802b6f:	48 89 e5             	mov    %rsp,%rbp
  802b72:	48 83 ec 10          	sub    $0x10,%rsp
  802b76:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b7a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b81:	8b 50 0c             	mov    0xc(%rax),%edx
  802b84:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b8b:	00 00 00 
  802b8e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b90:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b97:	00 00 00 
  802b9a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b9d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ba0:	be 00 00 00 00       	mov    $0x0,%esi
  802ba5:	bf 02 00 00 00       	mov    $0x2,%edi
  802baa:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
}
  802bb6:	c9                   	leaveq 
  802bb7:	c3                   	retq   

0000000000802bb8 <remove>:

// Delete a file
int
remove(const char *path)
{
  802bb8:	55                   	push   %rbp
  802bb9:	48 89 e5             	mov    %rsp,%rbp
  802bbc:	48 83 ec 10          	sub    $0x10,%rsp
  802bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc8:	48 89 c7             	mov    %rax,%rdi
  802bcb:	48 b8 c0 11 80 00 00 	movabs $0x8011c0,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
  802bd7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bdc:	7e 07                	jle    802be5 <remove+0x2d>
		return -E_BAD_PATH;
  802bde:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802be3:	eb 33                	jmp    802c18 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be9:	48 89 c6             	mov    %rax,%rsi
  802bec:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802bf3:	00 00 00 
  802bf6:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  802bfd:	00 00 00 
  802c00:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c02:	be 00 00 00 00       	mov    $0x0,%esi
  802c07:	bf 07 00 00 00       	mov    $0x7,%edi
  802c0c:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802c13:	00 00 00 
  802c16:	ff d0                	callq  *%rax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c1e:	be 00 00 00 00       	mov    $0x0,%esi
  802c23:	bf 08 00 00 00       	mov    $0x8,%edi
  802c28:	48 b8 2f 27 80 00 00 	movabs $0x80272f,%rax
  802c2f:	00 00 00 
  802c32:	ff d0                	callq  *%rax
}
  802c34:	5d                   	pop    %rbp
  802c35:	c3                   	retq   

0000000000802c36 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c36:	55                   	push   %rbp
  802c37:	48 89 e5             	mov    %rsp,%rbp
  802c3a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c41:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c48:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c4f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c56:	be 00 00 00 00       	mov    $0x0,%esi
  802c5b:	48 89 c7             	mov    %rax,%rdi
  802c5e:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c71:	79 28                	jns    802c9b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c76:	89 c6                	mov    %eax,%esi
  802c78:	48 bf fd 3f 80 00 00 	movabs $0x803ffd,%rdi
  802c7f:	00 00 00 
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
  802c87:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  802c8e:	00 00 00 
  802c91:	ff d2                	callq  *%rdx
		return fd_src;
  802c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c96:	e9 74 01 00 00       	jmpq   802e0f <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c9b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802ca2:	be 01 01 00 00       	mov    $0x101,%esi
  802ca7:	48 89 c7             	mov    %rax,%rdi
  802caa:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802cb1:	00 00 00 
  802cb4:	ff d0                	callq  *%rax
  802cb6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802cb9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cbd:	79 39                	jns    802cf8 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc2:	89 c6                	mov    %eax,%esi
  802cc4:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  802ccb:	00 00 00 
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd3:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  802cda:	00 00 00 
  802cdd:	ff d2                	callq  *%rdx
		close(fd_src);
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	89 c7                	mov    %eax,%edi
  802ce4:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802ceb:	00 00 00 
  802cee:	ff d0                	callq  *%rax
		return fd_dest;
  802cf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf3:	e9 17 01 00 00       	jmpq   802e0f <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cf8:	eb 74                	jmp    802d6e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802cfa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cfd:	48 63 d0             	movslq %eax,%rdx
  802d00:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0a:	48 89 ce             	mov    %rcx,%rsi
  802d0d:	89 c7                	mov    %eax,%edi
  802d0f:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
  802d1b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d22:	79 4a                	jns    802d6e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d24:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d27:	89 c6                	mov    %eax,%esi
  802d29:	48 bf 2d 40 80 00 00 	movabs $0x80402d,%rdi
  802d30:	00 00 00 
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  802d3f:	00 00 00 
  802d42:	ff d2                	callq  *%rdx
			close(fd_src);
  802d44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d47:	89 c7                	mov    %eax,%edi
  802d49:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
			close(fd_dest);
  802d55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d58:	89 c7                	mov    %eax,%edi
  802d5a:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
			return write_size;
  802d66:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d69:	e9 a1 00 00 00       	jmpq   802e0f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d6e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d78:	ba 00 02 00 00       	mov    $0x200,%edx
  802d7d:	48 89 ce             	mov    %rcx,%rsi
  802d80:	89 c7                	mov    %eax,%edi
  802d82:	48 b8 e0 22 80 00 00 	movabs $0x8022e0,%rax
  802d89:	00 00 00 
  802d8c:	ff d0                	callq  *%rax
  802d8e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d95:	0f 8f 5f ff ff ff    	jg     802cfa <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d9f:	79 47                	jns    802de8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802da1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802da4:	89 c6                	mov    %eax,%esi
  802da6:	48 bf 40 40 80 00 00 	movabs $0x804040,%rdi
  802dad:	00 00 00 
  802db0:	b8 00 00 00 00       	mov    $0x0,%eax
  802db5:	48 ba 64 06 80 00 00 	movabs $0x800664,%rdx
  802dbc:	00 00 00 
  802dbf:	ff d2                	callq  *%rdx
		close(fd_src);
  802dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc4:	89 c7                	mov    %eax,%edi
  802dc6:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
		close(fd_dest);
  802dd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd5:	89 c7                	mov    %eax,%edi
  802dd7:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802dde:	00 00 00 
  802de1:	ff d0                	callq  *%rax
		return read_size;
  802de3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802de6:	eb 27                	jmp    802e0f <copy+0x1d9>
	}
	close(fd_src);
  802de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802deb:	89 c7                	mov    %eax,%edi
  802ded:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
	close(fd_dest);
  802df9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
	return 0;
  802e0a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802e0f:	c9                   	leaveq 
  802e10:	c3                   	retq   

0000000000802e11 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
  802e15:	53                   	push   %rbx
  802e16:	48 83 ec 38          	sub    $0x38,%rsp
  802e1a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802e1e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802e22:	48 89 c7             	mov    %rax,%rdi
  802e25:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e38:	0f 88 bf 01 00 00    	js     802ffd <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e42:	ba 07 04 00 00       	mov    $0x407,%edx
  802e47:	48 89 c6             	mov    %rax,%rsi
  802e4a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4f:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
  802e5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e62:	0f 88 95 01 00 00    	js     802ffd <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802e68:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802e6c:	48 89 c7             	mov    %rax,%rdi
  802e6f:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e82:	0f 88 5d 01 00 00    	js     802fe5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e8c:	ba 07 04 00 00       	mov    $0x407,%edx
  802e91:	48 89 c6             	mov    %rax,%rsi
  802e94:	bf 00 00 00 00       	mov    $0x0,%edi
  802e99:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802eac:	0f 88 33 01 00 00    	js     802fe5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802eb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb6:	48 89 c7             	mov    %rax,%rdi
  802eb9:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	callq  *%rax
  802ec5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ec9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ecd:	ba 07 04 00 00       	mov    $0x407,%edx
  802ed2:	48 89 c6             	mov    %rax,%rsi
  802ed5:	bf 00 00 00 00       	mov    $0x0,%edi
  802eda:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
  802ee6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ee9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802eed:	79 05                	jns    802ef4 <pipe+0xe3>
		goto err2;
  802eef:	e9 d9 00 00 00       	jmpq   802fcd <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ef4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef8:	48 89 c7             	mov    %rax,%rdi
  802efb:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
  802f07:	48 89 c2             	mov    %rax,%rdx
  802f0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f0e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802f14:	48 89 d1             	mov    %rdx,%rcx
  802f17:	ba 00 00 00 00       	mov    $0x0,%edx
  802f1c:	48 89 c6             	mov    %rax,%rsi
  802f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f24:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
  802f30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f37:	79 1b                	jns    802f54 <pipe+0x143>
		goto err3;
  802f39:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802f3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3e:	48 89 c6             	mov    %rax,%rsi
  802f41:	bf 00 00 00 00       	mov    $0x0,%edi
  802f46:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
  802f52:	eb 79                	jmp    802fcd <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802f54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f58:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802f5f:	00 00 00 
  802f62:	8b 12                	mov    (%rdx),%edx
  802f64:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802f71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f75:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802f7c:	00 00 00 
  802f7f:	8b 12                	mov    (%rdx),%edx
  802f81:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802f83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f87:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802f8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f92:	48 89 c7             	mov    %rax,%rdi
  802f95:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
  802fa1:	89 c2                	mov    %eax,%edx
  802fa3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802fa7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802fa9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802fad:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802fb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb5:	48 89 c7             	mov    %rax,%rdi
  802fb8:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
  802fc4:	89 03                	mov    %eax,(%rbx)
	return 0;
  802fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcb:	eb 33                	jmp    803000 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802fcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fd1:	48 89 c6             	mov    %rax,%rsi
  802fd4:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd9:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe9:	48 89 c6             	mov    %rax,%rsi
  802fec:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff1:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  802ff8:	00 00 00 
  802ffb:	ff d0                	callq  *%rax
err:
	return r;
  802ffd:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803000:	48 83 c4 38          	add    $0x38,%rsp
  803004:	5b                   	pop    %rbx
  803005:	5d                   	pop    %rbp
  803006:	c3                   	retq   

0000000000803007 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803007:	55                   	push   %rbp
  803008:	48 89 e5             	mov    %rsp,%rbp
  80300b:	53                   	push   %rbx
  80300c:	48 83 ec 28          	sub    $0x28,%rsp
  803010:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803014:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803018:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80301f:	00 00 00 
  803022:	48 8b 00             	mov    (%rax),%rax
  803025:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80302b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80302e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803032:	48 89 c7             	mov    %rax,%rdi
  803035:	48 b8 68 38 80 00 00 	movabs $0x803868,%rax
  80303c:	00 00 00 
  80303f:	ff d0                	callq  *%rax
  803041:	89 c3                	mov    %eax,%ebx
  803043:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803047:	48 89 c7             	mov    %rax,%rdi
  80304a:	48 b8 68 38 80 00 00 	movabs $0x803868,%rax
  803051:	00 00 00 
  803054:	ff d0                	callq  *%rax
  803056:	39 c3                	cmp    %eax,%ebx
  803058:	0f 94 c0             	sete   %al
  80305b:	0f b6 c0             	movzbl %al,%eax
  80305e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803061:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803068:	00 00 00 
  80306b:	48 8b 00             	mov    (%rax),%rax
  80306e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803074:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803077:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80307a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80307d:	75 05                	jne    803084 <_pipeisclosed+0x7d>
			return ret;
  80307f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803082:	eb 4f                	jmp    8030d3 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803084:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803087:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80308a:	74 42                	je     8030ce <_pipeisclosed+0xc7>
  80308c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803090:	75 3c                	jne    8030ce <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803092:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803099:	00 00 00 
  80309c:	48 8b 00             	mov    (%rax),%rax
  80309f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8030a5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030ab:	89 c6                	mov    %eax,%esi
  8030ad:	48 bf 5b 40 80 00 00 	movabs $0x80405b,%rdi
  8030b4:	00 00 00 
  8030b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bc:	49 b8 64 06 80 00 00 	movabs $0x800664,%r8
  8030c3:	00 00 00 
  8030c6:	41 ff d0             	callq  *%r8
	}
  8030c9:	e9 4a ff ff ff       	jmpq   803018 <_pipeisclosed+0x11>
  8030ce:	e9 45 ff ff ff       	jmpq   803018 <_pipeisclosed+0x11>
}
  8030d3:	48 83 c4 28          	add    $0x28,%rsp
  8030d7:	5b                   	pop    %rbx
  8030d8:	5d                   	pop    %rbp
  8030d9:	c3                   	retq   

00000000008030da <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8030da:	55                   	push   %rbp
  8030db:	48 89 e5             	mov    %rsp,%rbp
  8030de:	48 83 ec 30          	sub    $0x30,%rsp
  8030e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030ec:	48 89 d6             	mov    %rdx,%rsi
  8030ef:	89 c7                	mov    %eax,%edi
  8030f1:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803100:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803104:	79 05                	jns    80310b <pipeisclosed+0x31>
		return r;
  803106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803109:	eb 31                	jmp    80313c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80310b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310f:	48 89 c7             	mov    %rax,%rdi
  803112:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803126:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80312a:	48 89 d6             	mov    %rdx,%rsi
  80312d:	48 89 c7             	mov    %rax,%rdi
  803130:	48 b8 07 30 80 00 00 	movabs $0x803007,%rax
  803137:	00 00 00 
  80313a:	ff d0                	callq  *%rax
}
  80313c:	c9                   	leaveq 
  80313d:	c3                   	retq   

000000000080313e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80313e:	55                   	push   %rbp
  80313f:	48 89 e5             	mov    %rsp,%rbp
  803142:	48 83 ec 40          	sub    $0x40,%rsp
  803146:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80314a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80314e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803152:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803156:	48 89 c7             	mov    %rax,%rdi
  803159:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803169:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80316d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803171:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803178:	00 
  803179:	e9 92 00 00 00       	jmpq   803210 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80317e:	eb 41                	jmp    8031c1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803180:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803185:	74 09                	je     803190 <devpipe_read+0x52>
				return i;
  803187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318b:	e9 92 00 00 00       	jmpq   803222 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803190:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803198:	48 89 d6             	mov    %rdx,%rsi
  80319b:	48 89 c7             	mov    %rax,%rdi
  80319e:	48 b8 07 30 80 00 00 	movabs $0x803007,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 07                	je     8031b5 <devpipe_read+0x77>
				return 0;
  8031ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b3:	eb 6d                	jmp    803222 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8031b5:	48 b8 1d 1b 80 00 00 	movabs $0x801b1d,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8031c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c5:	8b 10                	mov    (%rax),%edx
  8031c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031cb:	8b 40 04             	mov    0x4(%rax),%eax
  8031ce:	39 c2                	cmp    %eax,%edx
  8031d0:	74 ae                	je     803180 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8031d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031da:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8031de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e2:	8b 00                	mov    (%rax),%eax
  8031e4:	99                   	cltd   
  8031e5:	c1 ea 1b             	shr    $0x1b,%edx
  8031e8:	01 d0                	add    %edx,%eax
  8031ea:	83 e0 1f             	and    $0x1f,%eax
  8031ed:	29 d0                	sub    %edx,%eax
  8031ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031f3:	48 98                	cltq   
  8031f5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8031fa:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8031fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803200:	8b 00                	mov    (%rax),%eax
  803202:	8d 50 01             	lea    0x1(%rax),%edx
  803205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803209:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80320b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803214:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803218:	0f 82 60 ff ff ff    	jb     80317e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80321e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803222:	c9                   	leaveq 
  803223:	c3                   	retq   

0000000000803224 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803224:	55                   	push   %rbp
  803225:	48 89 e5             	mov    %rsp,%rbp
  803228:	48 83 ec 40          	sub    $0x40,%rsp
  80322c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803230:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803234:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803238:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80323c:	48 89 c7             	mov    %rax,%rdi
  80323f:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80324f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803253:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803257:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80325e:	00 
  80325f:	e9 8e 00 00 00       	jmpq   8032f2 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803264:	eb 31                	jmp    803297 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803266:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80326a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326e:	48 89 d6             	mov    %rdx,%rsi
  803271:	48 89 c7             	mov    %rax,%rdi
  803274:	48 b8 07 30 80 00 00 	movabs $0x803007,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 07                	je     80328b <devpipe_write+0x67>
				return 0;
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
  803289:	eb 79                	jmp    803304 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80328b:	48 b8 1d 1b 80 00 00 	movabs $0x801b1d,%rax
  803292:	00 00 00 
  803295:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329b:	8b 40 04             	mov    0x4(%rax),%eax
  80329e:	48 63 d0             	movslq %eax,%rdx
  8032a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a5:	8b 00                	mov    (%rax),%eax
  8032a7:	48 98                	cltq   
  8032a9:	48 83 c0 20          	add    $0x20,%rax
  8032ad:	48 39 c2             	cmp    %rax,%rdx
  8032b0:	73 b4                	jae    803266 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8032b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b6:	8b 40 04             	mov    0x4(%rax),%eax
  8032b9:	99                   	cltd   
  8032ba:	c1 ea 1b             	shr    $0x1b,%edx
  8032bd:	01 d0                	add    %edx,%eax
  8032bf:	83 e0 1f             	and    $0x1f,%eax
  8032c2:	29 d0                	sub    %edx,%eax
  8032c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8032c8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8032cc:	48 01 ca             	add    %rcx,%rdx
  8032cf:	0f b6 0a             	movzbl (%rdx),%ecx
  8032d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032d6:	48 98                	cltq   
  8032d8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8032dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e0:	8b 40 04             	mov    0x4(%rax),%eax
  8032e3:	8d 50 01             	lea    0x1(%rax),%edx
  8032e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ea:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032fa:	0f 82 64 ff ff ff    	jb     803264 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803304:	c9                   	leaveq 
  803305:	c3                   	retq   

0000000000803306 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803306:	55                   	push   %rbp
  803307:	48 89 e5             	mov    %rsp,%rbp
  80330a:	48 83 ec 20          	sub    $0x20,%rsp
  80330e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803312:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331a:	48 89 c7             	mov    %rax,%rdi
  80331d:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
  803329:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80332d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803331:	48 be 6e 40 80 00 00 	movabs $0x80406e,%rsi
  803338:	00 00 00 
  80333b:	48 89 c7             	mov    %rax,%rdi
  80333e:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80334a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334e:	8b 50 04             	mov    0x4(%rax),%edx
  803351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803355:	8b 00                	mov    (%rax),%eax
  803357:	29 c2                	sub    %eax,%edx
  803359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803363:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803367:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80336e:	00 00 00 
	stat->st_dev = &devpipe;
  803371:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803375:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80337c:	00 00 00 
  80337f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803386:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80338b:	c9                   	leaveq 
  80338c:	c3                   	retq   

000000000080338d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80338d:	55                   	push   %rbp
  80338e:	48 89 e5             	mov    %rsp,%rbp
  803391:	48 83 ec 10          	sub    $0x10,%rsp
  803395:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339d:	48 89 c6             	mov    %rax,%rsi
  8033a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a5:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8033b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b5:	48 89 c7             	mov    %rax,%rdi
  8033b8:	48 b8 eb 1d 80 00 00 	movabs $0x801deb,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
  8033c4:	48 89 c6             	mov    %rax,%rsi
  8033c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033cc:	48 b8 06 1c 80 00 00 	movabs $0x801c06,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
}
  8033d8:	c9                   	leaveq 
  8033d9:	c3                   	retq   

00000000008033da <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8033da:	55                   	push   %rbp
  8033db:	48 89 e5             	mov    %rsp,%rbp
  8033de:	48 83 ec 20          	sub    $0x20,%rsp
  8033e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8033e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e8:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8033eb:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8033ef:	be 01 00 00 00       	mov    $0x1,%esi
  8033f4:	48 89 c7             	mov    %rax,%rdi
  8033f7:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
}
  803403:	c9                   	leaveq 
  803404:	c3                   	retq   

0000000000803405 <getchar>:

int
getchar(void)
{
  803405:	55                   	push   %rbp
  803406:	48 89 e5             	mov    %rsp,%rbp
  803409:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80340d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803411:	ba 01 00 00 00       	mov    $0x1,%edx
  803416:	48 89 c6             	mov    %rax,%rsi
  803419:	bf 00 00 00 00       	mov    $0x0,%edi
  80341e:	48 b8 e0 22 80 00 00 	movabs $0x8022e0,%rax
  803425:	00 00 00 
  803428:	ff d0                	callq  *%rax
  80342a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80342d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803431:	79 05                	jns    803438 <getchar+0x33>
		return r;
  803433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803436:	eb 14                	jmp    80344c <getchar+0x47>
	if (r < 1)
  803438:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343c:	7f 07                	jg     803445 <getchar+0x40>
		return -E_EOF;
  80343e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803443:	eb 07                	jmp    80344c <getchar+0x47>
	return c;
  803445:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803449:	0f b6 c0             	movzbl %al,%eax
}
  80344c:	c9                   	leaveq 
  80344d:	c3                   	retq   

000000000080344e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	48 83 ec 20          	sub    $0x20,%rsp
  803456:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803459:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80345d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803460:	48 89 d6             	mov    %rdx,%rsi
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 ae 1e 80 00 00 	movabs $0x801eae,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803478:	79 05                	jns    80347f <iscons+0x31>
		return r;
  80347a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347d:	eb 1a                	jmp    803499 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80347f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803483:	8b 10                	mov    (%rax),%edx
  803485:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80348c:	00 00 00 
  80348f:	8b 00                	mov    (%rax),%eax
  803491:	39 c2                	cmp    %eax,%edx
  803493:	0f 94 c0             	sete   %al
  803496:	0f b6 c0             	movzbl %al,%eax
}
  803499:	c9                   	leaveq 
  80349a:	c3                   	retq   

000000000080349b <opencons>:

int
opencons(void)
{
  80349b:	55                   	push   %rbp
  80349c:	48 89 e5             	mov    %rsp,%rbp
  80349f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8034a3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034a7:	48 89 c7             	mov    %rax,%rdi
  8034aa:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  8034b1:	00 00 00 
  8034b4:	ff d0                	callq  *%rax
  8034b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034bd:	79 05                	jns    8034c4 <opencons+0x29>
		return r;
  8034bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c2:	eb 5b                	jmp    80351f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8034c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c8:	ba 07 04 00 00       	mov    $0x407,%edx
  8034cd:	48 89 c6             	mov    %rax,%rsi
  8034d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d5:	48 b8 5b 1b 80 00 00 	movabs $0x801b5b,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
  8034e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e8:	79 05                	jns    8034ef <opencons+0x54>
		return r;
  8034ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ed:	eb 30                	jmp    80351f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8034ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f3:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8034fa:	00 00 00 
  8034fd:	8b 12                	mov    (%rdx),%edx
  8034ff:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803505:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80350c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803510:	48 89 c7             	mov    %rax,%rdi
  803513:	48 b8 c8 1d 80 00 00 	movabs $0x801dc8,%rax
  80351a:	00 00 00 
  80351d:	ff d0                	callq  *%rax
}
  80351f:	c9                   	leaveq 
  803520:	c3                   	retq   

0000000000803521 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803521:	55                   	push   %rbp
  803522:	48 89 e5             	mov    %rsp,%rbp
  803525:	48 83 ec 30          	sub    $0x30,%rsp
  803529:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80352d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803531:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803535:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80353a:	75 07                	jne    803543 <devcons_read+0x22>
		return 0;
  80353c:	b8 00 00 00 00       	mov    $0x0,%eax
  803541:	eb 4b                	jmp    80358e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803543:	eb 0c                	jmp    803551 <devcons_read+0x30>
		sys_yield();
  803545:	48 b8 1d 1b 80 00 00 	movabs $0x801b1d,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803551:	48 b8 5d 1a 80 00 00 	movabs $0x801a5d,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
  80355d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803564:	74 df                	je     803545 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356a:	79 05                	jns    803571 <devcons_read+0x50>
		return c;
  80356c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356f:	eb 1d                	jmp    80358e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803571:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803575:	75 07                	jne    80357e <devcons_read+0x5d>
		return 0;
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
  80357c:	eb 10                	jmp    80358e <devcons_read+0x6d>
	*(char*)vbuf = c;
  80357e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803581:	89 c2                	mov    %eax,%edx
  803583:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803587:	88 10                	mov    %dl,(%rax)
	return 1;
  803589:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80358e:	c9                   	leaveq 
  80358f:	c3                   	retq   

0000000000803590 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803590:	55                   	push   %rbp
  803591:	48 89 e5             	mov    %rsp,%rbp
  803594:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80359b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8035a2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8035a9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8035b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035b7:	eb 76                	jmp    80362f <devcons_write+0x9f>
		m = n - tot;
  8035b9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8035c0:	89 c2                	mov    %eax,%edx
  8035c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c5:	29 c2                	sub    %eax,%edx
  8035c7:	89 d0                	mov    %edx,%eax
  8035c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8035cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035cf:	83 f8 7f             	cmp    $0x7f,%eax
  8035d2:	76 07                	jbe    8035db <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8035d4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8035db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035de:	48 63 d0             	movslq %eax,%rdx
  8035e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e4:	48 63 c8             	movslq %eax,%rcx
  8035e7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8035ee:	48 01 c1             	add    %rax,%rcx
  8035f1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8035f8:	48 89 ce             	mov    %rcx,%rsi
  8035fb:	48 89 c7             	mov    %rax,%rdi
  8035fe:	48 b8 50 15 80 00 00 	movabs $0x801550,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80360a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80360d:	48 63 d0             	movslq %eax,%rdx
  803610:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803617:	48 89 d6             	mov    %rdx,%rsi
  80361a:	48 89 c7             	mov    %rax,%rdi
  80361d:	48 b8 13 1a 80 00 00 	movabs $0x801a13,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803629:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80362c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80362f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803632:	48 98                	cltq   
  803634:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80363b:	0f 82 78 ff ff ff    	jb     8035b9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803641:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803644:	c9                   	leaveq 
  803645:	c3                   	retq   

0000000000803646 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803646:	55                   	push   %rbp
  803647:	48 89 e5             	mov    %rsp,%rbp
  80364a:	48 83 ec 08          	sub    $0x8,%rsp
  80364e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803657:	c9                   	leaveq 
  803658:	c3                   	retq   

0000000000803659 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803659:	55                   	push   %rbp
  80365a:	48 89 e5             	mov    %rsp,%rbp
  80365d:	48 83 ec 10          	sub    $0x10,%rsp
  803661:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803665:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366d:	48 be 7a 40 80 00 00 	movabs $0x80407a,%rsi
  803674:	00 00 00 
  803677:	48 89 c7             	mov    %rax,%rdi
  80367a:	48 b8 2c 12 80 00 00 	movabs $0x80122c,%rax
  803681:	00 00 00 
  803684:	ff d0                	callq  *%rax
	return 0;
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80368b:	c9                   	leaveq 
  80368c:	c3                   	retq   

000000000080368d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80368d:	55                   	push   %rbp
  80368e:	48 89 e5             	mov    %rsp,%rbp
  803691:	48 83 ec 30          	sub    $0x30,%rsp
  803695:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803699:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80369d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  8036a1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8036a6:	75 0e                	jne    8036b6 <ipc_recv+0x29>
        pg = (void *)UTOP;
  8036a8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8036af:	00 00 00 
  8036b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  8036b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ba:	48 89 c7             	mov    %rax,%rdi
  8036bd:	48 b8 84 1d 80 00 00 	movabs $0x801d84,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
  8036c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d0:	79 27                	jns    8036f9 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8036d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036d7:	74 0a                	je     8036e3 <ipc_recv+0x56>
            *from_env_store = 0;
  8036d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036dd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8036e3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8036e8:	74 0a                	je     8036f4 <ipc_recv+0x67>
            *perm_store = 0;
  8036ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8036f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f7:	eb 53                	jmp    80374c <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8036f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036fe:	74 19                	je     803719 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803700:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803707:	00 00 00 
  80370a:	48 8b 00             	mov    (%rax),%rax
  80370d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803717:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803719:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80371e:	74 19                	je     803739 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803720:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803727:	00 00 00 
  80372a:	48 8b 00             	mov    (%rax),%rax
  80372d:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803737:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803739:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803740:	00 00 00 
  803743:	48 8b 00             	mov    (%rax),%rax
  803746:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  80374c:	c9                   	leaveq 
  80374d:	c3                   	retq   

000000000080374e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80374e:	55                   	push   %rbp
  80374f:	48 89 e5             	mov    %rsp,%rbp
  803752:	48 83 ec 30          	sub    $0x30,%rsp
  803756:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803759:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80375c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803760:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803763:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803768:	75 0e                	jne    803778 <ipc_send+0x2a>
        pg = (void *)UTOP;
  80376a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803771:	00 00 00 
  803774:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803778:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80377b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80377e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803782:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803785:	89 c7                	mov    %eax,%edi
  803787:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
  803793:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379a:	79 36                	jns    8037d2 <ipc_send+0x84>
  80379c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8037a0:	74 30                	je     8037d2 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  8037a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a5:	89 c1                	mov    %eax,%ecx
  8037a7:	48 ba 81 40 80 00 00 	movabs $0x804081,%rdx
  8037ae:	00 00 00 
  8037b1:	be 49 00 00 00       	mov    $0x49,%esi
  8037b6:	48 bf 8e 40 80 00 00 	movabs $0x80408e,%rdi
  8037bd:	00 00 00 
  8037c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c5:	49 b8 2b 04 80 00 00 	movabs $0x80042b,%r8
  8037cc:	00 00 00 
  8037cf:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8037d2:	48 b8 1d 1b 80 00 00 	movabs $0x801b1d,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
    } while(r != 0);
  8037de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e2:	75 94                	jne    803778 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8037e4:	c9                   	leaveq 
  8037e5:	c3                   	retq   

00000000008037e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8037e6:	55                   	push   %rbp
  8037e7:	48 89 e5             	mov    %rsp,%rbp
  8037ea:	48 83 ec 14          	sub    $0x14,%rsp
  8037ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8037f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037f8:	eb 5e                	jmp    803858 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8037fa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803801:	00 00 00 
  803804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803807:	48 63 d0             	movslq %eax,%rdx
  80380a:	48 89 d0             	mov    %rdx,%rax
  80380d:	48 c1 e0 03          	shl    $0x3,%rax
  803811:	48 01 d0             	add    %rdx,%rax
  803814:	48 c1 e0 05          	shl    $0x5,%rax
  803818:	48 01 c8             	add    %rcx,%rax
  80381b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803821:	8b 00                	mov    (%rax),%eax
  803823:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803826:	75 2c                	jne    803854 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803828:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80382f:	00 00 00 
  803832:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803835:	48 63 d0             	movslq %eax,%rdx
  803838:	48 89 d0             	mov    %rdx,%rax
  80383b:	48 c1 e0 03          	shl    $0x3,%rax
  80383f:	48 01 d0             	add    %rdx,%rax
  803842:	48 c1 e0 05          	shl    $0x5,%rax
  803846:	48 01 c8             	add    %rcx,%rax
  803849:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80384f:	8b 40 08             	mov    0x8(%rax),%eax
  803852:	eb 12                	jmp    803866 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803854:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803858:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80385f:	7e 99                	jle    8037fa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803861:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803866:	c9                   	leaveq 
  803867:	c3                   	retq   

0000000000803868 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803868:	55                   	push   %rbp
  803869:	48 89 e5             	mov    %rsp,%rbp
  80386c:	48 83 ec 18          	sub    $0x18,%rsp
  803870:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803878:	48 c1 e8 15          	shr    $0x15,%rax
  80387c:	48 89 c2             	mov    %rax,%rdx
  80387f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803886:	01 00 00 
  803889:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80388d:	83 e0 01             	and    $0x1,%eax
  803890:	48 85 c0             	test   %rax,%rax
  803893:	75 07                	jne    80389c <pageref+0x34>
		return 0;
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	eb 53                	jmp    8038ef <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80389c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8038a4:	48 89 c2             	mov    %rax,%rdx
  8038a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038ae:	01 00 00 
  8038b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8038b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038bd:	83 e0 01             	and    $0x1,%eax
  8038c0:	48 85 c0             	test   %rax,%rax
  8038c3:	75 07                	jne    8038cc <pageref+0x64>
		return 0;
  8038c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ca:	eb 23                	jmp    8038ef <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8038cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8038d4:	48 89 c2             	mov    %rax,%rdx
  8038d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8038de:	00 00 00 
  8038e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8038e5:	48 01 d0             	add    %rdx,%rax
  8038e8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8038ec:	0f b7 c0             	movzwl %ax,%eax
}
  8038ef:	c9                   	leaveq 
  8038f0:	c3                   	retq   
