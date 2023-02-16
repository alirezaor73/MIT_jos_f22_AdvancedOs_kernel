
obj/user/echo:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be e0 36 80 00 00 	movabs $0x8036e0,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 d4 03 80 00 00 	movabs $0x8003d4,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be e3 36 80 00 00 	movabs $0x8036e3,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 70 14 80 00 00 	movabs $0x801470,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 06 02 80 00 00 	movabs $0x800206,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 70 14 80 00 00 	movabs $0x801470,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be e5 36 80 00 00 	movabs $0x8036e5,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 70 14 80 00 00 	movabs $0x801470,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 20          	sub    $0x20,%rsp
  80015a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80015d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  800161:	48 b8 25 0b 80 00 00 	movabs $0x800b25,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 89 d0             	mov    %rdx,%rax
  80017e:	48 c1 e0 03          	shl    $0x3,%rax
  800182:	48 01 d0             	add    %rdx,%rax
  800185:	48 c1 e0 05          	shl    $0x5,%rax
  800189:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800190:	00 00 00 
  800193:	48 01 c2             	add    %rax,%rdx
  800196:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80019d:	00 00 00 
  8001a0:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001a7:	7e 14                	jle    8001bd <libmain+0x6b>
		binaryname = argv[0];
  8001a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001ad:	48 8b 10             	mov    (%rax),%rdx
  8001b0:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001b7:	00 00 00 
  8001ba:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c4:	48 89 d6             	mov    %rdx,%rsi
  8001c7:	89 c7                	mov    %eax,%edi
  8001c9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001d0:	00 00 00 
  8001d3:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d5:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e7:	48 b8 4f 11 80 00 00 	movabs $0x80114f,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f8:	48 b8 e1 0a 80 00 00 	movabs $0x800ae1,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
}
  800204:	5d                   	pop    %rbp
  800205:	c3                   	retq   

0000000000800206 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800206:	55                   	push   %rbp
  800207:	48 89 e5             	mov    %rsp,%rbp
  80020a:	48 83 ec 18          	sub    $0x18,%rsp
  80020e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800219:	eb 09                	jmp    800224 <strlen+0x1e>
		n++;
  80021b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80021f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800228:	0f b6 00             	movzbl (%rax),%eax
  80022b:	84 c0                	test   %al,%al
  80022d:	75 ec                	jne    80021b <strlen+0x15>
		n++;
	return n;
  80022f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800232:	c9                   	leaveq 
  800233:	c3                   	retq   

0000000000800234 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800234:	55                   	push   %rbp
  800235:	48 89 e5             	mov    %rsp,%rbp
  800238:	48 83 ec 20          	sub    $0x20,%rsp
  80023c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800240:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80024b:	eb 0e                	jmp    80025b <strnlen+0x27>
		n++;
  80024d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800251:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800256:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80025b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800260:	74 0b                	je     80026d <strnlen+0x39>
  800262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800266:	0f b6 00             	movzbl (%rax),%eax
  800269:	84 c0                	test   %al,%al
  80026b:	75 e0                	jne    80024d <strnlen+0x19>
		n++;
	return n;
  80026d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800270:	c9                   	leaveq 
  800271:	c3                   	retq   

0000000000800272 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800272:	55                   	push   %rbp
  800273:	48 89 e5             	mov    %rsp,%rbp
  800276:	48 83 ec 20          	sub    $0x20,%rsp
  80027a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80027e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800286:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80028a:	90                   	nop
  80028b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800293:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800297:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80029b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80029f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8002a3:	0f b6 12             	movzbl (%rdx),%edx
  8002a6:	88 10                	mov    %dl,(%rax)
  8002a8:	0f b6 00             	movzbl (%rax),%eax
  8002ab:	84 c0                	test   %al,%al
  8002ad:	75 dc                	jne    80028b <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002b3:	c9                   	leaveq 
  8002b4:	c3                   	retq   

00000000008002b5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002b5:	55                   	push   %rbp
  8002b6:	48 89 e5             	mov    %rsp,%rbp
  8002b9:	48 83 ec 20          	sub    $0x20,%rsp
  8002bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002c9:	48 89 c7             	mov    %rax,%rdi
  8002cc:	48 b8 06 02 80 00 00 	movabs $0x800206,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
  8002d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002de:	48 63 d0             	movslq %eax,%rdx
  8002e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e5:	48 01 c2             	add    %rax,%rdx
  8002e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002ec:	48 89 c6             	mov    %rax,%rsi
  8002ef:	48 89 d7             	mov    %rdx,%rdi
  8002f2:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  8002f9:	00 00 00 
  8002fc:	ff d0                	callq  *%rax
	return dst;
  8002fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800302:	c9                   	leaveq 
  800303:	c3                   	retq   

0000000000800304 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800304:	55                   	push   %rbp
  800305:	48 89 e5             	mov    %rsp,%rbp
  800308:	48 83 ec 28          	sub    $0x28,%rsp
  80030c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800310:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800314:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800320:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800327:	00 
  800328:	eb 2a                	jmp    800354 <strncpy+0x50>
		*dst++ = *src;
  80032a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80032e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80033a:	0f b6 12             	movzbl (%rdx),%edx
  80033d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80033f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800343:	0f b6 00             	movzbl (%rax),%eax
  800346:	84 c0                	test   %al,%al
  800348:	74 05                	je     80034f <strncpy+0x4b>
			src++;
  80034a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80034f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800358:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80035c:	72 cc                	jb     80032a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80035e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800362:	c9                   	leaveq 
  800363:	c3                   	retq   

0000000000800364 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
  800368:	48 83 ec 28          	sub    $0x28,%rsp
  80036c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800370:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800374:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800378:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800380:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800385:	74 3d                	je     8003c4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800387:	eb 1d                	jmp    8003a6 <strlcpy+0x42>
			*dst++ = *src++;
  800389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80038d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800391:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800395:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800399:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80039d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8003a1:	0f b6 12             	movzbl (%rdx),%edx
  8003a4:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003ab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003b0:	74 0b                	je     8003bd <strlcpy+0x59>
  8003b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b6:	0f b6 00             	movzbl (%rax),%eax
  8003b9:	84 c0                	test   %al,%al
  8003bb:	75 cc                	jne    800389 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cc:	48 29 c2             	sub    %rax,%rdx
  8003cf:	48 89 d0             	mov    %rdx,%rax
}
  8003d2:	c9                   	leaveq 
  8003d3:	c3                   	retq   

00000000008003d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003d4:	55                   	push   %rbp
  8003d5:	48 89 e5             	mov    %rsp,%rbp
  8003d8:	48 83 ec 10          	sub    $0x10,%rsp
  8003dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003e4:	eb 0a                	jmp    8003f0 <strcmp+0x1c>
		p++, q++;
  8003e6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003eb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f4:	0f b6 00             	movzbl (%rax),%eax
  8003f7:	84 c0                	test   %al,%al
  8003f9:	74 12                	je     80040d <strcmp+0x39>
  8003fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ff:	0f b6 10             	movzbl (%rax),%edx
  800402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800406:	0f b6 00             	movzbl (%rax),%eax
  800409:	38 c2                	cmp    %al,%dl
  80040b:	74 d9                	je     8003e6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80040d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800411:	0f b6 00             	movzbl (%rax),%eax
  800414:	0f b6 d0             	movzbl %al,%edx
  800417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041b:	0f b6 00             	movzbl (%rax),%eax
  80041e:	0f b6 c0             	movzbl %al,%eax
  800421:	29 c2                	sub    %eax,%edx
  800423:	89 d0                	mov    %edx,%eax
}
  800425:	c9                   	leaveq 
  800426:	c3                   	retq   

0000000000800427 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	48 83 ec 18          	sub    $0x18,%rsp
  80042f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800433:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800437:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80043b:	eb 0f                	jmp    80044c <strncmp+0x25>
		n--, p++, q++;
  80043d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800442:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800447:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80044c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800451:	74 1d                	je     800470 <strncmp+0x49>
  800453:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800457:	0f b6 00             	movzbl (%rax),%eax
  80045a:	84 c0                	test   %al,%al
  80045c:	74 12                	je     800470 <strncmp+0x49>
  80045e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800462:	0f b6 10             	movzbl (%rax),%edx
  800465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800469:	0f b6 00             	movzbl (%rax),%eax
  80046c:	38 c2                	cmp    %al,%dl
  80046e:	74 cd                	je     80043d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800470:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800475:	75 07                	jne    80047e <strncmp+0x57>
		return 0;
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
  80047c:	eb 18                	jmp    800496 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80047e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800482:	0f b6 00             	movzbl (%rax),%eax
  800485:	0f b6 d0             	movzbl %al,%edx
  800488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048c:	0f b6 00             	movzbl (%rax),%eax
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	29 c2                	sub    %eax,%edx
  800494:	89 d0                	mov    %edx,%eax
}
  800496:	c9                   	leaveq 
  800497:	c3                   	retq   

0000000000800498 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800498:	55                   	push   %rbp
  800499:	48 89 e5             	mov    %rsp,%rbp
  80049c:	48 83 ec 0c          	sub    $0xc,%rsp
  8004a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004a4:	89 f0                	mov    %esi,%eax
  8004a6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004a9:	eb 17                	jmp    8004c2 <strchr+0x2a>
		if (*s == c)
  8004ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004af:	0f b6 00             	movzbl (%rax),%eax
  8004b2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004b5:	75 06                	jne    8004bd <strchr+0x25>
			return (char *) s;
  8004b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004bb:	eb 15                	jmp    8004d2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c6:	0f b6 00             	movzbl (%rax),%eax
  8004c9:	84 c0                	test   %al,%al
  8004cb:	75 de                	jne    8004ab <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d2:	c9                   	leaveq 
  8004d3:	c3                   	retq   

00000000008004d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004d4:	55                   	push   %rbp
  8004d5:	48 89 e5             	mov    %rsp,%rbp
  8004d8:	48 83 ec 0c          	sub    $0xc,%rsp
  8004dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004e0:	89 f0                	mov    %esi,%eax
  8004e2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004e5:	eb 13                	jmp    8004fa <strfind+0x26>
		if (*s == c)
  8004e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004eb:	0f b6 00             	movzbl (%rax),%eax
  8004ee:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004f1:	75 02                	jne    8004f5 <strfind+0x21>
			break;
  8004f3:	eb 10                	jmp    800505 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004fe:	0f b6 00             	movzbl (%rax),%eax
  800501:	84 c0                	test   %al,%al
  800503:	75 e2                	jne    8004e7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  800505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800509:	c9                   	leaveq 
  80050a:	c3                   	retq   

000000000080050b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80050b:	55                   	push   %rbp
  80050c:	48 89 e5             	mov    %rsp,%rbp
  80050f:	48 83 ec 18          	sub    $0x18,%rsp
  800513:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800517:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80051a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80051e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800523:	75 06                	jne    80052b <memset+0x20>
		return v;
  800525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800529:	eb 69                	jmp    800594 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80052b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052f:	83 e0 03             	and    $0x3,%eax
  800532:	48 85 c0             	test   %rax,%rax
  800535:	75 48                	jne    80057f <memset+0x74>
  800537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053b:	83 e0 03             	and    $0x3,%eax
  80053e:	48 85 c0             	test   %rax,%rax
  800541:	75 3c                	jne    80057f <memset+0x74>
		c &= 0xFF;
  800543:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80054a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054d:	c1 e0 18             	shl    $0x18,%eax
  800550:	89 c2                	mov    %eax,%edx
  800552:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800555:	c1 e0 10             	shl    $0x10,%eax
  800558:	09 c2                	or     %eax,%edx
  80055a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80055d:	c1 e0 08             	shl    $0x8,%eax
  800560:	09 d0                	or     %edx,%eax
  800562:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  800565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800569:	48 c1 e8 02          	shr    $0x2,%rax
  80056d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800570:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800574:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800577:	48 89 d7             	mov    %rdx,%rdi
  80057a:	fc                   	cld    
  80057b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80057d:	eb 11                	jmp    800590 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80057f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800583:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800586:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80058a:	48 89 d7             	mov    %rdx,%rdi
  80058d:	fc                   	cld    
  80058e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  800590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800594:	c9                   	leaveq 
  800595:	c3                   	retq   

0000000000800596 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800596:	55                   	push   %rbp
  800597:	48 89 e5             	mov    %rsp,%rbp
  80059a:	48 83 ec 28          	sub    $0x28,%rsp
  80059e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005be:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005c2:	0f 83 88 00 00 00    	jae    800650 <memmove+0xba>
  8005c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005d0:	48 01 d0             	add    %rdx,%rax
  8005d3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005d7:	76 77                	jbe    800650 <memmove+0xba>
		s += n;
  8005d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005dd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ed:	83 e0 03             	and    $0x3,%eax
  8005f0:	48 85 c0             	test   %rax,%rax
  8005f3:	75 3b                	jne    800630 <memmove+0x9a>
  8005f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f9:	83 e0 03             	and    $0x3,%eax
  8005fc:	48 85 c0             	test   %rax,%rax
  8005ff:	75 2f                	jne    800630 <memmove+0x9a>
  800601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800605:	83 e0 03             	and    $0x3,%eax
  800608:	48 85 c0             	test   %rax,%rax
  80060b:	75 23                	jne    800630 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80060d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800611:	48 83 e8 04          	sub    $0x4,%rax
  800615:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800619:	48 83 ea 04          	sub    $0x4,%rdx
  80061d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800621:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800625:	48 89 c7             	mov    %rax,%rdi
  800628:	48 89 d6             	mov    %rdx,%rsi
  80062b:	fd                   	std    
  80062c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80062e:	eb 1d                	jmp    80064d <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800634:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80063c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800644:	48 89 d7             	mov    %rdx,%rdi
  800647:	48 89 c1             	mov    %rax,%rcx
  80064a:	fd                   	std    
  80064b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80064d:	fc                   	cld    
  80064e:	eb 57                	jmp    8006a7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800654:	83 e0 03             	and    $0x3,%eax
  800657:	48 85 c0             	test   %rax,%rax
  80065a:	75 36                	jne    800692 <memmove+0xfc>
  80065c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800660:	83 e0 03             	and    $0x3,%eax
  800663:	48 85 c0             	test   %rax,%rax
  800666:	75 2a                	jne    800692 <memmove+0xfc>
  800668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066c:	83 e0 03             	and    $0x3,%eax
  80066f:	48 85 c0             	test   %rax,%rax
  800672:	75 1e                	jne    800692 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800674:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800678:	48 c1 e8 02          	shr    $0x2,%rax
  80067c:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80067f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800683:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800687:	48 89 c7             	mov    %rax,%rdi
  80068a:	48 89 d6             	mov    %rdx,%rsi
  80068d:	fc                   	cld    
  80068e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800690:	eb 15                	jmp    8006a7 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800696:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80069a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80069e:	48 89 c7             	mov    %rax,%rdi
  8006a1:	48 89 d6             	mov    %rdx,%rsi
  8006a4:	fc                   	cld    
  8006a5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006ab:	c9                   	leaveq 
  8006ac:	c3                   	retq   

00000000008006ad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006ad:	55                   	push   %rbp
  8006ae:	48 89 e5             	mov    %rsp,%rbp
  8006b1:	48 83 ec 18          	sub    $0x18,%rsp
  8006b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006cd:	48 89 ce             	mov    %rcx,%rsi
  8006d0:	48 89 c7             	mov    %rax,%rdi
  8006d3:	48 b8 96 05 80 00 00 	movabs $0x800596,%rax
  8006da:	00 00 00 
  8006dd:	ff d0                	callq  *%rax
}
  8006df:	c9                   	leaveq 
  8006e0:	c3                   	retq   

00000000008006e1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006e1:	55                   	push   %rbp
  8006e2:	48 89 e5             	mov    %rsp,%rbp
  8006e5:	48 83 ec 28          	sub    $0x28,%rsp
  8006e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800701:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  800705:	eb 36                	jmp    80073d <memcmp+0x5c>
		if (*s1 != *s2)
  800707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070b:	0f b6 10             	movzbl (%rax),%edx
  80070e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800712:	0f b6 00             	movzbl (%rax),%eax
  800715:	38 c2                	cmp    %al,%dl
  800717:	74 1a                	je     800733 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  800719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80071d:	0f b6 00             	movzbl (%rax),%eax
  800720:	0f b6 d0             	movzbl %al,%edx
  800723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800727:	0f b6 00             	movzbl (%rax),%eax
  80072a:	0f b6 c0             	movzbl %al,%eax
  80072d:	29 c2                	sub    %eax,%edx
  80072f:	89 d0                	mov    %edx,%eax
  800731:	eb 20                	jmp    800753 <memcmp+0x72>
		s1++, s2++;
  800733:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800738:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80073d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800741:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800745:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800749:	48 85 c0             	test   %rax,%rax
  80074c:	75 b9                	jne    800707 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80074e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800753:	c9                   	leaveq 
  800754:	c3                   	retq   

