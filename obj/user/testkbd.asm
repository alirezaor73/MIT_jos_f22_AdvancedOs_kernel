
obj/user/testkbd:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
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
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba a0 3b 80 00 00 	movabs $0x803ba0,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf ad 3b 80 00 00 	movabs $0x803bad,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba bc 3b 80 00 00 	movabs $0x803bbc,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf ad 3b 80 00 00 	movabs $0x803bad,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba d6 3b 80 00 00 	movabs $0x803bd6,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf ad 3b 80 00 00 	movabs $0x803bad,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf de 3b 80 00 00 	movabs $0x803bde,%rdi
  800153:	00 00 00 
  800156:	48 b8 b4 12 80 00 00 	movabs $0x8012b4,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be ec 3b 80 00 00 	movabs $0x803bec,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 f5 31 80 00 00 	movabs $0x8031f5,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be f0 3b 80 00 00 	movabs $0x803bf0,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba f5 31 80 00 00 	movabs $0x8031f5,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 16 20 80 00 00 	movabs $0x802016,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 ab 1c 80 00 00 	movabs $0x801cab,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be 0d 3c 80 00 00 	movabs $0x803c0d,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 7a 14 80 00 00 	movabs $0x80147a,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 20          	sub    $0x20,%rsp
  800473:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800476:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80047a:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  800489:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80048c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800491:	48 63 d0             	movslq %eax,%rdx
  800494:	48 89 d0             	mov    %rdx,%rax
  800497:	48 c1 e0 03          	shl    $0x3,%rax
  80049b:	48 01 d0             	add    %rdx,%rax
  80049e:	48 c1 e0 05          	shl    $0x5,%rax
  8004a2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8004a9:	00 00 00 
  8004ac:	48 01 c2             	add    %rax,%rdx
  8004af:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8004b6:	00 00 00 
  8004b9:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8004c0:	7e 14                	jle    8004d6 <libmain+0x6b>
		binaryname = argv[0];
  8004c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004c6:	48 8b 10             	mov    (%rax),%rdx
  8004c9:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8004d0:	00 00 00 
  8004d3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004dd:	48 89 d6             	mov    %rdx,%rsi
  8004e0:	89 c7                	mov    %eax,%edi
  8004e2:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004e9:	00 00 00 
  8004ec:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004ee:	48 b8 fc 04 80 00 00 	movabs $0x8004fc,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
}
  8004fa:	c9                   	leaveq 
  8004fb:	c3                   	retq   

00000000008004fc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004fc:	55                   	push   %rbp
  8004fd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800500:	48 b8 57 23 80 00 00 	movabs $0x802357,%rax
  800507:	00 00 00 
  80050a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80050c:	bf 00 00 00 00       	mov    $0x0,%edi
  800511:	48 b8 e9 1c 80 00 00 	movabs $0x801ce9,%rax
  800518:	00 00 00 
  80051b:	ff d0                	callq  *%rax
}
  80051d:	5d                   	pop    %rbp
  80051e:	c3                   	retq   

000000000080051f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80051f:	55                   	push   %rbp
  800520:	48 89 e5             	mov    %rsp,%rbp
  800523:	53                   	push   %rbx
  800524:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80052b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800532:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800538:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80053f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800546:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80054d:	84 c0                	test   %al,%al
  80054f:	74 23                	je     800574 <_panic+0x55>
  800551:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800558:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80055c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800560:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800564:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800568:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80056c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800570:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800574:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80057b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800582:	00 00 00 
  800585:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80058c:	00 00 00 
  80058f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800593:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80059a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a8:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8005af:	00 00 00 
  8005b2:	48 8b 18             	mov    (%rax),%rbx
  8005b5:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  8005bc:	00 00 00 
  8005bf:	ff d0                	callq  *%rax
  8005c1:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005ce:	41 89 c8             	mov    %ecx,%r8d
  8005d1:	48 89 d1             	mov    %rdx,%rcx
  8005d4:	48 89 da             	mov    %rbx,%rdx
  8005d7:	89 c6                	mov    %eax,%esi
  8005d9:	48 bf 20 3c 80 00 00 	movabs $0x803c20,%rdi
  8005e0:	00 00 00 
  8005e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e8:	49 b9 58 07 80 00 00 	movabs $0x800758,%r9
  8005ef:	00 00 00 
  8005f2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005fc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800603:	48 89 d6             	mov    %rdx,%rsi
  800606:	48 89 c7             	mov    %rax,%rdi
  800609:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  800610:	00 00 00 
  800613:	ff d0                	callq  *%rax
	cprintf("\n");
  800615:	48 bf 43 3c 80 00 00 	movabs $0x803c43,%rdi
  80061c:	00 00 00 
  80061f:	b8 00 00 00 00       	mov    $0x0,%eax
  800624:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  80062b:	00 00 00 
  80062e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800630:	cc                   	int3   
  800631:	eb fd                	jmp    800630 <_panic+0x111>

0000000000800633 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800633:	55                   	push   %rbp
  800634:	48 89 e5             	mov    %rsp,%rbp
  800637:	48 83 ec 10          	sub    $0x10,%rsp
  80063b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80063e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	8d 48 01             	lea    0x1(%rax),%ecx
  80064b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064f:	89 0a                	mov    %ecx,(%rdx)
  800651:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800654:	89 d1                	mov    %edx,%ecx
  800656:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065a:	48 98                	cltq   
  80065c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066b:	75 2c                	jne    800699 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	8b 00                	mov    (%rax),%eax
  800673:	48 98                	cltq   
  800675:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800679:	48 83 c2 08          	add    $0x8,%rdx
  80067d:	48 89 c6             	mov    %rax,%rsi
  800680:	48 89 d7             	mov    %rdx,%rdi
  800683:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  80068a:	00 00 00 
  80068d:	ff d0                	callq  *%rax
        b->idx = 0;
  80068f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800693:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069d:	8b 40 04             	mov    0x4(%rax),%eax
  8006a0:	8d 50 01             	lea    0x1(%rax),%edx
  8006a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006aa:	c9                   	leaveq 
  8006ab:	c3                   	retq   

00000000008006ac <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006be:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006c5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006cc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d3:	48 8b 0a             	mov    (%rdx),%rcx
  8006d6:	48 89 08             	mov    %rcx,(%rax)
  8006d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006f0:	00 00 00 
    b.cnt = 0;
  8006f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006fa:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006fd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800704:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800712:	48 89 c6             	mov    %rax,%rsi
  800715:	48 bf 33 06 80 00 00 	movabs $0x800633,%rdi
  80071c:	00 00 00 
  80071f:	48 b8 0b 0b 80 00 00 	movabs $0x800b0b,%rax
  800726:	00 00 00 
  800729:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80072b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800731:	48 98                	cltq   
  800733:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80073a:	48 83 c2 08          	add    $0x8,%rdx
  80073e:	48 89 c6             	mov    %rax,%rsi
  800741:	48 89 d7             	mov    %rdx,%rdi
  800744:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  80074b:	00 00 00 
  80074e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800750:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800756:	c9                   	leaveq 
  800757:	c3                   	retq   

0000000000800758 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800758:	55                   	push   %rbp
  800759:	48 89 e5             	mov    %rsp,%rbp
  80075c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800763:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80076a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800771:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800778:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80077f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800786:	84 c0                	test   %al,%al
  800788:	74 20                	je     8007aa <cprintf+0x52>
  80078a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80078e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800792:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800796:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80079a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80079e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007aa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007b1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b8:	00 00 00 
  8007bb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c2:	00 00 00 
  8007c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007d0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007de:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007ec:	48 8b 0a             	mov    (%rdx),%rcx
  8007ef:	48 89 08             	mov    %rcx,(%rax)
  8007f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800802:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800809:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800810:	48 89 d6             	mov    %rdx,%rsi
  800813:	48 89 c7             	mov    %rax,%rdi
  800816:	48 b8 ac 06 80 00 00 	movabs $0x8006ac,%rax
  80081d:	00 00 00 
  800820:	ff d0                	callq  *%rax
  800822:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800828:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80082e:	c9                   	leaveq 
  80082f:	c3                   	retq   

0000000000800830 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800830:	55                   	push   %rbp
  800831:	48 89 e5             	mov    %rsp,%rbp
  800834:	53                   	push   %rbx
  800835:	48 83 ec 38          	sub    $0x38,%rsp
  800839:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80083d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800841:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800845:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800848:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80084c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800850:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800853:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800857:	77 3b                	ja     800894 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800859:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80085c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800860:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800867:	ba 00 00 00 00       	mov    $0x0,%edx
  80086c:	48 f7 f3             	div    %rbx
  80086f:	48 89 c2             	mov    %rax,%rdx
  800872:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800875:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800878:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	41 89 f9             	mov    %edi,%r9d
  800883:	48 89 c7             	mov    %rax,%rdi
  800886:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  80088d:	00 00 00 
  800890:	ff d0                	callq  *%rax
  800892:	eb 1e                	jmp    8008b2 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800894:	eb 12                	jmp    8008a8 <printnum+0x78>
			putch(padc, putdat);
  800896:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80089a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80089d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a1:	48 89 ce             	mov    %rcx,%rsi
  8008a4:	89 d7                	mov    %edx,%edi
  8008a6:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a8:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008ac:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008b0:	7f e4                	jg     800896 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	48 f7 f1             	div    %rcx
  8008c1:	48 89 d0             	mov    %rdx,%rax
  8008c4:	48 ba 50 3e 80 00 00 	movabs $0x803e50,%rdx
  8008cb:	00 00 00 
  8008ce:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008d2:	0f be d0             	movsbl %al,%edx
  8008d5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dd:	48 89 ce             	mov    %rcx,%rsi
  8008e0:	89 d7                	mov    %edx,%edi
  8008e2:	ff d0                	callq  *%rax
}
  8008e4:	48 83 c4 38          	add    $0x38,%rsp
  8008e8:	5b                   	pop    %rbx
  8008e9:	5d                   	pop    %rbp
  8008ea:	c3                   	retq   

00000000008008eb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008eb:	55                   	push   %rbp
  8008ec:	48 89 e5             	mov    %rsp,%rbp
  8008ef:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8008fa:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fe:	7e 52                	jle    800952 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	8b 00                	mov    (%rax),%eax
  800906:	83 f8 30             	cmp    $0x30,%eax
  800909:	73 24                	jae    80092f <getuint+0x44>
  80090b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800917:	8b 00                	mov    (%rax),%eax
  800919:	89 c0                	mov    %eax,%eax
  80091b:	48 01 d0             	add    %rdx,%rax
  80091e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800922:	8b 12                	mov    (%rdx),%edx
  800924:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800927:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092b:	89 0a                	mov    %ecx,(%rdx)
  80092d:	eb 17                	jmp    800946 <getuint+0x5b>
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800937:	48 89 d0             	mov    %rdx,%rax
  80093a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800942:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800946:	48 8b 00             	mov    (%rax),%rax
  800949:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094d:	e9 a3 00 00 00       	jmpq   8009f5 <getuint+0x10a>
	else if (lflag)
  800952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800956:	74 4f                	je     8009a7 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	83 f8 30             	cmp    $0x30,%eax
  800961:	73 24                	jae    800987 <getuint+0x9c>
  800963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800967:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096f:	8b 00                	mov    (%rax),%eax
  800971:	89 c0                	mov    %eax,%eax
  800973:	48 01 d0             	add    %rdx,%rax
  800976:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097a:	8b 12                	mov    (%rdx),%edx
  80097c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800983:	89 0a                	mov    %ecx,(%rdx)
  800985:	eb 17                	jmp    80099e <getuint+0xb3>
  800987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80098f:	48 89 d0             	mov    %rdx,%rax
  800992:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800996:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099e:	48 8b 00             	mov    (%rax),%rax
  8009a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a5:	eb 4e                	jmp    8009f5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	8b 00                	mov    (%rax),%eax
  8009ad:	83 f8 30             	cmp    $0x30,%eax
  8009b0:	73 24                	jae    8009d6 <getuint+0xeb>
  8009b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	8b 00                	mov    (%rax),%eax
  8009c0:	89 c0                	mov    %eax,%eax
  8009c2:	48 01 d0             	add    %rdx,%rax
  8009c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c9:	8b 12                	mov    (%rdx),%edx
  8009cb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d2:	89 0a                	mov    %ecx,(%rdx)
  8009d4:	eb 17                	jmp    8009ed <getuint+0x102>
  8009d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009da:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009de:	48 89 d0             	mov    %rdx,%rax
  8009e1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ed:	8b 00                	mov    (%rax),%eax
  8009ef:	89 c0                	mov    %eax,%eax
  8009f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f9:	c9                   	leaveq 
  8009fa:	c3                   	retq   

00000000008009fb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009fb:	55                   	push   %rbp
  8009fc:	48 89 e5             	mov    %rsp,%rbp
  8009ff:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a07:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a0a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a0e:	7e 52                	jle    800a62 <getint+0x67>
		x=va_arg(*ap, long long);
  800a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a14:	8b 00                	mov    (%rax),%eax
  800a16:	83 f8 30             	cmp    $0x30,%eax
  800a19:	73 24                	jae    800a3f <getint+0x44>
  800a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a27:	8b 00                	mov    (%rax),%eax
  800a29:	89 c0                	mov    %eax,%eax
  800a2b:	48 01 d0             	add    %rdx,%rax
  800a2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a32:	8b 12                	mov    (%rdx),%edx
  800a34:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3b:	89 0a                	mov    %ecx,(%rdx)
  800a3d:	eb 17                	jmp    800a56 <getint+0x5b>
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a47:	48 89 d0             	mov    %rdx,%rax
  800a4a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a52:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a56:	48 8b 00             	mov    (%rax),%rax
  800a59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5d:	e9 a3 00 00 00       	jmpq   800b05 <getint+0x10a>
	else if (lflag)
  800a62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a66:	74 4f                	je     800ab7 <getint+0xbc>
		x=va_arg(*ap, long);
  800a68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6c:	8b 00                	mov    (%rax),%eax
  800a6e:	83 f8 30             	cmp    $0x30,%eax
  800a71:	73 24                	jae    800a97 <getint+0x9c>
  800a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a77:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7f:	8b 00                	mov    (%rax),%eax
  800a81:	89 c0                	mov    %eax,%eax
  800a83:	48 01 d0             	add    %rdx,%rax
  800a86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8a:	8b 12                	mov    (%rdx),%edx
  800a8c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a93:	89 0a                	mov    %ecx,(%rdx)
  800a95:	eb 17                	jmp    800aae <getint+0xb3>
  800a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a9f:	48 89 d0             	mov    %rdx,%rax
  800aa2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aaa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aae:	48 8b 00             	mov    (%rax),%rax
  800ab1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab5:	eb 4e                	jmp    800b05 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abb:	8b 00                	mov    (%rax),%eax
  800abd:	83 f8 30             	cmp    $0x30,%eax
  800ac0:	73 24                	jae    800ae6 <getint+0xeb>
  800ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ace:	8b 00                	mov    (%rax),%eax
  800ad0:	89 c0                	mov    %eax,%eax
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad9:	8b 12                	mov    (%rdx),%edx
  800adb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ade:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae2:	89 0a                	mov    %ecx,(%rdx)
  800ae4:	eb 17                	jmp    800afd <getint+0x102>
  800ae6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aee:	48 89 d0             	mov    %rdx,%rax
  800af1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800afd:	8b 00                	mov    (%rax),%eax
  800aff:	48 98                	cltq   
  800b01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b09:	c9                   	leaveq 
  800b0a:	c3                   	retq   

