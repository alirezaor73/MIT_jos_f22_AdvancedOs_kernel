
obj/user/ls:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 51 2b 80 00 00 	movabs $0x802b51,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 80 40 80 00 00 	movabs $0x804080,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 8c 40 80 00 00 	movabs $0x80408c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 cf 05 80 00 00 	movabs $0x8005cf,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 3f 2c 80 00 00 	movabs $0x802c3f,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 96 40 80 00 00 	movabs $0x804096,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 8c 40 80 00 00 	movabs $0x80408c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 cf 05 80 00 00 	movabs $0x8005cf,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 3e 28 80 00 00 	movabs $0x80283e,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba a2 40 80 00 00 	movabs $0x8040a2,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 8c 40 80 00 00 	movabs $0x80408c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 cf 05 80 00 00 	movabs $0x8005cf,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 8c 40 80 00 00 	movabs $0x80408c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 cf 05 80 00 00 	movabs $0x8005cf,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf df 40 80 00 00 	movabs $0x8040df,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 e8 34 80 00 00 	movabs $0x8034e8,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 64 13 80 00 00 	movabs $0x801364,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 e8 40 80 00 00 	movabs $0x8040e8,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 ea 40 80 00 00 	movabs $0x8040ea,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf eb 40 80 00 00 	movabs $0x8040eb,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 e8 34 80 00 00 	movabs $0x8034e8,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf f0 40 80 00 00 	movabs $0x8040f0,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba e8 34 80 00 00 	movabs $0x8034e8,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf e8 40 80 00 00 	movabs $0x8040e8,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba e8 34 80 00 00 	movabs $0x8034e8,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf f3 40 80 00 00 	movabs $0x8040f3,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba e8 34 80 00 00 	movabs $0x8034e8,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf f5 40 80 00 00 	movabs $0x8040f5,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba e8 34 80 00 00 	movabs $0x8034e8,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 ac 05 80 00 00 	movabs $0x8005ac,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 6c 1f 80 00 00 	movabs $0x801f6c,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 d0 1f 80 00 00 	movabs $0x801fd0,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be ea 40 80 00 00 	movabs $0x8040ea,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf e8 40 80 00 00 	movabs $0x8040e8,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 20          	sub    $0x20,%rsp
  800523:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800526:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80052a:	48 b8 83 1c 80 00 00 	movabs $0x801c83,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800539:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80053c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800541:	48 63 d0             	movslq %eax,%rdx
  800544:	48 89 d0             	mov    %rdx,%rax
  800547:	48 c1 e0 03          	shl    $0x3,%rax
  80054b:	48 01 d0             	add    %rdx,%rax
  80054e:	48 c1 e0 05          	shl    $0x5,%rax
  800552:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800559:	00 00 00 
  80055c:	48 01 c2             	add    %rax,%rdx
  80055f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800566:	00 00 00 
  800569:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800570:	7e 14                	jle    800586 <libmain+0x6b>
		binaryname = argv[0];
  800572:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800576:	48 8b 10             	mov    (%rax),%rdx
  800579:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800580:	00 00 00 
  800583:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800586:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80058a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80058d:	48 89 d6             	mov    %rdx,%rsi
  800590:	89 c7                	mov    %eax,%edi
  800592:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  800599:	00 00 00 
  80059c:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80059e:	48 b8 ac 05 80 00 00 	movabs $0x8005ac,%rax
  8005a5:	00 00 00 
  8005a8:	ff d0                	callq  *%rax
}
  8005aa:	c9                   	leaveq 
  8005ab:	c3                   	retq   

00000000008005ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ac:	55                   	push   %rbp
  8005ad:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005b0:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  8005b7:	00 00 00 
  8005ba:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c1:	48 b8 3f 1c 80 00 00 	movabs $0x801c3f,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
}
  8005cd:	5d                   	pop    %rbp
  8005ce:	c3                   	retq   

00000000008005cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
  8005d3:	53                   	push   %rbx
  8005d4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005db:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005e2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005e8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005ef:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005fd:	84 c0                	test   %al,%al
  8005ff:	74 23                	je     800624 <_panic+0x55>
  800601:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800608:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80060c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800610:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800614:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800618:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80061c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800620:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800624:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80062b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800632:	00 00 00 
  800635:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80063c:	00 00 00 
  80063f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800643:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80064a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800651:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800658:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80065f:	00 00 00 
  800662:	48 8b 18             	mov    (%rax),%rbx
  800665:	48 b8 83 1c 80 00 00 	movabs $0x801c83,%rax
  80066c:	00 00 00 
  80066f:	ff d0                	callq  *%rax
  800671:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800677:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80067e:	41 89 c8             	mov    %ecx,%r8d
  800681:	48 89 d1             	mov    %rdx,%rcx
  800684:	48 89 da             	mov    %rbx,%rdx
  800687:	89 c6                	mov    %eax,%esi
  800689:	48 bf 20 41 80 00 00 	movabs $0x804120,%rdi
  800690:	00 00 00 
  800693:	b8 00 00 00 00       	mov    $0x0,%eax
  800698:	49 b9 08 08 80 00 00 	movabs $0x800808,%r9
  80069f:	00 00 00 
  8006a2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006a5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006b3:	48 89 d6             	mov    %rdx,%rsi
  8006b6:	48 89 c7             	mov    %rax,%rdi
  8006b9:	48 b8 5c 07 80 00 00 	movabs $0x80075c,%rax
  8006c0:	00 00 00 
  8006c3:	ff d0                	callq  *%rax
	cprintf("\n");
  8006c5:	48 bf 43 41 80 00 00 	movabs $0x804143,%rdi
  8006cc:	00 00 00 
  8006cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d4:	48 ba 08 08 80 00 00 	movabs $0x800808,%rdx
  8006db:	00 00 00 
  8006de:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006e0:	cc                   	int3   
  8006e1:	eb fd                	jmp    8006e0 <_panic+0x111>

00000000008006e3 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006e3:	55                   	push   %rbp
  8006e4:	48 89 e5             	mov    %rsp,%rbp
  8006e7:	48 83 ec 10          	sub    $0x10,%rsp
  8006eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f6:	8b 00                	mov    (%rax),%eax
  8006f8:	8d 48 01             	lea    0x1(%rax),%ecx
  8006fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006ff:	89 0a                	mov    %ecx,(%rdx)
  800701:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800704:	89 d1                	mov    %edx,%ecx
  800706:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070a:	48 98                	cltq   
  80070c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800714:	8b 00                	mov    (%rax),%eax
  800716:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071b:	75 2c                	jne    800749 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80071d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800721:	8b 00                	mov    (%rax),%eax
  800723:	48 98                	cltq   
  800725:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800729:	48 83 c2 08          	add    $0x8,%rdx
  80072d:	48 89 c6             	mov    %rax,%rsi
  800730:	48 89 d7             	mov    %rdx,%rdi
  800733:	48 b8 b7 1b 80 00 00 	movabs $0x801bb7,%rax
  80073a:	00 00 00 
  80073d:	ff d0                	callq  *%rax
        b->idx = 0;
  80073f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800743:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80074d:	8b 40 04             	mov    0x4(%rax),%eax
  800750:	8d 50 01             	lea    0x1(%rax),%edx
  800753:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800757:	89 50 04             	mov    %edx,0x4(%rax)
}
  80075a:	c9                   	leaveq 
  80075b:	c3                   	retq   

000000000080075c <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80075c:	55                   	push   %rbp
  80075d:	48 89 e5             	mov    %rsp,%rbp
  800760:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800767:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80076e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800775:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80077c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800783:	48 8b 0a             	mov    (%rdx),%rcx
  800786:	48 89 08             	mov    %rcx,(%rax)
  800789:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80078d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800791:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800795:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800799:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007a0:	00 00 00 
    b.cnt = 0;
  8007a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007aa:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007ad:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007b4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007bb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007c2:	48 89 c6             	mov    %rax,%rsi
  8007c5:	48 bf e3 06 80 00 00 	movabs $0x8006e3,%rdi
  8007cc:	00 00 00 
  8007cf:	48 b8 bb 0b 80 00 00 	movabs $0x800bbb,%rax
  8007d6:	00 00 00 
  8007d9:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007db:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007e1:	48 98                	cltq   
  8007e3:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007ea:	48 83 c2 08          	add    $0x8,%rdx
  8007ee:	48 89 c6             	mov    %rax,%rsi
  8007f1:	48 89 d7             	mov    %rdx,%rdi
  8007f4:	48 b8 b7 1b 80 00 00 	movabs $0x801bb7,%rax
  8007fb:	00 00 00 
  8007fe:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800800:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800806:	c9                   	leaveq 
  800807:	c3                   	retq   

0000000000800808 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800808:	55                   	push   %rbp
  800809:	48 89 e5             	mov    %rsp,%rbp
  80080c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800813:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80081a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800821:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800828:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80082f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800836:	84 c0                	test   %al,%al
  800838:	74 20                	je     80085a <cprintf+0x52>
  80083a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80083e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800842:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800846:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80084a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80084e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800852:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800856:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80085a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800861:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800868:	00 00 00 
  80086b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800872:	00 00 00 
  800875:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800879:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800880:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800887:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80088e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800895:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80089c:	48 8b 0a             	mov    (%rdx),%rcx
  80089f:	48 89 08             	mov    %rcx,(%rax)
  8008a2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008aa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008ae:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008b2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008c0:	48 89 d6             	mov    %rdx,%rsi
  8008c3:	48 89 c7             	mov    %rax,%rdi
  8008c6:	48 b8 5c 07 80 00 00 	movabs $0x80075c,%rax
  8008cd:	00 00 00 
  8008d0:	ff d0                	callq  *%rax
  8008d2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008d8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	53                   	push   %rbx
  8008e5:	48 83 ec 38          	sub    $0x38,%rsp
  8008e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008f5:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008f8:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008fc:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800900:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800903:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800907:	77 3b                	ja     800944 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800909:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80090c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800910:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800917:	ba 00 00 00 00       	mov    $0x0,%edx
  80091c:	48 f7 f3             	div    %rbx
  80091f:	48 89 c2             	mov    %rax,%rdx
  800922:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800925:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800928:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80092c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800930:	41 89 f9             	mov    %edi,%r9d
  800933:	48 89 c7             	mov    %rax,%rdi
  800936:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  80093d:	00 00 00 
  800940:	ff d0                	callq  *%rax
  800942:	eb 1e                	jmp    800962 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800944:	eb 12                	jmp    800958 <printnum+0x78>
			putch(padc, putdat);
  800946:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80094a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	48 89 ce             	mov    %rcx,%rsi
  800954:	89 d7                	mov    %edx,%edi
  800956:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800958:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80095c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800960:	7f e4                	jg     800946 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800962:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
  80096e:	48 f7 f1             	div    %rcx
  800971:	48 89 d0             	mov    %rdx,%rax
  800974:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  80097b:	00 00 00 
  80097e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800982:	0f be d0             	movsbl %al,%edx
  800985:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	48 89 ce             	mov    %rcx,%rsi
  800990:	89 d7                	mov    %edx,%edi
  800992:	ff d0                	callq  *%rax
}
  800994:	48 83 c4 38          	add    $0x38,%rsp
  800998:	5b                   	pop    %rbx
  800999:	5d                   	pop    %rbp
  80099a:	c3                   	retq   

000000000080099b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80099b:	55                   	push   %rbp
  80099c:	48 89 e5             	mov    %rsp,%rbp
  80099f:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8009aa:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009ae:	7e 52                	jle    800a02 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	8b 00                	mov    (%rax),%eax
  8009b6:	83 f8 30             	cmp    $0x30,%eax
  8009b9:	73 24                	jae    8009df <getuint+0x44>
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	89 c0                	mov    %eax,%eax
  8009cb:	48 01 d0             	add    %rdx,%rax
  8009ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d2:	8b 12                	mov    (%rdx),%edx
  8009d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009db:	89 0a                	mov    %ecx,(%rdx)
  8009dd:	eb 17                	jmp    8009f6 <getuint+0x5b>
  8009df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e7:	48 89 d0             	mov    %rdx,%rax
  8009ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f6:	48 8b 00             	mov    (%rax),%rax
  8009f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009fd:	e9 a3 00 00 00       	jmpq   800aa5 <getuint+0x10a>
	else if (lflag)
  800a02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a06:	74 4f                	je     800a57 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0c:	8b 00                	mov    (%rax),%eax
  800a0e:	83 f8 30             	cmp    $0x30,%eax
  800a11:	73 24                	jae    800a37 <getuint+0x9c>
  800a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a17:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1f:	8b 00                	mov    (%rax),%eax
  800a21:	89 c0                	mov    %eax,%eax
  800a23:	48 01 d0             	add    %rdx,%rax
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	8b 12                	mov    (%rdx),%edx
  800a2c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a33:	89 0a                	mov    %ecx,(%rdx)
  800a35:	eb 17                	jmp    800a4e <getuint+0xb3>
  800a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3f:	48 89 d0             	mov    %rdx,%rax
  800a42:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a46:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4e:	48 8b 00             	mov    (%rax),%rax
  800a51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a55:	eb 4e                	jmp    800aa5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5b:	8b 00                	mov    (%rax),%eax
  800a5d:	83 f8 30             	cmp    $0x30,%eax
  800a60:	73 24                	jae    800a86 <getuint+0xeb>
  800a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a66:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6e:	8b 00                	mov    (%rax),%eax
  800a70:	89 c0                	mov    %eax,%eax
  800a72:	48 01 d0             	add    %rdx,%rax
  800a75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a79:	8b 12                	mov    (%rdx),%edx
  800a7b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a82:	89 0a                	mov    %ecx,(%rdx)
  800a84:	eb 17                	jmp    800a9d <getuint+0x102>
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8e:	48 89 d0             	mov    %rdx,%rax
  800a91:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a99:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9d:	8b 00                	mov    (%rax),%eax
  800a9f:	89 c0                	mov    %eax,%eax
  800aa1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa9:	c9                   	leaveq 
  800aaa:	c3                   	retq   

0000000000800aab <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aab:	55                   	push   %rbp
  800aac:	48 89 e5             	mov    %rsp,%rbp
  800aaf:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ab3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ab7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800aba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800abe:	7e 52                	jle    800b12 <getint+0x67>
		x=va_arg(*ap, long long);
  800ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac4:	8b 00                	mov    (%rax),%eax
  800ac6:	83 f8 30             	cmp    $0x30,%eax
  800ac9:	73 24                	jae    800aef <getint+0x44>
  800acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad7:	8b 00                	mov    (%rax),%eax
  800ad9:	89 c0                	mov    %eax,%eax
  800adb:	48 01 d0             	add    %rdx,%rax
  800ade:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae2:	8b 12                	mov    (%rdx),%edx
  800ae4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aeb:	89 0a                	mov    %ecx,(%rdx)
  800aed:	eb 17                	jmp    800b06 <getint+0x5b>
  800aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af7:	48 89 d0             	mov    %rdx,%rax
  800afa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800afe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b02:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b06:	48 8b 00             	mov    (%rax),%rax
  800b09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b0d:	e9 a3 00 00 00       	jmpq   800bb5 <getint+0x10a>
	else if (lflag)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b16:	74 4f                	je     800b67 <getint+0xbc>
		x=va_arg(*ap, long);
  800b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1c:	8b 00                	mov    (%rax),%eax
  800b1e:	83 f8 30             	cmp    $0x30,%eax
  800b21:	73 24                	jae    800b47 <getint+0x9c>
  800b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b27:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2f:	8b 00                	mov    (%rax),%eax
  800b31:	89 c0                	mov    %eax,%eax
  800b33:	48 01 d0             	add    %rdx,%rax
  800b36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3a:	8b 12                	mov    (%rdx),%edx
  800b3c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b43:	89 0a                	mov    %ecx,(%rdx)
  800b45:	eb 17                	jmp    800b5e <getint+0xb3>
  800b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b4f:	48 89 d0             	mov    %rdx,%rax
  800b52:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b5e:	48 8b 00             	mov    (%rax),%rax
  800b61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b65:	eb 4e                	jmp    800bb5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6b:	8b 00                	mov    (%rax),%eax
  800b6d:	83 f8 30             	cmp    $0x30,%eax
  800b70:	73 24                	jae    800b96 <getint+0xeb>
  800b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b76:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7e:	8b 00                	mov    (%rax),%eax
  800b80:	89 c0                	mov    %eax,%eax
  800b82:	48 01 d0             	add    %rdx,%rax
  800b85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b89:	8b 12                	mov    (%rdx),%edx
  800b8b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b92:	89 0a                	mov    %ecx,(%rdx)
  800b94:	eb 17                	jmp    800bad <getint+0x102>
  800b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b9e:	48 89 d0             	mov    %rdx,%rax
  800ba1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ba5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bad:	8b 00                	mov    (%rax),%eax
  800baf:	48 98                	cltq   
  800bb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bb9:	c9                   	leaveq 
  800bba:	c3                   	retq   