0000000000800755 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800755:	55                   	push   %rbp
  800756:	48 89 e5             	mov    %rsp,%rbp
  800759:	48 83 ec 28          	sub    $0x28,%rsp
  80075d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800761:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800764:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	48 01 d0             	add    %rdx,%rax
  800773:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800777:	eb 15                	jmp    80078e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  800779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077d:	0f b6 10             	movzbl (%rax),%edx
  800780:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800783:	38 c2                	cmp    %al,%dl
  800785:	75 02                	jne    800789 <memfind+0x34>
			break;
  800787:	eb 0f                	jmp    800798 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800789:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800796:	72 e1                	jb     800779 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80079c:	c9                   	leaveq 
  80079d:	c3                   	retq   

000000000080079e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80079e:	55                   	push   %rbp
  80079f:	48 89 e5             	mov    %rsp,%rbp
  8007a2:	48 83 ec 34          	sub    $0x34,%rsp
  8007a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007ae:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007b8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007bf:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c0:	eb 05                	jmp    8007c7 <strtol+0x29>
		s++;
  8007c2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007cb:	0f b6 00             	movzbl (%rax),%eax
  8007ce:	3c 20                	cmp    $0x20,%al
  8007d0:	74 f0                	je     8007c2 <strtol+0x24>
  8007d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d6:	0f b6 00             	movzbl (%rax),%eax
  8007d9:	3c 09                	cmp    $0x9,%al
  8007db:	74 e5                	je     8007c2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e1:	0f b6 00             	movzbl (%rax),%eax
  8007e4:	3c 2b                	cmp    $0x2b,%al
  8007e6:	75 07                	jne    8007ef <strtol+0x51>
		s++;
  8007e8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ed:	eb 17                	jmp    800806 <strtol+0x68>
	else if (*s == '-')
  8007ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007f3:	0f b6 00             	movzbl (%rax),%eax
  8007f6:	3c 2d                	cmp    $0x2d,%al
  8007f8:	75 0c                	jne    800806 <strtol+0x68>
		s++, neg = 1;
  8007fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800806:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80080a:	74 06                	je     800812 <strtol+0x74>
  80080c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  800810:	75 28                	jne    80083a <strtol+0x9c>
  800812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800816:	0f b6 00             	movzbl (%rax),%eax
  800819:	3c 30                	cmp    $0x30,%al
  80081b:	75 1d                	jne    80083a <strtol+0x9c>
  80081d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800821:	48 83 c0 01          	add    $0x1,%rax
  800825:	0f b6 00             	movzbl (%rax),%eax
  800828:	3c 78                	cmp    $0x78,%al
  80082a:	75 0e                	jne    80083a <strtol+0x9c>
		s += 2, base = 16;
  80082c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800831:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800838:	eb 2c                	jmp    800866 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80083a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80083e:	75 19                	jne    800859 <strtol+0xbb>
  800840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800844:	0f b6 00             	movzbl (%rax),%eax
  800847:	3c 30                	cmp    $0x30,%al
  800849:	75 0e                	jne    800859 <strtol+0xbb>
		s++, base = 8;
  80084b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800850:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800857:	eb 0d                	jmp    800866 <strtol+0xc8>
	else if (base == 0)
  800859:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80085d:	75 07                	jne    800866 <strtol+0xc8>
		base = 10;
  80085f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80086a:	0f b6 00             	movzbl (%rax),%eax
  80086d:	3c 2f                	cmp    $0x2f,%al
  80086f:	7e 1d                	jle    80088e <strtol+0xf0>
  800871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800875:	0f b6 00             	movzbl (%rax),%eax
  800878:	3c 39                	cmp    $0x39,%al
  80087a:	7f 12                	jg     80088e <strtol+0xf0>
			dig = *s - '0';
  80087c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800880:	0f b6 00             	movzbl (%rax),%eax
  800883:	0f be c0             	movsbl %al,%eax
  800886:	83 e8 30             	sub    $0x30,%eax
  800889:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80088c:	eb 4e                	jmp    8008dc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80088e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800892:	0f b6 00             	movzbl (%rax),%eax
  800895:	3c 60                	cmp    $0x60,%al
  800897:	7e 1d                	jle    8008b6 <strtol+0x118>
  800899:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089d:	0f b6 00             	movzbl (%rax),%eax
  8008a0:	3c 7a                	cmp    $0x7a,%al
  8008a2:	7f 12                	jg     8008b6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8008a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a8:	0f b6 00             	movzbl (%rax),%eax
  8008ab:	0f be c0             	movsbl %al,%eax
  8008ae:	83 e8 57             	sub    $0x57,%eax
  8008b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008b4:	eb 26                	jmp    8008dc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ba:	0f b6 00             	movzbl (%rax),%eax
  8008bd:	3c 40                	cmp    $0x40,%al
  8008bf:	7e 48                	jle    800909 <strtol+0x16b>
  8008c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c5:	0f b6 00             	movzbl (%rax),%eax
  8008c8:	3c 5a                	cmp    $0x5a,%al
  8008ca:	7f 3d                	jg     800909 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008d0:	0f b6 00             	movzbl (%rax),%eax
  8008d3:	0f be c0             	movsbl %al,%eax
  8008d6:	83 e8 37             	sub    $0x37,%eax
  8008d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008df:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008e2:	7c 02                	jl     8008e6 <strtol+0x148>
			break;
  8008e4:	eb 23                	jmp    800909 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008e6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008eb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008ee:	48 98                	cltq   
  8008f0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008f5:	48 89 c2             	mov    %rax,%rdx
  8008f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008fb:	48 98                	cltq   
  8008fd:	48 01 d0             	add    %rdx,%rax
  800900:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  800904:	e9 5d ff ff ff       	jmpq   800866 <strtol+0xc8>

	if (endptr)
  800909:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80090e:	74 0b                	je     80091b <strtol+0x17d>
		*endptr = (char *) s;
  800910:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800914:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800918:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80091b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091f:	74 09                	je     80092a <strtol+0x18c>
  800921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800925:	48 f7 d8             	neg    %rax
  800928:	eb 04                	jmp    80092e <strtol+0x190>
  80092a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80092e:	c9                   	leaveq 
  80092f:	c3                   	retq   

0000000000800930 <strstr>:

char * strstr(const char *in, const char *str)
{
  800930:	55                   	push   %rbp
  800931:	48 89 e5             	mov    %rsp,%rbp
  800934:	48 83 ec 30          	sub    $0x30,%rsp
  800938:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80093c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  800940:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800944:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800948:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80094c:	0f b6 00             	movzbl (%rax),%eax
  80094f:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800952:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800956:	75 06                	jne    80095e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  800958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80095c:	eb 6b                	jmp    8009c9 <strstr+0x99>

	len = strlen(str);
  80095e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800962:	48 89 c7             	mov    %rax,%rdi
  800965:	48 b8 06 02 80 00 00 	movabs $0x800206,%rax
  80096c:	00 00 00 
  80096f:	ff d0                	callq  *%rax
  800971:	48 98                	cltq   
  800973:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80097f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800983:	0f b6 00             	movzbl (%rax),%eax
  800986:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  800989:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80098d:	75 07                	jne    800996 <strstr+0x66>
				return (char *) 0;
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	eb 33                	jmp    8009c9 <strstr+0x99>
		} while (sc != c);
  800996:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80099a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80099d:	75 d8                	jne    800977 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80099f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009a3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009ab:	48 89 ce             	mov    %rcx,%rsi
  8009ae:	48 89 c7             	mov    %rax,%rdi
  8009b1:	48 b8 27 04 80 00 00 	movabs $0x800427,%rax
  8009b8:	00 00 00 
  8009bb:	ff d0                	callq  *%rax
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	75 b6                	jne    800977 <strstr+0x47>

	return (char *) (in - 1);
  8009c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c5:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c9:	c9                   	leaveq 
  8009ca:	c3                   	retq   

00000000008009cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009cb:	55                   	push   %rbp
  8009cc:	48 89 e5             	mov    %rsp,%rbp
  8009cf:	53                   	push   %rbx
  8009d0:	48 83 ec 48          	sub    $0x48,%rsp
  8009d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009da:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009de:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009e2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009ed:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009f1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009f5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009f9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009fd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800a01:	4c 89 c3             	mov    %r8,%rbx
  800a04:	cd 30                	int    $0x30
  800a06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a0a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a0e:	74 3e                	je     800a4e <syscall+0x83>
  800a10:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a15:	7e 37                	jle    800a4e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a17:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a1e:	49 89 d0             	mov    %rdx,%r8
  800a21:	89 c1                	mov    %eax,%ecx
  800a23:	48 ba f1 36 80 00 00 	movabs $0x8036f1,%rdx
  800a2a:	00 00 00 
  800a2d:	be 23 00 00 00       	mov    $0x23,%esi
  800a32:	48 bf 0e 37 80 00 00 	movabs $0x80370e,%rdi
  800a39:	00 00 00 
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a41:	49 b9 d3 26 80 00 00 	movabs $0x8026d3,%r9
  800a48:	00 00 00 
  800a4b:	41 ff d1             	callq  *%r9

	return ret;
  800a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a52:	48 83 c4 48          	add    $0x48,%rsp
  800a56:	5b                   	pop    %rbx
  800a57:	5d                   	pop    %rbp
  800a58:	c3                   	retq   

0000000000800a59 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a59:	55                   	push   %rbp
  800a5a:	48 89 e5             	mov    %rsp,%rbp
  800a5d:	48 83 ec 20          	sub    $0x20,%rsp
  800a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a78:	00 
  800a79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a85:	48 89 d1             	mov    %rdx,%rcx
  800a88:	48 89 c2             	mov    %rax,%rdx
  800a8b:	be 00 00 00 00       	mov    $0x0,%esi
  800a90:	bf 00 00 00 00       	mov    $0x0,%edi
  800a95:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800a9c:	00 00 00 
  800a9f:	ff d0                	callq  *%rax
}
  800aa1:	c9                   	leaveq 
  800aa2:	c3                   	retq   

0000000000800aa3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa3:	55                   	push   %rbp
  800aa4:	48 89 e5             	mov    %rsp,%rbp
  800aa7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ab2:	00 
  800ab3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800abf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	be 00 00 00 00       	mov    $0x0,%esi
  800ace:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad3:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800ada:	00 00 00 
  800add:	ff d0                	callq  *%rax
}
  800adf:	c9                   	leaveq 
  800ae0:	c3                   	retq   

0000000000800ae1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae1:	55                   	push   %rbp
  800ae2:	48 89 e5             	mov    %rsp,%rbp
  800ae5:	48 83 ec 10          	sub    $0x10,%rsp
  800ae9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aef:	48 98                	cltq   
  800af1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800af8:	00 
  800af9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800aff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0a:	48 89 c2             	mov    %rax,%rdx
  800b0d:	be 01 00 00 00       	mov    $0x1,%esi
  800b12:	bf 03 00 00 00       	mov    $0x3,%edi
  800b17:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800b1e:	00 00 00 
  800b21:	ff d0                	callq  *%rax
}
  800b23:	c9                   	leaveq 
  800b24:	c3                   	retq   

0000000000800b25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b25:	55                   	push   %rbp
  800b26:	48 89 e5             	mov    %rsp,%rbp
  800b29:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b34:	00 
  800b35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4b:	be 00 00 00 00       	mov    $0x0,%esi
  800b50:	bf 02 00 00 00       	mov    $0x2,%edi
  800b55:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
}
  800b61:	c9                   	leaveq 
  800b62:	c3                   	retq   

0000000000800b63 <sys_yield>:

void
sys_yield(void)
{
  800b63:	55                   	push   %rbp
  800b64:	48 89 e5             	mov    %rsp,%rbp
  800b67:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b72:	00 
  800b73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
  800b89:	be 00 00 00 00       	mov    $0x0,%esi
  800b8e:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b93:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800b9a:	00 00 00 
  800b9d:	ff d0                	callq  *%rax
}
  800b9f:	c9                   	leaveq 
  800ba0:	c3                   	retq   

0000000000800ba1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba1:	55                   	push   %rbp
  800ba2:	48 89 e5             	mov    %rsp,%rbp
  800ba5:	48 83 ec 20          	sub    $0x20,%rsp
  800ba9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bb0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb6:	48 63 c8             	movslq %eax,%rcx
  800bb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bc0:	48 98                	cltq   
  800bc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bc9:	00 
  800bca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bd0:	49 89 c8             	mov    %rcx,%r8
  800bd3:	48 89 d1             	mov    %rdx,%rcx
  800bd6:	48 89 c2             	mov    %rax,%rdx
  800bd9:	be 01 00 00 00       	mov    $0x1,%esi
  800bde:	bf 04 00 00 00       	mov    $0x4,%edi
  800be3:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800bea:	00 00 00 
  800bed:	ff d0                	callq  *%rax
}
  800bef:	c9                   	leaveq 
  800bf0:	c3                   	retq   

0000000000800bf1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf1:	55                   	push   %rbp
  800bf2:	48 89 e5             	mov    %rsp,%rbp
  800bf5:	48 83 ec 30          	sub    $0x30,%rsp
  800bf9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c00:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800c03:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c07:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c0b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c0e:	48 63 c8             	movslq %eax,%rcx
  800c11:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c18:	48 63 f0             	movslq %eax,%rsi
  800c1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c22:	48 98                	cltq   
  800c24:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c28:	49 89 f9             	mov    %rdi,%r9
  800c2b:	49 89 f0             	mov    %rsi,%r8
  800c2e:	48 89 d1             	mov    %rdx,%rcx
  800c31:	48 89 c2             	mov    %rax,%rdx
  800c34:	be 01 00 00 00       	mov    $0x1,%esi
  800c39:	bf 05 00 00 00       	mov    $0x5,%edi
  800c3e:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	callq  *%rax
}
  800c4a:	c9                   	leaveq 
  800c4b:	c3                   	retq   

0000000000800c4c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4c:	55                   	push   %rbp
  800c4d:	48 89 e5             	mov    %rsp,%rbp
  800c50:	48 83 ec 20          	sub    $0x20,%rsp
  800c54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c62:	48 98                	cltq   
  800c64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c6b:	00 
  800c6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c78:	48 89 d1             	mov    %rdx,%rcx
  800c7b:	48 89 c2             	mov    %rax,%rdx
  800c7e:	be 01 00 00 00       	mov    $0x1,%esi
  800c83:	bf 06 00 00 00       	mov    $0x6,%edi
  800c88:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800c8f:	00 00 00 
  800c92:	ff d0                	callq  *%rax
}
  800c94:	c9                   	leaveq 
  800c95:	c3                   	retq   

0000000000800c96 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c96:	55                   	push   %rbp
  800c97:	48 89 e5             	mov    %rsp,%rbp
  800c9a:	48 83 ec 10          	sub    $0x10,%rsp
  800c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ca4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ca7:	48 63 d0             	movslq %eax,%rdx
  800caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cad:	48 98                	cltq   
  800caf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cb6:	00 
  800cb7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cc3:	48 89 d1             	mov    %rdx,%rcx
  800cc6:	48 89 c2             	mov    %rax,%rdx
  800cc9:	be 01 00 00 00       	mov    $0x1,%esi
  800cce:	bf 08 00 00 00       	mov    $0x8,%edi
  800cd3:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
}
  800cdf:	c9                   	leaveq 
  800ce0:	c3                   	retq   

0000000000800ce1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce1:	55                   	push   %rbp
  800ce2:	48 89 e5             	mov    %rsp,%rbp
  800ce5:	48 83 ec 20          	sub    $0x20,%rsp
  800ce9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cf0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf7:	48 98                	cltq   
  800cf9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d00:	00 
  800d01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d0d:	48 89 d1             	mov    %rdx,%rcx
  800d10:	48 89 c2             	mov    %rax,%rdx
  800d13:	be 01 00 00 00       	mov    $0x1,%esi
  800d18:	bf 09 00 00 00       	mov    $0x9,%edi
  800d1d:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800d24:	00 00 00 
  800d27:	ff d0                	callq  *%rax
}
  800d29:	c9                   	leaveq 
  800d2a:	c3                   	retq   

0000000000800d2b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d2b:	55                   	push   %rbp
  800d2c:	48 89 e5             	mov    %rsp,%rbp
  800d2f:	48 83 ec 20          	sub    $0x20,%rsp
  800d33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d41:	48 98                	cltq   
  800d43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d4a:	00 
  800d4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d57:	48 89 d1             	mov    %rdx,%rcx
  800d5a:	48 89 c2             	mov    %rax,%rdx
  800d5d:	be 01 00 00 00       	mov    $0x1,%esi
  800d62:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d67:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800d6e:	00 00 00 
  800d71:	ff d0                	callq  *%rax
}
  800d73:	c9                   	leaveq 
  800d74:	c3                   	retq   

