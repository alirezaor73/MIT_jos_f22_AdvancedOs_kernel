
obj/user/lsfd:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf 20 3d 80 00 00 	movabs $0x803d20,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 96 03 80 00 00 	movabs $0x800396,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 4e 02 80 00 00 	movabs $0x80024e,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 5e 1b 80 00 00 	movabs $0x801b5e,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 26 26 80 00 00 	movabs $0x802626,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be 38 3d 80 00 00 	movabs $0x803d38,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba be 2f 80 00 00 	movabs $0x802fbe,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf 38 3d 80 00 00 	movabs $0x803d38,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 96 03 80 00 00 	movabs $0x800396,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 20          	sub    $0x20,%rsp
  8001c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  8001cc:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  8001db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e3:	48 63 d0             	movslq %eax,%rdx
  8001e6:	48 89 d0             	mov    %rdx,%rax
  8001e9:	48 c1 e0 03          	shl    $0x3,%rax
  8001ed:	48 01 d0             	add    %rdx,%rax
  8001f0:	48 c1 e0 05          	shl    $0x5,%rax
  8001f4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001fb:	00 00 00 
  8001fe:	48 01 c2             	add    %rax,%rdx
  800201:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800208:	00 00 00 
  80020b:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800212:	7e 14                	jle    800228 <libmain+0x6b>
		binaryname = argv[0];
  800214:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800218:	48 8b 10             	mov    (%rax),%rdx
  80021b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800222:	00 00 00 
  800225:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800228:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80022c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022f:	48 89 d6             	mov    %rdx,%rsi
  800232:	89 c7                	mov    %eax,%edi
  800234:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800240:	48 b8 4e 02 80 00 00 	movabs $0x80024e,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
}
  80024c:	c9                   	leaveq 
  80024d:	c3                   	retq   

000000000080024e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80024e:	55                   	push   %rbp
  80024f:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800252:	48 b8 20 21 80 00 00 	movabs $0x802120,%rax
  800259:	00 00 00 
  80025c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80025e:	bf 00 00 00 00       	mov    $0x0,%edi
  800263:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
}
  80026f:	5d                   	pop    %rbp
  800270:	c3                   	retq   

0000000000800271 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	48 83 ec 10          	sub    $0x10,%rsp
  800279:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80027c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800284:	8b 00                	mov    (%rax),%eax
  800286:	8d 48 01             	lea    0x1(%rax),%ecx
  800289:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80028d:	89 0a                	mov    %ecx,(%rdx)
  80028f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800292:	89 d1                	mov    %edx,%ecx
  800294:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800298:	48 98                	cltq   
  80029a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80029e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a2:	8b 00                	mov    (%rax),%eax
  8002a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a9:	75 2c                	jne    8002d7 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002af:	8b 00                	mov    (%rax),%eax
  8002b1:	48 98                	cltq   
  8002b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b7:	48 83 c2 08          	add    $0x8,%rdx
  8002bb:	48 89 c6             	mov    %rax,%rsi
  8002be:	48 89 d7             	mov    %rdx,%rdi
  8002c1:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  8002c8:	00 00 00 
  8002cb:	ff d0                	callq  *%rax
        b->idx = 0;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002db:	8b 40 04             	mov    0x4(%rax),%eax
  8002de:	8d 50 01             	lea    0x1(%rax),%edx
  8002e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002e8:	c9                   	leaveq 
  8002e9:	c3                   	retq   

00000000008002ea <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002ea:	55                   	push   %rbp
  8002eb:	48 89 e5             	mov    %rsp,%rbp
  8002ee:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002f5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002fc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800303:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80030a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800311:	48 8b 0a             	mov    (%rdx),%rcx
  800314:	48 89 08             	mov    %rcx,(%rax)
  800317:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80031b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80031f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800323:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800327:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80032e:	00 00 00 
    b.cnt = 0;
  800331:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800338:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80033b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800342:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800349:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800350:	48 89 c6             	mov    %rax,%rsi
  800353:	48 bf 71 02 80 00 00 	movabs $0x800271,%rdi
  80035a:	00 00 00 
  80035d:	48 b8 49 07 80 00 00 	movabs $0x800749,%rax
  800364:	00 00 00 
  800367:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800369:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80036f:	48 98                	cltq   
  800371:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800378:	48 83 c2 08          	add    $0x8,%rdx
  80037c:	48 89 c6             	mov    %rax,%rsi
  80037f:	48 89 d7             	mov    %rdx,%rdi
  800382:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  800389:	00 00 00 
  80038c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80038e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800394:	c9                   	leaveq 
  800395:	c3                   	retq   

0000000000800396 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800396:	55                   	push   %rbp
  800397:	48 89 e5             	mov    %rsp,%rbp
  80039a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003a1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003a8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003af:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003b6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003bd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003c4:	84 c0                	test   %al,%al
  8003c6:	74 20                	je     8003e8 <cprintf+0x52>
  8003c8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003cc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003d0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003d4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003d8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003dc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003e0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003e4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003e8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003ef:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003f6:	00 00 00 
  8003f9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800400:	00 00 00 
  800403:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800407:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80040e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800415:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80041c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800423:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80042a:	48 8b 0a             	mov    (%rdx),%rcx
  80042d:	48 89 08             	mov    %rcx,(%rax)
  800430:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800434:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800438:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800440:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800447:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80044e:	48 89 d6             	mov    %rdx,%rsi
  800451:	48 89 c7             	mov    %rax,%rdi
  800454:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  80045b:	00 00 00 
  80045e:	ff d0                	callq  *%rax
  800460:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800466:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80046c:	c9                   	leaveq 
  80046d:	c3                   	retq   

000000000080046e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
  800472:	53                   	push   %rbx
  800473:	48 83 ec 38          	sub    $0x38,%rsp
  800477:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80047b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80047f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800483:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800486:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80048a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80048e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800491:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800495:	77 3b                	ja     8004d2 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800497:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80049a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80049e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004aa:	48 f7 f3             	div    %rbx
  8004ad:	48 89 c2             	mov    %rax,%rdx
  8004b0:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004b3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004b6:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004be:	41 89 f9             	mov    %edi,%r9d
  8004c1:	48 89 c7             	mov    %rax,%rdi
  8004c4:	48 b8 6e 04 80 00 00 	movabs $0x80046e,%rax
  8004cb:	00 00 00 
  8004ce:	ff d0                	callq  *%rax
  8004d0:	eb 1e                	jmp    8004f0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d2:	eb 12                	jmp    8004e6 <printnum+0x78>
			putch(padc, putdat);
  8004d4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004d8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004df:	48 89 ce             	mov    %rcx,%rsi
  8004e2:	89 d7                	mov    %edx,%edi
  8004e4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004ea:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004ee:	7f e4                	jg     8004d4 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004f0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fc:	48 f7 f1             	div    %rcx
  8004ff:	48 89 d0             	mov    %rdx,%rax
  800502:	48 ba 70 3f 80 00 00 	movabs $0x803f70,%rdx
  800509:	00 00 00 
  80050c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800510:	0f be d0             	movsbl %al,%edx
  800513:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051b:	48 89 ce             	mov    %rcx,%rsi
  80051e:	89 d7                	mov    %edx,%edi
  800520:	ff d0                	callq  *%rax
}
  800522:	48 83 c4 38          	add    $0x38,%rsp
  800526:	5b                   	pop    %rbx
  800527:	5d                   	pop    %rbp
  800528:	c3                   	retq   

0000000000800529 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800529:	55                   	push   %rbp
  80052a:	48 89 e5             	mov    %rsp,%rbp
  80052d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800531:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800535:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800538:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80053c:	7e 52                	jle    800590 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80053e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800542:	8b 00                	mov    (%rax),%eax
  800544:	83 f8 30             	cmp    $0x30,%eax
  800547:	73 24                	jae    80056d <getuint+0x44>
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	8b 00                	mov    (%rax),%eax
  800557:	89 c0                	mov    %eax,%eax
  800559:	48 01 d0             	add    %rdx,%rax
  80055c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800560:	8b 12                	mov    (%rdx),%edx
  800562:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800565:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800569:	89 0a                	mov    %ecx,(%rdx)
  80056b:	eb 17                	jmp    800584 <getuint+0x5b>
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800575:	48 89 d0             	mov    %rdx,%rax
  800578:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800580:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800584:	48 8b 00             	mov    (%rax),%rax
  800587:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058b:	e9 a3 00 00 00       	jmpq   800633 <getuint+0x10a>
	else if (lflag)
  800590:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800594:	74 4f                	je     8005e5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	8b 00                	mov    (%rax),%eax
  80059c:	83 f8 30             	cmp    $0x30,%eax
  80059f:	73 24                	jae    8005c5 <getuint+0x9c>
  8005a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	8b 00                	mov    (%rax),%eax
  8005af:	89 c0                	mov    %eax,%eax
  8005b1:	48 01 d0             	add    %rdx,%rax
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	8b 12                	mov    (%rdx),%edx
  8005ba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c1:	89 0a                	mov    %ecx,(%rdx)
  8005c3:	eb 17                	jmp    8005dc <getuint+0xb3>
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005cd:	48 89 d0             	mov    %rdx,%rax
  8005d0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005dc:	48 8b 00             	mov    (%rax),%rax
  8005df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e3:	eb 4e                	jmp    800633 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	83 f8 30             	cmp    $0x30,%eax
  8005ee:	73 24                	jae    800614 <getuint+0xeb>
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	8b 00                	mov    (%rax),%eax
  8005fe:	89 c0                	mov    %eax,%eax
  800600:	48 01 d0             	add    %rdx,%rax
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	8b 12                	mov    (%rdx),%edx
  800609:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	89 0a                	mov    %ecx,(%rdx)
  800612:	eb 17                	jmp    80062b <getuint+0x102>
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061c:	48 89 d0             	mov    %rdx,%rax
  80061f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800627:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	89 c0                	mov    %eax,%eax
  80062f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800637:	c9                   	leaveq 
  800638:	c3                   	retq   

0000000000800639 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800639:	55                   	push   %rbp
  80063a:	48 89 e5             	mov    %rsp,%rbp
  80063d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800641:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800645:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800648:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80064c:	7e 52                	jle    8006a0 <getint+0x67>
		x=va_arg(*ap, long long);
  80064e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800652:	8b 00                	mov    (%rax),%eax
  800654:	83 f8 30             	cmp    $0x30,%eax
  800657:	73 24                	jae    80067d <getint+0x44>
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	8b 00                	mov    (%rax),%eax
  800667:	89 c0                	mov    %eax,%eax
  800669:	48 01 d0             	add    %rdx,%rax
  80066c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800670:	8b 12                	mov    (%rdx),%edx
  800672:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800679:	89 0a                	mov    %ecx,(%rdx)
  80067b:	eb 17                	jmp    800694 <getint+0x5b>
  80067d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800681:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800685:	48 89 d0             	mov    %rdx,%rax
  800688:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800690:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800694:	48 8b 00             	mov    (%rax),%rax
  800697:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069b:	e9 a3 00 00 00       	jmpq   800743 <getint+0x10a>
	else if (lflag)
  8006a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a4:	74 4f                	je     8006f5 <getint+0xbc>
		x=va_arg(*ap, long);
  8006a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006aa:	8b 00                	mov    (%rax),%eax
  8006ac:	83 f8 30             	cmp    $0x30,%eax
  8006af:	73 24                	jae    8006d5 <getint+0x9c>
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bd:	8b 00                	mov    (%rax),%eax
  8006bf:	89 c0                	mov    %eax,%eax
  8006c1:	48 01 d0             	add    %rdx,%rax
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	8b 12                	mov    (%rdx),%edx
  8006ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	89 0a                	mov    %ecx,(%rdx)
  8006d3:	eb 17                	jmp    8006ec <getint+0xb3>
  8006d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006dd:	48 89 d0             	mov    %rdx,%rax
  8006e0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ec:	48 8b 00             	mov    (%rax),%rax
  8006ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f3:	eb 4e                	jmp    800743 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f9:	8b 00                	mov    (%rax),%eax
  8006fb:	83 f8 30             	cmp    $0x30,%eax
  8006fe:	73 24                	jae    800724 <getint+0xeb>
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	8b 00                	mov    (%rax),%eax
  80070e:	89 c0                	mov    %eax,%eax
  800710:	48 01 d0             	add    %rdx,%rax
  800713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800717:	8b 12                	mov    (%rdx),%edx
  800719:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	89 0a                	mov    %ecx,(%rdx)
  800722:	eb 17                	jmp    80073b <getint+0x102>
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072c:	48 89 d0             	mov    %rdx,%rax
  80072f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800737:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	48 98                	cltq   
  80073f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800743:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800747:	c9                   	leaveq 
  800748:	c3                   	retq   

