
obj/user/testpipe:     file format elf64-x86-64


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
  80003c:	e8 fe 04 00 00       	callq  80053f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80004f:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  800055:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800063:	00 00 00 
  800066:	48 bb 04 43 80 00 00 	movabs $0x804304,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 e3 35 80 00 00 	movabs $0x8035e3,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba 10 43 80 00 00 	movabs $0x804310,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 e9 22 80 00 00 	movabs $0x8022e9,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba 29 43 80 00 00 	movabs $0x804329,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  800101:	00 00 00 
  800104:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80010b:	0f 85 5c 01 00 00    	jne    80026d <umain+0x22a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800111:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  800117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf 32 43 80 00 00 	movabs $0x804332,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf 4f 43 80 00 00 	movabs $0x80434f,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  80018c:	00 00 00 
  80018f:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800191:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800197:	48 8d 4d 80          	lea    -0x80(%rbp),%rcx
  80019b:	ba 63 00 00 00       	mov    $0x63,%edx
  8001a0:	48 89 ce             	mov    %rcx,%rsi
  8001a3:	89 c7                	mov    %eax,%edi
  8001a5:	48 b8 87 2b 80 00 00 	movabs $0x802b87,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 6c 43 80 00 00 	movabs $0x80436c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  8001e4:	00 00 00 
  8001e7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 10             	mov    (%rax),%rdx
  800201:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800205:	48 89 d6             	mov    %rdx,%rsi
  800208:	48 89 c7             	mov    %rax,%rdi
  80020b:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
  800217:	85 c0                	test   %eax,%eax
  800219:	75 1d                	jne    800238 <umain+0x1f5>
			cprintf("\npipe read closed properly\n");
  80021b:	48 bf 75 43 80 00 00 	movabs $0x804375,%rdi
  800222:	00 00 00 
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
  80022a:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  800231:	00 00 00 
  800234:	ff d2                	callq  *%rdx
  800236:	eb 24                	jmp    80025c <umain+0x219>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800238:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	89 c6                	mov    %eax,%esi
  800241:	48 bf 91 43 80 00 00 	movabs $0x804391,%rdi
  800248:	00 00 00 
  80024b:	b8 00 00 00 00       	mov    $0x0,%eax
  800250:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  800257:	00 00 00 
  80025a:	ff d1                	callq  *%rcx
		exit();
  80025c:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
  800268:	e9 2b 01 00 00       	jmpq   800398 <umain+0x355>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80026d:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800273:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf 32 43 80 00 00 	movabs $0x804332,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf a4 43 80 00 00 	movabs $0x8043a4,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033a:	00 00 00 
  80033d:	48 8b 00             	mov    (%rax),%rax
  800340:	48 89 c7             	mov    %rax,%rdi
  800343:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
  80034f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
  800352:	74 30                	je     800384 <umain+0x341>
			panic("write: %e", i);
  800354:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	48 ba c1 43 80 00 00 	movabs $0x8043c1,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 ac 3b 80 00 00 	movabs $0x803bac,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb cb 43 80 00 00 	movabs $0x8043cb,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 e3 35 80 00 00 	movabs $0x8035e3,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba 10 43 80 00 00 	movabs $0x804310,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 e9 22 80 00 00 	movabs $0x8022e9,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba 29 43 80 00 00 	movabs $0x804329,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf 19 43 80 00 00 	movabs $0x804319,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  80044e:	00 00 00 
  800451:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800454:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800458:	0f 85 83 00 00 00    	jne    8004e1 <umain+0x49e>
		close(p[0]);
  80045e:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf d8 43 80 00 00 	movabs $0x8043d8,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be da 43 80 00 00 	movabs $0x8043da,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf dc 43 80 00 00 	movabs $0x8043dc,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  8004cc:	00 00 00 
  8004cf:	ff d2                	callq  *%rdx
		exit();
  8004d1:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	eb 02                	jmp    8004e1 <umain+0x49e>
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  8004df:	eb 91                	jmp    800472 <umain+0x42f>
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  8004e1:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 ac 3b 80 00 00 	movabs $0x803bac,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf f9 43 80 00 00 	movabs $0x8043f9,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  800530:	00 00 00 
  800533:	ff d2                	callq  *%rdx
}
  800535:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80053c:	5b                   	pop    %rbx
  80053d:	5d                   	pop    %rbp
  80053e:	c3                   	retq   

000000000080053f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 20          	sub    $0x20,%rsp
  800547:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80054a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t id = sys_getenvid();
  80054e:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	thisenv = &envs[ENVX(id)];
  80055d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800560:	25 ff 03 00 00       	and    $0x3ff,%eax
  800565:	48 63 d0             	movslq %eax,%rdx
  800568:	48 89 d0             	mov    %rdx,%rax
  80056b:	48 c1 e0 03          	shl    $0x3,%rax
  80056f:	48 01 d0             	add    %rdx,%rax
  800572:	48 c1 e0 05          	shl    $0x5,%rax
  800576:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80057d:	00 00 00 
  800580:	48 01 c2             	add    %rax,%rdx
  800583:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80058a:	00 00 00 
  80058d:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800590:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800594:	7e 14                	jle    8005aa <libmain+0x6b>
		binaryname = argv[0];
  800596:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80059a:	48 8b 10             	mov    (%rax),%rdx
  80059d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8005a4:	00 00 00 
  8005a7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8005ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8005b1:	48 89 d6             	mov    %rdx,%rsi
  8005b4:	89 c7                	mov    %eax,%edi
  8005b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005bd:	00 00 00 
  8005c0:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005c2:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  8005c9:	00 00 00 
  8005cc:	ff d0                	callq  *%rax
}
  8005ce:	c9                   	leaveq 
  8005cf:	c3                   	retq   

00000000008005d0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005d0:	55                   	push   %rbp
  8005d1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005d4:	48 b8 db 28 80 00 00 	movabs $0x8028db,%rax
  8005db:	00 00 00 
  8005de:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8005e5:	48 b8 63 1c 80 00 00 	movabs $0x801c63,%rax
  8005ec:	00 00 00 
  8005ef:	ff d0                	callq  *%rax
}
  8005f1:	5d                   	pop    %rbp
  8005f2:	c3                   	retq   

00000000008005f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	53                   	push   %rbx
  8005f8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005ff:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800606:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80060c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800613:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80061a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800621:	84 c0                	test   %al,%al
  800623:	74 23                	je     800648 <_panic+0x55>
  800625:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80062c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800630:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800634:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800638:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80063c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800640:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800644:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800648:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80064f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800656:	00 00 00 
  800659:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800660:	00 00 00 
  800663:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800667:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80066e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800675:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80067c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800683:	00 00 00 
  800686:	48 8b 18             	mov    (%rax),%rbx
  800689:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  800690:	00 00 00 
  800693:	ff d0                	callq  *%rax
  800695:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80069b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8006a2:	41 89 c8             	mov    %ecx,%r8d
  8006a5:	48 89 d1             	mov    %rdx,%rcx
  8006a8:	48 89 da             	mov    %rbx,%rdx
  8006ab:	89 c6                	mov    %eax,%esi
  8006ad:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  8006b4:	00 00 00 
  8006b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006bc:	49 b9 2c 08 80 00 00 	movabs $0x80082c,%r9
  8006c3:	00 00 00 
  8006c6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006c9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006d0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d7:	48 89 d6             	mov    %rdx,%rsi
  8006da:	48 89 c7             	mov    %rax,%rdi
  8006dd:	48 b8 80 07 80 00 00 	movabs $0x800780,%rax
  8006e4:	00 00 00 
  8006e7:	ff d0                	callq  *%rax
	cprintf("\n");
  8006e9:	48 bf 3b 44 80 00 00 	movabs $0x80443b,%rdi
  8006f0:	00 00 00 
  8006f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f8:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  8006ff:	00 00 00 
  800702:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800704:	cc                   	int3   
  800705:	eb fd                	jmp    800704 <_panic+0x111>

0000000000800707 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800707:	55                   	push   %rbp
  800708:	48 89 e5             	mov    %rsp,%rbp
  80070b:	48 83 ec 10          	sub    $0x10,%rsp
  80070f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800712:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071a:	8b 00                	mov    (%rax),%eax
  80071c:	8d 48 01             	lea    0x1(%rax),%ecx
  80071f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800723:	89 0a                	mov    %ecx,(%rdx)
  800725:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800728:	89 d1                	mov    %edx,%ecx
  80072a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80072e:	48 98                	cltq   
  800730:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800738:	8b 00                	mov    (%rax),%eax
  80073a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073f:	75 2c                	jne    80076d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	48 98                	cltq   
  800749:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80074d:	48 83 c2 08          	add    $0x8,%rdx
  800751:	48 89 c6             	mov    %rax,%rsi
  800754:	48 89 d7             	mov    %rdx,%rdi
  800757:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  80075e:	00 00 00 
  800761:	ff d0                	callq  *%rax
        b->idx = 0;
  800763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800767:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80076d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800771:	8b 40 04             	mov    0x4(%rax),%eax
  800774:	8d 50 01             	lea    0x1(%rax),%edx
  800777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80077b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80077e:	c9                   	leaveq 
  80077f:	c3                   	retq   

0000000000800780 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800780:	55                   	push   %rbp
  800781:	48 89 e5             	mov    %rsp,%rbp
  800784:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80078b:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800792:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800799:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8007a0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007a7:	48 8b 0a             	mov    (%rdx),%rcx
  8007aa:	48 89 08             	mov    %rcx,(%rax)
  8007ad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8007bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007c4:	00 00 00 
    b.cnt = 0;
  8007c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007ce:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007d1:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007d8:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007df:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007e6:	48 89 c6             	mov    %rax,%rsi
  8007e9:	48 bf 07 07 80 00 00 	movabs $0x800707,%rdi
  8007f0:	00 00 00 
  8007f3:	48 b8 df 0b 80 00 00 	movabs $0x800bdf,%rax
  8007fa:	00 00 00 
  8007fd:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007ff:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800805:	48 98                	cltq   
  800807:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80080e:	48 83 c2 08          	add    $0x8,%rdx
  800812:	48 89 c6             	mov    %rax,%rsi
  800815:	48 89 d7             	mov    %rdx,%rdi
  800818:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  80081f:	00 00 00 
  800822:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800824:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80082a:	c9                   	leaveq 
  80082b:	c3                   	retq   

000000000080082c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80082c:	55                   	push   %rbp
  80082d:	48 89 e5             	mov    %rsp,%rbp
  800830:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800837:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80083e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800845:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80084c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800853:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80085a:	84 c0                	test   %al,%al
  80085c:	74 20                	je     80087e <cprintf+0x52>
  80085e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800862:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800866:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80086a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80086e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800872:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800876:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80087a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80087e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800885:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80088c:	00 00 00 
  80088f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800896:	00 00 00 
  800899:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80089d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008a4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008ab:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8008b2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008b9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008c0:	48 8b 0a             	mov    (%rdx),%rcx
  8008c3:	48 89 08             	mov    %rcx,(%rax)
  8008c6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008ca:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008ce:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008d6:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008dd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008e4:	48 89 d6             	mov    %rdx,%rsi
  8008e7:	48 89 c7             	mov    %rax,%rdi
  8008ea:	48 b8 80 07 80 00 00 	movabs $0x800780,%rax
  8008f1:	00 00 00 
  8008f4:	ff d0                	callq  *%rax
  8008f6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008fc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800902:	c9                   	leaveq 
  800903:	c3                   	retq   

0000000000800904 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800904:	55                   	push   %rbp
  800905:	48 89 e5             	mov    %rsp,%rbp
  800908:	53                   	push   %rbx
  800909:	48 83 ec 38          	sub    $0x38,%rsp
  80090d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800911:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800915:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800919:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80091c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800920:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800924:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800927:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80092b:	77 3b                	ja     800968 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80092d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800930:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800934:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093b:	ba 00 00 00 00       	mov    $0x0,%edx
  800940:	48 f7 f3             	div    %rbx
  800943:	48 89 c2             	mov    %rax,%rdx
  800946:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800949:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80094c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800954:	41 89 f9             	mov    %edi,%r9d
  800957:	48 89 c7             	mov    %rax,%rdi
  80095a:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  800961:	00 00 00 
  800964:	ff d0                	callq  *%rax
  800966:	eb 1e                	jmp    800986 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800968:	eb 12                	jmp    80097c <printnum+0x78>
			putch(padc, putdat);
  80096a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80096e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800975:	48 89 ce             	mov    %rcx,%rsi
  800978:	89 d7                	mov    %edx,%edi
  80097a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80097c:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800980:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800984:	7f e4                	jg     80096a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800986:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800989:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80098d:	ba 00 00 00 00       	mov    $0x0,%edx
  800992:	48 f7 f1             	div    %rcx
  800995:	48 89 d0             	mov    %rdx,%rax
  800998:	48 ba 30 46 80 00 00 	movabs $0x804630,%rdx
  80099f:	00 00 00 
  8009a2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009a6:	0f be d0             	movsbl %al,%edx
  8009a9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 89 ce             	mov    %rcx,%rsi
  8009b4:	89 d7                	mov    %edx,%edi
  8009b6:	ff d0                	callq  *%rax
}
  8009b8:	48 83 c4 38          	add    $0x38,%rsp
  8009bc:	5b                   	pop    %rbx
  8009bd:	5d                   	pop    %rbp
  8009be:	c3                   	retq   

00000000008009bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009bf:	55                   	push   %rbp
  8009c0:	48 89 e5             	mov    %rsp,%rbp
  8009c3:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009cb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8009ce:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009d2:	7e 52                	jle    800a26 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d8:	8b 00                	mov    (%rax),%eax
  8009da:	83 f8 30             	cmp    $0x30,%eax
  8009dd:	73 24                	jae    800a03 <getuint+0x44>
  8009df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	8b 00                	mov    (%rax),%eax
  8009ed:	89 c0                	mov    %eax,%eax
  8009ef:	48 01 d0             	add    %rdx,%rax
  8009f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f6:	8b 12                	mov    (%rdx),%edx
  8009f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ff:	89 0a                	mov    %ecx,(%rdx)
  800a01:	eb 17                	jmp    800a1a <getuint+0x5b>
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0b:	48 89 d0             	mov    %rdx,%rax
  800a0e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a16:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1a:	48 8b 00             	mov    (%rax),%rax
  800a1d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a21:	e9 a3 00 00 00       	jmpq   800ac9 <getuint+0x10a>
	else if (lflag)
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a2a:	74 4f                	je     800a7b <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a30:	8b 00                	mov    (%rax),%eax
  800a32:	83 f8 30             	cmp    $0x30,%eax
  800a35:	73 24                	jae    800a5b <getuint+0x9c>
  800a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	8b 00                	mov    (%rax),%eax
  800a45:	89 c0                	mov    %eax,%eax
  800a47:	48 01 d0             	add    %rdx,%rax
  800a4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4e:	8b 12                	mov    (%rdx),%edx
  800a50:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a57:	89 0a                	mov    %ecx,(%rdx)
  800a59:	eb 17                	jmp    800a72 <getuint+0xb3>
  800a5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a63:	48 89 d0             	mov    %rdx,%rax
  800a66:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a72:	48 8b 00             	mov    (%rax),%rax
  800a75:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a79:	eb 4e                	jmp    800ac9 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7f:	8b 00                	mov    (%rax),%eax
  800a81:	83 f8 30             	cmp    $0x30,%eax
  800a84:	73 24                	jae    800aaa <getuint+0xeb>
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a92:	8b 00                	mov    (%rax),%eax
  800a94:	89 c0                	mov    %eax,%eax
  800a96:	48 01 d0             	add    %rdx,%rax
  800a99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9d:	8b 12                	mov    (%rdx),%edx
  800a9f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa6:	89 0a                	mov    %ecx,(%rdx)
  800aa8:	eb 17                	jmp    800ac1 <getuint+0x102>
  800aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aae:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab2:	48 89 d0             	mov    %rdx,%rax
  800ab5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac1:	8b 00                	mov    (%rax),%eax
  800ac3:	89 c0                	mov    %eax,%eax
  800ac5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800acd:	c9                   	leaveq 
  800ace:	c3                   	retq   

0000000000800acf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800acf:	55                   	push   %rbp
  800ad0:	48 89 e5             	mov    %rsp,%rbp
  800ad3:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ad7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800adb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ade:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ae2:	7e 52                	jle    800b36 <getint+0x67>
		x=va_arg(*ap, long long);
  800ae4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae8:	8b 00                	mov    (%rax),%eax
  800aea:	83 f8 30             	cmp    $0x30,%eax
  800aed:	73 24                	jae    800b13 <getint+0x44>
  800aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afb:	8b 00                	mov    (%rax),%eax
  800afd:	89 c0                	mov    %eax,%eax
  800aff:	48 01 d0             	add    %rdx,%rax
  800b02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b06:	8b 12                	mov    (%rdx),%edx
  800b08:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0f:	89 0a                	mov    %ecx,(%rdx)
  800b11:	eb 17                	jmp    800b2a <getint+0x5b>
  800b13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b17:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b1b:	48 89 d0             	mov    %rdx,%rax
  800b1e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b2a:	48 8b 00             	mov    (%rax),%rax
  800b2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b31:	e9 a3 00 00 00       	jmpq   800bd9 <getint+0x10a>
	else if (lflag)
  800b36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b3a:	74 4f                	je     800b8b <getint+0xbc>
		x=va_arg(*ap, long);
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	8b 00                	mov    (%rax),%eax
  800b42:	83 f8 30             	cmp    $0x30,%eax
  800b45:	73 24                	jae    800b6b <getint+0x9c>
  800b47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b53:	8b 00                	mov    (%rax),%eax
  800b55:	89 c0                	mov    %eax,%eax
  800b57:	48 01 d0             	add    %rdx,%rax
  800b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5e:	8b 12                	mov    (%rdx),%edx
  800b60:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b67:	89 0a                	mov    %ecx,(%rdx)
  800b69:	eb 17                	jmp    800b82 <getint+0xb3>
  800b6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b73:	48 89 d0             	mov    %rdx,%rax
  800b76:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b82:	48 8b 00             	mov    (%rax),%rax
  800b85:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b89:	eb 4e                	jmp    800bd9 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8f:	8b 00                	mov    (%rax),%eax
  800b91:	83 f8 30             	cmp    $0x30,%eax
  800b94:	73 24                	jae    800bba <getint+0xeb>
  800b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba2:	8b 00                	mov    (%rax),%eax
  800ba4:	89 c0                	mov    %eax,%eax
  800ba6:	48 01 d0             	add    %rdx,%rax
  800ba9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bad:	8b 12                	mov    (%rdx),%edx
  800baf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb6:	89 0a                	mov    %ecx,(%rdx)
  800bb8:	eb 17                	jmp    800bd1 <getint+0x102>
  800bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc2:	48 89 d0             	mov    %rdx,%rax
  800bc5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bd1:	8b 00                	mov    (%rax),%eax
  800bd3:	48 98                	cltq   
  800bd5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bdd:	c9                   	leaveq 
  800bde:	c3                   	retq   