0000000000800b0b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b0b:	55                   	push   %rbp
  800b0c:	48 89 e5             	mov    %rsp,%rbp
  800b0f:	41 54                	push   %r12
  800b11:	53                   	push   %rbx
  800b12:	48 83 ec 60          	sub    $0x60,%rsp
  800b16:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b1a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b1e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b22:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b2a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b2e:	48 8b 0a             	mov    (%rdx),%rcx
  800b31:	48 89 08             	mov    %rcx,(%rax)
  800b34:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b38:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b3c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b40:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b44:	eb 17                	jmp    800b5d <vprintfmt+0x52>
			if (ch == '\0')
  800b46:	85 db                	test   %ebx,%ebx
  800b48:	0f 84 df 04 00 00    	je     80102d <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800b4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b56:	48 89 d6             	mov    %rdx,%rsi
  800b59:	89 df                	mov    %ebx,%edi
  800b5b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b5d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b61:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b65:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b69:	0f b6 00             	movzbl (%rax),%eax
  800b6c:	0f b6 d8             	movzbl %al,%ebx
  800b6f:	83 fb 25             	cmp    $0x25,%ebx
  800b72:	75 d2                	jne    800b46 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b74:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b78:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b7f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b8d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b94:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b98:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b9c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ba0:	0f b6 00             	movzbl (%rax),%eax
  800ba3:	0f b6 d8             	movzbl %al,%ebx
  800ba6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ba9:	83 f8 55             	cmp    $0x55,%eax
  800bac:	0f 87 47 04 00 00    	ja     800ff9 <vprintfmt+0x4ee>
  800bb2:	89 c0                	mov    %eax,%eax
  800bb4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bbb:	00 
  800bbc:	48 b8 78 3e 80 00 00 	movabs $0x803e78,%rax
  800bc3:	00 00 00 
  800bc6:	48 01 d0             	add    %rdx,%rax
  800bc9:	48 8b 00             	mov    (%rax),%rax
  800bcc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bce:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bd2:	eb c0                	jmp    800b94 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bd8:	eb ba                	jmp    800b94 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bda:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800be1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	c1 e0 02             	shl    $0x2,%eax
  800be9:	01 d0                	add    %edx,%eax
  800beb:	01 c0                	add    %eax,%eax
  800bed:	01 d8                	add    %ebx,%eax
  800bef:	83 e8 30             	sub    $0x30,%eax
  800bf2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bf5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf9:	0f b6 00             	movzbl (%rax),%eax
  800bfc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bff:	83 fb 2f             	cmp    $0x2f,%ebx
  800c02:	7e 0c                	jle    800c10 <vprintfmt+0x105>
  800c04:	83 fb 39             	cmp    $0x39,%ebx
  800c07:	7f 07                	jg     800c10 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c09:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c0e:	eb d1                	jmp    800be1 <vprintfmt+0xd6>
			goto process_precision;
  800c10:	eb 58                	jmp    800c6a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c15:	83 f8 30             	cmp    $0x30,%eax
  800c18:	73 17                	jae    800c31 <vprintfmt+0x126>
  800c1a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c21:	89 c0                	mov    %eax,%eax
  800c23:	48 01 d0             	add    %rdx,%rax
  800c26:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c29:	83 c2 08             	add    $0x8,%edx
  800c2c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c2f:	eb 0f                	jmp    800c40 <vprintfmt+0x135>
  800c31:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c35:	48 89 d0             	mov    %rdx,%rax
  800c38:	48 83 c2 08          	add    $0x8,%rdx
  800c3c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c40:	8b 00                	mov    (%rax),%eax
  800c42:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c45:	eb 23                	jmp    800c6a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4b:	79 0c                	jns    800c59 <vprintfmt+0x14e>
				width = 0;
  800c4d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c54:	e9 3b ff ff ff       	jmpq   800b94 <vprintfmt+0x89>
  800c59:	e9 36 ff ff ff       	jmpq   800b94 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c5e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c65:	e9 2a ff ff ff       	jmpq   800b94 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c6e:	79 12                	jns    800c82 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c70:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c73:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c76:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c7d:	e9 12 ff ff ff       	jmpq   800b94 <vprintfmt+0x89>
  800c82:	e9 0d ff ff ff       	jmpq   800b94 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c87:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c8b:	e9 04 ff ff ff       	jmpq   800b94 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c93:	83 f8 30             	cmp    $0x30,%eax
  800c96:	73 17                	jae    800caf <vprintfmt+0x1a4>
  800c98:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9f:	89 c0                	mov    %eax,%eax
  800ca1:	48 01 d0             	add    %rdx,%rax
  800ca4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca7:	83 c2 08             	add    $0x8,%edx
  800caa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cad:	eb 0f                	jmp    800cbe <vprintfmt+0x1b3>
  800caf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb3:	48 89 d0             	mov    %rdx,%rax
  800cb6:	48 83 c2 08          	add    $0x8,%rdx
  800cba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbe:	8b 10                	mov    (%rax),%edx
  800cc0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc8:	48 89 ce             	mov    %rcx,%rsi
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	ff d0                	callq  *%rax
			break;
  800ccf:	e9 53 03 00 00       	jmpq   801027 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd7:	83 f8 30             	cmp    $0x30,%eax
  800cda:	73 17                	jae    800cf3 <vprintfmt+0x1e8>
  800cdc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce3:	89 c0                	mov    %eax,%eax
  800ce5:	48 01 d0             	add    %rdx,%rax
  800ce8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ceb:	83 c2 08             	add    $0x8,%edx
  800cee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf1:	eb 0f                	jmp    800d02 <vprintfmt+0x1f7>
  800cf3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf7:	48 89 d0             	mov    %rdx,%rax
  800cfa:	48 83 c2 08          	add    $0x8,%rdx
  800cfe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d02:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d04:	85 db                	test   %ebx,%ebx
  800d06:	79 02                	jns    800d0a <vprintfmt+0x1ff>
				err = -err;
  800d08:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d0a:	83 fb 15             	cmp    $0x15,%ebx
  800d0d:	7f 16                	jg     800d25 <vprintfmt+0x21a>
  800d0f:	48 b8 a0 3d 80 00 00 	movabs $0x803da0,%rax
  800d16:	00 00 00 
  800d19:	48 63 d3             	movslq %ebx,%rdx
  800d1c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d20:	4d 85 e4             	test   %r12,%r12
  800d23:	75 2e                	jne    800d53 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d25:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	89 d9                	mov    %ebx,%ecx
  800d2f:	48 ba 61 3e 80 00 00 	movabs $0x803e61,%rdx
  800d36:	00 00 00 
  800d39:	48 89 c7             	mov    %rax,%rdi
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	49 b8 36 10 80 00 00 	movabs $0x801036,%r8
  800d48:	00 00 00 
  800d4b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d4e:	e9 d4 02 00 00       	jmpq   801027 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d53:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5b:	4c 89 e1             	mov    %r12,%rcx
  800d5e:	48 ba 6a 3e 80 00 00 	movabs $0x803e6a,%rdx
  800d65:	00 00 00 
  800d68:	48 89 c7             	mov    %rax,%rdi
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	49 b8 36 10 80 00 00 	movabs $0x801036,%r8
  800d77:	00 00 00 
  800d7a:	41 ff d0             	callq  *%r8
			break;
  800d7d:	e9 a5 02 00 00       	jmpq   801027 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d85:	83 f8 30             	cmp    $0x30,%eax
  800d88:	73 17                	jae    800da1 <vprintfmt+0x296>
  800d8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d91:	89 c0                	mov    %eax,%eax
  800d93:	48 01 d0             	add    %rdx,%rax
  800d96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d99:	83 c2 08             	add    $0x8,%edx
  800d9c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d9f:	eb 0f                	jmp    800db0 <vprintfmt+0x2a5>
  800da1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da5:	48 89 d0             	mov    %rdx,%rax
  800da8:	48 83 c2 08          	add    $0x8,%rdx
  800dac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db0:	4c 8b 20             	mov    (%rax),%r12
  800db3:	4d 85 e4             	test   %r12,%r12
  800db6:	75 0a                	jne    800dc2 <vprintfmt+0x2b7>
				p = "(null)";
  800db8:	49 bc 6d 3e 80 00 00 	movabs $0x803e6d,%r12
  800dbf:	00 00 00 
			if (width > 0 && padc != '-')
  800dc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc6:	7e 3f                	jle    800e07 <vprintfmt+0x2fc>
  800dc8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dcc:	74 39                	je     800e07 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dd1:	48 98                	cltq   
  800dd3:	48 89 c6             	mov    %rax,%rsi
  800dd6:	4c 89 e7             	mov    %r12,%rdi
  800dd9:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  800de0:	00 00 00 
  800de3:	ff d0                	callq  *%rax
  800de5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de8:	eb 17                	jmp    800e01 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dea:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dee:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800df2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df6:	48 89 ce             	mov    %rcx,%rsi
  800df9:	89 d7                	mov    %edx,%edi
  800dfb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e01:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e05:	7f e3                	jg     800dea <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e07:	eb 37                	jmp    800e40 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e09:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e0d:	74 1e                	je     800e2d <vprintfmt+0x322>
  800e0f:	83 fb 1f             	cmp    $0x1f,%ebx
  800e12:	7e 05                	jle    800e19 <vprintfmt+0x30e>
  800e14:	83 fb 7e             	cmp    $0x7e,%ebx
  800e17:	7e 14                	jle    800e2d <vprintfmt+0x322>
					putch('?', putdat);
  800e19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e21:	48 89 d6             	mov    %rdx,%rsi
  800e24:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e29:	ff d0                	callq  *%rax
  800e2b:	eb 0f                	jmp    800e3c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e35:	48 89 d6             	mov    %rdx,%rsi
  800e38:	89 df                	mov    %ebx,%edi
  800e3a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e40:	4c 89 e0             	mov    %r12,%rax
  800e43:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e47:	0f b6 00             	movzbl (%rax),%eax
  800e4a:	0f be d8             	movsbl %al,%ebx
  800e4d:	85 db                	test   %ebx,%ebx
  800e4f:	74 10                	je     800e61 <vprintfmt+0x356>
  800e51:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e55:	78 b2                	js     800e09 <vprintfmt+0x2fe>
  800e57:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e5f:	79 a8                	jns    800e09 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e61:	eb 16                	jmp    800e79 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6b:	48 89 d6             	mov    %rdx,%rsi
  800e6e:	bf 20 00 00 00       	mov    $0x20,%edi
  800e73:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e75:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e7d:	7f e4                	jg     800e63 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e7f:	e9 a3 01 00 00       	jmpq   801027 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e84:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e88:	be 03 00 00 00       	mov    $0x3,%esi
  800e8d:	48 89 c7             	mov    %rax,%rdi
  800e90:	48 b8 fb 09 80 00 00 	movabs $0x8009fb,%rax
  800e97:	00 00 00 
  800e9a:	ff d0                	callq  *%rax
  800e9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea4:	48 85 c0             	test   %rax,%rax
  800ea7:	79 1d                	jns    800ec6 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ea9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ead:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb1:	48 89 d6             	mov    %rdx,%rsi
  800eb4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eb9:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebf:	48 f7 d8             	neg    %rax
  800ec2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ec6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ecd:	e9 e8 00 00 00       	jmpq   800fba <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ed2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed6:	be 03 00 00 00       	mov    $0x3,%esi
  800edb:	48 89 c7             	mov    %rax,%rdi
  800ede:	48 b8 eb 08 80 00 00 	movabs $0x8008eb,%rax
  800ee5:	00 00 00 
  800ee8:	ff d0                	callq  *%rax
  800eea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800eee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef5:	e9 c0 00 00 00       	jmpq   800fba <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800efa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800efe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f02:	48 89 d6             	mov    %rdx,%rsi
  800f05:	bf 58 00 00 00       	mov    $0x58,%edi
  800f0a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f14:	48 89 d6             	mov    %rdx,%rsi
  800f17:	bf 58 00 00 00       	mov    $0x58,%edi
  800f1c:	ff d0                	callq  *%rax
			putch('X', putdat);
  800f1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f26:	48 89 d6             	mov    %rdx,%rsi
  800f29:	bf 58 00 00 00       	mov    $0x58,%edi
  800f2e:	ff d0                	callq  *%rax
			break;
  800f30:	e9 f2 00 00 00       	jmpq   801027 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800f35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3d:	48 89 d6             	mov    %rdx,%rsi
  800f40:	bf 30 00 00 00       	mov    $0x30,%edi
  800f45:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4f:	48 89 d6             	mov    %rdx,%rsi
  800f52:	bf 78 00 00 00       	mov    $0x78,%edi
  800f57:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f5c:	83 f8 30             	cmp    $0x30,%eax
  800f5f:	73 17                	jae    800f78 <vprintfmt+0x46d>
  800f61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f68:	89 c0                	mov    %eax,%eax
  800f6a:	48 01 d0             	add    %rdx,%rax
  800f6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f70:	83 c2 08             	add    $0x8,%edx
  800f73:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f76:	eb 0f                	jmp    800f87 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800f78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f7c:	48 89 d0             	mov    %rdx,%rax
  800f7f:	48 83 c2 08          	add    $0x8,%rdx
  800f83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f87:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f8e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f95:	eb 23                	jmp    800fba <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f9b:	be 03 00 00 00       	mov    $0x3,%esi
  800fa0:	48 89 c7             	mov    %rax,%rdi
  800fa3:	48 b8 eb 08 80 00 00 	movabs $0x8008eb,%rax
  800faa:	00 00 00 
  800fad:	ff d0                	callq  *%rax
  800faf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fba:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fbf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fc2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fc5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fcd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd1:	45 89 c1             	mov    %r8d,%r9d
  800fd4:	41 89 f8             	mov    %edi,%r8d
  800fd7:	48 89 c7             	mov    %rax,%rdi
  800fda:	48 b8 30 08 80 00 00 	movabs $0x800830,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	callq  *%rax
			break;
  800fe6:	eb 3f                	jmp    801027 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fe8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff0:	48 89 d6             	mov    %rdx,%rsi
  800ff3:	89 df                	mov    %ebx,%edi
  800ff5:	ff d0                	callq  *%rax
			break;
  800ff7:	eb 2e                	jmp    801027 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ff9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801001:	48 89 d6             	mov    %rdx,%rsi
  801004:	bf 25 00 00 00       	mov    $0x25,%edi
  801009:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80100b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801010:	eb 05                	jmp    801017 <vprintfmt+0x50c>
  801012:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801017:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80101b:	48 83 e8 01          	sub    $0x1,%rax
  80101f:	0f b6 00             	movzbl (%rax),%eax
  801022:	3c 25                	cmp    $0x25,%al
  801024:	75 ec                	jne    801012 <vprintfmt+0x507>
				/* do nothing */;
			break;
  801026:	90                   	nop
		}
	}
  801027:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801028:	e9 30 fb ff ff       	jmpq   800b5d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80102d:	48 83 c4 60          	add    $0x60,%rsp
  801031:	5b                   	pop    %rbx
  801032:	41 5c                	pop    %r12
  801034:	5d                   	pop    %rbp
  801035:	c3                   	retq   

0000000000801036 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801036:	55                   	push   %rbp
  801037:	48 89 e5             	mov    %rsp,%rbp
  80103a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801041:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801048:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80104f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801056:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80105d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801064:	84 c0                	test   %al,%al
  801066:	74 20                	je     801088 <printfmt+0x52>
  801068:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80106c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801070:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801074:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801078:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80107c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801080:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801084:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801088:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80108f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801096:	00 00 00 
  801099:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010a0:	00 00 00 
  8010a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010ae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010b5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010bc:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010c3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010ca:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010d1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010d8:	48 89 c7             	mov    %rax,%rdi
  8010db:	48 b8 0b 0b 80 00 00 	movabs $0x800b0b,%rax
  8010e2:	00 00 00 
  8010e5:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010e7:	c9                   	leaveq 
  8010e8:	c3                   	retq   

00000000008010e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010e9:	55                   	push   %rbp
  8010ea:	48 89 e5             	mov    %rsp,%rbp
  8010ed:	48 83 ec 10          	sub    $0x10,%rsp
  8010f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fc:	8b 40 10             	mov    0x10(%rax),%eax
  8010ff:	8d 50 01             	lea    0x1(%rax),%edx
  801102:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801106:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110d:	48 8b 10             	mov    (%rax),%rdx
  801110:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801114:	48 8b 40 08          	mov    0x8(%rax),%rax
  801118:	48 39 c2             	cmp    %rax,%rdx
  80111b:	73 17                	jae    801134 <sprintputch+0x4b>
		*b->buf++ = ch;
  80111d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801121:	48 8b 00             	mov    (%rax),%rax
  801124:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801128:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80112c:	48 89 0a             	mov    %rcx,(%rdx)
  80112f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801132:	88 10                	mov    %dl,(%rax)
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 50          	sub    $0x50,%rsp
  80113e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801142:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801145:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801149:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80114d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801151:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801155:	48 8b 0a             	mov    (%rdx),%rcx
  801158:	48 89 08             	mov    %rcx,(%rax)
  80115b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80115f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801163:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801167:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80116b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80116f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801173:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801176:	48 98                	cltq   
  801178:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80117c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801180:	48 01 d0             	add    %rdx,%rax
  801183:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801187:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80118e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801193:	74 06                	je     80119b <vsnprintf+0x65>
  801195:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801199:	7f 07                	jg     8011a2 <vsnprintf+0x6c>
		return -E_INVAL;
  80119b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a0:	eb 2f                	jmp    8011d1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011a2:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011a6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011aa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011ae:	48 89 c6             	mov    %rax,%rsi
  8011b1:	48 bf e9 10 80 00 00 	movabs $0x8010e9,%rdi
  8011b8:	00 00 00 
  8011bb:	48 b8 0b 0b 80 00 00 	movabs $0x800b0b,%rax
  8011c2:	00 00 00 
  8011c5:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011cb:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011ce:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011d1:	c9                   	leaveq 
  8011d2:	c3                   	retq   