0000000000800d75 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d75:	55                   	push   %rbp
  800d76:	48 89 e5             	mov    %rsp,%rbp
  800d79:	48 83 ec 20          	sub    $0x20,%rsp
  800d7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d84:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d88:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d8e:	48 63 f0             	movslq %eax,%rsi
  800d91:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d98:	48 98                	cltq   
  800d9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800da5:	00 
  800da6:	49 89 f1             	mov    %rsi,%r9
  800da9:	49 89 c8             	mov    %rcx,%r8
  800dac:	48 89 d1             	mov    %rdx,%rcx
  800daf:	48 89 c2             	mov    %rax,%rdx
  800db2:	be 00 00 00 00       	mov    $0x0,%esi
  800db7:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dbc:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800dc3:	00 00 00 
  800dc6:	ff d0                	callq  *%rax
}
  800dc8:	c9                   	leaveq 
  800dc9:	c3                   	retq   

0000000000800dca <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dca:	55                   	push   %rbp
  800dcb:	48 89 e5             	mov    %rsp,%rbp
  800dce:	48 83 ec 10          	sub    $0x10,%rsp
  800dd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800dda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800de1:	00 
  800de2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800de8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800dee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df3:	48 89 c2             	mov    %rax,%rdx
  800df6:	be 01 00 00 00       	mov    $0x1,%esi
  800dfb:	bf 0d 00 00 00       	mov    $0xd,%edi
  800e00:	48 b8 cb 09 80 00 00 	movabs $0x8009cb,%rax
  800e07:	00 00 00 
  800e0a:	ff d0                	callq  *%rax
}
  800e0c:	c9                   	leaveq 
  800e0d:	c3                   	retq   

0000000000800e0e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800e0e:	55                   	push   %rbp
  800e0f:	48 89 e5             	mov    %rsp,%rbp
  800e12:	48 83 ec 08          	sub    $0x8,%rsp
  800e16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800e1e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800e25:	ff ff ff 
  800e28:	48 01 d0             	add    %rdx,%rax
  800e2b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800e2f:	c9                   	leaveq 
  800e30:	c3                   	retq   

0000000000800e31 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e31:	55                   	push   %rbp
  800e32:	48 89 e5             	mov    %rsp,%rbp
  800e35:	48 83 ec 08          	sub    $0x8,%rsp
  800e39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e41:	48 89 c7             	mov    %rax,%rdi
  800e44:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  800e4b:	00 00 00 
  800e4e:	ff d0                	callq  *%rax
  800e50:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800e56:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800e5a:	c9                   	leaveq 
  800e5b:	c3                   	retq   

0000000000800e5c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e5c:	55                   	push   %rbp
  800e5d:	48 89 e5             	mov    %rsp,%rbp
  800e60:	48 83 ec 18          	sub    $0x18,%rsp
  800e64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e6f:	eb 6b                	jmp    800edc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e74:	48 98                	cltq   
  800e76:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800e7c:	48 c1 e0 0c          	shl    $0xc,%rax
  800e80:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e88:	48 c1 e8 15          	shr    $0x15,%rax
  800e8c:	48 89 c2             	mov    %rax,%rdx
  800e8f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800e96:	01 00 00 
  800e99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800e9d:	83 e0 01             	and    $0x1,%eax
  800ea0:	48 85 c0             	test   %rax,%rax
  800ea3:	74 21                	je     800ec6 <fd_alloc+0x6a>
  800ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea9:	48 c1 e8 0c          	shr    $0xc,%rax
  800ead:	48 89 c2             	mov    %rax,%rdx
  800eb0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800eb7:	01 00 00 
  800eba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ebe:	83 e0 01             	and    $0x1,%eax
  800ec1:	48 85 c0             	test   %rax,%rax
  800ec4:	75 12                	jne    800ed8 <fd_alloc+0x7c>
			*fd_store = fd;
  800ec6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ece:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed6:	eb 1a                	jmp    800ef2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ed8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800edc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800ee0:	7e 8f                	jle    800e71 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800eed:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800ef2:	c9                   	leaveq 
  800ef3:	c3                   	retq   

0000000000800ef4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ef4:	55                   	push   %rbp
  800ef5:	48 89 e5             	mov    %rsp,%rbp
  800ef8:	48 83 ec 20          	sub    $0x20,%rsp
  800efc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800eff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800f07:	78 06                	js     800f0f <fd_lookup+0x1b>
  800f09:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800f0d:	7e 07                	jle    800f16 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f14:	eb 6c                	jmp    800f82 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800f16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f19:	48 98                	cltq   
  800f1b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f21:	48 c1 e0 0c          	shl    $0xc,%rax
  800f25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f2d:	48 c1 e8 15          	shr    $0x15,%rax
  800f31:	48 89 c2             	mov    %rax,%rdx
  800f34:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f3b:	01 00 00 
  800f3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f42:	83 e0 01             	and    $0x1,%eax
  800f45:	48 85 c0             	test   %rax,%rax
  800f48:	74 21                	je     800f6b <fd_lookup+0x77>
  800f4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f4e:	48 c1 e8 0c          	shr    $0xc,%rax
  800f52:	48 89 c2             	mov    %rax,%rdx
  800f55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f5c:	01 00 00 
  800f5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f63:	83 e0 01             	and    $0x1,%eax
  800f66:	48 85 c0             	test   %rax,%rax
  800f69:	75 07                	jne    800f72 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f70:	eb 10                	jmp    800f82 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800f72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f76:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f7a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 30          	sub    $0x30,%rsp
  800f8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800f90:	89 f0                	mov    %esi,%eax
  800f92:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f99:	48 89 c7             	mov    %rax,%rdi
  800f9c:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  800fa3:	00 00 00 
  800fa6:	ff d0                	callq  *%rax
  800fa8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800fac:	48 89 d6             	mov    %rdx,%rsi
  800faf:	89 c7                	mov    %eax,%edi
  800fb1:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
  800fbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fc4:	78 0a                	js     800fd0 <fd_close+0x4c>
	    || fd != fd2)
  800fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fca:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800fce:	74 12                	je     800fe2 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800fd0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800fd4:	74 05                	je     800fdb <fd_close+0x57>
  800fd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd9:	eb 05                	jmp    800fe0 <fd_close+0x5c>
  800fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe0:	eb 69                	jmp    80104b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fe2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800fe6:	8b 00                	mov    (%rax),%eax
  800fe8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800fec:	48 89 d6             	mov    %rdx,%rsi
  800fef:	89 c7                	mov    %eax,%edi
  800ff1:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  800ff8:	00 00 00 
  800ffb:	ff d0                	callq  *%rax
  800ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801004:	78 2a                	js     801030 <fd_close+0xac>
		if (dev->dev_close)
  801006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80100e:	48 85 c0             	test   %rax,%rax
  801011:	74 16                	je     801029 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801017:	48 8b 40 20          	mov    0x20(%rax),%rax
  80101b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80101f:	48 89 d7             	mov    %rdx,%rdi
  801022:	ff d0                	callq  *%rax
  801024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801027:	eb 07                	jmp    801030 <fd_close+0xac>
		else
			r = 0;
  801029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801030:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801034:	48 89 c6             	mov    %rax,%rsi
  801037:	bf 00 00 00 00       	mov    $0x0,%edi
  80103c:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  801043:	00 00 00 
  801046:	ff d0                	callq  *%rax
	return r;
  801048:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104b:	c9                   	leaveq 
  80104c:	c3                   	retq   

000000000080104d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80104d:	55                   	push   %rbp
  80104e:	48 89 e5             	mov    %rsp,%rbp
  801051:	48 83 ec 20          	sub    $0x20,%rsp
  801055:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801058:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80105c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801063:	eb 41                	jmp    8010a6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801065:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80106c:	00 00 00 
  80106f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801072:	48 63 d2             	movslq %edx,%rdx
  801075:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801079:	8b 00                	mov    (%rax),%eax
  80107b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80107e:	75 22                	jne    8010a2 <dev_lookup+0x55>
			*dev = devtab[i];
  801080:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801087:	00 00 00 
  80108a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80108d:	48 63 d2             	movslq %edx,%rdx
  801090:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801094:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801098:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80109b:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a0:	eb 60                	jmp    801102 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8010a6:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8010ad:	00 00 00 
  8010b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010b3:	48 63 d2             	movslq %edx,%rdx
  8010b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8010ba:	48 85 c0             	test   %rax,%rax
  8010bd:	75 a6                	jne    801065 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010bf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8010c6:	00 00 00 
  8010c9:	48 8b 00             	mov    (%rax),%rax
  8010cc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8010d2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8010d5:	89 c6                	mov    %eax,%esi
  8010d7:	48 bf 20 37 80 00 00 	movabs $0x803720,%rdi
  8010de:	00 00 00 
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e6:	48 b9 0c 29 80 00 00 	movabs $0x80290c,%rcx
  8010ed:	00 00 00 
  8010f0:	ff d1                	callq  *%rcx
	*dev = 0;
  8010f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8010fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801102:	c9                   	leaveq 
  801103:	c3                   	retq   

0000000000801104 <close>:

int
close(int fdnum)
{
  801104:	55                   	push   %rbp
  801105:	48 89 e5             	mov    %rsp,%rbp
  801108:	48 83 ec 20          	sub    $0x20,%rsp
  80110c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80110f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801116:	48 89 d6             	mov    %rdx,%rsi
  801119:	89 c7                	mov    %eax,%edi
  80111b:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  801122:	00 00 00 
  801125:	ff d0                	callq  *%rax
  801127:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80112a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80112e:	79 05                	jns    801135 <close+0x31>
		return r;
  801130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801133:	eb 18                	jmp    80114d <close+0x49>
	else
		return fd_close(fd, 1);
  801135:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801139:	be 01 00 00 00       	mov    $0x1,%esi
  80113e:	48 89 c7             	mov    %rax,%rdi
  801141:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  801148:	00 00 00 
  80114b:	ff d0                	callq  *%rax
}
  80114d:	c9                   	leaveq 
  80114e:	c3                   	retq   

000000000080114f <close_all>:

void
close_all(void)
{
  80114f:	55                   	push   %rbp
  801150:	48 89 e5             	mov    %rsp,%rbp
  801153:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80115e:	eb 15                	jmp    801175 <close_all+0x26>
		close(i);
  801160:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801163:	89 c7                	mov    %eax,%edi
  801165:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801175:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801179:	7e e5                	jle    801160 <close_all+0x11>
		close(i);
}
  80117b:	c9                   	leaveq 
  80117c:	c3                   	retq   

000000000080117d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80117d:	55                   	push   %rbp
  80117e:	48 89 e5             	mov    %rsp,%rbp
  801181:	48 83 ec 40          	sub    $0x40,%rsp
  801185:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801188:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80118b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80118f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801192:	48 89 d6             	mov    %rdx,%rsi
  801195:	89 c7                	mov    %eax,%edi
  801197:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  80119e:	00 00 00 
  8011a1:	ff d0                	callq  *%rax
  8011a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011aa:	79 08                	jns    8011b4 <dup+0x37>
		return r;
  8011ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011af:	e9 70 01 00 00       	jmpq   801324 <dup+0x1a7>
	close(newfdnum);
  8011b4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011b7:	89 c7                	mov    %eax,%edi
  8011b9:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  8011c0:	00 00 00 
  8011c3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8011c5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011c8:	48 98                	cltq   
  8011ca:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8011d0:	48 c1 e0 0c          	shl    $0xc,%rax
  8011d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8011d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011dc:	48 89 c7             	mov    %rax,%rdi
  8011df:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  8011e6:	00 00 00 
  8011e9:	ff d0                	callq  *%rax
  8011eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8011ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f3:	48 89 c7             	mov    %rax,%rdi
  8011f6:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  8011fd:	00 00 00 
  801200:	ff d0                	callq  *%rax
  801202:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120a:	48 c1 e8 15          	shr    $0x15,%rax
  80120e:	48 89 c2             	mov    %rax,%rdx
  801211:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801218:	01 00 00 
  80121b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80121f:	83 e0 01             	and    $0x1,%eax
  801222:	48 85 c0             	test   %rax,%rax
  801225:	74 73                	je     80129a <dup+0x11d>
  801227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122b:	48 c1 e8 0c          	shr    $0xc,%rax
  80122f:	48 89 c2             	mov    %rax,%rdx
  801232:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801239:	01 00 00 
  80123c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801240:	83 e0 01             	and    $0x1,%eax
  801243:	48 85 c0             	test   %rax,%rax
  801246:	74 52                	je     80129a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124c:	48 c1 e8 0c          	shr    $0xc,%rax
  801250:	48 89 c2             	mov    %rax,%rdx
  801253:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80125a:	01 00 00 
  80125d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801261:	25 07 0e 00 00       	and    $0xe07,%eax
  801266:	89 c1                	mov    %eax,%ecx
  801268:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801270:	41 89 c8             	mov    %ecx,%r8d
  801273:	48 89 d1             	mov    %rdx,%rcx
  801276:	ba 00 00 00 00       	mov    $0x0,%edx
  80127b:	48 89 c6             	mov    %rax,%rsi
  80127e:	bf 00 00 00 00       	mov    $0x0,%edi
  801283:	48 b8 f1 0b 80 00 00 	movabs $0x800bf1,%rax
  80128a:	00 00 00 
  80128d:	ff d0                	callq  *%rax
  80128f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801296:	79 02                	jns    80129a <dup+0x11d>
			goto err;
  801298:	eb 57                	jmp    8012f1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80129a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129e:	48 c1 e8 0c          	shr    $0xc,%rax
  8012a2:	48 89 c2             	mov    %rax,%rdx
  8012a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8012ac:	01 00 00 
  8012af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b8:	89 c1                	mov    %eax,%ecx
  8012ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012c2:	41 89 c8             	mov    %ecx,%r8d
  8012c5:	48 89 d1             	mov    %rdx,%rcx
  8012c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cd:	48 89 c6             	mov    %rax,%rsi
  8012d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8012d5:	48 b8 f1 0b 80 00 00 	movabs $0x800bf1,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
  8012e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e8:	79 02                	jns    8012ec <dup+0x16f>
		goto err;
  8012ea:	eb 05                	jmp    8012f1 <dup+0x174>

	return newfdnum;
  8012ec:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012ef:	eb 33                	jmp    801324 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	48 89 c6             	mov    %rax,%rsi
  8012f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fd:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  801304:	00 00 00 
  801307:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130d:	48 89 c6             	mov    %rax,%rsi
  801310:	bf 00 00 00 00       	mov    $0x0,%edi
  801315:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  80131c:	00 00 00 
  80131f:	ff d0                	callq  *%rax
	return r;
  801321:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801324:	c9                   	leaveq 
  801325:	c3                   	retq   

0000000000801326 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801326:	55                   	push   %rbp
  801327:	48 89 e5             	mov    %rsp,%rbp
  80132a:	48 83 ec 40          	sub    $0x40,%rsp
  80132e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801331:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801335:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801339:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80133d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801340:	48 89 d6             	mov    %rdx,%rsi
  801343:	89 c7                	mov    %eax,%edi
  801345:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  80134c:	00 00 00 
  80134f:	ff d0                	callq  *%rax
  801351:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801354:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801358:	78 24                	js     80137e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135e:	8b 00                	mov    (%rax),%eax
  801360:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801364:	48 89 d6             	mov    %rdx,%rsi
  801367:	89 c7                	mov    %eax,%edi
  801369:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  801370:	00 00 00 
  801373:	ff d0                	callq  *%rax
  801375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80137c:	79 05                	jns    801383 <read+0x5d>
		return r;
  80137e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801381:	eb 76                	jmp    8013f9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801387:	8b 40 08             	mov    0x8(%rax),%eax
  80138a:	83 e0 03             	and    $0x3,%eax
  80138d:	83 f8 01             	cmp    $0x1,%eax
  801390:	75 3a                	jne    8013cc <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801392:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801399:	00 00 00 
  80139c:	48 8b 00             	mov    (%rax),%rax
  80139f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8013a5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8013a8:	89 c6                	mov    %eax,%esi
  8013aa:	48 bf 3f 37 80 00 00 	movabs $0x80373f,%rdi
  8013b1:	00 00 00 
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b9:	48 b9 0c 29 80 00 00 	movabs $0x80290c,%rcx
  8013c0:	00 00 00 
  8013c3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8013c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ca:	eb 2d                	jmp    8013f9 <read+0xd3>
	}
	if (!dev->dev_read)
  8013cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013d4:	48 85 c0             	test   %rax,%rax
  8013d7:	75 07                	jne    8013e0 <read+0xba>
		return -E_NOT_SUPP;
  8013d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8013de:	eb 19                	jmp    8013f9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8013e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013ec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013f0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8013f4:	48 89 cf             	mov    %rcx,%rdi
  8013f7:	ff d0                	callq  *%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 30          	sub    $0x30,%rsp
  801403:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801406:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80140e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801415:	eb 49                	jmp    801460 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141a:	48 98                	cltq   
  80141c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801420:	48 29 c2             	sub    %rax,%rdx
  801423:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801426:	48 63 c8             	movslq %eax,%rcx
  801429:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142d:	48 01 c1             	add    %rax,%rcx
  801430:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801433:	48 89 ce             	mov    %rcx,%rsi
  801436:	89 c7                	mov    %eax,%edi
  801438:	48 b8 26 13 80 00 00 	movabs $0x801326,%rax
  80143f:	00 00 00 
  801442:	ff d0                	callq  *%rax
  801444:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801447:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80144b:	79 05                	jns    801452 <readn+0x57>
			return m;
  80144d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801450:	eb 1c                	jmp    80146e <readn+0x73>
		if (m == 0)
  801452:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801456:	75 02                	jne    80145a <readn+0x5f>
			break;
  801458:	eb 11                	jmp    80146b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80145a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80145d:	01 45 fc             	add    %eax,-0x4(%rbp)
  801460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801463:	48 98                	cltq   
  801465:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801469:	72 ac                	jb     801417 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80146b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80146e:	c9                   	leaveq 
  80146f:	c3                   	retq   