0000000000800bdf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bdf:	55                   	push   %rbp
  800be0:	48 89 e5             	mov    %rsp,%rbp
  800be3:	41 54                	push   %r12
  800be5:	53                   	push   %rbx
  800be6:	48 83 ec 60          	sub    $0x60,%rsp
  800bea:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bee:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bf2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bf6:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfe:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c02:	48 8b 0a             	mov    (%rdx),%rcx
  800c05:	48 89 08             	mov    %rcx,(%rax)
  800c08:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c0c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c10:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c14:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c18:	eb 17                	jmp    800c31 <vprintfmt+0x52>
			if (ch == '\0')
  800c1a:	85 db                	test   %ebx,%ebx
  800c1c:	0f 84 df 04 00 00    	je     801101 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800c22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2a:	48 89 d6             	mov    %rdx,%rsi
  800c2d:	89 df                	mov    %ebx,%edi
  800c2f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c35:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c39:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c3d:	0f b6 00             	movzbl (%rax),%eax
  800c40:	0f b6 d8             	movzbl %al,%ebx
  800c43:	83 fb 25             	cmp    $0x25,%ebx
  800c46:	75 d2                	jne    800c1a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c48:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c4c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c53:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c61:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c68:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c6c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c70:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c74:	0f b6 00             	movzbl (%rax),%eax
  800c77:	0f b6 d8             	movzbl %al,%ebx
  800c7a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c7d:	83 f8 55             	cmp    $0x55,%eax
  800c80:	0f 87 47 04 00 00    	ja     8010cd <vprintfmt+0x4ee>
  800c86:	89 c0                	mov    %eax,%eax
  800c88:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c8f:	00 
  800c90:	48 b8 58 46 80 00 00 	movabs $0x804658,%rax
  800c97:	00 00 00 
  800c9a:	48 01 d0             	add    %rdx,%rax
  800c9d:	48 8b 00             	mov    (%rax),%rax
  800ca0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ca2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ca6:	eb c0                	jmp    800c68 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cac:	eb ba                	jmp    800c68 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cb5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cb8:	89 d0                	mov    %edx,%eax
  800cba:	c1 e0 02             	shl    $0x2,%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	01 c0                	add    %eax,%eax
  800cc1:	01 d8                	add    %ebx,%eax
  800cc3:	83 e8 30             	sub    $0x30,%eax
  800cc6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cc9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ccd:	0f b6 00             	movzbl (%rax),%eax
  800cd0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd3:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd6:	7e 0c                	jle    800ce4 <vprintfmt+0x105>
  800cd8:	83 fb 39             	cmp    $0x39,%ebx
  800cdb:	7f 07                	jg     800ce4 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cdd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce2:	eb d1                	jmp    800cb5 <vprintfmt+0xd6>
			goto process_precision;
  800ce4:	eb 58                	jmp    800d3e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ce6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce9:	83 f8 30             	cmp    $0x30,%eax
  800cec:	73 17                	jae    800d05 <vprintfmt+0x126>
  800cee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf5:	89 c0                	mov    %eax,%eax
  800cf7:	48 01 d0             	add    %rdx,%rax
  800cfa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfd:	83 c2 08             	add    $0x8,%edx
  800d00:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d03:	eb 0f                	jmp    800d14 <vprintfmt+0x135>
  800d05:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d09:	48 89 d0             	mov    %rdx,%rax
  800d0c:	48 83 c2 08          	add    $0x8,%rdx
  800d10:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d14:	8b 00                	mov    (%rax),%eax
  800d16:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d19:	eb 23                	jmp    800d3e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800d1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1f:	79 0c                	jns    800d2d <vprintfmt+0x14e>
				width = 0;
  800d21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d28:	e9 3b ff ff ff       	jmpq   800c68 <vprintfmt+0x89>
  800d2d:	e9 36 ff ff ff       	jmpq   800c68 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d32:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d39:	e9 2a ff ff ff       	jmpq   800c68 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d42:	79 12                	jns    800d56 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d44:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d47:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d4a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d51:	e9 12 ff ff ff       	jmpq   800c68 <vprintfmt+0x89>
  800d56:	e9 0d ff ff ff       	jmpq   800c68 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d5b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d5f:	e9 04 ff ff ff       	jmpq   800c68 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d67:	83 f8 30             	cmp    $0x30,%eax
  800d6a:	73 17                	jae    800d83 <vprintfmt+0x1a4>
  800d6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d73:	89 c0                	mov    %eax,%eax
  800d75:	48 01 d0             	add    %rdx,%rax
  800d78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7b:	83 c2 08             	add    $0x8,%edx
  800d7e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d81:	eb 0f                	jmp    800d92 <vprintfmt+0x1b3>
  800d83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d87:	48 89 d0             	mov    %rdx,%rax
  800d8a:	48 83 c2 08          	add    $0x8,%rdx
  800d8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d92:	8b 10                	mov    (%rax),%edx
  800d94:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9c:	48 89 ce             	mov    %rcx,%rsi
  800d9f:	89 d7                	mov    %edx,%edi
  800da1:	ff d0                	callq  *%rax
			break;
  800da3:	e9 53 03 00 00       	jmpq   8010fb <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800da8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dab:	83 f8 30             	cmp    $0x30,%eax
  800dae:	73 17                	jae    800dc7 <vprintfmt+0x1e8>
  800db0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db7:	89 c0                	mov    %eax,%eax
  800db9:	48 01 d0             	add    %rdx,%rax
  800dbc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dbf:	83 c2 08             	add    $0x8,%edx
  800dc2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc5:	eb 0f                	jmp    800dd6 <vprintfmt+0x1f7>
  800dc7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dcb:	48 89 d0             	mov    %rdx,%rax
  800dce:	48 83 c2 08          	add    $0x8,%rdx
  800dd2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dd8:	85 db                	test   %ebx,%ebx
  800dda:	79 02                	jns    800dde <vprintfmt+0x1ff>
				err = -err;
  800ddc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dde:	83 fb 15             	cmp    $0x15,%ebx
  800de1:	7f 16                	jg     800df9 <vprintfmt+0x21a>
  800de3:	48 b8 80 45 80 00 00 	movabs $0x804580,%rax
  800dea:	00 00 00 
  800ded:	48 63 d3             	movslq %ebx,%rdx
  800df0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800df4:	4d 85 e4             	test   %r12,%r12
  800df7:	75 2e                	jne    800e27 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800df9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e01:	89 d9                	mov    %ebx,%ecx
  800e03:	48 ba 41 46 80 00 00 	movabs $0x804641,%rdx
  800e0a:	00 00 00 
  800e0d:	48 89 c7             	mov    %rax,%rdi
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
  800e15:	49 b8 0a 11 80 00 00 	movabs $0x80110a,%r8
  800e1c:	00 00 00 
  800e1f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e22:	e9 d4 02 00 00       	jmpq   8010fb <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e27:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2f:	4c 89 e1             	mov    %r12,%rcx
  800e32:	48 ba 4a 46 80 00 00 	movabs $0x80464a,%rdx
  800e39:	00 00 00 
  800e3c:	48 89 c7             	mov    %rax,%rdi
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	49 b8 0a 11 80 00 00 	movabs $0x80110a,%r8
  800e4b:	00 00 00 
  800e4e:	41 ff d0             	callq  *%r8
			break;
  800e51:	e9 a5 02 00 00       	jmpq   8010fb <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e59:	83 f8 30             	cmp    $0x30,%eax
  800e5c:	73 17                	jae    800e75 <vprintfmt+0x296>
  800e5e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e65:	89 c0                	mov    %eax,%eax
  800e67:	48 01 d0             	add    %rdx,%rax
  800e6a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6d:	83 c2 08             	add    $0x8,%edx
  800e70:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e73:	eb 0f                	jmp    800e84 <vprintfmt+0x2a5>
  800e75:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e79:	48 89 d0             	mov    %rdx,%rax
  800e7c:	48 83 c2 08          	add    $0x8,%rdx
  800e80:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e84:	4c 8b 20             	mov    (%rax),%r12
  800e87:	4d 85 e4             	test   %r12,%r12
  800e8a:	75 0a                	jne    800e96 <vprintfmt+0x2b7>
				p = "(null)";
  800e8c:	49 bc 4d 46 80 00 00 	movabs $0x80464d,%r12
  800e93:	00 00 00 
			if (width > 0 && padc != '-')
  800e96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9a:	7e 3f                	jle    800edb <vprintfmt+0x2fc>
  800e9c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ea0:	74 39                	je     800edb <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea5:	48 98                	cltq   
  800ea7:	48 89 c6             	mov    %rax,%rsi
  800eaa:	4c 89 e7             	mov    %r12,%rdi
  800ead:	48 b8 b6 13 80 00 00 	movabs $0x8013b6,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
  800eb9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ebc:	eb 17                	jmp    800ed5 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ebe:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ec2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ec6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eca:	48 89 ce             	mov    %rcx,%rsi
  800ecd:	89 d7                	mov    %edx,%edi
  800ecf:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ed5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed9:	7f e3                	jg     800ebe <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800edb:	eb 37                	jmp    800f14 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800edd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ee1:	74 1e                	je     800f01 <vprintfmt+0x322>
  800ee3:	83 fb 1f             	cmp    $0x1f,%ebx
  800ee6:	7e 05                	jle    800eed <vprintfmt+0x30e>
  800ee8:	83 fb 7e             	cmp    $0x7e,%ebx
  800eeb:	7e 14                	jle    800f01 <vprintfmt+0x322>
					putch('?', putdat);
  800eed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef5:	48 89 d6             	mov    %rdx,%rsi
  800ef8:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800efd:	ff d0                	callq  *%rax
  800eff:	eb 0f                	jmp    800f10 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800f01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f09:	48 89 d6             	mov    %rdx,%rsi
  800f0c:	89 df                	mov    %ebx,%edi
  800f0e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f10:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f14:	4c 89 e0             	mov    %r12,%rax
  800f17:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f1b:	0f b6 00             	movzbl (%rax),%eax
  800f1e:	0f be d8             	movsbl %al,%ebx
  800f21:	85 db                	test   %ebx,%ebx
  800f23:	74 10                	je     800f35 <vprintfmt+0x356>
  800f25:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f29:	78 b2                	js     800edd <vprintfmt+0x2fe>
  800f2b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f33:	79 a8                	jns    800edd <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f35:	eb 16                	jmp    800f4d <vprintfmt+0x36e>
				putch(' ', putdat);
  800f37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3f:	48 89 d6             	mov    %rdx,%rsi
  800f42:	bf 20 00 00 00       	mov    $0x20,%edi
  800f47:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f49:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f51:	7f e4                	jg     800f37 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f53:	e9 a3 01 00 00       	jmpq   8010fb <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f58:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f5c:	be 03 00 00 00       	mov    $0x3,%esi
  800f61:	48 89 c7             	mov    %rax,%rdi
  800f64:	48 b8 cf 0a 80 00 00 	movabs $0x800acf,%rax
  800f6b:	00 00 00 
  800f6e:	ff d0                	callq  *%rax
  800f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f78:	48 85 c0             	test   %rax,%rax
  800f7b:	79 1d                	jns    800f9a <vprintfmt+0x3bb>
				putch('-', putdat);
  800f7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f85:	48 89 d6             	mov    %rdx,%rsi
  800f88:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f8d:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	48 f7 d8             	neg    %rax
  800f96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f9a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa1:	e9 e8 00 00 00       	jmpq   80108e <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fa6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800faa:	be 03 00 00 00       	mov    $0x3,%esi
  800faf:	48 89 c7             	mov    %rax,%rdi
  800fb2:	48 b8 bf 09 80 00 00 	movabs $0x8009bf,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	callq  *%rax
  800fbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fc2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fc9:	e9 c0 00 00 00       	jmpq   80108e <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd6:	48 89 d6             	mov    %rdx,%rsi
  800fd9:	bf 58 00 00 00       	mov    $0x58,%edi
  800fde:	ff d0                	callq  *%rax
			putch('X', putdat);
  800fe0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe8:	48 89 d6             	mov    %rdx,%rsi
  800feb:	bf 58 00 00 00       	mov    $0x58,%edi
  800ff0:	ff d0                	callq  *%rax
			putch('X', putdat);
  800ff2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ff6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ffa:	48 89 d6             	mov    %rdx,%rsi
  800ffd:	bf 58 00 00 00       	mov    $0x58,%edi
  801002:	ff d0                	callq  *%rax
			break;
  801004:	e9 f2 00 00 00       	jmpq   8010fb <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  801009:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80100d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801011:	48 89 d6             	mov    %rdx,%rsi
  801014:	bf 30 00 00 00       	mov    $0x30,%edi
  801019:	ff d0                	callq  *%rax
			putch('x', putdat);
  80101b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80101f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801023:	48 89 d6             	mov    %rdx,%rsi
  801026:	bf 78 00 00 00       	mov    $0x78,%edi
  80102b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80102d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801030:	83 f8 30             	cmp    $0x30,%eax
  801033:	73 17                	jae    80104c <vprintfmt+0x46d>
  801035:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801039:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80103c:	89 c0                	mov    %eax,%eax
  80103e:	48 01 d0             	add    %rdx,%rax
  801041:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801044:	83 c2 08             	add    $0x8,%edx
  801047:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80104a:	eb 0f                	jmp    80105b <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  80104c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801050:	48 89 d0             	mov    %rdx,%rax
  801053:	48 83 c2 08          	add    $0x8,%rdx
  801057:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80105b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801062:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801069:	eb 23                	jmp    80108e <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80106b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80106f:	be 03 00 00 00       	mov    $0x3,%esi
  801074:	48 89 c7             	mov    %rax,%rdi
  801077:	48 b8 bf 09 80 00 00 	movabs $0x8009bf,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
  801083:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801087:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801093:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801096:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801099:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a5:	45 89 c1             	mov    %r8d,%r9d
  8010a8:	41 89 f8             	mov    %edi,%r8d
  8010ab:	48 89 c7             	mov    %rax,%rdi
  8010ae:	48 b8 04 09 80 00 00 	movabs $0x800904,%rax
  8010b5:	00 00 00 
  8010b8:	ff d0                	callq  *%rax
			break;
  8010ba:	eb 3f                	jmp    8010fb <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010bc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c4:	48 89 d6             	mov    %rdx,%rsi
  8010c7:	89 df                	mov    %ebx,%edi
  8010c9:	ff d0                	callq  *%rax
			break;
  8010cb:	eb 2e                	jmp    8010fb <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010cd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d5:	48 89 d6             	mov    %rdx,%rsi
  8010d8:	bf 25 00 00 00       	mov    $0x25,%edi
  8010dd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010df:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010e4:	eb 05                	jmp    8010eb <vprintfmt+0x50c>
  8010e6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010eb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010ef:	48 83 e8 01          	sub    $0x1,%rax
  8010f3:	0f b6 00             	movzbl (%rax),%eax
  8010f6:	3c 25                	cmp    $0x25,%al
  8010f8:	75 ec                	jne    8010e6 <vprintfmt+0x507>
				/* do nothing */;
			break;
  8010fa:	90                   	nop
		}
	}
  8010fb:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010fc:	e9 30 fb ff ff       	jmpq   800c31 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801101:	48 83 c4 60          	add    $0x60,%rsp
  801105:	5b                   	pop    %rbx
  801106:	41 5c                	pop    %r12
  801108:	5d                   	pop    %rbp
  801109:	c3                   	retq   

000000000080110a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801115:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80111c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801123:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80112a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801131:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801138:	84 c0                	test   %al,%al
  80113a:	74 20                	je     80115c <printfmt+0x52>
  80113c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801140:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801144:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801148:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80114c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801150:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801154:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801158:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80115c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801163:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80116a:	00 00 00 
  80116d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801174:	00 00 00 
  801177:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80117b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801182:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801189:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801190:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801197:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80119e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011a5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011ac:	48 89 c7             	mov    %rax,%rdi
  8011af:	48 b8 df 0b 80 00 00 	movabs $0x800bdf,%rax
  8011b6:	00 00 00 
  8011b9:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011bb:	c9                   	leaveq 
  8011bc:	c3                   	retq   

00000000008011bd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011bd:	55                   	push   %rbp
  8011be:	48 89 e5             	mov    %rsp,%rbp
  8011c1:	48 83 ec 10          	sub    $0x10,%rsp
  8011c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d0:	8b 40 10             	mov    0x10(%rax),%eax
  8011d3:	8d 50 01             	lea    0x1(%rax),%edx
  8011d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011da:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e1:	48 8b 10             	mov    (%rax),%rdx
  8011e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011ec:	48 39 c2             	cmp    %rax,%rdx
  8011ef:	73 17                	jae    801208 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f5:	48 8b 00             	mov    (%rax),%rax
  8011f8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801200:	48 89 0a             	mov    %rcx,(%rdx)
  801203:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801206:	88 10                	mov    %dl,(%rax)
}
  801208:	c9                   	leaveq 
  801209:	c3                   	retq   

000000000080120a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80120a:	55                   	push   %rbp
  80120b:	48 89 e5             	mov    %rsp,%rbp
  80120e:	48 83 ec 50          	sub    $0x50,%rsp
  801212:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801216:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801219:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80121d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801221:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801225:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801229:	48 8b 0a             	mov    (%rdx),%rcx
  80122c:	48 89 08             	mov    %rcx,(%rax)
  80122f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801233:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801237:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80123b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80123f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801243:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801247:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80124a:	48 98                	cltq   
  80124c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801250:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801254:	48 01 d0             	add    %rdx,%rax
  801257:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80125b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801262:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801267:	74 06                	je     80126f <vsnprintf+0x65>
  801269:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80126d:	7f 07                	jg     801276 <vsnprintf+0x6c>
		return -E_INVAL;
  80126f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801274:	eb 2f                	jmp    8012a5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801276:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80127a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80127e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801282:	48 89 c6             	mov    %rax,%rsi
  801285:	48 bf bd 11 80 00 00 	movabs $0x8011bd,%rdi
  80128c:	00 00 00 
  80128f:	48 b8 df 0b 80 00 00 	movabs $0x800bdf,%rax
  801296:	00 00 00 
  801299:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80129b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80129f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012a2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012a5:	c9                   	leaveq 
  8012a6:	c3                   	retq   

00000000008012a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a7:	55                   	push   %rbp
  8012a8:	48 89 e5             	mov    %rsp,%rbp
  8012ab:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012b2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012b9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012bf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012c6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012cd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012d4:	84 c0                	test   %al,%al
  8012d6:	74 20                	je     8012f8 <snprintf+0x51>
  8012d8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012dc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012e0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012e4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012e8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012ec:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012f0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012f4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012f8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012ff:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801306:	00 00 00 
  801309:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801310:	00 00 00 
  801313:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801317:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80131e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801325:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80132c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801333:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80133a:	48 8b 0a             	mov    (%rdx),%rcx
  80133d:	48 89 08             	mov    %rcx,(%rax)
  801340:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801344:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801348:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80134c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801350:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801357:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80135e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801364:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80136b:	48 89 c7             	mov    %rax,%rdi
  80136e:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  801375:	00 00 00 
  801378:	ff d0                	callq  *%rax
  80137a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801380:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801386:	c9                   	leaveq 
  801387:	c3                   	retq   

0000000000801388 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801388:	55                   	push   %rbp
  801389:	48 89 e5             	mov    %rsp,%rbp
  80138c:	48 83 ec 18          	sub    $0x18,%rsp
  801390:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801394:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80139b:	eb 09                	jmp    8013a6 <strlen+0x1e>
		n++;
  80139d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013a1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	84 c0                	test   %al,%al
  8013af:	75 ec                	jne    80139d <strlen+0x15>
		n++;
	return n;
  8013b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013b4:	c9                   	leaveq 
  8013b5:	c3                   	retq   

00000000008013b6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013b6:	55                   	push   %rbp
  8013b7:	48 89 e5             	mov    %rsp,%rbp
  8013ba:	48 83 ec 20          	sub    $0x20,%rsp
  8013be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013cd:	eb 0e                	jmp    8013dd <strnlen+0x27>
		n++;
  8013cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013d8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013dd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013e2:	74 0b                	je     8013ef <strnlen+0x39>
  8013e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e8:	0f b6 00             	movzbl (%rax),%eax
  8013eb:	84 c0                	test   %al,%al
  8013ed:	75 e0                	jne    8013cf <strnlen+0x19>
		n++;
	return n;
  8013ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013f2:	c9                   	leaveq 
  8013f3:	c3                   	retq   

