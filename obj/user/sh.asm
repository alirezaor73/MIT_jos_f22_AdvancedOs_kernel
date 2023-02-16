
obj/user/sh:     file format elf64-x86-64


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
  80003c:	e8 35 11 00 00       	callq  801176 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf e8 5d 80 00 00 	movabs $0x805de8,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf 00 5e 80 00 00 	movabs $0x805e00,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 26 5e 80 00 00 	movabs $0x805e26,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 7f 39 80 00 00 	movabs $0x80397f,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf 40 5e 80 00 00 	movabs $0x805e40,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 66 5e 80 00 00 	movabs $0x805e66,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 7f 39 80 00 00 	movabs $0x80397f,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 c7 53 80 00 00 	movabs $0x8053c7,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 7c 5e 80 00 00 	movabs $0x805e7c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 85 5e 80 00 00 	movabs $0x805e85,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 92 5e 80 00 00 	movabs $0x805e92,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 7f 39 80 00 00 	movabs $0x80397f,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 7f 39 80 00 00 	movabs $0x80397f,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba 9b 5e 80 00 00 	movabs $0x805e9b,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf b7 5e 80 00 00 	movabs $0x805eb7,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046e:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf c1 5e 80 00 00 	movabs $0x805ec1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 10 3f 80 00 00 	movabs $0x803f10,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf d0 5e 80 00 00 	movabs $0x805ed0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf de 5e 80 00 00 	movabs $0x805ede,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063a:	48 bf e2 5e 80 00 00 	movabs $0x805ee2,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 5d 49 80 00 00 	movabs $0x80495d,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf e4 5e 80 00 00 	movabs $0x805ee4,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 51 39 80 00 00 	movabs $0x803951,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf f2 5e 80 00 00 	movabs $0x805ef2,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 63 14 80 00 00 	movabs $0x801463,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 90 59 80 00 00 	movabs $0x805990,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf 07 5f 80 00 00 	movabs $0x805f07,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf 1d 5f 80 00 00 	movabs $0x805f1d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 90 59 80 00 00 	movabs $0x805990,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf 07 5f 80 00 00 	movabs $0x805f07,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 3a 5f 80 00 00 	movabs $0x805f3a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf 49 5f 80 00 00 	movabs $0x805f49,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf 57 5f 80 00 00 	movabs $0x805f57,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf 5c 5f 80 00 00 	movabs $0x805f5c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf 61 5f 80 00 00 	movabs $0x805f61,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 69 5f 80 00 00 	movabs $0x805f69,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf 71 5f 80 00 00 	movabs $0x805f71,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 ab 23 80 00 00 	movabs $0x8023ab,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf 7d 5f 80 00 00 	movabs $0x805f7d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3a                	je     800aac <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800b1b:	00 00 00 
  800b1e:	8b 00                	mov    (%rax),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <usage>:


void
usage(void)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b26:	48 bf 88 5f 80 00 00 	movabs $0x805f88,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
}
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	retq   

0000000000800b4f <umain>:

void
umain(int argc, char **argv)
{
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	48 83 ec 50          	sub    $0x50,%rsp
  800b57:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
  800b5e:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6c:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b70:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b74:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b78:	48 89 ce             	mov    %rcx,%rsi
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	48 b8 2b 33 80 00 00 	movabs $0x80332b,%rax
  800b85:	00 00 00 
  800b88:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b8a:	eb 4d                	jmp    800bd9 <umain+0x8a>
		switch (r) {
  800b8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8f:	83 f8 69             	cmp    $0x69,%eax
  800b92:	74 27                	je     800bbb <umain+0x6c>
  800b94:	83 f8 78             	cmp    $0x78,%eax
  800b97:	74 2b                	je     800bc4 <umain+0x75>
  800b99:	83 f8 64             	cmp    $0x64,%eax
  800b9c:	75 2f                	jne    800bcd <umain+0x7e>
		case 'd':
			debug++;
  800b9e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	8d 50 01             	lea    0x1(%rax),%edx
  800bad:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800bb4:	00 00 00 
  800bb7:	89 10                	mov    %edx,(%rax)
			break;
  800bb9:	eb 1e                	jmp    800bd9 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc2:	eb 15                	jmp    800bd9 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bcb:	eb 0c                	jmp    800bd9 <umain+0x8a>
		default:
			usage();
  800bcd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 8f 33 80 00 00 	movabs $0x80338f,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf3:	79 97                	jns    800b8c <umain+0x3d>
			echocmds = 1;
			break;
		default:
			usage();
		}
	if (argc > 2)
  800bf5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf8:	83 f8 02             	cmp    $0x2,%eax
  800bfb:	7e 0c                	jle    800c09 <umain+0xba>
		usage();
  800bfd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800c04:	00 00 00 
  800c07:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c09:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0c:	83 f8 02             	cmp    $0x2,%eax
  800c0f:	0f 85 b3 00 00 00    	jne    800cc8 <umain+0x179>
		close(0);
  800c15:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1a:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c2a:	48 83 c0 08          	add    $0x8,%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	be 00 00 00 00       	mov    $0x0,%esi
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
  800c45:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4c:	79 3f                	jns    800c8d <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c52:	48 83 c0 08          	add    $0x8,%rax
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5c:	41 89 d0             	mov    %edx,%r8d
  800c5f:	48 89 c1             	mov    %rax,%rcx
  800c62:	48 ba a9 5f 80 00 00 	movabs $0x805fa9,%rdx
  800c69:	00 00 00 
  800c6c:	be 29 01 00 00       	mov    $0x129,%esi
  800c71:	48 bf b7 5e 80 00 00 	movabs $0x805eb7,%rdi
  800c78:	00 00 00 
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	49 b9 2a 12 80 00 00 	movabs $0x80122a,%r9
  800c87:	00 00 00 
  800c8a:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c91:	74 35                	je     800cc8 <umain+0x179>
  800c93:	48 b9 b5 5f 80 00 00 	movabs $0x805fb5,%rcx
  800c9a:	00 00 00 
  800c9d:	48 ba bc 5f 80 00 00 	movabs $0x805fbc,%rdx
  800ca4:	00 00 00 
  800ca7:	be 2a 01 00 00       	mov    $0x12a,%esi
  800cac:	48 bf b7 5e 80 00 00 	movabs $0x805eb7,%rdi
  800cb3:	00 00 00 
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  800cc2:	00 00 00 
  800cc5:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc8:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800ccc:	75 14                	jne    800ce2 <umain+0x193>
		interactive = iscons(0);
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;
		buf = readline(interactive ? "$ " : NULL);
  800ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce6:	74 0c                	je     800cf4 <umain+0x1a5>
  800ce8:	48 b8 d1 5f 80 00 00 	movabs $0x805fd1,%rax
  800cef:	00 00 00 
  800cf2:	eb 05                	jmp    800cf9 <umain+0x1aa>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 bf 1f 80 00 00 	movabs $0x801fbf,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d11:	75 37                	jne    800d4a <umain+0x1fb>
			if (debug)
  800d13:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d1a:	00 00 00 
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 1b                	je     800d3e <umain+0x1ef>
				cprintf("EXITING\n");
  800d23:	48 bf d4 5f 80 00 00 	movabs $0x805fd4,%rdi
  800d2a:	00 00 00 
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800d39:	00 00 00 
  800d3c:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3e:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
		}
		if(strcmp(buf, "quit")==0)
  800d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4e:	48 be dd 5f 80 00 00 	movabs $0x805fdd,%rsi
  800d55:	00 00 00 
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	callq  *%rax
  800d67:	85 c0                	test   %eax,%eax
  800d69:	75 0c                	jne    800d77 <umain+0x228>
			exit();
  800d6b:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
		if (debug)
  800d77:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d7e:	00 00 00 
  800d81:	8b 00                	mov    (%rax),%eax
  800d83:	85 c0                	test   %eax,%eax
  800d85:	74 22                	je     800da9 <umain+0x25a>
			cprintf("LINE: %s\n", buf);
  800d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8b:	48 89 c6             	mov    %rax,%rsi
  800d8e:	48 bf e2 5f 80 00 00 	movabs $0x805fe2,%rdi
  800d95:	00 00 00 
  800d98:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9d:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800da4:	00 00 00 
  800da7:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dad:	0f b6 00             	movzbl (%rax),%eax
  800db0:	3c 23                	cmp    $0x23,%al
  800db2:	75 05                	jne    800db9 <umain+0x26a>
			continue;
  800db4:	e9 05 01 00 00       	jmpq   800ebe <umain+0x36f>
		if (echocmds)
  800db9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800dbd:	74 22                	je     800de1 <umain+0x292>
			printf("# %s\n", buf);
  800dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc3:	48 89 c6             	mov    %rax,%rsi
  800dc6:	48 bf ec 5f 80 00 00 	movabs $0x805fec,%rdi
  800dcd:	00 00 00 
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	48 ba a7 48 80 00 00 	movabs $0x8048a7,%rdx
  800ddc:	00 00 00 
  800ddf:	ff d2                	callq  *%rdx
		if (debug)
  800de1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800de8:	00 00 00 
  800deb:	8b 00                	mov    (%rax),%eax
  800ded:	85 c0                	test   %eax,%eax
  800def:	74 1b                	je     800e0c <umain+0x2bd>
			cprintf("BEFORE FORK\n");
  800df1:	48 bf f2 5f 80 00 00 	movabs $0x805ff2,%rdi
  800df8:	00 00 00 
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800e07:	00 00 00 
  800e0a:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800e0c:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e1f:	79 30                	jns    800e51 <umain+0x302>
			panic("fork: %e", r);
  800e21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e24:	89 c1                	mov    %eax,%ecx
  800e26:	48 ba 92 5e 80 00 00 	movabs $0x805e92,%rdx
  800e2d:	00 00 00 
  800e30:	be 42 01 00 00       	mov    $0x142,%esi
  800e35:	48 bf b7 5e 80 00 00 	movabs $0x805eb7,%rdi
  800e3c:	00 00 00 
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  800e4b:	00 00 00 
  800e4e:	41 ff d0             	callq  *%r8
		if (debug)
  800e51:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e58:	00 00 00 
  800e5b:	8b 00                	mov    (%rax),%eax
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	74 20                	je     800e81 <umain+0x332>
			cprintf("FORK: %d\n", r);
  800e61:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e64:	89 c6                	mov    %eax,%esi
  800e66:	48 bf ff 5f 80 00 00 	movabs $0x805fff,%rdi
  800e6d:	00 00 00 
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  800e7c:	00 00 00 
  800e7f:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e85:	75 21                	jne    800ea8 <umain+0x359>
			runcmd(buf);
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
			exit();
  800e9a:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	eb 16                	jmp    800ebe <umain+0x36f>
		} else {
			wait(r);
  800ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800eab:	89 c7                	mov    %eax,%edi
  800ead:	48 b8 90 59 80 00 00 	movabs $0x805990,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
		}
	}
  800eb9:	e9 24 fe ff ff       	jmpq   800ce2 <umain+0x193>
  800ebe:	e9 1f fe ff ff       	jmpq   800ce2 <umain+0x193>

0000000000800ec3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800ec3:	55                   	push   %rbp
  800ec4:	48 89 e5             	mov    %rsp,%rbp
  800ec7:	48 83 ec 20          	sub    $0x20,%rsp
  800ecb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ece:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ed1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ed4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800ed8:	be 01 00 00 00       	mov    $0x1,%esi
  800edd:	48 89 c7             	mov    %rax,%rdi
  800ee0:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	callq  *%rax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <getchar>:

int
getchar(void)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ef6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800efa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eff:	48 89 c6             	mov    %rax,%rsi
  800f02:	bf 00 00 00 00       	mov    $0x0,%edi
  800f07:	48 b8 28 3b 80 00 00 	movabs $0x803b28,%rax
  800f0e:	00 00 00 
  800f11:	ff d0                	callq  *%rax
  800f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f1a:	79 05                	jns    800f21 <getchar+0x33>
		return r;
  800f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1f:	eb 14                	jmp    800f35 <getchar+0x47>
	if (r < 1)
  800f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f25:	7f 07                	jg     800f2e <getchar+0x40>
		return -E_EOF;
  800f27:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800f2c:	eb 07                	jmp    800f35 <getchar+0x47>
	return c;
  800f2e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
}
  800f35:	c9                   	leaveq 
  800f36:	c3                   	retq   

0000000000800f37 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f37:	55                   	push   %rbp
  800f38:	48 89 e5             	mov    %rsp,%rbp
  800f3b:	48 83 ec 20          	sub    $0x20,%rsp
  800f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f49:	48 89 d6             	mov    %rdx,%rsi
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
  800f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f61:	79 05                	jns    800f68 <iscons+0x31>
		return r;
  800f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f66:	eb 1a                	jmp    800f82 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6c:	8b 10                	mov    (%rax),%edx
  800f6e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800f75:	00 00 00 
  800f78:	8b 00                	mov    (%rax),%eax
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	0f 94 c0             	sete   %al
  800f7f:	0f b6 c0             	movzbl %al,%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <opencons>:

int
opencons(void)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f8c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa6:	79 05                	jns    800fad <opencons+0x29>
		return r;
  800fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fab:	eb 5b                	jmp    801008 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb1:	ba 07 04 00 00       	mov    $0x407,%edx
  800fb6:	48 89 c6             	mov    %rax,%rsi
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  800fc5:	00 00 00 
  800fc8:	ff d0                	callq  *%rax
  800fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd1:	79 05                	jns    800fd8 <opencons+0x54>
		return r;
  800fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd6:	eb 30                	jmp    801008 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdc:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  800fe3:	00 00 00 
  800fe6:	8b 12                	mov    (%rdx),%edx
  800fe8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 10 36 80 00 00 	movabs $0x803610,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
}
  801008:	c9                   	leaveq 
  801009:	c3                   	retq   

000000000080100a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80100a:	55                   	push   %rbp
  80100b:	48 89 e5             	mov    %rsp,%rbp
  80100e:	48 83 ec 30          	sub    $0x30,%rsp
  801012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801016:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80101a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80101e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801023:	75 07                	jne    80102c <devcons_read+0x22>
		return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 4b                	jmp    801077 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80102c:	eb 0c                	jmp    80103a <devcons_read+0x30>
		sys_yield();
  80102e:	48 b8 76 2a 80 00 00 	movabs $0x802a76,%rax
  801035:	00 00 00 
  801038:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80103a:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80104d:	74 df                	je     80102e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80104f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801053:	79 05                	jns    80105a <devcons_read+0x50>
		return c;
  801055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801058:	eb 1d                	jmp    801077 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80105a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80105e:	75 07                	jne    801067 <devcons_read+0x5d>
		return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	eb 10                	jmp    801077 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801070:	88 10                	mov    %dl,(%rax)
	return 1;
  801072:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801084:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80108b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801092:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a0:	eb 76                	jmp    801118 <devcons_write+0x9f>
		m = n - tot;
  8010a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8010b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010b8:	83 f8 7f             	cmp    $0x7f,%eax
  8010bb:	76 07                	jbe    8010c4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8010bd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8010c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c7:	48 63 d0             	movslq %eax,%rdx
  8010ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cd:	48 63 c8             	movslq %eax,%rcx
  8010d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8010d7:	48 01 c1             	add    %rax,%rcx
  8010da:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010e1:	48 89 ce             	mov    %rcx,%rsi
  8010e4:	48 89 c7             	mov    %rax,%rdi
  8010e7:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010f6:	48 63 d0             	movslq %eax,%rdx
  8010f9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801100:	48 89 d6             	mov    %rdx,%rsi
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801112:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801115:	01 45 fc             	add    %eax,-0x4(%rbp)
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 98                	cltq   
  80111d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801124:	0f 82 78 ff ff ff    	jb     8010a2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 08          	sub    $0x8,%rsp
  801137:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 10          	sub    $0x10,%rsp
  80114a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801156:	48 be 0e 60 80 00 00 	movabs $0x80600e,%rsi
  80115d:	00 00 00 
  801160:	48 89 c7             	mov    %rax,%rdi
  801163:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 20          	sub    $0x20,%rsp
  80117e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801181:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  801185:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  801194:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801197:	25 ff 03 00 00       	and    $0x3ff,%eax
  80119c:	48 63 d0             	movslq %eax,%rdx
  80119f:	48 89 d0             	mov    %rdx,%rax
  8011a2:	48 c1 e0 03          	shl    $0x3,%rax
  8011a6:	48 01 d0             	add    %rdx,%rax
  8011a9:	48 c1 e0 05          	shl    $0x5,%rax
  8011ad:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8011b4:	00 00 00 
  8011b7:	48 01 c2             	add    %rax,%rdx
  8011ba:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8011c1:	00 00 00 
  8011c4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8011cb:	7e 14                	jle    8011e1 <libmain+0x6b>
		binaryname = argv[0];
  8011cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d1:	48 8b 10             	mov    (%rax),%rdx
  8011d4:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8011db:	00 00 00 
  8011de:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011e8:	48 89 d6             	mov    %rdx,%rsi
  8011eb:	89 c7                	mov    %eax,%edi
  8011ed:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8011f4:	00 00 00 
  8011f7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8011f9:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  801200:	00 00 00 
  801203:	ff d0                	callq  *%rax
}
  801205:	c9                   	leaveq 
  801206:	c3                   	retq   

0000000000801207 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801207:	55                   	push   %rbp
  801208:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80120b:	48 b8 51 39 80 00 00 	movabs $0x803951,%rax
  801212:	00 00 00 
  801215:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  801217:	bf 00 00 00 00       	mov    $0x0,%edi
  80121c:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  801223:	00 00 00 
  801226:	ff d0                	callq  *%rax
}
  801228:	5d                   	pop    %rbp
  801229:	c3                   	retq   

000000000080122a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	53                   	push   %rbx
  80122f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801236:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80123d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801243:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80124a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801251:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801258:	84 c0                	test   %al,%al
  80125a:	74 23                	je     80127f <_panic+0x55>
  80125c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801263:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801267:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80126b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80126f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801273:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801277:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80127b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80127f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801286:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80128d:	00 00 00 
  801290:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801297:	00 00 00 
  80129a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80129e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8012a5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8012ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012b3:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8012ba:	00 00 00 
  8012bd:	48 8b 18             	mov    (%rax),%rbx
  8012c0:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  8012c7:	00 00 00 
  8012ca:	ff d0                	callq  *%rax
  8012cc:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012d2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012d9:	41 89 c8             	mov    %ecx,%r8d
  8012dc:	48 89 d1             	mov    %rdx,%rcx
  8012df:	48 89 da             	mov    %rbx,%rdx
  8012e2:	89 c6                	mov    %eax,%esi
  8012e4:	48 bf 20 60 80 00 00 	movabs $0x806020,%rdi
  8012eb:	00 00 00 
  8012ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f3:	49 b9 63 14 80 00 00 	movabs $0x801463,%r9
  8012fa:	00 00 00 
  8012fd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801300:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801307:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80130e:	48 89 d6             	mov    %rdx,%rsi
  801311:	48 89 c7             	mov    %rax,%rdi
  801314:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
	cprintf("\n");
  801320:	48 bf 43 60 80 00 00 	movabs $0x806043,%rdi
  801327:	00 00 00 
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
  80132f:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  801336:	00 00 00 
  801339:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80133b:	cc                   	int3   
  80133c:	eb fd                	jmp    80133b <_panic+0x111>

000000000080133e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 10          	sub    $0x10,%rsp
  801346:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801349:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80134d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801351:	8b 00                	mov    (%rax),%eax
  801353:	8d 48 01             	lea    0x1(%rax),%ecx
  801356:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80135a:	89 0a                	mov    %ecx,(%rdx)
  80135c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80135f:	89 d1                	mov    %edx,%ecx
  801361:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801365:	48 98                	cltq   
  801367:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80136b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136f:	8b 00                	mov    (%rax),%eax
  801371:	3d ff 00 00 00       	cmp    $0xff,%eax
  801376:	75 2c                	jne    8013a4 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137c:	8b 00                	mov    (%rax),%eax
  80137e:	48 98                	cltq   
  801380:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801384:	48 83 c2 08          	add    $0x8,%rdx
  801388:	48 89 c6             	mov    %rax,%rsi
  80138b:	48 89 d7             	mov    %rdx,%rdi
  80138e:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  801395:	00 00 00 
  801398:	ff d0                	callq  *%rax
        b->idx = 0;
  80139a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8013a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a8:	8b 40 04             	mov    0x4(%rax),%eax
  8013ab:	8d 50 01             	lea    0x1(%rax),%edx
  8013ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   

00000000008013b7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8013c2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8013c9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8013d0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013d7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013de:	48 8b 0a             	mov    (%rdx),%rcx
  8013e1:	48 89 08             	mov    %rcx,(%rax)
  8013e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8013f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013fb:	00 00 00 
    b.cnt = 0;
  8013fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801405:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801408:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80140f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801416:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80141d:	48 89 c6             	mov    %rax,%rsi
  801420:	48 bf 3e 13 80 00 00 	movabs $0x80133e,%rdi
  801427:	00 00 00 
  80142a:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801431:	00 00 00 
  801434:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801436:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80143c:	48 98                	cltq   
  80143e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801445:	48 83 c2 08          	add    $0x8,%rdx
  801449:	48 89 c6             	mov    %rax,%rsi
  80144c:	48 89 d7             	mov    %rdx,%rdi
  80144f:	48 b8 6c 29 80 00 00 	movabs $0x80296c,%rax
  801456:	00 00 00 
  801459:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80145b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801461:	c9                   	leaveq 
  801462:	c3                   	retq   

0000000000801463 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801463:	55                   	push   %rbp
  801464:	48 89 e5             	mov    %rsp,%rbp
  801467:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80146e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801475:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80147c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801483:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80148a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801491:	84 c0                	test   %al,%al
  801493:	74 20                	je     8014b5 <cprintf+0x52>
  801495:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801499:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80149d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8014a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8014bc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8014c3:	00 00 00 
  8014c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014cd:	00 00 00 
  8014d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8014e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014f7:	48 8b 0a             	mov    (%rdx),%rcx
  8014fa:	48 89 08             	mov    %rcx,(%rax)
  8014fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801501:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801505:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801509:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80150d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801514:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80151b:	48 89 d6             	mov    %rdx,%rsi
  80151e:	48 89 c7             	mov    %rax,%rdi
  801521:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  801528:	00 00 00 
  80152b:	ff d0                	callq  *%rax
  80152d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801533:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801539:	c9                   	leaveq 
  80153a:	c3                   	retq   

000000000080153b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80153b:	55                   	push   %rbp
  80153c:	48 89 e5             	mov    %rsp,%rbp
  80153f:	53                   	push   %rbx
  801540:	48 83 ec 38          	sub    $0x38,%rsp
  801544:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801548:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801550:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801553:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801557:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80155b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80155e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801562:	77 3b                	ja     80159f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801564:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801567:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80156b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	ba 00 00 00 00       	mov    $0x0,%edx
  801577:	48 f7 f3             	div    %rbx
  80157a:	48 89 c2             	mov    %rax,%rdx
  80157d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801580:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801583:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158b:	41 89 f9             	mov    %edi,%r9d
  80158e:	48 89 c7             	mov    %rax,%rdi
  801591:	48 b8 3b 15 80 00 00 	movabs $0x80153b,%rax
  801598:	00 00 00 
  80159b:	ff d0                	callq  *%rax
  80159d:	eb 1e                	jmp    8015bd <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80159f:	eb 12                	jmp    8015b3 <printnum+0x78>
			putch(padc, putdat);
  8015a1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015a5:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8015a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ac:	48 89 ce             	mov    %rcx,%rsi
  8015af:	89 d7                	mov    %edx,%edi
  8015b1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015b3:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8015b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8015bb:	7f e4                	jg     8015a1 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015bd:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8015c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c9:	48 f7 f1             	div    %rcx
  8015cc:	48 89 d0             	mov    %rdx,%rax
  8015cf:	48 ba 50 62 80 00 00 	movabs $0x806250,%rdx
  8015d6:	00 00 00 
  8015d9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015dd:	0f be d0             	movsbl %al,%edx
  8015e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e8:	48 89 ce             	mov    %rcx,%rsi
  8015eb:	89 d7                	mov    %edx,%edi
  8015ed:	ff d0                	callq  *%rax
}
  8015ef:	48 83 c4 38          	add    $0x38,%rsp
  8015f3:	5b                   	pop    %rbx
  8015f4:	5d                   	pop    %rbp
  8015f5:	c3                   	retq   

00000000008015f6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015f6:	55                   	push   %rbp
  8015f7:	48 89 e5             	mov    %rsp,%rbp
  8015fa:	48 83 ec 1c          	sub    $0x1c,%rsp
  8015fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801602:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  801605:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801609:	7e 52                	jle    80165d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80160b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160f:	8b 00                	mov    (%rax),%eax
  801611:	83 f8 30             	cmp    $0x30,%eax
  801614:	73 24                	jae    80163a <getuint+0x44>
  801616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80161e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801622:	8b 00                	mov    (%rax),%eax
  801624:	89 c0                	mov    %eax,%eax
  801626:	48 01 d0             	add    %rdx,%rax
  801629:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80162d:	8b 12                	mov    (%rdx),%edx
  80162f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801632:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801636:	89 0a                	mov    %ecx,(%rdx)
  801638:	eb 17                	jmp    801651 <getuint+0x5b>
  80163a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801642:	48 89 d0             	mov    %rdx,%rax
  801645:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801651:	48 8b 00             	mov    (%rax),%rax
  801654:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801658:	e9 a3 00 00 00       	jmpq   801700 <getuint+0x10a>
	else if (lflag)
  80165d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801661:	74 4f                	je     8016b2 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801667:	8b 00                	mov    (%rax),%eax
  801669:	83 f8 30             	cmp    $0x30,%eax
  80166c:	73 24                	jae    801692 <getuint+0x9c>
  80166e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801672:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167a:	8b 00                	mov    (%rax),%eax
  80167c:	89 c0                	mov    %eax,%eax
  80167e:	48 01 d0             	add    %rdx,%rax
  801681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801685:	8b 12                	mov    (%rdx),%edx
  801687:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80168a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80168e:	89 0a                	mov    %ecx,(%rdx)
  801690:	eb 17                	jmp    8016a9 <getuint+0xb3>
  801692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801696:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80169a:	48 89 d0             	mov    %rdx,%rax
  80169d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016a9:	48 8b 00             	mov    (%rax),%rax
  8016ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8016b0:	eb 4e                	jmp    801700 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8016b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b6:	8b 00                	mov    (%rax),%eax
  8016b8:	83 f8 30             	cmp    $0x30,%eax
  8016bb:	73 24                	jae    8016e1 <getuint+0xeb>
  8016bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c9:	8b 00                	mov    (%rax),%eax
  8016cb:	89 c0                	mov    %eax,%eax
  8016cd:	48 01 d0             	add    %rdx,%rax
  8016d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d4:	8b 12                	mov    (%rdx),%edx
  8016d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016dd:	89 0a                	mov    %ecx,(%rdx)
  8016df:	eb 17                	jmp    8016f8 <getuint+0x102>
  8016e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016e9:	48 89 d0             	mov    %rdx,%rax
  8016ec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016f8:	8b 00                	mov    (%rax),%eax
  8016fa:	89 c0                	mov    %eax,%eax
  8016fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801704:	c9                   	leaveq 
  801705:	c3                   	retq   