0000000000800bbb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bbb:	55                   	push   %rbp
  800bbc:	48 89 e5             	mov    %rsp,%rbp
  800bbf:	41 54                	push   %r12
  800bc1:	53                   	push   %rbx
  800bc2:	48 83 ec 60          	sub    $0x60,%rsp
  800bc6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bca:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bce:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bd2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bd6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bda:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bde:	48 8b 0a             	mov    (%rdx),%rcx
  800be1:	48 89 08             	mov    %rcx,(%rax)
  800be4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800be8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bf0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf4:	eb 17                	jmp    800c0d <vprintfmt+0x52>
			if (ch == '\0')
  800bf6:	85 db                	test   %ebx,%ebx
  800bf8:	0f 84 df 04 00 00    	je     8010dd <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800bfe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c06:	48 89 d6             	mov    %rdx,%rsi
  800c09:	89 df                	mov    %ebx,%edi
  800c0b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c11:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c15:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c19:	0f b6 00             	movzbl (%rax),%eax
  800c1c:	0f b6 d8             	movzbl %al,%ebx
  800c1f:	83 fb 25             	cmp    $0x25,%ebx
  800c22:	75 d2                	jne    800bf6 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c24:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c28:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c2f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c36:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c3d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c44:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c48:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c4c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c50:	0f b6 00             	movzbl (%rax),%eax
  800c53:	0f b6 d8             	movzbl %al,%ebx
  800c56:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c59:	83 f8 55             	cmp    $0x55,%eax
  800c5c:	0f 87 47 04 00 00    	ja     8010a9 <vprintfmt+0x4ee>
  800c62:	89 c0                	mov    %eax,%eax
  800c64:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c6b:	00 
  800c6c:	48 b8 78 43 80 00 00 	movabs $0x804378,%rax
  800c73:	00 00 00 
  800c76:	48 01 d0             	add    %rdx,%rax
  800c79:	48 8b 00             	mov    (%rax),%rax
  800c7c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c7e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c82:	eb c0                	jmp    800c44 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c84:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c88:	eb ba                	jmp    800c44 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c91:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c94:	89 d0                	mov    %edx,%eax
  800c96:	c1 e0 02             	shl    $0x2,%eax
  800c99:	01 d0                	add    %edx,%eax
  800c9b:	01 c0                	add    %eax,%eax
  800c9d:	01 d8                	add    %ebx,%eax
  800c9f:	83 e8 30             	sub    $0x30,%eax
  800ca2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ca5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca9:	0f b6 00             	movzbl (%rax),%eax
  800cac:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800caf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb2:	7e 0c                	jle    800cc0 <vprintfmt+0x105>
  800cb4:	83 fb 39             	cmp    $0x39,%ebx
  800cb7:	7f 07                	jg     800cc0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cbe:	eb d1                	jmp    800c91 <vprintfmt+0xd6>
			goto process_precision;
  800cc0:	eb 58                	jmp    800d1a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc5:	83 f8 30             	cmp    $0x30,%eax
  800cc8:	73 17                	jae    800ce1 <vprintfmt+0x126>
  800cca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd1:	89 c0                	mov    %eax,%eax
  800cd3:	48 01 d0             	add    %rdx,%rax
  800cd6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd9:	83 c2 08             	add    $0x8,%edx
  800cdc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cdf:	eb 0f                	jmp    800cf0 <vprintfmt+0x135>
  800ce1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce5:	48 89 d0             	mov    %rdx,%rax
  800ce8:	48 83 c2 08          	add    $0x8,%rdx
  800cec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf0:	8b 00                	mov    (%rax),%eax
  800cf2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cf5:	eb 23                	jmp    800d1a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800cf7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cfb:	79 0c                	jns    800d09 <vprintfmt+0x14e>
				width = 0;
  800cfd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d04:	e9 3b ff ff ff       	jmpq   800c44 <vprintfmt+0x89>
  800d09:	e9 36 ff ff ff       	jmpq   800c44 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d0e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d15:	e9 2a ff ff ff       	jmpq   800c44 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1e:	79 12                	jns    800d32 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d20:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d23:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d26:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d2d:	e9 12 ff ff ff       	jmpq   800c44 <vprintfmt+0x89>
  800d32:	e9 0d ff ff ff       	jmpq   800c44 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d37:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d3b:	e9 04 ff ff ff       	jmpq   800c44 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d43:	83 f8 30             	cmp    $0x30,%eax
  800d46:	73 17                	jae    800d5f <vprintfmt+0x1a4>
  800d48:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d4f:	89 c0                	mov    %eax,%eax
  800d51:	48 01 d0             	add    %rdx,%rax
  800d54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d57:	83 c2 08             	add    $0x8,%edx
  800d5a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d5d:	eb 0f                	jmp    800d6e <vprintfmt+0x1b3>
  800d5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d63:	48 89 d0             	mov    %rdx,%rax
  800d66:	48 83 c2 08          	add    $0x8,%rdx
  800d6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d6e:	8b 10                	mov    (%rax),%edx
  800d70:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d78:	48 89 ce             	mov    %rcx,%rsi
  800d7b:	89 d7                	mov    %edx,%edi
  800d7d:	ff d0                	callq  *%rax
			break;
  800d7f:	e9 53 03 00 00       	jmpq   8010d7 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d87:	83 f8 30             	cmp    $0x30,%eax
  800d8a:	73 17                	jae    800da3 <vprintfmt+0x1e8>
  800d8c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d93:	89 c0                	mov    %eax,%eax
  800d95:	48 01 d0             	add    %rdx,%rax
  800d98:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9b:	83 c2 08             	add    $0x8,%edx
  800d9e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da1:	eb 0f                	jmp    800db2 <vprintfmt+0x1f7>
  800da3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da7:	48 89 d0             	mov    %rdx,%rax
  800daa:	48 83 c2 08          	add    $0x8,%rdx
  800dae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800db4:	85 db                	test   %ebx,%ebx
  800db6:	79 02                	jns    800dba <vprintfmt+0x1ff>
				err = -err;
  800db8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dba:	83 fb 15             	cmp    $0x15,%ebx
  800dbd:	7f 16                	jg     800dd5 <vprintfmt+0x21a>
  800dbf:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  800dc6:	00 00 00 
  800dc9:	48 63 d3             	movslq %ebx,%rdx
  800dcc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dd0:	4d 85 e4             	test   %r12,%r12
  800dd3:	75 2e                	jne    800e03 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dd5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddd:	89 d9                	mov    %ebx,%ecx
  800ddf:	48 ba 61 43 80 00 00 	movabs $0x804361,%rdx
  800de6:	00 00 00 
  800de9:	48 89 c7             	mov    %rax,%rdi
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
  800df1:	49 b8 e6 10 80 00 00 	movabs $0x8010e6,%r8
  800df8:	00 00 00 
  800dfb:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dfe:	e9 d4 02 00 00       	jmpq   8010d7 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e03:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0b:	4c 89 e1             	mov    %r12,%rcx
  800e0e:	48 ba 6a 43 80 00 00 	movabs $0x80436a,%rdx
  800e15:	00 00 00 
  800e18:	48 89 c7             	mov    %rax,%rdi
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e20:	49 b8 e6 10 80 00 00 	movabs $0x8010e6,%r8
  800e27:	00 00 00 
  800e2a:	41 ff d0             	callq  *%r8
			break;
  800e2d:	e9 a5 02 00 00       	jmpq   8010d7 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e35:	83 f8 30             	cmp    $0x30,%eax
  800e38:	73 17                	jae    800e51 <vprintfmt+0x296>
  800e3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e41:	89 c0                	mov    %eax,%eax
  800e43:	48 01 d0             	add    %rdx,%rax
  800e46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e49:	83 c2 08             	add    $0x8,%edx
  800e4c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x2a5>
  800e51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e55:	48 89 d0             	mov    %rdx,%rax
  800e58:	48 83 c2 08          	add    $0x8,%rdx
  800e5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e60:	4c 8b 20             	mov    (%rax),%r12
  800e63:	4d 85 e4             	test   %r12,%r12
  800e66:	75 0a                	jne    800e72 <vprintfmt+0x2b7>
				p = "(null)";
  800e68:	49 bc 6d 43 80 00 00 	movabs $0x80436d,%r12
  800e6f:	00 00 00 
			if (width > 0 && padc != '-')
  800e72:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e76:	7e 3f                	jle    800eb7 <vprintfmt+0x2fc>
  800e78:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e7c:	74 39                	je     800eb7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e81:	48 98                	cltq   
  800e83:	48 89 c6             	mov    %rax,%rsi
  800e86:	4c 89 e7             	mov    %r12,%rdi
  800e89:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
  800e95:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e98:	eb 17                	jmp    800eb1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e9a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e9e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ea2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea6:	48 89 ce             	mov    %rcx,%rsi
  800ea9:	89 d7                	mov    %edx,%edi
  800eab:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ead:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eb5:	7f e3                	jg     800e9a <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb7:	eb 37                	jmp    800ef0 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ebd:	74 1e                	je     800edd <vprintfmt+0x322>
  800ebf:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec2:	7e 05                	jle    800ec9 <vprintfmt+0x30e>
  800ec4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec7:	7e 14                	jle    800edd <vprintfmt+0x322>
					putch('?', putdat);
  800ec9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ecd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed1:	48 89 d6             	mov    %rdx,%rsi
  800ed4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ed9:	ff d0                	callq  *%rax
  800edb:	eb 0f                	jmp    800eec <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800edd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee5:	48 89 d6             	mov    %rdx,%rsi
  800ee8:	89 df                	mov    %ebx,%edi
  800eea:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eec:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ef0:	4c 89 e0             	mov    %r12,%rax
  800ef3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ef7:	0f b6 00             	movzbl (%rax),%eax
  800efa:	0f be d8             	movsbl %al,%ebx
  800efd:	85 db                	test   %ebx,%ebx
  800eff:	74 10                	je     800f11 <vprintfmt+0x356>
  800f01:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f05:	78 b2                	js     800eb9 <vprintfmt+0x2fe>
  800f07:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f0f:	79 a8                	jns    800eb9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f11:	eb 16                	jmp    800f29 <vprintfmt+0x36e>
				putch(' ', putdat);
  800f13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1b:	48 89 d6             	mov    %rdx,%rsi
  800f1e:	bf 20 00 00 00       	mov    $0x20,%edi
  800f23:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f25:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f2d:	7f e4                	jg     800f13 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f2f:	e9 a3 01 00 00       	jmpq   8010d7 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f38:	be 03 00 00 00       	mov    $0x3,%esi
  800f3d:	48 89 c7             	mov    %rax,%rdi
  800f40:	48 b8 ab 0a 80 00 00 	movabs $0x800aab,%rax
  800f47:	00 00 00 
  800f4a:	ff d0                	callq  *%rax
  800f4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f54:	48 85 c0             	test   %rax,%rax
  800f57:	79 1d                	jns    800f76 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f61:	48 89 d6             	mov    %rdx,%rsi
  800f64:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f69:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	48 f7 d8             	neg    %rax
  800f72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f76:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f7d:	e9 e8 00 00 00       	jmpq   80106a <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f82:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f86:	be 03 00 00 00       	mov    $0x3,%esi
  800f8b:	48 89 c7             	mov    %rax,%rdi
  800f8e:	48 b8 9b 09 80 00 00 	movabs $0x80099b,%rax
  800f95:	00 00 00 
  800f98:	ff d0                	callq  *%rax
  800f9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f9e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa5:	e9 c0 00 00 00       	jmpq   80106a <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800faa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb2:	48 89 d6             	mov    %rdx,%rsi
  800fb5:	bf 58 00 00 00       	mov    $0x58,%edi
  800fba:	ff d0                	callq  *%rax
			putch('X', putdat);
  800fbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc4:	48 89 d6             	mov    %rdx,%rsi
  800fc7:	bf 58 00 00 00       	mov    $0x58,%edi
  800fcc:	ff d0                	callq  *%rax
			putch('X', putdat);
  800fce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd6:	48 89 d6             	mov    %rdx,%rsi
  800fd9:	bf 58 00 00 00       	mov    $0x58,%edi
  800fde:	ff d0                	callq  *%rax
			break;
  800fe0:	e9 f2 00 00 00       	jmpq   8010d7 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800fe5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fed:	48 89 d6             	mov    %rdx,%rsi
  800ff0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ff5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ff7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fff:	48 89 d6             	mov    %rdx,%rsi
  801002:	bf 78 00 00 00       	mov    $0x78,%edi
  801007:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801009:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100c:	83 f8 30             	cmp    $0x30,%eax
  80100f:	73 17                	jae    801028 <vprintfmt+0x46d>
  801011:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801015:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801018:	89 c0                	mov    %eax,%eax
  80101a:	48 01 d0             	add    %rdx,%rax
  80101d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801020:	83 c2 08             	add    $0x8,%edx
  801023:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801026:	eb 0f                	jmp    801037 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  801028:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80102c:	48 89 d0             	mov    %rdx,%rax
  80102f:	48 83 c2 08          	add    $0x8,%rdx
  801033:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801037:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80103e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801045:	eb 23                	jmp    80106a <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801047:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80104b:	be 03 00 00 00       	mov    $0x3,%esi
  801050:	48 89 c7             	mov    %rax,%rdi
  801053:	48 b8 9b 09 80 00 00 	movabs $0x80099b,%rax
  80105a:	00 00 00 
  80105d:	ff d0                	callq  *%rax
  80105f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801063:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80106a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80106f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801072:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801075:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801079:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80107d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801081:	45 89 c1             	mov    %r8d,%r9d
  801084:	41 89 f8             	mov    %edi,%r8d
  801087:	48 89 c7             	mov    %rax,%rdi
  80108a:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  801091:	00 00 00 
  801094:	ff d0                	callq  *%rax
			break;
  801096:	eb 3f                	jmp    8010d7 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801098:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80109c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a0:	48 89 d6             	mov    %rdx,%rsi
  8010a3:	89 df                	mov    %ebx,%edi
  8010a5:	ff d0                	callq  *%rax
			break;
  8010a7:	eb 2e                	jmp    8010d7 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b1:	48 89 d6             	mov    %rdx,%rsi
  8010b4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010b9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010bb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010c0:	eb 05                	jmp    8010c7 <vprintfmt+0x50c>
  8010c2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010c7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010cb:	48 83 e8 01          	sub    $0x1,%rax
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	3c 25                	cmp    $0x25,%al
  8010d4:	75 ec                	jne    8010c2 <vprintfmt+0x507>
				/* do nothing */;
			break;
  8010d6:	90                   	nop
		}
	}
  8010d7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010d8:	e9 30 fb ff ff       	jmpq   800c0d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010dd:	48 83 c4 60          	add    $0x60,%rsp
  8010e1:	5b                   	pop    %rbx
  8010e2:	41 5c                	pop    %r12
  8010e4:	5d                   	pop    %rbp
  8010e5:	c3                   	retq   

00000000008010e6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e6:	55                   	push   %rbp
  8010e7:	48 89 e5             	mov    %rsp,%rbp
  8010ea:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010f1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010f8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010ff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801106:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80110d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801114:	84 c0                	test   %al,%al
  801116:	74 20                	je     801138 <printfmt+0x52>
  801118:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80111c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801120:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801124:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801128:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80112c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801130:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801134:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801138:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80113f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801146:	00 00 00 
  801149:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801150:	00 00 00 
  801153:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801157:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80115e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801165:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80116c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801173:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80117a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801181:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801188:	48 89 c7             	mov    %rax,%rdi
  80118b:	48 b8 bb 0b 80 00 00 	movabs $0x800bbb,%rax
  801192:	00 00 00 
  801195:	ff d0                	callq  *%rax
	va_end(ap);
}
  801197:	c9                   	leaveq 
  801198:	c3                   	retq   

0000000000801199 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801199:	55                   	push   %rbp
  80119a:	48 89 e5             	mov    %rsp,%rbp
  80119d:	48 83 ec 10          	sub    $0x10,%rsp
  8011a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ac:	8b 40 10             	mov    0x10(%rax),%eax
  8011af:	8d 50 01             	lea    0x1(%rax),%edx
  8011b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	48 8b 10             	mov    (%rax),%rdx
  8011c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011c8:	48 39 c2             	cmp    %rax,%rdx
  8011cb:	73 17                	jae    8011e4 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d1:	48 8b 00             	mov    (%rax),%rax
  8011d4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011dc:	48 89 0a             	mov    %rcx,(%rdx)
  8011df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011e2:	88 10                	mov    %dl,(%rax)
}
  8011e4:	c9                   	leaveq 
  8011e5:	c3                   	retq   

00000000008011e6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011e6:	55                   	push   %rbp
  8011e7:	48 89 e5             	mov    %rsp,%rbp
  8011ea:	48 83 ec 50          	sub    $0x50,%rsp
  8011ee:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011f2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011f5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011f9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011fd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801201:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801205:	48 8b 0a             	mov    (%rdx),%rcx
  801208:	48 89 08             	mov    %rcx,(%rax)
  80120b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80120f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801213:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801217:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80121b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80121f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801223:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801226:	48 98                	cltq   
  801228:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80122c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801230:	48 01 d0             	add    %rdx,%rax
  801233:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801237:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80123e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801243:	74 06                	je     80124b <vsnprintf+0x65>
  801245:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801249:	7f 07                	jg     801252 <vsnprintf+0x6c>
		return -E_INVAL;
  80124b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801250:	eb 2f                	jmp    801281 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801252:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801256:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80125a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80125e:	48 89 c6             	mov    %rax,%rsi
  801261:	48 bf 99 11 80 00 00 	movabs $0x801199,%rdi
  801268:	00 00 00 
  80126b:	48 b8 bb 0b 80 00 00 	movabs $0x800bbb,%rax
  801272:	00 00 00 
  801275:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801277:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80127b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80127e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801281:	c9                   	leaveq 
  801282:	c3                   	retq   

0000000000801283 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801283:	55                   	push   %rbp
  801284:	48 89 e5             	mov    %rsp,%rbp
  801287:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80128e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801295:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80129b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012a2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012a9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 20                	je     8012d4 <snprintf+0x51>
  8012b4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012b8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012bc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012c0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012c4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012c8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012cc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012d0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012d4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012db:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012e2:	00 00 00 
  8012e5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012ec:	00 00 00 
  8012ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012f3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012fa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801301:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801308:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80130f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801316:	48 8b 0a             	mov    (%rdx),%rcx
  801319:	48 89 08             	mov    %rcx,(%rax)
  80131c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801320:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801324:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801328:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80132c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801333:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80133a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801340:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801347:	48 89 c7             	mov    %rax,%rdi
  80134a:	48 b8 e6 11 80 00 00 	movabs $0x8011e6,%rax
  801351:	00 00 00 
  801354:	ff d0                	callq  *%rax
  801356:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80135c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801362:	c9                   	leaveq 
  801363:	c3                   	retq   

0000000000801364 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801364:	55                   	push   %rbp
  801365:	48 89 e5             	mov    %rsp,%rbp
  801368:	48 83 ec 18          	sub    $0x18,%rsp
  80136c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801377:	eb 09                	jmp    801382 <strlen+0x1e>
		n++;
  801379:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80137d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	84 c0                	test   %al,%al
  80138b:	75 ec                	jne    801379 <strlen+0x15>
		n++;
	return n;
  80138d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801390:	c9                   	leaveq 
  801391:	c3                   	retq   