00000000008013f4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013f4:	55                   	push   %rbp
  8013f5:	48 89 e5             	mov    %rsp,%rbp
  8013f8:	48 83 ec 20          	sub    $0x20,%rsp
  8013fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801400:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801408:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80140c:	90                   	nop
  80140d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801411:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801415:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801419:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80141d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801421:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801425:	0f b6 12             	movzbl (%rdx),%edx
  801428:	88 10                	mov    %dl,(%rax)
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	84 c0                	test   %al,%al
  80142f:	75 dc                	jne    80140d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801435:	c9                   	leaveq 
  801436:	c3                   	retq   

0000000000801437 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801437:	55                   	push   %rbp
  801438:	48 89 e5             	mov    %rsp,%rbp
  80143b:	48 83 ec 20          	sub    $0x20,%rsp
  80143f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801443:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144b:	48 89 c7             	mov    %rax,%rdi
  80144e:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  801455:	00 00 00 
  801458:	ff d0                	callq  *%rax
  80145a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80145d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801460:	48 63 d0             	movslq %eax,%rdx
  801463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801467:	48 01 c2             	add    %rax,%rdx
  80146a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80146e:	48 89 c6             	mov    %rax,%rsi
  801471:	48 89 d7             	mov    %rdx,%rdi
  801474:	48 b8 f4 13 80 00 00 	movabs $0x8013f4,%rax
  80147b:	00 00 00 
  80147e:	ff d0                	callq  *%rax
	return dst;
  801480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801484:	c9                   	leaveq 
  801485:	c3                   	retq   

0000000000801486 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801486:	55                   	push   %rbp
  801487:	48 89 e5             	mov    %rsp,%rbp
  80148a:	48 83 ec 28          	sub    $0x28,%rsp
  80148e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801492:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801496:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80149a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014a2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014a9:	00 
  8014aa:	eb 2a                	jmp    8014d6 <strncpy+0x50>
		*dst++ = *src;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014b8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014bc:	0f b6 12             	movzbl (%rdx),%edx
  8014bf:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c5:	0f b6 00             	movzbl (%rax),%eax
  8014c8:	84 c0                	test   %al,%al
  8014ca:	74 05                	je     8014d1 <strncpy+0x4b>
			src++;
  8014cc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014da:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014de:	72 cc                	jb     8014ac <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e4:	c9                   	leaveq 
  8014e5:	c3                   	retq   

00000000008014e6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	48 83 ec 28          	sub    $0x28,%rsp
  8014ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801502:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801507:	74 3d                	je     801546 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801509:	eb 1d                	jmp    801528 <strlcpy+0x42>
			*dst++ = *src++;
  80150b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801513:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801517:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80151b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80151f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801523:	0f b6 12             	movzbl (%rdx),%edx
  801526:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801528:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80152d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801532:	74 0b                	je     80153f <strlcpy+0x59>
  801534:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	84 c0                	test   %al,%al
  80153d:	75 cc                	jne    80150b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80153f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801543:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	48 29 c2             	sub    %rax,%rdx
  801551:	48 89 d0             	mov    %rdx,%rax
}
  801554:	c9                   	leaveq 
  801555:	c3                   	retq   

0000000000801556 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801556:	55                   	push   %rbp
  801557:	48 89 e5             	mov    %rsp,%rbp
  80155a:	48 83 ec 10          	sub    $0x10,%rsp
  80155e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801562:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801566:	eb 0a                	jmp    801572 <strcmp+0x1c>
		p++, q++;
  801568:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801572:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801576:	0f b6 00             	movzbl (%rax),%eax
  801579:	84 c0                	test   %al,%al
  80157b:	74 12                	je     80158f <strcmp+0x39>
  80157d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801581:	0f b6 10             	movzbl (%rax),%edx
  801584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	38 c2                	cmp    %al,%dl
  80158d:	74 d9                	je     801568 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	0f b6 d0             	movzbl %al,%edx
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	0f b6 c0             	movzbl %al,%eax
  8015a3:	29 c2                	sub    %eax,%edx
  8015a5:	89 d0                	mov    %edx,%eax
}
  8015a7:	c9                   	leaveq 
  8015a8:	c3                   	retq   

00000000008015a9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015a9:	55                   	push   %rbp
  8015aa:	48 89 e5             	mov    %rsp,%rbp
  8015ad:	48 83 ec 18          	sub    $0x18,%rsp
  8015b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015bd:	eb 0f                	jmp    8015ce <strncmp+0x25>
		n--, p++, q++;
  8015bf:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d3:	74 1d                	je     8015f2 <strncmp+0x49>
  8015d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	84 c0                	test   %al,%al
  8015de:	74 12                	je     8015f2 <strncmp+0x49>
  8015e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e4:	0f b6 10             	movzbl (%rax),%edx
  8015e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	38 c2                	cmp    %al,%dl
  8015f0:	74 cd                	je     8015bf <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015f2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015f7:	75 07                	jne    801600 <strncmp+0x57>
		return 0;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	eb 18                	jmp    801618 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	0f b6 d0             	movzbl %al,%edx
  80160a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160e:	0f b6 00             	movzbl (%rax),%eax
  801611:	0f b6 c0             	movzbl %al,%eax
  801614:	29 c2                	sub    %eax,%edx
  801616:	89 d0                	mov    %edx,%eax
}
  801618:	c9                   	leaveq 
  801619:	c3                   	retq   

000000000080161a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80161a:	55                   	push   %rbp
  80161b:	48 89 e5             	mov    %rsp,%rbp
  80161e:	48 83 ec 0c          	sub    $0xc,%rsp
  801622:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801626:	89 f0                	mov    %esi,%eax
  801628:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80162b:	eb 17                	jmp    801644 <strchr+0x2a>
		if (*s == c)
  80162d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801631:	0f b6 00             	movzbl (%rax),%eax
  801634:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801637:	75 06                	jne    80163f <strchr+0x25>
			return (char *) s;
  801639:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163d:	eb 15                	jmp    801654 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80163f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	84 c0                	test   %al,%al
  80164d:	75 de                	jne    80162d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801654:	c9                   	leaveq 
  801655:	c3                   	retq   

0000000000801656 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801656:	55                   	push   %rbp
  801657:	48 89 e5             	mov    %rsp,%rbp
  80165a:	48 83 ec 0c          	sub    $0xc,%rsp
  80165e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801662:	89 f0                	mov    %esi,%eax
  801664:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801667:	eb 13                	jmp    80167c <strfind+0x26>
		if (*s == c)
  801669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801673:	75 02                	jne    801677 <strfind+0x21>
			break;
  801675:	eb 10                	jmp    801687 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801677:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80167c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	84 c0                	test   %al,%al
  801685:	75 e2                	jne    801669 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80168b:	c9                   	leaveq 
  80168c:	c3                   	retq   

000000000080168d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	48 83 ec 18          	sub    $0x18,%rsp
  801695:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801699:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80169c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016a0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a5:	75 06                	jne    8016ad <memset+0x20>
		return v;
  8016a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ab:	eb 69                	jmp    801716 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b1:	83 e0 03             	and    $0x3,%eax
  8016b4:	48 85 c0             	test   %rax,%rax
  8016b7:	75 48                	jne    801701 <memset+0x74>
  8016b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bd:	83 e0 03             	and    $0x3,%eax
  8016c0:	48 85 c0             	test   %rax,%rax
  8016c3:	75 3c                	jne    801701 <memset+0x74>
		c &= 0xFF;
  8016c5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cf:	c1 e0 18             	shl    $0x18,%eax
  8016d2:	89 c2                	mov    %eax,%edx
  8016d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d7:	c1 e0 10             	shl    $0x10,%eax
  8016da:	09 c2                	or     %eax,%edx
  8016dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016df:	c1 e0 08             	shl    $0x8,%eax
  8016e2:	09 d0                	or     %edx,%eax
  8016e4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016eb:	48 c1 e8 02          	shr    $0x2,%rax
  8016ef:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f9:	48 89 d7             	mov    %rdx,%rdi
  8016fc:	fc                   	cld    
  8016fd:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016ff:	eb 11                	jmp    801712 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801701:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801705:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801708:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80170c:	48 89 d7             	mov    %rdx,%rdi
  80170f:	fc                   	cld    
  801710:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801712:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801716:	c9                   	leaveq 
  801717:	c3                   	retq   

0000000000801718 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	48 83 ec 28          	sub    $0x28,%rsp
  801720:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801724:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801728:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80172c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801730:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801738:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80173c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801740:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801744:	0f 83 88 00 00 00    	jae    8017d2 <memmove+0xba>
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801752:	48 01 d0             	add    %rdx,%rax
  801755:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801759:	76 77                	jbe    8017d2 <memmove+0xba>
		s += n;
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801767:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80176b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176f:	83 e0 03             	and    $0x3,%eax
  801772:	48 85 c0             	test   %rax,%rax
  801775:	75 3b                	jne    8017b2 <memmove+0x9a>
  801777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177b:	83 e0 03             	and    $0x3,%eax
  80177e:	48 85 c0             	test   %rax,%rax
  801781:	75 2f                	jne    8017b2 <memmove+0x9a>
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	83 e0 03             	and    $0x3,%eax
  80178a:	48 85 c0             	test   %rax,%rax
  80178d:	75 23                	jne    8017b2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80178f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801793:	48 83 e8 04          	sub    $0x4,%rax
  801797:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80179b:	48 83 ea 04          	sub    $0x4,%rdx
  80179f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017a3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017a7:	48 89 c7             	mov    %rax,%rdi
  8017aa:	48 89 d6             	mov    %rdx,%rsi
  8017ad:	fd                   	std    
  8017ae:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017b0:	eb 1d                	jmp    8017cf <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017be:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c6:	48 89 d7             	mov    %rdx,%rdi
  8017c9:	48 89 c1             	mov    %rax,%rcx
  8017cc:	fd                   	std    
  8017cd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017cf:	fc                   	cld    
  8017d0:	eb 57                	jmp    801829 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d6:	83 e0 03             	and    $0x3,%eax
  8017d9:	48 85 c0             	test   %rax,%rax
  8017dc:	75 36                	jne    801814 <memmove+0xfc>
  8017de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e2:	83 e0 03             	and    $0x3,%eax
  8017e5:	48 85 c0             	test   %rax,%rax
  8017e8:	75 2a                	jne    801814 <memmove+0xfc>
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	83 e0 03             	and    $0x3,%eax
  8017f1:	48 85 c0             	test   %rax,%rax
  8017f4:	75 1e                	jne    801814 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fa:	48 c1 e8 02          	shr    $0x2,%rax
  8017fe:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801801:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801805:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801809:	48 89 c7             	mov    %rax,%rdi
  80180c:	48 89 d6             	mov    %rdx,%rsi
  80180f:	fc                   	cld    
  801810:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801812:	eb 15                	jmp    801829 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801818:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80181c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801820:	48 89 c7             	mov    %rax,%rdi
  801823:	48 89 d6             	mov    %rdx,%rsi
  801826:	fc                   	cld    
  801827:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80182d:	c9                   	leaveq 
  80182e:	c3                   	retq   

000000000080182f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80182f:	55                   	push   %rbp
  801830:	48 89 e5             	mov    %rsp,%rbp
  801833:	48 83 ec 18          	sub    $0x18,%rsp
  801837:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80183b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801847:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80184b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184f:	48 89 ce             	mov    %rcx,%rsi
  801852:	48 89 c7             	mov    %rax,%rdi
  801855:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  80185c:	00 00 00 
  80185f:	ff d0                	callq  *%rax
}
  801861:	c9                   	leaveq 
  801862:	c3                   	retq   

0000000000801863 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801863:	55                   	push   %rbp
  801864:	48 89 e5             	mov    %rsp,%rbp
  801867:	48 83 ec 28          	sub    $0x28,%rsp
  80186b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80186f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801873:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80187f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801883:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801887:	eb 36                	jmp    8018bf <memcmp+0x5c>
		if (*s1 != *s2)
  801889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188d:	0f b6 10             	movzbl (%rax),%edx
  801890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801894:	0f b6 00             	movzbl (%rax),%eax
  801897:	38 c2                	cmp    %al,%dl
  801899:	74 1a                	je     8018b5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80189b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189f:	0f b6 00             	movzbl (%rax),%eax
  8018a2:	0f b6 d0             	movzbl %al,%edx
  8018a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a9:	0f b6 00             	movzbl (%rax),%eax
  8018ac:	0f b6 c0             	movzbl %al,%eax
  8018af:	29 c2                	sub    %eax,%edx
  8018b1:	89 d0                	mov    %edx,%eax
  8018b3:	eb 20                	jmp    8018d5 <memcmp+0x72>
		s1++, s2++;
  8018b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018cb:	48 85 c0             	test   %rax,%rax
  8018ce:	75 b9                	jne    801889 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 28          	sub    $0x28,%rsp
  8018df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018e3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f2:	48 01 d0             	add    %rdx,%rax
  8018f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018f9:	eb 15                	jmp    801910 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ff:	0f b6 10             	movzbl (%rax),%edx
  801902:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801905:	38 c2                	cmp    %al,%dl
  801907:	75 02                	jne    80190b <memfind+0x34>
			break;
  801909:	eb 0f                	jmp    80191a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801914:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801918:	72 e1                	jb     8018fb <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80191a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 34          	sub    $0x34,%rsp
  801928:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80192c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801930:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801933:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80193a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801941:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801942:	eb 05                	jmp    801949 <strtol+0x29>
		s++;
  801944:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801949:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194d:	0f b6 00             	movzbl (%rax),%eax
  801950:	3c 20                	cmp    $0x20,%al
  801952:	74 f0                	je     801944 <strtol+0x24>
  801954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801958:	0f b6 00             	movzbl (%rax),%eax
  80195b:	3c 09                	cmp    $0x9,%al
  80195d:	74 e5                	je     801944 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80195f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	3c 2b                	cmp    $0x2b,%al
  801968:	75 07                	jne    801971 <strtol+0x51>
		s++;
  80196a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196f:	eb 17                	jmp    801988 <strtol+0x68>
	else if (*s == '-')
  801971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801975:	0f b6 00             	movzbl (%rax),%eax
  801978:	3c 2d                	cmp    $0x2d,%al
  80197a:	75 0c                	jne    801988 <strtol+0x68>
		s++, neg = 1;
  80197c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801981:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801988:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80198c:	74 06                	je     801994 <strtol+0x74>
  80198e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801992:	75 28                	jne    8019bc <strtol+0x9c>
  801994:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801998:	0f b6 00             	movzbl (%rax),%eax
  80199b:	3c 30                	cmp    $0x30,%al
  80199d:	75 1d                	jne    8019bc <strtol+0x9c>
  80199f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a3:	48 83 c0 01          	add    $0x1,%rax
  8019a7:	0f b6 00             	movzbl (%rax),%eax
  8019aa:	3c 78                	cmp    $0x78,%al
  8019ac:	75 0e                	jne    8019bc <strtol+0x9c>
		s += 2, base = 16;
  8019ae:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019b3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019ba:	eb 2c                	jmp    8019e8 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019c0:	75 19                	jne    8019db <strtol+0xbb>
  8019c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c6:	0f b6 00             	movzbl (%rax),%eax
  8019c9:	3c 30                	cmp    $0x30,%al
  8019cb:	75 0e                	jne    8019db <strtol+0xbb>
		s++, base = 8;
  8019cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019d2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019d9:	eb 0d                	jmp    8019e8 <strtol+0xc8>
	else if (base == 0)
  8019db:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019df:	75 07                	jne    8019e8 <strtol+0xc8>
		base = 10;
  8019e1:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ec:	0f b6 00             	movzbl (%rax),%eax
  8019ef:	3c 2f                	cmp    $0x2f,%al
  8019f1:	7e 1d                	jle    801a10 <strtol+0xf0>
  8019f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f7:	0f b6 00             	movzbl (%rax),%eax
  8019fa:	3c 39                	cmp    $0x39,%al
  8019fc:	7f 12                	jg     801a10 <strtol+0xf0>
			dig = *s - '0';
  8019fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a02:	0f b6 00             	movzbl (%rax),%eax
  801a05:	0f be c0             	movsbl %al,%eax
  801a08:	83 e8 30             	sub    $0x30,%eax
  801a0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a0e:	eb 4e                	jmp    801a5e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a14:	0f b6 00             	movzbl (%rax),%eax
  801a17:	3c 60                	cmp    $0x60,%al
  801a19:	7e 1d                	jle    801a38 <strtol+0x118>
  801a1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1f:	0f b6 00             	movzbl (%rax),%eax
  801a22:	3c 7a                	cmp    $0x7a,%al
  801a24:	7f 12                	jg     801a38 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2a:	0f b6 00             	movzbl (%rax),%eax
  801a2d:	0f be c0             	movsbl %al,%eax
  801a30:	83 e8 57             	sub    $0x57,%eax
  801a33:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a36:	eb 26                	jmp    801a5e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3c:	0f b6 00             	movzbl (%rax),%eax
  801a3f:	3c 40                	cmp    $0x40,%al
  801a41:	7e 48                	jle    801a8b <strtol+0x16b>
  801a43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a47:	0f b6 00             	movzbl (%rax),%eax
  801a4a:	3c 5a                	cmp    $0x5a,%al
  801a4c:	7f 3d                	jg     801a8b <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a52:	0f b6 00             	movzbl (%rax),%eax
  801a55:	0f be c0             	movsbl %al,%eax
  801a58:	83 e8 37             	sub    $0x37,%eax
  801a5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a61:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a64:	7c 02                	jl     801a68 <strtol+0x148>
			break;
  801a66:	eb 23                	jmp    801a8b <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a68:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a6d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a70:	48 98                	cltq   
  801a72:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a77:	48 89 c2             	mov    %rax,%rdx
  801a7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a7d:	48 98                	cltq   
  801a7f:	48 01 d0             	add    %rdx,%rax
  801a82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a86:	e9 5d ff ff ff       	jmpq   8019e8 <strtol+0xc8>

	if (endptr)
  801a8b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a90:	74 0b                	je     801a9d <strtol+0x17d>
		*endptr = (char *) s;
  801a92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a96:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a9a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aa1:	74 09                	je     801aac <strtol+0x18c>
  801aa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa7:	48 f7 d8             	neg    %rax
  801aaa:	eb 04                	jmp    801ab0 <strtol+0x190>
  801aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ab0:	c9                   	leaveq 
  801ab1:	c3                   	retq   

0000000000801ab2 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ab2:	55                   	push   %rbp
  801ab3:	48 89 e5             	mov    %rsp,%rbp
  801ab6:	48 83 ec 30          	sub    $0x30,%rsp
  801aba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801abe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801ac2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ace:	0f b6 00             	movzbl (%rax),%eax
  801ad1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ad4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ad8:	75 06                	jne    801ae0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801ada:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ade:	eb 6b                	jmp    801b4b <strstr+0x99>

	len = strlen(str);
  801ae0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae4:	48 89 c7             	mov    %rax,%rdi
  801ae7:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
  801af3:	48 98                	cltq   
  801af5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801af9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b01:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b05:	0f b6 00             	movzbl (%rax),%eax
  801b08:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b0b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b0f:	75 07                	jne    801b18 <strstr+0x66>
				return (char *) 0;
  801b11:	b8 00 00 00 00       	mov    $0x0,%eax
  801b16:	eb 33                	jmp    801b4b <strstr+0x99>
		} while (sc != c);
  801b18:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b1c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b1f:	75 d8                	jne    801af9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b25:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2d:	48 89 ce             	mov    %rcx,%rsi
  801b30:	48 89 c7             	mov    %rax,%rdi
  801b33:	48 b8 a9 15 80 00 00 	movabs $0x8015a9,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	75 b6                	jne    801af9 <strstr+0x47>

	return (char *) (in - 1);
  801b43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b47:	48 83 e8 01          	sub    $0x1,%rax
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	53                   	push   %rbx
  801b52:	48 83 ec 48          	sub    $0x48,%rsp
  801b56:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b59:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b5c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b60:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b64:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b68:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b6c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b6f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b73:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b77:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b7b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b7f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b83:	4c 89 c3             	mov    %r8,%rbx
  801b86:	cd 30                	int    $0x30
  801b88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b8c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b90:	74 3e                	je     801bd0 <syscall+0x83>
  801b92:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b97:	7e 37                	jle    801bd0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b9d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ba0:	49 89 d0             	mov    %rdx,%r8
  801ba3:	89 c1                	mov    %eax,%ecx
  801ba5:	48 ba 08 49 80 00 00 	movabs $0x804908,%rdx
  801bac:	00 00 00 
  801baf:	be 23 00 00 00       	mov    $0x23,%esi
  801bb4:	48 bf 25 49 80 00 00 	movabs $0x804925,%rdi
  801bbb:	00 00 00 
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc3:	49 b9 f3 05 80 00 00 	movabs $0x8005f3,%r9
  801bca:	00 00 00 
  801bcd:	41 ff d1             	callq  *%r9

	return ret;
  801bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bd4:	48 83 c4 48          	add    $0x48,%rsp
  801bd8:	5b                   	pop    %rbx
  801bd9:	5d                   	pop    %rbp
  801bda:	c3                   	retq   