0000000000800749 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800749:	55                   	push   %rbp
  80074a:	48 89 e5             	mov    %rsp,%rbp
  80074d:	41 54                	push   %r12
  80074f:	53                   	push   %rbx
  800750:	48 83 ec 60          	sub    $0x60,%rsp
  800754:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800758:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80075c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800760:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800764:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800768:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80076c:	48 8b 0a             	mov    (%rdx),%rcx
  80076f:	48 89 08             	mov    %rcx,(%rax)
  800772:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800776:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80077a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80077e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800782:	eb 17                	jmp    80079b <vprintfmt+0x52>
			if (ch == '\0')
  800784:	85 db                	test   %ebx,%ebx
  800786:	0f 84 df 04 00 00    	je     800c6b <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80078c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800790:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800794:	48 89 d6             	mov    %rdx,%rsi
  800797:	89 df                	mov    %ebx,%edi
  800799:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007a7:	0f b6 00             	movzbl (%rax),%eax
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	83 fb 25             	cmp    $0x25,%ebx
  8007b0:	75 d2                	jne    800784 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b2:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007b6:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007cb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007da:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007de:	0f b6 00             	movzbl (%rax),%eax
  8007e1:	0f b6 d8             	movzbl %al,%ebx
  8007e4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007e7:	83 f8 55             	cmp    $0x55,%eax
  8007ea:	0f 87 47 04 00 00    	ja     800c37 <vprintfmt+0x4ee>
  8007f0:	89 c0                	mov    %eax,%eax
  8007f2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007f9:	00 
  8007fa:	48 b8 98 3f 80 00 00 	movabs $0x803f98,%rax
  800801:	00 00 00 
  800804:	48 01 d0             	add    %rdx,%rax
  800807:	48 8b 00             	mov    (%rax),%rax
  80080a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80080c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800810:	eb c0                	jmp    8007d2 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800812:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800816:	eb ba                	jmp    8007d2 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800818:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80081f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800822:	89 d0                	mov    %edx,%eax
  800824:	c1 e0 02             	shl    $0x2,%eax
  800827:	01 d0                	add    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d8                	add    %ebx,%eax
  80082d:	83 e8 30             	sub    $0x30,%eax
  800830:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800833:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800837:	0f b6 00             	movzbl (%rax),%eax
  80083a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80083d:	83 fb 2f             	cmp    $0x2f,%ebx
  800840:	7e 0c                	jle    80084e <vprintfmt+0x105>
  800842:	83 fb 39             	cmp    $0x39,%ebx
  800845:	7f 07                	jg     80084e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800847:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80084c:	eb d1                	jmp    80081f <vprintfmt+0xd6>
			goto process_precision;
  80084e:	eb 58                	jmp    8008a8 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800850:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800853:	83 f8 30             	cmp    $0x30,%eax
  800856:	73 17                	jae    80086f <vprintfmt+0x126>
  800858:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085f:	89 c0                	mov    %eax,%eax
  800861:	48 01 d0             	add    %rdx,%rax
  800864:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800867:	83 c2 08             	add    $0x8,%edx
  80086a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086d:	eb 0f                	jmp    80087e <vprintfmt+0x135>
  80086f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800873:	48 89 d0             	mov    %rdx,%rax
  800876:	48 83 c2 08          	add    $0x8,%rdx
  80087a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087e:	8b 00                	mov    (%rax),%eax
  800880:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800883:	eb 23                	jmp    8008a8 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800885:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800889:	79 0c                	jns    800897 <vprintfmt+0x14e>
				width = 0;
  80088b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800892:	e9 3b ff ff ff       	jmpq   8007d2 <vprintfmt+0x89>
  800897:	e9 36 ff ff ff       	jmpq   8007d2 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80089c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008a3:	e9 2a ff ff ff       	jmpq   8007d2 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ac:	79 12                	jns    8008c0 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008b4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008bb:	e9 12 ff ff ff       	jmpq   8007d2 <vprintfmt+0x89>
  8008c0:	e9 0d ff ff ff       	jmpq   8007d2 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008c9:	e9 04 ff ff ff       	jmpq   8007d2 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d1:	83 f8 30             	cmp    $0x30,%eax
  8008d4:	73 17                	jae    8008ed <vprintfmt+0x1a4>
  8008d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dd:	89 c0                	mov    %eax,%eax
  8008df:	48 01 d0             	add    %rdx,%rax
  8008e2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008e5:	83 c2 08             	add    $0x8,%edx
  8008e8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008eb:	eb 0f                	jmp    8008fc <vprintfmt+0x1b3>
  8008ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008f1:	48 89 d0             	mov    %rdx,%rax
  8008f4:	48 83 c2 08          	add    $0x8,%rdx
  8008f8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008fc:	8b 10                	mov    (%rax),%edx
  8008fe:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800902:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800906:	48 89 ce             	mov    %rcx,%rsi
  800909:	89 d7                	mov    %edx,%edi
  80090b:	ff d0                	callq  *%rax
			break;
  80090d:	e9 53 03 00 00       	jmpq   800c65 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800912:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800915:	83 f8 30             	cmp    $0x30,%eax
  800918:	73 17                	jae    800931 <vprintfmt+0x1e8>
  80091a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80091e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800921:	89 c0                	mov    %eax,%eax
  800923:	48 01 d0             	add    %rdx,%rax
  800926:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800929:	83 c2 08             	add    $0x8,%edx
  80092c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80092f:	eb 0f                	jmp    800940 <vprintfmt+0x1f7>
  800931:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800935:	48 89 d0             	mov    %rdx,%rax
  800938:	48 83 c2 08          	add    $0x8,%rdx
  80093c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800940:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800942:	85 db                	test   %ebx,%ebx
  800944:	79 02                	jns    800948 <vprintfmt+0x1ff>
				err = -err;
  800946:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800948:	83 fb 15             	cmp    $0x15,%ebx
  80094b:	7f 16                	jg     800963 <vprintfmt+0x21a>
  80094d:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  800954:	00 00 00 
  800957:	48 63 d3             	movslq %ebx,%rdx
  80095a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80095e:	4d 85 e4             	test   %r12,%r12
  800961:	75 2e                	jne    800991 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800963:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800967:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096b:	89 d9                	mov    %ebx,%ecx
  80096d:	48 ba 81 3f 80 00 00 	movabs $0x803f81,%rdx
  800974:	00 00 00 
  800977:	48 89 c7             	mov    %rax,%rdi
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	49 b8 74 0c 80 00 00 	movabs $0x800c74,%r8
  800986:	00 00 00 
  800989:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 d4 02 00 00       	jmpq   800c65 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800995:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800999:	4c 89 e1             	mov    %r12,%rcx
  80099c:	48 ba 8a 3f 80 00 00 	movabs $0x803f8a,%rdx
  8009a3:	00 00 00 
  8009a6:	48 89 c7             	mov    %rax,%rdi
  8009a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ae:	49 b8 74 0c 80 00 00 	movabs $0x800c74,%r8
  8009b5:	00 00 00 
  8009b8:	41 ff d0             	callq  *%r8
			break;
  8009bb:	e9 a5 02 00 00       	jmpq   800c65 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 30             	cmp    $0x30,%eax
  8009c6:	73 17                	jae    8009df <vprintfmt+0x296>
  8009c8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cf:	89 c0                	mov    %eax,%eax
  8009d1:	48 01 d0             	add    %rdx,%rax
  8009d4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d7:	83 c2 08             	add    $0x8,%edx
  8009da:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009dd:	eb 0f                	jmp    8009ee <vprintfmt+0x2a5>
  8009df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e3:	48 89 d0             	mov    %rdx,%rax
  8009e6:	48 83 c2 08          	add    $0x8,%rdx
  8009ea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ee:	4c 8b 20             	mov    (%rax),%r12
  8009f1:	4d 85 e4             	test   %r12,%r12
  8009f4:	75 0a                	jne    800a00 <vprintfmt+0x2b7>
				p = "(null)";
  8009f6:	49 bc 8d 3f 80 00 00 	movabs $0x803f8d,%r12
  8009fd:	00 00 00 
			if (width > 0 && padc != '-')
  800a00:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a04:	7e 3f                	jle    800a45 <vprintfmt+0x2fc>
  800a06:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a0a:	74 39                	je     800a45 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a0f:	48 98                	cltq   
  800a11:	48 89 c6             	mov    %rax,%rsi
  800a14:	4c 89 e7             	mov    %r12,%rdi
  800a17:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  800a1e:	00 00 00 
  800a21:	ff d0                	callq  *%rax
  800a23:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a26:	eb 17                	jmp    800a3f <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a28:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a2c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a34:	48 89 ce             	mov    %rcx,%rsi
  800a37:	89 d7                	mov    %edx,%edi
  800a39:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a43:	7f e3                	jg     800a28 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a45:	eb 37                	jmp    800a7e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a47:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a4b:	74 1e                	je     800a6b <vprintfmt+0x322>
  800a4d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a50:	7e 05                	jle    800a57 <vprintfmt+0x30e>
  800a52:	83 fb 7e             	cmp    $0x7e,%ebx
  800a55:	7e 14                	jle    800a6b <vprintfmt+0x322>
					putch('?', putdat);
  800a57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5f:	48 89 d6             	mov    %rdx,%rsi
  800a62:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a67:	ff d0                	callq  *%rax
  800a69:	eb 0f                	jmp    800a7a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	48 89 d6             	mov    %rdx,%rsi
  800a76:	89 df                	mov    %ebx,%edi
  800a78:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a7e:	4c 89 e0             	mov    %r12,%rax
  800a81:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a85:	0f b6 00             	movzbl (%rax),%eax
  800a88:	0f be d8             	movsbl %al,%ebx
  800a8b:	85 db                	test   %ebx,%ebx
  800a8d:	74 10                	je     800a9f <vprintfmt+0x356>
  800a8f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a93:	78 b2                	js     800a47 <vprintfmt+0x2fe>
  800a95:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a99:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a9d:	79 a8                	jns    800a47 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a9f:	eb 16                	jmp    800ab7 <vprintfmt+0x36e>
				putch(' ', putdat);
  800aa1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa9:	48 89 d6             	mov    %rdx,%rsi
  800aac:	bf 20 00 00 00       	mov    $0x20,%edi
  800ab1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800abb:	7f e4                	jg     800aa1 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800abd:	e9 a3 01 00 00       	jmpq   800c65 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ac2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac6:	be 03 00 00 00       	mov    $0x3,%esi
  800acb:	48 89 c7             	mov    %rax,%rdi
  800ace:	48 b8 39 06 80 00 00 	movabs $0x800639,%rax
  800ad5:	00 00 00 
  800ad8:	ff d0                	callq  *%rax
  800ada:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae2:	48 85 c0             	test   %rax,%rax
  800ae5:	79 1d                	jns    800b04 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ae7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aeb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aef:	48 89 d6             	mov    %rdx,%rsi
  800af2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800af7:	ff d0                	callq  *%rax
				num = -(long long) num;
  800af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afd:	48 f7 d8             	neg    %rax
  800b00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b04:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b0b:	e9 e8 00 00 00       	jmpq   800bf8 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b14:	be 03 00 00 00       	mov    $0x3,%esi
  800b19:	48 89 c7             	mov    %rax,%rdi
  800b1c:	48 b8 29 05 80 00 00 	movabs $0x800529,%rax
  800b23:	00 00 00 
  800b26:	ff d0                	callq  *%rax
  800b28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b2c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b33:	e9 c0 00 00 00       	jmpq   800bf8 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	48 89 d6             	mov    %rdx,%rsi
  800b43:	bf 58 00 00 00       	mov    $0x58,%edi
  800b48:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	48 89 d6             	mov    %rdx,%rsi
  800b55:	bf 58 00 00 00       	mov    $0x58,%edi
  800b5a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	48 89 d6             	mov    %rdx,%rsi
  800b67:	bf 58 00 00 00       	mov    $0x58,%edi
  800b6c:	ff d0                	callq  *%rax
			break;
  800b6e:	e9 f2 00 00 00       	jmpq   800c65 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7b:	48 89 d6             	mov    %rdx,%rsi
  800b7e:	bf 30 00 00 00       	mov    $0x30,%edi
  800b83:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	48 89 d6             	mov    %rdx,%rsi
  800b90:	bf 78 00 00 00       	mov    $0x78,%edi
  800b95:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9a:	83 f8 30             	cmp    $0x30,%eax
  800b9d:	73 17                	jae    800bb6 <vprintfmt+0x46d>
  800b9f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ba3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba6:	89 c0                	mov    %eax,%eax
  800ba8:	48 01 d0             	add    %rdx,%rax
  800bab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bae:	83 c2 08             	add    $0x8,%edx
  800bb1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb4:	eb 0f                	jmp    800bc5 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800bb6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bba:	48 89 d0             	mov    %rdx,%rax
  800bbd:	48 83 c2 08          	add    $0x8,%rdx
  800bc1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bcc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bd3:	eb 23                	jmp    800bf8 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd9:	be 03 00 00 00       	mov    $0x3,%esi
  800bde:	48 89 c7             	mov    %rax,%rdi
  800be1:	48 b8 29 05 80 00 00 	movabs $0x800529,%rax
  800be8:	00 00 00 
  800beb:	ff d0                	callq  *%rax
  800bed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bf1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bfd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c00:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c07:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0f:	45 89 c1             	mov    %r8d,%r9d
  800c12:	41 89 f8             	mov    %edi,%r8d
  800c15:	48 89 c7             	mov    %rax,%rdi
  800c18:	48 b8 6e 04 80 00 00 	movabs $0x80046e,%rax
  800c1f:	00 00 00 
  800c22:	ff d0                	callq  *%rax
			break;
  800c24:	eb 3f                	jmp    800c65 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2e:	48 89 d6             	mov    %rdx,%rsi
  800c31:	89 df                	mov    %ebx,%edi
  800c33:	ff d0                	callq  *%rax
			break;
  800c35:	eb 2e                	jmp    800c65 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3f:	48 89 d6             	mov    %rdx,%rsi
  800c42:	bf 25 00 00 00       	mov    $0x25,%edi
  800c47:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c49:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c4e:	eb 05                	jmp    800c55 <vprintfmt+0x50c>
  800c50:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c55:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c59:	48 83 e8 01          	sub    $0x1,%rax
  800c5d:	0f b6 00             	movzbl (%rax),%eax
  800c60:	3c 25                	cmp    $0x25,%al
  800c62:	75 ec                	jne    800c50 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800c64:	90                   	nop
		}
	}
  800c65:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c66:	e9 30 fb ff ff       	jmpq   80079b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c6b:	48 83 c4 60          	add    $0x60,%rsp
  800c6f:	5b                   	pop    %rbx
  800c70:	41 5c                	pop    %r12
  800c72:	5d                   	pop    %rbp
  800c73:	c3                   	retq   

0000000000800c74 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c74:	55                   	push   %rbp
  800c75:	48 89 e5             	mov    %rsp,%rbp
  800c78:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c7f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c86:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c8d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c94:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c9b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ca2:	84 c0                	test   %al,%al
  800ca4:	74 20                	je     800cc6 <printfmt+0x52>
  800ca6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800caa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cb2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cb6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cbe:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cc2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cc6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ccd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cd4:	00 00 00 
  800cd7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cde:	00 00 00 
  800ce1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ce5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cf3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cfa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d01:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d08:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d0f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d16:	48 89 c7             	mov    %rax,%rdi
  800d19:	48 b8 49 07 80 00 00 	movabs $0x800749,%rax
  800d20:	00 00 00 
  800d23:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d25:	c9                   	leaveq 
  800d26:	c3                   	retq   

0000000000800d27 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d27:	55                   	push   %rbp
  800d28:	48 89 e5             	mov    %rsp,%rbp
  800d2b:	48 83 ec 10          	sub    $0x10,%rsp
  800d2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3a:	8b 40 10             	mov    0x10(%rax),%eax
  800d3d:	8d 50 01             	lea    0x1(%rax),%edx
  800d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d44:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d4b:	48 8b 10             	mov    (%rax),%rdx
  800d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d52:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d56:	48 39 c2             	cmp    %rax,%rdx
  800d59:	73 17                	jae    800d72 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5f:	48 8b 00             	mov    (%rax),%rax
  800d62:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d6a:	48 89 0a             	mov    %rcx,(%rdx)
  800d6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d70:	88 10                	mov    %dl,(%rax)
}
  800d72:	c9                   	leaveq 
  800d73:	c3                   	retq   

0000000000800d74 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d74:	55                   	push   %rbp
  800d75:	48 89 e5             	mov    %rsp,%rbp
  800d78:	48 83 ec 50          	sub    $0x50,%rsp
  800d7c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d80:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d83:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d87:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d8b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d8f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d93:	48 8b 0a             	mov    (%rdx),%rcx
  800d96:	48 89 08             	mov    %rcx,(%rax)
  800d99:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d9d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800da1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800da5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dad:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800db1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800db4:	48 98                	cltq   
  800db6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800dba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dbe:	48 01 d0             	add    %rdx,%rax
  800dc1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dc5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dcc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dd1:	74 06                	je     800dd9 <vsnprintf+0x65>
  800dd3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dd7:	7f 07                	jg     800de0 <vsnprintf+0x6c>
		return -E_INVAL;
  800dd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dde:	eb 2f                	jmp    800e0f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800de0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800de4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800de8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dec:	48 89 c6             	mov    %rax,%rsi
  800def:	48 bf 27 0d 80 00 00 	movabs $0x800d27,%rdi
  800df6:	00 00 00 
  800df9:	48 b8 49 07 80 00 00 	movabs $0x800749,%rax
  800e00:	00 00 00 
  800e03:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e09:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e0c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e0f:	c9                   	leaveq 
  800e10:	c3                   	retq   

0000000000800e11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e11:	55                   	push   %rbp
  800e12:	48 89 e5             	mov    %rsp,%rbp
  800e15:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e1c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e23:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e29:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e30:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e37:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e3e:	84 c0                	test   %al,%al
  800e40:	74 20                	je     800e62 <snprintf+0x51>
  800e42:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e46:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e4a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e4e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e52:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e56:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e5a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e5e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e62:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e69:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e70:	00 00 00 
  800e73:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e7a:	00 00 00 
  800e7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e81:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e88:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e8f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e96:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e9d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ea4:	48 8b 0a             	mov    (%rdx),%rcx
  800ea7:	48 89 08             	mov    %rcx,(%rax)
  800eaa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eb2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800eba:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ec1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ec8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ece:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ed5:	48 89 c7             	mov    %rax,%rdi
  800ed8:	48 b8 74 0d 80 00 00 	movabs $0x800d74,%rax
  800edf:	00 00 00 
  800ee2:	ff d0                	callq  *%rax
  800ee4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800eea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ef0:	c9                   	leaveq 
  800ef1:	c3                   	retq   

0000000000800ef2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ef2:	55                   	push   %rbp
  800ef3:	48 89 e5             	mov    %rsp,%rbp
  800ef6:	48 83 ec 18          	sub    $0x18,%rsp
  800efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f05:	eb 09                	jmp    800f10 <strlen+0x1e>
		n++;
  800f07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f0b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f14:	0f b6 00             	movzbl (%rax),%eax
  800f17:	84 c0                	test   %al,%al
  800f19:	75 ec                	jne    800f07 <strlen+0x15>
		n++;
	return n;
  800f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 20          	sub    $0x20,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f37:	eb 0e                	jmp    800f47 <strnlen+0x27>
		n++;
  800f39:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f3d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f42:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f47:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f4c:	74 0b                	je     800f59 <strnlen+0x39>
  800f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f52:	0f b6 00             	movzbl (%rax),%eax
  800f55:	84 c0                	test   %al,%al
  800f57:	75 e0                	jne    800f39 <strnlen+0x19>
		n++;
	return n;
  800f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f5c:	c9                   	leaveq 
  800f5d:	c3                   	retq   

0000000000800f5e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f5e:	55                   	push   %rbp
  800f5f:	48 89 e5             	mov    %rsp,%rbp
  800f62:	48 83 ec 20          	sub    $0x20,%rsp
  800f66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f76:	90                   	nop
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f83:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f87:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f8b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f8f:	0f b6 12             	movzbl (%rdx),%edx
  800f92:	88 10                	mov    %dl,(%rax)
  800f94:	0f b6 00             	movzbl (%rax),%eax
  800f97:	84 c0                	test   %al,%al
  800f99:	75 dc                	jne    800f77 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f9f:	c9                   	leaveq 
  800fa0:	c3                   	retq   

0000000000800fa1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fa1:	55                   	push   %rbp
  800fa2:	48 89 e5             	mov    %rsp,%rbp
  800fa5:	48 83 ec 20          	sub    $0x20,%rsp
  800fa9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb5:	48 89 c7             	mov    %rax,%rdi
  800fb8:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  800fbf:	00 00 00 
  800fc2:	ff d0                	callq  *%rax
  800fc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fca:	48 63 d0             	movslq %eax,%rdx
  800fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd1:	48 01 c2             	add    %rax,%rdx
  800fd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd8:	48 89 c6             	mov    %rax,%rsi
  800fdb:	48 89 d7             	mov    %rdx,%rdi
  800fde:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  800fe5:	00 00 00 
  800fe8:	ff d0                	callq  *%rax
	return dst;
  800fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 28          	sub    $0x28,%rsp
  800ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801000:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801008:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80100c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801013:	00 
  801014:	eb 2a                	jmp    801040 <strncpy+0x50>
		*dst++ = *src;
  801016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80101e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801022:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801026:	0f b6 12             	movzbl (%rdx),%edx
  801029:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80102b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80102f:	0f b6 00             	movzbl (%rax),%eax
  801032:	84 c0                	test   %al,%al
  801034:	74 05                	je     80103b <strncpy+0x4b>
			src++;
  801036:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80103b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801044:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801048:	72 cc                	jb     801016 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80104a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80104e:	c9                   	leaveq 
  80104f:	c3                   	retq   