0000000000801392 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801392:	55                   	push   %rbp
  801393:	48 89 e5             	mov    %rsp,%rbp
  801396:	48 83 ec 20          	sub    $0x20,%rsp
  80139a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013a9:	eb 0e                	jmp    8013b9 <strnlen+0x27>
		n++;
  8013ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013af:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013b4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013b9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013be:	74 0b                	je     8013cb <strnlen+0x39>
  8013c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	84 c0                	test   %al,%al
  8013c9:	75 e0                	jne    8013ab <strnlen+0x19>
		n++;
	return n;
  8013cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ce:	c9                   	leaveq 
  8013cf:	c3                   	retq   

00000000008013d0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	48 83 ec 20          	sub    $0x20,%rsp
  8013d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013e8:	90                   	nop
  8013e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013f9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013fd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801401:	0f b6 12             	movzbl (%rdx),%edx
  801404:	88 10                	mov    %dl,(%rax)
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	84 c0                	test   %al,%al
  80140b:	75 dc                	jne    8013e9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80140d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801411:	c9                   	leaveq 
  801412:	c3                   	retq   

0000000000801413 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801413:	55                   	push   %rbp
  801414:	48 89 e5             	mov    %rsp,%rbp
  801417:	48 83 ec 20          	sub    $0x20,%rsp
  80141b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801427:	48 89 c7             	mov    %rax,%rdi
  80142a:	48 b8 64 13 80 00 00 	movabs $0x801364,%rax
  801431:	00 00 00 
  801434:	ff d0                	callq  *%rax
  801436:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80143c:	48 63 d0             	movslq %eax,%rdx
  80143f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801443:	48 01 c2             	add    %rax,%rdx
  801446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144a:	48 89 c6             	mov    %rax,%rsi
  80144d:	48 89 d7             	mov    %rdx,%rdi
  801450:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  801457:	00 00 00 
  80145a:	ff d0                	callq  *%rax
	return dst;
  80145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 83 ec 28          	sub    $0x28,%rsp
  80146a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801472:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80147e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801485:	00 
  801486:	eb 2a                	jmp    8014b2 <strncpy+0x50>
		*dst++ = *src;
  801488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801490:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801494:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801498:	0f b6 12             	movzbl (%rdx),%edx
  80149b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80149d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	84 c0                	test   %al,%al
  8014a6:	74 05                	je     8014ad <strncpy+0x4b>
			src++;
  8014a8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014ba:	72 cc                	jb     801488 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014c0:	c9                   	leaveq 
  8014c1:	c3                   	retq   

00000000008014c2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014c2:	55                   	push   %rbp
  8014c3:	48 89 e5             	mov    %rsp,%rbp
  8014c6:	48 83 ec 28          	sub    $0x28,%rsp
  8014ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014e3:	74 3d                	je     801522 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014e5:	eb 1d                	jmp    801504 <strlcpy+0x42>
			*dst++ = *src++;
  8014e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014f7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014fb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014ff:	0f b6 12             	movzbl (%rdx),%edx
  801502:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801504:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801509:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80150e:	74 0b                	je     80151b <strlcpy+0x59>
  801510:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801514:	0f b6 00             	movzbl (%rax),%eax
  801517:	84 c0                	test   %al,%al
  801519:	75 cc                	jne    8014e7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801522:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801526:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152a:	48 29 c2             	sub    %rax,%rdx
  80152d:	48 89 d0             	mov    %rdx,%rax
}
  801530:	c9                   	leaveq 
  801531:	c3                   	retq   

0000000000801532 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801532:	55                   	push   %rbp
  801533:	48 89 e5             	mov    %rsp,%rbp
  801536:	48 83 ec 10          	sub    $0x10,%rsp
  80153a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801542:	eb 0a                	jmp    80154e <strcmp+0x1c>
		p++, q++;
  801544:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801549:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801552:	0f b6 00             	movzbl (%rax),%eax
  801555:	84 c0                	test   %al,%al
  801557:	74 12                	je     80156b <strcmp+0x39>
  801559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155d:	0f b6 10             	movzbl (%rax),%edx
  801560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801564:	0f b6 00             	movzbl (%rax),%eax
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 d9                	je     801544 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156f:	0f b6 00             	movzbl (%rax),%eax
  801572:	0f b6 d0             	movzbl %al,%edx
  801575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	0f b6 c0             	movzbl %al,%eax
  80157f:	29 c2                	sub    %eax,%edx
  801581:	89 d0                	mov    %edx,%eax
}
  801583:	c9                   	leaveq 
  801584:	c3                   	retq   

0000000000801585 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801585:	55                   	push   %rbp
  801586:	48 89 e5             	mov    %rsp,%rbp
  801589:	48 83 ec 18          	sub    $0x18,%rsp
  80158d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801591:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801595:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801599:	eb 0f                	jmp    8015aa <strncmp+0x25>
		n--, p++, q++;
  80159b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015af:	74 1d                	je     8015ce <strncmp+0x49>
  8015b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	84 c0                	test   %al,%al
  8015ba:	74 12                	je     8015ce <strncmp+0x49>
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	0f b6 10             	movzbl (%rax),%edx
  8015c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	38 c2                	cmp    %al,%dl
  8015cc:	74 cd                	je     80159b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d3:	75 07                	jne    8015dc <strncmp+0x57>
		return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	eb 18                	jmp    8015f4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	0f b6 d0             	movzbl %al,%edx
  8015e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	0f b6 c0             	movzbl %al,%eax
  8015f0:	29 c2                	sub    %eax,%edx
  8015f2:	89 d0                	mov    %edx,%eax
}
  8015f4:	c9                   	leaveq 
  8015f5:	c3                   	retq   

00000000008015f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015f6:	55                   	push   %rbp
  8015f7:	48 89 e5             	mov    %rsp,%rbp
  8015fa:	48 83 ec 0c          	sub    $0xc,%rsp
  8015fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801602:	89 f0                	mov    %esi,%eax
  801604:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801607:	eb 17                	jmp    801620 <strchr+0x2a>
		if (*s == c)
  801609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801613:	75 06                	jne    80161b <strchr+0x25>
			return (char *) s;
  801615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801619:	eb 15                	jmp    801630 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80161b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	84 c0                	test   %al,%al
  801629:	75 de                	jne    801609 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801630:	c9                   	leaveq 
  801631:	c3                   	retq   

0000000000801632 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801632:	55                   	push   %rbp
  801633:	48 89 e5             	mov    %rsp,%rbp
  801636:	48 83 ec 0c          	sub    $0xc,%rsp
  80163a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80163e:	89 f0                	mov    %esi,%eax
  801640:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801643:	eb 13                	jmp    801658 <strfind+0x26>
		if (*s == c)
  801645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80164f:	75 02                	jne    801653 <strfind+0x21>
			break;
  801651:	eb 10                	jmp    801663 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801653:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165c:	0f b6 00             	movzbl (%rax),%eax
  80165f:	84 c0                	test   %al,%al
  801661:	75 e2                	jne    801645 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801667:	c9                   	leaveq 
  801668:	c3                   	retq   

0000000000801669 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801669:	55                   	push   %rbp
  80166a:	48 89 e5             	mov    %rsp,%rbp
  80166d:	48 83 ec 18          	sub    $0x18,%rsp
  801671:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801675:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801678:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80167c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801681:	75 06                	jne    801689 <memset+0x20>
		return v;
  801683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801687:	eb 69                	jmp    8016f2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168d:	83 e0 03             	and    $0x3,%eax
  801690:	48 85 c0             	test   %rax,%rax
  801693:	75 48                	jne    8016dd <memset+0x74>
  801695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801699:	83 e0 03             	and    $0x3,%eax
  80169c:	48 85 c0             	test   %rax,%rax
  80169f:	75 3c                	jne    8016dd <memset+0x74>
		c &= 0xFF;
  8016a1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ab:	c1 e0 18             	shl    $0x18,%eax
  8016ae:	89 c2                	mov    %eax,%edx
  8016b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b3:	c1 e0 10             	shl    $0x10,%eax
  8016b6:	09 c2                	or     %eax,%edx
  8016b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016bb:	c1 e0 08             	shl    $0x8,%eax
  8016be:	09 d0                	or     %edx,%eax
  8016c0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c7:	48 c1 e8 02          	shr    $0x2,%rax
  8016cb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d5:	48 89 d7             	mov    %rdx,%rdi
  8016d8:	fc                   	cld    
  8016d9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016db:	eb 11                	jmp    8016ee <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016e8:	48 89 d7             	mov    %rdx,%rdi
  8016eb:	fc                   	cld    
  8016ec:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016f2:	c9                   	leaveq 
  8016f3:	c3                   	retq   

00000000008016f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016f4:	55                   	push   %rbp
  8016f5:	48 89 e5             	mov    %rsp,%rbp
  8016f8:	48 83 ec 28          	sub    $0x28,%rsp
  8016fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801700:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801704:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801708:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80170c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801714:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801720:	0f 83 88 00 00 00    	jae    8017ae <memmove+0xba>
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172e:	48 01 d0             	add    %rdx,%rax
  801731:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801735:	76 77                	jbe    8017ae <memmove+0xba>
		s += n;
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801747:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174b:	83 e0 03             	and    $0x3,%eax
  80174e:	48 85 c0             	test   %rax,%rax
  801751:	75 3b                	jne    80178e <memmove+0x9a>
  801753:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801757:	83 e0 03             	and    $0x3,%eax
  80175a:	48 85 c0             	test   %rax,%rax
  80175d:	75 2f                	jne    80178e <memmove+0x9a>
  80175f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801763:	83 e0 03             	and    $0x3,%eax
  801766:	48 85 c0             	test   %rax,%rax
  801769:	75 23                	jne    80178e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80176b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176f:	48 83 e8 04          	sub    $0x4,%rax
  801773:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801777:	48 83 ea 04          	sub    $0x4,%rdx
  80177b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80177f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801783:	48 89 c7             	mov    %rax,%rdi
  801786:	48 89 d6             	mov    %rdx,%rsi
  801789:	fd                   	std    
  80178a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80178c:	eb 1d                	jmp    8017ab <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80178e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801792:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	48 89 d7             	mov    %rdx,%rdi
  8017a5:	48 89 c1             	mov    %rax,%rcx
  8017a8:	fd                   	std    
  8017a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ab:	fc                   	cld    
  8017ac:	eb 57                	jmp    801805 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b2:	83 e0 03             	and    $0x3,%eax
  8017b5:	48 85 c0             	test   %rax,%rax
  8017b8:	75 36                	jne    8017f0 <memmove+0xfc>
  8017ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017be:	83 e0 03             	and    $0x3,%eax
  8017c1:	48 85 c0             	test   %rax,%rax
  8017c4:	75 2a                	jne    8017f0 <memmove+0xfc>
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	83 e0 03             	and    $0x3,%eax
  8017cd:	48 85 c0             	test   %rax,%rax
  8017d0:	75 1e                	jne    8017f0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d6:	48 c1 e8 02          	shr    $0x2,%rax
  8017da:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017e5:	48 89 c7             	mov    %rax,%rdi
  8017e8:	48 89 d6             	mov    %rdx,%rsi
  8017eb:	fc                   	cld    
  8017ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ee:	eb 15                	jmp    801805 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017fc:	48 89 c7             	mov    %rax,%rdi
  8017ff:	48 89 d6             	mov    %rdx,%rsi
  801802:	fc                   	cld    
  801803:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801809:	c9                   	leaveq 
  80180a:	c3                   	retq   

000000000080180b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
  80180f:	48 83 ec 18          	sub    $0x18,%rsp
  801813:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801817:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80181f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801823:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182b:	48 89 ce             	mov    %rcx,%rsi
  80182e:	48 89 c7             	mov    %rax,%rdi
  801831:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  801838:	00 00 00 
  80183b:	ff d0                	callq  *%rax
}
  80183d:	c9                   	leaveq 
  80183e:	c3                   	retq   

000000000080183f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 28          	sub    $0x28,%rsp
  801847:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80184f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801857:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80185b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80185f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801863:	eb 36                	jmp    80189b <memcmp+0x5c>
		if (*s1 != *s2)
  801865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801869:	0f b6 10             	movzbl (%rax),%edx
  80186c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	38 c2                	cmp    %al,%dl
  801875:	74 1a                	je     801891 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	0f b6 d0             	movzbl %al,%edx
  801881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	0f b6 c0             	movzbl %al,%eax
  80188b:	29 c2                	sub    %eax,%edx
  80188d:	89 d0                	mov    %edx,%eax
  80188f:	eb 20                	jmp    8018b1 <memcmp+0x72>
		s1++, s2++;
  801891:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801896:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80189b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018a7:	48 85 c0             	test   %rax,%rax
  8018aa:	75 b9                	jne    801865 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b1:	c9                   	leaveq 
  8018b2:	c3                   	retq   

00000000008018b3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018b3:	55                   	push   %rbp
  8018b4:	48 89 e5             	mov    %rsp,%rbp
  8018b7:	48 83 ec 28          	sub    $0x28,%rsp
  8018bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ce:	48 01 d0             	add    %rdx,%rax
  8018d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018d5:	eb 15                	jmp    8018ec <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018db:	0f b6 10             	movzbl (%rax),%edx
  8018de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e1:	38 c2                	cmp    %al,%dl
  8018e3:	75 02                	jne    8018e7 <memfind+0x34>
			break;
  8018e5:	eb 0f                	jmp    8018f6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018e7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018f4:	72 e1                	jb     8018d7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 34          	sub    $0x34,%rsp
  801904:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801908:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80190c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80190f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801916:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80191d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80191e:	eb 05                	jmp    801925 <strtol+0x29>
		s++;
  801920:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801929:	0f b6 00             	movzbl (%rax),%eax
  80192c:	3c 20                	cmp    $0x20,%al
  80192e:	74 f0                	je     801920 <strtol+0x24>
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	3c 09                	cmp    $0x9,%al
  801939:	74 e5                	je     801920 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	3c 2b                	cmp    $0x2b,%al
  801944:	75 07                	jne    80194d <strtol+0x51>
		s++;
  801946:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194b:	eb 17                	jmp    801964 <strtol+0x68>
	else if (*s == '-')
  80194d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801951:	0f b6 00             	movzbl (%rax),%eax
  801954:	3c 2d                	cmp    $0x2d,%al
  801956:	75 0c                	jne    801964 <strtol+0x68>
		s++, neg = 1;
  801958:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801964:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801968:	74 06                	je     801970 <strtol+0x74>
  80196a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80196e:	75 28                	jne    801998 <strtol+0x9c>
  801970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801974:	0f b6 00             	movzbl (%rax),%eax
  801977:	3c 30                	cmp    $0x30,%al
  801979:	75 1d                	jne    801998 <strtol+0x9c>
  80197b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197f:	48 83 c0 01          	add    $0x1,%rax
  801983:	0f b6 00             	movzbl (%rax),%eax
  801986:	3c 78                	cmp    $0x78,%al
  801988:	75 0e                	jne    801998 <strtol+0x9c>
		s += 2, base = 16;
  80198a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80198f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801996:	eb 2c                	jmp    8019c4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801998:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80199c:	75 19                	jne    8019b7 <strtol+0xbb>
  80199e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a2:	0f b6 00             	movzbl (%rax),%eax
  8019a5:	3c 30                	cmp    $0x30,%al
  8019a7:	75 0e                	jne    8019b7 <strtol+0xbb>
		s++, base = 8;
  8019a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ae:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019b5:	eb 0d                	jmp    8019c4 <strtol+0xc8>
	else if (base == 0)
  8019b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019bb:	75 07                	jne    8019c4 <strtol+0xc8>
		base = 10;
  8019bd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c8:	0f b6 00             	movzbl (%rax),%eax
  8019cb:	3c 2f                	cmp    $0x2f,%al
  8019cd:	7e 1d                	jle    8019ec <strtol+0xf0>
  8019cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d3:	0f b6 00             	movzbl (%rax),%eax
  8019d6:	3c 39                	cmp    $0x39,%al
  8019d8:	7f 12                	jg     8019ec <strtol+0xf0>
			dig = *s - '0';
  8019da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019de:	0f b6 00             	movzbl (%rax),%eax
  8019e1:	0f be c0             	movsbl %al,%eax
  8019e4:	83 e8 30             	sub    $0x30,%eax
  8019e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019ea:	eb 4e                	jmp    801a3a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f0:	0f b6 00             	movzbl (%rax),%eax
  8019f3:	3c 60                	cmp    $0x60,%al
  8019f5:	7e 1d                	jle    801a14 <strtol+0x118>
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	0f b6 00             	movzbl (%rax),%eax
  8019fe:	3c 7a                	cmp    $0x7a,%al
  801a00:	7f 12                	jg     801a14 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a06:	0f b6 00             	movzbl (%rax),%eax
  801a09:	0f be c0             	movsbl %al,%eax
  801a0c:	83 e8 57             	sub    $0x57,%eax
  801a0f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a12:	eb 26                	jmp    801a3a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a18:	0f b6 00             	movzbl (%rax),%eax
  801a1b:	3c 40                	cmp    $0x40,%al
  801a1d:	7e 48                	jle    801a67 <strtol+0x16b>
  801a1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a23:	0f b6 00             	movzbl (%rax),%eax
  801a26:	3c 5a                	cmp    $0x5a,%al
  801a28:	7f 3d                	jg     801a67 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2e:	0f b6 00             	movzbl (%rax),%eax
  801a31:	0f be c0             	movsbl %al,%eax
  801a34:	83 e8 37             	sub    $0x37,%eax
  801a37:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a3d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a40:	7c 02                	jl     801a44 <strtol+0x148>
			break;
  801a42:	eb 23                	jmp    801a67 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a44:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a49:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a4c:	48 98                	cltq   
  801a4e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a53:	48 89 c2             	mov    %rax,%rdx
  801a56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a59:	48 98                	cltq   
  801a5b:	48 01 d0             	add    %rdx,%rax
  801a5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a62:	e9 5d ff ff ff       	jmpq   8019c4 <strtol+0xc8>

	if (endptr)
  801a67:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a6c:	74 0b                	je     801a79 <strtol+0x17d>
		*endptr = (char *) s;
  801a6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a72:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a76:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a7d:	74 09                	je     801a88 <strtol+0x18c>
  801a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a83:	48 f7 d8             	neg    %rax
  801a86:	eb 04                	jmp    801a8c <strtol+0x190>
  801a88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <strstr>:

char * strstr(const char *in, const char *str)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	48 83 ec 30          	sub    $0x30,%rsp
  801a96:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a9a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aa2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aa6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aaa:	0f b6 00             	movzbl (%rax),%eax
  801aad:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ab0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ab4:	75 06                	jne    801abc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801ab6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aba:	eb 6b                	jmp    801b27 <strstr+0x99>

	len = strlen(str);
  801abc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac0:	48 89 c7             	mov    %rax,%rdi
  801ac3:	48 b8 64 13 80 00 00 	movabs $0x801364,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
  801acf:	48 98                	cltq   
  801ad1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801add:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ae1:	0f b6 00             	movzbl (%rax),%eax
  801ae4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ae7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801aeb:	75 07                	jne    801af4 <strstr+0x66>
				return (char *) 0;
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
  801af2:	eb 33                	jmp    801b27 <strstr+0x99>
		} while (sc != c);
  801af4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801af8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801afb:	75 d8                	jne    801ad5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801afd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b01:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b09:	48 89 ce             	mov    %rcx,%rsi
  801b0c:	48 89 c7             	mov    %rax,%rdi
  801b0f:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801b16:	00 00 00 
  801b19:	ff d0                	callq  *%rax
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	75 b6                	jne    801ad5 <strstr+0x47>

	return (char *) (in - 1);
  801b1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b23:	48 83 e8 01          	sub    $0x1,%rax
}
  801b27:	c9                   	leaveq 
  801b28:	c3                   	retq   

0000000000801b29 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b29:	55                   	push   %rbp
  801b2a:	48 89 e5             	mov    %rsp,%rbp
  801b2d:	53                   	push   %rbx
  801b2e:	48 83 ec 48          	sub    $0x48,%rsp
  801b32:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b35:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b38:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b3c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b40:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b44:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b48:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b4b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b4f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b53:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b57:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b5b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b5f:	4c 89 c3             	mov    %r8,%rbx
  801b62:	cd 30                	int    $0x30
  801b64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b68:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b6c:	74 3e                	je     801bac <syscall+0x83>
  801b6e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b73:	7e 37                	jle    801bac <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b79:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b7c:	49 89 d0             	mov    %rdx,%r8
  801b7f:	89 c1                	mov    %eax,%ecx
  801b81:	48 ba 28 46 80 00 00 	movabs $0x804628,%rdx
  801b88:	00 00 00 
  801b8b:	be 23 00 00 00       	mov    $0x23,%esi
  801b90:	48 bf 45 46 80 00 00 	movabs $0x804645,%rdi
  801b97:	00 00 00 
  801b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9f:	49 b9 cf 05 80 00 00 	movabs $0x8005cf,%r9
  801ba6:	00 00 00 
  801ba9:	41 ff d1             	callq  *%r9

	return ret;
  801bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bb0:	48 83 c4 48          	add    $0x48,%rsp
  801bb4:	5b                   	pop    %rbx
  801bb5:	5d                   	pop    %rbp
  801bb6:	c3                   	retq   

0000000000801bb7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bb7:	55                   	push   %rbp
  801bb8:	48 89 e5             	mov    %rsp,%rbp
  801bbb:	48 83 ec 20          	sub    $0x20,%rsp
  801bbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd6:	00 
  801bd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be3:	48 89 d1             	mov    %rdx,%rcx
  801be6:	48 89 c2             	mov    %rax,%rdx
  801be9:	be 00 00 00 00       	mov    $0x0,%esi
  801bee:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf3:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c10:	00 
  801c11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c22:	ba 00 00 00 00       	mov    $0x0,%edx
  801c27:	be 00 00 00 00       	mov    $0x0,%esi
  801c2c:	bf 01 00 00 00       	mov    $0x1,%edi
  801c31:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801c38:	00 00 00 
  801c3b:	ff d0                	callq  *%rax
}
  801c3d:	c9                   	leaveq 
  801c3e:	c3                   	retq   

0000000000801c3f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c3f:	55                   	push   %rbp
  801c40:	48 89 e5             	mov    %rsp,%rbp
  801c43:	48 83 ec 10          	sub    $0x10,%rsp
  801c47:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4d:	48 98                	cltq   
  801c4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c56:	00 
  801c57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c63:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c68:	48 89 c2             	mov    %rax,%rdx
  801c6b:	be 01 00 00 00       	mov    $0x1,%esi
  801c70:	bf 03 00 00 00       	mov    $0x3,%edi
  801c75:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801c7c:	00 00 00 
  801c7f:	ff d0                	callq  *%rax
}
  801c81:	c9                   	leaveq 
  801c82:	c3                   	retq   

0000000000801c83 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c83:	55                   	push   %rbp
  801c84:	48 89 e5             	mov    %rsp,%rbp
  801c87:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c8b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c92:	00 
  801c93:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c99:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca9:	be 00 00 00 00       	mov    $0x0,%esi
  801cae:	bf 02 00 00 00       	mov    $0x2,%edi
  801cb3:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	callq  *%rax
}
  801cbf:	c9                   	leaveq 
  801cc0:	c3                   	retq   

0000000000801cc1 <sys_yield>:

void
sys_yield(void)
{
  801cc1:	55                   	push   %rbp
  801cc2:	48 89 e5             	mov    %rsp,%rbp
  801cc5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd0:	00 
  801cd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce7:	be 00 00 00 00       	mov    $0x0,%esi
  801cec:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cf1:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
}
  801cfd:	c9                   	leaveq 
  801cfe:	c3                   	retq   

0000000000801cff <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cff:	55                   	push   %rbp
  801d00:	48 89 e5             	mov    %rsp,%rbp
  801d03:	48 83 ec 20          	sub    $0x20,%rsp
  801d07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d14:	48 63 c8             	movslq %eax,%rcx
  801d17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1e:	48 98                	cltq   
  801d20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d27:	00 
  801d28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2e:	49 89 c8             	mov    %rcx,%r8
  801d31:	48 89 d1             	mov    %rdx,%rcx
  801d34:	48 89 c2             	mov    %rax,%rdx
  801d37:	be 01 00 00 00       	mov    $0x1,%esi
  801d3c:	bf 04 00 00 00       	mov    $0x4,%edi
  801d41:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
}
  801d4d:	c9                   	leaveq 
  801d4e:	c3                   	retq   

0000000000801d4f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	48 83 ec 30          	sub    $0x30,%rsp
  801d57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d5e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d61:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d65:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d69:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d6c:	48 63 c8             	movslq %eax,%rcx
  801d6f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d76:	48 63 f0             	movslq %eax,%rsi
  801d79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d80:	48 98                	cltq   
  801d82:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d86:	49 89 f9             	mov    %rdi,%r9
  801d89:	49 89 f0             	mov    %rsi,%r8
  801d8c:	48 89 d1             	mov    %rdx,%rcx
  801d8f:	48 89 c2             	mov    %rax,%rdx
  801d92:	be 01 00 00 00       	mov    $0x1,%esi
  801d97:	bf 05 00 00 00       	mov    $0x5,%edi
  801d9c:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
}
  801da8:	c9                   	leaveq 
  801da9:	c3                   	retq   

0000000000801daa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801daa:	55                   	push   %rbp
  801dab:	48 89 e5             	mov    %rsp,%rbp
  801dae:	48 83 ec 20          	sub    $0x20,%rsp
  801db2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801db9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc0:	48 98                	cltq   
  801dc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc9:	00 
  801dca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd6:	48 89 d1             	mov    %rdx,%rcx
  801dd9:	48 89 c2             	mov    %rax,%rdx
  801ddc:	be 01 00 00 00       	mov    $0x1,%esi
  801de1:	bf 06 00 00 00       	mov    $0x6,%edi
  801de6:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801ded:	00 00 00 
  801df0:	ff d0                	callq  *%rax
}
  801df2:	c9                   	leaveq 
  801df3:	c3                   	retq   

0000000000801df4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801df4:	55                   	push   %rbp
  801df5:	48 89 e5             	mov    %rsp,%rbp
  801df8:	48 83 ec 10          	sub    $0x10,%rsp
  801dfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dff:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e05:	48 63 d0             	movslq %eax,%rdx
  801e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0b:	48 98                	cltq   
  801e0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e14:	00 
  801e15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e21:	48 89 d1             	mov    %rdx,%rcx
  801e24:	48 89 c2             	mov    %rax,%rdx
  801e27:	be 01 00 00 00       	mov    $0x1,%esi
  801e2c:	bf 08 00 00 00       	mov    $0x8,%edi
  801e31:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
}
  801e3d:	c9                   	leaveq 
  801e3e:	c3                   	retq   

0000000000801e3f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e3f:	55                   	push   %rbp
  801e40:	48 89 e5             	mov    %rsp,%rbp
  801e43:	48 83 ec 20          	sub    $0x20,%rsp
  801e47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e55:	48 98                	cltq   
  801e57:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5e:	00 
  801e5f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e65:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6b:	48 89 d1             	mov    %rdx,%rcx
  801e6e:	48 89 c2             	mov    %rax,%rdx
  801e71:	be 01 00 00 00       	mov    $0x1,%esi
  801e76:	bf 09 00 00 00       	mov    $0x9,%edi
  801e7b:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801e82:	00 00 00 
  801e85:	ff d0                	callq  *%rax
}
  801e87:	c9                   	leaveq 
  801e88:	c3                   	retq   

0000000000801e89 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e89:	55                   	push   %rbp
  801e8a:	48 89 e5             	mov    %rsp,%rbp
  801e8d:	48 83 ec 20          	sub    $0x20,%rsp
  801e91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9f:	48 98                	cltq   
  801ea1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea8:	00 
  801ea9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eaf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb5:	48 89 d1             	mov    %rdx,%rcx
  801eb8:	48 89 c2             	mov    %rax,%rdx
  801ebb:	be 01 00 00 00       	mov    $0x1,%esi
  801ec0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ec5:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801ecc:	00 00 00 
  801ecf:	ff d0                	callq  *%rax
}
  801ed1:	c9                   	leaveq 
  801ed2:	c3                   	retq   

0000000000801ed3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ed3:	55                   	push   %rbp
  801ed4:	48 89 e5             	mov    %rsp,%rbp
  801ed7:	48 83 ec 20          	sub    $0x20,%rsp
  801edb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ede:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ee2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ee6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ee9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eec:	48 63 f0             	movslq %eax,%rsi
  801eef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef6:	48 98                	cltq   
  801ef8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f03:	00 
  801f04:	49 89 f1             	mov    %rsi,%r9
  801f07:	49 89 c8             	mov    %rcx,%r8
  801f0a:	48 89 d1             	mov    %rdx,%rcx
  801f0d:	48 89 c2             	mov    %rax,%rdx
  801f10:	be 00 00 00 00       	mov    $0x0,%esi
  801f15:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f1a:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
}
  801f26:	c9                   	leaveq 
  801f27:	c3                   	retq   

0000000000801f28 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	48 83 ec 10          	sub    $0x10,%rsp
  801f30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3f:	00 
  801f40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f51:	48 89 c2             	mov    %rax,%rdx
  801f54:	be 01 00 00 00       	mov    $0x1,%esi
  801f59:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f5e:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  801f65:	00 00 00 
  801f68:	ff d0                	callq  *%rax
}
  801f6a:	c9                   	leaveq 
  801f6b:	c3                   	retq   

0000000000801f6c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801f6c:	55                   	push   %rbp
  801f6d:	48 89 e5             	mov    %rsp,%rbp
  801f70:	48 83 ec 18          	sub    $0x18,%rsp
  801f74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f7c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f84:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f88:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f93:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9b:	8b 00                	mov    (%rax),%eax
  801f9d:	83 f8 01             	cmp    $0x1,%eax
  801fa0:	7e 13                	jle    801fb5 <argstart+0x49>
  801fa2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801fa7:	74 0c                	je     801fb5 <argstart+0x49>
  801fa9:	48 b8 53 46 80 00 00 	movabs $0x804653,%rax
  801fb0:	00 00 00 
  801fb3:	eb 05                	jmp    801fba <argstart+0x4e>
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fbe:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc6:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fcd:	00 
}
  801fce:	c9                   	leaveq 
  801fcf:	c3                   	retq   

0000000000801fd0 <argnext>:

int
argnext(struct Argstate *args)
{
  801fd0:	55                   	push   %rbp
  801fd1:	48 89 e5             	mov    %rsp,%rbp
  801fd4:	48 83 ec 20          	sub    $0x20,%rsp
  801fd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801fdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe0:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fe7:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fec:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ff0:	48 85 c0             	test   %rax,%rax
  801ff3:	75 0a                	jne    801fff <argnext+0x2f>
		return -1;
  801ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801ffa:	e9 25 01 00 00       	jmpq   802124 <argnext+0x154>

	if (!*args->curarg) {
  801fff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802003:	48 8b 40 10          	mov    0x10(%rax),%rax
  802007:	0f b6 00             	movzbl (%rax),%eax
  80200a:	84 c0                	test   %al,%al
  80200c:	0f 85 d7 00 00 00    	jne    8020e9 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802016:	48 8b 00             	mov    (%rax),%rax
  802019:	8b 00                	mov    (%rax),%eax
  80201b:	83 f8 01             	cmp    $0x1,%eax
  80201e:	0f 84 ef 00 00 00    	je     802113 <argnext+0x143>
		    || args->argv[1][0] != '-'
  802024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802028:	48 8b 40 08          	mov    0x8(%rax),%rax
  80202c:	48 83 c0 08          	add    $0x8,%rax
  802030:	48 8b 00             	mov    (%rax),%rax
  802033:	0f b6 00             	movzbl (%rax),%eax
  802036:	3c 2d                	cmp    $0x2d,%al
  802038:	0f 85 d5 00 00 00    	jne    802113 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80203e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802042:	48 8b 40 08          	mov    0x8(%rax),%rax
  802046:	48 83 c0 08          	add    $0x8,%rax
  80204a:	48 8b 00             	mov    (%rax),%rax
  80204d:	48 83 c0 01          	add    $0x1,%rax
  802051:	0f b6 00             	movzbl (%rax),%eax
  802054:	84 c0                	test   %al,%al
  802056:	0f 84 b7 00 00 00    	je     802113 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80205c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802060:	48 8b 40 08          	mov    0x8(%rax),%rax
  802064:	48 83 c0 08          	add    $0x8,%rax
  802068:	48 8b 00             	mov    (%rax),%rax
  80206b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80206f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802073:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802077:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207b:	48 8b 00             	mov    (%rax),%rax
  80207e:	8b 00                	mov    (%rax),%eax
  802080:	83 e8 01             	sub    $0x1,%eax
  802083:	48 98                	cltq   
  802085:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80208c:	00 
  80208d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802091:	48 8b 40 08          	mov    0x8(%rax),%rax
  802095:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020a1:	48 83 c0 08          	add    $0x8,%rax
  8020a5:	48 89 ce             	mov    %rcx,%rsi
  8020a8:	48 89 c7             	mov    %rax,%rdi
  8020ab:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
		(*args->argc)--;
  8020b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bb:	48 8b 00             	mov    (%rax),%rax
  8020be:	8b 10                	mov    (%rax),%edx
  8020c0:	83 ea 01             	sub    $0x1,%edx
  8020c3:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020cd:	0f b6 00             	movzbl (%rax),%eax
  8020d0:	3c 2d                	cmp    $0x2d,%al
  8020d2:	75 15                	jne    8020e9 <argnext+0x119>
  8020d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020dc:	48 83 c0 01          	add    $0x1,%rax
  8020e0:	0f b6 00             	movzbl (%rax),%eax
  8020e3:	84 c0                	test   %al,%al
  8020e5:	75 02                	jne    8020e9 <argnext+0x119>
			goto endofargs;
  8020e7:	eb 2a                	jmp    802113 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8020e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ed:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020f1:	0f b6 00             	movzbl (%rax),%eax
  8020f4:	0f b6 c0             	movzbl %al,%eax
  8020f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8020fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fe:	48 8b 40 10          	mov    0x10(%rax),%rax
  802102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80210e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802111:	eb 11                	jmp    802124 <argnext+0x154>

endofargs:
	args->curarg = 0;
  802113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802117:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80211e:	00 
	return -1;
  80211f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802124:	c9                   	leaveq 
  802125:	c3                   	retq   

0000000000802126 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	48 83 ec 10          	sub    $0x10,%rsp
  80212e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802136:	48 8b 40 18          	mov    0x18(%rax),%rax
  80213a:	48 85 c0             	test   %rax,%rax
  80213d:	74 0a                	je     802149 <argvalue+0x23>
  80213f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802143:	48 8b 40 18          	mov    0x18(%rax),%rax
  802147:	eb 13                	jmp    80215c <argvalue+0x36>
  802149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80214d:	48 89 c7             	mov    %rax,%rdi
  802150:	48 b8 5e 21 80 00 00 	movabs $0x80215e,%rax
  802157:	00 00 00 
  80215a:	ff d0                	callq  *%rax
}
  80215c:	c9                   	leaveq 
  80215d:	c3                   	retq   

000000000080215e <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80215e:	55                   	push   %rbp
  80215f:	48 89 e5             	mov    %rsp,%rbp
  802162:	53                   	push   %rbx
  802163:	48 83 ec 18          	sub    $0x18,%rsp
  802167:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80216b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802173:	48 85 c0             	test   %rax,%rax
  802176:	75 0a                	jne    802182 <argnextvalue+0x24>
		return 0;
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
  80217d:	e9 c8 00 00 00       	jmpq   80224a <argnextvalue+0xec>
	if (*args->curarg) {
  802182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802186:	48 8b 40 10          	mov    0x10(%rax),%rax
  80218a:	0f b6 00             	movzbl (%rax),%eax
  80218d:	84 c0                	test   %al,%al
  80218f:	74 27                	je     8021b8 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  802191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802195:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219d:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8021a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a5:	48 bb 53 46 80 00 00 	movabs $0x804653,%rbx
  8021ac:	00 00 00 
  8021af:	48 89 58 10          	mov    %rbx,0x10(%rax)
  8021b3:	e9 8a 00 00 00       	jmpq   802242 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8021b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bc:	48 8b 00             	mov    (%rax),%rax
  8021bf:	8b 00                	mov    (%rax),%eax
  8021c1:	83 f8 01             	cmp    $0x1,%eax
  8021c4:	7e 64                	jle    80222a <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8021c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ca:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021ce:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d6:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8021da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021de:	48 8b 00             	mov    (%rax),%rax
  8021e1:	8b 00                	mov    (%rax),%eax
  8021e3:	83 e8 01             	sub    $0x1,%eax
  8021e6:	48 98                	cltq   
  8021e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021ef:	00 
  8021f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021f8:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8021fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802200:	48 8b 40 08          	mov    0x8(%rax),%rax
  802204:	48 83 c0 08          	add    $0x8,%rax
  802208:	48 89 ce             	mov    %rcx,%rsi
  80220b:	48 89 c7             	mov    %rax,%rdi
  80220e:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
		(*args->argc)--;
  80221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221e:	48 8b 00             	mov    (%rax),%rax
  802221:	8b 10                	mov    (%rax),%edx
  802223:	83 ea 01             	sub    $0x1,%edx
  802226:	89 10                	mov    %edx,(%rax)
  802228:	eb 18                	jmp    802242 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  80222a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222e:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802235:	00 
		args->curarg = 0;
  802236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223a:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802241:	00 
	}
	return (char*) args->argvalue;
  802242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802246:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  80224a:	48 83 c4 18          	add    $0x18,%rsp
  80224e:	5b                   	pop    %rbx
  80224f:	5d                   	pop    %rbp
  802250:	c3                   	retq   

0000000000802251 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802251:	55                   	push   %rbp
  802252:	48 89 e5             	mov    %rsp,%rbp
  802255:	48 83 ec 08          	sub    $0x8,%rsp
  802259:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80225d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802261:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802268:	ff ff ff 
  80226b:	48 01 d0             	add    %rdx,%rax
  80226e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802272:	c9                   	leaveq 
  802273:	c3                   	retq   

0000000000802274 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802274:	55                   	push   %rbp
  802275:	48 89 e5             	mov    %rsp,%rbp
  802278:	48 83 ec 08          	sub    $0x8,%rsp
  80227c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802284:	48 89 c7             	mov    %rax,%rdi
  802287:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  80228e:	00 00 00 
  802291:	ff d0                	callq  *%rax
  802293:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802299:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	48 83 ec 18          	sub    $0x18,%rsp
  8022a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022b2:	eb 6b                	jmp    80231f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b7:	48 98                	cltq   
  8022b9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022bf:	48 c1 e0 0c          	shl    $0xc,%rax
  8022c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cb:	48 c1 e8 15          	shr    $0x15,%rax
  8022cf:	48 89 c2             	mov    %rax,%rdx
  8022d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022d9:	01 00 00 
  8022dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e0:	83 e0 01             	and    $0x1,%eax
  8022e3:	48 85 c0             	test   %rax,%rax
  8022e6:	74 21                	je     802309 <fd_alloc+0x6a>
  8022e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f0:	48 89 c2             	mov    %rax,%rdx
  8022f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022fa:	01 00 00 
  8022fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802301:	83 e0 01             	and    $0x1,%eax
  802304:	48 85 c0             	test   %rax,%rax
  802307:	75 12                	jne    80231b <fd_alloc+0x7c>
			*fd_store = fd;
  802309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802311:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802314:	b8 00 00 00 00       	mov    $0x0,%eax
  802319:	eb 1a                	jmp    802335 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80231b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80231f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802323:	7e 8f                	jle    8022b4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802329:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802330:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802335:	c9                   	leaveq 
  802336:	c3                   	retq   

0000000000802337 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802337:	55                   	push   %rbp
  802338:	48 89 e5             	mov    %rsp,%rbp
  80233b:	48 83 ec 20          	sub    $0x20,%rsp
  80233f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802342:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802346:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80234a:	78 06                	js     802352 <fd_lookup+0x1b>
  80234c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802350:	7e 07                	jle    802359 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802352:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802357:	eb 6c                	jmp    8023c5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802359:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80235c:	48 98                	cltq   
  80235e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802364:	48 c1 e0 0c          	shl    $0xc,%rax
  802368:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80236c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802370:	48 c1 e8 15          	shr    $0x15,%rax
  802374:	48 89 c2             	mov    %rax,%rdx
  802377:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80237e:	01 00 00 
  802381:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802385:	83 e0 01             	and    $0x1,%eax
  802388:	48 85 c0             	test   %rax,%rax
  80238b:	74 21                	je     8023ae <fd_lookup+0x77>
  80238d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802391:	48 c1 e8 0c          	shr    $0xc,%rax
  802395:	48 89 c2             	mov    %rax,%rdx
  802398:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80239f:	01 00 00 
  8023a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a6:	83 e0 01             	and    $0x1,%eax
  8023a9:	48 85 c0             	test   %rax,%rax
  8023ac:	75 07                	jne    8023b5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b3:	eb 10                	jmp    8023c5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023bd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c5:	c9                   	leaveq 
  8023c6:	c3                   	retq   

00000000008023c7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023c7:	55                   	push   %rbp
  8023c8:	48 89 e5             	mov    %rsp,%rbp
  8023cb:	48 83 ec 30          	sub    $0x30,%rsp
  8023cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023d3:	89 f0                	mov    %esi,%eax
  8023d5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023dc:	48 89 c7             	mov    %rax,%rdi
  8023df:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
  8023eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ef:	48 89 d6             	mov    %rdx,%rsi
  8023f2:	89 c7                	mov    %eax,%edi
  8023f4:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax
  802400:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802403:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802407:	78 0a                	js     802413 <fd_close+0x4c>
	    || fd != fd2)
  802409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802411:	74 12                	je     802425 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802413:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802417:	74 05                	je     80241e <fd_close+0x57>
  802419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241c:	eb 05                	jmp    802423 <fd_close+0x5c>
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
  802423:	eb 69                	jmp    80248e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802429:	8b 00                	mov    (%rax),%eax
  80242b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242f:	48 89 d6             	mov    %rdx,%rsi
  802432:	89 c7                	mov    %eax,%edi
  802434:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  80243b:	00 00 00 
  80243e:	ff d0                	callq  *%rax
  802440:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802443:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802447:	78 2a                	js     802473 <fd_close+0xac>
		if (dev->dev_close)
  802449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802451:	48 85 c0             	test   %rax,%rax
  802454:	74 16                	je     80246c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80245e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802462:	48 89 d7             	mov    %rdx,%rdi
  802465:	ff d0                	callq  *%rax
  802467:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246a:	eb 07                	jmp    802473 <fd_close+0xac>
		else
			r = 0;
  80246c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802473:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802477:	48 89 c6             	mov    %rax,%rsi
  80247a:	bf 00 00 00 00       	mov    $0x0,%edi
  80247f:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  802486:	00 00 00 
  802489:	ff d0                	callq  *%rax
	return r;
  80248b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80248e:	c9                   	leaveq 
  80248f:	c3                   	retq   

0000000000802490 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802490:	55                   	push   %rbp
  802491:	48 89 e5             	mov    %rsp,%rbp
  802494:	48 83 ec 20          	sub    $0x20,%rsp
  802498:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80249b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80249f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a6:	eb 41                	jmp    8024e9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024a8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024af:	00 00 00 
  8024b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b5:	48 63 d2             	movslq %edx,%rdx
  8024b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bc:	8b 00                	mov    (%rax),%eax
  8024be:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024c1:	75 22                	jne    8024e5 <dev_lookup+0x55>
			*dev = devtab[i];
  8024c3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024ca:	00 00 00 
  8024cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024d0:	48 63 d2             	movslq %edx,%rdx
  8024d3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024db:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024de:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e3:	eb 60                	jmp    802545 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024e9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024f0:	00 00 00 
  8024f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024f6:	48 63 d2             	movslq %edx,%rdx
  8024f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fd:	48 85 c0             	test   %rax,%rax
  802500:	75 a6                	jne    8024a8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802502:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802509:	00 00 00 
  80250c:	48 8b 00             	mov    (%rax),%rax
  80250f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802515:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802518:	89 c6                	mov    %eax,%esi
  80251a:	48 bf 58 46 80 00 00 	movabs $0x804658,%rdi
  802521:	00 00 00 
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
  802529:	48 b9 08 08 80 00 00 	movabs $0x800808,%rcx
  802530:	00 00 00 
  802533:	ff d1                	callq  *%rcx
	*dev = 0;
  802535:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802539:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802540:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802545:	c9                   	leaveq 
  802546:	c3                   	retq   

0000000000802547 <close>:

int
close(int fdnum)
{
  802547:	55                   	push   %rbp
  802548:	48 89 e5             	mov    %rsp,%rbp
  80254b:	48 83 ec 20          	sub    $0x20,%rsp
  80254f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802552:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802556:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802559:	48 89 d6             	mov    %rdx,%rsi
  80255c:	89 c7                	mov    %eax,%edi
  80255e:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  802565:	00 00 00 
  802568:	ff d0                	callq  *%rax
  80256a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802571:	79 05                	jns    802578 <close+0x31>
		return r;
  802573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802576:	eb 18                	jmp    802590 <close+0x49>
	else
		return fd_close(fd, 1);
  802578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257c:	be 01 00 00 00       	mov    $0x1,%esi
  802581:	48 89 c7             	mov    %rax,%rdi
  802584:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  80258b:	00 00 00 
  80258e:	ff d0                	callq  *%rax
}
  802590:	c9                   	leaveq 
  802591:	c3                   	retq   

0000000000802592 <close_all>:

void
close_all(void)
{
  802592:	55                   	push   %rbp
  802593:	48 89 e5             	mov    %rsp,%rbp
  802596:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80259a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a1:	eb 15                	jmp    8025b8 <close_all+0x26>
		close(i);
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	89 c7                	mov    %eax,%edi
  8025a8:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  8025af:	00 00 00 
  8025b2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025bc:	7e e5                	jle    8025a3 <close_all+0x11>
		close(i);
}
  8025be:	c9                   	leaveq 
  8025bf:	c3                   	retq   

00000000008025c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025c0:	55                   	push   %rbp
  8025c1:	48 89 e5             	mov    %rsp,%rbp
  8025c4:	48 83 ec 40          	sub    $0x40,%rsp
  8025c8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025cb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025ce:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025d2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025d5:	48 89 d6             	mov    %rdx,%rsi
  8025d8:	89 c7                	mov    %eax,%edi
  8025da:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	callq  *%rax
  8025e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ed:	79 08                	jns    8025f7 <dup+0x37>
		return r;
  8025ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f2:	e9 70 01 00 00       	jmpq   802767 <dup+0x1a7>
	close(newfdnum);
  8025f7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802608:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80260b:	48 98                	cltq   
  80260d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802613:	48 c1 e0 0c          	shl    $0xc,%rax
  802617:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80261b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261f:	48 89 c7             	mov    %rax,%rdi
  802622:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
  80262e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802636:	48 89 c7             	mov    %rax,%rdi
  802639:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802640:	00 00 00 
  802643:	ff d0                	callq  *%rax
  802645:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264d:	48 c1 e8 15          	shr    $0x15,%rax
  802651:	48 89 c2             	mov    %rax,%rdx
  802654:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	48 85 c0             	test   %rax,%rax
  802668:	74 73                	je     8026dd <dup+0x11d>
  80266a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266e:	48 c1 e8 0c          	shr    $0xc,%rax
  802672:	48 89 c2             	mov    %rax,%rdx
  802675:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267c:	01 00 00 
  80267f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802683:	83 e0 01             	and    $0x1,%eax
  802686:	48 85 c0             	test   %rax,%rax
  802689:	74 52                	je     8026dd <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80268b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268f:	48 c1 e8 0c          	shr    $0xc,%rax
  802693:	48 89 c2             	mov    %rax,%rdx
  802696:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80269d:	01 00 00 
  8026a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8026a9:	89 c1                	mov    %eax,%ecx
  8026ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b3:	41 89 c8             	mov    %ecx,%r8d
  8026b6:	48 89 d1             	mov    %rdx,%rcx
  8026b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026be:	48 89 c6             	mov    %rax,%rsi
  8026c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c6:	48 b8 4f 1d 80 00 00 	movabs $0x801d4f,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d9:	79 02                	jns    8026dd <dup+0x11d>
			goto err;
  8026db:	eb 57                	jmp    802734 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e1:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e5:	48 89 c2             	mov    %rax,%rdx
  8026e8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ef:	01 00 00 
  8026f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8026fb:	89 c1                	mov    %eax,%ecx
  8026fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802701:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802705:	41 89 c8             	mov    %ecx,%r8d
  802708:	48 89 d1             	mov    %rdx,%rcx
  80270b:	ba 00 00 00 00       	mov    $0x0,%edx
  802710:	48 89 c6             	mov    %rax,%rsi
  802713:	bf 00 00 00 00       	mov    $0x0,%edi
  802718:	48 b8 4f 1d 80 00 00 	movabs $0x801d4f,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
  802724:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802727:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272b:	79 02                	jns    80272f <dup+0x16f>
		goto err;
  80272d:	eb 05                	jmp    802734 <dup+0x174>

	return newfdnum;
  80272f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802732:	eb 33                	jmp    802767 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802738:	48 89 c6             	mov    %rax,%rsi
  80273b:	bf 00 00 00 00       	mov    $0x0,%edi
  802740:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80274c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802750:	48 89 c6             	mov    %rax,%rsi
  802753:	bf 00 00 00 00       	mov    $0x0,%edi
  802758:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
	return r;
  802764:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 40          	sub    $0x40,%rsp
  802771:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802774:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802778:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80277c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802780:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802783:	48 89 d6             	mov    %rdx,%rsi
  802786:	89 c7                	mov    %eax,%edi
  802788:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  80278f:	00 00 00 
  802792:	ff d0                	callq  *%rax
  802794:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802797:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279b:	78 24                	js     8027c1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80279d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a1:	8b 00                	mov    (%rax),%eax
  8027a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a7:	48 89 d6             	mov    %rdx,%rsi
  8027aa:	89 c7                	mov    %eax,%edi
  8027ac:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
  8027b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bf:	79 05                	jns    8027c6 <read+0x5d>
		return r;
  8027c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c4:	eb 76                	jmp    80283c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ca:	8b 40 08             	mov    0x8(%rax),%eax
  8027cd:	83 e0 03             	and    $0x3,%eax
  8027d0:	83 f8 01             	cmp    $0x1,%eax
  8027d3:	75 3a                	jne    80280f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027d5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8027dc:	00 00 00 
  8027df:	48 8b 00             	mov    (%rax),%rax
  8027e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027eb:	89 c6                	mov    %eax,%esi
  8027ed:	48 bf 77 46 80 00 00 	movabs $0x804677,%rdi
  8027f4:	00 00 00 
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	48 b9 08 08 80 00 00 	movabs $0x800808,%rcx
  802803:	00 00 00 
  802806:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80280d:	eb 2d                	jmp    80283c <read+0xd3>
	}
	if (!dev->dev_read)
  80280f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802813:	48 8b 40 10          	mov    0x10(%rax),%rax
  802817:	48 85 c0             	test   %rax,%rax
  80281a:	75 07                	jne    802823 <read+0xba>
		return -E_NOT_SUPP;
  80281c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802821:	eb 19                	jmp    80283c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802827:	48 8b 40 10          	mov    0x10(%rax),%rax
  80282b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80282f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802833:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802837:	48 89 cf             	mov    %rcx,%rdi
  80283a:	ff d0                	callq  *%rax
}
  80283c:	c9                   	leaveq 
  80283d:	c3                   	retq   

000000000080283e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80283e:	55                   	push   %rbp
  80283f:	48 89 e5             	mov    %rsp,%rbp
  802842:	48 83 ec 30          	sub    $0x30,%rsp
  802846:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802849:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80284d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802851:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802858:	eb 49                	jmp    8028a3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80285a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285d:	48 98                	cltq   
  80285f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802863:	48 29 c2             	sub    %rax,%rdx
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	48 63 c8             	movslq %eax,%rcx
  80286c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802870:	48 01 c1             	add    %rax,%rcx
  802873:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802876:	48 89 ce             	mov    %rcx,%rsi
  802879:	89 c7                	mov    %eax,%edi
  80287b:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80288a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80288e:	79 05                	jns    802895 <readn+0x57>
			return m;
  802890:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802893:	eb 1c                	jmp    8028b1 <readn+0x73>
		if (m == 0)
  802895:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802899:	75 02                	jne    80289d <readn+0x5f>
			break;
  80289b:	eb 11                	jmp    8028ae <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80289d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028a0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a6:	48 98                	cltq   
  8028a8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028ac:	72 ac                	jb     80285a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8028ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b1:	c9                   	leaveq 
  8028b2:	c3                   	retq   

00000000008028b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028b3:	55                   	push   %rbp
  8028b4:	48 89 e5             	mov    %rsp,%rbp
  8028b7:	48 83 ec 40          	sub    $0x40,%rsp
  8028bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028cd:	48 89 d6             	mov    %rdx,%rsi
  8028d0:	89 c7                	mov    %eax,%edi
  8028d2:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e5:	78 24                	js     80290b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028eb:	8b 00                	mov    (%rax),%eax
  8028ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f1:	48 89 d6             	mov    %rdx,%rsi
  8028f4:	89 c7                	mov    %eax,%edi
  8028f6:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
  802902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802909:	79 05                	jns    802910 <write+0x5d>
		return r;
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	eb 75                	jmp    802985 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802914:	8b 40 08             	mov    0x8(%rax),%eax
  802917:	83 e0 03             	and    $0x3,%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	75 3a                	jne    802958 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80291e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802925:	00 00 00 
  802928:	48 8b 00             	mov    (%rax),%rax
  80292b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802931:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802934:	89 c6                	mov    %eax,%esi
  802936:	48 bf 93 46 80 00 00 	movabs $0x804693,%rdi
  80293d:	00 00 00 
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
  802945:	48 b9 08 08 80 00 00 	movabs $0x800808,%rcx
  80294c:	00 00 00 
  80294f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802951:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802956:	eb 2d                	jmp    802985 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802960:	48 85 c0             	test   %rax,%rax
  802963:	75 07                	jne    80296c <write+0xb9>
		return -E_NOT_SUPP;
  802965:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296a:	eb 19                	jmp    802985 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80296c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802970:	48 8b 40 18          	mov    0x18(%rax),%rax
  802974:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802978:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80297c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802980:	48 89 cf             	mov    %rcx,%rdi
  802983:	ff d0                	callq  *%rax
}
  802985:	c9                   	leaveq 
  802986:	c3                   	retq   