0000000000801bdb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 20          	sub    $0x20,%rsp
  801be3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfa:	00 
  801bfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c07:	48 89 d1             	mov    %rdx,%rcx
  801c0a:	48 89 c2             	mov    %rax,%rdx
  801c0d:	be 00 00 00 00       	mov    $0x0,%esi
  801c12:	bf 00 00 00 00       	mov    $0x0,%edi
  801c17:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	callq  *%rax
}
  801c23:	c9                   	leaveq 
  801c24:	c3                   	retq   

0000000000801c25 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c25:	55                   	push   %rbp
  801c26:	48 89 e5             	mov    %rsp,%rbp
  801c29:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c34:	00 
  801c35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c41:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	be 00 00 00 00       	mov    $0x0,%esi
  801c50:	bf 01 00 00 00       	mov    $0x1,%edi
  801c55:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801c5c:	00 00 00 
  801c5f:	ff d0                	callq  *%rax
}
  801c61:	c9                   	leaveq 
  801c62:	c3                   	retq   

0000000000801c63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c63:	55                   	push   %rbp
  801c64:	48 89 e5             	mov    %rsp,%rbp
  801c67:	48 83 ec 10          	sub    $0x10,%rsp
  801c6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c71:	48 98                	cltq   
  801c73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7a:	00 
  801c7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8c:	48 89 c2             	mov    %rax,%rdx
  801c8f:	be 01 00 00 00       	mov    $0x1,%esi
  801c94:	bf 03 00 00 00       	mov    $0x3,%edi
  801c99:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
}
  801ca5:	c9                   	leaveq 
  801ca6:	c3                   	retq   

0000000000801ca7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ca7:	55                   	push   %rbp
  801ca8:	48 89 e5             	mov    %rsp,%rbp
  801cab:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801caf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb6:	00 
  801cb7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccd:	be 00 00 00 00       	mov    $0x0,%esi
  801cd2:	bf 02 00 00 00       	mov    $0x2,%edi
  801cd7:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
}
  801ce3:	c9                   	leaveq 
  801ce4:	c3                   	retq   

0000000000801ce5 <sys_yield>:

void
sys_yield(void)
{
  801ce5:	55                   	push   %rbp
  801ce6:	48 89 e5             	mov    %rsp,%rbp
  801ce9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ced:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf4:	00 
  801cf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d01:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d06:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0b:	be 00 00 00 00       	mov    $0x0,%esi
  801d10:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d15:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801d1c:	00 00 00 
  801d1f:	ff d0                	callq  *%rax
}
  801d21:	c9                   	leaveq 
  801d22:	c3                   	retq   

0000000000801d23 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d23:	55                   	push   %rbp
  801d24:	48 89 e5             	mov    %rsp,%rbp
  801d27:	48 83 ec 20          	sub    $0x20,%rsp
  801d2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d32:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d38:	48 63 c8             	movslq %eax,%rcx
  801d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d42:	48 98                	cltq   
  801d44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4b:	00 
  801d4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d52:	49 89 c8             	mov    %rcx,%r8
  801d55:	48 89 d1             	mov    %rdx,%rcx
  801d58:	48 89 c2             	mov    %rax,%rdx
  801d5b:	be 01 00 00 00       	mov    $0x1,%esi
  801d60:	bf 04 00 00 00       	mov    $0x4,%edi
  801d65:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801d6c:	00 00 00 
  801d6f:	ff d0                	callq  *%rax
}
  801d71:	c9                   	leaveq 
  801d72:	c3                   	retq   

0000000000801d73 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d73:	55                   	push   %rbp
  801d74:	48 89 e5             	mov    %rsp,%rbp
  801d77:	48 83 ec 30          	sub    $0x30,%rsp
  801d7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d82:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d85:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d89:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d8d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d90:	48 63 c8             	movslq %eax,%rcx
  801d93:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9a:	48 63 f0             	movslq %eax,%rsi
  801d9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da4:	48 98                	cltq   
  801da6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801daa:	49 89 f9             	mov    %rdi,%r9
  801dad:	49 89 f0             	mov    %rsi,%r8
  801db0:	48 89 d1             	mov    %rdx,%rcx
  801db3:	48 89 c2             	mov    %rax,%rdx
  801db6:	be 01 00 00 00       	mov    $0x1,%esi
  801dbb:	bf 05 00 00 00       	mov    $0x5,%edi
  801dc0:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	callq  *%rax
}
  801dcc:	c9                   	leaveq 
  801dcd:	c3                   	retq   

0000000000801dce <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dce:	55                   	push   %rbp
  801dcf:	48 89 e5             	mov    %rsp,%rbp
  801dd2:	48 83 ec 20          	sub    $0x20,%rsp
  801dd6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ddd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de4:	48 98                	cltq   
  801de6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ded:	00 
  801dee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfa:	48 89 d1             	mov    %rdx,%rcx
  801dfd:	48 89 c2             	mov    %rax,%rdx
  801e00:	be 01 00 00 00       	mov    $0x1,%esi
  801e05:	bf 06 00 00 00       	mov    $0x6,%edi
  801e0a:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801e11:	00 00 00 
  801e14:	ff d0                	callq  *%rax
}
  801e16:	c9                   	leaveq 
  801e17:	c3                   	retq   

0000000000801e18 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e18:	55                   	push   %rbp
  801e19:	48 89 e5             	mov    %rsp,%rbp
  801e1c:	48 83 ec 10          	sub    $0x10,%rsp
  801e20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e23:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e29:	48 63 d0             	movslq %eax,%rdx
  801e2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2f:	48 98                	cltq   
  801e31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e38:	00 
  801e39:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e45:	48 89 d1             	mov    %rdx,%rcx
  801e48:	48 89 c2             	mov    %rax,%rdx
  801e4b:	be 01 00 00 00       	mov    $0x1,%esi
  801e50:	bf 08 00 00 00       	mov    $0x8,%edi
  801e55:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801e5c:	00 00 00 
  801e5f:	ff d0                	callq  *%rax
}
  801e61:	c9                   	leaveq 
  801e62:	c3                   	retq   

0000000000801e63 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e63:	55                   	push   %rbp
  801e64:	48 89 e5             	mov    %rsp,%rbp
  801e67:	48 83 ec 20          	sub    $0x20,%rsp
  801e6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e79:	48 98                	cltq   
  801e7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e82:	00 
  801e83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8f:	48 89 d1             	mov    %rdx,%rcx
  801e92:	48 89 c2             	mov    %rax,%rdx
  801e95:	be 01 00 00 00       	mov    $0x1,%esi
  801e9a:	bf 09 00 00 00       	mov    $0x9,%edi
  801e9f:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
}
  801eab:	c9                   	leaveq 
  801eac:	c3                   	retq   

0000000000801ead <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ead:	55                   	push   %rbp
  801eae:	48 89 e5             	mov    %rsp,%rbp
  801eb1:	48 83 ec 20          	sub    $0x20,%rsp
  801eb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ebc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec3:	48 98                	cltq   
  801ec5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ecc:	00 
  801ecd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed9:	48 89 d1             	mov    %rdx,%rcx
  801edc:	48 89 c2             	mov    %rax,%rdx
  801edf:	be 01 00 00 00       	mov    $0x1,%esi
  801ee4:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ee9:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
}
  801ef5:	c9                   	leaveq 
  801ef6:	c3                   	retq   

0000000000801ef7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ef7:	55                   	push   %rbp
  801ef8:	48 89 e5             	mov    %rsp,%rbp
  801efb:	48 83 ec 20          	sub    $0x20,%rsp
  801eff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f06:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f0a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f10:	48 63 f0             	movslq %eax,%rsi
  801f13:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1a:	48 98                	cltq   
  801f1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f27:	00 
  801f28:	49 89 f1             	mov    %rsi,%r9
  801f2b:	49 89 c8             	mov    %rcx,%r8
  801f2e:	48 89 d1             	mov    %rdx,%rcx
  801f31:	48 89 c2             	mov    %rax,%rdx
  801f34:	be 00 00 00 00       	mov    $0x0,%esi
  801f39:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f3e:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801f45:	00 00 00 
  801f48:	ff d0                	callq  *%rax
}
  801f4a:	c9                   	leaveq 
  801f4b:	c3                   	retq   

0000000000801f4c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f4c:	55                   	push   %rbp
  801f4d:	48 89 e5             	mov    %rsp,%rbp
  801f50:	48 83 ec 10          	sub    $0x10,%rsp
  801f54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f63:	00 
  801f64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f70:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f75:	48 89 c2             	mov    %rax,%rdx
  801f78:	be 01 00 00 00       	mov    $0x1,%esi
  801f7d:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f82:	48 b8 4d 1b 80 00 00 	movabs $0x801b4d,%rax
  801f89:	00 00 00 
  801f8c:	ff d0                	callq  *%rax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 30          	sub    $0x30,%rsp
  801f98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa0:	48 8b 00             	mov    (%rax),%rax
  801fa3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fab:	48 8b 40 08          	mov    0x8(%rax),%rax
  801faf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.

	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801fb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fb5:	83 e0 02             	and    $0x2,%eax
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	75 4d                	jne    802009 <pgfault+0x79>
  801fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc0:	48 c1 e8 0c          	shr    $0xc,%rax
  801fc4:	48 89 c2             	mov    %rax,%rdx
  801fc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fce:	01 00 00 
  801fd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd5:	25 00 08 00 00       	and    $0x800,%eax
  801fda:	48 85 c0             	test   %rax,%rax
  801fdd:	74 2a                	je     802009 <pgfault+0x79>
		panic("page fault!!! page is not writeable\n");
  801fdf:	48 ba 38 49 80 00 00 	movabs $0x804938,%rdx
  801fe6:	00 00 00 
  801fe9:	be 1e 00 00 00       	mov    $0x1e,%esi
  801fee:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  801ff5:	00 00 00 
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  802004:	00 00 00 
  802007:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	void *Pageaddr ;
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W))
  802009:	ba 07 00 00 00       	mov    $0x7,%edx
  80200e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802013:	bf 00 00 00 00       	mov    $0x0,%edi
  802018:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  80201f:	00 00 00 
  802022:	ff d0                	callq  *%rax
  802024:	85 c0                	test   %eax,%eax
  802026:	0f 85 cd 00 00 00    	jne    8020f9 <pgfault+0x169>
	{
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  80202c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802030:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802038:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80203e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802042:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802046:	ba 00 10 00 00       	mov    $0x1000,%edx
  80204b:	48 89 c6             	mov    %rax,%rsi
  80204e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802053:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  80205a:	00 00 00 
  80205d:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  80205f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802063:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802069:	48 89 c1             	mov    %rax,%rcx
  80206c:	ba 00 00 00 00       	mov    $0x0,%edx
  802071:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802076:	bf 00 00 00 00       	mov    $0x0,%edi
  80207b:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	85 c0                	test   %eax,%eax
  802089:	79 2a                	jns    8020b5 <pgfault+0x125>
				panic("Page map at temp address failed");
  80208b:	48 ba 68 49 80 00 00 	movabs $0x804968,%rdx
  802092:	00 00 00 
  802095:	be 2f 00 00 00       	mov    $0x2f,%esi
  80209a:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  8020a1:	00 00 00 
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  8020b0:	00 00 00 
  8020b3:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  8020b5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8020bf:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	79 54                	jns    802123 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8020cf:	48 ba 88 49 80 00 00 	movabs $0x804988,%rdx
  8020d6:	00 00 00 
  8020d9:	be 31 00 00 00       	mov    $0x31,%esi
  8020de:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  8020e5:	00 00 00 
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ed:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  8020f4:	00 00 00 
  8020f7:	ff d1                	callq  *%rcx
	}
	else
	{
		panic("Page assigning failed when handle page fault");
  8020f9:	48 ba b0 49 80 00 00 	movabs $0x8049b0,%rdx
  802100:	00 00 00 
  802103:	be 35 00 00 00       	mov    $0x35,%esi
  802108:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  80210f:	00 00 00 
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  80211e:	00 00 00 
  802121:	ff d1                	callq  *%rcx
	}

	//panic("pgfault not implemented");
}
  802123:	c9                   	leaveq 
  802124:	c3                   	retq   

0000000000802125 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802125:	55                   	push   %rbp
  802126:	48 89 e5             	mov    %rsp,%rbp
  802129:	48 83 ec 20          	sub    $0x20,%rsp
  80212d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802130:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.

	int perm = (uvpt[pn]) & PTE_SYSCALL;
  802133:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213a:	01 00 00 
  80213d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802140:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802144:	25 07 0e 00 00       	and    $0xe07,%eax
  802149:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  80214c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80214f:	48 c1 e0 0c          	shl    $0xc,%rax
  802153:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	if(perm & PTE_SHARE){
  802157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215a:	25 00 04 00 00       	and    $0x400,%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	74 57                	je     8021ba <duppage+0x95>
			if(0 < sys_page_map(0,addr,envid,addr,perm))
  802163:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802166:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80216a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80216d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802171:	41 89 f0             	mov    %esi,%r8d
  802174:	48 89 c6             	mov    %rax,%rsi
  802177:	bf 00 00 00 00       	mov    $0x0,%edi
  80217c:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
  802188:	85 c0                	test   %eax,%eax
  80218a:	0f 8e 52 01 00 00    	jle    8022e2 <duppage+0x1bd>
				panic("Page alloc with COW  failed.\n");
  802190:	48 ba dd 49 80 00 00 	movabs $0x8049dd,%rdx
  802197:	00 00 00 
  80219a:	be 52 00 00 00       	mov    $0x52,%esi
  80219f:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  8021a6:	00 00 00 
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  8021b5:	00 00 00 
  8021b8:	ff d1                	callq  *%rcx

		}else{
					if((perm & PTE_W || perm & PTE_COW)){
  8021ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021bd:	83 e0 02             	and    $0x2,%eax
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	75 10                	jne    8021d4 <duppage+0xaf>
  8021c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c7:	25 00 08 00 00       	and    $0x800,%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 84 bb 00 00 00    	je     80228f <duppage+0x16a>

						perm = (perm|PTE_COW)&(~PTE_W);
  8021d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d7:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8021dc:	80 cc 08             	or     $0x8,%ah
  8021df:	89 45 fc             	mov    %eax,-0x4(%rbp)

						if(0 < sys_page_map(0,addr,envid,addr,perm))
  8021e2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021e5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8021e9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f0:	41 89 f0             	mov    %esi,%r8d
  8021f3:	48 89 c6             	mov    %rax,%rsi
  8021f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fb:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  802202:	00 00 00 
  802205:	ff d0                	callq  *%rax
  802207:	85 c0                	test   %eax,%eax
  802209:	7e 2a                	jle    802235 <duppage+0x110>
							panic("Page alloc with COW  failed.\n");
  80220b:	48 ba dd 49 80 00 00 	movabs $0x8049dd,%rdx
  802212:	00 00 00 
  802215:	be 5a 00 00 00       	mov    $0x5a,%esi
  80221a:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  802221:	00 00 00 
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
  802229:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  802230:	00 00 00 
  802233:	ff d1                	callq  *%rcx

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  802235:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802238:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802240:	41 89 c8             	mov    %ecx,%r8d
  802243:	48 89 d1             	mov    %rdx,%rcx
  802246:	ba 00 00 00 00       	mov    $0x0,%edx
  80224b:	48 89 c6             	mov    %rax,%rsi
  80224e:	bf 00 00 00 00       	mov    $0x0,%edi
  802253:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax
  80225f:	85 c0                	test   %eax,%eax
  802261:	7e 2a                	jle    80228d <duppage+0x168>
							panic("Page alloc with COW  failed.\n");
  802263:	48 ba dd 49 80 00 00 	movabs $0x8049dd,%rdx
  80226a:	00 00 00 
  80226d:	be 5d 00 00 00       	mov    $0x5d,%esi
  802272:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  802279:	00 00 00 
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  802288:	00 00 00 
  80228b:	ff d1                	callq  *%rcx
						perm = (perm|PTE_COW)&(~PTE_W);

						if(0 < sys_page_map(0,addr,envid,addr,perm))
							panic("Page alloc with COW  failed.\n");

						if(0 <  sys_page_map(0,addr,0,addr,perm))
  80228d:	eb 53                	jmp    8022e2 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");

					}else{
						if(0 < sys_page_map(0,addr,envid,addr,perm))
  80228f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802292:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802296:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229d:	41 89 f0             	mov    %esi,%r8d
  8022a0:	48 89 c6             	mov    %rax,%rsi
  8022a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a8:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  8022af:	00 00 00 
  8022b2:	ff d0                	callq  *%rax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	7e 2a                	jle    8022e2 <duppage+0x1bd>
							panic("Page alloc with COW  failed.\n");
  8022b8:	48 ba dd 49 80 00 00 	movabs $0x8049dd,%rdx
  8022bf:	00 00 00 
  8022c2:	be 61 00 00 00       	mov    $0x61,%esi
  8022c7:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  8022ce:	00 00 00 
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  8022dd:	00 00 00 
  8022e0:	ff d1                	callq  *%rcx
					}
		}

	//panic("duppage not implemented");
	return 0;
  8022e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e7:	c9                   	leaveq 
  8022e8:	c3                   	retq   