0000000000801050 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801050:	55                   	push   %rbp
  801051:	48 89 e5             	mov    %rsp,%rbp
  801054:	48 83 ec 28          	sub    $0x28,%rsp
  801058:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801060:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801068:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80106c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801071:	74 3d                	je     8010b0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801073:	eb 1d                	jmp    801092 <strlcpy+0x42>
			*dst++ = *src++;
  801075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801079:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80107d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801081:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801085:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801089:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80108d:	0f b6 12             	movzbl (%rdx),%edx
  801090:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801092:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801097:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80109c:	74 0b                	je     8010a9 <strlcpy+0x59>
  80109e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a2:	0f b6 00             	movzbl (%rax),%eax
  8010a5:	84 c0                	test   %al,%al
  8010a7:	75 cc                	jne    801075 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b8:	48 29 c2             	sub    %rax,%rdx
  8010bb:	48 89 d0             	mov    %rdx,%rax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 10          	sub    $0x10,%rsp
  8010c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010d0:	eb 0a                	jmp    8010dc <strcmp+0x1c>
		p++, q++;
  8010d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e0:	0f b6 00             	movzbl (%rax),%eax
  8010e3:	84 c0                	test   %al,%al
  8010e5:	74 12                	je     8010f9 <strcmp+0x39>
  8010e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010eb:	0f b6 10             	movzbl (%rax),%edx
  8010ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	38 c2                	cmp    %al,%dl
  8010f7:	74 d9                	je     8010d2 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fd:	0f b6 00             	movzbl (%rax),%eax
  801100:	0f b6 d0             	movzbl %al,%edx
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	0f b6 c0             	movzbl %al,%eax
  80110d:	29 c2                	sub    %eax,%edx
  80110f:	89 d0                	mov    %edx,%eax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 18          	sub    $0x18,%rsp
  80111b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801123:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801127:	eb 0f                	jmp    801138 <strncmp+0x25>
		n--, p++, q++;
  801129:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80112e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801133:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801138:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80113d:	74 1d                	je     80115c <strncmp+0x49>
  80113f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801143:	0f b6 00             	movzbl (%rax),%eax
  801146:	84 c0                	test   %al,%al
  801148:	74 12                	je     80115c <strncmp+0x49>
  80114a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114e:	0f b6 10             	movzbl (%rax),%edx
  801151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801155:	0f b6 00             	movzbl (%rax),%eax
  801158:	38 c2                	cmp    %al,%dl
  80115a:	74 cd                	je     801129 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80115c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801161:	75 07                	jne    80116a <strncmp+0x57>
		return 0;
  801163:	b8 00 00 00 00       	mov    $0x0,%eax
  801168:	eb 18                	jmp    801182 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80116a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116e:	0f b6 00             	movzbl (%rax),%eax
  801171:	0f b6 d0             	movzbl %al,%edx
  801174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801178:	0f b6 00             	movzbl (%rax),%eax
  80117b:	0f b6 c0             	movzbl %al,%eax
  80117e:	29 c2                	sub    %eax,%edx
  801180:	89 d0                	mov    %edx,%eax
}
  801182:	c9                   	leaveq 
  801183:	c3                   	retq   

0000000000801184 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801184:	55                   	push   %rbp
  801185:	48 89 e5             	mov    %rsp,%rbp
  801188:	48 83 ec 0c          	sub    $0xc,%rsp
  80118c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801190:	89 f0                	mov    %esi,%eax
  801192:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801195:	eb 17                	jmp    8011ae <strchr+0x2a>
		if (*s == c)
  801197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119b:	0f b6 00             	movzbl (%rax),%eax
  80119e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011a1:	75 06                	jne    8011a9 <strchr+0x25>
			return (char *) s;
  8011a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a7:	eb 15                	jmp    8011be <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b2:	0f b6 00             	movzbl (%rax),%eax
  8011b5:	84 c0                	test   %al,%al
  8011b7:	75 de                	jne    801197 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011be:	c9                   	leaveq 
  8011bf:	c3                   	retq   

00000000008011c0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	48 83 ec 0c          	sub    $0xc,%rsp
  8011c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011cc:	89 f0                	mov    %esi,%eax
  8011ce:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011d1:	eb 13                	jmp    8011e6 <strfind+0x26>
		if (*s == c)
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011dd:	75 02                	jne    8011e1 <strfind+0x21>
			break;
  8011df:	eb 10                	jmp    8011f1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ea:	0f b6 00             	movzbl (%rax),%eax
  8011ed:	84 c0                	test   %al,%al
  8011ef:	75 e2                	jne    8011d3 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8011f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f5:	c9                   	leaveq 
  8011f6:	c3                   	retq   

00000000008011f7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011f7:	55                   	push   %rbp
  8011f8:	48 89 e5             	mov    %rsp,%rbp
  8011fb:	48 83 ec 18          	sub    $0x18,%rsp
  8011ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801203:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801206:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80120a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80120f:	75 06                	jne    801217 <memset+0x20>
		return v;
  801211:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801215:	eb 69                	jmp    801280 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121b:	83 e0 03             	and    $0x3,%eax
  80121e:	48 85 c0             	test   %rax,%rax
  801221:	75 48                	jne    80126b <memset+0x74>
  801223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801227:	83 e0 03             	and    $0x3,%eax
  80122a:	48 85 c0             	test   %rax,%rax
  80122d:	75 3c                	jne    80126b <memset+0x74>
		c &= 0xFF;
  80122f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801236:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801239:	c1 e0 18             	shl    $0x18,%eax
  80123c:	89 c2                	mov    %eax,%edx
  80123e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801241:	c1 e0 10             	shl    $0x10,%eax
  801244:	09 c2                	or     %eax,%edx
  801246:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801249:	c1 e0 08             	shl    $0x8,%eax
  80124c:	09 d0                	or     %edx,%eax
  80124e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801255:	48 c1 e8 02          	shr    $0x2,%rax
  801259:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80125c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801260:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801263:	48 89 d7             	mov    %rdx,%rdi
  801266:	fc                   	cld    
  801267:	f3 ab                	rep stos %eax,%es:(%rdi)
  801269:	eb 11                	jmp    80127c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80126b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80126f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801272:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801276:	48 89 d7             	mov    %rdx,%rdi
  801279:	fc                   	cld    
  80127a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801280:	c9                   	leaveq 
  801281:	c3                   	retq   

0000000000801282 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801282:	55                   	push   %rbp
  801283:	48 89 e5             	mov    %rsp,%rbp
  801286:	48 83 ec 28          	sub    $0x28,%rsp
  80128a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801292:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801296:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012ae:	0f 83 88 00 00 00    	jae    80133c <memmove+0xba>
  8012b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012bc:	48 01 d0             	add    %rdx,%rax
  8012bf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012c3:	76 77                	jbe    80133c <memmove+0xba>
		s += n;
  8012c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	83 e0 03             	and    $0x3,%eax
  8012dc:	48 85 c0             	test   %rax,%rax
  8012df:	75 3b                	jne    80131c <memmove+0x9a>
  8012e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e5:	83 e0 03             	and    $0x3,%eax
  8012e8:	48 85 c0             	test   %rax,%rax
  8012eb:	75 2f                	jne    80131c <memmove+0x9a>
  8012ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f1:	83 e0 03             	and    $0x3,%eax
  8012f4:	48 85 c0             	test   %rax,%rax
  8012f7:	75 23                	jne    80131c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fd:	48 83 e8 04          	sub    $0x4,%rax
  801301:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801305:	48 83 ea 04          	sub    $0x4,%rdx
  801309:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80130d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801311:	48 89 c7             	mov    %rax,%rdi
  801314:	48 89 d6             	mov    %rdx,%rsi
  801317:	fd                   	std    
  801318:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80131a:	eb 1d                	jmp    801339 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80131c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801320:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801328:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80132c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801330:	48 89 d7             	mov    %rdx,%rdi
  801333:	48 89 c1             	mov    %rax,%rcx
  801336:	fd                   	std    
  801337:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801339:	fc                   	cld    
  80133a:	eb 57                	jmp    801393 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	83 e0 03             	and    $0x3,%eax
  801343:	48 85 c0             	test   %rax,%rax
  801346:	75 36                	jne    80137e <memmove+0xfc>
  801348:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134c:	83 e0 03             	and    $0x3,%eax
  80134f:	48 85 c0             	test   %rax,%rax
  801352:	75 2a                	jne    80137e <memmove+0xfc>
  801354:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801358:	83 e0 03             	and    $0x3,%eax
  80135b:	48 85 c0             	test   %rax,%rax
  80135e:	75 1e                	jne    80137e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801364:	48 c1 e8 02          	shr    $0x2,%rax
  801368:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80136b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801373:	48 89 c7             	mov    %rax,%rdi
  801376:	48 89 d6             	mov    %rdx,%rsi
  801379:	fc                   	cld    
  80137a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80137c:	eb 15                	jmp    801393 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80137e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801382:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801386:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80138a:	48 89 c7             	mov    %rax,%rdi
  80138d:	48 89 d6             	mov    %rdx,%rsi
  801390:	fc                   	cld    
  801391:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801393:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801397:	c9                   	leaveq 
  801398:	c3                   	retq   

0000000000801399 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801399:	55                   	push   %rbp
  80139a:	48 89 e5             	mov    %rsp,%rbp
  80139d:	48 83 ec 18          	sub    $0x18,%rsp
  8013a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013b1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b9:	48 89 ce             	mov    %rcx,%rsi
  8013bc:	48 89 c7             	mov    %rax,%rdi
  8013bf:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  8013c6:	00 00 00 
  8013c9:	ff d0                	callq  *%rax
}
  8013cb:	c9                   	leaveq 
  8013cc:	c3                   	retq   

00000000008013cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	48 83 ec 28          	sub    $0x28,%rsp
  8013d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013f1:	eb 36                	jmp    801429 <memcmp+0x5c>
		if (*s1 != *s2)
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	0f b6 10             	movzbl (%rax),%edx
  8013fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fe:	0f b6 00             	movzbl (%rax),%eax
  801401:	38 c2                	cmp    %al,%dl
  801403:	74 1a                	je     80141f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	0f b6 d0             	movzbl %al,%edx
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	0f b6 c0             	movzbl %al,%eax
  801419:	29 c2                	sub    %eax,%edx
  80141b:	89 d0                	mov    %edx,%eax
  80141d:	eb 20                	jmp    80143f <memcmp+0x72>
		s1++, s2++;
  80141f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801424:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801431:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801435:	48 85 c0             	test   %rax,%rax
  801438:	75 b9                	jne    8013f3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80143a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143f:	c9                   	leaveq 
  801440:	c3                   	retq   

0000000000801441 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801441:	55                   	push   %rbp
  801442:	48 89 e5             	mov    %rsp,%rbp
  801445:	48 83 ec 28          	sub    $0x28,%rsp
  801449:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80144d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801450:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80145c:	48 01 d0             	add    %rdx,%rax
  80145f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801463:	eb 15                	jmp    80147a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801469:	0f b6 10             	movzbl (%rax),%edx
  80146c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80146f:	38 c2                	cmp    %al,%dl
  801471:	75 02                	jne    801475 <memfind+0x34>
			break;
  801473:	eb 0f                	jmp    801484 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801475:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801482:	72 e1                	jb     801465 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801488:	c9                   	leaveq 
  801489:	c3                   	retq   

000000000080148a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80148a:	55                   	push   %rbp
  80148b:	48 89 e5             	mov    %rsp,%rbp
  80148e:	48 83 ec 34          	sub    $0x34,%rsp
  801492:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801496:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80149a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80149d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014a4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014ab:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ac:	eb 05                	jmp    8014b3 <strtol+0x29>
		s++;
  8014ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	0f b6 00             	movzbl (%rax),%eax
  8014ba:	3c 20                	cmp    $0x20,%al
  8014bc:	74 f0                	je     8014ae <strtol+0x24>
  8014be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	3c 09                	cmp    $0x9,%al
  8014c7:	74 e5                	je     8014ae <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	3c 2b                	cmp    $0x2b,%al
  8014d2:	75 07                	jne    8014db <strtol+0x51>
		s++;
  8014d4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d9:	eb 17                	jmp    8014f2 <strtol+0x68>
	else if (*s == '-')
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	3c 2d                	cmp    $0x2d,%al
  8014e4:	75 0c                	jne    8014f2 <strtol+0x68>
		s++, neg = 1;
  8014e6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014eb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014f6:	74 06                	je     8014fe <strtol+0x74>
  8014f8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014fc:	75 28                	jne    801526 <strtol+0x9c>
  8014fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	3c 30                	cmp    $0x30,%al
  801507:	75 1d                	jne    801526 <strtol+0x9c>
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	48 83 c0 01          	add    $0x1,%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	3c 78                	cmp    $0x78,%al
  801516:	75 0e                	jne    801526 <strtol+0x9c>
		s += 2, base = 16;
  801518:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80151d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801524:	eb 2c                	jmp    801552 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801526:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80152a:	75 19                	jne    801545 <strtol+0xbb>
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 30                	cmp    $0x30,%al
  801535:	75 0e                	jne    801545 <strtol+0xbb>
		s++, base = 8;
  801537:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80153c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801543:	eb 0d                	jmp    801552 <strtol+0xc8>
	else if (base == 0)
  801545:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801549:	75 07                	jne    801552 <strtol+0xc8>
		base = 10;
  80154b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3c 2f                	cmp    $0x2f,%al
  80155b:	7e 1d                	jle    80157a <strtol+0xf0>
  80155d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801561:	0f b6 00             	movzbl (%rax),%eax
  801564:	3c 39                	cmp    $0x39,%al
  801566:	7f 12                	jg     80157a <strtol+0xf0>
			dig = *s - '0';
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	0f b6 00             	movzbl (%rax),%eax
  80156f:	0f be c0             	movsbl %al,%eax
  801572:	83 e8 30             	sub    $0x30,%eax
  801575:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801578:	eb 4e                	jmp    8015c8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	0f b6 00             	movzbl (%rax),%eax
  801581:	3c 60                	cmp    $0x60,%al
  801583:	7e 1d                	jle    8015a2 <strtol+0x118>
  801585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	3c 7a                	cmp    $0x7a,%al
  80158e:	7f 12                	jg     8015a2 <strtol+0x118>
			dig = *s - 'a' + 10;
  801590:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	0f be c0             	movsbl %al,%eax
  80159a:	83 e8 57             	sub    $0x57,%eax
  80159d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015a0:	eb 26                	jmp    8015c8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	3c 40                	cmp    $0x40,%al
  8015ab:	7e 48                	jle    8015f5 <strtol+0x16b>
  8015ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	3c 5a                	cmp    $0x5a,%al
  8015b6:	7f 3d                	jg     8015f5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	0f b6 00             	movzbl (%rax),%eax
  8015bf:	0f be c0             	movsbl %al,%eax
  8015c2:	83 e8 37             	sub    $0x37,%eax
  8015c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015cb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ce:	7c 02                	jl     8015d2 <strtol+0x148>
			break;
  8015d0:	eb 23                	jmp    8015f5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015da:	48 98                	cltq   
  8015dc:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015e1:	48 89 c2             	mov    %rax,%rdx
  8015e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015e7:	48 98                	cltq   
  8015e9:	48 01 d0             	add    %rdx,%rax
  8015ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015f0:	e9 5d ff ff ff       	jmpq   801552 <strtol+0xc8>

	if (endptr)
  8015f5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015fa:	74 0b                	je     801607 <strtol+0x17d>
		*endptr = (char *) s;
  8015fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801600:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801604:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801607:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80160b:	74 09                	je     801616 <strtol+0x18c>
  80160d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801611:	48 f7 d8             	neg    %rax
  801614:	eb 04                	jmp    80161a <strtol+0x190>
  801616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80161a:	c9                   	leaveq 
  80161b:	c3                   	retq   

000000000080161c <strstr>:

char * strstr(const char *in, const char *str)
{
  80161c:	55                   	push   %rbp
  80161d:	48 89 e5             	mov    %rsp,%rbp
  801620:	48 83 ec 30          	sub    $0x30,%rsp
  801624:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801628:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80162c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801630:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801634:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80163e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801642:	75 06                	jne    80164a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	eb 6b                	jmp    8016b5 <strstr+0x99>

	len = strlen(str);
  80164a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80164e:	48 89 c7             	mov    %rax,%rdi
  801651:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  801658:	00 00 00 
  80165b:	ff d0                	callq  *%rax
  80165d:	48 98                	cltq   
  80165f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80166b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801675:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801679:	75 07                	jne    801682 <strstr+0x66>
				return (char *) 0;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	eb 33                	jmp    8016b5 <strstr+0x99>
		} while (sc != c);
  801682:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801686:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801689:	75 d8                	jne    801663 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80168b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80168f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801697:	48 89 ce             	mov    %rcx,%rsi
  80169a:	48 89 c7             	mov    %rax,%rdi
  80169d:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  8016a4:	00 00 00 
  8016a7:	ff d0                	callq  *%rax
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	75 b6                	jne    801663 <strstr+0x47>

	return (char *) (in - 1);
  8016ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b1:	48 83 e8 01          	sub    $0x1,%rax
}
  8016b5:	c9                   	leaveq 
  8016b6:	c3                   	retq   

00000000008016b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
  8016bb:	53                   	push   %rbx
  8016bc:	48 83 ec 48          	sub    $0x48,%rsp
  8016c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016c3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016c6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016ca:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ce:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016d2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016d9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016dd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016e1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016e5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016e9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016ed:	4c 89 c3             	mov    %r8,%rbx
  8016f0:	cd 30                	int    $0x30
  8016f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016fa:	74 3e                	je     80173a <syscall+0x83>
  8016fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801701:	7e 37                	jle    80173a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801703:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801707:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80170a:	49 89 d0             	mov    %rdx,%r8
  80170d:	89 c1                	mov    %eax,%ecx
  80170f:	48 ba 48 42 80 00 00 	movabs $0x804248,%rdx
  801716:	00 00 00 
  801719:	be 23 00 00 00       	mov    $0x23,%esi
  80171e:	48 bf 65 42 80 00 00 	movabs $0x804265,%rdi
  801725:	00 00 00 
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	49 b9 a8 39 80 00 00 	movabs $0x8039a8,%r9
  801734:	00 00 00 
  801737:	41 ff d1             	callq  *%r9

	return ret;
  80173a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173e:	48 83 c4 48          	add    $0x48,%rsp
  801742:	5b                   	pop    %rbx
  801743:	5d                   	pop    %rbp
  801744:	c3                   	retq   