00000000008011d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011d3:	55                   	push   %rbp
  8011d4:	48 89 e5             	mov    %rsp,%rbp
  8011d7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011de:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011e5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011eb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011f2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011f9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801200:	84 c0                	test   %al,%al
  801202:	74 20                	je     801224 <snprintf+0x51>
  801204:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801208:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80120c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801210:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801214:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801218:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80121c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801220:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801224:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80122b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801232:	00 00 00 
  801235:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80123c:	00 00 00 
  80123f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801243:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80124a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801251:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801258:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80125f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801266:	48 8b 0a             	mov    (%rdx),%rcx
  801269:	48 89 08             	mov    %rcx,(%rax)
  80126c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801270:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801274:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801278:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80127c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801283:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80128a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801290:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801297:	48 89 c7             	mov    %rax,%rdi
  80129a:	48 b8 36 11 80 00 00 	movabs $0x801136,%rax
  8012a1:	00 00 00 
  8012a4:	ff d0                	callq  *%rax
  8012a6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012ac:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012b2:	c9                   	leaveq 
  8012b3:	c3                   	retq   

00000000008012b4 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012b4:	55                   	push   %rbp
  8012b5:	48 89 e5             	mov    %rsp,%rbp
  8012b8:	48 83 ec 20          	sub    $0x20,%rsp
  8012bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c5:	74 27                	je     8012ee <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cb:	48 89 c2             	mov    %rax,%rdx
  8012ce:	48 be 28 41 80 00 00 	movabs $0x804128,%rsi
  8012d5:	00 00 00 
  8012d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8012dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e2:	48 b9 f5 31 80 00 00 	movabs $0x8031f5,%rcx
  8012e9:	00 00 00 
  8012ec:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8012ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8012f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fa:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  801301:	00 00 00 
  801304:	ff d0                	callq  *%rax
  801306:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  801309:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  801310:	00 00 00 
  801313:	ff d0                	callq  *%rax
  801315:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  801318:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80131c:	79 30                	jns    80134e <readline+0x9a>
			if (c != -E_EOF)
  80131e:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801322:	74 20                	je     801344 <readline+0x90>
				cprintf("read error: %e\n", c);
  801324:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801327:	89 c6                	mov    %eax,%esi
  801329:	48 bf 2b 41 80 00 00 	movabs $0x80412b,%rdi
  801330:	00 00 00 
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
  801338:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  80133f:	00 00 00 
  801342:	ff d2                	callq  *%rdx
			return NULL;
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
  801349:	e9 be 00 00 00       	jmpq   80140c <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80134e:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801352:	74 06                	je     80135a <readline+0xa6>
  801354:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801358:	75 26                	jne    801380 <readline+0xcc>
  80135a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80135e:	7e 20                	jle    801380 <readline+0xcc>
			if (echoing)
  801360:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801364:	74 11                	je     801377 <readline+0xc3>
				cputchar('\b');
  801366:	bf 08 00 00 00       	mov    $0x8,%edi
  80136b:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801372:	00 00 00 
  801375:	ff d0                	callq  *%rax
			i--;
  801377:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80137b:	e9 87 00 00 00       	jmpq   801407 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801380:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801384:	7e 3f                	jle    8013c5 <readline+0x111>
  801386:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80138d:	7f 36                	jg     8013c5 <readline+0x111>
			if (echoing)
  80138f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801393:	74 11                	je     8013a6 <readline+0xf2>
				cputchar(c);
  801395:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801398:	89 c7                	mov    %eax,%edi
  80139a:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013a1:	00 00 00 
  8013a4:	ff d0                	callq  *%rax
			buf[i++] = c;
  8013a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013a9:	8d 50 01             	lea    0x1(%rax),%edx
  8013ac:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8013af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013b2:	89 d1                	mov    %edx,%ecx
  8013b4:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8013bb:	00 00 00 
  8013be:	48 98                	cltq   
  8013c0:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013c3:	eb 42                	jmp    801407 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8013c5:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013c9:	74 06                	je     8013d1 <readline+0x11d>
  8013cb:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013cf:	75 36                	jne    801407 <readline+0x153>
			if (echoing)
  8013d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013d5:	74 11                	je     8013e8 <readline+0x134>
				cputchar('\n');
  8013d7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013dc:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013e3:	00 00 00 
  8013e6:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013e8:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8013ef:	00 00 00 
  8013f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013f5:	48 98                	cltq   
  8013f7:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8013fb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801402:	00 00 00 
  801405:	eb 05                	jmp    80140c <readline+0x158>
		}
	}
  801407:	e9 fd fe ff ff       	jmpq   801309 <readline+0x55>
}
  80140c:	c9                   	leaveq 
  80140d:	c3                   	retq   

000000000080140e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80140e:	55                   	push   %rbp
  80140f:	48 89 e5             	mov    %rsp,%rbp
  801412:	48 83 ec 18          	sub    $0x18,%rsp
  801416:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80141a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801421:	eb 09                	jmp    80142c <strlen+0x1e>
		n++;
  801423:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801427:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80142c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801430:	0f b6 00             	movzbl (%rax),%eax
  801433:	84 c0                	test   %al,%al
  801435:	75 ec                	jne    801423 <strlen+0x15>
		n++;
	return n;
  801437:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80143a:	c9                   	leaveq 
  80143b:	c3                   	retq   

000000000080143c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80143c:	55                   	push   %rbp
  80143d:	48 89 e5             	mov    %rsp,%rbp
  801440:	48 83 ec 20          	sub    $0x20,%rsp
  801444:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801448:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80144c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801453:	eb 0e                	jmp    801463 <strnlen+0x27>
		n++;
  801455:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801459:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80145e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801463:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801468:	74 0b                	je     801475 <strnlen+0x39>
  80146a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146e:	0f b6 00             	movzbl (%rax),%eax
  801471:	84 c0                	test   %al,%al
  801473:	75 e0                	jne    801455 <strnlen+0x19>
		n++;
	return n;
  801475:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801478:	c9                   	leaveq 
  801479:	c3                   	retq   

000000000080147a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80147a:	55                   	push   %rbp
  80147b:	48 89 e5             	mov    %rsp,%rbp
  80147e:	48 83 ec 20          	sub    $0x20,%rsp
  801482:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801486:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801492:	90                   	nop
  801493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801497:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80149b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80149f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014a3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014a7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014ab:	0f b6 12             	movzbl (%rdx),%edx
  8014ae:	88 10                	mov    %dl,(%rax)
  8014b0:	0f b6 00             	movzbl (%rax),%eax
  8014b3:	84 c0                	test   %al,%al
  8014b5:	75 dc                	jne    801493 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014bb:	c9                   	leaveq 
  8014bc:	c3                   	retq   

00000000008014bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014bd:	55                   	push   %rbp
  8014be:	48 89 e5             	mov    %rsp,%rbp
  8014c1:	48 83 ec 20          	sub    $0x20,%rsp
  8014c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d1:	48 89 c7             	mov    %rax,%rdi
  8014d4:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  8014db:	00 00 00 
  8014de:	ff d0                	callq  *%rax
  8014e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e6:	48 63 d0             	movslq %eax,%rdx
  8014e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ed:	48 01 c2             	add    %rax,%rdx
  8014f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f4:	48 89 c6             	mov    %rax,%rsi
  8014f7:	48 89 d7             	mov    %rdx,%rdi
  8014fa:	48 b8 7a 14 80 00 00 	movabs $0x80147a,%rax
  801501:	00 00 00 
  801504:	ff d0                	callq  *%rax
	return dst;
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80150a:	c9                   	leaveq 
  80150b:	c3                   	retq   

000000000080150c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80150c:	55                   	push   %rbp
  80150d:	48 89 e5             	mov    %rsp,%rbp
  801510:	48 83 ec 28          	sub    $0x28,%rsp
  801514:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801518:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801524:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801528:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80152f:	00 
  801530:	eb 2a                	jmp    80155c <strncpy+0x50>
		*dst++ = *src;
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80153e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801542:	0f b6 12             	movzbl (%rdx),%edx
  801545:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801547:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	84 c0                	test   %al,%al
  801550:	74 05                	je     801557 <strncpy+0x4b>
			src++;
  801552:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801557:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801564:	72 cc                	jb     801532 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80156a:	c9                   	leaveq 
  80156b:	c3                   	retq   

000000000080156c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80156c:	55                   	push   %rbp
  80156d:	48 89 e5             	mov    %rsp,%rbp
  801570:	48 83 ec 28          	sub    $0x28,%rsp
  801574:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801578:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801584:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801588:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80158d:	74 3d                	je     8015cc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80158f:	eb 1d                	jmp    8015ae <strlcpy+0x42>
			*dst++ = *src++;
  801591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801595:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801599:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80159d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015a1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8015a5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8015a9:	0f b6 12             	movzbl (%rdx),%edx
  8015ac:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015ae:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015b8:	74 0b                	je     8015c5 <strlcpy+0x59>
  8015ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015be:	0f b6 00             	movzbl (%rax),%eax
  8015c1:	84 c0                	test   %al,%al
  8015c3:	75 cc                	jne    801591 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d4:	48 29 c2             	sub    %rax,%rdx
  8015d7:	48 89 d0             	mov    %rdx,%rax
}
  8015da:	c9                   	leaveq 
  8015db:	c3                   	retq   

00000000008015dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015dc:	55                   	push   %rbp
  8015dd:	48 89 e5             	mov    %rsp,%rbp
  8015e0:	48 83 ec 10          	sub    $0x10,%rsp
  8015e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015ec:	eb 0a                	jmp    8015f8 <strcmp+0x1c>
		p++, q++;
  8015ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	84 c0                	test   %al,%al
  801601:	74 12                	je     801615 <strcmp+0x39>
  801603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801607:	0f b6 10             	movzbl (%rax),%edx
  80160a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	38 c2                	cmp    %al,%dl
  801613:	74 d9                	je     8015ee <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	0f b6 d0             	movzbl %al,%edx
  80161f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	0f b6 c0             	movzbl %al,%eax
  801629:	29 c2                	sub    %eax,%edx
  80162b:	89 d0                	mov    %edx,%eax
}
  80162d:	c9                   	leaveq 
  80162e:	c3                   	retq   

000000000080162f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80162f:	55                   	push   %rbp
  801630:	48 89 e5             	mov    %rsp,%rbp
  801633:	48 83 ec 18          	sub    $0x18,%rsp
  801637:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80163b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80163f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801643:	eb 0f                	jmp    801654 <strncmp+0x25>
		n--, p++, q++;
  801645:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80164a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80164f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801654:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801659:	74 1d                	je     801678 <strncmp+0x49>
  80165b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	84 c0                	test   %al,%al
  801664:	74 12                	je     801678 <strncmp+0x49>
  801666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166a:	0f b6 10             	movzbl (%rax),%edx
  80166d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	38 c2                	cmp    %al,%dl
  801676:	74 cd                	je     801645 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801678:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80167d:	75 07                	jne    801686 <strncmp+0x57>
		return 0;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	eb 18                	jmp    80169e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	0f b6 d0             	movzbl %al,%edx
  801690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	0f b6 c0             	movzbl %al,%eax
  80169a:	29 c2                	sub    %eax,%edx
  80169c:	89 d0                	mov    %edx,%eax
}
  80169e:	c9                   	leaveq 
  80169f:	c3                   	retq   

00000000008016a0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016a0:	55                   	push   %rbp
  8016a1:	48 89 e5             	mov    %rsp,%rbp
  8016a4:	48 83 ec 0c          	sub    $0xc,%rsp
  8016a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016ac:	89 f0                	mov    %esi,%eax
  8016ae:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016b1:	eb 17                	jmp    8016ca <strchr+0x2a>
		if (*s == c)
  8016b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016bd:	75 06                	jne    8016c5 <strchr+0x25>
			return (char *) s;
  8016bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c3:	eb 15                	jmp    8016da <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ce:	0f b6 00             	movzbl (%rax),%eax
  8016d1:	84 c0                	test   %al,%al
  8016d3:	75 de                	jne    8016b3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	48 83 ec 0c          	sub    $0xc,%rsp
  8016e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016e8:	89 f0                	mov    %esi,%eax
  8016ea:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016ed:	eb 13                	jmp    801702 <strfind+0x26>
		if (*s == c)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016f9:	75 02                	jne    8016fd <strfind+0x21>
			break;
  8016fb:	eb 10                	jmp    80170d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801706:	0f b6 00             	movzbl (%rax),%eax
  801709:	84 c0                	test   %al,%al
  80170b:	75 e2                	jne    8016ef <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80170d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801711:	c9                   	leaveq 
  801712:	c3                   	retq   

0000000000801713 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801713:	55                   	push   %rbp
  801714:	48 89 e5             	mov    %rsp,%rbp
  801717:	48 83 ec 18          	sub    $0x18,%rsp
  80171b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80171f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801722:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801726:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80172b:	75 06                	jne    801733 <memset+0x20>
		return v;
  80172d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801731:	eb 69                	jmp    80179c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801737:	83 e0 03             	and    $0x3,%eax
  80173a:	48 85 c0             	test   %rax,%rax
  80173d:	75 48                	jne    801787 <memset+0x74>
  80173f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801743:	83 e0 03             	and    $0x3,%eax
  801746:	48 85 c0             	test   %rax,%rax
  801749:	75 3c                	jne    801787 <memset+0x74>
		c &= 0xFF;
  80174b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801752:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801755:	c1 e0 18             	shl    $0x18,%eax
  801758:	89 c2                	mov    %eax,%edx
  80175a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80175d:	c1 e0 10             	shl    $0x10,%eax
  801760:	09 c2                	or     %eax,%edx
  801762:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801765:	c1 e0 08             	shl    $0x8,%eax
  801768:	09 d0                	or     %edx,%eax
  80176a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80176d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801771:	48 c1 e8 02          	shr    $0x2,%rax
  801775:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801778:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80177c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80177f:	48 89 d7             	mov    %rdx,%rdi
  801782:	fc                   	cld    
  801783:	f3 ab                	rep stos %eax,%es:(%rdi)
  801785:	eb 11                	jmp    801798 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801787:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80178b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80178e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801792:	48 89 d7             	mov    %rdx,%rdi
  801795:	fc                   	cld    
  801796:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801798:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80179c:	c9                   	leaveq 
  80179d:	c3                   	retq   

000000000080179e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80179e:	55                   	push   %rbp
  80179f:	48 89 e5             	mov    %rsp,%rbp
  8017a2:	48 83 ec 28          	sub    $0x28,%rsp
  8017a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017ca:	0f 83 88 00 00 00    	jae    801858 <memmove+0xba>
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d8:	48 01 d0             	add    %rdx,%rax
  8017db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017df:	76 77                	jbe    801858 <memmove+0xba>
		s += n;
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f5:	83 e0 03             	and    $0x3,%eax
  8017f8:	48 85 c0             	test   %rax,%rax
  8017fb:	75 3b                	jne    801838 <memmove+0x9a>
  8017fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801801:	83 e0 03             	and    $0x3,%eax
  801804:	48 85 c0             	test   %rax,%rax
  801807:	75 2f                	jne    801838 <memmove+0x9a>
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	83 e0 03             	and    $0x3,%eax
  801810:	48 85 c0             	test   %rax,%rax
  801813:	75 23                	jne    801838 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801815:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801819:	48 83 e8 04          	sub    $0x4,%rax
  80181d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801821:	48 83 ea 04          	sub    $0x4,%rdx
  801825:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801829:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80182d:	48 89 c7             	mov    %rax,%rdi
  801830:	48 89 d6             	mov    %rdx,%rsi
  801833:	fd                   	std    
  801834:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801836:	eb 1d                	jmp    801855 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801844:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	48 89 d7             	mov    %rdx,%rdi
  80184f:	48 89 c1             	mov    %rax,%rcx
  801852:	fd                   	std    
  801853:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801855:	fc                   	cld    
  801856:	eb 57                	jmp    8018af <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801858:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185c:	83 e0 03             	and    $0x3,%eax
  80185f:	48 85 c0             	test   %rax,%rax
  801862:	75 36                	jne    80189a <memmove+0xfc>
  801864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801868:	83 e0 03             	and    $0x3,%eax
  80186b:	48 85 c0             	test   %rax,%rax
  80186e:	75 2a                	jne    80189a <memmove+0xfc>
  801870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801874:	83 e0 03             	and    $0x3,%eax
  801877:	48 85 c0             	test   %rax,%rax
  80187a:	75 1e                	jne    80189a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	48 c1 e8 02          	shr    $0x2,%rax
  801884:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80188f:	48 89 c7             	mov    %rax,%rdi
  801892:	48 89 d6             	mov    %rdx,%rsi
  801895:	fc                   	cld    
  801896:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801898:	eb 15                	jmp    8018af <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80189a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018a6:	48 89 c7             	mov    %rax,%rdi
  8018a9:	48 89 d6             	mov    %rdx,%rsi
  8018ac:	fc                   	cld    
  8018ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018b3:	c9                   	leaveq 
  8018b4:	c3                   	retq   