0000000000802987 <seek>:

int
seek(int fdnum, off_t offset)
{
  802987:	55                   	push   %rbp
  802988:	48 89 e5             	mov    %rsp,%rbp
  80298b:	48 83 ec 18          	sub    $0x18,%rsp
  80298f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802992:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802995:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802999:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80299c:	48 89 d6             	mov    %rdx,%rsi
  80299f:	89 c7                	mov    %eax,%edi
  8029a1:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b4:	79 05                	jns    8029bb <seek+0x34>
		return r;
  8029b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b9:	eb 0f                	jmp    8029ca <seek+0x43>
	fd->fd_offset = offset;
  8029bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ca:	c9                   	leaveq 
  8029cb:	c3                   	retq   

00000000008029cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 30          	sub    $0x30,%rsp
  8029d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029d7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029e1:	48 89 d6             	mov    %rdx,%rsi
  8029e4:	89 c7                	mov    %eax,%edi
  8029e6:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
  8029f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f9:	78 24                	js     802a1f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ff:	8b 00                	mov    (%rax),%eax
  802a01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a05:	48 89 d6             	mov    %rdx,%rsi
  802a08:	89 c7                	mov    %eax,%edi
  802a0a:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
  802a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1d:	79 05                	jns    802a24 <ftruncate+0x58>
		return r;
  802a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a22:	eb 72                	jmp    802a96 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a28:	8b 40 08             	mov    0x8(%rax),%eax
  802a2b:	83 e0 03             	and    $0x3,%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	75 3a                	jne    802a6c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a32:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802a39:	00 00 00 
  802a3c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a3f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a45:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a48:	89 c6                	mov    %eax,%esi
  802a4a:	48 bf b0 46 80 00 00 	movabs $0x8046b0,%rdi
  802a51:	00 00 00 
  802a54:	b8 00 00 00 00       	mov    $0x0,%eax
  802a59:	48 b9 08 08 80 00 00 	movabs $0x800808,%rcx
  802a60:	00 00 00 
  802a63:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a6a:	eb 2a                	jmp    802a96 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a70:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a74:	48 85 c0             	test   %rax,%rax
  802a77:	75 07                	jne    802a80 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a79:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a7e:	eb 16                	jmp    802a96 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a84:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a8c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a8f:	89 ce                	mov    %ecx,%esi
  802a91:	48 89 d7             	mov    %rdx,%rdi
  802a94:	ff d0                	callq  *%rax
}
  802a96:	c9                   	leaveq 
  802a97:	c3                   	retq   

0000000000802a98 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a98:	55                   	push   %rbp
  802a99:	48 89 e5             	mov    %rsp,%rbp
  802a9c:	48 83 ec 30          	sub    $0x30,%rsp
  802aa0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aa3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aae:	48 89 d6             	mov    %rdx,%rsi
  802ab1:	89 c7                	mov    %eax,%edi
  802ab3:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  802aba:	00 00 00 
  802abd:	ff d0                	callq  *%rax
  802abf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac6:	78 24                	js     802aec <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acc:	8b 00                	mov    (%rax),%eax
  802ace:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad2:	48 89 d6             	mov    %rdx,%rsi
  802ad5:	89 c7                	mov    %eax,%edi
  802ad7:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	callq  *%rax
  802ae3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aea:	79 05                	jns    802af1 <fstat+0x59>
		return r;
  802aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aef:	eb 5e                	jmp    802b4f <fstat+0xb7>
	if (!dev->dev_stat)
  802af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802af9:	48 85 c0             	test   %rax,%rax
  802afc:	75 07                	jne    802b05 <fstat+0x6d>
		return -E_NOT_SUPP;
  802afe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b03:	eb 4a                	jmp    802b4f <fstat+0xb7>
	stat->st_name[0] = 0;
  802b05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b09:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b10:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b17:	00 00 00 
	stat->st_isdir = 0;
  802b1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b1e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b25:	00 00 00 
	stat->st_dev = dev;
  802b28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b30:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b43:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b47:	48 89 ce             	mov    %rcx,%rsi
  802b4a:	48 89 d7             	mov    %rdx,%rdi
  802b4d:	ff d0                	callq  *%rax
}
  802b4f:	c9                   	leaveq 
  802b50:	c3                   	retq   

0000000000802b51 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b51:	55                   	push   %rbp
  802b52:	48 89 e5             	mov    %rsp,%rbp
  802b55:	48 83 ec 20          	sub    $0x20,%rsp
  802b59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b65:	be 00 00 00 00       	mov    $0x0,%esi
  802b6a:	48 89 c7             	mov    %rax,%rdi
  802b6d:	48 b8 3f 2c 80 00 00 	movabs $0x802c3f,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
  802b79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b80:	79 05                	jns    802b87 <stat+0x36>
		return fd;
  802b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b85:	eb 2f                	jmp    802bb6 <stat+0x65>
	r = fstat(fd, stat);
  802b87:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8e:	48 89 d6             	mov    %rdx,%rsi
  802b91:	89 c7                	mov    %eax,%edi
  802b93:	48 b8 98 2a 80 00 00 	movabs $0x802a98,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
  802b9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba5:	89 c7                	mov    %eax,%edi
  802ba7:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
	return r;
  802bb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bb6:	c9                   	leaveq 
  802bb7:	c3                   	retq   

0000000000802bb8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bb8:	55                   	push   %rbp
  802bb9:	48 89 e5             	mov    %rsp,%rbp
  802bbc:	48 83 ec 10          	sub    $0x10,%rsp
  802bc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bc7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bce:	00 00 00 
  802bd1:	8b 00                	mov    (%rax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	75 1d                	jne    802bf4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bd7:	bf 01 00 00 00       	mov    $0x1,%edi
  802bdc:	48 b8 73 3f 80 00 00 	movabs $0x803f73,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
  802be8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802bef:	00 00 00 
  802bf2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bf4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bfb:	00 00 00 
  802bfe:	8b 00                	mov    (%rax),%eax
  802c00:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c03:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c08:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c0f:	00 00 00 
  802c12:	89 c7                	mov    %eax,%edi
  802c14:	48 b8 db 3e 80 00 00 	movabs $0x803edb,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c24:	ba 00 00 00 00       	mov    $0x0,%edx
  802c29:	48 89 c6             	mov    %rax,%rsi
  802c2c:	bf 00 00 00 00       	mov    $0x0,%edi
  802c31:	48 b8 1a 3e 80 00 00 	movabs $0x803e1a,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
}
  802c3d:	c9                   	leaveq 
  802c3e:	c3                   	retq   

0000000000802c3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c3f:	55                   	push   %rbp
  802c40:	48 89 e5             	mov    %rsp,%rbp
  802c43:	48 83 ec 20          	sub    $0x20,%rsp
  802c47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c4b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c52:	48 89 c7             	mov    %rax,%rdi
  802c55:	48 b8 64 13 80 00 00 	movabs $0x801364,%rax
  802c5c:	00 00 00 
  802c5f:	ff d0                	callq  *%rax
  802c61:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c66:	7e 0a                	jle    802c72 <open+0x33>
		return -E_BAD_PATH;
  802c68:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c6d:	e9 a5 00 00 00       	jmpq   802d17 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c72:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c76:	48 89 c7             	mov    %rax,%rdi
  802c79:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8c:	79 08                	jns    802c96 <open+0x57>
		return r;
  802c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c91:	e9 81 00 00 00       	jmpq   802d17 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9a:	48 89 c6             	mov    %rax,%rsi
  802c9d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ca4:	00 00 00 
  802ca7:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802cb3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cba:	00 00 00 
  802cbd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cc0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cca:	48 89 c6             	mov    %rax,%rsi
  802ccd:	bf 01 00 00 00       	mov    $0x1,%edi
  802cd2:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
  802cde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce5:	79 1d                	jns    802d04 <open+0xc5>
		fd_close(fd, 0);
  802ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ceb:	be 00 00 00 00       	mov    $0x0,%esi
  802cf0:	48 89 c7             	mov    %rax,%rdi
  802cf3:	48 b8 c7 23 80 00 00 	movabs $0x8023c7,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
		return r;
  802cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d02:	eb 13                	jmp    802d17 <open+0xd8>
	}

	return fd2num(fd);
  802d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d08:	48 89 c7             	mov    %rax,%rdi
  802d0b:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802d17:	c9                   	leaveq 
  802d18:	c3                   	retq   

0000000000802d19 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d19:	55                   	push   %rbp
  802d1a:	48 89 e5             	mov    %rsp,%rbp
  802d1d:	48 83 ec 10          	sub    $0x10,%rsp
  802d21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d29:	8b 50 0c             	mov    0xc(%rax),%edx
  802d2c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d33:	00 00 00 
  802d36:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d38:	be 00 00 00 00       	mov    $0x0,%esi
  802d3d:	bf 06 00 00 00       	mov    $0x6,%edi
  802d42:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
}
  802d4e:	c9                   	leaveq 
  802d4f:	c3                   	retq   

0000000000802d50 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d50:	55                   	push   %rbp
  802d51:	48 89 e5             	mov    %rsp,%rbp
  802d54:	48 83 ec 30          	sub    $0x30,%rsp
  802d58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d68:	8b 50 0c             	mov    0xc(%rax),%edx
  802d6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d72:	00 00 00 
  802d75:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d7e:	00 00 00 
  802d81:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d85:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d89:	be 00 00 00 00       	mov    $0x0,%esi
  802d8e:	bf 03 00 00 00       	mov    $0x3,%edi
  802d93:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
  802d9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da6:	79 08                	jns    802db0 <devfile_read+0x60>
		return r;
  802da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dab:	e9 a4 00 00 00       	jmpq   802e54 <devfile_read+0x104>
	assert(r <= n);
  802db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db3:	48 98                	cltq   
  802db5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802db9:	76 35                	jbe    802df0 <devfile_read+0xa0>
  802dbb:	48 b9 dd 46 80 00 00 	movabs $0x8046dd,%rcx
  802dc2:	00 00 00 
  802dc5:	48 ba e4 46 80 00 00 	movabs $0x8046e4,%rdx
  802dcc:	00 00 00 
  802dcf:	be 84 00 00 00       	mov    $0x84,%esi
  802dd4:	48 bf f9 46 80 00 00 	movabs $0x8046f9,%rdi
  802ddb:	00 00 00 
  802dde:	b8 00 00 00 00       	mov    $0x0,%eax
  802de3:	49 b8 cf 05 80 00 00 	movabs $0x8005cf,%r8
  802dea:	00 00 00 
  802ded:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802df0:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802df7:	7e 35                	jle    802e2e <devfile_read+0xde>
  802df9:	48 b9 04 47 80 00 00 	movabs $0x804704,%rcx
  802e00:	00 00 00 
  802e03:	48 ba e4 46 80 00 00 	movabs $0x8046e4,%rdx
  802e0a:	00 00 00 
  802e0d:	be 85 00 00 00       	mov    $0x85,%esi
  802e12:	48 bf f9 46 80 00 00 	movabs $0x8046f9,%rdi
  802e19:	00 00 00 
  802e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e21:	49 b8 cf 05 80 00 00 	movabs $0x8005cf,%r8
  802e28:	00 00 00 
  802e2b:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e31:	48 63 d0             	movslq %eax,%rdx
  802e34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e38:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e3f:	00 00 00 
  802e42:	48 89 c7             	mov    %rax,%rdi
  802e45:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
	return r;
  802e51:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802e54:	c9                   	leaveq 
  802e55:	c3                   	retq   

0000000000802e56 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e56:	55                   	push   %rbp
  802e57:	48 89 e5             	mov    %rsp,%rbp
  802e5a:	48 83 ec 30          	sub    $0x30,%rsp
  802e5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e66:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6e:	8b 50 0c             	mov    0xc(%rax),%edx
  802e71:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e78:	00 00 00 
  802e7b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e7d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e84:	00 00 00 
  802e87:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e8b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802e8f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e96:	00 
  802e97:	76 35                	jbe    802ece <devfile_write+0x78>
  802e99:	48 b9 10 47 80 00 00 	movabs $0x804710,%rcx
  802ea0:	00 00 00 
  802ea3:	48 ba e4 46 80 00 00 	movabs $0x8046e4,%rdx
  802eaa:	00 00 00 
  802ead:	be 9e 00 00 00       	mov    $0x9e,%esi
  802eb2:	48 bf f9 46 80 00 00 	movabs $0x8046f9,%rdi
  802eb9:	00 00 00 
  802ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec1:	49 b8 cf 05 80 00 00 	movabs $0x8005cf,%r8
  802ec8:	00 00 00 
  802ecb:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802ece:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ed2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed6:	48 89 c6             	mov    %rax,%rsi
  802ed9:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ee0:	00 00 00 
  802ee3:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802eef:	be 00 00 00 00       	mov    $0x0,%esi
  802ef4:	bf 04 00 00 00       	mov    $0x4,%edi
  802ef9:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
  802f05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0c:	79 05                	jns    802f13 <devfile_write+0xbd>
		return r;
  802f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f11:	eb 43                	jmp    802f56 <devfile_write+0x100>
	assert(r <= n);
  802f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f16:	48 98                	cltq   
  802f18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f1c:	76 35                	jbe    802f53 <devfile_write+0xfd>
  802f1e:	48 b9 dd 46 80 00 00 	movabs $0x8046dd,%rcx
  802f25:	00 00 00 
  802f28:	48 ba e4 46 80 00 00 	movabs $0x8046e4,%rdx
  802f2f:	00 00 00 
  802f32:	be a2 00 00 00       	mov    $0xa2,%esi
  802f37:	48 bf f9 46 80 00 00 	movabs $0x8046f9,%rdi
  802f3e:	00 00 00 
  802f41:	b8 00 00 00 00       	mov    $0x0,%eax
  802f46:	49 b8 cf 05 80 00 00 	movabs $0x8005cf,%r8
  802f4d:	00 00 00 
  802f50:	41 ff d0             	callq  *%r8
	return r;
  802f53:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802f56:	c9                   	leaveq 
  802f57:	c3                   	retq   

0000000000802f58 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f58:	55                   	push   %rbp
  802f59:	48 89 e5             	mov    %rsp,%rbp
  802f5c:	48 83 ec 20          	sub    $0x20,%rsp
  802f60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6c:	8b 50 0c             	mov    0xc(%rax),%edx
  802f6f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f76:	00 00 00 
  802f79:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f7b:	be 00 00 00 00       	mov    $0x0,%esi
  802f80:	bf 05 00 00 00       	mov    $0x5,%edi
  802f85:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  802f8c:	00 00 00 
  802f8f:	ff d0                	callq  *%rax
  802f91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f98:	79 05                	jns    802f9f <devfile_stat+0x47>
		return r;
  802f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9d:	eb 56                	jmp    802ff5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802faa:	00 00 00 
  802fad:	48 89 c7             	mov    %rax,%rdi
  802fb0:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fbc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fc3:	00 00 00 
  802fc6:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fd6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fdd:	00 00 00 
  802fe0:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fea:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 10          	sub    $0x10,%rsp
  802fff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803003:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803006:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300a:	8b 50 0c             	mov    0xc(%rax),%edx
  80300d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803014:	00 00 00 
  803017:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803019:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803020:	00 00 00 
  803023:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803026:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803029:	be 00 00 00 00       	mov    $0x0,%esi
  80302e:	bf 02 00 00 00       	mov    $0x2,%edi
  803033:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  80303a:	00 00 00 
  80303d:	ff d0                	callq  *%rax
}
  80303f:	c9                   	leaveq 
  803040:	c3                   	retq   

0000000000803041 <remove>:

// Delete a file
int
remove(const char *path)
{
  803041:	55                   	push   %rbp
  803042:	48 89 e5             	mov    %rsp,%rbp
  803045:	48 83 ec 10          	sub    $0x10,%rsp
  803049:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80304d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803051:	48 89 c7             	mov    %rax,%rdi
  803054:	48 b8 64 13 80 00 00 	movabs $0x801364,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
  803060:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803065:	7e 07                	jle    80306e <remove+0x2d>
		return -E_BAD_PATH;
  803067:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80306c:	eb 33                	jmp    8030a1 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80306e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803072:	48 89 c6             	mov    %rax,%rsi
  803075:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80307c:	00 00 00 
  80307f:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80308b:	be 00 00 00 00       	mov    $0x0,%esi
  803090:	bf 07 00 00 00       	mov    $0x7,%edi
  803095:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
}
  8030a1:	c9                   	leaveq 
  8030a2:	c3                   	retq   

00000000008030a3 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030a3:	55                   	push   %rbp
  8030a4:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030a7:	be 00 00 00 00       	mov    $0x0,%esi
  8030ac:	bf 08 00 00 00       	mov    $0x8,%edi
  8030b1:	48 b8 b8 2b 80 00 00 	movabs $0x802bb8,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
}
  8030bd:	5d                   	pop    %rbp
  8030be:	c3                   	retq   