00000000008022e9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022e9:	55                   	push   %rbp
  8022ea:	48 89 e5             	mov    %rsp,%rbp
  8022ed:	48 83 ec 20          	sub    $0x20,%rsp
	int r;

	uint64_t i;
	uint64_t addr, last;

	set_pgfault_handler(pgfault);
  8022f1:	48 bf 90 1f 80 00 00 	movabs $0x801f90,%rdi
  8022f8:	00 00 00 
  8022fb:	48 b8 fc 3e 80 00 00 	movabs $0x803efc,%rax
  802302:	00 00 00 
  802305:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802307:	b8 07 00 00 00       	mov    $0x7,%eax
  80230c:	cd 30                	int    $0x30
  80230e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802311:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  802314:	89 45 f4             	mov    %eax,-0xc(%rbp)


	if(envid < 0)
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80231b:	79 30                	jns    80234d <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  80231d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802320:	89 c1                	mov    %eax,%ecx
  802322:	48 ba fb 49 80 00 00 	movabs $0x8049fb,%rdx
  802329:	00 00 00 
  80232c:	be 89 00 00 00       	mov    $0x89,%esi
  802331:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  802338:	00 00 00 
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  802347:	00 00 00 
  80234a:	41 ff d0             	callq  *%r8
    else if(envid == 0){
  80234d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802351:	75 46                	jne    802399 <fork+0xb0>
		thisenv = &envs[ENVX(sys_getenvid())];
  802353:	48 b8 a7 1c 80 00 00 	movabs $0x801ca7,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
  80235f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802364:	48 63 d0             	movslq %eax,%rdx
  802367:	48 89 d0             	mov    %rdx,%rax
  80236a:	48 c1 e0 03          	shl    $0x3,%rax
  80236e:	48 01 d0             	add    %rdx,%rax
  802371:	48 c1 e0 05          	shl    $0x5,%rax
  802375:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80237c:	00 00 00 
  80237f:	48 01 c2             	add    %rax,%rdx
  802382:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802389:	00 00 00 
  80238c:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	e9 d1 01 00 00       	jmpq   80256a <fork+0x281>
	}

	uint64_t ad = 0;
  802399:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8023a0:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  8023a1:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8023a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8023aa:	e9 df 00 00 00       	jmpq   80248e <fork+0x1a5>
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8023af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b3:	48 c1 e8 27          	shr    $0x27,%rax
  8023b7:	48 89 c2             	mov    %rax,%rdx
  8023ba:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023c1:	01 00 00 
  8023c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c8:	83 e0 01             	and    $0x1,%eax
  8023cb:	48 85 c0             	test   %rax,%rax
  8023ce:	0f 84 9e 00 00 00    	je     802472 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8023d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8023dc:	48 89 c2             	mov    %rax,%rdx
  8023df:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023e6:	01 00 00 
  8023e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ed:	83 e0 01             	and    $0x1,%eax
  8023f0:	48 85 c0             	test   %rax,%rax
  8023f3:	74 73                	je     802468 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8023f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f9:	48 c1 e8 15          	shr    $0x15,%rax
  8023fd:	48 89 c2             	mov    %rax,%rdx
  802400:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802407:	01 00 00 
  80240a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240e:	83 e0 01             	and    $0x1,%eax
  802411:	48 85 c0             	test   %rax,%rax
  802414:	74 48                	je     80245e <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802416:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80241a:	48 c1 e8 0c          	shr    $0xc,%rax
  80241e:	48 89 c2             	mov    %rax,%rdx
  802421:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802428:	01 00 00 
  80242b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802437:	83 e0 01             	and    $0x1,%eax
  80243a:	48 85 c0             	test   %rax,%rax
  80243d:	74 47                	je     802486 <fork+0x19d>
						duppage(envid, VPN(addr));
  80243f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802443:	48 c1 e8 0c          	shr    $0xc,%rax
  802447:	89 c2                	mov    %eax,%edx
  802449:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244c:	89 d6                	mov    %edx,%esi
  80244e:	89 c7                	mov    %eax,%edi
  802450:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
  80245c:	eb 28                	jmp    802486 <fork+0x19d>
						}
					}else{
						addr -= NPDENTRIES*PGSIZE;
  80245e:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802465:	00 
  802466:	eb 1e                	jmp    802486 <fork+0x19d>
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802468:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80246f:	40 
  802470:	eb 14                	jmp    802486 <fork+0x19d>
			}

		}else{
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT);
  802472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802476:	48 c1 e8 27          	shr    $0x27,%rax
  80247a:	48 83 c0 01          	add    $0x1,%rax
  80247e:	48 c1 e0 27          	shl    $0x27,%rax
  802482:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){
  802486:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80248d:	00 
  80248e:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802495:	00 
  802496:	0f 87 13 ff ff ff    	ja     8023af <fork+0xc6>
		}

	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  80249c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80249f:	ba 07 00 00 00       	mov    $0x7,%edx
  8024a4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024a9:	89 c7                	mov    %eax,%edi
  8024ab:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W);
  8024b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8024bf:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024c4:	89 c7                	mov    %eax,%edi
  8024c6:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  8024cd:	00 00 00 
  8024d0:	ff d0                	callq  *%rax
	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8024d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8024d5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8024db:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8024e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e5:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8024ea:	89 c7                	mov    %eax,%edi
  8024ec:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8024f8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024fd:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802502:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802507:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  80250e:	00 00 00 
  802511:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802513:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802518:	bf 00 00 00 00       	mov    $0x0,%edi
  80251d:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
  sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall);
  802529:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802530:	00 00 00 
  802533:	48 8b 00             	mov    (%rax),%rax
  802536:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80253d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802540:	48 89 d6             	mov    %rdx,%rsi
  802543:	89 c7                	mov    %eax,%edi
  802545:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  80254c:	00 00 00 
  80254f:	ff d0                	callq  *%rax
	sys_env_set_status(envid, ENV_RUNNABLE);
  802551:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802554:	be 02 00 00 00       	mov    $0x2,%esi
  802559:	89 c7                	mov    %eax,%edi
  80255b:	48 b8 18 1e 80 00 00 	movabs $0x801e18,%rax
  802562:	00 00 00 
  802565:	ff d0                	callq  *%rax

	return envid;
  802567:	8b 45 f4             	mov    -0xc(%rbp),%eax

	//panic("fork not implemented");
}
  80256a:	c9                   	leaveq 
  80256b:	c3                   	retq   

000000000080256c <sfork>:

// Challenge!
int
sfork(void)
{
  80256c:	55                   	push   %rbp
  80256d:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802570:	48 ba 13 4a 80 00 00 	movabs $0x804a13,%rdx
  802577:	00 00 00 
  80257a:	be b8 00 00 00       	mov    $0xb8,%esi
  80257f:	48 bf 5d 49 80 00 00 	movabs $0x80495d,%rdi
  802586:	00 00 00 
  802589:	b8 00 00 00 00       	mov    $0x0,%eax
  80258e:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  802595:	00 00 00 
  802598:	ff d1                	callq  *%rcx

000000000080259a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80259a:	55                   	push   %rbp
  80259b:	48 89 e5             	mov    %rsp,%rbp
  80259e:	48 83 ec 08          	sub    $0x8,%rsp
  8025a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025aa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025b1:	ff ff ff 
  8025b4:	48 01 d0             	add    %rdx,%rax
  8025b7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025bb:	c9                   	leaveq 
  8025bc:	c3                   	retq   

00000000008025bd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025bd:	55                   	push   %rbp
  8025be:	48 89 e5             	mov    %rsp,%rbp
  8025c1:	48 83 ec 08          	sub    $0x8,%rsp
  8025c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025cd:	48 89 c7             	mov    %rax,%rdi
  8025d0:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
  8025dc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025e2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025e6:	c9                   	leaveq 
  8025e7:	c3                   	retq   

00000000008025e8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025e8:	55                   	push   %rbp
  8025e9:	48 89 e5             	mov    %rsp,%rbp
  8025ec:	48 83 ec 18          	sub    $0x18,%rsp
  8025f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025fb:	eb 6b                	jmp    802668 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802600:	48 98                	cltq   
  802602:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802608:	48 c1 e0 0c          	shl    $0xc,%rax
  80260c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802614:	48 c1 e8 15          	shr    $0x15,%rax
  802618:	48 89 c2             	mov    %rax,%rdx
  80261b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802622:	01 00 00 
  802625:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802629:	83 e0 01             	and    $0x1,%eax
  80262c:	48 85 c0             	test   %rax,%rax
  80262f:	74 21                	je     802652 <fd_alloc+0x6a>
  802631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802635:	48 c1 e8 0c          	shr    $0xc,%rax
  802639:	48 89 c2             	mov    %rax,%rdx
  80263c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802643:	01 00 00 
  802646:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264a:	83 e0 01             	and    $0x1,%eax
  80264d:	48 85 c0             	test   %rax,%rax
  802650:	75 12                	jne    802664 <fd_alloc+0x7c>
			*fd_store = fd;
  802652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802656:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80265a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	eb 1a                	jmp    80267e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802664:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802668:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80266c:	7e 8f                	jle    8025fd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80266e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802672:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802679:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80267e:	c9                   	leaveq 
  80267f:	c3                   	retq   

0000000000802680 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802680:	55                   	push   %rbp
  802681:	48 89 e5             	mov    %rsp,%rbp
  802684:	48 83 ec 20          	sub    $0x20,%rsp
  802688:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80268b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80268f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802693:	78 06                	js     80269b <fd_lookup+0x1b>
  802695:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802699:	7e 07                	jle    8026a2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80269b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026a0:	eb 6c                	jmp    80270e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a5:	48 98                	cltq   
  8026a7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026ad:	48 c1 e0 0c          	shl    $0xc,%rax
  8026b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b9:	48 c1 e8 15          	shr    $0x15,%rax
  8026bd:	48 89 c2             	mov    %rax,%rdx
  8026c0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026c7:	01 00 00 
  8026ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ce:	83 e0 01             	and    $0x1,%eax
  8026d1:	48 85 c0             	test   %rax,%rax
  8026d4:	74 21                	je     8026f7 <fd_lookup+0x77>
  8026d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026da:	48 c1 e8 0c          	shr    $0xc,%rax
  8026de:	48 89 c2             	mov    %rax,%rdx
  8026e1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026e8:	01 00 00 
  8026eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026ef:	83 e0 01             	and    $0x1,%eax
  8026f2:	48 85 c0             	test   %rax,%rax
  8026f5:	75 07                	jne    8026fe <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026fc:	eb 10                	jmp    80270e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802702:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802706:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270e:	c9                   	leaveq 
  80270f:	c3                   	retq   

0000000000802710 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802710:	55                   	push   %rbp
  802711:	48 89 e5             	mov    %rsp,%rbp
  802714:	48 83 ec 30          	sub    $0x30,%rsp
  802718:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80271c:	89 f0                	mov    %esi,%eax
  80271e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802725:	48 89 c7             	mov    %rax,%rdi
  802728:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
  802734:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802738:	48 89 d6             	mov    %rdx,%rsi
  80273b:	89 c7                	mov    %eax,%edi
  80273d:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802744:	00 00 00 
  802747:	ff d0                	callq  *%rax
  802749:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802750:	78 0a                	js     80275c <fd_close+0x4c>
	    || fd != fd2)
  802752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802756:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80275a:	74 12                	je     80276e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80275c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802760:	74 05                	je     802767 <fd_close+0x57>
  802762:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802765:	eb 05                	jmp    80276c <fd_close+0x5c>
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	eb 69                	jmp    8027d7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80276e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802772:	8b 00                	mov    (%rax),%eax
  802774:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802778:	48 89 d6             	mov    %rdx,%rsi
  80277b:	89 c7                	mov    %eax,%edi
  80277d:	48 b8 d9 27 80 00 00 	movabs $0x8027d9,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
  802789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802790:	78 2a                	js     8027bc <fd_close+0xac>
		if (dev->dev_close)
  802792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802796:	48 8b 40 20          	mov    0x20(%rax),%rax
  80279a:	48 85 c0             	test   %rax,%rax
  80279d:	74 16                	je     8027b5 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80279f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027a7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ab:	48 89 d7             	mov    %rdx,%rdi
  8027ae:	ff d0                	callq  *%rax
  8027b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b3:	eb 07                	jmp    8027bc <fd_close+0xac>
		else
			r = 0;
  8027b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c0:	48 89 c6             	mov    %rax,%rsi
  8027c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c8:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
	return r;
  8027d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027d7:	c9                   	leaveq 
  8027d8:	c3                   	retq   

00000000008027d9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027d9:	55                   	push   %rbp
  8027da:	48 89 e5             	mov    %rsp,%rbp
  8027dd:	48 83 ec 20          	sub    $0x20,%rsp
  8027e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027ef:	eb 41                	jmp    802832 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8027f1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027f8:	00 00 00 
  8027fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027fe:	48 63 d2             	movslq %edx,%rdx
  802801:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802805:	8b 00                	mov    (%rax),%eax
  802807:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80280a:	75 22                	jne    80282e <dev_lookup+0x55>
			*dev = devtab[i];
  80280c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802813:	00 00 00 
  802816:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802819:	48 63 d2             	movslq %edx,%rdx
  80281c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802820:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802824:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
  80282c:	eb 60                	jmp    80288e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80282e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802832:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802839:	00 00 00 
  80283c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80283f:	48 63 d2             	movslq %edx,%rdx
  802842:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802846:	48 85 c0             	test   %rax,%rax
  802849:	75 a6                	jne    8027f1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80284b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802852:	00 00 00 
  802855:	48 8b 00             	mov    (%rax),%rax
  802858:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80285e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802861:	89 c6                	mov    %eax,%esi
  802863:	48 bf 30 4a 80 00 00 	movabs $0x804a30,%rdi
  80286a:	00 00 00 
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
  802872:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  802879:	00 00 00 
  80287c:	ff d1                	callq  *%rcx
	*dev = 0;
  80287e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802882:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80288e:	c9                   	leaveq 
  80288f:	c3                   	retq   

0000000000802890 <close>:

int
close(int fdnum)
{
  802890:	55                   	push   %rbp
  802891:	48 89 e5             	mov    %rsp,%rbp
  802894:	48 83 ec 20          	sub    $0x20,%rsp
  802898:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80289b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80289f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a2:	48 89 d6             	mov    %rdx,%rsi
  8028a5:	89 c7                	mov    %eax,%edi
  8028a7:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  8028ae:	00 00 00 
  8028b1:	ff d0                	callq  *%rax
  8028b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ba:	79 05                	jns    8028c1 <close+0x31>
		return r;
  8028bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bf:	eb 18                	jmp    8028d9 <close+0x49>
	else
		return fd_close(fd, 1);
  8028c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c5:	be 01 00 00 00       	mov    $0x1,%esi
  8028ca:	48 89 c7             	mov    %rax,%rdi
  8028cd:	48 b8 10 27 80 00 00 	movabs $0x802710,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
}
  8028d9:	c9                   	leaveq 
  8028da:	c3                   	retq   

00000000008028db <close_all>:

void
close_all(void)
{
  8028db:	55                   	push   %rbp
  8028dc:	48 89 e5             	mov    %rsp,%rbp
  8028df:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028ea:	eb 15                	jmp    802901 <close_all+0x26>
		close(i);
  8028ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ef:	89 c7                	mov    %eax,%edi
  8028f1:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802901:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802905:	7e e5                	jle    8028ec <close_all+0x11>
		close(i);
}
  802907:	c9                   	leaveq 
  802908:	c3                   	retq   

0000000000802909 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802909:	55                   	push   %rbp
  80290a:	48 89 e5             	mov    %rsp,%rbp
  80290d:	48 83 ec 40          	sub    $0x40,%rsp
  802911:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802914:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802917:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80291b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80291e:	48 89 d6             	mov    %rdx,%rsi
  802921:	89 c7                	mov    %eax,%edi
  802923:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	callq  *%rax
  80292f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802932:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802936:	79 08                	jns    802940 <dup+0x37>
		return r;
  802938:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293b:	e9 70 01 00 00       	jmpq   802ab0 <dup+0x1a7>
	close(newfdnum);
  802940:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802943:	89 c7                	mov    %eax,%edi
  802945:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802951:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802954:	48 98                	cltq   
  802956:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80295c:	48 c1 e0 0c          	shl    $0xc,%rax
  802960:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802968:	48 89 c7             	mov    %rax,%rdi
  80296b:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  802972:	00 00 00 
  802975:	ff d0                	callq  *%rax
  802977:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80297b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297f:	48 89 c7             	mov    %rax,%rdi
  802982:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  802989:	00 00 00 
  80298c:	ff d0                	callq  *%rax
  80298e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802996:	48 c1 e8 15          	shr    $0x15,%rax
  80299a:	48 89 c2             	mov    %rax,%rdx
  80299d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029a4:	01 00 00 
  8029a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ab:	83 e0 01             	and    $0x1,%eax
  8029ae:	48 85 c0             	test   %rax,%rax
  8029b1:	74 73                	je     802a26 <dup+0x11d>
  8029b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8029bb:	48 89 c2             	mov    %rax,%rdx
  8029be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029c5:	01 00 00 
  8029c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029cc:	83 e0 01             	and    $0x1,%eax
  8029cf:	48 85 c0             	test   %rax,%rax
  8029d2:	74 52                	je     802a26 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8029dc:	48 89 c2             	mov    %rax,%rdx
  8029df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029e6:	01 00 00 
  8029e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8029f2:	89 c1                	mov    %eax,%ecx
  8029f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029fc:	41 89 c8             	mov    %ecx,%r8d
  8029ff:	48 89 d1             	mov    %rdx,%rcx
  802a02:	ba 00 00 00 00       	mov    $0x0,%edx
  802a07:	48 89 c6             	mov    %rax,%rsi
  802a0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a0f:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  802a16:	00 00 00 
  802a19:	ff d0                	callq  *%rax
  802a1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a22:	79 02                	jns    802a26 <dup+0x11d>
			goto err;
  802a24:	eb 57                	jmp    802a7d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a2a:	48 c1 e8 0c          	shr    $0xc,%rax
  802a2e:	48 89 c2             	mov    %rax,%rdx
  802a31:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a38:	01 00 00 
  802a3b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a3f:	25 07 0e 00 00       	and    $0xe07,%eax
  802a44:	89 c1                	mov    %eax,%ecx
  802a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a4e:	41 89 c8             	mov    %ecx,%r8d
  802a51:	48 89 d1             	mov    %rdx,%rcx
  802a54:	ba 00 00 00 00       	mov    $0x0,%edx
  802a59:	48 89 c6             	mov    %rax,%rsi
  802a5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802a61:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
  802a6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a74:	79 02                	jns    802a78 <dup+0x16f>
		goto err;
  802a76:	eb 05                	jmp    802a7d <dup+0x174>

	return newfdnum;
  802a78:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a7b:	eb 33                	jmp    802ab0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a81:	48 89 c6             	mov    %rax,%rsi
  802a84:	bf 00 00 00 00       	mov    $0x0,%edi
  802a89:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a99:	48 89 c6             	mov    %rax,%rsi
  802a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa1:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
	return r;
  802aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ab0:	c9                   	leaveq 
  802ab1:	c3                   	retq   

0000000000802ab2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ab2:	55                   	push   %rbp
  802ab3:	48 89 e5             	mov    %rsp,%rbp
  802ab6:	48 83 ec 40          	sub    $0x40,%rsp
  802aba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802abd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ac1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ac5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802acc:	48 89 d6             	mov    %rdx,%rsi
  802acf:	89 c7                	mov    %eax,%edi
  802ad1:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802ad8:	00 00 00 
  802adb:	ff d0                	callq  *%rax
  802add:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae4:	78 24                	js     802b0a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ae6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aea:	8b 00                	mov    (%rax),%eax
  802aec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802af0:	48 89 d6             	mov    %rdx,%rsi
  802af3:	89 c7                	mov    %eax,%edi
  802af5:	48 b8 d9 27 80 00 00 	movabs $0x8027d9,%rax
  802afc:	00 00 00 
  802aff:	ff d0                	callq  *%rax
  802b01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b08:	79 05                	jns    802b0f <read+0x5d>
		return r;
  802b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0d:	eb 76                	jmp    802b85 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b13:	8b 40 08             	mov    0x8(%rax),%eax
  802b16:	83 e0 03             	and    $0x3,%eax
  802b19:	83 f8 01             	cmp    $0x1,%eax
  802b1c:	75 3a                	jne    802b58 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b1e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b25:	00 00 00 
  802b28:	48 8b 00             	mov    (%rax),%rax
  802b2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b31:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b34:	89 c6                	mov    %eax,%esi
  802b36:	48 bf 4f 4a 80 00 00 	movabs $0x804a4f,%rdi
  802b3d:	00 00 00 
  802b40:	b8 00 00 00 00       	mov    $0x0,%eax
  802b45:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  802b4c:	00 00 00 
  802b4f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b56:	eb 2d                	jmp    802b85 <read+0xd3>
	}
	if (!dev->dev_read)
  802b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b60:	48 85 c0             	test   %rax,%rax
  802b63:	75 07                	jne    802b6c <read+0xba>
		return -E_NOT_SUPP;
  802b65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b6a:	eb 19                	jmp    802b85 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b70:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b74:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b78:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b7c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b80:	48 89 cf             	mov    %rcx,%rdi
  802b83:	ff d0                	callq  *%rax
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 30          	sub    $0x30,%rsp
  802b8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b96:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ba1:	eb 49                	jmp    802bec <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba6:	48 98                	cltq   
  802ba8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bac:	48 29 c2             	sub    %rax,%rdx
  802baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb2:	48 63 c8             	movslq %eax,%rcx
  802bb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb9:	48 01 c1             	add    %rax,%rcx
  802bbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bbf:	48 89 ce             	mov    %rcx,%rsi
  802bc2:	89 c7                	mov    %eax,%edi
  802bc4:	48 b8 b2 2a 80 00 00 	movabs $0x802ab2,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
  802bd0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bd3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bd7:	79 05                	jns    802bde <readn+0x57>
			return m;
  802bd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdc:	eb 1c                	jmp    802bfa <readn+0x73>
		if (m == 0)
  802bde:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802be2:	75 02                	jne    802be6 <readn+0x5f>
			break;
  802be4:	eb 11                	jmp    802bf7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802be6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802be9:	01 45 fc             	add    %eax,-0x4(%rbp)
  802bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bef:	48 98                	cltq   
  802bf1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bf5:	72 ac                	jb     802ba3 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bfa:	c9                   	leaveq 
  802bfb:	c3                   	retq   