00000000008018b5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018b5:	55                   	push   %rbp
  8018b6:	48 89 e5             	mov    %rsp,%rbp
  8018b9:	48 83 ec 18          	sub    $0x18,%rsp
  8018bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d5:	48 89 ce             	mov    %rcx,%rsi
  8018d8:	48 89 c7             	mov    %rax,%rdi
  8018db:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  8018e2:	00 00 00 
  8018e5:	ff d0                	callq  *%rax
}
  8018e7:	c9                   	leaveq 
  8018e8:	c3                   	retq   

00000000008018e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	48 83 ec 28          	sub    $0x28,%rsp
  8018f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801901:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80190d:	eb 36                	jmp    801945 <memcmp+0x5c>
		if (*s1 != *s2)
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801913:	0f b6 10             	movzbl (%rax),%edx
  801916:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191a:	0f b6 00             	movzbl (%rax),%eax
  80191d:	38 c2                	cmp    %al,%dl
  80191f:	74 1a                	je     80193b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801921:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	0f b6 d0             	movzbl %al,%edx
  80192b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192f:	0f b6 00             	movzbl (%rax),%eax
  801932:	0f b6 c0             	movzbl %al,%eax
  801935:	29 c2                	sub    %eax,%edx
  801937:	89 d0                	mov    %edx,%eax
  801939:	eb 20                	jmp    80195b <memcmp+0x72>
		s1++, s2++;
  80193b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801940:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80194d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801951:	48 85 c0             	test   %rax,%rax
  801954:	75 b9                	jne    80190f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195b:	c9                   	leaveq 
  80195c:	c3                   	retq   

000000000080195d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80195d:	55                   	push   %rbp
  80195e:	48 89 e5             	mov    %rsp,%rbp
  801961:	48 83 ec 28          	sub    $0x28,%rsp
  801965:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801969:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80196c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801978:	48 01 d0             	add    %rdx,%rax
  80197b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80197f:	eb 15                	jmp    801996 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801985:	0f b6 10             	movzbl (%rax),%edx
  801988:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80198b:	38 c2                	cmp    %al,%dl
  80198d:	75 02                	jne    801991 <memfind+0x34>
			break;
  80198f:	eb 0f                	jmp    8019a0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801991:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80199e:	72 e1                	jb     801981 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8019a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 34          	sub    $0x34,%rsp
  8019ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019b6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019c0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019c7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019c8:	eb 05                	jmp    8019cf <strtol+0x29>
		s++;
  8019ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d3:	0f b6 00             	movzbl (%rax),%eax
  8019d6:	3c 20                	cmp    $0x20,%al
  8019d8:	74 f0                	je     8019ca <strtol+0x24>
  8019da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019de:	0f b6 00             	movzbl (%rax),%eax
  8019e1:	3c 09                	cmp    $0x9,%al
  8019e3:	74 e5                	je     8019ca <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	3c 2b                	cmp    $0x2b,%al
  8019ee:	75 07                	jne    8019f7 <strtol+0x51>
		s++;
  8019f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f5:	eb 17                	jmp    801a0e <strtol+0x68>
	else if (*s == '-')
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	0f b6 00             	movzbl (%rax),%eax
  8019fe:	3c 2d                	cmp    $0x2d,%al
  801a00:	75 0c                	jne    801a0e <strtol+0x68>
		s++, neg = 1;
  801a02:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a07:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a12:	74 06                	je     801a1a <strtol+0x74>
  801a14:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a18:	75 28                	jne    801a42 <strtol+0x9c>
  801a1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1e:	0f b6 00             	movzbl (%rax),%eax
  801a21:	3c 30                	cmp    $0x30,%al
  801a23:	75 1d                	jne    801a42 <strtol+0x9c>
  801a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a29:	48 83 c0 01          	add    $0x1,%rax
  801a2d:	0f b6 00             	movzbl (%rax),%eax
  801a30:	3c 78                	cmp    $0x78,%al
  801a32:	75 0e                	jne    801a42 <strtol+0x9c>
		s += 2, base = 16;
  801a34:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a39:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a40:	eb 2c                	jmp    801a6e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a42:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a46:	75 19                	jne    801a61 <strtol+0xbb>
  801a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4c:	0f b6 00             	movzbl (%rax),%eax
  801a4f:	3c 30                	cmp    $0x30,%al
  801a51:	75 0e                	jne    801a61 <strtol+0xbb>
		s++, base = 8;
  801a53:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a58:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a5f:	eb 0d                	jmp    801a6e <strtol+0xc8>
	else if (base == 0)
  801a61:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a65:	75 07                	jne    801a6e <strtol+0xc8>
		base = 10;
  801a67:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a72:	0f b6 00             	movzbl (%rax),%eax
  801a75:	3c 2f                	cmp    $0x2f,%al
  801a77:	7e 1d                	jle    801a96 <strtol+0xf0>
  801a79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7d:	0f b6 00             	movzbl (%rax),%eax
  801a80:	3c 39                	cmp    $0x39,%al
  801a82:	7f 12                	jg     801a96 <strtol+0xf0>
			dig = *s - '0';
  801a84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a88:	0f b6 00             	movzbl (%rax),%eax
  801a8b:	0f be c0             	movsbl %al,%eax
  801a8e:	83 e8 30             	sub    $0x30,%eax
  801a91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a94:	eb 4e                	jmp    801ae4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9a:	0f b6 00             	movzbl (%rax),%eax
  801a9d:	3c 60                	cmp    $0x60,%al
  801a9f:	7e 1d                	jle    801abe <strtol+0x118>
  801aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa5:	0f b6 00             	movzbl (%rax),%eax
  801aa8:	3c 7a                	cmp    $0x7a,%al
  801aaa:	7f 12                	jg     801abe <strtol+0x118>
			dig = *s - 'a' + 10;
  801aac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab0:	0f b6 00             	movzbl (%rax),%eax
  801ab3:	0f be c0             	movsbl %al,%eax
  801ab6:	83 e8 57             	sub    $0x57,%eax
  801ab9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801abc:	eb 26                	jmp    801ae4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac2:	0f b6 00             	movzbl (%rax),%eax
  801ac5:	3c 40                	cmp    $0x40,%al
  801ac7:	7e 48                	jle    801b11 <strtol+0x16b>
  801ac9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acd:	0f b6 00             	movzbl (%rax),%eax
  801ad0:	3c 5a                	cmp    $0x5a,%al
  801ad2:	7f 3d                	jg     801b11 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801ad4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad8:	0f b6 00             	movzbl (%rax),%eax
  801adb:	0f be c0             	movsbl %al,%eax
  801ade:	83 e8 37             	sub    $0x37,%eax
  801ae1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801ae4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ae7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801aea:	7c 02                	jl     801aee <strtol+0x148>
			break;
  801aec:	eb 23                	jmp    801b11 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801aee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801af3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801af6:	48 98                	cltq   
  801af8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801afd:	48 89 c2             	mov    %rax,%rdx
  801b00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b03:	48 98                	cltq   
  801b05:	48 01 d0             	add    %rdx,%rax
  801b08:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b0c:	e9 5d ff ff ff       	jmpq   801a6e <strtol+0xc8>

	if (endptr)
  801b11:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b16:	74 0b                	je     801b23 <strtol+0x17d>
		*endptr = (char *) s;
  801b18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b1c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b20:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b27:	74 09                	je     801b32 <strtol+0x18c>
  801b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b2d:	48 f7 d8             	neg    %rax
  801b30:	eb 04                	jmp    801b36 <strtol+0x190>
  801b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b36:	c9                   	leaveq 
  801b37:	c3                   	retq   

0000000000801b38 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b38:	55                   	push   %rbp
  801b39:	48 89 e5             	mov    %rsp,%rbp
  801b3c:	48 83 ec 30          	sub    $0x30,%rsp
  801b40:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b44:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b4c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b50:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b54:	0f b6 00             	movzbl (%rax),%eax
  801b57:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b5a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b5e:	75 06                	jne    801b66 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b64:	eb 6b                	jmp    801bd1 <strstr+0x99>

	len = strlen(str);
  801b66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b6a:	48 89 c7             	mov    %rax,%rdi
  801b6d:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  801b74:	00 00 00 
  801b77:	ff d0                	callq  *%rax
  801b79:	48 98                	cltq   
  801b7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b83:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b8b:	0f b6 00             	movzbl (%rax),%eax
  801b8e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b91:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b95:	75 07                	jne    801b9e <strstr+0x66>
				return (char *) 0;
  801b97:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9c:	eb 33                	jmp    801bd1 <strstr+0x99>
		} while (sc != c);
  801b9e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ba2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ba5:	75 d8                	jne    801b7f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ba7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bab:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801baf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb3:	48 89 ce             	mov    %rcx,%rsi
  801bb6:	48 89 c7             	mov    %rax,%rdi
  801bb9:	48 b8 2f 16 80 00 00 	movabs $0x80162f,%rax
  801bc0:	00 00 00 
  801bc3:	ff d0                	callq  *%rax
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	75 b6                	jne    801b7f <strstr+0x47>

	return (char *) (in - 1);
  801bc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcd:	48 83 e8 01          	sub    $0x1,%rax
}
  801bd1:	c9                   	leaveq 
  801bd2:	c3                   	retq   

0000000000801bd3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bd3:	55                   	push   %rbp
  801bd4:	48 89 e5             	mov    %rsp,%rbp
  801bd7:	53                   	push   %rbx
  801bd8:	48 83 ec 48          	sub    $0x48,%rsp
  801bdc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bdf:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801be2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801be6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bea:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bee:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bf2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bf5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801bf9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801bfd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c01:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c05:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c09:	4c 89 c3             	mov    %r8,%rbx
  801c0c:	cd 30                	int    $0x30
  801c0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801c12:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c16:	74 3e                	je     801c56 <syscall+0x83>
  801c18:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c1d:	7e 37                	jle    801c56 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c26:	49 89 d0             	mov    %rdx,%r8
  801c29:	89 c1                	mov    %eax,%ecx
  801c2b:	48 ba 3b 41 80 00 00 	movabs $0x80413b,%rdx
  801c32:	00 00 00 
  801c35:	be 23 00 00 00       	mov    $0x23,%esi
  801c3a:	48 bf 58 41 80 00 00 	movabs $0x804158,%rdi
  801c41:	00 00 00 
  801c44:	b8 00 00 00 00       	mov    $0x0,%eax
  801c49:	49 b9 1f 05 80 00 00 	movabs $0x80051f,%r9
  801c50:	00 00 00 
  801c53:	41 ff d1             	callq  *%r9

	return ret;
  801c56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c5a:	48 83 c4 48          	add    $0x48,%rsp
  801c5e:	5b                   	pop    %rbx
  801c5f:	5d                   	pop    %rbp
  801c60:	c3                   	retq   

0000000000801c61 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
  801c65:	48 83 ec 20          	sub    $0x20,%rsp
  801c69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c80:	00 
  801c81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8d:	48 89 d1             	mov    %rdx,%rcx
  801c90:	48 89 c2             	mov    %rax,%rdx
  801c93:	be 00 00 00 00       	mov    $0x0,%esi
  801c98:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9d:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	callq  *%rax
}
  801ca9:	c9                   	leaveq 
  801caa:	c3                   	retq   

0000000000801cab <sys_cgetc>:

int
sys_cgetc(void)
{
  801cab:	55                   	push   %rbp
  801cac:	48 89 e5             	mov    %rsp,%rbp
  801caf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801cb3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cba:	00 
  801cbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd1:	be 00 00 00 00       	mov    $0x0,%esi
  801cd6:	bf 01 00 00 00       	mov    $0x1,%edi
  801cdb:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801ce2:	00 00 00 
  801ce5:	ff d0                	callq  *%rax
}
  801ce7:	c9                   	leaveq 
  801ce8:	c3                   	retq   

0000000000801ce9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ce9:	55                   	push   %rbp
  801cea:	48 89 e5             	mov    %rsp,%rbp
  801ced:	48 83 ec 10          	sub    $0x10,%rsp
  801cf1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf7:	48 98                	cltq   
  801cf9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d00:	00 
  801d01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d12:	48 89 c2             	mov    %rax,%rdx
  801d15:	be 01 00 00 00       	mov    $0x1,%esi
  801d1a:	bf 03 00 00 00       	mov    $0x3,%edi
  801d1f:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax
}
  801d2b:	c9                   	leaveq 
  801d2c:	c3                   	retq   

0000000000801d2d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d2d:	55                   	push   %rbp
  801d2e:	48 89 e5             	mov    %rsp,%rbp
  801d31:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3c:	00 
  801d3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d53:	be 00 00 00 00       	mov    $0x0,%esi
  801d58:	bf 02 00 00 00       	mov    $0x2,%edi
  801d5d:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <sys_yield>:

void
sys_yield(void)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7a:	00 
  801d7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d91:	be 00 00 00 00       	mov    $0x0,%esi
  801d96:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d9b:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax
}
  801da7:	c9                   	leaveq 
  801da8:	c3                   	retq   

0000000000801da9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801da9:	55                   	push   %rbp
  801daa:	48 89 e5             	mov    %rsp,%rbp
  801dad:	48 83 ec 20          	sub    $0x20,%rsp
  801db1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801dbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dbe:	48 63 c8             	movslq %eax,%rcx
  801dc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc8:	48 98                	cltq   
  801dca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd1:	00 
  801dd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd8:	49 89 c8             	mov    %rcx,%r8
  801ddb:	48 89 d1             	mov    %rdx,%rcx
  801dde:	48 89 c2             	mov    %rax,%rdx
  801de1:	be 01 00 00 00       	mov    $0x1,%esi
  801de6:	bf 04 00 00 00       	mov    $0x4,%edi
  801deb:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
}
  801df7:	c9                   	leaveq 
  801df8:	c3                   	retq   

0000000000801df9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801df9:	55                   	push   %rbp
  801dfa:	48 89 e5             	mov    %rsp,%rbp
  801dfd:	48 83 ec 30          	sub    $0x30,%rsp
  801e01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e08:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e0b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e0f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e13:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e16:	48 63 c8             	movslq %eax,%rcx
  801e19:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e20:	48 63 f0             	movslq %eax,%rsi
  801e23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2a:	48 98                	cltq   
  801e2c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e30:	49 89 f9             	mov    %rdi,%r9
  801e33:	49 89 f0             	mov    %rsi,%r8
  801e36:	48 89 d1             	mov    %rdx,%rcx
  801e39:	48 89 c2             	mov    %rax,%rdx
  801e3c:	be 01 00 00 00       	mov    $0x1,%esi
  801e41:	bf 05 00 00 00       	mov    $0x5,%edi
  801e46:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801e4d:	00 00 00 
  801e50:	ff d0                	callq  *%rax
}
  801e52:	c9                   	leaveq 
  801e53:	c3                   	retq   

0000000000801e54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e54:	55                   	push   %rbp
  801e55:	48 89 e5             	mov    %rsp,%rbp
  801e58:	48 83 ec 20          	sub    $0x20,%rsp
  801e5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6a:	48 98                	cltq   
  801e6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e73:	00 
  801e74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e80:	48 89 d1             	mov    %rdx,%rcx
  801e83:	48 89 c2             	mov    %rax,%rdx
  801e86:	be 01 00 00 00       	mov    $0x1,%esi
  801e8b:	bf 06 00 00 00       	mov    $0x6,%edi
  801e90:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
}
  801e9c:	c9                   	leaveq 
  801e9d:	c3                   	retq   

0000000000801e9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e9e:	55                   	push   %rbp
  801e9f:	48 89 e5             	mov    %rsp,%rbp
  801ea2:	48 83 ec 10          	sub    $0x10,%rsp
  801ea6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ea9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801eac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eaf:	48 63 d0             	movslq %eax,%rdx
  801eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb5:	48 98                	cltq   
  801eb7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ebe:	00 
  801ebf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ecb:	48 89 d1             	mov    %rdx,%rcx
  801ece:	48 89 c2             	mov    %rax,%rdx
  801ed1:	be 01 00 00 00       	mov    $0x1,%esi
  801ed6:	bf 08 00 00 00       	mov    $0x8,%edi
  801edb:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
}
  801ee7:	c9                   	leaveq 
  801ee8:	c3                   	retq   