0000000000801470 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801470:	55                   	push   %rbp
  801471:	48 89 e5             	mov    %rsp,%rbp
  801474:	48 83 ec 40          	sub    $0x40,%rsp
  801478:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80147b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80147f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801483:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801487:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80148a:	48 89 d6             	mov    %rdx,%rsi
  80148d:	89 c7                	mov    %eax,%edi
  80148f:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  801496:	00 00 00 
  801499:	ff d0                	callq  *%rax
  80149b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80149e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a2:	78 24                	js     8014c8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a8:	8b 00                	mov    (%rax),%eax
  8014aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8014ae:	48 89 d6             	mov    %rdx,%rsi
  8014b1:	89 c7                	mov    %eax,%edi
  8014b3:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  8014ba:	00 00 00 
  8014bd:	ff d0                	callq  *%rax
  8014bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014c6:	79 05                	jns    8014cd <write+0x5d>
		return r;
  8014c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014cb:	eb 75                	jmp    801542 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d1:	8b 40 08             	mov    0x8(%rax),%eax
  8014d4:	83 e0 03             	and    $0x3,%eax
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	75 3a                	jne    801515 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014db:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8014e2:	00 00 00 
  8014e5:	48 8b 00             	mov    (%rax),%rax
  8014e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8014ee:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8014f1:	89 c6                	mov    %eax,%esi
  8014f3:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  8014fa:	00 00 00 
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	48 b9 0c 29 80 00 00 	movabs $0x80290c,%rcx
  801509:	00 00 00 
  80150c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80150e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801513:	eb 2d                	jmp    801542 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801519:	48 8b 40 18          	mov    0x18(%rax),%rax
  80151d:	48 85 c0             	test   %rax,%rax
  801520:	75 07                	jne    801529 <write+0xb9>
		return -E_NOT_SUPP;
  801522:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801527:	eb 19                	jmp    801542 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  801529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152d:	48 8b 40 18          	mov    0x18(%rax),%rax
  801531:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801535:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801539:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80153d:	48 89 cf             	mov    %rcx,%rdi
  801540:	ff d0                	callq  *%rax
}
  801542:	c9                   	leaveq 
  801543:	c3                   	retq   

0000000000801544 <seek>:

int
seek(int fdnum, off_t offset)
{
  801544:	55                   	push   %rbp
  801545:	48 89 e5             	mov    %rsp,%rbp
  801548:	48 83 ec 18          	sub    $0x18,%rsp
  80154c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80154f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801552:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801556:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801559:	48 89 d6             	mov    %rdx,%rsi
  80155c:	89 c7                	mov    %eax,%edi
  80155e:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  801565:	00 00 00 
  801568:	ff d0                	callq  *%rax
  80156a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80156d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801571:	79 05                	jns    801578 <seek+0x34>
		return r;
  801573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801576:	eb 0f                	jmp    801587 <seek+0x43>
	fd->fd_offset = offset;
  801578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80157f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801587:	c9                   	leaveq 
  801588:	c3                   	retq   

0000000000801589 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801589:	55                   	push   %rbp
  80158a:	48 89 e5             	mov    %rsp,%rbp
  80158d:	48 83 ec 30          	sub    $0x30,%rsp
  801591:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801594:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801597:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80159b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80159e:	48 89 d6             	mov    %rdx,%rsi
  8015a1:	89 c7                	mov    %eax,%edi
  8015a3:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  8015aa:	00 00 00 
  8015ad:	ff d0                	callq  *%rax
  8015af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015b6:	78 24                	js     8015dc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bc:	8b 00                	mov    (%rax),%eax
  8015be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015c2:	48 89 d6             	mov    %rdx,%rsi
  8015c5:	89 c7                	mov    %eax,%edi
  8015c7:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	callq  *%rax
  8015d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015da:	79 05                	jns    8015e1 <ftruncate+0x58>
		return r;
  8015dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015df:	eb 72                	jmp    801653 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e5:	8b 40 08             	mov    0x8(%rax),%eax
  8015e8:	83 e0 03             	and    $0x3,%eax
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	75 3a                	jne    801629 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015ef:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015f6:	00 00 00 
  8015f9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015fc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801602:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801605:	89 c6                	mov    %eax,%esi
  801607:	48 bf 78 37 80 00 00 	movabs $0x803778,%rdi
  80160e:	00 00 00 
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	48 b9 0c 29 80 00 00 	movabs $0x80290c,%rcx
  80161d:	00 00 00 
  801620:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801622:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801627:	eb 2a                	jmp    801653 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162d:	48 8b 40 30          	mov    0x30(%rax),%rax
  801631:	48 85 c0             	test   %rax,%rax
  801634:	75 07                	jne    80163d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801636:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80163b:	eb 16                	jmp    801653 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80163d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801641:	48 8b 40 30          	mov    0x30(%rax),%rax
  801645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801649:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80164c:	89 ce                	mov    %ecx,%esi
  80164e:	48 89 d7             	mov    %rdx,%rdi
  801651:	ff d0                	callq  *%rax
}
  801653:	c9                   	leaveq 
  801654:	c3                   	retq   

0000000000801655 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801655:	55                   	push   %rbp
  801656:	48 89 e5             	mov    %rsp,%rbp
  801659:	48 83 ec 30          	sub    $0x30,%rsp
  80165d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801660:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801664:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801668:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166b:	48 89 d6             	mov    %rdx,%rsi
  80166e:	89 c7                	mov    %eax,%edi
  801670:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  801677:	00 00 00 
  80167a:	ff d0                	callq  *%rax
  80167c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80167f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801683:	78 24                	js     8016a9 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801689:	8b 00                	mov    (%rax),%eax
  80168b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80168f:	48 89 d6             	mov    %rdx,%rsi
  801692:	89 c7                	mov    %eax,%edi
  801694:	48 b8 4d 10 80 00 00 	movabs $0x80104d,%rax
  80169b:	00 00 00 
  80169e:	ff d0                	callq  *%rax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a7:	79 05                	jns    8016ae <fstat+0x59>
		return r;
  8016a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ac:	eb 5e                	jmp    80170c <fstat+0xb7>
	if (!dev->dev_stat)
  8016ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016b6:	48 85 c0             	test   %rax,%rax
  8016b9:	75 07                	jne    8016c2 <fstat+0x6d>
		return -E_NOT_SUPP;
  8016bb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016c0:	eb 4a                	jmp    80170c <fstat+0xb7>
	stat->st_name[0] = 0;
  8016c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8016c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016cd:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8016d4:	00 00 00 
	stat->st_isdir = 0;
  8016d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016db:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8016e2:	00 00 00 
	stat->st_dev = dev;
  8016e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ed:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8016f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801700:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801704:	48 89 ce             	mov    %rcx,%rsi
  801707:	48 89 d7             	mov    %rdx,%rdi
  80170a:	ff d0                	callq  *%rax
}
  80170c:	c9                   	leaveq 
  80170d:	c3                   	retq   

000000000080170e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80170e:	55                   	push   %rbp
  80170f:	48 89 e5             	mov    %rsp,%rbp
  801712:	48 83 ec 20          	sub    $0x20,%rsp
  801716:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80171a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801722:	be 00 00 00 00       	mov    $0x0,%esi
  801727:	48 89 c7             	mov    %rax,%rdi
  80172a:	48 b8 fc 17 80 00 00 	movabs $0x8017fc,%rax
  801731:	00 00 00 
  801734:	ff d0                	callq  *%rax
  801736:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801739:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173d:	79 05                	jns    801744 <stat+0x36>
		return fd;
  80173f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801742:	eb 2f                	jmp    801773 <stat+0x65>
	r = fstat(fd, stat);
  801744:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801748:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174b:	48 89 d6             	mov    %rdx,%rsi
  80174e:	89 c7                	mov    %eax,%edi
  801750:	48 b8 55 16 80 00 00 	movabs $0x801655,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
  80175c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80175f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801762:	89 c7                	mov    %eax,%edi
  801764:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  80176b:	00 00 00 
  80176e:	ff d0                	callq  *%rax
	return r;
  801770:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	48 83 ec 10          	sub    $0x10,%rsp
  80177d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801780:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801784:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80178b:	00 00 00 
  80178e:	8b 00                	mov    (%rax),%eax
  801790:	85 c0                	test   %eax,%eax
  801792:	75 1d                	jne    8017b1 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801794:	bf 01 00 00 00       	mov    $0x1,%edi
  801799:	48 b8 c1 35 80 00 00 	movabs $0x8035c1,%rax
  8017a0:	00 00 00 
  8017a3:	ff d0                	callq  *%rax
  8017a5:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8017ac:	00 00 00 
  8017af:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017b1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8017b8:	00 00 00 
  8017bb:	8b 00                	mov    (%rax),%eax
  8017bd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8017c0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8017c5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8017cc:	00 00 00 
  8017cf:	89 c7                	mov    %eax,%edi
  8017d1:	48 b8 29 35 80 00 00 	movabs $0x803529,%rax
  8017d8:	00 00 00 
  8017db:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8017dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e6:	48 89 c6             	mov    %rax,%rsi
  8017e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ee:	48 b8 68 34 80 00 00 	movabs $0x803468,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
}
  8017fa:	c9                   	leaveq 
  8017fb:	c3                   	retq   

00000000008017fc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017fc:	55                   	push   %rbp
  8017fd:	48 89 e5             	mov    %rsp,%rbp
  801800:	48 83 ec 20          	sub    $0x20,%rsp
  801804:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801808:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180f:	48 89 c7             	mov    %rax,%rdi
  801812:	48 b8 06 02 80 00 00 	movabs $0x800206,%rax
  801819:	00 00 00 
  80181c:	ff d0                	callq  *%rax
  80181e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801823:	7e 0a                	jle    80182f <open+0x33>
		return -E_BAD_PATH;
  801825:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80182a:	e9 a5 00 00 00       	jmpq   8018d4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80182f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801833:	48 89 c7             	mov    %rax,%rdi
  801836:	48 b8 5c 0e 80 00 00 	movabs $0x800e5c,%rax
  80183d:	00 00 00 
  801840:	ff d0                	callq  *%rax
  801842:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801845:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801849:	79 08                	jns    801853 <open+0x57>
		return r;
  80184b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184e:	e9 81 00 00 00       	jmpq   8018d4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  801853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801857:	48 89 c6             	mov    %rax,%rsi
  80185a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801861:	00 00 00 
  801864:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  80186b:	00 00 00 
  80186e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  801870:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801877:	00 00 00 
  80187a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80187d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801887:	48 89 c6             	mov    %rax,%rsi
  80188a:	bf 01 00 00 00       	mov    $0x1,%edi
  80188f:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801896:	00 00 00 
  801899:	ff d0                	callq  *%rax
  80189b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80189e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a2:	79 1d                	jns    8018c1 <open+0xc5>
		fd_close(fd, 0);
  8018a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a8:	be 00 00 00 00       	mov    $0x0,%esi
  8018ad:	48 89 c7             	mov    %rax,%rdi
  8018b0:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  8018b7:	00 00 00 
  8018ba:	ff d0                	callq  *%rax
		return r;
  8018bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018bf:	eb 13                	jmp    8018d4 <open+0xd8>
	}

	return fd2num(fd);
  8018c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c5:	48 89 c7             	mov    %rax,%rdi
  8018c8:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  8018cf:	00 00 00 
  8018d2:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8018d4:	c9                   	leaveq 
  8018d5:	c3                   	retq   

00000000008018d6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018d6:	55                   	push   %rbp
  8018d7:	48 89 e5             	mov    %rsp,%rbp
  8018da:	48 83 ec 10          	sub    $0x10,%rsp
  8018de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e6:	8b 50 0c             	mov    0xc(%rax),%edx
  8018e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8018f0:	00 00 00 
  8018f3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8018f5:	be 00 00 00 00       	mov    $0x0,%esi
  8018fa:	bf 06 00 00 00       	mov    $0x6,%edi
  8018ff:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 30          	sub    $0x30,%rsp
  801915:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801919:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80191d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801925:	8b 50 0c             	mov    0xc(%rax),%edx
  801928:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80192f:	00 00 00 
  801932:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801934:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80193b:	00 00 00 
  80193e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801942:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801946:	be 00 00 00 00       	mov    $0x0,%esi
  80194b:	bf 03 00 00 00       	mov    $0x3,%edi
  801950:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801957:	00 00 00 
  80195a:	ff d0                	callq  *%rax
  80195c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80195f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801963:	79 08                	jns    80196d <devfile_read+0x60>
		return r;
  801965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801968:	e9 a4 00 00 00       	jmpq   801a11 <devfile_read+0x104>
	assert(r <= n);
  80196d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801970:	48 98                	cltq   
  801972:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801976:	76 35                	jbe    8019ad <devfile_read+0xa0>
  801978:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  80197f:	00 00 00 
  801982:	48 ba ac 37 80 00 00 	movabs $0x8037ac,%rdx
  801989:	00 00 00 
  80198c:	be 84 00 00 00       	mov    $0x84,%esi
  801991:	48 bf c1 37 80 00 00 	movabs $0x8037c1,%rdi
  801998:	00 00 00 
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a0:	49 b8 d3 26 80 00 00 	movabs $0x8026d3,%r8
  8019a7:	00 00 00 
  8019aa:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8019ad:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8019b4:	7e 35                	jle    8019eb <devfile_read+0xde>
  8019b6:	48 b9 cc 37 80 00 00 	movabs $0x8037cc,%rcx
  8019bd:	00 00 00 
  8019c0:	48 ba ac 37 80 00 00 	movabs $0x8037ac,%rdx
  8019c7:	00 00 00 
  8019ca:	be 85 00 00 00       	mov    $0x85,%esi
  8019cf:	48 bf c1 37 80 00 00 	movabs $0x8037c1,%rdi
  8019d6:	00 00 00 
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019de:	49 b8 d3 26 80 00 00 	movabs $0x8026d3,%r8
  8019e5:	00 00 00 
  8019e8:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ee:	48 63 d0             	movslq %eax,%rdx
  8019f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019f5:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8019fc:	00 00 00 
  8019ff:	48 89 c7             	mov    %rax,%rdi
  801a02:	48 b8 96 05 80 00 00 	movabs $0x800596,%rax
  801a09:	00 00 00 
  801a0c:	ff d0                	callq  *%rax
	return r;
  801a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  801a11:	c9                   	leaveq 
  801a12:	c3                   	retq   

0000000000801a13 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a13:	55                   	push   %rbp
  801a14:	48 89 e5             	mov    %rsp,%rbp
  801a17:	48 83 ec 30          	sub    $0x30,%rsp
  801a1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a23:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2b:	8b 50 0c             	mov    0xc(%rax),%edx
  801a2e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a35:	00 00 00 
  801a38:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801a3a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a41:	00 00 00 
  801a44:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a48:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a4c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801a53:	00 
  801a54:	76 35                	jbe    801a8b <devfile_write+0x78>
  801a56:	48 b9 d8 37 80 00 00 	movabs $0x8037d8,%rcx
  801a5d:	00 00 00 
  801a60:	48 ba ac 37 80 00 00 	movabs $0x8037ac,%rdx
  801a67:	00 00 00 
  801a6a:	be 9e 00 00 00       	mov    $0x9e,%esi
  801a6f:	48 bf c1 37 80 00 00 	movabs $0x8037c1,%rdi
  801a76:	00 00 00 
  801a79:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7e:	49 b8 d3 26 80 00 00 	movabs $0x8026d3,%r8
  801a85:	00 00 00 
  801a88:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801a8b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a93:	48 89 c6             	mov    %rax,%rsi
  801a96:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801a9d:	00 00 00 
  801aa0:	48 b8 ad 06 80 00 00 	movabs $0x8006ad,%rax
  801aa7:	00 00 00 
  801aaa:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801aac:	be 00 00 00 00       	mov    $0x0,%esi
  801ab1:	bf 04 00 00 00       	mov    $0x4,%edi
  801ab6:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801abd:	00 00 00 
  801ac0:	ff d0                	callq  *%rax
  801ac2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ac9:	79 05                	jns    801ad0 <devfile_write+0xbd>
		return r;
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ace:	eb 43                	jmp    801b13 <devfile_write+0x100>
	assert(r <= n);
  801ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad3:	48 98                	cltq   
  801ad5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801ad9:	76 35                	jbe    801b10 <devfile_write+0xfd>
  801adb:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  801ae2:	00 00 00 
  801ae5:	48 ba ac 37 80 00 00 	movabs $0x8037ac,%rdx
  801aec:	00 00 00 
  801aef:	be a2 00 00 00       	mov    $0xa2,%esi
  801af4:	48 bf c1 37 80 00 00 	movabs $0x8037c1,%rdi
  801afb:	00 00 00 
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
  801b03:	49 b8 d3 26 80 00 00 	movabs $0x8026d3,%r8
  801b0a:	00 00 00 
  801b0d:	41 ff d0             	callq  *%r8
	return r;
  801b10:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  801b13:	c9                   	leaveq 
  801b14:	c3                   	retq   