0000000000801706 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80170e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801712:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801715:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801719:	7e 52                	jle    80176d <getint+0x67>
		x=va_arg(*ap, long long);
  80171b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171f:	8b 00                	mov    (%rax),%eax
  801721:	83 f8 30             	cmp    $0x30,%eax
  801724:	73 24                	jae    80174a <getint+0x44>
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80172e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801732:	8b 00                	mov    (%rax),%eax
  801734:	89 c0                	mov    %eax,%eax
  801736:	48 01 d0             	add    %rdx,%rax
  801739:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80173d:	8b 12                	mov    (%rdx),%edx
  80173f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801742:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801746:	89 0a                	mov    %ecx,(%rdx)
  801748:	eb 17                	jmp    801761 <getint+0x5b>
  80174a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801752:	48 89 d0             	mov    %rdx,%rax
  801755:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801761:	48 8b 00             	mov    (%rax),%rax
  801764:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801768:	e9 a3 00 00 00       	jmpq   801810 <getint+0x10a>
	else if (lflag)
  80176d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801771:	74 4f                	je     8017c2 <getint+0xbc>
		x=va_arg(*ap, long);
  801773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801777:	8b 00                	mov    (%rax),%eax
  801779:	83 f8 30             	cmp    $0x30,%eax
  80177c:	73 24                	jae    8017a2 <getint+0x9c>
  80177e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801782:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178a:	8b 00                	mov    (%rax),%eax
  80178c:	89 c0                	mov    %eax,%eax
  80178e:	48 01 d0             	add    %rdx,%rax
  801791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801795:	8b 12                	mov    (%rdx),%edx
  801797:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80179a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80179e:	89 0a                	mov    %ecx,(%rdx)
  8017a0:	eb 17                	jmp    8017b9 <getint+0xb3>
  8017a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017aa:	48 89 d0             	mov    %rdx,%rax
  8017ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017b9:	48 8b 00             	mov    (%rax),%rax
  8017bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017c0:	eb 4e                	jmp    801810 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8017c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c6:	8b 00                	mov    (%rax),%eax
  8017c8:	83 f8 30             	cmp    $0x30,%eax
  8017cb:	73 24                	jae    8017f1 <getint+0xeb>
  8017cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d9:	8b 00                	mov    (%rax),%eax
  8017db:	89 c0                	mov    %eax,%eax
  8017dd:	48 01 d0             	add    %rdx,%rax
  8017e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e4:	8b 12                	mov    (%rdx),%edx
  8017e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ed:	89 0a                	mov    %ecx,(%rdx)
  8017ef:	eb 17                	jmp    801808 <getint+0x102>
  8017f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017f9:	48 89 d0             	mov    %rdx,%rax
  8017fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801804:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801808:	8b 00                	mov    (%rax),%eax
  80180a:	48 98                	cltq   
  80180c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801810:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801814:	c9                   	leaveq 
  801815:	c3                   	retq   

0000000000801816 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801816:	55                   	push   %rbp
  801817:	48 89 e5             	mov    %rsp,%rbp
  80181a:	41 54                	push   %r12
  80181c:	53                   	push   %rbx
  80181d:	48 83 ec 60          	sub    $0x60,%rsp
  801821:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801825:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801829:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80182d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801831:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801835:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801839:	48 8b 0a             	mov    (%rdx),%rcx
  80183c:	48 89 08             	mov    %rcx,(%rax)
  80183f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801843:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801847:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80184b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80184f:	eb 17                	jmp    801868 <vprintfmt+0x52>
			if (ch == '\0')
  801851:	85 db                	test   %ebx,%ebx
  801853:	0f 84 df 04 00 00    	je     801d38 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  801859:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80185d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801861:	48 89 d6             	mov    %rdx,%rsi
  801864:	89 df                	mov    %ebx,%edi
  801866:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801868:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80186c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801870:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801874:	0f b6 00             	movzbl (%rax),%eax
  801877:	0f b6 d8             	movzbl %al,%ebx
  80187a:	83 fb 25             	cmp    $0x25,%ebx
  80187d:	75 d2                	jne    801851 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80187f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801883:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80188a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801891:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801898:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80189f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018a3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8018ab:	0f b6 00             	movzbl (%rax),%eax
  8018ae:	0f b6 d8             	movzbl %al,%ebx
  8018b1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8018b4:	83 f8 55             	cmp    $0x55,%eax
  8018b7:	0f 87 47 04 00 00    	ja     801d04 <vprintfmt+0x4ee>
  8018bd:	89 c0                	mov    %eax,%eax
  8018bf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8018c6:	00 
  8018c7:	48 b8 78 62 80 00 00 	movabs $0x806278,%rax
  8018ce:	00 00 00 
  8018d1:	48 01 d0             	add    %rdx,%rax
  8018d4:	48 8b 00             	mov    (%rax),%rax
  8018d7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8018d9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018dd:	eb c0                	jmp    80189f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018df:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8018e3:	eb ba                	jmp    80189f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018e5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8018ec:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018ef:	89 d0                	mov    %edx,%eax
  8018f1:	c1 e0 02             	shl    $0x2,%eax
  8018f4:	01 d0                	add    %edx,%eax
  8018f6:	01 c0                	add    %eax,%eax
  8018f8:	01 d8                	add    %ebx,%eax
  8018fa:	83 e8 30             	sub    $0x30,%eax
  8018fd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801900:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80190a:	83 fb 2f             	cmp    $0x2f,%ebx
  80190d:	7e 0c                	jle    80191b <vprintfmt+0x105>
  80190f:	83 fb 39             	cmp    $0x39,%ebx
  801912:	7f 07                	jg     80191b <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801914:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801919:	eb d1                	jmp    8018ec <vprintfmt+0xd6>
			goto process_precision;
  80191b:	eb 58                	jmp    801975 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80191d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801920:	83 f8 30             	cmp    $0x30,%eax
  801923:	73 17                	jae    80193c <vprintfmt+0x126>
  801925:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801929:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80192c:	89 c0                	mov    %eax,%eax
  80192e:	48 01 d0             	add    %rdx,%rax
  801931:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801934:	83 c2 08             	add    $0x8,%edx
  801937:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80193a:	eb 0f                	jmp    80194b <vprintfmt+0x135>
  80193c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801940:	48 89 d0             	mov    %rdx,%rax
  801943:	48 83 c2 08          	add    $0x8,%rdx
  801947:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80194b:	8b 00                	mov    (%rax),%eax
  80194d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801950:	eb 23                	jmp    801975 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801952:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801956:	79 0c                	jns    801964 <vprintfmt+0x14e>
				width = 0;
  801958:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80195f:	e9 3b ff ff ff       	jmpq   80189f <vprintfmt+0x89>
  801964:	e9 36 ff ff ff       	jmpq   80189f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801969:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801970:	e9 2a ff ff ff       	jmpq   80189f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801975:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801979:	79 12                	jns    80198d <vprintfmt+0x177>
				width = precision, precision = -1;
  80197b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80197e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801981:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801988:	e9 12 ff ff ff       	jmpq   80189f <vprintfmt+0x89>
  80198d:	e9 0d ff ff ff       	jmpq   80189f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801992:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801996:	e9 04 ff ff ff       	jmpq   80189f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80199b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80199e:	83 f8 30             	cmp    $0x30,%eax
  8019a1:	73 17                	jae    8019ba <vprintfmt+0x1a4>
  8019a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019aa:	89 c0                	mov    %eax,%eax
  8019ac:	48 01 d0             	add    %rdx,%rax
  8019af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019b2:	83 c2 08             	add    $0x8,%edx
  8019b5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019b8:	eb 0f                	jmp    8019c9 <vprintfmt+0x1b3>
  8019ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019be:	48 89 d0             	mov    %rdx,%rax
  8019c1:	48 83 c2 08          	add    $0x8,%rdx
  8019c5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019c9:	8b 10                	mov    (%rax),%edx
  8019cb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8019cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019d3:	48 89 ce             	mov    %rcx,%rsi
  8019d6:	89 d7                	mov    %edx,%edi
  8019d8:	ff d0                	callq  *%rax
			break;
  8019da:	e9 53 03 00 00       	jmpq   801d32 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8019df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019e2:	83 f8 30             	cmp    $0x30,%eax
  8019e5:	73 17                	jae    8019fe <vprintfmt+0x1e8>
  8019e7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019ee:	89 c0                	mov    %eax,%eax
  8019f0:	48 01 d0             	add    %rdx,%rax
  8019f3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019f6:	83 c2 08             	add    $0x8,%edx
  8019f9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019fc:	eb 0f                	jmp    801a0d <vprintfmt+0x1f7>
  8019fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a02:	48 89 d0             	mov    %rdx,%rax
  801a05:	48 83 c2 08          	add    $0x8,%rdx
  801a09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a0d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801a0f:	85 db                	test   %ebx,%ebx
  801a11:	79 02                	jns    801a15 <vprintfmt+0x1ff>
				err = -err;
  801a13:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a15:	83 fb 15             	cmp    $0x15,%ebx
  801a18:	7f 16                	jg     801a30 <vprintfmt+0x21a>
  801a1a:	48 b8 a0 61 80 00 00 	movabs $0x8061a0,%rax
  801a21:	00 00 00 
  801a24:	48 63 d3             	movslq %ebx,%rdx
  801a27:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801a2b:	4d 85 e4             	test   %r12,%r12
  801a2e:	75 2e                	jne    801a5e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801a30:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a38:	89 d9                	mov    %ebx,%ecx
  801a3a:	48 ba 61 62 80 00 00 	movabs $0x806261,%rdx
  801a41:	00 00 00 
  801a44:	48 89 c7             	mov    %rax,%rdi
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4c:	49 b8 41 1d 80 00 00 	movabs $0x801d41,%r8
  801a53:	00 00 00 
  801a56:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a59:	e9 d4 02 00 00       	jmpq   801d32 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a5e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a66:	4c 89 e1             	mov    %r12,%rcx
  801a69:	48 ba 6a 62 80 00 00 	movabs $0x80626a,%rdx
  801a70:	00 00 00 
  801a73:	48 89 c7             	mov    %rax,%rdi
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7b:	49 b8 41 1d 80 00 00 	movabs $0x801d41,%r8
  801a82:	00 00 00 
  801a85:	41 ff d0             	callq  *%r8
			break;
  801a88:	e9 a5 02 00 00       	jmpq   801d32 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801a8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a90:	83 f8 30             	cmp    $0x30,%eax
  801a93:	73 17                	jae    801aac <vprintfmt+0x296>
  801a95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a9c:	89 c0                	mov    %eax,%eax
  801a9e:	48 01 d0             	add    %rdx,%rax
  801aa1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801aa4:	83 c2 08             	add    $0x8,%edx
  801aa7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801aaa:	eb 0f                	jmp    801abb <vprintfmt+0x2a5>
  801aac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ab0:	48 89 d0             	mov    %rdx,%rax
  801ab3:	48 83 c2 08          	add    $0x8,%rdx
  801ab7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801abb:	4c 8b 20             	mov    (%rax),%r12
  801abe:	4d 85 e4             	test   %r12,%r12
  801ac1:	75 0a                	jne    801acd <vprintfmt+0x2b7>
				p = "(null)";
  801ac3:	49 bc 6d 62 80 00 00 	movabs $0x80626d,%r12
  801aca:	00 00 00 
			if (width > 0 && padc != '-')
  801acd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801ad1:	7e 3f                	jle    801b12 <vprintfmt+0x2fc>
  801ad3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801ad7:	74 39                	je     801b12 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ad9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801adc:	48 98                	cltq   
  801ade:	48 89 c6             	mov    %rax,%rsi
  801ae1:	4c 89 e7             	mov    %r12,%rdi
  801ae4:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	callq  *%rax
  801af0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801af3:	eb 17                	jmp    801b0c <vprintfmt+0x2f6>
					putch(padc, putdat);
  801af5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801af9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801afd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b01:	48 89 ce             	mov    %rcx,%rsi
  801b04:	89 d7                	mov    %edx,%edi
  801b06:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b08:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b10:	7f e3                	jg     801af5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b12:	eb 37                	jmp    801b4b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801b14:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801b18:	74 1e                	je     801b38 <vprintfmt+0x322>
  801b1a:	83 fb 1f             	cmp    $0x1f,%ebx
  801b1d:	7e 05                	jle    801b24 <vprintfmt+0x30e>
  801b1f:	83 fb 7e             	cmp    $0x7e,%ebx
  801b22:	7e 14                	jle    801b38 <vprintfmt+0x322>
					putch('?', putdat);
  801b24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b2c:	48 89 d6             	mov    %rdx,%rsi
  801b2f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b34:	ff d0                	callq  *%rax
  801b36:	eb 0f                	jmp    801b47 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801b38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b40:	48 89 d6             	mov    %rdx,%rsi
  801b43:	89 df                	mov    %ebx,%edi
  801b45:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b47:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b4b:	4c 89 e0             	mov    %r12,%rax
  801b4e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801b52:	0f b6 00             	movzbl (%rax),%eax
  801b55:	0f be d8             	movsbl %al,%ebx
  801b58:	85 db                	test   %ebx,%ebx
  801b5a:	74 10                	je     801b6c <vprintfmt+0x356>
  801b5c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b60:	78 b2                	js     801b14 <vprintfmt+0x2fe>
  801b62:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b66:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b6a:	79 a8                	jns    801b14 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b6c:	eb 16                	jmp    801b84 <vprintfmt+0x36e>
				putch(' ', putdat);
  801b6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b76:	48 89 d6             	mov    %rdx,%rsi
  801b79:	bf 20 00 00 00       	mov    $0x20,%edi
  801b7e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b88:	7f e4                	jg     801b6e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801b8a:	e9 a3 01 00 00       	jmpq   801d32 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801b8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801b93:	be 03 00 00 00       	mov    $0x3,%esi
  801b98:	48 89 c7             	mov    %rax,%rdi
  801b9b:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
  801ba7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801bab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801baf:	48 85 c0             	test   %rax,%rax
  801bb2:	79 1d                	jns    801bd1 <vprintfmt+0x3bb>
				putch('-', putdat);
  801bb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bbc:	48 89 d6             	mov    %rdx,%rsi
  801bbf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801bc4:	ff d0                	callq  *%rax
				num = -(long long) num;
  801bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bca:	48 f7 d8             	neg    %rax
  801bcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801bd1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bd8:	e9 e8 00 00 00       	jmpq   801cc5 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801bdd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801be1:	be 03 00 00 00       	mov    $0x3,%esi
  801be6:	48 89 c7             	mov    %rax,%rdi
  801be9:	48 b8 f6 15 80 00 00 	movabs $0x8015f6,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	callq  *%rax
  801bf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801bf9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801c00:	e9 c0 00 00 00       	jmpq   801cc5 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c0d:	48 89 d6             	mov    %rdx,%rsi
  801c10:	bf 58 00 00 00       	mov    $0x58,%edi
  801c15:	ff d0                	callq  *%rax
			putch('X', putdat);
  801c17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c1f:	48 89 d6             	mov    %rdx,%rsi
  801c22:	bf 58 00 00 00       	mov    $0x58,%edi
  801c27:	ff d0                	callq  *%rax
			putch('X', putdat);
  801c29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c31:	48 89 d6             	mov    %rdx,%rsi
  801c34:	bf 58 00 00 00       	mov    $0x58,%edi
  801c39:	ff d0                	callq  *%rax
			break;
  801c3b:	e9 f2 00 00 00       	jmpq   801d32 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  801c40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c48:	48 89 d6             	mov    %rdx,%rsi
  801c4b:	bf 30 00 00 00       	mov    $0x30,%edi
  801c50:	ff d0                	callq  *%rax
			putch('x', putdat);
  801c52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c5a:	48 89 d6             	mov    %rdx,%rsi
  801c5d:	bf 78 00 00 00       	mov    $0x78,%edi
  801c62:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c67:	83 f8 30             	cmp    $0x30,%eax
  801c6a:	73 17                	jae    801c83 <vprintfmt+0x46d>
  801c6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c73:	89 c0                	mov    %eax,%eax
  801c75:	48 01 d0             	add    %rdx,%rax
  801c78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c7b:	83 c2 08             	add    $0x8,%edx
  801c7e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c81:	eb 0f                	jmp    801c92 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  801c83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c87:	48 89 d0             	mov    %rdx,%rax
  801c8a:	48 83 c2 08          	add    $0x8,%rdx
  801c8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c92:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801c99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801ca0:	eb 23                	jmp    801cc5 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801ca2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801ca6:	be 03 00 00 00       	mov    $0x3,%esi
  801cab:	48 89 c7             	mov    %rax,%rdi
  801cae:	48 b8 f6 15 80 00 00 	movabs $0x8015f6,%rax
  801cb5:	00 00 00 
  801cb8:	ff d0                	callq  *%rax
  801cba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801cbe:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cc5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801cca:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801ccd:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801cd0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cd4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801cd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cdc:	45 89 c1             	mov    %r8d,%r9d
  801cdf:	41 89 f8             	mov    %edi,%r8d
  801ce2:	48 89 c7             	mov    %rax,%rdi
  801ce5:	48 b8 3b 15 80 00 00 	movabs $0x80153b,%rax
  801cec:	00 00 00 
  801cef:	ff d0                	callq  *%rax
			break;
  801cf1:	eb 3f                	jmp    801d32 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cf3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cfb:	48 89 d6             	mov    %rdx,%rsi
  801cfe:	89 df                	mov    %ebx,%edi
  801d00:	ff d0                	callq  *%rax
			break;
  801d02:	eb 2e                	jmp    801d32 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d0c:	48 89 d6             	mov    %rdx,%rsi
  801d0f:	bf 25 00 00 00       	mov    $0x25,%edi
  801d14:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d16:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d1b:	eb 05                	jmp    801d22 <vprintfmt+0x50c>
  801d1d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d22:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801d26:	48 83 e8 01          	sub    $0x1,%rax
  801d2a:	0f b6 00             	movzbl (%rax),%eax
  801d2d:	3c 25                	cmp    $0x25,%al
  801d2f:	75 ec                	jne    801d1d <vprintfmt+0x507>
				/* do nothing */;
			break;
  801d31:	90                   	nop
		}
	}
  801d32:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d33:	e9 30 fb ff ff       	jmpq   801868 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801d38:	48 83 c4 60          	add    $0x60,%rsp
  801d3c:	5b                   	pop    %rbx
  801d3d:	41 5c                	pop    %r12
  801d3f:	5d                   	pop    %rbp
  801d40:	c3                   	retq   

0000000000801d41 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d4c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d53:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d5a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d61:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d68:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d6f:	84 c0                	test   %al,%al
  801d71:	74 20                	je     801d93 <printfmt+0x52>
  801d73:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d77:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801d7b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801d7f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801d83:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801d87:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801d8b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801d8f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801d93:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d9a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801da1:	00 00 00 
  801da4:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801dab:	00 00 00 
  801dae:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801db2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801db9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801dc0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801dc7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801dce:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801dd5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801ddc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801de3:	48 89 c7             	mov    %rax,%rdi
  801de6:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801ded:	00 00 00 
  801df0:	ff d0                	callq  *%rax
	va_end(ap);
}
  801df2:	c9                   	leaveq 
  801df3:	c3                   	retq   

0000000000801df4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801df4:	55                   	push   %rbp
  801df5:	48 89 e5             	mov    %rsp,%rbp
  801df8:	48 83 ec 10          	sub    $0x10,%rsp
  801dfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e07:	8b 40 10             	mov    0x10(%rax),%eax
  801e0a:	8d 50 01             	lea    0x1(%rax),%edx
  801e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e11:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e18:	48 8b 10             	mov    (%rax),%rdx
  801e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e1f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e23:	48 39 c2             	cmp    %rax,%rdx
  801e26:	73 17                	jae    801e3f <sprintputch+0x4b>
		*b->buf++ = ch;
  801e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2c:	48 8b 00             	mov    (%rax),%rax
  801e2f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801e33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e37:	48 89 0a             	mov    %rcx,(%rdx)
  801e3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e3d:	88 10                	mov    %dl,(%rax)
}
  801e3f:	c9                   	leaveq 
  801e40:	c3                   	retq   

0000000000801e41 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e41:	55                   	push   %rbp
  801e42:	48 89 e5             	mov    %rsp,%rbp
  801e45:	48 83 ec 50          	sub    $0x50,%rsp
  801e49:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e4d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e50:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e54:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e58:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e5c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e60:	48 8b 0a             	mov    (%rdx),%rcx
  801e63:	48 89 08             	mov    %rcx,(%rax)
  801e66:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e6a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e6e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e72:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e76:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e7a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801e7e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801e81:	48 98                	cltq   
  801e83:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e8b:	48 01 d0             	add    %rdx,%rax
  801e8e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801e92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801e99:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801e9e:	74 06                	je     801ea6 <vsnprintf+0x65>
  801ea0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801ea4:	7f 07                	jg     801ead <vsnprintf+0x6c>
		return -E_INVAL;
  801ea6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eab:	eb 2f                	jmp    801edc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801ead:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801eb1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801eb5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801eb9:	48 89 c6             	mov    %rax,%rsi
  801ebc:	48 bf f4 1d 80 00 00 	movabs $0x801df4,%rdi
  801ec3:	00 00 00 
  801ec6:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  801ecd:	00 00 00 
  801ed0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801ed2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ed6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801ed9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ee9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801ef0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801ef6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801efd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801f04:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801f0b:	84 c0                	test   %al,%al
  801f0d:	74 20                	je     801f2f <snprintf+0x51>
  801f0f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801f13:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801f17:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f1b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f1f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f23:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f27:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f2b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f2f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801f36:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801f3d:	00 00 00 
  801f40:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f47:	00 00 00 
  801f4a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f4e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f55:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f5c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f63:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f6a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f71:	48 8b 0a             	mov    (%rdx),%rcx
  801f74:	48 89 08             	mov    %rcx,(%rax)
  801f77:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f7b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f7f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f83:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801f87:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801f8e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801f95:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801f9b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801fa2:	48 89 c7             	mov    %rax,%rdi
  801fa5:	48 b8 41 1e 80 00 00 	movabs $0x801e41,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax
  801fb1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801fb7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801fbd:	c9                   	leaveq 
  801fbe:	c3                   	retq   

0000000000801fbf <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801fbf:	55                   	push   %rbp
  801fc0:	48 89 e5             	mov    %rsp,%rbp
  801fc3:	48 83 ec 20          	sub    $0x20,%rsp
  801fc7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801fcb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fd0:	74 27                	je     801ff9 <readline+0x3a>
		fprintf(1, "%s", prompt);
  801fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd6:	48 89 c2             	mov    %rax,%rdx
  801fd9:	48 be 28 65 80 00 00 	movabs $0x806528,%rsi
  801fe0:	00 00 00 
  801fe3:	bf 01 00 00 00       	mov    $0x1,%edi
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	48 b9 ef 47 80 00 00 	movabs $0x8047ef,%rcx
  801ff4:	00 00 00 
  801ff7:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  802000:	bf 00 00 00 00       	mov    $0x0,%edi
  802005:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  802014:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	callq  *%rax
  802020:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  802023:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802027:	79 30                	jns    802059 <readline+0x9a>
			if (c != -E_EOF)
  802029:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  80202d:	74 20                	je     80204f <readline+0x90>
				cprintf("read error: %e\n", c);
  80202f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802032:	89 c6                	mov    %eax,%esi
  802034:	48 bf 2b 65 80 00 00 	movabs $0x80652b,%rdi
  80203b:	00 00 00 
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  80204a:	00 00 00 
  80204d:	ff d2                	callq  *%rdx
			return NULL;
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	e9 be 00 00 00       	jmpq   802117 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802059:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80205d:	74 06                	je     802065 <readline+0xa6>
  80205f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802063:	75 26                	jne    80208b <readline+0xcc>
  802065:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802069:	7e 20                	jle    80208b <readline+0xcc>
			if (echoing)
  80206b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80206f:	74 11                	je     802082 <readline+0xc3>
				cputchar('\b');
  802071:	bf 08 00 00 00       	mov    $0x8,%edi
  802076:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  80207d:	00 00 00 
  802080:	ff d0                	callq  *%rax
			i--;
  802082:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802086:	e9 87 00 00 00       	jmpq   802112 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80208b:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  80208f:	7e 3f                	jle    8020d0 <readline+0x111>
  802091:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  802098:	7f 36                	jg     8020d0 <readline+0x111>
			if (echoing)
  80209a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80209e:	74 11                	je     8020b1 <readline+0xf2>
				cputchar(c);
  8020a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020a3:	89 c7                	mov    %eax,%edi
  8020a5:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
			buf[i++] = c;
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b4:	8d 50 01             	lea    0x1(%rax),%edx
  8020b7:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8020ba:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8020bd:	89 d1                	mov    %edx,%ecx
  8020bf:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8020c6:	00 00 00 
  8020c9:	48 98                	cltq   
  8020cb:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8020ce:	eb 42                	jmp    802112 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8020d0:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8020d4:	74 06                	je     8020dc <readline+0x11d>
  8020d6:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8020da:	75 36                	jne    802112 <readline+0x153>
			if (echoing)
  8020dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020e0:	74 11                	je     8020f3 <readline+0x134>
				cputchar('\n');
  8020e2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020e7:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax
			buf[i] = 0;
  8020f3:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8020fa:	00 00 00 
  8020fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802100:	48 98                	cltq   
  802102:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  802106:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80210d:	00 00 00 
  802110:	eb 05                	jmp    802117 <readline+0x158>
		}
	}
  802112:	e9 fd fe ff ff       	jmpq   802014 <readline+0x55>
}
  802117:	c9                   	leaveq 
  802118:	c3                   	retq   