0000000000802bfc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802bfc:	55                   	push   %rbp
  802bfd:	48 89 e5             	mov    %rsp,%rbp
  802c00:	48 83 ec 40          	sub    $0x40,%rsp
  802c04:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c0b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c16:	48 89 d6             	mov    %rdx,%rsi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2e:	78 24                	js     802c54 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c34:	8b 00                	mov    (%rax),%eax
  802c36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3a:	48 89 d6             	mov    %rdx,%rsi
  802c3d:	89 c7                	mov    %eax,%edi
  802c3f:	48 b8 d9 27 80 00 00 	movabs $0x8027d9,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
  802c4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c52:	79 05                	jns    802c59 <write+0x5d>
		return r;
  802c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c57:	eb 75                	jmp    802cce <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5d:	8b 40 08             	mov    0x8(%rax),%eax
  802c60:	83 e0 03             	and    $0x3,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	75 3a                	jne    802ca1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c67:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c6e:	00 00 00 
  802c71:	48 8b 00             	mov    (%rax),%rax
  802c74:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c7a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c7d:	89 c6                	mov    %eax,%esi
  802c7f:	48 bf 6b 4a 80 00 00 	movabs $0x804a6b,%rdi
  802c86:	00 00 00 
  802c89:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8e:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  802c95:	00 00 00 
  802c98:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c9f:	eb 2d                	jmp    802cce <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca5:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ca9:	48 85 c0             	test   %rax,%rax
  802cac:	75 07                	jne    802cb5 <write+0xb9>
		return -E_NOT_SUPP;
  802cae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb3:	eb 19                	jmp    802cce <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb9:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cbd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cc1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cc5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cc9:	48 89 cf             	mov    %rcx,%rdi
  802ccc:	ff d0                	callq  *%rax
}
  802cce:	c9                   	leaveq 
  802ccf:	c3                   	retq   

0000000000802cd0 <seek>:

int
seek(int fdnum, off_t offset)
{
  802cd0:	55                   	push   %rbp
  802cd1:	48 89 e5             	mov    %rsp,%rbp
  802cd4:	48 83 ec 18          	sub    $0x18,%rsp
  802cd8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cdb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cde:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ce2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce5:	48 89 d6             	mov    %rdx,%rsi
  802ce8:	89 c7                	mov    %eax,%edi
  802cea:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
  802cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfd:	79 05                	jns    802d04 <seek+0x34>
		return r;
  802cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d02:	eb 0f                	jmp    802d13 <seek+0x43>
	fd->fd_offset = offset;
  802d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d08:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d13:	c9                   	leaveq 
  802d14:	c3                   	retq   

0000000000802d15 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d15:	55                   	push   %rbp
  802d16:	48 89 e5             	mov    %rsp,%rbp
  802d19:	48 83 ec 30          	sub    $0x30,%rsp
  802d1d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d20:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d23:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d2a:	48 89 d6             	mov    %rdx,%rsi
  802d2d:	89 c7                	mov    %eax,%edi
  802d2f:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802d36:	00 00 00 
  802d39:	ff d0                	callq  *%rax
  802d3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d42:	78 24                	js     802d68 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d48:	8b 00                	mov    (%rax),%eax
  802d4a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d4e:	48 89 d6             	mov    %rdx,%rsi
  802d51:	89 c7                	mov    %eax,%edi
  802d53:	48 b8 d9 27 80 00 00 	movabs $0x8027d9,%rax
  802d5a:	00 00 00 
  802d5d:	ff d0                	callq  *%rax
  802d5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d66:	79 05                	jns    802d6d <ftruncate+0x58>
		return r;
  802d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6b:	eb 72                	jmp    802ddf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d71:	8b 40 08             	mov    0x8(%rax),%eax
  802d74:	83 e0 03             	and    $0x3,%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	75 3a                	jne    802db5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d7b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d82:	00 00 00 
  802d85:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d88:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d8e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d91:	89 c6                	mov    %eax,%esi
  802d93:	48 bf 88 4a 80 00 00 	movabs $0x804a88,%rdi
  802d9a:	00 00 00 
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	48 b9 2c 08 80 00 00 	movabs $0x80082c,%rcx
  802da9:	00 00 00 
  802dac:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802db3:	eb 2a                	jmp    802ddf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db9:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dbd:	48 85 c0             	test   %rax,%rax
  802dc0:	75 07                	jne    802dc9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dc2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dc7:	eb 16                	jmp    802ddf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcd:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dd5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802dd8:	89 ce                	mov    %ecx,%esi
  802dda:	48 89 d7             	mov    %rdx,%rdi
  802ddd:	ff d0                	callq  *%rax
}
  802ddf:	c9                   	leaveq 
  802de0:	c3                   	retq   

0000000000802de1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802de1:	55                   	push   %rbp
  802de2:	48 89 e5             	mov    %rsp,%rbp
  802de5:	48 83 ec 30          	sub    $0x30,%rsp
  802de9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802df0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802df4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802df7:	48 89 d6             	mov    %rdx,%rsi
  802dfa:	89 c7                	mov    %eax,%edi
  802dfc:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  802e03:	00 00 00 
  802e06:	ff d0                	callq  *%rax
  802e08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0f:	78 24                	js     802e35 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e15:	8b 00                	mov    (%rax),%eax
  802e17:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e1b:	48 89 d6             	mov    %rdx,%rsi
  802e1e:	89 c7                	mov    %eax,%edi
  802e20:	48 b8 d9 27 80 00 00 	movabs $0x8027d9,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
  802e2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e33:	79 05                	jns    802e3a <fstat+0x59>
		return r;
  802e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e38:	eb 5e                	jmp    802e98 <fstat+0xb7>
	if (!dev->dev_stat)
  802e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e42:	48 85 c0             	test   %rax,%rax
  802e45:	75 07                	jne    802e4e <fstat+0x6d>
		return -E_NOT_SUPP;
  802e47:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e4c:	eb 4a                	jmp    802e98 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e52:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e59:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e60:	00 00 00 
	stat->st_isdir = 0;
  802e63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e67:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e6e:	00 00 00 
	stat->st_dev = dev;
  802e71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e79:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e84:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e8c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e90:	48 89 ce             	mov    %rcx,%rsi
  802e93:	48 89 d7             	mov    %rdx,%rdi
  802e96:	ff d0                	callq  *%rax
}
  802e98:	c9                   	leaveq 
  802e99:	c3                   	retq   

0000000000802e9a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e9a:	55                   	push   %rbp
  802e9b:	48 89 e5             	mov    %rsp,%rbp
  802e9e:	48 83 ec 20          	sub    $0x20,%rsp
  802ea2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eae:	be 00 00 00 00       	mov    $0x0,%esi
  802eb3:	48 89 c7             	mov    %rax,%rdi
  802eb6:	48 b8 88 2f 80 00 00 	movabs $0x802f88,%rax
  802ebd:	00 00 00 
  802ec0:	ff d0                	callq  *%rax
  802ec2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec9:	79 05                	jns    802ed0 <stat+0x36>
		return fd;
  802ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ece:	eb 2f                	jmp    802eff <stat+0x65>
	r = fstat(fd, stat);
  802ed0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed7:	48 89 d6             	mov    %rdx,%rsi
  802eda:	89 c7                	mov    %eax,%edi
  802edc:	48 b8 e1 2d 80 00 00 	movabs $0x802de1,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
  802ee8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
	return r;
  802efc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802eff:	c9                   	leaveq 
  802f00:	c3                   	retq   

0000000000802f01 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f01:	55                   	push   %rbp
  802f02:	48 89 e5             	mov    %rsp,%rbp
  802f05:	48 83 ec 10          	sub    $0x10,%rsp
  802f09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f10:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f17:	00 00 00 
  802f1a:	8b 00                	mov    (%rax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	75 1d                	jne    802f3d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f20:	bf 01 00 00 00       	mov    $0x1,%edi
  802f25:	48 b8 9f 41 80 00 00 	movabs $0x80419f,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
  802f31:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802f38:	00 00 00 
  802f3b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f3d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f44:	00 00 00 
  802f47:	8b 00                	mov    (%rax),%eax
  802f49:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f4c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f51:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f58:	00 00 00 
  802f5b:	89 c7                	mov    %eax,%edi
  802f5d:	48 b8 07 41 80 00 00 	movabs $0x804107,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f72:	48 89 c6             	mov    %rax,%rsi
  802f75:	bf 00 00 00 00       	mov    $0x0,%edi
  802f7a:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	callq  *%rax
}
  802f86:	c9                   	leaveq 
  802f87:	c3                   	retq   

0000000000802f88 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f88:	55                   	push   %rbp
  802f89:	48 89 e5             	mov    %rsp,%rbp
  802f8c:	48 83 ec 20          	sub    $0x20,%rsp
  802f90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f94:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9b:	48 89 c7             	mov    %rax,%rdi
  802f9e:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
  802faa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802faf:	7e 0a                	jle    802fbb <open+0x33>
		return -E_BAD_PATH;
  802fb1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fb6:	e9 a5 00 00 00       	jmpq   803060 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802fbb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fbf:	48 89 c7             	mov    %rax,%rdi
  802fc2:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
  802fce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd5:	79 08                	jns    802fdf <open+0x57>
		return r;
  802fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fda:	e9 81 00 00 00       	jmpq   803060 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802fdf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe3:	48 89 c6             	mov    %rax,%rsi
  802fe6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fed:	00 00 00 
  802ff0:	48 b8 f4 13 80 00 00 	movabs $0x8013f4,%rax
  802ff7:	00 00 00 
  802ffa:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ffc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803003:	00 00 00 
  803006:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803009:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80300f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803013:	48 89 c6             	mov    %rax,%rsi
  803016:	bf 01 00 00 00       	mov    $0x1,%edi
  80301b:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
  803027:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80302a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302e:	79 1d                	jns    80304d <open+0xc5>
		fd_close(fd, 0);
  803030:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803034:	be 00 00 00 00       	mov    $0x0,%esi
  803039:	48 89 c7             	mov    %rax,%rdi
  80303c:	48 b8 10 27 80 00 00 	movabs $0x802710,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
		return r;
  803048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304b:	eb 13                	jmp    803060 <open+0xd8>
	}

	return fd2num(fd);
  80304d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803051:	48 89 c7             	mov    %rax,%rdi
  803054:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax


	// panic ("open not implemented");
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
  803066:	48 83 ec 10          	sub    $0x10,%rsp
  80306a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80306e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803072:	8b 50 0c             	mov    0xc(%rax),%edx
  803075:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80307c:	00 00 00 
  80307f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803081:	be 00 00 00 00       	mov    $0x0,%esi
  803086:	bf 06 00 00 00       	mov    $0x6,%edi
  80308b:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  803092:	00 00 00 
  803095:	ff d0                	callq  *%rax
}
  803097:	c9                   	leaveq 
  803098:	c3                   	retq   

0000000000803099 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803099:	55                   	push   %rbp
  80309a:	48 89 e5             	mov    %rsp,%rbp
  80309d:	48 83 ec 30          	sub    $0x30,%rsp
  8030a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// system server.
	// LAB 5: Your code here

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bb:	00 00 00 
  8030be:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c7:	00 00 00 
  8030ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030ce:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8030d2:	be 00 00 00 00       	mov    $0x0,%esi
  8030d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8030dc:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
  8030e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ef:	79 08                	jns    8030f9 <devfile_read+0x60>
		return r;
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f4:	e9 a4 00 00 00       	jmpq   80319d <devfile_read+0x104>
	assert(r <= n);
  8030f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fc:	48 98                	cltq   
  8030fe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803102:	76 35                	jbe    803139 <devfile_read+0xa0>
  803104:	48 b9 b5 4a 80 00 00 	movabs $0x804ab5,%rcx
  80310b:	00 00 00 
  80310e:	48 ba bc 4a 80 00 00 	movabs $0x804abc,%rdx
  803115:	00 00 00 
  803118:	be 84 00 00 00       	mov    $0x84,%esi
  80311d:	48 bf d1 4a 80 00 00 	movabs $0x804ad1,%rdi
  803124:	00 00 00 
  803127:	b8 00 00 00 00       	mov    $0x0,%eax
  80312c:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  803133:	00 00 00 
  803136:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803139:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803140:	7e 35                	jle    803177 <devfile_read+0xde>
  803142:	48 b9 dc 4a 80 00 00 	movabs $0x804adc,%rcx
  803149:	00 00 00 
  80314c:	48 ba bc 4a 80 00 00 	movabs $0x804abc,%rdx
  803153:	00 00 00 
  803156:	be 85 00 00 00       	mov    $0x85,%esi
  80315b:	48 bf d1 4a 80 00 00 	movabs $0x804ad1,%rdi
  803162:	00 00 00 
  803165:	b8 00 00 00 00       	mov    $0x0,%eax
  80316a:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  803171:	00 00 00 
  803174:	41 ff d0             	callq  *%r8
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317a:	48 63 d0             	movslq %eax,%rdx
  80317d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803181:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803188:	00 00 00 
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
	return r;
  80319a:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// panic("devfile_read not implemented");
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 30          	sub    $0x30,%rsp
  8031a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes than requested.
	// LAB 5: Your code here

	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8031ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c1:	00 00 00 
  8031c4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8031c6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031cd:	00 00 00 
  8031d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031d4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8031d8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8031df:	00 
  8031e0:	76 35                	jbe    803217 <devfile_write+0x78>
  8031e2:	48 b9 e8 4a 80 00 00 	movabs $0x804ae8,%rcx
  8031e9:	00 00 00 
  8031ec:	48 ba bc 4a 80 00 00 	movabs $0x804abc,%rdx
  8031f3:	00 00 00 
  8031f6:	be 9e 00 00 00       	mov    $0x9e,%esi
  8031fb:	48 bf d1 4a 80 00 00 	movabs $0x804ad1,%rdi
  803202:	00 00 00 
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  803211:	00 00 00 
  803214:	41 ff d0             	callq  *%r8
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803217:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80321b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321f:	48 89 c6             	mov    %rax,%rsi
  803222:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803229:	00 00 00 
  80322c:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803238:	be 00 00 00 00       	mov    $0x0,%esi
  80323d:	bf 04 00 00 00       	mov    $0x4,%edi
  803242:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
  80324e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803255:	79 05                	jns    80325c <devfile_write+0xbd>
		return r;
  803257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325a:	eb 43                	jmp    80329f <devfile_write+0x100>
	assert(r <= n);
  80325c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325f:	48 98                	cltq   
  803261:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803265:	76 35                	jbe    80329c <devfile_write+0xfd>
  803267:	48 b9 b5 4a 80 00 00 	movabs $0x804ab5,%rcx
  80326e:	00 00 00 
  803271:	48 ba bc 4a 80 00 00 	movabs $0x804abc,%rdx
  803278:	00 00 00 
  80327b:	be a2 00 00 00       	mov    $0xa2,%esi
  803280:	48 bf d1 4a 80 00 00 	movabs $0x804ad1,%rdi
  803287:	00 00 00 
  80328a:	b8 00 00 00 00       	mov    $0x0,%eax
  80328f:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  803296:	00 00 00 
  803299:	41 ff d0             	callq  *%r8
	return r;
  80329c:	8b 45 fc             	mov    -0x4(%rbp),%eax


	// panic("devfile_write not implemented");
}
  80329f:	c9                   	leaveq 
  8032a0:	c3                   	retq   

00000000008032a1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032a1:	55                   	push   %rbp
  8032a2:	48 89 e5             	mov    %rsp,%rbp
  8032a5:	48 83 ec 20          	sub    $0x20,%rsp
  8032a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b5:	8b 50 0c             	mov    0xc(%rax),%edx
  8032b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032bf:	00 00 00 
  8032c2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032c4:	be 00 00 00 00       	mov    $0x0,%esi
  8032c9:	bf 05 00 00 00       	mov    $0x5,%edi
  8032ce:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e1:	79 05                	jns    8032e8 <devfile_stat+0x47>
		return r;
  8032e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e6:	eb 56                	jmp    80333e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ec:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032f3:	00 00 00 
  8032f6:	48 89 c7             	mov    %rax,%rdi
  8032f9:	48 b8 f4 13 80 00 00 	movabs $0x8013f4,%rax
  803300:	00 00 00 
  803303:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803305:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80330c:	00 00 00 
  80330f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803315:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803319:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80331f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803326:	00 00 00 
  803329:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80332f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803333:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80333e:	c9                   	leaveq 
  80333f:	c3                   	retq   

0000000000803340 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803340:	55                   	push   %rbp
  803341:	48 89 e5             	mov    %rsp,%rbp
  803344:	48 83 ec 10          	sub    $0x10,%rsp
  803348:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80334c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80334f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803353:	8b 50 0c             	mov    0xc(%rax),%edx
  803356:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80335d:	00 00 00 
  803360:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803362:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803369:	00 00 00 
  80336c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80336f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803372:	be 00 00 00 00       	mov    $0x0,%esi
  803377:	bf 02 00 00 00       	mov    $0x2,%edi
  80337c:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
}
  803388:	c9                   	leaveq 
  803389:	c3                   	retq   

000000000080338a <remove>:

// Delete a file
int
remove(const char *path)
{
  80338a:	55                   	push   %rbp
  80338b:	48 89 e5             	mov    %rsp,%rbp
  80338e:	48 83 ec 10          	sub    $0x10,%rsp
  803392:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339a:	48 89 c7             	mov    %rax,%rdi
  80339d:	48 b8 88 13 80 00 00 	movabs $0x801388,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
  8033a9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033ae:	7e 07                	jle    8033b7 <remove+0x2d>
		return -E_BAD_PATH;
  8033b0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033b5:	eb 33                	jmp    8033ea <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bb:	48 89 c6             	mov    %rax,%rsi
  8033be:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8033c5:	00 00 00 
  8033c8:	48 b8 f4 13 80 00 00 	movabs $0x8013f4,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033d4:	be 00 00 00 00       	mov    $0x0,%esi
  8033d9:	bf 07 00 00 00       	mov    $0x7,%edi
  8033de:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
}
  8033ea:	c9                   	leaveq 
  8033eb:	c3                   	retq   