0000000000801745 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 20          	sub    $0x20,%rsp
  80174d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801751:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801759:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80175d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801764:	00 
  801765:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801771:	48 89 d1             	mov    %rdx,%rcx
  801774:	48 89 c2             	mov    %rax,%rdx
  801777:	be 00 00 00 00       	mov    $0x0,%esi
  80177c:	bf 00 00 00 00       	mov    $0x0,%edi
  801781:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801788:	00 00 00 
  80178b:	ff d0                	callq  *%rax
}
  80178d:	c9                   	leaveq 
  80178e:	c3                   	retq   

000000000080178f <sys_cgetc>:

int
sys_cgetc(void)
{
  80178f:	55                   	push   %rbp
  801790:	48 89 e5             	mov    %rsp,%rbp
  801793:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801797:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80179e:	00 
  80179f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	be 00 00 00 00       	mov    $0x0,%esi
  8017ba:	bf 01 00 00 00       	mov    $0x1,%edi
  8017bf:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
}
  8017cb:	c9                   	leaveq 
  8017cc:	c3                   	retq   

00000000008017cd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	48 83 ec 10          	sub    $0x10,%rsp
  8017d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017db:	48 98                	cltq   
  8017dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e4:	00 
  8017e5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017eb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f6:	48 89 c2             	mov    %rax,%rdx
  8017f9:	be 01 00 00 00       	mov    $0x1,%esi
  8017fe:	bf 03 00 00 00       	mov    $0x3,%edi
  801803:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80180a:	00 00 00 
  80180d:	ff d0                	callq  *%rax
}
  80180f:	c9                   	leaveq 
  801810:	c3                   	retq   

0000000000801811 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801811:	55                   	push   %rbp
  801812:	48 89 e5             	mov    %rsp,%rbp
  801815:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801819:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801820:	00 
  801821:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801827:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	be 00 00 00 00       	mov    $0x0,%esi
  80183c:	bf 02 00 00 00       	mov    $0x2,%edi
  801841:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <sys_yield>:

void
sys_yield(void)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801857:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185e:	00 
  80185f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801865:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801870:	ba 00 00 00 00       	mov    $0x0,%edx
  801875:	be 00 00 00 00       	mov    $0x0,%esi
  80187a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80187f:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
}
  80188b:	c9                   	leaveq 
  80188c:	c3                   	retq   

000000000080188d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 20          	sub    $0x20,%rsp
  801895:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801898:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80189c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80189f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a2:	48 63 c8             	movslq %eax,%rcx
  8018a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ac:	48 98                	cltq   
  8018ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b5:	00 
  8018b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bc:	49 89 c8             	mov    %rcx,%r8
  8018bf:	48 89 d1             	mov    %rdx,%rcx
  8018c2:	48 89 c2             	mov    %rax,%rdx
  8018c5:	be 01 00 00 00       	mov    $0x1,%esi
  8018ca:	bf 04 00 00 00       	mov    $0x4,%edi
  8018cf:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8018d6:	00 00 00 
  8018d9:	ff d0                	callq  *%rax
}
  8018db:	c9                   	leaveq 
  8018dc:	c3                   	retq   

00000000008018dd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018dd:	55                   	push   %rbp
  8018de:	48 89 e5             	mov    %rsp,%rbp
  8018e1:	48 83 ec 30          	sub    $0x30,%rsp
  8018e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ec:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018ef:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018f3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018f7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018fa:	48 63 c8             	movslq %eax,%rcx
  8018fd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801901:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801904:	48 63 f0             	movslq %eax,%rsi
  801907:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190e:	48 98                	cltq   
  801910:	48 89 0c 24          	mov    %rcx,(%rsp)
  801914:	49 89 f9             	mov    %rdi,%r9
  801917:	49 89 f0             	mov    %rsi,%r8
  80191a:	48 89 d1             	mov    %rdx,%rcx
  80191d:	48 89 c2             	mov    %rax,%rdx
  801920:	be 01 00 00 00       	mov    $0x1,%esi
  801925:	bf 05 00 00 00       	mov    $0x5,%edi
  80192a:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801931:	00 00 00 
  801934:	ff d0                	callq  *%rax
}
  801936:	c9                   	leaveq 
  801937:	c3                   	retq   

0000000000801938 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801938:	55                   	push   %rbp
  801939:	48 89 e5             	mov    %rsp,%rbp
  80193c:	48 83 ec 20          	sub    $0x20,%rsp
  801940:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801943:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801947:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194e:	48 98                	cltq   
  801950:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801957:	00 
  801958:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801964:	48 89 d1             	mov    %rdx,%rcx
  801967:	48 89 c2             	mov    %rax,%rdx
  80196a:	be 01 00 00 00       	mov    $0x1,%esi
  80196f:	bf 06 00 00 00       	mov    $0x6,%edi
  801974:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80197b:	00 00 00 
  80197e:	ff d0                	callq  *%rax
}
  801980:	c9                   	leaveq 
  801981:	c3                   	retq   

0000000000801982 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801982:	55                   	push   %rbp
  801983:	48 89 e5             	mov    %rsp,%rbp
  801986:	48 83 ec 10          	sub    $0x10,%rsp
  80198a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80198d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801990:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801993:	48 63 d0             	movslq %eax,%rdx
  801996:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801999:	48 98                	cltq   
  80199b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a2:	00 
  8019a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019af:	48 89 d1             	mov    %rdx,%rcx
  8019b2:	48 89 c2             	mov    %rax,%rdx
  8019b5:	be 01 00 00 00       	mov    $0x1,%esi
  8019ba:	bf 08 00 00 00       	mov    $0x8,%edi
  8019bf:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	callq  *%rax
}
  8019cb:	c9                   	leaveq 
  8019cc:	c3                   	retq   

00000000008019cd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019cd:	55                   	push   %rbp
  8019ce:	48 89 e5             	mov    %rsp,%rbp
  8019d1:	48 83 ec 20          	sub    $0x20,%rsp
  8019d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e3:	48 98                	cltq   
  8019e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ec:	00 
  8019ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f9:	48 89 d1             	mov    %rdx,%rcx
  8019fc:	48 89 c2             	mov    %rax,%rdx
  8019ff:	be 01 00 00 00       	mov    $0x1,%esi
  801a04:	bf 09 00 00 00       	mov    $0x9,%edi
  801a09:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801a10:	00 00 00 
  801a13:	ff d0                	callq  *%rax
}
  801a15:	c9                   	leaveq 
  801a16:	c3                   	retq   

0000000000801a17 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a17:	55                   	push   %rbp
  801a18:	48 89 e5             	mov    %rsp,%rbp
  801a1b:	48 83 ec 20          	sub    $0x20,%rsp
  801a1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2d:	48 98                	cltq   
  801a2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a36:	00 
  801a37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a43:	48 89 d1             	mov    %rdx,%rcx
  801a46:	48 89 c2             	mov    %rax,%rdx
  801a49:	be 01 00 00 00       	mov    $0x1,%esi
  801a4e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a53:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
}
  801a5f:	c9                   	leaveq 
  801a60:	c3                   	retq   

0000000000801a61 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a61:	55                   	push   %rbp
  801a62:	48 89 e5             	mov    %rsp,%rbp
  801a65:	48 83 ec 20          	sub    $0x20,%rsp
  801a69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a70:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a74:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7a:	48 63 f0             	movslq %eax,%rsi
  801a7d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a84:	48 98                	cltq   
  801a86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a91:	00 
  801a92:	49 89 f1             	mov    %rsi,%r9
  801a95:	49 89 c8             	mov    %rcx,%r8
  801a98:	48 89 d1             	mov    %rdx,%rcx
  801a9b:	48 89 c2             	mov    %rax,%rdx
  801a9e:	be 00 00 00 00       	mov    $0x0,%esi
  801aa3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801aa8:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801aaf:	00 00 00 
  801ab2:	ff d0                	callq  *%rax
}
  801ab4:	c9                   	leaveq 
  801ab5:	c3                   	retq   

0000000000801ab6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ab6:	55                   	push   %rbp
  801ab7:	48 89 e5             	mov    %rsp,%rbp
  801aba:	48 83 ec 10          	sub    $0x10,%rsp
  801abe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acd:	00 
  801ace:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ada:	b9 00 00 00 00       	mov    $0x0,%ecx
  801adf:	48 89 c2             	mov    %rax,%rdx
  801ae2:	be 01 00 00 00       	mov    $0x1,%esi
  801ae7:	bf 0d 00 00 00       	mov    $0xd,%edi
  801aec:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 18          	sub    $0x18,%rsp
  801b02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b12:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b16:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b21:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b29:	8b 00                	mov    (%rax),%eax
  801b2b:	83 f8 01             	cmp    $0x1,%eax
  801b2e:	7e 13                	jle    801b43 <argstart+0x49>
  801b30:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801b35:	74 0c                	je     801b43 <argstart+0x49>
  801b37:	48 b8 73 42 80 00 00 	movabs $0x804273,%rax
  801b3e:	00 00 00 
  801b41:	eb 05                	jmp    801b48 <argstart+0x4e>
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b4c:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801b50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b54:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801b5b:	00 
}
  801b5c:	c9                   	leaveq 
  801b5d:	c3                   	retq   

0000000000801b5e <argnext>:

int
argnext(struct Argstate *args)
{
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
  801b62:	48 83 ec 20          	sub    $0x20,%rsp
  801b66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b6e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801b75:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801b76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b7a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b7e:	48 85 c0             	test   %rax,%rax
  801b81:	75 0a                	jne    801b8d <argnext+0x2f>
		return -1;
  801b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b88:	e9 25 01 00 00       	jmpq   801cb2 <argnext+0x154>

	if (!*args->curarg) {
  801b8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b91:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b95:	0f b6 00             	movzbl (%rax),%eax
  801b98:	84 c0                	test   %al,%al
  801b9a:	0f 85 d7 00 00 00    	jne    801c77 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba4:	48 8b 00             	mov    (%rax),%rax
  801ba7:	8b 00                	mov    (%rax),%eax
  801ba9:	83 f8 01             	cmp    $0x1,%eax
  801bac:	0f 84 ef 00 00 00    	je     801ca1 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb6:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bba:	48 83 c0 08          	add    $0x8,%rax
  801bbe:	48 8b 00             	mov    (%rax),%rax
  801bc1:	0f b6 00             	movzbl (%rax),%eax
  801bc4:	3c 2d                	cmp    $0x2d,%al
  801bc6:	0f 85 d5 00 00 00    	jne    801ca1 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bd4:	48 83 c0 08          	add    $0x8,%rax
  801bd8:	48 8b 00             	mov    (%rax),%rax
  801bdb:	48 83 c0 01          	add    $0x1,%rax
  801bdf:	0f b6 00             	movzbl (%rax),%eax
  801be2:	84 c0                	test   %al,%al
  801be4:	0f 84 b7 00 00 00    	je     801ca1 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801bea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bee:	48 8b 40 08          	mov    0x8(%rax),%rax
  801bf2:	48 83 c0 08          	add    $0x8,%rax
  801bf6:	48 8b 00             	mov    (%rax),%rax
  801bf9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c01:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c09:	48 8b 00             	mov    (%rax),%rax
  801c0c:	8b 00                	mov    (%rax),%eax
  801c0e:	83 e8 01             	sub    $0x1,%eax
  801c11:	48 98                	cltq   
  801c13:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801c1a:	00 
  801c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c1f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c23:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c2f:	48 83 c0 08          	add    $0x8,%rax
  801c33:	48 89 ce             	mov    %rcx,%rsi
  801c36:	48 89 c7             	mov    %rax,%rdi
  801c39:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	callq  *%rax
		(*args->argc)--;
  801c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c49:	48 8b 00             	mov    (%rax),%rax
  801c4c:	8b 10                	mov    (%rax),%edx
  801c4e:	83 ea 01             	sub    $0x1,%edx
  801c51:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c57:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c5b:	0f b6 00             	movzbl (%rax),%eax
  801c5e:	3c 2d                	cmp    $0x2d,%al
  801c60:	75 15                	jne    801c77 <argnext+0x119>
  801c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c66:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c6a:	48 83 c0 01          	add    $0x1,%rax
  801c6e:	0f b6 00             	movzbl (%rax),%eax
  801c71:	84 c0                	test   %al,%al
  801c73:	75 02                	jne    801c77 <argnext+0x119>
			goto endofargs;
  801c75:	eb 2a                	jmp    801ca1 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c7b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c7f:	0f b6 00             	movzbl (%rax),%eax
  801c82:	0f b6 c0             	movzbl %al,%eax
  801c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c90:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9f:	eb 11                	jmp    801cb2 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca5:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801cac:	00 
	return -1;
  801cad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801cb2:	c9                   	leaveq 
  801cb3:	c3                   	retq   

0000000000801cb4 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801cb4:	55                   	push   %rbp
  801cb5:	48 89 e5             	mov    %rsp,%rbp
  801cb8:	48 83 ec 10          	sub    $0x10,%rsp
  801cbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc4:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cc8:	48 85 c0             	test   %rax,%rax
  801ccb:	74 0a                	je     801cd7 <argvalue+0x23>
  801ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd1:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cd5:	eb 13                	jmp    801cea <argvalue+0x36>
  801cd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdb:	48 89 c7             	mov    %rax,%rdi
  801cde:	48 b8 ec 1c 80 00 00 	movabs $0x801cec,%rax
  801ce5:	00 00 00 
  801ce8:	ff d0                	callq  *%rax
}
  801cea:	c9                   	leaveq 
  801ceb:	c3                   	retq   

0000000000801cec <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801cec:	55                   	push   %rbp
  801ced:	48 89 e5             	mov    %rsp,%rbp
  801cf0:	53                   	push   %rbx
  801cf1:	48 83 ec 18          	sub    $0x18,%rsp
  801cf5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfd:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d01:	48 85 c0             	test   %rax,%rax
  801d04:	75 0a                	jne    801d10 <argnextvalue+0x24>
		return 0;
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0b:	e9 c8 00 00 00       	jmpq   801dd8 <argnextvalue+0xec>
	if (*args->curarg) {
  801d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d14:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d18:	0f b6 00             	movzbl (%rax),%eax
  801d1b:	84 c0                	test   %al,%al
  801d1d:	74 27                	je     801d46 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801d1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d23:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2b:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d33:	48 bb 73 42 80 00 00 	movabs $0x804273,%rbx
  801d3a:	00 00 00 
  801d3d:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801d41:	e9 8a 00 00 00       	jmpq   801dd0 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801d46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4a:	48 8b 00             	mov    (%rax),%rax
  801d4d:	8b 00                	mov    (%rax),%eax
  801d4f:	83 f8 01             	cmp    $0x1,%eax
  801d52:	7e 64                	jle    801db8 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d58:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801d60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d64:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6c:	48 8b 00             	mov    (%rax),%rax
  801d6f:	8b 00                	mov    (%rax),%eax
  801d71:	83 e8 01             	sub    $0x1,%eax
  801d74:	48 98                	cltq   
  801d76:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801d7d:	00 
  801d7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d82:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d86:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801d8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d92:	48 83 c0 08          	add    $0x8,%rax
  801d96:	48 89 ce             	mov    %rcx,%rsi
  801d99:	48 89 c7             	mov    %rax,%rdi
  801d9c:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
		(*args->argc)--;
  801da8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dac:	48 8b 00             	mov    (%rax),%rax
  801daf:	8b 10                	mov    (%rax),%edx
  801db1:	83 ea 01             	sub    $0x1,%edx
  801db4:	89 10                	mov    %edx,(%rax)
  801db6:	eb 18                	jmp    801dd0 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801db8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbc:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801dc3:	00 
		args->curarg = 0;
  801dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc8:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801dcf:	00 
	}
	return (char*) args->argvalue;
  801dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd4:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801dd8:	48 83 c4 18          	add    $0x18,%rsp
  801ddc:	5b                   	pop    %rbx
  801ddd:	5d                   	pop    %rbp
  801dde:	c3                   	retq   

0000000000801ddf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 08          	sub    $0x8,%rsp
  801de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801deb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801def:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801df6:	ff ff ff 
  801df9:	48 01 d0             	add    %rdx,%rax
  801dfc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e00:	c9                   	leaveq 
  801e01:	c3                   	retq   

0000000000801e02 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e02:	55                   	push   %rbp
  801e03:	48 89 e5             	mov    %rsp,%rbp
  801e06:	48 83 ec 08          	sub    $0x8,%rsp
  801e0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e12:	48 89 c7             	mov    %rax,%rdi
  801e15:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  801e1c:	00 00 00 
  801e1f:	ff d0                	callq  *%rax
  801e21:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e27:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 18          	sub    $0x18,%rsp
  801e35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e40:	eb 6b                	jmp    801ead <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e45:	48 98                	cltq   
  801e47:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e4d:	48 c1 e0 0c          	shl    $0xc,%rax
  801e51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e59:	48 c1 e8 15          	shr    $0x15,%rax
  801e5d:	48 89 c2             	mov    %rax,%rdx
  801e60:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e67:	01 00 00 
  801e6a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6e:	83 e0 01             	and    $0x1,%eax
  801e71:	48 85 c0             	test   %rax,%rax
  801e74:	74 21                	je     801e97 <fd_alloc+0x6a>
  801e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7a:	48 c1 e8 0c          	shr    $0xc,%rax
  801e7e:	48 89 c2             	mov    %rax,%rdx
  801e81:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e88:	01 00 00 
  801e8b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8f:	83 e0 01             	and    $0x1,%eax
  801e92:	48 85 c0             	test   %rax,%rax
  801e95:	75 12                	jne    801ea9 <fd_alloc+0x7c>
			*fd_store = fd;
  801e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	eb 1a                	jmp    801ec3 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ea9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ead:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eb1:	7e 8f                	jle    801e42 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ebe:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 83 ec 20          	sub    $0x20,%rsp
  801ecd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ed4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ed8:	78 06                	js     801ee0 <fd_lookup+0x1b>
  801eda:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ede:	7e 07                	jle    801ee7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ee0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ee5:	eb 6c                	jmp    801f53 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ee7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eea:	48 98                	cltq   
  801eec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ef2:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efe:	48 c1 e8 15          	shr    $0x15,%rax
  801f02:	48 89 c2             	mov    %rax,%rdx
  801f05:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f0c:	01 00 00 
  801f0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f13:	83 e0 01             	and    $0x1,%eax
  801f16:	48 85 c0             	test   %rax,%rax
  801f19:	74 21                	je     801f3c <fd_lookup+0x77>
  801f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1f:	48 c1 e8 0c          	shr    $0xc,%rax
  801f23:	48 89 c2             	mov    %rax,%rdx
  801f26:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f2d:	01 00 00 
  801f30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f34:	83 e0 01             	and    $0x1,%eax
  801f37:	48 85 c0             	test   %rax,%rax
  801f3a:	75 07                	jne    801f43 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f41:	eb 10                	jmp    801f53 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f47:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f4b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f53:	c9                   	leaveq 
  801f54:	c3                   	retq   

0000000000801f55 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f55:	55                   	push   %rbp
  801f56:	48 89 e5             	mov    %rsp,%rbp
  801f59:	48 83 ec 30          	sub    $0x30,%rsp
  801f5d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f61:	89 f0                	mov    %esi,%eax
  801f63:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6a:	48 89 c7             	mov    %rax,%rdi
  801f6d:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  801f74:	00 00 00 
  801f77:	ff d0                	callq  *%rax
  801f79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f7d:	48 89 d6             	mov    %rdx,%rsi
  801f80:	89 c7                	mov    %eax,%edi
  801f82:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	callq  *%rax
  801f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f95:	78 0a                	js     801fa1 <fd_close+0x4c>
	    || fd != fd2)
  801f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f9f:	74 12                	je     801fb3 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fa1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fa5:	74 05                	je     801fac <fd_close+0x57>
  801fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801faa:	eb 05                	jmp    801fb1 <fd_close+0x5c>
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	eb 69                	jmp    80201c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb7:	8b 00                	mov    (%rax),%eax
  801fb9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fbd:	48 89 d6             	mov    %rdx,%rsi
  801fc0:	89 c7                	mov    %eax,%edi
  801fc2:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  801fc9:	00 00 00 
  801fcc:	ff d0                	callq  *%rax
  801fce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd5:	78 2a                	js     802001 <fd_close+0xac>
		if (dev->dev_close)
  801fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fdf:	48 85 c0             	test   %rax,%rax
  801fe2:	74 16                	je     801ffa <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fe4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ff0:	48 89 d7             	mov    %rdx,%rdi
  801ff3:	ff d0                	callq  *%rax
  801ff5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff8:	eb 07                	jmp    802001 <fd_close+0xac>
		else
			r = 0;
  801ffa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802001:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802005:	48 89 c6             	mov    %rax,%rsi
  802008:	bf 00 00 00 00       	mov    $0x0,%edi
  80200d:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  802014:	00 00 00 
  802017:	ff d0                	callq  *%rax
	return r;
  802019:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80201c:	c9                   	leaveq 
  80201d:	c3                   	retq   