0000000000802119 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802119:	55                   	push   %rbp
  80211a:	48 89 e5             	mov    %rsp,%rbp
  80211d:	48 83 ec 18          	sub    $0x18,%rsp
  802121:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212c:	eb 09                	jmp    802137 <strlen+0x1e>
		n++;
  80212e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802132:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213b:	0f b6 00             	movzbl (%rax),%eax
  80213e:	84 c0                	test   %al,%al
  802140:	75 ec                	jne    80212e <strlen+0x15>
		n++;
	return n;
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802145:	c9                   	leaveq 
  802146:	c3                   	retq   

0000000000802147 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802147:	55                   	push   %rbp
  802148:	48 89 e5             	mov    %rsp,%rbp
  80214b:	48 83 ec 20          	sub    $0x20,%rsp
  80214f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80215e:	eb 0e                	jmp    80216e <strnlen+0x27>
		n++;
  802160:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802164:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802169:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80216e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802173:	74 0b                	je     802180 <strnlen+0x39>
  802175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802179:	0f b6 00             	movzbl (%rax),%eax
  80217c:	84 c0                	test   %al,%al
  80217e:	75 e0                	jne    802160 <strnlen+0x19>
		n++;
	return n;
  802180:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802183:	c9                   	leaveq 
  802184:	c3                   	retq   

0000000000802185 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802185:	55                   	push   %rbp
  802186:	48 89 e5             	mov    %rsp,%rbp
  802189:	48 83 ec 20          	sub    $0x20,%rsp
  80218d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802191:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802199:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80219d:	90                   	nop
  80219e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021ae:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8021b2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8021b6:	0f b6 12             	movzbl (%rdx),%edx
  8021b9:	88 10                	mov    %dl,(%rax)
  8021bb:	0f b6 00             	movzbl (%rax),%eax
  8021be:	84 c0                	test   %al,%al
  8021c0:	75 dc                	jne    80219e <strcpy+0x19>
		/* do nothing */;
	return ret;
  8021c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021c6:	c9                   	leaveq 
  8021c7:	c3                   	retq   

00000000008021c8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021c8:	55                   	push   %rbp
  8021c9:	48 89 e5             	mov    %rsp,%rbp
  8021cc:	48 83 ec 20          	sub    $0x20,%rsp
  8021d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8021d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021dc:	48 89 c7             	mov    %rax,%rdi
  8021df:	48 b8 19 21 80 00 00 	movabs $0x802119,%rax
  8021e6:	00 00 00 
  8021e9:	ff d0                	callq  *%rax
  8021eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8021ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f1:	48 63 d0             	movslq %eax,%rdx
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	48 01 c2             	add    %rax,%rdx
  8021fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ff:	48 89 c6             	mov    %rax,%rsi
  802202:	48 89 d7             	mov    %rdx,%rdi
  802205:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax
	return dst;
  802211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802215:	c9                   	leaveq 
  802216:	c3                   	retq   

0000000000802217 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802217:	55                   	push   %rbp
  802218:	48 89 e5             	mov    %rsp,%rbp
  80221b:	48 83 ec 28          	sub    $0x28,%rsp
  80221f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802223:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802227:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80222b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802233:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80223a:	00 
  80223b:	eb 2a                	jmp    802267 <strncpy+0x50>
		*dst++ = *src;
  80223d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802241:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802245:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802249:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80224d:	0f b6 12             	movzbl (%rdx),%edx
  802250:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802252:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802256:	0f b6 00             	movzbl (%rax),%eax
  802259:	84 c0                	test   %al,%al
  80225b:	74 05                	je     802262 <strncpy+0x4b>
			src++;
  80225d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802262:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80226b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80226f:	72 cc                	jb     80223d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802275:	c9                   	leaveq 
  802276:	c3                   	retq   

0000000000802277 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802277:	55                   	push   %rbp
  802278:	48 89 e5             	mov    %rsp,%rbp
  80227b:	48 83 ec 28          	sub    $0x28,%rsp
  80227f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802283:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802287:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80228b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802293:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802298:	74 3d                	je     8022d7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80229a:	eb 1d                	jmp    8022b9 <strlcpy+0x42>
			*dst++ = *src++;
  80229c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8022a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8022a8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8022b0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8022b4:	0f b6 12             	movzbl (%rdx),%edx
  8022b7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022b9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8022be:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022c3:	74 0b                	je     8022d0 <strlcpy+0x59>
  8022c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c9:	0f b6 00             	movzbl (%rax),%eax
  8022cc:	84 c0                	test   %al,%al
  8022ce:	75 cc                	jne    80229c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8022d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8022d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022df:	48 29 c2             	sub    %rax,%rdx
  8022e2:	48 89 d0             	mov    %rdx,%rax
}
  8022e5:	c9                   	leaveq 
  8022e6:	c3                   	retq   

00000000008022e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022e7:	55                   	push   %rbp
  8022e8:	48 89 e5             	mov    %rsp,%rbp
  8022eb:	48 83 ec 10          	sub    $0x10,%rsp
  8022ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8022f7:	eb 0a                	jmp    802303 <strcmp+0x1c>
		p++, q++;
  8022f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022fe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802307:	0f b6 00             	movzbl (%rax),%eax
  80230a:	84 c0                	test   %al,%al
  80230c:	74 12                	je     802320 <strcmp+0x39>
  80230e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802312:	0f b6 10             	movzbl (%rax),%edx
  802315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802319:	0f b6 00             	movzbl (%rax),%eax
  80231c:	38 c2                	cmp    %al,%dl
  80231e:	74 d9                	je     8022f9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802324:	0f b6 00             	movzbl (%rax),%eax
  802327:	0f b6 d0             	movzbl %al,%edx
  80232a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232e:	0f b6 00             	movzbl (%rax),%eax
  802331:	0f b6 c0             	movzbl %al,%eax
  802334:	29 c2                	sub    %eax,%edx
  802336:	89 d0                	mov    %edx,%eax
}
  802338:	c9                   	leaveq 
  802339:	c3                   	retq   

000000000080233a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80233a:	55                   	push   %rbp
  80233b:	48 89 e5             	mov    %rsp,%rbp
  80233e:	48 83 ec 18          	sub    $0x18,%rsp
  802342:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80234a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80234e:	eb 0f                	jmp    80235f <strncmp+0x25>
		n--, p++, q++;
  802350:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802355:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80235a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80235f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802364:	74 1d                	je     802383 <strncmp+0x49>
  802366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80236a:	0f b6 00             	movzbl (%rax),%eax
  80236d:	84 c0                	test   %al,%al
  80236f:	74 12                	je     802383 <strncmp+0x49>
  802371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802375:	0f b6 10             	movzbl (%rax),%edx
  802378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237c:	0f b6 00             	movzbl (%rax),%eax
  80237f:	38 c2                	cmp    %al,%dl
  802381:	74 cd                	je     802350 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802383:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802388:	75 07                	jne    802391 <strncmp+0x57>
		return 0;
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
  80238f:	eb 18                	jmp    8023a9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802395:	0f b6 00             	movzbl (%rax),%eax
  802398:	0f b6 d0             	movzbl %al,%edx
  80239b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239f:	0f b6 00             	movzbl (%rax),%eax
  8023a2:	0f b6 c0             	movzbl %al,%eax
  8023a5:	29 c2                	sub    %eax,%edx
  8023a7:	89 d0                	mov    %edx,%eax
}
  8023a9:	c9                   	leaveq 
  8023aa:	c3                   	retq   

00000000008023ab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
  8023af:	48 83 ec 0c          	sub    $0xc,%rsp
  8023b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023bc:	eb 17                	jmp    8023d5 <strchr+0x2a>
		if (*s == c)
  8023be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c2:	0f b6 00             	movzbl (%rax),%eax
  8023c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023c8:	75 06                	jne    8023d0 <strchr+0x25>
			return (char *) s;
  8023ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ce:	eb 15                	jmp    8023e5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023d0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d9:	0f b6 00             	movzbl (%rax),%eax
  8023dc:	84 c0                	test   %al,%al
  8023de:	75 de                	jne    8023be <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e5:	c9                   	leaveq 
  8023e6:	c3                   	retq   

00000000008023e7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023e7:	55                   	push   %rbp
  8023e8:	48 89 e5             	mov    %rsp,%rbp
  8023eb:	48 83 ec 0c          	sub    $0xc,%rsp
  8023ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023f3:	89 f0                	mov    %esi,%eax
  8023f5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023f8:	eb 13                	jmp    80240d <strfind+0x26>
		if (*s == c)
  8023fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fe:	0f b6 00             	movzbl (%rax),%eax
  802401:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802404:	75 02                	jne    802408 <strfind+0x21>
			break;
  802406:	eb 10                	jmp    802418 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802408:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80240d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802411:	0f b6 00             	movzbl (%rax),%eax
  802414:	84 c0                	test   %al,%al
  802416:	75 e2                	jne    8023fa <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80241c:	c9                   	leaveq 
  80241d:	c3                   	retq   

000000000080241e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80241e:	55                   	push   %rbp
  80241f:	48 89 e5             	mov    %rsp,%rbp
  802422:	48 83 ec 18          	sub    $0x18,%rsp
  802426:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80242a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80242d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802431:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802436:	75 06                	jne    80243e <memset+0x20>
		return v;
  802438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243c:	eb 69                	jmp    8024a7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80243e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802442:	83 e0 03             	and    $0x3,%eax
  802445:	48 85 c0             	test   %rax,%rax
  802448:	75 48                	jne    802492 <memset+0x74>
  80244a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244e:	83 e0 03             	and    $0x3,%eax
  802451:	48 85 c0             	test   %rax,%rax
  802454:	75 3c                	jne    802492 <memset+0x74>
		c &= 0xFF;
  802456:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80245d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802460:	c1 e0 18             	shl    $0x18,%eax
  802463:	89 c2                	mov    %eax,%edx
  802465:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802468:	c1 e0 10             	shl    $0x10,%eax
  80246b:	09 c2                	or     %eax,%edx
  80246d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802470:	c1 e0 08             	shl    $0x8,%eax
  802473:	09 d0                	or     %edx,%eax
  802475:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247c:	48 c1 e8 02          	shr    $0x2,%rax
  802480:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802483:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802487:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80248a:	48 89 d7             	mov    %rdx,%rdi
  80248d:	fc                   	cld    
  80248e:	f3 ab                	rep stos %eax,%es:(%rdi)
  802490:	eb 11                	jmp    8024a3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802492:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802496:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802499:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80249d:	48 89 d7             	mov    %rdx,%rdi
  8024a0:	fc                   	cld    
  8024a1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8024a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	48 83 ec 28          	sub    $0x28,%rsp
  8024b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8024bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8024c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8024cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024d5:	0f 83 88 00 00 00    	jae    802563 <memmove+0xba>
  8024db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024e3:	48 01 d0             	add    %rdx,%rax
  8024e6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024ea:	76 77                	jbe    802563 <memmove+0xba>
		s += n;
  8024ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024f0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8024f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024f8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8024fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802500:	83 e0 03             	and    $0x3,%eax
  802503:	48 85 c0             	test   %rax,%rax
  802506:	75 3b                	jne    802543 <memmove+0x9a>
  802508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250c:	83 e0 03             	and    $0x3,%eax
  80250f:	48 85 c0             	test   %rax,%rax
  802512:	75 2f                	jne    802543 <memmove+0x9a>
  802514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802518:	83 e0 03             	and    $0x3,%eax
  80251b:	48 85 c0             	test   %rax,%rax
  80251e:	75 23                	jne    802543 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802524:	48 83 e8 04          	sub    $0x4,%rax
  802528:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80252c:	48 83 ea 04          	sub    $0x4,%rdx
  802530:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802534:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802538:	48 89 c7             	mov    %rax,%rdi
  80253b:	48 89 d6             	mov    %rdx,%rsi
  80253e:	fd                   	std    
  80253f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802541:	eb 1d                	jmp    802560 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802547:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80254b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802557:	48 89 d7             	mov    %rdx,%rdi
  80255a:	48 89 c1             	mov    %rax,%rcx
  80255d:	fd                   	std    
  80255e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802560:	fc                   	cld    
  802561:	eb 57                	jmp    8025ba <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802567:	83 e0 03             	and    $0x3,%eax
  80256a:	48 85 c0             	test   %rax,%rax
  80256d:	75 36                	jne    8025a5 <memmove+0xfc>
  80256f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802573:	83 e0 03             	and    $0x3,%eax
  802576:	48 85 c0             	test   %rax,%rax
  802579:	75 2a                	jne    8025a5 <memmove+0xfc>
  80257b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80257f:	83 e0 03             	and    $0x3,%eax
  802582:	48 85 c0             	test   %rax,%rax
  802585:	75 1e                	jne    8025a5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258b:	48 c1 e8 02          	shr    $0x2,%rax
  80258f:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802596:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80259a:	48 89 c7             	mov    %rax,%rdi
  80259d:	48 89 d6             	mov    %rdx,%rsi
  8025a0:	fc                   	cld    
  8025a1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8025a3:	eb 15                	jmp    8025ba <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8025a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ad:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8025b1:	48 89 c7             	mov    %rax,%rdi
  8025b4:	48 89 d6             	mov    %rdx,%rsi
  8025b7:	fc                   	cld    
  8025b8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8025ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8025be:	c9                   	leaveq 
  8025bf:	c3                   	retq   

00000000008025c0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025c0:	55                   	push   %rbp
  8025c1:	48 89 e5             	mov    %rsp,%rbp
  8025c4:	48 83 ec 18          	sub    $0x18,%rsp
  8025c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8025d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e0:	48 89 ce             	mov    %rcx,%rsi
  8025e3:	48 89 c7             	mov    %rax,%rdi
  8025e6:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
}
  8025f2:	c9                   	leaveq 
  8025f3:	c3                   	retq   

00000000008025f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 28          	sub    $0x28,%rsp
  8025fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802600:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802604:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802610:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802614:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802618:	eb 36                	jmp    802650 <memcmp+0x5c>
		if (*s1 != *s2)
  80261a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261e:	0f b6 10             	movzbl (%rax),%edx
  802621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802625:	0f b6 00             	movzbl (%rax),%eax
  802628:	38 c2                	cmp    %al,%dl
  80262a:	74 1a                	je     802646 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80262c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802630:	0f b6 00             	movzbl (%rax),%eax
  802633:	0f b6 d0             	movzbl %al,%edx
  802636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263a:	0f b6 00             	movzbl (%rax),%eax
  80263d:	0f b6 c0             	movzbl %al,%eax
  802640:	29 c2                	sub    %eax,%edx
  802642:	89 d0                	mov    %edx,%eax
  802644:	eb 20                	jmp    802666 <memcmp+0x72>
		s1++, s2++;
  802646:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80264b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802654:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802658:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80265c:	48 85 c0             	test   %rax,%rax
  80265f:	75 b9                	jne    80261a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802666:	c9                   	leaveq 
  802667:	c3                   	retq   

0000000000802668 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802668:	55                   	push   %rbp
  802669:	48 89 e5             	mov    %rsp,%rbp
  80266c:	48 83 ec 28          	sub    $0x28,%rsp
  802670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802674:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802677:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80267b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80267f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802683:	48 01 d0             	add    %rdx,%rax
  802686:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80268a:	eb 15                	jmp    8026a1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80268c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802690:	0f b6 10             	movzbl (%rax),%edx
  802693:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802696:	38 c2                	cmp    %al,%dl
  802698:	75 02                	jne    80269c <memfind+0x34>
			break;
  80269a:	eb 0f                	jmp    8026ab <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80269c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8026a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8026a9:	72 e1                	jb     80268c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8026ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8026af:	c9                   	leaveq 
  8026b0:	c3                   	retq   

00000000008026b1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8026b1:	55                   	push   %rbp
  8026b2:	48 89 e5             	mov    %rsp,%rbp
  8026b5:	48 83 ec 34          	sub    $0x34,%rsp
  8026b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026c1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8026c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8026cb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8026d2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026d3:	eb 05                	jmp    8026da <strtol+0x29>
		s++;
  8026d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026de:	0f b6 00             	movzbl (%rax),%eax
  8026e1:	3c 20                	cmp    $0x20,%al
  8026e3:	74 f0                	je     8026d5 <strtol+0x24>
  8026e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e9:	0f b6 00             	movzbl (%rax),%eax
  8026ec:	3c 09                	cmp    $0x9,%al
  8026ee:	74 e5                	je     8026d5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f4:	0f b6 00             	movzbl (%rax),%eax
  8026f7:	3c 2b                	cmp    $0x2b,%al
  8026f9:	75 07                	jne    802702 <strtol+0x51>
		s++;
  8026fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802700:	eb 17                	jmp    802719 <strtol+0x68>
	else if (*s == '-')
  802702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802706:	0f b6 00             	movzbl (%rax),%eax
  802709:	3c 2d                	cmp    $0x2d,%al
  80270b:	75 0c                	jne    802719 <strtol+0x68>
		s++, neg = 1;
  80270d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802712:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802719:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80271d:	74 06                	je     802725 <strtol+0x74>
  80271f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802723:	75 28                	jne    80274d <strtol+0x9c>
  802725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802729:	0f b6 00             	movzbl (%rax),%eax
  80272c:	3c 30                	cmp    $0x30,%al
  80272e:	75 1d                	jne    80274d <strtol+0x9c>
  802730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802734:	48 83 c0 01          	add    $0x1,%rax
  802738:	0f b6 00             	movzbl (%rax),%eax
  80273b:	3c 78                	cmp    $0x78,%al
  80273d:	75 0e                	jne    80274d <strtol+0x9c>
		s += 2, base = 16;
  80273f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802744:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80274b:	eb 2c                	jmp    802779 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80274d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802751:	75 19                	jne    80276c <strtol+0xbb>
  802753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802757:	0f b6 00             	movzbl (%rax),%eax
  80275a:	3c 30                	cmp    $0x30,%al
  80275c:	75 0e                	jne    80276c <strtol+0xbb>
		s++, base = 8;
  80275e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802763:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80276a:	eb 0d                	jmp    802779 <strtol+0xc8>
	else if (base == 0)
  80276c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802770:	75 07                	jne    802779 <strtol+0xc8>
		base = 10;
  802772:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277d:	0f b6 00             	movzbl (%rax),%eax
  802780:	3c 2f                	cmp    $0x2f,%al
  802782:	7e 1d                	jle    8027a1 <strtol+0xf0>
  802784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802788:	0f b6 00             	movzbl (%rax),%eax
  80278b:	3c 39                	cmp    $0x39,%al
  80278d:	7f 12                	jg     8027a1 <strtol+0xf0>
			dig = *s - '0';
  80278f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802793:	0f b6 00             	movzbl (%rax),%eax
  802796:	0f be c0             	movsbl %al,%eax
  802799:	83 e8 30             	sub    $0x30,%eax
  80279c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80279f:	eb 4e                	jmp    8027ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8027a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a5:	0f b6 00             	movzbl (%rax),%eax
  8027a8:	3c 60                	cmp    $0x60,%al
  8027aa:	7e 1d                	jle    8027c9 <strtol+0x118>
  8027ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b0:	0f b6 00             	movzbl (%rax),%eax
  8027b3:	3c 7a                	cmp    $0x7a,%al
  8027b5:	7f 12                	jg     8027c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8027b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bb:	0f b6 00             	movzbl (%rax),%eax
  8027be:	0f be c0             	movsbl %al,%eax
  8027c1:	83 e8 57             	sub    $0x57,%eax
  8027c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027c7:	eb 26                	jmp    8027ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8027c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027cd:	0f b6 00             	movzbl (%rax),%eax
  8027d0:	3c 40                	cmp    $0x40,%al
  8027d2:	7e 48                	jle    80281c <strtol+0x16b>
  8027d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d8:	0f b6 00             	movzbl (%rax),%eax
  8027db:	3c 5a                	cmp    $0x5a,%al
  8027dd:	7f 3d                	jg     80281c <strtol+0x16b>
			dig = *s - 'A' + 10;
  8027df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e3:	0f b6 00             	movzbl (%rax),%eax
  8027e6:	0f be c0             	movsbl %al,%eax
  8027e9:	83 e8 37             	sub    $0x37,%eax
  8027ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8027ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8027f5:	7c 02                	jl     8027f9 <strtol+0x148>
			break;
  8027f7:	eb 23                	jmp    80281c <strtol+0x16b>
		s++, val = (val * base) + dig;
  8027f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027fe:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802801:	48 98                	cltq   
  802803:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802808:	48 89 c2             	mov    %rax,%rdx
  80280b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80280e:	48 98                	cltq   
  802810:	48 01 d0             	add    %rdx,%rax
  802813:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802817:	e9 5d ff ff ff       	jmpq   802779 <strtol+0xc8>

	if (endptr)
  80281c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802821:	74 0b                	je     80282e <strtol+0x17d>
		*endptr = (char *) s;
  802823:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802827:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80282b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80282e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802832:	74 09                	je     80283d <strtol+0x18c>
  802834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802838:	48 f7 d8             	neg    %rax
  80283b:	eb 04                	jmp    802841 <strtol+0x190>
  80283d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802841:	c9                   	leaveq 
  802842:	c3                   	retq   

0000000000802843 <strstr>:

char * strstr(const char *in, const char *str)
{
  802843:	55                   	push   %rbp
  802844:	48 89 e5             	mov    %rsp,%rbp
  802847:	48 83 ec 30          	sub    $0x30,%rsp
  80284b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80284f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  802853:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802857:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80285b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80285f:	0f b6 00             	movzbl (%rax),%eax
  802862:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802865:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802869:	75 06                	jne    802871 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80286b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286f:	eb 6b                	jmp    8028dc <strstr+0x99>

	len = strlen(str);
  802871:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802875:	48 89 c7             	mov    %rax,%rdi
  802878:	48 b8 19 21 80 00 00 	movabs $0x802119,%rax
  80287f:	00 00 00 
  802882:	ff d0                	callq  *%rax
  802884:	48 98                	cltq   
  802886:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80288a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802892:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802896:	0f b6 00             	movzbl (%rax),%eax
  802899:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80289c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8028a0:	75 07                	jne    8028a9 <strstr+0x66>
				return (char *) 0;
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a7:	eb 33                	jmp    8028dc <strstr+0x99>
		} while (sc != c);
  8028a9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8028ad:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8028b0:	75 d8                	jne    80288a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8028b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028be:	48 89 ce             	mov    %rcx,%rsi
  8028c1:	48 89 c7             	mov    %rax,%rdi
  8028c4:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	75 b6                	jne    80288a <strstr+0x47>

	return (char *) (in - 1);
  8028d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d8:	48 83 e8 01          	sub    $0x1,%rax
}
  8028dc:	c9                   	leaveq 
  8028dd:	c3                   	retq   

00000000008028de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8028de:	55                   	push   %rbp
  8028df:	48 89 e5             	mov    %rsp,%rbp
  8028e2:	53                   	push   %rbx
  8028e3:	48 83 ec 48          	sub    $0x48,%rsp
  8028e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8028ed:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028f1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8028f5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8028f9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802900:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802904:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802908:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80290c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802910:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802914:	4c 89 c3             	mov    %r8,%rbx
  802917:	cd 30                	int    $0x30
  802919:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80291d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802921:	74 3e                	je     802961 <syscall+0x83>
  802923:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802928:	7e 37                	jle    802961 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80292a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80292e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802931:	49 89 d0             	mov    %rdx,%r8
  802934:	89 c1                	mov    %eax,%ecx
  802936:	48 ba 3b 65 80 00 00 	movabs $0x80653b,%rdx
  80293d:	00 00 00 
  802940:	be 23 00 00 00       	mov    $0x23,%esi
  802945:	48 bf 58 65 80 00 00 	movabs $0x806558,%rdi
  80294c:	00 00 00 
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	49 b9 2a 12 80 00 00 	movabs $0x80122a,%r9
  80295b:	00 00 00 
  80295e:	41 ff d1             	callq  *%r9

	return ret;
  802961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802965:	48 83 c4 48          	add    $0x48,%rsp
  802969:	5b                   	pop    %rbx
  80296a:	5d                   	pop    %rbp
  80296b:	c3                   	retq   

000000000080296c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80296c:	55                   	push   %rbp
  80296d:	48 89 e5             	mov    %rsp,%rbp
  802970:	48 83 ec 20          	sub    $0x20,%rsp
  802974:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802978:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80297c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802980:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802984:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80298b:	00 
  80298c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802992:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802998:	48 89 d1             	mov    %rdx,%rcx
  80299b:	48 89 c2             	mov    %rax,%rdx
  80299e:	be 00 00 00 00       	mov    $0x0,%esi
  8029a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a8:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
}
  8029b4:	c9                   	leaveq 
  8029b5:	c3                   	retq   

00000000008029b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
  8029ba:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8029be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029c5:	00 
  8029c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029dc:	be 00 00 00 00       	mov    $0x0,%esi
  8029e1:	bf 01 00 00 00       	mov    $0x1,%edi
  8029e6:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
}
  8029f2:	c9                   	leaveq 
  8029f3:	c3                   	retq   

00000000008029f4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8029f4:	55                   	push   %rbp
  8029f5:	48 89 e5             	mov    %rsp,%rbp
  8029f8:	48 83 ec 10          	sub    $0x10,%rsp
  8029fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8029ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a02:	48 98                	cltq   
  802a04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a0b:	00 
  802a0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a18:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a1d:	48 89 c2             	mov    %rax,%rdx
  802a20:	be 01 00 00 00       	mov    $0x1,%esi
  802a25:	bf 03 00 00 00       	mov    $0x3,%edi
  802a2a:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
}
  802a36:	c9                   	leaveq 
  802a37:	c3                   	retq   