00000000008030bf <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8030bf:	55                   	push   %rbp
  8030c0:	48 89 e5             	mov    %rsp,%rbp
  8030c3:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8030ca:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8030d1:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8030d8:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8030df:	be 00 00 00 00       	mov    $0x0,%esi
  8030e4:	48 89 c7             	mov    %rax,%rdi
  8030e7:	48 b8 3f 2c 80 00 00 	movabs $0x802c3f,%rax
  8030ee:	00 00 00 
  8030f1:	ff d0                	callq  *%rax
  8030f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8030f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fa:	79 28                	jns    803124 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8030fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ff:	89 c6                	mov    %eax,%esi
  803101:	48 bf 3d 47 80 00 00 	movabs $0x80473d,%rdi
  803108:	00 00 00 
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	48 ba 08 08 80 00 00 	movabs $0x800808,%rdx
  803117:	00 00 00 
  80311a:	ff d2                	callq  *%rdx
		return fd_src;
  80311c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311f:	e9 74 01 00 00       	jmpq   803298 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803124:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80312b:	be 01 01 00 00       	mov    $0x101,%esi
  803130:	48 89 c7             	mov    %rax,%rdi
  803133:	48 b8 3f 2c 80 00 00 	movabs $0x802c3f,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803142:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803146:	79 39                	jns    803181 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803148:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314b:	89 c6                	mov    %eax,%esi
  80314d:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  803154:	00 00 00 
  803157:	b8 00 00 00 00       	mov    $0x0,%eax
  80315c:	48 ba 08 08 80 00 00 	movabs $0x800808,%rdx
  803163:	00 00 00 
  803166:	ff d2                	callq  *%rdx
		close(fd_src);
  803168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316b:	89 c7                	mov    %eax,%edi
  80316d:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  803174:	00 00 00 
  803177:	ff d0                	callq  *%rax
		return fd_dest;
  803179:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80317c:	e9 17 01 00 00       	jmpq   803298 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803181:	eb 74                	jmp    8031f7 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803183:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803186:	48 63 d0             	movslq %eax,%rdx
  803189:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803190:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803193:	48 89 ce             	mov    %rcx,%rsi
  803196:	89 c7                	mov    %eax,%edi
  803198:	48 b8 b3 28 80 00 00 	movabs $0x8028b3,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
  8031a4:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8031a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8031ab:	79 4a                	jns    8031f7 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8031ad:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031b0:	89 c6                	mov    %eax,%esi
  8031b2:	48 bf 6d 47 80 00 00 	movabs $0x80476d,%rdi
  8031b9:	00 00 00 
  8031bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c1:	48 ba 08 08 80 00 00 	movabs $0x800808,%rdx
  8031c8:	00 00 00 
  8031cb:	ff d2                	callq  *%rdx
			close(fd_src);
  8031cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
			close(fd_dest);
  8031de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e1:	89 c7                	mov    %eax,%edi
  8031e3:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
			return write_size;
  8031ef:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031f2:	e9 a1 00 00 00       	jmpq   803298 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031f7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803201:	ba 00 02 00 00       	mov    $0x200,%edx
  803206:	48 89 ce             	mov    %rcx,%rsi
  803209:	89 c7                	mov    %eax,%edi
  80320b:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
  803217:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80321a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80321e:	0f 8f 5f ff ff ff    	jg     803183 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  803224:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803228:	79 47                	jns    803271 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80322a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80322d:	89 c6                	mov    %eax,%esi
  80322f:	48 bf 80 47 80 00 00 	movabs $0x804780,%rdi
  803236:	00 00 00 
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
  80323e:	48 ba 08 08 80 00 00 	movabs $0x800808,%rdx
  803245:	00 00 00 
  803248:	ff d2                	callq  *%rdx
		close(fd_src);
  80324a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324d:	89 c7                	mov    %eax,%edi
  80324f:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
		close(fd_dest);
  80325b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80325e:	89 c7                	mov    %eax,%edi
  803260:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  803267:	00 00 00 
  80326a:	ff d0                	callq  *%rax
		return read_size;
  80326c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80326f:	eb 27                	jmp    803298 <copy+0x1d9>
	}
	close(fd_src);
  803271:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803274:	89 c7                	mov    %eax,%edi
  803276:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
	close(fd_dest);
  803282:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803285:	89 c7                	mov    %eax,%edi
  803287:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
	return 0;
  803293:	b8 00 00 00 00       	mov    $0x0,%eax

}
  803298:	c9                   	leaveq 
  803299:	c3                   	retq   

000000000080329a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80329a:	55                   	push   %rbp
  80329b:	48 89 e5             	mov    %rsp,%rbp
  80329e:	48 83 ec 20          	sub    $0x20,%rsp
  8032a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8032a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032aa:	8b 40 0c             	mov    0xc(%rax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	7e 67                	jle    803318 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8032b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b5:	8b 40 04             	mov    0x4(%rax),%eax
  8032b8:	48 63 d0             	movslq %eax,%rdx
  8032bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bf:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8032c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c7:	8b 00                	mov    (%rax),%eax
  8032c9:	48 89 ce             	mov    %rcx,%rsi
  8032cc:	89 c7                	mov    %eax,%edi
  8032ce:	48 b8 b3 28 80 00 00 	movabs $0x8028b3,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8032dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e1:	7e 13                	jle    8032f6 <writebuf+0x5c>
			b->result += result;
  8032e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e7:	8b 50 08             	mov    0x8(%rax),%edx
  8032ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ed:	01 c2                	add    %eax,%edx
  8032ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f3:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8032f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fa:	8b 40 04             	mov    0x4(%rax),%eax
  8032fd:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803300:	74 16                	je     803318 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803302:	b8 00 00 00 00       	mov    $0x0,%eax
  803307:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330b:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80330f:	89 c2                	mov    %eax,%edx
  803311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803315:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803318:	c9                   	leaveq 
  803319:	c3                   	retq   

000000000080331a <putch>:

static void
putch(int ch, void *thunk)
{
  80331a:	55                   	push   %rbp
  80331b:	48 89 e5             	mov    %rsp,%rbp
  80331e:	48 83 ec 20          	sub    $0x20,%rsp
  803322:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803325:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803329:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803335:	8b 40 04             	mov    0x4(%rax),%eax
  803338:	8d 48 01             	lea    0x1(%rax),%ecx
  80333b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80333f:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803342:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803345:	89 d1                	mov    %edx,%ecx
  803347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80334b:	48 98                	cltq   
  80334d:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803355:	8b 40 04             	mov    0x4(%rax),%eax
  803358:	3d 00 01 00 00       	cmp    $0x100,%eax
  80335d:	75 1e                	jne    80337d <putch+0x63>
		writebuf(b);
  80335f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803363:	48 89 c7             	mov    %rax,%rdi
  803366:	48 b8 9a 32 80 00 00 	movabs $0x80329a,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
		b->idx = 0;
  803372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803376:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80337d:	c9                   	leaveq 
  80337e:	c3                   	retq   

000000000080337f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80337f:	55                   	push   %rbp
  803380:	48 89 e5             	mov    %rsp,%rbp
  803383:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80338a:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803390:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803397:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80339e:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8033a4:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8033aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8033b1:	00 00 00 
	b.result = 0;
  8033b4:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8033bb:	00 00 00 
	b.error = 1;
  8033be:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8033c5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8033c8:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8033cf:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8033d6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8033dd:	48 89 c6             	mov    %rax,%rsi
  8033e0:	48 bf 1a 33 80 00 00 	movabs $0x80331a,%rdi
  8033e7:	00 00 00 
  8033ea:	48 b8 bb 0b 80 00 00 	movabs $0x800bbb,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8033f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	7e 16                	jle    803416 <vfprintf+0x97>
		writebuf(&b);
  803400:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803407:	48 89 c7             	mov    %rax,%rdi
  80340a:	48 b8 9a 32 80 00 00 	movabs $0x80329a,%rax
  803411:	00 00 00 
  803414:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803416:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 08                	je     803428 <vfprintf+0xa9>
  803420:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803426:	eb 06                	jmp    80342e <vfprintf+0xaf>
  803428:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80342e:	c9                   	leaveq 
  80342f:	c3                   	retq   

0000000000803430 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803430:	55                   	push   %rbp
  803431:	48 89 e5             	mov    %rsp,%rbp
  803434:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80343b:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803441:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803448:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80344f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803456:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80345d:	84 c0                	test   %al,%al
  80345f:	74 20                	je     803481 <fprintf+0x51>
  803461:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803465:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803469:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80346d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803471:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803475:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803479:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80347d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803481:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803488:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80348f:	00 00 00 
  803492:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803499:	00 00 00 
  80349c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8034a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8034a7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8034ae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8034b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8034bc:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8034c3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8034c9:	48 89 ce             	mov    %rcx,%rsi
  8034cc:	89 c7                	mov    %eax,%edi
  8034ce:	48 b8 7f 33 80 00 00 	movabs $0x80337f,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
  8034da:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8034e0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034e6:	c9                   	leaveq 
  8034e7:	c3                   	retq   

00000000008034e8 <printf>:

int
printf(const char *fmt, ...)
{
  8034e8:	55                   	push   %rbp
  8034e9:	48 89 e5             	mov    %rsp,%rbp
  8034ec:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8034f3:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8034fa:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803501:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803508:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80350f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803516:	84 c0                	test   %al,%al
  803518:	74 20                	je     80353a <printf+0x52>
  80351a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80351e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803522:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803526:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80352a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80352e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803532:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803536:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80353a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803541:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803548:	00 00 00 
  80354b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803552:	00 00 00 
  803555:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803559:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803560:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803567:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80356e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803575:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80357c:	48 89 c6             	mov    %rax,%rsi
  80357f:	bf 01 00 00 00       	mov    $0x1,%edi
  803584:	48 b8 7f 33 80 00 00 	movabs $0x80337f,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
  803590:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803596:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80359c:	c9                   	leaveq 
  80359d:	c3                   	retq   

000000000080359e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80359e:	55                   	push   %rbp
  80359f:	48 89 e5             	mov    %rsp,%rbp
  8035a2:	53                   	push   %rbx
  8035a3:	48 83 ec 38          	sub    $0x38,%rsp
  8035a7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035ab:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035af:	48 89 c7             	mov    %rax,%rdi
  8035b2:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  8035b9:	00 00 00 
  8035bc:	ff d0                	callq  *%rax
  8035be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035c5:	0f 88 bf 01 00 00    	js     80378a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035cf:	ba 07 04 00 00       	mov    $0x407,%edx
  8035d4:	48 89 c6             	mov    %rax,%rsi
  8035d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035dc:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
  8035e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035ef:	0f 88 95 01 00 00    	js     80378a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035f5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035f9:	48 89 c7             	mov    %rax,%rdi
  8035fc:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80360b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80360f:	0f 88 5d 01 00 00    	js     803772 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803615:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803619:	ba 07 04 00 00       	mov    $0x407,%edx
  80361e:	48 89 c6             	mov    %rax,%rsi
  803621:	bf 00 00 00 00       	mov    $0x0,%edi
  803626:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
  803632:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803635:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803639:	0f 88 33 01 00 00    	js     803772 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80363f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803643:	48 89 c7             	mov    %rax,%rdi
  803646:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
  803652:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803656:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80365a:	ba 07 04 00 00       	mov    $0x407,%edx
  80365f:	48 89 c6             	mov    %rax,%rsi
  803662:	bf 00 00 00 00       	mov    $0x0,%edi
  803667:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
  803673:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803676:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80367a:	79 05                	jns    803681 <pipe+0xe3>
		goto err2;
  80367c:	e9 d9 00 00 00       	jmpq   80375a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803681:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803685:	48 89 c7             	mov    %rax,%rdi
  803688:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
  803694:	48 89 c2             	mov    %rax,%rdx
  803697:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80369b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036a1:	48 89 d1             	mov    %rdx,%rcx
  8036a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8036a9:	48 89 c6             	mov    %rax,%rsi
  8036ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8036b1:	48 b8 4f 1d 80 00 00 	movabs $0x801d4f,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
  8036bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c4:	79 1b                	jns    8036e1 <pipe+0x143>
		goto err3;
  8036c6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036cb:	48 89 c6             	mov    %rax,%rsi
  8036ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d3:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	eb 79                	jmp    80375a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e5:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8036ec:	00 00 00 
  8036ef:	8b 12                	mov    (%rdx),%edx
  8036f1:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803702:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803709:	00 00 00 
  80370c:	8b 12                	mov    (%rdx),%edx
  80370e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803710:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803714:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80371b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371f:	48 89 c7             	mov    %rax,%rdi
  803722:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  803729:	00 00 00 
  80372c:	ff d0                	callq  *%rax
  80372e:	89 c2                	mov    %eax,%edx
  803730:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803734:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803736:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80373a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80373e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803742:	48 89 c7             	mov    %rax,%rdi
  803745:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
  803751:	89 03                	mov    %eax,(%rbx)
	return 0;
  803753:	b8 00 00 00 00       	mov    $0x0,%eax
  803758:	eb 33                	jmp    80378d <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80375a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375e:	48 89 c6             	mov    %rax,%rsi
  803761:	bf 00 00 00 00       	mov    $0x0,%edi
  803766:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803776:	48 89 c6             	mov    %rax,%rsi
  803779:	bf 00 00 00 00       	mov    $0x0,%edi
  80377e:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
err:
	return r;
  80378a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80378d:	48 83 c4 38          	add    $0x38,%rsp
  803791:	5b                   	pop    %rbx
  803792:	5d                   	pop    %rbp
  803793:	c3                   	retq   

0000000000803794 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803794:	55                   	push   %rbp
  803795:	48 89 e5             	mov    %rsp,%rbp
  803798:	53                   	push   %rbx
  803799:	48 83 ec 28          	sub    $0x28,%rsp
  80379d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037a5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8037ac:	00 00 00 
  8037af:	48 8b 00             	mov    (%rax),%rax
  8037b2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037bf:	48 89 c7             	mov    %rax,%rdi
  8037c2:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
  8037ce:	89 c3                	mov    %eax,%ebx
  8037d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d4:	48 89 c7             	mov    %rax,%rdi
  8037d7:	48 b8 f5 3f 80 00 00 	movabs $0x803ff5,%rax
  8037de:	00 00 00 
  8037e1:	ff d0                	callq  *%rax
  8037e3:	39 c3                	cmp    %eax,%ebx
  8037e5:	0f 94 c0             	sete   %al
  8037e8:	0f b6 c0             	movzbl %al,%eax
  8037eb:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037ee:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8037f5:	00 00 00 
  8037f8:	48 8b 00             	mov    (%rax),%rax
  8037fb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803801:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803804:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803807:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80380a:	75 05                	jne    803811 <_pipeisclosed+0x7d>
			return ret;
  80380c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80380f:	eb 4f                	jmp    803860 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803811:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803814:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803817:	74 42                	je     80385b <_pipeisclosed+0xc7>
  803819:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80381d:	75 3c                	jne    80385b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80381f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803826:	00 00 00 
  803829:	48 8b 00             	mov    (%rax),%rax
  80382c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803832:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803835:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803838:	89 c6                	mov    %eax,%esi
  80383a:	48 bf 9b 47 80 00 00 	movabs $0x80479b,%rdi
  803841:	00 00 00 
  803844:	b8 00 00 00 00       	mov    $0x0,%eax
  803849:	49 b8 08 08 80 00 00 	movabs $0x800808,%r8
  803850:	00 00 00 
  803853:	41 ff d0             	callq  *%r8
	}
  803856:	e9 4a ff ff ff       	jmpq   8037a5 <_pipeisclosed+0x11>
  80385b:	e9 45 ff ff ff       	jmpq   8037a5 <_pipeisclosed+0x11>
}
  803860:	48 83 c4 28          	add    $0x28,%rsp
  803864:	5b                   	pop    %rbx
  803865:	5d                   	pop    %rbp
  803866:	c3                   	retq   

0000000000803867 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803867:	55                   	push   %rbp
  803868:	48 89 e5             	mov    %rsp,%rbp
  80386b:	48 83 ec 30          	sub    $0x30,%rsp
  80386f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803872:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803876:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803879:	48 89 d6             	mov    %rdx,%rsi
  80387c:	89 c7                	mov    %eax,%edi
  80387e:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  803885:	00 00 00 
  803888:	ff d0                	callq  *%rax
  80388a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803891:	79 05                	jns    803898 <pipeisclosed+0x31>
		return r;
  803893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803896:	eb 31                	jmp    8038c9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389c:	48 89 c7             	mov    %rax,%rdi
  80389f:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
  8038ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b7:	48 89 d6             	mov    %rdx,%rsi
  8038ba:	48 89 c7             	mov    %rax,%rdi
  8038bd:	48 b8 94 37 80 00 00 	movabs $0x803794,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
}
  8038c9:	c9                   	leaveq 
  8038ca:	c3                   	retq   

00000000008038cb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038cb:	55                   	push   %rbp
  8038cc:	48 89 e5             	mov    %rsp,%rbp
  8038cf:	48 83 ec 40          	sub    $0x40,%rsp
  8038d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038db:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e3:	48 89 c7             	mov    %rax,%rdi
  8038e6:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8038ed:	00 00 00 
  8038f0:	ff d0                	callq  *%rax
  8038f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038fe:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803905:	00 
  803906:	e9 92 00 00 00       	jmpq   80399d <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80390b:	eb 41                	jmp    80394e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80390d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803912:	74 09                	je     80391d <devpipe_read+0x52>
				return i;
  803914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803918:	e9 92 00 00 00       	jmpq   8039af <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80391d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803921:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803925:	48 89 d6             	mov    %rdx,%rsi
  803928:	48 89 c7             	mov    %rax,%rdi
  80392b:	48 b8 94 37 80 00 00 	movabs $0x803794,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
  803937:	85 c0                	test   %eax,%eax
  803939:	74 07                	je     803942 <devpipe_read+0x77>
				return 0;
  80393b:	b8 00 00 00 00       	mov    $0x0,%eax
  803940:	eb 6d                	jmp    8039af <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803942:	48 b8 c1 1c 80 00 00 	movabs $0x801cc1,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80394e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803952:	8b 10                	mov    (%rax),%edx
  803954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803958:	8b 40 04             	mov    0x4(%rax),%eax
  80395b:	39 c2                	cmp    %eax,%edx
  80395d:	74 ae                	je     80390d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80395f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803963:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803967:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80396b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396f:	8b 00                	mov    (%rax),%eax
  803971:	99                   	cltd   
  803972:	c1 ea 1b             	shr    $0x1b,%edx
  803975:	01 d0                	add    %edx,%eax
  803977:	83 e0 1f             	and    $0x1f,%eax
  80397a:	29 d0                	sub    %edx,%eax
  80397c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803980:	48 98                	cltq   
  803982:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803987:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398d:	8b 00                	mov    (%rax),%eax
  80398f:	8d 50 01             	lea    0x1(%rax),%edx
  803992:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803996:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803998:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80399d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039a5:	0f 82 60 ff ff ff    	jb     80390b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039af:	c9                   	leaveq 
  8039b0:	c3                   	retq   