00000000008033ec <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033ec:	55                   	push   %rbp
  8033ed:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033f0:	be 00 00 00 00       	mov    $0x0,%esi
  8033f5:	bf 08 00 00 00       	mov    $0x8,%edi
  8033fa:	48 b8 01 2f 80 00 00 	movabs $0x802f01,%rax
  803401:	00 00 00 
  803404:	ff d0                	callq  *%rax
}
  803406:	5d                   	pop    %rbp
  803407:	c3                   	retq   

0000000000803408 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803408:	55                   	push   %rbp
  803409:	48 89 e5             	mov    %rsp,%rbp
  80340c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803413:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80341a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803421:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803428:	be 00 00 00 00       	mov    $0x0,%esi
  80342d:	48 89 c7             	mov    %rax,%rdi
  803430:	48 b8 88 2f 80 00 00 	movabs $0x802f88,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
  80343c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80343f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803443:	79 28                	jns    80346d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803448:	89 c6                	mov    %eax,%esi
  80344a:	48 bf 15 4b 80 00 00 	movabs $0x804b15,%rdi
  803451:	00 00 00 
  803454:	b8 00 00 00 00       	mov    $0x0,%eax
  803459:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  803460:	00 00 00 
  803463:	ff d2                	callq  *%rdx
		return fd_src;
  803465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803468:	e9 74 01 00 00       	jmpq   8035e1 <copy+0x1d9>
	}

	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80346d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803474:	be 01 01 00 00       	mov    $0x101,%esi
  803479:	48 89 c7             	mov    %rax,%rdi
  80347c:	48 b8 88 2f 80 00 00 	movabs $0x802f88,%rax
  803483:	00 00 00 
  803486:	ff d0                	callq  *%rax
  803488:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80348b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80348f:	79 39                	jns    8034ca <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803491:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803494:	89 c6                	mov    %eax,%esi
  803496:	48 bf 2b 4b 80 00 00 	movabs $0x804b2b,%rdi
  80349d:	00 00 00 
  8034a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a5:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  8034ac:	00 00 00 
  8034af:	ff d2                	callq  *%rdx
		close(fd_src);
  8034b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b4:	89 c7                	mov    %eax,%edi
  8034b6:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8034bd:	00 00 00 
  8034c0:	ff d0                	callq  *%rax
		return fd_dest;
  8034c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c5:	e9 17 01 00 00       	jmpq   8035e1 <copy+0x1d9>
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8034ca:	eb 74                	jmp    803540 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8034cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034cf:	48 63 d0             	movslq %eax,%rdx
  8034d2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034dc:	48 89 ce             	mov    %rcx,%rsi
  8034df:	89 c7                	mov    %eax,%edi
  8034e1:	48 b8 fc 2b 80 00 00 	movabs $0x802bfc,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
  8034ed:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8034f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034f4:	79 4a                	jns    803540 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8034f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034f9:	89 c6                	mov    %eax,%esi
  8034fb:	48 bf 45 4b 80 00 00 	movabs $0x804b45,%rdi
  803502:	00 00 00 
  803505:	b8 00 00 00 00       	mov    $0x0,%eax
  80350a:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  803511:	00 00 00 
  803514:	ff d2                	callq  *%rdx
			close(fd_src);
  803516:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803519:	89 c7                	mov    %eax,%edi
  80351b:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  803522:	00 00 00 
  803525:	ff d0                	callq  *%rax
			close(fd_dest);
  803527:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80352a:	89 c7                	mov    %eax,%edi
  80352c:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
			return write_size;
  803538:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80353b:	e9 a1 00 00 00       	jmpq   8035e1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}

	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803540:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354a:	ba 00 02 00 00       	mov    $0x200,%edx
  80354f:	48 89 ce             	mov    %rcx,%rsi
  803552:	89 c7                	mov    %eax,%edi
  803554:	48 b8 b2 2a 80 00 00 	movabs $0x802ab2,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803563:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803567:	0f 8f 5f ff ff ff    	jg     8034cc <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}
	}
	if (read_size < 0) {
  80356d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803571:	79 47                	jns    8035ba <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803573:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803576:	89 c6                	mov    %eax,%esi
  803578:	48 bf 58 4b 80 00 00 	movabs $0x804b58,%rdi
  80357f:	00 00 00 
  803582:	b8 00 00 00 00       	mov    $0x0,%eax
  803587:	48 ba 2c 08 80 00 00 	movabs $0x80082c,%rdx
  80358e:	00 00 00 
  803591:	ff d2                	callq  *%rdx
		close(fd_src);
  803593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803596:	89 c7                	mov    %eax,%edi
  803598:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
		close(fd_dest);
  8035a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a7:	89 c7                	mov    %eax,%edi
  8035a9:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8035b0:	00 00 00 
  8035b3:	ff d0                	callq  *%rax
		return read_size;
  8035b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035b8:	eb 27                	jmp    8035e1 <copy+0x1d9>
	}
	close(fd_src);
  8035ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bd:	89 c7                	mov    %eax,%edi
  8035bf:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
	close(fd_dest);
  8035cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ce:	89 c7                	mov    %eax,%edi
  8035d0:	48 b8 90 28 80 00 00 	movabs $0x802890,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
	return 0;
  8035dc:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8035e1:	c9                   	leaveq 
  8035e2:	c3                   	retq   

00000000008035e3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035e3:	55                   	push   %rbp
  8035e4:	48 89 e5             	mov    %rsp,%rbp
  8035e7:	53                   	push   %rbx
  8035e8:	48 83 ec 38          	sub    $0x38,%rsp
  8035ec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035f0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035f4:	48 89 c7             	mov    %rax,%rdi
  8035f7:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  8035fe:	00 00 00 
  803601:	ff d0                	callq  *%rax
  803603:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803606:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80360a:	0f 88 bf 01 00 00    	js     8037cf <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803614:	ba 07 04 00 00       	mov    $0x407,%edx
  803619:	48 89 c6             	mov    %rax,%rsi
  80361c:	bf 00 00 00 00       	mov    $0x0,%edi
  803621:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
  80362d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803630:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803634:	0f 88 95 01 00 00    	js     8037cf <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80363a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80363e:	48 89 c7             	mov    %rax,%rdi
  803641:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
  80364d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803650:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803654:	0f 88 5d 01 00 00    	js     8037b7 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80365a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80365e:	ba 07 04 00 00       	mov    $0x407,%edx
  803663:	48 89 c6             	mov    %rax,%rsi
  803666:	bf 00 00 00 00       	mov    $0x0,%edi
  80366b:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
  803677:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80367a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80367e:	0f 88 33 01 00 00    	js     8037b7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803688:	48 89 c7             	mov    %rax,%rdi
  80368b:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  803692:	00 00 00 
  803695:	ff d0                	callq  *%rax
  803697:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80369b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80369f:	ba 07 04 00 00       	mov    $0x407,%edx
  8036a4:	48 89 c6             	mov    %rax,%rsi
  8036a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ac:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
  8036b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036bf:	79 05                	jns    8036c6 <pipe+0xe3>
		goto err2;
  8036c1:	e9 d9 00 00 00       	jmpq   80379f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ca:	48 89 c7             	mov    %rax,%rdi
  8036cd:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  8036d4:	00 00 00 
  8036d7:	ff d0                	callq  *%rax
  8036d9:	48 89 c2             	mov    %rax,%rdx
  8036dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036e6:	48 89 d1             	mov    %rdx,%rcx
  8036e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8036ee:	48 89 c6             	mov    %rax,%rsi
  8036f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f6:	48 b8 73 1d 80 00 00 	movabs $0x801d73,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
  803702:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803705:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803709:	79 1b                	jns    803726 <pipe+0x143>
		goto err3;
  80370b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80370c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803710:	48 89 c6             	mov    %rax,%rsi
  803713:	bf 00 00 00 00       	mov    $0x0,%edi
  803718:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  80371f:	00 00 00 
  803722:	ff d0                	callq  *%rax
  803724:	eb 79                	jmp    80379f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372a:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803731:	00 00 00 
  803734:	8b 12                	mov    (%rdx),%edx
  803736:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803743:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803747:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80374e:	00 00 00 
  803751:	8b 12                	mov    (%rdx),%edx
  803753:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803755:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803759:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803764:	48 89 c7             	mov    %rax,%rdi
  803767:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
  803773:	89 c2                	mov    %eax,%edx
  803775:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803779:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80377b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80377f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803783:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803787:	48 89 c7             	mov    %rax,%rdi
  80378a:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
  803796:	89 03                	mov    %eax,(%rbx)
	return 0;
  803798:	b8 00 00 00 00       	mov    $0x0,%eax
  80379d:	eb 33                	jmp    8037d2 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80379f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a3:	48 89 c6             	mov    %rax,%rsi
  8037a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ab:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  8037b2:	00 00 00 
  8037b5:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037bb:	48 89 c6             	mov    %rax,%rsi
  8037be:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c3:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  8037ca:	00 00 00 
  8037cd:	ff d0                	callq  *%rax
err:
	return r;
  8037cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037d2:	48 83 c4 38          	add    $0x38,%rsp
  8037d6:	5b                   	pop    %rbx
  8037d7:	5d                   	pop    %rbp
  8037d8:	c3                   	retq   

00000000008037d9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037d9:	55                   	push   %rbp
  8037da:	48 89 e5             	mov    %rsp,%rbp
  8037dd:	53                   	push   %rbx
  8037de:	48 83 ec 28          	sub    $0x28,%rsp
  8037e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037ea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037f1:	00 00 00 
  8037f4:	48 8b 00             	mov    (%rax),%rax
  8037f7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803804:	48 89 c7             	mov    %rax,%rdi
  803807:	48 b8 21 42 80 00 00 	movabs $0x804221,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
  803813:	89 c3                	mov    %eax,%ebx
  803815:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803819:	48 89 c7             	mov    %rax,%rdi
  80381c:	48 b8 21 42 80 00 00 	movabs $0x804221,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
  803828:	39 c3                	cmp    %eax,%ebx
  80382a:	0f 94 c0             	sete   %al
  80382d:	0f b6 c0             	movzbl %al,%eax
  803830:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803833:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80383a:	00 00 00 
  80383d:	48 8b 00             	mov    (%rax),%rax
  803840:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803846:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803849:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80384f:	75 05                	jne    803856 <_pipeisclosed+0x7d>
			return ret;
  803851:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803854:	eb 4f                	jmp    8038a5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803856:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803859:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80385c:	74 42                	je     8038a0 <_pipeisclosed+0xc7>
  80385e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803862:	75 3c                	jne    8038a0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803864:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80386b:	00 00 00 
  80386e:	48 8b 00             	mov    (%rax),%rax
  803871:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803877:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80387a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80387d:	89 c6                	mov    %eax,%esi
  80387f:	48 bf 73 4b 80 00 00 	movabs $0x804b73,%rdi
  803886:	00 00 00 
  803889:	b8 00 00 00 00       	mov    $0x0,%eax
  80388e:	49 b8 2c 08 80 00 00 	movabs $0x80082c,%r8
  803895:	00 00 00 
  803898:	41 ff d0             	callq  *%r8
	}
  80389b:	e9 4a ff ff ff       	jmpq   8037ea <_pipeisclosed+0x11>
  8038a0:	e9 45 ff ff ff       	jmpq   8037ea <_pipeisclosed+0x11>
}
  8038a5:	48 83 c4 28          	add    $0x28,%rsp
  8038a9:	5b                   	pop    %rbx
  8038aa:	5d                   	pop    %rbp
  8038ab:	c3                   	retq   

00000000008038ac <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038ac:	55                   	push   %rbp
  8038ad:	48 89 e5             	mov    %rsp,%rbp
  8038b0:	48 83 ec 30          	sub    $0x30,%rsp
  8038b4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038be:	48 89 d6             	mov    %rdx,%rsi
  8038c1:	89 c7                	mov    %eax,%edi
  8038c3:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
  8038cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d6:	79 05                	jns    8038dd <pipeisclosed+0x31>
		return r;
  8038d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038db:	eb 31                	jmp    80390e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e1:	48 89 c7             	mov    %rax,%rdi
  8038e4:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  8038eb:	00 00 00 
  8038ee:	ff d0                	callq  *%rax
  8038f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038fc:	48 89 d6             	mov    %rdx,%rsi
  8038ff:	48 89 c7             	mov    %rax,%rdi
  803902:	48 b8 d9 37 80 00 00 	movabs $0x8037d9,%rax
  803909:	00 00 00 
  80390c:	ff d0                	callq  *%rax
}
  80390e:	c9                   	leaveq 
  80390f:	c3                   	retq   

0000000000803910 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803910:	55                   	push   %rbp
  803911:	48 89 e5             	mov    %rsp,%rbp
  803914:	48 83 ec 40          	sub    $0x40,%rsp
  803918:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80391c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803920:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803928:	48 89 c7             	mov    %rax,%rdi
  80392b:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
  803937:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80393b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803943:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80394a:	00 
  80394b:	e9 92 00 00 00       	jmpq   8039e2 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803950:	eb 41                	jmp    803993 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803952:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803957:	74 09                	je     803962 <devpipe_read+0x52>
				return i;
  803959:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395d:	e9 92 00 00 00       	jmpq   8039f4 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803962:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803966:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396a:	48 89 d6             	mov    %rdx,%rsi
  80396d:	48 89 c7             	mov    %rax,%rdi
  803970:	48 b8 d9 37 80 00 00 	movabs $0x8037d9,%rax
  803977:	00 00 00 
  80397a:	ff d0                	callq  *%rax
  80397c:	85 c0                	test   %eax,%eax
  80397e:	74 07                	je     803987 <devpipe_read+0x77>
				return 0;
  803980:	b8 00 00 00 00       	mov    $0x0,%eax
  803985:	eb 6d                	jmp    8039f4 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803987:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  80398e:	00 00 00 
  803991:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803997:	8b 10                	mov    (%rax),%edx
  803999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399d:	8b 40 04             	mov    0x4(%rax),%eax
  8039a0:	39 c2                	cmp    %eax,%edx
  8039a2:	74 ae                	je     803952 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ac:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b4:	8b 00                	mov    (%rax),%eax
  8039b6:	99                   	cltd   
  8039b7:	c1 ea 1b             	shr    $0x1b,%edx
  8039ba:	01 d0                	add    %edx,%eax
  8039bc:	83 e0 1f             	and    $0x1f,%eax
  8039bf:	29 d0                	sub    %edx,%eax
  8039c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039c5:	48 98                	cltq   
  8039c7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039cc:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d2:	8b 00                	mov    (%rax),%eax
  8039d4:	8d 50 01             	lea    0x1(%rax),%edx
  8039d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039db:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039ea:	0f 82 60 ff ff ff    	jb     803950 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039f4:	c9                   	leaveq 
  8039f5:	c3                   	retq   

00000000008039f6 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039f6:	55                   	push   %rbp
  8039f7:	48 89 e5             	mov    %rsp,%rbp
  8039fa:	48 83 ec 40          	sub    $0x40,%rsp
  8039fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a06:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0e:	48 89 c7             	mov    %rax,%rdi
  803a11:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a29:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a30:	00 
  803a31:	e9 8e 00 00 00       	jmpq   803ac4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a36:	eb 31                	jmp    803a69 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a40:	48 89 d6             	mov    %rdx,%rsi
  803a43:	48 89 c7             	mov    %rax,%rdi
  803a46:	48 b8 d9 37 80 00 00 	movabs $0x8037d9,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
  803a52:	85 c0                	test   %eax,%eax
  803a54:	74 07                	je     803a5d <devpipe_write+0x67>
				return 0;
  803a56:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5b:	eb 79                	jmp    803ad6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a5d:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  803a64:	00 00 00 
  803a67:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a6d:	8b 40 04             	mov    0x4(%rax),%eax
  803a70:	48 63 d0             	movslq %eax,%rdx
  803a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a77:	8b 00                	mov    (%rax),%eax
  803a79:	48 98                	cltq   
  803a7b:	48 83 c0 20          	add    $0x20,%rax
  803a7f:	48 39 c2             	cmp    %rax,%rdx
  803a82:	73 b4                	jae    803a38 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a88:	8b 40 04             	mov    0x4(%rax),%eax
  803a8b:	99                   	cltd   
  803a8c:	c1 ea 1b             	shr    $0x1b,%edx
  803a8f:	01 d0                	add    %edx,%eax
  803a91:	83 e0 1f             	and    $0x1f,%eax
  803a94:	29 d0                	sub    %edx,%eax
  803a96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a9a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a9e:	48 01 ca             	add    %rcx,%rdx
  803aa1:	0f b6 0a             	movzbl (%rdx),%ecx
  803aa4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aa8:	48 98                	cltq   
  803aaa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803aae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab2:	8b 40 04             	mov    0x4(%rax),%eax
  803ab5:	8d 50 01             	lea    0x1(%rax),%edx
  803ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803abf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ac4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803acc:	0f 82 64 ff ff ff    	jb     803a36 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ad6:	c9                   	leaveq 
  803ad7:	c3                   	retq   

0000000000803ad8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ad8:	55                   	push   %rbp
  803ad9:	48 89 e5             	mov    %rsp,%rbp
  803adc:	48 83 ec 20          	sub    $0x20,%rsp
  803ae0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ae4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ae8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aec:	48 89 c7             	mov    %rax,%rdi
  803aef:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
  803afb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b03:	48 be 86 4b 80 00 00 	movabs $0x804b86,%rsi
  803b0a:	00 00 00 
  803b0d:	48 89 c7             	mov    %rax,%rdi
  803b10:	48 b8 f4 13 80 00 00 	movabs $0x8013f4,%rax
  803b17:	00 00 00 
  803b1a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b20:	8b 50 04             	mov    0x4(%rax),%edx
  803b23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b27:	8b 00                	mov    (%rax),%eax
  803b29:	29 c2                	sub    %eax,%edx
  803b2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b40:	00 00 00 
	stat->st_dev = &devpipe;
  803b43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b47:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803b4e:	00 00 00 
  803b51:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b5d:	c9                   	leaveq 
  803b5e:	c3                   	retq   

0000000000803b5f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b5f:	55                   	push   %rbp
  803b60:	48 89 e5             	mov    %rsp,%rbp
  803b63:	48 83 ec 10          	sub    $0x10,%rsp
  803b67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6f:	48 89 c6             	mov    %rax,%rsi
  803b72:	bf 00 00 00 00       	mov    $0x0,%edi
  803b77:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  803b7e:	00 00 00 
  803b81:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b87:	48 89 c7             	mov    %rax,%rdi
  803b8a:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	48 89 c6             	mov    %rax,%rsi
  803b99:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9e:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  803ba5:	00 00 00 
  803ba8:	ff d0                	callq  *%rax
}
  803baa:	c9                   	leaveq 
  803bab:	c3                   	retq   

0000000000803bac <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803bac:	55                   	push   %rbp
  803bad:	48 89 e5             	mov    %rsp,%rbp
  803bb0:	48 83 ec 20          	sub    $0x20,%rsp
  803bb4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803bb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bbb:	75 35                	jne    803bf2 <wait+0x46>
  803bbd:	48 b9 8d 4b 80 00 00 	movabs $0x804b8d,%rcx
  803bc4:	00 00 00 
  803bc7:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  803bce:	00 00 00 
  803bd1:	be 09 00 00 00       	mov    $0x9,%esi
  803bd6:	48 bf ad 4b 80 00 00 	movabs $0x804bad,%rdi
  803bdd:	00 00 00 
  803be0:	b8 00 00 00 00       	mov    $0x0,%eax
  803be5:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  803bec:	00 00 00 
  803bef:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803bf2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf5:	25 ff 03 00 00       	and    $0x3ff,%eax
  803bfa:	48 63 d0             	movslq %eax,%rdx
  803bfd:	48 89 d0             	mov    %rdx,%rax
  803c00:	48 c1 e0 03          	shl    $0x3,%rax
  803c04:	48 01 d0             	add    %rdx,%rax
  803c07:	48 c1 e0 05          	shl    $0x5,%rax
  803c0b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c12:	00 00 00 
  803c15:	48 01 d0             	add    %rdx,%rax
  803c18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803c1c:	eb 0c                	jmp    803c2a <wait+0x7e>
		sys_yield();
  803c1e:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c34:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c37:	75 0e                	jne    803c47 <wait+0x9b>
  803c39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c43:	85 c0                	test   %eax,%eax
  803c45:	75 d7                	jne    803c1e <wait+0x72>
		sys_yield();
}
  803c47:	c9                   	leaveq 
  803c48:	c3                   	retq   