0000000000802a38 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802a38:	55                   	push   %rbp
  802a39:	48 89 e5             	mov    %rsp,%rbp
  802a3c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802a40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a47:	00 
  802a48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a54:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a59:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5e:	be 00 00 00 00       	mov    $0x0,%esi
  802a63:	bf 02 00 00 00       	mov    $0x2,%edi
  802a68:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802a6f:	00 00 00 
  802a72:	ff d0                	callq  *%rax
}
  802a74:	c9                   	leaveq 
  802a75:	c3                   	retq   

0000000000802a76 <sys_yield>:

void
sys_yield(void)
{
  802a76:	55                   	push   %rbp
  802a77:	48 89 e5             	mov    %rsp,%rbp
  802a7a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802a7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a85:	00 
  802a86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a92:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a97:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9c:	be 00 00 00 00       	mov    $0x0,%esi
  802aa1:	bf 0b 00 00 00       	mov    $0xb,%edi
  802aa6:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	callq  *%rax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 83 ec 20          	sub    $0x20,%rsp
  802abc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802abf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ac3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802ac6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ac9:	48 63 c8             	movslq %eax,%rcx
  802acc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad3:	48 98                	cltq   
  802ad5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802adc:	00 
  802add:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ae3:	49 89 c8             	mov    %rcx,%r8
  802ae6:	48 89 d1             	mov    %rdx,%rcx
  802ae9:	48 89 c2             	mov    %rax,%rdx
  802aec:	be 01 00 00 00       	mov    $0x1,%esi
  802af1:	bf 04 00 00 00       	mov    $0x4,%edi
  802af6:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
}
  802b02:	c9                   	leaveq 
  802b03:	c3                   	retq   

0000000000802b04 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802b04:	55                   	push   %rbp
  802b05:	48 89 e5             	mov    %rsp,%rbp
  802b08:	48 83 ec 30          	sub    $0x30,%rsp
  802b0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b13:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802b16:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b1a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802b1e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b21:	48 63 c8             	movslq %eax,%rcx
  802b24:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802b28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b2b:	48 63 f0             	movslq %eax,%rsi
  802b2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b35:	48 98                	cltq   
  802b37:	48 89 0c 24          	mov    %rcx,(%rsp)
  802b3b:	49 89 f9             	mov    %rdi,%r9
  802b3e:	49 89 f0             	mov    %rsi,%r8
  802b41:	48 89 d1             	mov    %rdx,%rcx
  802b44:	48 89 c2             	mov    %rax,%rdx
  802b47:	be 01 00 00 00       	mov    $0x1,%esi
  802b4c:	bf 05 00 00 00       	mov    $0x5,%edi
  802b51:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
}
  802b5d:	c9                   	leaveq 
  802b5e:	c3                   	retq   

0000000000802b5f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b5f:	55                   	push   %rbp
  802b60:	48 89 e5             	mov    %rsp,%rbp
  802b63:	48 83 ec 20          	sub    $0x20,%rsp
  802b67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802b6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b75:	48 98                	cltq   
  802b77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b7e:	00 
  802b7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b8b:	48 89 d1             	mov    %rdx,%rcx
  802b8e:	48 89 c2             	mov    %rax,%rdx
  802b91:	be 01 00 00 00       	mov    $0x1,%esi
  802b96:	bf 06 00 00 00       	mov    $0x6,%edi
  802b9b:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
}
  802ba7:	c9                   	leaveq 
  802ba8:	c3                   	retq   

0000000000802ba9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802ba9:	55                   	push   %rbp
  802baa:	48 89 e5             	mov    %rsp,%rbp
  802bad:	48 83 ec 10          	sub    $0x10,%rsp
  802bb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bb4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802bb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bba:	48 63 d0             	movslq %eax,%rdx
  802bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc0:	48 98                	cltq   
  802bc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bc9:	00 
  802bca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bd6:	48 89 d1             	mov    %rdx,%rcx
  802bd9:	48 89 c2             	mov    %rax,%rdx
  802bdc:	be 01 00 00 00       	mov    $0x1,%esi
  802be1:	bf 08 00 00 00       	mov    $0x8,%edi
  802be6:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	callq  *%rax
}
  802bf2:	c9                   	leaveq 
  802bf3:	c3                   	retq   

0000000000802bf4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802bf4:	55                   	push   %rbp
  802bf5:	48 89 e5             	mov    %rsp,%rbp
  802bf8:	48 83 ec 20          	sub    $0x20,%rsp
  802bfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0a:	48 98                	cltq   
  802c0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c13:	00 
  802c14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c20:	48 89 d1             	mov    %rdx,%rcx
  802c23:	48 89 c2             	mov    %rax,%rdx
  802c26:	be 01 00 00 00       	mov    $0x1,%esi
  802c2b:	bf 09 00 00 00       	mov    $0x9,%edi
  802c30:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802c37:	00 00 00 
  802c3a:	ff d0                	callq  *%rax
}
  802c3c:	c9                   	leaveq 
  802c3d:	c3                   	retq   

0000000000802c3e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802c3e:	55                   	push   %rbp
  802c3f:	48 89 e5             	mov    %rsp,%rbp
  802c42:	48 83 ec 20          	sub    $0x20,%rsp
  802c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c54:	48 98                	cltq   
  802c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c5d:	00 
  802c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c6a:	48 89 d1             	mov    %rdx,%rcx
  802c6d:	48 89 c2             	mov    %rax,%rdx
  802c70:	be 01 00 00 00       	mov    $0x1,%esi
  802c75:	bf 0a 00 00 00       	mov    $0xa,%edi
  802c7a:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
}
  802c86:	c9                   	leaveq 
  802c87:	c3                   	retq   

0000000000802c88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802c88:	55                   	push   %rbp
  802c89:	48 89 e5             	mov    %rsp,%rbp
  802c8c:	48 83 ec 20          	sub    $0x20,%rsp
  802c90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c9b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802c9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca1:	48 63 f0             	movslq %eax,%rsi
  802ca4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cab:	48 98                	cltq   
  802cad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cb8:	00 
  802cb9:	49 89 f1             	mov    %rsi,%r9
  802cbc:	49 89 c8             	mov    %rcx,%r8
  802cbf:	48 89 d1             	mov    %rdx,%rcx
  802cc2:	48 89 c2             	mov    %rax,%rdx
  802cc5:	be 00 00 00 00       	mov    $0x0,%esi
  802cca:	bf 0c 00 00 00       	mov    $0xc,%edi
  802ccf:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802cd6:	00 00 00 
  802cd9:	ff d0                	callq  *%rax
}
  802cdb:	c9                   	leaveq 
  802cdc:	c3                   	retq   

0000000000802cdd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802cdd:	55                   	push   %rbp
  802cde:	48 89 e5             	mov    %rsp,%rbp
  802ce1:	48 83 ec 10          	sub    $0x10,%rsp
  802ce5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802ce9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ced:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cf4:	00 
  802cf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d01:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d06:	48 89 c2             	mov    %rax,%rdx
  802d09:	be 01 00 00 00       	mov    $0x1,%esi
  802d0e:	bf 0d 00 00 00       	mov    $0xd,%edi
  802d13:	48 b8 de 28 80 00 00 	movabs $0x8028de,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
}
  802d1f:	c9                   	leaveq 
  802d20:	c3                   	retq   

0000000000802d21 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802d21:	55                   	push   %rbp
  802d22:	48 89 e5             	mov    %rsp,%rbp
  802d25:	48 83 ec 30          	sub    $0x30,%rsp
  802d29:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d31:	48 8b 00             	mov    (%rax),%rax
  802d34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d3c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802d40:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802d43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d46:	83 e0 02             	and    $0x2,%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	75 4d                	jne    802d9a <pgfault+0x79>
  802d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d51:	48 c1 e8 0c          	shr    $0xc,%rax
  802d55:	48 89 c2             	mov    %rax,%rdx
  802d58:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d5f:	01 00 00 
  802d62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d66:	25 00 08 00 00       	and    $0x800,%eax
  802d6b:	48 85 c0             	test   %rax,%rax
  802d6e:	74 2a                	je     802d9a <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  802d70:	48 ba 68 65 80 00 00 	movabs $0x806568,%rdx
  802d77:	00 00 00 
  802d7a:	be 1e 00 00 00       	mov    $0x1e,%esi
  802d7f:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  802d86:	00 00 00 
  802d89:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8e:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  802d95:	00 00 00 
  802d98:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  802d9a:	ba 07 00 00 00       	mov    $0x7,%edx
  802d9f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802da4:	bf 00 00 00 00       	mov    $0x0,%edi
  802da9:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	0f 85 cd 00 00 00    	jne    802e8a <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802dcf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802dd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd7:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ddc:	48 89 c6             	mov    %rax,%rsi
  802ddf:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802de4:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802df0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802dfa:	48 89 c1             	mov    %rax,%rcx
  802dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  802e02:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802e07:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0c:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802e13:	00 00 00 
  802e16:	ff d0                	callq  *%rax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	79 2a                	jns    802e46 <pgfault+0x125>
				panic("Page map at temp address failed");
  802e1c:	48 ba 98 65 80 00 00 	movabs $0x806598,%rdx
  802e23:	00 00 00 
  802e26:	be 2f 00 00 00       	mov    $0x2f,%esi
  802e2b:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  802e32:	00 00 00 
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  802e41:	00 00 00 
  802e44:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802e46:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802e4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e50:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  802e57:	00 00 00 
  802e5a:	ff d0                	callq  *%rax
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	79 54                	jns    802eb4 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802e60:	48 ba b8 65 80 00 00 	movabs $0x8065b8,%rdx
  802e67:	00 00 00 
  802e6a:	be 31 00 00 00       	mov    $0x31,%esi
  802e6f:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  802e76:	00 00 00 
  802e79:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7e:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  802e85:	00 00 00 
  802e88:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  802e8a:	48 ba e0 65 80 00 00 	movabs $0x8065e0,%rdx
  802e91:	00 00 00 
  802e94:	be 35 00 00 00       	mov    $0x35,%esi
  802e99:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  802ea0:	00 00 00 
  802ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea8:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  802eaf:	00 00 00 
  802eb2:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  802eb4:	c9                   	leaveq 
  802eb5:	c3                   	retq   

0000000000802eb6 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802eb6:	55                   	push   %rbp
  802eb7:	48 89 e5             	mov    %rsp,%rbp
  802eba:	48 83 ec 20          	sub    $0x20,%rsp
  802ebe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ec1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  802ec4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ecb:	01 00 00 
  802ece:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ed1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ed5:	25 07 0e 00 00       	and    $0xe07,%eax
  802eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802edd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ee0:	48 c1 e0 0c          	shl    $0xc,%rax
  802ee4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  802ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eeb:	25 00 04 00 00       	and    $0x400,%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 57                	je     802f4b <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  802ef4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ef7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802efb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f02:	41 89 f0             	mov    %esi,%r8d
  802f05:	48 89 c6             	mov    %rax,%rsi
  802f08:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0d:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	0f 8e 52 01 00 00    	jle    803073 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  802f21:	48 ba 0d 66 80 00 00 	movabs $0x80660d,%rdx
  802f28:	00 00 00 
  802f2b:	be 52 00 00 00       	mov    $0x52,%esi
  802f30:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  802f37:	00 00 00 
  802f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3f:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  802f46:	00 00 00 
  802f49:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  802f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4e:	83 e0 02             	and    $0x2,%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	75 10                	jne    802f65 <duppage+0xaf>
  802f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f58:	25 00 08 00 00       	and    $0x800,%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	0f 84 bb 00 00 00    	je     803020 <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  802f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f68:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802f6d:	80 cc 08             	or     $0x8,%ah
  802f70:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  802f73:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f76:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f7a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f81:	41 89 f0             	mov    %esi,%r8d
  802f84:	48 89 c6             	mov    %rax,%rsi
  802f87:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8c:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	7e 2a                	jle    802fc6 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  802f9c:	48 ba 0d 66 80 00 00 	movabs $0x80660d,%rdx
  802fa3:	00 00 00 
  802fa6:	be 5a 00 00 00       	mov    $0x5a,%esi
  802fab:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  802fb2:	00 00 00 
  802fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802fba:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  802fc1:	00 00 00 
  802fc4:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802fc6:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802fc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd1:	41 89 c8             	mov    %ecx,%r8d
  802fd4:	48 89 d1             	mov    %rdx,%rcx
  802fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  802fdc:	48 89 c6             	mov    %rax,%rsi
  802fdf:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe4:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	7e 2a                	jle    80301e <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  802ff4:	48 ba 0d 66 80 00 00 	movabs $0x80660d,%rdx
  802ffb:	00 00 00 
  802ffe:	be 5d 00 00 00       	mov    $0x5d,%esi
  803003:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  80300a:	00 00 00 
  80300d:	b8 00 00 00 00       	mov    $0x0,%eax
  803012:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  803019:	00 00 00 
  80301c:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  80301e:	eb 53                	jmp    803073 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  803020:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803023:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803027:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80302a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302e:	41 89 f0             	mov    %esi,%r8d
  803031:	48 89 c6             	mov    %rax,%rsi
  803034:	bf 00 00 00 00       	mov    $0x0,%edi
  803039:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	85 c0                	test   %eax,%eax
  803047:	7e 2a                	jle    803073 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  803049:	48 ba 0d 66 80 00 00 	movabs $0x80660d,%rdx
  803050:	00 00 00 
  803053:	be 61 00 00 00       	mov    $0x61,%esi
  803058:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  80305f:	00 00 00 
  803062:	b8 00 00 00 00       	mov    $0x0,%eax
  803067:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  80306e:	00 00 00 
  803071:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  803073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  803082:	48 bf 21 2d 80 00 00 	movabs $0x802d21,%rdi
  803089:	00 00 00 
  80308c:	48 b8 2d 5a 80 00 00 	movabs $0x805a2d,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803098:	b8 07 00 00 00       	mov    $0x7,%eax
  80309d:	cd 30                	int    $0x30
  80309f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8030a2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8030a5:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  8030a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8030ac:	79 30                	jns    8030de <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8030ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030b1:	89 c1                	mov    %eax,%ecx
  8030b3:	48 ba 2b 66 80 00 00 	movabs $0x80662b,%rdx
  8030ba:	00 00 00 
  8030bd:	be 89 00 00 00       	mov    $0x89,%esi
  8030c2:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  8030c9:	00 00 00 
  8030cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d1:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  8030d8:	00 00 00 
  8030db:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  8030de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8030e2:	75 46                	jne    80312a <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  8030e4:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  8030eb:	00 00 00 
  8030ee:	ff d0                	callq  *%rax
  8030f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8030f5:	48 63 d0             	movslq %eax,%rdx
  8030f8:	48 89 d0             	mov    %rdx,%rax
  8030fb:	48 c1 e0 03          	shl    $0x3,%rax
  8030ff:	48 01 d0             	add    %rdx,%rax
  803102:	48 c1 e0 05          	shl    $0x5,%rax
  803106:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80310d:	00 00 00 
  803110:	48 01 c2             	add    %rax,%rdx
  803113:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80311a:	00 00 00 
  80311d:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  803120:	b8 00 00 00 00       	mov    $0x0,%eax
  803125:	e9 d1 01 00 00       	jmpq   8032fb <fork+0x281>
	}

	uint64_t ad = 0;
  80312a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803131:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  803132:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803137:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80313b:	e9 df 00 00 00       	jmpq   80321f <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  803140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803144:	48 c1 e8 27          	shr    $0x27,%rax
  803148:	48 89 c2             	mov    %rax,%rdx
  80314b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803152:	01 00 00 
  803155:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803159:	83 e0 01             	and    $0x1,%eax
  80315c:	48 85 c0             	test   %rax,%rax
  80315f:	0f 84 9e 00 00 00    	je     803203 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  803165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803169:	48 c1 e8 1e          	shr    $0x1e,%rax
  80316d:	48 89 c2             	mov    %rax,%rdx
  803170:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803177:	01 00 00 
  80317a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80317e:	83 e0 01             	and    $0x1,%eax
  803181:	48 85 c0             	test   %rax,%rax
  803184:	74 73                	je     8031f9 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  803186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318a:	48 c1 e8 15          	shr    $0x15,%rax
  80318e:	48 89 c2             	mov    %rax,%rdx
  803191:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803198:	01 00 00 
  80319b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80319f:	83 e0 01             	and    $0x1,%eax
  8031a2:	48 85 c0             	test   %rax,%rax
  8031a5:	74 48                	je     8031ef <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8031a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8031af:	48 89 c2             	mov    %rax,%rdx
  8031b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031b9:	01 00 00 
  8031bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8031c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c8:	83 e0 01             	and    $0x1,%eax
  8031cb:	48 85 c0             	test   %rax,%rax
  8031ce:	74 47                	je     803217 <fork+0x19d>
						duppage(envid, VPN(addr));
  8031d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8031d8:	89 c2                	mov    %eax,%edx
  8031da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031dd:	89 d6                	mov    %edx,%esi
  8031df:	89 c7                	mov    %eax,%edi
  8031e1:	48 b8 b6 2e 80 00 00 	movabs $0x802eb6,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
  8031ed:	eb 28                	jmp    803217 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  8031ef:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8031f6:	00 
  8031f7:	eb 1e                	jmp    803217 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8031f9:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  803200:	40 
  803201:	eb 14                	jmp    803217 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  803203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803207:	48 c1 e8 27          	shr    $0x27,%rax
  80320b:	48 83 c0 01          	add    $0x1,%rax
  80320f:	48 c1 e0 27          	shl    $0x27,%rax
  803213:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  803217:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80321e:	00 
  80321f:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  803226:	00 
  803227:	0f 87 13 ff ff ff    	ja     803140 <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80322d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803230:	ba 07 00 00 00       	mov    $0x7,%edx
  803235:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80323a:	89 c7                	mov    %eax,%edi
  80323c:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  803243:	00 00 00 
  803246:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  803248:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80324b:	ba 07 00 00 00       	mov    $0x7,%edx
  803250:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  803255:	89 c7                	mov    %eax,%edi
  803257:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  803263:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803266:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80326c:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  803271:	ba 00 00 00 00       	mov    $0x0,%edx
  803276:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80327b:	89 c7                	mov    %eax,%edi
  80327d:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  803284:	00 00 00 
  803287:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  803289:	ba 00 10 00 00       	mov    $0x1000,%edx
  80328e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  803293:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  803298:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8032a4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8032a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ae:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  8032ba:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8032c1:	00 00 00 
  8032c4:	48 8b 00             	mov    (%rax),%rax
  8032c7:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8032ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032d1:	48 89 d6             	mov    %rdx,%rsi
  8032d4:	89 c7                	mov    %eax,%edi
  8032d6:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  8032dd:	00 00 00 
  8032e0:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  8032e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032e5:	be 02 00 00 00       	mov    $0x2,%esi
  8032ea:	89 c7                	mov    %eax,%edi
  8032ec:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8032f3:	00 00 00 
  8032f6:	ff d0                	callq  *%rax

	return envid;
  8032f8:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  8032fb:	c9                   	leaveq 
  8032fc:	c3                   	retq   

00000000008032fd <sfork>:

// Challenge!
int
sfork(void)
{
  8032fd:	55                   	push   %rbp
  8032fe:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  803301:	48 ba 43 66 80 00 00 	movabs $0x806643,%rdx
  803308:	00 00 00 
  80330b:	be b8 00 00 00       	mov    $0xb8,%esi
  803310:	48 bf 8d 65 80 00 00 	movabs $0x80658d,%rdi
  803317:	00 00 00 
  80331a:	b8 00 00 00 00       	mov    $0x0,%eax
  80331f:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  803326:	00 00 00 
  803329:	ff d1                	callq  *%rcx

000000000080332b <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80332b:	55                   	push   %rbp
  80332c:	48 89 e5             	mov    %rsp,%rbp
  80332f:	48 83 ec 18          	sub    $0x18,%rsp
  803333:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803337:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80333b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  80333f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803343:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803347:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803352:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  803356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80335a:	8b 00                	mov    (%rax),%eax
  80335c:	83 f8 01             	cmp    $0x1,%eax
  80335f:	7e 13                	jle    803374 <argstart+0x49>
  803361:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  803366:	74 0c                	je     803374 <argstart+0x49>
  803368:	48 b8 59 66 80 00 00 	movabs $0x806659,%rax
  80336f:	00 00 00 
  803372:	eb 05                	jmp    803379 <argstart+0x4e>
  803374:	b8 00 00 00 00       	mov    $0x0,%eax
  803379:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80337d:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  803381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803385:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80338c:	00 
}
  80338d:	c9                   	leaveq 
  80338e:	c3                   	retq   

000000000080338f <argnext>:

int
argnext(struct Argstate *args)
{
  80338f:	55                   	push   %rbp
  803390:	48 89 e5             	mov    %rsp,%rbp
  803393:	48 83 ec 20          	sub    $0x20,%rsp
  803397:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80339b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339f:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8033a6:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8033a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ab:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033af:	48 85 c0             	test   %rax,%rax
  8033b2:	75 0a                	jne    8033be <argnext+0x2f>
		return -1;
  8033b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8033b9:	e9 25 01 00 00       	jmpq   8034e3 <argnext+0x154>

	if (!*args->curarg) {
  8033be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033c6:	0f b6 00             	movzbl (%rax),%eax
  8033c9:	84 c0                	test   %al,%al
  8033cb:	0f 85 d7 00 00 00    	jne    8034a8 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8033d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d5:	48 8b 00             	mov    (%rax),%rax
  8033d8:	8b 00                	mov    (%rax),%eax
  8033da:	83 f8 01             	cmp    $0x1,%eax
  8033dd:	0f 84 ef 00 00 00    	je     8034d2 <argnext+0x143>
		    || args->argv[1][0] != '-'
  8033e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8033eb:	48 83 c0 08          	add    $0x8,%rax
  8033ef:	48 8b 00             	mov    (%rax),%rax
  8033f2:	0f b6 00             	movzbl (%rax),%eax
  8033f5:	3c 2d                	cmp    $0x2d,%al
  8033f7:	0f 85 d5 00 00 00    	jne    8034d2 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  8033fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803401:	48 8b 40 08          	mov    0x8(%rax),%rax
  803405:	48 83 c0 08          	add    $0x8,%rax
  803409:	48 8b 00             	mov    (%rax),%rax
  80340c:	48 83 c0 01          	add    $0x1,%rax
  803410:	0f b6 00             	movzbl (%rax),%eax
  803413:	84 c0                	test   %al,%al
  803415:	0f 84 b7 00 00 00    	je     8034d2 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80341b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341f:	48 8b 40 08          	mov    0x8(%rax),%rax
  803423:	48 83 c0 08          	add    $0x8,%rax
  803427:	48 8b 00             	mov    (%rax),%rax
  80342a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80342e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803432:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80343a:	48 8b 00             	mov    (%rax),%rax
  80343d:	8b 00                	mov    (%rax),%eax
  80343f:	83 e8 01             	sub    $0x1,%eax
  803442:	48 98                	cltq   
  803444:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80344b:	00 
  80344c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803450:	48 8b 40 08          	mov    0x8(%rax),%rax
  803454:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80345c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803460:	48 83 c0 08          	add    $0x8,%rax
  803464:	48 89 ce             	mov    %rcx,%rsi
  803467:	48 89 c7             	mov    %rax,%rdi
  80346a:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  803471:	00 00 00 
  803474:	ff d0                	callq  *%rax
		(*args->argc)--;
  803476:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80347a:	48 8b 00             	mov    (%rax),%rax
  80347d:	8b 10                	mov    (%rax),%edx
  80347f:	83 ea 01             	sub    $0x1,%edx
  803482:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  803484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803488:	48 8b 40 10          	mov    0x10(%rax),%rax
  80348c:	0f b6 00             	movzbl (%rax),%eax
  80348f:	3c 2d                	cmp    $0x2d,%al
  803491:	75 15                	jne    8034a8 <argnext+0x119>
  803493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803497:	48 8b 40 10          	mov    0x10(%rax),%rax
  80349b:	48 83 c0 01          	add    $0x1,%rax
  80349f:	0f b6 00             	movzbl (%rax),%eax
  8034a2:	84 c0                	test   %al,%al
  8034a4:	75 02                	jne    8034a8 <argnext+0x119>
			goto endofargs;
  8034a6:	eb 2a                	jmp    8034d2 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8034a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ac:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034b0:	0f b6 00             	movzbl (%rax),%eax
  8034b3:	0f b6 c0             	movzbl %al,%eax
  8034b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8034b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bd:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8034c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8034cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d0:	eb 11                	jmp    8034e3 <argnext+0x154>

endofargs:
	args->curarg = 0;
  8034d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d6:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8034dd:	00 
	return -1;
  8034de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8034e3:	c9                   	leaveq 
  8034e4:	c3                   	retq   

00000000008034e5 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  8034e5:	55                   	push   %rbp
  8034e6:	48 89 e5             	mov    %rsp,%rbp
  8034e9:	48 83 ec 10          	sub    $0x10,%rsp
  8034ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8034f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8034f9:	48 85 c0             	test   %rax,%rax
  8034fc:	74 0a                	je     803508 <argvalue+0x23>
  8034fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803502:	48 8b 40 18          	mov    0x18(%rax),%rax
  803506:	eb 13                	jmp    80351b <argvalue+0x36>
  803508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80350c:	48 89 c7             	mov    %rax,%rdi
  80350f:	48 b8 1d 35 80 00 00 	movabs $0x80351d,%rax
  803516:	00 00 00 
  803519:	ff d0                	callq  *%rax
}
  80351b:	c9                   	leaveq 
  80351c:	c3                   	retq   

000000000080351d <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80351d:	55                   	push   %rbp
  80351e:	48 89 e5             	mov    %rsp,%rbp
  803521:	53                   	push   %rbx
  803522:	48 83 ec 18          	sub    $0x18,%rsp
  803526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80352a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352e:	48 8b 40 10          	mov    0x10(%rax),%rax
  803532:	48 85 c0             	test   %rax,%rax
  803535:	75 0a                	jne    803541 <argnextvalue+0x24>
		return 0;
  803537:	b8 00 00 00 00       	mov    $0x0,%eax
  80353c:	e9 c8 00 00 00       	jmpq   803609 <argnextvalue+0xec>
	if (*args->curarg) {
  803541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803545:	48 8b 40 10          	mov    0x10(%rax),%rax
  803549:	0f b6 00             	movzbl (%rax),%eax
  80354c:	84 c0                	test   %al,%al
  80354e:	74 27                	je     803577 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  803550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803554:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355c:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  803560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803564:	48 bb 59 66 80 00 00 	movabs $0x806659,%rbx
  80356b:	00 00 00 
  80356e:	48 89 58 10          	mov    %rbx,0x10(%rax)
  803572:	e9 8a 00 00 00       	jmpq   803601 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  803577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357b:	48 8b 00             	mov    (%rax),%rax
  80357e:	8b 00                	mov    (%rax),%eax
  803580:	83 f8 01             	cmp    $0x1,%eax
  803583:	7e 64                	jle    8035e9 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  803585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803589:	48 8b 40 08          	mov    0x8(%rax),%rax
  80358d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803595:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359d:	48 8b 00             	mov    (%rax),%rax
  8035a0:	8b 00                	mov    (%rax),%eax
  8035a2:	83 e8 01             	sub    $0x1,%eax
  8035a5:	48 98                	cltq   
  8035a7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035ae:	00 
  8035af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035b7:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8035bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035c3:	48 83 c0 08          	add    $0x8,%rax
  8035c7:	48 89 ce             	mov    %rcx,%rsi
  8035ca:	48 89 c7             	mov    %rax,%rdi
  8035cd:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
		(*args->argc)--;
  8035d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035dd:	48 8b 00             	mov    (%rax),%rax
  8035e0:	8b 10                	mov    (%rax),%edx
  8035e2:	83 ea 01             	sub    $0x1,%edx
  8035e5:	89 10                	mov    %edx,(%rax)
  8035e7:	eb 18                	jmp    803601 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  8035e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ed:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8035f4:	00 
		args->curarg = 0;
  8035f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f9:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803600:	00 
	}
	return (char*) args->argvalue;
  803601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803605:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803609:	48 83 c4 18          	add    $0x18,%rsp
  80360d:	5b                   	pop    %rbx
  80360e:	5d                   	pop    %rbp
  80360f:	c3                   	retq   

0000000000803610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  803610:	55                   	push   %rbp
  803611:	48 89 e5             	mov    %rsp,%rbp
  803614:	48 83 ec 08          	sub    $0x8,%rsp
  803618:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80361c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803620:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803627:	ff ff ff 
  80362a:	48 01 d0             	add    %rdx,%rax
  80362d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  803631:	c9                   	leaveq 
  803632:	c3                   	retq   

0000000000803633 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803633:	55                   	push   %rbp
  803634:	48 89 e5             	mov    %rsp,%rbp
  803637:	48 83 ec 08          	sub    $0x8,%rsp
  80363b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80363f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803643:	48 89 c7             	mov    %rax,%rdi
  803646:	48 b8 10 36 80 00 00 	movabs $0x803610,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
  803652:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  803658:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80365c:	c9                   	leaveq 
  80365d:	c3                   	retq   

000000000080365e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80365e:	55                   	push   %rbp
  80365f:	48 89 e5             	mov    %rsp,%rbp
  803662:	48 83 ec 18          	sub    $0x18,%rsp
  803666:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80366a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803671:	eb 6b                	jmp    8036de <fd_alloc+0x80>
		fd = INDEX2FD(i);
  803673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803676:	48 98                	cltq   
  803678:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80367e:	48 c1 e0 0c          	shl    $0xc,%rax
  803682:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  803686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368a:	48 c1 e8 15          	shr    $0x15,%rax
  80368e:	48 89 c2             	mov    %rax,%rdx
  803691:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803698:	01 00 00 
  80369b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80369f:	83 e0 01             	and    $0x1,%eax
  8036a2:	48 85 c0             	test   %rax,%rax
  8036a5:	74 21                	je     8036c8 <fd_alloc+0x6a>
  8036a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8036af:	48 89 c2             	mov    %rax,%rdx
  8036b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036b9:	01 00 00 
  8036bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036c0:	83 e0 01             	and    $0x1,%eax
  8036c3:	48 85 c0             	test   %rax,%rax
  8036c6:	75 12                	jne    8036da <fd_alloc+0x7c>
			*fd_store = fd;
  8036c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036d0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8036d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d8:	eb 1a                	jmp    8036f4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8036da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8036de:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8036e2:	7e 8f                	jle    803673 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8036e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8036ef:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8036f4:	c9                   	leaveq 
  8036f5:	c3                   	retq   

00000000008036f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8036f6:	55                   	push   %rbp
  8036f7:	48 89 e5             	mov    %rsp,%rbp
  8036fa:	48 83 ec 20          	sub    $0x20,%rsp
  8036fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803701:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803705:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803709:	78 06                	js     803711 <fd_lookup+0x1b>
  80370b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80370f:	7e 07                	jle    803718 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803711:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803716:	eb 6c                	jmp    803784 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803718:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371b:	48 98                	cltq   
  80371d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803723:	48 c1 e0 0c          	shl    $0xc,%rax
  803727:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80372b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372f:	48 c1 e8 15          	shr    $0x15,%rax
  803733:	48 89 c2             	mov    %rax,%rdx
  803736:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80373d:	01 00 00 
  803740:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803744:	83 e0 01             	and    $0x1,%eax
  803747:	48 85 c0             	test   %rax,%rax
  80374a:	74 21                	je     80376d <fd_lookup+0x77>
  80374c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803750:	48 c1 e8 0c          	shr    $0xc,%rax
  803754:	48 89 c2             	mov    %rax,%rdx
  803757:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80375e:	01 00 00 
  803761:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803765:	83 e0 01             	and    $0x1,%eax
  803768:	48 85 c0             	test   %rax,%rax
  80376b:	75 07                	jne    803774 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80376d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803772:	eb 10                	jmp    803784 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  803774:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803778:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80377c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80377f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803784:	c9                   	leaveq 
  803785:	c3                   	retq   

0000000000803786 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  803786:	55                   	push   %rbp
  803787:	48 89 e5             	mov    %rsp,%rbp
  80378a:	48 83 ec 30          	sub    $0x30,%rsp
  80378e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803792:	89 f0                	mov    %esi,%eax
  803794:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  803797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379b:	48 89 c7             	mov    %rax,%rdi
  80379e:	48 b8 10 36 80 00 00 	movabs $0x803610,%rax
  8037a5:	00 00 00 
  8037a8:	ff d0                	callq  *%rax
  8037aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037ae:	48 89 d6             	mov    %rdx,%rsi
  8037b1:	89 c7                	mov    %eax,%edi
  8037b3:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  8037ba:	00 00 00 
  8037bd:	ff d0                	callq  *%rax
  8037bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c6:	78 0a                	js     8037d2 <fd_close+0x4c>
	    || fd != fd2)
  8037c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8037d0:	74 12                	je     8037e4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8037d2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8037d6:	74 05                	je     8037dd <fd_close+0x57>
  8037d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037db:	eb 05                	jmp    8037e2 <fd_close+0x5c>
  8037dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e2:	eb 69                	jmp    80384d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8037e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e8:	8b 00                	mov    (%rax),%eax
  8037ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037ee:	48 89 d6             	mov    %rdx,%rsi
  8037f1:	89 c7                	mov    %eax,%edi
  8037f3:	48 b8 4f 38 80 00 00 	movabs $0x80384f,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
  8037ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803802:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803806:	78 2a                	js     803832 <fd_close+0xac>
		if (dev->dev_close)
  803808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380c:	48 8b 40 20          	mov    0x20(%rax),%rax
  803810:	48 85 c0             	test   %rax,%rax
  803813:	74 16                	je     80382b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803819:	48 8b 40 20          	mov    0x20(%rax),%rax
  80381d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803821:	48 89 d7             	mov    %rdx,%rdi
  803824:	ff d0                	callq  *%rax
  803826:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803829:	eb 07                	jmp    803832 <fd_close+0xac>
		else
			r = 0;
  80382b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803836:	48 89 c6             	mov    %rax,%rsi
  803839:	bf 00 00 00 00       	mov    $0x0,%edi
  80383e:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  803845:	00 00 00 
  803848:	ff d0                	callq  *%rax
	return r;
  80384a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80384d:	c9                   	leaveq 
  80384e:	c3                   	retq   

000000000080384f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80384f:	55                   	push   %rbp
  803850:	48 89 e5             	mov    %rsp,%rbp
  803853:	48 83 ec 20          	sub    $0x20,%rsp
  803857:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80385a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80385e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803865:	eb 41                	jmp    8038a8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803867:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80386e:	00 00 00 
  803871:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803874:	48 63 d2             	movslq %edx,%rdx
  803877:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80387b:	8b 00                	mov    (%rax),%eax
  80387d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803880:	75 22                	jne    8038a4 <dev_lookup+0x55>
			*dev = devtab[i];
  803882:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803889:	00 00 00 
  80388c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80388f:	48 63 d2             	movslq %edx,%rdx
  803892:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80389a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80389d:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a2:	eb 60                	jmp    803904 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8038a4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8038a8:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8038af:	00 00 00 
  8038b2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038b5:	48 63 d2             	movslq %edx,%rdx
  8038b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038bc:	48 85 c0             	test   %rax,%rax
  8038bf:	75 a6                	jne    803867 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8038c1:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8038c8:	00 00 00 
  8038cb:	48 8b 00             	mov    (%rax),%rax
  8038ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8038d4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038d7:	89 c6                	mov    %eax,%esi
  8038d9:	48 bf 60 66 80 00 00 	movabs $0x806660,%rdi
  8038e0:	00 00 00 
  8038e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e8:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  8038ef:	00 00 00 
  8038f2:	ff d1                	callq  *%rcx
	*dev = 0;
  8038f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8038ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803904:	c9                   	leaveq 
  803905:	c3                   	retq   

0000000000803906 <close>:

int
close(int fdnum)
{
  803906:	55                   	push   %rbp
  803907:	48 89 e5             	mov    %rsp,%rbp
  80390a:	48 83 ec 20          	sub    $0x20,%rsp
  80390e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803911:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803915:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803918:	48 89 d6             	mov    %rdx,%rsi
  80391b:	89 c7                	mov    %eax,%edi
  80391d:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803930:	79 05                	jns    803937 <close+0x31>
		return r;
  803932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803935:	eb 18                	jmp    80394f <close+0x49>
	else
		return fd_close(fd, 1);
  803937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393b:	be 01 00 00 00       	mov    $0x1,%esi
  803940:	48 89 c7             	mov    %rax,%rdi
  803943:	48 b8 86 37 80 00 00 	movabs $0x803786,%rax
  80394a:	00 00 00 
  80394d:	ff d0                	callq  *%rax
}
  80394f:	c9                   	leaveq 
  803950:	c3                   	retq   

0000000000803951 <close_all>:

void
close_all(void)
{
  803951:	55                   	push   %rbp
  803952:	48 89 e5             	mov    %rsp,%rbp
  803955:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803960:	eb 15                	jmp    803977 <close_all+0x26>
		close(i);
  803962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803965:	89 c7                	mov    %eax,%edi
  803967:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  80396e:	00 00 00 
  803971:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803973:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803977:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80397b:	7e e5                	jle    803962 <close_all+0x11>
		close(i);
}
  80397d:	c9                   	leaveq 
  80397e:	c3                   	retq   

000000000080397f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80397f:	55                   	push   %rbp
  803980:	48 89 e5             	mov    %rsp,%rbp
  803983:	48 83 ec 40          	sub    $0x40,%rsp
  803987:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80398a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80398d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803991:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803994:	48 89 d6             	mov    %rdx,%rsi
  803997:	89 c7                	mov    %eax,%edi
  803999:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ac:	79 08                	jns    8039b6 <dup+0x37>
		return r;
  8039ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b1:	e9 70 01 00 00       	jmpq   803b26 <dup+0x1a7>
	close(newfdnum);
  8039b6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8039b9:	89 c7                	mov    %eax,%edi
  8039bb:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8039c2:	00 00 00 
  8039c5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8039c7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8039ca:	48 98                	cltq   
  8039cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8039d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8039d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8039da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039de:	48 89 c7             	mov    %rax,%rdi
  8039e1:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
  8039ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8039f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f5:	48 89 c7             	mov    %rax,%rdi
  8039f8:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  8039ff:	00 00 00 
  803a02:	ff d0                	callq  *%rax
  803a04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a0c:	48 c1 e8 15          	shr    $0x15,%rax
  803a10:	48 89 c2             	mov    %rax,%rdx
  803a13:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a1a:	01 00 00 
  803a1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a21:	83 e0 01             	and    $0x1,%eax
  803a24:	48 85 c0             	test   %rax,%rax
  803a27:	74 73                	je     803a9c <dup+0x11d>
  803a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a2d:	48 c1 e8 0c          	shr    $0xc,%rax
  803a31:	48 89 c2             	mov    %rax,%rdx
  803a34:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a3b:	01 00 00 
  803a3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a42:	83 e0 01             	and    $0x1,%eax
  803a45:	48 85 c0             	test   %rax,%rax
  803a48:	74 52                	je     803a9c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a4e:	48 c1 e8 0c          	shr    $0xc,%rax
  803a52:	48 89 c2             	mov    %rax,%rdx
  803a55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a5c:	01 00 00 
  803a5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a63:	25 07 0e 00 00       	and    $0xe07,%eax
  803a68:	89 c1                	mov    %eax,%ecx
  803a6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a72:	41 89 c8             	mov    %ecx,%r8d
  803a75:	48 89 d1             	mov    %rdx,%rcx
  803a78:	ba 00 00 00 00       	mov    $0x0,%edx
  803a7d:	48 89 c6             	mov    %rax,%rsi
  803a80:	bf 00 00 00 00       	mov    $0x0,%edi
  803a85:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
  803a91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a98:	79 02                	jns    803a9c <dup+0x11d>
			goto err;
  803a9a:	eb 57                	jmp    803af3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803a9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa0:	48 c1 e8 0c          	shr    $0xc,%rax
  803aa4:	48 89 c2             	mov    %rax,%rdx
  803aa7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803aae:	01 00 00 
  803ab1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ab5:	25 07 0e 00 00       	and    $0xe07,%eax
  803aba:	89 c1                	mov    %eax,%ecx
  803abc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac4:	41 89 c8             	mov    %ecx,%r8d
  803ac7:	48 89 d1             	mov    %rdx,%rcx
  803aca:	ba 00 00 00 00       	mov    $0x0,%edx
  803acf:	48 89 c6             	mov    %rax,%rsi
  803ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad7:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  803ade:	00 00 00 
  803ae1:	ff d0                	callq  *%rax
  803ae3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aea:	79 02                	jns    803aee <dup+0x16f>
		goto err;
  803aec:	eb 05                	jmp    803af3 <dup+0x174>

	return newfdnum;
  803aee:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803af1:	eb 33                	jmp    803b26 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803af3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af7:	48 89 c6             	mov    %rax,%rsi
  803afa:	bf 00 00 00 00       	mov    $0x0,%edi
  803aff:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803b0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0f:	48 89 c6             	mov    %rax,%rsi
  803b12:	bf 00 00 00 00       	mov    $0x0,%edi
  803b17:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  803b1e:	00 00 00 
  803b21:	ff d0                	callq  *%rax
	return r;
  803b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b26:	c9                   	leaveq 
  803b27:	c3                   	retq   

0000000000803b28 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803b28:	55                   	push   %rbp
  803b29:	48 89 e5             	mov    %rsp,%rbp
  803b2c:	48 83 ec 40          	sub    $0x40,%rsp
  803b30:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803b33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b37:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803b3b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b3f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b42:	48 89 d6             	mov    %rdx,%rsi
  803b45:	89 c7                	mov    %eax,%edi
  803b47:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  803b4e:	00 00 00 
  803b51:	ff d0                	callq  *%rax
  803b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b5a:	78 24                	js     803b80 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803b5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b60:	8b 00                	mov    (%rax),%eax
  803b62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b66:	48 89 d6             	mov    %rdx,%rsi
  803b69:	89 c7                	mov    %eax,%edi
  803b6b:	48 b8 4f 38 80 00 00 	movabs $0x80384f,%rax
  803b72:	00 00 00 
  803b75:	ff d0                	callq  *%rax
  803b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b7e:	79 05                	jns    803b85 <read+0x5d>
		return r;
  803b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b83:	eb 76                	jmp    803bfb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b89:	8b 40 08             	mov    0x8(%rax),%eax
  803b8c:	83 e0 03             	and    $0x3,%eax
  803b8f:	83 f8 01             	cmp    $0x1,%eax
  803b92:	75 3a                	jne    803bce <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803b94:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803b9b:	00 00 00 
  803b9e:	48 8b 00             	mov    (%rax),%rax
  803ba1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ba7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803baa:	89 c6                	mov    %eax,%esi
  803bac:	48 bf 7f 66 80 00 00 	movabs $0x80667f,%rdi
  803bb3:	00 00 00 
  803bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbb:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  803bc2:	00 00 00 
  803bc5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803bc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803bcc:	eb 2d                	jmp    803bfb <read+0xd3>
	}
	if (!dev->dev_read)
  803bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd2:	48 8b 40 10          	mov    0x10(%rax),%rax
  803bd6:	48 85 c0             	test   %rax,%rax
  803bd9:	75 07                	jne    803be2 <read+0xba>
		return -E_NOT_SUPP;
  803bdb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803be0:	eb 19                	jmp    803bfb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be6:	48 8b 40 10          	mov    0x10(%rax),%rax
  803bea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803bee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803bf2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803bf6:	48 89 cf             	mov    %rcx,%rdi
  803bf9:	ff d0                	callq  *%rax
}
  803bfb:	c9                   	leaveq 
  803bfc:	c3                   	retq   

0000000000803bfd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803bfd:	55                   	push   %rbp
  803bfe:	48 89 e5             	mov    %rsp,%rbp
  803c01:	48 83 ec 30          	sub    $0x30,%rsp
  803c05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803c10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c17:	eb 49                	jmp    803c62 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1c:	48 98                	cltq   
  803c1e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c22:	48 29 c2             	sub    %rax,%rdx
  803c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c28:	48 63 c8             	movslq %eax,%rcx
  803c2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c2f:	48 01 c1             	add    %rax,%rcx
  803c32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c35:	48 89 ce             	mov    %rcx,%rsi
  803c38:	89 c7                	mov    %eax,%edi
  803c3a:	48 b8 28 3b 80 00 00 	movabs $0x803b28,%rax
  803c41:	00 00 00 
  803c44:	ff d0                	callq  *%rax
  803c46:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803c49:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c4d:	79 05                	jns    803c54 <readn+0x57>
			return m;
  803c4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c52:	eb 1c                	jmp    803c70 <readn+0x73>
		if (m == 0)
  803c54:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c58:	75 02                	jne    803c5c <readn+0x5f>
			break;
  803c5a:	eb 11                	jmp    803c6d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803c5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c65:	48 98                	cltq   
  803c67:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803c6b:	72 ac                	jb     803c19 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c70:	c9                   	leaveq 
  803c71:	c3                   	retq   

0000000000803c72 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803c72:	55                   	push   %rbp
  803c73:	48 89 e5             	mov    %rsp,%rbp
  803c76:	48 83 ec 40          	sub    $0x40,%rsp
  803c7a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803c7d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c81:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803c85:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c8c:	48 89 d6             	mov    %rdx,%rsi
  803c8f:	89 c7                	mov    %eax,%edi
  803c91:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  803c98:	00 00 00 
  803c9b:	ff d0                	callq  *%rax
  803c9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca4:	78 24                	js     803cca <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803caa:	8b 00                	mov    (%rax),%eax
  803cac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cb0:	48 89 d6             	mov    %rdx,%rsi
  803cb3:	89 c7                	mov    %eax,%edi
  803cb5:	48 b8 4f 38 80 00 00 	movabs $0x80384f,%rax
  803cbc:	00 00 00 
  803cbf:	ff d0                	callq  *%rax
  803cc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc8:	79 05                	jns    803ccf <write+0x5d>
		return r;
  803cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccd:	eb 75                	jmp    803d44 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd3:	8b 40 08             	mov    0x8(%rax),%eax
  803cd6:	83 e0 03             	and    $0x3,%eax
  803cd9:	85 c0                	test   %eax,%eax
  803cdb:	75 3a                	jne    803d17 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803cdd:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803ce4:	00 00 00 
  803ce7:	48 8b 00             	mov    (%rax),%rax
  803cea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803cf0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803cf3:	89 c6                	mov    %eax,%esi
  803cf5:	48 bf 9b 66 80 00 00 	movabs $0x80669b,%rdi
  803cfc:	00 00 00 
  803cff:	b8 00 00 00 00       	mov    $0x0,%eax
  803d04:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  803d0b:	00 00 00 
  803d0e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803d10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d15:	eb 2d                	jmp    803d44 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1b:	48 8b 40 18          	mov    0x18(%rax),%rax
  803d1f:	48 85 c0             	test   %rax,%rax
  803d22:	75 07                	jne    803d2b <write+0xb9>
		return -E_NOT_SUPP;
  803d24:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d29:	eb 19                	jmp    803d44 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803d2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d2f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803d33:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d37:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d3b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803d3f:	48 89 cf             	mov    %rcx,%rdi
  803d42:	ff d0                	callq  *%rax
}
  803d44:	c9                   	leaveq 
  803d45:	c3                   	retq   

0000000000803d46 <seek>:

int
seek(int fdnum, off_t offset)
{
  803d46:	55                   	push   %rbp
  803d47:	48 89 e5             	mov    %rsp,%rbp
  803d4a:	48 83 ec 18          	sub    $0x18,%rsp
  803d4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d51:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5b:	48 89 d6             	mov    %rdx,%rsi
  803d5e:	89 c7                	mov    %eax,%edi
  803d60:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  803d67:	00 00 00 
  803d6a:	ff d0                	callq  *%rax
  803d6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d73:	79 05                	jns    803d7a <seek+0x34>
		return r;
  803d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d78:	eb 0f                	jmp    803d89 <seek+0x43>
	fd->fd_offset = offset;
  803d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d81:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d89:	c9                   	leaveq 
  803d8a:	c3                   	retq   

0000000000803d8b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803d8b:	55                   	push   %rbp
  803d8c:	48 89 e5             	mov    %rsp,%rbp
  803d8f:	48 83 ec 30          	sub    $0x30,%rsp
  803d93:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d96:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803d99:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d9d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803da0:	48 89 d6             	mov    %rdx,%rsi
  803da3:	89 c7                	mov    %eax,%edi
  803da5:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
  803db1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db8:	78 24                	js     803dde <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803dba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dbe:	8b 00                	mov    (%rax),%eax
  803dc0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dc4:	48 89 d6             	mov    %rdx,%rsi
  803dc7:	89 c7                	mov    %eax,%edi
  803dc9:	48 b8 4f 38 80 00 00 	movabs $0x80384f,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
  803dd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ddc:	79 05                	jns    803de3 <ftruncate+0x58>
		return r;
  803dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de1:	eb 72                	jmp    803e55 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de7:	8b 40 08             	mov    0x8(%rax),%eax
  803dea:	83 e0 03             	and    $0x3,%eax
  803ded:	85 c0                	test   %eax,%eax
  803def:	75 3a                	jne    803e2b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803df1:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803df8:	00 00 00 
  803dfb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803dfe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e04:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e07:	89 c6                	mov    %eax,%esi
  803e09:	48 bf b8 66 80 00 00 	movabs $0x8066b8,%rdi
  803e10:	00 00 00 
  803e13:	b8 00 00 00 00       	mov    $0x0,%eax
  803e18:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  803e1f:	00 00 00 
  803e22:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803e24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e29:	eb 2a                	jmp    803e55 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803e33:	48 85 c0             	test   %rax,%rax
  803e36:	75 07                	jne    803e3f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803e38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e3d:	eb 16                	jmp    803e55 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e43:	48 8b 40 30          	mov    0x30(%rax),%rax
  803e47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e4b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803e4e:	89 ce                	mov    %ecx,%esi
  803e50:	48 89 d7             	mov    %rdx,%rdi
  803e53:	ff d0                	callq  *%rax
}
  803e55:	c9                   	leaveq 
  803e56:	c3                   	retq   

0000000000803e57 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803e57:	55                   	push   %rbp
  803e58:	48 89 e5             	mov    %rsp,%rbp
  803e5b:	48 83 ec 30          	sub    $0x30,%rsp
  803e5f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803e62:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803e66:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e6d:	48 89 d6             	mov    %rdx,%rsi
  803e70:	89 c7                	mov    %eax,%edi
  803e72:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  803e79:	00 00 00 
  803e7c:	ff d0                	callq  *%rax
  803e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e85:	78 24                	js     803eab <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e8b:	8b 00                	mov    (%rax),%eax
  803e8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e91:	48 89 d6             	mov    %rdx,%rsi
  803e94:	89 c7                	mov    %eax,%edi
  803e96:	48 b8 4f 38 80 00 00 	movabs $0x80384f,%rax
  803e9d:	00 00 00 
  803ea0:	ff d0                	callq  *%rax
  803ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea9:	79 05                	jns    803eb0 <fstat+0x59>
		return r;
  803eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eae:	eb 5e                	jmp    803f0e <fstat+0xb7>
	if (!dev->dev_stat)
  803eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb4:	48 8b 40 28          	mov    0x28(%rax),%rax
  803eb8:	48 85 c0             	test   %rax,%rax
  803ebb:	75 07                	jne    803ec4 <fstat+0x6d>
		return -E_NOT_SUPP;
  803ebd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803ec2:	eb 4a                	jmp    803f0e <fstat+0xb7>
	stat->st_name[0] = 0;
  803ec4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803ecb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ecf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803ed6:	00 00 00 
	stat->st_isdir = 0;
  803ed9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803edd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ee4:	00 00 00 
	stat->st_dev = dev;
  803ee7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803eeb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eef:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803efa:	48 8b 40 28          	mov    0x28(%rax),%rax
  803efe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f02:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803f06:	48 89 ce             	mov    %rcx,%rsi
  803f09:	48 89 d7             	mov    %rdx,%rdi
  803f0c:	ff d0                	callq  *%rax
}
  803f0e:	c9                   	leaveq 
  803f0f:	c3                   	retq   