0000000000801ee9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ee9:	55                   	push   %rbp
  801eea:	48 89 e5             	mov    %rsp,%rbp
  801eed:	48 83 ec 20          	sub    $0x20,%rsp
  801ef1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ef8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eff:	48 98                	cltq   
  801f01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f08:	00 
  801f09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f15:	48 89 d1             	mov    %rdx,%rcx
  801f18:	48 89 c2             	mov    %rax,%rdx
  801f1b:	be 01 00 00 00       	mov    $0x1,%esi
  801f20:	bf 09 00 00 00       	mov    $0x9,%edi
  801f25:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801f2c:	00 00 00 
  801f2f:	ff d0                	callq  *%rax
}
  801f31:	c9                   	leaveq 
  801f32:	c3                   	retq   

0000000000801f33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	48 83 ec 20          	sub    $0x20,%rsp
  801f3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f49:	48 98                	cltq   
  801f4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f52:	00 
  801f53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5f:	48 89 d1             	mov    %rdx,%rcx
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	be 01 00 00 00       	mov    $0x1,%esi
  801f6a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f6f:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801f76:	00 00 00 
  801f79:	ff d0                	callq  *%rax
}
  801f7b:	c9                   	leaveq 
  801f7c:	c3                   	retq   

0000000000801f7d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f7d:	55                   	push   %rbp
  801f7e:	48 89 e5             	mov    %rsp,%rbp
  801f81:	48 83 ec 20          	sub    $0x20,%rsp
  801f85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f8c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f90:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f96:	48 63 f0             	movslq %eax,%rsi
  801f99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa0:	48 98                	cltq   
  801fa2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fad:	00 
  801fae:	49 89 f1             	mov    %rsi,%r9
  801fb1:	49 89 c8             	mov    %rcx,%r8
  801fb4:	48 89 d1             	mov    %rdx,%rcx
  801fb7:	48 89 c2             	mov    %rax,%rdx
  801fba:	be 00 00 00 00       	mov    $0x0,%esi
  801fbf:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fc4:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  801fcb:	00 00 00 
  801fce:	ff d0                	callq  *%rax
}
  801fd0:	c9                   	leaveq 
  801fd1:	c3                   	retq   

0000000000801fd2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fd2:	55                   	push   %rbp
  801fd3:	48 89 e5             	mov    %rsp,%rbp
  801fd6:	48 83 ec 10          	sub    $0x10,%rsp
  801fda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe9:	00 
  801fea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ff0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ffb:	48 89 c2             	mov    %rax,%rdx
  801ffe:	be 01 00 00 00       	mov    $0x1,%esi
  802003:	bf 0d 00 00 00       	mov    $0xd,%edi
  802008:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax
}
  802014:	c9                   	leaveq 
  802015:	c3                   	retq   

0000000000802016 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802016:	55                   	push   %rbp
  802017:	48 89 e5             	mov    %rsp,%rbp
  80201a:	48 83 ec 08          	sub    $0x8,%rsp
  80201e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802022:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802026:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80202d:	ff ff ff 
  802030:	48 01 d0             	add    %rdx,%rax
  802033:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 08          	sub    $0x8,%rsp
  802041:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802045:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802049:	48 89 c7             	mov    %rax,%rdi
  80204c:	48 b8 16 20 80 00 00 	movabs $0x802016,%rax
  802053:	00 00 00 
  802056:	ff d0                	callq  *%rax
  802058:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80205e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802062:	c9                   	leaveq 
  802063:	c3                   	retq   

0000000000802064 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802064:	55                   	push   %rbp
  802065:	48 89 e5             	mov    %rsp,%rbp
  802068:	48 83 ec 18          	sub    $0x18,%rsp
  80206c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802077:	eb 6b                	jmp    8020e4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802079:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207c:	48 98                	cltq   
  80207e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802084:	48 c1 e0 0c          	shl    $0xc,%rax
  802088:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80208c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802090:	48 c1 e8 15          	shr    $0x15,%rax
  802094:	48 89 c2             	mov    %rax,%rdx
  802097:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80209e:	01 00 00 
  8020a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a5:	83 e0 01             	and    $0x1,%eax
  8020a8:	48 85 c0             	test   %rax,%rax
  8020ab:	74 21                	je     8020ce <fd_alloc+0x6a>
  8020ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8020b5:	48 89 c2             	mov    %rax,%rdx
  8020b8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020bf:	01 00 00 
  8020c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c6:	83 e0 01             	and    $0x1,%eax
  8020c9:	48 85 c0             	test   %rax,%rax
  8020cc:	75 12                	jne    8020e0 <fd_alloc+0x7c>
			*fd_store = fd;
  8020ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	eb 1a                	jmp    8020fa <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020e4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020e8:	7e 8f                	jle    802079 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ee:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020f5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020fa:	c9                   	leaveq 
  8020fb:	c3                   	retq   

00000000008020fc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020fc:	55                   	push   %rbp
  8020fd:	48 89 e5             	mov    %rsp,%rbp
  802100:	48 83 ec 20          	sub    $0x20,%rsp
  802104:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802107:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80210b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80210f:	78 06                	js     802117 <fd_lookup+0x1b>
  802111:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802115:	7e 07                	jle    80211e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80211c:	eb 6c                	jmp    80218a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80211e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802121:	48 98                	cltq   
  802123:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802129:	48 c1 e0 0c          	shl    $0xc,%rax
  80212d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802135:	48 c1 e8 15          	shr    $0x15,%rax
  802139:	48 89 c2             	mov    %rax,%rdx
  80213c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802143:	01 00 00 
  802146:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214a:	83 e0 01             	and    $0x1,%eax
  80214d:	48 85 c0             	test   %rax,%rax
  802150:	74 21                	je     802173 <fd_lookup+0x77>
  802152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802156:	48 c1 e8 0c          	shr    $0xc,%rax
  80215a:	48 89 c2             	mov    %rax,%rdx
  80215d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802164:	01 00 00 
  802167:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80216b:	83 e0 01             	and    $0x1,%eax
  80216e:	48 85 c0             	test   %rax,%rax
  802171:	75 07                	jne    80217a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802178:	eb 10                	jmp    80218a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80217a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802182:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218a:	c9                   	leaveq 
  80218b:	c3                   	retq   

000000000080218c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80218c:	55                   	push   %rbp
  80218d:	48 89 e5             	mov    %rsp,%rbp
  802190:	48 83 ec 30          	sub    $0x30,%rsp
  802194:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802198:	89 f0                	mov    %esi,%eax
  80219a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80219d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a1:	48 89 c7             	mov    %rax,%rdi
  8021a4:	48 b8 16 20 80 00 00 	movabs $0x802016,%rax
  8021ab:	00 00 00 
  8021ae:	ff d0                	callq  *%rax
  8021b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021b4:	48 89 d6             	mov    %rdx,%rsi
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cc:	78 0a                	js     8021d8 <fd_close+0x4c>
	    || fd != fd2)
  8021ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021d6:	74 12                	je     8021ea <fd_close+0x5e>
		return (must_exist ? r : 0);
  8021d8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021dc:	74 05                	je     8021e3 <fd_close+0x57>
  8021de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e1:	eb 05                	jmp    8021e8 <fd_close+0x5c>
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	eb 69                	jmp    802253 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ee:	8b 00                	mov    (%rax),%eax
  8021f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021f4:	48 89 d6             	mov    %rdx,%rsi
  8021f7:	89 c7                	mov    %eax,%edi
  8021f9:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  802200:	00 00 00 
  802203:	ff d0                	callq  *%rax
  802205:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802208:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220c:	78 2a                	js     802238 <fd_close+0xac>
		if (dev->dev_close)
  80220e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802212:	48 8b 40 20          	mov    0x20(%rax),%rax
  802216:	48 85 c0             	test   %rax,%rax
  802219:	74 16                	je     802231 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80221b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802223:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802227:	48 89 d7             	mov    %rdx,%rdi
  80222a:	ff d0                	callq  *%rax
  80222c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222f:	eb 07                	jmp    802238 <fd_close+0xac>
		else
			r = 0;
  802231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802238:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80223c:	48 89 c6             	mov    %rax,%rsi
  80223f:	bf 00 00 00 00       	mov    $0x0,%edi
  802244:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	callq  *%rax
	return r;
  802250:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802253:	c9                   	leaveq 
  802254:	c3                   	retq   

0000000000802255 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802255:	55                   	push   %rbp
  802256:	48 89 e5             	mov    %rsp,%rbp
  802259:	48 83 ec 20          	sub    $0x20,%rsp
  80225d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802260:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80226b:	eb 41                	jmp    8022ae <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80226d:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  802274:	00 00 00 
  802277:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80227a:	48 63 d2             	movslq %edx,%rdx
  80227d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802281:	8b 00                	mov    (%rax),%eax
  802283:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802286:	75 22                	jne    8022aa <dev_lookup+0x55>
			*dev = devtab[i];
  802288:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  80228f:	00 00 00 
  802292:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802295:	48 63 d2             	movslq %edx,%rdx
  802298:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80229c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	eb 60                	jmp    80230a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8022aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022ae:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  8022b5:	00 00 00 
  8022b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022bb:	48 63 d2             	movslq %edx,%rdx
  8022be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c2:	48 85 c0             	test   %rax,%rax
  8022c5:	75 a6                	jne    80226d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022c7:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8022ce:	00 00 00 
  8022d1:	48 8b 00             	mov    (%rax),%rax
  8022d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022dd:	89 c6                	mov    %eax,%esi
  8022df:	48 bf 68 41 80 00 00 	movabs $0x804168,%rdi
  8022e6:	00 00 00 
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ee:	48 b9 58 07 80 00 00 	movabs $0x800758,%rcx
  8022f5:	00 00 00 
  8022f8:	ff d1                	callq  *%rcx
	*dev = 0;
  8022fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022fe:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80230a:	c9                   	leaveq 
  80230b:	c3                   	retq   

000000000080230c <close>:

int
close(int fdnum)
{
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 83 ec 20          	sub    $0x20,%rsp
  802314:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802317:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231e:	48 89 d6             	mov    %rdx,%rsi
  802321:	89 c7                	mov    %eax,%edi
  802323:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80232a:	00 00 00 
  80232d:	ff d0                	callq  *%rax
  80232f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802332:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802336:	79 05                	jns    80233d <close+0x31>
		return r;
  802338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233b:	eb 18                	jmp    802355 <close+0x49>
	else
		return fd_close(fd, 1);
  80233d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802341:	be 01 00 00 00       	mov    $0x1,%esi
  802346:	48 89 c7             	mov    %rax,%rdi
  802349:	48 b8 8c 21 80 00 00 	movabs $0x80218c,%rax
  802350:	00 00 00 
  802353:	ff d0                	callq  *%rax
}
  802355:	c9                   	leaveq 
  802356:	c3                   	retq   

0000000000802357 <close_all>:

void
close_all(void)
{
  802357:	55                   	push   %rbp
  802358:	48 89 e5             	mov    %rsp,%rbp
  80235b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80235f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802366:	eb 15                	jmp    80237d <close_all+0x26>
		close(i);
  802368:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236b:	89 c7                	mov    %eax,%edi
  80236d:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802374:	00 00 00 
  802377:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802379:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80237d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802381:	7e e5                	jle    802368 <close_all+0x11>
		close(i);
}
  802383:	c9                   	leaveq 
  802384:	c3                   	retq   

0000000000802385 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802385:	55                   	push   %rbp
  802386:	48 89 e5             	mov    %rsp,%rbp
  802389:	48 83 ec 40          	sub    $0x40,%rsp
  80238d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802390:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802393:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802397:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80239a:	48 89 d6             	mov    %rdx,%rsi
  80239d:	89 c7                	mov    %eax,%edi
  80239f:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
  8023ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b2:	79 08                	jns    8023bc <dup+0x37>
		return r;
  8023b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b7:	e9 70 01 00 00       	jmpq   80252c <dup+0x1a7>
	close(newfdnum);
  8023bc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8023cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023d0:	48 98                	cltq   
  8023d2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023d8:	48 c1 e0 0c          	shl    $0xc,%rax
  8023dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e4:	48 89 c7             	mov    %rax,%rdi
  8023e7:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  8023ee:	00 00 00 
  8023f1:	ff d0                	callq  *%rax
  8023f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fb:	48 89 c7             	mov    %rax,%rdi
  8023fe:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  802405:	00 00 00 
  802408:	ff d0                	callq  *%rax
  80240a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80240e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802412:	48 c1 e8 15          	shr    $0x15,%rax
  802416:	48 89 c2             	mov    %rax,%rdx
  802419:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802420:	01 00 00 
  802423:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802427:	83 e0 01             	and    $0x1,%eax
  80242a:	48 85 c0             	test   %rax,%rax
  80242d:	74 73                	je     8024a2 <dup+0x11d>
  80242f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802433:	48 c1 e8 0c          	shr    $0xc,%rax
  802437:	48 89 c2             	mov    %rax,%rdx
  80243a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802441:	01 00 00 
  802444:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802448:	83 e0 01             	and    $0x1,%eax
  80244b:	48 85 c0             	test   %rax,%rax
  80244e:	74 52                	je     8024a2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802454:	48 c1 e8 0c          	shr    $0xc,%rax
  802458:	48 89 c2             	mov    %rax,%rdx
  80245b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802462:	01 00 00 
  802465:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802469:	25 07 0e 00 00       	and    $0xe07,%eax
  80246e:	89 c1                	mov    %eax,%ecx
  802470:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802478:	41 89 c8             	mov    %ecx,%r8d
  80247b:	48 89 d1             	mov    %rdx,%rcx
  80247e:	ba 00 00 00 00       	mov    $0x0,%edx
  802483:	48 89 c6             	mov    %rax,%rsi
  802486:	bf 00 00 00 00       	mov    $0x0,%edi
  80248b:	48 b8 f9 1d 80 00 00 	movabs $0x801df9,%rax
  802492:	00 00 00 
  802495:	ff d0                	callq  *%rax
  802497:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249e:	79 02                	jns    8024a2 <dup+0x11d>
			goto err;
  8024a0:	eb 57                	jmp    8024f9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8024a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8024aa:	48 89 c2             	mov    %rax,%rdx
  8024ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024b4:	01 00 00 
  8024b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8024c0:	89 c1                	mov    %eax,%ecx
  8024c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024ca:	41 89 c8             	mov    %ecx,%r8d
  8024cd:	48 89 d1             	mov    %rdx,%rcx
  8024d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d5:	48 89 c6             	mov    %rax,%rsi
  8024d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024dd:	48 b8 f9 1d 80 00 00 	movabs $0x801df9,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	callq  *%rax
  8024e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f0:	79 02                	jns    8024f4 <dup+0x16f>
		goto err;
  8024f2:	eb 05                	jmp    8024f9 <dup+0x174>

	return newfdnum;
  8024f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024f7:	eb 33                	jmp    80252c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fd:	48 89 c6             	mov    %rax,%rsi
  802500:	bf 00 00 00 00       	mov    $0x0,%edi
  802505:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802511:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802515:	48 89 c6             	mov    %rax,%rsi
  802518:	bf 00 00 00 00       	mov    $0x0,%edi
  80251d:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
	return r;
  802529:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 40          	sub    $0x40,%rsp
  802536:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802539:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80253d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802541:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802545:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802548:	48 89 d6             	mov    %rdx,%rsi
  80254b:	89 c7                	mov    %eax,%edi
  80254d:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	78 24                	js     802586 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802562:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802566:	8b 00                	mov    (%rax),%eax
  802568:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256c:	48 89 d6             	mov    %rdx,%rsi
  80256f:	89 c7                	mov    %eax,%edi
  802571:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	79 05                	jns    80258b <read+0x5d>
		return r;
  802586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802589:	eb 76                	jmp    802601 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80258b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258f:	8b 40 08             	mov    0x8(%rax),%eax
  802592:	83 e0 03             	and    $0x3,%eax
  802595:	83 f8 01             	cmp    $0x1,%eax
  802598:	75 3a                	jne    8025d4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80259a:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8025a1:	00 00 00 
  8025a4:	48 8b 00             	mov    (%rax),%rax
  8025a7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025ad:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025b0:	89 c6                	mov    %eax,%esi
  8025b2:	48 bf 87 41 80 00 00 	movabs $0x804187,%rdi
  8025b9:	00 00 00 
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c1:	48 b9 58 07 80 00 00 	movabs $0x800758,%rcx
  8025c8:	00 00 00 
  8025cb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025d2:	eb 2d                	jmp    802601 <read+0xd3>
	}
	if (!dev->dev_read)
  8025d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025dc:	48 85 c0             	test   %rax,%rax
  8025df:	75 07                	jne    8025e8 <read+0xba>
		return -E_NOT_SUPP;
  8025e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025e6:	eb 19                	jmp    802601 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025f8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025fc:	48 89 cf             	mov    %rcx,%rdi
  8025ff:	ff d0                	callq  *%rax
}
  802601:	c9                   	leaveq 
  802602:	c3                   	retq   