0000000000801b15 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	48 83 ec 20          	sub    $0x20,%rsp
  801b1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b29:	8b 50 0c             	mov    0xc(%rax),%edx
  801b2c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b33:	00 00 00 
  801b36:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b38:	be 00 00 00 00       	mov    $0x0,%esi
  801b3d:	bf 05 00 00 00       	mov    $0x5,%edi
  801b42:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801b49:	00 00 00 
  801b4c:	ff d0                	callq  *%rax
  801b4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b55:	79 05                	jns    801b5c <devfile_stat+0x47>
		return r;
  801b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5a:	eb 56                	jmp    801bb2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b60:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801b67:	00 00 00 
  801b6a:	48 89 c7             	mov    %rax,%rdi
  801b6d:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801b79:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b80:	00 00 00 
  801b83:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801b89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b8d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b93:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801b9a:	00 00 00 
  801b9d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801ba3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb2:	c9                   	leaveq 
  801bb3:	c3                   	retq   

0000000000801bb4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bb4:	55                   	push   %rbp
  801bb5:	48 89 e5             	mov    %rsp,%rbp
  801bb8:	48 83 ec 10          	sub    $0x10,%rsp
  801bbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc7:	8b 50 0c             	mov    0xc(%rax),%edx
  801bca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bd1:	00 00 00 
  801bd4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801bd6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801bdd:	00 00 00 
  801be0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801be3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801be6:	be 00 00 00 00       	mov    $0x0,%esi
  801beb:	bf 02 00 00 00       	mov    $0x2,%edi
  801bf0:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	callq  *%rax
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <remove>:

// Delete a file
int
remove(const char *path)
{
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 10          	sub    $0x10,%rsp
  801c06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801c0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0e:	48 89 c7             	mov    %rax,%rdi
  801c11:	48 b8 06 02 80 00 00 	movabs $0x800206,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	callq  *%rax
  801c1d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c22:	7e 07                	jle    801c2b <remove+0x2d>
		return -E_BAD_PATH;
  801c24:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801c29:	eb 33                	jmp    801c5e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2f:	48 89 c6             	mov    %rax,%rsi
  801c32:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801c39:	00 00 00 
  801c3c:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801c48:	be 00 00 00 00       	mov    $0x0,%esi
  801c4d:	bf 07 00 00 00       	mov    $0x7,%edi
  801c52:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
}
  801c5e:	c9                   	leaveq 
  801c5f:	c3                   	retq   

0000000000801c60 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801c60:	55                   	push   %rbp
  801c61:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c64:	be 00 00 00 00       	mov    $0x0,%esi
  801c69:	bf 08 00 00 00       	mov    $0x8,%edi
  801c6e:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801c75:	00 00 00 
  801c78:	ff d0                	callq  *%rax
}
  801c7a:	5d                   	pop    %rbp
  801c7b:	c3                   	retq   

0000000000801c7c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801c7c:	55                   	push   %rbp
  801c7d:	48 89 e5             	mov    %rsp,%rbp
  801c80:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801c87:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801c8e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801c95:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801c9c:	be 00 00 00 00       	mov    $0x0,%esi
  801ca1:	48 89 c7             	mov    %rax,%rdi
  801ca4:	48 b8 fc 17 80 00 00 	movabs $0x8017fc,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	callq  *%rax
  801cb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801cb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cb7:	79 28                	jns    801ce1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbc:	89 c6                	mov    %eax,%esi
  801cbe:	48 bf 05 38 80 00 00 	movabs $0x803805,%rdi
  801cc5:	00 00 00 
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccd:	48 ba 0c 29 80 00 00 	movabs $0x80290c,%rdx
  801cd4:	00 00 00 
  801cd7:	ff d2                	callq  *%rdx
		return fd_src;
  801cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdc:	e9 74 01 00 00       	jmpq   801e55 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801ce1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801ce8:	be 01 01 00 00       	mov    $0x101,%esi
  801ced:	48 89 c7             	mov    %rax,%rdi
  801cf0:	48 b8 fc 17 80 00 00 	movabs $0x8017fc,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	callq  *%rax
  801cfc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801cff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d03:	79 39                	jns    801d3e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801d05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d08:	89 c6                	mov    %eax,%esi
  801d0a:	48 bf 1b 38 80 00 00 	movabs $0x80381b,%rdi
  801d11:	00 00 00 
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	48 ba 0c 29 80 00 00 	movabs $0x80290c,%rdx
  801d20:	00 00 00 
  801d23:	ff d2                	callq  *%rdx
		close(fd_src);
  801d25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d28:	89 c7                	mov    %eax,%edi
  801d2a:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801d31:	00 00 00 
  801d34:	ff d0                	callq  *%rax
		return fd_dest;
  801d36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d39:	e9 17 01 00 00       	jmpq   801e55 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801d3e:	eb 74                	jmp    801db4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801d40:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d43:	48 63 d0             	movslq %eax,%rdx
  801d46:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801d4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d50:	48 89 ce             	mov    %rcx,%rsi
  801d53:	89 c7                	mov    %eax,%edi
  801d55:	48 b8 70 14 80 00 00 	movabs $0x801470,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
  801d61:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d68:	79 4a                	jns    801db4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801d6a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d6d:	89 c6                	mov    %eax,%esi
  801d6f:	48 bf 35 38 80 00 00 	movabs $0x803835,%rdi
  801d76:	00 00 00 
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	48 ba 0c 29 80 00 00 	movabs $0x80290c,%rdx
  801d85:	00 00 00 
  801d88:	ff d2                	callq  *%rdx
			close(fd_src);
  801d8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8d:	89 c7                	mov    %eax,%edi
  801d8f:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801d96:	00 00 00 
  801d99:	ff d0                	callq  *%rax
			close(fd_dest);
  801d9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9e:	89 c7                	mov    %eax,%edi
  801da0:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801da7:	00 00 00 
  801daa:	ff d0                	callq  *%rax
			return write_size;
  801dac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801daf:	e9 a1 00 00 00       	jmpq   801e55 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801db4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801dbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbe:	ba 00 02 00 00       	mov    $0x200,%edx
  801dc3:	48 89 ce             	mov    %rcx,%rsi
  801dc6:	89 c7                	mov    %eax,%edi
  801dc8:	48 b8 26 13 80 00 00 	movabs $0x801326,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	callq  *%rax
  801dd4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ddb:	0f 8f 5f ff ff ff    	jg     801d40 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  801de1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801de5:	79 47                	jns    801e2e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801de7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dea:	89 c6                	mov    %eax,%esi
  801dec:	48 bf 48 38 80 00 00 	movabs $0x803848,%rdi
  801df3:	00 00 00 
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfb:	48 ba 0c 29 80 00 00 	movabs $0x80290c,%rdx
  801e02:	00 00 00 
  801e05:	ff d2                	callq  *%rdx
		close(fd_src);
  801e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0a:	89 c7                	mov    %eax,%edi
  801e0c:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	callq  *%rax
		close(fd_dest);
  801e18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1b:	89 c7                	mov    %eax,%edi
  801e1d:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801e24:	00 00 00 
  801e27:	ff d0                	callq  *%rax
		return read_size;
  801e29:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e2c:	eb 27                	jmp    801e55 <copy+0x1d9>
	}
	close(fd_src);
  801e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e31:	89 c7                	mov    %eax,%edi
  801e33:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801e3a:	00 00 00 
  801e3d:	ff d0                	callq  *%rax
	close(fd_dest);
  801e3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e42:	89 c7                	mov    %eax,%edi
  801e44:	48 b8 04 11 80 00 00 	movabs $0x801104,%rax
  801e4b:	00 00 00 
  801e4e:	ff d0                	callq  *%rax
	return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801e55:	c9                   	leaveq 
  801e56:	c3                   	retq   

0000000000801e57 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e57:	55                   	push   %rbp
  801e58:	48 89 e5             	mov    %rsp,%rbp
  801e5b:	53                   	push   %rbx
  801e5c:	48 83 ec 38          	sub    $0x38,%rsp
  801e60:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e64:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801e68:	48 89 c7             	mov    %rax,%rdi
  801e6b:	48 b8 5c 0e 80 00 00 	movabs $0x800e5c,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	callq  *%rax
  801e77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e7e:	0f 88 bf 01 00 00    	js     802043 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e88:	ba 07 04 00 00       	mov    $0x407,%edx
  801e8d:	48 89 c6             	mov    %rax,%rsi
  801e90:	bf 00 00 00 00       	mov    $0x0,%edi
  801e95:	48 b8 a1 0b 80 00 00 	movabs $0x800ba1,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ea4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ea8:	0f 88 95 01 00 00    	js     802043 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801eae:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801eb2:	48 89 c7             	mov    %rax,%rdi
  801eb5:	48 b8 5c 0e 80 00 00 	movabs $0x800e5c,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
  801ec1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ec4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ec8:	0f 88 5d 01 00 00    	js     80202b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ece:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ed2:	ba 07 04 00 00       	mov    $0x407,%edx
  801ed7:	48 89 c6             	mov    %rax,%rsi
  801eda:	bf 00 00 00 00       	mov    $0x0,%edi
  801edf:	48 b8 a1 0b 80 00 00 	movabs $0x800ba1,%rax
  801ee6:	00 00 00 
  801ee9:	ff d0                	callq  *%rax
  801eeb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef2:	0f 88 33 01 00 00    	js     80202b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801ef8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efc:	48 89 c7             	mov    %rax,%rdi
  801eff:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
  801f0b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f13:	ba 07 04 00 00       	mov    $0x407,%edx
  801f18:	48 89 c6             	mov    %rax,%rsi
  801f1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f20:	48 b8 a1 0b 80 00 00 	movabs $0x800ba1,%rax
  801f27:	00 00 00 
  801f2a:	ff d0                	callq  *%rax
  801f2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f33:	79 05                	jns    801f3a <pipe+0xe3>
		goto err2;
  801f35:	e9 d9 00 00 00       	jmpq   802013 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f3e:	48 89 c7             	mov    %rax,%rdi
  801f41:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  801f48:	00 00 00 
  801f4b:	ff d0                	callq  *%rax
  801f4d:	48 89 c2             	mov    %rax,%rdx
  801f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f54:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801f5a:	48 89 d1             	mov    %rdx,%rcx
  801f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f62:	48 89 c6             	mov    %rax,%rsi
  801f65:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6a:	48 b8 f1 0b 80 00 00 	movabs $0x800bf1,%rax
  801f71:	00 00 00 
  801f74:	ff d0                	callq  *%rax
  801f76:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f79:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f7d:	79 1b                	jns    801f9a <pipe+0x143>
		goto err3;
  801f7f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801f80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f84:	48 89 c6             	mov    %rax,%rsi
  801f87:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8c:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	eb 79                	jmp    802013 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801fa5:	00 00 00 
  801fa8:	8b 12                	mov    (%rdx),%edx
  801faa:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801fac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbb:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801fc2:	00 00 00 
  801fc5:	8b 12                	mov    (%rdx),%edx
  801fc7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801fc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fcd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd8:	48 89 c7             	mov    %rax,%rdi
  801fdb:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	callq  *%rax
  801fe7:	89 c2                	mov    %eax,%edx
  801fe9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801fed:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801fef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ff3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801ff7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ffb:	48 89 c7             	mov    %rax,%rdi
  801ffe:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  802005:	00 00 00 
  802008:	ff d0                	callq  *%rax
  80200a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
  802011:	eb 33                	jmp    802046 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802013:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802017:	48 89 c6             	mov    %rax,%rsi
  80201a:	bf 00 00 00 00       	mov    $0x0,%edi
  80201f:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  802026:	00 00 00 
  802029:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80202b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202f:	48 89 c6             	mov    %rax,%rsi
  802032:	bf 00 00 00 00       	mov    $0x0,%edi
  802037:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  80203e:	00 00 00 
  802041:	ff d0                	callq  *%rax
err:
	return r;
  802043:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802046:	48 83 c4 38          	add    $0x38,%rsp
  80204a:	5b                   	pop    %rbx
  80204b:	5d                   	pop    %rbp
  80204c:	c3                   	retq   

000000000080204d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80204d:	55                   	push   %rbp
  80204e:	48 89 e5             	mov    %rsp,%rbp
  802051:	53                   	push   %rbx
  802052:	48 83 ec 28          	sub    $0x28,%rsp
  802056:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80205a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80205e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802065:	00 00 00 
  802068:	48 8b 00             	mov    (%rax),%rax
  80206b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802071:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802074:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802078:	48 89 c7             	mov    %rax,%rdi
  80207b:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	89 c3                	mov    %eax,%ebx
  802089:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80208d:	48 89 c7             	mov    %rax,%rdi
  802090:	48 b8 43 36 80 00 00 	movabs $0x803643,%rax
  802097:	00 00 00 
  80209a:	ff d0                	callq  *%rax
  80209c:	39 c3                	cmp    %eax,%ebx
  80209e:	0f 94 c0             	sete   %al
  8020a1:	0f b6 c0             	movzbl %al,%eax
  8020a4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8020a7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020ae:	00 00 00 
  8020b1:	48 8b 00             	mov    (%rax),%rax
  8020b4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020ba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8020bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020c3:	75 05                	jne    8020ca <_pipeisclosed+0x7d>
			return ret;
  8020c5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020c8:	eb 4f                	jmp    802119 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8020ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020cd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020d0:	74 42                	je     802114 <_pipeisclosed+0xc7>
  8020d2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8020d6:	75 3c                	jne    802114 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020d8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020df:	00 00 00 
  8020e2:	48 8b 00             	mov    (%rax),%rax
  8020e5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8020eb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8020ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f1:	89 c6                	mov    %eax,%esi
  8020f3:	48 bf 63 38 80 00 00 	movabs $0x803863,%rdi
  8020fa:	00 00 00 
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	49 b8 0c 29 80 00 00 	movabs $0x80290c,%r8
  802109:	00 00 00 
  80210c:	41 ff d0             	callq  *%r8
	}
  80210f:	e9 4a ff ff ff       	jmpq   80205e <_pipeisclosed+0x11>
  802114:	e9 45 ff ff ff       	jmpq   80205e <_pipeisclosed+0x11>
}
  802119:	48 83 c4 28          	add    $0x28,%rsp
  80211d:	5b                   	pop    %rbx
  80211e:	5d                   	pop    %rbp
  80211f:	c3                   	retq   

0000000000802120 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802120:	55                   	push   %rbp
  802121:	48 89 e5             	mov    %rsp,%rbp
  802124:	48 83 ec 30          	sub    $0x30,%rsp
  802128:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80212f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802132:	48 89 d6             	mov    %rdx,%rsi
  802135:	89 c7                	mov    %eax,%edi
  802137:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
  802143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214a:	79 05                	jns    802151 <pipeisclosed+0x31>
		return r;
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	eb 31                	jmp    802182 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802155:	48 89 c7             	mov    %rax,%rdi
  802158:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  80215f:	00 00 00 
  802162:	ff d0                	callq  *%rax
  802164:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802170:	48 89 d6             	mov    %rdx,%rsi
  802173:	48 89 c7             	mov    %rax,%rdi
  802176:	48 b8 4d 20 80 00 00 	movabs $0x80204d,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax
}
  802182:	c9                   	leaveq 
  802183:	c3                   	retq   

0000000000802184 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802184:	55                   	push   %rbp
  802185:	48 89 e5             	mov    %rsp,%rbp
  802188:	48 83 ec 40          	sub    $0x40,%rsp
  80218c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802190:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802194:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802198:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219c:	48 89 c7             	mov    %rax,%rdi
  80219f:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	callq  *%rax
  8021ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8021af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021b7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021be:	00 
  8021bf:	e9 92 00 00 00       	jmpq   802256 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8021c4:	eb 41                	jmp    802207 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021c6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8021cb:	74 09                	je     8021d6 <devpipe_read+0x52>
				return i;
  8021cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d1:	e9 92 00 00 00       	jmpq   802268 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021de:	48 89 d6             	mov    %rdx,%rsi
  8021e1:	48 89 c7             	mov    %rax,%rdi
  8021e4:	48 b8 4d 20 80 00 00 	movabs $0x80204d,%rax
  8021eb:	00 00 00 
  8021ee:	ff d0                	callq  *%rax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 07                	je     8021fb <devpipe_read+0x77>
				return 0;
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	eb 6d                	jmp    802268 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021fb:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  802202:	00 00 00 
  802205:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220b:	8b 10                	mov    (%rax),%edx
  80220d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802211:	8b 40 04             	mov    0x4(%rax),%eax
  802214:	39 c2                	cmp    %eax,%edx
  802216:	74 ae                	je     8021c6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802220:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802228:	8b 00                	mov    (%rax),%eax
  80222a:	99                   	cltd   
  80222b:	c1 ea 1b             	shr    $0x1b,%edx
  80222e:	01 d0                	add    %edx,%eax
  802230:	83 e0 1f             	and    $0x1f,%eax
  802233:	29 d0                	sub    %edx,%eax
  802235:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802239:	48 98                	cltq   
  80223b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802240:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802246:	8b 00                	mov    (%rax),%eax
  802248:	8d 50 01             	lea    0x1(%rax),%edx
  80224b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802251:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80225e:	0f 82 60 ff ff ff    	jb     8021c4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802268:	c9                   	leaveq 
  802269:	c3                   	retq   