000000000080201e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
  802022:	48 83 ec 20          	sub    $0x20,%rsp
  802026:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802029:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80202d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802034:	eb 41                	jmp    802077 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802036:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80203d:	00 00 00 
  802040:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802043:	48 63 d2             	movslq %edx,%rdx
  802046:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204a:	8b 00                	mov    (%rax),%eax
  80204c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80204f:	75 22                	jne    802073 <dev_lookup+0x55>
			*dev = devtab[i];
  802051:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802058:	00 00 00 
  80205b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80205e:	48 63 d2             	movslq %edx,%rdx
  802061:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802065:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802069:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	eb 60                	jmp    8020d3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802073:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802077:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80207e:	00 00 00 
  802081:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802084:	48 63 d2             	movslq %edx,%rdx
  802087:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208b:	48 85 c0             	test   %rax,%rax
  80208e:	75 a6                	jne    802036 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802090:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802097:	00 00 00 
  80209a:	48 8b 00             	mov    (%rax),%rax
  80209d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020a3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020a6:	89 c6                	mov    %eax,%esi
  8020a8:	48 bf 78 42 80 00 00 	movabs $0x804278,%rdi
  8020af:	00 00 00 
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b7:	48 b9 96 03 80 00 00 	movabs $0x800396,%rcx
  8020be:	00 00 00 
  8020c1:	ff d1                	callq  *%rcx
	*dev = 0;
  8020c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020c7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020d3:	c9                   	leaveq 
  8020d4:	c3                   	retq   

00000000008020d5 <close>:

int
close(int fdnum)
{
  8020d5:	55                   	push   %rbp
  8020d6:	48 89 e5             	mov    %rsp,%rbp
  8020d9:	48 83 ec 20          	sub    $0x20,%rsp
  8020dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020e7:	48 89 d6             	mov    %rdx,%rsi
  8020ea:	89 c7                	mov    %eax,%edi
  8020ec:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	callq  *%rax
  8020f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ff:	79 05                	jns    802106 <close+0x31>
		return r;
  802101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802104:	eb 18                	jmp    80211e <close+0x49>
	else
		return fd_close(fd, 1);
  802106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210a:	be 01 00 00 00       	mov    $0x1,%esi
  80210f:	48 89 c7             	mov    %rax,%rdi
  802112:	48 b8 55 1f 80 00 00 	movabs $0x801f55,%rax
  802119:	00 00 00 
  80211c:	ff d0                	callq  *%rax
}
  80211e:	c9                   	leaveq 
  80211f:	c3                   	retq   

0000000000802120 <close_all>:

void
close_all(void)
{
  802120:	55                   	push   %rbp
  802121:	48 89 e5             	mov    %rsp,%rbp
  802124:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802128:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212f:	eb 15                	jmp    802146 <close_all+0x26>
		close(i);
  802131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802134:	89 c7                	mov    %eax,%edi
  802136:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802142:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802146:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80214a:	7e e5                	jle    802131 <close_all+0x11>
		close(i);
}
  80214c:	c9                   	leaveq 
  80214d:	c3                   	retq   

000000000080214e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80214e:	55                   	push   %rbp
  80214f:	48 89 e5             	mov    %rsp,%rbp
  802152:	48 83 ec 40          	sub    $0x40,%rsp
  802156:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802159:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80215c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802160:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802163:	48 89 d6             	mov    %rdx,%rsi
  802166:	89 c7                	mov    %eax,%edi
  802168:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  80216f:	00 00 00 
  802172:	ff d0                	callq  *%rax
  802174:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802177:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217b:	79 08                	jns    802185 <dup+0x37>
		return r;
  80217d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802180:	e9 70 01 00 00       	jmpq   8022f5 <dup+0x1a7>
	close(newfdnum);
  802185:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802188:	89 c7                	mov    %eax,%edi
  80218a:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802196:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802199:	48 98                	cltq   
  80219b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021a1:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ad:	48 89 c7             	mov    %rax,%rdi
  8021b0:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
  8021bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c4:	48 89 c7             	mov    %rax,%rdi
  8021c7:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	callq  *%rax
  8021d3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021db:	48 c1 e8 15          	shr    $0x15,%rax
  8021df:	48 89 c2             	mov    %rax,%rdx
  8021e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021e9:	01 00 00 
  8021ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f0:	83 e0 01             	and    $0x1,%eax
  8021f3:	48 85 c0             	test   %rax,%rax
  8021f6:	74 73                	je     80226b <dup+0x11d>
  8021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802200:	48 89 c2             	mov    %rax,%rdx
  802203:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80220a:	01 00 00 
  80220d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802211:	83 e0 01             	and    $0x1,%eax
  802214:	48 85 c0             	test   %rax,%rax
  802217:	74 52                	je     80226b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221d:	48 c1 e8 0c          	shr    $0xc,%rax
  802221:	48 89 c2             	mov    %rax,%rdx
  802224:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222b:	01 00 00 
  80222e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802232:	25 07 0e 00 00       	and    $0xe07,%eax
  802237:	89 c1                	mov    %eax,%ecx
  802239:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80223d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802241:	41 89 c8             	mov    %ecx,%r8d
  802244:	48 89 d1             	mov    %rdx,%rcx
  802247:	ba 00 00 00 00       	mov    $0x0,%edx
  80224c:	48 89 c6             	mov    %rax,%rsi
  80224f:	bf 00 00 00 00       	mov    $0x0,%edi
  802254:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	callq  *%rax
  802260:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802267:	79 02                	jns    80226b <dup+0x11d>
			goto err;
  802269:	eb 57                	jmp    8022c2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80226b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226f:	48 c1 e8 0c          	shr    $0xc,%rax
  802273:	48 89 c2             	mov    %rax,%rdx
  802276:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227d:	01 00 00 
  802280:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802284:	25 07 0e 00 00       	and    $0xe07,%eax
  802289:	89 c1                	mov    %eax,%ecx
  80228b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802293:	41 89 c8             	mov    %ecx,%r8d
  802296:	48 89 d1             	mov    %rdx,%rcx
  802299:	ba 00 00 00 00       	mov    $0x0,%edx
  80229e:	48 89 c6             	mov    %rax,%rsi
  8022a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a6:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  8022ad:	00 00 00 
  8022b0:	ff d0                	callq  *%rax
  8022b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b9:	79 02                	jns    8022bd <dup+0x16f>
		goto err;
  8022bb:	eb 05                	jmp    8022c2 <dup+0x174>

	return newfdnum;
  8022bd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022c0:	eb 33                	jmp    8022f5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c6:	48 89 c6             	mov    %rax,%rsi
  8022c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ce:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  8022d5:	00 00 00 
  8022d8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022de:	48 89 c6             	mov    %rax,%rsi
  8022e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e6:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
	return r;
  8022f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f5:	c9                   	leaveq 
  8022f6:	c3                   	retq   

00000000008022f7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022f7:	55                   	push   %rbp
  8022f8:	48 89 e5             	mov    %rsp,%rbp
  8022fb:	48 83 ec 40          	sub    $0x40,%rsp
  8022ff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802302:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802306:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80230a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80230e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802311:	48 89 d6             	mov    %rdx,%rsi
  802314:	89 c7                	mov    %eax,%edi
  802316:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  80231d:	00 00 00 
  802320:	ff d0                	callq  *%rax
  802322:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802325:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802329:	78 24                	js     80234f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80232b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232f:	8b 00                	mov    (%rax),%eax
  802331:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802335:	48 89 d6             	mov    %rdx,%rsi
  802338:	89 c7                	mov    %eax,%edi
  80233a:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax
  802346:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802349:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234d:	79 05                	jns    802354 <read+0x5d>
		return r;
  80234f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802352:	eb 76                	jmp    8023ca <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802358:	8b 40 08             	mov    0x8(%rax),%eax
  80235b:	83 e0 03             	and    $0x3,%eax
  80235e:	83 f8 01             	cmp    $0x1,%eax
  802361:	75 3a                	jne    80239d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802363:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80236a:	00 00 00 
  80236d:	48 8b 00             	mov    (%rax),%rax
  802370:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802376:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802379:	89 c6                	mov    %eax,%esi
  80237b:	48 bf 97 42 80 00 00 	movabs $0x804297,%rdi
  802382:	00 00 00 
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
  80238a:	48 b9 96 03 80 00 00 	movabs $0x800396,%rcx
  802391:	00 00 00 
  802394:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802396:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80239b:	eb 2d                	jmp    8023ca <read+0xd3>
	}
	if (!dev->dev_read)
  80239d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a5:	48 85 c0             	test   %rax,%rax
  8023a8:	75 07                	jne    8023b1 <read+0xba>
		return -E_NOT_SUPP;
  8023aa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023af:	eb 19                	jmp    8023ca <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023b9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023bd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023c1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023c5:	48 89 cf             	mov    %rcx,%rdi
  8023c8:	ff d0                	callq  *%rax
}
  8023ca:	c9                   	leaveq 
  8023cb:	c3                   	retq   

00000000008023cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023cc:	55                   	push   %rbp
  8023cd:	48 89 e5             	mov    %rsp,%rbp
  8023d0:	48 83 ec 30          	sub    $0x30,%rsp
  8023d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e6:	eb 49                	jmp    802431 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023eb:	48 98                	cltq   
  8023ed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023f1:	48 29 c2             	sub    %rax,%rdx
  8023f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f7:	48 63 c8             	movslq %eax,%rcx
  8023fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023fe:	48 01 c1             	add    %rax,%rcx
  802401:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802404:	48 89 ce             	mov    %rcx,%rsi
  802407:	89 c7                	mov    %eax,%edi
  802409:	48 b8 f7 22 80 00 00 	movabs $0x8022f7,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802418:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80241c:	79 05                	jns    802423 <readn+0x57>
			return m;
  80241e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802421:	eb 1c                	jmp    80243f <readn+0x73>
		if (m == 0)
  802423:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802427:	75 02                	jne    80242b <readn+0x5f>
			break;
  802429:	eb 11                	jmp    80243c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80242b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802434:	48 98                	cltq   
  802436:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80243a:	72 ac                	jb     8023e8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80243c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80243f:	c9                   	leaveq 
  802440:	c3                   	retq   

0000000000802441 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802441:	55                   	push   %rbp
  802442:	48 89 e5             	mov    %rsp,%rbp
  802445:	48 83 ec 40          	sub    $0x40,%rsp
  802449:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80244c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802450:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802454:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802458:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80245b:	48 89 d6             	mov    %rdx,%rsi
  80245e:	89 c7                	mov    %eax,%edi
  802460:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
  80246c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802473:	78 24                	js     802499 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802479:	8b 00                	mov    (%rax),%eax
  80247b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80247f:	48 89 d6             	mov    %rdx,%rsi
  802482:	89 c7                	mov    %eax,%edi
  802484:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	callq  *%rax
  802490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802497:	79 05                	jns    80249e <write+0x5d>
		return r;
  802499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249c:	eb 75                	jmp    802513 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80249e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a2:	8b 40 08             	mov    0x8(%rax),%eax
  8024a5:	83 e0 03             	and    $0x3,%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	75 3a                	jne    8024e6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024ac:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024b3:	00 00 00 
  8024b6:	48 8b 00             	mov    (%rax),%rax
  8024b9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024bf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024c2:	89 c6                	mov    %eax,%esi
  8024c4:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  8024cb:	00 00 00 
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	48 b9 96 03 80 00 00 	movabs $0x800396,%rcx
  8024da:	00 00 00 
  8024dd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e4:	eb 2d                	jmp    802513 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ea:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ee:	48 85 c0             	test   %rax,%rax
  8024f1:	75 07                	jne    8024fa <write+0xb9>
		return -E_NOT_SUPP;
  8024f3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024f8:	eb 19                	jmp    802513 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802502:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802506:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80250a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80250e:	48 89 cf             	mov    %rcx,%rdi
  802511:	ff d0                	callq  *%rax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <seek>:

int
seek(int fdnum, off_t offset)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 18          	sub    $0x18,%rsp
  80251d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802520:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802523:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802527:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80252a:	48 89 d6             	mov    %rdx,%rsi
  80252d:	89 c7                	mov    %eax,%edi
  80252f:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802536:	00 00 00 
  802539:	ff d0                	callq  *%rax
  80253b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802542:	79 05                	jns    802549 <seek+0x34>
		return r;
  802544:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802547:	eb 0f                	jmp    802558 <seek+0x43>
	fd->fd_offset = offset;
  802549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802550:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802558:	c9                   	leaveq 
  802559:	c3                   	retq   

000000000080255a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80255a:	55                   	push   %rbp
  80255b:	48 89 e5             	mov    %rsp,%rbp
  80255e:	48 83 ec 30          	sub    $0x30,%rsp
  802562:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802565:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802568:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80256c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80256f:	48 89 d6             	mov    %rdx,%rsi
  802572:	89 c7                	mov    %eax,%edi
  802574:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  80257b:	00 00 00 
  80257e:	ff d0                	callq  *%rax
  802580:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802583:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802587:	78 24                	js     8025ad <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258d:	8b 00                	mov    (%rax),%eax
  80258f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802593:	48 89 d6             	mov    %rdx,%rsi
  802596:	89 c7                	mov    %eax,%edi
  802598:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ab:	79 05                	jns    8025b2 <ftruncate+0x58>
		return r;
  8025ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b0:	eb 72                	jmp    802624 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b6:	8b 40 08             	mov    0x8(%rax),%eax
  8025b9:	83 e0 03             	and    $0x3,%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	75 3a                	jne    8025fa <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025c0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025c7:	00 00 00 
  8025ca:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025d6:	89 c6                	mov    %eax,%esi
  8025d8:	48 bf d0 42 80 00 00 	movabs $0x8042d0,%rdi
  8025df:	00 00 00 
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e7:	48 b9 96 03 80 00 00 	movabs $0x800396,%rcx
  8025ee:	00 00 00 
  8025f1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f8:	eb 2a                	jmp    802624 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802602:	48 85 c0             	test   %rax,%rax
  802605:	75 07                	jne    80260e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802607:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80260c:	eb 16                	jmp    802624 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80260e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802612:	48 8b 40 30          	mov    0x30(%rax),%rax
  802616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80261a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80261d:	89 ce                	mov    %ecx,%esi
  80261f:	48 89 d7             	mov    %rdx,%rdi
  802622:	ff d0                	callq  *%rax
}
  802624:	c9                   	leaveq 
  802625:	c3                   	retq   