0000000000802603 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802603:	55                   	push   %rbp
  802604:	48 89 e5             	mov    %rsp,%rbp
  802607:	48 83 ec 30          	sub    $0x30,%rsp
  80260b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802612:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802616:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80261d:	eb 49                	jmp    802668 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80261f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802622:	48 98                	cltq   
  802624:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802628:	48 29 c2             	sub    %rax,%rdx
  80262b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262e:	48 63 c8             	movslq %eax,%rcx
  802631:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802635:	48 01 c1             	add    %rax,%rcx
  802638:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80263b:	48 89 ce             	mov    %rcx,%rsi
  80263e:	89 c7                	mov    %eax,%edi
  802640:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802647:	00 00 00 
  80264a:	ff d0                	callq  *%rax
  80264c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80264f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802653:	79 05                	jns    80265a <readn+0x57>
			return m;
  802655:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802658:	eb 1c                	jmp    802676 <readn+0x73>
		if (m == 0)
  80265a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80265e:	75 02                	jne    802662 <readn+0x5f>
			break;
  802660:	eb 11                	jmp    802673 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802662:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802665:	01 45 fc             	add    %eax,-0x4(%rbp)
  802668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266b:	48 98                	cltq   
  80266d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802671:	72 ac                	jb     80261f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802673:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802676:	c9                   	leaveq 
  802677:	c3                   	retq   

0000000000802678 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802678:	55                   	push   %rbp
  802679:	48 89 e5             	mov    %rsp,%rbp
  80267c:	48 83 ec 40          	sub    $0x40,%rsp
  802680:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802683:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802687:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80268b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80268f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802692:	48 89 d6             	mov    %rdx,%rsi
  802695:	89 c7                	mov    %eax,%edi
  802697:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
  8026a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026aa:	78 24                	js     8026d0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b0:	8b 00                	mov    (%rax),%eax
  8026b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026b6:	48 89 d6             	mov    %rdx,%rsi
  8026b9:	89 c7                	mov    %eax,%edi
  8026bb:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax
  8026c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ce:	79 05                	jns    8026d5 <write+0x5d>
		return r;
  8026d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d3:	eb 75                	jmp    80274a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d9:	8b 40 08             	mov    0x8(%rax),%eax
  8026dc:	83 e0 03             	and    $0x3,%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	75 3a                	jne    80271d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026e3:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8026ea:	00 00 00 
  8026ed:	48 8b 00             	mov    (%rax),%rax
  8026f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026f9:	89 c6                	mov    %eax,%esi
  8026fb:	48 bf a3 41 80 00 00 	movabs $0x8041a3,%rdi
  802702:	00 00 00 
  802705:	b8 00 00 00 00       	mov    $0x0,%eax
  80270a:	48 b9 58 07 80 00 00 	movabs $0x800758,%rcx
  802711:	00 00 00 
  802714:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802716:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80271b:	eb 2d                	jmp    80274a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80271d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802721:	48 8b 40 18          	mov    0x18(%rax),%rax
  802725:	48 85 c0             	test   %rax,%rax
  802728:	75 07                	jne    802731 <write+0xb9>
		return -E_NOT_SUPP;
  80272a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272f:	eb 19                	jmp    80274a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802735:	48 8b 40 18          	mov    0x18(%rax),%rax
  802739:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80273d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802741:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802745:	48 89 cf             	mov    %rcx,%rdi
  802748:	ff d0                	callq  *%rax
}
  80274a:	c9                   	leaveq 
  80274b:	c3                   	retq   

000000000080274c <seek>:

int
seek(int fdnum, off_t offset)
{
  80274c:	55                   	push   %rbp
  80274d:	48 89 e5             	mov    %rsp,%rbp
  802750:	48 83 ec 18          	sub    $0x18,%rsp
  802754:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802757:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80275a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80275e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802761:	48 89 d6             	mov    %rdx,%rsi
  802764:	89 c7                	mov    %eax,%edi
  802766:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
  802772:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802775:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802779:	79 05                	jns    802780 <seek+0x34>
		return r;
  80277b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277e:	eb 0f                	jmp    80278f <seek+0x43>
	fd->fd_offset = offset;
  802780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802784:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802787:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80278a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278f:	c9                   	leaveq 
  802790:	c3                   	retq   

0000000000802791 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802791:	55                   	push   %rbp
  802792:	48 89 e5             	mov    %rsp,%rbp
  802795:	48 83 ec 30          	sub    $0x30,%rsp
  802799:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80279c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80279f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027a6:	48 89 d6             	mov    %rdx,%rsi
  8027a9:	89 c7                	mov    %eax,%edi
  8027ab:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027be:	78 24                	js     8027e4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c4:	8b 00                	mov    (%rax),%eax
  8027c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ca:	48 89 d6             	mov    %rdx,%rsi
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
  8027db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e2:	79 05                	jns    8027e9 <ftruncate+0x58>
		return r;
  8027e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e7:	eb 72                	jmp    80285b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ed:	8b 40 08             	mov    0x8(%rax),%eax
  8027f0:	83 e0 03             	and    $0x3,%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 3a                	jne    802831 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027f7:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8027fe:	00 00 00 
  802801:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802804:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80280a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80280d:	89 c6                	mov    %eax,%esi
  80280f:	48 bf c0 41 80 00 00 	movabs $0x8041c0,%rdi
  802816:	00 00 00 
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
  80281e:	48 b9 58 07 80 00 00 	movabs $0x800758,%rcx
  802825:	00 00 00 
  802828:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80282a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80282f:	eb 2a                	jmp    80285b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802835:	48 8b 40 30          	mov    0x30(%rax),%rax
  802839:	48 85 c0             	test   %rax,%rax
  80283c:	75 07                	jne    802845 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80283e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802843:	eb 16                	jmp    80285b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802849:	48 8b 40 30          	mov    0x30(%rax),%rax
  80284d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802851:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802854:	89 ce                	mov    %ecx,%esi
  802856:	48 89 d7             	mov    %rdx,%rdi
  802859:	ff d0                	callq  *%rax
}
  80285b:	c9                   	leaveq 
  80285c:	c3                   	retq   

000000000080285d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80285d:	55                   	push   %rbp
  80285e:	48 89 e5             	mov    %rsp,%rbp
  802861:	48 83 ec 30          	sub    $0x30,%rsp
  802865:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802868:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80286c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802870:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802873:	48 89 d6             	mov    %rdx,%rsi
  802876:	89 c7                	mov    %eax,%edi
  802878:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80287f:	00 00 00 
  802882:	ff d0                	callq  *%rax
  802884:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802887:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288b:	78 24                	js     8028b1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80288d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802891:	8b 00                	mov    (%rax),%eax
  802893:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802897:	48 89 d6             	mov    %rdx,%rsi
  80289a:	89 c7                	mov    %eax,%edi
  80289c:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  8028a3:	00 00 00 
  8028a6:	ff d0                	callq  *%rax
  8028a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028af:	79 05                	jns    8028b6 <fstat+0x59>
		return r;
  8028b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b4:	eb 5e                	jmp    802914 <fstat+0xb7>
	if (!dev->dev_stat)
  8028b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ba:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028be:	48 85 c0             	test   %rax,%rax
  8028c1:	75 07                	jne    8028ca <fstat+0x6d>
		return -E_NOT_SUPP;
  8028c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028c8:	eb 4a                	jmp    802914 <fstat+0xb7>
	stat->st_name[0] = 0;
  8028ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ce:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8028d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028d5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028dc:	00 00 00 
	stat->st_isdir = 0;
  8028df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028e3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028ea:	00 00 00 
	stat->st_dev = dev;
  8028ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028f5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802900:	48 8b 40 28          	mov    0x28(%rax),%rax
  802904:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802908:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80290c:	48 89 ce             	mov    %rcx,%rsi
  80290f:	48 89 d7             	mov    %rdx,%rdi
  802912:	ff d0                	callq  *%rax
}
  802914:	c9                   	leaveq 
  802915:	c3                   	retq   

0000000000802916 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802916:	55                   	push   %rbp
  802917:	48 89 e5             	mov    %rsp,%rbp
  80291a:	48 83 ec 20          	sub    $0x20,%rsp
  80291e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802922:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292a:	be 00 00 00 00       	mov    $0x0,%esi
  80292f:	48 89 c7             	mov    %rax,%rdi
  802932:	48 b8 04 2a 80 00 00 	movabs $0x802a04,%rax
  802939:	00 00 00 
  80293c:	ff d0                	callq  *%rax
  80293e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802941:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802945:	79 05                	jns    80294c <stat+0x36>
		return fd;
  802947:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294a:	eb 2f                	jmp    80297b <stat+0x65>
	r = fstat(fd, stat);
  80294c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802953:	48 89 d6             	mov    %rdx,%rsi
  802956:	89 c7                	mov    %eax,%edi
  802958:	48 b8 5d 28 80 00 00 	movabs $0x80285d,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
  802964:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296a:	89 c7                	mov    %eax,%edi
  80296c:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802973:	00 00 00 
  802976:	ff d0                	callq  *%rax
	return r;
  802978:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80297b:	c9                   	leaveq 
  80297c:	c3                   	retq   

000000000080297d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80297d:	55                   	push   %rbp
  80297e:	48 89 e5             	mov    %rsp,%rbp
  802981:	48 83 ec 10          	sub    $0x10,%rsp
  802985:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802988:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80298c:	48 b8 00 64 80 00 00 	movabs $0x806400,%rax
  802993:	00 00 00 
  802996:	8b 00                	mov    (%rax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	75 1d                	jne    8029b9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80299c:	bf 01 00 00 00       	mov    $0x1,%edi
  8029a1:	48 b8 85 3a 80 00 00 	movabs $0x803a85,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	48 ba 00 64 80 00 00 	movabs $0x806400,%rdx
  8029b4:	00 00 00 
  8029b7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8029b9:	48 b8 00 64 80 00 00 	movabs $0x806400,%rax
  8029c0:	00 00 00 
  8029c3:	8b 00                	mov    (%rax),%eax
  8029c5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8029c8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8029cd:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8029d4:	00 00 00 
  8029d7:	89 c7                	mov    %eax,%edi
  8029d9:	48 b8 ed 39 80 00 00 	movabs $0x8039ed,%rax
  8029e0:	00 00 00 
  8029e3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ee:	48 89 c6             	mov    %rax,%rsi
  8029f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f6:	48 b8 2c 39 80 00 00 	movabs $0x80392c,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
}
  802a02:	c9                   	leaveq 
  802a03:	c3                   	retq   

0000000000802a04 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
  802a08:	48 83 ec 20          	sub    $0x20,%rsp
  802a0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a10:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	48 89 c7             	mov    %rax,%rdi
  802a1a:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a2b:	7e 0a                	jle    802a37 <open+0x33>
		return -E_BAD_PATH;
  802a2d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a32:	e9 a5 00 00 00       	jmpq   802adc <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802a37:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a3b:	48 89 c7             	mov    %rax,%rdi
  802a3e:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  802a45:	00 00 00 
  802a48:	ff d0                	callq  *%rax
  802a4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a51:	79 08                	jns    802a5b <open+0x57>
		return r;
  802a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a56:	e9 81 00 00 00       	jmpq   802adc <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802a5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5f:	48 89 c6             	mov    %rax,%rsi
  802a62:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a69:	00 00 00 
  802a6c:	48 b8 7a 14 80 00 00 	movabs $0x80147a,%rax
  802a73:	00 00 00 
  802a76:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802a78:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a7f:	00 00 00 
  802a82:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a85:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8f:	48 89 c6             	mov    %rax,%rsi
  802a92:	bf 01 00 00 00       	mov    $0x1,%edi
  802a97:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	callq  *%rax
  802aa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aaa:	79 1d                	jns    802ac9 <open+0xc5>
		fd_close(fd, 0);
  802aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab0:	be 00 00 00 00       	mov    $0x0,%esi
  802ab5:	48 89 c7             	mov    %rax,%rdi
  802ab8:	48 b8 8c 21 80 00 00 	movabs $0x80218c,%rax
  802abf:	00 00 00 
  802ac2:	ff d0                	callq  *%rax
		return r;
  802ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac7:	eb 13                	jmp    802adc <open+0xd8>
	}

	return fd2num(fd);
  802ac9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802acd:	48 89 c7             	mov    %rax,%rdi
  802ad0:	48 b8 16 20 80 00 00 	movabs $0x802016,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  802adc:	c9                   	leaveq 
  802add:	c3                   	retq   

0000000000802ade <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ade:	55                   	push   %rbp
  802adf:	48 89 e5             	mov    %rsp,%rbp
  802ae2:	48 83 ec 10          	sub    $0x10,%rsp
  802ae6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802aea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aee:	8b 50 0c             	mov    0xc(%rax),%edx
  802af1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802af8:	00 00 00 
  802afb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802afd:	be 00 00 00 00       	mov    $0x0,%esi
  802b02:	bf 06 00 00 00       	mov    $0x6,%edi
  802b07:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802b0e:	00 00 00 
  802b11:	ff d0                	callq  *%rax
}
  802b13:	c9                   	leaveq 
  802b14:	c3                   	retq   

0000000000802b15 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b15:	55                   	push   %rbp
  802b16:	48 89 e5             	mov    %rsp,%rbp
  802b19:	48 83 ec 30          	sub    $0x30,%rsp
  802b1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2d:	8b 50 0c             	mov    0xc(%rax),%edx
  802b30:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b37:	00 00 00 
  802b3a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802b3c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b43:	00 00 00 
  802b46:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b4a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802b4e:	be 00 00 00 00       	mov    $0x0,%esi
  802b53:	bf 03 00 00 00       	mov    $0x3,%edi
  802b58:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6b:	79 08                	jns    802b75 <devfile_read+0x60>
		return r;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	e9 a4 00 00 00       	jmpq   802c19 <devfile_read+0x104>
	assert(r <= n);
  802b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b78:	48 98                	cltq   
  802b7a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b7e:	76 35                	jbe    802bb5 <devfile_read+0xa0>
  802b80:	48 b9 ed 41 80 00 00 	movabs $0x8041ed,%rcx
  802b87:	00 00 00 
  802b8a:	48 ba f4 41 80 00 00 	movabs $0x8041f4,%rdx
  802b91:	00 00 00 
  802b94:	be 84 00 00 00       	mov    $0x84,%esi
  802b99:	48 bf 09 42 80 00 00 	movabs $0x804209,%rdi
  802ba0:	00 00 00 
  802ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba8:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  802baf:	00 00 00 
  802bb2:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802bb5:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802bbc:	7e 35                	jle    802bf3 <devfile_read+0xde>
  802bbe:	48 b9 14 42 80 00 00 	movabs $0x804214,%rcx
  802bc5:	00 00 00 
  802bc8:	48 ba f4 41 80 00 00 	movabs $0x8041f4,%rdx
  802bcf:	00 00 00 
  802bd2:	be 85 00 00 00       	mov    $0x85,%esi
  802bd7:	48 bf 09 42 80 00 00 	movabs $0x804209,%rdi
  802bde:	00 00 00 
  802be1:	b8 00 00 00 00       	mov    $0x0,%eax
  802be6:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  802bed:	00 00 00 
  802bf0:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf6:	48 63 d0             	movslq %eax,%rdx
  802bf9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bfd:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802c04:	00 00 00 
  802c07:	48 89 c7             	mov    %rax,%rdi
  802c0a:	48 b8 9e 17 80 00 00 	movabs $0x80179e,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	callq  *%rax
	return r;
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  802c19:	c9                   	leaveq 
  802c1a:	c3                   	retq   