0000000000803c49 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c49:	55                   	push   %rbp
  803c4a:	48 89 e5             	mov    %rsp,%rbp
  803c4d:	48 83 ec 20          	sub    $0x20,%rsp
  803c51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c57:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c5a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c5e:	be 01 00 00 00       	mov    $0x1,%esi
  803c63:	48 89 c7             	mov    %rax,%rdi
  803c66:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  803c6d:	00 00 00 
  803c70:	ff d0                	callq  *%rax
}
  803c72:	c9                   	leaveq 
  803c73:	c3                   	retq   

0000000000803c74 <getchar>:

int
getchar(void)
{
  803c74:	55                   	push   %rbp
  803c75:	48 89 e5             	mov    %rsp,%rbp
  803c78:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c7c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c80:	ba 01 00 00 00       	mov    $0x1,%edx
  803c85:	48 89 c6             	mov    %rax,%rsi
  803c88:	bf 00 00 00 00       	mov    $0x0,%edi
  803c8d:	48 b8 b2 2a 80 00 00 	movabs $0x802ab2,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
  803c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca0:	79 05                	jns    803ca7 <getchar+0x33>
		return r;
  803ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca5:	eb 14                	jmp    803cbb <getchar+0x47>
	if (r < 1)
  803ca7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cab:	7f 07                	jg     803cb4 <getchar+0x40>
		return -E_EOF;
  803cad:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cb2:	eb 07                	jmp    803cbb <getchar+0x47>
	return c;
  803cb4:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cb8:	0f b6 c0             	movzbl %al,%eax
}
  803cbb:	c9                   	leaveq 
  803cbc:	c3                   	retq   

0000000000803cbd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cbd:	55                   	push   %rbp
  803cbe:	48 89 e5             	mov    %rsp,%rbp
  803cc1:	48 83 ec 20          	sub    $0x20,%rsp
  803cc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ccc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ccf:	48 89 d6             	mov    %rdx,%rsi
  803cd2:	89 c7                	mov    %eax,%edi
  803cd4:	48 b8 80 26 80 00 00 	movabs $0x802680,%rax
  803cdb:	00 00 00 
  803cde:	ff d0                	callq  *%rax
  803ce0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce7:	79 05                	jns    803cee <iscons+0x31>
		return r;
  803ce9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cec:	eb 1a                	jmp    803d08 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf2:	8b 10                	mov    (%rax),%edx
  803cf4:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803cfb:	00 00 00 
  803cfe:	8b 00                	mov    (%rax),%eax
  803d00:	39 c2                	cmp    %eax,%edx
  803d02:	0f 94 c0             	sete   %al
  803d05:	0f b6 c0             	movzbl %al,%eax
}
  803d08:	c9                   	leaveq 
  803d09:	c3                   	retq   

0000000000803d0a <opencons>:

int
opencons(void)
{
  803d0a:	55                   	push   %rbp
  803d0b:	48 89 e5             	mov    %rsp,%rbp
  803d0e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d12:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d16:	48 89 c7             	mov    %rax,%rdi
  803d19:	48 b8 e8 25 80 00 00 	movabs $0x8025e8,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
  803d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2c:	79 05                	jns    803d33 <opencons+0x29>
		return r;
  803d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d31:	eb 5b                	jmp    803d8e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d37:	ba 07 04 00 00       	mov    $0x407,%edx
  803d3c:	48 89 c6             	mov    %rax,%rsi
  803d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d44:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  803d4b:	00 00 00 
  803d4e:	ff d0                	callq  *%rax
  803d50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d57:	79 05                	jns    803d5e <opencons+0x54>
		return r;
  803d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5c:	eb 30                	jmp    803d8e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d62:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803d69:	00 00 00 
  803d6c:	8b 12                	mov    (%rdx),%edx
  803d6e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d74:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7f:	48 89 c7             	mov    %rax,%rdi
  803d82:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  803d89:	00 00 00 
  803d8c:	ff d0                	callq  *%rax
}
  803d8e:	c9                   	leaveq 
  803d8f:	c3                   	retq   

0000000000803d90 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d90:	55                   	push   %rbp
  803d91:	48 89 e5             	mov    %rsp,%rbp
  803d94:	48 83 ec 30          	sub    $0x30,%rsp
  803d98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803da4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803da9:	75 07                	jne    803db2 <devcons_read+0x22>
		return 0;
  803dab:	b8 00 00 00 00       	mov    $0x0,%eax
  803db0:	eb 4b                	jmp    803dfd <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803db2:	eb 0c                	jmp    803dc0 <devcons_read+0x30>
		sys_yield();
  803db4:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dc0:	48 b8 25 1c 80 00 00 	movabs $0x801c25,%rax
  803dc7:	00 00 00 
  803dca:	ff d0                	callq  *%rax
  803dcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd3:	74 df                	je     803db4 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd9:	79 05                	jns    803de0 <devcons_read+0x50>
		return c;
  803ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dde:	eb 1d                	jmp    803dfd <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803de0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803de4:	75 07                	jne    803ded <devcons_read+0x5d>
		return 0;
  803de6:	b8 00 00 00 00       	mov    $0x0,%eax
  803deb:	eb 10                	jmp    803dfd <devcons_read+0x6d>
	*(char*)vbuf = c;
  803ded:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df0:	89 c2                	mov    %eax,%edx
  803df2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df6:	88 10                	mov    %dl,(%rax)
	return 1;
  803df8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803dfd:	c9                   	leaveq 
  803dfe:	c3                   	retq   

0000000000803dff <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dff:	55                   	push   %rbp
  803e00:	48 89 e5             	mov    %rsp,%rbp
  803e03:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e0a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e11:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e18:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e26:	eb 76                	jmp    803e9e <devcons_write+0x9f>
		m = n - tot;
  803e28:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e2f:	89 c2                	mov    %eax,%edx
  803e31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e34:	29 c2                	sub    %eax,%edx
  803e36:	89 d0                	mov    %edx,%eax
  803e38:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e3e:	83 f8 7f             	cmp    $0x7f,%eax
  803e41:	76 07                	jbe    803e4a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e43:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e4d:	48 63 d0             	movslq %eax,%rdx
  803e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e53:	48 63 c8             	movslq %eax,%rcx
  803e56:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e5d:	48 01 c1             	add    %rax,%rcx
  803e60:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e67:	48 89 ce             	mov    %rcx,%rsi
  803e6a:	48 89 c7             	mov    %rax,%rdi
  803e6d:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803e74:	00 00 00 
  803e77:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e7c:	48 63 d0             	movslq %eax,%rdx
  803e7f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e86:	48 89 d6             	mov    %rdx,%rsi
  803e89:	48 89 c7             	mov    %rax,%rdi
  803e8c:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  803e93:	00 00 00 
  803e96:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e9b:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea1:	48 98                	cltq   
  803ea3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803eaa:	0f 82 78 ff ff ff    	jb     803e28 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803eb3:	c9                   	leaveq 
  803eb4:	c3                   	retq   

0000000000803eb5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803eb5:	55                   	push   %rbp
  803eb6:	48 89 e5             	mov    %rsp,%rbp
  803eb9:	48 83 ec 08          	sub    $0x8,%rsp
  803ebd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec6:	c9                   	leaveq 
  803ec7:	c3                   	retq   

0000000000803ec8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ec8:	55                   	push   %rbp
  803ec9:	48 89 e5             	mov    %rsp,%rbp
  803ecc:	48 83 ec 10          	sub    $0x10,%rsp
  803ed0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ed4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edc:	48 be bd 4b 80 00 00 	movabs $0x804bbd,%rsi
  803ee3:	00 00 00 
  803ee6:	48 89 c7             	mov    %rax,%rdi
  803ee9:	48 b8 f4 13 80 00 00 	movabs $0x8013f4,%rax
  803ef0:	00 00 00 
  803ef3:	ff d0                	callq  *%rax
	return 0;
  803ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803efa:	c9                   	leaveq 
  803efb:	c3                   	retq   

0000000000803efc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803efc:	55                   	push   %rbp
  803efd:	48 89 e5             	mov    %rsp,%rbp
  803f00:	48 83 ec 10          	sub    $0x10,%rsp
  803f04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803f08:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f0f:	00 00 00 
  803f12:	48 8b 00             	mov    (%rax),%rax
  803f15:	48 85 c0             	test   %rax,%rax
  803f18:	75 49                	jne    803f63 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.
		if((sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P) < 0))
  803f1a:	ba 07 00 00 00       	mov    $0x7,%edx
  803f1f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803f24:	bf 00 00 00 00       	mov    $0x0,%edi
  803f29:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  803f30:	00 00 00 
  803f33:	ff d0                	callq  *%rax
  803f35:	85 c0                	test   %eax,%eax
  803f37:	79 2a                	jns    803f63 <set_pgfault_handler+0x67>
			panic("set_pgfault_handler: sys_page_alloc error\n");
  803f39:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  803f40:	00 00 00 
  803f43:	be 21 00 00 00       	mov    $0x21,%esi
  803f48:	48 bf f3 4b 80 00 00 	movabs $0x804bf3,%rdi
  803f4f:	00 00 00 
  803f52:	b8 00 00 00 00       	mov    $0x0,%eax
  803f57:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  803f5e:	00 00 00 
  803f61:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803f63:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803f6a:	00 00 00 
  803f6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f71:	48 89 10             	mov    %rdx,(%rax)
	if((sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  803f74:	48 be bf 3f 80 00 00 	movabs $0x803fbf,%rsi
  803f7b:	00 00 00 
  803f7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f83:	48 b8 ad 1e 80 00 00 	movabs $0x801ead,%rax
  803f8a:	00 00 00 
  803f8d:	ff d0                	callq  *%rax
  803f8f:	85 c0                	test   %eax,%eax
  803f91:	79 2a                	jns    803fbd <set_pgfault_handler+0xc1>
		panic("set_pgfault_handler: sys_env_set_pgfault_upcall error\n");
  803f93:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  803f9a:	00 00 00 
  803f9d:	be 27 00 00 00       	mov    $0x27,%esi
  803fa2:	48 bf f3 4b 80 00 00 	movabs $0x804bf3,%rdi
  803fa9:	00 00 00 
  803fac:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb1:	48 b9 f3 05 80 00 00 	movabs $0x8005f3,%rcx
  803fb8:	00 00 00 
  803fbb:	ff d1                	callq  *%rcx
}
  803fbd:	c9                   	leaveq 
  803fbe:	c3                   	retq   

0000000000803fbf <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  803fbf:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803fc2:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803fc9:	00 00 00 
call *%rax
  803fcc:	ff d0                	callq  *%rax
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.

    movq 136(%rsp), %rbx
  803fce:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803fd5:	00 
    movq 152(%rsp), %rcx
  803fd6:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803fdd:	00 
    subq $8, %rcx
  803fde:	48 83 e9 08          	sub    $0x8,%rcx
    movq %rbx, (%rcx)
  803fe2:	48 89 19             	mov    %rbx,(%rcx)
    movq %rcx, 152(%rsp)
  803fe5:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803fec:	00 

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.

    addq $16,%rsp
  803fed:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  803ff1:	4c 8b 3c 24          	mov    (%rsp),%r15
  803ff5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803ffa:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803fff:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804004:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804009:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80400e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804013:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804018:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80401d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804022:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804027:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80402c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804031:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804036:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80403b:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.

    addq $8, %rsp
  80403f:	48 83 c4 08          	add    $0x8,%rsp
    popfq
  804043:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.

    popq %rsp
  804044:	5c                   	pop    %rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    ret
  804045:	c3                   	retq   

0000000000804046 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804046:	55                   	push   %rbp
  804047:	48 89 e5             	mov    %rsp,%rbp
  80404a:	48 83 ec 30          	sub    $0x30,%rsp
  80404e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804052:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804056:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80405a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80405f:	75 0e                	jne    80406f <ipc_recv+0x29>
        pg = (void *)UTOP;
  804061:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804068:	00 00 00 
  80406b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    if ((r = sys_ipc_recv(pg)) < 0) {
  80406f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804073:	48 89 c7             	mov    %rax,%rdi
  804076:	48 b8 4c 1f 80 00 00 	movabs $0x801f4c,%rax
  80407d:	00 00 00 
  804080:	ff d0                	callq  *%rax
  804082:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804085:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804089:	79 27                	jns    8040b2 <ipc_recv+0x6c>
        if (from_env_store != NULL) {
  80408b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804090:	74 0a                	je     80409c <ipc_recv+0x56>
            *from_env_store = 0;
  804092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804096:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        if (perm_store != NULL) {
  80409c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040a1:	74 0a                	je     8040ad <ipc_recv+0x67>
            *perm_store = 0;
  8040a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
        }
        return r;
  8040ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b0:	eb 53                	jmp    804105 <ipc_recv+0xbf>
    }
    if (from_env_store != NULL) {
  8040b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040b7:	74 19                	je     8040d2 <ipc_recv+0x8c>
        *from_env_store = thisenv->env_ipc_from;
  8040b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040c0:	00 00 00 
  8040c3:	48 8b 00             	mov    (%rax),%rax
  8040c6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8040cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d0:	89 10                	mov    %edx,(%rax)
    }
    if (perm_store != NULL) {
  8040d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040d7:	74 19                	je     8040f2 <ipc_recv+0xac>
        *perm_store = thisenv->env_ipc_perm;
  8040d9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040e0:	00 00 00 
  8040e3:	48 8b 00             	mov    (%rax),%rax
  8040e6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8040ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f0:	89 10                	mov    %edx,(%rax)
    }
    return thisenv->env_ipc_value;
  8040f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040f9:	00 00 00 
  8040fc:	48 8b 00             	mov    (%rax),%rax
  8040ff:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax


	//panic("ipc_recv not implemented");
	//return 0;
}
  804105:	c9                   	leaveq 
  804106:	c3                   	retq   

0000000000804107 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804107:	55                   	push   %rbp
  804108:	48 89 e5             	mov    %rsp,%rbp
  80410b:	48 83 ec 30          	sub    $0x30,%rsp
  80410f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804112:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804115:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804119:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;

    if (pg == NULL) {
  80411c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804121:	75 0e                	jne    804131 <ipc_send+0x2a>
        pg = (void *)UTOP;
  804123:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80412a:	00 00 00 
  80412d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    }
    do {
        r = sys_ipc_try_send(to_env, val, pg, perm);
  804131:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804134:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804137:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80413b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80413e:	89 c7                	mov    %eax,%edi
  804140:	48 b8 f7 1e 80 00 00 	movabs $0x801ef7,%rax
  804147:	00 00 00 
  80414a:	ff d0                	callq  *%rax
  80414c:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r < 0 && r != -E_IPC_NOT_RECV) {
  80414f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804153:	79 36                	jns    80418b <ipc_send+0x84>
  804155:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804159:	74 30                	je     80418b <ipc_send+0x84>
            panic("ipc_send: %e", r);
  80415b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415e:	89 c1                	mov    %eax,%ecx
  804160:	48 ba 3f 4c 80 00 00 	movabs $0x804c3f,%rdx
  804167:	00 00 00 
  80416a:	be 49 00 00 00       	mov    $0x49,%esi
  80416f:	48 bf 4c 4c 80 00 00 	movabs $0x804c4c,%rdi
  804176:	00 00 00 
  804179:	b8 00 00 00 00       	mov    $0x0,%eax
  80417e:	49 b8 f3 05 80 00 00 	movabs $0x8005f3,%r8
  804185:	00 00 00 
  804188:	41 ff d0             	callq  *%r8
        }
        sys_yield();
  80418b:	48 b8 e5 1c 80 00 00 	movabs $0x801ce5,%rax
  804192:	00 00 00 
  804195:	ff d0                	callq  *%rax
    } while(r != 0);
  804197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80419b:	75 94                	jne    804131 <ipc_send+0x2a>
	//panic("ipc_send not implemented");
}
  80419d:	c9                   	leaveq 
  80419e:	c3                   	retq   

000000000080419f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80419f:	55                   	push   %rbp
  8041a0:	48 89 e5             	mov    %rsp,%rbp
  8041a3:	48 83 ec 14          	sub    $0x14,%rsp
  8041a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8041aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041b1:	eb 5e                	jmp    804211 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8041b3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8041ba:	00 00 00 
  8041bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c0:	48 63 d0             	movslq %eax,%rdx
  8041c3:	48 89 d0             	mov    %rdx,%rax
  8041c6:	48 c1 e0 03          	shl    $0x3,%rax
  8041ca:	48 01 d0             	add    %rdx,%rax
  8041cd:	48 c1 e0 05          	shl    $0x5,%rax
  8041d1:	48 01 c8             	add    %rcx,%rax
  8041d4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041da:	8b 00                	mov    (%rax),%eax
  8041dc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8041df:	75 2c                	jne    80420d <ipc_find_env+0x6e>
			return envs[i].env_id;
  8041e1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8041e8:	00 00 00 
  8041eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ee:	48 63 d0             	movslq %eax,%rdx
  8041f1:	48 89 d0             	mov    %rdx,%rax
  8041f4:	48 c1 e0 03          	shl    $0x3,%rax
  8041f8:	48 01 d0             	add    %rdx,%rax
  8041fb:	48 c1 e0 05          	shl    $0x5,%rax
  8041ff:	48 01 c8             	add    %rcx,%rax
  804202:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804208:	8b 40 08             	mov    0x8(%rax),%eax
  80420b:	eb 12                	jmp    80421f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80420d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804211:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804218:	7e 99                	jle    8041b3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80421a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80421f:	c9                   	leaveq 
  804220:	c3                   	retq   

0000000000804221 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804221:	55                   	push   %rbp
  804222:	48 89 e5             	mov    %rsp,%rbp
  804225:	48 83 ec 18          	sub    $0x18,%rsp
  804229:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80422d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804231:	48 c1 e8 15          	shr    $0x15,%rax
  804235:	48 89 c2             	mov    %rax,%rdx
  804238:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80423f:	01 00 00 
  804242:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804246:	83 e0 01             	and    $0x1,%eax
  804249:	48 85 c0             	test   %rax,%rax
  80424c:	75 07                	jne    804255 <pageref+0x34>
		return 0;
  80424e:	b8 00 00 00 00       	mov    $0x0,%eax
  804253:	eb 53                	jmp    8042a8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804255:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804259:	48 c1 e8 0c          	shr    $0xc,%rax
  80425d:	48 89 c2             	mov    %rax,%rdx
  804260:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804267:	01 00 00 
  80426a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80426e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804276:	83 e0 01             	and    $0x1,%eax
  804279:	48 85 c0             	test   %rax,%rax
  80427c:	75 07                	jne    804285 <pageref+0x64>
		return 0;
  80427e:	b8 00 00 00 00       	mov    $0x0,%eax
  804283:	eb 23                	jmp    8042a8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804289:	48 c1 e8 0c          	shr    $0xc,%rax
  80428d:	48 89 c2             	mov    %rax,%rdx
  804290:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804297:	00 00 00 
  80429a:	48 c1 e2 04          	shl    $0x4,%rdx
  80429e:	48 01 d0             	add    %rdx,%rax
  8042a1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042a5:	0f b7 c0             	movzwl %ax,%eax
}
  8042a8:	c9                   	leaveq 
  8042a9:	c3                   	retq   