0000000000802626 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802626:	55                   	push   %rbp
  802627:	48 89 e5             	mov    %rsp,%rbp
  80262a:	48 83 ec 30          	sub    $0x30,%rsp
  80262e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802631:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802635:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802639:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80263c:	48 89 d6             	mov    %rdx,%rsi
  80263f:	89 c7                	mov    %eax,%edi
  802641:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802648:	00 00 00 
  80264b:	ff d0                	callq  *%rax
  80264d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802650:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802654:	78 24                	js     80267a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265a:	8b 00                	mov    (%rax),%eax
  80265c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802660:	48 89 d6             	mov    %rdx,%rsi
  802663:	89 c7                	mov    %eax,%edi
  802665:	48 b8 1e 20 80 00 00 	movabs $0x80201e,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	callq  *%rax
  802671:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802674:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802678:	79 05                	jns    80267f <fstat+0x59>
		return r;
  80267a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267d:	eb 5e                	jmp    8026dd <fstat+0xb7>
	if (!dev->dev_stat)
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 8b 40 28          	mov    0x28(%rax),%rax
  802687:	48 85 c0             	test   %rax,%rax
  80268a:	75 07                	jne    802693 <fstat+0x6d>
		return -E_NOT_SUPP;
  80268c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802691:	eb 4a                	jmp    8026dd <fstat+0xb7>
	stat->st_name[0] = 0;
  802693:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802697:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80269a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026a5:	00 00 00 
	stat->st_isdir = 0;
  8026a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ac:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026b3:	00 00 00 
	stat->st_dev = dev;
  8026b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026be:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026d1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026d5:	48 89 ce             	mov    %rcx,%rsi
  8026d8:	48 89 d7             	mov    %rdx,%rdi
  8026db:	ff d0                	callq  *%rax
}
  8026dd:	c9                   	leaveq 
  8026de:	c3                   	retq   

00000000008026df <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026df:	55                   	push   %rbp
  8026e0:	48 89 e5             	mov    %rsp,%rbp
  8026e3:	48 83 ec 20          	sub    $0x20,%rsp
  8026e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f3:	be 00 00 00 00       	mov    $0x0,%esi
  8026f8:	48 89 c7             	mov    %rax,%rdi
  8026fb:	48 b8 cd 27 80 00 00 	movabs $0x8027cd,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
  802707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270e:	79 05                	jns    802715 <stat+0x36>
		return fd;
  802710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802713:	eb 2f                	jmp    802744 <stat+0x65>
	r = fstat(fd, stat);
  802715:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271c:	48 89 d6             	mov    %rdx,%rsi
  80271f:	89 c7                	mov    %eax,%edi
  802721:	48 b8 26 26 80 00 00 	movabs $0x802626,%rax
  802728:	00 00 00 
  80272b:	ff d0                	callq  *%rax
  80272d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802733:	89 c7                	mov    %eax,%edi
  802735:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
	return r;
  802741:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802744:	c9                   	leaveq 
  802745:	c3                   	retq   

0000000000802746 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802746:	55                   	push   %rbp
  802747:	48 89 e5             	mov    %rsp,%rbp
  80274a:	48 83 ec 10          	sub    $0x10,%rsp
  80274e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802751:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802755:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80275c:	00 00 00 
  80275f:	8b 00                	mov    (%rax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	75 1d                	jne    802782 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802765:	bf 01 00 00 00       	mov    $0x1,%edi
  80276a:	48 b8 15 3c 80 00 00 	movabs $0x803c15,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80277d:	00 00 00 
  802780:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802782:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802789:	00 00 00 
  80278c:	8b 00                	mov    (%rax),%eax
  80278e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802791:	b9 07 00 00 00       	mov    $0x7,%ecx
  802796:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80279d:	00 00 00 
  8027a0:	89 c7                	mov    %eax,%edi
  8027a2:	48 b8 7d 3b 80 00 00 	movabs $0x803b7d,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b7:	48 89 c6             	mov    %rax,%rsi
  8027ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8027bf:	48 b8 bc 3a 80 00 00 	movabs $0x803abc,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax
}
  8027cb:	c9                   	leaveq 
  8027cc:	c3                   	retq   

00000000008027cd <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027cd:	55                   	push   %rbp
  8027ce:	48 89 e5             	mov    %rsp,%rbp
  8027d1:	48 83 ec 20          	sub    $0x20,%rsp
  8027d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e0:	48 89 c7             	mov    %rax,%rdi
  8027e3:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax
  8027ef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027f4:	7e 0a                	jle    802800 <open+0x33>
		return -E_BAD_PATH;
  8027f6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027fb:	e9 a5 00 00 00       	jmpq   8028a5 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802800:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802804:	48 89 c7             	mov    %rax,%rdi
  802807:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
  802813:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802816:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281a:	79 08                	jns    802824 <open+0x57>
		return r;
  80281c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281f:	e9 81 00 00 00       	jmpq   8028a5 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802828:	48 89 c6             	mov    %rax,%rsi
  80282b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802832:	00 00 00 
  802835:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  80283c:	00 00 00 
  80283f:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802841:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802848:	00 00 00 
  80284b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80284e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802854:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802858:	48 89 c6             	mov    %rax,%rsi
  80285b:	bf 01 00 00 00       	mov    $0x1,%edi
  802860:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802867:	00 00 00 
  80286a:	ff d0                	callq  *%rax
  80286c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802873:	79 1d                	jns    802892 <open+0xc5>
		fd_close(fd, 0);
  802875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802879:	be 00 00 00 00       	mov    $0x0,%esi
  80287e:	48 89 c7             	mov    %rax,%rdi
  802881:	48 b8 55 1f 80 00 00 	movabs $0x801f55,%rax
  802888:	00 00 00 
  80288b:	ff d0                	callq  *%rax
		return r;
  80288d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802890:	eb 13                	jmp    8028a5 <open+0xd8>
	}

	return fd2num(fd);
  802892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802896:	48 89 c7             	mov    %rax,%rdi
  802899:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  8028a0:	00 00 00 
  8028a3:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8028a5:	c9                   	leaveq 
  8028a6:	c3                   	retq   

00000000008028a7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028a7:	55                   	push   %rbp
  8028a8:	48 89 e5             	mov    %rsp,%rbp
  8028ab:	48 83 ec 10          	sub    $0x10,%rsp
  8028af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028c1:	00 00 00 
  8028c4:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028c6:	be 00 00 00 00       	mov    $0x0,%esi
  8028cb:	bf 06 00 00 00       	mov    $0x6,%edi
  8028d0:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
}
  8028dc:	c9                   	leaveq 
  8028dd:	c3                   	retq   

00000000008028de <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028de:	55                   	push   %rbp
  8028df:	48 89 e5             	mov    %rsp,%rbp
  8028e2:	48 83 ec 30          	sub    $0x30,%rsp
  8028e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f6:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802900:	00 00 00 
  802903:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802905:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290c:	00 00 00 
  80290f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802913:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802917:	be 00 00 00 00       	mov    $0x0,%esi
  80291c:	bf 03 00 00 00       	mov    $0x3,%edi
  802921:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802928:	00 00 00 
  80292b:	ff d0                	callq  *%rax
  80292d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802930:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802934:	79 08                	jns    80293e <devfile_read+0x60>
		return r;
  802936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802939:	e9 a4 00 00 00       	jmpq   8029e2 <devfile_read+0x104>
	assert(r <= n);
  80293e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802941:	48 98                	cltq   
  802943:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802947:	76 35                	jbe    80297e <devfile_read+0xa0>
  802949:	48 b9 fd 42 80 00 00 	movabs $0x8042fd,%rcx
  802950:	00 00 00 
  802953:	48 ba 04 43 80 00 00 	movabs $0x804304,%rdx
  80295a:	00 00 00 
  80295d:	be 84 00 00 00       	mov    $0x84,%esi
  802962:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  802969:	00 00 00 
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
  802971:	49 b8 a8 39 80 00 00 	movabs $0x8039a8,%r8
  802978:	00 00 00 
  80297b:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80297e:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802985:	7e 35                	jle    8029bc <devfile_read+0xde>
  802987:	48 b9 24 43 80 00 00 	movabs $0x804324,%rcx
  80298e:	00 00 00 
  802991:	48 ba 04 43 80 00 00 	movabs $0x804304,%rdx
  802998:	00 00 00 
  80299b:	be 85 00 00 00       	mov    $0x85,%esi
  8029a0:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  8029a7:	00 00 00 
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	49 b8 a8 39 80 00 00 	movabs $0x8039a8,%r8
  8029b6:	00 00 00 
  8029b9:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8029bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bf:	48 63 d0             	movslq %eax,%rdx
  8029c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029cd:	00 00 00 
  8029d0:	48 89 c7             	mov    %rax,%rdi
  8029d3:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	callq  *%rax
	return r;
  8029df:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  8029e2:	c9                   	leaveq 
  8029e3:	c3                   	retq   

00000000008029e4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	48 83 ec 30          	sub    $0x30,%rsp
  8029ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a06:	00 00 00 
  802a09:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a0b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a12:	00 00 00 
  802a15:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a19:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802a1d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a24:	00 
  802a25:	76 35                	jbe    802a5c <devfile_write+0x78>
  802a27:	48 b9 30 43 80 00 00 	movabs $0x804330,%rcx
  802a2e:	00 00 00 
  802a31:	48 ba 04 43 80 00 00 	movabs $0x804304,%rdx
  802a38:	00 00 00 
  802a3b:	be 9e 00 00 00       	mov    $0x9e,%esi
  802a40:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  802a47:	00 00 00 
  802a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4f:	49 b8 a8 39 80 00 00 	movabs $0x8039a8,%r8
  802a56:	00 00 00 
  802a59:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802a5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a64:	48 89 c6             	mov    %rax,%rsi
  802a67:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a6e:	00 00 00 
  802a71:	48 b8 99 13 80 00 00 	movabs $0x801399,%rax
  802a78:	00 00 00 
  802a7b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a7d:	be 00 00 00 00       	mov    $0x0,%esi
  802a82:	bf 04 00 00 00       	mov    $0x4,%edi
  802a87:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802a8e:	00 00 00 
  802a91:	ff d0                	callq  *%rax
  802a93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9a:	79 05                	jns    802aa1 <devfile_write+0xbd>
		return r;
  802a9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9f:	eb 43                	jmp    802ae4 <devfile_write+0x100>
	assert(r <= n);
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa4:	48 98                	cltq   
  802aa6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802aaa:	76 35                	jbe    802ae1 <devfile_write+0xfd>
  802aac:	48 b9 fd 42 80 00 00 	movabs $0x8042fd,%rcx
  802ab3:	00 00 00 
  802ab6:	48 ba 04 43 80 00 00 	movabs $0x804304,%rdx
  802abd:	00 00 00 
  802ac0:	be a2 00 00 00       	mov    $0xa2,%esi
  802ac5:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  802acc:	00 00 00 
  802acf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad4:	49 b8 a8 39 80 00 00 	movabs $0x8039a8,%r8
  802adb:	00 00 00 
  802ade:	41 ff d0             	callq  *%r8
	return r;
  802ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802ae4:	c9                   	leaveq 
  802ae5:	c3                   	retq   

0000000000802ae6 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	48 83 ec 20          	sub    $0x20,%rsp
  802aee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afa:	8b 50 0c             	mov    0xc(%rax),%edx
  802afd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b04:	00 00 00 
  802b07:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b09:	be 00 00 00 00       	mov    $0x0,%esi
  802b0e:	bf 05 00 00 00       	mov    $0x5,%edi
  802b13:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
  802b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b26:	79 05                	jns    802b2d <devfile_stat+0x47>
		return r;
  802b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2b:	eb 56                	jmp    802b83 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b31:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b38:	00 00 00 
  802b3b:	48 89 c7             	mov    %rax,%rdi
  802b3e:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  802b45:	00 00 00 
  802b48:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b51:	00 00 00 
  802b54:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b5e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b64:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b6b:	00 00 00 
  802b6e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b78:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b83:	c9                   	leaveq 
  802b84:	c3                   	retq   

0000000000802b85 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b85:	55                   	push   %rbp
  802b86:	48 89 e5             	mov    %rsp,%rbp
  802b89:	48 83 ec 10          	sub    $0x10,%rsp
  802b8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b91:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b98:	8b 50 0c             	mov    0xc(%rax),%edx
  802b9b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba2:	00 00 00 
  802ba5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ba7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bae:	00 00 00 
  802bb1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bb4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bb7:	be 00 00 00 00       	mov    $0x0,%esi
  802bbc:	bf 02 00 00 00       	mov    $0x2,%edi
  802bc1:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	callq  *%rax
}
  802bcd:	c9                   	leaveq 
  802bce:	c3                   	retq   

0000000000802bcf <remove>:

// Delete a file
int
remove(const char *path)
{
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
  802bd3:	48 83 ec 10          	sub    $0x10,%rsp
  802bd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bdf:	48 89 c7             	mov    %rax,%rdi
  802be2:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
  802bee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bf3:	7e 07                	jle    802bfc <remove+0x2d>
		return -E_BAD_PATH;
  802bf5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bfa:	eb 33                	jmp    802c2f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c00:	48 89 c6             	mov    %rax,%rsi
  802c03:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c0a:	00 00 00 
  802c0d:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  802c14:	00 00 00 
  802c17:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c19:	be 00 00 00 00       	mov    $0x0,%esi
  802c1e:	bf 07 00 00 00       	mov    $0x7,%edi
  802c23:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	callq  *%rax
}
  802c2f:	c9                   	leaveq 
  802c30:	c3                   	retq   

0000000000802c31 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c31:	55                   	push   %rbp
  802c32:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c35:	be 00 00 00 00       	mov    $0x0,%esi
  802c3a:	bf 08 00 00 00       	mov    $0x8,%edi
  802c3f:	48 b8 46 27 80 00 00 	movabs $0x802746,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
}
  802c4b:	5d                   	pop    %rbp
  802c4c:	c3                   	retq   

0000000000802c4d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c4d:	55                   	push   %rbp
  802c4e:	48 89 e5             	mov    %rsp,%rbp
  802c51:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c58:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c5f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c66:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c6d:	be 00 00 00 00       	mov    $0x0,%esi
  802c72:	48 89 c7             	mov    %rax,%rdi
  802c75:	48 b8 cd 27 80 00 00 	movabs $0x8027cd,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	callq  *%rax
  802c81:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c88:	79 28                	jns    802cb2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8d:	89 c6                	mov    %eax,%esi
  802c8f:	48 bf 5d 43 80 00 00 	movabs $0x80435d,%rdi
  802c96:	00 00 00 
  802c99:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9e:	48 ba 96 03 80 00 00 	movabs $0x800396,%rdx
  802ca5:	00 00 00 
  802ca8:	ff d2                	callq  *%rdx
		return fd_src;
  802caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cad:	e9 74 01 00 00       	jmpq   802e26 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cb2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cb9:	be 01 01 00 00       	mov    $0x101,%esi
  802cbe:	48 89 c7             	mov    %rax,%rdi
  802cc1:	48 b8 cd 27 80 00 00 	movabs $0x8027cd,%rax
  802cc8:	00 00 00 
  802ccb:	ff d0                	callq  *%rax
  802ccd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802cd0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cd4:	79 39                	jns    802d0f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802cd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd9:	89 c6                	mov    %eax,%esi
  802cdb:	48 bf 73 43 80 00 00 	movabs $0x804373,%rdi
  802ce2:	00 00 00 
  802ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cea:	48 ba 96 03 80 00 00 	movabs $0x800396,%rdx
  802cf1:	00 00 00 
  802cf4:	ff d2                	callq  *%rdx
		close(fd_src);
  802cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
		return fd_dest;
  802d07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0a:	e9 17 01 00 00       	jmpq   802e26 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d0f:	eb 74                	jmp    802d85 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d11:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d14:	48 63 d0             	movslq %eax,%rdx
  802d17:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d21:	48 89 ce             	mov    %rcx,%rsi
  802d24:	89 c7                	mov    %eax,%edi
  802d26:	48 b8 41 24 80 00 00 	movabs $0x802441,%rax
  802d2d:	00 00 00 
  802d30:	ff d0                	callq  *%rax
  802d32:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d35:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d39:	79 4a                	jns    802d85 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d3b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d3e:	89 c6                	mov    %eax,%esi
  802d40:	48 bf 8d 43 80 00 00 	movabs $0x80438d,%rdi
  802d47:	00 00 00 
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4f:	48 ba 96 03 80 00 00 	movabs $0x800396,%rdx
  802d56:	00 00 00 
  802d59:	ff d2                	callq  *%rdx
			close(fd_src);
  802d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5e:	89 c7                	mov    %eax,%edi
  802d60:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802d67:	00 00 00 
  802d6a:	ff d0                	callq  *%rax
			close(fd_dest);
  802d6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d6f:	89 c7                	mov    %eax,%edi
  802d71:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802d78:	00 00 00 
  802d7b:	ff d0                	callq  *%rax
			return write_size;
  802d7d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d80:	e9 a1 00 00 00       	jmpq   802e26 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d85:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8f:	ba 00 02 00 00       	mov    $0x200,%edx
  802d94:	48 89 ce             	mov    %rcx,%rsi
  802d97:	89 c7                	mov    %eax,%edi
  802d99:	48 b8 f7 22 80 00 00 	movabs $0x8022f7,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax
  802da5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802dac:	0f 8f 5f ff ff ff    	jg     802d11 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802db6:	79 47                	jns    802dff <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802db8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dbb:	89 c6                	mov    %eax,%esi
  802dbd:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  802dc4:	00 00 00 
  802dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcc:	48 ba 96 03 80 00 00 	movabs $0x800396,%rdx
  802dd3:	00 00 00 
  802dd6:	ff d2                	callq  *%rdx
		close(fd_src);
  802dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
		close(fd_dest);
  802de9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dec:	89 c7                	mov    %eax,%edi
  802dee:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
		return read_size;
  802dfa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dfd:	eb 27                	jmp    802e26 <copy+0x1d9>
	}
	close(fd_src);
  802dff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e02:	89 c7                	mov    %eax,%edi
  802e04:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
	close(fd_dest);
  802e10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e13:	89 c7                	mov    %eax,%edi
  802e15:	48 b8 d5 20 80 00 00 	movabs $0x8020d5,%rax
  802e1c:	00 00 00 
  802e1f:	ff d0                	callq  *%rax
	return 0;
  802e21:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802e26:	c9                   	leaveq 
  802e27:	c3                   	retq   