0000000000803f10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803f10:	55                   	push   %rbp
  803f11:	48 89 e5             	mov    %rsp,%rbp
  803f14:	48 83 ec 20          	sub    $0x20,%rsp
  803f18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f24:	be 00 00 00 00       	mov    $0x0,%esi
  803f29:	48 89 c7             	mov    %rax,%rdi
  803f2c:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  803f33:	00 00 00 
  803f36:	ff d0                	callq  *%rax
  803f38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3f:	79 05                	jns    803f46 <stat+0x36>
		return fd;
  803f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f44:	eb 2f                	jmp    803f75 <stat+0x65>
	r = fstat(fd, stat);
  803f46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f4d:	48 89 d6             	mov    %rdx,%rsi
  803f50:	89 c7                	mov    %eax,%edi
  803f52:	48 b8 57 3e 80 00 00 	movabs $0x803e57,%rax
  803f59:	00 00 00 
  803f5c:	ff d0                	callq  *%rax
  803f5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803f61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f64:	89 c7                	mov    %eax,%edi
  803f66:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  803f6d:	00 00 00 
  803f70:	ff d0                	callq  *%rax
	return r;
  803f72:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803f75:	c9                   	leaveq 
  803f76:	c3                   	retq   

0000000000803f77 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803f77:	55                   	push   %rbp
  803f78:	48 89 e5             	mov    %rsp,%rbp
  803f7b:	48 83 ec 10          	sub    $0x10,%rsp
  803f7f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803f86:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  803f8d:	00 00 00 
  803f90:	8b 00                	mov    (%rax),%eax
  803f92:	85 c0                	test   %eax,%eax
  803f94:	75 1d                	jne    803fb3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803f96:	bf 01 00 00 00       	mov    $0x1,%edi
  803f9b:	48 b8 d0 5c 80 00 00 	movabs $0x805cd0,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
  803fa7:	48 ba 20 94 80 00 00 	movabs $0x809420,%rdx
  803fae:	00 00 00 
  803fb1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803fb3:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  803fba:	00 00 00 
  803fbd:	8b 00                	mov    (%rax),%eax
  803fbf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803fc2:	b9 07 00 00 00       	mov    $0x7,%ecx
  803fc7:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803fce:	00 00 00 
  803fd1:	89 c7                	mov    %eax,%edi
  803fd3:	48 b8 38 5c 80 00 00 	movabs $0x805c38,%rax
  803fda:	00 00 00 
  803fdd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803fdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  803fe8:	48 89 c6             	mov    %rax,%rsi
  803feb:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff0:	48 b8 77 5b 80 00 00 	movabs $0x805b77,%rax
  803ff7:	00 00 00 
  803ffa:	ff d0                	callq  *%rax
}
  803ffc:	c9                   	leaveq 
  803ffd:	c3                   	retq   

0000000000803ffe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803ffe:	55                   	push   %rbp
  803fff:	48 89 e5             	mov    %rsp,%rbp
  804002:	48 83 ec 20          	sub    $0x20,%rsp
  804006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80400a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80400d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804011:	48 89 c7             	mov    %rax,%rdi
  804014:	48 b8 19 21 80 00 00 	movabs $0x802119,%rax
  80401b:	00 00 00 
  80401e:	ff d0                	callq  *%rax
  804020:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804025:	7e 0a                	jle    804031 <open+0x33>
		return -E_BAD_PATH;
  804027:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80402c:	e9 a5 00 00 00       	jmpq   8040d6 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  804031:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804035:	48 89 c7             	mov    %rax,%rdi
  804038:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  80403f:	00 00 00 
  804042:	ff d0                	callq  *%rax
  804044:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804047:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80404b:	79 08                	jns    804055 <open+0x57>
		return r;
  80404d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804050:	e9 81 00 00 00       	jmpq   8040d6 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  804055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804059:	48 89 c6             	mov    %rax,%rsi
  80405c:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  804063:	00 00 00 
  804066:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  80406d:	00 00 00 
  804070:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  804072:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804079:	00 00 00 
  80407c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80407f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  804085:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804089:	48 89 c6             	mov    %rax,%rsi
  80408c:	bf 01 00 00 00       	mov    $0x1,%edi
  804091:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  804098:	00 00 00 
  80409b:	ff d0                	callq  *%rax
  80409d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a4:	79 1d                	jns    8040c3 <open+0xc5>
		fd_close(fd, 0);
  8040a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040aa:	be 00 00 00 00       	mov    $0x0,%esi
  8040af:	48 89 c7             	mov    %rax,%rdi
  8040b2:	48 b8 86 37 80 00 00 	movabs $0x803786,%rax
  8040b9:	00 00 00 
  8040bc:	ff d0                	callq  *%rax
		return r;
  8040be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c1:	eb 13                	jmp    8040d6 <open+0xd8>
	}

	return fd2num(fd);
  8040c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c7:	48 89 c7             	mov    %rax,%rdi
  8040ca:	48 b8 10 36 80 00 00 	movabs $0x803610,%rax
  8040d1:	00 00 00 
  8040d4:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  8040d6:	c9                   	leaveq 
  8040d7:	c3                   	retq   

00000000008040d8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8040d8:	55                   	push   %rbp
  8040d9:	48 89 e5             	mov    %rsp,%rbp
  8040dc:	48 83 ec 10          	sub    $0x10,%rsp
  8040e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8040e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8040eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8040f2:	00 00 00 
  8040f5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8040f7:	be 00 00 00 00       	mov    $0x0,%esi
  8040fc:	bf 06 00 00 00       	mov    $0x6,%edi
  804101:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  804108:	00 00 00 
  80410b:	ff d0                	callq  *%rax
}
  80410d:	c9                   	leaveq 
  80410e:	c3                   	retq   

000000000080410f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80410f:	55                   	push   %rbp
  804110:	48 89 e5             	mov    %rsp,%rbp
  804113:	48 83 ec 30          	sub    $0x30,%rsp
  804117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80411b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80411f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  804123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804127:	8b 50 0c             	mov    0xc(%rax),%edx
  80412a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804131:	00 00 00 
  804134:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  804136:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80413d:	00 00 00 
  804140:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804144:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  804148:	be 00 00 00 00       	mov    $0x0,%esi
  80414d:	bf 03 00 00 00       	mov    $0x3,%edi
  804152:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  804159:	00 00 00 
  80415c:	ff d0                	callq  *%rax
  80415e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804161:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804165:	79 08                	jns    80416f <devfile_read+0x60>
		return r;
  804167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416a:	e9 a4 00 00 00       	jmpq   804213 <devfile_read+0x104>
	assert(r <= n);
  80416f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804172:	48 98                	cltq   
  804174:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804178:	76 35                	jbe    8041af <devfile_read+0xa0>
  80417a:	48 b9 e5 66 80 00 00 	movabs $0x8066e5,%rcx
  804181:	00 00 00 
  804184:	48 ba ec 66 80 00 00 	movabs $0x8066ec,%rdx
  80418b:	00 00 00 
  80418e:	be 84 00 00 00       	mov    $0x84,%esi
  804193:	48 bf 01 67 80 00 00 	movabs $0x806701,%rdi
  80419a:	00 00 00 
  80419d:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a2:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  8041a9:	00 00 00 
  8041ac:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8041af:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8041b6:	7e 35                	jle    8041ed <devfile_read+0xde>
  8041b8:	48 b9 0c 67 80 00 00 	movabs $0x80670c,%rcx
  8041bf:	00 00 00 
  8041c2:	48 ba ec 66 80 00 00 	movabs $0x8066ec,%rdx
  8041c9:	00 00 00 
  8041cc:	be 85 00 00 00       	mov    $0x85,%esi
  8041d1:	48 bf 01 67 80 00 00 	movabs $0x806701,%rdi
  8041d8:	00 00 00 
  8041db:	b8 00 00 00 00       	mov    $0x0,%eax
  8041e0:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  8041e7:	00 00 00 
  8041ea:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8041ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f0:	48 63 d0             	movslq %eax,%rdx
  8041f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8041fe:	00 00 00 
  804201:	48 89 c7             	mov    %rax,%rdi
  804204:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  80420b:	00 00 00 
  80420e:	ff d0                	callq  *%rax
	return r;
  804210:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  804213:	c9                   	leaveq 
  804214:	c3                   	retq   

0000000000804215 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  804215:	55                   	push   %rbp
  804216:	48 89 e5             	mov    %rsp,%rbp
  804219:	48 83 ec 30          	sub    $0x30,%rsp
  80421d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804221:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804225:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  804229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422d:	8b 50 0c             	mov    0xc(%rax),%edx
  804230:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804237:	00 00 00 
  80423a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80423c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804243:	00 00 00 
  804246:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80424a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80424e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  804255:	00 
  804256:	76 35                	jbe    80428d <devfile_write+0x78>
  804258:	48 b9 18 67 80 00 00 	movabs $0x806718,%rcx
  80425f:	00 00 00 
  804262:	48 ba ec 66 80 00 00 	movabs $0x8066ec,%rdx
  804269:	00 00 00 
  80426c:	be 9e 00 00 00       	mov    $0x9e,%esi
  804271:	48 bf 01 67 80 00 00 	movabs $0x806701,%rdi
  804278:	00 00 00 
  80427b:	b8 00 00 00 00       	mov    $0x0,%eax
  804280:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  804287:	00 00 00 
  80428a:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80428d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804291:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804295:	48 89 c6             	mov    %rax,%rsi
  804298:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  80429f:	00 00 00 
  8042a2:	48 b8 c0 25 80 00 00 	movabs $0x8025c0,%rax
  8042a9:	00 00 00 
  8042ac:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8042ae:	be 00 00 00 00       	mov    $0x0,%esi
  8042b3:	bf 04 00 00 00       	mov    $0x4,%edi
  8042b8:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  8042bf:	00 00 00 
  8042c2:	ff d0                	callq  *%rax
  8042c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042cb:	79 05                	jns    8042d2 <devfile_write+0xbd>
		return r;
  8042cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d0:	eb 43                	jmp    804315 <devfile_write+0x100>
	assert(r <= n);
  8042d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d5:	48 98                	cltq   
  8042d7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8042db:	76 35                	jbe    804312 <devfile_write+0xfd>
  8042dd:	48 b9 e5 66 80 00 00 	movabs $0x8066e5,%rcx
  8042e4:	00 00 00 
  8042e7:	48 ba ec 66 80 00 00 	movabs $0x8066ec,%rdx
  8042ee:	00 00 00 
  8042f1:	be a2 00 00 00       	mov    $0xa2,%esi
  8042f6:	48 bf 01 67 80 00 00 	movabs $0x806701,%rdi
  8042fd:	00 00 00 
  804300:	b8 00 00 00 00       	mov    $0x0,%eax
  804305:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  80430c:	00 00 00 
  80430f:	41 ff d0             	callq  *%r8
	return r;
  804312:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  804315:	c9                   	leaveq 
  804316:	c3                   	retq   

0000000000804317 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  804317:	55                   	push   %rbp
  804318:	48 89 e5             	mov    %rsp,%rbp
  80431b:	48 83 ec 20          	sub    $0x20,%rsp
  80431f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804323:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  804327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80432b:	8b 50 0c             	mov    0xc(%rax),%edx
  80432e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804335:	00 00 00 
  804338:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80433a:	be 00 00 00 00       	mov    $0x0,%esi
  80433f:	bf 05 00 00 00       	mov    $0x5,%edi
  804344:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  80434b:	00 00 00 
  80434e:	ff d0                	callq  *%rax
  804350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804357:	79 05                	jns    80435e <devfile_stat+0x47>
		return r;
  804359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435c:	eb 56                	jmp    8043b4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80435e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804362:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  804369:	00 00 00 
  80436c:	48 89 c7             	mov    %rax,%rdi
  80436f:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80437b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804382:	00 00 00 
  804385:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80438b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80438f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804395:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80439c:	00 00 00 
  80439f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8043a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8043af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043b4:	c9                   	leaveq 
  8043b5:	c3                   	retq   

00000000008043b6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8043b6:	55                   	push   %rbp
  8043b7:	48 89 e5             	mov    %rsp,%rbp
  8043ba:	48 83 ec 10          	sub    $0x10,%rsp
  8043be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043c2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8043c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8043cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043d3:	00 00 00 
  8043d6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8043d8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8043df:	00 00 00 
  8043e2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8043e5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8043e8:	be 00 00 00 00       	mov    $0x0,%esi
  8043ed:	bf 02 00 00 00       	mov    $0x2,%edi
  8043f2:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  8043f9:	00 00 00 
  8043fc:	ff d0                	callq  *%rax
}
  8043fe:	c9                   	leaveq 
  8043ff:	c3                   	retq   

0000000000804400 <remove>:

// Delete a file
int
remove(const char *path)
{
  804400:	55                   	push   %rbp
  804401:	48 89 e5             	mov    %rsp,%rbp
  804404:	48 83 ec 10          	sub    $0x10,%rsp
  804408:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80440c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804410:	48 89 c7             	mov    %rax,%rdi
  804413:	48 b8 19 21 80 00 00 	movabs $0x802119,%rax
  80441a:	00 00 00 
  80441d:	ff d0                	callq  *%rax
  80441f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804424:	7e 07                	jle    80442d <remove+0x2d>
		return -E_BAD_PATH;
  804426:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80442b:	eb 33                	jmp    804460 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80442d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804431:	48 89 c6             	mov    %rax,%rsi
  804434:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80443b:	00 00 00 
  80443e:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  804445:	00 00 00 
  804448:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80444a:	be 00 00 00 00       	mov    $0x0,%esi
  80444f:	bf 07 00 00 00       	mov    $0x7,%edi
  804454:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  80445b:	00 00 00 
  80445e:	ff d0                	callq  *%rax
}
  804460:	c9                   	leaveq 
  804461:	c3                   	retq   

0000000000804462 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  804462:	55                   	push   %rbp
  804463:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  804466:	be 00 00 00 00       	mov    $0x0,%esi
  80446b:	bf 08 00 00 00       	mov    $0x8,%edi
  804470:	48 b8 77 3f 80 00 00 	movabs $0x803f77,%rax
  804477:	00 00 00 
  80447a:	ff d0                	callq  *%rax
}
  80447c:	5d                   	pop    %rbp
  80447d:	c3                   	retq   

000000000080447e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80447e:	55                   	push   %rbp
  80447f:	48 89 e5             	mov    %rsp,%rbp
  804482:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  804489:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  804490:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  804497:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80449e:	be 00 00 00 00       	mov    $0x0,%esi
  8044a3:	48 89 c7             	mov    %rax,%rdi
  8044a6:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  8044ad:	00 00 00 
  8044b0:	ff d0                	callq  *%rax
  8044b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8044b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b9:	79 28                	jns    8044e3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8044bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044be:	89 c6                	mov    %eax,%esi
  8044c0:	48 bf 45 67 80 00 00 	movabs $0x806745,%rdi
  8044c7:	00 00 00 
  8044ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8044cf:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  8044d6:	00 00 00 
  8044d9:	ff d2                	callq  *%rdx
		return fd_src;
  8044db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044de:	e9 74 01 00 00       	jmpq   804657 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8044e3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8044ea:	be 01 01 00 00       	mov    $0x101,%esi
  8044ef:	48 89 c7             	mov    %rax,%rdi
  8044f2:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  8044f9:	00 00 00 
  8044fc:	ff d0                	callq  *%rax
  8044fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  804501:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804505:	79 39                	jns    804540 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  804507:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80450a:	89 c6                	mov    %eax,%esi
  80450c:	48 bf 5b 67 80 00 00 	movabs $0x80675b,%rdi
  804513:	00 00 00 
  804516:	b8 00 00 00 00       	mov    $0x0,%eax
  80451b:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  804522:	00 00 00 
  804525:	ff d2                	callq  *%rdx
		close(fd_src);
  804527:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80452a:	89 c7                	mov    %eax,%edi
  80452c:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  804533:	00 00 00 
  804536:	ff d0                	callq  *%rax
		return fd_dest;
  804538:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80453b:	e9 17 01 00 00       	jmpq   804657 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804540:	eb 74                	jmp    8045b6 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  804542:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804545:	48 63 d0             	movslq %eax,%rdx
  804548:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80454f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804552:	48 89 ce             	mov    %rcx,%rsi
  804555:	89 c7                	mov    %eax,%edi
  804557:	48 b8 72 3c 80 00 00 	movabs $0x803c72,%rax
  80455e:	00 00 00 
  804561:	ff d0                	callq  *%rax
  804563:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  804566:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80456a:	79 4a                	jns    8045b6 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80456c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80456f:	89 c6                	mov    %eax,%esi
  804571:	48 bf 75 67 80 00 00 	movabs $0x806775,%rdi
  804578:	00 00 00 
  80457b:	b8 00 00 00 00       	mov    $0x0,%eax
  804580:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  804587:	00 00 00 
  80458a:	ff d2                	callq  *%rdx
			close(fd_src);
  80458c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80458f:	89 c7                	mov    %eax,%edi
  804591:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  804598:	00 00 00 
  80459b:	ff d0                	callq  *%rax
			close(fd_dest);
  80459d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045a0:	89 c7                	mov    %eax,%edi
  8045a2:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8045a9:	00 00 00 
  8045ac:	ff d0                	callq  *%rax
			return write_size;
  8045ae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8045b1:	e9 a1 00 00 00       	jmpq   804657 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8045b6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8045bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c0:	ba 00 02 00 00       	mov    $0x200,%edx
  8045c5:	48 89 ce             	mov    %rcx,%rsi
  8045c8:	89 c7                	mov    %eax,%edi
  8045ca:	48 b8 28 3b 80 00 00 	movabs $0x803b28,%rax
  8045d1:	00 00 00 
  8045d4:	ff d0                	callq  *%rax
  8045d6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8045d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8045dd:	0f 8f 5f ff ff ff    	jg     804542 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  8045e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8045e7:	79 47                	jns    804630 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8045e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8045ec:	89 c6                	mov    %eax,%esi
  8045ee:	48 bf 88 67 80 00 00 	movabs $0x806788,%rdi
  8045f5:	00 00 00 
  8045f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8045fd:	48 ba 63 14 80 00 00 	movabs $0x801463,%rdx
  804604:	00 00 00 
  804607:	ff d2                	callq  *%rdx
		close(fd_src);
  804609:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80460c:	89 c7                	mov    %eax,%edi
  80460e:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  804615:	00 00 00 
  804618:	ff d0                	callq  *%rax
		close(fd_dest);
  80461a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80461d:	89 c7                	mov    %eax,%edi
  80461f:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  804626:	00 00 00 
  804629:	ff d0                	callq  *%rax
		return read_size;
  80462b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80462e:	eb 27                	jmp    804657 <copy+0x1d9>
	}
	close(fd_src);
  804630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804633:	89 c7                	mov    %eax,%edi
  804635:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  80463c:	00 00 00 
  80463f:	ff d0                	callq  *%rax
	close(fd_dest);
  804641:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804644:	89 c7                	mov    %eax,%edi
  804646:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  80464d:	00 00 00 
  804650:	ff d0                	callq  *%rax
	return 0;
  804652:	b8 00 00 00 00       	mov    $0x0,%eax

}
  804657:	c9                   	leaveq 
  804658:	c3                   	retq   

0000000000804659 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  804659:	55                   	push   %rbp
  80465a:	48 89 e5             	mov    %rsp,%rbp
  80465d:	48 83 ec 20          	sub    $0x20,%rsp
  804661:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  804665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804669:	8b 40 0c             	mov    0xc(%rax),%eax
  80466c:	85 c0                	test   %eax,%eax
  80466e:	7e 67                	jle    8046d7 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  804670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804674:	8b 40 04             	mov    0x4(%rax),%eax
  804677:	48 63 d0             	movslq %eax,%rdx
  80467a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80467e:	48 8d 48 10          	lea    0x10(%rax),%rcx
  804682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804686:	8b 00                	mov    (%rax),%eax
  804688:	48 89 ce             	mov    %rcx,%rsi
  80468b:	89 c7                	mov    %eax,%edi
  80468d:	48 b8 72 3c 80 00 00 	movabs $0x803c72,%rax
  804694:	00 00 00 
  804697:	ff d0                	callq  *%rax
  804699:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80469c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a0:	7e 13                	jle    8046b5 <writebuf+0x5c>
			b->result += result;
  8046a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046a6:	8b 50 08             	mov    0x8(%rax),%edx
  8046a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ac:	01 c2                	add    %eax,%edx
  8046ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046b2:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8046b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046b9:	8b 40 04             	mov    0x4(%rax),%eax
  8046bc:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8046bf:	74 16                	je     8046d7 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8046c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8046c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ca:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8046ce:	89 c2                	mov    %eax,%edx
  8046d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d4:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8046d7:	c9                   	leaveq 
  8046d8:	c3                   	retq   

00000000008046d9 <putch>:

static void
putch(int ch, void *thunk)
{
  8046d9:	55                   	push   %rbp
  8046da:	48 89 e5             	mov    %rsp,%rbp
  8046dd:	48 83 ec 20          	sub    $0x20,%rsp
  8046e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8046e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8046f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f4:	8b 40 04             	mov    0x4(%rax),%eax
  8046f7:	8d 48 01             	lea    0x1(%rax),%ecx
  8046fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046fe:	89 4a 04             	mov    %ecx,0x4(%rdx)
  804701:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804704:	89 d1                	mov    %edx,%ecx
  804706:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80470a:	48 98                	cltq   
  80470c:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  804710:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804714:	8b 40 04             	mov    0x4(%rax),%eax
  804717:	3d 00 01 00 00       	cmp    $0x100,%eax
  80471c:	75 1e                	jne    80473c <putch+0x63>
		writebuf(b);
  80471e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804722:	48 89 c7             	mov    %rax,%rdi
  804725:	48 b8 59 46 80 00 00 	movabs $0x804659,%rax
  80472c:	00 00 00 
  80472f:	ff d0                	callq  *%rax
		b->idx = 0;
  804731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804735:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80473c:	c9                   	leaveq 
  80473d:	c3                   	retq   

000000000080473e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80473e:	55                   	push   %rbp
  80473f:	48 89 e5             	mov    %rsp,%rbp
  804742:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804749:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80474f:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804756:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80475d:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804763:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  804769:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  804770:	00 00 00 
	b.result = 0;
  804773:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  80477a:	00 00 00 
	b.error = 1;
  80477d:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804784:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804787:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80478e:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804795:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80479c:	48 89 c6             	mov    %rax,%rsi
  80479f:	48 bf d9 46 80 00 00 	movabs $0x8046d9,%rdi
  8047a6:	00 00 00 
  8047a9:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8047b0:	00 00 00 
  8047b3:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8047b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8047bb:	85 c0                	test   %eax,%eax
  8047bd:	7e 16                	jle    8047d5 <vfprintf+0x97>
		writebuf(&b);
  8047bf:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8047c6:	48 89 c7             	mov    %rax,%rdi
  8047c9:	48 b8 59 46 80 00 00 	movabs $0x804659,%rax
  8047d0:	00 00 00 
  8047d3:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8047d5:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8047db:	85 c0                	test   %eax,%eax
  8047dd:	74 08                	je     8047e7 <vfprintf+0xa9>
  8047df:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8047e5:	eb 06                	jmp    8047ed <vfprintf+0xaf>
  8047e7:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8047ed:	c9                   	leaveq 
  8047ee:	c3                   	retq   

00000000008047ef <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8047ef:	55                   	push   %rbp
  8047f0:	48 89 e5             	mov    %rsp,%rbp
  8047f3:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8047fa:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804800:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804807:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80480e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804815:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80481c:	84 c0                	test   %al,%al
  80481e:	74 20                	je     804840 <fprintf+0x51>
  804820:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804824:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804828:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80482c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804830:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804834:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804838:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80483c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804840:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804847:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80484e:	00 00 00 
  804851:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804858:	00 00 00 
  80485b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80485f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804866:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80486d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804874:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80487b:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804882:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804888:	48 89 ce             	mov    %rcx,%rsi
  80488b:	89 c7                	mov    %eax,%edi
  80488d:	48 b8 3e 47 80 00 00 	movabs $0x80473e,%rax
  804894:	00 00 00 
  804897:	ff d0                	callq  *%rax
  804899:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80489f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8048a5:	c9                   	leaveq 
  8048a6:	c3                   	retq   

00000000008048a7 <printf>:

int
printf(const char *fmt, ...)
{
  8048a7:	55                   	push   %rbp
  8048a8:	48 89 e5             	mov    %rsp,%rbp
  8048ab:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8048b2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8048b9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8048c0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8048c7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8048ce:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8048d5:	84 c0                	test   %al,%al
  8048d7:	74 20                	je     8048f9 <printf+0x52>
  8048d9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8048dd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8048e1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8048e5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8048e9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8048ed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8048f1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8048f5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8048f9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804900:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804907:	00 00 00 
  80490a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804911:	00 00 00 
  804914:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804918:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80491f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804926:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80492d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804934:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80493b:	48 89 c6             	mov    %rax,%rsi
  80493e:	bf 01 00 00 00       	mov    $0x1,%edi
  804943:	48 b8 3e 47 80 00 00 	movabs $0x80473e,%rax
  80494a:	00 00 00 
  80494d:	ff d0                	callq  *%rax
  80494f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804955:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80495b:	c9                   	leaveq 
  80495c:	c3                   	retq   

000000000080495d <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80495d:	55                   	push   %rbp
  80495e:	48 89 e5             	mov    %rsp,%rbp
  804961:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  804968:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80496f:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804976:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80497d:	be 00 00 00 00       	mov    $0x0,%esi
  804982:	48 89 c7             	mov    %rax,%rdi
  804985:	48 b8 fe 3f 80 00 00 	movabs $0x803ffe,%rax
  80498c:	00 00 00 
  80498f:	ff d0                	callq  *%rax
  804991:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804994:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804998:	79 08                	jns    8049a2 <spawn+0x45>
		return r;
  80499a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80499d:	e9 14 03 00 00       	jmpq   804cb6 <spawn+0x359>
	fd = r;
  8049a2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8049a5:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8049a8:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8049af:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8049b3:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8049ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049bd:	ba 00 02 00 00       	mov    $0x200,%edx
  8049c2:	48 89 ce             	mov    %rcx,%rsi
  8049c5:	89 c7                	mov    %eax,%edi
  8049c7:	48 b8 fd 3b 80 00 00 	movabs $0x803bfd,%rax
  8049ce:	00 00 00 
  8049d1:	ff d0                	callq  *%rax
  8049d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8049d8:	75 0d                	jne    8049e7 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8049da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049de:	8b 00                	mov    (%rax),%eax
  8049e0:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8049e5:	74 43                	je     804a2a <spawn+0xcd>
		close(fd);
  8049e7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049ea:	89 c7                	mov    %eax,%edi
  8049ec:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  8049f3:	00 00 00 
  8049f6:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8049f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049fc:	8b 00                	mov    (%rax),%eax
  8049fe:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804a03:	89 c6                	mov    %eax,%esi
  804a05:	48 bf a0 67 80 00 00 	movabs $0x8067a0,%rdi
  804a0c:	00 00 00 
  804a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a14:	48 b9 63 14 80 00 00 	movabs $0x801463,%rcx
  804a1b:	00 00 00 
  804a1e:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804a20:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804a25:	e9 8c 02 00 00       	jmpq   804cb6 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804a2a:	b8 07 00 00 00       	mov    $0x7,%eax
  804a2f:	cd 30                	int    $0x30
  804a31:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804a34:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804a37:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a3e:	79 08                	jns    804a48 <spawn+0xeb>
		return r;
  804a40:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a43:	e9 6e 02 00 00       	jmpq   804cb6 <spawn+0x359>
	child = r;
  804a48:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a4b:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804a4e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804a51:	25 ff 03 00 00       	and    $0x3ff,%eax
  804a56:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804a5d:	00 00 00 
  804a60:	48 63 d0             	movslq %eax,%rdx
  804a63:	48 89 d0             	mov    %rdx,%rax
  804a66:	48 c1 e0 03          	shl    $0x3,%rax
  804a6a:	48 01 d0             	add    %rdx,%rax
  804a6d:	48 c1 e0 05          	shl    $0x5,%rax
  804a71:	48 01 c8             	add    %rcx,%rax
  804a74:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804a7b:	48 89 c6             	mov    %rax,%rsi
  804a7e:	b8 18 00 00 00       	mov    $0x18,%eax
  804a83:	48 89 d7             	mov    %rdx,%rdi
  804a86:	48 89 c1             	mov    %rax,%rcx
  804a89:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804a8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a90:	48 8b 40 18          	mov    0x18(%rax),%rax
  804a94:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804a9b:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804aa2:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804aa9:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804ab0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ab3:	48 89 ce             	mov    %rcx,%rsi
  804ab6:	89 c7                	mov    %eax,%edi
  804ab8:	48 b8 20 4f 80 00 00 	movabs $0x804f20,%rax
  804abf:	00 00 00 
  804ac2:	ff d0                	callq  *%rax
  804ac4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804ac7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804acb:	79 08                	jns    804ad5 <spawn+0x178>
		return r;
  804acd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804ad0:	e9 e1 01 00 00       	jmpq   804cb6 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ad9:	48 8b 40 20          	mov    0x20(%rax),%rax
  804add:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804ae4:	48 01 d0             	add    %rdx,%rax
  804ae7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804aeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804af2:	e9 a3 00 00 00       	jmpq   804b9a <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  804af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804afb:	8b 00                	mov    (%rax),%eax
  804afd:	83 f8 01             	cmp    $0x1,%eax
  804b00:	74 05                	je     804b07 <spawn+0x1aa>
			continue;
  804b02:	e9 8a 00 00 00       	jmpq   804b91 <spawn+0x234>
		perm = PTE_P | PTE_U;
  804b07:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804b0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b12:	8b 40 04             	mov    0x4(%rax),%eax
  804b15:	83 e0 02             	and    $0x2,%eax
  804b18:	85 c0                	test   %eax,%eax
  804b1a:	74 04                	je     804b20 <spawn+0x1c3>
			perm |= PTE_W;
  804b1c:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b24:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804b28:	41 89 c1             	mov    %eax,%r9d
  804b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b2f:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b37:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804b3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b3f:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804b43:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804b46:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804b49:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804b4c:	89 3c 24             	mov    %edi,(%rsp)
  804b4f:	89 c7                	mov    %eax,%edi
  804b51:	48 b8 c9 51 80 00 00 	movabs $0x8051c9,%rax
  804b58:	00 00 00 
  804b5b:	ff d0                	callq  *%rax
  804b5d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804b60:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804b64:	79 2b                	jns    804b91 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804b66:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804b67:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804b6a:	89 c7                	mov    %eax,%edi
  804b6c:	48 b8 f4 29 80 00 00 	movabs $0x8029f4,%rax
  804b73:	00 00 00 
  804b76:	ff d0                	callq  *%rax
	close(fd);
  804b78:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804b7b:	89 c7                	mov    %eax,%edi
  804b7d:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  804b84:	00 00 00 
  804b87:	ff d0                	callq  *%rax
	return r;
  804b89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b8c:	e9 25 01 00 00       	jmpq   804cb6 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804b91:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804b95:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804b9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b9e:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804ba2:	0f b7 c0             	movzwl %ax,%eax
  804ba5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804ba8:	0f 8f 49 ff ff ff    	jg     804af7 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804bae:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804bb1:	89 c7                	mov    %eax,%edi
  804bb3:	48 b8 06 39 80 00 00 	movabs $0x803906,%rax
  804bba:	00 00 00 
  804bbd:	ff d0                	callq  *%rax
	fd = -1;
  804bbf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804bc6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804bc9:	89 c7                	mov    %eax,%edi
  804bcb:	48 b8 b5 53 80 00 00 	movabs $0x8053b5,%rax
  804bd2:	00 00 00 
  804bd5:	ff d0                	callq  *%rax
  804bd7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804bda:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804bde:	79 30                	jns    804c10 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  804be0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804be3:	89 c1                	mov    %eax,%ecx
  804be5:	48 ba ba 67 80 00 00 	movabs $0x8067ba,%rdx
  804bec:	00 00 00 
  804bef:	be 82 00 00 00       	mov    $0x82,%esi
  804bf4:	48 bf d0 67 80 00 00 	movabs $0x8067d0,%rdi
  804bfb:	00 00 00 
  804bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  804c03:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  804c0a:	00 00 00 
  804c0d:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804c10:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804c17:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c1a:	48 89 d6             	mov    %rdx,%rsi
  804c1d:	89 c7                	mov    %eax,%edi
  804c1f:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  804c26:	00 00 00 
  804c29:	ff d0                	callq  *%rax
  804c2b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c32:	79 30                	jns    804c64 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  804c34:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c37:	89 c1                	mov    %eax,%ecx
  804c39:	48 ba dc 67 80 00 00 	movabs $0x8067dc,%rdx
  804c40:	00 00 00 
  804c43:	be 85 00 00 00       	mov    $0x85,%esi
  804c48:	48 bf d0 67 80 00 00 	movabs $0x8067d0,%rdi
  804c4f:	00 00 00 
  804c52:	b8 00 00 00 00       	mov    $0x0,%eax
  804c57:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  804c5e:	00 00 00 
  804c61:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804c64:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c67:	be 02 00 00 00       	mov    $0x2,%esi
  804c6c:	89 c7                	mov    %eax,%edi
  804c6e:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  804c75:	00 00 00 
  804c78:	ff d0                	callq  *%rax
  804c7a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c81:	79 30                	jns    804cb3 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  804c83:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c86:	89 c1                	mov    %eax,%ecx
  804c88:	48 ba f6 67 80 00 00 	movabs $0x8067f6,%rdx
  804c8f:	00 00 00 
  804c92:	be 88 00 00 00       	mov    $0x88,%esi
  804c97:	48 bf d0 67 80 00 00 	movabs $0x8067d0,%rdi
  804c9e:	00 00 00 
  804ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  804ca6:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  804cad:	00 00 00 
  804cb0:	41 ff d0             	callq  *%r8

	return child;
  804cb3:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804cb6:	c9                   	leaveq 
  804cb7:	c3                   	retq   

0000000000804cb8 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804cb8:	55                   	push   %rbp
  804cb9:	48 89 e5             	mov    %rsp,%rbp
  804cbc:	41 55                	push   %r13
  804cbe:	41 54                	push   %r12
  804cc0:	53                   	push   %rbx
  804cc1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804cc8:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804ccf:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804cd6:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804cdd:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804ce4:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804ceb:	84 c0                	test   %al,%al
  804ced:	74 26                	je     804d15 <spawnl+0x5d>
  804cef:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804cf6:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804cfd:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804d01:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804d05:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804d09:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804d0d:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804d11:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804d15:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804d1c:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804d23:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804d26:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804d2d:	00 00 00 
  804d30:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804d37:	00 00 00 
  804d3a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804d3e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804d45:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804d4c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804d53:	eb 07                	jmp    804d5c <spawnl+0xa4>
		argc++;
  804d55:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804d5c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804d62:	83 f8 30             	cmp    $0x30,%eax
  804d65:	73 23                	jae    804d8a <spawnl+0xd2>
  804d67:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804d6e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804d74:	89 c0                	mov    %eax,%eax
  804d76:	48 01 d0             	add    %rdx,%rax
  804d79:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804d7f:	83 c2 08             	add    $0x8,%edx
  804d82:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804d88:	eb 15                	jmp    804d9f <spawnl+0xe7>
  804d8a:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804d91:	48 89 d0             	mov    %rdx,%rax
  804d94:	48 83 c2 08          	add    $0x8,%rdx
  804d98:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804d9f:	48 8b 00             	mov    (%rax),%rax
  804da2:	48 85 c0             	test   %rax,%rax
  804da5:	75 ae                	jne    804d55 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804da7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804dad:	83 c0 02             	add    $0x2,%eax
  804db0:	48 89 e2             	mov    %rsp,%rdx
  804db3:	48 89 d3             	mov    %rdx,%rbx
  804db6:	48 63 d0             	movslq %eax,%rdx
  804db9:	48 83 ea 01          	sub    $0x1,%rdx
  804dbd:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804dc4:	48 63 d0             	movslq %eax,%rdx
  804dc7:	49 89 d4             	mov    %rdx,%r12
  804dca:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804dd0:	48 63 d0             	movslq %eax,%rdx
  804dd3:	49 89 d2             	mov    %rdx,%r10
  804dd6:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804ddc:	48 98                	cltq   
  804dde:	48 c1 e0 03          	shl    $0x3,%rax
  804de2:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804de6:	b8 10 00 00 00       	mov    $0x10,%eax
  804deb:	48 83 e8 01          	sub    $0x1,%rax
  804def:	48 01 d0             	add    %rdx,%rax
  804df2:	bf 10 00 00 00       	mov    $0x10,%edi
  804df7:	ba 00 00 00 00       	mov    $0x0,%edx
  804dfc:	48 f7 f7             	div    %rdi
  804dff:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804e03:	48 29 c4             	sub    %rax,%rsp
  804e06:	48 89 e0             	mov    %rsp,%rax
  804e09:	48 83 c0 07          	add    $0x7,%rax
  804e0d:	48 c1 e8 03          	shr    $0x3,%rax
  804e11:	48 c1 e0 03          	shl    $0x3,%rax
  804e15:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804e1c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804e23:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804e2a:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804e2d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804e33:	8d 50 01             	lea    0x1(%rax),%edx
  804e36:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804e3d:	48 63 d2             	movslq %edx,%rdx
  804e40:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804e47:	00 

	va_start(vl, arg0);
  804e48:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804e4f:	00 00 00 
  804e52:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804e59:	00 00 00 
  804e5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804e60:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804e67:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804e6e:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804e75:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  804e7c:	00 00 00 
  804e7f:	eb 63                	jmp    804ee4 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  804e81:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804e87:	8d 70 01             	lea    0x1(%rax),%esi
  804e8a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804e90:	83 f8 30             	cmp    $0x30,%eax
  804e93:	73 23                	jae    804eb8 <spawnl+0x200>
  804e95:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804e9c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804ea2:	89 c0                	mov    %eax,%eax
  804ea4:	48 01 d0             	add    %rdx,%rax
  804ea7:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804ead:	83 c2 08             	add    $0x8,%edx
  804eb0:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804eb6:	eb 15                	jmp    804ecd <spawnl+0x215>
  804eb8:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804ebf:	48 89 d0             	mov    %rdx,%rax
  804ec2:	48 83 c2 08          	add    $0x8,%rdx
  804ec6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804ecd:	48 8b 08             	mov    (%rax),%rcx
  804ed0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804ed7:	89 f2                	mov    %esi,%edx
  804ed9:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804edd:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804ee4:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804eea:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804ef0:	77 8f                	ja     804e81 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804ef2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804ef9:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804f00:	48 89 d6             	mov    %rdx,%rsi
  804f03:	48 89 c7             	mov    %rax,%rdi
  804f06:	48 b8 5d 49 80 00 00 	movabs $0x80495d,%rax
  804f0d:	00 00 00 
  804f10:	ff d0                	callq  *%rax
  804f12:	48 89 dc             	mov    %rbx,%rsp
}
  804f15:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  804f19:	5b                   	pop    %rbx
  804f1a:	41 5c                	pop    %r12
  804f1c:	41 5d                	pop    %r13
  804f1e:	5d                   	pop    %rbp
  804f1f:	c3                   	retq   

0000000000804f20 <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  804f20:	55                   	push   %rbp
  804f21:	48 89 e5             	mov    %rsp,%rbp
  804f24:	48 83 ec 50          	sub    $0x50,%rsp
  804f28:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804f2b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804f2f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804f33:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804f3a:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804f3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804f42:	eb 33                	jmp    804f77 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804f44:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f47:	48 98                	cltq   
  804f49:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804f50:	00 
  804f51:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804f55:	48 01 d0             	add    %rdx,%rax
  804f58:	48 8b 00             	mov    (%rax),%rax
  804f5b:	48 89 c7             	mov    %rax,%rdi
  804f5e:	48 b8 19 21 80 00 00 	movabs $0x802119,%rax
  804f65:	00 00 00 
  804f68:	ff d0                	callq  *%rax
  804f6a:	83 c0 01             	add    $0x1,%eax
  804f6d:	48 98                	cltq   
  804f6f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804f73:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804f77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f7a:	48 98                	cltq   
  804f7c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804f83:	00 
  804f84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804f88:	48 01 d0             	add    %rdx,%rax
  804f8b:	48 8b 00             	mov    (%rax),%rax
  804f8e:	48 85 c0             	test   %rax,%rax
  804f91:	75 b1                	jne    804f44 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804f93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f97:	48 f7 d8             	neg    %rax
  804f9a:	48 05 00 10 40 00    	add    $0x401000,%rax
  804fa0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804fa4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804fa8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804fac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fb0:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804fb4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804fb7:	83 c2 01             	add    $0x1,%edx
  804fba:	c1 e2 03             	shl    $0x3,%edx
  804fbd:	48 63 d2             	movslq %edx,%rdx
  804fc0:	48 f7 da             	neg    %rdx
  804fc3:	48 01 d0             	add    %rdx,%rax
  804fc6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804fca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fce:	48 83 e8 10          	sub    $0x10,%rax
  804fd2:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804fd8:	77 0a                	ja     804fe4 <init_stack+0xc4>
		return -E_NO_MEM;
  804fda:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804fdf:	e9 e3 01 00 00       	jmpq   8051c7 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804fe4:	ba 07 00 00 00       	mov    $0x7,%edx
  804fe9:	be 00 00 40 00       	mov    $0x400000,%esi
  804fee:	bf 00 00 00 00       	mov    $0x0,%edi
  804ff3:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  804ffa:	00 00 00 
  804ffd:	ff d0                	callq  *%rax
  804fff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805002:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805006:	79 08                	jns    805010 <init_stack+0xf0>
		return r;
  805008:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80500b:	e9 b7 01 00 00       	jmpq   8051c7 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  805010:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  805017:	e9 8a 00 00 00       	jmpq   8050a6 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  80501c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80501f:	48 98                	cltq   
  805021:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805028:	00 
  805029:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80502d:	48 01 c2             	add    %rax,%rdx
  805030:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805035:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805039:	48 01 c8             	add    %rcx,%rax
  80503c:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805042:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  805045:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805048:	48 98                	cltq   
  80504a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805051:	00 
  805052:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805056:	48 01 d0             	add    %rdx,%rax
  805059:	48 8b 10             	mov    (%rax),%rdx
  80505c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805060:	48 89 d6             	mov    %rdx,%rsi
  805063:	48 89 c7             	mov    %rax,%rdi
  805066:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  80506d:	00 00 00 
  805070:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  805072:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805075:	48 98                	cltq   
  805077:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80507e:	00 
  80507f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805083:	48 01 d0             	add    %rdx,%rax
  805086:	48 8b 00             	mov    (%rax),%rax
  805089:	48 89 c7             	mov    %rax,%rdi
  80508c:	48 b8 19 21 80 00 00 	movabs $0x802119,%rax
  805093:	00 00 00 
  805096:	ff d0                	callq  *%rax
  805098:	48 98                	cltq   
  80509a:	48 83 c0 01          	add    $0x1,%rax
  80509e:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8050a2:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8050a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8050a9:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8050ac:	0f 8c 6a ff ff ff    	jl     80501c <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8050b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050b5:	48 98                	cltq   
  8050b7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8050be:	00 
  8050bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8050c3:	48 01 d0             	add    %rdx,%rax
  8050c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8050cd:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8050d4:	00 
  8050d5:	74 35                	je     80510c <init_stack+0x1ec>
  8050d7:	48 b9 10 68 80 00 00 	movabs $0x806810,%rcx
  8050de:	00 00 00 
  8050e1:	48 ba 36 68 80 00 00 	movabs $0x806836,%rdx
  8050e8:	00 00 00 
  8050eb:	be f1 00 00 00       	mov    $0xf1,%esi
  8050f0:	48 bf d0 67 80 00 00 	movabs $0x8067d0,%rdi
  8050f7:	00 00 00 
  8050fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8050ff:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  805106:	00 00 00 
  805109:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80510c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805110:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  805114:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805119:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80511d:	48 01 c8             	add    %rcx,%rax
  805120:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805126:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  805129:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80512d:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  805131:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805134:	48 98                	cltq   
  805136:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  805139:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80513e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805142:	48 01 d0             	add    %rdx,%rax
  805145:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80514b:	48 89 c2             	mov    %rax,%rdx
  80514e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  805152:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  805155:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805158:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80515e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805163:	89 c2                	mov    %eax,%edx
  805165:	be 00 00 40 00       	mov    $0x400000,%esi
  80516a:	bf 00 00 00 00       	mov    $0x0,%edi
  80516f:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  805176:	00 00 00 
  805179:	ff d0                	callq  *%rax
  80517b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80517e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805182:	79 02                	jns    805186 <init_stack+0x266>
		goto error;
  805184:	eb 28                	jmp    8051ae <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  805186:	be 00 00 40 00       	mov    $0x400000,%esi
  80518b:	bf 00 00 00 00       	mov    $0x0,%edi
  805190:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  805197:	00 00 00 
  80519a:	ff d0                	callq  *%rax
  80519c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80519f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8051a3:	79 02                	jns    8051a7 <init_stack+0x287>
		goto error;
  8051a5:	eb 07                	jmp    8051ae <init_stack+0x28e>

	return 0;
  8051a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8051ac:	eb 19                	jmp    8051c7 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8051ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8051b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8051b8:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  8051bf:	00 00 00 
  8051c2:	ff d0                	callq  *%rax
	return r;
  8051c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8051c7:	c9                   	leaveq 
  8051c8:	c3                   	retq   

00000000008051c9 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8051c9:	55                   	push   %rbp
  8051ca:	48 89 e5             	mov    %rsp,%rbp
  8051cd:	48 83 ec 50          	sub    $0x50,%rsp
  8051d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8051d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8051d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8051dc:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8051df:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8051e3:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8051e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051eb:	25 ff 0f 00 00       	and    $0xfff,%eax
  8051f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8051f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051f7:	74 21                	je     80521a <map_segment+0x51>
		va -= i;
  8051f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051fc:	48 98                	cltq   
  8051fe:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  805202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805205:	48 98                	cltq   
  805207:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80520b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80520e:	48 98                	cltq   
  805210:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  805214:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805217:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80521a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805221:	e9 79 01 00 00       	jmpq   80539f <map_segment+0x1d6>
		if (i >= filesz) {
  805226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805229:	48 98                	cltq   
  80522b:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80522f:	72 3c                	jb     80526d <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  805231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805234:	48 63 d0             	movslq %eax,%rdx
  805237:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80523b:	48 01 d0             	add    %rdx,%rax
  80523e:	48 89 c1             	mov    %rax,%rcx
  805241:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805244:	8b 55 10             	mov    0x10(%rbp),%edx
  805247:	48 89 ce             	mov    %rcx,%rsi
  80524a:	89 c7                	mov    %eax,%edi
  80524c:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  805253:	00 00 00 
  805256:	ff d0                	callq  *%rax
  805258:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80525b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80525f:	0f 89 33 01 00 00    	jns    805398 <map_segment+0x1cf>
				return r;
  805265:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805268:	e9 46 01 00 00       	jmpq   8053b3 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80526d:	ba 07 00 00 00       	mov    $0x7,%edx
  805272:	be 00 00 40 00       	mov    $0x400000,%esi
  805277:	bf 00 00 00 00       	mov    $0x0,%edi
  80527c:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  805283:	00 00 00 
  805286:	ff d0                	callq  *%rax
  805288:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80528b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80528f:	79 08                	jns    805299 <map_segment+0xd0>
				return r;
  805291:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805294:	e9 1a 01 00 00       	jmpq   8053b3 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  805299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80529c:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80529f:	01 c2                	add    %eax,%edx
  8052a1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8052a4:	89 d6                	mov    %edx,%esi
  8052a6:	89 c7                	mov    %eax,%edi
  8052a8:	48 b8 46 3d 80 00 00 	movabs $0x803d46,%rax
  8052af:	00 00 00 
  8052b2:	ff d0                	callq  *%rax
  8052b4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8052b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8052bb:	79 08                	jns    8052c5 <map_segment+0xfc>
				return r;
  8052bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8052c0:	e9 ee 00 00 00       	jmpq   8053b3 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8052c5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8052cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052cf:	48 98                	cltq   
  8052d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8052d5:	48 29 c2             	sub    %rax,%rdx
  8052d8:	48 89 d0             	mov    %rdx,%rax
  8052db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8052df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052e2:	48 63 d0             	movslq %eax,%rdx
  8052e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052e9:	48 39 c2             	cmp    %rax,%rdx
  8052ec:	48 0f 47 d0          	cmova  %rax,%rdx
  8052f0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8052f3:	be 00 00 40 00       	mov    $0x400000,%esi
  8052f8:	89 c7                	mov    %eax,%edi
  8052fa:	48 b8 fd 3b 80 00 00 	movabs $0x803bfd,%rax
  805301:	00 00 00 
  805304:	ff d0                	callq  *%rax
  805306:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805309:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80530d:	79 08                	jns    805317 <map_segment+0x14e>
				return r;
  80530f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805312:	e9 9c 00 00 00       	jmpq   8053b3 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80531a:	48 63 d0             	movslq %eax,%rdx
  80531d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805321:	48 01 d0             	add    %rdx,%rax
  805324:	48 89 c2             	mov    %rax,%rdx
  805327:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80532a:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80532e:	48 89 d1             	mov    %rdx,%rcx
  805331:	89 c2                	mov    %eax,%edx
  805333:	be 00 00 40 00       	mov    $0x400000,%esi
  805338:	bf 00 00 00 00       	mov    $0x0,%edi
  80533d:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  805344:	00 00 00 
  805347:	ff d0                	callq  *%rax
  805349:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80534c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805350:	79 30                	jns    805382 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  805352:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805355:	89 c1                	mov    %eax,%ecx
  805357:	48 ba 4b 68 80 00 00 	movabs $0x80684b,%rdx
  80535e:	00 00 00 
  805361:	be 24 01 00 00       	mov    $0x124,%esi
  805366:	48 bf d0 67 80 00 00 	movabs $0x8067d0,%rdi
  80536d:	00 00 00 
  805370:	b8 00 00 00 00       	mov    $0x0,%eax
  805375:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  80537c:	00 00 00 
  80537f:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  805382:	be 00 00 40 00       	mov    $0x400000,%esi
  805387:	bf 00 00 00 00       	mov    $0x0,%edi
  80538c:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  805393:	00 00 00 
  805396:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805398:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80539f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053a2:	48 98                	cltq   
  8053a4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8053a8:	0f 82 78 fe ff ff    	jb     805226 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8053ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8053b3:	c9                   	leaveq 
  8053b4:	c3                   	retq   

00000000008053b5 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8053b5:	55                   	push   %rbp
  8053b6:	48 89 e5             	mov    %rsp,%rbp
  8053b9:	48 83 ec 04          	sub    $0x4,%rsp
  8053bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  8053c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8053c5:	c9                   	leaveq 
  8053c6:	c3                   	retq   

00000000008053c7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8053c7:	55                   	push   %rbp
  8053c8:	48 89 e5             	mov    %rsp,%rbp
  8053cb:	53                   	push   %rbx
  8053cc:	48 83 ec 38          	sub    $0x38,%rsp
  8053d0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8053d4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8053d8:	48 89 c7             	mov    %rax,%rdi
  8053db:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  8053e2:	00 00 00 
  8053e5:	ff d0                	callq  *%rax
  8053e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053ee:	0f 88 bf 01 00 00    	js     8055b3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8053f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053f8:	ba 07 04 00 00       	mov    $0x407,%edx
  8053fd:	48 89 c6             	mov    %rax,%rsi
  805400:	bf 00 00 00 00       	mov    $0x0,%edi
  805405:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80540c:	00 00 00 
  80540f:	ff d0                	callq  *%rax
  805411:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805414:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805418:	0f 88 95 01 00 00    	js     8055b3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80541e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805422:	48 89 c7             	mov    %rax,%rdi
  805425:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  80542c:	00 00 00 
  80542f:	ff d0                	callq  *%rax
  805431:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805434:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805438:	0f 88 5d 01 00 00    	js     80559b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80543e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805442:	ba 07 04 00 00       	mov    $0x407,%edx
  805447:	48 89 c6             	mov    %rax,%rsi
  80544a:	bf 00 00 00 00       	mov    $0x0,%edi
  80544f:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  805456:	00 00 00 
  805459:	ff d0                	callq  *%rax
  80545b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80545e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805462:	0f 88 33 01 00 00    	js     80559b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80546c:	48 89 c7             	mov    %rax,%rdi
  80546f:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  805476:	00 00 00 
  805479:	ff d0                	callq  *%rax
  80547b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80547f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805483:	ba 07 04 00 00       	mov    $0x407,%edx
  805488:	48 89 c6             	mov    %rax,%rsi
  80548b:	bf 00 00 00 00       	mov    $0x0,%edi
  805490:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  805497:	00 00 00 
  80549a:	ff d0                	callq  *%rax
  80549c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80549f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8054a3:	79 05                	jns    8054aa <pipe+0xe3>
		goto err2;
  8054a5:	e9 d9 00 00 00       	jmpq   805583 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8054aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054ae:	48 89 c7             	mov    %rax,%rdi
  8054b1:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  8054b8:	00 00 00 
  8054bb:	ff d0                	callq  *%rax
  8054bd:	48 89 c2             	mov    %rax,%rdx
  8054c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8054c4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8054ca:	48 89 d1             	mov    %rdx,%rcx
  8054cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8054d2:	48 89 c6             	mov    %rax,%rsi
  8054d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8054da:	48 b8 04 2b 80 00 00 	movabs $0x802b04,%rax
  8054e1:	00 00 00 
  8054e4:	ff d0                	callq  *%rax
  8054e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8054e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8054ed:	79 1b                	jns    80550a <pipe+0x143>
		goto err3;
  8054ef:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8054f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8054f4:	48 89 c6             	mov    %rax,%rsi
  8054f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8054fc:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  805503:	00 00 00 
  805506:	ff d0                	callq  *%rax
  805508:	eb 79                	jmp    805583 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80550a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80550e:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  805515:	00 00 00 
  805518:	8b 12                	mov    (%rdx),%edx
  80551a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80551c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805520:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805527:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80552b:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  805532:	00 00 00 
  805535:	8b 12                	mov    (%rdx),%edx
  805537:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805539:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80553d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805544:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805548:	48 89 c7             	mov    %rax,%rdi
  80554b:	48 b8 10 36 80 00 00 	movabs $0x803610,%rax
  805552:	00 00 00 
  805555:	ff d0                	callq  *%rax
  805557:	89 c2                	mov    %eax,%edx
  805559:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80555d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80555f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805563:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805567:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80556b:	48 89 c7             	mov    %rax,%rdi
  80556e:	48 b8 10 36 80 00 00 	movabs $0x803610,%rax
  805575:	00 00 00 
  805578:	ff d0                	callq  *%rax
  80557a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80557c:	b8 00 00 00 00       	mov    $0x0,%eax
  805581:	eb 33                	jmp    8055b6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805583:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805587:	48 89 c6             	mov    %rax,%rsi
  80558a:	bf 00 00 00 00       	mov    $0x0,%edi
  80558f:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  805596:	00 00 00 
  805599:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80559b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80559f:	48 89 c6             	mov    %rax,%rsi
  8055a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8055a7:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  8055ae:	00 00 00 
  8055b1:	ff d0                	callq  *%rax
err:
	return r;
  8055b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8055b6:	48 83 c4 38          	add    $0x38,%rsp
  8055ba:	5b                   	pop    %rbx
  8055bb:	5d                   	pop    %rbp
  8055bc:	c3                   	retq   

00000000008055bd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8055bd:	55                   	push   %rbp
  8055be:	48 89 e5             	mov    %rsp,%rbp
  8055c1:	53                   	push   %rbx
  8055c2:	48 83 ec 28          	sub    $0x28,%rsp
  8055c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8055ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8055ce:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8055d5:	00 00 00 
  8055d8:	48 8b 00             	mov    (%rax),%rax
  8055db:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8055e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8055e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055e8:	48 89 c7             	mov    %rax,%rdi
  8055eb:	48 b8 52 5d 80 00 00 	movabs $0x805d52,%rax
  8055f2:	00 00 00 
  8055f5:	ff d0                	callq  *%rax
  8055f7:	89 c3                	mov    %eax,%ebx
  8055f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8055fd:	48 89 c7             	mov    %rax,%rdi
  805600:	48 b8 52 5d 80 00 00 	movabs $0x805d52,%rax
  805607:	00 00 00 
  80560a:	ff d0                	callq  *%rax
  80560c:	39 c3                	cmp    %eax,%ebx
  80560e:	0f 94 c0             	sete   %al
  805611:	0f b6 c0             	movzbl %al,%eax
  805614:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  805617:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80561e:	00 00 00 
  805621:	48 8b 00             	mov    (%rax),%rax
  805624:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80562a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80562d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805630:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805633:	75 05                	jne    80563a <_pipeisclosed+0x7d>
			return ret;
  805635:	8b 45 e8             	mov    -0x18(%rbp),%eax
  805638:	eb 4f                	jmp    805689 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80563a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80563d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805640:	74 42                	je     805684 <_pipeisclosed+0xc7>
  805642:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805646:	75 3c                	jne    805684 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805648:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80564f:	00 00 00 
  805652:	48 8b 00             	mov    (%rax),%rax
  805655:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80565b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80565e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805661:	89 c6                	mov    %eax,%esi
  805663:	48 bf 6d 68 80 00 00 	movabs $0x80686d,%rdi
  80566a:	00 00 00 
  80566d:	b8 00 00 00 00       	mov    $0x0,%eax
  805672:	49 b8 63 14 80 00 00 	movabs $0x801463,%r8
  805679:	00 00 00 
  80567c:	41 ff d0             	callq  *%r8
	}
  80567f:	e9 4a ff ff ff       	jmpq   8055ce <_pipeisclosed+0x11>
  805684:	e9 45 ff ff ff       	jmpq   8055ce <_pipeisclosed+0x11>
}
  805689:	48 83 c4 28          	add    $0x28,%rsp
  80568d:	5b                   	pop    %rbx
  80568e:	5d                   	pop    %rbp
  80568f:	c3                   	retq   