0000000000802c1b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c1b:	55                   	push   %rbp
  802c1c:	48 89 e5             	mov    %rsp,%rbp
  802c1f:	48 83 ec 30          	sub    $0x30,%rsp
  802c23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c2b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c33:	8b 50 0c             	mov    0xc(%rax),%edx
  802c36:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c3d:	00 00 00 
  802c40:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802c42:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c49:	00 00 00 
  802c4c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c50:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  802c54:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802c5b:	00 
  802c5c:	76 35                	jbe    802c93 <devfile_write+0x78>
  802c5e:	48 b9 20 42 80 00 00 	movabs $0x804220,%rcx
  802c65:	00 00 00 
  802c68:	48 ba f4 41 80 00 00 	movabs $0x8041f4,%rdx
  802c6f:	00 00 00 
  802c72:	be 9e 00 00 00       	mov    $0x9e,%esi
  802c77:	48 bf 09 42 80 00 00 	movabs $0x804209,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  802c8d:	00 00 00 
  802c90:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802c93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9b:	48 89 c6             	mov    %rax,%rsi
  802c9e:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802ca5:	00 00 00 
  802ca8:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802cb4:	be 00 00 00 00       	mov    $0x0,%esi
  802cb9:	bf 04 00 00 00       	mov    $0x4,%edi
  802cbe:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax
  802cca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd1:	79 05                	jns    802cd8 <devfile_write+0xbd>
		return r;
  802cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd6:	eb 43                	jmp    802d1b <devfile_write+0x100>
	assert(r <= n);
  802cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdb:	48 98                	cltq   
  802cdd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ce1:	76 35                	jbe    802d18 <devfile_write+0xfd>
  802ce3:	48 b9 ed 41 80 00 00 	movabs $0x8041ed,%rcx
  802cea:	00 00 00 
  802ced:	48 ba f4 41 80 00 00 	movabs $0x8041f4,%rdx
  802cf4:	00 00 00 
  802cf7:	be a2 00 00 00       	mov    $0xa2,%esi
  802cfc:	48 bf 09 42 80 00 00 	movabs $0x804209,%rdi
  802d03:	00 00 00 
  802d06:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0b:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  802d12:	00 00 00 
  802d15:	41 ff d0             	callq  *%r8
	return r;
  802d18:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  802d1b:	c9                   	leaveq 
  802d1c:	c3                   	retq   

0000000000802d1d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d1d:	55                   	push   %rbp
  802d1e:	48 89 e5             	mov    %rsp,%rbp
  802d21:	48 83 ec 20          	sub    $0x20,%rsp
  802d25:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d29:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d31:	8b 50 0c             	mov    0xc(%rax),%edx
  802d34:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d3b:	00 00 00 
  802d3e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d40:	be 00 00 00 00       	mov    $0x0,%esi
  802d45:	bf 05 00 00 00       	mov    $0x5,%edi
  802d4a:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
  802d56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5d:	79 05                	jns    802d64 <devfile_stat+0x47>
		return r;
  802d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d62:	eb 56                	jmp    802dba <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d68:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802d6f:	00 00 00 
  802d72:	48 89 c7             	mov    %rax,%rdi
  802d75:	48 b8 7a 14 80 00 00 	movabs $0x80147a,%rax
  802d7c:	00 00 00 
  802d7f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d81:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d88:	00 00 00 
  802d8b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d95:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d9b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802da2:	00 00 00 
  802da5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802daf:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dba:	c9                   	leaveq 
  802dbb:	c3                   	retq   

0000000000802dbc <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802dbc:	55                   	push   %rbp
  802dbd:	48 89 e5             	mov    %rsp,%rbp
  802dc0:	48 83 ec 10          	sub    $0x10,%rsp
  802dc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dc8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802dcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dcf:	8b 50 0c             	mov    0xc(%rax),%edx
  802dd2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dd9:	00 00 00 
  802ddc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802dde:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802de5:	00 00 00 
  802de8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802deb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802dee:	be 00 00 00 00       	mov    $0x0,%esi
  802df3:	bf 02 00 00 00       	mov    $0x2,%edi
  802df8:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax
}
  802e04:	c9                   	leaveq 
  802e05:	c3                   	retq   

0000000000802e06 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e06:	55                   	push   %rbp
  802e07:	48 89 e5             	mov    %rsp,%rbp
  802e0a:	48 83 ec 10          	sub    $0x10,%rsp
  802e0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e16:	48 89 c7             	mov    %rax,%rdi
  802e19:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
  802e25:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e2a:	7e 07                	jle    802e33 <remove+0x2d>
		return -E_BAD_PATH;
  802e2c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e31:	eb 33                	jmp    802e66 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e37:	48 89 c6             	mov    %rax,%rsi
  802e3a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802e41:	00 00 00 
  802e44:	48 b8 7a 14 80 00 00 	movabs $0x80147a,%rax
  802e4b:	00 00 00 
  802e4e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e50:	be 00 00 00 00       	mov    $0x0,%esi
  802e55:	bf 07 00 00 00       	mov    $0x7,%edi
  802e5a:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	callq  *%rax
}
  802e66:	c9                   	leaveq 
  802e67:	c3                   	retq   

0000000000802e68 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802e68:	55                   	push   %rbp
  802e69:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802e6c:	be 00 00 00 00       	mov    $0x0,%esi
  802e71:	bf 08 00 00 00       	mov    $0x8,%edi
  802e76:	48 b8 7d 29 80 00 00 	movabs $0x80297d,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
}
  802e82:	5d                   	pop    %rbp
  802e83:	c3                   	retq   

0000000000802e84 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e84:	55                   	push   %rbp
  802e85:	48 89 e5             	mov    %rsp,%rbp
  802e88:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e8f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e96:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e9d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ea4:	be 00 00 00 00       	mov    $0x0,%esi
  802ea9:	48 89 c7             	mov    %rax,%rdi
  802eac:	48 b8 04 2a 80 00 00 	movabs $0x802a04,%rax
  802eb3:	00 00 00 
  802eb6:	ff d0                	callq  *%rax
  802eb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ebb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebf:	79 28                	jns    802ee9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec4:	89 c6                	mov    %eax,%esi
  802ec6:	48 bf 4d 42 80 00 00 	movabs $0x80424d,%rdi
  802ecd:	00 00 00 
  802ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed5:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  802edc:	00 00 00 
  802edf:	ff d2                	callq  *%rdx
		return fd_src;
  802ee1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee4:	e9 74 01 00 00       	jmpq   80305d <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ee9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802ef0:	be 01 01 00 00       	mov    $0x101,%esi
  802ef5:	48 89 c7             	mov    %rax,%rdi
  802ef8:	48 b8 04 2a 80 00 00 	movabs $0x802a04,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
  802f04:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f07:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f0b:	79 39                	jns    802f46 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f10:	89 c6                	mov    %eax,%esi
  802f12:	48 bf 63 42 80 00 00 	movabs $0x804263,%rdi
  802f19:	00 00 00 
  802f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f21:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  802f28:	00 00 00 
  802f2b:	ff d2                	callq  *%rdx
		close(fd_src);
  802f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f30:	89 c7                	mov    %eax,%edi
  802f32:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
		return fd_dest;
  802f3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f41:	e9 17 01 00 00       	jmpq   80305d <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f46:	eb 74                	jmp    802fbc <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802f48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f4b:	48 63 d0             	movslq %eax,%rdx
  802f4e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f58:	48 89 ce             	mov    %rcx,%rsi
  802f5b:	89 c7                	mov    %eax,%edi
  802f5d:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
  802f69:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f70:	79 4a                	jns    802fbc <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802f72:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f75:	89 c6                	mov    %eax,%esi
  802f77:	48 bf 7d 42 80 00 00 	movabs $0x80427d,%rdi
  802f7e:	00 00 00 
  802f81:	b8 00 00 00 00       	mov    $0x0,%eax
  802f86:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  802f8d:	00 00 00 
  802f90:	ff d2                	callq  *%rdx
			close(fd_src);
  802f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f95:	89 c7                	mov    %eax,%edi
  802f97:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
			close(fd_dest);
  802fa3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa6:	89 c7                	mov    %eax,%edi
  802fa8:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
			return write_size;
  802fb4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fb7:	e9 a1 00 00 00       	jmpq   80305d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fbc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc6:	ba 00 02 00 00       	mov    $0x200,%edx
  802fcb:	48 89 ce             	mov    %rcx,%rsi
  802fce:	89 c7                	mov    %eax,%edi
  802fd0:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
  802fdc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fe3:	0f 8f 5f ff ff ff    	jg     802f48 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  802fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fed:	79 47                	jns    803036 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802fef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ff2:	89 c6                	mov    %eax,%esi
  802ff4:	48 bf 90 42 80 00 00 	movabs $0x804290,%rdi
  802ffb:	00 00 00 
  802ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  803003:	48 ba 58 07 80 00 00 	movabs $0x800758,%rdx
  80300a:	00 00 00 
  80300d:	ff d2                	callq  *%rdx
		close(fd_src);
  80300f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803012:	89 c7                	mov    %eax,%edi
  803014:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
		close(fd_dest);
  803020:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803023:	89 c7                	mov    %eax,%edi
  803025:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  80302c:	00 00 00 
  80302f:	ff d0                	callq  *%rax
		return read_size;
  803031:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803034:	eb 27                	jmp    80305d <copy+0x1d9>
	}
	close(fd_src);
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803039:	89 c7                	mov    %eax,%edi
  80303b:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
	close(fd_dest);
  803047:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80304a:	89 c7                	mov    %eax,%edi
  80304c:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
	return 0;
  803058:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80305d:	c9                   	leaveq 
  80305e:	c3                   	retq   

000000000080305f <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80305f:	55                   	push   %rbp
  803060:	48 89 e5             	mov    %rsp,%rbp
  803063:	48 83 ec 20          	sub    $0x20,%rsp
  803067:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80306b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306f:	8b 40 0c             	mov    0xc(%rax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	7e 67                	jle    8030dd <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  803076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307a:	8b 40 04             	mov    0x4(%rax),%eax
  80307d:	48 63 d0             	movslq %eax,%rdx
  803080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803084:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308c:	8b 00                	mov    (%rax),%eax
  80308e:	48 89 ce             	mov    %rcx,%rsi
  803091:	89 c7                	mov    %eax,%edi
  803093:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
  80309f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8030a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a6:	7e 13                	jle    8030bb <writebuf+0x5c>
			b->result += result;
  8030a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ac:	8b 50 08             	mov    0x8(%rax),%edx
  8030af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b2:	01 c2                	add    %eax,%edx
  8030b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b8:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8030bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bf:	8b 40 04             	mov    0x4(%rax),%eax
  8030c2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8030c5:	74 16                	je     8030dd <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8030c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d0:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8030d4:	89 c2                	mov    %eax,%edx
  8030d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030da:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8030dd:	c9                   	leaveq 
  8030de:	c3                   	retq   

00000000008030df <putch>:

static void
putch(int ch, void *thunk)
{
  8030df:	55                   	push   %rbp
  8030e0:	48 89 e5             	mov    %rsp,%rbp
  8030e3:	48 83 ec 20          	sub    $0x20,%rsp
  8030e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8030ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8030f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fa:	8b 40 04             	mov    0x4(%rax),%eax
  8030fd:	8d 48 01             	lea    0x1(%rax),%ecx
  803100:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803104:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803107:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80310a:	89 d1                	mov    %edx,%ecx
  80310c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803110:	48 98                	cltq   
  803112:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80311a:	8b 40 04             	mov    0x4(%rax),%eax
  80311d:	3d 00 01 00 00       	cmp    $0x100,%eax
  803122:	75 1e                	jne    803142 <putch+0x63>
		writebuf(b);
  803124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803128:	48 89 c7             	mov    %rax,%rdi
  80312b:	48 b8 5f 30 80 00 00 	movabs $0x80305f,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax
		b->idx = 0;
  803137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803142:	c9                   	leaveq 
  803143:	c3                   	retq   

0000000000803144 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80314f:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  803155:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80315c:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803163:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803169:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80316f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803176:	00 00 00 
	b.result = 0;
  803179:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803180:	00 00 00 
	b.error = 1;
  803183:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80318a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80318d:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803194:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80319b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031a2:	48 89 c6             	mov    %rax,%rsi
  8031a5:	48 bf df 30 80 00 00 	movabs $0x8030df,%rdi
  8031ac:	00 00 00 
  8031af:	48 b8 0b 0b 80 00 00 	movabs $0x800b0b,%rax
  8031b6:	00 00 00 
  8031b9:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8031bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	7e 16                	jle    8031db <vfprintf+0x97>
		writebuf(&b);
  8031c5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031cc:	48 89 c7             	mov    %rax,%rdi
  8031cf:	48 b8 5f 30 80 00 00 	movabs $0x80305f,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8031db:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 08                	je     8031ed <vfprintf+0xa9>
  8031e5:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031eb:	eb 06                	jmp    8031f3 <vfprintf+0xaf>
  8031ed:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8031f3:	c9                   	leaveq 
  8031f4:	c3                   	retq   

00000000008031f5 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8031f5:	55                   	push   %rbp
  8031f6:	48 89 e5             	mov    %rsp,%rbp
  8031f9:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803200:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803206:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80320d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803214:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80321b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803222:	84 c0                	test   %al,%al
  803224:	74 20                	je     803246 <fprintf+0x51>
  803226:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80322a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80322e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803232:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803236:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80323a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80323e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803242:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803246:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80324d:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803254:	00 00 00 
  803257:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80325e:	00 00 00 
  803261:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803265:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80326c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803273:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80327a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803281:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803288:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80328e:	48 89 ce             	mov    %rcx,%rsi
  803291:	89 c7                	mov    %eax,%edi
  803293:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
  80329f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8032a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8032ab:	c9                   	leaveq 
  8032ac:	c3                   	retq   

00000000008032ad <printf>:

int
printf(const char *fmt, ...)
{
  8032ad:	55                   	push   %rbp
  8032ae:	48 89 e5             	mov    %rsp,%rbp
  8032b1:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8032b8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8032bf:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8032c6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8032cd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032d4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032db:	84 c0                	test   %al,%al
  8032dd:	74 20                	je     8032ff <printf+0x52>
  8032df:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032e3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032e7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032eb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032ef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032f3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032f7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032fb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032ff:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803306:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80330d:	00 00 00 
  803310:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803317:	00 00 00 
  80331a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80331e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803325:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80332c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803333:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80333a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803341:	48 89 c6             	mov    %rax,%rsi
  803344:	bf 01 00 00 00       	mov    $0x1,%edi
  803349:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80335b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803361:	c9                   	leaveq 
  803362:	c3                   	retq   

0000000000803363 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803363:	55                   	push   %rbp
  803364:	48 89 e5             	mov    %rsp,%rbp
  803367:	53                   	push   %rbx
  803368:	48 83 ec 38          	sub    $0x38,%rsp
  80336c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803370:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803374:	48 89 c7             	mov    %rax,%rdi
  803377:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
  803383:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803386:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338a:	0f 88 bf 01 00 00    	js     80354f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803390:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803394:	ba 07 04 00 00       	mov    $0x407,%edx
  803399:	48 89 c6             	mov    %rax,%rsi
  80339c:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a1:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8033a8:	00 00 00 
  8033ab:	ff d0                	callq  *%rax
  8033ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033b4:	0f 88 95 01 00 00    	js     80354f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8033ba:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033be:	48 89 c7             	mov    %rax,%rdi
  8033c1:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  8033c8:	00 00 00 
  8033cb:	ff d0                	callq  *%rax
  8033cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d4:	0f 88 5d 01 00 00    	js     803537 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033de:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e3:	48 89 c6             	mov    %rax,%rsi
  8033e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033eb:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033fe:	0f 88 33 01 00 00    	js     803537 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803404:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803408:	48 89 c7             	mov    %rax,%rdi
  80340b:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  803412:	00 00 00 
  803415:	ff d0                	callq  *%rax
  803417:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80341b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341f:	ba 07 04 00 00       	mov    $0x407,%edx
  803424:	48 89 c6             	mov    %rax,%rsi
  803427:	bf 00 00 00 00       	mov    $0x0,%edi
  80342c:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
  803438:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80343b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80343f:	79 05                	jns    803446 <pipe+0xe3>
		goto err2;
  803441:	e9 d9 00 00 00       	jmpq   80351f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803446:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344a:	48 89 c7             	mov    %rax,%rdi
  80344d:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	48 89 c2             	mov    %rax,%rdx
  80345c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803460:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803466:	48 89 d1             	mov    %rdx,%rcx
  803469:	ba 00 00 00 00       	mov    $0x0,%edx
  80346e:	48 89 c6             	mov    %rax,%rsi
  803471:	bf 00 00 00 00       	mov    $0x0,%edi
  803476:	48 b8 f9 1d 80 00 00 	movabs $0x801df9,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
  803482:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803485:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803489:	79 1b                	jns    8034a6 <pipe+0x143>
		goto err3;
  80348b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80348c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803490:	48 89 c6             	mov    %rax,%rsi
  803493:	bf 00 00 00 00       	mov    $0x0,%edi
  803498:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	eb 79                	jmp    80351f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8034a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034aa:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  8034b1:	00 00 00 
  8034b4:	8b 12                	mov    (%rdx),%edx
  8034b6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8034b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8034c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c7:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  8034ce:	00 00 00 
  8034d1:	8b 12                	mov    (%rdx),%edx
  8034d3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8034d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8034e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e4:	48 89 c7             	mov    %rax,%rdi
  8034e7:	48 b8 16 20 80 00 00 	movabs $0x802016,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
  8034f3:	89 c2                	mov    %eax,%edx
  8034f5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034f9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8034fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034ff:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803507:	48 89 c7             	mov    %rax,%rdi
  80350a:	48 b8 16 20 80 00 00 	movabs $0x802016,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
  803516:	89 03                	mov    %eax,(%rbx)
	return 0;
  803518:	b8 00 00 00 00       	mov    $0x0,%eax
  80351d:	eb 33                	jmp    803552 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	48 89 c6             	mov    %rax,%rsi
  803526:	bf 00 00 00 00       	mov    $0x0,%edi
  80352b:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80353b:	48 89 c6             	mov    %rax,%rsi
  80353e:	bf 00 00 00 00       	mov    $0x0,%edi
  803543:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  80354a:	00 00 00 
  80354d:	ff d0                	callq  *%rax
err:
	return r;
  80354f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803552:	48 83 c4 38          	add    $0x38,%rsp
  803556:	5b                   	pop    %rbx
  803557:	5d                   	pop    %rbp
  803558:	c3                   	retq   

0000000000803559 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803559:	55                   	push   %rbp
  80355a:	48 89 e5             	mov    %rsp,%rbp
  80355d:	53                   	push   %rbx
  80355e:	48 83 ec 28          	sub    $0x28,%rsp
  803562:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803566:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80356a:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  803571:	00 00 00 
  803574:	48 8b 00             	mov    (%rax),%rax
  803577:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80357d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803584:	48 89 c7             	mov    %rax,%rdi
  803587:	48 b8 07 3b 80 00 00 	movabs $0x803b07,%rax
  80358e:	00 00 00 
  803591:	ff d0                	callq  *%rax
  803593:	89 c3                	mov    %eax,%ebx
  803595:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803599:	48 89 c7             	mov    %rax,%rdi
  80359c:	48 b8 07 3b 80 00 00 	movabs $0x803b07,%rax
  8035a3:	00 00 00 
  8035a6:	ff d0                	callq  *%rax
  8035a8:	39 c3                	cmp    %eax,%ebx
  8035aa:	0f 94 c0             	sete   %al
  8035ad:	0f b6 c0             	movzbl %al,%eax
  8035b0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8035b3:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8035ba:	00 00 00 
  8035bd:	48 8b 00             	mov    (%rax),%rax
  8035c0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035c6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8035c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035cc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035cf:	75 05                	jne    8035d6 <_pipeisclosed+0x7d>
			return ret;
  8035d1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035d4:	eb 4f                	jmp    803625 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8035d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035dc:	74 42                	je     803620 <_pipeisclosed+0xc7>
  8035de:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8035e2:	75 3c                	jne    803620 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035e4:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8035eb:	00 00 00 
  8035ee:	48 8b 00             	mov    (%rax),%rax
  8035f1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035f7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035fd:	89 c6                	mov    %eax,%esi
  8035ff:	48 bf ab 42 80 00 00 	movabs $0x8042ab,%rdi
  803606:	00 00 00 
  803609:	b8 00 00 00 00       	mov    $0x0,%eax
  80360e:	49 b8 58 07 80 00 00 	movabs $0x800758,%r8
  803615:	00 00 00 
  803618:	41 ff d0             	callq  *%r8
	}
  80361b:	e9 4a ff ff ff       	jmpq   80356a <_pipeisclosed+0x11>
  803620:	e9 45 ff ff ff       	jmpq   80356a <_pipeisclosed+0x11>
}
  803625:	48 83 c4 28          	add    $0x28,%rsp
  803629:	5b                   	pop    %rbx
  80362a:	5d                   	pop    %rbp
  80362b:	c3                   	retq   

000000000080362c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80362c:	55                   	push   %rbp
  80362d:	48 89 e5             	mov    %rsp,%rbp
  803630:	48 83 ec 30          	sub    $0x30,%rsp
  803634:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803637:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80363b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80363e:	48 89 d6             	mov    %rdx,%rsi
  803641:	89 c7                	mov    %eax,%edi
  803643:	48 b8 fc 20 80 00 00 	movabs $0x8020fc,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
  80364f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803656:	79 05                	jns    80365d <pipeisclosed+0x31>
		return r;
  803658:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365b:	eb 31                	jmp    80368e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80365d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803661:	48 89 c7             	mov    %rax,%rdi
  803664:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
  803670:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803678:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80367c:	48 89 d6             	mov    %rdx,%rsi
  80367f:	48 89 c7             	mov    %rax,%rdi
  803682:	48 b8 59 35 80 00 00 	movabs $0x803559,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
}
  80368e:	c9                   	leaveq 
  80368f:	c3                   	retq   