0000000000802e28 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802e28:	55                   	push   %rbp
  802e29:	48 89 e5             	mov    %rsp,%rbp
  802e2c:	48 83 ec 20          	sub    $0x20,%rsp
  802e30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e38:	8b 40 0c             	mov    0xc(%rax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	7e 67                	jle    802ea6 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802e3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e43:	8b 40 04             	mov    0x4(%rax),%eax
  802e46:	48 63 d0             	movslq %eax,%rdx
  802e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e55:	8b 00                	mov    (%rax),%eax
  802e57:	48 89 ce             	mov    %rcx,%rsi
  802e5a:	89 c7                	mov    %eax,%edi
  802e5c:	48 b8 41 24 80 00 00 	movabs $0x802441,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6f:	7e 13                	jle    802e84 <writebuf+0x5c>
			b->result += result;
  802e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e75:	8b 50 08             	mov    0x8(%rax),%edx
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	01 c2                	add    %eax,%edx
  802e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e81:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e88:	8b 40 04             	mov    0x4(%rax),%eax
  802e8b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e8e:	74 16                	je     802ea6 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
  802e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e99:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802e9d:	89 c2                	mov    %eax,%edx
  802e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea3:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ea6:	c9                   	leaveq 
  802ea7:	c3                   	retq   

0000000000802ea8 <putch>:

static void
putch(int ch, void *thunk)
{
  802ea8:	55                   	push   %rbp
  802ea9:	48 89 e5             	mov    %rsp,%rbp
  802eac:	48 83 ec 20          	sub    $0x20,%rsp
  802eb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802eb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802ebf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec3:	8b 40 04             	mov    0x4(%rax),%eax
  802ec6:	8d 48 01             	lea    0x1(%rax),%ecx
  802ec9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ecd:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802ed0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ed3:	89 d1                	mov    %edx,%ecx
  802ed5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed9:	48 98                	cltq   
  802edb:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802edf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee3:	8b 40 04             	mov    0x4(%rax),%eax
  802ee6:	3d 00 01 00 00       	cmp    $0x100,%eax
  802eeb:	75 1e                	jne    802f0b <putch+0x63>
		writebuf(b);
  802eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef1:	48 89 c7             	mov    %rax,%rdi
  802ef4:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
		b->idx = 0;
  802f00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802f0b:	c9                   	leaveq 
  802f0c:	c3                   	retq   

0000000000802f0d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802f0d:	55                   	push   %rbp
  802f0e:	48 89 e5             	mov    %rsp,%rbp
  802f11:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802f18:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802f1e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802f25:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802f2c:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802f32:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802f38:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802f3f:	00 00 00 
	b.result = 0;
  802f42:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802f49:	00 00 00 
	b.error = 1;
  802f4c:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802f53:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802f56:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802f5d:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802f64:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f6b:	48 89 c6             	mov    %rax,%rsi
  802f6e:	48 bf a8 2e 80 00 00 	movabs $0x802ea8,%rdi
  802f75:	00 00 00 
  802f78:	48 b8 49 07 80 00 00 	movabs $0x800749,%rax
  802f7f:	00 00 00 
  802f82:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802f84:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	7e 16                	jle    802fa4 <vfprintf+0x97>
		writebuf(&b);
  802f8e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802f95:	48 89 c7             	mov    %rax,%rdi
  802f98:	48 b8 28 2e 80 00 00 	movabs $0x802e28,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802fa4:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 08                	je     802fb6 <vfprintf+0xa9>
  802fae:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802fb4:	eb 06                	jmp    802fbc <vfprintf+0xaf>
  802fb6:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802fbc:	c9                   	leaveq 
  802fbd:	c3                   	retq   

0000000000802fbe <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802fbe:	55                   	push   %rbp
  802fbf:	48 89 e5             	mov    %rsp,%rbp
  802fc2:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802fc9:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802fcf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fd6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fdd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fe4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802feb:	84 c0                	test   %al,%al
  802fed:	74 20                	je     80300f <fprintf+0x51>
  802fef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ff3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ff7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ffb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803003:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803007:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80300b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80300f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803016:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80301d:	00 00 00 
  803020:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803027:	00 00 00 
  80302a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80302e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803035:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80303c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803043:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80304a:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803051:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803057:	48 89 ce             	mov    %rcx,%rsi
  80305a:	89 c7                	mov    %eax,%edi
  80305c:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
  803068:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80306e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803074:	c9                   	leaveq 
  803075:	c3                   	retq   

0000000000803076 <printf>:

int
printf(const char *fmt, ...)
{
  803076:	55                   	push   %rbp
  803077:	48 89 e5             	mov    %rsp,%rbp
  80307a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803081:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803088:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80308f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803096:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80309d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8030a4:	84 c0                	test   %al,%al
  8030a6:	74 20                	je     8030c8 <printf+0x52>
  8030a8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030ac:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030b0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030b4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030b8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030bc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030c0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030c4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030c8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8030cf:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030d6:	00 00 00 
  8030d9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030e0:	00 00 00 
  8030e3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030e7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030ee:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030f5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8030fc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803103:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80310a:	48 89 c6             	mov    %rax,%rsi
  80310d:	bf 01 00 00 00       	mov    $0x1,%edi
  803112:	48 b8 0d 2f 80 00 00 	movabs $0x802f0d,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
  80311e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803124:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80312a:	c9                   	leaveq 
  80312b:	c3                   	retq   

000000000080312c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80312c:	55                   	push   %rbp
  80312d:	48 89 e5             	mov    %rsp,%rbp
  803130:	53                   	push   %rbx
  803131:	48 83 ec 38          	sub    $0x38,%rsp
  803135:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803139:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80313d:	48 89 c7             	mov    %rax,%rdi
  803140:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  803147:	00 00 00 
  80314a:	ff d0                	callq  *%rax
  80314c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80314f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803153:	0f 88 bf 01 00 00    	js     803318 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80315d:	ba 07 04 00 00       	mov    $0x407,%edx
  803162:	48 89 c6             	mov    %rax,%rsi
  803165:	bf 00 00 00 00       	mov    $0x0,%edi
  80316a:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
  803176:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803179:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80317d:	0f 88 95 01 00 00    	js     803318 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803183:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803187:	48 89 c7             	mov    %rax,%rdi
  80318a:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
  803196:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803199:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80319d:	0f 88 5d 01 00 00    	js     803300 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031a7:	ba 07 04 00 00       	mov    $0x407,%edx
  8031ac:	48 89 c6             	mov    %rax,%rsi
  8031af:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b4:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
  8031c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031c7:	0f 88 33 01 00 00    	js     803300 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8031cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d1:	48 89 c7             	mov    %rax,%rdi
  8031d4:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax
  8031e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e8:	ba 07 04 00 00       	mov    $0x407,%edx
  8031ed:	48 89 c6             	mov    %rax,%rsi
  8031f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f5:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	callq  *%rax
  803201:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803204:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803208:	79 05                	jns    80320f <pipe+0xe3>
		goto err2;
  80320a:	e9 d9 00 00 00       	jmpq   8032e8 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80320f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803213:	48 89 c7             	mov    %rax,%rdi
  803216:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  80321d:	00 00 00 
  803220:	ff d0                	callq  *%rax
  803222:	48 89 c2             	mov    %rax,%rdx
  803225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803229:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80322f:	48 89 d1             	mov    %rdx,%rcx
  803232:	ba 00 00 00 00       	mov    $0x0,%edx
  803237:	48 89 c6             	mov    %rax,%rsi
  80323a:	bf 00 00 00 00       	mov    $0x0,%edi
  80323f:	48 b8 dd 18 80 00 00 	movabs $0x8018dd,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
  80324b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80324e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803252:	79 1b                	jns    80326f <pipe+0x143>
		goto err3;
  803254:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803255:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803259:	48 89 c6             	mov    %rax,%rsi
  80325c:	bf 00 00 00 00       	mov    $0x0,%edi
  803261:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
  80326d:	eb 79                	jmp    8032e8 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80326f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803273:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80327a:	00 00 00 
  80327d:	8b 12                	mov    (%rdx),%edx
  80327f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803285:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80328c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803290:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803297:	00 00 00 
  80329a:	8b 12                	mov    (%rdx),%edx
  80329c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80329e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ad:	48 89 c7             	mov    %rax,%rdi
  8032b0:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
  8032bc:	89 c2                	mov    %eax,%edx
  8032be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032c2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8032c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032c8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8032cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d0:	48 89 c7             	mov    %rax,%rdi
  8032d3:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  8032da:	00 00 00 
  8032dd:	ff d0                	callq  *%rax
  8032df:	89 03                	mov    %eax,(%rbx)
	return 0;
  8032e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e6:	eb 33                	jmp    80331b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8032e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ec:	48 89 c6             	mov    %rax,%rsi
  8032ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f4:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803300:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803304:	48 89 c6             	mov    %rax,%rsi
  803307:	bf 00 00 00 00       	mov    $0x0,%edi
  80330c:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
err:
	return r;
  803318:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80331b:	48 83 c4 38          	add    $0x38,%rsp
  80331f:	5b                   	pop    %rbx
  803320:	5d                   	pop    %rbp
  803321:	c3                   	retq   

0000000000803322 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803322:	55                   	push   %rbp
  803323:	48 89 e5             	mov    %rsp,%rbp
  803326:	53                   	push   %rbx
  803327:	48 83 ec 28          	sub    $0x28,%rsp
  80332b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80332f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803333:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80333a:	00 00 00 
  80333d:	48 8b 00             	mov    (%rax),%rax
  803340:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803346:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803349:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334d:	48 89 c7             	mov    %rax,%rdi
  803350:	48 b8 97 3c 80 00 00 	movabs $0x803c97,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 c3                	mov    %eax,%ebx
  80335e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803362:	48 89 c7             	mov    %rax,%rdi
  803365:	48 b8 97 3c 80 00 00 	movabs $0x803c97,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	39 c3                	cmp    %eax,%ebx
  803373:	0f 94 c0             	sete   %al
  803376:	0f b6 c0             	movzbl %al,%eax
  803379:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80337c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803383:	00 00 00 
  803386:	48 8b 00             	mov    (%rax),%rax
  803389:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80338f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803392:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803395:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803398:	75 05                	jne    80339f <_pipeisclosed+0x7d>
			return ret;
  80339a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80339d:	eb 4f                	jmp    8033ee <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80339f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033a2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033a5:	74 42                	je     8033e9 <_pipeisclosed+0xc7>
  8033a7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8033ab:	75 3c                	jne    8033e9 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033b4:	00 00 00 
  8033b7:	48 8b 00             	mov    (%rax),%rax
  8033ba:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8033c0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033c6:	89 c6                	mov    %eax,%esi
  8033c8:	48 bf bb 43 80 00 00 	movabs $0x8043bb,%rdi
  8033cf:	00 00 00 
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	49 b8 96 03 80 00 00 	movabs $0x800396,%r8
  8033de:	00 00 00 
  8033e1:	41 ff d0             	callq  *%r8
	}
  8033e4:	e9 4a ff ff ff       	jmpq   803333 <_pipeisclosed+0x11>
  8033e9:	e9 45 ff ff ff       	jmpq   803333 <_pipeisclosed+0x11>
}
  8033ee:	48 83 c4 28          	add    $0x28,%rsp
  8033f2:	5b                   	pop    %rbx
  8033f3:	5d                   	pop    %rbp
  8033f4:	c3                   	retq   

00000000008033f5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033f5:	55                   	push   %rbp
  8033f6:	48 89 e5             	mov    %rsp,%rbp
  8033f9:	48 83 ec 30          	sub    $0x30,%rsp
  8033fd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803400:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803404:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803407:	48 89 d6             	mov    %rdx,%rsi
  80340a:	89 c7                	mov    %eax,%edi
  80340c:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  803413:	00 00 00 
  803416:	ff d0                	callq  *%rax
  803418:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80341b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80341f:	79 05                	jns    803426 <pipeisclosed+0x31>
		return r;
  803421:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803424:	eb 31                	jmp    803457 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342a:	48 89 c7             	mov    %rax,%rdi
  80342d:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
  803439:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80343d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803441:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803445:	48 89 d6             	mov    %rdx,%rsi
  803448:	48 89 c7             	mov    %rax,%rdi
  80344b:	48 b8 22 33 80 00 00 	movabs $0x803322,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
}
  803457:	c9                   	leaveq 
  803458:	c3                   	retq   

0000000000803459 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803459:	55                   	push   %rbp
  80345a:	48 89 e5             	mov    %rsp,%rbp
  80345d:	48 83 ec 40          	sub    $0x40,%rsp
  803461:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803465:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803469:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80346d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803471:	48 89 c7             	mov    %rax,%rdi
  803474:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	callq  *%rax
  803480:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803484:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803488:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80348c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803493:	00 
  803494:	e9 92 00 00 00       	jmpq   80352b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803499:	eb 41                	jmp    8034dc <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80349b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034a0:	74 09                	je     8034ab <devpipe_read+0x52>
				return i;
  8034a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a6:	e9 92 00 00 00       	jmpq   80353d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b3:	48 89 d6             	mov    %rdx,%rsi
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 22 33 80 00 00 	movabs $0x803322,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 07                	je     8034d0 <devpipe_read+0x77>
				return 0;
  8034c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ce:	eb 6d                	jmp    80353d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8034d0:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8034d7:	00 00 00 
  8034da:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e0:	8b 10                	mov    (%rax),%edx
  8034e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e6:	8b 40 04             	mov    0x4(%rax),%eax
  8034e9:	39 c2                	cmp    %eax,%edx
  8034eb:	74 ae                	je     80349b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034f5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034fd:	8b 00                	mov    (%rax),%eax
  8034ff:	99                   	cltd   
  803500:	c1 ea 1b             	shr    $0x1b,%edx
  803503:	01 d0                	add    %edx,%eax
  803505:	83 e0 1f             	and    $0x1f,%eax
  803508:	29 d0                	sub    %edx,%eax
  80350a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80350e:	48 98                	cltq   
  803510:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803515:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351b:	8b 00                	mov    (%rax),%eax
  80351d:	8d 50 01             	lea    0x1(%rax),%edx
  803520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803524:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803526:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80352b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803533:	0f 82 60 ff ff ff    	jb     803499 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80353d:	c9                   	leaveq 
  80353e:	c3                   	retq   

000000000080353f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80353f:	55                   	push   %rbp
  803540:	48 89 e5             	mov    %rsp,%rbp
  803543:	48 83 ec 40          	sub    $0x40,%rsp
  803547:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80354b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80354f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803557:	48 89 c7             	mov    %rax,%rdi
  80355a:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80356a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80356e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803572:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803579:	00 
  80357a:	e9 8e 00 00 00       	jmpq   80360d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80357f:	eb 31                	jmp    8035b2 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803581:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803589:	48 89 d6             	mov    %rdx,%rsi
  80358c:	48 89 c7             	mov    %rax,%rdi
  80358f:	48 b8 22 33 80 00 00 	movabs $0x803322,%rax
  803596:	00 00 00 
  803599:	ff d0                	callq  *%rax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	74 07                	je     8035a6 <devpipe_write+0x67>
				return 0;
  80359f:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a4:	eb 79                	jmp    80361f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8035a6:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8035ad:	00 00 00 
  8035b0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b6:	8b 40 04             	mov    0x4(%rax),%eax
  8035b9:	48 63 d0             	movslq %eax,%rdx
  8035bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c0:	8b 00                	mov    (%rax),%eax
  8035c2:	48 98                	cltq   
  8035c4:	48 83 c0 20          	add    $0x20,%rax
  8035c8:	48 39 c2             	cmp    %rax,%rdx
  8035cb:	73 b4                	jae    803581 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8035cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d1:	8b 40 04             	mov    0x4(%rax),%eax
  8035d4:	99                   	cltd   
  8035d5:	c1 ea 1b             	shr    $0x1b,%edx
  8035d8:	01 d0                	add    %edx,%eax
  8035da:	83 e0 1f             	and    $0x1f,%eax
  8035dd:	29 d0                	sub    %edx,%eax
  8035df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035e7:	48 01 ca             	add    %rcx,%rdx
  8035ea:	0f b6 0a             	movzbl (%rdx),%ecx
  8035ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035f1:	48 98                	cltq   
  8035f3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fb:	8b 40 04             	mov    0x4(%rax),%eax
  8035fe:	8d 50 01             	lea    0x1(%rax),%edx
  803601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803605:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803608:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80360d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803611:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803615:	0f 82 64 ff ff ff    	jb     80357f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80361b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80361f:	c9                   	leaveq 
  803620:	c3                   	retq   