0000000000805690 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  805690:	55                   	push   %rbp
  805691:	48 89 e5             	mov    %rsp,%rbp
  805694:	48 83 ec 30          	sub    $0x30,%rsp
  805698:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80569b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80569f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8056a2:	48 89 d6             	mov    %rdx,%rsi
  8056a5:	89 c7                	mov    %eax,%edi
  8056a7:	48 b8 f6 36 80 00 00 	movabs $0x8036f6,%rax
  8056ae:	00 00 00 
  8056b1:	ff d0                	callq  *%rax
  8056b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056ba:	79 05                	jns    8056c1 <pipeisclosed+0x31>
		return r;
  8056bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056bf:	eb 31                	jmp    8056f2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8056c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056c5:	48 89 c7             	mov    %rax,%rdi
  8056c8:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  8056cf:	00 00 00 
  8056d2:	ff d0                	callq  *%rax
  8056d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8056d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8056e0:	48 89 d6             	mov    %rdx,%rsi
  8056e3:	48 89 c7             	mov    %rax,%rdi
  8056e6:	48 b8 bd 55 80 00 00 	movabs $0x8055bd,%rax
  8056ed:	00 00 00 
  8056f0:	ff d0                	callq  *%rax
}
  8056f2:	c9                   	leaveq 
  8056f3:	c3                   	retq   

00000000008056f4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8056f4:	55                   	push   %rbp
  8056f5:	48 89 e5             	mov    %rsp,%rbp
  8056f8:	48 83 ec 40          	sub    $0x40,%rsp
  8056fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805700:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805704:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  805708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80570c:	48 89 c7             	mov    %rax,%rdi
  80570f:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  805716:	00 00 00 
  805719:	ff d0                	callq  *%rax
  80571b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80571f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805723:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805727:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80572e:	00 
  80572f:	e9 92 00 00 00       	jmpq   8057c6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  805734:	eb 41                	jmp    805777 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  805736:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80573b:	74 09                	je     805746 <devpipe_read+0x52>
				return i;
  80573d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805741:	e9 92 00 00 00       	jmpq   8057d8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805746:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80574a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80574e:	48 89 d6             	mov    %rdx,%rsi
  805751:	48 89 c7             	mov    %rax,%rdi
  805754:	48 b8 bd 55 80 00 00 	movabs $0x8055bd,%rax
  80575b:	00 00 00 
  80575e:	ff d0                	callq  *%rax
  805760:	85 c0                	test   %eax,%eax
  805762:	74 07                	je     80576b <devpipe_read+0x77>
				return 0;
  805764:	b8 00 00 00 00       	mov    $0x0,%eax
  805769:	eb 6d                	jmp    8057d8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80576b:	48 b8 76 2a 80 00 00 	movabs $0x802a76,%rax
  805772:	00 00 00 
  805775:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80577b:	8b 10                	mov    (%rax),%edx
  80577d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805781:	8b 40 04             	mov    0x4(%rax),%eax
  805784:	39 c2                	cmp    %eax,%edx
  805786:	74 ae                	je     805736 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805788:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80578c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805790:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805798:	8b 00                	mov    (%rax),%eax
  80579a:	99                   	cltd   
  80579b:	c1 ea 1b             	shr    $0x1b,%edx
  80579e:	01 d0                	add    %edx,%eax
  8057a0:	83 e0 1f             	and    $0x1f,%eax
  8057a3:	29 d0                	sub    %edx,%eax
  8057a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8057a9:	48 98                	cltq   
  8057ab:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8057b0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8057b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057b6:	8b 00                	mov    (%rax),%eax
  8057b8:	8d 50 01             	lea    0x1(%rax),%edx
  8057bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057bf:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8057c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8057c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057ca:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8057ce:	0f 82 60 ff ff ff    	jb     805734 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8057d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8057d8:	c9                   	leaveq 
  8057d9:	c3                   	retq   

00000000008057da <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8057da:	55                   	push   %rbp
  8057db:	48 89 e5             	mov    %rsp,%rbp
  8057de:	48 83 ec 40          	sub    $0x40,%rsp
  8057e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8057e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8057ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8057ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057f2:	48 89 c7             	mov    %rax,%rdi
  8057f5:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  8057fc:	00 00 00 
  8057ff:	ff d0                	callq  *%rax
  805801:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805805:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805809:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80580d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805814:	00 
  805815:	e9 8e 00 00 00       	jmpq   8058a8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80581a:	eb 31                	jmp    80584d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80581c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805824:	48 89 d6             	mov    %rdx,%rsi
  805827:	48 89 c7             	mov    %rax,%rdi
  80582a:	48 b8 bd 55 80 00 00 	movabs $0x8055bd,%rax
  805831:	00 00 00 
  805834:	ff d0                	callq  *%rax
  805836:	85 c0                	test   %eax,%eax
  805838:	74 07                	je     805841 <devpipe_write+0x67>
				return 0;
  80583a:	b8 00 00 00 00       	mov    $0x0,%eax
  80583f:	eb 79                	jmp    8058ba <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  805841:	48 b8 76 2a 80 00 00 	movabs $0x802a76,%rax
  805848:	00 00 00 
  80584b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80584d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805851:	8b 40 04             	mov    0x4(%rax),%eax
  805854:	48 63 d0             	movslq %eax,%rdx
  805857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80585b:	8b 00                	mov    (%rax),%eax
  80585d:	48 98                	cltq   
  80585f:	48 83 c0 20          	add    $0x20,%rax
  805863:	48 39 c2             	cmp    %rax,%rdx
  805866:	73 b4                	jae    80581c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80586c:	8b 40 04             	mov    0x4(%rax),%eax
  80586f:	99                   	cltd   
  805870:	c1 ea 1b             	shr    $0x1b,%edx
  805873:	01 d0                	add    %edx,%eax
  805875:	83 e0 1f             	and    $0x1f,%eax
  805878:	29 d0                	sub    %edx,%eax
  80587a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80587e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805882:	48 01 ca             	add    %rcx,%rdx
  805885:	0f b6 0a             	movzbl (%rdx),%ecx
  805888:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80588c:	48 98                	cltq   
  80588e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805896:	8b 40 04             	mov    0x4(%rax),%eax
  805899:	8d 50 01             	lea    0x1(%rax),%edx
  80589c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058a0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8058a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8058a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058ac:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8058b0:	0f 82 64 ff ff ff    	jb     80581a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8058b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8058ba:	c9                   	leaveq 
  8058bb:	c3                   	retq   

00000000008058bc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8058bc:	55                   	push   %rbp
  8058bd:	48 89 e5             	mov    %rsp,%rbp
  8058c0:	48 83 ec 20          	sub    $0x20,%rsp
  8058c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8058c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8058cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058d0:	48 89 c7             	mov    %rax,%rdi
  8058d3:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  8058da:	00 00 00 
  8058dd:	ff d0                	callq  *%rax
  8058df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8058e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8058e7:	48 be 80 68 80 00 00 	movabs $0x806880,%rsi
  8058ee:	00 00 00 
  8058f1:	48 89 c7             	mov    %rax,%rdi
  8058f4:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  8058fb:	00 00 00 
  8058fe:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805904:	8b 50 04             	mov    0x4(%rax),%edx
  805907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80590b:	8b 00                	mov    (%rax),%eax
  80590d:	29 c2                	sub    %eax,%edx
  80590f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805913:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  805919:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80591d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805924:	00 00 00 
	stat->st_dev = &devpipe;
  805927:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80592b:	48 b9 c0 80 80 00 00 	movabs $0x8080c0,%rcx
  805932:	00 00 00 
  805935:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80593c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805941:	c9                   	leaveq 
  805942:	c3                   	retq   

0000000000805943 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805943:	55                   	push   %rbp
  805944:	48 89 e5             	mov    %rsp,%rbp
  805947:	48 83 ec 10          	sub    $0x10,%rsp
  80594b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80594f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805953:	48 89 c6             	mov    %rax,%rsi
  805956:	bf 00 00 00 00       	mov    $0x0,%edi
  80595b:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  805962:	00 00 00 
  805965:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  805967:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80596b:	48 89 c7             	mov    %rax,%rdi
  80596e:	48 b8 33 36 80 00 00 	movabs $0x803633,%rax
  805975:	00 00 00 
  805978:	ff d0                	callq  *%rax
  80597a:	48 89 c6             	mov    %rax,%rsi
  80597d:	bf 00 00 00 00       	mov    $0x0,%edi
  805982:	48 b8 5f 2b 80 00 00 	movabs $0x802b5f,%rax
  805989:	00 00 00 
  80598c:	ff d0                	callq  *%rax
}
  80598e:	c9                   	leaveq 
  80598f:	c3                   	retq   

0000000000805990 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  805990:	55                   	push   %rbp
  805991:	48 89 e5             	mov    %rsp,%rbp
  805994:	48 83 ec 20          	sub    $0x20,%rsp
  805998:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80599b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80599f:	75 35                	jne    8059d6 <wait+0x46>
  8059a1:	48 b9 87 68 80 00 00 	movabs $0x806887,%rcx
  8059a8:	00 00 00 
  8059ab:	48 ba 92 68 80 00 00 	movabs $0x806892,%rdx
  8059b2:	00 00 00 
  8059b5:	be 09 00 00 00       	mov    $0x9,%esi
  8059ba:	48 bf a7 68 80 00 00 	movabs $0x8068a7,%rdi
  8059c1:	00 00 00 
  8059c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8059c9:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  8059d0:	00 00 00 
  8059d3:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8059d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8059de:	48 63 d0             	movslq %eax,%rdx
  8059e1:	48 89 d0             	mov    %rdx,%rax
  8059e4:	48 c1 e0 03          	shl    $0x3,%rax
  8059e8:	48 01 d0             	add    %rdx,%rax
  8059eb:	48 c1 e0 05          	shl    $0x5,%rax
  8059ef:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8059f6:	00 00 00 
  8059f9:	48 01 d0             	add    %rdx,%rax
  8059fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805a00:	eb 0c                	jmp    805a0e <wait+0x7e>
		sys_yield();
  805a02:	48 b8 76 2a 80 00 00 	movabs $0x802a76,%rax
  805a09:	00 00 00 
  805a0c:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805a0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a12:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805a18:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805a1b:	75 0e                	jne    805a2b <wait+0x9b>
  805a1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a21:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805a27:	85 c0                	test   %eax,%eax
  805a29:	75 d7                	jne    805a02 <wait+0x72>
		sys_yield();
}
  805a2b:	c9                   	leaveq 
  805a2c:	c3                   	retq   

0000000000805a2d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805a2d:	55                   	push   %rbp
  805a2e:	48 89 e5             	mov    %rsp,%rbp
  805a31:	48 83 ec 10          	sub    $0x10,%rsp
  805a35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  805a39:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805a40:	00 00 00 
  805a43:	48 8b 00             	mov    (%rax),%rax
  805a46:	48 85 c0             	test   %rax,%rax
  805a49:	75 49                	jne    805a94 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  805a4b:	ba 07 00 00 00       	mov    $0x7,%edx
  805a50:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805a55:	bf 00 00 00 00       	mov    $0x0,%edi
  805a5a:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  805a61:	00 00 00 
  805a64:	ff d0                	callq  *%rax
  805a66:	85 c0                	test   %eax,%eax
  805a68:	79 2a                	jns    805a94 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  805a6a:	48 ba b8 68 80 00 00 	movabs $0x8068b8,%rdx
  805a71:	00 00 00 
  805a74:	be 21 00 00 00       	mov    $0x21,%esi
  805a79:	48 bf e3 68 80 00 00 	movabs $0x8068e3,%rdi
  805a80:	00 00 00 
  805a83:	b8 00 00 00 00       	mov    $0x0,%eax
  805a88:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  805a8f:	00 00 00 
  805a92:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805a94:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805a9b:	00 00 00 
  805a9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805aa2:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  805aa5:	48 be f0 5a 80 00 00 	movabs $0x805af0,%rsi
  805aac:	00 00 00 
  805aaf:	bf 00 00 00 00       	mov    $0x0,%edi
  805ab4:	48 b8 3e 2c 80 00 00 	movabs $0x802c3e,%rax
  805abb:	00 00 00 
  805abe:	ff d0                	callq  *%rax
  805ac0:	85 c0                	test   %eax,%eax
  805ac2:	79 2a                	jns    805aee <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  805ac4:	48 ba f8 68 80 00 00 	movabs $0x8068f8,%rdx
  805acb:	00 00 00 
  805ace:	be 27 00 00 00       	mov    $0x27,%esi
  805ad3:	48 bf e3 68 80 00 00 	movabs $0x8068e3,%rdi
  805ada:	00 00 00 
  805add:	b8 00 00 00 00       	mov    $0x0,%eax
  805ae2:	48 b9 2a 12 80 00 00 	movabs $0x80122a,%rcx
  805ae9:	00 00 00 
  805aec:	ff d1                	callq  *%rcx
}
  805aee:	c9                   	leaveq 
  805aef:	c3                   	retq   

0000000000805af0 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805af0:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805af3:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  805afa:	00 00 00 
call *%rax
  805afd:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  805aff:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805b06:	00 
    movq 152(%rsp), %rcx
  805b07:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805b0e:	00 
    subq $8, %rcx
  805b0f:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  805b13:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  805b16:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  805b1d:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  805b1e:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  805b22:	4c 8b 3c 24          	mov    (%rsp),%r15
  805b26:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805b2b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805b30:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805b35:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805b3a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805b3f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805b44:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805b49:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805b4e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805b53:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805b58:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805b5d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805b62:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805b67:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805b6c:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  805b70:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  805b74:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  805b75:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  805b76:	c3                   	retq   

0000000000805b77 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805b77:	55                   	push   %rbp
  805b78:	48 89 e5             	mov    %rsp,%rbp
  805b7b:	48 83 ec 30          	sub    $0x30,%rsp
  805b7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805b87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  805b8b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805b90:	75 0e                	jne    805ba0 <ipc_recv+0x29>
        pg = (void *)UTOP;
  805b92:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805b99:	00 00 00 
  805b9c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  805ba0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ba4:	48 89 c7             	mov    %rax,%rdi
  805ba7:	48 b8 dd 2c 80 00 00 	movabs $0x802cdd,%rax
  805bae:	00 00 00 
  805bb1:	ff d0                	callq  *%rax
  805bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bba:	79 27                	jns    805be3 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  805bbc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805bc1:	74 0a                	je     805bcd <ipc_recv+0x56>
            *from_env_store = 0;
  805bc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bc7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  805bcd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805bd2:	74 0a                	je     805bde <ipc_recv+0x67>
            *perm_store = 0;
  805bd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805bd8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  805bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805be1:	eb 53                	jmp    805c36 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  805be3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805be8:	74 19                	je     805c03 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  805bea:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805bf1:	00 00 00 
  805bf4:	48 8b 00             	mov    (%rax),%rax
  805bf7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c01:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  805c03:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805c08:	74 19                	je     805c23 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  805c0a:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805c11:	00 00 00 
  805c14:	48 8b 00             	mov    (%rax),%rax
  805c17:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805c1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805c21:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  805c23:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805c2a:	00 00 00 
  805c2d:	48 8b 00             	mov    (%rax),%rax
  805c30:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  805c36:	c9                   	leaveq 
  805c37:	c3                   	retq   

0000000000805c38 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805c38:	55                   	push   %rbp
  805c39:	48 89 e5             	mov    %rsp,%rbp
  805c3c:	48 83 ec 30          	sub    $0x30,%rsp
  805c40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805c43:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805c46:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805c4a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  805c4d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805c52:	75 0e                	jne    805c62 <ipc_send+0x2a>
        pg = (void *)UTOP;
  805c54:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805c5b:	00 00 00 
  805c5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  805c62:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805c65:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805c68:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805c6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805c6f:	89 c7                	mov    %eax,%edi
  805c71:	48 b8 88 2c 80 00 00 	movabs $0x802c88,%rax
  805c78:	00 00 00 
  805c7b:	ff d0                	callq  *%rax
  805c7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  805c80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c84:	79 36                	jns    805cbc <ipc_send+0x84>
  805c86:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805c8a:	74 30                	je     805cbc <ipc_send+0x84>
            panic("ipc_send: %e", r);
  805c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c8f:	89 c1                	mov    %eax,%ecx
  805c91:	48 ba 2f 69 80 00 00 	movabs $0x80692f,%rdx
  805c98:	00 00 00 
  805c9b:	be 49 00 00 00       	mov    $0x49,%esi
  805ca0:	48 bf 3c 69 80 00 00 	movabs $0x80693c,%rdi
  805ca7:	00 00 00 
  805caa:	b8 00 00 00 00       	mov    $0x0,%eax
  805caf:	49 b8 2a 12 80 00 00 	movabs $0x80122a,%r8
  805cb6:	00 00 00 
  805cb9:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  805cbc:	48 b8 76 2a 80 00 00 	movabs $0x802a76,%rax
  805cc3:	00 00 00 
  805cc6:	ff d0                	callq  *%rax
    } while(r != 0);
  805cc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ccc:	75 94                	jne    805c62 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  805cce:	c9                   	leaveq 
  805ccf:	c3                   	retq   

0000000000805cd0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805cd0:	55                   	push   %rbp
  805cd1:	48 89 e5             	mov    %rsp,%rbp
  805cd4:	48 83 ec 14          	sub    $0x14,%rsp
  805cd8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805ce2:	eb 5e                	jmp    805d42 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  805ce4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805ceb:	00 00 00 
  805cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805cf1:	48 63 d0             	movslq %eax,%rdx
  805cf4:	48 89 d0             	mov    %rdx,%rax
  805cf7:	48 c1 e0 03          	shl    $0x3,%rax
  805cfb:	48 01 d0             	add    %rdx,%rax
  805cfe:	48 c1 e0 05          	shl    $0x5,%rax
  805d02:	48 01 c8             	add    %rcx,%rax
  805d05:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805d0b:	8b 00                	mov    (%rax),%eax
  805d0d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805d10:	75 2c                	jne    805d3e <ipc_find_env+0x6e>
			return envs[i].env_id;
  805d12:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805d19:	00 00 00 
  805d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d1f:	48 63 d0             	movslq %eax,%rdx
  805d22:	48 89 d0             	mov    %rdx,%rax
  805d25:	48 c1 e0 03          	shl    $0x3,%rax
  805d29:	48 01 d0             	add    %rdx,%rax
  805d2c:	48 c1 e0 05          	shl    $0x5,%rax
  805d30:	48 01 c8             	add    %rcx,%rax
  805d33:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805d39:	8b 40 08             	mov    0x8(%rax),%eax
  805d3c:	eb 12                	jmp    805d50 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805d3e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805d42:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805d49:	7e 99                	jle    805ce4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805d50:	c9                   	leaveq 
  805d51:	c3                   	retq   

0000000000805d52 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805d52:	55                   	push   %rbp
  805d53:	48 89 e5             	mov    %rsp,%rbp
  805d56:	48 83 ec 18          	sub    $0x18,%rsp
  805d5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805d5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d62:	48 c1 e8 15          	shr    $0x15,%rax
  805d66:	48 89 c2             	mov    %rax,%rdx
  805d69:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805d70:	01 00 00 
  805d73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d77:	83 e0 01             	and    $0x1,%eax
  805d7a:	48 85 c0             	test   %rax,%rax
  805d7d:	75 07                	jne    805d86 <pageref+0x34>
		return 0;
  805d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  805d84:	eb 53                	jmp    805dd9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805d86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d8a:	48 c1 e8 0c          	shr    $0xc,%rax
  805d8e:	48 89 c2             	mov    %rax,%rdx
  805d91:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805d98:	01 00 00 
  805d9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805da7:	83 e0 01             	and    $0x1,%eax
  805daa:	48 85 c0             	test   %rax,%rax
  805dad:	75 07                	jne    805db6 <pageref+0x64>
		return 0;
  805daf:	b8 00 00 00 00       	mov    $0x0,%eax
  805db4:	eb 23                	jmp    805dd9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805db6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805dba:	48 c1 e8 0c          	shr    $0xc,%rax
  805dbe:	48 89 c2             	mov    %rax,%rdx
  805dc1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805dc8:	00 00 00 
  805dcb:	48 c1 e2 04          	shl    $0x4,%rdx
  805dcf:	48 01 d0             	add    %rdx,%rax
  805dd2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805dd6:	0f b7 c0             	movzwl %ax,%eax
}
  805dd9:	c9                   	leaveq 
  805dda:	c3                   	retq   