00000000008039b1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039b1:	55                   	push   %rbp
  8039b2:	48 89 e5             	mov    %rsp,%rbp
  8039b5:	48 83 ec 40          	sub    $0x40,%rsp
  8039b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c9:	48 89 c7             	mov    %rax,%rdi
  8039cc:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8039d3:	00 00 00 
  8039d6:	ff d0                	callq  *%rax
  8039d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039e4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039eb:	00 
  8039ec:	e9 8e 00 00 00       	jmpq   803a7f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039f1:	eb 31                	jmp    803a24 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039fb:	48 89 d6             	mov    %rdx,%rsi
  8039fe:	48 89 c7             	mov    %rax,%rdi
  803a01:	48 b8 94 37 80 00 00 	movabs $0x803794,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
  803a0d:	85 c0                	test   %eax,%eax
  803a0f:	74 07                	je     803a18 <devpipe_write+0x67>
				return 0;
  803a11:	b8 00 00 00 00       	mov    $0x0,%eax
  803a16:	eb 79                	jmp    803a91 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a18:	48 b8 c1 1c 80 00 00 	movabs $0x801cc1,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a28:	8b 40 04             	mov    0x4(%rax),%eax
  803a2b:	48 63 d0             	movslq %eax,%rdx
  803a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a32:	8b 00                	mov    (%rax),%eax
  803a34:	48 98                	cltq   
  803a36:	48 83 c0 20          	add    $0x20,%rax
  803a3a:	48 39 c2             	cmp    %rax,%rdx
  803a3d:	73 b4                	jae    8039f3 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a43:	8b 40 04             	mov    0x4(%rax),%eax
  803a46:	99                   	cltd   
  803a47:	c1 ea 1b             	shr    $0x1b,%edx
  803a4a:	01 d0                	add    %edx,%eax
  803a4c:	83 e0 1f             	and    $0x1f,%eax
  803a4f:	29 d0                	sub    %edx,%eax
  803a51:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a55:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a59:	48 01 ca             	add    %rcx,%rdx
  803a5c:	0f b6 0a             	movzbl (%rdx),%ecx
  803a5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a63:	48 98                	cltq   
  803a65:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a6d:	8b 40 04             	mov    0x4(%rax),%eax
  803a70:	8d 50 01             	lea    0x1(%rax),%edx
  803a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a77:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a7a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a83:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a87:	0f 82 64 ff ff ff    	jb     8039f1 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   

0000000000803a93 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a93:	55                   	push   %rbp
  803a94:	48 89 e5             	mov    %rsp,%rbp
  803a97:	48 83 ec 20          	sub    $0x20,%rsp
  803a9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa7:	48 89 c7             	mov    %rax,%rdi
  803aaa:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax
  803ab6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803aba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abe:	48 be ae 47 80 00 00 	movabs $0x8047ae,%rsi
  803ac5:	00 00 00 
  803ac8:	48 89 c7             	mov    %rax,%rdi
  803acb:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  803ad2:	00 00 00 
  803ad5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803adb:	8b 50 04             	mov    0x4(%rax),%edx
  803ade:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae2:	8b 00                	mov    (%rax),%eax
  803ae4:	29 c2                	sub    %eax,%edx
  803ae6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aea:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803af0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803afb:	00 00 00 
	stat->st_dev = &devpipe;
  803afe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b02:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803b09:	00 00 00 
  803b0c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b18:	c9                   	leaveq 
  803b19:	c3                   	retq   

0000000000803b1a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b1a:	55                   	push   %rbp
  803b1b:	48 89 e5             	mov    %rsp,%rbp
  803b1e:	48 83 ec 10          	sub    $0x10,%rsp
  803b22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2a:	48 89 c6             	mov    %rax,%rsi
  803b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b32:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b42:	48 89 c7             	mov    %rax,%rdi
  803b45:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  803b4c:	00 00 00 
  803b4f:	ff d0                	callq  *%rax
  803b51:	48 89 c6             	mov    %rax,%rsi
  803b54:	bf 00 00 00 00       	mov    $0x0,%edi
  803b59:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  803b60:	00 00 00 
  803b63:	ff d0                	callq  *%rax
}
  803b65:	c9                   	leaveq 
  803b66:	c3                   	retq   

0000000000803b67 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b67:	55                   	push   %rbp
  803b68:	48 89 e5             	mov    %rsp,%rbp
  803b6b:	48 83 ec 20          	sub    $0x20,%rsp
  803b6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b75:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b78:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b7c:	be 01 00 00 00       	mov    $0x1,%esi
  803b81:	48 89 c7             	mov    %rax,%rdi
  803b84:	48 b8 b7 1b 80 00 00 	movabs $0x801bb7,%rax
  803b8b:	00 00 00 
  803b8e:	ff d0                	callq  *%rax
}
  803b90:	c9                   	leaveq 
  803b91:	c3                   	retq   

0000000000803b92 <getchar>:

int
getchar(void)
{
  803b92:	55                   	push   %rbp
  803b93:	48 89 e5             	mov    %rsp,%rbp
  803b96:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b9a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b9e:	ba 01 00 00 00       	mov    $0x1,%edx
  803ba3:	48 89 c6             	mov    %rax,%rsi
  803ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  803bab:	48 b8 69 27 80 00 00 	movabs $0x802769,%rax
  803bb2:	00 00 00 
  803bb5:	ff d0                	callq  *%rax
  803bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bbe:	79 05                	jns    803bc5 <getchar+0x33>
		return r;
  803bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc3:	eb 14                	jmp    803bd9 <getchar+0x47>
	if (r < 1)
  803bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc9:	7f 07                	jg     803bd2 <getchar+0x40>
		return -E_EOF;
  803bcb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bd0:	eb 07                	jmp    803bd9 <getchar+0x47>
	return c;
  803bd2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bd6:	0f b6 c0             	movzbl %al,%eax
}
  803bd9:	c9                   	leaveq 
  803bda:	c3                   	retq   

0000000000803bdb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803bdb:	55                   	push   %rbp
  803bdc:	48 89 e5             	mov    %rsp,%rbp
  803bdf:	48 83 ec 20          	sub    $0x20,%rsp
  803be3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803be6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bed:	48 89 d6             	mov    %rdx,%rsi
  803bf0:	89 c7                	mov    %eax,%edi
  803bf2:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
  803bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c05:	79 05                	jns    803c0c <iscons+0x31>
		return r;
  803c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0a:	eb 1a                	jmp    803c26 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c10:	8b 10                	mov    (%rax),%edx
  803c12:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803c19:	00 00 00 
  803c1c:	8b 00                	mov    (%rax),%eax
  803c1e:	39 c2                	cmp    %eax,%edx
  803c20:	0f 94 c0             	sete   %al
  803c23:	0f b6 c0             	movzbl %al,%eax
}
  803c26:	c9                   	leaveq 
  803c27:	c3                   	retq   

0000000000803c28 <opencons>:

int
opencons(void)
{
  803c28:	55                   	push   %rbp
  803c29:	48 89 e5             	mov    %rsp,%rbp
  803c2c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c30:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c34:	48 89 c7             	mov    %rax,%rdi
  803c37:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  803c3e:	00 00 00 
  803c41:	ff d0                	callq  *%rax
  803c43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c4a:	79 05                	jns    803c51 <opencons+0x29>
		return r;
  803c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4f:	eb 5b                	jmp    803cac <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c55:	ba 07 04 00 00       	mov    $0x407,%edx
  803c5a:	48 89 c6             	mov    %rax,%rsi
  803c5d:	bf 00 00 00 00       	mov    $0x0,%edi
  803c62:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  803c69:	00 00 00 
  803c6c:	ff d0                	callq  *%rax
  803c6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c75:	79 05                	jns    803c7c <opencons+0x54>
		return r;
  803c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7a:	eb 30                	jmp    803cac <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c80:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803c87:	00 00 00 
  803c8a:	8b 12                	mov    (%rdx),%edx
  803c8c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c92:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9d:	48 89 c7             	mov    %rax,%rdi
  803ca0:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	callq  *%rax
}
  803cac:	c9                   	leaveq 
  803cad:	c3                   	retq   

0000000000803cae <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cae:	55                   	push   %rbp
  803caf:	48 89 e5             	mov    %rsp,%rbp
  803cb2:	48 83 ec 30          	sub    $0x30,%rsp
  803cb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cbe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803cc2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cc7:	75 07                	jne    803cd0 <devcons_read+0x22>
		return 0;
  803cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cce:	eb 4b                	jmp    803d1b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cd0:	eb 0c                	jmp    803cde <devcons_read+0x30>
		sys_yield();
  803cd2:	48 b8 c1 1c 80 00 00 	movabs $0x801cc1,%rax
  803cd9:	00 00 00 
  803cdc:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cde:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
  803cea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ced:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf1:	74 df                	je     803cd2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803cf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf7:	79 05                	jns    803cfe <devcons_read+0x50>
		return c;
  803cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cfc:	eb 1d                	jmp    803d1b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803cfe:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d02:	75 07                	jne    803d0b <devcons_read+0x5d>
		return 0;
  803d04:	b8 00 00 00 00       	mov    $0x0,%eax
  803d09:	eb 10                	jmp    803d1b <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0e:	89 c2                	mov    %eax,%edx
  803d10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d14:	88 10                	mov    %dl,(%rax)
	return 1;
  803d16:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d1b:	c9                   	leaveq 
  803d1c:	c3                   	retq   

0000000000803d1d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d1d:	55                   	push   %rbp
  803d1e:	48 89 e5             	mov    %rsp,%rbp
  803d21:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d28:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d2f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d36:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d44:	eb 76                	jmp    803dbc <devcons_write+0x9f>
		m = n - tot;
  803d46:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d4d:	89 c2                	mov    %eax,%edx
  803d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d52:	29 c2                	sub    %eax,%edx
  803d54:	89 d0                	mov    %edx,%eax
  803d56:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d5c:	83 f8 7f             	cmp    $0x7f,%eax
  803d5f:	76 07                	jbe    803d68 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d61:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d6b:	48 63 d0             	movslq %eax,%rdx
  803d6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d71:	48 63 c8             	movslq %eax,%rcx
  803d74:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d7b:	48 01 c1             	add    %rax,%rcx
  803d7e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d85:	48 89 ce             	mov    %rcx,%rsi
  803d88:	48 89 c7             	mov    %rax,%rdi
  803d8b:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  803d92:	00 00 00 
  803d95:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d9a:	48 63 d0             	movslq %eax,%rdx
  803d9d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803da4:	48 89 d6             	mov    %rdx,%rsi
  803da7:	48 89 c7             	mov    %rax,%rdi
  803daa:	48 b8 b7 1b 80 00 00 	movabs $0x801bb7,%rax
  803db1:	00 00 00 
  803db4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803db6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803db9:	01 45 fc             	add    %eax,-0x4(%rbp)
  803dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbf:	48 98                	cltq   
  803dc1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dc8:	0f 82 78 ff ff ff    	jb     803d46 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dd1:	c9                   	leaveq 
  803dd2:	c3                   	retq   

0000000000803dd3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803dd3:	55                   	push   %rbp
  803dd4:	48 89 e5             	mov    %rsp,%rbp
  803dd7:	48 83 ec 08          	sub    $0x8,%rsp
  803ddb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803de4:	c9                   	leaveq 
  803de5:	c3                   	retq   

0000000000803de6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803de6:	55                   	push   %rbp
  803de7:	48 89 e5             	mov    %rsp,%rbp
  803dea:	48 83 ec 10          	sub    $0x10,%rsp
  803dee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803df2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfa:	48 be ba 47 80 00 00 	movabs $0x8047ba,%rsi
  803e01:	00 00 00 
  803e04:	48 89 c7             	mov    %rax,%rdi
  803e07:	48 b8 d0 13 80 00 00 	movabs $0x8013d0,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
	return 0;
  803e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e18:	c9                   	leaveq 
  803e19:	c3                   	retq   

0000000000803e1a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e1a:	55                   	push   %rbp
  803e1b:	48 89 e5             	mov    %rsp,%rbp
  803e1e:	48 83 ec 30          	sub    $0x30,%rsp
  803e22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e2a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803e2e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e33:	75 0e                	jne    803e43 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803e35:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e3c:	00 00 00 
  803e3f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803e43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e47:	48 89 c7             	mov    %rax,%rdi
  803e4a:	48 b8 28 1f 80 00 00 	movabs $0x801f28,%rax
  803e51:	00 00 00 
  803e54:	ff d0                	callq  *%rax
  803e56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e5d:	79 27                	jns    803e86 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803e5f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e64:	74 0a                	je     803e70 <ipc_recv+0x56>
            *from_env_store = 0;
  803e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e6a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803e70:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e75:	74 0a                	je     803e81 <ipc_recv+0x67>
            *perm_store = 0;
  803e77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e84:	eb 53                	jmp    803ed9 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803e86:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e8b:	74 19                	je     803ea6 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  803e8d:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803e94:	00 00 00 
  803e97:	48 8b 00             	mov    (%rax),%rax
  803e9a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ea4:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  803ea6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803eab:	74 19                	je     803ec6 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  803ead:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803eb4:	00 00 00 
  803eb7:	48 8b 00             	mov    (%rax),%rax
  803eba:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ec0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec4:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803ec6:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803ecd:	00 00 00 
  803ed0:	48 8b 00             	mov    (%rax),%rax
  803ed3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803ed9:	c9                   	leaveq 
  803eda:	c3                   	retq   

0000000000803edb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803edb:	55                   	push   %rbp
  803edc:	48 89 e5             	mov    %rsp,%rbp
  803edf:	48 83 ec 30          	sub    $0x30,%rsp
  803ee3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ee6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ee9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803eed:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803ef0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ef5:	75 0e                	jne    803f05 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803ef7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803efe:	00 00 00 
  803f01:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803f05:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f08:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f0b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f12:	89 c7                	mov    %eax,%edi
  803f14:	48 b8 d3 1e 80 00 00 	movabs $0x801ed3,%rax
  803f1b:	00 00 00 
  803f1e:	ff d0                	callq  *%rax
  803f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f27:	79 36                	jns    803f5f <ipc_send+0x84>
  803f29:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f2d:	74 30                	je     803f5f <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f32:	89 c1                	mov    %eax,%ecx
  803f34:	48 ba c1 47 80 00 00 	movabs $0x8047c1,%rdx
  803f3b:	00 00 00 
  803f3e:	be 49 00 00 00       	mov    $0x49,%esi
  803f43:	48 bf ce 47 80 00 00 	movabs $0x8047ce,%rdi
  803f4a:	00 00 00 
  803f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f52:	49 b8 cf 05 80 00 00 	movabs $0x8005cf,%r8
  803f59:	00 00 00 
  803f5c:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803f5f:	48 b8 c1 1c 80 00 00 	movabs $0x801cc1,%rax
  803f66:	00 00 00 
  803f69:	ff d0                	callq  *%rax
    } while(r != 0);
  803f6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6f:	75 94                	jne    803f05 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803f71:	c9                   	leaveq 
  803f72:	c3                   	retq   

0000000000803f73 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f73:	55                   	push   %rbp
  803f74:	48 89 e5             	mov    %rsp,%rbp
  803f77:	48 83 ec 14          	sub    $0x14,%rsp
  803f7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f85:	eb 5e                	jmp    803fe5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803f87:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f8e:	00 00 00 
  803f91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f94:	48 63 d0             	movslq %eax,%rdx
  803f97:	48 89 d0             	mov    %rdx,%rax
  803f9a:	48 c1 e0 03          	shl    $0x3,%rax
  803f9e:	48 01 d0             	add    %rdx,%rax
  803fa1:	48 c1 e0 05          	shl    $0x5,%rax
  803fa5:	48 01 c8             	add    %rcx,%rax
  803fa8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803fae:	8b 00                	mov    (%rax),%eax
  803fb0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fb3:	75 2c                	jne    803fe1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803fb5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fbc:	00 00 00 
  803fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc2:	48 63 d0             	movslq %eax,%rdx
  803fc5:	48 89 d0             	mov    %rdx,%rax
  803fc8:	48 c1 e0 03          	shl    $0x3,%rax
  803fcc:	48 01 d0             	add    %rdx,%rax
  803fcf:	48 c1 e0 05          	shl    $0x5,%rax
  803fd3:	48 01 c8             	add    %rcx,%rax
  803fd6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803fdc:	8b 40 08             	mov    0x8(%rax),%eax
  803fdf:	eb 12                	jmp    803ff3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803fe1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803fe5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803fec:	7e 99                	jle    803f87 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ff3:	c9                   	leaveq 
  803ff4:	c3                   	retq   

0000000000803ff5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ff5:	55                   	push   %rbp
  803ff6:	48 89 e5             	mov    %rsp,%rbp
  803ff9:	48 83 ec 18          	sub    $0x18,%rsp
  803ffd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804005:	48 c1 e8 15          	shr    $0x15,%rax
  804009:	48 89 c2             	mov    %rax,%rdx
  80400c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804013:	01 00 00 
  804016:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80401a:	83 e0 01             	and    $0x1,%eax
  80401d:	48 85 c0             	test   %rax,%rax
  804020:	75 07                	jne    804029 <pageref+0x34>
		return 0;
  804022:	b8 00 00 00 00       	mov    $0x0,%eax
  804027:	eb 53                	jmp    80407c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80402d:	48 c1 e8 0c          	shr    $0xc,%rax
  804031:	48 89 c2             	mov    %rax,%rdx
  804034:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80403b:	01 00 00 
  80403e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804042:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80404a:	83 e0 01             	and    $0x1,%eax
  80404d:	48 85 c0             	test   %rax,%rax
  804050:	75 07                	jne    804059 <pageref+0x64>
		return 0;
  804052:	b8 00 00 00 00       	mov    $0x0,%eax
  804057:	eb 23                	jmp    80407c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80405d:	48 c1 e8 0c          	shr    $0xc,%rax
  804061:	48 89 c2             	mov    %rax,%rdx
  804064:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80406b:	00 00 00 
  80406e:	48 c1 e2 04          	shl    $0x4,%rdx
  804072:	48 01 d0             	add    %rdx,%rax
  804075:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804079:	0f b7 c0             	movzwl %ax,%eax
}
  80407c:	c9                   	leaveq 
  80407d:	c3                   	retq   