0000000000803621 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803621:	55                   	push   %rbp
  803622:	48 89 e5             	mov    %rsp,%rbp
  803625:	48 83 ec 20          	sub    $0x20,%rsp
  803629:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80362d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803635:	48 89 c7             	mov    %rax,%rdi
  803638:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
  803644:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803648:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80364c:	48 be ce 43 80 00 00 	movabs $0x8043ce,%rsi
  803653:	00 00 00 
  803656:	48 89 c7             	mov    %rax,%rdi
  803659:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  803660:	00 00 00 
  803663:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803669:	8b 50 04             	mov    0x4(%rax),%edx
  80366c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803670:	8b 00                	mov    (%rax),%eax
  803672:	29 c2                	sub    %eax,%edx
  803674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803678:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80367e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803682:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803689:	00 00 00 
	stat->st_dev = &devpipe;
  80368c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803690:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803697:	00 00 00 
  80369a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8036a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 10          	sub    $0x10,%rsp
  8036b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8036b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b8:	48 89 c6             	mov    %rax,%rsi
  8036bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c0:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  8036c7:	00 00 00 
  8036ca:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8036cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d0:	48 89 c7             	mov    %rax,%rdi
  8036d3:	48 b8 02 1e 80 00 00 	movabs $0x801e02,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	48 89 c6             	mov    %rax,%rsi
  8036e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e7:	48 b8 38 19 80 00 00 	movabs $0x801938,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
}
  8036f3:	c9                   	leaveq 
  8036f4:	c3                   	retq   

00000000008036f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036f5:	55                   	push   %rbp
  8036f6:	48 89 e5             	mov    %rsp,%rbp
  8036f9:	48 83 ec 20          	sub    $0x20,%rsp
  8036fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803700:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803703:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803706:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80370a:	be 01 00 00 00       	mov    $0x1,%esi
  80370f:	48 89 c7             	mov    %rax,%rdi
  803712:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  803719:	00 00 00 
  80371c:	ff d0                	callq  *%rax
}
  80371e:	c9                   	leaveq 
  80371f:	c3                   	retq   

0000000000803720 <getchar>:

int
getchar(void)
{
  803720:	55                   	push   %rbp
  803721:	48 89 e5             	mov    %rsp,%rbp
  803724:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803728:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80372c:	ba 01 00 00 00       	mov    $0x1,%edx
  803731:	48 89 c6             	mov    %rax,%rsi
  803734:	bf 00 00 00 00       	mov    $0x0,%edi
  803739:	48 b8 f7 22 80 00 00 	movabs $0x8022f7,%rax
  803740:	00 00 00 
  803743:	ff d0                	callq  *%rax
  803745:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803748:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374c:	79 05                	jns    803753 <getchar+0x33>
		return r;
  80374e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803751:	eb 14                	jmp    803767 <getchar+0x47>
	if (r < 1)
  803753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803757:	7f 07                	jg     803760 <getchar+0x40>
		return -E_EOF;
  803759:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80375e:	eb 07                	jmp    803767 <getchar+0x47>
	return c;
  803760:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803764:	0f b6 c0             	movzbl %al,%eax
}
  803767:	c9                   	leaveq 
  803768:	c3                   	retq   

0000000000803769 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803769:	55                   	push   %rbp
  80376a:	48 89 e5             	mov    %rsp,%rbp
  80376d:	48 83 ec 20          	sub    $0x20,%rsp
  803771:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803774:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803778:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377b:	48 89 d6             	mov    %rdx,%rsi
  80377e:	89 c7                	mov    %eax,%edi
  803780:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  803787:	00 00 00 
  80378a:	ff d0                	callq  *%rax
  80378c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803793:	79 05                	jns    80379a <iscons+0x31>
		return r;
  803795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803798:	eb 1a                	jmp    8037b4 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80379a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379e:	8b 10                	mov    (%rax),%edx
  8037a0:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8037a7:	00 00 00 
  8037aa:	8b 00                	mov    (%rax),%eax
  8037ac:	39 c2                	cmp    %eax,%edx
  8037ae:	0f 94 c0             	sete   %al
  8037b1:	0f b6 c0             	movzbl %al,%eax
}
  8037b4:	c9                   	leaveq 
  8037b5:	c3                   	retq   

00000000008037b6 <opencons>:

int
opencons(void)
{
  8037b6:	55                   	push   %rbp
  8037b7:	48 89 e5             	mov    %rsp,%rbp
  8037ba:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8037be:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037c2:	48 89 c7             	mov    %rax,%rdi
  8037c5:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  8037cc:	00 00 00 
  8037cf:	ff d0                	callq  *%rax
  8037d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d8:	79 05                	jns    8037df <opencons+0x29>
		return r;
  8037da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037dd:	eb 5b                	jmp    80383a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8037e8:	48 89 c6             	mov    %rax,%rsi
  8037eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f0:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  8037f7:	00 00 00 
  8037fa:	ff d0                	callq  *%rax
  8037fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803803:	79 05                	jns    80380a <opencons+0x54>
		return r;
  803805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803808:	eb 30                	jmp    80383a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80380a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803815:	00 00 00 
  803818:	8b 12                	mov    (%rdx),%edx
  80381a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80381c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803820:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803827:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80382b:	48 89 c7             	mov    %rax,%rdi
  80382e:	48 b8 df 1d 80 00 00 	movabs $0x801ddf,%rax
  803835:	00 00 00 
  803838:	ff d0                	callq  *%rax
}
  80383a:	c9                   	leaveq 
  80383b:	c3                   	retq   

000000000080383c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80383c:	55                   	push   %rbp
  80383d:	48 89 e5             	mov    %rsp,%rbp
  803840:	48 83 ec 30          	sub    $0x30,%rsp
  803844:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803848:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80384c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803850:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803855:	75 07                	jne    80385e <devcons_read+0x22>
		return 0;
  803857:	b8 00 00 00 00       	mov    $0x0,%eax
  80385c:	eb 4b                	jmp    8038a9 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80385e:	eb 0c                	jmp    80386c <devcons_read+0x30>
		sys_yield();
  803860:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80386c:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  803873:	00 00 00 
  803876:	ff d0                	callq  *%rax
  803878:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387f:	74 df                	je     803860 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803885:	79 05                	jns    80388c <devcons_read+0x50>
		return c;
  803887:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388a:	eb 1d                	jmp    8038a9 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80388c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803890:	75 07                	jne    803899 <devcons_read+0x5d>
		return 0;
  803892:	b8 00 00 00 00       	mov    $0x0,%eax
  803897:	eb 10                	jmp    8038a9 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389c:	89 c2                	mov    %eax,%edx
  80389e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a2:	88 10                	mov    %dl,(%rax)
	return 1;
  8038a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038a9:	c9                   	leaveq 
  8038aa:	c3                   	retq   

00000000008038ab <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038ab:	55                   	push   %rbp
  8038ac:	48 89 e5             	mov    %rsp,%rbp
  8038af:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8038b6:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8038bd:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8038c4:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038d2:	eb 76                	jmp    80394a <devcons_write+0x9f>
		m = n - tot;
  8038d4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8038db:	89 c2                	mov    %eax,%edx
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e0:	29 c2                	sub    %eax,%edx
  8038e2:	89 d0                	mov    %edx,%eax
  8038e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8038e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ea:	83 f8 7f             	cmp    $0x7f,%eax
  8038ed:	76 07                	jbe    8038f6 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8038ef:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038f9:	48 63 d0             	movslq %eax,%rdx
  8038fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ff:	48 63 c8             	movslq %eax,%rcx
  803902:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803909:	48 01 c1             	add    %rax,%rcx
  80390c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803913:	48 89 ce             	mov    %rcx,%rsi
  803916:	48 89 c7             	mov    %rax,%rdi
  803919:	48 b8 82 12 80 00 00 	movabs $0x801282,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803925:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803928:	48 63 d0             	movslq %eax,%rdx
  80392b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803932:	48 89 d6             	mov    %rdx,%rsi
  803935:	48 89 c7             	mov    %rax,%rdi
  803938:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  80393f:	00 00 00 
  803942:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803944:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803947:	01 45 fc             	add    %eax,-0x4(%rbp)
  80394a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394d:	48 98                	cltq   
  80394f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803956:	0f 82 78 ff ff ff    	jb     8038d4 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80395f:	c9                   	leaveq 
  803960:	c3                   	retq   

0000000000803961 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803961:	55                   	push   %rbp
  803962:	48 89 e5             	mov    %rsp,%rbp
  803965:	48 83 ec 08          	sub    $0x8,%rsp
  803969:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80396d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803972:	c9                   	leaveq 
  803973:	c3                   	retq   

0000000000803974 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803974:	55                   	push   %rbp
  803975:	48 89 e5             	mov    %rsp,%rbp
  803978:	48 83 ec 10          	sub    $0x10,%rsp
  80397c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803980:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803988:	48 be da 43 80 00 00 	movabs $0x8043da,%rsi
  80398f:	00 00 00 
  803992:	48 89 c7             	mov    %rax,%rdi
  803995:	48 b8 5e 0f 80 00 00 	movabs $0x800f5e,%rax
  80399c:	00 00 00 
  80399f:	ff d0                	callq  *%rax
	return 0;
  8039a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039a6:	c9                   	leaveq 
  8039a7:	c3                   	retq   

00000000008039a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8039a8:	55                   	push   %rbp
  8039a9:	48 89 e5             	mov    %rsp,%rbp
  8039ac:	53                   	push   %rbx
  8039ad:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8039b4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8039bb:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8039c1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8039c8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8039cf:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8039d6:	84 c0                	test   %al,%al
  8039d8:	74 23                	je     8039fd <_panic+0x55>
  8039da:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8039e1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8039e5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8039e9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8039ed:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8039f1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8039f5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8039f9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8039fd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a04:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a0b:	00 00 00 
  803a0e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a15:	00 00 00 
  803a18:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a1c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a23:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a2a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803a31:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803a38:	00 00 00 
  803a3b:	48 8b 18             	mov    (%rax),%rbx
  803a3e:	48 b8 11 18 80 00 00 	movabs $0x801811,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a50:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a57:	41 89 c8             	mov    %ecx,%r8d
  803a5a:	48 89 d1             	mov    %rdx,%rcx
  803a5d:	48 89 da             	mov    %rbx,%rdx
  803a60:	89 c6                	mov    %eax,%esi
  803a62:	48 bf e8 43 80 00 00 	movabs $0x8043e8,%rdi
  803a69:	00 00 00 
  803a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a71:	49 b9 96 03 80 00 00 	movabs $0x800396,%r9
  803a78:	00 00 00 
  803a7b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803a7e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803a85:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a8c:	48 89 d6             	mov    %rdx,%rsi
  803a8f:	48 89 c7             	mov    %rax,%rdi
  803a92:	48 b8 ea 02 80 00 00 	movabs $0x8002ea,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
	cprintf("\n");
  803a9e:	48 bf 0b 44 80 00 00 	movabs $0x80440b,%rdi
  803aa5:	00 00 00 
  803aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  803aad:	48 ba 96 03 80 00 00 	movabs $0x800396,%rdx
  803ab4:	00 00 00 
  803ab7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803ab9:	cc                   	int3   
  803aba:	eb fd                	jmp    803ab9 <_panic+0x111>

0000000000803abc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803abc:	55                   	push   %rbp
  803abd:	48 89 e5             	mov    %rsp,%rbp
  803ac0:	48 83 ec 30          	sub    $0x30,%rsp
  803ac4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ac8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803acc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803ad0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ad5:	75 0e                	jne    803ae5 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803ad7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ade:	00 00 00 
  803ae1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803ae5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae9:	48 89 c7             	mov    %rax,%rdi
  803aec:	48 b8 b6 1a 80 00 00 	movabs $0x801ab6,%rax
  803af3:	00 00 00 
  803af6:	ff d0                	callq  *%rax
  803af8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aff:	79 27                	jns    803b28 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803b01:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b06:	74 0a                	je     803b12 <ipc_recv+0x56>
            *from_env_store = 0;
  803b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803b12:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b17:	74 0a                	je     803b23 <ipc_recv+0x67>
            *perm_store = 0;
  803b19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b26:	eb 53                	jmp    803b7b <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803b28:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b2d:	74 19                	je     803b48 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803b2f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b36:	00 00 00 
  803b39:	48 8b 00             	mov    (%rax),%rax
  803b3c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803b42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b46:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803b48:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b4d:	74 19                	je     803b68 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803b4f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b56:	00 00 00 
  803b59:	48 8b 00             	mov    (%rax),%rax
  803b5c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b66:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803b68:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b6f:	00 00 00 
  803b72:	48 8b 00             	mov    (%rax),%rax
  803b75:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803b7b:	c9                   	leaveq 
  803b7c:	c3                   	retq   

0000000000803b7d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b7d:	55                   	push   %rbp
  803b7e:	48 89 e5             	mov    %rsp,%rbp
  803b81:	48 83 ec 30          	sub    $0x30,%rsp
  803b85:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b88:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b8b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b8f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803b92:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b97:	75 0e                	jne    803ba7 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803b99:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ba0:	00 00 00 
  803ba3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803ba7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803baa:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803bad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803bb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bb4:	89 c7                	mov    %eax,%edi
  803bb6:	48 b8 61 1a 80 00 00 	movabs $0x801a61,%rax
  803bbd:	00 00 00 
  803bc0:	ff d0                	callq  *%rax
  803bc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc9:	79 36                	jns    803c01 <ipc_send+0x84>
  803bcb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803bcf:	74 30                	je     803c01 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd4:	89 c1                	mov    %eax,%ecx
  803bd6:	48 ba 0d 44 80 00 00 	movabs $0x80440d,%rdx
  803bdd:	00 00 00 
  803be0:	be 49 00 00 00       	mov    $0x49,%esi
  803be5:	48 bf 1a 44 80 00 00 	movabs $0x80441a,%rdi
  803bec:	00 00 00 
  803bef:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf4:	49 b8 a8 39 80 00 00 	movabs $0x8039a8,%r8
  803bfb:	00 00 00 
  803bfe:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803c01:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  803c08:	00 00 00 
  803c0b:	ff d0                	callq  *%rax
    } while(r != 0);
  803c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c11:	75 94                	jne    803ba7 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803c13:	c9                   	leaveq 
  803c14:	c3                   	retq   

0000000000803c15 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803c15:	55                   	push   %rbp
  803c16:	48 89 e5             	mov    %rsp,%rbp
  803c19:	48 83 ec 14          	sub    $0x14,%rsp
  803c1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803c20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c27:	eb 5e                	jmp    803c87 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803c29:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c30:	00 00 00 
  803c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c36:	48 63 d0             	movslq %eax,%rdx
  803c39:	48 89 d0             	mov    %rdx,%rax
  803c3c:	48 c1 e0 03          	shl    $0x3,%rax
  803c40:	48 01 d0             	add    %rdx,%rax
  803c43:	48 c1 e0 05          	shl    $0x5,%rax
  803c47:	48 01 c8             	add    %rcx,%rax
  803c4a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803c50:	8b 00                	mov    (%rax),%eax
  803c52:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c55:	75 2c                	jne    803c83 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803c57:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c5e:	00 00 00 
  803c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c64:	48 63 d0             	movslq %eax,%rdx
  803c67:	48 89 d0             	mov    %rdx,%rax
  803c6a:	48 c1 e0 03          	shl    $0x3,%rax
  803c6e:	48 01 d0             	add    %rdx,%rax
  803c71:	48 c1 e0 05          	shl    $0x5,%rax
  803c75:	48 01 c8             	add    %rcx,%rax
  803c78:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c7e:	8b 40 08             	mov    0x8(%rax),%eax
  803c81:	eb 12                	jmp    803c95 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803c83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c87:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c8e:	7e 99                	jle    803c29 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c95:	c9                   	leaveq 
  803c96:	c3                   	retq   

0000000000803c97 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c97:	55                   	push   %rbp
  803c98:	48 89 e5             	mov    %rsp,%rbp
  803c9b:	48 83 ec 18          	sub    $0x18,%rsp
  803c9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca7:	48 c1 e8 15          	shr    $0x15,%rax
  803cab:	48 89 c2             	mov    %rax,%rdx
  803cae:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803cb5:	01 00 00 
  803cb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbc:	83 e0 01             	and    $0x1,%eax
  803cbf:	48 85 c0             	test   %rax,%rax
  803cc2:	75 07                	jne    803ccb <pageref+0x34>
		return 0;
  803cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc9:	eb 53                	jmp    803d1e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ccb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ccf:	48 c1 e8 0c          	shr    $0xc,%rax
  803cd3:	48 89 c2             	mov    %rax,%rdx
  803cd6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cdd:	01 00 00 
  803ce0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ce4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cec:	83 e0 01             	and    $0x1,%eax
  803cef:	48 85 c0             	test   %rax,%rax
  803cf2:	75 07                	jne    803cfb <pageref+0x64>
		return 0;
  803cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf9:	eb 23                	jmp    803d1e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cff:	48 c1 e8 0c          	shr    $0xc,%rax
  803d03:	48 89 c2             	mov    %rax,%rdx
  803d06:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d0d:	00 00 00 
  803d10:	48 c1 e2 04          	shl    $0x4,%rdx
  803d14:	48 01 d0             	add    %rdx,%rax
  803d17:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d1b:	0f b7 c0             	movzwl %ax,%eax
}
  803d1e:	c9                   	leaveq 
  803d1f:	c3                   	retq   