000000000080226a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80226a:	55                   	push   %rbp
  80226b:	48 89 e5             	mov    %rsp,%rbp
  80226e:	48 83 ec 40          	sub    $0x40,%rsp
  802272:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802276:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80227a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80227e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802282:	48 89 c7             	mov    %rax,%rdi
  802285:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  80228c:	00 00 00 
  80228f:	ff d0                	callq  *%rax
  802291:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802295:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802299:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80229d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8022a4:	00 
  8022a5:	e9 8e 00 00 00       	jmpq   802338 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022aa:	eb 31                	jmp    8022dd <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b4:	48 89 d6             	mov    %rdx,%rsi
  8022b7:	48 89 c7             	mov    %rax,%rdi
  8022ba:	48 b8 4d 20 80 00 00 	movabs $0x80204d,%rax
  8022c1:	00 00 00 
  8022c4:	ff d0                	callq  *%rax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 07                	je     8022d1 <devpipe_write+0x67>
				return 0;
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	eb 79                	jmp    80234a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022d1:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e1:	8b 40 04             	mov    0x4(%rax),%eax
  8022e4:	48 63 d0             	movslq %eax,%rdx
  8022e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022eb:	8b 00                	mov    (%rax),%eax
  8022ed:	48 98                	cltq   
  8022ef:	48 83 c0 20          	add    $0x20,%rax
  8022f3:	48 39 c2             	cmp    %rax,%rdx
  8022f6:	73 b4                	jae    8022ac <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022fc:	8b 40 04             	mov    0x4(%rax),%eax
  8022ff:	99                   	cltd   
  802300:	c1 ea 1b             	shr    $0x1b,%edx
  802303:	01 d0                	add    %edx,%eax
  802305:	83 e0 1f             	and    $0x1f,%eax
  802308:	29 d0                	sub    %edx,%eax
  80230a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80230e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802312:	48 01 ca             	add    %rcx,%rdx
  802315:	0f b6 0a             	movzbl (%rdx),%ecx
  802318:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80231c:	48 98                	cltq   
  80231e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802326:	8b 40 04             	mov    0x4(%rax),%eax
  802329:	8d 50 01             	lea    0x1(%rax),%edx
  80232c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802330:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802333:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80233c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802340:	0f 82 64 ff ff ff    	jb     8022aa <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80234a:	c9                   	leaveq 
  80234b:	c3                   	retq   

000000000080234c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80234c:	55                   	push   %rbp
  80234d:	48 89 e5             	mov    %rsp,%rbp
  802350:	48 83 ec 20          	sub    $0x20,%rsp
  802354:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802358:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80235c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802360:	48 89 c7             	mov    %rax,%rdi
  802363:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  80236a:	00 00 00 
  80236d:	ff d0                	callq  *%rax
  80236f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802373:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802377:	48 be 76 38 80 00 00 	movabs $0x803876,%rsi
  80237e:	00 00 00 
  802381:	48 89 c7             	mov    %rax,%rdi
  802384:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  80238b:	00 00 00 
  80238e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802394:	8b 50 04             	mov    0x4(%rax),%edx
  802397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239b:	8b 00                	mov    (%rax),%eax
  80239d:	29 c2                	sub    %eax,%edx
  80239f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8023a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ad:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023b4:	00 00 00 
	stat->st_dev = &devpipe;
  8023b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023bb:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8023c2:	00 00 00 
  8023c5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d1:	c9                   	leaveq 
  8023d2:	c3                   	retq   

00000000008023d3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023d3:	55                   	push   %rbp
  8023d4:	48 89 e5             	mov    %rsp,%rbp
  8023d7:	48 83 ec 10          	sub    $0x10,%rsp
  8023db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8023df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e3:	48 89 c6             	mov    %rax,%rsi
  8023e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023eb:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8023f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fb:	48 89 c7             	mov    %rax,%rdi
  8023fe:	48 b8 31 0e 80 00 00 	movabs $0x800e31,%rax
  802405:	00 00 00 
  802408:	ff d0                	callq  *%rax
  80240a:	48 89 c6             	mov    %rax,%rsi
  80240d:	bf 00 00 00 00       	mov    $0x0,%edi
  802412:	48 b8 4c 0c 80 00 00 	movabs $0x800c4c,%rax
  802419:	00 00 00 
  80241c:	ff d0                	callq  *%rax
}
  80241e:	c9                   	leaveq 
  80241f:	c3                   	retq   

0000000000802420 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802420:	55                   	push   %rbp
  802421:	48 89 e5             	mov    %rsp,%rbp
  802424:	48 83 ec 20          	sub    $0x20,%rsp
  802428:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80242b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80242e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802431:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802435:	be 01 00 00 00       	mov    $0x1,%esi
  80243a:	48 89 c7             	mov    %rax,%rdi
  80243d:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  802444:	00 00 00 
  802447:	ff d0                	callq  *%rax
}
  802449:	c9                   	leaveq 
  80244a:	c3                   	retq   

000000000080244b <getchar>:

int
getchar(void)
{
  80244b:	55                   	push   %rbp
  80244c:	48 89 e5             	mov    %rsp,%rbp
  80244f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802453:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802457:	ba 01 00 00 00       	mov    $0x1,%edx
  80245c:	48 89 c6             	mov    %rax,%rsi
  80245f:	bf 00 00 00 00       	mov    $0x0,%edi
  802464:	48 b8 26 13 80 00 00 	movabs $0x801326,%rax
  80246b:	00 00 00 
  80246e:	ff d0                	callq  *%rax
  802470:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802477:	79 05                	jns    80247e <getchar+0x33>
		return r;
  802479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247c:	eb 14                	jmp    802492 <getchar+0x47>
	if (r < 1)
  80247e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802482:	7f 07                	jg     80248b <getchar+0x40>
		return -E_EOF;
  802484:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802489:	eb 07                	jmp    802492 <getchar+0x47>
	return c;
  80248b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80248f:	0f b6 c0             	movzbl %al,%eax
}
  802492:	c9                   	leaveq 
  802493:	c3                   	retq   

0000000000802494 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802494:	55                   	push   %rbp
  802495:	48 89 e5             	mov    %rsp,%rbp
  802498:	48 83 ec 20          	sub    $0x20,%rsp
  80249c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80249f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a6:	48 89 d6             	mov    %rdx,%rsi
  8024a9:	89 c7                	mov    %eax,%edi
  8024ab:	48 b8 f4 0e 80 00 00 	movabs $0x800ef4,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
  8024b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024be:	79 05                	jns    8024c5 <iscons+0x31>
		return r;
  8024c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c3:	eb 1a                	jmp    8024df <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8024c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c9:	8b 10                	mov    (%rax),%edx
  8024cb:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8024d2:	00 00 00 
  8024d5:	8b 00                	mov    (%rax),%eax
  8024d7:	39 c2                	cmp    %eax,%edx
  8024d9:	0f 94 c0             	sete   %al
  8024dc:	0f b6 c0             	movzbl %al,%eax
}
  8024df:	c9                   	leaveq 
  8024e0:	c3                   	retq   

00000000008024e1 <opencons>:

int
opencons(void)
{
  8024e1:	55                   	push   %rbp
  8024e2:	48 89 e5             	mov    %rsp,%rbp
  8024e5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024e9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024ed:	48 89 c7             	mov    %rax,%rdi
  8024f0:	48 b8 5c 0e 80 00 00 	movabs $0x800e5c,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
  8024fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802503:	79 05                	jns    80250a <opencons+0x29>
		return r;
  802505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802508:	eb 5b                	jmp    802565 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80250a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250e:	ba 07 04 00 00       	mov    $0x407,%edx
  802513:	48 89 c6             	mov    %rax,%rsi
  802516:	bf 00 00 00 00       	mov    $0x0,%edi
  80251b:	48 b8 a1 0b 80 00 00 	movabs $0x800ba1,%rax
  802522:	00 00 00 
  802525:	ff d0                	callq  *%rax
  802527:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252e:	79 05                	jns    802535 <opencons+0x54>
		return r;
  802530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802533:	eb 30                	jmp    802565 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802539:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  802540:	00 00 00 
  802543:	8b 12                	mov    (%rdx),%edx
  802545:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802556:	48 89 c7             	mov    %rax,%rdi
  802559:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  802560:	00 00 00 
  802563:	ff d0                	callq  *%rax
}
  802565:	c9                   	leaveq 
  802566:	c3                   	retq   

0000000000802567 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802567:	55                   	push   %rbp
  802568:	48 89 e5             	mov    %rsp,%rbp
  80256b:	48 83 ec 30          	sub    $0x30,%rsp
  80256f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802573:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802577:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80257b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802580:	75 07                	jne    802589 <devcons_read+0x22>
		return 0;
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
  802587:	eb 4b                	jmp    8025d4 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802589:	eb 0c                	jmp    802597 <devcons_read+0x30>
		sys_yield();
  80258b:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802597:	48 b8 a3 0a 80 00 00 	movabs $0x800aa3,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025aa:	74 df                	je     80258b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8025ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b0:	79 05                	jns    8025b7 <devcons_read+0x50>
		return c;
  8025b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b5:	eb 1d                	jmp    8025d4 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8025b7:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8025bb:	75 07                	jne    8025c4 <devcons_read+0x5d>
		return 0;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c2:	eb 10                	jmp    8025d4 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8025c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025cd:	88 10                	mov    %dl,(%rax)
	return 1;
  8025cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025d4:	c9                   	leaveq 
  8025d5:	c3                   	retq   

00000000008025d6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025d6:	55                   	push   %rbp
  8025d7:	48 89 e5             	mov    %rsp,%rbp
  8025da:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8025e1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8025e8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8025ef:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025fd:	eb 76                	jmp    802675 <devcons_write+0x9f>
		m = n - tot;
  8025ff:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802606:	89 c2                	mov    %eax,%edx
  802608:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260b:	29 c2                	sub    %eax,%edx
  80260d:	89 d0                	mov    %edx,%eax
  80260f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802612:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802615:	83 f8 7f             	cmp    $0x7f,%eax
  802618:	76 07                	jbe    802621 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80261a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802621:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802624:	48 63 d0             	movslq %eax,%rdx
  802627:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262a:	48 63 c8             	movslq %eax,%rcx
  80262d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802634:	48 01 c1             	add    %rax,%rcx
  802637:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80263e:	48 89 ce             	mov    %rcx,%rsi
  802641:	48 89 c7             	mov    %rax,%rdi
  802644:	48 b8 96 05 80 00 00 	movabs $0x800596,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802650:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802653:	48 63 d0             	movslq %eax,%rdx
  802656:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80265d:	48 89 d6             	mov    %rdx,%rsi
  802660:	48 89 c7             	mov    %rax,%rdi
  802663:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  80266a:	00 00 00 
  80266d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80266f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802672:	01 45 fc             	add    %eax,-0x4(%rbp)
  802675:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802678:	48 98                	cltq   
  80267a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802681:	0f 82 78 ff ff ff    	jb     8025ff <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802687:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 08          	sub    $0x8,%rsp
  802694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
  8026a3:	48 83 ec 10          	sub    $0x10,%rsp
  8026a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8026af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b3:	48 be 82 38 80 00 00 	movabs $0x803882,%rsi
  8026ba:	00 00 00 
  8026bd:	48 89 c7             	mov    %rax,%rdi
  8026c0:	48 b8 72 02 80 00 00 	movabs $0x800272,%rax
  8026c7:	00 00 00 
  8026ca:	ff d0                	callq  *%rax
	return 0;
  8026cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d1:	c9                   	leaveq 
  8026d2:	c3                   	retq   

00000000008026d3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026d3:	55                   	push   %rbp
  8026d4:	48 89 e5             	mov    %rsp,%rbp
  8026d7:	53                   	push   %rbx
  8026d8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8026df:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8026e6:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8026ec:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8026f3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8026fa:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802701:	84 c0                	test   %al,%al
  802703:	74 23                	je     802728 <_panic+0x55>
  802705:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80270c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802710:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802714:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802718:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80271c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802720:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802724:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802728:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80272f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802736:	00 00 00 
  802739:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802740:	00 00 00 
  802743:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802747:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80274e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802755:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80275c:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802763:	00 00 00 
  802766:	48 8b 18             	mov    (%rax),%rbx
  802769:	48 b8 25 0b 80 00 00 	movabs $0x800b25,%rax
  802770:	00 00 00 
  802773:	ff d0                	callq  *%rax
  802775:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80277b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802782:	41 89 c8             	mov    %ecx,%r8d
  802785:	48 89 d1             	mov    %rdx,%rcx
  802788:	48 89 da             	mov    %rbx,%rdx
  80278b:	89 c6                	mov    %eax,%esi
  80278d:	48 bf 90 38 80 00 00 	movabs $0x803890,%rdi
  802794:	00 00 00 
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
  80279c:	49 b9 0c 29 80 00 00 	movabs $0x80290c,%r9
  8027a3:	00 00 00 
  8027a6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027a9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8027b0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027b7:	48 89 d6             	mov    %rdx,%rsi
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 60 28 80 00 00 	movabs $0x802860,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
	cprintf("\n");
  8027c9:	48 bf b3 38 80 00 00 	movabs $0x8038b3,%rdi
  8027d0:	00 00 00 
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	48 ba 0c 29 80 00 00 	movabs $0x80290c,%rdx
  8027df:	00 00 00 
  8027e2:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027e4:	cc                   	int3   
  8027e5:	eb fd                	jmp    8027e4 <_panic+0x111>

00000000008027e7 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8027e7:	55                   	push   %rbp
  8027e8:	48 89 e5             	mov    %rsp,%rbp
  8027eb:	48 83 ec 10          	sub    $0x10,%rsp
  8027ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8027f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fa:	8b 00                	mov    (%rax),%eax
  8027fc:	8d 48 01             	lea    0x1(%rax),%ecx
  8027ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802803:	89 0a                	mov    %ecx,(%rdx)
  802805:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802808:	89 d1                	mov    %edx,%ecx
  80280a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80280e:	48 98                	cltq   
  802810:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  802814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802818:	8b 00                	mov    (%rax),%eax
  80281a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80281f:	75 2c                	jne    80284d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802825:	8b 00                	mov    (%rax),%eax
  802827:	48 98                	cltq   
  802829:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80282d:	48 83 c2 08          	add    $0x8,%rdx
  802831:	48 89 c6             	mov    %rax,%rsi
  802834:	48 89 d7             	mov    %rdx,%rdi
  802837:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  80283e:	00 00 00 
  802841:	ff d0                	callq  *%rax
        b->idx = 0;
  802843:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802847:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80284d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802851:	8b 40 04             	mov    0x4(%rax),%eax
  802854:	8d 50 01             	lea    0x1(%rax),%edx
  802857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80285e:	c9                   	leaveq 
  80285f:	c3                   	retq   

0000000000802860 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802860:	55                   	push   %rbp
  802861:	48 89 e5             	mov    %rsp,%rbp
  802864:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80286b:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802872:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802879:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802880:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802887:	48 8b 0a             	mov    (%rdx),%rcx
  80288a:	48 89 08             	mov    %rcx,(%rax)
  80288d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802891:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802895:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802899:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80289d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8028a4:	00 00 00 
    b.cnt = 0;
  8028a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8028ae:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8028b1:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8028b8:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8028bf:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8028c6:	48 89 c6             	mov    %rax,%rsi
  8028c9:	48 bf e7 27 80 00 00 	movabs $0x8027e7,%rdi
  8028d0:	00 00 00 
  8028d3:	48 b8 bf 2c 80 00 00 	movabs $0x802cbf,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8028df:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8028e5:	48 98                	cltq   
  8028e7:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8028ee:	48 83 c2 08          	add    $0x8,%rdx
  8028f2:	48 89 c6             	mov    %rax,%rsi
  8028f5:	48 89 d7             	mov    %rdx,%rdi
  8028f8:	48 b8 59 0a 80 00 00 	movabs $0x800a59,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802904:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80290a:	c9                   	leaveq 
  80290b:	c3                   	retq   