0000000000803690 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803690:	55                   	push   %rbp
  803691:	48 89 e5             	mov    %rsp,%rbp
  803694:	48 83 ec 40          	sub    $0x40,%rsp
  803698:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80369c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036a0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a8:	48 89 c7             	mov    %rax,%rdi
  8036ab:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  8036b2:	00 00 00 
  8036b5:	ff d0                	callq  *%rax
  8036b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036c3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036ca:	00 
  8036cb:	e9 92 00 00 00       	jmpq   803762 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8036d0:	eb 41                	jmp    803713 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8036d2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8036d7:	74 09                	je     8036e2 <devpipe_read+0x52>
				return i;
  8036d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036dd:	e9 92 00 00 00       	jmpq   803774 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ea:	48 89 d6             	mov    %rdx,%rsi
  8036ed:	48 89 c7             	mov    %rax,%rdi
  8036f0:	48 b8 59 35 80 00 00 	movabs $0x803559,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	74 07                	je     803707 <devpipe_read+0x77>
				return 0;
  803700:	b8 00 00 00 00       	mov    $0x0,%eax
  803705:	eb 6d                	jmp    803774 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803707:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803717:	8b 10                	mov    (%rax),%edx
  803719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371d:	8b 40 04             	mov    0x4(%rax),%eax
  803720:	39 c2                	cmp    %eax,%edx
  803722:	74 ae                	je     8036d2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803724:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80372c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803734:	8b 00                	mov    (%rax),%eax
  803736:	99                   	cltd   
  803737:	c1 ea 1b             	shr    $0x1b,%edx
  80373a:	01 d0                	add    %edx,%eax
  80373c:	83 e0 1f             	and    $0x1f,%eax
  80373f:	29 d0                	sub    %edx,%eax
  803741:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803745:	48 98                	cltq   
  803747:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80374c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80374e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803752:	8b 00                	mov    (%rax),%eax
  803754:	8d 50 01             	lea    0x1(%rax),%edx
  803757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80375d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803762:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803766:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80376a:	0f 82 60 ff ff ff    	jb     8036d0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803774:	c9                   	leaveq 
  803775:	c3                   	retq   

0000000000803776 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803776:	55                   	push   %rbp
  803777:	48 89 e5             	mov    %rsp,%rbp
  80377a:	48 83 ec 40          	sub    $0x40,%rsp
  80377e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803782:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803786:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80378a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80378e:	48 89 c7             	mov    %rax,%rdi
  803791:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
  80379d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037a9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037b0:	00 
  8037b1:	e9 8e 00 00 00       	jmpq   803844 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037b6:	eb 31                	jmp    8037e9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8037b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c0:	48 89 d6             	mov    %rdx,%rsi
  8037c3:	48 89 c7             	mov    %rax,%rdi
  8037c6:	48 b8 59 35 80 00 00 	movabs $0x803559,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	74 07                	je     8037dd <devpipe_write+0x67>
				return 0;
  8037d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037db:	eb 79                	jmp    803856 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8037dd:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ed:	8b 40 04             	mov    0x4(%rax),%eax
  8037f0:	48 63 d0             	movslq %eax,%rdx
  8037f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f7:	8b 00                	mov    (%rax),%eax
  8037f9:	48 98                	cltq   
  8037fb:	48 83 c0 20          	add    $0x20,%rax
  8037ff:	48 39 c2             	cmp    %rax,%rdx
  803802:	73 b4                	jae    8037b8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803804:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803808:	8b 40 04             	mov    0x4(%rax),%eax
  80380b:	99                   	cltd   
  80380c:	c1 ea 1b             	shr    $0x1b,%edx
  80380f:	01 d0                	add    %edx,%eax
  803811:	83 e0 1f             	and    $0x1f,%eax
  803814:	29 d0                	sub    %edx,%eax
  803816:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80381a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80381e:	48 01 ca             	add    %rcx,%rdx
  803821:	0f b6 0a             	movzbl (%rdx),%ecx
  803824:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803828:	48 98                	cltq   
  80382a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80382e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803832:	8b 40 04             	mov    0x4(%rax),%eax
  803835:	8d 50 01             	lea    0x1(%rax),%edx
  803838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80383f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803848:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80384c:	0f 82 64 ff ff ff    	jb     8037b6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803852:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803856:	c9                   	leaveq 
  803857:	c3                   	retq   

0000000000803858 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803858:	55                   	push   %rbp
  803859:	48 89 e5             	mov    %rsp,%rbp
  80385c:	48 83 ec 20          	sub    $0x20,%rsp
  803860:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803864:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386c:	48 89 c7             	mov    %rax,%rdi
  80386f:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80387f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803883:	48 be be 42 80 00 00 	movabs $0x8042be,%rsi
  80388a:	00 00 00 
  80388d:	48 89 c7             	mov    %rax,%rdi
  803890:	48 b8 7a 14 80 00 00 	movabs $0x80147a,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80389c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a0:	8b 50 04             	mov    0x4(%rax),%edx
  8038a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a7:	8b 00                	mov    (%rax),%eax
  8038a9:	29 c2                	sub    %eax,%edx
  8038ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038af:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8038b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8038c0:	00 00 00 
	stat->st_dev = &devpipe;
  8038c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038c7:	48 b9 a0 50 80 00 00 	movabs $0x8050a0,%rcx
  8038ce:	00 00 00 
  8038d1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8038d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038dd:	c9                   	leaveq 
  8038de:	c3                   	retq   

00000000008038df <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8038df:	55                   	push   %rbp
  8038e0:	48 89 e5             	mov    %rsp,%rbp
  8038e3:	48 83 ec 10          	sub    $0x10,%rsp
  8038e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8038eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ef:	48 89 c6             	mov    %rax,%rsi
  8038f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f7:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803907:	48 89 c7             	mov    %rax,%rdi
  80390a:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  803911:	00 00 00 
  803914:	ff d0                	callq  *%rax
  803916:	48 89 c6             	mov    %rax,%rsi
  803919:	bf 00 00 00 00       	mov    $0x0,%edi
  80391e:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
}
  80392a:	c9                   	leaveq 
  80392b:	c3                   	retq   

000000000080392c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80392c:	55                   	push   %rbp
  80392d:	48 89 e5             	mov    %rsp,%rbp
  803930:	48 83 ec 30          	sub    $0x30,%rsp
  803934:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803938:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80393c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803940:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803945:	75 0e                	jne    803955 <ipc_recv+0x29>
        pg = (void *)UTOP;
  803947:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80394e:	00 00 00 
  803951:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  803955:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803959:	48 89 c7             	mov    %rax,%rdi
  80395c:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  803963:	00 00 00 
  803966:	ff d0                	callq  *%rax
  803968:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80396f:	79 27                	jns    803998 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  803971:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803976:	74 0a                	je     803982 <ipc_recv+0x56>
            *from_env_store = 0;
  803978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80397c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  803982:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803987:	74 0a                	je     803993 <ipc_recv+0x67>
            *perm_store = 0;
  803989:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  803993:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803996:	eb 53                	jmp    8039eb <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  803998:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80399d:	74 19                	je     8039b8 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  80399f:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8039a6:	00 00 00 
  8039a9:	48 8b 00             	mov    (%rax),%rax
  8039ac:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8039b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b6:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8039b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039bd:	74 19                	je     8039d8 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8039bf:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8039c6:	00 00 00 
  8039c9:	48 8b 00             	mov    (%rax),%rax
  8039cc:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8039d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d6:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8039d8:	48 b8 08 64 80 00 00 	movabs $0x806408,%rax
  8039df:	00 00 00 
  8039e2:	48 8b 00             	mov    (%rax),%rax
  8039e5:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  8039eb:	c9                   	leaveq 
  8039ec:	c3                   	retq   

00000000008039ed <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8039ed:	55                   	push   %rbp
  8039ee:	48 89 e5             	mov    %rsp,%rbp
  8039f1:	48 83 ec 30          	sub    $0x30,%rsp
  8039f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039f8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8039fb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8039ff:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  803a02:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a07:	75 0e                	jne    803a17 <ipc_send+0x2a>
        pg = (void *)UTOP;
  803a09:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a10:	00 00 00 
  803a13:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  803a17:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a1a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a24:	89 c7                	mov    %eax,%edi
  803a26:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  803a35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a39:	79 36                	jns    803a71 <ipc_send+0x84>
  803a3b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a3f:	74 30                	je     803a71 <ipc_send+0x84>
            panic("ipc_send: %e", r);
  803a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a44:	89 c1                	mov    %eax,%ecx
  803a46:	48 ba c5 42 80 00 00 	movabs $0x8042c5,%rdx
  803a4d:	00 00 00 
  803a50:	be 49 00 00 00       	mov    $0x49,%esi
  803a55:	48 bf d2 42 80 00 00 	movabs $0x8042d2,%rdi
  803a5c:	00 00 00 
  803a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a64:	49 b8 1f 05 80 00 00 	movabs $0x80051f,%r8
  803a6b:	00 00 00 
  803a6e:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  803a71:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
    } while(r != 0);
  803a7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a81:	75 94                	jne    803a17 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  803a83:	c9                   	leaveq 
  803a84:	c3                   	retq   

0000000000803a85 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803a85:	55                   	push   %rbp
  803a86:	48 89 e5             	mov    %rsp,%rbp
  803a89:	48 83 ec 14          	sub    $0x14,%rsp
  803a8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803a90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a97:	eb 5e                	jmp    803af7 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803a99:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803aa0:	00 00 00 
  803aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa6:	48 63 d0             	movslq %eax,%rdx
  803aa9:	48 89 d0             	mov    %rdx,%rax
  803aac:	48 c1 e0 03          	shl    $0x3,%rax
  803ab0:	48 01 d0             	add    %rdx,%rax
  803ab3:	48 c1 e0 05          	shl    $0x5,%rax
  803ab7:	48 01 c8             	add    %rcx,%rax
  803aba:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ac0:	8b 00                	mov    (%rax),%eax
  803ac2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ac5:	75 2c                	jne    803af3 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ac7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ace:	00 00 00 
  803ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad4:	48 63 d0             	movslq %eax,%rdx
  803ad7:	48 89 d0             	mov    %rdx,%rax
  803ada:	48 c1 e0 03          	shl    $0x3,%rax
  803ade:	48 01 d0             	add    %rdx,%rax
  803ae1:	48 c1 e0 05          	shl    $0x5,%rax
  803ae5:	48 01 c8             	add    %rcx,%rax
  803ae8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803aee:	8b 40 08             	mov    0x8(%rax),%eax
  803af1:	eb 12                	jmp    803b05 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803af3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803af7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803afe:	7e 99                	jle    803a99 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b05:	c9                   	leaveq 
  803b06:	c3                   	retq   

0000000000803b07 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b07:	55                   	push   %rbp
  803b08:	48 89 e5             	mov    %rsp,%rbp
  803b0b:	48 83 ec 18          	sub    $0x18,%rsp
  803b0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b17:	48 c1 e8 15          	shr    $0x15,%rax
  803b1b:	48 89 c2             	mov    %rax,%rdx
  803b1e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b25:	01 00 00 
  803b28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b2c:	83 e0 01             	and    $0x1,%eax
  803b2f:	48 85 c0             	test   %rax,%rax
  803b32:	75 07                	jne    803b3b <pageref+0x34>
		return 0;
  803b34:	b8 00 00 00 00       	mov    $0x0,%eax
  803b39:	eb 53                	jmp    803b8e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b3f:	48 c1 e8 0c          	shr    $0xc,%rax
  803b43:	48 89 c2             	mov    %rax,%rdx
  803b46:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b4d:	01 00 00 
  803b50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b5c:	83 e0 01             	and    $0x1,%eax
  803b5f:	48 85 c0             	test   %rax,%rax
  803b62:	75 07                	jne    803b6b <pageref+0x64>
		return 0;
  803b64:	b8 00 00 00 00       	mov    $0x0,%eax
  803b69:	eb 23                	jmp    803b8e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803b6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6f:	48 c1 e8 0c          	shr    $0xc,%rax
  803b73:	48 89 c2             	mov    %rax,%rdx
  803b76:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803b7d:	00 00 00 
  803b80:	48 c1 e2 04          	shl    $0x4,%rdx
  803b84:	48 01 d0             	add    %rdx,%rax
  803b87:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803b8b:	0f b7 c0             	movzwl %ax,%eax
}
  803b8e:	c9                   	leaveq 
  803b8f:	c3                   	retq   