000000000080290c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80290c:	55                   	push   %rbp
  80290d:	48 89 e5             	mov    %rsp,%rbp
  802910:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802917:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80291e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802925:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80292c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802933:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80293a:	84 c0                	test   %al,%al
  80293c:	74 20                	je     80295e <cprintf+0x52>
  80293e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802942:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802946:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80294a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80294e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802952:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802956:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80295a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80295e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802965:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80296c:	00 00 00 
  80296f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802976:	00 00 00 
  802979:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80297d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802984:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80298b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802992:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802999:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8029a0:	48 8b 0a             	mov    (%rdx),%rcx
  8029a3:	48 89 08             	mov    %rcx,(%rax)
  8029a6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029aa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029ae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029b2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8029b6:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8029bd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029c4:	48 89 d6             	mov    %rdx,%rsi
  8029c7:	48 89 c7             	mov    %rax,%rdi
  8029ca:	48 b8 60 28 80 00 00 	movabs $0x802860,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	callq  *%rax
  8029d6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8029dc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8029e2:	c9                   	leaveq 
  8029e3:	c3                   	retq   

00000000008029e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	53                   	push   %rbx
  8029e9:	48 83 ec 38          	sub    $0x38,%rsp
  8029ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8029f9:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8029fc:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a00:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a04:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a07:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a0b:	77 3b                	ja     802a48 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a0d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a10:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a14:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a20:	48 f7 f3             	div    %rbx
  802a23:	48 89 c2             	mov    %rax,%rdx
  802a26:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a29:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a2c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a34:	41 89 f9             	mov    %edi,%r9d
  802a37:	48 89 c7             	mov    %rax,%rdi
  802a3a:	48 b8 e4 29 80 00 00 	movabs $0x8029e4,%rax
  802a41:	00 00 00 
  802a44:	ff d0                	callq  *%rax
  802a46:	eb 1e                	jmp    802a66 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a48:	eb 12                	jmp    802a5c <printnum+0x78>
			putch(padc, putdat);
  802a4a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a4e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a55:	48 89 ce             	mov    %rcx,%rsi
  802a58:	89 d7                	mov    %edx,%edi
  802a5a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a5c:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802a60:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802a64:	7f e4                	jg     802a4a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802a66:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a72:	48 f7 f1             	div    %rcx
  802a75:	48 89 d0             	mov    %rdx,%rax
  802a78:	48 ba b0 3a 80 00 00 	movabs $0x803ab0,%rdx
  802a7f:	00 00 00 
  802a82:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802a86:	0f be d0             	movsbl %al,%edx
  802a89:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a91:	48 89 ce             	mov    %rcx,%rsi
  802a94:	89 d7                	mov    %edx,%edi
  802a96:	ff d0                	callq  *%rax
}
  802a98:	48 83 c4 38          	add    $0x38,%rsp
  802a9c:	5b                   	pop    %rbx
  802a9d:	5d                   	pop    %rbp
  802a9e:	c3                   	retq   

0000000000802a9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802a9f:	55                   	push   %rbp
  802aa0:	48 89 e5             	mov    %rsp,%rbp
  802aa3:	48 83 ec 1c          	sub    $0x1c,%rsp
  802aa7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aab:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  802aae:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802ab2:	7e 52                	jle    802b06 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab8:	8b 00                	mov    (%rax),%eax
  802aba:	83 f8 30             	cmp    $0x30,%eax
  802abd:	73 24                	jae    802ae3 <getuint+0x44>
  802abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acb:	8b 00                	mov    (%rax),%eax
  802acd:	89 c0                	mov    %eax,%eax
  802acf:	48 01 d0             	add    %rdx,%rax
  802ad2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ad6:	8b 12                	mov    (%rdx),%edx
  802ad8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802adf:	89 0a                	mov    %ecx,(%rdx)
  802ae1:	eb 17                	jmp    802afa <getuint+0x5b>
  802ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802aeb:	48 89 d0             	mov    %rdx,%rax
  802aee:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802af6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802afa:	48 8b 00             	mov    (%rax),%rax
  802afd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b01:	e9 a3 00 00 00       	jmpq   802ba9 <getuint+0x10a>
	else if (lflag)
  802b06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b0a:	74 4f                	je     802b5b <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b10:	8b 00                	mov    (%rax),%eax
  802b12:	83 f8 30             	cmp    $0x30,%eax
  802b15:	73 24                	jae    802b3b <getuint+0x9c>
  802b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b23:	8b 00                	mov    (%rax),%eax
  802b25:	89 c0                	mov    %eax,%eax
  802b27:	48 01 d0             	add    %rdx,%rax
  802b2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b2e:	8b 12                	mov    (%rdx),%edx
  802b30:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b37:	89 0a                	mov    %ecx,(%rdx)
  802b39:	eb 17                	jmp    802b52 <getuint+0xb3>
  802b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b43:	48 89 d0             	mov    %rdx,%rax
  802b46:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b4e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b52:	48 8b 00             	mov    (%rax),%rax
  802b55:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b59:	eb 4e                	jmp    802ba9 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5f:	8b 00                	mov    (%rax),%eax
  802b61:	83 f8 30             	cmp    $0x30,%eax
  802b64:	73 24                	jae    802b8a <getuint+0xeb>
  802b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b72:	8b 00                	mov    (%rax),%eax
  802b74:	89 c0                	mov    %eax,%eax
  802b76:	48 01 d0             	add    %rdx,%rax
  802b79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b7d:	8b 12                	mov    (%rdx),%edx
  802b7f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b86:	89 0a                	mov    %ecx,(%rdx)
  802b88:	eb 17                	jmp    802ba1 <getuint+0x102>
  802b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b92:	48 89 d0             	mov    %rdx,%rax
  802b95:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b9d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802ba1:	8b 00                	mov    (%rax),%eax
  802ba3:	89 c0                	mov    %eax,%eax
  802ba5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bad:	c9                   	leaveq 
  802bae:	c3                   	retq   

0000000000802baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802baf:	55                   	push   %rbp
  802bb0:	48 89 e5             	mov    %rsp,%rbp
  802bb3:	48 83 ec 1c          	sub    $0x1c,%rsp
  802bb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bbb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802bbe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802bc2:	7e 52                	jle    802c16 <getint+0x67>
		x=va_arg(*ap, long long);
  802bc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc8:	8b 00                	mov    (%rax),%eax
  802bca:	83 f8 30             	cmp    $0x30,%eax
  802bcd:	73 24                	jae    802bf3 <getint+0x44>
  802bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdb:	8b 00                	mov    (%rax),%eax
  802bdd:	89 c0                	mov    %eax,%eax
  802bdf:	48 01 d0             	add    %rdx,%rax
  802be2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802be6:	8b 12                	mov    (%rdx),%edx
  802be8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802beb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bef:	89 0a                	mov    %ecx,(%rdx)
  802bf1:	eb 17                	jmp    802c0a <getint+0x5b>
  802bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802bfb:	48 89 d0             	mov    %rdx,%rax
  802bfe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c06:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c0a:	48 8b 00             	mov    (%rax),%rax
  802c0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c11:	e9 a3 00 00 00       	jmpq   802cb9 <getint+0x10a>
	else if (lflag)
  802c16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c1a:	74 4f                	je     802c6b <getint+0xbc>
		x=va_arg(*ap, long);
  802c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c20:	8b 00                	mov    (%rax),%eax
  802c22:	83 f8 30             	cmp    $0x30,%eax
  802c25:	73 24                	jae    802c4b <getint+0x9c>
  802c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c33:	8b 00                	mov    (%rax),%eax
  802c35:	89 c0                	mov    %eax,%eax
  802c37:	48 01 d0             	add    %rdx,%rax
  802c3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c3e:	8b 12                	mov    (%rdx),%edx
  802c40:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c47:	89 0a                	mov    %ecx,(%rdx)
  802c49:	eb 17                	jmp    802c62 <getint+0xb3>
  802c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c53:	48 89 d0             	mov    %rdx,%rax
  802c56:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c5e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c62:	48 8b 00             	mov    (%rax),%rax
  802c65:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c69:	eb 4e                	jmp    802cb9 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6f:	8b 00                	mov    (%rax),%eax
  802c71:	83 f8 30             	cmp    $0x30,%eax
  802c74:	73 24                	jae    802c9a <getint+0xeb>
  802c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c82:	8b 00                	mov    (%rax),%eax
  802c84:	89 c0                	mov    %eax,%eax
  802c86:	48 01 d0             	add    %rdx,%rax
  802c89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c8d:	8b 12                	mov    (%rdx),%edx
  802c8f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c96:	89 0a                	mov    %ecx,(%rdx)
  802c98:	eb 17                	jmp    802cb1 <getint+0x102>
  802c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ca2:	48 89 d0             	mov    %rdx,%rax
  802ca5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802ca9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cb1:	8b 00                	mov    (%rax),%eax
  802cb3:	48 98                	cltq   
  802cb5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cbd:	c9                   	leaveq 
  802cbe:	c3                   	retq   

0000000000802cbf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802cbf:	55                   	push   %rbp
  802cc0:	48 89 e5             	mov    %rsp,%rbp
  802cc3:	41 54                	push   %r12
  802cc5:	53                   	push   %rbx
  802cc6:	48 83 ec 60          	sub    $0x60,%rsp
  802cca:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802cce:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802cd2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802cd6:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802cda:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802cde:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802ce2:	48 8b 0a             	mov    (%rdx),%rcx
  802ce5:	48 89 08             	mov    %rcx,(%rax)
  802ce8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802cec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802cf0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802cf4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802cf8:	eb 17                	jmp    802d11 <vprintfmt+0x52>
			if (ch == '\0')
  802cfa:	85 db                	test   %ebx,%ebx
  802cfc:	0f 84 df 04 00 00    	je     8031e1 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  802d02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d0a:	48 89 d6             	mov    %rdx,%rsi
  802d0d:	89 df                	mov    %ebx,%edi
  802d0f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d11:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d15:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d19:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d1d:	0f b6 00             	movzbl (%rax),%eax
  802d20:	0f b6 d8             	movzbl %al,%ebx
  802d23:	83 fb 25             	cmp    $0x25,%ebx
  802d26:	75 d2                	jne    802cfa <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d28:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d2c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d33:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d3a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d41:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802d48:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d4c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d50:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d54:	0f b6 00             	movzbl (%rax),%eax
  802d57:	0f b6 d8             	movzbl %al,%ebx
  802d5a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802d5d:	83 f8 55             	cmp    $0x55,%eax
  802d60:	0f 87 47 04 00 00    	ja     8031ad <vprintfmt+0x4ee>
  802d66:	89 c0                	mov    %eax,%eax
  802d68:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802d6f:	00 
  802d70:	48 b8 d8 3a 80 00 00 	movabs $0x803ad8,%rax
  802d77:	00 00 00 
  802d7a:	48 01 d0             	add    %rdx,%rax
  802d7d:	48 8b 00             	mov    (%rax),%rax
  802d80:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802d82:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802d86:	eb c0                	jmp    802d48 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802d88:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802d8c:	eb ba                	jmp    802d48 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802d8e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802d95:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d98:	89 d0                	mov    %edx,%eax
  802d9a:	c1 e0 02             	shl    $0x2,%eax
  802d9d:	01 d0                	add    %edx,%eax
  802d9f:	01 c0                	add    %eax,%eax
  802da1:	01 d8                	add    %ebx,%eax
  802da3:	83 e8 30             	sub    $0x30,%eax
  802da6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802da9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802dad:	0f b6 00             	movzbl (%rax),%eax
  802db0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802db3:	83 fb 2f             	cmp    $0x2f,%ebx
  802db6:	7e 0c                	jle    802dc4 <vprintfmt+0x105>
  802db8:	83 fb 39             	cmp    $0x39,%ebx
  802dbb:	7f 07                	jg     802dc4 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802dbd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802dc2:	eb d1                	jmp    802d95 <vprintfmt+0xd6>
			goto process_precision;
  802dc4:	eb 58                	jmp    802e1e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802dc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dc9:	83 f8 30             	cmp    $0x30,%eax
  802dcc:	73 17                	jae    802de5 <vprintfmt+0x126>
  802dce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dd5:	89 c0                	mov    %eax,%eax
  802dd7:	48 01 d0             	add    %rdx,%rax
  802dda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ddd:	83 c2 08             	add    $0x8,%edx
  802de0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802de3:	eb 0f                	jmp    802df4 <vprintfmt+0x135>
  802de5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802de9:	48 89 d0             	mov    %rdx,%rax
  802dec:	48 83 c2 08          	add    $0x8,%rdx
  802df0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802df4:	8b 00                	mov    (%rax),%eax
  802df6:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802df9:	eb 23                	jmp    802e1e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802dfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802dff:	79 0c                	jns    802e0d <vprintfmt+0x14e>
				width = 0;
  802e01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e08:	e9 3b ff ff ff       	jmpq   802d48 <vprintfmt+0x89>
  802e0d:	e9 36 ff ff ff       	jmpq   802d48 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802e12:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e19:	e9 2a ff ff ff       	jmpq   802d48 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e22:	79 12                	jns    802e36 <vprintfmt+0x177>
				width = precision, precision = -1;
  802e24:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e27:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e2a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e31:	e9 12 ff ff ff       	jmpq   802d48 <vprintfmt+0x89>
  802e36:	e9 0d ff ff ff       	jmpq   802d48 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e3b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e3f:	e9 04 ff ff ff       	jmpq   802d48 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802e44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e47:	83 f8 30             	cmp    $0x30,%eax
  802e4a:	73 17                	jae    802e63 <vprintfmt+0x1a4>
  802e4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e53:	89 c0                	mov    %eax,%eax
  802e55:	48 01 d0             	add    %rdx,%rax
  802e58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e5b:	83 c2 08             	add    $0x8,%edx
  802e5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e61:	eb 0f                	jmp    802e72 <vprintfmt+0x1b3>
  802e63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e67:	48 89 d0             	mov    %rdx,%rax
  802e6a:	48 83 c2 08          	add    $0x8,%rdx
  802e6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e72:	8b 10                	mov    (%rax),%edx
  802e74:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802e78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e7c:	48 89 ce             	mov    %rcx,%rsi
  802e7f:	89 d7                	mov    %edx,%edi
  802e81:	ff d0                	callq  *%rax
			break;
  802e83:	e9 53 03 00 00       	jmpq   8031db <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802e88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e8b:	83 f8 30             	cmp    $0x30,%eax
  802e8e:	73 17                	jae    802ea7 <vprintfmt+0x1e8>
  802e90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e97:	89 c0                	mov    %eax,%eax
  802e99:	48 01 d0             	add    %rdx,%rax
  802e9c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e9f:	83 c2 08             	add    $0x8,%edx
  802ea2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ea5:	eb 0f                	jmp    802eb6 <vprintfmt+0x1f7>
  802ea7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802eab:	48 89 d0             	mov    %rdx,%rax
  802eae:	48 83 c2 08          	add    $0x8,%rdx
  802eb2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802eb6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802eb8:	85 db                	test   %ebx,%ebx
  802eba:	79 02                	jns    802ebe <vprintfmt+0x1ff>
				err = -err;
  802ebc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802ebe:	83 fb 15             	cmp    $0x15,%ebx
  802ec1:	7f 16                	jg     802ed9 <vprintfmt+0x21a>
  802ec3:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  802eca:	00 00 00 
  802ecd:	48 63 d3             	movslq %ebx,%rdx
  802ed0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802ed4:	4d 85 e4             	test   %r12,%r12
  802ed7:	75 2e                	jne    802f07 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802ed9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802edd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ee1:	89 d9                	mov    %ebx,%ecx
  802ee3:	48 ba c1 3a 80 00 00 	movabs $0x803ac1,%rdx
  802eea:	00 00 00 
  802eed:	48 89 c7             	mov    %rax,%rdi
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef5:	49 b8 ea 31 80 00 00 	movabs $0x8031ea,%r8
  802efc:	00 00 00 
  802eff:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f02:	e9 d4 02 00 00       	jmpq   8031db <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f07:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f0f:	4c 89 e1             	mov    %r12,%rcx
  802f12:	48 ba ca 3a 80 00 00 	movabs $0x803aca,%rdx
  802f19:	00 00 00 
  802f1c:	48 89 c7             	mov    %rax,%rdi
  802f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f24:	49 b8 ea 31 80 00 00 	movabs $0x8031ea,%r8
  802f2b:	00 00 00 
  802f2e:	41 ff d0             	callq  *%r8
			break;
  802f31:	e9 a5 02 00 00       	jmpq   8031db <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f39:	83 f8 30             	cmp    $0x30,%eax
  802f3c:	73 17                	jae    802f55 <vprintfmt+0x296>
  802f3e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f45:	89 c0                	mov    %eax,%eax
  802f47:	48 01 d0             	add    %rdx,%rax
  802f4a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f4d:	83 c2 08             	add    $0x8,%edx
  802f50:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f53:	eb 0f                	jmp    802f64 <vprintfmt+0x2a5>
  802f55:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f59:	48 89 d0             	mov    %rdx,%rax
  802f5c:	48 83 c2 08          	add    $0x8,%rdx
  802f60:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f64:	4c 8b 20             	mov    (%rax),%r12
  802f67:	4d 85 e4             	test   %r12,%r12
  802f6a:	75 0a                	jne    802f76 <vprintfmt+0x2b7>
				p = "(null)";
  802f6c:	49 bc cd 3a 80 00 00 	movabs $0x803acd,%r12
  802f73:	00 00 00 
			if (width > 0 && padc != '-')
  802f76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f7a:	7e 3f                	jle    802fbb <vprintfmt+0x2fc>
  802f7c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802f80:	74 39                	je     802fbb <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802f82:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f85:	48 98                	cltq   
  802f87:	48 89 c6             	mov    %rax,%rsi
  802f8a:	4c 89 e7             	mov    %r12,%rdi
  802f8d:	48 b8 34 02 80 00 00 	movabs $0x800234,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802f9c:	eb 17                	jmp    802fb5 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802f9e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802fa2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802fa6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802faa:	48 89 ce             	mov    %rcx,%rsi
  802fad:	89 d7                	mov    %edx,%edi
  802faf:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802fb1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fb5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fb9:	7f e3                	jg     802f9e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fbb:	eb 37                	jmp    802ff4 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802fbd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802fc1:	74 1e                	je     802fe1 <vprintfmt+0x322>
  802fc3:	83 fb 1f             	cmp    $0x1f,%ebx
  802fc6:	7e 05                	jle    802fcd <vprintfmt+0x30e>
  802fc8:	83 fb 7e             	cmp    $0x7e,%ebx
  802fcb:	7e 14                	jle    802fe1 <vprintfmt+0x322>
					putch('?', putdat);
  802fcd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fd5:	48 89 d6             	mov    %rdx,%rsi
  802fd8:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802fdd:	ff d0                	callq  *%rax
  802fdf:	eb 0f                	jmp    802ff0 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802fe1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fe5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fe9:	48 89 d6             	mov    %rdx,%rsi
  802fec:	89 df                	mov    %ebx,%edi
  802fee:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ff0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802ff4:	4c 89 e0             	mov    %r12,%rax
  802ff7:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802ffb:	0f b6 00             	movzbl (%rax),%eax
  802ffe:	0f be d8             	movsbl %al,%ebx
  803001:	85 db                	test   %ebx,%ebx
  803003:	74 10                	je     803015 <vprintfmt+0x356>
  803005:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803009:	78 b2                	js     802fbd <vprintfmt+0x2fe>
  80300b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80300f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803013:	79 a8                	jns    802fbd <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803015:	eb 16                	jmp    80302d <vprintfmt+0x36e>
				putch(' ', putdat);
  803017:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80301b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80301f:	48 89 d6             	mov    %rdx,%rsi
  803022:	bf 20 00 00 00       	mov    $0x20,%edi
  803027:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803029:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80302d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803031:	7f e4                	jg     803017 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803033:	e9 a3 01 00 00       	jmpq   8031db <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803038:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80303c:	be 03 00 00 00       	mov    $0x3,%esi
  803041:	48 89 c7             	mov    %rax,%rdi
  803044:	48 b8 af 2b 80 00 00 	movabs $0x802baf,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
  803050:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803058:	48 85 c0             	test   %rax,%rax
  80305b:	79 1d                	jns    80307a <vprintfmt+0x3bb>
				putch('-', putdat);
  80305d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803061:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803065:	48 89 d6             	mov    %rdx,%rsi
  803068:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80306d:	ff d0                	callq  *%rax
				num = -(long long) num;
  80306f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803073:	48 f7 d8             	neg    %rax
  803076:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80307a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803081:	e9 e8 00 00 00       	jmpq   80316e <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803086:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80308a:	be 03 00 00 00       	mov    $0x3,%esi
  80308f:	48 89 c7             	mov    %rax,%rdi
  803092:	48 b8 9f 2a 80 00 00 	movabs $0x802a9f,%rax
  803099:	00 00 00 
  80309c:	ff d0                	callq  *%rax
  80309e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8030a2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030a9:	e9 c0 00 00 00       	jmpq   80316e <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8030ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030b6:	48 89 d6             	mov    %rdx,%rsi
  8030b9:	bf 58 00 00 00       	mov    $0x58,%edi
  8030be:	ff d0                	callq  *%rax
			putch('X', putdat);
  8030c0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030c8:	48 89 d6             	mov    %rdx,%rsi
  8030cb:	bf 58 00 00 00       	mov    $0x58,%edi
  8030d0:	ff d0                	callq  *%rax
			putch('X', putdat);
  8030d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030da:	48 89 d6             	mov    %rdx,%rsi
  8030dd:	bf 58 00 00 00       	mov    $0x58,%edi
  8030e2:	ff d0                	callq  *%rax
			break;
  8030e4:	e9 f2 00 00 00       	jmpq   8031db <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  8030e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030f1:	48 89 d6             	mov    %rdx,%rsi
  8030f4:	bf 30 00 00 00       	mov    $0x30,%edi
  8030f9:	ff d0                	callq  *%rax
			putch('x', putdat);
  8030fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803103:	48 89 d6             	mov    %rdx,%rsi
  803106:	bf 78 00 00 00       	mov    $0x78,%edi
  80310b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80310d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803110:	83 f8 30             	cmp    $0x30,%eax
  803113:	73 17                	jae    80312c <vprintfmt+0x46d>
  803115:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803119:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80311c:	89 c0                	mov    %eax,%eax
  80311e:	48 01 d0             	add    %rdx,%rax
  803121:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803124:	83 c2 08             	add    $0x8,%edx
  803127:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80312a:	eb 0f                	jmp    80313b <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80312c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803130:	48 89 d0             	mov    %rdx,%rax
  803133:	48 83 c2 08          	add    $0x8,%rdx
  803137:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80313b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80313e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803142:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803149:	eb 23                	jmp    80316e <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80314b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80314f:	be 03 00 00 00       	mov    $0x3,%esi
  803154:	48 89 c7             	mov    %rax,%rdi
  803157:	48 b8 9f 2a 80 00 00 	movabs $0x802a9f,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
  803163:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803167:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80316e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803173:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803176:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803179:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80317d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803181:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803185:	45 89 c1             	mov    %r8d,%r9d
  803188:	41 89 f8             	mov    %edi,%r8d
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 e4 29 80 00 00 	movabs $0x8029e4,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
			break;
  80319a:	eb 3f                	jmp    8031db <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80319c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031a4:	48 89 d6             	mov    %rdx,%rsi
  8031a7:	89 df                	mov    %ebx,%edi
  8031a9:	ff d0                	callq  *%rax
			break;
  8031ab:	eb 2e                	jmp    8031db <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8031ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031b5:	48 89 d6             	mov    %rdx,%rsi
  8031b8:	bf 25 00 00 00       	mov    $0x25,%edi
  8031bd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8031bf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031c4:	eb 05                	jmp    8031cb <vprintfmt+0x50c>
  8031c6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8031cf:	48 83 e8 01          	sub    $0x1,%rax
  8031d3:	0f b6 00             	movzbl (%rax),%eax
  8031d6:	3c 25                	cmp    $0x25,%al
  8031d8:	75 ec                	jne    8031c6 <vprintfmt+0x507>
				/* do nothing */;
			break;
  8031da:	90                   	nop
		}
	}
  8031db:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031dc:	e9 30 fb ff ff       	jmpq   802d11 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8031e1:	48 83 c4 60          	add    $0x60,%rsp
  8031e5:	5b                   	pop    %rbx
  8031e6:	41 5c                	pop    %r12
  8031e8:	5d                   	pop    %rbp
  8031e9:	c3                   	retq   

00000000008031ea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8031ea:	55                   	push   %rbp
  8031eb:	48 89 e5             	mov    %rsp,%rbp
  8031ee:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8031f5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8031fc:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803203:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80320a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803211:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803218:	84 c0                	test   %al,%al
  80321a:	74 20                	je     80323c <printfmt+0x52>
  80321c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803220:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803224:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803228:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80322c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803230:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803234:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803238:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80323c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803243:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80324a:	00 00 00 
  80324d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803254:	00 00 00 
  803257:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80325b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803262:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803269:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803270:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803277:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80327e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803285:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80328c:	48 89 c7             	mov    %rax,%rdi
  80328f:	48 b8 bf 2c 80 00 00 	movabs $0x802cbf,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
	va_end(ap);
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 10          	sub    $0x10,%rsp
  8032a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8032ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b0:	8b 40 10             	mov    0x10(%rax),%eax
  8032b3:	8d 50 01             	lea    0x1(%rax),%edx
  8032b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ba:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8032bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c1:	48 8b 10             	mov    (%rax),%rdx
  8032c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8032cc:	48 39 c2             	cmp    %rax,%rdx
  8032cf:	73 17                	jae    8032e8 <sprintputch+0x4b>
		*b->buf++ = ch;
  8032d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d5:	48 8b 00             	mov    (%rax),%rax
  8032d8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8032dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032e0:	48 89 0a             	mov    %rcx,(%rdx)
  8032e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032e6:	88 10                	mov    %dl,(%rax)
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	48 83 ec 50          	sub    $0x50,%rsp
  8032f2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8032f6:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8032f9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8032fd:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803301:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803305:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803309:	48 8b 0a             	mov    (%rdx),%rcx
  80330c:	48 89 08             	mov    %rcx,(%rax)
  80330f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803313:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803317:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80331b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80331f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803323:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803327:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80332a:	48 98                	cltq   
  80332c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803330:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803334:	48 01 d0             	add    %rdx,%rax
  803337:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80333b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803342:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803347:	74 06                	je     80334f <vsnprintf+0x65>
  803349:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80334d:	7f 07                	jg     803356 <vsnprintf+0x6c>
		return -E_INVAL;
  80334f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803354:	eb 2f                	jmp    803385 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803356:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80335a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80335e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803362:	48 89 c6             	mov    %rax,%rsi
  803365:	48 bf 9d 32 80 00 00 	movabs $0x80329d,%rdi
  80336c:	00 00 00 
  80336f:	48 b8 bf 2c 80 00 00 	movabs $0x802cbf,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80337b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803382:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803385:	c9                   	leaveq 
  803386:	c3                   	retq   

0000000000803387 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803387:	55                   	push   %rbp
  803388:	48 89 e5             	mov    %rsp,%rbp
  80338b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803392:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803399:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80339f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033a6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033ad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033b4:	84 c0                	test   %al,%al
  8033b6:	74 20                	je     8033d8 <snprintf+0x51>
  8033b8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033bc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033c0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033c4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033c8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033cc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033d0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033d4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033d8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8033df:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8033e6:	00 00 00 
  8033e9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033f0:	00 00 00 
  8033f3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033f7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033fe:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803405:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80340c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803413:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80341a:	48 8b 0a             	mov    (%rdx),%rcx
  80341d:	48 89 08             	mov    %rcx,(%rax)
  803420:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803424:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803428:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80342c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803430:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803437:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80343e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803444:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80344b:	48 89 c7             	mov    %rax,%rdi
  80344e:	48 b8 ea 32 80 00 00 	movabs $0x8032ea,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803460:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803466:	c9                   	leaveq 
  803467:	c3                   	retq   

0000000000803468 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803468:	55                   	push   %rbp
  803469:	48 89 e5             	mov    %rsp,%rbp
  80346c:	48 83 ec 30          	sub    $0x30,%rsp
  803470:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803478:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80347c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803481:	75 0e                	jne    803491 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803483:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80348a:	00 00 00 
  80348d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803491:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803495:	48 89 c7             	mov    %rax,%rdi
  803498:	48 b8 ca 0d 80 00 00 	movabs $0x800dca,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ab:	79 27                	jns    8034d4 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  8034ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034b2:	74 0a                	je     8034be <ipc_recv+0x56>
            *from_env_store = 0;
  8034b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  8034be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034c3:	74 0a                	je     8034cf <ipc_recv+0x67>
            *perm_store = 0;
  8034c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8034cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d2:	eb 53                	jmp    803527 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8034d4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034d9:	74 19                	je     8034f4 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8034db:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034e2:	00 00 00 
  8034e5:	48 8b 00             	mov    (%rax),%rax
  8034e8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8034ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f2:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8034f4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034f9:	74 19                	je     803514 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8034fb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803502:	00 00 00 
  803505:	48 8b 00             	mov    (%rax),%rax
  803508:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80350e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803512:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  803514:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80351b:	00 00 00 
  80351e:	48 8b 00             	mov    (%rax),%rax
  803521:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  803527:	c9                   	leaveq 
  803528:	c3                   	retq   

0000000000803529 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803529:	55                   	push   %rbp
  80352a:	48 89 e5             	mov    %rsp,%rbp
  80352d:	48 83 ec 30          	sub    $0x30,%rsp
  803531:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803534:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803537:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80353b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80353e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803543:	75 0e                	jne    803553 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803545:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80354c:	00 00 00 
  80354f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803553:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803556:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803559:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80355d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803560:	89 c7                	mov    %eax,%edi
  803562:	48 b8 75 0d 80 00 00 	movabs $0x800d75,%rax
  803569:	00 00 00 
  80356c:	ff d0                	callq  *%rax
  80356e:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803571:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803575:	79 36                	jns    8035ad <ipc_send+0x84>
  803577:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80357b:	74 30                	je     8035ad <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80357d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803580:	89 c1                	mov    %eax,%ecx
  803582:	48 ba 88 3d 80 00 00 	movabs $0x803d88,%rdx
  803589:	00 00 00 
  80358c:	be 49 00 00 00       	mov    $0x49,%esi
  803591:	48 bf 95 3d 80 00 00 	movabs $0x803d95,%rdi
  803598:	00 00 00 
  80359b:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a0:	49 b8 d3 26 80 00 00 	movabs $0x8026d3,%r8
  8035a7:	00 00 00 
  8035aa:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  8035ad:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
    } while(r != 0);
  8035b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035bd:	75 94                	jne    803553 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  8035bf:	c9                   	leaveq 
  8035c0:	c3                   	retq   

00000000008035c1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035c1:	55                   	push   %rbp
  8035c2:	48 89 e5             	mov    %rsp,%rbp
  8035c5:	48 83 ec 14          	sub    $0x14,%rsp
  8035c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8035cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035d3:	eb 5e                	jmp    803633 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8035d5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035dc:	00 00 00 
  8035df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e2:	48 63 d0             	movslq %eax,%rdx
  8035e5:	48 89 d0             	mov    %rdx,%rax
  8035e8:	48 c1 e0 03          	shl    $0x3,%rax
  8035ec:	48 01 d0             	add    %rdx,%rax
  8035ef:	48 c1 e0 05          	shl    $0x5,%rax
  8035f3:	48 01 c8             	add    %rcx,%rax
  8035f6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8035fc:	8b 00                	mov    (%rax),%eax
  8035fe:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803601:	75 2c                	jne    80362f <ipc_find_env+0x6e>
			return envs[i].env_id;
  803603:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80360a:	00 00 00 
  80360d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803610:	48 63 d0             	movslq %eax,%rdx
  803613:	48 89 d0             	mov    %rdx,%rax
  803616:	48 c1 e0 03          	shl    $0x3,%rax
  80361a:	48 01 d0             	add    %rdx,%rax
  80361d:	48 c1 e0 05          	shl    $0x5,%rax
  803621:	48 01 c8             	add    %rcx,%rax
  803624:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80362a:	8b 40 08             	mov    0x8(%rax),%eax
  80362d:	eb 12                	jmp    803641 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80362f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803633:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80363a:	7e 99                	jle    8035d5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80363c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803641:	c9                   	leaveq 
  803642:	c3                   	retq   

0000000000803643 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803643:	55                   	push   %rbp
  803644:	48 89 e5             	mov    %rsp,%rbp
  803647:	48 83 ec 18          	sub    $0x18,%rsp
  80364b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80364f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803653:	48 c1 e8 15          	shr    $0x15,%rax
  803657:	48 89 c2             	mov    %rax,%rdx
  80365a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803661:	01 00 00 
  803664:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803668:	83 e0 01             	and    $0x1,%eax
  80366b:	48 85 c0             	test   %rax,%rax
  80366e:	75 07                	jne    803677 <pageref+0x34>
		return 0;
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
  803675:	eb 53                	jmp    8036ca <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367b:	48 c1 e8 0c          	shr    $0xc,%rax
  80367f:	48 89 c2             	mov    %rax,%rdx
  803682:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803689:	01 00 00 
  80368c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803690:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803698:	83 e0 01             	and    $0x1,%eax
  80369b:	48 85 c0             	test   %rax,%rax
  80369e:	75 07                	jne    8036a7 <pageref+0x64>
		return 0;
  8036a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a5:	eb 23                	jmp    8036ca <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8036a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8036af:	48 89 c2             	mov    %rax,%rdx
  8036b2:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8036b9:	00 00 00 
  8036bc:	48 c1 e2 04          	shl    $0x4,%rdx
  8036c0:	48 01 d0             	add    %rdx,%rax
  8036c3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8036c7:	0f b7 c0             	movzwl %ax,%eax
}
  8036ca:	c9                   	leaveq 
  8036cb:	c3                   	retq   
